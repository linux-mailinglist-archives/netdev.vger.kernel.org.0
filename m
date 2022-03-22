Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEA44E3D19
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 12:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233855AbiCVLCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 07:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233816AbiCVLCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 07:02:47 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B1B5A08E;
        Tue, 22 Mar 2022 04:01:19 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id g24so22215206lja.7;
        Tue, 22 Mar 2022 04:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=Gkv/Enp/IZmxcfofAOCjTBnszxX0aQMOLZxHcfoa6sI=;
        b=cjd3KI2i21VdxnTAX1vYFQv6InII+4UIOpRkW0Ttkn25FiUgiZzihokuoLn2u36vWj
         Q3ZcqOqeG+xvuevBbHaGOQjtlM2kZlqMXQpfmCDp5+BFaBIovgfjJvWYTBm+/abwkyMC
         sUF1AnOXneFlisQihQI5QzuITbgQNp7MbxSJL4CGsdoiW5ou4V6EYBz7zzaswNhIebRI
         McrLmmO5VoNznl/5PtHFYtSFS3d99FUJFBMnrbl6JezgidCYPNegRQWJuRtlu+OB+qbp
         xuqAjvzNLJAB8ow04SzHI9MIY4q6hESh0kWlvf0iPg0fSciu0AY/dbli7YUz3IjbpgnT
         irdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Gkv/Enp/IZmxcfofAOCjTBnszxX0aQMOLZxHcfoa6sI=;
        b=cztiYhhxCp8w5D8WupBtdEg0kdEKAFwkIWh2Cl1XOVPMX1Haw+OfD9pf+w1VbW9B1B
         Bd2U3P65E6DuRU6MuEcjGEYWukqpduuInnhCP3GWUHPHoP0ABEV6Pi+RmDmL9cDymIC5
         68DDCSsclO4JGOh3s90xRSmOr7/bcgkxpJFCZ7XWZaE7+efAxTnB+7S3Um0VDPoRrDfa
         IKndoFk2oRW9xtH5kCDmY7nxb0cYN9YibK2SEXQUT4gw461FcP13L9Zrr3qeB9y+2OF+
         hAXaGy9E/vh4nGHbwuNowZ6Xx1Guq4L82EL7WFFYiMAc8/+Iz/1mBetJU+0+8Hl128Ij
         Ndjw==
X-Gm-Message-State: AOAM532kClFxeXPchAvCU11RSIpbRG49oGtakw28RAuOEb3Q2dY3xvfH
        lWwulOcLsIGz2nfqbaRvW50hoFne9f2Qeg==
X-Google-Smtp-Source: ABdhPJy17WGcM1t+58Ds/55kZB/UVfagy6H7Awrmygrcjn4ZsnGei+mnwfnnX1ZBL1MjhCeUXHA+MQ==
X-Received: by 2002:a2e:8847:0:b0:249:7d2f:8a26 with SMTP id z7-20020a2e8847000000b002497d2f8a26mr10192677ljj.493.1647946877458;
        Tue, 22 Mar 2022 04:01:17 -0700 (PDT)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id 5-20020a2e1445000000b002491768821asm2392781lju.49.2022.03.22.04.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 04:01:16 -0700 (PDT)
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
In-Reply-To: <20220318131943.hc7z52beztqlzwfq@skbuf>
References: <86lex9hsg0.fsf@gmail.com> <YjNDgnrYaYfviNTi@lunn.ch>
 <20220317153625.2ld5zgtuhoxbcgvo@skbuf> <86ilscr2a4.fsf@gmail.com>
 <20220317161808.psftauoz5iaecduy@skbuf> <8635jg5xe5.fsf@gmail.com>
 <20220317172013.rhjvknre5w7mfmlo@skbuf> <86tubvk24r.fsf@gmail.com>
 <20220318121400.sdc4guu5m4auwoej@skbuf> <86pmmjieyl.fsf@gmail.com>
 <20220318131943.hc7z52beztqlzwfq@skbuf>
Date:   Tue, 22 Mar 2022 12:01:13 +0100
Message-ID: <86a6dixnd2.fsf@gmail.com>
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

On fre, mar 18, 2022 at 15:19, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Fri, Mar 18, 2022 at 02:10:26PM +0100, Hans Schultz wrote:
>> In the offloaded case there is no difference between static and dynamic
>> flags, which I see as a general issue. (The resulting ATU entry is static
>> in either case.)
>
> It _is_ a problem. We had the same problem with the is_local bit.
> Independently of this series, you can add the dynamic bit to struct
> switchdev_notifier_fdb_info and make drivers reject it.
>
>> These FDB entries are removed when link goes down (soft or hard). The
>> zero DPV entries that the new code introduces age out after 5 minutes,
>> while the locked flagged FDB entries are removed by link down (thus the
>> FDB and the ATU are not in sync in this case).
>
> Ok, so don't let them disappear from hardware, refresh them from the
> driver, since user space and the bridge driver expect that they are
> still there.

I have now tested with two extra unmanaged switches (each connected to a
seperate port on our managed switch, and when migrating from one port to
another, there is member violations, but as the initial entry ages out,
a new miss violation occurs and the new port adds the locked entry. In
this case I only see one locked entry, either on the initial port or
later on the port the host migrated to (via switch).

If I refresh the ATU entries indefinitly, then this migration will for
sure not work, and with the member violation suppressed, it will be
silent about it.

So I don't think it is a good idea to refresh the ATU entries
indefinitely.

Another issue I see, is that there is a deadlock or similar issue when
receiving violations and running 'bridge fdb show' (it seemed that
member violations also caused this, but not sure yet...), as the unit
freezes, not to return...
