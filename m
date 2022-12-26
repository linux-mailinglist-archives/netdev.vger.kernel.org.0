Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2E9F656289
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 13:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiLZM1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 07:27:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiLZM1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 07:27:12 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94213110D
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 04:27:11 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id h6so5589508iof.9
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 04:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fB4g2vcur5YFb2ggicxgn/EklvxqZxIPloWShYBYzog=;
        b=QN4ecyfAIiveA3YUPjugr4QaoNbjoHS8W7UcNaHE9d8hIlOWQvyVVA6GVslS6f21DK
         PXTg4g4lWPmUCuqSuZmn3RBMlM6wLpFTcSdeNiQ6u719RGRppis8OQ0XuCX/wcIEiAYt
         UMzpK+QwzF6luEUJirRZAXQb82IqjDnDyQBcr2PH7s2Bup4Q+oZFswFjX9LnlxXA7csX
         gnt+7ktXVfHHVZTXXiGyU9fdrVKKHmp1yR8jPqiWAjJ2DYeGHgBdAhtr+wu5aTB1U79l
         tZrZEwRetMx8nFC9q0CcNmDntlWp5Rwpy6AGWl2kn0WpMrrIsf+VqUTYPvd+jbjxQN7a
         2IdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fB4g2vcur5YFb2ggicxgn/EklvxqZxIPloWShYBYzog=;
        b=C/gaXmib9Xn/8rd/8v8G6B4pRDsTeZ4s4XWarolNQVYp9XpkiBb4KNCVxOKOK7Wr+t
         ZeL0qqU9920iAqYJwYHFKEW+6Bdp/Qrbz7KAZ6fZw/BNuBAusLiXTkavboc/cke0uaOj
         dC3051Sq6akh7CkcS+Qlqc78cB6GgJPUn5wWesbaQGhcjvkdMgzHhAcAUFpv+OPburQo
         ZR5OKcHZk64tRX1M6m1CEaHmLLv3YGlIRrmg02DHJ02fddbnWgxTtVo5abrII6sFKTGa
         hZ4bZKwKCPEhc6owdGKVUMDG6KLunPGNEL/z1e1pzQHWRZuEMfxxaQYAobRhJz76x/q2
         oI+Q==
X-Gm-Message-State: AFqh2kr2xzWJVZhXPgvurXOxaWao9HoAOWjqo4yvUw5T2V0OOBJssUml
        +of6alGZOcrnT/dLf7VDJMuoHmYW4PXkcpCymhaoQDy6hYFBWJg9
X-Google-Smtp-Source: AMrXdXtolPt+hsLiDxprLIL710rvWie8UHsOBkQa7FvKQSukLQqZBs8/lSsH/IMrnjNjr+SJeSmzIVo7JlggLRapCik=
X-Received: by 2002:a5d:9955:0:b0:6bb:b955:185e with SMTP id
 v21-20020a5d9955000000b006bbb955185emr1454288ios.22.1672057630317; Mon, 26
 Dec 2022 04:27:10 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Mon, 26 Dec 2022 04:26:56 -0800
Message-ID: <CANP3RGc15v262aev2ZSo3PG9dOmKiJ0-57XjKiOmO29dbt94=w@mail.gmail.com>
Subject: A linux route cache (flush) irregularity...
To:     Linux NetDev <netdev@vger.kernel.org>
Cc:     Jean Chalard <jchalard@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I can't seem to explain the following...
without there being some part/aspect of the route cache that 'ip route
flush cached' doesn't actually flush...
(ping output below slightly trimmed to make this log shorter)

This is on a 5.19.11-1rodete1-amd64 debian (or ubuntu?) based gLinux
kernel (I don't *think* there's any special gLinux hacks in it that
would be relevant though)
on a laptop connected via wifi to a cellular hotspot with 1460 mtu
path to the internet.

# ip route flush cached
# ip route show cached

# ping -c 1 -s $[1500-28] 8.8.8.8
From 10.0.0.200 icmp_seq=1 Frag needed and DF set (mtu = 1460)

# ip route show cached
8.8.8.8 via 10.0.0.200 dev wlp0s20f3
    cache expires 86396sec mtu 1460

# ping -c 1 -s $[1460-28] 8.8.8.8
76 bytes from 8.8.8.8: icmp_seq=1 ttl=113 (truncated)

# ip route show cached
8.8.8.8 via 10.0.0.200 dev wlp0s20f3
    cache expires 86390sec mtu 1460

# ping -c 1 -s $[1460-28] 1.1.1.1
1440 bytes from 1.1.1.1: icmp_seq=1 ttl=53 time=39.0 ms

# ip route show cached
8.8.8.8 via 10.0.0.200 dev wlp0s20f3
    cache expires 86381sec mtu 1460

# ip route flush cached
# ip route show cached

# ping -c 1 1.1.1.1
64 bytes from 1.1.1.1: icmp_seq=1 ttl=53 time=26.9 ms

# ping -c 1 8.8.8.8
64 bytes from 8.8.8.8: icmp_seq=1 ttl=113 time=50.0 ms

# ip route show cached
8.8.8.8 via 10.0.0.200 dev wlp0s20f3
    cache

Up until this spot I could explain everything, but why is there now an
entry for 8.8.8.8 but not 1.1.1.1?

The only explanation I can think of is that *some* part of the route
cache has actually remembered that a per-ip override for 8.8.8.8 needs
to be generated, but not for 1.1.1.1...

No, this doesn't really matter, but I'm the curious sort...
[side note: it also appears that 'ip route flush cached' and/or 'ip
route show cached' might be asynchronous...]

- Maciej
