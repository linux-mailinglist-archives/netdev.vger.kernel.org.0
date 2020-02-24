Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31C7D16B210
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 22:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbgBXVUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 16:20:38 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:32793 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbgBXVUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 16:20:38 -0500
Received: by mail-wr1-f65.google.com with SMTP id u6so12181117wrt.0;
        Mon, 24 Feb 2020 13:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=qscCkCYLPIYQvGQ0vp/FXoAcwoUcoJvhzgh3zcuzI6c=;
        b=LOid8p+1VpBpxox0zBcpa3C4jmGSWxAgqiCFZ/nqlJ2r7iqyEsIl53tJ1PgxQu+wb9
         ZOokU5+fmv6r2aEP599La6oj6x3uwdku2wNHgS6zuFkYq2wXnK9aPUfeDTvAkzAyoZuz
         8vQ8Do61R23Bg9MIaE5IxdKzUrfPwy4h4DbHy8D/+Vwx56sepLNKOL4Bs5mDfZ+cjBOe
         /q45gFnr9CrlCAzf4l7BqLUyN3t+tlYDk7sn4vLs0UcQD/w0ePhrt7PSBqfA4tNwwGSk
         92s39pxazQZeZSVPMH/+7cjvSjjsLi735EsPRVf4G5uQYm82ebyMR640JuPQJzLMdRSV
         9dQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=qscCkCYLPIYQvGQ0vp/FXoAcwoUcoJvhzgh3zcuzI6c=;
        b=XznUBE25XuwBZWopD8owugFFQCSf1H0fRCJP8LvPTjyOWwGyVY9hmMvpk0NTAQPEiI
         DEQm87L/74Cx+w14WoYRU1EmiBzxHpxxQKo1o9+FwDNFcNL7oKklMesYWYj9ODLSDy+K
         ix5zt6VaSUGNCE5POrQ0DV0L9VZ24B3oUvW/YUURUQ0FZxonaTYhYrO1pnpu7Oy7kHgt
         m0BwFgM9S4TFW9SfNKjKKDlK7IYDo+MwGZTdQhXxv1A3Bl+dGVQfwjSt2eaG3v0pO23e
         j8GophiyBDWuf7rExnfN+3wJvB4+ErwUlGmQo8h8Q/Uq4Nz3nP5DAo0zxbT8bkVYck6R
         2fBw==
X-Gm-Message-State: APjAAAUQxwH5WZXJ0w+gZOfdfbYWi1pPxtEo5Ltjjz1hSFFZ1QnGevBW
        gbsXCiNy93Sdzf8/CqabXvU=
X-Google-Smtp-Source: APXvYqxcUPq9UhEbUhugSPEWSY77F4KTVHa1q68vrxMdTNGDidiJeqhAeANXCqtvqr51K8TKN+4eUg==
X-Received: by 2002:adf:e686:: with SMTP id r6mr69503287wrm.177.1582579236173;
        Mon, 24 Feb 2020 13:20:36 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:3d90:eff:31bc:c6a9? (p200300EA8F2960003D900EFF31BCC6A9.dip0.t-ipconnect.de. [2003:ea:8f29:6000:3d90:eff:31bc:c6a9])
        by smtp.googlemail.com with ESMTPSA id b7sm12321269wrs.97.2020.02.24.13.20.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 13:20:35 -0800 (PST)
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        alsa-devel@alsa-project.org
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 0/9] PCI: add and use constant PCI_STATUS_ERROR_BITS and
 helper pci_status_get_and_clear_errors
Message-ID: <5939f711-92aa-e7ed-2a26-4f1e4169f786@gmail.com>
Date:   Mon, 24 Feb 2020 22:20:08 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Few drivers have own definitions for this constant, so move it to the
PCI core. In addition there are several places where the following
code sequence is used:
1. Read PCI_STATUS
2. Mask out non-error bits
3. Action based on set error bits
4. Write back set error bits to clear them

As this is a repeated pattern, add a helper to the PCI core.

Most affected drivers are network drivers. But as it's about core
PCI functionality, I suppose the series should go through the PCI
tree.

Heiner Kallweit (8):
  PCI: add constant PCI_STATUS_ERROR_BITS
  PCI: add pci_status_get_and_clear_errors
  r8169: use pci_status_get_and_clear_errors
  net: cassini: use pci_status_get_and_clear_errors
  net: sungem: use pci_status_get_and_clear_errors
  net: skfp: use PCI_STATUS_ERROR_BITS
  PCI: pci-bridge-emul: use PCI_STATUS_ERROR_BITS
  sound: bt87x: use pci_status_get_and_clear_errors

 drivers/net/ethernet/marvell/skge.h       |  6 -----
 drivers/net/ethernet/marvell/sky2.h       |  6 -----
 drivers/net/ethernet/realtek/r8169_main.c | 15 +++++-------
 drivers/net/ethernet/sun/cassini.c        | 28 ++++++++-------------
 drivers/net/ethernet/sun/sungem.c         | 30 +++++++----------------
 drivers/net/fddi/skfp/drvfbi.c            |  2 +-
 drivers/net/fddi/skfp/h/skfbi.h           |  5 ----
 drivers/pci/pci-bridge-emul.c             | 14 ++---------
 drivers/pci/pci.c                         | 23 +++++++++++++++++
 include/linux/pci.h                       |  1 +
 include/uapi/linux/pci_regs.h             |  7 ++++++
 sound/pci/bt87x.c                         |  7 +-----
 12 files changed, 60 insertions(+), 84 deletions(-)

-- 
2.25.1



