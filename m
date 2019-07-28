Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9E877D25
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 03:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729097AbfG1BjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 21:39:23 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:1900 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726240AbfG1BjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 21:39:23 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x6S1dJCl003565;
        Sat, 27 Jul 2019 18:39:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=oKnK6U5Dox5sfEv48v0PFY/FdOLI6IUH36HvgFiA94k=;
 b=iCz9kulA9JZU7EKu7Ykur/MZ8BHPYOcfISv761kk/h8PJG8qSEEGOd7ET++Xqv+PZddh
 Wb0M3DgMBCrXOwtHyP29NH1V1hnw2oUBM0FLKq++tmLvIC7puxnf7pWRAc4fkfO8uGhV
 tDm4We3c1mR4S2/v+NehlJlYpdTyfGNSPVTTNDJGGmRapNGxPrffq4IpYQX1KAOyBHBk
 +4+fuxfV9Tnm1rdQqC+XjZNXF55uOD5KRJqF9FsUsO+0AEXVChrFMa4yhw2R6Mv4j68s
 SZ+1f4wvC74iRTjSnbP5H9e4J7Adm4yuB7HrklxH7iRnwdotmFmAEuKf0koybegFngKe Xg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2u0p4kt15w-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 27 Jul 2019 18:39:19 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Sat, 27 Jul
 2019 18:39:18 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (104.47.41.51) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Sat, 27 Jul 2019 18:39:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SCLwMn9Z7qo2DG9Il/NhqKLsYbF22xmHOhhhwC52uqR59nM0tnWhw8mvChOKxFsuYZs53NSfiTWRFE5c8IcGMroN/1Oy8iF8inlUodq/nzV+zSCXMlkqwI0bgRqhVQT6xOEpCbs/xeBYFkk6SPbjzkv8Ac4RaIc1Rs1ebiCyVGghnESAtJUeG42t/qcw/lHl3UoOLDsVb7f8HCu3nH0nlzF3Ypx77PRNSk69V7jlQTYtAUMbgtdsazuOnVOGy0O+P2Dnym+ZKf0RDo+MXYAnAO3U3SV5L4Y8vLnF546ufwLMOQTY1xR1WjMk6RCYVu3GUZNjRdaNeE4yn7NP+js9bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oKnK6U5Dox5sfEv48v0PFY/FdOLI6IUH36HvgFiA94k=;
 b=g7bSU75TIi2guuK0xoZcy2Tl1imn2d6CNmWmhnwAW9h4GXrCbfBaJtBnK6fyLJbl0atRsIzJuWXGfDoqicKu8X19dBkgCEB5pquDzSAiwgrCOMFHRzSXT39C1paHXL1iS/LRIopLUuobMw4lz7JL5aa2UyqOt7cDy6ahc99u220ciNUO4N4PuOV3KijFpTOga1zQ3I0wOrbaqz8ySCicu25tsP3ZTmB40tzeZBFBXf5I8uoYc06xBHZpihInLJBu0mAjWyfiYBF7CTcoWLwRJ78tYFoyn44IGVOrQoKB/ppQ4o+jwliKOPQCeCfPfK+prYtqEo1i0g0Z2Er4hBiIxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=marvell.com;dmarc=pass action=none
 header.from=marvell.com;dkim=pass header.d=marvell.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oKnK6U5Dox5sfEv48v0PFY/FdOLI6IUH36HvgFiA94k=;
 b=NhvjfOdaBrWz7r13uEQe17cYl9s9ZU6ZGLSSvrjiu1yF7/Fkk6lgaBWCJGq+gaaN6aUb/wlhwydcJZZ4JV6lVECtgwDoTx59wJEe5b2njjwu5mJjTRjGMgjdYq8rawjs4JLMxvAU6ThZ2pDO9FmwdzQyRXKPdrxM55K+chkZ9v0=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (20.179.80.86) by
 MN2PR18MB2733.namprd18.prod.outlook.com (20.179.21.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Sun, 28 Jul 2019 01:39:16 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::cd80:d44a:f501:72a9]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::cd80:d44a:f501:72a9%7]) with mapi id 15.20.2115.005; Sun, 28 Jul 2019
 01:39:16 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michal Kalderon <mkalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>
Subject: RE: [PATCH net-next v2 1/2] qed: Add API for configuring NVM
 attributes.
Thread-Topic: [PATCH net-next v2 1/2] qed: Add API for configuring NVM
 attributes.
Thread-Index: AQHVQ8owtVZg7F5nzky6rHH8PIXJXqbe9Q+AgABNFYA=
Date:   Sun, 28 Jul 2019 01:39:15 +0000
Message-ID: <MN2PR18MB2528F94900CC673887E23D19D3C20@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <20190726155215.25151-1-skalluru@marvell.com>
        <20190726155215.25151-2-skalluru@marvell.com>
 <20190727.140029.1705855810720310694.davem@davemloft.net>
In-Reply-To: <20190727.140029.1705855810720310694.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [42.109.144.223]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd5ba6e9-5f64-422b-1cc6-08d712fc66ba
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2733;
x-ms-traffictypediagnostic: MN2PR18MB2733:
x-microsoft-antispam-prvs: <MN2PR18MB27336963680260C142DE6349D3C20@MN2PR18MB2733.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 01128BA907
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(396003)(39850400004)(376002)(366004)(13464003)(199004)(189003)(4744005)(446003)(66556008)(64756008)(66446008)(66946007)(86362001)(66066001)(9686003)(74316002)(5660300002)(76116006)(486006)(66476007)(7736002)(256004)(53936002)(305945005)(55016002)(11346002)(53546011)(6506007)(478600001)(71190400001)(71200400001)(2906002)(68736007)(476003)(52536014)(14454004)(8676002)(186003)(81166006)(81156014)(8936002)(7696005)(99286004)(6436002)(25786009)(6116002)(6916009)(3846002)(26005)(229853002)(102836004)(107886003)(4326008)(33656002)(6246003)(54906003)(316002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2733;H:MN2PR18MB2528.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Y8S1NXumhaWiJ+5U4i2lGKy6enR4qCEwrHuuGDtAxPkzmAt0nAPtGdjGr3+BTeGPwkEWR8ricYsuFQ5KeU5ZzEOAQS5um7BLZ5DgylCsYOBE6Lj2JZm3020bxqqZRp36qFDe3/1aTl8P1pUHx5v4WWfnIj6ZneTf+xdjzKxS2C1Wq+v3XWQ/OEuBDQDBACh7TcaBYPQtXWHx9G6DzW97kqAhH4C+yz1sf3dM9ZQyY6wjpB0+B5SDDmcQ8/vvA/noGlvXpVpS5zbQP5vpG+/jsn/chbqTHfLJN32FzmW0eUDQLCxWIMmQjxU4aZoHqYoQ5bfNXAVRj2Z0YYx9FtvugDz3MvFQf2xr1PLbz2U08ITdsDJqZmv4Fx3CFKrw/HZ3X9pqgF1pqy20f986/+684yeVUeTfb8lkIh6PVEcGc/E=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dd5ba6e9-5f64-422b-1cc6-08d712fc66ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2019 01:39:15.8967
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: skalluru@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2733
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-07-27_18:2019-07-26,2019-07-27 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of David Miller
> Sent: Sunday, July 28, 2019 2:30 AM
> To: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Cc: netdev@vger.kernel.org; Michal Kalderon <mkalderon@marvell.com>;
> Ariel Elior <aelior@marvell.com>
> Subject: Re: [PATCH net-next v2 1/2] qed: Add API for configuring NVM
> attributes.
>=20
> From: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Date: Fri, 26 Jul 2019 08:52:14 -0700
>=20
> > +int qed_mcp_nvm_set_cfg(struct qed_hwfn *p_hwfn, struct qed_ptt
> *p_ptt,
> > +			u16 option_id, u8 entity_id, u16 flags, u8 *p_buf,
> > +			u32 len)
> > +{
> > +	u32 mb_param =3D 0, resp, param;
> > +	int rc;
>  ...
> > +	rc =3D qed_mcp_nvm_wr_cmd(p_hwfn, p_ptt,
> > +				DRV_MSG_CODE_SET_NVM_CFG_OPTION,
> > +				mb_param, &resp, &param, len, (u32
> *)p_buf);
> > +
> > +	return rc;
>=20
> 'rc' is completely unnecessary, please just return the function result di=
rectly.
>=20
> Thank you.

Thanks for your comments. Will send the updated patch.
