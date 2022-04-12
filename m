Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D907F4FE0CA
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351426AbiDLMuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355299AbiDLMsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:48:10 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604D3DEC7;
        Tue, 12 Apr 2022 05:16:47 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id g18so11988787ejc.10;
        Tue, 12 Apr 2022 05:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vgJhsUA0t53G3i/our+ohO3psku9eyW28VU5QSKiZig=;
        b=MbpelD1kO9fpd+TInbPP84SQTrTYFohS7QmbpAgzqeblyAZFn3SqJtplp4zUHPDIN+
         TiPBFcZy1uzoaGj6w8UCN6eSvYKqFm/GpqOxZZDGhiOnnw64ZPG+a3cL8ayI5PBKEmiV
         Bm5PiVvPrfxKiQYkNWj/y67f/behHd+xZYG6SJ27oZudVrF4fvY8p1PDKl019RGHD90r
         od4La0PkXqCWYS8vORcSOuwIokgKkz4LnPqN9FF8H6Gz4v61Oxb2jWhUrpJgNql9m2mM
         RmUwLOrTNPjZ+TlQ2pnRdHrWNs7b6qt/pSyuJ7YK37HQvNRjkmsEEhMx0Y0j+so2ZdhI
         C92A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vgJhsUA0t53G3i/our+ohO3psku9eyW28VU5QSKiZig=;
        b=ajjky8+bEmdeOr93RrGzX1xaw8vSjxMEPkqwP2eBT1dM/2hoB1Y8jQCkNRka0pVEkt
         ltXpwPy6sr72fgewMNgW0WwTB6fevGusPtASdirTYcjcQBSptda2eGHqTwUGjiFUtSnP
         D43+Tw4Rwy18CWD3cwi6J73Jrt//QBVldeG3zoKqsBl+ktFltbLRDaptSGL8yjrmGdlF
         xrnyPQPS1G8WhbFyve0J5OHCpgjRRjfYWoNkwEj5LorwWRmcI+f/TJD33dLUzKn+5uHa
         +rQN8OMCoiqJZvA+a+BRAahVQ27NV1VuOiGEpYjEGs/QkCjPu8IbFpmrPO+HwzAQIIPe
         hFWw==
X-Gm-Message-State: AOAM530MFvkphX+jdEQR+Sd4dy/JD5BpQ3kgOB7PpSXYmr8gaR8zrGFl
        uNE4wG+wVzWxHbVz5wv39P4=
X-Google-Smtp-Source: ABdhPJyMo6KTIk8H1Og/i+lDyMmyHBej66pIRzx61AXonnOv1vkfSgXfoiYQQvHnWxdCDwIqyLYSRw==
X-Received: by 2002:a17:906:a046:b0:6b9:20c:47c1 with SMTP id bg6-20020a170906a04600b006b9020c47c1mr34222677ejb.615.1649765805743;
        Tue, 12 Apr 2022 05:16:45 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id b5-20020a17090630c500b006e8044fa76bsm8827900ejb.143.2022.04.12.05.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 05:16:45 -0700 (PDT)
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
        Michael Walle <michael@walle.cc>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Colin Ian King <colin.king@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        Di Zhu <zhudi21@huawei.com>, Xu Wang <vulab@iscas.ac.cn>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: [PATCH net-next v3 16/18] ps3_gelic: Replace usage of found with dedicated list iterator variable
Date:   Tue, 12 Apr 2022 14:15:55 +0200
Message-Id: <20220412121557.3553555-17-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220412121557.3553555-1-jakobkoschel@gmail.com>
References: <20220412121557.3553555-1-jakobkoschel@gmail.com>
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
 .../net/ethernet/toshiba/ps3_gelic_wireless.c | 30 +++++++++----------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_wireless.c b/drivers/net/ethernet/toshiba/ps3_gelic_wireless.c
index dc14a66583ff..c8a016c902cd 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_wireless.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_wireless.c
@@ -1495,14 +1495,14 @@ static int gelic_wl_start_scan(struct gelic_wl_info *wl, int always_scan,
  */
 static void gelic_wl_scan_complete_event(struct gelic_wl_info *wl)
 {
+	struct gelic_wl_scan_info *target = NULL, *iter, *tmp;
 	struct gelic_eurus_cmd *cmd = NULL;
-	struct gelic_wl_scan_info *target, *tmp;
 	struct gelic_wl_scan_info *oldest = NULL;
 	struct gelic_eurus_scan_info *scan_info;
 	unsigned int scan_info_size;
 	union iwreq_data data;
 	unsigned long this_time = jiffies;
-	unsigned int data_len, i, found, r;
+	unsigned int data_len, i, r;
 	void *buf;
 
 	pr_debug("%s:start\n", __func__);
@@ -1539,14 +1539,14 @@ static void gelic_wl_scan_complete_event(struct gelic_wl_info *wl)
 	wl->scan_stat = GELIC_WL_SCAN_STAT_GOT_LIST;
 
 	/* mark all entries are old */
-	list_for_each_entry_safe(target, tmp, &wl->network_list, list) {
-		target->valid = 0;
+	list_for_each_entry_safe(iter, tmp, &wl->network_list, list) {
+		iter->valid = 0;
 		/* expire too old entries */
-		if (time_before(target->last_scanned + wl->scan_age,
+		if (time_before(iter->last_scanned + wl->scan_age,
 				this_time)) {
-			kfree(target->hwinfo);
-			target->hwinfo = NULL;
-			list_move_tail(&target->list, &wl->network_free_list);
+			kfree(iter->hwinfo);
+			iter->hwinfo = NULL;
+			list_move_tail(&iter->list, &wl->network_free_list);
 		}
 	}
 
@@ -1569,22 +1569,22 @@ static void gelic_wl_scan_complete_event(struct gelic_wl_info *wl)
 			continue;
 		}
 
-		found = 0;
+		target = NULL;
 		oldest = NULL;
-		list_for_each_entry(target, &wl->network_list, list) {
-			if (ether_addr_equal(&target->hwinfo->bssid[2],
+		list_for_each_entry(iter, &wl->network_list, list) {
+			if (ether_addr_equal(&iter->hwinfo->bssid[2],
 					     &scan_info->bssid[2])) {
-				found = 1;
+				target = iter;
 				pr_debug("%s: same BBS found scanned list\n",
 					 __func__);
 				break;
 			}
 			if (!oldest ||
-			    (target->last_scanned < oldest->last_scanned))
-				oldest = target;
+			    (iter->last_scanned < oldest->last_scanned))
+				oldest = iter;
 		}
 
-		if (!found) {
+		if (!target) {
 			/* not found in the list */
 			if (list_empty(&wl->network_free_list)) {
 				/* expire oldest */
-- 
2.25.1

