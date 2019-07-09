Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57D3363063
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 08:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbfGIGVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 02:21:02 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42074 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfGIGVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 02:21:01 -0400
Received: by mail-wr1-f66.google.com with SMTP id a10so18497902wrp.9
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 23:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=ii+SXJ6+lfZyOMkcgHiyxZo8EJmBOTy8e2tqhigbHgM=;
        b=mzoMzL+uHjgHbharxa6BcWOTmRpcvyOhY1DkVle/hIw5aphi/yagKx8zIgSi8AHTGE
         8VQwdWSyV7AQZ67NzZXEoojinQ7FTenP+7PftdgjHYNiJ6oISdx49oemqROx06TL68Yl
         hzc5Rdzji2xumhrB3Rml3dtritWa+LvzjpeCa+/W0SsbqAebpNWe0E/lR3kKJuNmWh7j
         wlePILMgzUS6KTPjb6/gx8I5E9CBOltn5mWPCaRxRpeEb2sWXON+MxmMtYIZ1S1ZCeyR
         +IdzfKZgetmraUoX4wXKBgPbd2Gy2E3XbySc4jY2cdUNlvmtPqvtaEPQcvm3e9CEe1/q
         ExFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=ii+SXJ6+lfZyOMkcgHiyxZo8EJmBOTy8e2tqhigbHgM=;
        b=SXEdK6UccdhoLxhko6REoisSPqHuj45HjHUGU6pd/OWbaH/SZeDv67avmU4IdJP7Zo
         AM9kXvpOVhZWHC9Qt/3XgJw398VrRVuxRN0GQCQ/5SgGewYbWyDNbjL2fe7vnEUv/kUd
         vh6yrFykqjblIjVY5XcrkbGkhldH6aLsBg+bM/nJjgR4X7cdHhqpSpCKUPJ3+5dxJinO
         uT3S+293WfxfvpsIfNO2aLYsthaY21jwjz+YOQpeX+Avt5Z3Z40/Wz6YH75mgLpeGe5Q
         ECg6F3eIYgwsM5W2FD24BpbuPf93w23CfTCXJLzZ5UnGlE3naxuJlPeunk+VB+UB5Lxd
         2qrA==
X-Gm-Message-State: APjAAAXR+oJTguUXCCbrSM1D1P41L5ZIeEUlaQ0mU1kykGGZ1jeT3Ccw
        VCKCAASotcBwwURd2o9ElQSU/Q==
X-Google-Smtp-Source: APXvYqwMuAxaX1kwGYFqL8yFCzZQLst+dSPzj80a5gurwUi/qGC6E0PqpmLgwMja9ali6xLiVwN6qA==
X-Received: by 2002:a5d:6284:: with SMTP id k4mr23350348wru.179.1562653259657;
        Mon, 08 Jul 2019 23:20:59 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id v15sm17182167wru.61.2019.07.08.23.20.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 23:20:59 -0700 (PDT)
Date:   Tue, 9 Jul 2019 08:20:58 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, netdev@vger.kernel.org,
        davem@davemloft.net, thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        madalin.bucur@nxp.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        linux-net-drivers@solarflare.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        maxime.chevallier@bootlin.com, cphealy@gmail.com,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next,v3 11/11] netfilter: nf_tables: add hardware
 offload support
Message-ID: <20190709062058.GI2282@nanopsycho.orion>
References: <20190708160614.2226-1-pablo@netfilter.org>
 <20190708160614.2226-12-pablo@netfilter.org>
 <20190708184437.4d29648a@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190708184437.4d29648a@cakuba.netronome.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 09, 2019 at 03:44:37AM CEST, jakub.kicinski@netronome.com wrote:
>On Mon,  8 Jul 2019 18:06:13 +0200, Pablo Neira Ayuso wrote:
>> This patch adds hardware offload support for nftables through the
>> existing netdev_ops->ndo_setup_tc() interface, the TC_SETUP_CLSFLOWER
>> classifier and the flow rule API. This hardware offload support is
>> available for the NFPROTO_NETDEV family and the ingress hook.
>> 
>> Each nftables expression has a new ->offload interface, that is used to
>> populate the flow rule object that is attached to the transaction
>> object.
>> 
>> There is a new per-table NFT_TABLE_F_HW flag, that is set on to offload
>> an entire table, including all of its chains.
>> 
>> This patch supports for basic metadata (layer 3 and 4 protocol numbers),
>> 5-tuple payload matching and the accept/drop actions; this also includes
>> basechain hardware offload only.
>> 
>> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>
>Any particular reason to not fence this off with a device feature
>(ethtool -k)?  Then you wouldn't need that per-driver list abomination
>until drivers start advertising it..  IDK if we want the per-device
>offload enable flags or not in general, it seems like a good idea in
>general for admin to be able to disable offload per device 🤷
>
>> +static int nft_flow_offload_rule(struct nft_trans *trans,
>> +				 enum tc_fl_command command)
>> +{
>> +	struct nft_flow_rule *flow = nft_trans_flow_rule(trans);
>> +	struct nft_rule *rule = nft_trans_rule(trans);
>> +	struct tc_cls_flower_offload cls_flower = {};
>> +	struct nft_base_chain *basechain;
>> +	struct netlink_ext_ack extack;
>> +	__be16 proto = ETH_P_ALL;
>> +
>> +	if (!nft_is_base_chain(trans->ctx.chain))
>> +		return -EOPNOTSUPP;
>> +
>> +	basechain = nft_base_chain(trans->ctx.chain);
>> +
>> +	if (flow)
>> +		proto = flow->proto;
>> +
>> +	nft_flow_offload_common_init(&cls_flower.common, proto, &extack);
>> +	cls_flower.command = command;
>> +	cls_flower.cookie = (unsigned long) rule;
>> +	if (flow)
>> +		cls_flower.rule = flow->rule;
>> +
>> +	return nft_setup_cb_call(basechain, TC_SETUP_CLSFLOWER, &cls_flower);
>> +}
>
>Are we 100% okay with using TC cls_flower structures and defines in nft
>code?

Yeah, your right. Should be renamed and moved to "flow offload" as well.
