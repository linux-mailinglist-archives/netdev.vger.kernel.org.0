Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D13A45D5AF
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 08:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235766AbhKYHrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 02:47:04 -0500
Received: from mail-dm6nam11on2054.outbound.protection.outlook.com ([40.107.223.54]:62561
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236244AbhKYHpE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 02:45:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jOZTMUxbe4mC/A7NPii+YlXld6eAq9loAy+oKcHjRgBuV/DQiaPE2p0NmmH77IPBVsXFwvKANGdx8vaM/UIZOALPvXunTsz7ImrXa3P7HFUgtQXr07LXnYKqGv/6FXoH1a1lBGBJshHcZF0AZd3vwIFgpkDiIsfjSgwtWrGEUTMq6+1AzBv0X1ELYu37p42fA0Q21lpHlLhwrAqyZ1z2Pn5vVxoVybDIbe5XZeCLFulfBN0xdAdIGwa45PRmvIF5lRLstjc3VchhUFie4bF1MeaCPhcAtqS80coL+cYplhNWpNB5jIoAD27YA9HcVk7erCEgPv3iWXKHEO5sXhxd4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SXP3PPdMbzLEMJkWmISLQpoe04QES7HQ4Y0wVr/bEV8=;
 b=KVBKrJ1NxE613ZAp+xRRnev4zL0p0TK6B1oF3y6gJEPh5QmCDbKxQFdzmBxE9eLfLbkgkQkvtA+p3lrDLnAxr3brM50RqwsjdHYvIUvQSNKfvluJBoI8VfeEWtKZpwxHXXIPv06X4Y1y6Wawgi0lz9wh4AMqGz+CZUDmG41G9seI4VMrpKCex73hqUJ4I+7TwtdS85R3XMlI73lf8c+LYgmiVycYh5AKKCJsiPy3yLoyq5GnqVnM4idsyIEralnwfraC0gzSih4YN90FJNyt9Ov2J2TZL3oYLf7qBwZinP1Ui/b14GlBDrun9cFACgr/ZbhLuuo/VMdtkmor9lUMqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SXP3PPdMbzLEMJkWmISLQpoe04QES7HQ4Y0wVr/bEV8=;
 b=a0+bBA/ED7yqzwVbXSaNqhREWa3873sCmFpyZ1i6N9X2AJ/b4Hopwk7+amRM2wPOd6XczYHvPbk3fmUi9Jzv0S3CfNtWn2zdPMgGAQRAtst0CcQLfJeqECOZEI1+tEIOQGhgsgxsngh1REDEu76UsN9L0kBh2+wcD0mssXwCZjDAyMvB7GQHY9H2a3v9vBSwZ1czVfLMzS7qlyoPVc+2TPkXTXJmxNPM2PEeChXGsiGOpgfqVSpbF0/tpSPAJq2dOvXBckYjWkn2AsfY+PTdeKKXFnl2qPTXu7jADdRIslnPBndMi2C1lXynZFByc5EW0KXNX6s7sVSmCjL7vwTmcA==
Received: from MWHPR14CA0063.namprd14.prod.outlook.com (2603:10b6:300:81::25)
 by MN2PR12MB3791.namprd12.prod.outlook.com (2603:10b6:208:167::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Thu, 25 Nov
 2021 07:41:51 +0000
Received: from CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:81:cafe::84) by MWHPR14CA0063.outlook.office365.com
 (2603:10b6:300:81::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.19 via Frontend
 Transport; Thu, 25 Nov 2021 07:41:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT015.mail.protection.outlook.com (10.13.175.130) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 07:41:50 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.187.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Thu, 25 Nov 2021 07:41:48 +0000
Date:   Thu, 25 Nov 2021 09:41:45 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] virtio-net: enable big mode correctly
Message-ID: <20211125074145.GA214101@mtl-vdi-166.wap.labs.mlnx>
References: <20211125060547.11961-1-jasowang@redhat.com>
 <20211125070939.GC211101@mtl-vdi-166.wap.labs.mlnx>
 <CACGkMEsNsQ_XWTvdjaCEdo8sYaLew24zU1UUCJrokM-Koxj4fw@mail.gmail.com>
 <20211125072040.GA213301@mtl-vdi-166.wap.labs.mlnx>
 <CACGkMEuYWoL4x5o_OO2a27X4Ah8Y2ggBjy0XFHe3Onmj4RhFFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CACGkMEuYWoL4x5o_OO2a27X4Ah8Y2ggBjy0XFHe3Onmj4RhFFg@mail.gmail.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e420aa33-983a-4b97-e237-08d9afe70af3
X-MS-TrafficTypeDiagnostic: MN2PR12MB3791:
X-Microsoft-Antispam-PRVS: <MN2PR12MB3791F39E78435CEAC9152B38AB629@MN2PR12MB3791.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j5s4nGGKIh3NEI4iF+Kv93r8Af6y3Oob1RNQr0gSudXte23uV7pshRxxx7Tce377eOlzyJtaro0nWGEcN096k037pdjRG6ozxiIS/Aglo1nVmKTW4wXrCyC7YEbkIbHDUUOBq8Bz6w0GveBrAPEuoBln6C2DOPsYTiXuN9UfhD7RTNbGLRpJycIA9rdS6MiNP82jHpJ6ovMROqW0B0VPoi8srdURSgOiv0U525xNOYXKRmG0Xx6uoC/tF0ndBUV6E14m07GVwR8DC3KD19l3xlj3XO6M7sKrWOPKCEZgm1ZXirrLDtc/+SLs+FBO5ox6Ni6dw6N/3nOPBSf/BlNr/8PGWURfyYF/jOUkRlpjIrUXy9jv1Xm5Uq+i6PSip3dYnuI9rIWsKQ4O7H8V0g9HzoiwJD9NPWQYQ3qMePnZT3lLSivWSp2XI1gD1EOEszOzaYjTJhv6vyJ2o2Vk7VcuJqug/1Wm9z37ozM2VLyHwfbvV6YNu6P9JIEgX9MriEoMan9XOfq19067Ytkkxo8k5yioUs+ilaIWaLrNP6LxuMIaZ15Ctjezp+2xBXwhmj0oER9+V39TPHDE8Ho2lWy6r5WCotl1wiyTYlwgoc1koUgXNwWDfhtEMZIXFGOzvll4QfT3hyegl7+Mt/W7culWRXIy+nYLqqOKzdWdxpZz8MGZ29n78DXlG59FFlJv81FbvWVYZgR6Fx0yvgZtQofYxw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(4326008)(356005)(2906002)(70586007)(6916009)(1076003)(508600001)(7636003)(8676002)(316002)(82310400004)(55016003)(336012)(53546011)(26005)(47076005)(186003)(16526019)(54906003)(426003)(7696005)(33656002)(8936002)(5660300002)(6666004)(86362001)(9686003)(83380400001)(36860700001)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 07:41:50.4527
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e420aa33-983a-4b97-e237-08d9afe70af3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3791
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 03:26:22PM +0800, Jason Wang wrote:
> On Thu, Nov 25, 2021 at 3:20 PM Eli Cohen <elic@nvidia.com> wrote:
> >
> > On Thu, Nov 25, 2021 at 03:15:33PM +0800, Jason Wang wrote:
> > > On Thu, Nov 25, 2021 at 3:09 PM Eli Cohen <elic@nvidia.com> wrote:
> > > >
> > > > On Thu, Nov 25, 2021 at 02:05:47PM +0800, Jason Wang wrote:
> > > > > When VIRTIO_NET_F_MTU feature is not negotiated, we assume a very
> > > > > large max_mtu. In this case, using small packet mode is not correct
> > > > > since it may breaks the networking when MTU is grater than
> > > > > ETH_DATA_LEN.
> > > > >
> > > > > To have a quick fix, simply enable the big packet mode when
> > > > > VIRTIO_NET_F_MTU is not negotiated. We can do optimization on top.
> > > > >
> > > > > Reported-by: Eli Cohen <elic@nvidia.com>
> > > > > Cc: Eli Cohen <elic@nvidia.com>
> > > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > > ---
> > > > >  drivers/net/virtio_net.c | 7 ++++---
> > > > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > > > >
> > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > index 7c43bfc1ce44..83ae3ef5eb11 100644
> > > > > --- a/drivers/net/virtio_net.c
> > > > > +++ b/drivers/net/virtio_net.c
> > > > > @@ -3200,11 +3200,12 @@ static int virtnet_probe(struct virtio_device *vdev)
> > > > >               dev->mtu = mtu;
> > > > >               dev->max_mtu = mtu;
> > > > >
> > > > > -             /* TODO: size buffers correctly in this case. */
> > > > > -             if (dev->mtu > ETH_DATA_LEN)
> > > > > -                     vi->big_packets = true;
> > > > >       }
> > > > >
> > > > > +     /* TODO: size buffers correctly in this case. */
> > > > > +     if (dev->max_mtu > ETH_DATA_LEN)
> > > > > +             vi->big_packets = true;
> > > > > +
> > > >
> > > > If VIRTIO_NET_F_MTU is provided, then dev->max_mtu is going to equal
> > > > ETH_DATA_LEN (will be set in ether_setup()) so I don't think it will set
> > > > big_packets to true.
> > >
> > > I may miss something, the dev->max_mtu is just assigned to the mtu
> > > value read from the config space in the code block above  (inside the
> > > feature check of VIRTIO_NET_F_MTU).
> >
> > Sorry, I meant "If VIRTIO_NET_F_MTU is ***NOT*** provided". In that case
> > dev->max_mtu eauals ETH_DATA_LEN so you won't set vi->big_packets to
> > true.
> 
> I see but in this case, the above assignment:
> 
>         /* MTU range: 68 - 65535 */
>         dev->min_mtu = MIN_MTU;
>         dev->max_mtu = MAX_MTU;
> 
> happens after alloc_etherdev_mq() which calls ether_setup(), so we are
> probably fine here.
> 

I see, thanks.

> Thanks
> 
> >
> > >
> > > Thanks
> > >
> > > >
> > > >
> > > > >       if (vi->any_header_sg)
> > > > >               dev->needed_headroom = vi->hdr_len;
> > > > >
> > > > > --
> > > > > 2.25.1
> > > > >
> > > >
> > >
> >
> 
