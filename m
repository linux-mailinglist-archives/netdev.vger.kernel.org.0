Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0361B1C9E87
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 00:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgEGWgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 18:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgEGWgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 18:36:08 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D141C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 15:36:08 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id y24so8689846wma.4
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 15:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EIdlbgnVk8C+8duYevXIvIfJcPisuB0wqNHx2yaLOSU=;
        b=VdcxZeoloeIWGDqaINxKUbE0vXPE7ZBpKMZY142fEzOCWrIbUMoe5mZV2m5HMbglol
         f+kXHmq1rWmbzUMLi5/YBqBJWpG9zxfWWINiJNZXirZ88JDJrYEQ6xYIAOQZ288BMMtb
         zCWOR9Z76sB/D9MNEF5BxxItU/B/j7GYPuMTkaoCrbFsS9Y9pjuLDwyz+yXsDNw8kign
         bIqKsNZTZvnWoB9Eq6e0a2m1PwYC2V6QYNWuCcbzmBxQZ2WLmz7XmaGhewOtG6A/QqWj
         069diywlbd/u5FER4mGTMs/gY0w2cfeWvAC4KZ/M5fyLLNN9gW/FnXXv034RuQaRvtQr
         K9jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EIdlbgnVk8C+8duYevXIvIfJcPisuB0wqNHx2yaLOSU=;
        b=TCdfn8IseXplfKCERl6XAZLRb8kSnnYG4SrKECveI0ATC481UXPO9mcG/HmNBge/OY
         APC1rqF2lnZo7vWN8IayTW0JorGW4Gq/8YTjIDUrEzotIbWW8qWUoA1ZL1f0dSNDqraX
         tzAYY1n5nDypO9AI66ueup/+KVJOyYHXveRkdH3kAN+vervCjTjjm+wpDuISWFwacN6f
         f/eHo5kN+JzX+OLCv85eRd7tq7epcrIXGY7PmNwX9RD7Nd2zT8zRP1CqDVATCNUsQL8G
         cujVUMo5m4QF7ss74IVv6ghTC+44o28douyyxNgwCbtdVatX6id+eclLJK34Hf7VAhjv
         EhvA==
X-Gm-Message-State: AGi0PuaqSexu76NLBKm2HMDnOA3bLlBxU9lkfV5l7LaK5aF2BX8soCGP
        bAVHxM2VEQdyQrHw6J/SJuA=
X-Google-Smtp-Source: APiQypJq49zSa3P/hRm3TAyG2rpw0mkOpXi+DSN9h8rzSDltNfl7pHOQaxWScjZDovNhCqiqYhkYGA==
X-Received: by 2002:a7b:c41a:: with SMTP id k26mr6676864wmi.85.1588890966827;
        Thu, 07 May 2020 15:36:06 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c17sm10436716wrn.59.2020.05.07.15.36.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 15:36:06 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 0/4] Cross-chip bridging for disjoint DSA
 trees
To:     David Miller <davem@davemloft.net>, olteanv@gmail.com
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, jiri@resnulli.us,
        idosch@idosch.org, kuba@kernel.org, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        mingkai.hu@nxp.com
References: <20200503221228.10928-1-olteanv@gmail.com>
 <CA+h21hpmr9Wey7SV9wLhE--VCSO=vobkqNW_kOB8c+DHE_Zs6g@mail.gmail.com>
 <20200507.151535.889895250031586890.davem@davemloft.net>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <cc18bf9c-a182-f182-1dbb-40f547a0abfa@gmail.com>
Date:   Thu, 7 May 2020 15:36:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200507.151535.889895250031586890.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/7/2020 3:15 PM, David Miller wrote:
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Thu, 7 May 2020 19:07:32 +0300
> 
>> What does it mean that this series is "deferred" in patchwork?
> 
> I need it to be reviewed, nobody reviewed it for days so I just toss
> it in the deferred state.
> 
> I don't feel comfortable applying this without Andrew/Florian's
> review, but if that doesn't happen I don't want this series clogging
> up my backlog so I toss it because you can always repost after
> some time.

I should be able to review those patches later today and give them a
spin too.
-- 
Florian
