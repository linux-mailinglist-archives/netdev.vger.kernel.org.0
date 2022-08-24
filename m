Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A464059F341
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 07:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234695AbiHXF5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 01:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbiHXF5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 01:57:21 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4278A1F7;
        Tue, 23 Aug 2022 22:57:20 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27NM4lrA022828;
        Tue, 23 Aug 2022 22:57:03 -0700
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3j4x5h3yuk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Aug 2022 22:57:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LEqSsCLP/ugndoxTA3DhF/STDvSUvVK3qp0QPSZ3XZrL7qzM3BUXxMHWMioNParerI70wOSl+TK/w0WXxSvpi2SsAr0liRbYzTKxbZbwBqzU44AW5ZhqFRfltxwjfcwblF3fYcQtMW15X2bWv1hMkuJWlUubNNtfeNzJp5O5+QvTAhzTm/wE4bSNZZQxxg2WSqHKRLGJPEtm9D1RNu8WJY84ieX95vnH2Mw6r+0fgJ/3u22ARPiIfNlngpvFdtu267PizF8lA7UJOf9EedcIil30yquekEOiZ3Yt9EV6RHjxpz7Wssc4HHef5KC3DS1xECRIk5Aqe+yVkez6hWTxGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hOiMbwRFdP4uoiZzDBx8KomCY9yj990j/3PcIyN3tYE=;
 b=Cfwd3KzbFmPHs4XELnfOQ2zZGPNYws+rXp8hB2Ah8tC+aj/jLE7Qcx0NdZ+nAKVDBiokIwke5VgzPoH5ytkNBNvrE/yFeyg0k4/6nkDj4tfjs7CAqGlo80kiRuoFBB0Yjq+BMwR5eFcuiUbEJon0o3GRJiIaeaUdZN8oY0olN3yk7dQoR9I/Fo6oj/DdrUJoIw9x9DGKD8wn+rFt/aHg2tkYD39a/jw4vwFb/Q3Rxad1iEDPqaBEfDyNUNAdupVP9s9k8fO9ynUXAc0S94kugVYfNO3p0CzBAP7MPURh7FljoP2g8OLSDwZF6h1iP4mo0cM+H8K8FHD6uZhkkQ2eYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hOiMbwRFdP4uoiZzDBx8KomCY9yj990j/3PcIyN3tYE=;
 b=opNFujrBWwtOrymIpSKHWSPhtIRGDeIorbcXivCKdkDF3TagVF/z+L43a3tCpkzapEbfX3g9Hkg0mEXXKeEdmeLsleitHRUqaa/jr8rYe8n0tCtezb8u7KSJwqvn6fqWuQGnEpwVEj3ibDUNGSiKa/EPQv0/MYwgDWJsmVDXfT0=
Received: from SJ0PR18MB5216.namprd18.prod.outlook.com (2603:10b6:a03:430::6)
 by DM5PR18MB2216.namprd18.prod.outlook.com (2603:10b6:4:b1::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Wed, 24 Aug
 2022 05:57:01 +0000
Received: from SJ0PR18MB5216.namprd18.prod.outlook.com
 ([fe80::a0cb:528f:3593:e24]) by SJ0PR18MB5216.namprd18.prod.outlook.com
 ([fe80::a0cb:528f:3593:e24%7]) with mapi id 15.20.5566.014; Wed, 24 Aug 2022
 05:57:01 +0000
From:   Suman Ghosh <sumang@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH] octeontx2-pf: Add egress PFC support
Thread-Topic: [EXT] Re: [PATCH] octeontx2-pf: Add egress PFC support
Thread-Index: AQHYtr3HeGi5pSU58kec6ewncZP3f628or2AgADq/hA=
Date:   Wed, 24 Aug 2022 05:57:00 +0000
Message-ID: <SJ0PR18MB52165D5FA51E433CAD0E8CBBDB739@SJ0PR18MB5216.namprd18.prod.outlook.com>
References: <20220823065829.1060339-1-sumang@marvell.com>
 <YwT3V6A4xrS3jAqf@lunn.ch>
In-Reply-To: <YwT3V6A4xrS3jAqf@lunn.ch>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90ae6e4d-de1b-47bb-bfee-08da85957675
x-ms-traffictypediagnostic: DM5PR18MB2216:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OgKSpsVhoclcnD8SUWNSSdzfiyNBfzOxZ0zK6gk/QEi0N8whjx7dRM52mjtpzf5r6MjWd6wuSnVDJ47MTseW6ffuyJxUOWRcMULlnLQzyztqhPlaWeN8YgPNpBdhxux5KLAIDyuzbdBWDgwneLSQraT9I61UREWYSZEBM4BZP5ibPpKteej5SY+EQ/lAWaJNl0IUax5KzHxP/JllMJSmVcxXB7r43IlSzIP5ef0xCqnZN1tMhitPtmrAMzcDZovfStJkWRIol/4Gx7SxloRR39xVITm9rAzl/TM0+ZYwYRRukjA+qKJMTB+Pnhq57GWxIFfodDeBT19zwV7+Iw0ftU14H3/LZfWud6MeBnIw/yRt8C50T+aRv3nzG+M+KOzxiA/Ts8Xozbk58KP3QU9Hw3H6rFHfJ0Ci8rDWo4M131QGH285USNbYgNM/+7g1eNXyyfvFAo2sDj5WkafCgZgtxg8HUPETyXCezaKOwDhPSrPS775GmhWHhdxyDK8h/tUkZyHywmV6tFoW+1U81/Qp1Hq4xT40FZ7LTQgSnVjRVN7D/t8Vr8ywXP7lB2xMlJNTQsQ3nq8vjLUzD7SZN0UGPGn7iDnJUn++k34/a5vlff6a35eSXNUM/2NsBHjOlzCFjR75aqGCGtw/FiMo+mocbi+JpYKidKDlnLzg0exYsaczFmv1bNqrzPbRAdUGkWvG4Pka8kGPXlFa2WeK8+fg4rfVN1nRit5UGQhNSo/xn5NeTqvPGC7YCsSRS33lyCv9PXy1M80Ie3Yds42QLuUKg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB5216.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(478600001)(52536014)(8936002)(38070700005)(86362001)(71200400001)(2906002)(4326008)(76116006)(26005)(186003)(66946007)(7696005)(6506007)(83380400001)(9686003)(66446008)(64756008)(66556008)(66476007)(8676002)(38100700002)(316002)(55016003)(41300700001)(5660300002)(122000001)(54906003)(6916009)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eUS03PzhUEkMEZAREFFQHIYL5sZyvGw9653vRZPCqQG23uuexVcMnsZzwuzH?=
 =?us-ascii?Q?LFw/wMxGaV8B3Wan68pW5irpDss0Mrgkp44fHv8iAZOUeBKySIhtVZfRFIZa?=
 =?us-ascii?Q?cbxSZIfjBYf6yl3tfp+WJkLHRJ8FyGHmpgHJvx7D9RTgOWaxlm4mTmRiiUFG?=
 =?us-ascii?Q?1AHvUu1cDFUj6AeoJawJxAQlHVmuUcTCZSZmwYhikONSE4MowQ9bqnhf3wQF?=
 =?us-ascii?Q?ackvrXQLEDel95cgjUIg51dbidz2cI/Mka6YXVKu+M0oTkX+l8yutx1qvLeC?=
 =?us-ascii?Q?Y7eHfBF75SBWkC7BCXO19KzpL/J1GkFBZ+OhCO3deGSWkesAt+WxN26q+1mV?=
 =?us-ascii?Q?CgtEEOvpvep6NFsBpAJT9UHF7hT1ji52+mZnOrHfxAkkIpppp3WxLuzXy8TB?=
 =?us-ascii?Q?ZtaQkJwv/Ny4y9a2LHSx28psLL1MQCCuj746JsxFDMF/RCrj3YqKvNMmIY7t?=
 =?us-ascii?Q?vaBmCWIusrDUke1TPSUYRaJVDdg+P8cDPw/to/3jXWsGKfG1QHm+bgqM2Ul3?=
 =?us-ascii?Q?2GwTqDGmpSMvKlXS1F7bPml1yxGCdNEH2/kUryMYfna6rwEeOijtXXQ+z9hW?=
 =?us-ascii?Q?4GkNrhQZJZJIIOrcBiAkyC3ZntoH9KpqT1eeeBJj+YulpGN92fXt5Ro/rYkX?=
 =?us-ascii?Q?U0P75B0Zn2rXdoeXCO/ryIE2FKWicfmuSkVmCrhA0LBi2fCH5F9iuNNJsoZI?=
 =?us-ascii?Q?3pN7MBvSJ/xQid0WIKlQkYE4uevOLpkcjWptMZQw5zkA2/6bD5orpC16C0Px?=
 =?us-ascii?Q?Cr/IaFTR8yO7JOZ0tTEvHdHZdoqQ5OXt2NNw8MWsfgiyQqPfBlYUd77nIfIi?=
 =?us-ascii?Q?oIw712I3yQqNOo+TCeDiIR03cN9TFd5jr5iqCWD4BCtTkhOGmY0eO357Fnr7?=
 =?us-ascii?Q?5/jxURn+K+HLQrv3cDbeuNwcgECCOMKGsIj/EH1grSNtSLROBNQPkEDe5yV5?=
 =?us-ascii?Q?8KhHCnIB8cojXIdrwGUyIWhkGnHrMhWHppsdk5GmRTU5uZ8jbyo0e/S699Te?=
 =?us-ascii?Q?0PX+iGTG+5hCgeQz8cJqsinwNvt+quQqUdAhGMSfs05GLDNVZFq3Z1RByoOg?=
 =?us-ascii?Q?PL2QDkJV94NnOWPV1easNyS7pT9VgzEXPx+cmdtcVP2jpj19gyF6e96SJRoY?=
 =?us-ascii?Q?7IN9NhYQR+PhfTajVc0aUKS4HSUs5SU4QpJAqzTNNXPleEMgWIzZZFE3Bskn?=
 =?us-ascii?Q?L6jmipGJmqzPwJpbMDW0AminoH/Em2VExwq1TDL4su3hmRLnLNl5aI1RAZBP?=
 =?us-ascii?Q?uGXiGjP9YU94lr2mKol6mw3s2LTUJS8jqZGZ8kBjY0k+9fdVTSmtHSMp28bK?=
 =?us-ascii?Q?mRE6/darkv+kRYggY1YrUTC+9xHnSbVbGgDHz1UoozwTeFydElwrHx22u39O?=
 =?us-ascii?Q?2+XlGLfmpBKZXcc/CAGSNx8j1R+AgzU8qzgjbOTYi8iq9ZQUMPSXMtRsp0o5?=
 =?us-ascii?Q?Ecz+vqiGenfUvLfEMqICyJ4TxVIGw3wgHXvJt2fv/kx8wmB5ECLmbj1qJQ8N?=
 =?us-ascii?Q?coH/a3qzdygrxQkDmzaOt4cQ7JvC4OelbYgIVOt6mxAjLIlCg7P5MIMdotz7?=
 =?us-ascii?Q?S+/lm8OseBGN9Y2irHCIDTSZlMZqnEilV63lOssC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB5216.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90ae6e4d-de1b-47bb-bfee-08da85957675
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2022 05:57:00.9771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RpO1CGd7oOcD84lMVmyN7VUKJ3axzY0/Qlv9zIrqZ9pl7lEhEc8YUuUsTEzKUd+4+Jo34Peipe6QogIG5XBFcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB2216
X-Proofpoint-ORIG-GUID: qbbEUU0A-mi3c3M0ghigV0rfFurLzb10
X-Proofpoint-GUID: qbbEUU0A-mi3c3M0ghigV0rfFurLzb10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-24_02,2022-08-22_02,2022-06-22_01
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please see inline

Regards,
Suman

>-----Original Message-----
>From: Andrew Lunn <andrew@lunn.ch>
>Sent: Tuesday, August 23, 2022 9:21 PM
>To: Suman Ghosh <sumang@marvell.com>
>Cc: Sunil Kovvuri Goutham <sgoutham@marvell.com>; Linu Cherian
><lcherian@marvell.com>; Geethasowjanya Akula <gakula@marvell.com>; Jerin
>Jacob Kollanukkaran <jerinj@marvell.com>; Hariprasad Kelam
><hkelam@marvell.com>; Subbaraya Sundeep Bhatta <sbhatta@marvell.com>;
>davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
>pabeni@redhat.com; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
>Subject: [EXT] Re: [PATCH] octeontx2-pf: Add egress PFC support
>
>External Email
>
>----------------------------------------------------------------------
>> -int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
>> +int otx2_txschq_config(struct otx2_nic *pfvf, int lvl, int prio, bool
>> +txschq_for_pfc)
>>  {
>>  	struct otx2_hw *hw =3D &pfvf->hw;
>>  	struct nix_txschq_config *req;
>> @@ -602,7 +602,13 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int
>lvl)
>>  	req->lvl =3D lvl;
>>  	req->num_regs =3D 1;
>>
>> -	schq =3D hw->txschq_list[lvl][0];
>> +#ifdef CONFIG_DCB
>> +	if (txschq_for_pfc)
>> +		schq =3D pfvf->pfc_schq_list[lvl][prio];
>> +	else
>> +#endif
>
>Please could you try to remove as many of these #ifdef CONFIG_DCB as
>possible. It makes build testing less efficient at finding build
>problems. Can you do:
>
>> +	if (IS_ENABLED(CONFIG_DCB) && txschq_for_pfc)
>> +		schq =3D pfvf->pfc_schq_list[lvl][prio];
>
[Suman] I will restructured the code. But we cannot use pfvf->pfc_schq_list=
 outside #ifdef CONFIG_DCB as these are defined under the=20
macro in otx2_common.h

>> +#ifdef CONFIG_DCB
>> +int otx2_pfc_txschq_config(struct otx2_nic *pfvf) {
>> +	u8 pfc_en, pfc_bit_set;
>> +	int prio, lvl, err;
>> +
>> +	pfc_en =3D pfvf->pfc_en;
>> +	for (prio =3D 0; prio < NIX_PF_PFC_PRIO_MAX; prio++) {
>> +		pfc_bit_set =3D pfc_en & (1 << prio);
>> +
>
>Maybe put all of this into a file of its own, and provide stubs for when
>it is not enabled?
[Suman] I will move these APIs to otx2_dcbnl.c. This file will be compiled =
when CONFIG_DCB is enabled.

>
>     Andrew
