Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC8536DC52
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 17:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240308AbhD1Psd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 11:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231981AbhD1PsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 11:48:24 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBA4C061346
        for <netdev@vger.kernel.org>; Wed, 28 Apr 2021 08:47:01 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id z7so11259799oix.9
        for <netdev@vger.kernel.org>; Wed, 28 Apr 2021 08:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=6lTwEo/GEmMFKpiB3fXK1Ubf9hjD77Op4l6cbLYx2z0=;
        b=gqRnVelfUUiQwdZGsy5S3cThhwKhThTyXv1GLfpWTvpYDwrlHIHGSBmfzHAv0k2D0d
         hGrbzSnueCH91hhyyDlq5CcG9Nwg66Rj8Tc+QvNVpUl+g5obgddbE3O5mpBPm8Wxj2fT
         AgC5Ay9ns/fYeo+mPmsGD5W8rrJ4fjdRWaBqV9peXYUNgMLER4ffweeyTT0rl6PXl2Ub
         ddjPgLvjswJILo658qFoeGE8ZY9UazjFhE+R4qRDBHDEwOlkq9LQiXhI0LWb68oERX7d
         4U4s/OvH3lkcA8Wzf2CZiwXgHySdRY6LX5w6yH4jBTt1fi8Gm2YvjMChQZrrjPCFuHTj
         2DZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6lTwEo/GEmMFKpiB3fXK1Ubf9hjD77Op4l6cbLYx2z0=;
        b=Kobnc/aEZPTCL9QJVGhqETrArpZ9umcJqx2xSigigEl18gNnIXi1WZvXw5fG1mL9/7
         fbL0OxVCuzB+WHrGxJM+nJlBIL3qEbsbLcMjMRLKvwId/LSCa/w6/UTfeyONp7udKzBg
         DqaG0XkubON87TR7hzszk77UPiM/Jz9rluipDipiWN3rMBgTnSy2+7uNeevRMyrTobIf
         kpHDjyAvn5zYy7ogvC2+n0NRDVw2HyISXxy0JDRwYsy6T6putmPaKuIWthjV9qMYKZFR
         dHUNt5x4A4c1G6H+YP2LEgEkw9czf46uzcsP5PQ5mGj4dCQk5ly9uzsgR1fbNK9f9pte
         /GFw==
X-Gm-Message-State: AOAM530fjfx466UageKw+nnGxjyYqQ/6/gZdYrcHk0c9mFwEgS3q9zGU
        N5ZUZtIUKbN1Kv8ua35SXGzUJcN5VFs=
X-Google-Smtp-Source: ABdhPJwsl/zq5/C54UqeZh83nRo/855gwTl+QGHN0Mo6RAxjbLNmCAwcNqGmhdxmarDPG9HBhzrjJg==
X-Received: by 2002:aca:3684:: with SMTP id d126mr20629922oia.129.1619624820621;
        Wed, 28 Apr 2021 08:47:00 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id r9sm80184ool.3.2021.04.28.08.47.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 08:47:00 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] ip: Add nodst option to macvlan type source
To:     Jethro Beekman <kernel@jbeekman.nl>, netdev@vger.kernel.org
References: <702c692e-c45a-8daa-50e1-e17564f8b787@jbeekman.nl>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d0a647ad-ec2d-10c3-5eb6-3de81db400bf@gmail.com>
Date:   Wed, 28 Apr 2021 09:46:58 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <702c692e-c45a-8daa-50e1-e17564f8b787@jbeekman.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/24/21 3:28 PM, Jethro Beekman wrote:
> The default behavior for source MACVLAN is to duplicate packets to
> appropriate type source devices, and then do the normal destination MACVLAN
> flow. This patch adds an option to skip destination MACVLAN processing if
> any matching source MACVLAN device has the option set.
> 
> This allows setting up a "catch all" device for source MACVLAN: create one
> or more devices with type source nodst, and one device with e.g. type vepa,
> and incoming traffic will be received on exactly one device.
> 
> Signed-off-by: Jethro Beekman <kernel@jbeekman.nl>
> ---
>  ip/iplink_macvlan.c   | 12 ++++++++++--
>  man/man8/ip-link.8.in |  9 ++++++---
>  2 files changed, 16 insertions(+), 5 deletions(-)
> 

applied to iproute2-next.

