Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33AE42F528
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 16:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237327AbhJOOZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 10:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbhJOOZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 10:25:38 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A39C061570
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 07:23:31 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id y15so42555000lfk.7
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 07:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=I1yd0Kg3PInoRGoWNvW2I6imujJbF3fiak9H6lsWXX4=;
        b=A6gREVibTcvNTmVGky9se8S1lvkH2RkTmrzx0uyklyAHNnznIAuwXNsCMXBArO6tuW
         Ts5Hj6G//NuWsg4XxCr0W6zmdwbDovER6pZr3jxyaq1KOov635aTjdrShrsV1Pn8vJ0+
         rA1vkK+DDlWjqIoXydA/DIvJ7JCOWrm/aoB5CXJ/PZBt8Qq00wU5bCGKnpzURcC+sKPY
         tGLgDbPrBmWhM8xm7XHQM8TrhAvOqoHzESWsDNpMtIbNUiLM21ro5rPKFDS89Il75pkQ
         M95wMgkncoNfS3qsRW6+pTIoo4Pf7dUix4TR4Bb/S1+yqOwMS+iqMf1CPJwh3qLHnm2e
         yh8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=I1yd0Kg3PInoRGoWNvW2I6imujJbF3fiak9H6lsWXX4=;
        b=byc0cMdaMb2ooRVIoKpEfCWnx0EgOPjjx6ErqLBEmK7IYcNb+1Oqod6MM+0ybPRv6A
         liW6zharnZqJ1yRWYbUhgynAjKj9FLbhWXuKEwZ/tHhH4Za4Gm2JfLPsDLDTKZl40EVt
         sRwdNXeim1UdOoYzfg0hTlXA1yt+AjL6onO2tbEhAqr8LW4WYf3CZt909hjZrWA+KJqT
         UqG2zJoWH8yj6ew1hpYx1hg5ElMZze66+G+H3kl0iT7cY6f5XSiexUDxF3hyD3mlnNJA
         QNCT8z+HSq5auiuBpo4kDtaRQEFt8FP1wJbElbLrUjuqBznrWNujUKkv1CJ9Zf50cEE9
         MnJw==
X-Gm-Message-State: AOAM533mQhStltdym854adxtD0xHygYrHw6giweZ3z0y+rA6Lyvjo/tg
        iJMOusYYXqKyxAP4SOggn+zJtgqrOpKJIxLPzaeEsL4S4waWlS9c
X-Google-Smtp-Source: ABdhPJzZJ8TJkviFsYjb2WrxfvYmZctptkQf1LYDEtA2oI9sGpdQwQvqOquaksjkFTUO+sjBQbc7RFGwwkOD3REm54Q=
X-Received: by 2002:a05:6512:2213:: with SMTP id h19mr11789382lfu.576.1634307809209;
 Fri, 15 Oct 2021 07:23:29 -0700 (PDT)
MIME-Version: 1.0
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Fri, 15 Oct 2021 22:23:17 +0800
Message-ID: <CALW65jbKsDGTXghqQFQe2CxYbWPakkaeFrr+3vAA4gAPjeeL2w@mail.gmail.com>
Subject: MT7621 ethernet does not get probed on net-next branch after 5.15 merge
To:     netdev <netdev@vger.kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Siddhant Gupta <siddhantgupta416@gmail.com>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Cc:     openwrt-devel@lists.openwrt.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

After the merge of 5.15.y into net-next, MT7621 ethernet
(mtk_eth_soc.c) does not get probed at all.

Kernel log before 5.15 merge:
...
libphy: Fixed MDIO Bus: probed
libphy: mdio: probed
mt7530 mdio-bus:1f: MT7530 adapts as multi-chip module
mtk_soc_eth 1e100000.ethernet eth0: mediatek frame engine at 0xbe100000, irq 20
mt7621-pci 1e140000.pcie: host bridge /pcie@1e140000 ranges:
...

Kernel log after 5.15 merge:
...
libphy: Fixed MDIO Bus: probed
mt7621-pci 1e140000.pcie: host bridge /pcie@1e140000 ranges:
...


I tried adding debug prints into the .mtk_probe function, but it did
not execute.
There are no dts changes for MT7621 between 5.14 and 5.15, so I
believe it should be something else.

Any ideas?
