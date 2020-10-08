Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B393B28749F
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 14:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730128AbgJHM6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 08:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729722AbgJHM6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 08:58:11 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFB3C061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 05:58:11 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id s47so4956514qth.4
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 05:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DCfBohSv/2MYChEHos/NCDqxdJBntx3sdb+fm8tsEY0=;
        b=LvJza0GzHu6y51xoNmw4ielaDyKM+H+Ggf+iwnGDefC+tgECk2rwwK87hgn/g1LF20
         SY1slwNikRBjo4h/D07JNG5nsJz7+6tZNsPnoa6gbRe0jaucMEntntG2/8L52CNPGQ4W
         gY7d7x6904g2kPFtZGIIjwI/fbjjjsK+2t5v6/k6ZNlq763g7ADmSaT03WXiEpFTw9Fe
         O0GkW4Z0bnTnxuGlNUIScgo1WolHnwVsz+6Q7QqXzy/qE7imNtC5wGk3ShBmApgN24s8
         O9ylfz6tWAZ5WJ+Kn33UWzxzjG4XmbNNRUsPUuUqjThGAaC+LQ7Gaz7koVNyD+izhrJJ
         FauQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DCfBohSv/2MYChEHos/NCDqxdJBntx3sdb+fm8tsEY0=;
        b=WKUd6Qv/pgqNil78rLRfu7YSFDv4ty1fFUAl1er2bFQhIExMIi/6QBYakw+TKzdcdu
         F9J7fBokHzfJxDtUKoqF5rPT3SsrkZkizjU3KqHR6Rlia0NkyVOuTcXthQpfNrDRlA3w
         cVtnLjqK6w6uhzafKhEAeqYVcMs8aHif+3ygqjvBDZLG3fEw7HuJMge3M8fugOC8gWyq
         7YyFmwnd+TMZwLItXzw0vzpRxvssJl+tlEXtkXk+m8NeGEEdnv2HuaCIyereAAT1qPJN
         OLvbu2GFeV/FX7gBvoMIL+1jHHTSZIBF5Y+O3+7A7hXNWjrJURSlu2n7hss5CoXiDSru
         cG4A==
X-Gm-Message-State: AOAM531ym3px9wBW7uxOre7/M5KpYwhImbyoa/cnYl7zdWxTj9WjnjU6
        SvkPCqhs0E63YO0v5CV7kHYC1A==
X-Google-Smtp-Source: ABdhPJxi7k0ukR46O4WyBZ4ho2E25v/A7wyEZgQfyTFwMl11pTFF+3HOhaJQ+cEAYBltBtQKpVFTSg==
X-Received: by 2002:ac8:5a10:: with SMTP id n16mr8228605qta.164.1602161890301;
        Thu, 08 Oct 2020 05:58:10 -0700 (PDT)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id f76sm3823933qke.19.2020.10.08.05.58.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 05:58:09 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2 2/2] tc: implement support for terse dump
To:     David Ahern <dsahern@gmail.com>, Vlad Buslov <vladbu@nvidia.com>,
        stephen@networkplumber.org, xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@resnulli.us,
        ivecera@redhat.com, Vlad Buslov <vladbu@mellanox.com>
References: <20200930165924.16404-1-vladbu@nvidia.com>
 <20200930165924.16404-3-vladbu@nvidia.com>
 <9961ad12-dc8f-55fc-3f9d-8e1aaca82327@gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <ff969d59-53e0-aca3-2de8-9be41d6d7804@mojatatu.com>
Date:   Thu, 8 Oct 2020 08:58:07 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <9961ad12-dc8f-55fc-3f9d-8e1aaca82327@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-07 9:40 p.m., David Ahern wrote:
> On 9/30/20 9:59 AM, Vlad Buslov wrote:
>> From: Vlad Buslov <vladbu@mellanox.com>
>>
>> Implement support for classifier/action terse dump using new TCA_DUMP_FLAGS
>> tlv with only available flag value TCA_DUMP_FLAGS_TERSE. Set the flag when
>> user requested it with following example CLI (-br for 'brief'):
>>
>>> tc -s -br filter show dev ens1f0 ingress
>>
>> In terse mode dump only outputs essential data needed to identify the
>> filter and action (handle, cookie, etc.) and stats, if requested by the
>> user. The intention is to significantly improve rule dump rate by omitting
>> all static data that do not change after rule is created.
>>
> 
> I really want to get agreement from other heavy tc users about what the
> right information is for a brief mode.

Vlad, would have been helpful in your commit log to show both
terse vs no terse (or at least the terse output). Cant tell short
of patching and testing. Having said that:
The differentiation via TCA_DUMP_FLAGS_TERSE in the request
is in my opinion sufficient to accept the patch.
Also, assuming you have tested with outstanding tc tests for the
first patch i think it looks reasoan

cheers,
jamal
