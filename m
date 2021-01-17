Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D032F9286
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 14:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbhAQNYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 08:24:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728131AbhAQNYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 08:24:36 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B2EC061573
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 05:23:55 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id n11so15470597lji.5
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 05:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2npGEl46cus6vnu4tj9K9ViRUOt1heqnkXhDR8HDOJI=;
        b=XYu2ZkuiGqcU4B0kqEUgzft2ReMKrjalYrOSvtCJRiC7QEY3EYke+vr6YdHcm/qZve
         fOFedPDmK30b/dIKRP7VWJ/SIJ21afAINdxvrOrTjUDTiMlprsLJaadvHczyyZ3nHfl7
         DLzl0oR+TA4Y27Bp1zapujmn657Igt6zLxzL3FYCWo/iXoD55FVknBKfEx0JtaCMrlvJ
         vmFEpEcN+HDMqNh/Fmkqx5cdVlpc0F5XFnU+8jV1gY3XCzxCDAlxtkeG1BEAdRcxEHTK
         YwfiZ9HYvgZCntzH4nFBYQBStuLu09TxEJqT4fmfVTZX+SgtdGAUT0zjbJSPDyFAmAD1
         a8Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2npGEl46cus6vnu4tj9K9ViRUOt1heqnkXhDR8HDOJI=;
        b=TTDW5cpiurQQiXlktHAi6Fktqi14Txc89X43YInssPQsQcKtNUbeGpDP/ROvRJwbUo
         PbqxliUoXfPagtz3lsbzFWXQHgC8WVaju9xH3pZupuFIyHXuc+wngp6AKWHX8aadlg3n
         RGS7k6voGB1HHmgJqV70FoW9qeASoDnp4fN9CxKSxmYWR3UEIqh242/etpwcdGrSNZtS
         L1gSKR2sHrr2jp6/oHi4pUUm0n5s3oeUcNYAF7Fk3AIqqAkVHvdGrdIbChPPjm2RSXyq
         im4FzLPAznnJJWW+6OAwvCizz/mw5jfnFagt6GKj3KF+NO56A8zHn/A9XNGm5EBYmh/O
         ekrg==
X-Gm-Message-State: AOAM530Cvtp/1zSakqgRIzGuIJaBNLhvBw0Jt22dN9AAldAdaN2Y+qaK
        P6ApVNFWG9ndMFUvs+2+XF60hA==
X-Google-Smtp-Source: ABdhPJzkWtCR63BS7Yb/Y3ggFj1ibOgL7AkGKSr0C4EWplp4WngBAmIijTPAxCWZOMmSXEstn8v5AA==
X-Received: by 2002:a2e:50b:: with SMTP id 11mr8595788ljf.484.1610889833720;
        Sun, 17 Jan 2021 05:23:53 -0800 (PST)
Received: from [192.168.1.157] (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id j27sm1561189lfm.178.2021.01.17.05.23.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jan 2021 05:23:53 -0800 (PST)
Subject: Re: [PATCH net-next v5] GTP: add support for flow based tunneling API
To:     Jakub Kicinski <kuba@kernel.org>, Pravin B Shelar <pbshelar@fb.com>
Cc:     netdev@vger.kernel.org, pablo@netfilter.org, laforge@gnumonks.org
References: <20210110070021.26822-1-pbshelar@fb.com>
 <20210116164642.4af4de8e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jonas Bonn <jonas@norrbonn.se>
Message-ID: <8adc4450-c32d-625e-3c8c-70dbd7cbf052@norrbonn.se>
Date:   Sun, 17 Jan 2021 14:23:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210116164642.4af4de8e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On 17/01/2021 01:46, Jakub Kicinski wrote:
> On Sat,  9 Jan 2021 23:00:21 -0800 Pravin B Shelar wrote:
>> Following patch add support for flow based tunneling API
>> to send and recv GTP tunnel packet over tunnel metadata API.
>> This would allow this device integration with OVS or eBPF using
>> flow based tunneling APIs.
>>
>> Signed-off-by: Pravin B Shelar <pbshelar@fb.com>
> 
> Applied, thanks!
> 

This patch hasn't received any ACK's from either the maintainers or 
anyone else providing review.  The following issues remain unaddressed 
after review:

i)  the patch contains several logically separate changes that would be 
better served as smaller patches
ii) functionality like the handling of end markers has been introduced 
without further explanation
iii) symmetry between the handling of GTPv0 and GTPv1 has been 
unnecessarily broken
iv) there are no available userspace tools to allow for testing this 
functionality

I have requested that this patch be reworked into a series of smaller 
changes.  That would allow:

i) reasonable review
ii) the possibility to explain _why_ things are being done in the patch 
comment where this isn't obvious (like the handling of end markers)
iii) the chance to do a reasonable rebase of other ongoing work onto 
this patch (series):  this one patch is invasive and difficult to rebase 
onto

I'm not sure what the hurry is to get this patch into mainline.  Large 
and complicated patches like this take time to review; please revert 
this and allow that process to happen.

Thanks,
Jonas
