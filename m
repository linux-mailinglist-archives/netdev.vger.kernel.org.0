Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C953A2C1504
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 21:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729171AbgKWUD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 15:03:58 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17000 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbgKWUDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 15:03:54 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fbc15a70004>; Mon, 23 Nov 2020 12:03:51 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 23 Nov
 2020 20:03:49 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 23 Nov 2020 20:03:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gITd84wMHHzcOptjQRg1Bi4wKYLoloErjGXTzbxbsYYxXpRm6DfDjP1G8JsqPPruG8n8djHpWT3ChykgCoTQdTlPHkj05TPw7WZ4Y46HlI8bprZC3XuF3n009Te/qaTwPxc9ef3s3wxgnUStlvtZrJvP5WQhh3MIKLFTGEWjhLXWcgs1VmoV9q6ndrBwWgPhsRBIC9rKh9qqm9cf9Ujr9sks/ml2cZ4bW16uPSJVifE1ke5RuUikXPZ60YcpNVw15sbmeBPfJ8v059YAkVfr8AOpsBgi+OymMySTg/JYVNFtVJ2pGo3M9pC5txLp474ztgTCR2D9RfvqUQOXT+42RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QophqWBVIGhmInjMMmoN1JCz5yEuED07MVw87J8AVUY=;
 b=dpOj+p56VpZQgFejSTc+TjZx9PpIbmIlWcJPfXyA8QiV6hyerQ1PNIg37pZm/OoPMM7dRNU+MPO2Sxmva5Z6iKtLQpQNkcM79tS52of8WjxHEmReB+Qc/VB0gzy26dU2FtXMoEzn5Rx6YHRp97uhlWeSk7Nsi1BUrieORD+G9yqkgKBmwQvC726s6EkJ0s32uNc7iMGffyCjKbyBtSLggJX9G9WEJ0m0GYQlYWRE7aVXL+Iy16bXoksvn7nW7YXP74v45GAqxPt7EElquzCZ4kXurFfWXXWM9ThsUobGLm/yb7wWVAmTEM+ttWZwc1mR7P3I+RsId2H9o2Xiqq+zAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4338.namprd12.prod.outlook.com (2603:10b6:5:2a2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21; Mon, 23 Nov
 2020 20:03:48 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::e40c:730c:156c:2ef9]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::e40c:730c:156c:2ef9%7]) with mapi id 15.20.3589.022; Mon, 23 Nov 2020
 20:03:48 +0000
Date:   Mon, 23 Nov 2020 16:03:45 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <amd-gfx@lists.freedesktop.org>,
        <bridge@lists.linux-foundation.org>, <ceph-devel@vger.kernel.org>,
        <cluster-devel@redhat.com>, <coreteam@netfilter.org>,
        <devel@driverdev.osuosl.org>, <dm-devel@redhat.com>,
        <drbd-dev@lists.linbit.com>, <dri-devel@lists.freedesktop.org>,
        <GR-everest-linux-l2@marvell.com>, <GR-Linux-NIC-Dev@marvell.com>,
        <intel-gfx@lists.freedesktop.org>,
        <intel-wired-lan@lists.osuosl.org>, <keyrings@vger.kernel.org>,
        <linux1394-devel@lists.sourceforge.net>,
        <linux-acpi@vger.kernel.org>, <linux-afs@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-atm-general@lists.sourceforge.net>,
        <linux-block@vger.kernel.org>, <linux-can@vger.kernel.org>,
        <linux-cifs@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-decnet-user@lists.sourceforge.net>,
        <linux-ext4@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-geode@lists.infradead.org>, <linux-gpio@vger.kernel.org>,
        <linux-hams@vger.kernel.org>, <linux-hwmon@vger.kernel.org>,
        <linux-i3c@lists.infradead.org>, <linux-ide@vger.kernel.org>,
        <linux-iio@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-integrity@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-media@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-mtd@lists.infradead.org>,
        <linux-nfs@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-renesas-soc@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux-sctp@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-usb@vger.kernel.org>, <linux-watchdog@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <nouveau@lists.freedesktop.org>,
        <op-tee@lists.trustedfirmware.org>, <oss-drivers@netronome.com>,
        <patches@opensource.cirrus.com>, <rds-devel@oss.oracle.com>,
        <reiserfs-devel@vger.kernel.org>,
        <samba-technical@lists.samba.org>, <selinux@vger.kernel.org>,
        <target-devel@vger.kernel.org>,
        <tipc-discussion@lists.sourceforge.net>,
        <usb-storage@lists.one-eyed-alien.net>,
        <virtualization@lists.linux-foundation.org>,
        <wcn36xx@lists.infradead.org>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>,
        <linux-hardening@vger.kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Miguel Ojeda <ojeda@kernel.org>, Joe Perches <joe@perches.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 000/141] Fix fall-through warnings for Clang
Message-ID: <20201123200345.GA38546@nvidia.com>
References: <cover.1605896059.git.gustavoars@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
X-ClientProxiedBy: MN2PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:208:23a::18) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR03CA0013.namprd03.prod.outlook.com (2603:10b6:208:23a::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Mon, 23 Nov 2020 20:03:47 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1khI3t-000A35-Tb; Mon, 23 Nov 2020 16:03:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606161831; bh=QophqWBVIGhmInjMMmoN1JCz5yEuED07MVw87J8AVUY=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType;
        b=Zr1EZlr7FGouweCXJ2A3YJZ8lxsTazMwmiIDkNNgeYuPc4M3hA0h9guNHLXrnnLeX
         Dp0jtpGLpYuZZsYit0m8+Y/3Pgk+U78P2KDuhjfei0oh+kHbQnRfzB2jD1Wu7rVyZ8
         A2iuCgvA8hhwNVx8Bo/l4LfRAECKvf8eJj6um7c8+wyJ6oFgyijvPixB8Xcq6YNTLj
         o7o09Zdo2SkPJV9Ld82VvGAW1KENwGx8qxL8L4kHw5xGizl/kk/4FLfOCs8mx17bXD
         N2PIS7AsaPoH2bHogxWrZ7vcH6YOCMGYKk/oZQ1BhSoaDoH96AMZAs9BCirfcyYEMq
         3EMRDyReptNPA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 12:21:39PM -0600, Gustavo A. R. Silva wrote:

>   IB/hfi1: Fix fall-through warnings for Clang
>   IB/mlx4: Fix fall-through warnings for Clang
>   IB/qedr: Fix fall-through warnings for Clang
>   RDMA/mlx5: Fix fall-through warnings for Clang

I picked these four to the rdma tree, thanks

Jason
