Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2714588315
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 22:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234530AbiHBUYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 16:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiHBUYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 16:24:42 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AEC351A02
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 13:24:41 -0700 (PDT)
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id AE5173F467
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 20:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1659471878;
        bh=XckhJFclqKrbU42VcCej+1+auTuCQcWjrkD/B9dmAbA=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=muKkBd9CvbyObVFRUyGtjVO4BkNcV1wUs10/LYg4NpY/2e2CYIavW8Pdf7+R4XBAD
         dKNmQJ9QWx+3dFQPELCPRxyaZTqYmXI52dZyFASjyzN/df+Nq+KsUm29Uq5JUiyIIr
         Izj6x+rGVrJm0cw1FBY6UzZsc2gMzOJjrbNsxElgq+JjWYNW8ZsY5A8Bh/RxhtDIMo
         aqlHrTr+0Cwuy+WkmgQnD3/v3n6ji7VHEctI4FNGXDBhDvCAd1ei1KBarm/YFfgUHu
         D6SOD+i2UQnUaGc7wjZR6mI3V3siYegq1HaEN+Vu0yC3hLzbyRGzTnpsqS0aOu8Eda
         Q5ulJi+CWBvWw==
Received: by mail-pj1-f71.google.com with SMTP id r13-20020a17090a454d00b001f04dfc6195so8030853pjm.2
        for <netdev@vger.kernel.org>; Tue, 02 Aug 2022 13:24:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-id:mime-version:comments:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=XckhJFclqKrbU42VcCej+1+auTuCQcWjrkD/B9dmAbA=;
        b=qVYOTxOKmu/3jZ8zgv3dvSb/DTTvs9vVpPhSvVN1iCjv/Kiu8AEIP7esZtU97AfM6L
         mAdWH7QHeO8qkg694UIDBY4ctc55SmoD9BXhAQeXuT9MDegwmsq/ihBGnHBUeOiPWHZp
         lUzsknbOM6psqc6+nQZKEA7oZ1ynMpEvIXvqXc+aXio4Hnj8OJoQwOXc1hssdcy8Et0H
         cqjN6uzbWa5J3vlhsk+AtC8zgM1wXgSSVCrLN2Il8ozkIewpfu2cqZ/DK0CXGnY07SJW
         FMvbfKkyRekegQTTkUQoyteY+xhx+vMDduGK+UcV79eYeub56rktDXqluB+bC/+Q+jvI
         +jtw==
X-Gm-Message-State: ACgBeo0+pQ7zbdRtX1Ed5X+2S5y/fr0vXAaC7t2xyHz71Gjj0ngULbS8
        6icQQ16ff+m5ZxDC8a/y9DXANWiGtA//XvEQVj3SuXQ63Naq3WISaYyczg44oQ5cUnL/RdMK0Ay
        WcxvWHbej/7mk//1BVuNMYM449EFvVUf/OA==
X-Received: by 2002:a17:90a:f016:b0:1f4:e30c:188d with SMTP id bt22-20020a17090af01600b001f4e30c188dmr1258466pjb.60.1659471876047;
        Tue, 02 Aug 2022 13:24:36 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4dCetgx1mp2nCg+NhZTJDC+ib/82grlFRB/XPL/DiER4b7D46uEBO7msPT9RdUm4gjmEcUOQ==
X-Received: by 2002:a17:90a:f016:b0:1f4:e30c:188d with SMTP id bt22-20020a17090af01600b001f4e30c188dmr1258436pjb.60.1659471875761;
        Tue, 02 Aug 2022 13:24:35 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id o11-20020a170903210b00b0016d2db82962sm125360ple.16.2022.08.02.13.24.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Aug 2022 13:24:35 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id D2BC66118F; Tue,  2 Aug 2022 13:24:34 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id CBA399FA79;
        Tue,  2 Aug 2022 13:24:34 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
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
In-reply-to: <20220802121029.13b9020b@kernel.org>
References: <20220731124108.2810233-1-vladimir.oltean@nxp.com> <20220731124108.2810233-2-vladimir.oltean@nxp.com> <1547.1659293635@famine> <20220731191327.cey4ziiez5tvcxpy@skbuf> <5679.1659402295@famine> <20220802014553.rtyzpkdvwnqje44l@skbuf> <d04773ee3e6b6dee88a1362bbc537bf51b020238.camel@redhat.com> <20220802091110.036d40dd@kernel.org> <20220802163027.z4hjr5en2vcjaek5@skbuf> <e11a02756a3253362a1ef17c8b43478b68cc15ba.camel@redhat.com> <16274.1659463241@famine> <20220802121029.13b9020b@kernel.org>
Comments: In-reply-to Jakub Kicinski <kuba@kernel.org>
   message dated "Tue, 02 Aug 2022 12:10:29 -0700."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <23019.1659471874.1@famine>
Date:   Tue, 02 Aug 2022 13:24:34 -0700
Message-ID: <23020.1659471874@famine>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:

>On Tue, 02 Aug 2022 11:00:41 -0700 Jay Vosburgh wrote:
>> >> Alternatively, would it be more comfortable to just put this
>> >> patch (1/4) to stable and not backport the others?   
>> >
>> >The above works for me - I thought it was not ok for Jay, but since he
>> >is proposing such sulution, I guess I was wrong.  
>> 
>> 	My original reluctance was that I hadn't had an opportunity to
>> sufficiently review the patch set to think through the potential
>> regressions.  There might be something I haven't thought of, but I think
>> would only manifest in very unusual configurations.
>> 
>> 	I'm ok with applying the series to net-next when it's available,
>> and backporting 1/4 for stable (and 4/4 with it, since that's the
>> documentation update).
>> 
>> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
>
>One more time, sorry :) If I'm reading things right Vladimir and 
>I would like this to be part of 5.20, Paolo is okay with that,
>Jay would prefer to delay it until 5.21.
>
>Is that right?

	I'm sure there's an Abbott & Costello joke in here somewhere,
but I thought Paolo preferred net-next, and I said I was ok with that.

>My preference for 5.20 is because we do have active users reporting
>problems in stable, and by moving to 5.21 we're delaying things by
>2 weeks. At the same time, 5.20 vs 5.21 doesn't matter as we intend 
>to hit stable users with these change before either of those is out.

	I have no objection to 5.20 if you & Paolo don't object.

	For stable, I believe that 1/4 (and 4/4 for docs) is the minimum
set to resolve the functional issues; is the plan to send all 4 patches
to stable, or just 1 and 4?

	I do think this patch does widen the scope of failures that may
go undetected on the TX side, but most of the time the failure to
receive the ARP on the RX side should cover for that.  Regardless,
that's a concern for later that doesn't need to be hashed out right now.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
