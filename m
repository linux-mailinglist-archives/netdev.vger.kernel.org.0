Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F154D5029E2
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 14:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353483AbiDOMdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 08:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353873AbiDOMdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 08:33:32 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14EA133E03;
        Fri, 15 Apr 2022 05:31:04 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id t25so9762689edt.9;
        Fri, 15 Apr 2022 05:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0WZ3VKnVxGM80qdLHkweZkrBfRptzeVUXSKm7/OGDn8=;
        b=HpKlEPRptbD/f1jBswuHJ3tvWie+EvRLe0jlVv7fhDSfxhscO+VA6roZkgEC6/6ZDJ
         wjwgmhdS9bdvuRaYewcvaOMAsf0uZh+KFcQdXxRcE7NsGF5sGyFWYDL3rrc5XIK+0sSO
         YeNC4Ky18jsviNL6gUw7JnOE6cABTwUTyG7OJdPu+4KpKpcJ/KlP71IwKL4zNi2SLj60
         h2MQmYdTvasp8jQDaGuzgrwE9rqpx6+DqAbk0uAyvaQ1v67IfmfBM/OUmgBmfluTvH0N
         OBl0XAO7QH6NSqt5pqsXAmGOEcTZ9cWxXP+bpDI62KX5XkzgQa4C4e2lxC2sBmFPQU1j
         tgOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0WZ3VKnVxGM80qdLHkweZkrBfRptzeVUXSKm7/OGDn8=;
        b=rvUmV2g0S3Cw5SfuiWBGYPiBRjtN5hcqps6Kj5FGsNdaNIQxb6Advywpl1lYeCruvW
         3uAF71o/Ytv3Cf8S9bYZcufiZPg6o3cHPFAKy2cx1JIbcNSKjJlUDF5oKPrNRscaOKjp
         daPxawsbMqILu8BT0lzelx5kVSB1aXhykzl/9JEB4Q1VnFO1luD9OFh1B89Mo7W7OibG
         mRxW0Fpytalq9vd084l4+eiKT+WH07xCtwqPJ3ukdb6g56+jqUBj7rfssH/y/i/2hLel
         gODQFIP84YjLC6y9SAddTAuyYsBAGcIj+h0dv2tyETZnXRONme8byRVURIJwR8I3AnOf
         4+Xg==
X-Gm-Message-State: AOAM530jFYHXnwW3v51d405CRJW/l1+K+e3lHnlM2js8mvQypp8frGoA
        Djf/TU9AoAp20gM62yAk4Kw=
X-Google-Smtp-Source: ABdhPJzrQprMTk8zfgWwJ+kQwuxXWp8pz8/Ul5emjvpU5KWxuLgjh/e6TfXZxlX60bako3WcwVs9QQ==
X-Received: by 2002:a05:6402:430c:b0:419:4660:e261 with SMTP id m12-20020a056402430c00b004194660e261mr8010136edc.324.1650025862541;
        Fri, 15 Apr 2022 05:31:02 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id bo14-20020a170906d04e00b006ce98d9c3e3sm1649533ejb.194.2022.04.15.05.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 05:31:02 -0700 (PDT)
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
Subject: [PATCH net-next v4 12/18] net: qede: Replace usage of found with dedicated list iterator variable
Date:   Fri, 15 Apr 2022 14:29:41 +0200
Message-Id: <20220415122947.2754662-13-jakobkoschel@gmail.com>
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

