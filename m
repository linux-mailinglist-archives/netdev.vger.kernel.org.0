Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D844E4AD17
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 23:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730445AbfFRVNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 17:13:05 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35702 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729982AbfFRVNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 17:13:05 -0400
Received: by mail-wm1-f68.google.com with SMTP id c6so4721787wml.0;
        Tue, 18 Jun 2019 14:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=jbIsMzKNbiyiT4qd7+hJ+eJ9MUb5iA1IG3AFaSf6GeM=;
        b=cT+vHO2ON3lEDovfybrmoZZIUC9/Hf8M615rHtK7MROMWZPgAE+XB015vVLDx38N0h
         cnxBMkXAcpVXseFfK2kJJRPLvSWebuwdPM3dinFwr3OzYa7MHwhx/IRKAipySqtlfp+3
         PFNJ2ZcjurwGMoQY0oYR6FkfPCb1yqn16bocP17XrHEAD00nNGzDfQT+j4PMGnuZznvL
         87UF/vaCAJB5RMNKkn8PtosUXmDxABiS6F0YS0s/Cmsheq8NxdKJlYxhrdIz3gmbSUuw
         jQp/Zd9xcNDdmA/R/2mWuu2agoeFCzqydVeHQedexUYiVUspz2Ei90VJ23f8VbiKN+kz
         kYCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=jbIsMzKNbiyiT4qd7+hJ+eJ9MUb5iA1IG3AFaSf6GeM=;
        b=jB4dO6WpuNqIGpJTsBw4TjUNH9Nwrv1kEBK1OrQ9EegHb3Q8jt715UKVVh9l0+KQ4R
         OCDktJ4yoJgKwJKvWSrFEz75tr1tGyibixu5nkpYfs19e2C9kimLy42BIfdGhlccLByy
         c8c8pYe5TbCmvEQOu4Q+CmDvOkolYcS22SeFfaVVEyzrn5+qQDbJZ+D8PK2CQOexAJ24
         AYgDKp6qOeJgYPDf1QZDfVEzf9jOUs0IWQi5kVTnAGEsds4Kf6zHlBKgjwTz7/Lmon2W
         Qk8CdC/0X3/6i8oCIGFR/RoM2JjC1zGJF/iduTy68ElrF9jj5ZhBWp3bitRjFCZGr1gv
         KUEQ==
X-Gm-Message-State: APjAAAXlqE3WkFlczFnH4w+4p1dPfXiRKnxXDnJ047kRh4BlURV5w/cD
        gUxTg6V52rFEEloO24gIork7xr/D
X-Google-Smtp-Source: APXvYqzBz5Rv3ZJLoAxXNVu6vMg7rmhe+EaXsZ5d81GewWmoX2NLP+DL2t8yyxb5lNYZwWmc4qL/1Q==
X-Received: by 2002:a7b:cd8e:: with SMTP id y14mr5117467wmj.155.1560892382663;
        Tue, 18 Jun 2019 14:13:02 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:28c3:39c3:997e:395f? (p200300EA8BF3BD0028C339C3997E395F.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:28c3:39c3:997e:395f])
        by smtp.googlemail.com with ESMTPSA id w67sm5124115wma.24.2019.06.18.14.13.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 14:13:02 -0700 (PDT)
To:     Bjorn Helgaas <bhelgaas@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/2] PCI: let pci_disable_link_state propagate errors
Message-ID: <5ea56278-05e2-794f-5f66-23343e72164c@gmail.com>
Date:   Tue, 18 Jun 2019 23:12:56 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers like r8169 rely on pci_disable_link_state() having disabled
certain ASPM link states. If OS can't control ASPM then
pci_disable_link_state() turns into a no-op w/o informing the caller.
The driver therefore may falsely assume the respective ASPM link
states are disabled. Let pci_disable_link_state() propagate errors
to the caller, enabling the caller to react accordingly.

I'd propose to let this series go through the netdev tree if the PCI
core extension is acked by the PCI people.

Heiner Kallweit (2):
  PCI: let pci_disable_link_state propagate errors
  r8169: don't activate ASPM in chip if OS can't control ASPM

 drivers/net/ethernet/realtek/r8169_main.c |  8 ++++++--
 drivers/pci/pcie/aspm.c                   | 20 +++++++++++---------
 include/linux/pci-aspm.h                  |  7 ++++---
 3 files changed, 21 insertions(+), 14 deletions(-)

-- 
2.22.0

