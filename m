Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0BFB105639
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 16:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfKUP4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 10:56:40 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:43075 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfKUP4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 10:56:39 -0500
Received: by mail-qv1-f68.google.com with SMTP id cg2so1590337qvb.10
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 07:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uo29jvd3MvEnaXPNSX8k39P3wPPu4OCIWaGTEkLO67Y=;
        b=V9JvsFLWwMItV1uYU9jSM3EdBB9baMm3tce6P/HR77UwWM6RoIVv4i+yuUoDninY1C
         cZ2dssTJ1w6XsZ+b+wAM+vhEZAaMIxreTQdypyPYFkaYcGrgRAoDAZCbV9ipvYfICZQF
         yrdCHuS4C4ktZCijGNZqvSoNiiYtg3/OVExWr+t9GrbZZm8n6TB0U4cg/d+iCQHPQDqP
         rVfIgM4UM0R/YNCnNeRiAMRqJ1xItMpz4sYLB9MmFGDTL0k3+uhtlW2ovJHAWGMo6u1R
         o1Y2NRyn2juVkufZvvybJXPi8VKiHTkWyae8bsq/HccTJSacpxSN8EFWZkvbmgvp1buq
         bGfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uo29jvd3MvEnaXPNSX8k39P3wPPu4OCIWaGTEkLO67Y=;
        b=JY2vOqo/jqvEDeKqs1kBe6+mnuOEtioEiqTTnIhN86ok2Xwz2QmmFRHzevtvFMnt5u
         iHVRS09ihFAzAF9eN2lFYuYn06riHIk8zaCXIrgijbCrudKqgILB6jMgyxQ3ggcCTxat
         lZuza2ZitwKTsJFHO2mCvRn0FgRnoLzkKKgOuIoiwbb+KYFwKrpfGV3M6IfwpLQQqc/u
         ZAwfx3M0NGRV54fF/vC7U40QbUu8PIMHRdubm4Wj5WvBC3/AQzAC0KIW3ZcAuE4j3pQq
         3GtmWXSSR4waFXByDAq/cnT93mY+83Q33jfhJkSDi2UpPj6dEY2cwqXZnU5kuzm4KVBF
         ltcQ==
X-Gm-Message-State: APjAAAV4cQCqriwX6kCWmwj0WWw0n/s7OqyAud5dhe30IWpqq660fFt8
        SQITXeNvjzooycvy96aXpl0=
X-Google-Smtp-Source: APXvYqw4ISnccH01RU50VXX+dhjxcxSzgKWdZ4ugHhjSqKbt+Vvdr1EVv+TDC/sAl2ItO6IVaW6g0g==
X-Received: by 2002:a0c:d983:: with SMTP id y3mr9060562qvj.52.1574351798142;
        Thu, 21 Nov 2019 07:56:38 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:b9b1:601f:b338:feda])
        by smtp.googlemail.com with ESMTPSA id r80sm1555568qke.121.2019.11.21.07.56.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 07:56:37 -0800 (PST)
Subject: Re: [PATCH net-next 1/4] net: sched: add vxlan option support to
 act_tunnel_key
To:     Xin Long <lucien.xin@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Simon Horman <simon.horman@netronome.com>
References: <cover.1574155869.git.lucien.xin@gmail.com>
 <af3c3d95717d8ff70c2c21621cb2f49c310593e2.1574155869.git.lucien.xin@gmail.com>
 <20191119161241.5b010232@cakuba.netronome.com>
 <CADvbK_d8XrsVJvdwemxjTEQbA-MAcOeERtJ3GTPtUmZ_6foEdw@mail.gmail.com>
 <20191120091704.2d10ab90@cakuba.netronome.com>
 <CADvbK_dbT5XTtUvu6qhk8JvH3UQYJN8bOPMTqmvi3mCEn+Yt1g@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c9e37f21-163b-0c0f-4b39-741573a11664@gmail.com>
Date:   Thu, 21 Nov 2019 08:56:36 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CADvbK_dbT5XTtUvu6qhk8JvH3UQYJN8bOPMTqmvi3mCEn+Yt1g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/20/19 10:45 PM, Xin Long wrote:
>> Hm, that's what I thought but then we were asked to add it in
>> act_mpls.c. I should've checked the code.
>>
>> Anyway, we should probably clean up act_mpls.c and act_ct.c so people
>> don't copy it unnecessarily.
> will send a cleanup, also for the one in net/ipv4/nexthop.c.

thanks. Clearly, I forgot .strict_type_start does not apply to users of
the new API.
