Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB65422DD4F
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 10:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgGZIfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 04:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbgGZIfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jul 2020 04:35:11 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB10C0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 01:35:11 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id l2so1356052wrc.7
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 01:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Fd0kdDDomSYw73gxhuK3Byf9Wjw8VrotHdNoMdDTnQA=;
        b=qFgKdX4J0e7feEGlaK65c9pV9wQiKo+ap6v5MSNmCGIkuvtfTdb+BjfSE/exUf4ycm
         F1w5V6Sj6xbkE+fS7RGyCIfSpueMaTmbmp8loPgeZK6R+8xZYPZgwqI8bPH8UbrgzZn6
         zSA8ClwemMTcX8QTCn6ZGalsb+OHTnDGAhV3P0+19f5eOMMxU8sHXFbv+jcLpu5vJlUQ
         cdzi73tU+kYRkR/gceA3yKY/XO6w6BjPx9t/JcXrXw9w7Ie3WyMy0lgv+zjiQgoGCSdC
         c9wn9vxL/gA1r5pyeeJ/3ydrSQnI4qXPun5tlII5RMKQ+HaaZrcObVE/1BjZb7l7mnwn
         BnOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Fd0kdDDomSYw73gxhuK3Byf9Wjw8VrotHdNoMdDTnQA=;
        b=DEPSx4tFlppAr8yLP0YZhpwPMNeOAqReTn1sIj7ss24iCt4nuCRsI29pqooztp6zKX
         TrTdP1fcNQ1dS9/1zXyRD15GG0Dlr2hEZle5SXG9Lr7juMJR56O9gtYuFI5sEOzxD7eL
         NberNbA3mClIPXIPPDlZVtnj2tcLlt/AR7dhITeOyUCcuVEBD//5u71U5i1XPujKIe//
         5CVH5s871WQhNGZKxGRlAc/vxtsIkuOzT3eBHevEixgC2hAiwyJqGD7wJjguMs9mLv8R
         AihZnrdrTLE0ml/ocbBEfFhSfE/sbkmxBklZRw2aM9TUqGkCnlUXVDWYhy8OVp+kMFj0
         L4mg==
X-Gm-Message-State: AOAM530R/ET1Q41H+TejCNJVP3lrYWOqSuAhTnrE9tEq7IQSYKrcBSxV
        GAqJvUZlukxeP9oI4QVzI/V8pQ==
X-Google-Smtp-Source: ABdhPJzQykzRcQFyUoJ7JbVUy2mFJZFqr9B59xGbab1EfckSx+3pKa8z6Ugt8xwElRsAU+qF9B2NZg==
X-Received: by 2002:a5d:464e:: with SMTP id j14mr15642884wrs.361.1595752510214;
        Sun, 26 Jul 2020 01:35:10 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id v15sm7533827wrm.23.2020.07.26.01.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2020 01:35:09 -0700 (PDT)
Date:   Sun, 26 Jul 2020 10:35:09 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [net-next v3 1/6] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
Message-ID: <20200726083509.GE2216@nanopsycho>
References: <20200725150651.17029-1-vadym.kochan@plvision.eu>
 <20200725150651.17029-2-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200725150651.17029-2-vadym.kochan@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Jul 25, 2020 at 05:06:46PM CEST, vadym.kochan@plvision.eu wrote:
>Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
>ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
>wireless SMB deployment.
>
>The current implementation supports only boards designed for the Marvell
>Switchdev solution and requires special firmware.
>
>The core Prestera switching logic is implemented in prestera_main.c,
>there is an intermediate hw layer between core logic and firmware. It is
>implemented in prestera_hw.c, the purpose of it is to encapsulate hw
>related logic, in future there is a plan to support more devices with
>different HW related configurations.
>
>This patch contains only basic switch initialization and RX/TX support
>over SDMA mechanism.
>
>Currently supported devices have DMA access range <= 32bit and require
>ZONE_DMA to be enabled, for such cases SDMA driver checks if the skb
>allocated in proper range supported by the Prestera device.
>
>Also meanwhile there is no TX interrupt support in current firmware
>version so recycling work is scheduled on each xmit.
>
>Port's mac address is generated from the switch base mac which may be
>provided via device-tree (static one or as nvme cell), or randomly
>generated.
>
>Signed-off-by: Andrii Savka <andrii.savka@plvision.eu>
>Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
>Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
>Signed-off-by: Serhiy Pshyk <serhiy.pshyk@plvision.eu>
>Signed-off-by: Taras Chornyi <taras.chornyi@plvision.eu>
>Signed-off-by: Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
>Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
>---

[...]


>+static const struct net_device_ops netdev_ops = {

Prefix, please:
prestera_netdev_ops.



>+	.ndo_open = prestera_port_open,
>+	.ndo_stop = prestera_port_close,
>+	.ndo_start_xmit = prestera_port_xmit,
>+	.ndo_change_mtu = prestera_port_change_mtu,
>+	.ndo_get_stats64 = prestera_port_get_stats64,
>+	.ndo_set_mac_address = prestera_port_set_mac_address,
>+};

[...]
