Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76E4017C88E
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 23:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgCFWyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 17:54:04 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35575 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgCFWyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 17:54:03 -0500
Received: by mail-wm1-f65.google.com with SMTP id m3so4044301wmi.0
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 14:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=oro0fIlAywUpDDnaaYh8TQQc6WsRQK8SqA63cQTs/ZU=;
        b=Yn4jYN99e+DkrXW7u4mxtjY0qNsvncXwaxnSDF+kATMqLZPbeAFwFEiC00i+94Lro5
         acVMF4iQS4oqcjicyAjvSUgxRPoj0TVdQEZ9vgdDBTjEEaZzO7dgkm9yAl/rKwZxjs1a
         COpJYYpInmSa3oDKcOIoHrWlOtW6XlMbbvSk87TNshUenC/6h/xKFFfzDQGYvGtnB+v2
         IfKbHDXUi4TGK5KH6r1SdQNx5//N+7Zo6DVa9aUVpsjJGkZbBAyucB+GN5WfYgCHsLO5
         fWLZEmyjaTZwlQXABnir7MX2tLFonfBfM6iEEfHkZYuQgoMH82AEKpy5hcO6ZtFbDH4x
         5ZGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=oro0fIlAywUpDDnaaYh8TQQc6WsRQK8SqA63cQTs/ZU=;
        b=He++ZAPRUKqnwBDpuX0LlQ3CftKXV6jeDVhiv9N81/HTy6DsETAa4/RCt0+pIS4Xiu
         fMGvhrlBIUaW/m7R5t5GrFiCiX+vtBLZ/bYfWhN8kseZyqsr98h15rgBB7xKavZbMfey
         zW1iH7kqVvSyPwfeFvLOxHMYEAmURiDWMawBdzSUGbzauYNKkKogEoWSw5yN89KftthF
         2wxzGdc0ZnsKfe8zvQailm8Ap/4GGjFJRjrK63zjisHwinTg2N957idQxair65YgLbnl
         0qUJmf+pkcOLDpAuPfr3aO3XMEXDlNjLh82QupuAT8g8wnvWrkaWdePr8Qw/Ptj05e8y
         mrTQ==
X-Gm-Message-State: ANhLgQ1XkOzlnoIQxZJJIpSaAzQeBHpSE9USTeO4ydkvor5C1cqLUsmq
        /sh0vJNRNQ7duCoaWu8iQvsQtgxA
X-Google-Smtp-Source: ADFU+vsaY4WD6Zdnmwo8vErMvnmMpMk9U231zs6NWpAU3KcuHXsLQRDGf2W27ND0f0kZYauprAgkGw==
X-Received: by 2002:a1c:9915:: with SMTP id b21mr5920300wme.24.1583535241392;
        Fri, 06 Mar 2020 14:54:01 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:1447:bded:797c:45a5? (p200300EA8F2960001447BDED797C45A5.dip0.t-ipconnect.de. [2003:ea:8f29:6000:1447:bded:797c:45a5])
        by smtp.googlemail.com with ESMTPSA id e7sm30840439wrt.70.2020.03.06.14.54.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2020 14:54:00 -0800 (PST)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next 0/4] r8169: series with improvements to rtl_tx
Message-ID: <de8e697e-dd20-cbae-4d2d-b1e8994ba65d@gmail.com>
Date:   Fri, 6 Mar 2020 23:53:43 +0100
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

This series includes few improvements to rtl_tx().

Heiner Kallweit (4):
  r8169: convert while to for loop in rtl_tx
  r8169: ensure tx_skb is fully reset after calling rtl8169_unmap_tx_skb
  r8169: simplify usage of rtl8169_unmap_tx_skb
  r8169: remove now unneeded barrier in rtl_tx

 drivers/net/ethernet/realtek/r8169_main.c | 46 ++++++++---------------
 1 file changed, 16 insertions(+), 30 deletions(-)

-- 
2.25.1

