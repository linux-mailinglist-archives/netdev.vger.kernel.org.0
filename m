Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19C5A59EEDD
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 00:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbiHWWQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 18:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234372AbiHWWQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 18:16:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1DFEB868
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 15:13:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57C5D616A9
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 22:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DD1C433D7;
        Tue, 23 Aug 2022 22:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661292836;
        bh=Prhox3lhzPWb536NCkfodNU7o6Jkqz6iVRb8D/4bAKw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hXqUHX6V4Db4DDJKmkdLlzwQ9W3SGu4V6E5vzVEGZooUSF3qTUTwehxOWzWg+3QWV
         7suuOVQsoeSaVMFaibKwkAxAwlIoEQCuvDNVszuoTj2wbNQdsHdatmr4PoqeFsdrgE
         FonjaboEmLQoxDnHOa7T3D5mnQq/tOKdetpesVmV/VWTKI5VWeZj6BWgIqbbWYJZcl
         3p3YP8RKjdKb1x/sPP5oxK50NSfHlbhLbMHdOf4DdVFYU4ixs+ehkQi4OcOwnPDmT2
         hzD9YUdiqqt0whiJVU08vX/Paqvlk0c6ZiSKSrTJup6lJSKqM2YflMPszYgbaxVJOr
         IMcJATvbwNI9w==
Date:   Tue, 23 Aug 2022 15:13:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Dimitris Michailidis <dmichail@fungible.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Shannon Nelson <snelson@pensando.io>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Fei Qin <fei.qin@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Yu Xiao <yu.xiao@corigine.com>,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
        <u.kleine-koenig@pengutronix.de>, Yufeng Mo <moyufeng@huawei.com>,
        Sixiang Chen <sixiang.chen@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Erik Ekman <erik@kryo.se>, Ido Schimmel <idosch@nvidia.com>,
        Jie Wang <wangjie125@huawei.com>,
        Moshe Tal <moshet@nvidia.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Marco Bonelli <marco@mebeim.net>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: Re: [PATCH net-next 1/2] ethtool: pass netlink extended ACK to
 .set_fecparam
Message-ID: <20220823151354.4becbfe7@kernel.org>
In-Reply-To: <20220823150438.3613327-2-jacob.e.keller@intel.com>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
        <20220823150438.3613327-2-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Aug 2022 08:04:37 -0700 Jacob Keller wrote:
> Add the netlink extended ACK structure pointer to the interface for
> .set_fecparam. This allows reporting errors to the user appropriately when
> using the netlink ethtool interface.

Could you wrap it into a structure perhaps?

Would be good if we didn't have to modify the signature of the callback
next time we need to extend it (especially since struct ethtool_fecparam
is ioctl uABI so we can't really add fields there).
