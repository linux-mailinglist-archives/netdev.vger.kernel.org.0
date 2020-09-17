Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF4EE26E6E6
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgIQUrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgIQUrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 16:47:32 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8D4C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 13:47:32 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id q12so1744341plr.12
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 13:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=IxxHrmWWJ4Feco1k5qnEX/pVVC2HSwzwYPXEezTI+lw=;
        b=hyjOCN63ZOwb0sCjlpKGioBC4EfUbm4mkFFdlLIoTgYcv7RLEj3cJNrvPbZqWHk4/E
         FdLnEKXb/mEfyRXX1NNaoLg+nU8V1MOx1capV5AVq4V3wPzAEAcZ12tcLvfJ1dlMFdBF
         xKuRpXVJBOvU6qO9LVhj00q+UIxj35l/MpteFGgDOnThnRiUCFKmgMaAwRsfp6STHsbF
         oiH85FA+1Rhk6CC+q13HGSot3z6a+YT6TPlUCWaPDq09CZhNNVds9WIiW5C0uZt6umai
         FQAN738Ul0sz9QF6W/ApSDEN9hyZAAuFlI3O5bUj7ztf0BpLOp1j9XiasIlKO+5jexOC
         779Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=IxxHrmWWJ4Feco1k5qnEX/pVVC2HSwzwYPXEezTI+lw=;
        b=Pb+s6voNhlL/60DSfRldZVbnsCGd/vkrC977Pv0PHRH7jE8oRR0jLj2kWit/I/UWVf
         jzlqXva6hLY9K7QG5BvtybXkiFfzhuh2LKBMsJybxF0YnkWPB5WO0Uh4Fcqq64u7/ov3
         fDH3AIKdRbmNcA7Lei8pi5mIAOfYAYfQ2p+7vRM67b5S5QK7aP/TyIOM4yxkDLcRg5Kp
         Tzx1gYZJAt/Vt98XSzbC4xjLitpa7MM0UGk+j4V/ThaHG6Qy6OxWfuplYKSQJG7NElYh
         6CuMl6pXHdt0N8StINeZ0r8fSNwYxrTV7EYexBEqEqJ0nR+f05Bf7M/NPZ2B9Kn4rAXL
         qNxg==
X-Gm-Message-State: AOAM532cmrgmZ9z72Pr9cj8w8DJaXasgUbu1yBY8zypTHoLZPv0zFqD8
        JXwmENeq5CQnEe/SnN2zI82n6w==
X-Google-Smtp-Source: ABdhPJwcXM2slP/1AEEVTgGvCJBGn/EYoI/zqwQXRcyCEM+Ej4RBaQn33hrNKIcZR1OQwU8+Ez+uMQ==
X-Received: by 2002:a17:90a:6741:: with SMTP id c1mr9840144pjm.6.1600375652524;
        Thu, 17 Sep 2020 13:47:32 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id r5sm505511pgk.34.2020.09.17.13.47.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 13:47:31 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 5/5] ionic: add devlink firmware update
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200917030204.50098-1-snelson@pensando.io>
 <20200917030204.50098-6-snelson@pensando.io>
 <20200917125227.52d58738@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <43903f9d-d191-4b38-7d26-cb3ab280917f@pensando.io>
Date:   Thu, 17 Sep 2020 13:47:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200917125227.52d58738@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/20 12:52 PM, Jakub Kicinski wrote:
> On Wed, 16 Sep 2020 20:02:04 -0700 Shannon Nelson wrote:
>> Add support for firmware update through the devlink interface.
>> This update copies the firmware object into the device, asks
>> the current firmware to install it, then asks the firmware to
>> select the new firmware for the next boot-up.
>>
>> The install and select steps are launched as asynchronous
>> requests, which are then followed up with status request
>> commands.  These status request commands will be answered with
>> an EAGAIN return value and will try again until the request
>> has completed or reached the timeout specified.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> Acked-by: Jakub Kicinski <kuba@kernel.org>

Thanks.

sln

