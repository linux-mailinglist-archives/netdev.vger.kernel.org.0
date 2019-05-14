Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3111CD5B
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 19:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbfENRBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 13:01:14 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44591 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfENRBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 13:01:12 -0400
Received: by mail-lj1-f194.google.com with SMTP id e13so14975880ljl.11
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 10:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=M+asgOjKkxyJidGL/Vv7sfbCymMBgR+wKAqUoHiQtxQ=;
        b=DBn77Du5EqyM2uvrG7eNPNaGA/tGHGSxA8hp3ANygkA973XM0lNus2cMRlzwlDI1Vs
         6B5lPIMBoAobVSKlb3sHrqvhtG3QySxMFNeNZgcZ2AYY5sQn3NVdjVrH5ZvEZESxX6MU
         bBWfK4seR2BkvMlCaRNR41y4ezetAKHIfA6LcpjpEZYIJxsrHd2ot6uMhUXdkbou8YDA
         WvPj/8iY0LyBlF6+4e0RVUe6TX+wf/Nk3tHqaTDusW0lHQ8s1tNc1bAcRo2nkEi/YCP/
         BKUtQh9CGohGpAQQ4Z3cRTud+07RkzCITxFuqaHf323bt1CeTqhSuAfOdBTy4AIAHW8R
         8EGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=M+asgOjKkxyJidGL/Vv7sfbCymMBgR+wKAqUoHiQtxQ=;
        b=WTT+GukplqDgsR2weqawg3QKBTM+/mJxqAw5KJJOaFKJvhMM1hA3QV0wgSXQnIcPCH
         X7b+XGQD/5g+BXVP9CWeKKZNkZhtUQ8+3YhOd5otUdwKPOyFElvXHAi603ukbkH9CHIp
         h4n9ovbxmcahVHSzP4sYH+idlG4+1OtP5bLanht7k3PmhzVgPoK3aQJjRev3MFV9sNgX
         q6frcejyQVh0Sf8nhSEXG5Dlaew1wA9JUiSVL692mzwIitiQKyZn/1RcVwL9y+W+FDEc
         z3zXywTUaitnwTJbrLO98uuWIOkgcdQDQ67HgkvVG+ny2T/TCL/RLxsSmk4rWqx0UY5k
         tYeA==
X-Gm-Message-State: APjAAAW/XFUWq5eVP60KOCN7YAnlP08SW7Yb3RNYkICQYvtz4lzNVEoI
        gGUhneHcIRGIy67DxxreDdcZHQ==
X-Google-Smtp-Source: APXvYqyZO1556MZKXsal2lV5RL+zHNQ5YneIp2bnTiE535h27p9BAdsFS0cmUdvm/v9YvwPJBHwjAQ==
X-Received: by 2002:a2e:568b:: with SMTP id k11mr17600632lje.124.1557853270761;
        Tue, 14 May 2019 10:01:10 -0700 (PDT)
Received: from localhost ([5.180.201.3])
        by smtp.gmail.com with ESMTPSA id q26sm2413815lfd.54.2019.05.14.10.01.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 May 2019 10:01:10 -0700 (PDT)
Date:   Tue, 14 May 2019 19:01:08 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, thomas.lendacky@amd.com,
        f.fainelli@gmail.com, ariel.elior@cavium.com,
        michael.chan@broadcom.com, santosh@chelsio.com,
        madalin.bucur@nxp.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, jakub.kicinski@netronome.com,
        peppe.cavallaro@st.com, grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        julia.lawall@lip6.fr, john.fastabend@gmail.com
Subject: Re: [PATCH net-next,RFC 2/2] netfilter: nf_tables: add hardware
 offload support
Message-ID: <20190514170108.GC2584@nanopsycho>
References: <20190509163954.13703-1-pablo@netfilter.org>
 <20190509163954.13703-3-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509163954.13703-3-pablo@netfilter.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, May 09, 2019 at 06:39:51PM CEST, pablo@netfilter.org wrote:
>This patch adds hardware offload support for nftables through the
>existing netdev_ops->ndo_setup_tc() interface, the TC_SETUP_CLSFLOWER
>classifier and the flow rule API. This hardware offload support is
>available for the NFPROTO_NETDEV family and the ingress hook.
>
>Each nftables expression has a new ->offload interface, that is used to
>populate the flow rule object that is attached to the transaction
>object.
>
>There is a new per-table NFT_TABLE_F_HW flag, that is set on to offload
>an entire table, including all of its chains.
>
>This patch supports for basic metadata (layer 3 and 4 protocol numbers),
>5-tuple payload matching and the accept/drop actions; this also includes
>basechain hardware offload only.
>
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

[...]

>+static int nft_flow_offload_chain(struct nft_trans *trans,
>+				  enum flow_block_command cmd)
>+{
>+	struct nft_chain *chain = trans->ctx.chain;
>+	struct netlink_ext_ack extack = {};
>+	struct flow_block_offload bo = {};
>+	struct nft_base_chain *basechain;
>+	struct net_device *dev;
>+	int err;
>+
>+	if (!nft_is_base_chain(chain))
>+		return -EOPNOTSUPP;
>+
>+	basechain = nft_base_chain(chain);
>+	dev = basechain->ops.dev;
>+	if (!dev)
>+		return -EOPNOTSUPP;
>+
>+	bo.command = cmd;
>+	bo.binder_type = TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS;
>+	bo.block_index = (u32)trans->ctx.chain->handle;
>+	bo.extack = &extack;
>+	INIT_LIST_HEAD(&bo.cb_list);
>+
>+	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);

Okay, so you pretend to be clsact-ingress-flower. That looks fine.
But how do you ensure that the real one does not bind a block on the
same device too?


>+	if (err < 0)
>+		return err;
>+
>+	list_splice(&bo.cb_list, &basechain->cb_list);
>+	return 0;
>+}
>+

[...]
