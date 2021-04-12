Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A52035D271
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 23:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244788AbhDLVTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 17:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242830AbhDLVTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 17:19:43 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D44C061574;
        Mon, 12 Apr 2021 14:19:24 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id BE3754D259C01;
        Mon, 12 Apr 2021 14:19:20 -0700 (PDT)
Date:   Mon, 12 Apr 2021 14:19:16 -0700 (PDT)
Message-Id: <20210412.141916.1569200948681549246.davem@davemloft.net>
To:     boon.leong.ong@intel.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        mcoquelin.stm32@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH net-next 6/7] net: stmmac: Enable RX via AF_XDP
 zero-copy
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210412154130.20742-7-boon.leong.ong@intel.com>
References: <20210412154130.20742-1-boon.leong.ong@intel.com>
        <20210412154130.20742-7-boon.leong.ong@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 12 Apr 2021 14:19:21 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+	/* synchronize_rcu() needed for pending XDP buffers to drain */
+	for (queue = 0; queue < rx_queues_cnt; queue++) {
+		rx_q = &priv->rx_queue[queue];
+		if (rx_q->xsk_pool) {
+			synchronize_rcu();

Are you sure this is safe here, especially via the ->ndo_setup_tc() code path?

Thank you.
