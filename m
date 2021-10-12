Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335BD42ABE5
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 20:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbhJLS2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 14:28:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232387AbhJLS2l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 14:28:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0B3960ED4;
        Tue, 12 Oct 2021 18:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634063199;
        bh=J3Mc/SDShwvBM909cmp1iBdUKv6KSGXPyMli5iEQx+g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ka3U0KmoRDP7+rgKSbMwcHER5mXZSPUb/I6fi3I3hzB1RFII2d4iUPo6AWH3PvMUp
         YVRgXSCMW2qUanKBPCxp1qQQ/6f2OTJ7R4PtKv7CRFnRvJI/TRl3LOAR2PMV7371pl
         eTVGUoy8fSt3RM/aiZX4N6BoqB+uMpcFOka09ZVjvmVpQvKjvqgi7SP1KARrMpMCE2
         UxCDdQaxAH53m9bwC7OuwU1AxLIxBGpgWp5v6eWKwlKVVl8nXaPPkkKgPOkv5Qx5WO
         rt7h0acHaQpKZ3zoxGD52AaBLnB8CY7gD9zHWlRXnAKZ2f7J8CyyqQNcg+94K1kd2q
         J7v4Fd9/M867g==
Date:   Tue, 12 Oct 2021 11:26:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <mkubecek@suse.cz>, <andrew@lunn.ch>,
        <amitc@mellanox.com>, <idosch@idosch.org>, <danieller@nvidia.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <jdike@addtoit.com>, <richard@nod.at>,
        <anton.ivanov@cambridgegreys.com>, <netanel@amazon.com>,
        <akiyano@amazon.com>, <gtzalik@amazon.com>, <saeedb@amazon.com>,
        <chris.snook@gmail.com>, <ulli.kroll@googlemail.com>,
        <linus.walleij@linaro.org>, <jeroendb@google.com>,
        <csully@google.com>, <awogbemila@google.com>, <jdmason@kudzu.us>,
        <rain.1986.08.12@gmail.com>, <zyjzyj2000@gmail.com>,
        <kys@microsoft.com>, <haiyangz@microsoft.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <doshir@vmware.com>,
        <pv-drivers@vmware.com>, <jwi@linux.ibm.com>,
        <kgraul@linux.ibm.com>, <hca@linux.ibm.com>, <gor@linux.ibm.com>,
        <johannes@sipsolutions.net>, <netdev@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>,
        <linux-s390@vger.kernel.org>
Subject: Re: [PATCH V3 net-next 4/6] ethtool: extend ringparam setting uAPI
 with rx_buf_len
Message-ID: <20211012112637.5489ac9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211012134127.11761-5-huangguangbin2@huawei.com>
References: <20211012134127.11761-1-huangguangbin2@huawei.com>
        <20211012134127.11761-5-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Oct 2021 21:41:25 +0800 Guangbin Huang wrote:
> @@ -80,7 +83,10 @@ static int rings_fill_reply(struct sk_buff *skb,
>  	     (nla_put_u32(skb, ETHTOOL_A_RINGS_TX_MAX,
>  			  ringparam->tx_max_pending) ||
>  	      nla_put_u32(skb, ETHTOOL_A_RINGS_TX,
> -			  ringparam->tx_pending))))
> +			  ringparam->tx_pending)))  ||
> +	    (ringparam_ext->rx_buf_len &&
> +	     (nla_put_u32(skb, ETHTOOL_A_RINGS_RX_BUF_LEN,
> +			  ringparam_ext->rx_buf_len))))
>  		return -EMSGSIZE;

I think that this chunk belongs in the previous patch.
