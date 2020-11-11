Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE182AE5CF
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 02:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732293AbgKKBZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 20:25:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:58764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727275AbgKKBZ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 20:25:27 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A82F20825;
        Wed, 11 Nov 2020 01:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605057927;
        bh=CjreQz4Svm7D1uF1hgfEHc4Uw0YTa5E2rBYHOU23a0A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=USdCXw1rB/dGFXl0AtKrycIUQ9OB5WE5ah80eKXG0iIupk8FjEJav8TAyPuVLhvIn
         oVJ2/3g3eK6upTuzODVQFx4EE5hXhCjsZGmvJ3krUc/V+gjq5Kf2Ycvur3yEQlU4Ie
         JEJQisHu5YHBIx2Wmzlp3iTqaWOLqc4g3gKZUMog=
Date:   Tue, 10 Nov 2020 17:25:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <linuxarm@huawei.com>
Subject: Re: [PATCH V2 net-next 09/11] net: hns3: add support for EQ/CQ mode
 configuration
Message-ID: <20201110172525.250da44c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604892159-19990-10-git-send-email-tanhuazhong@huawei.com>
References: <1604892159-19990-1-git-send-email-tanhuazhong@huawei.com>
        <1604892159-19990-10-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Nov 2020 11:22:37 +0800 Huazhong Tan wrote:
> For device whose version is above V3(include V3), the GL can
> select EQ or CQ mode, so adds support for it.
> 
> In CQ mode, the coalesced timer will restart upon new completion,
> while in EQ mode, the timer will not restart.
> 
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>

Let's see if I understand - in CQ mode the timer is restarted very time
new frame gets received/transmitted? IOW for a continuous stream of
frames it will only generate an interrupt once it reaches max_frames?

I think that if you need such a configuration knob we should add this as
an option to the official ethtool -c/-C interface, now that we have the
ability to extend the netlink API.
