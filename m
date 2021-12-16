Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F092D477704
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 17:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238893AbhLPQIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 11:08:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53468 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238943AbhLPQIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 11:08:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E820B61E8D;
        Thu, 16 Dec 2021 16:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C0FC36AE4;
        Thu, 16 Dec 2021 16:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639670930;
        bh=3KxkF/ZqZ4ahlQR47wiwqxVbEXQUbtGMU5LaCAgj8KA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pnrbd9u1FSZzygZRQMPGwZQ3Clb8DjT1qiICVXwOZ0P+87+M/mma4ERq6ebVuFG4z
         qpNcCMU6EmCyakpissutysLfXHS2ROI6CzCFqZsA/40vDv0TmxgC1hmmWg0vU2NpIs
         WtGLlTASTy0bXMznE6ijVStIdYj8TF5UOhqEACZxEjd8HEK7SXdJSKlzpD/e2NhcEX
         14rpvj/1SNS8W7ZxBt+qgPtzF8zQ1AcS1C+jgmVrsoWoPX6mDYuqYbQPu14bLiDlrI
         98fV2qD5tT6XiX/8I4T22cklVZfMN5ZIcwCjSKMCMFKOGlBjBx6lOCbcWzEcFiIj9K
         zrZHsxGewagrg==
Date:   Thu, 16 Dec 2021 08:08:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, mickeyr@marvell.com,
        serhiy.pshyk@plvision.eu, taras.chornyi@plvision.eu,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: prestera: flower template support
Message-ID: <20211216080849.714c3707@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1639562850-24140-1-git-send-email-volodymyr.mytnyk@plvision.eu>
References: <1639562850-24140-1-git-send-email-volodymyr.mytnyk@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Dec 2021 12:07:30 +0200 Volodymyr Mytnyk wrote:
> From: Volodymyr Mytnyk <vmytnyk@marvell.com>
> 
> Add user template explicit support. At this moment, max
> TCAM rule size is utilized for all rules, doesn't matter
> which and how much flower matches are provided by user. It
> means that some of TCAM space is wasted, which impacts
> the number of filters that can be offloaded.
> 
> Introducing the template, allows to have more HW offloaded
> filters by specifying the template explicitly.
> 
> Example:
>   tc qd add dev PORT clsact
>   tc chain add dev PORT ingress protocol ip \
>     flower dst_ip 0.0.0.0/16
>   tc filter add dev PORT ingress protocol ip \
>     flower skip_sw dst_ip 1.2.3.4/16 action drop
> 
> NOTE: chain 0 is the default chain id for "tc chain" & "tc filter"
>       command, so it is omitted in the example above.
> 
> This patch adds only template support for default chain 0 suppoerted
> by prestera driver at this moment. Chains are not supported yet,
> and will be added later.
> 
> Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>

This was applied to net-next.
