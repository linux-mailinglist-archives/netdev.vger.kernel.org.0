Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A10F1DC147
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 23:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgETVVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 17:21:01 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:61324 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727006AbgETVVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 17:21:00 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04KLF74f011440;
        Wed, 20 May 2020 14:20:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=4owTVq2pFHzr88jEecRMzqh6XvDvsqQlqiMCaXgSAOI=;
 b=O94y9ZmxHYJ2IuDpbaQu+yQUZefh4gGu2wln3nUVGTh7kP3YGM2ZATGEPHwdfU1LoLL4
 NqcWzh0ZrHlwCrdpWLOyOziNcBs7NVdS2fA9RU5cPnZUd7hKWh6GEyZ0U9tf1IvQMTaz
 9BcBT9mMQl6xNIt6/zMtFSTkScwzvLhYPei9/x1hi5p3QeqzFNb+EDSX/dz0ZUhY9qrY
 A5EGsltgHzttQKN9UYXM1XbWj61LE3sOf1Cf8Camlh5+fEsGf9QfS8oMxojw6XRB/Zh4
 IufMe3oPIXYskj0oaX/xm25AuhXTzHxvSD3qR7x4JtlCMgXq0WQa7OoQyBRnjQEwqEs1 kQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 312fppadj1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 20 May 2020 14:20:56 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 20 May
 2020 14:20:54 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 20 May 2020 14:20:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TzIzCcGZ+YfNk3iXo/FfDbUNR3ZNZJvQfEihcKQpdLvZCw2e7iDWbj7TBCZf6b3Bi+CFg7R4ywRM14mvs5uiBFHpTGuSZhJuEM0rZYEuK8JF8T/LbVKAhQbv/oHs92edPzpEovEnjh+8GGYlSvbzZBowFDngwru1du1Y6MBR6yQGBvnEvlPnZTiu87I30i6cx6I13qOIfzYPqIuinevriI4Sp1rJUqKmoiopG3FVUrxb9+TBDeZo3vAqLY5BNBRe2A8OvVgZ394D2KSuI4fHg8W9Vl/+sdfGyV/lN9MXd840FTOI3eBCMjr4S0Nv8vaQSp4yQJR+ILvGo1pGTtAjkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4owTVq2pFHzr88jEecRMzqh6XvDvsqQlqiMCaXgSAOI=;
 b=F+YPCAxFDkG5Z1sZQHs3qVBBZPlm+cDRc3o/dtS/udSHfkR83FYzSlc/uMtiw02k97jJZeXnu0uvhFhtUDwtruEJEHarLa1z4E7PEZ0iniZ5wPk6bEWwb4X0g7svu+BKtyNFSLtQLqo4xuS/ABROkP74KSQ/CYkeVXRJdHxJ/bshDZWQ35sOU/zde0lycIWTNtnk05RaTK/rLzJgRTl+jTkiIytgMUsH1oXQXN4SJBJ1SRoWan4LmziWgvhKP9B/tbVQRtoNssrVfHUKOBjjuDN2BYDet1SFvaKhgTLdVlOrq9iR3hKqdiv5AYzWbyJmgBN4xRj+ZO67wk+ZRqjIvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4owTVq2pFHzr88jEecRMzqh6XvDvsqQlqiMCaXgSAOI=;
 b=mHT1dh7IeBZHwCJRLJZ2WtHG/yZILY7wNSV6pFgZnUFwNybi1dxSzYsEN8DFFyjzg1QPhwa6syM0Sd1PYIlvfAtZxR+lOzcJAWXiEtZLvmHuRJGO+owYSEFg9DojRjkR3rWVy6+IsOK6JoG0G0E30vIDvxgcYAPtNVD095dp5CM=
Received: from DM5PR18MB1387.namprd18.prod.outlook.com (2603:10b6:3:b3::23) by
 DM5PR18MB1193.namprd18.prod.outlook.com (2603:10b6:3:bf::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3000.26; Wed, 20 May 2020 21:20:53 +0000
Received: from DM5PR18MB1387.namprd18.prod.outlook.com
 ([fe80::dd59:7969:71b8:5754]) by DM5PR18MB1387.namprd18.prod.outlook.com
 ([fe80::dd59:7969:71b8:5754%11]) with mapi id 15.20.3021.020; Wed, 20 May
 2020 21:20:53 +0000
From:   Yuval Basson <ybason@marvell.com>
To:     David Miller <davem@davemloft.net>
CC:     Michal Kalderon <mkalderon@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net-next,v2 2/2] qed: Add XRC to RoCE
Thread-Topic: [EXT] Re: [PATCH net-next,v2 2/2] qed: Add XRC to RoCE
Thread-Index: AQHWLielGhnQs/Wa8kyF/4lkcPPdLaiv+/aAgAF+kjA=
Date:   Wed, 20 May 2020 21:20:53 +0000
Message-ID: <DM5PR18MB1387960C6A5D7E792A478DF9D0B60@DM5PR18MB1387.namprd18.prod.outlook.com>
References: <20200519205126.26987-1-ybason@marvell.com>
        <20200519205126.26987-3-ybason@marvell.com>
 <20200519.152335.968463052378721004.davem@davemloft.net>
In-Reply-To: <20200519.152335.968463052378721004.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [5.102.238.63]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ef286da7-141b-4af3-75ae-08d7fd03ad96
x-ms-traffictypediagnostic: DM5PR18MB1193:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB11936AA45C8ECE1892EECD2BD0B60@DM5PR18MB1193.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1284;
x-forefront-prvs: 04097B7F7F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HP7pQVSIjQ6vIX/WAhQLOKtVfTVhTrPKtoa+jX9TVvJ7iuc+bDl6ZmopHuF7tKJRa/EkOzG3EIzCOiT00QmTbLBJ3Yz0iH7BG0X0J6kQBQd57SNC0kAtXOEaPra+BJO1Fe8JbiwGavSS4O7QzrBm52RCpgx7AJ4OseEGxe2tK5O/Q+906NPj/Y7ZMZPChdwpLSbkRTAYOWX6SzbI3L38FWNG9Y8m/cxcMEXN5z/hPb/ff3tXCtx/SDNTTsKneYNEf3NBUFssIrVP+IrGoGGKrdp09pOhQSUahGkTJ84YO/EQ4E8DE7/0qeRGSYWRiCFdxK5/gijotNVd94wbDJypa4CXz30NOgZGFFR1E94RcrRq5+nSwxGUaZ+tOY0rF4dpxcHzgVKGU8rJzIK9lP35o/LMcbWjgq9lmoGqpLmdbtENv5QHU/HPvu9rxA7DG8+dGF97m1AIfA/SkCGT9upOYpq1/n/Ex6h+LB5i6T3jmkLDbvTd6ya7SINZPNKH3rHb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR18MB1387.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(396003)(376002)(39860400002)(366004)(55016002)(52536014)(4326008)(2906002)(71200400001)(9686003)(86362001)(33656002)(26005)(76116006)(8676002)(54906003)(6916009)(7696005)(66556008)(66946007)(66476007)(64756008)(66446008)(316002)(6506007)(478600001)(5660300002)(8936002)(186003)(142933001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: NxsnbL2ipcniL3vG8SJvJMVRF9lee9Y/7LaPnvgKSBDWl1QzvjJybcUAtwIGb5ngVTplTIQpuTBOC388WYt4YevzpMrDJxeXMF6qd/wW0lRbwj7JG0zJFfP8jpqQcqlR0ygaca2cqp07bQ/CP2u8M8oWtkZSW+7YQhKnVtDhhKdkNbuMHYlbSzUfap5CStzNliMfhnSji9yOFBh9IosctPJwrjTbJwbphA0W742BeIoXUaPGYJN3WPpiJyHHlmFwZvipmRFMM+C3XEa4vm1Fg1LAuCo9u7fpZUHBfcLkcxyPXSRacimh52Cp7I8xAAVRW2Va6dt0bvX4HJ/A22uqEe6+z5cQW5Hm+zJ1UhcPzWZmNTSJC2sCc2eXihTPw2eGE7a6Fh0FzKGSY5g2Nj0TovA0IrC66G6JxGOWT3A1TToa646Kwi7UgRePDKz8CFFyE8tZWjRkwfVB9DQBm3OKLdI0pMN+gQm6sncwX7O2pxM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ef286da7-141b-4af3-75ae-08d7fd03ad96
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2020 21:20:53.3743
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lhrojQWZoGfbY/kQu7rRSDr39NwhCUMgzHT2/A6rt7UM/RNNLPbvgJXWSLb5xGqZ4MNSuU54s0KOmGAftNnjpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1193
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-20_16:2020-05-20,2020-05-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Yuval Basson <ybason@marvell.com>
> Date: Tue, 19 May 2020 23:51:26 +0300
>=20
> > @@ -1748,24 +1839,26 @@ static int qed_rdma_modify_srq(void
> *rdma_cxt,
> >  	u16 opaque_fid, srq_id;
> >  	struct qed_bmap *bmap;
> >  	u32 returned_id;
> > +	u16 offset;
> >  	int rc;
> >
> > -	bmap =3D &p_hwfn->p_rdma_info->srq_map;
> > +	bmap =3D qed_rdma_get_srq_bmap(p_hwfn, in_params->is_xrc);
> >  	spin_lock_bh(&p_hwfn->p_rdma_info->lock);
> >  	rc =3D qed_rdma_bmap_alloc_id(p_hwfn, bmap, &returned_id);
> >  	spin_unlock_bh(&p_hwfn->p_rdma_info->lock);
> >
> >  	if (rc) {
> > -		DP_NOTICE(p_hwfn, "failed to allocate srq id\n");
> > +		DP_NOTICE(p_hwfn,
> > +			  "failed to allocate xrc/srq id (is_xrc=3D%u)\n",
> > +			  in_params->is_xrc);
> >  		return rc;
> >  	}
> >
> > -	elem_type =3D QED_ELEM_SRQ;
> > +	elem_type =3D (in_params->is_xrc) ? (QED_ELEM_XRC_SRQ) :
> (QED_ELEM_SRQ);
> >  	rc =3D qed_cxt_dynamic_ilt_alloc(p_hwfn, elem_type, returned_id);
> >  	if (rc)
> >  		goto err;
>=20
> This "if (rc)" error path will leak 'returned_id' won't it?
I don't think so.. this allocation is not part of this patch. It is handled=
 here -=20
err:
        spin_lock_bh(&p_hwfn->p_rdma_info->lock);
        qed_bmap_release_id(p_hwfn, bmap, returned_id);
        spin_unlock_bh(&p_hwfn->p_rdma_info->lock);
