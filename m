Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF44932C3D7
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354307AbhCDAIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:08:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1451572AbhCCGKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 01:10:05 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954B5C06178A
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 22:09:24 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id a9so8396563qkn.13
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 22:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vt-edu.20150623.gappssmtp.com; s=20150623;
        h=sender:from:to:cc:subject:mime-version:date:message-id;
        bh=KOGOKvRSzoNPFZQryb8VGK9fT5tcMe0OoD6HHUH2Lxg=;
        b=Bi12P9AOAIL8ie09CdRp3QX8XoD0z0Ee9KBtLgBtV/JPuNqq9a7doMIDpxeqsCWccN
         502Q6n0Hb93dD7tC1uvOpSvGXUsYKqAp3iTY/v/hjqLJatBDxm5GZGBgscEwNpYo0yPb
         aBGXGjjwQfGCpJWS0LZIUcKJqr5QUPGl6Ts2MSU3XsjnbvGDmPbmIreS+Jhz4XYeVZ/H
         L+vM0mG3s8a9QVyljmDLHv54JU7YJc2Ypv/PFaydIXx4JZLGEzTwFveQCYJAViXbh/Ez
         2Dv6Vb/D8/WftzLEVtcR6Qh1TpT0URWkcgDSzWo92vtxO+D1jG5U9dU/vXZEw9WlOtSP
         lu5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:mime-version:date
         :message-id;
        bh=KOGOKvRSzoNPFZQryb8VGK9fT5tcMe0OoD6HHUH2Lxg=;
        b=icJE7qa/NiL0EaECtyYSbfRiJMPQmH7uSwyicAncMnS61Yb94M4uKDIFAj2Nthhgad
         E7BZomzJsSBSmDAnFL7qsGOxKYSabQZIWyM241fEi2+ZaGWHcxo90PEQ7nNEFtfWDoIB
         yBaF01gCdergmUq460FoGcn1rUadC9bJ9BD7T7fP2eP8uv1WMYF3SuqNfAzGf3kmdnXg
         fJ0O9R5buupZDFBuj9NVGxRMKQQYfdgiK2JyQI/FiXxEtpmDVylbaAgxCaYVE6se4MxB
         b/zNRC/5ThQWTvMtDgUg+fLLvfpkE85PvMtfGE2HJRGKPPx83JGu35MyrCmgsuE/dfvZ
         ZJLw==
X-Gm-Message-State: AOAM532xpJFxcu4jjT5NHFA4SP4XpGnV1lP5RQ0bZ9x8rZJMseXrOPzh
        Q/dd/5B5zg+Vl+UZzbgQafJW7g==
X-Google-Smtp-Source: ABdhPJyyS94moCcVTiYItlptxqX3tKO7r+u9zG1zGn1qvs4uV2MfNAjtsei9B8JmvKtmlRNz8deVMQ==
X-Received: by 2002:a37:3c8:: with SMTP id 191mr22964562qkd.90.1614751763714;
        Tue, 02 Mar 2021 22:09:23 -0800 (PST)
Received: from turing-police ([2601:5c0:c380:d61::359])
        by smtp.gmail.com with ESMTPSA id 19sm16590523qkv.95.2021.03.02.22.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 22:09:23 -0800 (PST)
Sender: Valdis Kletnieks <valdis@vt.edu>
From:   "Valdis =?utf-8?Q?Kl=c4=93tnieks?=" <valdis.kletnieks@vt.edu>
X-Google-Original-From: "Valdis =?utf-8?Q?Kl=c4=93tnieks?=" <Valdis.Kletnieks@vt.edu>
X-Mailer: exmh version 2.9.0 11/07/2018 with nmh-1.7+dev
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: next-20210302 - build issue with linux-firmware and rtl_nic/ firmware.
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date:   Wed, 03 Mar 2021 01:09:22 -0500
Message-ID: <199898.1614751762@turing-police>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So my kernel build died..

  UPD     drivers/base/firmware_loader/builtin/rtl_nic/rtl8106e-1.fw.gen.S
make[4]: *** No rule to make target '/lib/firmware/rtl_nic/rtl8106e-1.fw', needed by 'drivers/base/firmware_loader/builtin/rtl_nic/rtl8106e-1.fw.gen.o'.  Stop.
make[3]: *** [scripts/Makefile.build:514: drivers/base/firmware_loader/builtin] Error 2

I tracked it down to a linux-firmware update that shipped everything with .xz compression:

% rpm2cpio linux-firmware-20201218-116.fc34.noarch.rpm | cpio -itv | grep 8106e-1
-rw-r--r--   1 root     root         1856 Dec 19 04:43 ./usr/lib/firmware/rtl_nic/rtl8106e-1.fw
631034 blocks
% rpm2cpio linux-firmware-20210208-117.fc34.noarch.rpm | cpio -itv|  grep 8106e-1
-rw-r--r--   1 root     root          848 Feb  8 16:38 ./usr/lib/firmware/rtl_nic/rtl8106e-1.fw.xz
340217 blocks

and my .config shows it's self-inflicted (no, I don't remember why it's in there):

# Firmware loader
CONFIG_EXTRA_FIRMWARE="rtl_nic/rtl8106e-1.fw"
CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware"

But then I take a closer look at  drivers/net/ethernet/realtek/r8169_main.c
#define FIRMWARE_8168D_1	"rtl_nic/rtl8168d-1.fw"
#define FIRMWARE_8168D_2	"rtl_nic/rtl8168d-2.fw"
#define FIRMWARE_8168E_1	"rtl_nic/rtl8168e-1.fw"

So now I'm mystified how this compressing all the firmware files is supposed to work...
