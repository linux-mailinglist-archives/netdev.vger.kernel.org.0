Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D92FF511F74
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242204AbiD0QNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242154AbiD0QMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:12:01 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5533D494BE4;
        Wed, 27 Apr 2022 09:08:17 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id r13so4370068ejd.5;
        Wed, 27 Apr 2022 09:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JrLemglUST4WORuuuukktAwV8TRd9yLyGflAl3xl1zc=;
        b=P7ArfueFfqb+nsrBlYp2Z856X99lZCDM/QPiYaspWe/aoZAfnFhi0ej7wLBT4hCcfL
         77k4+v50MSgxLOvjNPnIhYfOBW4FQFYVlZiYujNH+pqRygBvfUrRQ3FV/jFtqBJKS/2b
         Lx93egMHRueiT7MNxTOXGno/PUsnNMD3V7O++/DXMseaGxU16Wm96460Dus2hzo+sGA0
         +bJ6hDMpHDm4BqEA3s2WCFCDC6qlZiwzBTRuauQoibdYSZYp81HTcc3V4uhwItLxrziD
         VaUpGDXAGkwEXQIB658hbO3HrqsFXij7V0DZUhMsQ5/sihqgnJtuLyZupaLA8yDcY1MF
         Xbug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JrLemglUST4WORuuuukktAwV8TRd9yLyGflAl3xl1zc=;
        b=MifsBbGYumA9Nj4UdRyDN3zyR67nOHOWCrY6pWtbuk+zLC05ZdC+ivIE7iEf79/mQj
         QgqWZ3hLPcb0koyDMmBCYAfNz8rWeBLxdqMeA4W8o2CAbJNyRCx2nHo+ruoMD1uZYmfQ
         oGbYKVksxa6UjgvWey5QQdqTaj1neYKgb8B7qY++DgMFndgM1HPKB91+KoERmau1ujSU
         +PjH0qFeK89vQYG94WD8T7SrVrC7iPzqjlGcLE9CVtCTu9Dkp1fSachNkp8pLOVZ36oP
         slayyGlin90z4cvdiG8kvB3f/7OonkughpN5M5bKsjh/4jyO9TJZrKJXQY6HYFnTfRDl
         /2+A==
X-Gm-Message-State: AOAM531R7pMG5zVF5a1jv6i9JNC4xdd8QfCx5LNPDEuw6dOPIpowbibt
        xZ+6s5AbPDG0vtFLmlau/Mw=
X-Google-Smtp-Source: ABdhPJymUyAuP9S3z9f8SGZ0ibdaRIW+1KvXVMPgBEGCfB3jsk37oMAvhNa2911ZCug37bA6orWp7w==
X-Received: by 2002:a17:907:97cd:b0:6f3:aeb8:6002 with SMTP id js13-20020a17090797cd00b006f3aeb86002mr9157397ejc.530.1651075648894;
        Wed, 27 Apr 2022 09:07:28 -0700 (PDT)
Received: from localhost.localdomain (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.googlemail.com with ESMTPSA id n5-20020a170906378500b006efb4ab6f59sm6984098ejc.86.2022.04.27.09.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 09:07:28 -0700 (PDT)
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
        Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Colin Ian King <colin.king@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Xu Wang <vulab@iscas.ac.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: [PATCH net-next v5 11/18] qed: Remove usage of list iterator variable after the loop
Date:   Wed, 27 Apr 2022 18:06:28 +0200
Message-Id: <20220427160635.420492-12-jakobkoschel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220427160635.420492-1-jakobkoschel@gmail.com>
References: <20220427160635.420492-1-jakobkoschel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To move the list iterator variable into the list_for_each_entry_*()
macro in the future it should be avoided to use the list iterator
variable after the loop body.

Since "found" and "p_ent" need to be equal, "found" should be used
consistently to limit the scope of "p_ent" to the list traversal in
the future.

Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
---
 drivers/net/ethernet/qlogic/qed/qed_spq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_spq.c b/drivers/net/ethernet/qlogic/qed/qed_spq.c
index d01b9245f811..cbaa2abed660 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_spq.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_spq.c
@@ -934,10 +934,10 @@ int qed_spq_completion(struct qed_hwfn *p_hwfn,
 		       u8 fw_return_code,
 		       union event_ring_data *p_data)
 {
+	struct qed_spq_entry	*found = NULL;
 	struct qed_spq		*p_spq;
-	struct qed_spq_entry	*p_ent = NULL;
+	struct qed_spq_entry	*p_ent;
 	struct qed_spq_entry	*tmp;
-	struct qed_spq_entry	*found = NULL;
 
 	if (!p_hwfn)
 		return -EINVAL;
@@ -980,7 +980,7 @@ int qed_spq_completion(struct qed_hwfn *p_hwfn,
 	DP_VERBOSE(p_hwfn, QED_MSG_SPQ,
 		   "Complete EQE [echo %04x]: func %p cookie %p)\n",
 		   le16_to_cpu(echo),
-		   p_ent->comp_cb.function, p_ent->comp_cb.cookie);
+		   found->comp_cb.function, found->comp_cb.cookie);
 	if (found->comp_cb.function)
 		found->comp_cb.function(p_hwfn, found->comp_cb.cookie, p_data,
 					fw_return_code);
-- 
2.25.1

