Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E9B5E8BC6
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 13:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233411AbiIXL1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 07:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233391AbiIXL1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 07:27:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931F1102520;
        Sat, 24 Sep 2022 04:27:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31B96601B6;
        Sat, 24 Sep 2022 11:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C8DC433D6;
        Sat, 24 Sep 2022 11:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664018833;
        bh=Om3IK1bSFGWtUAzinAij84ISOXU5jRFjWepJ6S7ZPoU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=thpRP6w5I7RcLrD4BizGi7ev+8Xqh3ETHfXT9nShw8Vlfoka9G7ZbcyzblpAKZBz1
         k+8cky7x+3CGolZrDtqRH3zIR2+D87w5jPMj6/baLJi+1coB3UimhJXmJCrRcdkGn1
         WS6qCcBaN38LukWRTPvE0tu45W8c5I5+QnY1aYslzfFTWRJpshlAxIP/OU7wzVCdjB
         0chhGLIiP/sdE6+InY8hIeTjYp0gviltbL/RXM8ickQe5CNozNaiuuvB5joV/iiZtG
         JG1SR9ngqatbb9ybL0v6MnCNGC1CneUe9zJi/PAmObYb3+Yf6CUVTXXxomO4XnbFTL
         uPFl3p2zjK3wQ==
Date:   Sat, 24 Sep 2022 14:27:09 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>, kuba@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lipeng321@huawei.com, lanhao@huawei.com
Subject: Re: [PATCH net-next 00/14] redefine some macros of feature abilities
 judgement
Message-ID: <Yy7pjTX8VLLIiA0G@unreal>
References: <20220924023024.14219-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220924023024.14219-1-huangguangbin2@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 24, 2022 at 10:30:10AM +0800, Guangbin Huang wrote:
> The macros hnae3_dev_XXX_supported just can be used in hclge layer, but
> hns3_enet layer may need to use, so this serial redefine these macros.

IMHO, you shouldn't add new obfuscated code, but delete it.

Jakub,

The more drivers authors will obfuscate in-kernel primitives and reinvent
their own names, macros e.t.c, the less external reviewers you will be able
to attract.

IMHO, netdev should have more active position do not allow obfuscated code.

Thanks

> 
> Guangbin Huang (14):
>   net: hns3: modify macro hnae3_dev_fec_supported
>   net: hns3: modify macro hnae3_dev_udp_gso_supported
>   net: hns3: modify macro hnae3_dev_qb_supported
>   net: hns3: modify macro hnae3_dev_fd_forward_tc_supported
>   net: hns3: modify macro hnae3_dev_ptp_supported
>   net: hns3: modify macro hnae3_dev_int_ql_supported
>   net: hns3: modify macro hnae3_dev_hw_csum_supported
>   net: hns3: modify macro hnae3_dev_tx_push_supported
>   net: hns3: modify macro hnae3_dev_phy_imp_supported
>   net: hns3: modify macro hnae3_dev_ras_imp_supported
>   net: hns3: delete redundant macro hnae3_dev_tqp_txrx_indep_supported
>   net: hns3: modify macro hnae3_dev_hw_pad_supported
>   net: hns3: modify macro hnae3_dev_stash_supported
>   net: hns3: modify macro hnae3_dev_pause_supported
> 
>  drivers/net/ethernet/hisilicon/hns3/hnae3.h   | 55 +++++++++----------
>  .../hns3/hns3_common/hclge_comm_cmd.c         |  2 +-
>  .../hns3/hns3_common/hclge_comm_cmd.h         |  3 -
>  .../ethernet/hisilicon/hns3/hns3_debugfs.c    |  2 +-
>  .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 10 ++--
>  .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 14 ++---
>  .../hisilicon/hns3/hns3pf/hclge_debugfs.c     |  2 +-
>  .../hisilicon/hns3/hns3pf/hclge_main.c        | 38 ++++++-------
>  .../hisilicon/hns3/hns3pf/hclge_ptp.c         |  2 +-
>  .../hisilicon/hns3/hns3vf/hclgevf_main.c      |  2 +-
>  10 files changed, 62 insertions(+), 68 deletions(-)
> 
> -- 
> 2.33.0
> 
