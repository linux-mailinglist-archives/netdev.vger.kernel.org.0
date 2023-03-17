Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D27496BEE9A
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjCQQkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbjCQQkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:40:43 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5565D8B9;
        Fri, 17 Mar 2023 09:40:42 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id j7so6351911ybg.4;
        Fri, 17 Mar 2023 09:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679071241;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V0NQzreqJNClx/qUUAFqnDkFxgg2yneThmq80r4wg20=;
        b=h7b4KrCCDiWcY9+QA+5544zkQjZ/GGP4W3hoK+dfEdmuH37QUaPtedljTEjJzTvD1x
         0vJ41BjwIPdFaz/WnAgnpAucu6C3ffqV0/yXlvxTeQ0USyQvxcFhWeJb5Ih7SKSHwPvb
         1GVwbGp48n1b11z2XT2o1LfaSu8ApCpG+1gRQ3Ek+NVc42HJRyvF4ZuLhNfQmIHX7KFT
         cgdjLMfQ+kfRWDHB9upk0mhAWwur3LS8AWsqBdlzoNfmvcRWRfRjnZwO9L+6/JJZxCNb
         UIuau8sRNv3mNv5hH5WcziJUokQRgL1Qb/VFy1onCW2c4aQFX72aIkJMPnd0mNXRlBZN
         cgoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679071241;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V0NQzreqJNClx/qUUAFqnDkFxgg2yneThmq80r4wg20=;
        b=RX4i7kyVwEzPC5B/tj9NmqOpA6XQeFJCTMtf5aW2CfTKhxwMmBQtcWYA248o1AcX6U
         cZWF2s78MVMhN7h7DkJm7/+0y2iQ42x4VMzIFrcjdqc3LlcFkX5spjUSpwb0GHWBX5NJ
         seTw9SpSyxL/pTJ0pIZ2nL9/GKzJuHIzlP3Ro01KUKtbgcMy8+DSD4JQFw/aqj0NOVm5
         H0oYb/dB10QEBRJanxRLelz2mu8ybjgKWAaQtulMGu/bA09D0t3Z1J4fgL1c73542sWg
         zezN/ThtJJyrfrQi4UVefNhMZ69c0BMx9YXJQNRaq/LY4Xw4THky0UIdBRroAIHXXPSp
         3Hwg==
X-Gm-Message-State: AO0yUKXEFFtaOHdg1WKIX67THgC1jFAC/Jk42RM2c/AFZJq3tmCN0tPc
        t6Oig0Nc8xlrGAOCZDr2UXfq/qSHWJqrxUX3dMk=
X-Google-Smtp-Source: AK7set+oqbtdb2m0hAtEG6r8tTpitMKFRq6TPr4Ahbi2+eYe60YRrddt5TxfYMT89EDwlFXJzEDOfmqNUTfkBDa8Mb0=
X-Received: by 2002:a05:6902:1101:b0:b47:5f4a:d5fc with SMTP id
 o1-20020a056902110100b00b475f4ad5fcmr147812ybu.9.1679071241214; Fri, 17 Mar
 2023 09:40:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230317120815.321871-1-noltari@gmail.com> <00783066-a99c-4bab-ae60-514f4bce687b@lunn.ch>
In-Reply-To: <00783066-a99c-4bab-ae60-514f4bce687b@lunn.ch>
From:   =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Date:   Fri, 17 Mar 2023 17:40:30 +0100
Message-ID: <CAKR-sGe=+xaTmtOSkRURXCwH4kweMxNOJnPq46cSeZJJa5yXEA@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: tag_brcm: legacy: fix daisy-chained switches
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     f.fainelli@gmail.com, jonas.gorski@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

El vie, 17 mar 2023 a las 17:32, Andrew Lunn (<andrew@lunn.ch>) escribi=C3=
=B3:
>
> On Fri, Mar 17, 2023 at 01:08:15PM +0100, =C3=81lvaro Fern=C3=A1ndez Roja=
s wrote:
> > When BCM63xx internal switches are connected to switches with a 4-byte
> > Broadcom tag, it does not identify the packet as VLAN tagged, so it add=
s one
> > based on its PVID (which is likely 0).
> > Right now, the packet is received by the BCM63xx internal switch and th=
e 6-byte
> > tag is properly processed. The next step would to decode the correspond=
ing
> > 4-byte tag. However, the internal switch adds an invalid VLAN tag after=
 the
> > 6-byte tag and the 4-byte tag handling fails.
> > In order to fix this we need to remove the invalid VLAN tag after the 6=
-byte
> > tag before passing it to the 4-byte tag decoding.
>
> Is there an errata for this invalid VLAN tag? Or is the driver simply
> missing some configuration for it to produce a valid VLAN tag?

Yes, this is a HW issue due to the fact that Broadcom Legacy switches
which use a 6-byte tag cannot identify the tag of newer Broadcom
switches using a 4-byte tag and therefore adding their own tag along
with a default VLAN tag ignoring the corresponding untag bit in those
ports.
But Florian and Jonas can probably provide more information about this
HW issue, and also this link too:
https://github.com/openwrt/openwrt/issues/10313

>
> The description does not convince me you are fixing the correct
> problem.

Well, if you think that I should fix the configuration then I'm afraid
you're wrong.

>
>         Andrew

--
=C3=81lvaro
