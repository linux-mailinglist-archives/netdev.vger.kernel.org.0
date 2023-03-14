Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4556B9B71
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbjCNQ3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbjCNQ3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:29:03 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209C4ACE14
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 09:28:36 -0700 (PDT)
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id C6AB53F592
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 16:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1678810836;
        bh=PXAcYaD/yFFkZXcuBipJhrG3uBj2LEdoin0l7zIrmwI=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=Ti8zJ9jtbYuhyM3RXCsSM3yC8EdUOYFwLh5NYthVMOUPPhIi00XpjC/83DcLxkXq/
         PxX8+ez/NSAe+iCFBZqnT/8VJq7UxmazWMYnVBhwoYuOhE8RaTB5Z/S/yE7CES+Y+3
         Rem22lTTvAumog01goYG9bB2WRWdU6XY1VVklyC/EamFV4tS5sYNeHZxoRcvfqOqx8
         AwMBJkfgzD9P9hLLlGk4zRJF4X2s/AwAupjBAOIIW4lQ+5rICJ6j9a4W75E7uXbHPH
         nbTkwXZm9sTEnxD1oCiA6oojIUxjp2Z94sr72CIzcfElvcP2pkBXjWfi8FZHTBVxH9
         wvgR+qn2U1OfA==
Received: by mail-pg1-f198.google.com with SMTP id 79-20020a630452000000b005030840e570so3762944pge.9
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 09:20:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678810835;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PXAcYaD/yFFkZXcuBipJhrG3uBj2LEdoin0l7zIrmwI=;
        b=Xbkq5NszZ7VbjOD3cX0xKHEXzNtFcO480vOpBmRRoJWvS/lEAquW/Nv8l0g2ykqfH+
         4sppWnez8efhyGPm8nZtXlNdqCi560CFi4WmdzEQ0Dbj6rcVMsi1fRQMGOBzYk9Qdheu
         yEQW83NgJSumHuCk2acD5xg9P7VLBiawzmEmd7yk0Koi2Hl7wqqIgSK7f0pQtNOwV7Pd
         tx+1qNQIYpJwklLoI2PFuil7u+L7ZVoIGCKN6+Qv7LREn6C02S13C0TwyzFYZTwhlbiz
         PLogzao+gLxxhFYM9DLOaPIQE0rBlmHNBC7DAOk5K3h+5mghDuumhSH71jtniZGhNn01
         dlgQ==
X-Gm-Message-State: AO0yUKUH4aoGWsGv/+uopHO5yXHeqpZjRziQGslTpzGJwwj0ANPuZsjC
        WPPvW+/0Vu9xiyBdLfYynD8jBQPLv3b9TLZLR0i8mPFu1LvqJ+w9aNB1gF+3WglHCNnvtOntNB1
        oejl4aC5saPVf4uqiynaMYGriu47WQYz3NQ==
X-Received: by 2002:a17:902:d486:b0:19e:2495:20ea with SMTP id c6-20020a170902d48600b0019e249520eamr45967711plg.28.1678810835429;
        Tue, 14 Mar 2023 09:20:35 -0700 (PDT)
X-Google-Smtp-Source: AK7set9gbTyuwOpeDV0gfndM77gFlbfNPKGml9PU/MHMEOBHGshly8BeePAGzP1BzquQdDsoAp75oQ==
X-Received: by 2002:a17:902:d486:b0:19e:2495:20ea with SMTP id c6-20020a170902d48600b0019e249520eamr45967695plg.28.1678810835180;
        Tue, 14 Mar 2023 09:20:35 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id j7-20020a170903024700b001a043e84bf0sm1957193plh.209.2023.03.14.09.20.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Mar 2023 09:20:34 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 5A70A5FEAC; Tue, 14 Mar 2023 09:20:34 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 527A99FA5F;
        Tue, 14 Mar 2023 09:20:34 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
cc:     netdev@vger.kernel.org, monis@voltaire.com, syoshida@redhat.com,
        andy@greyhouse.net, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com,
        syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com
Subject: Re: [PATCH net v2 0/4] bonding: properly restore flags when bond changes ether type
In-reply-to: <20230314111426.1254998-1-razor@blackwall.org>
References: <20230314111426.1254998-1-razor@blackwall.org>
Comments: In-reply-to Nikolay Aleksandrov <razor@blackwall.org>
   message dated "Tue, 14 Mar 2023 13:14:22 +0200."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <32339.1678810834.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 14 Mar 2023 09:20:34 -0700
Message-ID: <32340.1678810834@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nikolay Aleksandrov <razor@blackwall.org> wrote:

>Hi,
>A bug was reported by syzbot[1] that causes a warning and a myriad of
>other potential issues if a bond, that is also a slave, fails to enslave =
a
>non-eth device. While fixing that bug I found that we have the same
>issues when such enslave passes and after that the bond changes back to
>ARPHRD_ETHER (again due to ether_setup). This set fixes all issues by
>extracting the ether_setup() sequence in a helper which does the right
>thing about bond flags when it needs to change back to ARPHRD_ETHER. It
>also adds selftests for these cases.
>
>Patch 01 adds the new bond_ether_setup helper that is used in the
>following patches to fix the bond dev flag issues. Patch 02 fixes the
>issues when a bond device changes its ether type due to successful
>enslave. Patch 03 fixes the issues when it changes its ether type due to
>an unsuccessful enslave. Note we need two patches because the bugs were
>introduced by different commits. Patch 04 adds the new selftests.
>
>v2: new set, all patches are new due to new approach of fixing these bugs

	For the series:

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>


>Thanks,
> Nik
>
>[1] https://syzkaller.appspot.com/bug?id=3D391c7b1f6522182899efba27d891f1=
743e8eb3ef
>
>Nikolay Aleksandrov (4):
>  bonding: add bond_ether_setup helper
>  bonding: restore IFF_MASTER/SLAVE flags on bond enslave ether type
>    change
>  bonding: restore bond's IFF_SLAVE flag if a non-eth dev enslave fails
>  selftests: bonding: add tests for ether type changes
>
> drivers/net/bonding/bond_main.c               | 22 +++--
> .../selftests/drivers/net/bonding/Makefile    |  3 +-
> .../net/bonding/bond-eth-type-change.sh       | 85 +++++++++++++++++++
> 3 files changed, 102 insertions(+), 8 deletions(-)
> create mode 100755 tools/testing/selftests/drivers/net/bonding/bond-eth-=
type-change.sh
>
>-- =

>2.39.2
>
