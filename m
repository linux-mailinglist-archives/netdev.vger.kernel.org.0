Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8323545D533
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 08:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352333AbhKYHPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 02:15:00 -0500
Received: from mail-co1nam11on2067.outbound.protection.outlook.com ([40.107.220.67]:50241
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1352609AbhKYHNA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 02:13:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L7rzJ8J6J1He/RUolm9KHUU0J/egVX9GMgY6ruHnyfoWhbzNQxvdaZxmhKrjcS0ziv/EjhXupmYS6XkVkJ2srpU1AjwRtZQsqeoLtD8LAR52BgQ86k93otitpnLg2Do7U1pQxB+gIsdwzaul96ZSzyBFD7azz3pAxtHLE22+FFHy2vL6uCd+P/iud5OE07vzSIlynqDDCseZ7dzTkcYilYuR5SRq28Yf9bE5qsDMDudsQaIr/BYT5d2eV2g/Vga6NhiLQ+0E2y+b+JxN3CGTp80wQlBgJ+sMuDWjzfe1g/nZEJgM0NJ+1c60BYkjSw/9FTAawwBRrF1G9kyUPbVmDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P1gv3gvtvL/cQ8vavcsZ8GNiHhKgWPBOVdBOY6MUfvI=;
 b=ZAbW0dBh24VSu72fzpZgJyL8s9W/m6ZFunoGpoHVuVU59xNqFODzq3yiOXs3tw4Q0GkHNYQTVCrSYwukVam8O9caiTeJ1cs3dwOFYI+dY4Cek45qNCMEWOLWHWmZJox2FJ1btIjIkyum9vXtWsSJr8J0oM/aTjvJomjqVv0zjxDLczMLY8BgPB72c61OMIPXo9SrjfZIK6vQW1mCpwNTEpNpbMxosz4G2IlMXlFLpFpQOGdahniNm1+1eX3tGSr+liaYQnY3UdJfAWjSF05FzpK9JXsheZRPTUtLfYm+qyI9xOKi0RPpUS8/r3wfRXkosPUp1cGsvI6gsmZyuHK5GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P1gv3gvtvL/cQ8vavcsZ8GNiHhKgWPBOVdBOY6MUfvI=;
 b=hqJj+jYWrVWkddify7NkUCZubJq0CP5ucyWDTzr+bSb0Iu6xjglTrNhVB0dmItZO04rs7wtPHHdAfqQoWAn2A2DJjfcJ2W24hxy12Yo3iSiqhCDYqTHGk2YKNbqsRt3nSm2kbMG1c6viz11BETqL3iv76M0kRMp72ggTzk9a74ourMDiyg4LXEZrqDBIvkzWICei3c4IZjiPTyB07EpoF9/yA7Vv40RMd0GNE7ZS27/or+otqv5HQsfEr7YvlWxcCGQqmcR8UxD5QmXMBnLeyqGUEAcDMRHXUDgfFKzgFSftqQo7btC0hLDehS32Om6LTIG1R2R2ul40Qfd3YVcd6Q==
Received: from MW4PR03CA0086.namprd03.prod.outlook.com (2603:10b6:303:b6::31)
 by CY4PR1201MB0053.namprd12.prod.outlook.com (2603:10b6:910:23::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Thu, 25 Nov
 2021 07:09:48 +0000
Received: from CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::17) by MW4PR03CA0086.outlook.office365.com
 (2603:10b6:303:b6::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend
 Transport; Thu, 25 Nov 2021 07:09:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT034.mail.protection.outlook.com (10.13.174.248) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 07:09:48 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.187.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Thu, 25 Nov 2021 07:09:44 +0000
Date:   Thu, 25 Nov 2021 09:09:39 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     <mst@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] virtio-net: enable big mode correctly
Message-ID: <20211125070939.GC211101@mtl-vdi-166.wap.labs.mlnx>
References: <20211125060547.11961-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211125060547.11961-1-jasowang@redhat.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 203f7b97-6ab9-4fb6-c1c4-08d9afe29118
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0053:
X-Microsoft-Antispam-PRVS: <CY4PR1201MB00534D1E6BBA2B1ED90C6FF8AB629@CY4PR1201MB0053.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: igpShDDTOqWWO7qQwQFmNXbnwSoLoZ7o255s8WSgh8kOMI5lhZLis/zRV+KlE0xNvfIP5LZ37M+skoznrPLgKfJoHIv9OS54E3vutS5S4EC23HVEccU6gZ+nA9Blc2Y4guYboeXo481RfWI4kvKgUep+YYi+shn4ovzT1t+R2LV8ZNo8ne2CafTvTvaCXfDtcuh1m4MU9fFT3K9Nh2dauW+kUjx3RM8Nnwq8oPLn7X+hacCsZlsMob78t+zaWLzx5jTlNp8lornGXPFHtGLqCB/D9x48GMArgqbZnaSdK3ihnJmU9odfdnzjPQnSOmhEDrQTfYyB5afrp/RdbYFJZmhnTT6Yed7Y72R1va9vepyJzVFFw5iwZKmeOzJeGBNpb+RgAVyaSNgueueT7+3kqH2dTs4+vXfhEgZhONlV12SJW3jsIbMQ1bMHOxDaZ/QUhL21Dr4DqMQxtn9Lx5l/Z/55SUyys9P9gZzk0fOjIK/ehVkmRqnsFWjrg+xBGzU9qgjBFdpxoW4brpf0+QSmphDdbtYU3OxVqyZl2ULtqHubfNYrnmhpuIfIkvC0tLPDmyxyg2kSY8Jv0UmYPLVFhKH4Za7xZ/+NZIajr6fh1G9WnZKHqcTG4sFX18dXXM8nuqfkCJ2mq5ucY1H2YkpgXlc0BA0YzDgIGzt8tL0BRnNitKzBFe7SMP09g1N63jeA4GzHUG9lHRaEqFYtqhGRVA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(86362001)(47076005)(186003)(70206006)(508600001)(70586007)(2906002)(9686003)(55016003)(7696005)(7636003)(356005)(26005)(8936002)(336012)(36860700001)(6666004)(6916009)(5660300002)(83380400001)(8676002)(33656002)(16526019)(1076003)(316002)(426003)(82310400004)(54906003)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 07:09:48.0374
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 203f7b97-6ab9-4fb6-c1c4-08d9afe29118
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0053
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 02:05:47PM +0800, Jason Wang wrote:
> When VIRTIO_NET_F_MTU feature is not negotiated, we assume a very
> large max_mtu. In this case, using small packet mode is not correct
> since it may breaks the networking when MTU is grater than
> ETH_DATA_LEN.
> 
> To have a quick fix, simply enable the big packet mode when
> VIRTIO_NET_F_MTU is not negotiated. We can do optimization on top.
> 
> Reported-by: Eli Cohen <elic@nvidia.com>
> Cc: Eli Cohen <elic@nvidia.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/net/virtio_net.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 7c43bfc1ce44..83ae3ef5eb11 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3200,11 +3200,12 @@ static int virtnet_probe(struct virtio_device *vdev)
>  		dev->mtu = mtu;
>  		dev->max_mtu = mtu;
>  
> -		/* TODO: size buffers correctly in this case. */
> -		if (dev->mtu > ETH_DATA_LEN)
> -			vi->big_packets = true;
>  	}
>  
> +	/* TODO: size buffers correctly in this case. */
> +	if (dev->max_mtu > ETH_DATA_LEN)
> +		vi->big_packets = true;
> +

If VIRTIO_NET_F_MTU is provided, then dev->max_mtu is going to equal
ETH_DATA_LEN (will be set in ether_setup()) so I don't think it will set
big_packets to true.


>  	if (vi->any_header_sg)
>  		dev->needed_headroom = vi->hdr_len;
>  
> -- 
> 2.25.1
> 
