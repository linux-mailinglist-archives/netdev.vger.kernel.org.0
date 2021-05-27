Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADBB3934E7
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 19:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234786AbhE0RjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 13:39:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:32856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234594AbhE0RjU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 13:39:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6456B613BE;
        Thu, 27 May 2021 17:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622137067;
        bh=Irw+MU3BjYuP1C6dvrSGvPjgSbyAD0Zx9yR6o9g4Pho=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KnAd4Ie6fWQ2YKj7k4WKNckCSIOEsVUF80j8tCFzCv4JCsfDOJKPJBNvTr+CCIImE
         aIjZu7VHhyYviBlz+saqf/xdgb1nJZS1oh7p1SvCfXk85cG3Qhb6VydDWEEQHWTAEs
         muRCRlnHgCyb1Tqcu6/Gp55x4DJl8t3+vt1jY5BJeM2v3LlIVQ2qW/XdULhVpC/FPH
         F5xhBL3b5aUCJqfMEQI9C0kH1nN4ePO65UTz4rG6h9jz4PAAL3yGG3A6C+78cpc5ii
         8zw/azz0np4S5cMfP9f9Z0xd/AvbAApnH+9vu/law2y//MFB5Ilq2BhLrhZX/6Wyj/
         nT/zG14UsWv3g==
Date:   Thu, 27 May 2021 10:37:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@huawei.com>,
        <dledford@redhat.com>, <jgg@ziepe.ca>, <netanel@amazon.com>,
        <akiyano@amazon.com>, <thomas.lendacky@amd.com>,
        <irusskikh@marvell.com>, <michael.chan@broadcom.com>,
        <edwin.peer@broadcom.com>, <rohitm@chelsio.com>,
        <jesse.brandeburg@intel.com>, <jacob.e.keller@intel.com>,
        <ioana.ciornei@nxp.com>, <vladimir.oltean@nxp.com>,
        <sgoutham@marvell.com>, <sbhatta@marvell.com>, <saeedm@nvidia.com>,
        <ecree.xilinx@gmail.com>, <grygorii.strashko@ti.com>,
        <merez@codeaurora.org>, <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>
Subject: Re: [RFC net-next 2/4] ethtool: extend coalesce setting uAPI with
 CQE mode
Message-ID: <20210527103745.5005b5df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b29f05f8-3c57-ec6a-78bb-3a22f743f7f1@huawei.com>
References: <1622021262-8881-1-git-send-email-tanhuazhong@huawei.com>
        <1622021262-8881-3-git-send-email-tanhuazhong@huawei.com>
        <20210526170033.62c8e6eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <b29f05f8-3c57-ec6a-78bb-3a22f743f7f1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 May 2021 10:00:44 +0800 Huazhong Tan wrote:
> >> @@ -179,6 +179,8 @@ __ethtool_get_link_ksettings(struct net_device *dev,
> >>   
> >>   struct kernel_ethtool_coalesce {
> >>   	struct ethtool_coalesce	base;
> >> +	__u32	use_cqe_mode_tx;
> >> +	__u32	use_cqe_mode_rx;  
> > No __ in front, this is not a user space structure.
> > Why not bool or a bitfield?  
> 
> bool is enough, __u32 is used here to be consistent with
> 
> fields in struct ethtool_coalesce.
> 
> This seems unnecessary?

Yup, I think the IOCTL made everything a __u32 for uniformity 
of the uAPI and to avoid holes and paddings. This is an internal 
kernel structure so natural types like bool are better.
