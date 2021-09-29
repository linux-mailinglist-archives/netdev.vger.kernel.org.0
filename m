Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94BE441C03F
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 10:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244519AbhI2IHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 04:07:37 -0400
Received: from mail-bn8nam11on2131.outbound.protection.outlook.com ([40.107.236.131]:31360
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244389AbhI2IHf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 04:07:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hhUkIGqMEVVihlcxaoPEk3IcRcCgPFKEXJ8b6ntZLK6eXq8ZYlQjmwMvmiYLwOIpF5fDeANRUqxsyxeVGnmGLiKbKa+yT5Xoa93J3NqHssgt7N4Ma9XaVk+WCABynRFS3dAZMy5jbP0Q4ak3Vp2/pGU9eP1oAKx5j2MK364Xc+IWj0+YtmToKoBG1ectUQHp9GvbuFs/VE09GWNd19ZbWnbAW0ncqiMi/A2uvT1J7l1fepUvDzjZRiIzduZuJwJnNzxPQXPlls59+4UMfcd4HXEjpjZnuQPTOE6qOyURXnChOrqAWQFBQJ6zZuz5pQBky+/CNSZZplOfRw6bxkSz/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MvbrO2b2INd+tYVaEX8PpSJAcOsQ/Xr3oVsNV2MJF98=;
 b=Put8VN/9hAd2oUp/o0GH+fk4SEixL7gW5PbGNZzOng84aVepV+7eUNSymkhRxuHM+f2d3WhagjtmFrPVXOED4Rvy98GKMjXaQFi1zXFZCnKFyXW756KmlEcG1tmARGtf2dXzZed7Jf1253VKuZjpF/2pOb9N5lvi2lKQ9KKXpRYha4ghl1pp/JKtCfh8SrlAUO+rQuido2BymgrN2pL+EiSPSJ6W3vNVGu9A4s4AiDwAA0dyM0XpBkWh7tEy4J4EGiAwom/uQXHTxZsJuIiiuIgnKoBCWLO1JPocvASWSwroYA1xiYgongWN8xr684J8E4KcspKA2NfrhB4+qcTNtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MvbrO2b2INd+tYVaEX8PpSJAcOsQ/Xr3oVsNV2MJF98=;
 b=nLgh4qj6NTKpUGSOGoMBeTzVDa09wuA8kwIVxZ2iXQlUBQwYvhObdCbyvcO6w/SIkYNp59maESxm8tJsZ+Zv9rlydFBxtiuqE5CAvuRq1aS1dPhN6fbxtFFRPm3fPbXwKZb0V9KUKR22Y83zBBkY+wMI3jbL6k8nimkwYBx+/+0=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none
 header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4907.namprd13.prod.outlook.com (2603:10b6:510:99::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.10; Wed, 29 Sep
 2021 08:05:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%9]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 08:05:52 +0000
Date:   Wed, 29 Sep 2021 10:05:42 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-pci@vger.kernel.org, Alexander Duyck <alexanderduyck@fb.com>,
        oss-drivers@corigine.com, Paul Mackerras <paulus@samba.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Vadym Kochan <vkochan@marvell.com>, Michael Buesch <m@bues.ch>,
        Jiri Pirko <jiri@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Taras Chornyi <tchornyi@marvell.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de,
        Oliver O'Halloran <oohall@gmail.com>,
        linuxppc-dev@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 4/8] PCI: replace pci_dev::driver usage that gets the
 driver name
Message-ID: <20210929080541.GA13506@corigine.com>
References: <20210927204326.612555-1-uwe@kleine-koenig.org>
 <20210927204326.612555-5-uwe@kleine-koenig.org>
 <20210928100127.GA16801@corigine.com>
 <20210928103129.c3gcbnfbarezr3mm@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210928103129.c3gcbnfbarezr3mm@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM4PR05CA0034.eurprd05.prod.outlook.com (2603:10a6:205::47)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from corigine.com (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM4PR05CA0034.eurprd05.prod.outlook.com (2603:10a6:205::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 08:05:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4b207205-89bd-46ad-13b9-08d9831ff457
X-MS-TrafficTypeDiagnostic: PH0PR13MB4907:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB490740A0B15016851445AE59E8A99@PH0PR13MB4907.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1I1/T4nEuMglxXziM6JsHh+tMoALHxzKkTPl1cNS1cUp8LjqTap4nx/8dL5eL4PZHjEUTu4O95UhOidhK95ZfeWmbJfN9sT3nK71eEvGalUBChK/IDxyboguywVYbLJXw2/kQFLC2yQ45k/Jy9JgoRUcb3MyEQnuF7d44WwctxdVjClPa73MpTp5P7GGXjJun0oLFAL6cP+NKyWINOiZy6G2aDdU0RihHgW7iD7D9l6fDX0zLXlLM9zaxzy6bEKuKupgIL+I5nIvb8zyd7UPjAgkOuWcuusllC2mL9NrQBFZlD3hHDxNOgwaQGBup/ix4M0fsZkCM/7p5PvjPtRm42ANPPAJ6AuollQs9HIQH5PKdPH6MJkP66qfoBVLV2pcCk5Mc+31l9UTW+eWoct1Hahhy0pSuwi1F0Z0ZwdL4Su/obHa1sQFrZFiF4mI3F4ycy7qm9PTewflJP4YFknbdmDGe3/edhRxbP1WxBephGkl0cno4kXNIfjvD45HyPERdj/q0xCdslN/+pnLTALP+h/pUZAuBaXIjtSkQYQtC3AoF3dYDnhYKTyAYmV5GF9jA9fl9HmTn5BTWqpd2g+wRev6iWsY+JIN6Da0Ac7Zwu8HHtD5+Joy+050apmQKayTnYm15LhdMR+Y2FDrpK/H/yY+WduKRY/7Cln2xBC2RQ5PeEShd6JSoVYN2/O4uno3cUX0vG11UbhPaAxOCdlj0Docw51cydTiOEsbhDtz7vI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(396003)(346002)(39830400003)(5660300002)(4326008)(86362001)(66556008)(2616005)(44832011)(52116002)(966005)(316002)(7696005)(55016002)(38100700002)(33656002)(66476007)(8936002)(54906003)(7416002)(508600001)(8886007)(2906002)(66574015)(36756003)(6666004)(6916009)(83380400001)(1076003)(66946007)(8676002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bDkwd21CdFhTYTdtdzRyRjc1S0xRWkNhbEJUd3NNUkd6OVlHTE8wbTZ3MGJl?=
 =?utf-8?B?THVZdEZIUzRTLzM4eDVGZVhxdUlxamx3UlBOQVRTdDB0UGQzb3EreEVHNzA5?=
 =?utf-8?B?WkpETHZycS9tNUtxVjg0WVRRTlo1WjlzcWFKRjlNTmJQNGRFUGpTalZZaHB2?=
 =?utf-8?B?L28waStvVnZscnJwVDJaYjlZdlliL25xaWxPSENEblpuaTJiUmhydTE4MGpk?=
 =?utf-8?B?Q0x6VVhwaTdSMWdaTU5uVC9RRmJRZEN0RjlsUkhDcTVDZ1lKTHhuYlVUZm5B?=
 =?utf-8?B?YkpuNDRlaTluUFhjUStYVkdFRmhWMkxaMDJLb0hRNlFWRUREeHM2YUZnc3h2?=
 =?utf-8?B?MjFKOHVYMitzRjQxRGNsdDNZRUl5VEh1cHZocTNkNUc4SGJkYVlwTVg0OFdR?=
 =?utf-8?B?ZEprU1VmaHM3ZWNtdHRiK2swMTIrM0Y0bkNRdjdkd0RkNndyako3K3NBeE1I?=
 =?utf-8?B?ejVvVzFsOUlaUnBPNGE1OVg1bm5MTDA5T1JUUEh4R0lJN2JFMU9TMGQxTTBX?=
 =?utf-8?B?bnc5ZGRSMktmdU15OE45dlRFZm12dVo5YWl0L3Q5VlhSRVlyZ1cxaWtIbnNP?=
 =?utf-8?B?bktLajhUZWlCKytsYjdZOThtWTBFZ1Q1Z09nMTV1Um52ZlJTQXpSNDk1eEVG?=
 =?utf-8?B?Vkc5cnB0cW5yb3V2N1JnZ05mdzVLTXlnRGpSbmhHUG04ZjY0Z0ViVEtDR3p6?=
 =?utf-8?B?Qnd1TUFWbTZnMVVObmdZa0cvN253bzlTc0tPL3NTZmc4dXF6bW1KSUJwV2tC?=
 =?utf-8?B?V3pYUkl1WVZ3aHVrd2dYRUk3SXg2bStYNFV4V2FLd0orL01NVzA0dWMvMDlR?=
 =?utf-8?B?Uko0cXNoc0dWMzBiVm5KMFdING1sWHd5Rm1HUDZiU3JoQXJHc3VWdWFqYWl6?=
 =?utf-8?B?OVorZllCYjJjdXNsTGcwUW0zZnp5aWhsQWoxRHhodTVjb3k0bmQwemhrbjNy?=
 =?utf-8?B?RVAzUk9razIwd2J1RjQrK3ZlM0lONm5mTjg3OWg5UzBhRWNjT3VXbnV3Y0w4?=
 =?utf-8?B?Z0FDZGpGTHN4Mk9NeWVTVVNnUTUrYkdiSERKbEJkdEVIN2Y4cmhvUUFTeDlD?=
 =?utf-8?B?cHJlem9tVFFIRzJZMVZoNktxWEVKQnY5OThRMmpQeUlQQ2hUTHdYdkJIcWJG?=
 =?utf-8?B?YjFneVdwUXZ2WWVudnA4NVQrcU9HWllCc1h2b1dWUSsxVzByQzJzRlJjb2Fw?=
 =?utf-8?B?MmFFbmZGTzlGb25DaFVlV0ZhSi96aTA3M3ptRVY3b1hBRDBzQzI2Y2gzQ2wv?=
 =?utf-8?B?TUVjT21UL3RiK2pKWGJPMmw0OVZURDZ1T2d2c3JJYTlsL3ZWSnlCQjNhbFcw?=
 =?utf-8?B?Z0hHaE5Rb0ZSQlFMN0tPZVc4RUV3WDNzNUFJSVJ6enllWlYrMWcrdmF6NitU?=
 =?utf-8?B?OEN0OVlDbUZPc1E0dzNQdUNmbEY4RXYxYUtoQUdYMW9ZQzFoTzgxWHIyN2c5?=
 =?utf-8?B?azNPanEwT3Erb2E4LzVsaVJUK0NMTStnUGYwa0JTYmpXZ3Y3Ky9tQ3gwVWJO?=
 =?utf-8?B?d1E3NDdpU3RoM1JuLzE2ZEJaT3Y4L3ZHcEZTTWhNOVdnOEpCVDRmSUE0b2VP?=
 =?utf-8?B?Vy9ob2xWQXpyOHBPb0tVbUltMFVSQUtuUElDNWx3Nmp3bTkrVWxJaGZLNTJs?=
 =?utf-8?B?UVlmNGhJcWV3ZXZJMVFzU0krV084V09STWZxOWR5YmgrVDZWVEV5OWZ6SjV3?=
 =?utf-8?B?aEYrQUIzVUJpaE9meFpUSFRmdE5sOFhqSEJYSWRaUzR6ZlFHTjRFV2lWbURj?=
 =?utf-8?B?ODgvSktWZWkxTHlwb0NBUlJQcUhLNy9YRndxK2FLOVYwRGVTdVB0S2VoTnE2?=
 =?utf-8?B?YzdjU0hMMUdPQ0tBNDg0UWdNWHc1OVBPU0hCU0hUVUpiMGluVlNLdXF4NjFE?=
 =?utf-8?Q?QjQnORx9+6DCf?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b207205-89bd-46ad-13b9-08d9831ff457
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 08:05:51.9204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ebSttBpcX9ebubYIFRXFfeHaLPdxfG7keaAiWNC9iAF75gGtjjokrVCgq3QKM/yzrA5svvoInj0ZdWtMVdLqsRorpjXNCEkrWBl2nE/0Cos=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4907
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 12:31:29PM +0200, Uwe Kleine-König wrote:
> On Tue, Sep 28, 2021 at 12:01:28PM +0200, Simon Horman wrote:
> > On Mon, Sep 27, 2021 at 10:43:22PM +0200, Uwe Kleine-König wrote:
> > > From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > > 
> > > struct pci_dev::driver holds (apart from a constant offset) the same
> > > data as struct pci_dev::dev->driver. With the goal to remove struct
> > > pci_dev::driver to get rid of data duplication replace getting the
> > > driver name by dev_driver_string() which implicitly makes use of struct
> > > pci_dev::dev->driver.
> > > 
> > > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > 
> > ...
> > 
> > > diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> > > index 0685ece1f155..23dfb599c828 100644
> > > --- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> > > +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
> > > @@ -202,7 +202,7 @@ nfp_get_drvinfo(struct nfp_app *app, struct pci_dev *pdev,
> > >  {
> > >  	char nsp_version[ETHTOOL_FWVERS_LEN] = {};
> > >  
> > > -	strlcpy(drvinfo->driver, pdev->driver->name, sizeof(drvinfo->driver));
> > > +	strlcpy(drvinfo->driver, dev_driver_string(&pdev->dev), sizeof(drvinfo->driver));
> > 
> > I'd slightly prefer to maintain lines under 80 columns wide.
> > But not nearly strongly enough to engage in a long debate about it.
> 
> :-)
> 
> Looking at the output of
> 
> 	git grep strlcpy.\*sizeof
> 
> I wonder if it would be sensible to introduce something like
> 
> 	#define strlcpy_array(arr, src) (strlcpy(arr, src, sizeof(arr)) + __must_be_array(arr))
> 
> but not sure this is possible without a long debate either (and this
> line is over 80 chars wide, too :-).

My main motivation for the 80 char limit in nfp_net_ethtool.c is
not that I think 80 char is universally a good limit (although that is true),
but rather that I expect that is the prevailing style in nfp_net_ethtool.c.

So a macro more than 80 car wide somewhere else is fine by me.

However, when running checkpatch --strict over the patch it told me:

    WARNING: Prefer strscpy over strlcpy - see: https://lore.kernel.org/r/CAHk-=wgfRnXz0W3D37d01q3JFkr_i_uTL=V6A6G1oUZcprmknw@mail.gmail.com/
    #276: FILE: drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c:205:
    +	strlcpy(drvinfo->driver, dev_driver_string(&pdev->dev), sizeof(drvinfo->driver));

    total: 0 errors, 1 warnings, 0 checks, 80 lines checked

(Amusingly, more text wider than 80 column, perhaps suggesting the folly of
 my original comment, but lets move on from that.)

As your patch doesn't introduce the usage of strlcpy() I was considering a
follow-up patch to change it to strscpy(). And in general the email at the
link above suggests all usages of strlcpy() should do so. So perhaps
creating strscpy_array is a better idea?

I have not thought about this much, and probably this just leads us to a
deeper part of the rabbit hole.
