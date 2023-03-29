Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC096CECE3
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 17:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbjC2P3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 11:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbjC2P3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 11:29:00 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA27140E4;
        Wed, 29 Mar 2023 08:28:57 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32TEYSP1026809;
        Wed, 29 Mar 2023 15:28:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=o4qlS1J1meg/HA6tAMbV4ABhwMauV6fTEacD8zgKaik=;
 b=BWwGMEsI4QDfdmRYP9afjqEw9wqLXnyVtlm2IseAcNujZfc9iDY+eAXkcEhscoyTezY9
 hHxrSPJucBU+vozIZY3HR7/QtJa2OQfm8Etf7bM/XYSXUWlLgvprx1Ym95V9RiBz4FvH
 GiJl+zZlRjECtw6l4r4AsIChGJlfJG7svzPNJKK46EDthhUBBpQV6sVJi26ETjaiFQXc
 Hq8gluoenunpB6UyOxapf6uFqhZC7X6l/fHHL7V56VChzFMGSRKBr6EluxgQVui1jUrc
 Csgf9IWXHW3UdIxB1/92DSDHNq/5UmobBFBPQbKdKqpgrIYD/4SP7zehgy3IJmm3HyJ3 hw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pmq79855b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Mar 2023 15:28:28 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32TEERX4036424;
        Wed, 29 Mar 2023 15:28:28 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3phqdfrn4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Mar 2023 15:28:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lXYXBv84wJc6hoZNHEwMbg8eRnMwFjJOKlJAXGxXkZnGDKNJbsevlbTXEgwDdGVCyZqruJSSEgY92d9+y3MNPfY++AU9GfjsatyupUippk40gv3/cqkJFN78YlE+2GhQ6VXmKF4rO9jGNmgp1sULkudHidrLXVJXZD96V77zcZ98jZ0gB62LiUfTemVZDIOKfItafWluof5NKwywl1aZGP2bBSSG75+3Vd0YL0FqVm1XGLv3NDafSwaH0rKop20d566KKIS8TWHjTgrMv5EHuUCMyAQiSeAkJcGWEWhBW+jPuwT3E80PLmgKaIrTQp6Rrp15+1wh2NcYc/OTwRM7Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o4qlS1J1meg/HA6tAMbV4ABhwMauV6fTEacD8zgKaik=;
 b=Zsy+FDclFK+c1nJvhMgaCGHb9vCgkCQTMVmH6F3q+y1G+xTK2iMxIcqne8fx8gCxLD2MOfA56Zoq8J5XFpBHFgFv3szS7TyOJZAiG399LQyo5tZ5ZKcEpLn/c2VtvEktZNEtpDfou+FGl33axXVLM8xozNB6nok/CmeGP9gMR5JidKL/4Lb4whkwom6pTVFtqefg2RfubSOCvBFrt2qORfwwrROgx0bgUPmya1VNCd5bR46azOKdNXvrx64j5AXS19fxBRuoDE3TixdL+yqeEVwT9DLMTaXg4d1T7Expq9hzf7EYMOFM8mE5jDpxU/9toVTdQ9Wt/YObxKHwGvW3JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4qlS1J1meg/HA6tAMbV4ABhwMauV6fTEacD8zgKaik=;
 b=BkWUIUHWsMfcF9c6VS/aY+osIlf1eEVvy91DSUiTM8Vp+nHGDTnJPtl0va3P+6H1IiHMC53T//hPVGIcdQ4ZVEJGdWMJPvyDwbuseBtqmBKdvg3fnqBooaYEt9H2kpzT1PKW7k0kslVMkhGsormiUIFLngSjkjsHmRFYExm5fh4=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DS0PR10MB6800.namprd10.prod.outlook.com (2603:10b6:8:13b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Wed, 29 Mar
 2023 15:28:19 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%6]) with mapi id 15.20.6222.035; Wed, 29 Mar 2023
 15:28:19 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     David Howells <dhowells@redhat.com>
CC:     Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: [RFC PATCH v2 40/48] sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather
 then sendpage
Thread-Topic: [RFC PATCH v2 40/48] sunrpc: Use sendmsg(MSG_SPLICE_PAGES)
 rather then sendpage
Thread-Index: AQHZYkj+dLwZN/D8CEye9eJOITPkS68R4ZoA
Date:   Wed, 29 Mar 2023 15:28:19 +0000
Message-ID: <6F2985FF-2474-4F36-BD94-5F8E97E46AC2@oracle.com>
References: <20230329141354.516864-1-dhowells@redhat.com>
 <20230329141354.516864-41-dhowells@redhat.com>
In-Reply-To: <20230329141354.516864-41-dhowells@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|DS0PR10MB6800:EE_
x-ms-office365-filtering-correlation-id: 29952f34-340c-4802-4307-08db306a397d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uc+OFYe4rkG/aqctaOwoxfAXWpBC1BN1Ieb6pA2rkPHZDtavd54FenF/rzzDrcX3drvhMTmIot5dy6Fw6yoBhm9FJkH1vK93ok+802sUiFQmQb1jCr6DTSD6rkxlrermhxhWwDgLw3460kdBKR5RdF/2LI/7G2CtJPlNsx3r5WtNYXq9J8FlNKv8N1jPaliQiIk1QT6ZJa0Crkxi9TY2mRte8fqWygF8pd4EUwtLJ5i0Fb9P2yFasF56g/j8lrfr7aOJUF6lCCewCihEuV9ktkqFca0sPr87wpONw+03LPiWUpw/WxN1AZEEaZ4OuhBetvwxG2RstKPM12jS2i3Uk/3xT2rYMED7m3Dnvg6JRM8W2Lqg4wPXKz4GJd0KW+B9dr/VYDHlTGSUlENfNwD4gA/Af+Pho04EG27WpU5pA1HIvBEXXy/Yo9twYykOzkHWvu+sdFR5tlYe5Pm10OIIO5cpR6Crffp91k64xWrnl/DTXGmHKrSnDTdcO1XWZHV7GdCqjIKShjU1ekVpnhVOGVYc6RQVL5O7ZsQP+jpie9l0I9tPc53d0xxkhk4YQee0pGw6izDpTEF1y8Ajo/JUtNhOw93IuJ2ufUfHaz96VOVTNp+kcsasVTb83hh+ztVguuUrnXzETgaW3h+PVJuilQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(346002)(366004)(136003)(376002)(451199021)(122000001)(83380400001)(38100700002)(66899021)(2906002)(2616005)(8936002)(6486002)(7416002)(86362001)(186003)(38070700005)(71200400001)(33656002)(316002)(54906003)(76116006)(66476007)(5660300002)(41300700001)(478600001)(4326008)(91956017)(36756003)(53546011)(6916009)(64756008)(6512007)(26005)(6506007)(8676002)(66446008)(66556008)(66946007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gH+wf+V7Ljfr5w7+beTL1WHVRqvXJGpOFawz7lmRgt+6D+izjlKPfutMEv6y?=
 =?us-ascii?Q?v9hWT1NwS5AmMWAeKgxqv/0EcK/9lH7FIgK3oxeShe0+BVSywM71GZASjt5l?=
 =?us-ascii?Q?2Knx3CFPFmHyFr1zKwE5YmKJMl1EHAr96k/TqfRjznkREjl02weu+d2dn4Ed?=
 =?us-ascii?Q?0vt99lZnO/AD/rrs89lWR3O/TpS1/umlfuA/QnKQBcB761byC1XkecLEXRvu?=
 =?us-ascii?Q?fXr3PoIxGSTuNrF5pu80ip0nTPYRVsE1Xtc/d3wpasjVbnHf3Bqgr3XrfsGX?=
 =?us-ascii?Q?r8jmk2rV0S1PChgbs88QsNQMur1PN50SejtrgBCyU7l44NTaoL2UlppKKWgO?=
 =?us-ascii?Q?uu1HIcqXsQtsQ5WRYZRFgpwqya/3LbiWQAYDrsIr30pf8eo+tIQKlNHGXw6E?=
 =?us-ascii?Q?y7weX7FqyOl6EG4IJiesNHOHPRFtdSj0Dx6HQCDDv/0CLwHr+G01NQXzjFs0?=
 =?us-ascii?Q?J+T0l4NXdhAxeHWiclrnKTfstGTz+/UZ/Gsf82JBIoyay0O4T2H/WF1sODKj?=
 =?us-ascii?Q?Dp9PkdovSkYQkVB/eouJwwoswIhlGHBqivs+pfspmFCy+deO1VQHRyusWBqV?=
 =?us-ascii?Q?OFwdF95yMKvadsUv2UQzUqncu6txWEOsTwlfB5T1Q6iSVAxOLxoKniikmuuq?=
 =?us-ascii?Q?Ios3gH9O89EqvZuX0li5B91Bw5ckwXVE2iaiG8v76QmnLX0WhKsM6t5e/4XI?=
 =?us-ascii?Q?vLIG4NhHrCo0jwOTHU6gnNn33RydS+z42B+QO8hCDGE+0JWxQT7K9wEWq2sB?=
 =?us-ascii?Q?o/R8A0VEXFRMl2eTzRIaJm5RAUaIyuNAE4XHuMtkaZ4jJuw9ng+ZKUNhp3b2?=
 =?us-ascii?Q?MrjAx02BiE4oQ1HkpDOATwT3d5qLw81IdhcpuiwVYEeSi5hDdtFNM3ZgG6iQ?=
 =?us-ascii?Q?QXNU0zINmdkNjFRvldmJF17QeS0YbiicvomHrOnq71LmK0AjWe5ottbRkvaz?=
 =?us-ascii?Q?eWm4J03drsiORASkSRAbwjgVXdiHfuWC3nlMRPuk+EPNQOslXZvTCoHHQrR3?=
 =?us-ascii?Q?nutgYvNlNIbloxdb9tHbrwrJM1OaVuD1J6c8RfC8XtqTVk2uwWo+AACaNofP?=
 =?us-ascii?Q?Lu8O/VR96uYZH8albOkrLbdYyVpl2vG1Oc6gC7mHJVv/ldegnJvV5KkLzAhz?=
 =?us-ascii?Q?hbovgAigNL58k9SSRqrrbTsTz5EyoJJPmHJNBIPLgIWDawebuedb54vGfJmO?=
 =?us-ascii?Q?xw+04ag4He3iD8dZKhq9sNIv+83s61jZXEAByWcLgmbTCriTByNwX9UYYckj?=
 =?us-ascii?Q?Pzpp+gJnUkmjtqsng4DQcR+KB5g+9YLnts6fim2MJnjfz0Cc3e/KsSH5XVi2?=
 =?us-ascii?Q?Xj1TmLdrivXXIFSoMWHQ/w9Bb29J9lzEyu+QWu15NTOyahDNCgUAva4uefPW?=
 =?us-ascii?Q?KjieLtCh7kliXiTD7ZxpXaiNNDEMu4TobjrH1Tu1bsvDCYiNcxCXMgL7yohf?=
 =?us-ascii?Q?W36es0+xxYB52n1Oc7fUzrCD81ZhjrkwrsN4zBXBreiNzklQclbBR8mPIJj7?=
 =?us-ascii?Q?5bJO65ngc/dLoKgYlp06UREcTVSB3Ln79SF3m04z+oQZKdkespFZSoaCUO3S?=
 =?us-ascii?Q?LRQ71jvNERH3/BkkZJXsMbmRm+9YGU7QLnaspTlY4yp4HWMpWpqqEc4OecXW?=
 =?us-ascii?Q?TQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5741FCAB13B70D45B159C3DCB0815A99@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?IiyAjFWSga6beDy+GgEMBg8ji9HgeJcRQYijIyGhL3k08UUdgcbfzNOKrDG2?=
 =?us-ascii?Q?QJE+jei++ZYVBK9L0FUeyRzuEtm5thJVC5rmwnMZe9mHcIpGr6shGWG7OWvU?=
 =?us-ascii?Q?GJM7/fqnNWhpk+m5nqoh3jLBbPJnDPVlCa7aFRa4DihPm500qHvf10kloL5b?=
 =?us-ascii?Q?oHhnESnh4U8PKiCYxZRm+9oCgMQJq80uYQ78mIAnzKn3o0Mju9zzk2yKpSdE?=
 =?us-ascii?Q?VsOMw4vdxDECEHO7Edathso/41qjaDSwYC1s4iUnnQy4cXzQ7x+p0UdR748K?=
 =?us-ascii?Q?H2rTrSfPKDthX3rZ5+DUp96NcMMAOf1D5/8hyx8vai3qQQq5SzUIIit5Zrh8?=
 =?us-ascii?Q?x1pLx4pEI191PnYhHyMhTsAUm2rxX2c4qoFeHV/N3nbu26lrXPpoeXlG3Kmy?=
 =?us-ascii?Q?/vT9Rkjqt2kK2JdqxdkCORmm6EyMSfiwgyc5cMwMrpiBX9EVpid+tGzIenAi?=
 =?us-ascii?Q?nTvTdMfvnovKYL+UTV33eZCLiOYdvU679Pu8hAwj93u69WX7BB3I9ndXAmYV?=
 =?us-ascii?Q?uDgVi+hi8uY2L39r8EeneIdltoZAhb2gwGN3rZGIeyLrbzKyaQ9lXVMvSj7Y?=
 =?us-ascii?Q?ChcswjnyzkULYIUT54UehHPKk4dHhF41SOQLRzyTIr/zn2wWEDsKDRegard4?=
 =?us-ascii?Q?bxHcfadonGjuNGHtpmg4+2wSrFcdMJAMQeBk6EcNukIkcaMygCAeYT9PxGdU?=
 =?us-ascii?Q?71WIh70V17gfkrH8tHWdubtGyJaPi/UIF0GiXSoI1nhF3Zigi5yA9T24F5sh?=
 =?us-ascii?Q?IG8sqLWd6DGnr0K147sLPf45nKnu7cRO5j3jmAMn4FAAKXHKKlVlAbTEcA3g?=
 =?us-ascii?Q?Udi17L2+wIzqbP+QAttv4og8AV4vyt2WCk/ZFMSzP2piUBZg/TkN7IYbvjAv?=
 =?us-ascii?Q?OW58oG9whfQZ+VwmqXozHsAXB21EF+RS26XUp1Q2f9QD68GVMkSSP9FP4D5v?=
 =?us-ascii?Q?Uy+8oAv+WmqC6Q2PPJDkJ7O3n4jXMERPAo6EkVVaFhVdJW4W1DZ2jSBw9xE/?=
 =?us-ascii?Q?TBkWcJ1jmlToGad8dUOBvc46qhuMergSVG2XkJ4lPLrQ+vsuwE2v+x8otboc?=
 =?us-ascii?Q?rza5A3ipHE4ZunFwvCQ721xfkCvkLpVMQ4x7oZFUxf6TTnhyaAigmwYXvTKo?=
 =?us-ascii?Q?9d9g5HH2YHDw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29952f34-340c-4802-4307-08db306a397d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 15:28:19.1874
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m/g6U83PW+93WC0GkiispkZupc+NFt8ak/h7KtcncaEzlUGLZDYq0iIoLEiOi8FilIq2S54Gm9ihiB9Qprm3kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6800
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-29_09,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303290122
X-Proofpoint-ORIG-GUID: qbvuQsjfBAAFR8TCrSLm3x76DtgryC6l
X-Proofpoint-GUID: qbvuQsjfBAAFR8TCrSLm3x76DtgryC6l
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 29, 2023, at 10:13 AM, David Howells <dhowells@redhat.com> wrote:
>=20
> When transmitting data, call down into TCP using a single sendmsg with
> MSG_SPLICE_PAGES to indicate that content should be spliced rather than
> performing several sendmsg and sendpage calls to transmit header, data
> pages and trailer.
>=20
> To make this work, the data is assembled in a bio_vec array and attached =
to
> a BVEC-type iterator.  The header and trailer are copied into page
> fragments so that they can be freed with put_page and attached to iterato=
rs
> of their own.  An iterator-of-iterators is then created to bridge all thr=
ee
> iterators (headers, data, trailer) and that is passed to sendmsg to pass
> the entire message in a single call.
>=20
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Trond Myklebust <trond.myklebust@hammerspace.com>
> cc: Anna Schumaker <anna@kernel.org>
> cc: Chuck Lever <chuck.lever@oracle.com>
> cc: Jeff Layton <jlayton@kernel.org>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Eric Dumazet <edumazet@google.com>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: linux-nfs@vger.kernel.org
> cc: netdev@vger.kernel.org
> ---
> include/linux/sunrpc/svc.h | 11 +++--
> net/sunrpc/svcsock.c       | 89 +++++++++++++++-----------------------
> 2 files changed, 40 insertions(+), 60 deletions(-)
>=20
> diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
> index 877891536c2f..456ae554aa11 100644
> --- a/include/linux/sunrpc/svc.h
> +++ b/include/linux/sunrpc/svc.h
> @@ -161,16 +161,15 @@ static inline bool svc_put_not_last(struct svc_serv=
 *serv)
> extern u32 svc_max_payload(const struct svc_rqst *rqstp);
>=20
> /*
> - * RPC Requsts and replies are stored in one or more pages.
> + * RPC Requests and replies are stored in one or more pages.
>  * We maintain an array of pages for each server thread.
>  * Requests are copied into these pages as they arrive.  Remaining
>  * pages are available to write the reply into.
>  *
> - * Pages are sent using ->sendpage so each server thread needs to
> - * allocate more to replace those used in sending.  To help keep track
> - * of these pages we have a receive list where all pages initialy live,
> - * and a send list where pages are moved to when there are to be part
> - * of a reply.
> + * Pages are sent using ->sendmsg with MSG_SPLICE_PAGES so each server t=
hread
> + * needs to allocate more to replace those used in sending.  To help kee=
p track
> + * of these pages we have a receive list where all pages initialy live, =
and a
> + * send list where pages are moved to when there are to be part of a rep=
ly.
>  *
>  * We use xdr_buf for holding responses as it fits well with NFS
>  * read responses (that have a header, and some data pages, and possibly
> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
> index 03a4f5615086..f1cc53aad6e0 100644
> --- a/net/sunrpc/svcsock.c
> +++ b/net/sunrpc/svcsock.c
> @@ -1060,16 +1060,8 @@ static int svc_tcp_recvfrom(struct svc_rqst *rqstp=
)
> 	return 0;	/* record not complete */
> }
>=20
> -static int svc_tcp_send_kvec(struct socket *sock, const struct kvec *vec=
,
> -			      int flags)
> -{
> -	return kernel_sendpage(sock, virt_to_page(vec->iov_base),
> -			       offset_in_page(vec->iov_base),
> -			       vec->iov_len, flags);
> -}
> -
> /*
> - * kernel_sendpage() is used exclusively to reduce the number of
> + * MSG_SPLICE_PAGES is used exclusively to reduce the number of
>  * copy operations in this path. Therefore the caller must ensure
>  * that the pages backing @xdr are unchanging.
>  *
> @@ -1081,65 +1073,54 @@ static int svc_tcp_sendmsg(struct socket *sock, s=
truct xdr_buf *xdr,
> {
> 	const struct kvec *head =3D xdr->head;
> 	const struct kvec *tail =3D xdr->tail;
> -	struct kvec rm =3D {
> -		.iov_base	=3D &marker,
> -		.iov_len	=3D sizeof(marker),
> -	};
> +	struct iov_iter iters[3];
> +	struct bio_vec head_bv, tail_bv;
> 	struct msghdr msg =3D {
> -		.msg_flags	=3D 0,
> +		.msg_flags	=3D MSG_SPLICE_PAGES,
> 	};
> -	int ret;
> +	void *m, *t;
> +	int ret, n =3D 2, size;
>=20
> 	*sentp =3D 0;
> 	ret =3D xdr_alloc_bvec(xdr, GFP_KERNEL);
> 	if (ret < 0)
> 		return ret;
>=20
> -	ret =3D kernel_sendmsg(sock, &msg, &rm, 1, rm.iov_len);
> -	if (ret < 0)
> -		return ret;
> -	*sentp +=3D ret;
> -	if (ret !=3D rm.iov_len)
> -		return -EAGAIN;
> +	m =3D page_frag_alloc(NULL, sizeof(marker) + head->iov_len + tail->iov_=
len,
> +			    GFP_KERNEL);
> +	if (!m)
> +		return -ENOMEM;

I'm not excited about adding another memory allocation for this
very common case.

It seems to me that you could eliminate the kernel_sendpage()
consumer here in svc_tcp_sendmsg() without also replacing the
kernel_sendmsg() calls. That would be a conservative step-wise
approach which would carry less risk, and would accomplish
your stated goal without more radical surgery.

Later maybe we can find a way to deal with the head, tail, and
record marker without additional memory allocations. I believe
on the server side, head and tail are already in pages, for
example, not in kmalloc'd memory. That would need some code
auditing, but I'm OK with combining these into a single
sock_sendmsg() call once we've worked out the disposition of
the xdr_buf components outside of the bvec. That seems a bit
outside your stated goal.

Simply replacing the kernel_sendpage() loop would be a
straightforward change and easy to evaluate and test, and
I'd welcome that without hesitation.


> -	ret =3D svc_tcp_send_kvec(sock, head, 0);
> -	if (ret < 0)
> -		return ret;
> -	*sentp +=3D ret;
> -	if (ret !=3D head->iov_len)
> -		goto out;
> +	memcpy(m, &marker, sizeof(marker));
> +	if (head->iov_len)
> +		memcpy(m + sizeof(marker), head->iov_base, head->iov_len);
> +	bvec_set_virt(&head_bv, m, sizeof(marker) + head->iov_len);
> +	iov_iter_bvec(&iters[0], ITER_SOURCE, &head_bv, 1,
> +		      sizeof(marker) + head->iov_len);
>=20
> -	if (xdr->page_len) {
> -		unsigned int offset, len, remaining;
> -		struct bio_vec *bvec;
> -
> -		bvec =3D xdr->bvec + (xdr->page_base >> PAGE_SHIFT);
> -		offset =3D offset_in_page(xdr->page_base);
> -		remaining =3D xdr->page_len;
> -		while (remaining > 0) {
> -			len =3D min(remaining, bvec->bv_len - offset);
> -			ret =3D kernel_sendpage(sock, bvec->bv_page,
> -					      bvec->bv_offset + offset,
> -					      len, 0);
> -			if (ret < 0)
> -				return ret;
> -			*sentp +=3D ret;
> -			if (ret !=3D len)
> -				goto out;
> -			remaining -=3D len;
> -			offset =3D 0;
> -			bvec++;
> -		}
> -	}
> +	iov_iter_bvec(&iters[1], ITER_SOURCE, xdr->bvec,
> +		      xdr_buf_pagecount(xdr), xdr->page_len);
>=20
> 	if (tail->iov_len) {
> -		ret =3D svc_tcp_send_kvec(sock, tail, 0);
> -		if (ret < 0)
> -			return ret;
> -		*sentp +=3D ret;
> +		t =3D page_frag_alloc(NULL, tail->iov_len, GFP_KERNEL);
> +		if (!t)
> +			return -ENOMEM;
> +		memcpy(t, tail->iov_base, tail->iov_len);
> +		bvec_set_virt(&tail_bv,  t, tail->iov_len);
> +		iov_iter_bvec(&iters[2], ITER_SOURCE, &tail_bv, 1, tail->iov_len);
> +		n++;
> 	}
>=20
> -out:
> +	size =3D sizeof(marker) + head->iov_len + xdr->page_len + tail->iov_len=
;

	size =3D sizeof(marker) + xdr->len;

If xdr->len !=3D head->iov_len + xdr->page_len + tail->iov_len,
that is a bug these days.


> +	iov_iter_iterlist(&msg.msg_iter, ITER_SOURCE, iters, n, size);
> +
> +	ret =3D sock_sendmsg(sock, &msg);
> +	if (ret < 0)
> +		return ret;
> +	if (ret > 0)
> +		*sentp =3D ret;
> +	if (ret !=3D size)
> +		return -EAGAIN;
> 	return 0;
> }
>=20
>=20

--
Chuck Lever


