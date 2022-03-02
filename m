Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B37B24C9B0F
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 03:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239044AbiCBCPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 21:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233943AbiCBCPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 21:15:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E37CA6476;
        Tue,  1 Mar 2022 18:15:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A00AB81EF4;
        Wed,  2 Mar 2022 02:14:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 639DEC340EE;
        Wed,  2 Mar 2022 02:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646187297;
        bh=9pvrzJsTQc1+kpXew6pVudNtyCN7dFOr33TlfTRA5MI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EZZ7IU1/sbdfwBIK9m/aTzbhrlEceYi7Oq086hyn5s5hyX58aQ2Gn6wYXXfeQQgg8
         Hj1IvW/xHRGfsaOppGXqeNmaeu8ismKd/5XYUq3rKpxbujjsK2nvdp0Hf/ljYPPdcY
         ax/jaC7XPkpEJeZrvBK8XUHR2CHq1yy4koWjDTaiiCV02FcaMD4fvK9gfZj7jNjpLK
         ylQuD+w0gYMw30fbRji8O9MRvPgQPYYnM20uffAYhDElYjbhtLB9x/2mMOgIih17gy
         rYVqZe81UeomIoAXAhh0fA5kQhU6lXlSV2ZKOsJj3VxvK8ujZ5h7WJXLDZqKN76r8x
         l0xcGKEsFYtAA==
Date:   Tue, 1 Mar 2022 18:14:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Q1IQ <fufuyqqqqqq@gmail.com>
Cc:     ioana.ciornei@nxp.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lyz_cs@pku.edu.cn
Subject: Re: [PATCH] dpaa2 ethernet switch driver: Fix memory leak in
 dpaa2_switch_acl_entry_remove()
Message-ID: <20220301181456.3678a4b0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220301092450.42523-1-fufuyqqqqqq@gmail.com>
References: <20220301092450.42523-1-fufuyqqqqqq@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Mar 2022 17:24:50 +0800 Q1IQ wrote:
> @@ -182,6 +183,7 @@ dpaa2_switch_acl_entry_remove(struct dpaa2_switch_filter_block *block,
>  			 DMA_TO_DEVICE);
>  	if (err) {
>  		dev_err(dev, "dpsw_acl_remove_entry() failed %d\n", err);
> +		kfree(cmd_buff);
>  		return err;
>  	}

Same comments apply to this patch as to the other patch you sent.
