Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6372A5B2A24
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 01:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiIHXZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 19:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiIHXZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 19:25:51 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87613B2852
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 16:25:47 -0700 (PDT)
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id A42633F468
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 23:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1662679545;
        bh=tS+w+xDxLF4hvMpjpKaRAirhp1pKkbvak4v9jx2p1j8=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=nwxuIqd3PDZwxmWaifOuIsw9wVDoqgcK4pnyGUGI62CcAeW2tVrZlqgLmcdLEU5kv
         0YVlAC8V6olj1WPHoJtWRjHnd46yDKbOJARBtWwwmLtBFSFZ47pBCXvseGfgD7ClpD
         Ou7RsqLs/qhmZ2Tlo1hMP+IRLAKT92CX6Eyw18h6E6WIGFaayygaOlUvxjunuEjq2L
         XOvpbiMUoPKFiRxNIW6zzw355wuJDwBcton1TGeZO7OyPZRiaUYoVBXwYjuPIKq9aZ
         tNvvrLehRQNWCqyD1ql3FrFuCAuxVCzKutuf5ytlsVIZ90vtQ5p+kefuscl0LpwSBq
         30J75nX4raR4Q==
Received: by mail-pj1-f70.google.com with SMTP id e1-20020a17090a7c4100b001fd7e8c4eb1so1907399pjl.1
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 16:25:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=tS+w+xDxLF4hvMpjpKaRAirhp1pKkbvak4v9jx2p1j8=;
        b=5fvCXp2dsDIgUtc/BLdtcYR6t3lOp+IStndF/BUq+VW53eC2VhAWkfvY5S+9oETpea
         dHCgl8qcaxmZALwJQzzkDE0Q8gtr+t8Mth+PkwrSY7B1CiZLkhvlARgS+r3E/EK77iB8
         PuUsd3QnqeGOTDmo8u6aH+2DZDfYHWefMfg3C37daTLGklW1Q/BOqEZee64D8EnKl3cs
         7kZObVbwtEj2G3+KHWPco2Q22IihyPrzThmC0IO/WwaacZhABLidzvR8/BvwNbFwpEKd
         mtPJo9DLXJco4Jlr2Kupbbd+epriGyr+6783aGk+ZfAzTa6Xzz/J8YtOjTowiiYK7+Zh
         8jwQ==
X-Gm-Message-State: ACgBeo0MCvc/BemAgvxBGtuqd5uiNopB9TpiEHL0OzaDMgfElaA/eFgM
        Z3OvqA33MswF46TMtQG0Xig89u/89hTAsN45EdVZAJ1YC4fAgatojCJSUWKgF/HnCHKKWjWCn8r
        L30cZZeGnt+UrfEgqSj8ydYN2F7vdlAFAhA==
X-Received: by 2002:a17:902:f0d4:b0:176:988a:77fd with SMTP id v20-20020a170902f0d400b00176988a77fdmr10958069pla.25.1662679544113;
        Thu, 08 Sep 2022 16:25:44 -0700 (PDT)
X-Google-Smtp-Source: AA6agR63aLutnqaqmiGtlvpKhQuwX7EaLOG3coz37wJVtO5hsoY9Pzm9gjeK2erZlvtMMPj6dm43/A==
X-Received: by 2002:a17:902:f0d4:b0:176:988a:77fd with SMTP id v20-20020a170902f0d400b00176988a77fdmr10958055pla.25.1662679543858;
        Thu, 08 Sep 2022 16:25:43 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id y66-20020a636445000000b00421841943dfsm28651pgb.12.2022.09.08.16.25.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Sep 2022 16:25:43 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 1E34260DBF; Thu,  8 Sep 2022 16:25:43 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 16522A02D5;
        Thu,  8 Sep 2022 16:25:43 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Benjamin Poirier <bpoirier@nvidia.com>
cc:     netdev@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Shuah Khan <shuah@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net v3 0/4] Unsync addresses from ports when stopping aggregated devices
In-reply-to: <20220907075642.475236-1-bpoirier@nvidia.com>
References: <20220907075642.475236-1-bpoirier@nvidia.com>
Comments: In-reply-to Benjamin Poirier <bpoirier@nvidia.com>
   message dated "Wed, 07 Sep 2022 16:56:38 +0900."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <31138.1662679543.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Thu, 08 Sep 2022 16:25:43 -0700
Message-ID: <31139.1662679543@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Benjamin Poirier <bpoirier@nvidia.com> wrote:

>This series fixes similar problems in the bonding and team drivers.
>
>Because of missing dev_{uc,mc}_unsync() calls, addresses added to
>underlying devices may be leftover after the aggregated device is deleted=
.
>Add the missing calls and a few related tests.

	I'm not seeing any gaps in the logic; so, for the bonding parts
of the series

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

	-J


>v2:
>* fix selftest installation, see patch 3
>
>v3:
>* Split lacpdu_multicast changes to their own patch, #1
>* In ndo_{add,del}_slave methods, only perform address list changes when
>  the aggregated device is up (patches 2 & 3)
>* Add selftest function related to the above change (patch 4)
>
>Benjamin Poirier (4):
>  net: bonding: Share lacpdu_mcast_addr definition
>  net: bonding: Unsync device addresses on ndo_stop
>  net: team: Unsync device addresses on ndo_stop
>  net: Add tests for bonding and team address list management
>
> MAINTAINERS                                   |   1 +
> drivers/net/bonding/bond_3ad.c                |   5 +-
> drivers/net/bonding/bond_main.c               |  57 +++++----
> drivers/net/team/team.c                       |  24 +++-
> include/net/bond_3ad.h                        |   2 -
> include/net/bonding.h                         |   3 +
> tools/testing/selftests/Makefile              |   1 +
> .../selftests/drivers/net/bonding/Makefile    |   5 +-
> .../selftests/drivers/net/bonding/config      |   1 +
> .../drivers/net/bonding/dev_addr_lists.sh     | 109 ++++++++++++++++++
> .../selftests/drivers/net/bonding/lag_lib.sh  |  61 ++++++++++
> .../selftests/drivers/net/team/Makefile       |   6 +
> .../testing/selftests/drivers/net/team/config |   3 +
> .../drivers/net/team/dev_addr_lists.sh        |  51 ++++++++
> 14 files changed, 297 insertions(+), 32 deletions(-)
> create mode 100755 tools/testing/selftests/drivers/net/bonding/dev_addr_=
lists.sh
> create mode 100644 tools/testing/selftests/drivers/net/bonding/lag_lib.s=
h
> create mode 100644 tools/testing/selftests/drivers/net/team/Makefile
> create mode 100644 tools/testing/selftests/drivers/net/team/config
> create mode 100755 tools/testing/selftests/drivers/net/team/dev_addr_lis=
ts.sh
>
>-- =

>2.37.2
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
