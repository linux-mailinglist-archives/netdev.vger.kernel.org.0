Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C425588042
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 18:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237224AbiHBQ32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 12:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232846AbiHBQ31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 12:29:27 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3723C33E0E
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 09:29:26 -0700 (PDT)
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 5A5C73F464
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 16:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1659457761;
        bh=1Hb65tRMoI26SspFVybFEyCmUoPfVdEbMP7rGOmyF6U=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=aefQ9WlJnpECVkjTGG6EgyE0XTW210wnHMb83AVS+UYQBCUacUakBNR/ewe6TYgxV
         TJdgEoIyOkkM8ULOvdD9MBaA+Pbn2wUeWe74ey27B1a4NtocoqglZGK+MrCospUi7I
         kqTF7vV1EuuO2n5zPqNhzpmX3gid2kDznfKIfJSU/lNmmScSfNgguxca1lvZguTy2C
         C7ILEq5KE+gUGD41Rf4NZkzEBa69RMxK79AdyzdFrI3aILXJ9FLpgFtRDaziy1Q28/
         fKYrKGBqz0O1Grn0dRYJelzuMjx6z8omIK+chMii7e54NxApCVedlzK1uqGW08RcAj
         hXdngIgNKpulw==
Received: by mail-pl1-f198.google.com with SMTP id ix21-20020a170902f81500b0016ee5379fe5so4015016plb.18
        for <netdev@vger.kernel.org>; Tue, 02 Aug 2022 09:29:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-id:mime-version:comments:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=1Hb65tRMoI26SspFVybFEyCmUoPfVdEbMP7rGOmyF6U=;
        b=WlbnA/xo6ydZRmxESq9vupstaBFCbYJWqyAHmxbK3pen0ENPLZjJPDIZ9tPRrSOa+r
         5q2tXZsY8meLB69eRk6BNVlrr1WIFVuG7b5Elaz9aPGrBCJEl9NFcy7bZr+FKlOnjM3S
         BBj9wXNjuxmv0rwG0sPnhd8bgA5XF6+tkpMnd3zYbxjS55OCfNlCtzyrAc67pLQZj0+b
         Nsu5K2Gz3R4QS/E6JJ+UZtIscRdOtSNYRpVSlw3CpFsf2y4UVM8SN2JJsDVUkZBo8F5l
         3yIEpxldp2hIV34xafpORsMN8sjc84jYq0114oaCp74bSokvrLPg3ynlccZTb5BYrTm3
         Xb+A==
X-Gm-Message-State: ACgBeo34vm2eXyTJxW7t9oewUFw3mVII+/nOzbwLcSZY1YOQvIj6aUV3
        HV5hksNm6itl1z7xBTr0Z7uUJhUga8tAnVRzNRQToKOio101czNYfF3Mi3sCLBTXOOYtxJExSYC
        cPO2/DQXcnrC8zTEOaLlr+lWj6FKvulpO2Q==
X-Received: by 2002:a17:90a:c718:b0:1f4:238f:f50d with SMTP id o24-20020a17090ac71800b001f4238ff50dmr306945pjt.104.1659457759910;
        Tue, 02 Aug 2022 09:29:19 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5tladpQzdY1jKfuqCqMlb2iN1z4V+jgRczg/w8t3XMjut7Jz8U36wctoWbpduAP2sLc/mFEw==
X-Received: by 2002:a17:90a:c718:b0:1f4:238f:f50d with SMTP id o24-20020a17090ac71800b001f4238ff50dmr306916pjt.104.1659457759644;
        Tue, 02 Aug 2022 09:29:19 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id u5-20020a654c05000000b003fdc16f5de2sm9345358pgq.15.2022.08.02.09.29.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Aug 2022 09:29:19 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id DF4546118F; Tue,  2 Aug 2022 09:29:18 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id D6C149FA79;
        Tue,  2 Aug 2022 09:29:18 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH v3 net 1/4] net: bonding: replace dev_trans_start() with the jiffies of the last ARP/NS
In-reply-to: <20220802091110.036d40dd@kernel.org>
References: <20220731124108.2810233-1-vladimir.oltean@nxp.com> <20220731124108.2810233-2-vladimir.oltean@nxp.com> <1547.1659293635@famine> <20220731191327.cey4ziiez5tvcxpy@skbuf> <5679.1659402295@famine> <20220802014553.rtyzpkdvwnqje44l@skbuf> <d04773ee3e6b6dee88a1362bbc537bf51b020238.camel@redhat.com> <20220802091110.036d40dd@kernel.org>
Comments: In-reply-to Jakub Kicinski <kuba@kernel.org>
   message dated "Tue, 02 Aug 2022 09:11:10 -0700."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <10960.1659457758.1@famine>
Date:   Tue, 02 Aug 2022 09:29:18 -0700
Message-ID: <10961.1659457758@famine>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:

>On Tue, 02 Aug 2022 11:05:19 +0200 Paolo Abeni wrote:
>> In any case, this looks like a significative rework, do you mind
>> consider it for the net-next, when it re-open?
>
>It does seem like it could be a lot for stable.
>
>Perhaps we could take:
>
>https://lore.kernel.org/all/20220727152000.3616086-1-vladimir.oltean@nxp.com/
>
>as is, without the extra work Stephen asked for (since it's gonna be
>reverted in net-next, anyway)? How do you feel about that option?

	Would that mean that the older stable kernels end up with a
different implementation that's unique to stable, or are you proposing
to take the linked patch,

"net/sched: make dev_trans_start() have a better chance of working with
stacked interfaces"

	as a complete replacement for this series?

	Alternatively, would it be more comfortable to just put this
patch (1/4) to stable and not backport the others?  If I understand
correctly, this patch enables the functionality, and the others are
cleaning up logic that isn't necessary after 1/4 is applied.

	I think this patch will work as described, and haven't thought
of any non-crazy scenarios that it could break (e.g., things that depend
on the "drop after arp_send" discussed elsewhere).

	I also think this patch is preferable to the "stacked
interfaces" patch: it limits the scope to just bonding, doesn't change
dev_trans_start() itself, and should cover any type of interface in a
bond.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
