Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF783EC81F
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 10:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236672AbhHOISn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 04:18:43 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:11426 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235569AbhHOISn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Aug 2021 04:18:43 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17F607Ia015747;
        Sun, 15 Aug 2021 01:18:11 -0700
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by mx0a-0016f401.pphosted.com with ESMTP id 3aeb6na23a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 15 Aug 2021 01:18:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cpx72oBUOa6j6fusvTGbNb/jcUQDeRKo1ouYMyv1ecH7Wphg86jg1R7dOA1fAHnuG/DsF99qsKKkoVgtmUKJYKV54LmbbH3xDf3+ciKJwkNBt/kKChz5emwmLpBaQKfSJJhecRoCNUKt9KjcQBVBVxOl1CQcdm6gdi4KzYHxwQawum7SxmHsqE0sm+rPOEZ4/VirZh4+q7bhA/HrWgHiCW9c4ncxsthKfYPbJ8FTPILG0mz76l80pgQrxheuwk2wrgX+jo6sapoOUJIJ8irJpKPtBcidbIv16MvKbMEEBJst6c2BJ4ufidhlq2VZXhC/kRjyyrBrqO2pn8iHCQjqow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NOhhh2T/PKxk0Hl7ZL7ZoeZmSkAJ60U1jq58IoPlAdU=;
 b=EW+t7GqqZJGbnuNeDMKEyboykS5hRKAGHkCFVz8nSr4JNe5CE2OYulSWqPE5D5czh71QYx/mPuFVyGoEjRvXvglL//jfWEm8DVY61mpGgkcQHafgX1UmjP2pEjcB80zpdIUT7Pk+9V/oAdi+dhfDJR8AqIu5LvkV4wEn8LriPPobvOEuWsF9O9qClwkvB4x6GedDg9MssslLo2+EAONIeeFEn18SPSA0+aYWrDVyZiFZlJ1WKLbKnWcGPGxbUUFBQ1h5cwfyKGPt60AEnWcSX+wzRFPWksRQvjdAmt4yvHNHBRwFCBiefn7PDMZZrI+EeZeahARMIPDbvBJe/TJkDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NOhhh2T/PKxk0Hl7ZL7ZoeZmSkAJ60U1jq58IoPlAdU=;
 b=vIVu1ZmMmRQ4hXCWoKBCfXsU57PYX6V5N2vP7ks/wVcF8ux8AgfmEQ+72WvFxJXKxuFZ5yrJYGr8nHZpsDobQkYKldhjFbpSmBICHQcNtb0Sb6TjPLUpMIDO913+yFfNVNCxQ/2VE9CzwMzlraOpW0H2WogaK44QlZVsiTxyA3A=
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com (2603:10b6:a03:2c8::13)
 by BYAPR18MB2581.namprd18.prod.outlook.com (2603:10b6:a03:13c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Sun, 15 Aug
 2021 08:18:07 +0000
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::6513:d2ca:d44a:537c]) by SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::6513:d2ca:d44a:537c%8]) with mapi id 15.20.4415.022; Sun, 15 Aug 2021
 08:18:07 +0000
From:   Shai Malin <smalin@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>
Subject: Re: [PATCH v2] qed: qed ll2 race condition fixes
Thread-Topic: [PATCH v2] qed: qed ll2 race condition fixes
Thread-Index: AdeRrYY8+3S2+pLdSTO8kr15w1WakA==
Date:   Sun, 15 Aug 2021 08:18:07 +0000
Message-ID: <SJ0PR18MB3882F27A79F4913034FE9E70CCFC9@SJ0PR18MB3882.namprd18.prod.outlook.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0cbf8b43-d3c7-42d5-b348-08d95fc5367d
x-ms-traffictypediagnostic: BYAPR18MB2581:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2581D5EEB95F38DAEA2CFED2CCFC9@BYAPR18MB2581.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bDG+/AXRjWhGyyfncOE1h9lDQss6I/56jJkkz5oYYoeHaG7M4PvgG1ZEh35WGLD7L/JajI06sY8gWsDL4mELqBHU3dG4++KBeihqpI/yLxXlNeXH8LLIX4cS8xn09vv03xOclvcBe83Mv0zH1AXxCCpVnPGi7BGDQwdvTT9rvCxGvgTMCJ3SIBuRK7iiKYgZ3q51HQO3Z3zTXnsJx/E6OXlc9EUtVupp1lkW6aw2z2bFXT/gJ2LN14TKCrif51HfQ5a7iV/FRqtI06R0wK60YwQvf2sRb4O3j2Jvh7Bb0cWi7ZDGigPTFabwXFf98rbUU2b6PRV36aHfKmflzYoYJ6ZcvBobSwLcM6k8iKmvcXc/jMWSgO7xej4HhuQQ2ADCO7o0tDgYAeCrACC4+Zdifjo5e2OnTrEyA3TyvSsTUMOKYcYAlH/IiROTWXuUe72mt9X9ygYa73Db5i7z8cH8G62yXUGgvCp/idbltlF4Rhkow8iyla/i9I4zad594mdqnJI0k1wFd8Bi+BnpPpFon15LeW4TTxEo1lGwJV2QufWro+hO1dB9PM5jtAf4N90Eyr0YR9P+NAgMoj4XaUsxJ+G6jLf3ez4kxHlsIOjDeL9ibjC1zOepPfQ2hwZp5vHJUhVgWy7rof/fExTKROfkR1pF/e7xyOM4FrEwgVYtYGzjn+PQ0B6pi+KbqabzCpo9QX5YU2MiXgKn4jvCA5s6EA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB3882.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(346002)(39850400004)(376002)(33656002)(6506007)(38070700005)(76116006)(478600001)(2906002)(54906003)(71200400001)(52536014)(55016002)(83380400001)(9686003)(86362001)(66556008)(66946007)(4326008)(6916009)(66446008)(316002)(8676002)(8936002)(186003)(66476007)(38100700002)(122000001)(7696005)(64756008)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zAMpwQ2cpnJXFqGR5+VEvGdAeos4Olwtc4afs8/jB9gOEGuVO2lKeiUTNgz+?=
 =?us-ascii?Q?hfkCCmnBrzwlqoJQSFAb6+P+7YnwKP6MmQcsZ2NVsDBm71FQ/8zzQUso0SY+?=
 =?us-ascii?Q?YKW+AW3XJ5m/YrGnlnr6Eypwa5fbkkBmxqtDVDgQIiEwNkUKQ7VjMJjLqjYw?=
 =?us-ascii?Q?Z/FwIKCyWLsMOkY/T7EZ0LUNHQgnuQjkbDTed6iQGQzqJWrfgmUQKv93+aDq?=
 =?us-ascii?Q?KU3O1pVp9Fmb4Tss/PRSMYFTqpd4zTC5YlfOIIKsRbuPFd0p3JtL6QCte11F?=
 =?us-ascii?Q?flq66pXPiqjKU2f32HGQnCSoFvnjTXO+Dp6B5R8ZSrk4XcS4SG/XVbqmiCvU?=
 =?us-ascii?Q?FKJO89svojhrTl0A5hc6Obi+FPm5lMI6Whl5w4ouP8T+jvKvcXXTC5E/Y3H3?=
 =?us-ascii?Q?qjqgsUFVigGhnHhd5DntdYGhsvxq2AMheA3cBz/K0m0zb9JDnpZMIZMoXhu8?=
 =?us-ascii?Q?IuK+sLOU4fGf8DWMFg3ruUux51VdZwsxMt2UA6TGNm8zcm7mFWM7gzJjrvZp?=
 =?us-ascii?Q?u9+tbrHbOGZWRBaSCZ+c8+MZFUSKVizY4kk7b4aqTY+SDugJigokh/UK2jAP?=
 =?us-ascii?Q?4ONBXs7sn71vCUQA8Qo2f0oL69cwqhIzWE+yuVQmlJkZ5ZvZVp9O0ad9u6FG?=
 =?us-ascii?Q?wS5KNanQqAi+RsBoHvLOPXxQi3I7koUReX1555Bu678ME0g07/i9VD07JTdq?=
 =?us-ascii?Q?J0ncYV6KpgAEoihHkUyIFjdpS2ght5izzxW7gzO6ru57TNvQgv5N7+/jfzHu?=
 =?us-ascii?Q?X58LBZwLheC1ZXgmuOWSKATqb65x9q0nBBlbrVTqW7E1yM/8JT4eh97mjNkX?=
 =?us-ascii?Q?w3RVHYKiDd6laZ7/JjLQZVZIpwxWEW+KmfygRbc4idmrw16QyiZaYpdheBH6?=
 =?us-ascii?Q?L7Q+/pzkL8qxPAAo9nBUya20AYBfKALPB6VBFKFJjRTv/qsUe3XxORLyD99E?=
 =?us-ascii?Q?NI73rpe1sI4tjlGNVBduWScTm/M1ftPKbyzcTpKovJ+cnU1jI7Q4joKC0FrE?=
 =?us-ascii?Q?BVYuZdk9yjIbdJrp0qwHVLAusv2/JmojVE/MzEXmW7nAClXf7t3YkpJgYfmQ?=
 =?us-ascii?Q?CeXCtHAKkIL9CH/NYfLWypPlQEHFDwNvaToMzXvZq0WONlSEWUPjtRxQWMRU?=
 =?us-ascii?Q?INA0M3Ov4iQ8YZBbxlbrqhC6P4juXWgPoO87wqe7lneeUGFKLjImGjpJwX+b?=
 =?us-ascii?Q?JmfZuiAbyLJz2Kokh6yBsH5tVduGvpmJm1pJXiBb1S5EjGLOc3ACfZ7s1Mvq?=
 =?us-ascii?Q?8tof+3G8VADbGFY5lJq9cePYxz8RHLo3Oq3o8i/eyGyYJkFUpSH6pDNeff7J?=
 =?us-ascii?Q?igHZzMPVBsXDoN4Khe45Aon0ZKo+Gk9VNNl4uZTzJaN7I9Q2mWYwAp/Z7r44?=
 =?us-ascii?Q?vsnRD7E=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB3882.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cbf8b43-d3c7-42d5-b348-08d95fc5367d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2021 08:18:07.4719
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MniT41C+HuxpTrnkIl/G4yJt6Unnlh/gqOBLpasZ10LB1bTR+1L71P8rOeR1eEfpzq/cYh6t0sKOEI098IJj6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2581
X-Proofpoint-GUID: GkpqzBpK8kz4VoEHszpugxRqBbriZh0t
X-Proofpoint-ORIG-GUID: GkpqzBpK8kz4VoEHszpugxRqBbriZh0t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-15_03,2021-08-13_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Aug 2021 03:05:00 + 0300 Jakub Kicinski wrote:
> On Thu, 12 Aug 2021 22:53:13 +0300 Shai Malin wrote:
> > Avoiding qed ll2 race condition and NULL pointer dereference as part
> > of the remove and recovery flows.
> >
> > Changes form V1:
> > - Change (!p_rx->set_prod_addr).
> > - qed_ll2.c checkpatch fixes.
> >
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > ---
> >  drivers/net/ethernet/qlogic/qed/qed_ll2.c | 38 +++++++++++++++++------
> >  1 file changed, 29 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
> b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
> > index 02a4610d9330..9a9f0c516c0c 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
> > @@ -106,7 +106,7 @@ static int qed_ll2_alloc_buffer(struct qed_dev *cde=
v,
> >  }
> >
> >  static int qed_ll2_dealloc_buffer(struct qed_dev *cdev,
> > -				 struct qed_ll2_buffer *buffer)
> > +				  struct qed_ll2_buffer *buffer)
> >  {
> >  	spin_lock_bh(&cdev->ll2->lock);
> >
>=20
> > @@ -670,11 +682,11 @@ static int qed_ll2_lb_rxq_handler(struct qed_hwfn
> *p_hwfn,
> >  		p_pkt =3D list_first_entry(&p_rx->active_descq,
> >  					 struct qed_ll2_rx_packet, list_entry);
> >
> > -		if ((iscsi_ooo->ooo_opcode =3D=3D TCP_EVENT_ADD_NEW_ISLE) ||
> > -		    (iscsi_ooo->ooo_opcode =3D=3D TCP_EVENT_ADD_ISLE_RIGHT) ||
> > -		    (iscsi_ooo->ooo_opcode =3D=3D TCP_EVENT_ADD_ISLE_LEFT) ||
> > -		    (iscsi_ooo->ooo_opcode =3D=3D TCP_EVENT_ADD_PEN) ||
> > -		    (iscsi_ooo->ooo_opcode =3D=3D TCP_EVENT_JOIN)) {
> > +		if (iscsi_ooo->ooo_opcode =3D=3D TCP_EVENT_ADD_NEW_ISLE ||
> > +		    iscsi_ooo->ooo_opcode =3D=3D TCP_EVENT_ADD_ISLE_RIGHT ||
> > +		    iscsi_ooo->ooo_opcode =3D=3D TCP_EVENT_ADD_ISLE_LEFT ||
> > +		    iscsi_ooo->ooo_opcode =3D=3D TCP_EVENT_ADD_PEN ||
> > +		    iscsi_ooo->ooo_opcode =3D=3D TCP_EVENT_JOIN) {
> >  			if (!p_pkt) {
> >  				DP_NOTICE(p_hwfn,
> >  					  "LL2 OOO RX packet is not valid\n");
>=20
> Sorry, I missed this before, please don't mix code clean up into
> unrelated patches. Especially into fixes. Same goes for your other
> patch (qed: Fix null-pointer dereference in qed_rdma_create_qp()).

Sure.
