Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D9A309856
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 21:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbhA3Urr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 15:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbhA3Urp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 15:47:45 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2915FC06174A
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 12:47:05 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id t8so14666441ljk.10
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 12:47:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:in-reply-to:references:date:message-id:mime-version;
        bh=HKVoS2rrydn4evqBfByv/fLsc4rWiOOxhn5xpMDPXuA=;
        b=YYeRX8uAMTy24PjmszEhE+U3nh9+PUkvfH5lFjYKPjLlKQi4Y7wPwMdSXr73v5nGhT
         w7Qpwvnys9VY3g2E87RIaOt3Myz2aBYmjUuHJV/h5UggQBIDXwxEK8ub8z07JR3+3om5
         FIf5Hpbw8zk+W5wiThS0kmC2WVUf95/yUFs0KWjmuPQg+LIryz9JbW0WltoaNcUk0+0Y
         O4rBaf6qEQSqYKagcRiBRdpHrV2bQLpst6Xl/+V0nlvjlQrdHsxEc/odK+wZIre0akpP
         9QAidkVDhgIVua6uj4N6r91NWRbdszuihXIqboOhJPffqMl+ymIGgmZLC48yhd5bBwB5
         h1PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=HKVoS2rrydn4evqBfByv/fLsc4rWiOOxhn5xpMDPXuA=;
        b=BM3fJupU6fkHxjkabLoeXo4LdMHb0/ARUChN3ZliOoXKYQXWGIAHTwVQq6/z83niZC
         +IX6wvhVwoZ5UK99S00nvsk9CPL3xYN79nwqC/K1aVaZoAsnIr50P3QsrBaZ6ftvwNXF
         nseuM3/KMuzCk1r5U0gUrexcpBJBU4iFp1qI5cpv2aLCwVOqmuIc31uMOiowBJJr1/bj
         yIf+SPxx8lVP90B8ugPENn2FlPdT8GTbrrernepSTWDB7FRtkW2Z9KdNVV4gl5lAR+aF
         dE3qhMTYCRKvAFcMGNx8Fr9mqZnV6Rw6YSEKg4rl4/3wx5YYByPOlhJ1pTd8j9D0zbAx
         gD7Q==
X-Gm-Message-State: AOAM532hIPrVO1YTmNUmwZDcoZRJjNNNd+goxa04Ei3LRSX7QMLqyvf7
        YTyCILHJjAJCwDs9imeKnUlEhg==
X-Google-Smtp-Source: ABdhPJyBffwdVBDn7wJB1j+Q9tDxTRJch4YacsEqxY56NHI4ZHWYhR9QsgZwnQUW854ywKZiTYtzyA==
X-Received: by 2002:a2e:7812:: with SMTP id t18mr2128221ljc.168.1612039623579;
        Sat, 30 Jan 2021 12:47:03 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id t7sm3088951ljc.87.2021.01.30.12.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jan 2021 12:47:02 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: override existent unicast portvec in port_fdb_add
In-Reply-To: <20210130134334.10243-1-dqfext@gmail.com>
References: <20210130134334.10243-1-dqfext@gmail.com>
Date:   Sat, 30 Jan 2021 21:47:02 +0100
Message-ID: <87eei25f09.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 30, 2021 at 21:43, DENG Qingfang <dqfext@gmail.com> wrote:
> Having multiple destination ports for a unicast address does not make
> sense.
> Make port_db_load_purge override existent unicast portvec instead of
> adding a new port bit.

Is this the layer we want to solve this problem at? What are the
contents of the software FDB at this stage?

Here is a quick example I tried on one of my systems:

root@envoy:~# bridge fdb add 02:00:de:ad:00:01 dev eth1 static vlan 1
root@envoy:~# bridge fdb add 02:00:de:ad:00:01 dev eth2 static vlan 1
root@envoy:~# bridge fdb | grep de:ad
02:00:de:ad:00:01 dev eth2 vlan 1 self static
02:00:de:ad:00:01 dev eth1 vlan 1 self static

Why does the second add operation succeed? Am I missing some magic flag?
Presumably the bridge will only ever forward packets to which ever entry
ends up being first in the relevant hash list. Is that not the real
problem here?

As it stands today, those commands will result in the following ATU
config (eth1/2 being mapped to port 10/9):

root@envoy:~# mvls atu
ADDRESS             FID  STATE      Q  F  0  1  2  3  4  5  6  7  8  9  a
ff:ff:ff:ff:ff:ff     0  static     -  -  0  1  2  3  4  5  6  7  8  9  a
02:00:de:ad:00:01     1  static     -  -  .  .  .  .  .  .  .  .  .  9  a
ff:ff:ff:ff:ff:ff     1  static     -  -  0  1  2  3  4  5  6  7  8  9  a

One might argue that this is no more wrong than what would have been set
up with this patch applied. The problem is that the bridge allows this
configuration in the first place.
