Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE72722D02B
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 23:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgGXVDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 17:03:34 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31028 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726591AbgGXVDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 17:03:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595624612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=mz9JALUb1Eq/OpIWOhI+hSok+N0F8JBO8OI958mC2F0=;
        b=Gntzk7e1spzw+bzC7Hefs8e/rfxapVx/jPXX+QojDXOTK49EkXtVl2WD8/x2CoUMggXdF6
        h1FsLXQ3Olyo5Fiz9/FFJ4Wtf2/w49+BYCl0cS+Sp/MQwkaAHku9X6oEPhwrp7CL+SmkoH
        XhqabnqhFeacgu6z30nh9vbJFwDbK5s=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-2HXT0kdkPyiY-JuoyuKI5A-1; Fri, 24 Jul 2020 17:03:31 -0400
X-MC-Unique: 2HXT0kdkPyiY-JuoyuKI5A-1
Received: by mail-wr1-f72.google.com with SMTP id h4so2446732wrh.10
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 14:03:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=mz9JALUb1Eq/OpIWOhI+hSok+N0F8JBO8OI958mC2F0=;
        b=ZNoiXfwPqbPJj/0XvJV3tyKWrU7PM4ddZ3wySwgc9TkGDf8vLrnt2JGhiw8A81m9ZG
         qO9j7Sn9R+O7GMpLIBZuAD45/fvBAUxn5hr35J1+htb8BnEh7qli+C8nhhzMeA5BcPTz
         t5IG4wUlQmggQHjC1Ik8Z1DfmuRldprsnChLbgZpTKVvFvxVNBilKsu3875GQLcC4Sqw
         GoT8L2pl6upe5qPzZM8lcaPgbalFXUyC1hIAbf5nqM/XFO8g2Pi2D2saNE0kyauDeFCg
         Ncjow5LVVfDYIj7/sNOKg2eSPVWRSM4gSkhGSmkMTdwJk4SL69keGNa8AgdXTmtFsgof
         FCEA==
X-Gm-Message-State: AOAM533B9KtY+nIJzv9scZheeqKdHgFDQuid22crOjMcvcRz/K1YWJkQ
        k0bTbd4yHqyjHTWUe5bZ1qkHngZ/xi2sfUb7wb/gQn2wMypS31DiMDPLW5pmrMwK9j3QNHFRste
        +gBzcxua0u54QkbRI
X-Received: by 2002:a7b:cbd0:: with SMTP id n16mr7446087wmi.123.1595624609927;
        Fri, 24 Jul 2020 14:03:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzXncqslqFYJcjJp3xLZ0dpj2rRxKMBdleqNd2aVAPXwTieAxUePJCaFOyCda87dYpDe4qA2Q==
X-Received: by 2002:a7b:cbd0:: with SMTP id n16mr7446061wmi.123.1595624609455;
        Fri, 24 Jul 2020 14:03:29 -0700 (PDT)
Received: from pc-2.home (2a01cb058529bf0075b0798a7f5975cb.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:bf00:75b0:798a:7f59:75cb])
        by smtp.gmail.com with ESMTPSA id t202sm8487273wmt.20.2020.07.24.14.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 14:03:28 -0700 (PDT)
Date:   Fri, 24 Jul 2020 23:03:26 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Martin Varghese <martin.varghese@nokia.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] bareudp: forbid mixing IP and MPLS in multiproto mode
Message-ID: <f6e832e7632acf28b1d2b35dddb08769c7ce4fab.1595624517.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In multiproto mode, bareudp_xmit() accepts sending multicast MPLS and
IPv6 packets regardless of the bareudp ethertype. In practice, this
let an IP tunnel send multicast MPLS packets, or an MPLS tunnel send
IPv6 packets.

We need to restrict the test further, so that the multiproto mode only
enables
  * IPv6 for IPv4 tunnels,
  * or multicast MPLS for unicast MPLS tunnels.

To improve clarity, the protocol validation is moved to its own
function, where each logical test has its own condition.

Fixes: 4b5f67232d95 ("net: Special handling for IP & MPLS.")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 drivers/net/bareudp.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 3dd46cd55114..e97f318f9f06 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -407,19 +407,34 @@ static int bareudp6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	return err;
 }
 
+static bool bareudp_proto_valid(struct bareudp_dev *bareudp, __be16 proto)
+{
+	if (bareudp->ethertype == proto)
+		return true;
+
+	if (!bareudp->multi_proto_mode)
+		return false;
+
+	if (bareudp->ethertype == htons(ETH_P_MPLS_UC) &&
+	    proto == ntohs(ETH_P_MPLS_MC))
+		return true;
+
+	if (bareudp->ethertype == htons(ETH_P_IP) &&
+	    proto == ntohs(ETH_P_IPV6))
+		return true;
+
+	return false;
+}
+
 static netdev_tx_t bareudp_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct bareudp_dev *bareudp = netdev_priv(dev);
 	struct ip_tunnel_info *info = NULL;
 	int err;
 
-	if (skb->protocol != bareudp->ethertype) {
-		if (!bareudp->multi_proto_mode ||
-		    (skb->protocol !=  htons(ETH_P_MPLS_MC) &&
-		     skb->protocol !=  htons(ETH_P_IPV6))) {
-			err = -EINVAL;
-			goto tx_error;
-		}
+	if (!bareudp_proto_valid(bareudp, skb->protocol)) {
+		err = -EINVAL;
+		goto tx_error;
 	}
 
 	info = skb_tunnel_info(skb);
-- 
2.21.3

