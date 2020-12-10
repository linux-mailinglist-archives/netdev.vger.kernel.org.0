Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E8A2D6169
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 17:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731294AbgLJQNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 11:13:32 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:27032 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392349AbgLJQNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 11:13:09 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BAG4juN004934;
        Thu, 10 Dec 2020 08:12:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=x7CcT1SH5PgNGEW+P1B2v6HKUWn4pF1f5fCm8X9d3KI=;
 b=YZEkfz4+cN97BC9LfVu4XSjVoPlSY1+f1X9ZaHg+uEUTH0fYIOVLDQ2IXrcK3hHvIW6W
 qrr9L+EnDJRszPAmK+ko2u6MSal3053JsphuhN6+5N5U0d+tJgmapRDb8MyrBmylhZEl
 mwRB5WnMd8Ju3VWP7kdMnG/6mNE8ObGwO2w1QdcWjiSs3ENR1EoW3Pc5RgJnbJ4v6wiz
 bz469vM7aC5TD15nm0U94dnwDfSZcXFfvNtbu/oz0fr9QeSYiq6kFOV8kfJm/nYekLb5
 F4I3R0xDNqkShMGoLM68VHGTYv8F0M/iP/UjKGn5aSNf6ANs10PFGxCUrpmEiRiIaxTQ Xg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 358akrfrkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 10 Dec 2020 08:12:16 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Dec
 2020 08:12:14 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Dec
 2020 08:12:14 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.52) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 10 Dec 2020 08:12:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i8/GRWrFsrstUBwolOXbPnPGtfEwILpEj2Xjbujm4qV5ZAHf0m/ABQvRxyBXeTsARpuRsxRsfNLqUrur+E57BeKEVL/pebK/6HCoHSLvYtk8UOmu1UpGGnfMo46LKzVcPvPlChwBEQVhOayaS2qHokJx3wFE8nkcr+xFZjJhbKAoJ+PKFONb8Pyn33OwzV8BAXDP3MjyhvuzGuSth13a/8MMEyG+LFsQJs/5l+KKlygfuYEk67JLQLjmualJeb/eMKh6z9U7JbAFh0V9ZYLXfYI6jzROVQR6V7IqQCIhrVXFUeESkrNxJ9071AHxU1HRu2Wy/0oMT/t3qZ40O8ZfZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7CcT1SH5PgNGEW+P1B2v6HKUWn4pF1f5fCm8X9d3KI=;
 b=jmkHgTGuJtA0ZW/x+uz0l8Ct6Sc7nNjO1jlTnaWdk6ANXxC5JHutE8h/1K98GstDEfrAKkksq60Kbfy8QPWHr++wr0NPSMfQh092wxNVTgRFY7Kg759NCMFRHbmfTvcFpKuSWF2nFnMRYev8wrDRIve7IY7KGV9AqTMzb/wv0CqK1DYln7tmZCJS9xWr7voCvie6fkgrvp+Z/SOSfvichTv5+bVvI1txsv/whvMljMw9mAKHkdXX22kkWiX2GhFzH3yQDOXu37KximkM11WbHNq3R5byCPEt6yIdPEQ/7avWGheEihumEZvSLeLlQmuZ51GQkJh8RhLYbl0jsoWEiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7CcT1SH5PgNGEW+P1B2v6HKUWn4pF1f5fCm8X9d3KI=;
 b=SkYF/SY5NXeLnBQz2xvGKm22P9BYS+VDWa/+bILghWnld1VE6m5sXam2SEa/ElG+GpCee4bzbt+zGsCdnYGjDtg2MAAwDfFvFQgyLdp7gUKPQD7A0MwHBxgmg004ChtVjlUvBEQxWEX4impevnN+hXostWK/s7Otyq7siD4n8zk=
Received: from DM6PR18MB2602.namprd18.prod.outlook.com (2603:10b6:5:15d::25)
 by DM6PR18MB3585.namprd18.prod.outlook.com (2603:10b6:5:2af::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Thu, 10 Dec
 2020 16:12:12 +0000
Received: from DM6PR18MB2602.namprd18.prod.outlook.com
 ([fe80::c4e7:19ce:d712:bd91]) by DM6PR18MB2602.namprd18.prod.outlook.com
 ([fe80::c4e7:19ce:d712:bd91%5]) with mapi id 15.20.3654.012; Thu, 10 Dec 2020
 16:12:12 +0000
From:   Geethasowjanya Akula <gakula@marvell.com>
To:     Saeed Mahameed <saeed@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Subbaraya Sundeep Bhatta" <sbhatta@marvell.com>
Subject: Re: [EXT] Re: [PATCHv3 net-next] octeontx2-pf: Add RSS multi group
 support
Thread-Topic: [EXT] Re: [PATCHv3 net-next] octeontx2-pf: Add RSS multi group
 support
Thread-Index: AQHWzk4d9K8Ye5uitUy6hna3D0lwvKnvILkAgAFgzQI=
Date:   Thu, 10 Dec 2020 16:12:12 +0000
Message-ID: <DM6PR18MB26028B727E26DAFBA2D711E5CDCB0@DM6PR18MB2602.namprd18.prod.outlook.com>
References: <20201209170937.19548-1-gakula@marvell.com>,<f47444311bc7661c6482de11d570fb815f8e7941.camel@kernel.org>
In-Reply-To: <f47444311bc7661c6482de11d570fb815f8e7941.camel@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [103.248.210.142]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 97ebdbce-3467-40cb-1a30-08d89d265a9d
x-ms-traffictypediagnostic: DM6PR18MB3585:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB358513A37510BADAA5AFFEC9CDCB0@DM6PR18MB3585.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J8wDzQnMmxstjzj5lqtOP/6+Mdq+hWko5GlK4UECAEqo32hKxuc/TW/u9glQismZ9bDqw3DFkucUK1Q2ujFrzzQ4K+cod8quHh1qlw6CzaHAWpgNPJn2naNU4DCOxoPgHG8D5T+fZxkAKbDAa2o5yquztBPB++DBdpmpKnJjhgBLB1Hm6aQMDdVOPjVRBz8aBwqj8xw5xpd1B6fDS/1xvyqfEgkoSuQjvOiulbwr51A6KVA/Btm0PBF/Ao7UpBngh9eXNtVe/dZDwymSkzCCokiQ1JuJ+NGSlwLEvyMhs4s2tAvz9s/6jTTN05ysRuNDNIkwsHje2zH0xFIcJmHaXg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB2602.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(136003)(52536014)(54906003)(86362001)(5660300002)(66946007)(110136005)(33656002)(4326008)(66446008)(66556008)(91956017)(71200400001)(6506007)(55016002)(26005)(9686003)(53546011)(7696005)(64756008)(508600001)(76116006)(66476007)(107886003)(8936002)(2906002)(83380400001)(186003)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?+asKIGNuemFhiYd7jfiiCwaC2pZY0YPfKR+m4WauzarE9kSlsZjuXUPudnFr?=
 =?us-ascii?Q?oO8CShso97f2GVreqs/sERVB/GAcJcG6UHPYXy9Ffgc/06d24VPVvFWvIW7w?=
 =?us-ascii?Q?AScYux2ryX9BlWJFyi3wI/6ZZ52SS6iY/tsx83zP/4DdRZ/NFNq12QjyLdpX?=
 =?us-ascii?Q?4P9hTAyZs22zK9IzFsG4WxiPPE9ovZheKUOT6GSRqenHarMUy7U+B1XcU7qV?=
 =?us-ascii?Q?QuQOZd9T+lHQNmSseAtPTK7kQ4fXDUSl4/H6bN0B1OQK8KJOJDAzOkLgtEY+?=
 =?us-ascii?Q?Kp6RIcQiPDx4iGEwr5W4M6i8GetOc328JvuKMBpWx4x9Yf0uVcb7QVj6eFYN?=
 =?us-ascii?Q?gcNQP4Xh3/BGXS7/ue8d0KOOexsTk3q5M4Ty73/bYEetdh78HFYBM62Il8ZV?=
 =?us-ascii?Q?FMWg4+DJFhepjV0qPqYv7fwFH65Te6sW+Qvzg1vNAvDZferlaOiZoYCfZLod?=
 =?us-ascii?Q?qpNteNCW7a6skKToHXbAcIL8gxtmWo4a17i6B4QjrQGOtc/lExyyDr8cnjk4?=
 =?us-ascii?Q?NOmAduUzrtZatbMMxRWpICYDWV94XsIbPhV46FStzN9yuOfEFH9PTgsk7Web?=
 =?us-ascii?Q?q8jZrBbhE41gUVZ2CMY6daBzl8SClDW/Tc0hC8QbOLmSyMvBqgCvfxaK5Uh8?=
 =?us-ascii?Q?AR+5rs6XY9x12ObS4H1UGjJIT/MaklfsO/RSmOiF9klhIjuGzAKkCqeCEatj?=
 =?us-ascii?Q?kSYl6nY77+t+WqnitDalb/ikF2zag6hv5KjxRyBR6G3QR4S2YjtarDlw0qTY?=
 =?us-ascii?Q?g6sCQePfr9mmgS7rg9KcZhhafEx+nwRbgc2vrLeR9LjlBxkEGBtUzoBqrYwp?=
 =?us-ascii?Q?+5HyOhUKbldXkaO96oKT20tcN7CQGvLYw/5Wl3qUYLazZGfbN9U6/7e+B/ZK?=
 =?us-ascii?Q?C4BxiMIqcbg3gN4MxjmnknxuYlFbi0Vzb7pC1M8r6F8IAFp5A5t5xgjLc96G?=
 =?us-ascii?Q?skSTp5rWoW3QDRXTMUOQ4xyhlu4LM7VnG1cySKUTegQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB2602.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97ebdbce-3467-40cb-1a30-08d89d265a9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2020 16:12:12.6589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TmxtcvkrV55QOvGewCZ6IEyshBWMPs8l3mxtxY216RF+ew26bWaP8RZk+1+L/bG8FKFzrwZKSLjGyep0Hbeh9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3585
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-10_06:2020-12-09,2020-12-10 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Saeed for the feedback. Will address your comments in next version.



________________________________________
From: Saeed Mahameed <saeed@kernel.org>
Sent: Thursday, December 10, 2020 12:38 AM
To: Geethasowjanya Akula; netdev@vger.kernel.org; linux-kernel@vger.kernel.=
org
Cc: Sunil Kovvuri Goutham; davem@davemloft.net; kuba@kernel.org; Subbaraya =
Sundeep Bhatta
Subject: [EXT] Re: [PATCHv3 net-next] octeontx2-pf: Add RSS multi group sup=
port

External Email

----------------------------------------------------------------------
On Wed, 2020-12-09 at 22:39 +0530, Geetha sowjanya wrote:
> Hardware supports 8 RSS groups per interface. Currently we are using
> only group '0'. This patch allows user to create new RSS
> groups/contexts
> and use the same as destination for flow steering rules.
>
> usage:
> To steer the traffic to RQ 2,3
>
> ethtool -X eth0 weight 0 0 1 1 context new
> (It will print the allocated context id number)
> New RSS context is 1
>
> ethtool -N eth0 flow-type tcp4 dst-port 80 context 1 loc 1
>
> To delete the context
> ethtool -X eth0 context 1 delete
>
> When an RSS context is removed, the active classification
> rules using this context are also removed.
>
> Change-log:
> v2
> - Removed unrelated whitespace
> - Coverted otx2_get_rxfh() to use new function.
>
> v3
> - Coverted otx2_set_rxfh() to use new function.
>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> ---

...

> -/* Configure RSS table and hash key */
> -static int otx2_set_rxfh(struct net_device *dev, const u32 *indir,
> -                      const u8 *hkey, const u8 hfunc)
> +static int otx2_get_rxfh_context(struct net_device *dev, u32 *indir,
> +                              u8 *hkey, u8 *hfunc, u32 rss_context)
>  {
>       struct otx2_nic *pfvf =3D netdev_priv(dev);
> +     struct otx2_rss_ctx *rss_ctx;
>       struct otx2_rss_info *rss;
>       int idx;
>
> -     if (hfunc !=3D ETH_RSS_HASH_NO_CHANGE && hfunc !=3D
> ETH_RSS_HASH_TOP)
> -             return -EOPNOTSUPP;
> -
>       rss =3D &pfvf->hw.rss_info;
>
>       if (!rss->enable) {
> -             netdev_err(dev, "RSS is disabled, cannot change
> settings\n");
> +             netdev_err(dev, "RSS is disabled\n");
>               return -EIO;
>       }

I see that you init/enable rss on open, is this is your way to block
getting rss info if device is not open ? why do you need to report an
error anyway, why not just report whatever default config you will be
setting up on next open ?

to me reporting errors to ethtool queries when device is down is a bad
user experience.

> +     if (rss_context >=3D MAX_RSS_GROUPS)
> +             return -EINVAL;
> +

-ENOENT
> +     rss_ctx =3D rss->rss_ctx[rss_context];
> +     if (!rss_ctx)
> +             return -EINVAL;
>

-ENOENT


