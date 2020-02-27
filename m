Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6AFF172928
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 21:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730761AbgB0UBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 15:01:36 -0500
Received: from mail-eopbgr130052.outbound.protection.outlook.com ([40.107.13.52]:8490
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730080AbgB0UBg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 15:01:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AHdytTnJo3mukzTfp8u+Zb9rJCh/9Nplo9rTVfuu9BC1tagP31GGQGcLB8CEhZwqBlhTu34IkuWhC8v2IolljaXNzGEiglcTH9dRd5/U86tGufaTeDIzO7HKTnQpBnQokjMzE0qBIVlT7Lcjtn+SR6HxKx5ie5RuRD5my+Qn69twZRUM+dcbzJtxSpNWDKocr+UsnK3JqTdGYKvPKzskScRgUGLIH4+zF9E+w/16cOhpsxmhja3UL9K8BGBTLAQt68L37XUK8Nzff5/zq0EuW8MQjOVP2Yi2wSjWA+GmH4hGDS9xnw1Ap9VW/1jVMREqCV2jaP/Q1yK2+eVOd7VneA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2qnOvRnuyyH2S3/UFPl6ctmTy7Jufw5flp/Kd5JaMYA=;
 b=M4WZcQYSO0DC1edTHUqBgebhdh7WyN4aRF526thI9roN6JBht6kS4QDlaxRMyISaj73Nx9CjxfLogI0ajMS2I+7tPy31CAsXRIjbA6gHFsSlT4rz3HwPDS01KHSHIaSWVDdBN4lAgfHPdmRml85SucKEzkGlGnjeFxleEZfP9KvjUD/vyApew+db04vnD6AzbXc25eixvdQTm6LOLNbVvj+uxa09vNdaey8l362q0oVEo9k0DeRnDwSqDriJxFjox1seYP0RX8toa9IEjY93wMWwzQ0hnoJwRiJ7nLeBmG6PAv0tk1AKHT2Eyqe+S7xCsdO0TNGGuL+B5XVcDawgWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2qnOvRnuyyH2S3/UFPl6ctmTy7Jufw5flp/Kd5JaMYA=;
 b=rj8fSIev8CUUkXEvV3bS+Nb3xb73UvQ6KHIUlow5y68bzA6CamqTwQzZ9aMkpv/eJmFVnVm+JKr1VFmirTMUt3qHZfIy/ZhwCbElpQBAncCuwx8Aaf/hhzfKGkNdrITrlEDzKnVFQGKPn2Q/lchWZSF8/jBb4luQ75kV0GO615E=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB5040.eurprd05.prod.outlook.com (20.177.48.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15; Thu, 27 Feb 2020 20:00:55 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d%7]) with mapi id 15.20.2750.021; Thu, 27 Feb 2020
 20:00:55 +0000
Date:   Thu, 27 Feb 2020 16:00:52 -0400
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "leon@kernel.org" <leon@kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Michael Guralnik <michaelgur@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 1/9] RDMA/mlx5: Move asynchronous mkey creation
 to mlx5_ib
Message-ID: <20200227200052.GR26318@mellanox.com>
References: <20200227123400.97758-1-leon@kernel.org>
 <20200227123400.97758-2-leon@kernel.org>
 <952538abb4d035fb4c60db9ea136838641b741d5.camel@mellanox.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <952538abb4d035fb4c60db9ea136838641b741d5.camel@mellanox.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR05CA0038.namprd05.prod.outlook.com
 (2603:10b6:208:236::7) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR05CA0038.namprd05.prod.outlook.com (2603:10b6:208:236::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.11 via Frontend Transport; Thu, 27 Feb 2020 20:00:55 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1j7PL2-0004cv-6Z; Thu, 27 Feb 2020 16:00:52 -0400
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e7f21be0-287b-4364-e9ea-08d7bbbfc178
X-MS-TrafficTypeDiagnostic: VI1PR05MB5040:|VI1PR05MB5040:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB504079E00864FBC588D88091CFEB0@VI1PR05MB5040.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 03264AEA72
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(199004)(189003)(2616005)(66946007)(33656002)(4326008)(66476007)(52116002)(54906003)(37006003)(9786002)(9746002)(66556008)(86362001)(1076003)(6862004)(316002)(186003)(8936002)(36756003)(8676002)(26005)(81156014)(966005)(5660300002)(81166006)(6636002)(2906002)(478600001)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5040;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 00QRTDqBoDKZJgW+l72AAVM9FLu6KFzy2y1/Xtc/tHJgdZ8ctpksDhM/QaT+GphROcE9Xpbbg8D4tmKfYjjQ/exee0j2QXQLZB+LVA0qLU8IkqTU9TDp6UewkMufu1EayY1nDmUUp4AeKRdT5iPr6/zoyyWdTINtzHuEsD+vDPxOS50dNcuSb4kbeT+nbpdBqzPdiWpaqhJdYURsUMIIZYpcm1QLsQe30kaicBozzkHrHpGOvOpBWnYqTXDoWvkK2DVJVTOs29cai7eV499xOkRtdkyMdchWOoOjlmm+0XD+chpWA0j+lYKxNk6lsmKt0pdN3Qqr+02v4pf95pXkOluuaEkxShu/QCtrKD2WvNnBGjDBcU/4ixiWPJB0IwRhbfDVi8OOf67rlw/vfTaHAqKgrAQfRBP4aL+e27wCRpA3yddmmNT0oRtk+4lTeZ0tlWuujz6ELU/W5k373+FfcQ8/XFYKpzdFW6cSx8KnLyaVAwwVZzZoEv1xX/8dFWKMZybCmkekUqv8nJvvZuWfDl3ubl00xOaiqunUv9FD8db0PpGxEpzjPAM6HO/q8SjGSJ+u7XXYAXjZPWZCFsYAwQ==
X-MS-Exchange-AntiSpam-MessageData: S/AhrhpWoZW5UsyGeZfT1IE4ddyt+uuLuwdR1xqKau1VybK9LGSwh7ta5+dCwvYWJD1I4LI1fEnR7F39iaCyoxWp62d0HBG/ncgJ+i/lrx7gR0z1JqTtIdk7373FcR7+S3C8xlMpd4gSTqYPn02j+Q==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7f21be0-287b-4364-e9ea-08d7bbbfc178
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2020 20:00:55.7267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B1XftOKtPj31LLX1XhFzXiXlv7X65+3wTkJ6Os/s6VfG/4IHGjLjzZf5ZduqcKY8z63Kf5yvz4fWBi0X33QgRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5040
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 27, 2020 at 07:41:24PM +0000, Saeed Mahameed wrote:
> On Thu, 2020-02-27 at 14:33 +0200, Leon Romanovsky wrote:
> > From: Michael Guralnik <michaelgur@mellanox.com>
> > 
> > As mlx5_ib is the only user of the mlx5_core_create_mkey_cb, move the
> > logic inside mlx5_ib and cleanup the code in mlx5_core.
> > 
> 
> I have a WIP series that is moving the whole mr.c to mlx5_ib.
> https://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git/log/?h=topic/mr-relocate
> 
> 
> > Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> >  drivers/infiniband/hw/mlx5/mr.c              | 25 ++++++++++++++++
> >  drivers/net/ethernet/mellanox/mlx5/core/mr.c | 22 +++--------------
> >  include/linux/mlx5/driver.h                  |  6 -----
> >  3 files changed, 24 insertions(+), 29 deletions(-)
> > 
> > diff --git a/drivers/infiniband/hw/mlx5/mr.c
> > b/drivers/infiniband/hw/mlx5/mr.c
> > index 6fa0a83c19de..dea14477a676 100644
> > +++ b/drivers/infiniband/hw/mlx5/mr.c
> > @@ -79,6 +79,25 @@ static bool use_umr_mtt_update(struct mlx5_ib_mr
> > *mr, u64 start, u64 length)
> >  		length + (start & (MLX5_ADAPTER_PAGE_SIZE - 1));
> >  }
> >  
> > +static int create_mkey_cb(struct mlx5_core_dev *dev, struct
> > mlx5_ib_mr *mr,
> > +			  struct mlx5_async_ctx *async_ctx, u32 *in,
> > int inlen,
> > +			  mlx5_async_cbk_t callback)
> > +{
> > +	void *mkc;
> > +	u8 key;
> > +
> > +	spin_lock_irq(&dev->priv.mkey_lock);
> > +	key = dev->priv.mkey_key++;
> 
> you know i don't like mlx5_ib sniffing around mlx5_core->priv .. 
> 
> this is handled correctly in my series, i can rebase it and make it
> ready in a couple of days.. let me know if this will be good enough for
> you.

How about Michael just take the two relevant patches into this series

{IB,net}/mlx5: Setup mkey variant before mr create command invocation
{IB,net}/mlx5: Assign mkey variant in mlx5_ib only

And this partially moves toward your series. It will be more than a
few days to rebase and check all the parts of your series I think.

Jason
