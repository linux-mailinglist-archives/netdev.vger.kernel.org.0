Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81ED84FDEFD
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347475AbiDLMFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351850AbiDLMCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:02:44 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81AE4316;
        Tue, 12 Apr 2022 03:59:14 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id v4so8363171edl.7;
        Tue, 12 Apr 2022 03:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vgJhsUA0t53G3i/our+ohO3psku9eyW28VU5QSKiZig=;
        b=kODKyvrcOrR77JclBDjUYnawnWNK01/GVWtFIsW12r7g8YN0axNvWI+Tkgp6Cyhz0Z
         C6xzF62i4JoRriVl8LA+AVqe5ltwD1FuxXd+mmLD4NQPGKZJoVvRasG/GPyHXFErFgGm
         LdswQFXyhPAvPmiYgVHGyDGqaM9j5cr9mD1liWP3Qzxyq55Wf33aoAwgm9b1Zfd8/fHK
         qhVrmV7f99XAz177959rW+5G/60EOBMlfarhiN5BeLtFcrg8DC+ww502DPmowCO44w/Q
         GtGbyld1ijFb9Mmlm4wzzE7Icc6yMDgQLt6J7mEhHdzoFwiPtonQbOvYWrZA7yn6f5ls
         Cqnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vgJhsUA0t53G3i/our+ohO3psku9eyW28VU5QSKiZig=;
        b=et81hI/Ngq89hf/9pEMlrwoh6kHsVogITT1h+LI6yGyaT3/qLxLGVa26wuh5+3lDEM
         P2OoOg6zHcccru8TJCa0vOmuTHqboAP7RcpDezeIbv6zQ/hOUmpoUKQP1WlUiS42yk9H
         XDDE0JgvfkcAhiDtyVoF9Nl5oTBMpwCnmOhzaDdk0T6ASXSopsvDScqEOzOFszk0FX6L
         ceWh5iHiZc8tBqXlymZOEtvDRJEmVXJJ+AiNDM7RyeZCTjrd3+5O1GUnEGaiGjy+k84O
         MuDLLL6DFGOSMBRpOM6+BqrKkFgi7CEd2dyrMnQAE/ASivHPI6PmTfyNP97pqINWDm0x
         reaw==
X-Gm-Message-State: AOAM532z6HP1I0oXy95o9MW5htWmhha9a+20dkI/Ns0Ql5B2eJwjjZm2
        n6IEt0dj1x5FbEmdib8rr94=
X-Google-Smtp-Source: ABdhPJywkgO95X0rz4DuO846vGglHJszFGcoUayyvWUmqo2BIcn+GJrvbkhswsbiFoR2QzwirmQ+Lg==
X-Received: by 2002:a05:6402:370b:b0:41d:8508:20af with SMTP id ek11-20020a056402370b00b0041d850820afmr6829552edb.16.1649761152863;
        Tue, 12 Apr 2022 03:59:12 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id f1-20020a056402194100b00416b174987asm16986370edz.35.2022.04.12.03.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 03:59:12 -0700 (PDT)
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
        Jakob Koschel <jakobkoschel@gmail.com>,
        Colin Ian King <colin.king@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Walle <michael@walle.cc>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Eric Dumazet <edumazet@google.com>,
        Xu Wang <vulab@iscas.ac.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: [PATCH net-next v2 16/18] ps3_gelic: Replace usage of found with dedicated list iterator variable
Date:   Tue, 12 Apr 2022 12:58:28 +0200
Message-Id: <20220412105830.3495846-17-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220412105830.3495846-1-jakobkoschel@gmail.com>
References: <20220412105830.3495846-1-jakobkoschel@gmail.com>
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

