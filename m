Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48E0756A3BF
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 15:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235442AbiGGNeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 09:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235291AbiGGNeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 09:34:20 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97B1C1CFC4
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 06:34:19 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id sb34so32404682ejc.11
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 06:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=okAwAj/dur0TgONLZKl6ESmvVp9wfbAFg6URaz0Ss1w=;
        b=VIED6OhiS+wXK80wFq18NU+T6BtY4qpnnHhOcZonl02jHmn910kkWWSie8vwZqCRHz
         qsLu3pjzfTUHtikUWzmxzVq0ByQ4Wqwc5FX/JTSSczqJi+2hNHcGJDxZLiSRde1WYCnv
         oTNj+7C39Qy5fT3pZuf2oQIb+X8pC/2TtL1sKGniZemJJ+ED3mhR+j3TrGeKBsGHaM9w
         aZDrGGZVAKaPFpFuorLKWK50VHlp3/m7fVpFFNyF2e8P2qphRUgNAOXWQ8MsGZRrMPCt
         nQ1tidZ5mEO+vtVdVe+laWBEY5JMTgpOpnonCX+MKGSn8Je46p94CX1lWzF9tnDTEQe8
         BGCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=okAwAj/dur0TgONLZKl6ESmvVp9wfbAFg6URaz0Ss1w=;
        b=bbzdv1cUVOaKxyPWZdNmKigBOFLIODxWmwoH2TnZbuK4ywKExG/hz+IYqRc3dnPlxa
         eoVS+nHUhpLh+/yHIweFvQiNRz8bwV1w58LvXvOvuvOivlAlRPOC9e53+qBhFH8rm7Kd
         VpVX+pPV89QKVgOM0Hr6CHcCuG9yq4hWgGdX50O/aaRhdX3dWbgQXWLHyj6g4Y5k9ON+
         yJraRPpI3etArO6dE0QREljhUe969vrPGoYTEfvnDGVpoVWjxiODOV61qut/lt6PLn/t
         RmwSLepSVvCiKm2LaZUrsWCeXRnSdGcNTEvCPIrVyIo+0CXJW8i+0VA34GwTV1qoPuX9
         livw==
X-Gm-Message-State: AJIora9+cCGIxOREkoAU3s06oZY9dLGjoDKaMkDYDZaN8Z86I6RmRsD5
        mX7q2qtmgUcZ/bHREKHm8c0pvSt4iBAr0BJUihU=
X-Google-Smtp-Source: AGRyM1tKXeYz/8NOtu8cPIv5dGWc2QgvyB5Q6LK3dDQWml895Cw2/voyTjUksFclNRQlQt4b1d9EuQIhJiZ/sWfDglI=
X-Received: by 2002:a17:906:7386:b0:715:7024:3df7 with SMTP id
 f6-20020a170906738600b0071570243df7mr45563819ejl.543.1657200858043; Thu, 07
 Jul 2022 06:34:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220705173114.2004386-1-vladimir.oltean@nxp.com> <20220705173114.2004386-2-vladimir.oltean@nxp.com>
In-Reply-To: <20220705173114.2004386-2-vladimir.oltean@nxp.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Thu, 7 Jul 2022 15:34:07 +0200
Message-ID: <CAFBinCCqDRNzeAM2sU2QjJS6WxzCoUi6pwtktE4Th1NTXXNdKg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 1/3] selftests: forwarding: add a
 vlan_deletion test to bridge_vlan_unaware
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Tue, Jul 5, 2022 at 7:32 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
[...]
>  .../net/forwarding/bridge_vlan_unaware.sh     | 25 ++++++++++++++++---
>  1 file changed, 22 insertions(+), 3 deletions(-)
While working on an OpenWrt package for these selftests I found that
this should be added to the Makefile (in the same directory as the
test).
That way it can be installed by a distribution using:
  make -C tools/testing/selftests/net/forwarding/ \
      INSTALL_PATH="some/install/path" \
      install

If you agree then I can also send patches for adding no_forwarding.sh
and local_termination.sh to that Makefile (which are the only two
files which are missing currently).


Best regards,
Martin
