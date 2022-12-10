Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F299648B83
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 01:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiLJABS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 19:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiLJABQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 19:01:16 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393D4B1048
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 16:01:14 -0800 (PST)
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 4C6BC3F176
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 00:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1670630470;
        bh=dTla1/72IISFsTTkEGMVDbGGvj0mbLcbfVtUwN7qszE=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=NDuovwqYXIhnnIJ6XYafqe9c8BWnfPPH/XqdFhC59+PVv6P71tRPJFdfli7979X2n
         2YxSslROOWZulaZShjvavjjMQr4zANyNKkr0BtQ062NAOhTeOhlaQWkDRFMrqp6KHA
         YjdSOJAH/GhGspNfc4+7dxm/Ut9ND6xCwPE01ZkJ6mXtM9xqpTh/LeJfGDaXo3nUjG
         5wToYqL3Dxik+LqEN4Zdc96fqmwh9GlzDB+2qprRSR05MpwvBtRkLXeGrKGc/QFPyZ
         5DJdaYSSojtkAYEM2FhEHxZFIkwmWugZh/DftZ6e5mWkvu+9gFr2Jdb7SGuP83RBYu
         H64rDI7WkyI8A==
Received: by mail-pg1-f198.google.com with SMTP id o8-20020a6548c8000000b0047927da1501so1049003pgs.18
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 16:01:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dTla1/72IISFsTTkEGMVDbGGvj0mbLcbfVtUwN7qszE=;
        b=TP5hUX+ZrIzktdwbNmIxhA+PTsatXdToShBaNd4S9AsmS8GgDaRJpD3WWAVk3tbG5K
         q0kzILuyVUZHfOoFnqlwSibMTif2r0psn7mInl9/I6CYDqO7qB/HIn2OLzCphSY5niaw
         PSzM1DvXkVsgMOX1AZlR4Hi+WoaGTVVgbLoHtAIi95Mz3sCOwCPoQE3XvycqUG7m0x1S
         UGZ4J4a2afjko9SX4mQgxdDSAz9rrHx/a/LapyIdj9KGQdN5tW/em5oAmnCjLfsbrru8
         T/BvCo45n5HGeC4nwlRpTDmiYLyO+SFJtQrM/7isKIr0ixWnX3q5WBYzDfqjebih3f0U
         5QoA==
X-Gm-Message-State: ANoB5pkUdhRfqItgYGK0AQXvZtT07CLaAQMSUZKqaoxciDlfDFwKrbSe
        do+JaHAVCHl0RT1i3I4MYkCglYZS7yex4ArKSkZYA0in1cuNbSZwz6LvBsQmsdWs3I+3GLgANV8
        Onbz0bcQwVQwhjJRiMr7o7WvnnrH3P8K5+Q==
X-Received: by 2002:a17:903:240d:b0:187:4920:3a76 with SMTP id e13-20020a170903240d00b0018749203a76mr7944076plo.34.1670630468522;
        Fri, 09 Dec 2022 16:01:08 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4NodzGSPYyR3Mma7TpZtNn35H3s7yrrltja7gzr0PN4a7/WNZbsMpa83XxpjB2SGzQKPIFtg==
X-Received: by 2002:a17:903:240d:b0:187:4920:3a76 with SMTP id e13-20020a170903240d00b0018749203a76mr7944059plo.34.1670630468212;
        Fri, 09 Dec 2022 16:01:08 -0800 (PST)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id o37-20020a634e65000000b00478fbfd5276sm1448691pgl.15.2022.12.09.16.01.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Dec 2022 16:01:07 -0800 (PST)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 4FF375FF12; Fri,  9 Dec 2022 16:01:07 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 487319FAA8;
        Fri,  9 Dec 2022 16:01:07 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, liali <liali@redhat.com>
Subject: Re: [PATCH net 0/3] Bonding: fix high prio not effect issue
In-reply-to: <20221209101305.713073-1-liuhangbin@gmail.com>
References: <20221209101305.713073-1-liuhangbin@gmail.com>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Fri, 09 Dec 2022 18:13:02 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9327.1670630467.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Fri, 09 Dec 2022 16:01:07 -0800
Message-ID: <9328.1670630467@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> wrote:

>When a high prio link up, if there has current link, it will not do
>failover as we missed the check in link up event. Fix it in this patchset
>and add a prio option test case.
>
>Hangbin Liu (2):
>  bonding: access curr_active_slave with rtnl_dereference
>  bonding: do failover when high prio link up
>
>Liang Li (1):
>  selftests: bonding: add bonding prio option test

	For the series:

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

	The only comment I have is that since prio is a signed value, it
would be nice if the selftest tested negative prio values.

	-J


> drivers/net/bonding/bond_main.c               |   6 +-
> .../selftests/drivers/net/bonding/Makefile    |   3 +-
> .../drivers/net/bonding/option_prio.sh        | 246 ++++++++++++++++++
> 3 files changed, 252 insertions(+), 3 deletions(-)
> create mode 100755 tools/testing/selftests/drivers/net/bonding/option_pr=
io.sh
>
>-- =

>2.38.1
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
