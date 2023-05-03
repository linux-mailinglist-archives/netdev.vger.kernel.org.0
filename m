Return-Path: <netdev+bounces-179-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ACC556F5A8B
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 17:01:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A03301C20F4B
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 15:01:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 315E11079B;
	Wed,  3 May 2023 15:01:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218AED2F7
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 15:01:18 +0000 (UTC)
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CC34C15
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 08:01:16 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-4ec8148f73eso6093552e87.1
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 08:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683126074; x=1685718074;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fK0OPnkXTYVAUq9QF8eFZRUg9LL1NgiwHML277Y1qrw=;
        b=lYhb6tl3t+m1bhSZPU67u4Ft1VLme/jdl14vYQxNa9ntQBz3wyZy9ohyT79mM+sdAm
         +pAb+s5P6CH1jF1MQuwTX4otD5P/5bDvhf1qBsH6MRFlOAKY0REJ+nUiYJJgaq572bCE
         VhMo7yvDdA+NAYZYykPh3qkD+dNoxSZortUIVt3+uxzPPQJLhuPgKeKLQlltUi+AfAiM
         01lLVrUXnoFlhRLjdUIDo66A+f9wwPvU6VILzl8RW2D34FemjQWqoNHudSE6esLgxON0
         aF2fyh1zl4PXi7weEuy3H9BKJrqHN1ojdGS3cFklQRqnQUxdvgnzo9sk3k9Bn9xLqo6F
         CKAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683126074; x=1685718074;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fK0OPnkXTYVAUq9QF8eFZRUg9LL1NgiwHML277Y1qrw=;
        b=kwZSQ6leA6zNFZ/AWTLZ3TUBMFWA7JGhTpZb66BVzU1PYoCCbShRav/BFyjUcSqbf7
         0SKncd8DA5wr4IPrWobVw5KNKFy4SHalXKGQbsCQa6HOCc2vgX3d/f1NPqMtsYidhcAs
         sQ/T38eXZcj4bzSd3lT0S4Sc1IgM4R6ZIlTqJi+7d4wMvzUuHmUl5DZBo+z+dC3lIZfX
         ZS+N++u1qGIFTfL9Ae3QETHRJFl2HthgNcT6jWqx+5UPXXVAgg+P8BU6A0fADCdatxz/
         a2Tj7H86mYKfR6bONPNVweKojHiaWpKJlGgkJzQKjMdO5q3n+JNtKj5mLl8JeRgkJNHP
         aenA==
X-Gm-Message-State: AC+VfDwMDCrcTNumaFqoKont+LkrAqlgYcjJ6d4VdvdV2Dk0uxh3DVAE
	AK3GW5grHGwr65mF8w3E+bN/awsm8kMgQWt+GTObnfsiYDg=
X-Google-Smtp-Source: ACHHUZ7XitQIBNH+Jti9W4VpBwjfLnPbGU/mK5yYFEBXEbEPgi8Pqs39gjL6y/mpKWnPITt3LBludtoF+DS3kFE2nWg=
X-Received: by 2002:ac2:4943:0:b0:4f0:1149:c875 with SMTP id
 o3-20020ac24943000000b004f01149c875mr977692lfi.31.1683126074097; Wed, 03 May
 2023 08:01:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Aleksey Shumnik <ashumnik9@gmail.com>
Date: Wed, 3 May 2023 18:01:03 +0300
Message-ID: <CAJGXZLjLXrUzz4S9C7SqeyszMMyjR6RRu52y1fyh_d6gRqFHdA@mail.gmail.com>
Subject: [BUG] Dependence of routing cache entries on the ignore-df flag
To: netdev@vger.kernel.org, waltje@uwalt.nl.mugnet.org, 
	Jakub Kicinski <kuba@kernel.org>, gw4pts@gw4pts.ampr.org, kuznet@ms2.inr.ac.ru, 
	"willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>, gnault@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Dear maintainers,

I found such a dependency, if the ignore-df flag is set on the
interface, then entries appear in the routing cache.
You can reproduce it as follows:

# cat /etc/network/interfaces.d/mgre0
auto mgre0
iface mgre0 inet static
address 10.10.10.1
netmask 255.255.255.0
pre-up ip tunnel add mgre0 mode gre key 1 ttl 64 tos inherit
pre-up ethtool -K mgre0 tx off > /dev/null
pre-up ip link set mgre0 mtu 1400
pre-up ip link set mgre0 multicast on
pre-up ip link set mgre0 type gre nopmtudisc
pre-up ip link set mgre0 type gre ignore-df
post-down ip link del mgre0

# ifup mgre0
# ip link set mgre0 arp on
# ip neigh add 10.10.10.2 dev mgre0 lladdr <some ipv4 addr>
# ping 10.10.10.2
# ip route show cache
10.10.10.2 dev mgre0
    cache expires 598sec mtu 1400

Creating mgre interface using the following config. Set arp on (this
is necessary).
Add an entry to the neighbor table for arp routing, specify the
address from the same subnet as the address on the mgre interface.
Ping this address. After that, an entry is added to the routing cache.
It seems that after it was not possible to find a suitable entry in
the routing table for the address 10.10.10.2, before looking at the
arp table, an entry is added to the routing cache.

But the most incomprehensible thing for me is if you remove the
ignore-df flag, restart (ifdown, ifup) the interface, then the problem
is not observed, that is, entries are not added to the routing cache.
The answer to the question of how the ignore-df flag  and adding
entries to the routing cache is connected, I have not found.

On the one hand, the routing cache has not been supported in linux for
a long time, and there should not be such entries. On the other hand,
when some services are started, they request the routing table via
netlink and the kernel responds by sending not only the entries of the
main routing table, but also the routing cache.
As a result, incorrect routing entries with 0.0.0.0 nexthop address
appear in the peer list of these services.
Of course, it's not difficult to fix it in the services themselves,
but it seems to me that this will be a correction of the consequences
of the problem, and not the cause itself. It seems to me that this is
the wrong behavior.

Might you answer the questions:
1. How the ignore-df flag and adding entries to the routing cache is
connected? In which kernel files may I look to find this connection?
2. Is this behavior wrong?
3. Is there any way to completely disable the use of the routing
cache? (as far as I understand, it used to be possible to set the
rhash_entries parameter to 0, but now there is no such parameter)
4. Why is an entry added to the routing cache if a suitable entry was
eventually found in the arp table (it is added directly, without being
temporarily added to the routing table)?


Regards,
Aleksey

