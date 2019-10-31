Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96E64EB690
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 19:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbfJaSBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 14:01:32 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37287 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729033AbfJaSB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 14:01:29 -0400
Received: by mail-ot1-f66.google.com with SMTP id 53so6187439otv.4
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 11:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7yF1ZFa0NQKW1P9+UET4zyA+4HzwzTV8eBOXyYYcm50=;
        b=KdI7GJoPUQ87vC9eDvndZA0yAZXeweGXN1/7uAzOxrFy5OhyZwKF/N7T8DLXzqJ1JY
         YcJmQzIxRU+2NgvLtHQQ3zH6cLb1e4skGxrap6E9BQJSurU7Q/20H96bUJ7Hrndsb++e
         +QdEU2jUS01dbXwGCNlWHNwhOcF9bHuLrRbBw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7yF1ZFa0NQKW1P9+UET4zyA+4HzwzTV8eBOXyYYcm50=;
        b=UeKmcbfFA13YnAwYAdaGpXYa1DqUilCGT9Czq1FG8qenrCnwQktXE27GOH4OzLS5TO
         otSrSlzlE7g5+6SucvUwrFuaXGUNokliLkb5DQHpcxCiwIzThxl7TyS3iRXsxb8XsA1N
         t477s9UFieAA3A0ffXr2qQFnEA1GIEaljS0MpJDUluqFmvM54OwCyVhyu64tNvmimvaZ
         ciMrmIiglw8fDgxoIQy7OX5g02SnlWB4AlxKRDo3Y18uWSqDcm9QIAhdTM9re5npdHfh
         dpFe8sNlDx1R8SlDyIqXZpbaChF91N85FuQTQNivs0vh5TOdvhHy9SxOU46RGhbpB/zm
         9Eew==
X-Gm-Message-State: APjAAAWq+hCY7eUV79K2q+0iJt4tfuKFSu4r5IjkqI/LyOvoz5NF1dS6
        0g2y2ANr3Tk8I16TP6Wc/oqBTu3ECKq7w/YG6EEwaw==
X-Google-Smtp-Source: APXvYqy1uzgZvxYZJr1xLmUp54jxULY37cEV21ulK7dM1ZQuVKhCPIrNGtKksA/VMg4P36KII5M0JLGeNPA8AF9oERU=
X-Received: by 2002:a9d:39a5:: with SMTP id y34mr5476867otb.36.1572544888141;
 Thu, 31 Oct 2019 11:01:28 -0700 (PDT)
MIME-Version: 1.0
References: <1572516532-5977-1-git-send-email-sheetal.tigadoli@broadcom.com> <1572516532-5977-4-git-send-email-sheetal.tigadoli@broadcom.com>
In-Reply-To: <1572516532-5977-4-git-send-email-sheetal.tigadoli@broadcom.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Thu, 31 Oct 2019 11:01:17 -0700
Message-ID: <CACKFLim+ru8c1JfB+Q3miyWid48OTPn_xHrrjG_z_OznjVWTJw@mail.gmail.com>
Subject: Re: [PATCH net-next V5 3/3] bnxt_en: Add support to collect crash
 dump via ethtool
To:     Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>
Cc:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Rajan Vaja <rajan.vaja@xilinx.com>,
        Scott Branden <scott.branden@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Vikram Prakash <vikram.prakash@broadcom.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vikas Gupta <vikas.gupta@broadcom.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        tee-dev@lists.linaro.org,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 3:09 AM Sheetal Tigadoli
<sheetal.tigadoli@broadcom.com> wrote:
>
> From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
>
> Driver supports 2 types of core dumps.
>
> 1. Live dump - Firmware dump when system is up and running.
> 2. Crash dump - Dump which is collected during firmware crash
>                 that can be retrieved after recovery.
> Crash dump is currently supported only on specific 58800 chips
> which can be retrieved using OP-TEE API only, as firmware cannot
> access this region directly.
>
> User needs to set the dump flag using following command before
> initiating the dump collection:
>
>     $ ethtool -W|--set-dump eth0 N
>
> Where N is "0" for live dump and "1" for crash dump
>
> Command to collect the dump after setting the flag:
>
>     $ ethtool -w eth0 data Filename
>
> v3: Modify set_dump to support even when CONFIG_TEE_BNXT_FW=n.
> Also change log message to netdev_info().
>
> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
> Cc: Michael Chan <michael.chan@broadcom.com>
> Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> Signed-off-by: Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
