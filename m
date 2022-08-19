Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5300159A6FA
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 22:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351779AbiHSUNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 16:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351270AbiHSUNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 16:13:37 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6D32A264
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 13:13:35 -0700 (PDT)
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 737E53F146
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 20:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1660940013;
        bh=2uTDm3JqPjue3AIkEgu+x5HgitNBrWkb1DC+v6PopJs=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=Gkl7Vb58jig6h7DjUpEDwof8UuhSfVQ48CGbgXVgakQLWfDynWAkd+nMG1xvCsHd3
         /pF7naSwg9/HAzbKAHppDvSy9JvJAdzG4MIGkz9sYI+bKDQwDcH+O2/xAW+0CWa0Rt
         5CE7ml/NabbhGbbRTJfQe/KsCLK2swhWd6taU75k+rYtGuSHFQbPRI00f45YLo10Bw
         jKQzrLigJrhZqotD8Os/a3I10+eiBpZmfV38ocpuji9kzyu12rkUsUwsgZXOl0j1eg
         CcMxNsF4WDqqXfdV7/5/89lXSwHS3ePA08dJbDbFJOk41anmdmJYYlSfyAjNDUuoFI
         gSbOPkhZPfLjg==
Received: by mail-pl1-f199.google.com with SMTP id a15-20020a170902eccf00b0016f92ee2d54so3289573plh.15
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 13:13:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=2uTDm3JqPjue3AIkEgu+x5HgitNBrWkb1DC+v6PopJs=;
        b=ibWTVUOSLa/8ncOwTY2E0GyZNcUcy2n74A/O22GloaK880U1E0j+8ZOmdYlOchZX3A
         KTHQUu0I58hrcbtkTnMEqItZuP6Wcv9GeuBcAKlNxHRNVo5V4Azg7PIwV12ewtj2oZhE
         NCnRX/wfZpSBg4hTdzTcTvRuYCpAsTlncbFBq554yWQHP6bEnKhwTox2+qIhh1LiYoh/
         iWNXofzVlFbGykN02BC9/Hm81OGU8SLd7lQAeHs8kfrzXOS/Mus74jkW1o26BVnxVqOH
         ++9/SFf4SV/P5fmAyNIlO+9hkIdqXy9+HkcgGkzpm/AvlEB4dE0BstH739OdYIaseHud
         9yaA==
X-Gm-Message-State: ACgBeo0v/1d1zk4xeFRQcqvXCdDc/eeNmI+gRjlurFOC9XYjScZZuf8F
        HPNdA2ikrS0Sc0cAQ042k3nfbbQOY4Un7Rf84D/SL2qYIGeGNYlJTDv8dIdSmAi5d73Bsgi/nVq
        3eIjZ55O1MQHnudfPijh3H5wjzmzm1AIdDQ==
X-Received: by 2002:a05:6a00:13a8:b0:536:1c12:8513 with SMTP id t40-20020a056a0013a800b005361c128513mr3477939pfg.8.1660940011499;
        Fri, 19 Aug 2022 13:13:31 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6EfhB2mDvpDD3JGA8DWtwvHM6HCG+hVzS+B56WtMp8iDejIOIdfWCZoIXR/1Tn9UCetZyNkQ==
X-Received: by 2002:a05:6a00:13a8:b0:536:1c12:8513 with SMTP id t40-20020a056a0013a800b005361c128513mr3477921pfg.8.1660940011236;
        Fri, 19 Aug 2022 13:13:31 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id bf10-20020a170902b90a00b001728ecd2277sm3529673plb.113.2022.08.19.13.13.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Aug 2022 13:13:30 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 4D44761193; Fri, 19 Aug 2022 13:13:30 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 481689FA79;
        Fri, 19 Aug 2022 13:13:30 -0700 (PDT)
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
Content-ID: <11675.1660940010.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 19 Aug 2022 13:13:30 -0700
Message-ID: <11676.1660940010@famine>
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
