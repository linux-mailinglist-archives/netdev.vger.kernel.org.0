Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B156239CC
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 03:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbiKJCbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 21:31:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiKJCbx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 21:31:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C663B4AB;
        Wed,  9 Nov 2022 18:31:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06BDEB82061;
        Thu, 10 Nov 2022 02:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C617AC433D6;
        Thu, 10 Nov 2022 02:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668047509;
        bh=OkRdl99qH3PlyIOCHROPggipykp7UbLjsi5lijqpHCs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qYcy75shETSi0WSpHbRrV2i26r33+Kw/WLE0Aq+NWDfv1l2TO+uOMRINtZXL8N4IO
         TrpICNNfDAc+yBMenzKJmw6xOD51soUfTqz1LpDVVa56i49scGLlCX2ccxU+PV2aTD
         5wiGBuSi7VEALK6WrdKQhKWLzerlPILFbtzeeEFqEkGWwb75LsImS0Vfk0jFTOVTEg
         ZLArUfB4GY8CrFSnh6lTF4nKSR4C29Mp1ohP2dv/8OdXZr459Tl/+PeCDfweMKbOdo
         xpJC2pe/RqyT/yU5VlKjGq46+80BG8fUYQR87Q7f3kP1imzDMsKZVuAponNloh8lKP
         m3OGLRbu7ShIA==
Date:   Wed, 9 Nov 2022 18:31:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     <linux-omap@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <grygorii.strashko@ti.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <chi.minghao@zte.com.cn>,
        <mkl@pengutronix.de>, <wsa+renesas@sang-engineering.com>,
        <ardb@kernel.org>, <yangyingliang@huawei.com>,
        <mugunthanvnm@ti.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>
Subject: Re: [PATCH net] net: cpsw: disable napi in cpsw_ndo_open()
Message-ID: <20221109183147.17dba3ef@kernel.org>
In-Reply-To: <20221109011537.96975-1-shaozhengchao@huawei.com>
References: <20221109011537.96975-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Nov 2022 09:15:37 +0800 Zhengchao Shao wrote:
> When failed to create xdp rxqs or fill rx channels in cpsw_ndo_open() for
> opening device, napi isn't disabled. When open cpsw device next time, it
> will report a invalid opcode issue. Fix it. Only be compiled, not be
> tested.
> 
> Fixes: d354eb85d618 ("drivers: net: cpsw: dual_emac: simplify napi usage")

Nice work, not a trivial Fixes tag to zero in on, I appreciate 
the improvement :)
