Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4E542BBDC
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 11:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239219AbhJMJqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 05:46:09 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:46020 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239162AbhJMJqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 05:46:08 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19D8TMmE003710;
        Wed, 13 Oct 2021 02:43:52 -0700
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bnkc5thja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Oct 2021 02:43:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hBAAyXkMzbzcJjUILfMI0HVkkhFpHDP9IuA9XUsHwSr3ba5NmXdVF5xzfTzpYaNYSedopRh+bhH3kKCMGoncqODbVUns1SJlGLODZio5ZrCuWkqkz1V/4PgNPcFtKi+xsqj16afRjYHwc+wh+MoLqH+88aGt+1W3SZHtotCDEzGY1jAVM3R24xs6d0ywRY5ZSWITzt6dZ7DH81V9/yPQDy0GL0lVMHsgKis7UO+zdX4x1HuMejJdve6DYdK2WEJtjsg9W6Zg5v2uyxWmQigNrjVxUBSNAUGg0nkWq61AOsMHDA8Q3IW6r99/hOLXhUWn2fS3ZZXC4FJdljKjrDokOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=undyd0JdP93BfRsaV3evOlHL2mLLUTGvEkYIIwzwYMw=;
 b=Yf2VJZIOybTkU6AJaelIA/rC8c9zK+bIdhdZknKp+XqfeDPghdImy/4RJ86kIgFOo6UJkCAhrFLeUUTS7/zogvzsN33oA0LpJtgHsWBRsTfUOGo9+lBerUqWvqWUigRA0Vere6afrwvaUdmjDa6Rd+iMesLc7Mf3r45D8boL+MehtlbGZR83ursci1fqUn5u8tvdY/MDtC7q3+CSmxAck/RluXkNaY1uaShzOVUWcUHdHgQCo1ySYVXMjnXCbDtnAS1U4667DeqWru2iTv1HU2fpt0yVVxvNNLsgkYT+FaigADuWCMnAHkPk++B+Hcss3RJtrEsTuAXoEj1iJfcc7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=undyd0JdP93BfRsaV3evOlHL2mLLUTGvEkYIIwzwYMw=;
 b=TqKb2mKNkjTDAOb77radwSy5Era55Tbr7vzg/5YpsZEfenIfcsuKKF6XF/kI6gRuiX8xe+8c3Zl8EjApmbHSYhz2CSX6OMsrpHae/Cf1fZ11xzRFg65mYxosyBHVSZzNny/JOauHW/wypQauNb/S/Xw5QW4HkNeGbFvMgl1+8EI=
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com (2603:10b6:a03:2eb::24)
 by BYAPR18MB2725.namprd18.prod.outlook.com (2603:10b6:a03:111::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Wed, 13 Oct
 2021 09:43:49 +0000
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::919c:1891:e266:2502]) by SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::919c:1891:e266:2502%9]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 09:43:49 +0000
From:   "Volodymyr Mytnyk [C]" <vmytnyk@marvell.com>
To:     Vlad Buslov <vladbu@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] sched: fix infinite loop when creating tc filter
Thread-Topic: [PATCH net] sched: fix infinite loop when creating tc filter
Thread-Index: AQHXwBbSHT7r9n75L0yIMY0i0tQ89Q==
Date:   Wed, 13 Oct 2021 09:43:48 +0000
Message-ID: <SJ0PR18MB4009D2CF6AA2DFF25732A4BFB2B79@SJ0PR18MB4009.namprd18.prod.outlook.com>
References: <1633848948-11315-1-git-send-email-volodymyr.mytnyk@plvision.eu>
 <ygnhbl3vbrto.fsf@nvidia.com>
In-Reply-To: <ygnhbl3vbrto.fsf@nvidia.com>
Accept-Language: en-GB, uk-UA, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 8f2633f7-da5b-97e3-6fd9-6ae1180685ec
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6557299a-d108-46c4-efc6-08d98e2df563
x-ms-traffictypediagnostic: BYAPR18MB2725:
x-microsoft-antispam-prvs: <BYAPR18MB2725FE6E76C659918E15DFEBB2B79@BYAPR18MB2725.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LGmem2rwgh8Wvf2pjOcg9IrcpqGRJC05XDZNN4263Jaaf/+ymw0OVFO/ovVB6yPYf6+aBhVzxCCyjrHvI6dSkEM8N7s0sQ4vdo9tkAWn1o55uNGnBvEADnuU7nSxRrSHmUtAqvbBN5DQQmyKv8Cli7tG6S37W+bCVpIYjeVeN1S6u/d+hkszr7zUYHWHP7maY7DtQTe4rwXCo9is9b3XKOutQp0j3dNEHgG+yOTKqrxvuAjldwl75i75jCHqgjEQG9OE/cmrJTqlJb5cWutiSeFcv0f3O65mhzQxwbcxIIi1e476+Se55eWe/YTxTSGLwDGduTZaUrtMDXcX3rnZmS9nM7PUiOLWwXwNtNFvqDoMXz2dWxEEgUmskdjrIdtkLHl+oN50d5YfDJbSjm6MSy6F6ynm15KW3GPj2qEtdy6egzXQhMRWLi5qIu/6RiEEj/J4GKlJO0LDaoxeD3mTTLmS1O474Tqm0x45aFSV1QF632iWJtxMWus8Sm7uSMlczpSj6AKg1MbhYcedsBiX+CtjyYwwlQ96JKT3ObcSi4/G/nXM18r1qtce+7hMIK0A7oscXczdhBnVzoTxtuQhIRryisdNJI8cOMqlw5+7tE6k9jnxu31gDYiu9mu1t+5zd7rwHrktflsbW5xdahwclLLUcJrigqqXwY5+tdKmoEmnpJVRz6ru+2zw3Qy4ob6eCobl7/PwTAAPgnlheujruA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB4009.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(6506007)(7416002)(66946007)(8936002)(316002)(52536014)(508600001)(5660300002)(6916009)(26005)(7696005)(186003)(54906003)(86362001)(38100700002)(66446008)(2906002)(66476007)(64756008)(4326008)(9686003)(76116006)(8676002)(66556008)(55016002)(122000001)(38070700005)(71200400001)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Mfl92Z+njR2tWKRdDormHQCXSX+FwUcf5UcSIRHolp9VHG7tIh/+oslt2h?=
 =?iso-8859-1?Q?LYf2vynJU5PdPBPO3jV0YpFeBF4kcvsZg9B091jLddmaxhuoDBLCO5r8wY?=
 =?iso-8859-1?Q?1Q11fiPcb8xEIXVXpJuHwJ9x8/1vY6Gr0WqWaOiDuBlfRJr8AHmywIBVia?=
 =?iso-8859-1?Q?2AfIEzuBi9/jGI3rPW0cp1BvnRThUCtSO1lLTUZnj95Q0se3Su+nmyOZ4z?=
 =?iso-8859-1?Q?MFOZ+GrKYvTpbc2c7HYX+HdgoxovHumkg6bj4xUartT8LUa6dxuS3TmWbd?=
 =?iso-8859-1?Q?9IePCfA9fU1+S97maym+CNrMMw91I2l3gWkqVtU2x4UIKfg1HuIFll9fa8?=
 =?iso-8859-1?Q?D6ojfQBCwD/LYM0Qyt+EzLIjgMrB8+/RKGTSUa3uiz1s6WYBXo+SGHU3OI?=
 =?iso-8859-1?Q?uiJFig5Fn7pm+wWCYPgS0/SH03Gmtb93W/Jxb3k2qGaQG4eCqJ5mAseCpl?=
 =?iso-8859-1?Q?SPPBjNrIYLzq34MTSXdSLMWcfoB+iIXcLj47jUta+augIltLqqcnG9HkUK?=
 =?iso-8859-1?Q?HGcMbGiWZQj0TYmRsXfBp0etxabMaCnty+AJffbpx5HEk8x9Os1swl4oxV?=
 =?iso-8859-1?Q?k2dKTNUREQlwPg1XjBE3kfx13pDkvZd9IW2iFdA6/lhaNJiQVzCXZP4kCp?=
 =?iso-8859-1?Q?A5YI2Hos0VOPoVHITV7W3FMS1CpgVtinnvfhgyWlZLssdwsPwzYIOUoC7b?=
 =?iso-8859-1?Q?C4x/PdBU+++3x4OAsHXSuK0E1B3JiF7CHZZUSy30m5PiQyE+aK5II984q1?=
 =?iso-8859-1?Q?CimuWjk+Q1REWYRhOmaTu1zB0Ra/x3q5aIJpjRjxE4hMcFBOwrkKx/tDU9?=
 =?iso-8859-1?Q?H3FfWHWSDhIu6ZcRDVWqBoGBmr0oXv0BHUcEmcbtYc6edZsBJJtSUjBPN5?=
 =?iso-8859-1?Q?gMgpPAg6gq3yhjraoqGrFKtz7UiKNigr0Zt5CQedgEt6ZddGEi0Q2HLnQO?=
 =?iso-8859-1?Q?xpZdtvzL94dUi/AXdlnVZ3EQSk+WuWSzjCRQ9EsvGV6lhGVLTYGO6s482m?=
 =?iso-8859-1?Q?vFFUfLfe43CzLfIANEbRkE8I1clsQzoInlttByH5vKJE7kLomDejDPOa4S?=
 =?iso-8859-1?Q?t0J2nan9I6DsE2ZxoNR6OB+X44bZwlWPRDgyO8IwLUK8SdW5ckhFXLPpey?=
 =?iso-8859-1?Q?FnjUo3y/6YKZ+Q7bx6mtGWRYBD7IEbVla7uxzkD6XpiwXRIbzZYVshhgOF?=
 =?iso-8859-1?Q?FonuQner88h7Z0hE4z1IatXfqI5JK/TfX3S5tFjqfikiGaWt55tG8VuyHP?=
 =?iso-8859-1?Q?2kv5il7Ooyb45QHWJHEPDIGnQl//KYv8SUAQ5m8OzhDWnQNAaAthfhmHcQ?=
 =?iso-8859-1?Q?iDhP8PiGtsBN1HpZgEox5A2mjqWxnAIEf9SoPRBm2378g6w=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB4009.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6557299a-d108-46c4-efc6-08d98e2df563
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 09:43:48.9802
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ECTqMzkU5d1VO/tDhuFfGwZqEubQ9amT0CZf1Z8jSW0pROhH5/MrQRoKHSgdOvpFhXnRyKYgbGeCiYkUeJq+2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2725
X-Proofpoint-GUID: kJNswArZ3w9fm-qd7iUEK9MNinJYO54g
X-Proofpoint-ORIG-GUID: kJNswArZ3w9fm-qd7iUEK9MNinJYO54g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-13_03,2021-10-13_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vlad,=0A=
=0A=
Thanks for your review comments and good explanation of the problem you obs=
erve. I will=0A=
take a look at this and will back to you.=0A=
=0A=
Regards,=0A=
Volodymyr=0A=
=0A=
> Hi Volodymyr,=0A=
> =0A=
> On Sun 10 Oct 2021 at 09:55, Volodymyr Mytnyk <volodymyr.mytnyk@plvision.=
eu> wrote:=0A=
> > From: Volodymyr Mytnyk <vmytnyk@marvell.com>=0A=
> >=0A=
> > After running a specific set of commands tc will become unresponsive:=
=0A=
> >=0A=
> >=A0=A0 $ ip link add dev DEV type veth=0A=
> >=A0=A0 $ tc qdisc add dev DEV clsact=0A=
> >=A0=A0 $ tc chain add dev DEV chain 0 ingress=0A=
> >=A0=A0 $ tc filter del dev DEV ingress=0A=
> >=A0=A0 $ tc filter add dev DEV ingress flower action pass=0A=
> >=0A=
> > When executing chain flush, the "chain->flushing" field is set=0A=
> > to true, which prevents insertion of new classifier instances.=0A=
> > It is unset in one place under two conditions:=0A=
> >=0A=
> > `refcnt - chain->action_refcnt =3D=3D 0` and `!by_act`.=0A=
> >=0A=
> > Ignoring the by_act and action_refcnt arguments the `flushing procedure=
`=0A=
> > will be over when refcnt is 0.=0A=
> >=0A=
> > But if the chain is explicitly created (e.g. `tc chain add .. chain 0 .=
.`)=0A=
> > refcnt is set to 1 without any classifier instances. Thus the condition=
=0A=
> > is never met and the chain->flushing field is never cleared.=0A=
> > And because the default chain is `flushing` new classifiers cannot=0A=
> > be added. tc_new_tfilter is stuck in a loop trying to find a chain=0A=
> > where chain->flushing is false.=0A=
> >=0A=
> > By moving `chain->flushing =3D false` from __tcf_chain_put to the end=
=0A=
> > of tcf_chain_flush will avoid the condition and the field will always=
=0A=
> > be reset after the flush procedure.=0A=
> >=0A=
> > Fixes: 91052fa1c657 ("net: sched: protect chain->explicitly_created wit=
h block->lock")=0A=
> =0A=
> Thanks for working on this!=0A=
> =0A=
> >=0A=
> > Co-developed-by: Serhiy Boiko <serhiy.boiko@plvision.eu>=0A=
> > Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>=0A=
> > Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>=0A=
> > ---=0A=
> >=A0 net/sched/cls_api.c | 5 +++--=0A=
> >=A0 1 file changed, 3 insertions(+), 2 deletions(-)=0A=
> >=0A=
> > diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c=0A=
> > index d73b5c5514a9..327594cce554 100644=0A=
> > --- a/net/sched/cls_api.c=0A=
> > +++ b/net/sched/cls_api.c=0A=
> > @@ -563,8 +563,6 @@ static void __tcf_chain_put(struct tcf_chain *chain=
, bool by_act,=0A=
> >=A0=A0=A0=A0=A0=A0=A0 if (refcnt - chain->action_refcnt =3D=3D 0 && !by_=
act) {=0A=
> >=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tc_chain_notify_delete(tmp=
lt_ops, tmplt_priv, chain->index,=0A=
> >=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 block, NULL, 0, 0, false);=0A=
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* Last reference to chain, no ne=
ed to lock. */=0A=
> > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 chain->flushing =3D false;=0A=
> >=A0=A0=A0=A0=A0=A0=A0 }=0A=
> >=A0 =0A=
> >=A0=A0=A0=A0=A0=A0=A0 if (refcnt =3D=3D 0)=0A=
> > @@ -615,6 +613,9 @@ static void tcf_chain_flush(struct tcf_chain *chain=
, bool rtnl_held)=0A=
> >=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tcf_proto_put(tp, rtnl_hel=
d, NULL);=0A=
> >=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 tp =3D tp_next;=0A=
> >=A0=A0=A0=A0=A0=A0=A0 }=0A=
> > +=0A=
> > +=A0=A0=A0=A0 /* Last reference to chain, no need to lock. */=0A=
> =0A=
> But after moving the code block here you can no longer guarantee that=0A=
> this is the last reference, right?=0A=
> =0A=
> > +=A0=A0=A0=A0 chain->flushing =3D false;=0A=
> =0A=
> Resetting the flag here is probably correct for actual flush use-case=0A=
> (e.g. RTM_DELTFILTER message with prio=3D=3D0), but can cause undesired=
=0A=
> side-effects for other users of tcf_chain_flush(). Consider following=0A=
> interaction between new filter creation and explicit chain deletion that=
=0A=
> also uses tcf_chanin_flush():=0A=
> =0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 RTM_DELCHAIN=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 RTM_NEWTFILTER=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 +=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 +=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 +----------v-----------=
+=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 __tcf_block_find=
=A0=A0=A0 |=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 +----------+-----------=
+=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 +----------v-----------=
-+=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0 tcf_chain_ge=
t=A0=A0=A0=A0=A0 |=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 +----------+-----------=
-+=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=0A=
> =A0=A0=A0=A0=A0=A0 +--------v--------+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=0A=
> =A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 |=0A=
> =A0=A0=A0=A0=A0=A0 | tcf_chain_flush |=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=0A=
> =A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 |=0A=
> =A0=A0=A0=A0=A0=A0 +--------+--------+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 +----------v-----------=
-+=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 tcf_chain_tp_find=
=A0=A0=A0 |=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 +----------+-----------=
-+=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |tp=3D=3DNULL=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |chain->flushing=3D=3Dfalse=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 +---------------v----------------+=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 tp_created =3D 1=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 tcf_chain_tp_insert_unique=A0=A0=
=A0 |=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 +---------------+----------------+=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=0A=
> +---------------v-----------------+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 |=0A=
> |=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 |=0A=
> |tcf_chain_put_explicitly_created |=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 |=0A=
> |=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 |=0A=
> +---------------+-----------------+=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 |=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 |=0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 v=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 v=0A=
> =0A=
> In this example tc_new_tfilter() holds chain reference during flush. If=
=0A=
> flush finishes concurrently before the check for chain->flushing, the=0A=
> chain reference counter will not reach 0 (because new filter creation=0A=
> code will not back off and release the reference). In the described=0A=
> example tc_chain_notify_delete() will not be called which will confuse=0A=
> any userland code that expects to receive delete chain notification=0A=
> after sending RTM_DELCHAIN message.=0A=
> =0A=
> With these considerations I can propose following approach to fix the=0A=
> issue:=0A=
> =0A=
> 1. Extend tcf_chain_flush() with additional boolean argument and only=0A=
> call it with 'true' value from tc_del_tfilter(). (or create helper=0A=
> function that calls tcf_chain_flush() and then resets chain->flushing=0A=
> flag)=0A=
> =0A=
> 2. Reset the 'flushing' flag when new argument is true.=0A=
> =0A=
> 3. Wrap the 'flushing' flag reset code in filter_chain_lock critical=0A=
> section.=0A=
> =0A=
> >=A0 }=0A=
> >=A0 =0A=
>=
