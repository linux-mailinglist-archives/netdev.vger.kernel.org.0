Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9345FDC8E
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 16:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiJMOpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 10:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiJMOpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 10:45:11 -0400
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3870B4DB10
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 07:45:10 -0700 (PDT)
Received: from pps.filterd (m0134420.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29DEXxiF016166;
        Thu, 13 Oct 2022 14:45:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps0720;
 bh=1k0bFQ5j4cs/6mXRAvFScoltWdArJggfR0/FZzwtXG8=;
 b=C0D8Vm5xHgY4TR90f6Tb5oRrbT71b71dyVXmc2cITv4eHPsI3sdHLfWBDxIH+uMPnc6t
 lRF/bjAbtPrAb5nNegRLm62Zmt98ZSIO7lqTtf7Tb5WKwnQmlhECpNAlZGu+sXetPlyG
 OxL9WeU5skxn0ceWvR66ywfSw7nLHl3jf3AOnM4CtBCPC/MFOvgYT3QYR7Ef9H5sOV1l
 grqKfbBN+C4Jv+ZSbYDEgMYnVwz6f2xNIvfcpGpQMy2Y8NB0ZvlUppxOjwFz71dz5Isv
 HlzsaBoI8vx+NhK1715yGxrljVH3HenewXKDG/vyFUQRS8L/Hau+yJGvA1Iq5+/Em9F7 4g== 
Received: from p1lg14881.it.hpe.com (p1lg14881.it.hpe.com [16.230.97.202])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3k6mj583xm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Oct 2022 14:45:06 +0000
Received: from p2wg14937.americas.hpqcorp.net (unknown [10.119.145.217])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by p1lg14881.it.hpe.com (Postfix) with ESMTPS id 79CA4804712;
        Thu, 13 Oct 2022 14:45:04 +0000 (UTC)
Received: from p2wg14936.americas.hpqcorp.net (10.119.145.214) by
 p2wg14937.americas.hpqcorp.net (10.119.145.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Thu, 13 Oct 2022 02:45:04 -1200
Received: from p2wg14930.americas.hpqcorp.net (16.228.19.10) by
 p2wg14936.americas.hpqcorp.net (10.119.145.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15
 via Frontend Transport; Thu, 13 Oct 2022 02:45:04 -1200
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (192.58.207.38)
 by edge.it.hpe.com (16.228.19.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15; Thu, 13 Oct
 2022 02:45:03 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dxk2WNUEFEn/pyRyL0C/EQUZDXiRvyW7IC/3AQtzHX+trO0HLg/DOyJYiK068fpZ2X2/EGRWzPCziSHSd5t2/UC6FuWKHZtlDoaaQpPqlGtHem/J7DgPRh4Kx3NFXiz+uRQFDu0aFw9rqKEbAVoKWu4ZXORrW2vLHUqU+nfAPPs+fYz109u+ZXe9mS0k109v+EjxOvypn81MCx+PQHK9uFLHqlsKQzbwSU1pM/O5kuHmLAF6xdTVPymsFdHS5ewXblwOSz1Ve9Q8TVhlLYEuWWBnra83LLOe9qpUiF18TkRHWhA0MK5YNlzfpqnM8k7uxQgQw8UyORSNcvKxMQXRQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1k0bFQ5j4cs/6mXRAvFScoltWdArJggfR0/FZzwtXG8=;
 b=nNaVowhhC6qyl/oo7i1/0fXP5V8E/vpn4Bue8tt2ur9GIRMLXsnt9APJIKk7KDXl+C4S/dkdcbR2eFh+OrB1kMM4WI1cIE5wn99hxBr7xq/6DXTpEmsdqZMb1STUha665JZMQ9t4PAbDnaKq7mrw4sfMUThndO1a+hOu5OOvyLPAOF8jFom5bibKcwO2qAJubfJ/M9GNe78YuCIjVRKTxxuQZJojgwUcyxR5u4/MMhBTkC+j5JUV4ImrJO8AXfjduz7YHkDqOj7q9f+O6J4e6tOjF361My6Xi3xcWI3cLhJ35CYuXvtuer/R80dOR9iV9huhkrenuoVBZTWplD3bhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:a03:435::12)
 by MW5PR84MB1425.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1ab::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Thu, 13 Oct
 2022 14:44:02 +0000
Received: from SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::6688:54dd:3b38:f0ad]) by SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::6688:54dd:3b38:f0ad%6]) with mapi id 15.20.5709.019; Thu, 13 Oct 2022
 14:44:02 +0000
From:   "Arankal, Nagaraj" <nagaraj.p.arankal@hpe.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: socket leaks observed in Linux kernel's passive close path
Thread-Topic: socket leaks observed in Linux kernel's passive close path
Thread-Index: Adjez6aXF+0o42+nT1Wf6u5HaTF1XwAP0HeAAADClkA=
Date:   Thu, 13 Oct 2022 14:44:02 +0000
Message-ID: <SJ0PR84MB184707E40732357494D0EC17B2259@SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM>
References: <SJ0PR84MB1847204B80E86F8449DE1AAAB2259@SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM>
 <Y0genWOLGfy2kQ/M@lunn.ch>
In-Reply-To: <Y0genWOLGfy2kQ/M@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR84MB1847:EE_|MW5PR84MB1425:EE_
x-ms-office365-filtering-correlation-id: 18c9f263-5e11-452f-3ed6-08daad295ef6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3+3SDKQlngUXpxhGZVwHHqit6sskDTupKUUk7S06QQpwzs4cSrerm8QMm3oWINAg3QfPJTFRQUpJuFHClaPIjjAEbs3RTb8V2NXvJ1RXJeB2TSz42W/P+laT0xz1cN0cOk3nN5qsw10q3FuuHb0fnEhvvvloAcmuj7jLtbJCjiVgc9mRgWy3Sp6C6rrrRLlN/Pf6ffB8Z+AKCXmZ9svg9PfbI6FtXW+W1TgJfCjWOz8Tmy1L915iW/rl7bit5VvHmWRbBaucu5yLbriVx21d7GoOs1nTyHFdwixmOs6swtS46ypagMDb9X4tO+7L5d1tjHBCgVDFd1+ZzUdn7W3RcDErn7+2YLyHp+3udU8y3eKmwH73DAZ3R8lEFw42AG3y7UP9/9EjKWsWZ1Bg7EdlQ6jWR0l21lXUGLSJk5bO2353SrX4a1m0N1/a2UHfWsFBTzMPmdDgyc9g4zeJ50XbocU4qx8wtfYKmtWCCUT3MWJoXTshK5w30a2cPMdu/OxsvDlMHFAB9yMKlwtyXN1f+/eu+yniIaLfvwzXRWfQGh7EjKlCyJzzveaSq5FzKlfyAWKV1KUjeHoqpebCyL9+2QUV3jItI0vkkG470G9QrJGQSjrFdnNAlaJJYmcdXs5M3quDpKNpwrB40PiVRKH94/xbKmXqcRrST86iAdx9rfTN/nzEiTTB0zTLugER9ZJ/s/c4Wsd/dUDrjlAwyhlTpj/bLUOI+u5mLxSckF108P1AJoEkFu1x6VL+DQikqQ9vy7vnbA/y/i0jNAxkVn/0XA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(396003)(346002)(366004)(136003)(451199015)(2906002)(66556008)(5660300002)(66946007)(52536014)(64756008)(4326008)(66476007)(8936002)(66446008)(41300700001)(8676002)(76116006)(316002)(6916009)(55016003)(82960400001)(122000001)(53546011)(478600001)(71200400001)(7696005)(26005)(9686003)(86362001)(38070700005)(33656002)(83380400001)(186003)(38100700002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XBGxGHcC3TaNlrB7uqOXd8yLohzXTpvo9ITdR3h6LQ9ydu63nSPYWiJh/XEV?=
 =?us-ascii?Q?mWDTP3IskmcPcpJh9EElH2hhdwBaJ2Zme4imrnGtYMdq9ZsqELUJb4BmnEYV?=
 =?us-ascii?Q?s4Eh7VUoRcDjs9cm9+GM5l40GvjXXs+Y8IJAW+hMl4yDjsvk1rVGwZ5KN/uc?=
 =?us-ascii?Q?yqM5E7CDAJFv0Te4uypJibfk9ObTsCl5Hg0TY2aTdMTPpMtRItXUIwJcb9NE?=
 =?us-ascii?Q?jD0xpMPS7hNFNc36YmxzCCtpHRpMmYPb/NU5ykjlrIQrLk8LovXWUXgmQSMl?=
 =?us-ascii?Q?N3BDAvEkxUbGy6yVhJDgI++S0Klhw22cwJxyvV8/kdlkCN2dgxOdXRgp3uL2?=
 =?us-ascii?Q?zI0oBqit35ruVxhuo4s3i/1HiUAnle8YwxERR8hfRAGLGZ3WD3kohy6Nw2Dk?=
 =?us-ascii?Q?piLs8Fdsso/7EL7ma4VwZ454N96JwYEKQglhC8TWdpjl3sqBM2Nlik/3Hxw8?=
 =?us-ascii?Q?8B83DfhLA2jUDi+6J/NGTlhA6a4PPXbiZBM/2/R61XSm4P0unfJUOZm4jZw8?=
 =?us-ascii?Q?XaZsYhw8HjAdlcRucoHrTEREp1UG0DE9LiUuYwZNpCZt2x7Zdz+93NkENAkv?=
 =?us-ascii?Q?wNoQeX1ACdt+tCO58L7+jgwN8yWJSe7ZCTn34FbFzu/zj/ABdjVy8CJkk27l?=
 =?us-ascii?Q?vmt2Ltc+opXLJkboSPi3WHr3eqfmXlYrbqMhRQdtyszIw9eAaSreN2FJFgXo?=
 =?us-ascii?Q?9/vId0mYq6Qz3eBrt8HlB7AbyUQgz0ZptcydhfnDNSRPyYCvOgJTFc0/l/xX?=
 =?us-ascii?Q?l5W196r5WYHletUX0nVk62NWhmCncnF5WHYebUa/Bm9MdKVmsO3AYpDQ50AE?=
 =?us-ascii?Q?njmrQqN3FaIi/nOZYvAY4uLfocF9UCeVZpOAX40hx2pUeF2IvaSgkJJJNLjr?=
 =?us-ascii?Q?cxLHRbN+dh13S6tWhdHCMYW16hG1MwhtJQEKomvDgJVsrh7rE2FrCP9qyqe5?=
 =?us-ascii?Q?o4b6R3LNsKLf9v0d97tT+vAIXo0gFueopFymHnyCXKgJMjhSJil0aB+RzyUF?=
 =?us-ascii?Q?x8tFTYA8eJsrYYrhLyqncV/+hhaw///f/yen4xr7TPx+7+NqTavUYU8PC/kH?=
 =?us-ascii?Q?pGvzoWAHqff3NG8hbzx65s0wvyuCeC1Xw5T+HB+ZZZqCZkvhhAfw/t8O9dqn?=
 =?us-ascii?Q?JPHx8Um3Grqp5cudyJeV63Gksx2j6gpw4AHzqbpLCkaP/5tvKOKvp+57wl+x?=
 =?us-ascii?Q?IAUG2knJOz/rgl3HI6QxdRudrJbxggcmVqj6apqPxgkNIwRMgJR0XM0eGzFN?=
 =?us-ascii?Q?8vYXlbT0iraSysvIy9MtZZ37Pbtp9a2hFDc7bRxvJ8r2J7+blp1lWoNBB30p?=
 =?us-ascii?Q?kig61BTIxMAcBOMxehnLlqq1uFRDDmtnVQtoYlxYNhbxG+8/VaB3pArs95KU?=
 =?us-ascii?Q?+hD9paAcL/OEcInPWSBY0SkWqXduYuqTLNwrgX/6vn0o7+OldKpChLoiovhJ?=
 =?us-ascii?Q?v5vAoUDeFbT3Rcp2l/Bt6u5VDwM++pjkIU9E25ZdrX1//TF3Z4yaWEJv3SYE?=
 =?us-ascii?Q?+T/fFg9Ktytifm7AN72DW5XT5Docl7MZvr6FrUOBvQ5I+UAuIQ09lFpAyI2S?=
 =?us-ascii?Q?JTcq6xbII7XyucUsP2+NoYxtUrwyVlirGSJy3//YjPseE9pJlwAm1/eAe2WC?=
 =?us-ascii?Q?fg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 18c9f263-5e11-452f-3ed6-08daad295ef6
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2022 14:44:02.4650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JXTAh3yBqJ4tzAyFoBOVKWZlY2x67bfGc/uVm4tlhwDyD+9K56cl1a8CfMIuSQsy0G37Ov+1dMHLdsEpz1aLoPMHFnVXeECl3JhlLn8XSww=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR84MB1425
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: DjTuG4xM1Zi8drJdfHxGi8THQH3TZxnp
X-Proofpoint-GUID: DjTuG4xM1Zi8drJdfHxGi8THQH3TZxnp
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-13_08,2022-10-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 clxscore=1011 impostorscore=0 mlxlogscore=932 suspectscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 priorityscore=1501
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210130086
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,
Thanks for looking into this,  I have not tested this on V6.0 kernel, and a=
s far as I know I have not observed any fixes in this area, that's why I po=
sted this, as this seems to be a valid case.

Thanks,
Nagaraj P Arankal

-----Original Message-----
From: Andrew Lunn <andrew@lunn.ch>=20
Sent: Thursday, October 13, 2022 7:50 PM
To: Arankal, Nagaraj <nagaraj.p.arankal@hpe.com>
Cc: netdev@vger.kernel.org
Subject: Re: socket leaks observed in Linux kernel's passive close path

On Thu, Oct 13, 2022 at 06:47:56AM +0000, Arankal, Nagaraj wrote:
> Description:
> We have observed a strange race condition , where sockets are not freed i=
n kernel in the following condition.
> We have a kernel module , which monitors the TCP connection state changes=
 , as part of the functionality it replaces the default sk_destruct functio=
n of all TCP sockets with our module specific routine.  Looks like sk_destr=
uct() is not invoked in following condition and hence the sockets are leake=
d despite receiving RESET from the remote.
>=20
> 1.	Establish a TCP connection between Host A and Host B.
> 2.	Make the client at B to initiate the CLOSE() immediately after 3-way h=
andshake.
> 3.	Server end sends huge amount of data to client and does close on FD.
> 4.	FIN from the client is not ACKED, and server is busy sending the data.
> 5.	RESET is received from the remote client.
> 6.	Sk_destruct() is not invoked due to non-null sk_refcnt or sk_wmem_allo=
c count.
>=20
> Kernel version: Debian Linux 4.19.y(238,247)

Is this reproducible with a modern kernel? v6.0? If this is already fixed, =
we need to identify what change fixed it, and get it back ported. If it is =
broken in v6.0, and net-next, it first needs fixing in net-next, and then b=
ack porting to the different LTS kernels.

   Andrew
