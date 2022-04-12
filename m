Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D95C74FDF2E
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350217AbiDLMGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351776AbiDLMCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:02:43 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3C74A3D3;
        Tue, 12 Apr 2022 03:59:08 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id bg10so36567333ejb.4;
        Tue, 12 Apr 2022 03:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0WZ3VKnVxGM80qdLHkweZkrBfRptzeVUXSKm7/OGDn8=;
        b=XZluyyXBrSJrDF64OiHdboQ+ZaxK2ykPWgKXHz6CncWVY4DziM2RY4qNmsykbtsgUu
         08JLMlZV9OcMJWqB86aOYu+iw263HRolsP+H7z/noCeKqqK8hXMsdAW0XZPPXMYQWksG
         w6l4nkpBI3i6/4vSvZvI3HlokHsF0U6Q4egmb0iFo/TvYWrnsqz3YxzyCuGiighxHsQ5
         2kA0FM43PbosMl/yrvykkSxyrD9FonhzgPMFEyNRyWk54oCH++MECb1/FQpjWuKTtphB
         uJ/04nx57SCToZr7ZC+YTdHhACyjXy/VhUka6PZwXXJFi8lrElMpOpoPfSM9kFVEjH8d
         8JMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0WZ3VKnVxGM80qdLHkweZkrBfRptzeVUXSKm7/OGDn8=;
        b=bJOUldjZYHv9Rczvkctc0pCig3DhaQrARLjmCvb+amx7bLxInqQ0YpEDpM99qks8S/
         haLjLdosVSSLappEHqpEIwZ/Ke0ri/LqioewulIdSi/pErB2HBPAErTnlRgNWn27Ru6l
         E5T50hTUzGV1K7iMjMfmZdAkPKQBZUR7NyYxjr1KXm8vbWnQh6DIP+Qg7JfONgGIc2oU
         HlSMmYtfiQJ/SsY7uN2fWDDXIP2Lu2OiiUFxJ4crSDFPftq89XnZT/f0hrJdd07VlxSq
         WG3cB0AdvGmxRK7A8EEtj/f0xz6GR8eXTD03xlU0qS0sZMo6TUIOprK6O3Pe9w1/HmHh
         Qpww==
X-Gm-Message-State: AOAM531XPsgG9KrxmKCQE2MoP1868PG2jXRHb3sNKzs7D2NP9RJp0QAT
        DV1uWh3M6lpjV0Llp8ItObw=
X-Google-Smtp-Source: ABdhPJxDHNie4r8skUxjeBcgyxDVwngRrhoDRWdvCwq105U3Ymrsz4/WteZI1QKZZU0ouaxPdY/MNw==
X-Received: by 2002:a17:907:e91:b0:6e8:61d0:9e4d with SMTP id ho17-20020a1709070e9100b006e861d09e4dmr16468938ejc.507.1649761147299;
        Tue, 12 Apr 2022 03:59:07 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id f1-20020a056402194100b00416b174987asm16986370edz.35.2022.04.12.03.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 03:59:06 -0700 (PDT)
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
Subject: [PATCH net-next v2 12/18] net: qede: Replace usage of found with dedicated list iterator variable
Date:   Tue, 12 Apr 2022 12:58:24 +0200
Message-Id: <20220412105830.3495846-13-jakobkoschel@gmail.com>
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
 drivers/net/ethernet/qlogic/qede/qede_rdma.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_rdma.c b/drivers/net/ethernet/qlogic/qede/qede_rdma.c
index 6304514a6f2c..2eb03ffe2484 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_rdma.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_rdma.c
@@ -246,18 +246,17 @@ static void qede_rdma_change_mtu(struct qede_dev *edev)
 static struct qede_rdma_event_work *
 qede_rdma_get_free_event_node(struct qede_dev *edev)
 {
-	struct qede_rdma_event_work *event_node = NULL;
-	bool found = false;
+	struct qede_rdma_event_work *event_node = NULL, *iter;
 
-	list_for_each_entry(event_node, &edev->rdma_info.rdma_event_list,
+	list_for_each_entry(iter, &edev->rdma_info.rdma_event_list,
 			    list) {
-		if (!work_pending(&event_node->work)) {
-			found = true;
+		if (!work_pending(&iter->work)) {
+			event_node = iter;
 			break;
 		}
 	}
 
-	if (!found) {
+	if (!event_node) {
 		event_node = kzalloc(sizeof(*event_node), GFP_ATOMIC);
 		if (!event_node) {
 			DP_NOTICE(edev,
-- 
2.25.1

