Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E11E79D874
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 23:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbfHZVc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 17:32:59 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:32896 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729015AbfHZVc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 17:32:59 -0400
Received: by mail-ed1-f68.google.com with SMTP id s15so28439291edx.0
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 14:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=gBwDGsC6foYqXEPI47ZDhCrEWzYaPgLkTrUQJeVlEUI=;
        b=axgBS9niHQTJhaOHrQVs/D2379m7mRjRRp7N1UPdbqaCZiWXR3Vse9jTmhow2Jku5N
         j+jjfar6Dnw3/lU8toCSl/ZVoXiOyNUDafjN3UEhIzpExBk1mNyidPpfk03+k5DM1Ciq
         mqPeyWHxTLlrHCxTrXYLQ724ccQg4L5yCgIX1+LRRoCmOvS3AwYIfazHmf2VXgPup2r+
         1M39IHjlLvRS3cRHySK/29E6hnO4mUnZw3y10DVSVpPltPBRV15e6UbS2VSPkh/hcX6G
         pCAKeJ6C6RTBg0DzTMuGUwoitsT/VnzjMjKUwWkremtCLqPQ4PoX7ScYLVQHHkf/TrUz
         ODWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=gBwDGsC6foYqXEPI47ZDhCrEWzYaPgLkTrUQJeVlEUI=;
        b=i8qZL1tSuOxsmcf2cG4A6z2C86OtPQPR1Feyxrpcb7n11WCOvycWLDQ5lUozzxpGMl
         EYd0JIlSv0raYqFx9cFBeYfHOoQYDNjTmJ8fcsn9cJpmMO1I1nk85Afd2qSW8kCr7566
         9X96oi4/H5j1NexNsJVnt0RIkEFilaBWtuRROoSP40m4QQdqLcH5VkY8soCDB161XzDG
         50C6Jx9GDnxXQEDO2Yr32QNVkuISdVTpafCm1URW0X3qonFr5xch5d8crcSyg9Bo0JYO
         Vr/6h8dKFxgDBmr+JZyltF6VRclHVrSWLF3vGlCQDZtfoHMu1OYQV6cZ0IYGer3BRXmM
         1anQ==
X-Gm-Message-State: APjAAAXN3ZFX38RESktXk1LQBny1XtSRRO6SSsXmf7Ifc+l/zoroqYDx
        uXhpomleBBUQvyhUSkRmGAOw3Q==
X-Google-Smtp-Source: APXvYqzquzVt14p3LLDL+d3Z5AzbHNSEdgfLktAqh2hV/Fjlt9aM1wW8rtmdqp+rQakkGhepRtZVXw==
X-Received: by 2002:a50:f70b:: with SMTP id g11mr2398581edn.263.1566855177482;
        Mon, 26 Aug 2019 14:32:57 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id oq26sm3058283ejb.66.2019.08.26.14.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 14:32:57 -0700 (PDT)
Date:   Mon, 26 Aug 2019 14:32:37 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Mallesham Jatharakonda <mallesh537@gmail.com>
Cc:     borisp@mellanox.com, davejwatson@fb.com, daniel@iogearbox.net,
        davem@davemloft.net, ast@kernel.org, kafai@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: TLS record double free
Message-ID: <20190826143237.7dd91c62@cakuba.netronome.com>
In-Reply-To: <CADgrbRrtawBDAnk+E-PBUd2qiEd7Q3SrvF7F+HVjsE=6JAnvHg@mail.gmail.com>
References: <CADgrbRrtawBDAnk+E-PBUd2qiEd7Q3SrvF7F+HVjsE=6JAnvHg@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you for the report.

On Sun, 25 Aug 2019 22:21:50 +0530, Mallesham Jatharakonda wrote:
> Hi All,
> 
> Am facing one tls double while using the Nitrox(cavium) card and n5pf
> driver over the TLS module.
> 
> Please see the below details:
> 
> TLS module is crashing While running SSL record encryption using
> Klts_send_[file]
> 
> Precondition:
> 1) Installed 5.3-rc4.
> 2) Nitrox5 card pluggin.

Presumably this card contains a crypto accelerator? Does it have any
special characteristic which could help us narrow down the bug search?

Before we proceed - are you able to reproduce this issue with an
pure upstream kernel? It seems the kernel in the BUG report is tainted.

> Steps to produce the issue:
> 1) Install n5pf.ko.(drivers/crypto/cavium/nitrox)
> 2) Install tls.ko if not is installed by default(net/tls)
> 3) Taken uperf tool from git.
>    3.1) Modified uperf to use tls module by using setsocket.
>    3.2) Modified uperf tool to support sendfile with SSL.
> 
> 
> Test:
> 1) Running uperf with 4threads.
> 2) Each Thread send the data using sendfile over SSL protocol.
> 
> 
> After few seconds kernel is crashing because of record list corruption
> 
> 
> [  270.888952] ------------[ cut here ]------------
> [  270.890450] list_del corruption, ffff91cc3753a800->prev is
> LIST_POISON2 (dead000000000122)
> [  270.891194] WARNING: CPU: 1 PID: 7387 at lib/list_debug.c:50
> __list_del_entry_valid+0x62/0x90
> [  270.892037] Modules linked in: n5pf(OE) netconsole tls(OE) bonding
> intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal
> intel_powerclamp coretemp kvm_intel kvm iTCO_wdt iTCO_vendor_support
> irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel
> aesni_intel crypto_simd mei_me cryptd glue_helper ipmi_si sg mei
> lpc_ich pcspkr joydev ioatdma i2c_i801 ipmi_devintf ipmi_msghandler
> wmi ip_tables xfs libcrc32c sd_mod mgag200 drm_vram_helper ttm
> drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm isci
> libsas ahci scsi_transport_sas libahci crc32c_intel serio_raw igb
> libata ptp pps_core dca i2c_algo_bit dm_mirror dm_region_hash dm_log
> dm_mod [last unloaded: nitrox_drv]
> [  270.896836] CPU: 1 PID: 7387 Comm: uperf Kdump: loaded Tainted: G
>         OE     5.3.0-rc4 #1
