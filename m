Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F80588197
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 20:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbiHBSCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 14:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236926AbiHBSB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 14:01:26 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E443B51A2C
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 11:00:45 -0700 (PDT)
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id EDB0B3F45D
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 18:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1659463244;
        bh=APzF2QhYLwrj7VJu7ODMFW7oVPDRohhRo1yGOwOv+VE=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=cMOvlZiKAEuQDG3+vpofZ/RPB+eBNIVV9jCiaMsLON8qRkwcej/yd2u6kDGiLFwYB
         IpTfuANaqgkOvLLlfvjOZKn6AcQp1+9rtR70vEgEOWVMN5YtjzXPSOYm1/C223q4/t
         TOnnXL7HBvvyP4lfFN3mttdGXe9pfm3+JCuFW4k7j9frZIjdewGeFvTcorjobJll4m
         QolJ3NdfaGn00jKN2Kij/HUg0vJMvF/jI7yLIq2wf38ko4XBvC7n8+uYkT9TUk3Hfm
         o8s2P0g/ZzC0nQNLo01WRtc7f68d17idzh9TGPqBGkhCYL2LGbRvHeFcbQZ/YIyDFU
         xm6M0oraYiyyg==
Received: by mail-pg1-f197.google.com with SMTP id 21-20020a630015000000b0041b022ba974so5855713pga.9
        for <netdev@vger.kernel.org>; Tue, 02 Aug 2022 11:00:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-id:mime-version:comments:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=APzF2QhYLwrj7VJu7ODMFW7oVPDRohhRo1yGOwOv+VE=;
        b=41U37sbhyxuuum9lSVMn6rbrpyYx/ddyVUysikrGDmU2Avqfe8qs1+ewUfza1MR34H
         O3cA+SPv6jYWkQOf/JTPL0FWDDYzb+9j5Mk0RlT/wmiDhUsFpz2mdV1cJjBWUZVL2i7A
         orLS038eMS5I5GOScv7r6mldBOP5/J3iennPRbv2QrnaQg4fvxB4qAZ7WWeaXj4gonaZ
         HJGM8xP/aIiS2agb71tCNKHx49jQX9nlSw8panGM0VbwyBrSOEToitVCIqWIBNLrm3/n
         j/yQb3UHq2xirEVIPVbsL207zkgDxiqrHmIJYO4YMmhU+qwZFdwsE5yo6sgfSzEMVnmx
         7J/w==
X-Gm-Message-State: ACgBeo1GHpUYRLmsv7LuaZvHmsGWdCLStjdWi5FTVhKqGPrQiNgAv4Lx
        B336OD1HHvDotKGRPl1MXYahlMf3ey5NizmFKXHXgVSBNTN7Q+U2YypCGI6p2LYRx0Kh1siF10h
        9jhO9CQcpV4g4fnuArE4lnA+KdWQH1nxDzg==
X-Received: by 2002:a17:90a:14f:b0:1f4:e8d0:e5ab with SMTP id z15-20020a17090a014f00b001f4e8d0e5abmr659247pje.200.1659463242589;
        Tue, 02 Aug 2022 11:00:42 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5gmRrztDhQy3aYUHTBGFCLAlYOzP76nz+bAbZ2HYJodZDpid8ev3XnxE+UzOZJVGxmWeu7qA==
X-Received: by 2002:a17:90a:14f:b0:1f4:e8d0:e5ab with SMTP id z15-20020a17090a014f00b001f4e8d0e5abmr659213pje.200.1659463242272;
        Tue, 02 Aug 2022 11:00:42 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id e11-20020aa7980b000000b00528a097aeffsm1952139pfl.118.2022.08.02.11.00.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Aug 2022 11:00:41 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 7B0016118F; Tue,  2 Aug 2022 11:00:41 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 7510D9FA79;
        Tue,  2 Aug 2022 11:00:41 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Paolo Abeni <pabeni@redhat.com>
cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
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
In-reply-to: <e11a02756a3253362a1ef17c8b43478b68cc15ba.camel@redhat.com>
References: <20220731124108.2810233-1-vladimir.oltean@nxp.com> <20220731124108.2810233-2-vladimir.oltean@nxp.com> <1547.1659293635@famine> <20220731191327.cey4ziiez5tvcxpy@skbuf> <5679.1659402295@famine> <20220802014553.rtyzpkdvwnqje44l@skbuf> <d04773ee3e6b6dee88a1362bbc537bf51b020238.camel@redhat.com> <20220802091110.036d40dd@kernel.org> <20220802163027.z4hjr5en2vcjaek5@skbuf> <e11a02756a3253362a1ef17c8b43478b68cc15ba.camel@redhat.com>
Comments: In-reply-to Paolo Abeni <pabeni@redhat.com>
   message dated "Tue, 02 Aug 2022 19:33:52 +0200."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <16273.1659463241.1@famine>
Date:   Tue, 02 Aug 2022 11:00:41 -0700
Message-ID: <16274.1659463241@famine>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paolo Abeni <pabeni@redhat.com> wrote:

>On Tue, 2022-08-02 at 16:30 +0000, Vladimir Oltean wrote:
>> On Tue, Aug 02, 2022 at 09:11:10AM -0700, Jakub Kicinski wrote:
>> > On Tue, 02 Aug 2022 11:05:19 +0200 Paolo Abeni wrote:
>> > > In any case, this looks like a significative rework, do you mind
>> > > consider it for the net-next, when it re-open?
>> > 
>> > It does seem like it could be a lot for stable.
>
>I'm sorry, I did not intend to block the series. It looked to me there
>was no agreement on this, and I was wondering if a net-next target
>would allow a clean solution to make eveyone happy.
>
>I now see it's relevant to have something we can queue for stable.
>
>I'm ok with Jay suggestion:
>> Alternatively, would it be more comfortable to just put this
>> patch (1/4) to stable and not backport the others? 
>
>The above works for me - I thought it was not ok for Jay, but since he
>is proposing such sulution, I guess I was wrong.

	My original reluctance was that I hadn't had an opportunity to
sufficiently review the patch set to think through the potential
regressions.  There might be something I haven't thought of, but I think
would only manifest in very unusual configurations.

	I'm ok with applying the series to net-next when it's available,
and backporting 1/4 for stable (and 4/4 with it, since that's the
documentation update).

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
