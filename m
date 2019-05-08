Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9778C17B3D
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 16:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbfEHOCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 10:02:34 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37821 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbfEHOCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 10:02:34 -0400
Received: by mail-qt1-f196.google.com with SMTP id o7so1199186qtp.4
        for <netdev@vger.kernel.org>; Wed, 08 May 2019 07:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OMayxOPng3VI9oLdv6LysTsZC2kSXkwJS8Ocn5AZIxo=;
        b=bF0k9WXe4tmmFE99bq0ToeUzppfIQAWaVmVkMn4cbqhK72GsPFrxQdOu+ch+/yH6Sg
         QtBKDDHGhLTZcD1nI69edCcSemmSD3qFRW4ScSYX1e5RnpJzt1SHkF/baC/FbLBScaHD
         7EBPVvTwCqQ93cWA7hwXMv87VG/ziTj0YvdnDc9W/ooRSFMIIsk99ppYAstUMR5n9pQw
         +aBdt36ZUJjZKr7srL/AcDbQ/sv2olX3PkdagRQwPvO+rwl3C/k3obbglzFlGY0mSVup
         4TQjxTRsAq1vumYFJwL/I1TsI/EGa2HtOCMI3vA4dgZBCchDXO6e5Ne2JLz51nROSqaq
         Dvdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OMayxOPng3VI9oLdv6LysTsZC2kSXkwJS8Ocn5AZIxo=;
        b=epoDyxcBMkjRzS5nnldT+funyIQ2XB0pMMvHZvdaTXDVu9lQkVzeYCmm2Ir0o1OPQW
         YzxFotv8vPFp+XEn+TWDZRh/5UuShWKOLsECk7wFoEYWDK7jcjz73lgWjlvz6xHT2FCz
         9EgrnwAL6tZy7ixWArQaQpqiqVgBoUDquHcmtw7ImzEBrJIVP323E7HCL7wmOcopjzSj
         lhCUCQCSjxiOV7zRYJGrKYA3yIKdDI7krttqyS26JYljIlo6+hjGDUWNb5E2pLOozmFm
         oG6XkWGiNhu4D8SLzrFP/af8y33eWgu995iju46va3uANCgqG9J97tBpBzGdfnzczL4P
         2Ngw==
X-Gm-Message-State: APjAAAV7KoOgkCGy0Ql+bFUB/aUcn6+nWJ3Q7bPKX1h3nW0Zdwipuok7
        2oR2HfIpJchxr59VLwYkos8fKg==
X-Google-Smtp-Source: APXvYqxHeJWTP7p8mYSCW0mWVj+xfW6XiMj6pEOAEmyoja5yJE0819A12TLI/OQr4VbaZvhRo5Z86w==
X-Received: by 2002:ad4:4025:: with SMTP id q5mr30080452qvp.41.1557324153701;
        Wed, 08 May 2019 07:02:33 -0700 (PDT)
Received: from [10.0.0.169] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id v141sm9984636qka.35.2019.05.08.07.02.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 07:02:32 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 2/3] flow_offload: restore ability to collect
 separate stats per action
To:     Edward Cree <ecree@solarflare.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Anjali Singhai Jain <anjali.singhai@intel.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
References: <alpine.LFD.2.21.1905031603340.11823@ehc-opti7040.uk.solarflarecom.com>
 <20190504022759.64232fc0@cakuba.netronome.com>
 <db827a95-1042-cf74-1378-8e2eac356e6d@mojatatu.com>
 <1b37d659-5a2b-6130-e8d6-c15d6f57b55e@solarflare.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <ab1f179e-9a91-837b-28c8-81eecbd09e7f@mojatatu.com>
Date:   Wed, 8 May 2019 10:02:21 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1b37d659-5a2b-6130-e8d6-c15d6f57b55e@solarflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-07 8:27 a.m., Edward Cree wrote:
> On 06/05/2019 13:41, Jamal Hadi Salim wrote:
>> On 2019-05-04 2:27 a.m., Jakub Kicinski wrote:
>>> On Fri, 3 May 2019 16:06:55 +0100, Edward Cree wrote:

[..]


> I don't know much of anything about RTM_GETACTION, but it doesn't appear
>   to be part of the current "tc offload" world, which AIUI is very much
>   centred around cls_flower.  I'm just trying to make counters in
>   cls_flower offload do 'the right thing' (whatever that may be), anything
>   else is out of scope.
> 

The lazy thing most people have done is essentially assume that
there is a stat per filter rule. From tc semantics that is an implicit
"pipe" action (which then carries stats).
And most times they implement a single action per match. I wouldnt call
it the 'the right thing'...

>> Most H/W i have seen has a global indexed stats table which is
>> shared by different action types (droppers, accept, mirror etc).
>> The specific actions may also have their own tables which also
>> then refer to the 32 bit index used in the stats table[1].
>> So for this to work well, the action will need at minimal to have
>> two indices one that is used in hardware stats table
>> and another that is kernel mapped to identify the attributes. Of
>> course we'll need to have a skip_sw flag etc.
> I'm not sure I'm parsing this correctly, but are you saying that the
>   index namespace is per-action type?  I.e. a mirred and a drop action
>   could have the same index yet expect to have separate counters?  My
>   approach here has assumed that in such a case they would share their
>   counters.

Yes, the index at tc semantics level is per-action type.
So "mirred index 1" and "drop index 1" are not the same stats counter.
Filters on the other hand can share per-action type stats by virtue of
sharing the same index per-action. e.g

flower match foo action drop index 1
flower match bar action drop index 1

will share the same stats.

cheers,
jamal


