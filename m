Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0CC45D5ED
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 09:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238353AbhKYIGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 03:06:53 -0500
Received: from mail-dm3nam07on2085.outbound.protection.outlook.com ([40.107.95.85]:7041
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240966AbhKYIEw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 03:04:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h26hYrB1spGqOtfPbPYzpZ7BTj373GbrcaZR+HJ3lVafqdRRlH5wsEGUDjZTjoYuM7Z8vJ6Pul+Mhyxjnn+TaDWW2ez+PPMxKYpQJw+0rb+moTdkttpRFe8D8sSW/Lz0ImOZbqCkZ3yRGo/PYrZ6FG+wq3enPR40LjV8Z+JehDy/1mpawQaicpelxjVWP9UsJXr0n3vI+ouf690Tb3e5K7tFwvhEjCVGIf0rWZEDQ+uMQrtm36z5Cg+FTJWKlVUob6Dq1HRiK07cxpAbfmC4t3e+nZKQ/bWJc/dcOk+Vnk5pAA51Conr+7phQSxUj3T15fI2+lRYSmTV2yvJppmr2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6XuQwlqgYdyOD6F+14rbnImSH4sx7ixxpMoB99UyAkM=;
 b=SrYA/O49K3/KzO2t5Mes+OaOhVYtkC75lU4K1uv8XKEMj2vQ5MpY9n3zpZLa9Uq6i0K8TUYq0lJyOgk4xP/LJjzHPIeyer7UGW2etzp62aEjY2u9L7czhh64pEl/nMuorHA7F/dZTt3Kkxf7q3gSkXHAHJDLaKzO5K7Wem5wPrVgPwpPe2BsftkDNVO5alcy6ItHqwi2Bu0EVBCdIE8KSKhikZzcBSXrVVDMnNZHKnnhSEh9zx8oaAitSyEtndcjsYZTTwI48Kc3KyFEg0jXzDYkQxzKDJHZdrP0Y8blD9oszEhZYAg8gRCcR3JURo3/fUwD9ujQf6eFytIEdQnv8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6XuQwlqgYdyOD6F+14rbnImSH4sx7ixxpMoB99UyAkM=;
 b=kkduJs70n3FPqqQSMDl+wEvYOTUEvvxmDpl3Br8Ag9qK3mrwq8wDgcscHS4idN7O6neZrlWrdFwvNkywrf/iXx2joS9LDxvgnTmOOy47e55Muz9HCKwvtmBi32dhSIj/anIuum0by+jViXCkQHYZQoOEGf0Rgg6O0DYhByAGiCb4IKib/SAoAT9P4qj2I3ftuzeG9If/QQsJUX5jIX2/p5hNDOHzYt/kN8Ls38WyGYIEtO60iWfahDxyQLGs5SCSd3YyP23nu+DWa/OOg7BA4wA5wwqWYLhf+2rmEMJNpvrKO3lrGw+TC1EwEcX1JHnjL93FfxfA6m6hCLX7dzZz6Q==
Received: from DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20)
 by DM6PR12MB3178.namprd12.prod.outlook.com (2603:10b6:5:18d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Thu, 25 Nov
 2021 08:01:40 +0000
Received: from DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::a5c1:7bee:503f:e0d0]) by DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::a5c1:7bee:503f:e0d0%8]) with mapi id 15.20.4734.021; Thu, 25 Nov 2021
 08:01:40 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: RE: [PATCH net v2] igb: fix netpoll exit with traffic
Thread-Topic: [PATCH net v2] igb: fix netpoll exit with traffic
Thread-Index: AQHX4KpS8IRO8CTaPUObrYaieVzqnKwT3RWAgAAGp1A=
Date:   Thu, 25 Nov 2021 08:01:40 +0000
Message-ID: <DM6PR12MB4516B65E19B294524570296FD8629@DM6PR12MB4516.namprd12.prod.outlook.com>
References: <20211123204000.1597971-1-jesse.brandeburg@intel.com>
 <DM6PR12MB451662EC02B77D17A9C27473D8629@DM6PR12MB4516.namprd12.prod.outlook.com>
In-Reply-To: <DM6PR12MB451662EC02B77D17A9C27473D8629@DM6PR12MB4516.namprd12.prod.outlook.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48384791-a90e-4fa6-e09f-08d9afe9d037
x-ms-traffictypediagnostic: DM6PR12MB3178:
x-microsoft-antispam-prvs: <DM6PR12MB3178D3C1A35A81446B1A655DD8629@DM6PR12MB3178.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O+puwaVpb7Q78jMhONySFoTzCd4IqrHCoEVW+r1vRmFyPH+4exubCDdTNgvJ9qVW6qi11MsTAew5953fbv+JiNuNuy/DkLOTd/mMRSNVoiIjfxwBlTClfO6/apS9RWku2ZNIlne1MHbeNUES8AiPjqiAtzT51Hzsmn7PoU1JXFDnSOa7U6QagG73pU3ryfjUfg6ZIc2bD81/8LTu8uutNi5TtMjJSIH0nRpWH4mn+LMBIUuJOXEBCrV0/2ttg3d3WNY7DJF5AySxs6lJ623GHsb1nsBnYYkX9EQmXMIn0vOkBJxhw1RaPsVj5AJ/BOwaI+iY2BGOSTHI01aUMk3pRdk09GESGT/pMTu7hniJMLUtAl9dBbq+VHMrLVSC5Tpj8/9DBBFyqBX5ah5mHeS8vFuqcNfhE5OinLG9JeKXaHTfVFYLMjqpplTo+BW8N4hTsjUpx3ntjz39QepS6Dme4nbLmNzk2YI4143HEZGykAqOEyhBOJJrHFYA55d0zED2ULscg4VT5sCny9qgzA6uhFclF+kv9H/bqEg29DNWLs6kIy+OvLx+EmDYOXwS7wmoS6Z86SPwHGBaD2UfLvHLdsdrhFmzoyBPfeR7+g9318eKdnbIHPVCVqck4/UbLrLEcywVU9Dl0ayw64lC7P0KRO6xlWiZNSnRj7rwbl0r7YukD8txwTuQGi+04TKjkHsfJjR3Yq/O64Xapt9ipxZ+4w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4516.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(53546011)(64756008)(83380400001)(66446008)(76116006)(66946007)(8936002)(7696005)(66556008)(8676002)(5660300002)(508600001)(2940100002)(86362001)(66476007)(122000001)(9686003)(110136005)(316002)(54906003)(2906002)(38100700002)(38070700005)(52536014)(26005)(186003)(55016003)(71200400001)(33656002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?slhACWv3dVL5pgR6l2clrHuGQEVTZBegy0AwoxO2oyLP6T95USqc0HnKFiLy?=
 =?us-ascii?Q?JHVGMbnBwoY3GrgjaIcPzYVpOtErXOSHIQS00gJyA5cFwibG/0PkC8EIikIL?=
 =?us-ascii?Q?nyNUlelFyIXFl45GSyeFjVp7g80ntVP4PK5UQScNx6JHJ9JYrkCbxdwSF/fh?=
 =?us-ascii?Q?4SdkbVV1eBbxoOi/SdF7MK/zoASxGdw1V90wln5x6apOIPkzFd9nZp0nvH1m?=
 =?us-ascii?Q?J1kxT8Lw8L3Rorz43926cPhsV5JuZ7LlLV3J2IPXZd6fjyKtfnSV8oiU1gnC?=
 =?us-ascii?Q?mp+B8DFfIyC7B7DxObrYbTuKqNMbXfjTnYd9nk9ugtouirjM/pL8VY8CB6a4?=
 =?us-ascii?Q?UT3FWEFBDb9LYxq1ZI6n8rfRJFHDqcHtbGW78oe7HppVoLN5c2JOHSddfikr?=
 =?us-ascii?Q?zKUgqa/8XXnBVS0r0+K3j3QhQtZ1SD359+s5uMK3nqpJ6A8a8i60wrs3os73?=
 =?us-ascii?Q?xsUJdQFrOP3NlPQrcmH3ZOr9LsIsLPjEjSGF6eHW+/1Hsv6eGTE/7FBTyrFv?=
 =?us-ascii?Q?Ke5J9ReZNT6r7O5u8wkR1qWrpQEsYXyPbBFA2w5wcR2riP5Nio9IIeXn1FnJ?=
 =?us-ascii?Q?C3GccriKSubTAmGADGAsK5vdvNqROyOPSSjwaIPtlmKuwzIrgCclLdGKpA70?=
 =?us-ascii?Q?iGtveAxB93YQldy5rTaW/0/Nwy/COwSyiqXHH8aQV5+oM/B8Jbnau8LGNxDC?=
 =?us-ascii?Q?CHKd3x4J7mONzqaJL9wZWUwGpNp/ZpGvHy6Szl4kHD3e/T449orcZ3xA+Hp8?=
 =?us-ascii?Q?+SERgTqH7MO7HH4WtgRcZ2TjT0RkfLuGoIHZakCUADqkj2mUyfgYTyU79X94?=
 =?us-ascii?Q?F3gI9vfj+mwvE+BYocSHeuqp0/wSRy5iDpsjxgu9TCrZ9zsGBJhXTsZaej00?=
 =?us-ascii?Q?9xesLcNuk0/C4Uwck/Sd4XO5N3UXq6oZP9I8bNdO3Uh4L0/6VYiJmjPTTv+4?=
 =?us-ascii?Q?Z/dzIeH8+J28Pi80heDOUoJU+Gk3I2JwTbbpyzvcLNeK+LCEqcuSrHdJjjRH?=
 =?us-ascii?Q?xuEGA7fV/E44l3miyeCftlnK8BrTAT8Zm+1bsdOdWdgwNAhZ5qlOGni4msAF?=
 =?us-ascii?Q?+wcGBUdzfsaCPve02qY4zcGRAp/UeYYuP0pSF47GCrbfHSswqX0H8EFQ0hex?=
 =?us-ascii?Q?+eDSaMKy6Jhy5c0ksXfDfcjZcE3fz8WlnerLznS3K2SIM+W2i0ikBoE9qNU8?=
 =?us-ascii?Q?j6IMZTpl7lGDKv3kYDf+Gt1guRZhOFXVw1rv2aG7iPJS5AnCTkU3CUlbqsps?=
 =?us-ascii?Q?vn1RQ5hCFGDhTIOSZqwKeYlceudBd+pPjM1VqfOr0jdyWi9qg4ZzghxERV3x?=
 =?us-ascii?Q?YPlNi37v5xgTsqohKhqx7bGkLIARSkBEN+Zcnof0hxTH9Bx09KC30aKjrw33?=
 =?us-ascii?Q?oadOuAcXLIBW67a5bhbPdIWnVka6RsagcZQYdWmvKc/5VC5dd6l5c+SZ5RVT?=
 =?us-ascii?Q?E/7UpG1w0u45Sm2COysbbUaNoy915UrcY7uSQBnDOKpRwPZansDeqMkPEk0Q?=
 =?us-ascii?Q?eU1igGBl+CbVRkVigd9cC6MzkdHuSZImNE7hHSAD7B9xnWLU18/5hg8o88eF?=
 =?us-ascii?Q?VvM3s144vFo5rGT9h/KNC5ucLZO9JDMTqSpfVUERi1VykyPRZbqhpmp7C8Fz?=
 =?us-ascii?Q?YBRTMIjsMLHMQvhTqQzRxgw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4516.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48384791-a90e-4fa6-e09f-08d9afe9d037
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2021 08:01:40.4701
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WxewlpWA9AXvABzZe55Ov2Q9g3Ta1r8Mx9PQ0TmTHb4m1ZWNzfIPVhXrrHJ+MZMQETdv34tSJxSMK9KZu0Vo9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3178
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Danielle Ratson
> Sent: Thursday, November 25, 2021 9:37 AM
> To: Jesse Brandeburg <jesse.brandeburg@intel.com>; intel-wired-
> lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; Oleksandr Natalenko
> <oleksandr@natalenko.name>; Alexander Duyck
> <alexander.duyck@gmail.com>
> Subject: RE: [PATCH net v2] igb: fix netpoll exit with traffic
>=20
>=20
>=20
> > -----Original Message-----
> > From: Jesse Brandeburg <jesse.brandeburg@intel.com>
> > Sent: Tuesday, November 23, 2021 10:40 PM
> > To: intel-wired-lan@lists.osuosl.org
> > Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>;
> > netdev@vger.kernel.org; Oleksandr Natalenko
> > <oleksandr@natalenko.name>; Danielle Ratson <danieller@nvidia.com>;
> > Alexander Duyck <alexander.duyck@gmail.com>
> > Subject: [PATCH net v2] igb: fix netpoll exit with traffic
> >
> > Oleksandr brought a bug report where netpoll causes trace messages in
> > the log on igb.
> >
> > Danielle brought this back up as still occuring, so we'll try again.
> >
> > [22038.710800] ------------[ cut here ]------------ [22038.710801]
> > igb_poll+0x0/0x1440 [igb] exceeded budget in poll [22038.710802]
> > WARNING: CPU: 12 PID: 40362 at net/core/netpoll.c:155
> > netpoll_poll_dev+0x18a/0x1a0
> >
> > As Alex suggested, change the driver to return work_done at the exit
> > of napi_poll, which should be safe to do in this driver because it is
> > not polling multiple queues in this single napi context (multiple
> > queues attached to one MSI-X vector). Several other drivers contain
> > the same simple sequence, so I hope this will not create new problems.
> >
> > Fixes: 16eb8815c235 ("igb: Refactor clean_rx_irq to reduce overhead
> > and improve performance")
> > Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
> > Reported-by: Danielle Ratson <danieller@nvidia.com>
> > Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
> > Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> > ---
> > COMPILE TESTED ONLY! I have no way to reproduce this even on a machine
> > I have with igb. It works fine to load the igb driver and netconsole
> > with no errors.
> > ---
> > v2: simplified patch with an attempt to make it work
> > v1: original patch that apparently didn't work
> > ---
> >  drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/intel/igb/igb_main.c
> > b/drivers/net/ethernet/intel/igb/igb_main.c
> > index e647cc89c239..5e24b7ce5a92 100644
> > --- a/drivers/net/ethernet/intel/igb/igb_main.c
> > +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> > @@ -8104,7 +8104,7 @@ static int igb_poll(struct napi_struct *napi,
> > int
> > budget)
> >  	if (likely(napi_complete_done(napi, work_done)))
> >  		igb_ring_irq_enable(q_vector);
> >
> > -	return min(work_done, budget - 1);
> > +	return work_done;
> >  }
> >
> >  /**
> > --
> > 2.33.1
>=20
> Tested and looks ok, thanks!

Tested-By: Danielle Ratson <danieller@nvidia.com>
