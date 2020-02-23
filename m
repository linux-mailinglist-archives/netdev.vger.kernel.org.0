Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E31C41698B3
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 17:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgBWQz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 11:55:26 -0500
Received: from bonobo.elm.relay.mailchannels.net ([23.83.212.22]:48376 "EHLO
        bonobo.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726208AbgBWQz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 11:55:26 -0500
X-Sender-Id: dreamhost|x-authsender|craig@zhatt.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id AEFEC920916
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 16:47:18 +0000 (UTC)
Received: from pdx1-sub0-mail-a55.g.dreamhost.com (100-96-0-13.trex.outbound.svc.cluster.local [100.96.0.13])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 3668092086C
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 16:47:18 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|craig@zhatt.com
Received: from pdx1-sub0-mail-a55.g.dreamhost.com ([TEMPUNAVAIL].
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.18.5);
        Sun, 23 Feb 2020 16:47:18 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|craig@zhatt.com
X-MailChannels-Auth-Id: dreamhost
X-Minister-Rock: 27c9d99b4f8773c8_1582476438427_4271670727
X-MC-Loop-Signature: 1582476438426:2483662335
X-MC-Ingress-Time: 1582476438426
Received: from pdx1-sub0-mail-a55.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a55.g.dreamhost.com (Postfix) with ESMTP id 57912801C6
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 08:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zhatt.com; h=mime-version
        :from:date:message-id:subject:to:content-type; s=zhatt.com; bh=o
        koi4AQnz/oDtL/v/NUc0WVr7zw=; b=hlEYjIUFc7gmFGydUHb6s/tCLPy++8f16
        /aMqe/Z2wO+RdyIb8Ymq38l0fjNEPb8NCKuSEHaK20tBlfwAypNm7Gji3YleFpCi
        VaX3uEOO5CX4DfKFi8y49EI20lFWnE+S03jkC7bdVZlLmLwlT+OtNTFFaHbP76TF
        9mlGrbfPfw=
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: craig@zhatt.com)
        by pdx1-sub0-mail-a55.g.dreamhost.com (Postfix) with ESMTPSA id 0C6397F603
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 08:47:13 -0800 (PST)
Received: by mail-wm1-f45.google.com with SMTP id q9so6644367wmj.5
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 08:47:13 -0800 (PST)
X-Gm-Message-State: APjAAAVy3YpwJ+OrOyvzCLBCenv7u3j7JNw/SBFdUa2+szLi2HhiwbOD
        KU7sayn8JeA4sd8EDs7EHEkOX0EuI5XALKOK2Sg=
X-Google-Smtp-Source: APXvYqyYSfzDLjwIUrqhkXcfgKZQLID7gfPXRw8B4x1ycU2wzUQ7no/mNAzOv92LpjZMuoy4Md5Hh53d8y+iOI3lh0I=
X-Received: by 2002:a05:600c:22d3:: with SMTP id 19mr17481732wmg.92.1582476432312;
 Sun, 23 Feb 2020 08:47:12 -0800 (PST)
MIME-Version: 1.0
X-DH-BACKEND: pdx1-sub0-mail-a55
From:   Craig Robson <craig@zhatt.com>
Date:   Sun, 23 Feb 2020 08:46:56 -0800
X-Gmail-Original-Message-ID: <CAK0T-BKRWOLR8h7uaFV6pYfkYcG8qb0CrzLXSvcpNWafWcA_dg@mail.gmail.com>
Message-ID: <CAK0T-BKRWOLR8h7uaFV6pYfkYcG8qb0CrzLXSvcpNWafWcA_dg@mail.gmail.com>
Subject: Subject: [PATCH net-next] bonding: Fix hashing byte order
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 0
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedugedrkeekgdelfecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecunecujfgurhepggfhfffkuffvtgesthdtredttddtjeenucfhrhhomhepvehrrghighcutfhosghsohhnuceotghrrghighesiihhrghtthdrtghomheqnecukfhppedvtdelrdekhedruddvkedrgeehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhppdhhvghlohepmhgrihhlqdifmhduqdhfgeehrdhgohhoghhlvgdrtghomhdpihhnvghtpedvtdelrdekhedruddvkedrgeehpdhrvghtuhhrnhdqphgrthhhpeevrhgrihhgucftohgsshhonhcuoegtrhgrihhgseiihhgrthhtrdgtohhmqedpmhgrihhlfhhrohhmpegtrhgrihhgseiihhgrthhtrdgtohhmpdhnrhgtphhtthhopehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change to use host order bytes when hashing IP address.
---
 drivers/net/bonding/bond_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index fef599eb822b..6f9a0758c54f 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3274,8 +3274,8 @@ u32 bond_xmit_hash(struct bonding *bond, struct
sk_buff *skb)
                hash = bond_eth_hash(skb);
        else
                hash = (__force u32)flow.ports.ports;
-       hash ^= (__force u32)flow_get_u32_dst(&flow) ^
-               (__force u32)flow_get_u32_src(&flow);
+       hash ^= ntohl((__force u32)flow_get_u32_dst(&flow)) ^
+               ntohl((__force u32)flow_get_u32_src(&flow));
        hash ^= (hash >> 16);
        hash ^= (hash >> 8);

-- 
2.24.1
