Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDDEB244D
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 18:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729908AbfIMQpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 12:45:07 -0400
Received: from mail-ot1-f50.google.com ([209.85.210.50]:36285 "EHLO
        mail-ot1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbfIMQpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 12:45:07 -0400
Received: by mail-ot1-f50.google.com with SMTP id 67so30033734oto.3
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 09:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=9s0vzNtGPmO1bdQ4Cq4gfsJM39CcJqb8VS/DHl7Sbks=;
        b=qETekpzNjNXe34f7hPN0eIWwDLSvqG4P7krtaNYLQWOEvJHQMJ94aY6/pmJO1sbU/u
         XFFryNjIT0e+bIabn1XsX21V5H1pgn+7WJTcRaH6135OqhBoyfEine6Myd+vL1B4NYVD
         6iXJeU7N+Zy4rqepy5TMEXH+rbXwuKlS3CZPDe59qVt3G5SiVb4muxQzW2o+Cjg22JDC
         6784/9amaMGB+rDT6YHnmaga7m2ZsS+NggU5ZtkKIpSjsOCMl+c3+xX7DB+qNyiGXcHT
         T5l0Kx2CKR2I3cdzkswnoZZOZX6s+VfbpPDTg4wsryzoVpoXddETo5M3mkIGgaZIAxRW
         U2MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=9s0vzNtGPmO1bdQ4Cq4gfsJM39CcJqb8VS/DHl7Sbks=;
        b=ilBnJ1Zl1256T5YaFgDwyO/x65L5YU67TFnfOPMQ2Yi/6jcopyDNtThMne833hIJeQ
         K8/LCj/b71PC0r9nl4a3f8AaxPa7wYLjLWEn17qaNKgZn1P9n29s8PQAdFfkRZ68k8hF
         ZqXdTbn34kwGHdu/mtaVSLWxC5tWVrpSXiFcrLYwhLxo+nEJ/whqP1VEyaemfWExlFwp
         PN0xyt0+ZiDOMf6OSUr4Sq8t63icAepdTscm8IAe4Jj7TR2G3SIieaK6sV3WSDEQsyt4
         JpHc1PN+FdGNoF9K58S+OfOzUsz3ljOX3jLAq6I4U7f5H3ittVFuM0KViPAHSg20Un/l
         DAgw==
X-Gm-Message-State: APjAAAXhmgcEAbO2a8XzTdUkEWnxjdZvmKwFkbEDr+cZkOASgmhA34U7
        X7731i35Hooz1CmG35nou5F3pa+sC5xZgPddgP2XSZ4=
X-Google-Smtp-Source: APXvYqwQvgrMk3rj04Vck2Oa3BCyE0nF5pQbjPS2hniSw7Vd2WPF7zSh6ufadnP+zcnxAnbBQ0Q51aOlO+lHP5bDRHg=
X-Received: by 2002:a9d:21a6:: with SMTP id s35mr43540030otb.77.1568393105987;
 Fri, 13 Sep 2019 09:45:05 -0700 (PDT)
MIME-Version: 1.0
From:   George McCollister <george.mccollister@gmail.com>
Date:   Fri, 13 Sep 2019 11:44:54 -0500
Message-ID: <CAFSKS=NmM9bPb0R_zoFN+9AuG=x6DUffTNXpLSNRAHuZz4ki-g@mail.gmail.com>
Subject: SFP support with RGMII MAC via RGMII to SERDES/SGMII PHY?
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Every example of phylink SFP support I've seen is using an Ethernet
MAC with native SGMII.
Can phylink facilitate support of Fiber and Copper SFP modules
connected to an RGMII MAC if all of the following are true?

1) The MAC is connected via RGMII to a transceiver/PHY (such as
Marvell 88E1512) which then connects to the SFP via SERDER/SGMII. If
you want to see a block diagram it's the first one here:
https://www.marvell.com/transceivers/assets/Alaska_88E1512-001_product_brief.pdf

2) The 1G Ethernet driver has been converted to use phylink.

3) An I2C controller on the SoC is connected to the SFP cage.

4) TxFault, LOS and MOD-DEF0 are connected to GPIO on the SoC.

5) MDIO is connected to the intermediate PHY.

Any thoughts on what might be missing to support this (if anything)
would be appreciated.

Cheers,
George McCollister
