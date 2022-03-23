Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB08E4E509B
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 11:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234464AbiCWKs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 06:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233371AbiCWKs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 06:48:28 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 887326E7A8;
        Wed, 23 Mar 2022 03:46:58 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id l20so1961294lfg.12;
        Wed, 23 Mar 2022 03:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=Pu11LzVwuByfb36IZDoOrF20LUpwOjWGCIQG1Ta8jIk=;
        b=Ntiazh9dgiTE4IwJgyUwQMnIG/ORs4kK1bZSFbSQydrSo/iK8bqJMWdRu/tsA3bDqG
         IoTMbmyQGQKSwc7re78cg6+wSgvrdWFZKBtGnE1ELpFS90Cxutl6ccSGIHp0OYvyqOuM
         d/BLjJwBQrtiqW4AFg99q/dh4ZEhJ5cJbdwIphqhcP4LGkjrgw5YMKVgnazbiLXpnf7E
         Joyliu8uqdz9KbVNSLnjKhtNvl5TCLXC2pyj449YPVK+J3D/ymqYNhR/wukKVYDsfsmS
         eaPCjYt4cZxsI8AiV6likmQID2ZhEISyR/JVfS/4s+cQnwyb+DJe3c+S8J5ZI9yIes4c
         exYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Pu11LzVwuByfb36IZDoOrF20LUpwOjWGCIQG1Ta8jIk=;
        b=2vV16y727oTUvTBbJtP8DAfNzMJplcNRLzipDjLIV2EqNNWGg9gtPjkDMH31WmSv/b
         9MPanzzjczwLWElqwPra41jP0JArxEtibvA2G3jdTLmdihESWIcx/+b0MuOHJRpdNtFp
         h6LeOtv0Zwl3z4Ier4eh6wxkX7F/N30y48Hik6WHd8UboPfkEsc/K7R9fxM8Qyem8Abs
         ktlOUUu9mKS0Huxuhd59DgivgT6ppSNuuXSsGXEuF05SR2afZRZ8hQpiDjKrfREEntdp
         s88iKH4+HPJMiXvbj+gqw0OQ6OFqx13234A8rjkrEJngyaF2LqNo9JZeaWYv93tjwVp8
         oQ9A==
X-Gm-Message-State: AOAM530ueGVjZ5rmYQT2KxKr7wNVepG8GH/LAuib9RuT5ouY6Q1y19SV
        AwJkkx3KuT3jzyyN/9J2v6A=
X-Google-Smtp-Source: ABdhPJwS+x43AwVdf/Sg4bgW4u+6IvcsrHVM8+aAaoQWmLJD4WKc4uQK5ia9Z5ZW/bb2U0c4Qv33gQ==
X-Received: by 2002:a05:6512:c23:b0:44a:2c00:1a08 with SMTP id z35-20020a0565120c2300b0044a2c001a08mr10346655lfu.468.1648032416918;
        Wed, 23 Mar 2022 03:46:56 -0700 (PDT)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id p12-20020a056512138c00b0044833f1cd85sm2495587lfa.62.2022.03.23.03.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 03:46:56 -0700 (PDT)
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
In-Reply-To: <20220323101643.kum3nuqctunakcfo@skbuf>
References: <20220317161808.psftauoz5iaecduy@skbuf>
 <8635jg5xe5.fsf@gmail.com> <20220317172013.rhjvknre5w7mfmlo@skbuf>
 <86tubvk24r.fsf@gmail.com> <20220318121400.sdc4guu5m4auwoej@skbuf>
 <86pmmjieyl.fsf@gmail.com> <20220318131943.hc7z52beztqlzwfq@skbuf>
 <86a6dixnd2.fsf@gmail.com> <20220322110806.kbdb362jf6pbtqaf@skbuf>
 <86fsn90ye8.fsf@gmail.com> <20220323101643.kum3nuqctunakcfo@skbuf>
Date:   Wed, 23 Mar 2022 11:46:53 +0100
Message-ID: <86h77px7xe.fsf@gmail.com>
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

On ons, mar 23, 2022 at 12:16, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Wed, Mar 23, 2022 at 11:13:51AM +0100, Hans Schultz wrote:
>> On tis, mar 22, 2022 at 13:08, Vladimir Oltean <olteanv@gmail.com> wrote:
>> > On Tue, Mar 22, 2022 at 12:01:13PM +0100, Hans Schultz wrote:
>> >> On fre, mar 18, 2022 at 15:19, Vladimir Oltean <olteanv@gmail.com> wrote:
>> >> > On Fri, Mar 18, 2022 at 02:10:26PM +0100, Hans Schultz wrote:
>> >> >> In the offloaded case there is no difference between static and dynamic
>> >> >> flags, which I see as a general issue. (The resulting ATU entry is static
>> >> >> in either case.)
>> >> >
>> >> > It _is_ a problem. We had the same problem with the is_local bit.
>> >> > Independently of this series, you can add the dynamic bit to struct
>> >> > switchdev_notifier_fdb_info and make drivers reject it.
>> >> >
>> >> >> These FDB entries are removed when link goes down (soft or hard). The
>> >> >> zero DPV entries that the new code introduces age out after 5 minutes,
>> >> >> while the locked flagged FDB entries are removed by link down (thus the
>> >> >> FDB and the ATU are not in sync in this case).
>> >> >
>> >> > Ok, so don't let them disappear from hardware, refresh them from the
>> >> > driver, since user space and the bridge driver expect that they are
>> >> > still there.
>> >> 
>> >> I have now tested with two extra unmanaged switches (each connected to a
>> >> seperate port on our managed switch, and when migrating from one port to
>> >> another, there is member violations, but as the initial entry ages out,
>> >> a new miss violation occurs and the new port adds the locked entry. In
>> >> this case I only see one locked entry, either on the initial port or
>> >> later on the port the host migrated to (via switch).
>> >> 
>> >> If I refresh the ATU entries indefinitly, then this migration will for
>> >> sure not work, and with the member violation suppressed, it will be
>> >> silent about it.
>> >
>> > Manual says that migrations should trigger miss violations if configured
>> > adequately, is this not the case?
>> >
>> >> So I don't think it is a good idea to refresh the ATU entries
>> >> indefinitely.
>> >> 
>> >> Another issue I see, is that there is a deadlock or similar issue when
>> >> receiving violations and running 'bridge fdb show' (it seemed that
>> >> member violations also caused this, but not sure yet...), as the unit
>> >> freezes, not to return...
>> >
>> > Have you enabled lockdep, debug atomic sleep, detect hung tasks, things
>> > like that?
>> 
>> I have now determined that it is the rtnl_lock() that causes the
>> "deadlock". The doit() in rtnetlink.c is under rtnl_lock() and is what
>> takes care of getting the fdb entries when running 'bridge fdb show'. In
>> principle there should be no problem with this, but I don't know if some
>> interrupt queue is getting jammed as they are blocked from rtnetlink.c?
>
> Sorry, I forgot to respond yesterday to this.
> By any chance do you maybe have an AB/BA lock inversion, where from the
> ATU interrupt handler you do mv88e6xxx_reg_lock() -> rtnl_lock(), while
> from the port_fdb_dump() handler you do rtnl_lock() -> mv88e6xxx_reg_lock()?

Yes, I forgot that the whole handler is under mv88e6xxx_reg_lock(). I
hope then that I can release the mv88e6xxx_reg_lock() before calling the
handler function with issues?
