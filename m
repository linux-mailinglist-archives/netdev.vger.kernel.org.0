Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82EBE466A93
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 20:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbhLBTpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 14:45:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242720AbhLBTpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 14:45:07 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C39C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 11:41:44 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so3723152pjj.0
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 11:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GmCpvTi4+KgCcKBrfAymYCijwgutRdSDGHmxrOe/0Rk=;
        b=7l1m63AEuMhCUEHQ3xOJfOK0gOMWocEeLXSnslG3wRT1CkEoDZeTL2RsN+detpuzFV
         AY06DFcqQFTuDA+t8jr7n5RcLJOHI72k4ACIKyVpMka5kcXRDTxjEjkYN2kZvk6UGiEw
         nAb4BH/qL1NVcrtC7fVrpitmNGOacYvTAAiSPijA6OsonQNCPbr2ZvfnQt8HsehMsYjC
         /RFd6EUT9CJybJP46popr3jYkj7N7JScSmB46ZQHyRjFUYaXIxThL8ll/jwdKRmtnYn/
         KxFTbIQYOSzF1edKbscf2yrA2bEhHV8Bq5IiEhogEvjQSexnjgIKXCiRDA8mwdipSY+B
         PFFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GmCpvTi4+KgCcKBrfAymYCijwgutRdSDGHmxrOe/0Rk=;
        b=GI+iN7S5a+nqwgGo7vLwPqtPgKVqQ5HnqTLwxcJPQ102fse/x0IfCzqBVJgxbDr8RD
         QTif8bzmeCDIlw0st4yS8Fpl3b5hIryU2WaU13L+lodKlFYdezCEL4RoY9ieABA7MuCP
         cW932WjZ8EHj5zQFNymCf9KDFix1h22DXqWaIK9Xqc8F+Wd8seszheSskoKi0XQZPzoE
         dnaiQ4tRNedJ7UlFy7Xyun/VX/2WRYpRHEJXWfbVrkRaqbZJLtbQNmk3ShVYsIuT2Wee
         W8EOh5v8gst1tFE8v7J4QAV3qqEpOfhcEq0tGQvQgOfwgRDcfzcpnTpHj+VJDCxCgQRX
         DnMQ==
X-Gm-Message-State: AOAM5305jr2OGf7Ko9bRqYOopQktCeUGLCQa1T+cJ4nKB6ivm/8G6Ibu
        9xHYY7fIuX6Yb8YhPEe53FS+q5i7ifXwwQ==
X-Google-Smtp-Source: ABdhPJzcGokZDB5Bi+9GaW7r0x+vIvuKpeDGCUElU63JD+RBsfakGBKtAmaVvOW5KGcET0hs05ObzQ==
X-Received: by 2002:a17:90a:b107:: with SMTP id z7mr8156292pjq.104.1638474103782;
        Thu, 02 Dec 2021 11:41:43 -0800 (PST)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id d9sm3682370pjs.2.2021.12.02.11.41.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 11:41:43 -0800 (PST)
Date:   Thu, 2 Dec 2021 11:41:41 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Arijit De <arijitde@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: How to avoid getting ndo_open() immediately after probe
Message-ID: <20211202114141.35e40115@hermes.local>
In-Reply-To: <CO6PR18MB4465B4170C7A3B8F6DEFB369D4699@CO6PR18MB4465.namprd18.prod.outlook.com>
References: <CO6PR18MB4465B4170C7A3B8F6DEFB369D4699@CO6PR18MB4465.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Dec 2021 18:11:30 +0000
Arijit De <arijitde@marvell.com> wrote:

> Hi,
> 
> I have handled the probe() and registered the netdev structure using register_netdev().
> I have observed in other opensource driver(i.e. Intel e1000e driver) that ndo_open() gets called only when we try to bring up the interface (i.e. ifconfig <ip> ifconfig eth0 <ip-addr> netmask <net-mask> up).
> But in my network driver I am getting ndo_open() call immediately after I handle the probe(). It's a wrong behavior, also my network interface is getting to UP/RUNNING state(as shown below) even without any valid ip address.
> 
> enp1s0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
>         ether 00:22:55:33:22:28  txqueuelen 1000  (Ethernet)
>         RX packets 0  bytes 0 (0.0 B)
>         RX errors 0  dropped 0  overruns 0  frame 0
>         TX packets 252  bytes 43066 (43.0 KB)
>         TX errors 0  dropped 0 overruns 0  carrier 0  collisions
> 
> What is the change required in the driver such that my network interface(enp1s0) should be in down state(BROADCAST & MULTICAST only) after probe()
> and ndo_open() call should happen only when device gets configured?
> 
> Thanks
> Arijit

ndo_open gets called when userspace brings the device up.
Based on the device name, you are running on a distribution which renames
devices; probably systemd/networkd and it is starting the device.

You need to change userspace configuration 
