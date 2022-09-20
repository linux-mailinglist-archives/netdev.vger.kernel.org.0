Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2F5F5BEC65
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 19:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbiITRyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 13:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbiITRyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 13:54:02 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F849101FC
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 10:54:01 -0700 (PDT)
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 96612413DC
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 17:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1663696439;
        bh=ZP2D4q1tNP2aKxbLN+OInDR7LOyy+BPSL4siKrJ6mps=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=IUn6gHg6I5qDzC5bM0C1DZvil6eqY/XSLQnJwjd56dvmrYEekrmRpspxaNw6Us3ew
         633xOAtUAeCrJshAidbpgNrcFFAhEnGMwVpxNbVhXZ4G04AF8DM79LEQWvrGKIWWGm
         LINI8KUCynjQY0oVvZ4RyfqhY0EBumZ1nH6i6RmGPzbVDOr2abyRpe2+65hLTuA7Vk
         BwbweBNE9Gfl9jgkTwu3M9IHTDdImxq/zuG4IrD9ZxkQ1SXgFFb25Z+1MY2yJRzh6+
         Gq70+QSenZlm3dPS3Rc/g7hE/+UixURF4SqnFmvvRShZNOlwCzrxF9tw0/RCvYZv7d
         rEKEKjC6nCFjw==
Received: by mail-pg1-f200.google.com with SMTP id i25-20020a635859000000b0042bbb74be8bso2017152pgm.5
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 10:53:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ZP2D4q1tNP2aKxbLN+OInDR7LOyy+BPSL4siKrJ6mps=;
        b=gnpfi42sYKRpzif+HlzbYQJRxVjjRb73BSJUmFcs4bzKl9AXGq0841rDBNkB9J6SQB
         aqrJPqfAQyPQP2Bzvl6DyLcb2DLdYO3pSJptF+pHw7573bJSuPkEFAwx2ib/QUGTzjvd
         T2jnbayyS+W46XFBzcjhyusX9zR8q9JZzuqyYj3CGQMN8EdN25GLZ5E02cTmxAi0RjLL
         xTPu4gFE6j470p/NwVnil5PDHftGWwNc8s+xX/oAokB0g5DNxkZ+K7WFiWOi/DrdtI6Q
         AMgitmAUsCOMmy9cpuQ/dmzucUeuM4rlfmqrNrgYhaH/hDQyMxSZsmNDrzCAS5nqXm3k
         Qtqw==
X-Gm-Message-State: ACrzQf1gYx7BWM0j41ZmcAakQkb45UFyoRzubxdbw9F1tXw/ceZF6ZRd
        8qiN/hxVeuZn7xxE8o3S2BozKDEfXdz+N6R4dqVlhc7+qbN/ubQB87DG6VB3u+KZ7WnFm2B2FcW
        5TjxUCD++qoKq5Af7qNtjBLq60E9QOaq+AQ==
X-Received: by 2002:a17:902:e891:b0:178:7b6:92db with SMTP id w17-20020a170902e89100b0017807b692dbmr800409plg.160.1663696438054;
        Tue, 20 Sep 2022 10:53:58 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5X5vmGQEAa8M+dVX7dtNAcS45klxy6fahTZBsYpcL1NcP0JCJ/om0HWZ/SFtGJ3iziM7ve3A==
X-Received: by 2002:a17:902:e891:b0:178:7b6:92db with SMTP id w17-20020a170902e89100b0017807b692dbmr800386plg.160.1663696437720;
        Tue, 20 Sep 2022 10:53:57 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id c4-20020a17090ad90400b001fffbad35f6sm169415pjv.44.2022.09.20.10.53.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Sep 2022 10:53:57 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id DCA8E604E4; Tue, 20 Sep 2022 10:53:56 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id D780EA0101;
        Tue, 20 Sep 2022 10:53:56 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
cc:     "netdev @ vger . kernel . org" <netdev@vger.kernel.org>,
        Jussi Maki <joamaki@gmail.com>
Subject: Re: [PATCH net v2 0/2] bonding: fix NULL deref in bond_rr_gen_slave_id
In-reply-to: <cover.1663694476.git.jtoppins@redhat.com>
References: <cover.1663694476.git.jtoppins@redhat.com>
Comments: In-reply-to Jonathan Toppins <jtoppins@redhat.com>
   message dated "Tue, 20 Sep 2022 13:45:50 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <29845.1663696436.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 20 Sep 2022 10:53:56 -0700
Message-ID: <29846.1663696436@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan Toppins <jtoppins@redhat.com> wrote:

>Fix a NULL dereference of the struct bonding.rr_tx_counter member because
>if a bond is initially created with an initial mode !=3D zero (Round Robi=
n)
>the memory required for the counter is never created and when the mode is
>changed there is never any attempt to verify the memory is allocated upon
>switching modes.
>
>The first patch provides a selftest to demonstrate the issue and the
>second patch fixes the issue.
>
>Jonathan Toppins (2):
>  selftests: bonding: cause oops in bond_rr_gen_slave_id
>  bonding: fix NULL deref in bond_rr_gen_slave_id

	For the series:

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>


> drivers/net/bonding/bond_main.c               | 15 +++---
> .../selftests/drivers/net/bonding/Makefile    |  3 +-
> .../bonding/bond-arp-interval-causes-panic.sh | 49 +++++++++++++++++++
> 3 files changed, 57 insertions(+), 10 deletions(-)
> create mode 100755 tools/testing/selftests/drivers/net/bonding/bond-arp-=
interval-causes-panic.sh
>
>-- =

>2.31.1
>
