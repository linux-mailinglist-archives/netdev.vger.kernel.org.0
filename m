Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9EC611675
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 17:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiJ1P5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 11:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiJ1P4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 11:56:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3980213458;
        Fri, 28 Oct 2022 08:56:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80A466294B;
        Fri, 28 Oct 2022 15:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C62C433B5;
        Fri, 28 Oct 2022 15:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666972612;
        bh=OQlTNs6K9RM2r9cG36xI9/3B4VZTynlfkDdsy479UoA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XDXpagv1gK5e2p7R3YmxvrN7nVeWQNNriakbXhioYA7CfJ/cRJaD1tVuUtYtrg1ti
         PGWyFkO5WBOcrpD4zmhwBXleFBWQhfB37RLVF98zhH/fyw6VHEYDw6c/SB6yCLBDMh
         ByAuSbdMlX5ulSutcSQnXK1IgRU66EAqccOQLaTTUIT9y2EPpzTb7snUlB+vnOFiqI
         BFFs44EpIqKqqyXnh/xeMXSTqdcRsKGSne7MZn9PehlA0+BSsOOqrdk2vXywTxa7Rv
         QMZXLbDmcxp0dLTPLJiY0NMthTtOzinYBV92Dz2jMgb4hiN8eCFkf8jVw4d4V88twC
         foUC6MGKtPidA==
Date:   Fri, 28 Oct 2022 08:56:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cai Huoqing <cai.huoqing@linux.dev>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        Bin Chen <bin.chen@corigine.com>,
        Krzysztof =?UTF-8?B?V2lsY3p5xYRza2k=?= <kw@linux.com>,
        Peter Chen <peter.chen@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: hinic: Add control command support for VF PMD
 driver in DPDK
Message-ID: <20221028085651.78408e2c@kernel.org>
In-Reply-To: <20221028045655.GB3164@chq-T47>
References: <20221026125922.34080-1-cai.huoqing@linux.dev>
        <20221026125922.34080-2-cai.huoqing@linux.dev>
        <20221027110312.7391f69f@kernel.org>
        <20221028045655.GB3164@chq-T47>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Oct 2022 12:56:55 +0800 Cai Huoqing wrote:
> > The commands are actually supported or you're just ignoring them
> > silently?  
> No, 

Do you mean "neither"?

> if the cmd is not added to 'nic_cmd_support_vf',
> the PF will return false, and the error messsage "PF Receive VFx
> unsupported cmd x" in the function 'hinic_mbox_check_cmd_valid',
> then, the configuration will not be set to hardware.

You're describing the behavior before the patch?

After the patch the command is ignored silently, like I said, right?
Because there is no handler added to nic_vf_cmd_msg_handler[].
Why is that okay? Or is there handler somewhere else?
