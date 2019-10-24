Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31679E3B6A
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 20:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504191AbfJXS4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 14:56:01 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33133 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504162AbfJXSz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 14:55:58 -0400
Received: by mail-pg1-f193.google.com with SMTP id u23so4088700pgo.0
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 11:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=skkWOjQAG2SIq7AkesQ7N9Msme6HEgCnl64zvN/Bfgc=;
        b=gmYZ0ZzXFAhIzSn0RsC3E5IY9lO/5YCbqiPHNi32xz8spoK5ic6ykYwFs1FYgYuyey
         gcSBD2gT0zJ1ONk5m3kGX9BkihBtmDZR4zhv5qJiFZj1KzesHfIkvdeP6G307k4UHrXQ
         qBwTje3AIyhk8WyJSj1jfRQe9piFiiOHMYH+CHsV7T6zT9HkiC4oXZ/kz7QrHnTjlfhE
         AnkKJRz+42vz1bkIJy3aohf+CuTT4SvjlNPEv/xMgRLUoRapXBcEzKpinlezFcT//pBX
         L6NJoY5ibeSgSWkaZteYUoq7L0OCQAxdzPbYdrfXI6doMjJ1z8oxwrf4TYsG08t6/nte
         qLFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=skkWOjQAG2SIq7AkesQ7N9Msme6HEgCnl64zvN/Bfgc=;
        b=VwyXqq/nS+4+R6YNw1O07uENvIUzbXrsfD1J0uEoW/w6NLfIqxbxjSYUmRxA3PNEii
         wC3o5QHLjoF/oPBMAgdoI7G3+TAiMugumR+iMf1XTvlLDaRgSEg+MI+hk5iUvjf1rZwU
         eopAuMFfQfmopRxwr5b31LzFhUVmY5SHR985XqqiH6lPXaIbTqp4FGwn3xE1y96bOYVm
         3buObvXr18T39YFscxBqNHYIeYSJli3fTzQcdl8/dtiY83Vm5PhgJ1rO3jXlEXmGitdG
         r1TqlVcX5iU23XaIkOeZi38uLeSJeDWJoGhRB5YI9XHDSEPzcIhIIAg8keCGV6IW0SsG
         kjqg==
X-Gm-Message-State: APjAAAWLWPJh41Fs6Ubv7WJ5FhVOOmP3vvaJX9cVKrP7lj8cMcgxpw35
        xHVP/nFSuwetw7QCiWX+1yK7rA==
X-Google-Smtp-Source: APXvYqxkPjWyobL7PL4g3GBnG5LW/qPP3xnmD7I0AhT6krKXNPb0Dyo+2MgK0FL0VIAnXgtEOx6Xsg==
X-Received: by 2002:a63:9208:: with SMTP id o8mr18075167pgd.256.1571943356385;
        Thu, 24 Oct 2019 11:55:56 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id f25sm9448405pfk.10.2019.10.24.11.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 11:55:56 -0700 (PDT)
Date:   Thu, 24 Oct 2019 11:55:53 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>
Cc:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Rajan Vaja <rajan.vaja@xilinx.com>,
        Scott Branden <scott.branden@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Vikram Prakash <vikram.prakash@broadcom.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vikas Gupta <vikas.gupta@broadcom.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        tee-dev@lists.linaro.org, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH V3 3/3] bnxt_en: Add support to collect crash dump via
 ethtool
Message-ID: <20191024115553.11a6f4be@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <1571895161-26487-4-git-send-email-sheetal.tigadoli@broadcom.com>
References: <1571895161-26487-1-git-send-email-sheetal.tigadoli@broadcom.com>
        <1571895161-26487-4-git-send-email-sheetal.tigadoli@broadcom.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Oct 2019 11:02:41 +0530, Sheetal Tigadoli wrote:
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

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
