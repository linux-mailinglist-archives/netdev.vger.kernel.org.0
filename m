Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAF95AAC62
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 12:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbiIBK3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 06:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235223AbiIBK3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 06:29:44 -0400
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC31DBD293
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 03:29:41 -0700 (PDT)
Received: from pps.filterd (m0150241.ppops.net [127.0.0.1])
        by mx0a-002e3701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 282AHVP8021993
        for <netdev@vger.kernel.org>; Fri, 2 Sep 2022 10:29:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : subject :
 date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pps0720; bh=pgR36PdRajoavufFSVNP9+P4/RIhGco0/3s078Yy2ZQ=;
 b=fOeWvdnqQjHDwX4AIqlFbknUvxvc1R1jdZ/+qnaVM8mMtF8XSVd6WMSx9AoDp/0cczIO
 yiw/ClBup1rxW7DFtM7inJXF2PRHZkWhEKZsZIrWBWvMRswq3mqe7cFwIVjcsNHSH9Or
 ipLeVc2UTqcSQReq3oJm0hu47hQj3uDidInnGB8d20Noee7l/wtzBepI4uLeSMz0lVme
 UdiZFDAyjxfkHHMPX7jox+BUlFUGGX7I1FdRkIQspRjxfztI1an+y5TvKnX91s+Aq7qK
 HxJq8GnLKVCs262gBZbjqVEFnm3lrln73UUSRv9w2a/aVx7vGcAKf6FBogg/HE5GmlwM yA== 
Received: from p1lg14879.it.hpe.com (p1lg14879.it.hpe.com [16.230.97.200])
        by mx0a-002e3701.pphosted.com (PPS) with ESMTPS id 3jbfke08p4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 10:29:41 +0000
Received: from p1wg14923.americas.hpqcorp.net (unknown [10.119.18.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14879.it.hpe.com (Postfix) with ESMTPS id E545BD29C
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 10:29:40 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14923.americas.hpqcorp.net (10.119.18.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Thu, 1 Sep 2022 22:29:12 -1200
Received: from p1wg14923.americas.hpqcorp.net (10.119.18.111) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Thu, 1 Sep 2022 22:29:12 -1200
Received: from p1wg14920.americas.hpqcorp.net (16.230.19.123) by
 p1wg14923.americas.hpqcorp.net (10.119.18.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15
 via Frontend Transport; Thu, 1 Sep 2022 22:29:12 -1200
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (192.58.206.38)
 by edge.it.hpe.com (16.230.19.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Thu, 1 Sep 2022 22:29:11 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TeZ6923agmzKn/9IS89707V+9t7coonvkVKWgsUNXSKJHxNA70w+QlS555F7id/YcMEiomAagWkjAO+Z5tyLJWG9Axj8LvkIJiO1oKYDMbg76REVGXMLE1q6o+dt3CXNnmCAJMzFsr+IYqeT1If8loUUcdBL9raAlCPecgE0YNGVHUoy/XtY6Zw4QAGHD7oVsslbLfLYUOslkKE7Fc7Sx/XZB7c7ZHi/IPvaTE5Nl2YsIRrreKvCkB1a1pPRbcwktAiXblW+81Q3BkxtAdOID0jeNmtGMAyRbsog3OXA+LRUPxTPJHzQCaYIfNY1+UbmEr69uFOx3s2c6LzbR2L3Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pgR36PdRajoavufFSVNP9+P4/RIhGco0/3s078Yy2ZQ=;
 b=bdWquJo7yKb+HhfYacHqIrcyxglaaFIPXBPyoACcOcMoDdplK0TryS3Y1cQMOKychezPYqWqrpYBYpVhxAoP+8uqfmdgpmMV0c+jSZVW0LVVUYjn//Q7NXDXiAKZ/C7mB8wOZ7xFL1pKfhwL8p+VKBHa1sy6CqW1mJ83ryoaUa/uVCMQiB5BVx+J24eMX7Ag/b8K4rO3aBzfaouM2NWiOSk0llftyzZtfMcVVuPye0BvN8aHcV97QMWQS3R3SdQLRvLhVneWMpuv79NRzPI0perJBgLVnPHqwyfYNZRbob5aHNKZmzYy6KZx5J4qEmpbkVpLRtg+RrWSVYwhdx3WDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:a03:435::12)
 by MW5PR84MB1714.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 10:29:10 +0000
Received: from SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::f416:ee64:8c3c:b37b]) by SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::f416:ee64:8c3c:b37b%8]) with mapi id 15.20.5566.021; Fri, 2 Sep 2022
 10:29:10 +0000
From:   "Arankal, Nagaraj" <nagaraj.p.arankal@hpe.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: retrans_stamp not cleared while testing NewReno implementation.
Thread-Topic: retrans_stamp not cleared while testing NewReno implementation.
Thread-Index: Adi+trvQEat+6GYxQwSDDFxq9fIdqQ==
Date:   Fri, 2 Sep 2022 10:29:09 +0000
Message-ID: <SJ0PR84MB1847BE6C24D274C46A1B9B0EB27A9@SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c36c18a-cf02-42c7-8a2c-08da8ccdf8fa
x-ms-traffictypediagnostic: MW5PR84MB1714:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TP5Hq+l0sdhBFyPI3ZMebAfKnTqAelEfSBiBE7pdHEu0IFsmVEOpkUkmtiGi9PUdCO6NWF283Ah+z3PlceO+S1tlVdi1txkX4Jg3KVcgPYMzZgbqBsQZ96pRY5pp3pRGzT9VYVYj+0Qe2jdaBwuo2/hFYGiRZmmHCoO2f8IJbRduemD4LXGX71PCymaKr5JAKd//CDTaqKSrZoFixZsh42nTSwvy0FxOfn3gepBfDHYTF2PCiWAsP4gFlJv9jMiTGRV9VUfktKT016sDUwzuDICH01fgqCVvsIAfC0l3teNrsTAMb6b8n7yPhYT4Dq9mI7q67tO0s4iHM9xkk3DXAxhUO9ELkbjKNvMk0SAXZUAPvQUqs5Udkj9+M2jhhbUbmC/8oDBEmN0CTmtgfkSyU5T95r4ni6v6bI6hIdw+YNSBgFVdjf6WnAnfyOMt94OeChxVx8yjRYoWURNXy04N79uaVand/mDR7ksa/wPzkdwVuE/Gtg85drBNCiLXmTpGY07S4iU2x7p0DMAPXHqn9oWKwF1JF56+u0phawuEc4glfZMeJvuw1xAQDlS7hdeP5ouZifhHTL1oUYh6zLqWqxft0Z2/GylWQ4VHbR41wu2Ab5Jy8MEjpnGkTineatinJgwIaxHDZjvt5BWpzjCchOnN13DMaGNEtScDPZvI2sCcRJnfs3UBU9F+fce8UfkZLFXu436xVyeK/1VJIDGQPDC/E1e1qOr9wvz3+NB43ACK7duRWxIKHxqw4X7h80iJdtwesWHeww7S0KCsV7bHug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(39860400002)(376002)(136003)(396003)(71200400001)(7696005)(66476007)(6506007)(66556008)(66946007)(82960400001)(76116006)(26005)(52536014)(316002)(9686003)(64756008)(38100700002)(41300700001)(86362001)(6916009)(2906002)(8676002)(186003)(66446008)(122000001)(478600001)(5660300002)(55016003)(38070700005)(8936002)(33656002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2+S7X1PG3P4LbGqNWL2/7Y7GkmzRTmBz1CDezIZnuDnAW8wyWASEamNVkdoZ?=
 =?us-ascii?Q?18UVKEQd5OqFeytQRbndCyLlkPR2Z/M1se+siCiUha6RIq2v3i2uFj3w86tv?=
 =?us-ascii?Q?lGN3qNDQUhOn9lYSzjtqVTNR9meUyhZybj3dk0diMaj9e5KU9SJwo//xVT0s?=
 =?us-ascii?Q?I/mZZjdR2v4eRqIHMLlnmU7cdoCn2ni6cHoLwplvf5BoxKKAu4dhYjJaTx+q?=
 =?us-ascii?Q?VJcHnVYPAZe/cZ9JKTfc/4EBOvpGmtmQaYXIyTuKhWZZ1y1YLQRO85sQpNsc?=
 =?us-ascii?Q?PK7pcRaAsyZHVfMUiq42aMfr8xr7TrzbTGWO4FQRwuhrofA4aWwkHPlmNdHE?=
 =?us-ascii?Q?yKaIq3fxHBf3IJZ7u2BrKpW2CGlB3JnwUqb3334rlIqSi0UlcmD8T8rpsuAV?=
 =?us-ascii?Q?XDryuhCyE8WyuQDfRA47PuDb0eANL/ejlKJ8pgWiaxTRqRuxOciT2qu4Geyt?=
 =?us-ascii?Q?t1GD9wqtI0g+2b7j1kqyaN6jyRj41leH79sRxDBXstzUUXsgpEnBZAjI+78W?=
 =?us-ascii?Q?h4oF+GdgeI2vrVqIrjfbv/3HVmZkKeZa9T8FyGk64wcS1HCG/GrQZCcrjlMM?=
 =?us-ascii?Q?V6z9jvgfs5smFuqHshGm3WwMkHPXnS3+cklI4XUuSk4C5cYuq9sv2BJ+hmHj?=
 =?us-ascii?Q?dW3oBh8BTwYvKZqyXoEAFxUGg8FTs+xC+eMTTLU8COAysW9upbVTrQzk3gnz?=
 =?us-ascii?Q?MYBYPOMLGNuRljP+NUaNm9iu46GU2qI0T8s9tbe3R5s9GSRhF+ZlMEfd1Bob?=
 =?us-ascii?Q?5jbJ3d22OgW3MBfJ2Phch2incONYtvMv+6gYkTfKEFUp3E06rKcOzCEzNkjQ?=
 =?us-ascii?Q?viQX1b2X3FOme1D0YSPjHZxUagIpqsjwAodXzGMjb96bLEf0KB5/hbV5JaNy?=
 =?us-ascii?Q?2hbxXKVhlvYUfyXCt4HJXbQNXuJhlbmwhj6eCjfLexmVM5z2zwKx4ircVaiS?=
 =?us-ascii?Q?HebSFagTkjy1hQzH8hbWLPEPghHpsgtAlUZG0k6+opGDPyKmTAZHQe5qHpNc?=
 =?us-ascii?Q?5nfcHNDGFkgjplLg3gviLudyS+UdXYq7Sur1phyFIWKO544ch5JaAqpGvOb2?=
 =?us-ascii?Q?Kr7NJkA7QKvug9NsILbFw/4lQ2gV8NxYIm0CiOCIGsgOyROMaq3LExxflWjk?=
 =?us-ascii?Q?DIwH7T1ebfg15P2jUl1rVfQx49JdWvzj/uWY0p34YcHlFtDTkd8PASfpsWY0?=
 =?us-ascii?Q?cTr0BYqDKY9GjSvcw6DRlAUC9M31BZuaeEAtefsF0mBnoVMOpfxSoKE39pIh?=
 =?us-ascii?Q?L6C3i+zk2tE3dg47Avj4uHTmgHqeGh66Q9P6c1scqj+w8RzuhH/Jw1o9dUyP?=
 =?us-ascii?Q?J4dnMUSP3bb/XwVO5shxo7gYUYjFwuCSstc80uz4aRvNadb9dNXSmARos0P2?=
 =?us-ascii?Q?x9+wJnaJA7YlIaN8bc+YO/aN2Rs+POnduJ+pr8u2h93oKQkUfg+6I86cnAkB?=
 =?us-ascii?Q?8v7xBBIvlA5sNhpO63CeaqiJKMJ63d7LB1jBlgDRI0osDIDsj5cYrn0ljV1N?=
 =?us-ascii?Q?nUq5Fc6M7qYzwKnBJqdXnHJ5kRJui7CeHlgEWMO5koQxA8vzqiu9rs/ugW8I?=
 =?us-ascii?Q?4JuYojEDST/z9+J8vM+b3GT9CiG8iHOXbHhtDupoTJj5uX+EMvrN/0i7YopE?=
 =?us-ascii?Q?SA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c36c18a-cf02-42c7-8a2c-08da8ccdf8fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2022 10:29:09.9543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BxlYXU6K8T0TFY639x5aSga2CsvzQpFh3K5uKfT1r40uk4t29DbrYn+p58NL8yWThnPepf3hF6frx3Xf3+tyrhPyTIxdDDAMpElfM3ZeFLg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR84MB1714
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: nIVC1iRsFMQkm5SDwhPLzrSBcSiUM7O9
X-Proofpoint-ORIG-GUID: nIVC1iRsFMQkm5SDwhPLzrSBcSiUM7O9
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-02_02,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 spamscore=0 malwarescore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 bulkscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209020050
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While testing newReno implementation on 4.19.197 based debian kernel, NewRe=
no(SACK disabled) with connections that have a very low traffic, we may tim=
eout the connection too early if a second loss occurs after the first one w=
as successfully acked but no data was transferred later. Below is his descr=
iption of it:

When SACK is disabled, and a socket suffers multiple separate TCP retransmi=
ssions, that socket's ETIMEDOUT value is calculated from the time of the *f=
irst* retransmission instead of the *latest* retransmission.

This happens because the tcp_sock's retrans_stamp is set once then never cl=
eared.

Take the following connection:


(*1) One data packet sent.
(*2) Because no ACK packet is received, the packet is retransmitted.
(*3) The ACK packet is received. The transmitted packet is acknowledged.

At this point the first "retransmission event" has passed and been recovere=
d from. Any future retransmission is a completely new "event".

(*4) After 16 minutes (to correspond with tcp_retries2=3D15), a new data pa=
cket is sent. Note: No data is transmitted between (*3) and (*4) and we dis=
abled keep alives.

The socket's timeout SHOULD be calculated from this point in time, but inst=
ead it's calculated from the prior "event" 16 minutes ago.

(*5) Because no ACK packet is received, the packet is retransmitted.
(*6) At the time of the 2nd retransmission, the socket returns ETIMEDOUT.

From the history I came to know that there was a fix included, which would =
resolve above issue. Please find below patch.

static bool tcp_try_undo_recovery(struct sock *sk)
                                * is ACKed. For Reno it is MUST to prevent =
false
                                * fast retransmits (RFC2582). SACK TCP is s=
afe. */
                               tcp_moderate_cwnd(tp);
+                             if (!tcp_any_retrans_done(sk))
+                                             tp->retrans_stamp =3D 0;
                               return true;
               }
 =20
However, after introducing following fix,=20

[net,1/2] tcp: only undo on partial ACKs in CA_Loss

I am not able to see retrains_stamp reset to Zero.
Inside tcp_process_loss , we are returning from below code path.

if ((flag & FLAG_SND_UNA_ADVANCED) &&
            tcp_try_undo_loss(sk, false))
                return;
because of which tp->retrans_stamp is never cleared as we failed to invoke =
tcp_try_undo_recovery.

Is this a known bug in kernel code or is it an expected behavior.


- Thanks in advance,
Nagaraj

