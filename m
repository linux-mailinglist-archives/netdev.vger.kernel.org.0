Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3DA43B4142
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 12:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbhFYKRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 06:17:17 -0400
Received: from mx01-muc.bfs.de ([193.174.230.67]:17536 "EHLO mx01-muc.bfs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229940AbhFYKRR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 06:17:17 -0400
X-Greylist: delayed 507 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jun 2021 06:17:16 EDT
Received: from SRVEX01-SZ.bfs.intern (exchange-sz.bfs.de [10.129.90.31])
        by mx01-muc.bfs.de (Postfix) with ESMTPS id 9FFEA202DF;
        Fri, 25 Jun 2021 12:06:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bfs.de; s=dkim201901;
        t=1624615587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lnyniA925oaLv6xCmAUV0koGpDyQMoCBIxvn4fBq48g=;
        b=xnppenF25ro/6uqS/VaNmGOypuWgFRalWkw6LQc16W4MDIuTw/Q00n3zgnIZDd14tCMXYm
        OPbPLCNt8NHWOVP1pWGt3KO8NjL8LY+rhm+QS8eoUfjvoXE3reA2nksAj087bvDpOnnlBd
        03ZYwdllCkR/AYaqAyzI4S8vO0cjtofALgAcyyg48xIcw3ssbBv5/bMIdgJTnezTR4A1v1
        9RQ5QzEztuVZVyrN0umswtnl705IK/09LTlGkD/iP957+LLEAROFQqriS+vkMaZMvI1S/s
        PZY3ImLlsxkm5rdg61XgGMpobSBzS4K92VTP+OqOgCkD6PcoGxswfAhvOMTDgw==
Received: from SRVEX01-SZ.bfs.intern (10.129.90.31) by SRVEX01-SZ.bfs.intern
 (10.129.90.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2242.4; Fri, 25 Jun
 2021 12:06:26 +0200
Received: from SRVEX01-SZ.bfs.intern ([fe80::7d2d:f9cb:2761:d24a]) by
 SRVEX01-SZ.bfs.intern ([fe80::7d2d:f9cb:2761:d24a%13]) with mapi id
 15.01.2242.008; Fri, 25 Jun 2021 12:06:26 +0200
From:   Walter Harms <wharms@bfs.de>
To:     Colin King <colin.king@canonical.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "Florian Westphal" <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: AW: [PATCH][next] netfilter: nf_tables: Fix dereference of null
 pointer flow
Thread-Topic: [PATCH][next] netfilter: nf_tables: Fix dereference of null
 pointer flow
Thread-Index: AQHXaTMrWtvE9yeYHE6OoR1wi0gmZqskfzhs
Date:   Fri, 25 Jun 2021 10:06:26 +0000
Message-ID: <b9c2377849aa4ac38ab0306589eb22d2@bfs.de>
References: <20210624195718.170796-1-colin.king@canonical.com>
In-Reply-To: <20210624195718.170796-1-colin.king@canonical.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.137.16.39]
x-tm-as-product-ver: SMEX-14.0.0.3080-8.6.1012-26240.007
x-tm-as-result: No-10-1.494800-5.000000
x-tmase-matchedrid: 1S6u5QTQd1vRubRCcrbc5grcxrzwsv5u3dCmvEa6IiEIhX6eoWEDQDK2
        ieu8M5yxXbEQ4IMEUkNYSFfNN4dT5nnpTNH/AsJs3nHtGkYl/VqospiVPA7RNd5JCoCAal7SqAX
        wsdh85gYWMGt82b0KdosykhlkMBZrns4ol/Cq0ar27WtDgGBc8rFPTb5VFSmp+frbXg+Uc4WlSP
        ogXOOu0nkxLxnSVVL2YckdNkata7p1A7Kay+/ARqRUKLeQWKvT/OXzMJnlSkVqEsgVJ+91qjXoJ
        TJoH3SyuW01O3xWv9744I/8BxtbujmGi73P/qmpHWRJEfGP5nl+CWCcHScOE/kuQv9PIVnNCd/k
        lmH4wZWb/TcV2K3QQB+XeYq6CbwCLGmmJTL2jhwD2WXLXdz+Adi5W7Rf+s6QkHPVkBTu31OW1Ro
        eNht4RefOVcxjDhcwPcCXjNqUmkVYF3qW3Je6+wPi+Wq5iTrnL9aE8reMsSUmpZaVbtuQtjySXe
        WTqK8YOj1mmoYoiHtHUiUGLlM6fiBt/EW/7slJ+SxNivL27/fZQR0FijuLkt7hHyldoPK3Ce3Hh
        LNk3bDTNQdFAimn3qV/ssqsXD7H9qHo4HSWvyB+3BndfXUhXQ==
x-tm-as-user-approved-sender: No
x-tm-as-user-blocked-sender: No
x-tmase-result: 10-1.494800-5.000000
x-tmase-version: SMEX-14.0.0.3080-8.6.1012-26240.007
x-tm-snts-smtp: 1E84C81F601FA0A81524726E59E79818BC81096A2DE42DC5DBB5023316AAF4202000:9
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spam-Status: No, score=-18.00
X-Spamd-Result: default: False [-18.00 / 7.00];
         ARC_NA(0.00)[];
         TO_DN_EQ_ADDR_SOME(0.00)[];
         HAS_XOIP(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[bfs.de:s=dkim201901];
         WHITELIST_LOCAL_IP(-15.00)[10.129.90.31];
         RCPT_COUNT_SEVEN(0.00)[11];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_MATCH_FROM(0.00)[];
         BAYES_HAM(-3.00)[99.99%]
Authentication-Results: mx01-muc.bfs.de;
        none
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi Colin,
most free_something_functions accept NULL
these days, perhaps it would be more efficient
to add a check in nft_flow_rule_destroy().
There is a chance that this will catch the same
mistake in future  also.

jm2c,
re,
 wh
________________________________________
Von: Colin King <colin.king@canonical.com>
Gesendet: Donnerstag, 24. Juni 2021 21:57:18
An: Pablo Neira Ayuso; Jozsef Kadlecsik; Florian Westphal; David S . Miller=
; Jakub Kicinski; netfilter-devel@vger.kernel.org; coreteam@netfilter.org; =
netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org; linux-kernel@vger.kernel.org
Betreff: [PATCH][next] netfilter: nf_tables: Fix dereference of null pointe=
r flow

WARNUNG: Diese E-Mail kam von au=DFerhalb der Organisation. Klicken Sie nic=
ht auf Links oder =F6ffnen Sie keine Anh=E4nge, es sei denn, Sie kennen den=
/die Absender*in und wissen, dass der Inhalt sicher ist.


From: Colin Ian King <colin.king@canonical.com>

In the case where chain->flags & NFT_CHAIN_HW_OFFLOAD is false then
nft_flow_rule_create is not called and flow is NULL. The subsequent
error handling execution via label err_destroy_flow_rule will lead
to a null pointer dereference on flow when calling nft_flow_rule_destroy.
Since the error path to err_destroy_flow_rule has to cater for null
and non-null flows, only call nft_flow_rule_destroy if flow is non-null
to fix this issue.

Addresses-Coverity: ("Explicity null dereference")
Fixes: 3c5e44622011 ("netfilter: nf_tables: memleak in hw offload abort pat=
h")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/netfilter/nf_tables_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 390d4466567f..de182d1f7c4e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3446,7 +3446,8 @@ static int nf_tables_newrule(struct sk_buff *skb, con=
st struct nfnl_info *info,
        return 0;

 err_destroy_flow_rule:
-       nft_flow_rule_destroy(flow);
+       if (flow)
+               nft_flow_rule_destroy(flow);
 err_release_rule:
        nf_tables_rule_release(&ctx, rule);
 err_release_expr:
--
2.31.1

