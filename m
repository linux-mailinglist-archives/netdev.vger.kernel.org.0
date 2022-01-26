Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E5649C258
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 04:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237371AbiAZDzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 22:55:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237323AbiAZDzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 22:55:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D7B4C06161C;
        Tue, 25 Jan 2022 19:55:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A6576179E;
        Wed, 26 Jan 2022 03:55:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DDCC340E3;
        Wed, 26 Jan 2022 03:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643169310;
        bh=AdEQx6P4XOBwro+VlIIWa9C4GWuLQlwyRfT0o/UMBBw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=soYWJX0dTeTt9uaUa8Axn5HWVHMlOOEyPB5ZSYgJiJwv1RUeJeom11HhFHZZ1PXzd
         /fdlOGq9qUZq9SinSAHDiIjoYmHYjFHdQtifRmTB+Giczotv3DTZyIW7TQBtYpN0Zp
         9XB6yyxfUXRExiJZAiP+y7uWn7ZWd2YWfmVOHo8Va9rdK67P+tvPVf91fsl+ypvRDh
         oqYZHfbqVBwCLiYoEkBwe/KqUIFi+mI0fXkral0kEpY1BR1nm/9knunscRpVTupyb9
         N8ifhVtThqh1ERqv0RTEqdxHWTirjJlAIQFo6kexMa9w7VF1BDbuxwZoe9TXt6mK0m
         YOjpI6iD6Nnbg==
Date:   Tue, 25 Jan 2022 19:55:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <wangjie125@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>
Subject: Re: [RESEND PATCH net-next 2/2] net: hns3: add ethtool priv-flag
 for TX push
Message-ID: <20220125195508.585b0c40@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220125072149.56604-3-huangguangbin2@huawei.com>
References: <20220125072149.56604-1-huangguangbin2@huawei.com>
        <20220125072149.56604-3-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jan 2022 15:21:49 +0800 Guangbin Huang wrote:
> From: Yufeng Mo <moyufeng@huawei.com>
> 
> Add a control private flag in ethtool for enable/disable
> TX push feature.

I think it's a pretty standard feature for NICs which also support RDMA.
Mellanox/nVidia has it (or at least it the previous gen HW did),
Broadcom's bnxt driver does it as well.

Can we make this a standard knob via ethtool? Not entirely sure under
which switch, maybe it's okay to add it under -g? Perhaps we need a new
command similar to -k but for features contained entirely to the driver?
