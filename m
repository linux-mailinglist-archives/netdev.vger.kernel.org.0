Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3FD259AB66
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 06:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243598AbiHTEg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 00:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiHTEg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 00:36:28 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B79DAEDF
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 21:36:27 -0700 (PDT)
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 9A46E3F120
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 04:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1660970185;
        bh=2uTDm3JqPjue3AIkEgu+x5HgitNBrWkb1DC+v6PopJs=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=hVt4pQcdTSI4Fza4i+pOqnxV19Cplz5AMq+6/uuPSnJzZvmUQcy9mc2TITvB6qIuT
         T0yEX68bWqfZCxHCO4ZClHeLAxQRmIb5U7NIRH62VXFWZStBp9hbWv2f/Fw/PxLaAl
         yhLXcP06yTu4AMMVoHYozTcmjr0dJv8yI7wcR/+D2olX9qr7eYZqbcsRgemJbmhoCZ
         n6QApS+O50REKkC8X5QkrGyVwwiaAOP8R2Kx6o90OnguyOkTdgd7IzW/JV+Zmn/k6U
         KsaokupNmhL2ssLjy1u2tocyS5pUbVO9r5iW4Ke/iMWV2uRjk2I6qBjK4kCkaLbrcC
         bdpUhCRtYS6VQ==
Received: by mail-pj1-f71.google.com with SMTP id ng1-20020a17090b1a8100b001f4f9f69d48so5905669pjb.4
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 21:36:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=2uTDm3JqPjue3AIkEgu+x5HgitNBrWkb1DC+v6PopJs=;
        b=Ba31fm0p0ZDQTruyaJGGuYEk+GFTyFVyobz+VPZg5MzYsKO5FR0fv+1+ic+yeCb/n3
         ZhWFufGduVBY0VOxYVCFFwBFG1Xfa8ST6lITbS+pOtJIcH48hUY5SPdELqLyOEnOL5kv
         Ar5ENXG8clPo8XlplW554F0WPKS1UtAwIaQx8zgJrnYKkSYc5MFJs2oODxCGwOgDVFzN
         R2mZY9mzeRzl6UsLsZPgIZysiqqKtcaSll2TT6yLxASuUn8JfH8EwBaFKF/DtuwEFMhe
         Z9GcUM1D5xL5c5W3faWniCHGA9hqws134zZ5qd++HUVnNubxlV3UZ0NFeCIfpauTAcLq
         PxIA==
X-Gm-Message-State: ACgBeo2tA8AIpp5ISQwbqu/JCEF6qKAOuCsU7skpQkgcH5rca62jlglQ
        asC/k8Y20F67m8Ah2pw57k1c1qedSqjAIQHmkD29sNHS3JTUxehydu3lCx3C3XUWD9qJxqHH4kj
        UrZOfygUMrC80OaM0RUc9mIVPDnnRVrsSyA==
X-Received: by 2002:a63:8b44:0:b0:41c:df4c:7275 with SMTP id j65-20020a638b44000000b0041cdf4c7275mr9056226pge.434.1660970184301;
        Fri, 19 Aug 2022 21:36:24 -0700 (PDT)
X-Google-Smtp-Source: AA6agR709DaA5BVH5jelO0RPsMqblXjlRRKbf7EHi1gcEyJiqQT6WWD7dHt6u76cxCVC/UWdbO/2TQ==
X-Received: by 2002:a63:8b44:0:b0:41c:df4c:7275 with SMTP id j65-20020a638b44000000b0041cdf4c7275mr9056210pge.434.1660970184058;
        Fri, 19 Aug 2022 21:36:24 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id 3-20020a631943000000b0041c30def5e8sm3483872pgz.33.2022.08.19.21.36.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Aug 2022 21:36:23 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 4A50661193; Fri, 19 Aug 2022 21:36:23 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 4341D9FA79;
        Fri, 19 Aug 2022 21:36:23 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
cc:     netdev@vger.kernel.org, liuhangbin@gmail.com
Subject: Re: [PATCH net v5 0/3] bonding: 802.3ad: fix no transmission of LACPDUs
In-reply-to: <cover.1660919940.git.jtoppins@redhat.com>
References: <cover.1660919940.git.jtoppins@redhat.com>
Comments: In-reply-to Jonathan Toppins <jtoppins@redhat.com>
   message dated "Fri, 19 Aug 2022 11:15:11 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2548.1660970183.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 19 Aug 2022 21:36:23 -0700
Message-ID: <2549.1660970183@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Toppins <jtoppins@redhat.com> wrote:

>Configuring a bond in a specific order can leave the bond in a state
>where it never transmits LACPDUs.
>
>The first patch adds some kselftest infrastructure and the reproducer
>that demonstrates the problem. The second patch fixes the issue. The
>new third patch makes ad_ticks_per_sec a static const and removes the
>passing of this variable via the stack.

	For the series:

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>


>v5:
> * fixup kdoc
>v4:
> * rebased to latest net/master
> * removed if check around bond_3ad_initialize function contents
> * created a new patch that makes ad_ticks_per_sec a static const
>v3:
> * rebased to latest net/master
> * addressed comment from Hangbin
>
>Jonathan Toppins (3):
>  selftests: include bonding tests into the kselftest infra
>  bonding: 802.3ad: fix no transmission of LACPDUs
>  bonding: 3ad: make ad_ticks_per_sec a const
>
> MAINTAINERS                                   |  1 +
> drivers/net/bonding/bond_3ad.c                | 41 ++++------
> drivers/net/bonding/bond_main.c               |  2 +-
> include/net/bond_3ad.h                        |  2 +-
> tools/testing/selftests/Makefile              |  1 +
> .../selftests/drivers/net/bonding/Makefile    |  6 ++
> .../net/bonding/bond-break-lacpdu-tx.sh       | 81 +++++++++++++++++++
> .../selftests/drivers/net/bonding/config      |  1 +
> .../selftests/drivers/net/bonding/settings    |  1 +
> 9 files changed, 108 insertions(+), 28 deletions(-)
> create mode 100644 tools/testing/selftests/drivers/net/bonding/Makefile
> create mode 100755 tools/testing/selftests/drivers/net/bonding/bond-brea=
k-lacpdu-tx.sh
> create mode 100644 tools/testing/selftests/drivers/net/bonding/config
> create mode 100644 tools/testing/selftests/drivers/net/bonding/settings
>
>-- =

>2.31.1
>
