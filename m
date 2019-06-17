Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E63747EB1
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 11:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbfFQJpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 05:45:06 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:56816 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725837AbfFQJpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 05:45:06 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5H9gBgf027410;
        Mon, 17 Jun 2019 02:45:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=XtYGVH7L+NoQgEwXA9+AoFpWNTlJTYVwd1SB2jouZF8=;
 b=j38IGT4OOnCxoFEhr8UCrgNkqLCQEK2UOBIn9xlIYpwSC5coD7m+Rh6yw990q4BvD2JQ
 MhRGQ+APmenprjfJFdrBJdSvC29mKiN+EzIED2n+DIXeHKFDsLrzdDbF11p+CSeP4aDU
 B8/j4bFurvdmkaMILDKpyhuwlmBLb+AcLiELCiRFp6a7bKScUDkpvGR8HSq4kzQTiwyH
 Bafm2QD2Rouj1ie3ljT4b25g0xFtrwnqv41rFSBxiOazr0J9VPkW68bH1tHDbUsomxHI
 Fdyq4QCXxa9LEMvY5q2n08W2wiM6defP6gnDACItzv0aBc45IhTUR3bzX1nBbiu82Trc nA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2t6537rpau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 17 Jun 2019 02:45:02 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 17 Jun
 2019 02:45:01 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.53) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 17 Jun 2019 02:45:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XtYGVH7L+NoQgEwXA9+AoFpWNTlJTYVwd1SB2jouZF8=;
 b=lE8RT7LMGF28DzhEr265MtxJgnQuFNFhxDqn2JzQ0PA6mbpnAwLt2HEa+iGN5INGXSn4Puyo9pWH7GIzF8YOs12M42X2hQIQsjnWMC2RN19pN/tbjp8kSoU9u2adRykrYTTLwQvb2ST8opYwrzxQwnExoDYD1mejYnJjuSqPWFI=
Received: from BYAPR18MB2696.namprd18.prod.outlook.com (20.178.207.225) by
 BYAPR18MB2645.namprd18.prod.outlook.com (20.179.92.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Mon, 17 Jun 2019 09:45:00 +0000
Received: from BYAPR18MB2696.namprd18.prod.outlook.com
 ([fe80::c9d6:760d:5638:aaad]) by BYAPR18MB2696.namprd18.prod.outlook.com
 ([fe80::c9d6:760d:5638:aaad%5]) with mapi id 15.20.1987.014; Mon, 17 Jun 2019
 09:45:00 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     Benjamin Poirier <bpoirier@suse.com>,
        GR-Linux-NIC-Dev <GR-Linux-NIC-Dev@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] [PATCH net-next 06/16] qlge: Remove useless dma
 synchronization calls
Thread-Topic: [EXT] [PATCH net-next 06/16] qlge: Remove useless dma
 synchronization calls
Thread-Index: AQHVJOFKsFfkJiFou0arRTjpXQmXAqaflWjw
Date:   Mon, 17 Jun 2019 09:44:59 +0000
Message-ID: <BYAPR18MB2696CEF6D42DAE1E467582ABABEB0@BYAPR18MB2696.namprd18.prod.outlook.com>
References: <20190617074858.32467-1-bpoirier@suse.com>
 <20190617074858.32467-6-bpoirier@suse.com>
In-Reply-To: <20190617074858.32467-6-bpoirier@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2409:4042:2285:e2f3:422:9a23:2377:cc2b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 705ab0ad-3d97-4aa7-2b14-08d6f3087702
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR18MB2645;
x-ms-traffictypediagnostic: BYAPR18MB2645:
x-microsoft-antispam-prvs: <BYAPR18MB2645E58CCA2BDD5D02423A7AABEB0@BYAPR18MB2645.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1169;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(376002)(346002)(39850400004)(396003)(189003)(13464003)(199004)(478600001)(25786009)(46003)(52536014)(14444005)(256004)(102836004)(316002)(68736007)(2906002)(14454004)(7696005)(229853002)(99286004)(2501003)(86362001)(9686003)(6436002)(73956011)(76176011)(6506007)(53546011)(66946007)(110136005)(66476007)(66556008)(64756008)(55016002)(486006)(7736002)(5660300002)(8676002)(11346002)(53936002)(6246003)(76116006)(66446008)(476003)(305945005)(74316002)(446003)(71200400001)(71190400001)(33656002)(186003)(6116002)(81156014)(81166006)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR18MB2645;H:BYAPR18MB2696.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7e7AjTB36ENqXAKsmuDsLLAG2PNKDdAvsrvWSX2yEA7YHXsjuAlWL8a0lOYtFEH6/THe5IIij07HY37QBJadxUy0C8BJYVgUCEzGP3GG8ZrY3qpiyaB6VJ5/5LaruQ9wZ3eErvfVaX4jQnRIVAAHwGJXNHP0Lh5sBiC4GqSfI0vc56r802XMdvd4MoGFHVpXcjuBEImjIc+Ts5JcrttCZgiqVxixmWrwt2i6xGOkgn8kY7VKDyLOaUprD5niZYsBEJMSlDz9d8AcjUYljlupTxLNvV7Ld7Jk0IhDCiad4svguHrZn+/6UMiG//eSA9AbXigvjt0sAHVdD3LiFYgi92IQ42VT75F1yl8iZ6Lj8lVt/T07osSHeoX3cjYbIU5HhBmoCejDCYdq98AWwPNpN8fHnt9nS3Er5PdxiwLgH68=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 705ab0ad-3d97-4aa7-2b14-08d6f3087702
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 09:44:59.9903
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: manishc@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2645
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_05:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Benjamin Poirier <bpoirier@suse.com>
> Sent: Monday, June 17, 2019 1:19 PM
> To: Manish Chopra <manishc@marvell.com>; GR-Linux-NIC-Dev <GR-Linux-
> NIC-Dev@marvell.com>; netdev@vger.kernel.org
> Subject: [EXT] [PATCH net-next 06/16] qlge: Remove useless dma
> synchronization calls
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> This is unneeded for two reasons:
> 1) the mapping is not written by the cpu
> 2) calls like ..._sync_..._for_device(..., ..._FROMDEVICE) are
>    nonsensical, see commit 3f0fb4e85b38 ("Documentation/DMA-API-
> HOWTO.txt:
>    fix misleading example")
>=20
> Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
> ---
>  drivers/net/ethernet/qlogic/qlge/qlge_main.c | 12 ------------
>  1 file changed, 12 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
> b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
> index 6b932bb6ce8f..70a284857488 100644
> --- a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
> +++ b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
> @@ -1110,9 +1110,6 @@ static void ql_update_lbq(struct ql_adapter *qdev,
> struct rx_ring *rx_ring)
>  			dma_unmap_addr_set(lbq_desc, mapaddr, map);
>  			*lbq_desc->addr =3D cpu_to_le64(map);
>=20
> -			pci_dma_sync_single_for_device(qdev->pdev, map,
> -						       qdev->lbq_buf_size,
> -						       PCI_DMA_FROMDEVICE);
>  			clean_idx++;
>  			if (clean_idx =3D=3D rx_ring->lbq_len)
>  				clean_idx =3D 0;
> @@ -1598,10 +1595,6 @@ static void ql_process_mac_rx_skb(struct
> ql_adapter *qdev,
>=20
>  	skb_put_data(new_skb, skb->data, length);
>=20
> -	pci_dma_sync_single_for_device(qdev->pdev,
> -				       dma_unmap_addr(sbq_desc, mapaddr),
> -				       SMALL_BUF_MAP_SIZE,
> -				       PCI_DMA_FROMDEVICE);

This was introduced in commit 2c9a266afefe ("qlge: Fix receive packets drop=
").
So hoping that it is fine, the buffer shouldn't be synced for the device ba=
ck after the synced for CPU call in context of any ownership etc. ?



