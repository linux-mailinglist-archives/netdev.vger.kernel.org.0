Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACC9B57FDA
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 12:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfF0KCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 06:02:34 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54070 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726292AbfF0KCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 06:02:33 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5RA0l77003837;
        Thu, 27 Jun 2019 03:02:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=UYPlRV7WcvyHYgd0slzSqPC2V1PFh9WYR3tNLQNX6k8=;
 b=B1Fr/TJra2rblT/I06R00ezV15qgDtLgVzz5uN0k0XM0zgpb305PPPyQnRBt9EqyNMoD
 d7dOliAdOAK3bwksM0IHTJm5b6hEVZusDAVduDjkKSeaBb2Rsm5uqVBEUm1zg8USW9JD
 bSAcMVCWwcqMUAOzdq+8g60yUki82jB87B5+UBKi6Zg/6wHnMS0ecjwXOHPZh6Gi9gMd
 tPAW2zDZJ8rCoWkptXUCi6fcPV2515A7UXU3+p9SY6hbeaJ7xaO7PYkfBsjzTEI+pCJA
 ZpRMJjj2C+ZmezAZ+RhiFpcuBG+gyM6qn9GLPP2L47yTbj/pSWKeziQ5XIz3y5UIkkzQ LQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2tch69aeu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 27 Jun 2019 03:02:30 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 27 Jun
 2019 03:02:29 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (104.47.50.53) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 27 Jun 2019 03:02:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=uuCoLV6z7uDtvUnC6WfXY4F9AZd+F1DbXG8MHDduhX5G2YdOGa/arQsPPwWzvMZ3ou+uTGHnLyi/qo5WahYPDtUzPuSfs8Eu6/bLjhfsJ3KXuWyUo+aQQfwB15aOKdKHmkSEBGuWiyRHWDESAbGmj/pPjx9sUUdzI2wL0Jrq2Po=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UYPlRV7WcvyHYgd0slzSqPC2V1PFh9WYR3tNLQNX6k8=;
 b=JfuJro7p/D6rb8Fxu4X0XY55UrDKv1aDTEGhNwg1jr4a6CloLfKtoZW2q8r7nyjNnaq7bzz05Bsz//RfoSuY1wbN1+8uMr0gWpAPfjPNGnhELAmpJnlBZNnnxJoEnW62/yo6Gr5ZNiowgT+kf4UdSQrYlTHhyCFxL0H93VxuNZY=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UYPlRV7WcvyHYgd0slzSqPC2V1PFh9WYR3tNLQNX6k8=;
 b=PPVTQFINZ0NkQGsTfph9E3pdt4BT17bAzNcMeDONB3/hgnC/ZWn9CK6vSOZ0XlNns35LEYqyAkNBhUJ27be74rO8BV12++/b4LqydsUBbKEXSem0wHTn/bS4df2gtXE7h4mznt/POtFkboBy1C3sbqTVkEmRyyD8ru73KRU3ack=
Received: from DM6PR18MB2697.namprd18.prod.outlook.com (20.179.49.204) by
 DM6PR18MB3435.namprd18.prod.outlook.com (10.255.175.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Thu, 27 Jun 2019 10:02:24 +0000
Received: from DM6PR18MB2697.namprd18.prod.outlook.com
 ([fe80::4121:8e6e:23b8:b631]) by DM6PR18MB2697.namprd18.prod.outlook.com
 ([fe80::4121:8e6e:23b8:b631%6]) with mapi id 15.20.2008.018; Thu, 27 Jun 2019
 10:02:24 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     Benjamin Poirier <bpoirier@suse.com>,
        GR-Linux-NIC-Dev <GR-Linux-NIC-Dev@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] [PATCH net-next 07/16] qlge: Deduplicate rx buffer queue
 management
Thread-Topic: [EXT] [PATCH net-next 07/16] qlge: Deduplicate rx buffer queue
 management
Thread-Index: AQHVJOFJNghbNmq4ckeTCtv5h99OtqavUtiA
Date:   Thu, 27 Jun 2019 10:02:24 +0000
Message-ID: <DM6PR18MB2697AC678152A26AC676A1B2ABFD0@DM6PR18MB2697.namprd18.prod.outlook.com>
References: <20190617074858.32467-1-bpoirier@suse.com>
 <20190617074858.32467-7-bpoirier@suse.com>
In-Reply-To: <20190617074858.32467-7-bpoirier@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2409:4042:2192:124f:91a0:c28f:ff45:18bc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 047e3ea7-0d2c-4271-a7bf-08d6fae68d88
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR18MB3435;
x-ms-traffictypediagnostic: DM6PR18MB3435:
x-microsoft-antispam-prvs: <DM6PR18MB3435501452BDD1EDC3B8B18BABFD0@DM6PR18MB3435.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 008184426E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(366004)(39860400002)(136003)(376002)(199004)(189003)(2501003)(6506007)(73956011)(66476007)(76176011)(68736007)(99286004)(186003)(74316002)(6116002)(66946007)(305945005)(5660300002)(64756008)(7696005)(25786009)(102836004)(66446008)(8936002)(7736002)(81166006)(81156014)(8676002)(76116006)(66556008)(2906002)(4744005)(6246003)(256004)(71200400001)(71190400001)(14454004)(53936002)(229853002)(478600001)(6436002)(316002)(9686003)(86362001)(110136005)(52536014)(446003)(11346002)(33656002)(55016002)(476003)(486006)(46003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR18MB3435;H:DM6PR18MB2697.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1XQpFc4lljAc9L9jPhc5l8PCWpVOdwZD5oXxIxOsFlnTVmCbH8aUeeN8NA+Z4GH3viMQVJPbgXtHTeTihHokhlDdIihZXAjE+eCUSqBCctHgdJAZFcGTBLsY8MqNuY9qSslwuEG/5QLGDBJKgKMXdO6TVYMLeXkqibLrvhM+UTxPmZijLjW35xUDjGoHIR8/yHk19a0ZWHZBM0xm1O8cooQ1t8ZJwWS7d5ByMVbfUSSxE+5+vgVI/BonJoqj1QGW7nQBJC1UdJWNNeWnv1qbqHusyV6DP0beLHTjSgxrPCbDUt+VEN5wlXpHWa8Jh/0c5X/uSt6bKWTQxYnrYNahtz+rsloMpMVaNYDt9zyE3nEAUGu2+8chmvXYylAecIq5+sKzKmWEoAYPEUNBaWQV8/FzWd/rhSssy6q9duXBtjE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 047e3ea7-0d2c-4271-a7bf-08d6fae68d88
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2019 10:02:24.2249
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: manishc@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3435
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_05:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  	while (curr_idx !=3D clean_idx) {
> -		lbq_desc =3D &rx_ring->lbq[curr_idx];
> +		struct qlge_bq_desc *lbq_desc =3D &rx_ring-
> >lbq.queue[curr_idx];
>=20
>  		if (lbq_desc->p.pg_chunk.offset =3D=3D last_offset)
> -			pci_unmap_page(qdev->pdev, lbq_desc-
> >p.pg_chunk.map,
> +			pci_unmap_page(qdev->pdev, lbq_desc->dma_addr,
>  				       ql_lbq_block_size(qdev),
>  				       PCI_DMA_FROMDEVICE);

In this patch, lbq_desc->dma_addr points to offset in the page. So unmappin=
g is broken within this patch.
Would have been nicer to fix this in the same patch although it might have =
been taken care in next patches probably.


