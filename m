Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE506E7262
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 06:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbjDSEoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 00:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjDSEoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 00:44:23 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF65F213F
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 21:44:21 -0700 (PDT)
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id B19753F1AC
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 04:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1681879459;
        bh=/7BMm3sIo0IBLyrQQdUD02cMKOKS5T/Rh8fwfm2J568=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=dCOKjwD8ndf/DgcpqZik0/z7lX0Alr+ZH4BZEm1moGlc3WJ3DRoyL0SJ58Uo9b6hJ
         bIy3O+rzGHX/6Xa6L6+o1pAPfof/nSJaxrPvdd3NwPTR1uqorMThhuoIl8PeozXQvj
         EzbGBmhJ4MD4Zcfq1VNmJLwRou1UMEfO0Ba4nZRciKw0gl5eLinuEge5x0ogHl5FT5
         ydUJbTQHLSWYxnizFFYeQ3tSiMD2Vkmf3KqtYLmZzQr57JlSNnovM7wVq+jU/WLoZf
         EiQVaEvZ772nd5XK9LCYn+tWlxZvUU2cvKr8k7rdzvhzHsViPyffVkKZeeyAzh1EFP
         jp8ZUYFNsm5ew==
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1a66bd44f7eso25743425ad.0
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 21:44:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681879457; x=1684471457;
        h=message-id:date:content-id:mime-version:comments:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/7BMm3sIo0IBLyrQQdUD02cMKOKS5T/Rh8fwfm2J568=;
        b=l9VasxB0IXxiYG5SUpKKmHhShd8sOi/rT3X2D5gH4uovieOpU8HvRDEN+QUuTNrQGn
         KkZxET2rfN5bH2dMGqU4BrFCPwVcWW/Iq5cIbF6L63jGdrLuqU1GOkNsiT//fpwt3qjv
         secbBvr1ZQ5NCBIS820yQ/k0JwNkb+J/aJ2qaMLcDS74A79okIpkuFXwk7XuQeWu+sAk
         rr177CkjK+96HUhbJ8qXAYybCvT2K4Hwsj53hOZTWPWuYgddeiyHlenUa/u5+FcE8gJT
         pexHolYnbsWpSNWPUbYtW32VGCk3vASqUK99rqZNdYSCIt9CanpkUQXQPuIzWt+FCIPi
         93IA==
X-Gm-Message-State: AAQBX9fg6XvWuLvL0777XmfaJsIMN4B4du/omWoHBja2FwnBdR6qFfOI
        EtoaIhUg/Xqx84kUTgAn2BCjg3O8/kMMJXU9LMFakBmc7d5oeZY925kWLWkSXMw3ZbyhQWyHGZl
        7fnIKdENOxgyhuI9FIMSip127WZKNMw37hA==
X-Received: by 2002:a17:902:7c10:b0:1a6:fe25:4138 with SMTP id x16-20020a1709027c1000b001a6fe254138mr3873709pll.59.1681879457728;
        Tue, 18 Apr 2023 21:44:17 -0700 (PDT)
X-Google-Smtp-Source: AKy350YsQXxdE3U/l2yQmJUzhuu0xcyFcNr4qDqfTBoB/PUc0HIZtSAQD9ExHzsiGlBl84RM9fjphA==
X-Received: by 2002:a17:902:7c10:b0:1a6:fe25:4138 with SMTP id x16-20020a1709027c1000b001a6fe254138mr3873696pll.59.1681879457480;
        Tue, 18 Apr 2023 21:44:17 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id o11-20020a170902bccb00b0019309be03e7sm10403493pls.66.2023.04.18.21.44.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Apr 2023 21:44:17 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id A0CFE607E6; Tue, 18 Apr 2023 21:44:16 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 99E829FB79;
        Tue, 18 Apr 2023 21:44:16 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: [PATCHv5 net-next] bonding: add software tx timestamping support
In-reply-to: <20230418211746.2aa60760@kernel.org>
References: <20230418034841.2566262-1-liuhangbin@gmail.com> <20230418205023.414275ab@kernel.org> <ZD9pbffw3s1HVwvE@Laptop-X1> <20230418211746.2aa60760@kernel.org>
Comments: In-reply-to Jakub Kicinski <kuba@kernel.org>
   message dated "Tue, 18 Apr 2023 21:17:46 -0700."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <24845.1681879456.1@famine>
Date:   Tue, 18 Apr 2023 21:44:16 -0700
Message-ID: <24846.1681879456@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:

>On Wed, 19 Apr 2023 12:09:17 +0800 Hangbin Liu wrote:
>> > I'll apply Jay's ack from v4 since these are not substantial changes.
>> > Thanks!  
>> 
>> Sorry, not sure if I missed something. bond_ethtool_get_ts_info() could be
>> called without RTNL. And we have ASSERT_RTNL() in v4.
>
>Are there any documented best practices on when to keep an ack?
>I'm not aware of such a doc, it's a bit of a gray zone.
>IMHO the changes here weren't big enough to drop Jay's tag.

	I don't know of any such documents, but just to clarify for
posterity, I'm fine with having my ack on the patch.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
