Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6151D5029E0
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 14:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353547AbiDOMd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 08:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353857AbiDOMd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 08:33:29 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E6FF2F03F;
        Fri, 15 Apr 2022 05:31:01 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id l7so15185022ejn.2;
        Fri, 15 Apr 2022 05:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LXuHnml0JyQ7WUWtSyqxCdcrvdOAihH7ECEcB+ac3FQ=;
        b=VTgQeHrkpIHgOEGZvW6m7lK+ww/hBIaLxp/ed1YbHFERxY7K8zgmthq8r0MO/eDheA
         64RJAUDP0PCNupTiFSXSD0K9TwZw/VBqVra2httvVSuGRa0rtzP8UWtbBnmILYXL6Z2H
         sr5X4+IEfwB6d5kKRo4eDMfm2O1ZmyozhlUEFzHkyPeS+S7EEuZSM7ink8BrFdT5ZLz3
         GIxrZW9NwL5XcJZvTEmI8dg0NdKEWbX31YU7MxwkMeQJhRou9/SCt1Ujs+st1SvtgpVw
         9aQDWxS22TjT0DPrnK2A3NtIzbFZtU+RaSWnUyyUovnBEkNcZnYSmXiUDfvziK0b2SLX
         cyEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LXuHnml0JyQ7WUWtSyqxCdcrvdOAihH7ECEcB+ac3FQ=;
        b=jyumd+Y07D6xT8FUWRRZp5q+cNdnmyrz4tTDn4JqRPjR2eNKcbgcvVDI7fSFOwkPL3
         I8LmbxZzi4OWRtjxKdXiZwTKH5tw191MkMPrDftgQZ6SpyQ5+uRrrOM28NXRwFegGCjZ
         CJ+eus6IgcC0TgR6snJ1GVD8u6irOOVeeH5eChLS9E283IU3J51mePkpwQ1mkdsxoOCq
         UrMXC69OgV2IAM17fYyShjbZhuSZK4wflxLVMKfYboGUbJEEupF6FMzCBvQl1S90Gz/z
         lGBfev3ZRv2xVm3zUOBvqsbLpw0zC0zdVyUALh3xIQJSWgy2LikG2l73G8tq+7if+yta
         hpXg==
X-Gm-Message-State: AOAM533fh04TNMb5kzgzwOZvFXUYvuOjKCBzY33u0FIjQFEEK1B3FVVm
        a3n5/+GNDpYMe8Sf0lxRPiU=
X-Google-Smtp-Source: ABdhPJxoOHJKRpfHC4KfhLHKEeHHtK1KA32Oh4BvD5pxRHzbDl+DHwOIhAvuB9jirqfyrBrH+vb+KQ==
X-Received: by 2002:a17:907:9485:b0:6da:aa54:a88 with SMTP id dm5-20020a170907948500b006daaa540a88mr6248462ejc.427.1650025859818;
        Fri, 15 Apr 2022 05:30:59 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id bo14-20020a170906d04e00b006ce98d9c3e3sm1649533ejb.194.2022.04.15.05.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 05:30:59 -0700 (PDT)
From:   Jakob Koschel <jakobkoschel@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Colin Ian King <colin.king@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Xu Wang <vulab@iscas.ac.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: [PATCH net-next v4 10/18] qed: Replace usage of found with dedicated list iterator variable
Date:   Fri, 15 Apr 2022 14:29:39 +0200
Message-Id: <20220415122947.2754662-11-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220415122947.2754662-1-jakobkoschel@gmail.com>
References: <20220415122947.2754662-1-jakobkoschel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To move the list iterator variable into the list_for_each_entry_*()
macro in the future it should be avoided to use the list iterator
variable after the loop body.

To *never* use the list iterator variable after the loop it was
concluded to use a separate iterator variable instead of a
found boolean [1].

This removes the need to use a found variable and simply checking if
the variable was set, can determine if the break/goto was hit.

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/ [1]
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 26 ++++++++++-----------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index 1d1d4caad680..198c9321bf51 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -1630,38 +1630,36 @@ static struct qed_iwarp_listener *
 qed_iwarp_get_listener(struct qed_hwfn *p_hwfn,
 		       struct qed_iwarp_cm_info *cm_info)
 {
-	struct qed_iwarp_listener *listener = NULL;
+	struct qed_iwarp_listener *listener = NULL, *iter;
 	static const u32 ip_zero[4] = { 0, 0, 0, 0 };
-	bool found = false;
 
-	list_for_each_entry(listener,
+	list_for_each_entry(iter,
 			    &p_hwfn->p_rdma_info->iwarp.listen_list,
 			    list_entry) {
-		if (listener->port == cm_info->local_port) {
-			if (!memcmp(listener->ip_addr,
+		if (iter->port == cm_info->local_port) {
+			if (!memcmp(iter->ip_addr,
 				    ip_zero, sizeof(ip_zero))) {
-				found = true;
+				listener = iter;
 				break;
 			}
 
-			if (!memcmp(listener->ip_addr,
+			if (!memcmp(iter->ip_addr,
 				    cm_info->local_ip,
 				    sizeof(cm_info->local_ip)) &&
-			    (listener->vlan == cm_info->vlan)) {
-				found = true;
+			    iter->vlan == cm_info->vlan) {
+				listener = iter;
 				break;
 			}
 		}
 	}
 
-	if (found) {
+	if (listener)
 		DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "listener found = %p\n",
 			   listener);
-		return listener;
-	}
+	else
+		DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "listener not found\n");
 
-	DP_VERBOSE(p_hwfn, QED_MSG_RDMA, "listener not found\n");
-	return NULL;
+	return listener;
 }
 
 static int
-- 
2.25.1

