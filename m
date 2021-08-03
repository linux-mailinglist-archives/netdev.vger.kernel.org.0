Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046E33DF259
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbhHCQTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:19:31 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:9478 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233096AbhHCQT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:19:29 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 173GHUcJ024266;
        Tue, 3 Aug 2021 09:19:06 -0700
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by mx0a-0016f401.pphosted.com with ESMTP id 3a6sfubf7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 09:19:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EehZbXs7Kg9vPTTEfx0It20r5pIBf7u870tsQ116710AhQL3GqPpfITtKAZ+8hy7qKkOZnQh+IFFdKE1/yILXzowLSDAuRtfbTTfKdYixWJKbbwF1DH+/NQiLDOT9owIqq0/uE8Jkp+gewWZpcoXNKKyBt4CFWzzm4VFy09c7ZfL8tH3SxeyYSkX17L159CCC/I2hyvj0MpV25MuIOKdj9P7HwbUGxJVlDsxjvBF1NHvHXcapCDsNDaRQmL95q1oEdH2Upwh3/T7uTLzkio/a6ZpfQ0QBLGzIINhDuQmaLnqFLQvHmzvujySiVc4wQn5ZnEVoxNr0ZIcBR/OJtKYKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=be4AZtxIzJNnKRRpIGxJkKED67XTrQHz6YU9+OWQ+Mk=;
 b=n5UzwS6e4DSEuYUMpGHmhuJr3rjxqus1PaoVvgJjT8Wl153eI0SKb4gVxeHHjCq40w4UNJJtP3CD2SdpSSwydXzliOV3MHfC6OXCHq0Q+LMyaURg10VjBoN1/5taO6v7N5y9wZHVg4KrLpnhLEeevwurZGg14cB87ef8+TID0EMNBbyd0352VKq/ACaX0pUPbHDFTKBvJQ08AiuYDEzUim1hRnX/V6VbLrlSDYM3YgZJ5aG2IDPz62mkW3AE3n7wcFm59LUEUotuTOE/BkE86nbW/+sMdgauHjWMAftBqWXssppJI5pH15aE9fBGmaOwzWzcDHuY6WBryBCm4g/mEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=be4AZtxIzJNnKRRpIGxJkKED67XTrQHz6YU9+OWQ+Mk=;
 b=C5jMfcUEG4T6Q0HIsvPAu+dSm8zq02Aemfuhng3LWoOHwh4UsoX0eGbYiK/R8Bx6KwZg0g9wCCzm95vkr8K+TPE+hCIEUlON5tvj6qoAFM7kk6suhRbcYOATaRnoOMSjz23xRcQV1MFQ7VjcZvv9teYVjijyExjYlhKKzVj61Ww=
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com (2603:10b6:a03:2eb::24)
 by BY5PR18MB3297.namprd18.prod.outlook.com (2603:10b6:a03:1a1::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.24; Tue, 3 Aug
 2021 16:19:03 +0000
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::fd4c:1017:996a:d8c5]) by SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::fd4c:1017:996a:d8c5%9]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 16:19:03 +0000
From:   "Volodymyr Mytnyk [C]" <vmytnyk@marvell.com>
To:     Ido Schimmel <idosch@idosch.org>,
        Vadym Kochan <vadym.kochan@plvision.eu>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>,
        Mickey Rachamim <mickeyr@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Vadym Kochan [C]" <vkochan@marvell.com>
Subject: Re: [PATCH net-next v2 4/4] net: marvell: prestera: Offload
 FLOW_ACTION_POLICE
Thread-Topic: [PATCH net-next v2 4/4] net: marvell: prestera: Offload
 FLOW_ACTION_POLICE
Thread-Index: AQHXiINGT+iNhw1SOE6nI3my9wPbFQ==
Date:   Tue, 3 Aug 2021 16:19:03 +0000
Message-ID: <SJ0PR18MB4009243B42CB9A03C2C35647B2F09@SJ0PR18MB4009.namprd18.prod.outlook.com>
References: <20210802140849.2050-1-vadym.kochan@plvision.eu>
 <20210802140849.2050-5-vadym.kochan@plvision.eu>,<YQgN1djql6wOk8dc@shredder>
In-Reply-To: <YQgN1djql6wOk8dc@shredder>
Accept-Language: en-GB, uk-UA, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0fa38c0b-f896-4698-7699-08d9569a6930
x-ms-traffictypediagnostic: BY5PR18MB3297:
x-ld-processed: 70e1fb47-1155-421d-87fc-2e58f638b6e0,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB32973ED164EF3B22674D5571B2F09@BY5PR18MB3297.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fkvSmy7+tmjXj2yZH7ylxxn3OnAiDjX77JSz+CdWUl7btsBnbDvUgnY7o+HctCbjL9w/Dom2wOCTltrx+xWPTVz5chPodR/Yff3gjlWgBv4So/NEzrj6r+vtLVFAnWW1APih0LYwPnxK7UCVrhfg73ikEJJxAsrnnYqF2vNFNNkKyuCCSsq3Xeuy20c3yRBrGPyBGkFeihTyHwIeapMwMMeuoWiqfUdpOiBkB7H7HPCklk1uslcw/FWQt5ICZedHULuTR9l+CcJ9jPyHQCe42e7YMPyYWF/+K1gVjsyBDZeuFh1LVSnA0mSItwzBC4ciSiNo/rthsPeEwvS5Jg/R2vlsQEKvfmzIXAXx4Hc94NIk+TFULLPVca9pyP1hWwn2MZrOecXJL1Mxsd218SNZRrqoXN1qPybSQrn8Rm/nMOJyEJRh3PEGxshYGo7Qjvrd8lvXW8QvDiqcvrWb4Auu60AnFe8LIRPmFFq+JG/yCKmg6jZuD4j2FWUJ5MrN4eETnlmgpCM1j576cDtz1ontmEYUdYSTPnlqhTyTY4BLnshuKoaQ/Y4smSq84us/QAo8XtFpHh4E+DKoJYW0oUYkA1IirzBwfTE+cD6Ju+46zEnvTkHEkKob7m8eP7aH7jOPyWY8CI4g8ClcD3fQ7fUnJY2eTzMuri0Q3Xi8y2LnW58h/9Z48KX3Fx/M0OHefrxg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB4009.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(396003)(346002)(39850400004)(9686003)(55016002)(122000001)(86362001)(38100700002)(186003)(66556008)(33656002)(66476007)(76116006)(52536014)(64756008)(66446008)(38070700005)(5660300002)(66946007)(7416002)(7696005)(8676002)(8936002)(55236004)(316002)(2906002)(110136005)(83380400001)(54906003)(6506007)(26005)(478600001)(71200400001)(4326008)(107886003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?yZwtFNdKtBHFef5eBPKMvOVveNgEE6BMtPTCuVxxVGV0vYsoMgJNGxQe4m?=
 =?iso-8859-1?Q?xtQ6HEU9RVhCAGemtH8oQDorDGnh1I9GcWZeLkJGxsNZkqT7JmCCPns31/?=
 =?iso-8859-1?Q?jzMBF13JK/xnmiI0zAG9EfaiiYqqQxX3wWgDK+DLrxqUF6OEtFnWBTXffl?=
 =?iso-8859-1?Q?GHig/P6PoBJBxJHseotjX2e2OTcojJQdXEw7OMB96U13RU/JJt6DxYGcj2?=
 =?iso-8859-1?Q?KxE+y9y6cXhyXQ+H5dqQZ62DYuBx/LxLHt0eqYOc2tlvXL5a3omzDSoBPi?=
 =?iso-8859-1?Q?a3f53/soB0zvoDLDFx/IJZKABACgPDucF6De9SMy5LsTYhWtlj6ZiJYTYD?=
 =?iso-8859-1?Q?rYRahyyfciHhNXW3P+nlQtiL6iPTdKAvznIr+fwy8W2AuO84PrE2JtTFBN?=
 =?iso-8859-1?Q?bln+o0uxUPPMhh3CNsy68jgvBW5d1JJy/fA/VRSkbr4rxwLQCBNiApluJp?=
 =?iso-8859-1?Q?vQAzcmP8p2VVRauoIMp8GqbJ8ATRV3LWOzozHwXwRsH98m7m4RE+27ZA6T?=
 =?iso-8859-1?Q?zPB1I5pze+OwEIfhM/urhC/KAl14RSH1SXRsEIZAdAsUPQE9TxQGrcX+p0?=
 =?iso-8859-1?Q?Za7V9mPJRfoYr8xuWwacGt/bN+lFRDO/8AG4Ws6lJkf5lGinv0zch5/e00?=
 =?iso-8859-1?Q?EIeRBiTlZfLsOmg8zzk+2HIilZFyABmAL3p4kjnrPnASIiNINqiXFvdO/1?=
 =?iso-8859-1?Q?ILYGOtm98UkFkXOZcnmIKUwSVRk5+wMVWy1eXSpzeDcSG/ueTowomq9z52?=
 =?iso-8859-1?Q?7bHsYe+5D2NBahz4gwOw/BxrgrbxEcM0OOIhS9aax7JWIlapNKV6Lh7fY4?=
 =?iso-8859-1?Q?IMPz8kLvbyZ1GvXLyKwKtaEyJ3Xs1MV9ctcGbbzawcJMtgGxVnmiNfR9rJ?=
 =?iso-8859-1?Q?hwdjbNNeawB81NY5k+H9TrMVIpDIrRj9Q6Ioes5OYMBeWAOfzbZCB7jDo2?=
 =?iso-8859-1?Q?1+12rgrQ8+PFT+gM9/zrM+HfeVf78xQHkT2PIF0UoLUOn7116wbrLHW+6H?=
 =?iso-8859-1?Q?D6Pn/U+FTwskg6IjrmP9aDmFVTQOWcaoKvW9KyZRdE0Tg7nKuX6Dy70TTz?=
 =?iso-8859-1?Q?ICq61xOYAo+YuJy7Gl42gxr+sJ4N8TLHKGt8YklcgSzgnkRPvRDn4lsMoD?=
 =?iso-8859-1?Q?+ffKCS/wRnOBnMdf36H62mArNoz+gtuOGF/W3G0iXMc5FQViAcmnO/iT08?=
 =?iso-8859-1?Q?BtxMgxnLDZ1XRIcK5PfuLFF3D4pAJGe+XTAYRs+PDg73fletCflsrud1HQ?=
 =?iso-8859-1?Q?+Nmr+y+5lDgLBKMwAptjv52GYTgalRS6CAGRR/o18=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB4009.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fa38c0b-f896-4698-7699-08d9569a6930
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2021 16:19:03.7938
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QiGFy7MbXpLwtssQiNha37g/wrp4+eFojLDFqzeDCwN+atkXAxZWdvUpaDfty3kxtFpTQIbyC6t/FhUHeCrglw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3297
X-Proofpoint-ORIG-GUID: 2M6-GAX0CdHQ_iWG-yDdZh4XlxCcnS9c
X-Proofpoint-GUID: 2M6-GAX0CdHQ_iWG-yDdZh4XlxCcnS9c
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-03_05:2021-08-03,2021-08-03 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ido,=0A=
=0A=
Thanks for the review. Pls see the comments inline.=0A=
=0A=
> On Mon, Aug 02, 2021 at 05:08:49PM +0300, Vadym Kochan wrote:=0A=
> > diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.c b/=
drivers/net/ethernet/marvell/prestera/prestera_flower.c=0A=
> > index e571ba09ec08..76f30856ac98 100644=0A=
> > --- a/drivers/net/ethernet/marvell/prestera/prestera_flower.c=0A=
> > +++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.c=0A=
> > @@ -5,6 +5,8 @@=0A=
> > =A0#include "prestera_acl.h"=0A=
> > =A0#include "prestera_flower.h"=0A=
> >=0A=
> > +#define PRESTERA_HW_TC_NUM =A0 8=0A=
> > +=0A=
> > =A0static int prestera_flower_parse_actions(struct prestera_flow_block =
*block,=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 struct prestera_acl_rule *rule,=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 struct flow_action *flow_action,=0A=
> > @@ -30,6 +32,11 @@ static int prestera_flower_parse_actions(struct pres=
tera_flow_block *block,=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case FLOW_ACTION_TRAP:=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0a_entry.id =3D PRESTERA_=
ACL_RULE_ACTION_TRAP;=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;=0A=
> > + =A0 =A0 =A0 =A0 =A0 =A0 case FLOW_ACTION_POLICE:=0A=
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 a_entry.id =3D PRESTERA_ACL_R=
ULE_ACTION_POLICE;=0A=
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 a_entry.police.rate =3D act->=
police.rate_bytes_ps;=0A=
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 a_entry.police.burst =3D act-=
>police.burst;=0A=
>=0A=
> If packet rate based policing is not supported, an error should be=0A=
> returned here with extack.=0A=
=0A=
Agree, it makes sense.=0A=
=0A=
>=0A=
> It seems the implementation assumes that each rule has a different=0A=
> policer, so an error should be returned in case the same policer is=0A=
> shared between different rules.=0A=
=0A=
Each rule has a different policer assigned by HW. Do you mean the police.in=
dex should be checked here ?=0A=
=0A=
>=0A=
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0default:=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0NL_SET_ERR_MSG_MOD(extac=
k, "Unsupported action");=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pr_err("Unsupported acti=
on\n");=0A=
> > @@ -110,6 +117,17 @@ static int prestera_flower_parse(struct prestera_f=
low_block *block,=0A=
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EOPNOTSUPP;=0A=
> > =A0 =A0 =A0 =A0}=0A=
> >=0A=
> > + =A0 =A0 if (f->classid) {=0A=
> > + =A0 =A0 =A0 =A0 =A0 =A0 int hw_tc =3D __tc_classid_to_hwtc(PRESTERA_H=
W_TC_NUM, f->classid);=0A=
> > +=0A=
> > + =A0 =A0 =A0 =A0 =A0 =A0 if (hw_tc < 0) {=0A=
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 NL_SET_ERR_MSG_MOD(f->common.=
extack, "Unsupported HW TC");=0A=
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return hw_tc;=0A=
> > + =A0 =A0 =A0 =A0 =A0 =A0 }=0A=
> > +=0A=
> > + =A0 =A0 =A0 =A0 =A0 =A0 prestera_acl_rule_hw_tc_set(rule, hw_tc);=0A=
> > + =A0 =A0 }=0A=
>=0A=
> Not sure what this is. Can you show a command line example of how this=0A=
> is used?=0A=
=0A=
This is HW traffic class used for packets that are trapped to CPU port. The=
 usage is as the following:=0A=
=0A=
tc qdisc add dev DEV clsact=0A=
tc filter add dev DEV ingress flower skip_sw dst_mac 00:AA:AA:AA:AA:00 hw_t=
c 1 action trap=0A=
=0A=
>=0A=
> What about visibility regarding number of packets that were dropped by=0A=
> the policer?=0A=
=0A=
This is not support at this moment by the driver, so it is always zero now.=
=0A=
