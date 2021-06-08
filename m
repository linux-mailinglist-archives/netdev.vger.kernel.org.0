Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E443E39F962
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 16:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbhFHOnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 10:43:39 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:27176 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233239AbhFHOnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 10:43:39 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 158Eb0sn024004;
        Tue, 8 Jun 2021 14:41:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=SuSmJ50tLBzpTJu/fzyR1driBeCTt7UBkjyedNYgLlo=;
 b=L3xjBvT260ZCZvKXEP68Zhjx0ja7tzkuxsJP88f2ziiRCFkKuKbRYcsNZSQzBZhMl32T
 cvGv6FZ7xfBAV3A6JoNWmib7O9NIkrjQpLW4ohXLsFjwDrtqkJSv3Eh5BBqkiFj+6OXX
 pZYRL1aQdpbi8IYQ3/hp5LRTppN/qyt5oXPg5PlF+Q+YXoeuuItjw4zQErIBR7qhsET7
 gTEMVKyDkg+1fFRrILBVBh61Yi4fgTmosVOHkDkWdvKsbtm5XCOTKRaaVuIshhRAAtgK
 PH5eIR/wxQp0mf14NsomSAsxiJmWQQRRH09rCyoOpRkBmJX6H6D/qKFgN6TLKis3p2sX 3g== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3917pwgps3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 14:41:42 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 158Ed42x154597;
        Tue, 8 Jun 2021 14:41:41 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by userp3030.oracle.com with ESMTP id 38yxcus1sd-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 14:41:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lDadaiUkz+oH4Bx6imR9sLSSmYGv700Cw41sn/cVrxtNuLnsRZlqW+FAF7S6nXPUbQLSd8FZmvVGxABfrC9CF2uwJmHIgkFygOyWiG6qasf2tuvdoYLNTCTDlfG5AKa3k5wqIu6d9eRlLtwe8T/Bh0AabR7eq8INUNkdf2DylsyIukEdXzHWGg5BpnYJnGCwpmiC5DskbE9TUGd6X1yNRIXod8AArYwsneOwMc0lsiS5ARatloKFHPbssPOSwt1L883Dy1AiyQ7SPJMtHsrzTi0KEe9YwDfZf7vakew5pXePyhhKBLNpMXCh6VC+vs7XTfLfU8drd7xsg94JJpY9zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SuSmJ50tLBzpTJu/fzyR1driBeCTt7UBkjyedNYgLlo=;
 b=YLDZXfiGu5VmQOHmhTIbq4EjborOOxM+Ly3iaeRQGcNxY0fQP8jTJ0eHw7QvbDphm6wmCw2YUYcxKNBPvdTVWZ8urTDJjUqMRdUmyuqLj9XHDu98gGwB7VCVRyLWp+7cHtelWGw82rVZYd0xFU4coNjcDOO1OEjhoI2BOpXNfEjljwFrXFKfsGalJoerJx0J4EMIKajdg0QPmAf2SK1EAYwxtrt+My3oiO3jI0MC6STiaZr8DC3IBITXquCtlW0ev+re0IvHgdxnOJ/QKDSCcOzbGddwvqZsHNMtJCHsTq6BEyPkM5CCtPuq7miCj8z7dxzHLNAkS2sW0dKL05lnjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SuSmJ50tLBzpTJu/fzyR1driBeCTt7UBkjyedNYgLlo=;
 b=gnbgWwNiYgU4hRIUe1jAK7XsI4rLaayzP2evzU95vQf5PMiXvIfXk2MfVAlFKQ+eSRGsKJig9kCTvHPTYK4z8zWKlPRd/XvBSkzigLe6T2WRXDk0G4FxEpT+keOHiyEMhnhs2KtyNSL4H4RIEBzVWBuTqic3cflThoJpoby8x8c=
Received: from BYAPR10MB3270.namprd10.prod.outlook.com (2603:10b6:a03:159::25)
 by BYAPR10MB3270.namprd10.prod.outlook.com (2603:10b6:a03:159::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Tue, 8 Jun
 2021 14:41:38 +0000
Received: from BYAPR10MB3270.namprd10.prod.outlook.com
 ([fe80::b867:7c17:11b1:4705]) by BYAPR10MB3270.namprd10.prod.outlook.com
 ([fe80::b867:7c17:11b1:4705%7]) with mapi id 15.20.4219.021; Tue, 8 Jun 2021
 14:41:38 +0000
From:   Santosh Shilimkar <santosh.shilimkar@oracle.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com" 
        <syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail.com>
Subject: Re: [PATCH v2] net: rds: fix memory leak in rds_recvmsg
Thread-Topic: [PATCH v2] net: rds: fix memory leak in rds_recvmsg
Thread-Index: AQHXXHRjHk4wgQwXQUuKHUobVcZ1xA==
Date:   Tue, 8 Jun 2021 14:41:38 +0000
Message-ID: <56870339-B19F-41D4-8A92-BECB2EAC5646@oracle.com>
References: <CF68E17D-CC8A-4B30-9B67-4A0B0047FCE1@oracle.com>
 <20210608080641.16543-1-paskripkin@gmail.com>
In-Reply-To: <20210608080641.16543-1-paskripkin@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [138.3.200.26]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce11e02b-9d75-4386-e9dd-08d92a8b85ac
x-ms-traffictypediagnostic: BYAPR10MB3270:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR10MB32706514AEEF51D2B828E3B993379@BYAPR10MB3270.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iBlEkI3PhJkAmTkUU8A9gLBahqmhzPM96ZTNpwuLNb9TJAgfhYFHDb/XZGy7K9VqnvBtHWwQgPJoWBlbBuLnr04Pdg7/Maxo9Texd53Pt6/VaZfvlfBj9YswXE9a6iPvXltxc1x/PVpZK0PgM4sbzHMABmIgvL2DaDfUXLoHrte+552C6LKlnPNVeVMnpHLjpWkBKHdaUUo0Zjy0WYPYdeD8MNaw3tkScLvb3x8j00owROlSWlE65owWO3k/uRAQrHhgBzVCpYSZmHdnI0Stxn0AF4gx99dA8vDKAXpBIBRUK2Fg1ty2MjRfLHVzid1ljN0+ITRD/OXKA1NTHvHOXbLq/gd+Hejy4NYv4SWWY4nKXP9toYeZyO1nixo0IGwsyG41ZvqgoQlBAgRsY2myK5peZKz0WGNVccWeuqOofPnHBlxVsDecsguoGCwCGsNAkj+lfsiZBN5HdVNKwiJhH/Vp8rFL4zdbXFMbC0cSdLTb0s7T1M56jlRyED026upvyUME69Pl3pRkWQe+Zhm6mh66IbXuZuQAITaHxGMqMAwzJ7oXdqCaRVvXROkGPRXRk5VUBogFDm8Kholvd5IBZwLDQWYsxycn/j73ZgVDsro1JL0UmBe19bfHF3LTbA/gAB4+wwxRlcgvZQizwnFAxjKik4rlE+//pu3W8FtabG4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3270.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(346002)(39860400002)(376002)(6916009)(8676002)(186003)(26005)(4326008)(66446008)(64756008)(8936002)(66946007)(66476007)(66556008)(6512007)(2616005)(76116006)(83380400001)(71200400001)(478600001)(38100700002)(5660300002)(316002)(86362001)(54906003)(2906002)(6486002)(44832011)(122000001)(36756003)(53546011)(6506007)(33656002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PTcHDzLAmOErubH4f9nfAkz9dr72r0UykK5FQ5OBmOGKJjZXA9Fow2Gu9kwf?=
 =?us-ascii?Q?Qfv+NeLByhS+DyZLKoURk2bG0T4AlxcVVIukzYQlkHl8dM1aOmSPddgYOzzC?=
 =?us-ascii?Q?KkJCzyY5Lfk+n1eUfgjxA4HU8hK6gsVJ6UqVvTt1ckkGE22BBZ6/pz1g2Tau?=
 =?us-ascii?Q?lkKa38qY+JcZ4bvq2OZBPulLZ+dvWrzrfDL+Aq9HNxQ7BhEee2OEotbePEZZ?=
 =?us-ascii?Q?ebxzqbmiuG1+n3WieLG5yHDnYs/FKQYtzLdWJl9q9HzYMdgXDawDmfZ2vfyO?=
 =?us-ascii?Q?hMNdA143XbeIvHFJd0lFpVVvaiGri+dUW0es1vwHNmUHpfvcbdUWrA1VTTwa?=
 =?us-ascii?Q?fRfj1EBOr9a2Mg6zY1F9LfH+wdM0exdvZBUqqeDxcTWcL4efKDuITN3A5bLx?=
 =?us-ascii?Q?6SPFOoyQ6ERkImUEk6Ulnjs1YxtU0KxucdPDXpsWb0oK/a6cbfn6oa9ug+lc?=
 =?us-ascii?Q?kcnf01MaLxRx04+ouSQfOU5LQPfFsnmS4o9NQwUYriqySJ8NINlyFyyp8/6m?=
 =?us-ascii?Q?QMr2GPAtMDlQ2fS9KkiyGgohC1mkmBcByy7u26q6KBObd4r20ctk+Sjt2PPC?=
 =?us-ascii?Q?aKFGmtBKbL+2smQI70S3/BcEa7rjlPcvgg4c7f8/9tnAlXOf2qkqY6DDIOSs?=
 =?us-ascii?Q?lC2aVwJc3ymmX+KfDP7RaONIYHB4zA36c37rLhH+2O0ZTyyeSNa16VD0z+j6?=
 =?us-ascii?Q?r1je9y7ehxkZGLx646ftRUnf8Itu+YPmeDMztsxOUJXZqPlVRbzp9LZTIwi4?=
 =?us-ascii?Q?k49HDMP4NRm1cvft2emnciVO6KGp1HQArM3CRa6YImp8YFgQQ7/q1sdVD/L+?=
 =?us-ascii?Q?BM1TfhB/12eqDhrE/5uOAAbHX0zjZvNmWPHh8g7tpkmvaTN95OPPfXmi6I5i?=
 =?us-ascii?Q?V+NWh9x660MWl9tbZoVtdtT5XbY9WgYxacuxiYaE/WANHR2bG1/u0xZFqVRB?=
 =?us-ascii?Q?G8+3c9Zxlou/hQs2s+G9bu7/2hjb4aMWxeKfgg16AetNwI8TnfeNVoEx/bfq?=
 =?us-ascii?Q?JiNOlzemSj3Q4o3Y57OP8nRNllAMtTkZM3Tcvsk9mlJOpcN4kQPTXKq+uemJ?=
 =?us-ascii?Q?uDxGmGlCot0sNGzQRpbv8wtdudvV2n0MoFbvbA1OQjtNuDlYoirpE/syjVQO?=
 =?us-ascii?Q?11FP7A4gbrnyiZeUvjFoNFeMh/QaUvsn6gxyQM82eSd27gNsmaE5P+Zwoe+1?=
 =?us-ascii?Q?t6mspRP31f2M10a7GopkTw8nFuwgKqBbE/SkKcy7as4WgfP0Je/zy5GuBUIo?=
 =?us-ascii?Q?1WmU71U1ESYNe+iwb4fU871BRvt2c/PIDC7v7uqnQizsAwKzOqwJu9lLnXPp?=
 =?us-ascii?Q?BXY/HoMBXC24G12Me6QR7dvv?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4A128030DDB73846818FF8EF4F905252@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3270.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce11e02b-9d75-4386-e9dd-08d92a8b85ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2021 14:41:38.0668
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b/3RDkZ8V2nOJUQxsZufinnKmrq2fdjoYm/HZraVoo8wF3vXyTjznPEUlgORPbQ/DiyxXTSYHeUZ5lDjUiS2su3fN1+5d2P0N79X3/0Lmfk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3270
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106080094
X-Proofpoint-ORIG-GUID: ZGmTBR02F7JYeeR5Ra94LSW1iZrDJxEh
X-Proofpoint-GUID: ZGmTBR02F7JYeeR5Ra94LSW1iZrDJxEh
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Jun 8, 2021, at 1:06 AM, Pavel Skripkin <paskripkin@gmail.com> wrote:
>=20
> Syzbot reported memory leak in rds. The problem
> was in unputted refcount in case of error.
>=20
> int rds_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
> 		int msg_flags)
> {
> ...
>=20
> 	if (!rds_next_incoming(rs, &inc)) {
> 		...
> 	}
>=20
> After this "if" inc refcount incremented and
>=20
> 	if (rds_cmsg_recv(inc, msg, rs)) {
> 		ret =3D -EFAULT;
> 		goto out;
> 	}
> ...
> out:
> 	return ret;
> }
>=20
> in case of rds_cmsg_recv() fail the refcount won't be
> decremented. And it's easy to see from ftrace log, that
> rds_inc_addref() don't have rds_inc_put() pair in
> rds_recvmsg() after rds_cmsg_recv()
>=20
> 1)               |  rds_recvmsg() {
> 1)   3.721 us    |    rds_inc_addref();
> 1)   3.853 us    |    rds_message_inc_copy_to_user();
> 1) + 10.395 us   |    rds_cmsg_recv();
> 1) + 34.260 us   |  }
>=20
> Fixes: bdbe6fbc6a2f ("RDS: recv.c")
> Reported-and-tested-by: syzbot+5134cdf021c4ed5aaa5f@syzkaller.appspotmail=
.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
>=20
> Changes in v2:
> 	Changed goto to break.
>=20
Looks fine by me. Thanks for the fix.

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>


