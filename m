Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D8D45D55B
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 08:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhKYH0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 02:26:02 -0500
Received: from mail-dm6nam11on2069.outbound.protection.outlook.com ([40.107.223.69]:29217
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229660AbhKYHX7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 02:23:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MxbxK5mLPn4un0c0E2IcLG28iQxNw5iGFhhKCRR9z3qItzavjU3I8ibzA8nq0I5D01apwT3SefDyvwLzq0jasAtx1BjpFUZ8OXZolOdTuEs2YJJExmSWIUb5PK3R80q3YetgFgLC3868ckZCSXVrnG8P7C1NtuOQ16UmUyufppbqtPx0SajXpnhnBXScztt5V5uCIKjxqNem76xT9cTmKbBOMkqrsIXq9pGZ+gObOF8gaDVQludziyaUGxgsTPwHaiX9wLdXeCoaoiuQKPJrYbBbNI2Qy/ghIDauh+FhGY2IeKHXIheJ+8lNIIOtYpatebeX6vNNsGHP7liKCb8zcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OtZzSQ9hqqXhTwp+5jLYp2tyMLOfi4HEH25vniaFIBs=;
 b=J35pBR/8Kip7m87a9K8Doy29FuBxN3AqTDrEMPi07482dIfTEeae4jCjY8f4/Tcf9OVTuS38A3/Nbwqv/YRnTv6V5hzxAK/JfjxT8GDuH7vosSc5B8FKTowrMaEFB5z5XR1zRiks+X7STD1XXSTmuPpN1pL62Zz33jBDBkjT4upigldzgDFYqENDLf1AW40dOQ/KJw4ijzheKrlLHtrAWq8oDe2hqAvjByxmZHi++TD9EzJ/sd+14Y77gHYwlmXw8sNk4AR+xcnQuL1oPNSORs/XFxnZfSO/uo43zy3zahQ6DsvNhhPgUFywjFcGR91a2XDnV2LBr3Ji+BCNxDpI4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OtZzSQ9hqqXhTwp+5jLYp2tyMLOfi4HEH25vniaFIBs=;
 b=FtYFlVNipWQb2q20qouRfoYtSEputStoMQisrdlWxkGbDE7czD7ExM4MYqID4OmpEPTSOksZQgu6WiFn/qJCy/TU4aP4D1euK0cOR/6kfxJy0ZEcChjEg84NMtjKNyt7kImacyGxUTsIh9nwbr+KX8UP3vWf6oqfGsjliIBDmvRlW4ZJL/Gf3ageo3qi1SqiF/gonuBp/DBnVKN+UWtdebLeWasU9R/MiTO19kpTwezjLa09rSLleJ3E2xfzktCyw7S+rG0vlMaNimemHhKlknoPwajErFAe7xZcHGY+Rf6LoizqEWCMzOfgV4l6meSUlgjxfAK/C9nKC44Ir+Osow==
Received: from MW4PR04CA0375.namprd04.prod.outlook.com (2603:10b6:303:81::20)
 by DM6PR12MB4500.namprd12.prod.outlook.com (2603:10b6:5:28f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Thu, 25 Nov
 2021 07:20:46 +0000
Received: from CO1NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::70) by MW4PR04CA0375.outlook.office365.com
 (2603:10b6:303:81::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24 via Frontend
 Transport; Thu, 25 Nov 2021 07:20:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT031.mail.protection.outlook.com (10.13.174.118) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4713.20 via Frontend Transport; Thu, 25 Nov 2021 07:20:46 +0000
Received: from mtl-vdi-166.wap.labs.mlnx (172.20.187.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Thu, 25 Nov 2021 07:20:43 +0000
Date:   Thu, 25 Nov 2021 09:20:40 +0200
From:   Eli Cohen <elic@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] virtio-net: enable big mode correctly
Message-ID: <20211125072040.GA213301@mtl-vdi-166.wap.labs.mlnx>
References: <20211125060547.11961-1-jasowang@redhat.com>
 <20211125070939.GC211101@mtl-vdi-166.wap.labs.mlnx>
 <CACGkMEsNsQ_XWTvdjaCEdo8sYaLew24zU1UUCJrokM-Koxj4fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CACGkMEsNsQ_XWTvdjaCEdo8sYaLew24zU1UUCJrokM-Koxj4fw@mail.gmail.com>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eccd31f8-51db-4d32-fc90-08d9afe41997
X-MS-TrafficTypeDiagnostic: DM6PR12MB4500:
X-Microsoft-Antispam-PRVS: <DM6PR12MB45000F1878C2036B2DDF3E18AB629@DM6PR12MB4500.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 569CBTNP8DfjcQb/rJqlcV/rfGC6FMW6XKe5LyIN/ao7GAMWJi2gqkOtzC2nBtPVG304qbFt1gwuNLTn3KiKJPuF9Cq0nAn74asJpNDqV+bSH51zRFxErX3p2SOynMiFpMl7eEp1RPBIx2OnkZqN4SSXMFqvLvKhD1hEm/ZrEbTuAfIhATo8PhS6r7/lXYsVsY2Y5Wqhra3wOpc8bcOc/0wtC7CDZMkoi17kdUbj1s7I/XnbxwQPeD4Sw8nVtZwsJHcNVoq0wf+Dnc6SOXOG4mN8dw4c2rCbkb13/RhVzRwIWJYxbzx7N4/rz6tC0LbFzddPAq4cCtahjSZuRe08c26Hy5dzKsLecrESuEHatO980s/VobJ/yNZskr4a1LUhUEg0Kf4NXW0PKtc6EC9/Y5UO0p4LVkB3uUO/+csfUrmi60p1YqXEPtSszYXlul5+rOyBj7atwsv5ak4WtPOsNyZ1LRcgiIRTNZeygPNI63x+9WYQHYYbdAwa6xSrfxUClirLv+E026psRQMue+DdEb4F0W736HtBHlBJz+g23S4IoUPTuq9RrnS12kYdYeOhed8Un4/fUTgGKIgI+F78v3i8XCqtlAkDAwnxJBQ351BUSNfM36GONoIUja+f7nbGKaU/MmZUzuA0RrbbsKte/DPE4UV9d+uWzyYG4vE1hx6qmLWIhPgy0SVwPlW17+5Q2crArxDC6MeP9UasEI4iCQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(356005)(1076003)(8936002)(83380400001)(7696005)(70586007)(8676002)(5660300002)(70206006)(336012)(316002)(33656002)(54906003)(4326008)(9686003)(6916009)(7636003)(508600001)(53546011)(86362001)(36860700001)(426003)(26005)(2906002)(55016003)(16526019)(186003)(47076005)(82310400004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 07:20:46.5291
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eccd31f8-51db-4d32-fc90-08d9afe41997
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4500
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 25, 2021 at 03:15:33PM +0800, Jason Wang wrote:
> On Thu, Nov 25, 2021 at 3:09 PM Eli Cohen <elic@nvidia.com> wrote:
> >
> > On Thu, Nov 25, 2021 at 02:05:47PM +0800, Jason Wang wrote:
> > > When VIRTIO_NET_F_MTU feature is not negotiated, we assume a very
> > > large max_mtu. In this case, using small packet mode is not correct
> > > since it may breaks the networking when MTU is grater than
> > > ETH_DATA_LEN.
> > >
> > > To have a quick fix, simply enable the big packet mode when
> > > VIRTIO_NET_F_MTU is not negotiated. We can do optimization on top.
> > >
> > > Reported-by: Eli Cohen <elic@nvidia.com>
> > > Cc: Eli Cohen <elic@nvidia.com>
> > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > ---
> > >  drivers/net/virtio_net.c | 7 ++++---
> > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 7c43bfc1ce44..83ae3ef5eb11 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -3200,11 +3200,12 @@ static int virtnet_probe(struct virtio_device *vdev)
> > >               dev->mtu = mtu;
> > >               dev->max_mtu = mtu;
> > >
> > > -             /* TODO: size buffers correctly in this case. */
> > > -             if (dev->mtu > ETH_DATA_LEN)
> > > -                     vi->big_packets = true;
> > >       }
> > >
> > > +     /* TODO: size buffers correctly in this case. */
> > > +     if (dev->max_mtu > ETH_DATA_LEN)
> > > +             vi->big_packets = true;
> > > +
> >
> > If VIRTIO_NET_F_MTU is provided, then dev->max_mtu is going to equal
> > ETH_DATA_LEN (will be set in ether_setup()) so I don't think it will set
> > big_packets to true.
> 
> I may miss something, the dev->max_mtu is just assigned to the mtu
> value read from the config space in the code block above  (inside the
> feature check of VIRTIO_NET_F_MTU).

Sorry, I meant "If VIRTIO_NET_F_MTU is ***NOT*** provided". In that case
dev->max_mtu eauals ETH_DATA_LEN so you won't set vi->big_packets to
true.

> 
> Thanks
> 
> >
> >
> > >       if (vi->any_header_sg)
> > >               dev->needed_headroom = vi->hdr_len;
> > >
> > > --
> > > 2.25.1
> > >
> >
> 
