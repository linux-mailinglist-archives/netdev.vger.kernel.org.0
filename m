Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F3E230614
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbgG1JEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:04:45 -0400
Received: from mail-vi1eur05on2060.outbound.protection.outlook.com ([40.107.21.60]:49761
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728051AbgG1JEp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:04:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nb5Izy49APrelQwQhwDdjunQFfN9O5rbW1YIsKq7k9HblSBzkWWtg2Nnlg/mtwTT6pd7vzVxar0Iq5ZlP4BKqzTw3p4wi33+OUh1Xc8AE07KLuvxD9hVxQUNprI8vFRDfQ79O4v/BGIlY8B9qD4T3pCOsGHf9PskiM7/02p8dUc6OL52wlMGGpIE78Vz8/cbktjUGUSTRj9sm1aX4OmPfUbsIRCSFT+UP6JazLdCEY7BmjhdIA4xJ/EIjXOYKOla203jiYRwyOPc4CxCwCU7g3IxRCrN9NhA674sQZeSQesW1Y5IBw9ff5Bf4EpUBowe6Jchk26JfrHbRpBuVLVIiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PwSbCoyT48SY+W2X3hco12Y0BUw0tGELfvsSSILW9fM=;
 b=hm+wfsexBlcgJoVmEkulnoAbac5g07J7XCa8/dIkEcgoXucj+yHf/roxv64Aff+4v0x6s5gIcBEY9oLZbpyH0i+kHdpdRzePGOIeQwUWp7ygftDFet5oZgInVdQkcQrMnlqu/qt9X+Ia7kkhfu9zgOcRQR4eDXtsuG9wl4gZ4InHZ+Y0nh7TTaNizVihl3/0O7z+qRgW6Wpl+MpkJ8YVwhV9Lc37M+OOn/OFucFGZHvnEPJf5WX+qszug10kdU4MZdvt1gEiKPGn+jEDTU4VlVtvd+BrIWwvhb7disXCN0+GMcYajob3/f9asF/vSIyonq7CHZctP5GtPMyPOkJg9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PwSbCoyT48SY+W2X3hco12Y0BUw0tGELfvsSSILW9fM=;
 b=nYc8lh20AgqnNya15OP9cKUSDM9zc2qzuOdWacVqRh74zbWWOfc8e+51eEs5N3voUDVg9Pq+RwB+zY9BEfDLOWPne2QgNKP2dlsUmkVhH5Snk45ldE15HE4WUEciwVPmLRAyNgcjJVpA5r1xG3CUVQfa99Dv+0D/67sQ/1GwCLw=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4786.eurprd05.prod.outlook.com (2603:10a6:208:b3::15)
 by AM0PR05MB6116.eurprd05.prod.outlook.com (2603:10a6:208:130::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Tue, 28 Jul
 2020 09:04:41 +0000
Received: from AM0PR05MB4786.eurprd05.prod.outlook.com
 ([fe80::9186:8b7:3cf7:7813]) by AM0PR05MB4786.eurprd05.prod.outlook.com
 ([fe80::9186:8b7:3cf7:7813%7]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 09:04:41 +0000
Date:   Tue, 28 Jul 2020 12:04:38 +0300
From:   Eli Cohen <eli@mellanox.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, alex.williamson@redhat.com, mst@redhat.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org, shahafs@mellanox.com,
        parav@mellanox.com
Subject: Re: [PATCH V4 4/6] vhost_vdpa: implement IRQ offloading in vhost_vdpa
Message-ID: <20200728090438.GA21875@nps-server-21.mtl.labs.mlnx>
References: <20200728042405.17579-1-lingshan.zhu@intel.com>
 <20200728042405.17579-5-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728042405.17579-5-lingshan.zhu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: AM0PR10CA0059.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::39) To AM0PR05MB4786.eurprd05.prod.outlook.com
 (2603:10a6:208:b3::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from nps-server-21.mtl.labs.mlnx (94.188.199.18) by AM0PR10CA0059.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Tue, 28 Jul 2020 09:04:40 +0000
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a8d71944-5193-4780-6d8a-08d832d54355
X-MS-TrafficTypeDiagnostic: AM0PR05MB6116:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB6116493FE9A159D8CBBD54D1C5730@AM0PR05MB6116.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Akn45LIkWeuZLcHr8c61Gc5GY5h6JszSf19DEc7E2eQsEtrTUuGfKg8PnpR4NCYZlxOPwi3tW9BIEwX3aJtUGsYUSG7lp86d8XScotE9TvUIQfL+A48EOd1Xd3u5CYiBqQPOWHCyjmTbpYGtZ79VP3psL2iCjvzPVZ8l5B/jnANDoxSaID2wqj2KquIsBIw9VvokI4XUqqz6s0lEagPm+T/ZxNPG/4cxvdbXfsKS5iNTKevoSe20EglVIjis8j0QRudyP+YU4mdNMxMekxhQkdqoACvO4s2gS+iz7/4808yPXHurnKKG8uB+bIN2cY4ie+qP7UBHkMf0stW13XGOqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4786.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(83380400001)(6506007)(7696005)(52116002)(86362001)(66556008)(66476007)(4744005)(5660300002)(33656002)(7416002)(66946007)(4326008)(2906002)(1076003)(186003)(6916009)(55016002)(9686003)(478600001)(316002)(107886003)(26005)(956004)(8936002)(8676002)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Z2omUVDN/mCYkPGPl2fdthKrm5ulXuLtMCNokLaWm+dCPnHCSSlgAWfvWip+1oIDvzQKN0CX04bSLbxiwh3Bs7jbvzwP4xeoT6laITtLXKFPxAYjjToeIIyR1Fi1tFOa3nJ3Vv/HfOUnrkiJvwnl2J2KIx+TNZ2fv3EQ0epHl2tkcbFXDpj04P3AJBcKo5BDcpJi8BXJD7Dir+mVIXik7YN18zYqpONqgy5nFOuRgn5NXBEfAHETnKQQtpon8XBTz+xuLsQ668t25gqUwHyDuxclBBWzl25yZsvFckNyD5c3HKgF8bXjXPT36wgkehDcdg3TY6cucnpPx0mtG7yy44syrR5LXU22qo9tK0odGCKB5AsNZbqPH/AdtjWXqfliopstxYsxwVBrqNskk/JbeY+FhprXbL7ZBKmGzG/yY4q7unljqMrn/qail9RD24993b5JDK34s84F1l5X3p1ssJE6jKeTlKInrTdb+hYrPxA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8d71944-5193-4780-6d8a-08d832d54355
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4786.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 09:04:41.3749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G8RE3aVQ08CIERWvHIlogqGbd2blyW5+vLuUchlge0TbfoG5X1E+vbV1KjmIwSEp9Aon9oeJ1PFyHjwMJjXReQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6116
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 12:24:03PM +0800, Zhu Lingshan wrote:
>  
> +static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, int qid)
> +{
> +	struct vhost_virtqueue *vq = &v->vqs[qid];
> +	const struct vdpa_config_ops *ops = v->vdpa->config;
> +	struct vdpa_device *vdpa = v->vdpa;
> +	int ret, irq;
> +
> +	spin_lock(&vq->call_ctx.ctx_lock);
> +	irq = ops->get_vq_irq(vdpa, qid);
> +	if (!vq->call_ctx.ctx || irq == -EINVAL) {
> +		spin_unlock(&vq->call_ctx.ctx_lock);
> +		return;
> +	}
> +

If I understand correctly, this will cause these IRQs to be forwarded
directly to the VCPU, e.g. will be handled by the guest/qemu.
Does this mean that the host will not handle this interrupt? How does it
work in case on level triggered interrupts?

In the case of ConnectX, I need to execute some code to acknowledge the
interrupt.

Can you explain how this should be done?
