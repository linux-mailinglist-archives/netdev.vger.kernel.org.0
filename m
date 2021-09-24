Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B41184179FE
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 19:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344641AbhIXRt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 13:49:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344543AbhIXRtZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 13:49:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F22E61076;
        Fri, 24 Sep 2021 17:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632505672;
        bh=jwGq3T9SWUtbKc9Gjb5uspuKUEIlvFqf7Wf6LwvoktQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z9PBRhpNBbzXPxtGSlpKiGU2zCvGnZF/BjaXR/YTMHF7G0YsMhlbyeLyLNkgzB/HN
         kIiPmWIrXoi0K9X+Eecbw7PlSU6zAnA1o4wVpqmPpJQIuW0raSxMDp5W04DsLXSK1J
         qDlMBvWRTiP3WlOk4eAoukisuELwQ5D2QYRKhb2xQtrSQHEtjCrptg56ZLTyGciqwI
         fFm4efqerO8XqVfGmsK9w4dr9lOv70X9j4SfdnZSpmoEkmh1Y3mBSk4SLeFDAR9Oec
         9kU0fRvrW8utdNo098NiDnlyvlzsHjjp4hBueMKM8OA7eK7iXLdqHPYFLd164BZKj6
         XhgRJtmqX/qMQ==
Date:   Fri, 24 Sep 2021 10:47:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     <davem@davemloft.net>, <mkubecek@suse.cz>, <andrew@lunn.ch>,
        <amitc@mellanox.com>, <idosch@idosch.org>, <danieller@nvidia.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <jdike@addtoit.com>, <richard@nod.at>,
        <anton.ivanov@cambridgegreys.com>, <netanel@amazon.com>,
        <akiyano@amazon.com>, <gtzalik@amazon.com>, <saeedb@amazon.com>,
        <chris.snook@gmail.com>, <ulli.kroll@googlemail.com>,
        <linus.walleij@linaro.org>, <jeroendb@google.com>,
        <csully@google.com>, <awogbemila@google.com>, <jdmason@kudzu.us>,
        <rain.1986.08.12@gmail.com>, <zyjzyj2000@gmail.com>,
        <kys@microsoft.com>, <haiyangz@microsoft.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <doshir@vmware.com>,
        <pv-drivers@vmware.com>, <jwi@linux.ibm.com>,
        <kgraul@linux.ibm.com>, <hca@linux.ibm.com>, <gor@linux.ibm.com>,
        <johannes@sipsolutions.net>, <netdev@vger.kernel.org>,
        <lipeng321@huawei.com>, <chenhao288@hisilicon.com>,
        <linux-s390@vger.kernel.org>
Subject: Re: [PATCH V2 net-next 3/6] ethtool: add support to set/get rx buf
 len via ethtool
Message-ID: <20210924104750.48ad3692@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210924142959.7798-4-huangguangbin2@huawei.com>
References: <20210924142959.7798-1-huangguangbin2@huawei.com>
        <20210924142959.7798-4-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Sep 2021 22:29:56 +0800 Guangbin Huang wrote:
> @@ -621,9 +631,13 @@ struct ethtool_ops {
>  				struct kernel_ethtool_coalesce *,
>  				struct netlink_ext_ack *);
>  	void	(*get_ringparam)(struct net_device *,
> -				 struct ethtool_ringparam *);
> +				 struct ethtool_ringparam *,
> +				 struct ethtool_ringparam_ext *,
> +				 struct netlink_ext_ack *);
>  	int	(*set_ringparam)(struct net_device *,
> -				 struct ethtool_ringparam *);
> +				 struct ethtool_ringparam *,
> +				 struct ethtool_ringparam_ext *,
> +				 struct netlink_ext_ack *);

You need to make the driver changes together with this chunk.
Otherwise the build will be broken between the two during bisection.
