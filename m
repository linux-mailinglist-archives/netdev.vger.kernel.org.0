Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC4C88206C
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 17:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbfHEPhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 11:37:52 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33558 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726508AbfHEPhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 11:37:51 -0400
Received: by mail-wm1-f67.google.com with SMTP id h19so6941386wme.0
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 08:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gRsgYUHBudFevX5r+ua05+FIbiFDZGlVLL58B2hcd1o=;
        b=jSo900+Vk/Jcr+b/5cAfdibWFXerywQgy6HdrNIWpfXyZFwlKHOJD3796UiSRkpcUC
         dErDdF6N91sP1fcyHlMeGC49WWOTuNEX3LMB8nhq7/uEYPzr1xCWnTQcz4vxYAHQZmdn
         r2Q/aEc7xvv/K/n7WAsnTbGrnw6vMdSHQjmedtcJ6qmgqFHvifgLIKUeVNnn2TQ551Zp
         Jh8zYysfRD8yV9XpQdWYWXgGARpHeB+lMkHg5GiQdu2bfURUuTWPfseXK4ZmjI/tGpgI
         eONxb9+1qHC+FyjEwzDUEHIFz1PIzKMh4X1YMxMa/MbXRSmsgzinA52BN40lJ7NRH8iD
         wVHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=gRsgYUHBudFevX5r+ua05+FIbiFDZGlVLL58B2hcd1o=;
        b=gUYBtEXJrMKCiETBeCBEnDtXcTq96qpD0tT6GKtxi3j96s/uE+05Xg7celNmbg1AIc
         FopuJ0LuBkbArKayeXmIq8R49Q79dB5lFGFVumLt6IKbbsnriviHN/12cSBRj2sAL69p
         W7Gy/94/8Ws0KqJ8FguyZzGvhUInT0HILOID7Nq3NHZoffQOTrQ+3HnSqKCPg3bu/90F
         F4DOsxnl4v4cLj7MwvSQniepPliaGNMrDB1u6y+tDiIBJSOoBA1ZlrPg+Z39C4eyytWW
         M+uk9PxfCAbTNXlIztuK2lIGN6tK/4+S6j6nZA6kUMt7N0MnjFrIKTAvbXVFanv3kkz6
         yoBA==
X-Gm-Message-State: APjAAAUwliOumruy04tLssFKGr7QpSsp2UjgIrWKG5N36O3rd8Owf8Qb
        Qjo8uljpbJJbsM4jynbxtmEIFxQNr1nZ8Q==
X-Google-Smtp-Source: APXvYqyKmkvsPrspmBKOl0A6u0vlQV0YuphNPeS/aAMwa16VA+4Fzu9P96NV0o/xdwT3YeAAohutnw==
X-Received: by 2002:a1c:3c04:: with SMTP id j4mr18088011wma.37.1565019469798;
        Mon, 05 Aug 2019 08:37:49 -0700 (PDT)
Received: from tycho.fritz.box ([188.192.146.8])
        by smtp.gmail.com with ESMTPSA id z5sm60816364wmf.48.2019.08.05.08.37.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 08:37:49 -0700 (PDT)
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, jhs@mojatatu.com, dsahern@gmail.com,
        simon.horman@netronome.com, makita.toshiaki@lab.ntt.co.jp,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, ast@plumgrid.com,
        johannes@sipsolutions.net,
        Zahari Doychev <zahari.doychev@linux.com>
Subject: [PATCH v2 0/1] Fix bridge mac_len handling
Date:   Mon,  5 Aug 2019 17:37:39 +0200
Message-Id: <20190805153740.29627-1-zahari.doychev@linux.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the last discussion about the possible solution of the problem. I have
decided to resend the patches making the discussed corrections. It seems that
the patches are still not the complete solution as there still can be problem
handling skb->data pointing after the VLAN tag but I got the impression that
all agreed that the bridge code should be able to handle mac_len correctly.

Here again the description how to problem can be reproduce.

The Linux bridge does not correctly forward double vlan tagged packets added
using the tc act_vlan action. I am using a bridge with two netdevs and on one
of them a have the clsact qdisc with tc flower rule adding two vlan tags.

ip link add name br0 type bridge vlan_filtering 1
ip link set dev br0 up

ip link set dev net0 up
ip link set dev net0 master br0

ip link set dev net1 up
ip link set dev net1 master br0

bridge vlan add dev net0 vid 100 master
bridge vlan add dev br0 vid 100 self
bridge vlan add dev net1 vid 100 master

tc qdisc add dev net0 handle ffff: clsact
tc qdisc add dev net1 handle ffff: clsact

tc filter add dev net0 ingress pref 1 protocol all flower \
		  action vlan push id 10 pipe action vlan push id 100

tc filter add dev net0 egress pref 1 protocol 802.1q flower \
		  vlan_id 100 vlan_ethtype 802.1q cvlan_id 10 \
		  action vlan pop pipe action vlan pop

When using the setup above the packets coming on net0 get double tagged but
the MAC headers gets corrupted when the packets go out of net1. The second vlan
header is not considered in br_dev_queue_push_xmit. The skb data pointer is
decremented only by the ETH_HLEN length. This later causes the function
validate_xmit_vlan to insert the outer vlan tag behind the inner vlan tag. 
The inner vlan becomes in this way part of the source mac address.

The problem in the bridge forwarding is fixed by using the mac_len when using
skb_push before forwarding the packets which ensures that the skb->data is
set correctly on push/pull.

Changes from v1:

- reset mac_len in br_dev_xmit 

Zahari Doychev (1):
  net: bridge: use mac_len in bridge forwarding

 net/bridge/br_device.c  | 3 ++-
 net/bridge/br_forward.c | 4 ++--
 net/bridge/br_vlan.c    | 3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

-- 
2.22.0

