Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 950BB1FCF3
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 03:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbfEPBqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 21:46:24 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33789 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbfEPAHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 20:07:01 -0400
Received: by mail-pf1-f193.google.com with SMTP id z28so830815pfk.0
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 17:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=W+vzgbZKs9EokE5e1mehK6rlEduFTjf67kBmGk7RoAI=;
        b=Wf6QEtsydUHUMzkDMIYCuwah5J2fUgKeNSMgPzEcd5C0FLO5pNFdjCkDYCy8h2AFMu
         ZRygK/k6sGdLOVgr55yqDtEXTMzUG2Tc0BTrgnuxshGtAuiPADxCcw05L+Pleavb9Apg
         +mp+EQI6f5pfa0zjqa0EU9f71D3ePoQ9Vm2+3b5GQC4XzrOxuKQJhFz6JRq5hKGtkr80
         Bxwb/mT847P/lOdqqqIDBjKZeWrgQJoVwxoM9Mgp3bGuJqHX4fE4iqsql5VKf1cb8Mja
         2MWK7I2h3/HT6J/okXUBa0/GSWbk09ptFiDGfB6jnJ134anGj5DAUK+2U+BhB+QpKY9V
         6UrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W+vzgbZKs9EokE5e1mehK6rlEduFTjf67kBmGk7RoAI=;
        b=BnthdSmwCh4z7b5UBuRLwQj6cNHez3ji6zd8d2f9a8hNyUFkdJWgRmz1FhlroqsvZY
         mi2Krja+ACOI+mGwsOSI6K8tcsNi2kKUInFNu2LjOox/VtCbuwLA98WK4MKULjYABmN1
         K7x+7x4i0JC/Qsbn0ld6/Z75oSZNf6EvRflp8RDPeCUj5k39xcKrwfwY23CxfuOx00yJ
         9bV9d39UotgcdTIcS8/Csr0m/iT5XzZlYSn0N50rvkuKWDCnu+x70xyEfV9CsJGJVEpt
         39lfed2dtEMrDLa6SiFk4g7crf55RF6TERwEZ8vxlusKve7Rfq2jUOpwHcB0WA8TbRjv
         LUZA==
X-Gm-Message-State: APjAAAUzXXZueXOG7ksamDopJPwE0v48Mm+/rk2XhhmCVEGcwEgcL6w6
        FwDk1jMzf/tP0nnrPMGTQ0w=
X-Google-Smtp-Source: APXvYqxqw02mAIrzY7xgk4abXzQkArMkGHJMFR4sGmA+g0HGXBs1+abHvAovp+llINbDYoHX2x6RFQ==
X-Received: by 2002:a63:7054:: with SMTP id a20mr33321799pgn.354.1557965220649;
        Wed, 15 May 2019 17:07:00 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:81dc:8ee9:edb2:6ea? ([2601:282:800:fd80:81dc:8ee9:edb2:6ea])
        by smtp.googlemail.com with ESMTPSA id p81sm4491687pfa.26.2019.05.15.17.06.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 17:06:59 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: fix src addr routing with the exception table
To:     Wei Wang <weiwan@google.com>, Martin Lau <kafai@fb.com>
Cc:     Wei Wang <tracywwnj@gmail.com>, David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mikael Magnusson <mikael.kernel@lists.m7n.se>,
        Eric Dumazet <edumazet@google.com>
References: <20190515004610.102519-1-tracywwnj@gmail.com>
 <20190515215052.vqku4gohestbkldj@kafai-mbp>
 <CAEA6p_AA2Xy==jrEWcWuRN2xk3Wz-MqdPC32HtRP90vPH_KmhQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6ab0f808-bcd9-0f6f-9d88-c1272493b6d9@gmail.com>
Date:   Wed, 15 May 2019 18:06:58 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAEA6p_AA2Xy==jrEWcWuRN2xk3Wz-MqdPC32HtRP90vPH_KmhQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/15/19 6:03 PM, Wei Wang wrote:
> Thanks Martin.
> Changing __rt6_find_exception_xxx() might not be easy cause other
> callers of this function does not really need to back off and use
> another saddr.
> And the validation of the result is a bit different for different callers.
> What about add a new helper for the above 2 cases and just call that
> from both places?

Since this needs to be backported to stable releases, I would say
simplest patch for that is best.

I have changes queued for this area once net-next opens; I can look at
consolidating as part of that.
