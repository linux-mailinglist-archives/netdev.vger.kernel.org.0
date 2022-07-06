Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15200567B9C
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 03:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiGFBnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 21:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiGFBnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 21:43:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DD0A471;
        Tue,  5 Jul 2022 18:43:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B89ECB81993;
        Wed,  6 Jul 2022 01:43:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45A3C341C7;
        Wed,  6 Jul 2022 01:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657071808;
        bh=FeocsbBNEux4TLsbBgpQ6iqCVmXecDKwhz0U3RuyrXM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NJN//NCpFlc0g1LDc61E4av/zed0QXQXOYBs3Sj4IDW/Jy3duyUvj1nPnbL2uNRTL
         ktaaz/kVmRy9OBih96C+UZGDmr7+bsz0O2KepaaB0Wiq8Xv/kWVjfAXygnfDRen5Uq
         QOcG8oCysLIZuGWfrAlfihlrKgVD8E/ojH0tBlXLfG0sNB5LNhiyV2mWLG9jkVlC0K
         MTEivJghg4mRRKMvLcJ3H1jA93fUNHH14UG6Xi57PbOvjnuAKExsxLHYz21dg7UI4t
         eSdgRaIYYtZmrGLUZcACJ+Qr8ANahL39UC9Xplq97D3hG8tANEWX4UAc+aGf17AXBe
         0u+F3CHEm6Ckw==
Date:   Tue, 5 Jul 2022 18:43:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
Subject: Re: [PATCH net-next] net/sched: remove return value of
 unregister_tcf_proto_ops
Message-ID: <20220705184326.649a4e04@kernel.org>
In-Reply-To: <20220704124322.355211-1-shaozhengchao@huawei.com>
References: <20220704124322.355211-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 4 Jul 2022 20:43:22 +0800 Zhengchao Shao wrote:
> Return value of unregister_tcf_proto_ops is useless, remove it.

s/useless/unused/ ?

Should we add a WARN if the ops getting removed can't be found or there
are callers which depend on handling unregistered ops without a warning?
