Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B84C6D346B
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 01:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfJJXgr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 19:36:47 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43577 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbfJJXgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 19:36:47 -0400
Received: by mail-qt1-f195.google.com with SMTP id t20so5935034qtr.10
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 16:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=av3QhjSP9dPC6K/3Tu2KgLquj3FbUZo3yUCAykIMn5k=;
        b=sblCQ47ky0yb+G8CncWygruasZGCKMX+qc2XaNHtbd8cV4kEIxpaYkSlAYbG5uB1VQ
         LYTOaGca57EVH/+XZjyRFO9xZ4hafeRBbls6XBQOjx5Y6/SHAtkKLBNNaEGupEflD5l6
         TgTV23V4S3rBoDojtt0NMa7bZNOP3ZkDORqYdJKYOBNMl/LuaZr2+CwWJfcA9setqNGn
         u0iyVohaI2PSOiWyeYkIC3YSaFv6cPM4pLJFFqYxoxwSdY57gOiPKRX0UkWJC0Pq9/im
         r2fRVbAIMjQ1Bd02kjdITglYam35edyL7WFVrXbJpvYGa8H0Pj8viER5eBG0oL7GXlx3
         /wXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=av3QhjSP9dPC6K/3Tu2KgLquj3FbUZo3yUCAykIMn5k=;
        b=WFX5C82utQESyOsV/Z/eb8mPiR8MI9nP7+ufjwBjOGg+xbJWf+0DzWZwl3QbkIAQPC
         TAnxlomoap0A7tK47DVAguDxh2MAgEAJgGnCSGM7UBKogi/AgOlTncbrg5KUBVLK5vbP
         duNvpHKtNOrL0HPVTpNwQRMiuLyXnW1TbpLg/8oEwBar+wN1IJCr1SuzJIr9j9O7MzRA
         XjOciHIGpZMLaaCaqJhOI0250P5Z+TrDXE7rPYHGIvMFCbR2UT4+nuJlyVUVjG0O4tU8
         UK+4jSPwiPmRpA3DXrkzhUWMtiQ4UupdHSPkmJekUBV1Up01Q2KVsH69RtnTg+47G1m8
         kDQQ==
X-Gm-Message-State: APjAAAX/kH3MSmeQv+tUEO7/yzKnwhBkWOnVgsPvmJlPdDx7xDGAK8Jw
        Jr9mW7dE+40RAx8632SHw2o0iD9isFc=
X-Google-Smtp-Source: APXvYqyV0WE0/RyJRDQjpbpvsozMlVs1g0rn+cG75p63ykwLI5ueFllcQRtgdhJ60FhKi+XwtzAeWg==
X-Received: by 2002:a0c:f98f:: with SMTP id t15mr1716004qvn.119.1570750606108;
        Thu, 10 Oct 2019 16:36:46 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id u23sm3540908qkm.49.2019.10.10.16.36.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 16:36:46 -0700 (PDT)
Date:   Thu, 10 Oct 2019 16:36:30 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mariusz Bialonczyk <manio@skyboo.net>
Subject: Re: [PATCH net] r8169: fix jumbo packet handling on resume from
 suspend
Message-ID: <20191010163630.0afb5dd8@cakuba.netronome.com>
In-Reply-To: <05ef825e-6ab2-cc25-be4e-54d52acd752f@gmail.com>
References: <05ef825e-6ab2-cc25-be4e-54d52acd752f@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Oct 2019 20:55:48 +0200, Heiner Kallweit wrote:
> Mariusz reported that invalid packets are sent after resume from
> suspend if jumbo packets are active. It turned out that his BIOS
> resets chip settings to non-jumbo on resume. Most chip settings are
> re-initialized on resume from suspend by calling rtl_hw_start(),
> so let's add configuring jumbo to this function.
> There's nothing wrong with the commit marked as fixed, it's just
> the first one where the patch applies cleanly.
> 
> Fixes: 7366016d2d4c ("r8169: read common register for PCI commit")
> Reported-by: Mariusz Bialonczyk <manio@skyboo.net>
> Tested-by: Mariusz Bialonczyk <manio@skyboo.net>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, somewhat begrudgingly - this really isn't the way the Fixes
tag should be used, but I appreciate it may be hard at this point to
pin down a commit to blame given how many generations of HW this driver
supports and how old it is.. perhaps I should have removed the tag in
this case, hm.

Since the selected commit came in 5.4 I'm not queuing for stable.
