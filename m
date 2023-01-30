Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF4C4680E5A
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 14:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236899AbjA3NB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 08:01:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236980AbjA3NBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 08:01:25 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0B4302AF;
        Mon, 30 Jan 2023 05:01:23 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id f7so3625964edw.5;
        Mon, 30 Jan 2023 05:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=neoL0rnVPCzU+65abZKFSowfu0z0tRwtvrCbBBDQLH4=;
        b=gEjQDI2/GoUW5Wyt9AqJ5KffGpMLWO01c9NtywWi6iUYxwzY6isikPXWseHw7PKrqz
         T94d7Htx9HrZL7c8jO34FHcpigS/cQJfTRBQDaYlPueBQuWjYRV3FWGnFlKhySW/aun2
         iHQXlZ3QOIxbNMWOLbtxM6wg2A42YwIhy7U6vbEqhy1OqdbHZNJJSDQPgR1FEm6hIRiM
         746cJBaXImWKDy38wda3lT24tqOWiu6D7MEImh5U0QIeVMq9SQYhkqMvC1ww5VeN0i/1
         ua+AfFoD1ah9cmif4rx3c8UpRkN1aNbKRCxER0bPLsOyI3sA+7kQbsPPYEgKm9xZ6G51
         TAog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=neoL0rnVPCzU+65abZKFSowfu0z0tRwtvrCbBBDQLH4=;
        b=hcWZ24QtEQCpHEWJTQPDM86M8PlR30P2WGMXjzQBaPTrZJBpdmw9hXn+q9ED1L0Je3
         sz4po/mhjbMjMMGNkUT2UYu298yrnslCJF/aihYuGBIIu5VYSNbwBoH68XgItaf9j6pa
         9ct5WY9EjC4duaN+5KBBanog8tNs9OeelCTI8tCYlGVE63FT2vHuGpb9r2hZA8A7bxwz
         vUzP8qLfHlolGw90B3A5EcV7n0ccqXXEp5R2cTXgGD3tYXIH3QfhpED8opxYAp4pICVh
         NSK2SBWtmISmSEZYb08GpyjmI/k2/AMKlwCsNe1qRhF+lUK4wSJwjCe+n+4bJXdtM1HV
         A7UQ==
X-Gm-Message-State: AFqh2koV7SVxUn1o1Sj0wYc5QvUPJoaNY8dqFNb7NrrnNQdhAEB9ogxD
        tfPwUfMj5oIr1AAuBn2CcLQ=
X-Google-Smtp-Source: AMrXdXuIe4ekBpiEOiGmPzMwqm9U6W91/zQ02eHQC6xSIr7ocUhZjk5EJ/cPmUAH6xoPFo0b1rKegg==
X-Received: by 2002:aa7:dbd0:0:b0:49e:351b:5ab3 with SMTP id v16-20020aa7dbd0000000b0049e351b5ab3mr43751069edt.6.1675083682364;
        Mon, 30 Jan 2023 05:01:22 -0800 (PST)
Received: from skbuf ([188.26.57.205])
        by smtp.gmail.com with ESMTPSA id q11-20020aa7d44b000000b0046ac460da13sm6781607edr.53.2023.01.30.05.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 05:01:21 -0800 (PST)
Date:   Mon, 30 Jan 2023 15:01:19 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>
Subject: Re: [BUG] vlan-aware bridge breaks vlan on another port on same gmac
Message-ID: <20230130130119.a36qt3t27xqahiup@skbuf>
References: <trinity-e6294d28-636c-4c40-bb8b-b523521b00be-1674233135062@3c-app-gmx-bs36>
 <20230120172132.rfo3kf4fmkxtw4cl@skbuf>
 <trinity-b0df6ff8-cceb-4aa5-a26f-41bc04dc289c-1674303103108@3c-app-gmx-bap60>
 <20230121122223.3kfcwxqtqm3b6po5@skbuf>
 <trinity-7c2af652-d3f8-4086-ba12-85cd18cd6a1a-1674304362789@3c-app-gmx-bap60>
 <20230121133549.vibz2infg5jwupdc@skbuf>
 <trinity-fd23c4a0-a979-475e-a077-330577d7d632-1674311727972@3c-app-gmx-bap60>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-fd23c4a0-a979-475e-a077-330577d7d632-1674311727972@3c-app-gmx-bap60>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 21, 2023 at 03:35:28PM +0100, Frank Wunderlich wrote:
> btw. why is my vlan software-only and not pushed to hardware?

Short story, because committing it to hardware is a useless complication.
A standalone port should be VLAN-unaware, or i.o.w. it should not drop
based on VLAN port membership, shouldn't add or strip any VLAN header,
and should forward as if the VLAN wasn't there.

So the behavior of a standalone port is absolutely sufficient as a basis
for an 8021q upper interface to see the traffic it needs, and for the
traffic it sends to reach the outside world as it intended.
