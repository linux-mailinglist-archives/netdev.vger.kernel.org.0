Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC6A67F871
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 15:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234681AbjA1OHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 09:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233979AbjA1OHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 09:07:17 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3900A23866
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 06:07:05 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30SCtEJk022251;
        Sat, 28 Jan 2023 14:06:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=x8twOmu78+fDt8x3r0Xn4FhK0vdV3OJ7pQ/y0HqPitk=;
 b=Yot20JZ9RsDb55O8VPHh6IWkc/wVpkXZWRfFMju8fxNb3GBfFqcsMpt64DC6RVC8gcU4
 A2niIpZT+C8IjESpkOzvyJ6eWPlocop6lGbr2ETPlOdvQBzM1ojA8EArcDlne3Glmg2u
 4wkHiIIJLDVXwDuOfZXD1eXrg3ezDrGhUxWRxh3ZD8EzCfzNT+GvR2ztrOjB7cynhQl5
 mvgPyjxDzt7GeRW+KHuJFuMn26SeVG9ZcI+F6bri8cs1SIpvbcRq+fbam6NUw5QJrUku
 FuDVxa3T6rUNvF7RduebX7PmyTAMmoTHw3YtalAk2OTDqjTDNkzWiWDesdVN9xoif9Pi Jg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvqwrgy6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Jan 2023 14:06:53 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30SDqif8017574;
        Sat, 28 Jan 2023 14:06:52 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nct59pr72-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Jan 2023 14:06:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=imLfjbYKVGkWrhZJEp0QRdEGdkO+khlUa2l3aE8DuRmmy3v9gdrE0HsvRc8aKnHJXFNfRVe9CtJP3bMXA16rqbyaJ8mu7A+8moDF/z7kor2hB8Q0MCcxLX/DM31CN53OS/PCicM7p2WcQDIoRjmAR/rLTvMBcbGztNBvjHljzirTv4XyrGYUsR6Eyf6dk3WMNsPLg+J0nu/oI8HSfZ8NkiG9Caqoih4v1mDIvUBlGY339wD+qut1z6t8jyRElRS6LXCAf4GcPfHnUfbbSBIvhGT6oooVCwCOQgtJKjKzJu3PliNr8BZ3vMIoAOSQ5LKT2J43qzHBclKmP+aP5wG7zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x8twOmu78+fDt8x3r0Xn4FhK0vdV3OJ7pQ/y0HqPitk=;
 b=m2oHhDMnUlbs+P60oQJzqnIEVJHIfDYCBu1hwcvTNCH48F/Y5qIA9ZNsVQrvAUxxFpFym0O2oyamijP0xAQQlHAKoj+Oxzaq1/QSsPmuIxupVIwFmjmluCHUgYGFla9mfGHXBUCosiiJlfAg7OlDPIlZA4N+iB9yJLEm1O/pqWVdF9nhHIE+1Jp9t9hna7lPP9dU8fOM6WnVg8ksGXAopEeqh0RLrEM8Pzcx2kSgiwTdYHHhyuXluzehiZN54jI6ZT+UDsL8f04XoUH2Ics+6rKZ0bdcjXZE7f0KKCsIAbTbjBE2LGCu6yT+6eSrSFmZhK88F8ffaJwICOYUW482rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x8twOmu78+fDt8x3r0Xn4FhK0vdV3OJ7pQ/y0HqPitk=;
 b=qLF8brDCzGfKQ++i5g8/TgctLeCyZOe5STiBmaGR5ajIqyMXHsLRtcv/70+hPWPXAZIEvUahG6zZTn8keBgetpX6LBkrNCpNCtWuoe/sZHPphqP4Plh40fJpZa7vEBf8R7eiYuqxhOnL4CeAjow3jn5hPO4RwHzl3FS4iavSpyI=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DS0PR10MB7342.namprd10.prod.outlook.com (2603:10b6:8:f9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.17; Sat, 28 Jan
 2023 14:06:50 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::96a2:2d53:eb8c:b5ed]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::96a2:2d53:eb8c:b5ed%4]) with mapi id 15.20.6064.017; Sat, 28 Jan 2023
 14:06:49 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     netdev <netdev@vger.kernel.org>, "hare@suse.com" <hare@suse.com>,
        David Howells <dhowells@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH v2 2/3] net/handshake: Add support for PF_HANDSHAKE
Thread-Topic: [PATCH v2 2/3] net/handshake: Add support for PF_HANDSHAKE
Thread-Index: AQHZMvMNX3GnD3At1ECXj8a1a7fZTa6z3aCA
Date:   Sat, 28 Jan 2023 14:06:49 +0000
Message-ID: <860B3B8A-1322-478E-8BF9-C5A3444227F7@oracle.com>
References: <167474840929.5189.15539668431467077918.stgit@91.116.238.104.host.secureserver.net>
 <167474894272.5189.9499312703868893688.stgit@91.116.238.104.host.secureserver.net>
 <20230128003212.7f37b45c@kernel.org>
In-Reply-To: <20230128003212.7f37b45c@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|DS0PR10MB7342:EE_
x-ms-office365-filtering-correlation-id: f9d61b36-a425-475f-51f0-08db0138e667
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RiWWIZucPL3rVTF841H2C1o+7zJO7cTsROLS+tAXsqicukY2JFOzJjCOjRS741ZRwQSdbUzYu9syMnnyibq9JokX+sXdNlEQJkG9R5HQcRWhMpFGkSeBRPT0Z23xluPM9Oz2dQayNGB68UWZae+zqFkMkZDcyMAqcL/2DBdG0BvoiCDpLzWi2c/x70Y1GSEw2G6uLbIFoVdrQIA0YQ4tJTtzvX0ztaBfJacs4Hb5Qh7pGkumHs/7bsm1OjsJFln+Use9IhjnmumszBzQtvwVg5N2UpPTkWFwmnBQAYLGNNC47spoDRStHL5Mpw8xHnjsDFEcH6V0sqTi08pRsaXQNsdHQGhXpArbBujzGfYEFuorxuVLQnw8JKv/iHqNF/pgoJ3kIQrrHeeqQvHwY0o9AZAx+RNG4jU8SUvsuLoF6spTuVtKJXz0NiEyKk4amP15Mkte1j0D1osyuO1yN65vJoobXJrAWlp6YmzymPfN6ewPshMUXQl0kz1jzyp9EuPP1114aKARW117olVKg68km8FUWs0aKlJoAcYZUAfa4pqphIAx+y19ngulQ3heuIA64p+cZB/raLigWfcPjumnjMbOZ54SAE4+JRMDqfHkZhzUXHdHc5YJt+Xk4e2tNqd9Z4LQRRv94NGgGNOlJfhcL1VXxbl/NMeltX3bwXzhz5w1BRCP9rVuABK9V4U+ABWsRuw4YJsYLUfL2qq3yYOGTlhFJLoX7WHVDz4LJYRRlMg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199018)(478600001)(6486002)(71200400001)(83380400001)(38070700005)(86362001)(122000001)(33656002)(38100700002)(26005)(186003)(6512007)(2616005)(36756003)(53546011)(6506007)(6916009)(4326008)(8676002)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(54906003)(8936002)(5660300002)(316002)(41300700001)(91956017)(2906002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?u6MvQq++45b3bXdbyBX/JocinSBYOt0w3VoYB0/87+RKOha101QPSmXN5rUg?=
 =?us-ascii?Q?068jbDiekNjATsL0Z3mIiWKB2EizfaQjJf0YSkpw7ab0QVCQUNAXv00GPa38?=
 =?us-ascii?Q?blFz64qB+xns2NY+Bwc/Idd3Z3NWMKk+wdTxi11ArVw/ke6J3gK6z84sC5Xd?=
 =?us-ascii?Q?mAQczVf0XaS0PRC9ivZVAo7nH9/xqCPhzgSv6W/DPXFBTg3evTWvYNZFosCB?=
 =?us-ascii?Q?iXzocQoU3faaVx0G6BzkhCf4rCjh1vakJEtwm+eh5V5c1AJPfBlio1QMuj++?=
 =?us-ascii?Q?Ut/hJmoWiEJk1gz5dAN/MahR2rup5QKkbvPEM/oyFZwkDFe0gpD3ULCA44KN?=
 =?us-ascii?Q?YtqT5MAb41hz/hkzi01g7KnL8wx9gQ7YXyVQxKdiFqMdfgRjA8uaXStcZomW?=
 =?us-ascii?Q?b3VI3WubUWXEVSzDkedptCGIPpIXf0BpQ6MGUKt6I3pZNa3TrpJd4oEeYbHo?=
 =?us-ascii?Q?QTDrtXpR43HlT6+08qEHz0AoYyZeLDN7K85m4i1MEoBI+QmDUqnnbI5bn87b?=
 =?us-ascii?Q?luXPyfWwl1NoRxgg+142H3cJMGsTX2GEvfHSiSbUC5e6cUkR9bb6LXmwYbVH?=
 =?us-ascii?Q?1B5Kx5zi/mBDtPZ29ibLV3mIQVj/jjDzBJMQc6cZBxhVGcuLqPAu6WHIB0Bi?=
 =?us-ascii?Q?XGpVVl2uoyuH8ln1WSrny2HEj2JyEw8CgJWg0shuGEXs5ee5OQyJEbpaIl6C?=
 =?us-ascii?Q?s7n4aox16Mpiv2iU7N4LnTSGO3WyLcPtvwmEDHkOkP3raZ30LXkPOjYV9LMv?=
 =?us-ascii?Q?w5gR4HTYCDjf6b6Ak0AoF8u3riiO8pBv82v03dmZUA/Dz1gFDV0v5VPQmZ0y?=
 =?us-ascii?Q?5soUagsowHY4J0H54gztmROrgQ3jyZxx21UzTw3sWvkv4TGgjfwkVzCICPJp?=
 =?us-ascii?Q?80UEF9/4opJWpZHVjnc6Jv+sJQSJqWL3/lkIjIw/MfyXdL41nHjIYAvQyU3E?=
 =?us-ascii?Q?iOnlhZ4FqrQq+UxxPbt4u9ScdnojCv0j6JZDYj8sv98VHqOP5bNivdRBGyax?=
 =?us-ascii?Q?uHmAFumrxoqAgnnN+3y0uMqHQ6Z8j3JWJY0huT6FgH2IN53SA8LL1n4zXQlh?=
 =?us-ascii?Q?8Ql14u36BrVztpY2/12AvcN3SUmSoJAWiiU6Z1ciSXpDjAzohjNWtiuRaJ42?=
 =?us-ascii?Q?0L66L3BFIg8EsgkiCzA+h+95BMoM12CEgYCDWRNrZCVdxep/lzxP9TO6OQyJ?=
 =?us-ascii?Q?g2KaZeK85aBo8lyZKe2032IPWRMp5z8xmPMpw7l+mdwhZs5DvxpvZSuA50P3?=
 =?us-ascii?Q?1vyNLGXLPBJkbS4ERxP2wkk7J6xmVl4oyG0dNwwjheyREOnvxEIsjnPZi8eP?=
 =?us-ascii?Q?yRJhUAh3VZu5iPaqyFQl2smMaUZLpzIKC4xWqhyYgdixph7LQaHs181efAWi?=
 =?us-ascii?Q?VCov1G4n1sbxeKoRr96b4SnSZ50gtyaXrPg0UdCK0WTDsDc33I8EAv6nNAe7?=
 =?us-ascii?Q?OrTHj/ZKCQmLBYJ4bouLz0iIXo1w1Up++jKsRxnBPk/jE8UN1YizSXK+Po/r?=
 =?us-ascii?Q?qA8eLrZpdJFlkYZ05Y62Od/JKeCDQdHm/DRajay7zkuQ0z2uIYyVyXJEZSQO?=
 =?us-ascii?Q?LgC4TdYJ1mTIVcZyT3PEru8jU7PBUuWUKjWE5q0R0YNtCrg3tlHNdzPzXRxm?=
 =?us-ascii?Q?BQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <217F0C738179824F8E7DEE8AD179CFE0@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: /0d0pq2hSnNmhUO5+UsEXU8oF6j7WsqylcBzwO1UmVWj8HzznUjnjZLYvIKFc6dVsRnVHYOFr6KMjVqTvGZbHRNrXw0MfYUKpolGYvuPZulY3fEawhCggVSx/BgHrOkKTVd98rOiTpa1voRJrI1YCIGGPzXc2oNkX0SbeM98bqryfmezbCbvJGGcSaO8GFLn7HEqkEKIreMv5a+iFRGU1qcSNiAemJ1yedOLgY5HoXqOYTol6PrI1fxkD6HcgXAR+loy9UDGkOLqIlz0dVE1lnCf1qbtEycWWHWm2EuJQZ1O0EvpCpQqLNWI/YFzPlYS6JPB/N8cn3xYh3T/w5quxc+qZnhvs3oJAzmJ9uHcSuVrExX8QoM9WpfUXKlg56Bt8x7bMBEYy/LDVIbWw38+rljFGobYCIAigIMgqO4bbhhT5FMaHcivLEvKgEj6suQi+a7hJDW1h41S9bet7STpStX3fVNrRkMTr0RhwWm3X3dE7VfFEjOwc8aikQsPZcmIZXOoyaB1wHppPKAAeZO93pd4GkoxbmwUKClFNLjsUvWubVZC4ES31LkN/S8Bvi7aeBcu2i35eOa174tu6B99iFZoUOZT/tvXTBQk8ZChk4QWMYyH+EhWa/YyCEcrRY34Co5kMfyJNrsXgsDGnwirkdXYAKVksEHRtRU2vWQSAyzorpHK4fv7RFnIxL8/J96NjJmbVfTQkoiZKakhiLSWWUr+gMxSmkggo0SL5MpLAWedMdGCn9CsXq8jz044I9tizbagjkA35ETCT3Sdsmyz/32qlmemchDtxhwcmiqzPk9kEfJxTIwMHs4YySkk9p4jSPIRPEijt8R3Ez+omf+kQSqkzUAo/TZno4EnlT+3nf6ugzk2hHmFlWZp4WWZIVrO
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9d61b36-a425-475f-51f0-08db0138e667
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2023 14:06:49.8228
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GuwUztSk9PJtMjpKrR1QqwBZ1m9Y36JvZ0lSuAJTmpAQQVOG+CtWKcUJ2P1OZH0RlJSSEgNp+pyVfrj2hcdCCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7342
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-28_06,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=835 phishscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301280137
X-Proofpoint-ORIG-GUID: VLCOPHmlIPem6nO73Ur45AGCjdQ_Jcvk
X-Proofpoint-GUID: VLCOPHmlIPem6nO73Ur45AGCjdQ_Jcvk
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Jan 28, 2023, at 3:32 AM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Thu, 26 Jan 2023 11:02:22 -0500 Chuck Lever wrote:
>> I've designed a way to pass a connected kernel socket endpoint to
>> user space using the traditional listen/accept mechanism. accept(2)
>> gives us a well-worn building block that can materialize a connected
>> socket endpoint as a file descriptor in a specific user space
>> process. Like any open socket descriptor, the accepted FD can then
>> be passed to a library such as GnuTLS to perform a TLS handshake.
>=20
> I can't bring myself to like the new socket family layer.

poll/listen/accept is the simplest and most natural way of
materializing a socket endpoint in a process that I can think
of. It's a well-understood building block. What specifically
is troubling you about it?


> I'd like a second opinion on that, if anyone within netdev
> is willing to share..

Hopefully that opinion comes with an alternative way of getting
a connected kernel socket endpoint up to user space without
race issues.

We need to make some progress on this. If you don't have a
technical objection, I think we should go with this with the
idea that eventually something more palatable will come along
to replace it.


--
Chuck Lever



