Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5BF25CC5E
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 23:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729306AbgICVfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 17:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728134AbgICVfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 17:35:37 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE1CC061246
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 14:35:36 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id v196so3399152pfc.1
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 14:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=yyrpyIOrAmq+Cl5n2s3XLW8GrCQtJByKlG8POlfivPs=;
        b=CRJS8/7PpH5pBFU+hBuv6AkVFFz9YwCimuTzSHvrG2h1AUodV4bTdeZSM/d5B/JNaw
         vaF1uiM9EBUOf5j+c54/rOCyCf2oiYYYZHUN97VXHlGzxFlH3DQ+Z2kCYoYCblAd7Tw6
         GmZFNzh0QroG1ySZ7FJwYOg9FPSfdQ14zpkFMrj7b94wSXuvYUisE0COoRSSYzhgdYa2
         SuRN2/cmpU9AWmzG6CtXe0Z7s1w/anCy8BfxlztrSxFsMH/6dozszPEWjsK9aI4ZwIC7
         A/pQOTvxy/vVKZgo0jTPIzPioLRTWRELE3TASuu+ErTu05IyQ76RzS+AfMvRjDVzuIFh
         9huw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=yyrpyIOrAmq+Cl5n2s3XLW8GrCQtJByKlG8POlfivPs=;
        b=l2j4r4nrFM1uDDRKWviTz96WTAWjIv1z46F0sMzdiiIl5t1y7aQs6bZOeSm4PhJRN5
         KzsS7amtG5CoTbOPFOnazehGWQH/HAfbIekfZPMuJezUJNMIyFTdnNk+Ce60si1DBA3V
         M0vhyhIT7vRUjHbLMzH7PfJCV6vhpxMfA5hOpdOSF5johpesnjhOKnDsl2HxRylbMKIX
         P5PrmGixqNH9is5XLox44qFSiYHjPUuz/FmDliIrJNo71+U9VX9RfqZ/0uYEOocfGVOG
         YgIA2+TdUnfUuGWsV4RnA3QHZIbg/GNur9QS9Mb8KlwYrka5KfxXkbRr7WkDUhFMVyHC
         k19g==
X-Gm-Message-State: AOAM530vb5qe7Cru5nxUNcplcLtqtnm9vEEHjNONoBpVYP4gmjk31T6X
        l2EwHlvX90MvMfyDD+0aCKILvw==
X-Google-Smtp-Source: ABdhPJzKyeEeigxkOwIbnybir9u/fAL2BYPF34mZNCJl4hlsrGoy77WlRitACooDQqZj3qn/EQi7bg==
X-Received: by 2002:a62:17c5:: with SMTP id 188mr5711139pfx.71.1599168936178;
        Thu, 03 Sep 2020 14:35:36 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id d77sm4247264pfd.121.2020.09.03.14.35.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 14:35:35 -0700 (PDT)
Subject: Re: [PATCH net-next 2/2] ionic: add devlink firmware update
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        moshe@mellanox.com
References: <20200902195717.56830-1-snelson@pensando.io>
 <20200902195717.56830-3-snelson@pensando.io>
 <20200903060128.GC2997@nanopsycho.orion>
 <9937d5f2-21a1-53cc-e7fb-075b3014a344@pensando.io>
 <20200903173029.GD2997@nanopsycho.orion>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <fb821a31-e4d5-346b-4f5c-6c545661c638@pensando.io>
Date:   Thu, 3 Sep 2020 14:35:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200903173029.GD2997@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/3/20 10:30 AM, Jiri Pirko wrote:
> Thu, Sep 03, 2020 at 05:58:42PM CEST, snelson@pensando.io wrote:
>>
>> True, they aren't "needed" for operational purposes, but they are rather
>> useful when inspecting a system after getting a report of bad behavior, and
> I don't think it is nice to pollute dmesg with any arbitrary driver-specific
> messages.
>
>
>> since this should be seldom performed there should be no risk of filling the
>> log.  As far as I can tell, the devlink messages are only seen at the time
>> the flash is performed as output from the flash command, or from a devlink
>> monitor if someone started it before the flash operation.  Is there any other
>> place that can be inspected later that will indicate someone was fussing with
>> the firmware?
> Not really, no. But perhaps we can have a counter for that. Similar to
> what Jakub suggested for reload.
>

When we need to debug a complaint about a firmware load, I want to be 
able to find out what fw file the user actually tried to load, and maybe 
were there other broken load attempts before that.  If there was 
something that broke in the download, it would be nice to know when - 
beginning?  4k bytes in?  near the end?  A counter might show a number 
of load attempts, but no context as to when, what file, or what else was 
going on around the same time.

sln

