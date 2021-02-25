Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3588032541D
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 17:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbhBYQzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 11:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233839AbhBYQyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 11:54:09 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62C2C061786;
        Thu, 25 Feb 2021 08:53:26 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id m6so4005361pfk.1;
        Thu, 25 Feb 2021 08:53:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ed35dcuRnd3GC1XwvAGlrBcWXkH5YkU5hUGqEY7cuns=;
        b=F+ukRgC614Qkk8R8d2Z/Jn/6h+kgbmWsIQzeuK59PjQlVRR/Xdb6aVRGHP9jWoqyR4
         eGTOXGuNltcVXC9Kaq1rLHdvMZ3HSHBZo0vDlNbD8ZSMNg/iXgAzGpY4g2Qhi36XHTj1
         FmJgZH/3tFVbcqCa+106zrS8ip/3g11C/ZquCIvS9oiaV9hqDvE05FlGC+jM29LEU6mW
         e0sB5aL3GYwuVgOszUVZoYged1fLbtge7PtKv7SAwL6quvrdWhEh7QmS/Alios85swpV
         mjC8/gvOfpr3ug29+Hxb03LfBz7Xk7a1Uz8kIcT/Ln/MdSIMuLyzmLK9v3JN8cI7GCY8
         OD8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ed35dcuRnd3GC1XwvAGlrBcWXkH5YkU5hUGqEY7cuns=;
        b=BwjOxYs+f8cCCaksyRbqEMzXn7LhxIP9g2LEVpb9zRAWabFHLMtSWWPAQLgMxafSVN
         fRtRhb91ki9w5G3wihMsxF8fpBaJMH0i5FbEew48LbKrA6rqmBJNYL+Q37vfO+x3FH72
         1rxQ78SwSITiKX7M6hRnwLGilJKa8ZOL1v+1wWbCSeNM162Gy0ZthQMkszkL7zPMA1VV
         Wd2Q33CyoFXrR684Z+ZTCsn3mFVUvMbjVQmWTJZMxNiu91OV+S04X+MXusir+NernUCg
         ryUQacmhRVclpAmGH9Rde/APMoFmSY1z/jAwJemEzpxBwCMSaUF9JtIJDUOHrr8is+OV
         73oQ==
X-Gm-Message-State: AOAM533zsaMqnPk/PffufDIyk1Eb3FJ9fJ85NheNrCKNmbjyTe1mvxem
        fXGg8t5OCPsi6VG6uWqJi7c=
X-Google-Smtp-Source: ABdhPJyLrJz44EXCt33qZLDCT5vtiEYxgZYSihuABgZZfo9zIJ9Y9ePylNpjorFrN8LPdrsRTUOpyA==
X-Received: by 2002:a05:6a00:1a46:b029:1d5:9acd:798c with SMTP id h6-20020a056a001a46b02901d59acd798cmr4052153pfv.25.1614272005989;
        Thu, 25 Feb 2021 08:53:25 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6sm6390046pgv.70.2021.02.25.08.53.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Feb 2021 08:53:25 -0800 (PST)
Subject: Re: [PATCH stable 0/8] net: dsa: b53: Correct learning for standalone
 ports
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, olteanv@gmail.com, sashal@kernel.org
References: <20210225010853.946338-1-f.fainelli@gmail.com>
 <YDdcvkQQoAs2yc3C@kroah.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7d32ff3e-eea7-90ac-a458-348b07410f85@gmail.com>
Date:   Thu, 25 Feb 2021 08:53:22 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <YDdcvkQQoAs2yc3C@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/25/2021 12:15 AM, Greg KH wrote:
> On Wed, Feb 24, 2021 at 05:08:53PM -0800, Florian Fainelli wrote:
>> From: Florian Fainelli <florian.fainelli@broadcom.com>
>>
>> Hi Greg, Sasha, Jaakub and David,
>>
>> This patch series contains backports for a change that recently made it
>> upstream as:
>>
>> commit f3f9be9c58085d11f4448ec199bf49dc2f9b7fb9
>> Merge: 18755e270666 f9b3827ee66c
>> Author: Jakub Kicinski <kuba@kernel.org>
>> Date:   Tue Feb 23 12:23:06 2021 -0800
>>
>>     Merge branch 'net-dsa-learning-fixes-for-b53-bcm_sf2'
> 
> That is a merge commit, not a "real" commit.
> 
> What is the upstream git commit id for this?

The commit upstream is f9b3827ee66cfcf297d0acd6ecf33653a5f297ef ("net:
dsa: b53: Support setting learning on port") it may still only be in
netdev-net/master at this point, though it will likely reach Linus' tree
soon.

> 
>> The way this was fixed in the netdev group's net tree is slightly
>> different from how it should be backported to stable trees which is why
>> you will find a patch for each branch in the thread started by this
>> cover letter.
>>
>> Let me know if this does not apply for some reason. The changes from 4.9
>> through 4.19 are nearly identical and then from 5.4 through 5.11 are
>> about the same.
> 
> Thanks for the backports, but I still need a real git id to match these
> up with :)

You should have it in the Fixes: tag of each patch which all point to
when the bug dates back to when the driver was introduced. Let me know
if you need me to tag the patches differently.

Thank you!
-- 
Florian
