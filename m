Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8E854E5022
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 11:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbiCWKP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 06:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiCWKP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 06:15:26 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E0810FCC;
        Wed, 23 Mar 2022 03:13:56 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id a26so1827866lfg.10;
        Wed, 23 Mar 2022 03:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=hLvX9In1jxN1MmiovYwJxjgsn4VqeCvwwYBZvBi7CO8=;
        b=Zf5pwO/z+b6zqpeN5dacXhHvcrf713zmafvc8sSy8t0z52u5r1uZRhyV4XZIRIwmbC
         x9n8Lqxv0rn1j4Nbm2QnMzECR8pvFJTiTByr1e3drc2Iq2NcfyvHfg0L8zdP/N2L8lJO
         vzobpHKPSZIJE5msoH0TE9nsoYQRU3+MUmXzi470pixY+ZU9XG0skAFJXWd300AP9qfr
         vllNF++PhJAARRziXJriMiGeMnSlZ924JgNJDW16l+7DdV0C9GF9n0NqZI3rzpfyLPXo
         Gt7+b+rHI0t6L9g7xL6ZsKc2lth/J6/rJBTHaZti4GGG6cH7za1zCFafr8a+2CJZ+4kc
         aBvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=hLvX9In1jxN1MmiovYwJxjgsn4VqeCvwwYBZvBi7CO8=;
        b=MSNEBymjHkwZcvnyGgc5Y0DfrQm8HF+sEDAZX1cTXokA3JU3bJrs45v2ddJdSnIKW9
         sXi4cbmodZmpLpxHHcNftGbP5XDwju5ORjMXoixRSsO3RKQQ4nGSpZzUrREf0pHnfQuA
         itgcSLbTHyA/Fhi6RmnOUfSoFL67tGau2lmVsyYNwwgG3Od/XM/VndaAX11PYTWx4IGT
         cpyK722F04gwr6HC48t5XemRTLksZCLdHu5qgBp4WWfC7iEoilOLaGz9BWJXc374FbFk
         e3k/1Q9Avy0ZOzW7KrGfi8XmHE3sP96ZjiXPhgqCDwYaeULq8VO59ReEg5XDp/k3g36S
         +Z4w==
X-Gm-Message-State: AOAM530cmEtwAtBnWwDE5FKLRy1+Kg4HDgSGB6hLQ4mTu/MkZQF22eSP
        hjMW8hW29w3cVMQ9lQsWX2Y=
X-Google-Smtp-Source: ABdhPJzYM1NapzxHCy1ebX8F9FoanQrXK+KeduV/abULBsUOa0ZN8ZAlyDoW0Fm24AVD44I00Czx2Q==
X-Received: by 2002:ac2:4c56:0:b0:44a:5592:9fe1 with SMTP id o22-20020ac24c56000000b0044a55929fe1mr838691lfk.162.1648030435054;
        Wed, 23 Mar 2022 03:13:55 -0700 (PDT)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id c20-20020a196554000000b0044a1181c527sm1714363lfj.9.2022.03.23.03.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 03:13:54 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Hans Schultz <schultz.hans@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
In-Reply-To: <20220322110806.kbdb362jf6pbtqaf@skbuf>
References: <20220317153625.2ld5zgtuhoxbcgvo@skbuf>
 <86ilscr2a4.fsf@gmail.com> <20220317161808.psftauoz5iaecduy@skbuf>
 <8635jg5xe5.fsf@gmail.com> <20220317172013.rhjvknre5w7mfmlo@skbuf>
 <86tubvk24r.fsf@gmail.com> <20220318121400.sdc4guu5m4auwoej@skbuf>
 <86pmmjieyl.fsf@gmail.com> <20220318131943.hc7z52beztqlzwfq@skbuf>
 <86a6dixnd2.fsf@gmail.com> <20220322110806.kbdb362jf6pbtqaf@skbuf>
Date:   Wed, 23 Mar 2022 11:13:51 +0100
Message-ID: <86fsn90ye8.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On tis, mar 22, 2022 at 13:08, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Tue, Mar 22, 2022 at 12:01:13PM +0100, Hans Schultz wrote:
>> On fre, mar 18, 2022 at 15:19, Vladimir Oltean <olteanv@gmail.com> wrote:
>> > On Fri, Mar 18, 2022 at 02:10:26PM +0100, Hans Schultz wrote:
>> >> In the offloaded case there is no difference between static and dynamic
>> >> flags, which I see as a general issue. (The resulting ATU entry is static
>> >> in either case.)
>> >
>> > It _is_ a problem. We had the same problem with the is_local bit.
>> > Independently of this series, you can add the dynamic bit to struct
>> > switchdev_notifier_fdb_info and make drivers reject it.
>> >
>> >> These FDB entries are removed when link goes down (soft or hard). The
>> >> zero DPV entries that the new code introduces age out after 5 minutes,
>> >> while the locked flagged FDB entries are removed by link down (thus the
>> >> FDB and the ATU are not in sync in this case).
>> >
>> > Ok, so don't let them disappear from hardware, refresh them from the
>> > driver, since user space and the bridge driver expect that they are
>> > still there.
>> 
>> I have now tested with two extra unmanaged switches (each connected to a
>> seperate port on our managed switch, and when migrating from one port to
>> another, there is member violations, but as the initial entry ages out,
>> a new miss violation occurs and the new port adds the locked entry. In
>> this case I only see one locked entry, either on the initial port or
>> later on the port the host migrated to (via switch).
>> 
>> If I refresh the ATU entries indefinitly, then this migration will for
>> sure not work, and with the member violation suppressed, it will be
>> silent about it.
>
> Manual says that migrations should trigger miss violations if configured
> adequately, is this not the case?
>
>> So I don't think it is a good idea to refresh the ATU entries
>> indefinitely.
>> 
>> Another issue I see, is that there is a deadlock or similar issue when
>> receiving violations and running 'bridge fdb show' (it seemed that
>> member violations also caused this, but not sure yet...), as the unit
>> freezes, not to return...
>
> Have you enabled lockdep, debug atomic sleep, detect hung tasks, things
> like that?

I have now determined that it is the rtnl_lock() that causes the
"deadlock". The doit() in rtnetlink.c is under rtnl_lock() and is what
takes care of getting the fdb entries when running 'bridge fdb show'. In
principle there should be no problem with this, but I don't know if some
interrupt queue is getting jammed as they are blocked from rtnetlink.c?
