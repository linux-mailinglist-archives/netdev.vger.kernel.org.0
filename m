Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A21D4E8F25
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 09:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238869AbiC1HkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 03:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbiC1HkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 03:40:19 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29879434AA;
        Mon, 28 Mar 2022 00:38:38 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id i4so205404wrb.5;
        Mon, 28 Mar 2022 00:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=ZGgY4ugwWH/2hsjBN3Oyi9qQcKXFArqdIzAWmPvr9nI=;
        b=GCOuo35vnRS7u5Ydo1MREMDiIjABMrAhyb/kARxBn3RT5X+NvQ34pvRoTsgxJxcTDC
         pN2ve8Xa+yXdNt22LGrUxARo/2cRBIxcJyJEdIsgEYrclDTm6eLSoY+mFkIvHzOsDQn2
         H9fu4dTDTnRGce3wQcX9LnFRk7vaZoAQQ4CjoJI6wWqhxepDCto93XzPvZ6u4Oj0aKOT
         Yd1tmxrnC52QeGCFnZWmAfPfx7UpxCGbBrtGe7FhtlsPkax4RAubPCtYnIvnjvY7QLwI
         W0IbN8Ig3qECdSCT2BWWJ7bHCL4tjhU8ghLwQUK98ZXyS2gFHc6THKwaEEL6h0hB3LMW
         diwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ZGgY4ugwWH/2hsjBN3Oyi9qQcKXFArqdIzAWmPvr9nI=;
        b=3+S8D96Q8exorLFjbu9dl1LFUlEvOTMyDFAu6A+OWxnKaMXzJ89UQ0KDLyNauRAu+B
         dwWkGPzrNeugDqFYNd99EEysi/qQS5cwFI2cyxPdM17L/Asg5Q7OeowsHdCFoKrsWSGT
         lgzTR8NC+7/poizJtRsOhBZBLVEqWomQiAhYckRfiZCk/x/xeJyCa8mWlh+8Yz6Xz7sS
         oPhRDphaNztLz/esrMoPL4eO6d4nsX5VP6S4CEQCWYTJxWYQ2JDIZWW2TG1qLSsp2B9+
         dmwuUh8s0ggbxdOmDNvkvzDNXYWQJlSoFrkntSefVMsUeo6qNgcdKJZSubTA41EVZ/yC
         zcTA==
X-Gm-Message-State: AOAM532ied5IYzIy6qpir2/tNnb36HvuGabz0TdNmUFf4VuQwdxbOOh+
        3KbahQj/tEjec6py5hYfJGqq6NDU/R0=
X-Google-Smtp-Source: ABdhPJzGvphoXH2utUv2XMoaCJgzDmSCXjq8T3Jq51P+jmVpWm4mJE3i0TNctPzeecybvsH/sbKbJw==
X-Received: by 2002:a5d:5849:0:b0:205:85cb:baaf with SMTP id i9-20020a5d5849000000b0020585cbbaafmr21879767wrf.442.1648453116632;
        Mon, 28 Mar 2022 00:38:36 -0700 (PDT)
Received: from wse-c0127 (2-104-116-184-cable.dk.customer.tdc.net. [2.104.116.184])
        by smtp.gmail.com with ESMTPSA id p8-20020a5d59a8000000b00204178688d3sm12622464wrr.100.2022.03.28.00.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 00:38:35 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/4] net: switchdev: add support for
 offloading of fdb locked flag
In-Reply-To: <20220325203057.vrw5nbwqctluc6u3@skbuf>
References: <20220323144304.4uqst3hapvzg3ej6@skbuf>
 <86lewzej4n.fsf@gmail.com> <20220324110959.t4hqale35qbrakdu@skbuf>
 <86v8w3vbk4.fsf@gmail.com> <20220324142749.la5til4ys6zva4uf@skbuf>
 <86czia1ned.fsf@gmail.com> <20220325132102.bss26plrk4sifby2@skbuf>
 <86fsn6uoqz.fsf@gmail.com> <20220325140003.a4w4hysqbzmrcxbq@skbuf>
 <86tubmt408.fsf@gmail.com> <20220325203057.vrw5nbwqctluc6u3@skbuf>
Date:   Mon, 28 Mar 2022 09:38:33 +0200
Message-ID: <86ee2m8r2e.fsf@gmail.com>
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

On fre, mar 25, 2022 at 22:30, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Fri, Mar 25, 2022 at 05:01:59PM +0100, Hans Schultz wrote:
>> > An attacker sweeping through the 2^47 source MAC address range is a
>> > problem regardless of the implementations proposed so far, no?
>> 
>> The idea is to have a count on the number of locked entries in both the
>> ATU and the FDB, so that a limit on entries can be enforced.
>
> I can agree with that.
>
> Note that as far as I understand regular 802.1X, these locked FDB
> entries are just bloatware if you don't need MAC authentication bypass,
> because the source port is already locked, so it drops all traffic from
> an unknown MAC SA except for the link-local packets necessary to run
> EAPOL, which are trapped to the CPU.

802.1X and MAC Auth can be completely seperated by hostapd listning
directly on the locked port interface before entering the bridge.

>
> So maybe user space should opt into the MAC authentication bypass
> process, really, since that requires secure CPU-assisted learning, and
> regular 802.1X doesn't. It's a real additional burden that shouldn't be
> ignored or enabled by default.
>
>> > If unlimited growth of the mv88e6xxx locked ATU entry cache is a
>> > concern (which it is), we could limit its size, and when we purge a
>> > cached entry in software is also when we could emit a
>> > SWITCHDEV_FDB_DEL_TO_BRIDGE for it, right?
>> 
>> I think the best would be dynamic entries in both the ATU and the FDB
>> for locked entries.
>
> Making locked (DPV=0) ATU entries be dynamic (age out) makes sense.
> Since you set the IgnoreWrongData for source ports, you suppress ATU
> interrupts for this MAC SA, which in turn means that a station which is
> unauthorized on port A can never redeem itself when it migrates to port B,
> for which it does have an authorization, since software never receives
> any notice that it has moved to a new port.
>
> But making the locked bridge FDB entry be dynamic, why does it matter?
> I'm not seeing this through. To denote that it can migrate, or to denote
> that it can age out? These locked FDB entries are 'extern_learn', so
> they aren't aged out by the bridge anyway, they are aged out by whomever
> added them => in our case the SWITCHDEV_FDB_DEL_TO_BRIDGE that I mentioned.
>
I think the FDB and the ATU should be as much in sync as possible, and
the FDB definitely should not keep stale entries that only get removed
by link down. The SWITCHDEV_FDB_DEL_TO_BRIDGE route would requre an
interrupt when a entry ages out in the ATU, but we know that that cannot
happen with DPV=0. Thus the need to add dynamic entries with
SWITCHDEV_FDB_ADD_TO_BRIDGE. 

>> How the two are kept in sync is another question, but if there is a
>> switchcore, it will be the 'master', so I don't think the bridge
>> module will need to tell the switchcore to remove entries in that
>> case. Or?
>
> The bridge will certainly not *need* to tell the switch to delete a
> locked FDB entry, but it certainly *can* (and this is in fact part of
> the authorization process, replace an ATU entry with DPV=0 with an ATU
> entry with DPV=BIT(port)).

Yes you are right, but I was implicitly only regarding internal
mechanisms in the 'bridge + switchcore', and not userspace netlink
commands.
>
> I feel as if I'm missing the essence of your reply.
