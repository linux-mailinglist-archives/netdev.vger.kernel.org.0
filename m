Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E27895776EB
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 17:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbiGQPI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 11:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiGQPI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 11:08:27 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2ED13CF3;
        Sun, 17 Jul 2022 08:08:26 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id m13so2072723edc.5;
        Sun, 17 Jul 2022 08:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hMG19jnX3PRCbXZ+on0hHKlUdqbr9JhdKfsdJnBO8LI=;
        b=XtRmz+aAA92yKbmzuHPW3+DHixLtci04vqzmWpp+cD5JXHKeheq9k0sZHk2ikywuVm
         Ya+X1fi6i6DrekCrRvklz9kah/1l+vUSVxc3/+Mo/b6k5YPNZ+eK3YL+647np6c9eBFP
         cO9KIo5RMa0ByDF+dwwXR4eyh8YRzFEzuatHQcbyx+ujWJ+4vGcFvAucRKmCNEWoeX4u
         ThpQlP0hiaeXV53bOTqWltSSKxzTd6zlQxDZCwQuyEK1/Adg0B2cQW9bbz9ObD62iE7U
         UoYgFTCDsjR1xYb042K9W2yv6zWdzbtgpK2vAbtId8LPh9ThtgW26QkbNbfRzBBH4Lgd
         xVxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hMG19jnX3PRCbXZ+on0hHKlUdqbr9JhdKfsdJnBO8LI=;
        b=lScCJPaqaYGE2wpRNPrcw+T863O+5lXlFlICDGBwsLCyDeSnV/vNpGUd1VtxP2zzZN
         fcaXIxP4r0Udicj8UB5J/kQ1OhsQqQ6i23w3woCFckq5k8YnrMu60v39zUse2JTJpV8N
         45bmQIyrNbMtqYih5gUp3JhlbT9oxr1NBJgTBuMiehSA1lb7fN9tmzzhWBIgj2woxl6A
         gWHV+roZ5yqP4TLFfx3VCgeDv+FhG4x3sNo+mv0vGVntprEJ13GcwMK7mvEbgTnsZsKg
         poWpTg/PLWxwPGOFyz2jHOTXfNDzEgYJvc1Pe4hmVpm/bi3qY+Buo1FobwCcGBkbG9pU
         7LbA==
X-Gm-Message-State: AJIora+fKtX/JanxU2EmWxo+RhXS8IMZWEvX2eLPqm3n8grZ66kuU6QF
        V8xuf9DSO7BIxVPqGijGfFw=
X-Google-Smtp-Source: AGRyM1vK5tMCFy4TTvk3ikk733WBr21RKIX8TZhTP+OIvOFvf3jJSDEYmgj2i91/pvFuoROXMSy8Gw==
X-Received: by 2002:a05:6402:4504:b0:43b:4ec7:2ec1 with SMTP id ez4-20020a056402450400b0043b4ec72ec1mr11287321edb.7.1658070504655;
        Sun, 17 Jul 2022 08:08:24 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id d2-20020a056402000200b0043a61f6c389sm6832967edu.4.2022.07.17.08.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 08:08:23 -0700 (PDT)
Date:   Sun, 17 Jul 2022 18:08:21 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     Ido Schimmel <idosch@nvidia.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/6] drivers: net: dsa: add locked fdb entry
 flag to drivers
Message-ID: <20220717150821.ehgtbnh6kmcbmx6u@skbuf>
References: <20220708115624.rrjzjtidlhcqczjv@skbuf>
 <723e2995314b41ff323272536ef27341@kapio-technology.com>
 <YsqPWK67U0+Iw2Ru@shredder>
 <d3f674dc6b4f92f2fda3601685c78ced@kapio-technology.com>
 <Ys69DiAwT0Md+6ai@shredder>
 <648ba6718813bf76e7b973150b73f028@kapio-technology.com>
 <20220717125718.mj7b3j3jmltu6gm5@skbuf>
 <a6ec816279b282a4ea72252a7400d5b3@kapio-technology.com>
 <20220717135951.ho4raw3bzwlgixpb@skbuf>
 <e1c1e7c114f0226b116d9549cea8e7a9@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1c1e7c114f0226b116d9549cea8e7a9@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 17, 2022 at 04:57:50PM +0200, netdev@kapio-technology.com wrote:
> 
> Maybe I am just trying to understand the problem you are posing, so afaics
> MAC addresses should be unique and having the same MAC address behind a
> locked port and a not-locked port seems like a mis-configuration regardless
> of vlan setup? As the zero-DPV entry only blocks the specific SA MAC on a
> specific vlan, which is behind a locked port, there shouldn't be any
> problem...?
> 
> If the host behind a locked port starts sending on another vlan than where
> it got the first locked entry, another locked entry will occur, as the
> locked entries are MAC + vlan.

I don't think it's an invalid configuration, I have a 17-port Marvell
switch which I use as infrastructure to connect my PC with my board farm
and to the Internet. I've cropped 4 out of those 17 ports for use in
selftests, effectively now having 2 bridges (br0 used by the selftests
and br-lan for systemd-networkd).

Currently all the traffic sent and received by the selftests is done
through lan1-lan4, but if I wanted to run some bridge locked port tests
with traffic from my PC, what I'd do is I'd connect a (locked) port from br0
to a port from br-lan, and my PC would thus gain indirect connectivity to the
locked port.

Then I'd send a packet and the switch would create a locked FDB entry
for my PC's MAC address, but that FDB entry would span across the entire
MV88E6XXX_FID_BRIDGED, so practically speaking, it would block my PC's
MAC address from doing anything, including accessing the Internet, i.e.
traffic that has nothing at all to do with the locked port in br0.
That isn't quite ok.
