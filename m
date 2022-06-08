Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFC1543ADF
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 19:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233163AbiFHRzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 13:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233099AbiFHRzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 13:55:14 -0400
X-Greylist: delayed 276 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 08 Jun 2022 10:55:11 PDT
Received: from mailrelay.tu-berlin.de (mailrelay.tu-berlin.de [130.149.7.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C75443D3;
        Wed,  8 Jun 2022 10:55:11 -0700 (PDT)
Received: from SPMA-03.tubit.win.tu-berlin.de (localhost.localdomain [127.0.0.1])
        by localhost (Email Security Appliance) with SMTP id 5519F6CC4C_2A0E168B;
        Wed,  8 Jun 2022 17:50:32 +0000 (GMT)
Received: from mail.tu-berlin.de (mail.tu-berlin.de [141.23.12.141])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "exchange.tu-berlin.de", Issuer "DFN-Verein Global Issuing CA" (not verified))
        by SPMA-03.tubit.win.tu-berlin.de (Sophos Email Appliance) with ESMTPS id 2194A6CC49_2A0E168F;
        Wed,  8 Jun 2022 17:50:32 +0000 (GMT)
Received: from jt.fritz.box (77.183.106.143) by ex-04.svc.tu-berlin.de
 (10.150.18.8) with Microsoft SMTP Server id 15.2.986.22; Wed, 8 Jun 2022
 19:50:31 +0200
From:   =?UTF-8?q?J=C3=B6rn-Thorben=20Hinz?= <jthinz@mailbox.tu-berlin.de>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        =?UTF-8?q?J=C3=B6rn-Thorben=20Hinz?= <jthinz@mailbox.tu-berlin.de>
Subject: [PATCH bpf-next 0/2] Align BPF TCP CCs implementing cong_control() with non-BPF CCs
Date:   Wed, 8 Jun 2022 19:48:41 +0200
Message-ID: <20220608174843.1936060-1-jthinz@mailbox.tu-berlin.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-SASI-RCODE: 200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=campus.tu-berlin.de; h=from:to:cc:subject:date:message-id:mime-version:content-type:content-transfer-encoding; s=dkim-tub; bh=tFIIq1mlQaYMEbUwEcOiqSBwB9Sl8ZXeLT5TWV11mtU=; b=jf7cRU+KRzX9doz7IHG0wgOSETjrUCSY6Eo4TqPpzzkEreZiPfFDIrHNfLv+GYQi46Kkn5QfFZIEzcX9HSKNTuJ+rnjv3KAyZclPSadNAcQAPBgXilutqPjey8dAFKZpnvnoa5pLDIzavHtCO8qUrh/JKj7+Ib+8aewmWPlRDV8=
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello there,

hope, I’m in the right place with bpf-next. Previous changes to
bpf_tcp_ca.c seemed to have gone here, besides the MAINTAINERS file and
get_maintainer.pl hinting more towards the neighboring net-next.

This small series corrects some inconveniences for a BPF TCP CC that
implements and uses tcp_congestion_ops.cong_control(). Until now, such a
CC did not have all necessary write access to struct sock and
unnecessarily needed to implement cong_avoid().

Jörn-Thorben Hinz (2):
  bpf: Allow a TCP CC to write sk_pacing_rate and sk_pacing_status
  bpf: Require only one of cong_avoid() and cong_control() from a TCP CC

 net/ipv4/bpf_tcp_ca.c | 7 +++++++
 1 file changed, 7 insertions(+)

-- 
2.30.2

