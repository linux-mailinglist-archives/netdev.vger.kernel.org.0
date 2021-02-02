Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6754D30CD28
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 21:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbhBBUfn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 15:35:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232556AbhBBUfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 15:35:38 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E79FC06174A;
        Tue,  2 Feb 2021 12:34:58 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id 7so21886281wrz.0;
        Tue, 02 Feb 2021 12:34:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=tnv2kk3+4uAnHFDEYnFneJ8g44LDP4N7nemgkVTA6BU=;
        b=Ij2krijiBcZhnFd4zHACwvGRG3aghcpJPlU75Fus9BBICD8EWXFvuQZ9iaueSV7oei
         /bHZsrXzJIw3Wsbhb6Bvhbgn5vFc+qC6lSv0CfxUc7tIkl7at8IdQYB2dDENJ6McXlFz
         Q3SxT9k2Lrubsaur9IRlFcrNZ1ojFzsO4boJZqQkhVOgLXoAUKCVTttBWpP9LHm215I2
         329k38f3N0HxNF+3xd8erod1KeJEEQDKQXfShyceBCwERs+49l+0P5VPuaGwBnpzNoQ/
         uAavuv+lwjIaV75JqMAfqufNgy9rAa5K+8LidOaZnfh0oAgB18L1k1kidhMEAkVGB6PU
         N1pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=tnv2kk3+4uAnHFDEYnFneJ8g44LDP4N7nemgkVTA6BU=;
        b=K2CwjjhEctMq2qYRrYV3prIKkwE9fuuX6Q9Xjnk2ayAKahBCsZVMEvjagfIy/Eqbhb
         jB4eUcoBRpHppBftSvdUy2aGFNTBkm4HqNP0Qipge0PF6PLd+LywWVCJhR5Ayopd3evx
         apgLnnzgUnRvUvqPnVrmajgYWSBFAqgwMynHmdZy5cvNlHe5IMjqS0agEFPZwSTN331q
         wPoN+B0EbHAgPSNYOBMDG3R05OdiuFXcVtMsHWnTgunKBHtlBMsYR2dHM9m8AB8Pxw1Z
         h1IHXoyVg1X8M/uhQukCCFLvBCQSzDCCxmLrdzJgAsgYJJ3B9E+1oOs0XF1g/vQjrZlu
         4hHw==
X-Gm-Message-State: AOAM533jEe4mk2TbakdADxUojCXuZEQ3155W//7yIbuyqCRxekvRmQdP
        ZnpBjU7JMQSKU4gYAfgaifMzcMexusw=
X-Google-Smtp-Source: ABdhPJw5VOzCoXt4Nf3Ku0U97DzWIoWlOaUBMOgA1OFughIp8ShjC9hOXT9uaMeGELlNqDdJl/uXYQ==
X-Received: by 2002:a5d:4ccb:: with SMTP id c11mr24439808wrt.324.1612298096505;
        Tue, 02 Feb 2021 12:34:56 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:e887:ce1a:5d1d:a96e? (p200300ea8f1fad00e887ce1a5d1da96e.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:e887:ce1a:5d1d:a96e])
        by smtp.googlemail.com with ESMTPSA id s4sm33334620wrt.85.2021.02.02.12.34.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Feb 2021 12:34:56 -0800 (PST)
To:     Raju Rangoju <rajur@chelsio.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/4] chelsio: improve PCI VPD handling
Message-ID: <b07dc99d-7fd0-48c0-3fc4-89cda90ee5d7@gmail.com>
Date:   Tue, 2 Feb 2021 21:34:49 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Working on PCI VPD core code I came across the Chelsio drivers.
Let's improve the way how they handle PCI VPD.

This series touches only device-specific quirks in the core code,
therefore I think it should go via the netdev tree.

Heiner Kallweit (4):
  PCI/VPD: Remove Chelsio T3 quirk
  cxgb4: remove unused vpd_cap_addr
  PCI/VPD: Change Chelsio T4 quirk to provide access to full virtual
    address space
  cxgb4: remove changing VPD len

 .../net/ethernet/chelsio/cxgb4/cudbg_entity.h |  1 -
 .../net/ethernet/chelsio/cxgb4/cudbg_lib.c    | 21 ++++---------------
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |  1 -
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  2 --
 drivers/pci/vpd.c                             | 18 ++++------------
 5 files changed, 8 insertions(+), 35 deletions(-)

-- 
2.30.0

