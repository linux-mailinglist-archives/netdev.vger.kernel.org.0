Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 051D36E3303
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 19:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjDOR6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 13:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjDOR6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 13:58:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 000743C13
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 10:58:09 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33F5g6tZ030453;
        Sat, 15 Apr 2023 17:58:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=9wIP6HK7amCs/VMcbxycHIflGO/+6D57cXD9hauH150=;
 b=A5jnu3OwDz/3c82LvWbP1z0uJ4WC55Z9QpyRuOFETvRejTSj5FTiIHNxJV4AIGieHA7m
 Z8gIpdfIN2Eb8oOVbxz9pP3wOYixcNAeo8kDj5yOgVVkjTaUwd3ilqN0fRDibfn6Lpb9
 ZUCN2cvgLQDhmGv7dnovgNi9GWz9O4qM0VOUtThgPjs4wCsSVVDBPE2P1n9t5nY2HFJE
 vlOUtTbCvn+oaUjNcfE05o45uW+YFzQHuFdIu4kEfbwKqRHHZqKOroijm/P1L+r+j3HF
 mrVQXhb/juOYXd/ot2ocq/VueJm88XO41bE+RGYYpn0OY2d0kGyqTiYrrrplWn0NFDhj vw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pykhtrnp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 Apr 2023 17:58:00 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33FH4FHI007634;
        Sat, 15 Apr 2023 17:57:59 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2044.outbound.protection.outlook.com [104.47.73.44])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjc27b8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 Apr 2023 17:57:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UfUbb14TLbpxTCW2vR6Rr41m6Ixv6vfP9PpSldzi/pkOCkymZE0s2MmjL2QuvAVgyC9WabyiN+R9HVXdU8hB0+zyRoS19sTCTemO5PMNJyT3/YKj0v1QD66tScjlQnHDxhxkiYHjGbNKhyDezI95HaInKjr2lorY7WC8gjj1pPs7B5WcocGsPWqqQ2WWm5NvnwCL+IZkIPm541Wl0BpqqAFJMahbNN4pMpLcIYv6rTCpBnnmQWfykuVrDd4lgXsKBCYO4eDDD2JlPMgBDhbyETMkhEYWlLa7Q4lwIAV1Gno8pTFCrCkt7ECQbULd+kNHhpLdBLYukAgJX8Ir6bOZEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9wIP6HK7amCs/VMcbxycHIflGO/+6D57cXD9hauH150=;
 b=mBQGclVqfcQ4FfQGIFPGzBmxLCRgSHnOXhUN2v+30vDOtKrO+B3oJ47emgIE2CC509Y6zmyS37XaSJEIIjdAES2+9r1r7f5SpYfUvgpSVJtqWemYn3143d6QdP5eleWTRvs+F976lcnMmvpEQK1MuLziOxFYg5Nqj/7Zxm3gkqKr+A7VHMWPUTFEd7fRigvk4x4b1BYKmESAHtYYXjoG6naEvqazOiDuQhGrACz+PFSapQUqrEvyF6FvMFn8/daI/XD14UtifNrHZAeNiwuBVDdvfGcSvRHJrPRZNUmfagGIXWVKbmL/ZTWGJxjC+cfvzwtfSPnF8/HWOSM/swiofA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9wIP6HK7amCs/VMcbxycHIflGO/+6D57cXD9hauH150=;
 b=IKYK9M+01Z5uverTFCAt/+LNSZFF3Y5DtR6vUAB8QJHfX1dd+NkJaMk7ap4pN+RVRZ0qtwcELN5sEZdBJh2mANDKmbUNvJTTQXu7NlmM0T1DzPtVWc/XFkHMGjGjkqo6sm16MStRfa3ymqo8T/4FotU0MRhnw9dYD3yEaDAASKI=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by MW4PR10MB5725.namprd10.prod.outlook.com (2603:10b6:303:18b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Sat, 15 Apr
 2023 17:57:56 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%7]) with mapi id 15.20.6298.030; Sat, 15 Apr 2023
 17:57:56 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>
Subject: Re: [PATCH v9 3/3] net/handshake: Add Kunit tests for the handshake
 consumer API
Thread-Topic: [PATCH v9 3/3] net/handshake: Add Kunit tests for the handshake
 consumer API
Thread-Index: AQHZbjwkjSZ2M9hK9Ua6WU+fbYWpF68rl3WAgAAJ/oCAAAJwAIAAF0gAgADv7IA=
Date:   Sat, 15 Apr 2023 17:57:56 +0000
Message-ID: <ECA36DAF-F928-4EBD-9CD0-3AA20C2612FF@oracle.com>
References: <168141287044.157208.15120359741792569671.stgit@manet.1015granger.net>
 <168141324822.157208.14911977368369619191.stgit@manet.1015granger.net>
 <20230414183113.318ee353@kernel.org> <ZDoGw3nVG+jNWrwV@manet.1015granger.net>
 <20230414191542.16a98637@kernel.org> <ZDocVvsqKJ57c1Tk@manet.1015granger.net>
In-Reply-To: <ZDocVvsqKJ57c1Tk@manet.1015granger.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|MW4PR10MB5725:EE_
x-ms-office365-filtering-correlation-id: 8af5151d-7761-4586-1887-08db3ddaf11b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sb4xP83A8WzLM3K4TXrf30v6bVJ97HScVre+fk8CdFz6TOxX1pJq3epVSq/2ZthlQFtafD2eCxeQoGTmwP22jBfX/2AkVQADiX4FZIHvTNSNVls3p+dcHO41dNvD2fEzkv+7uAMJyB+S1eZFxYEJovwq2t8v0t52tJLxycEE/jJamZkQRkTPUoEHXqUCPD2PfAeNwJSpraU/tIwkh9dT9ejMq4+a2lCHmzuUiLWoln+3ehTxarABiFC9+8jjj8fFnaPIAC8r4mjXFl06/xHoPkIrLgx0MCEY0ll3iHjqE/npqS1Ej2SVC1nyK+QZlp6lk8qgalzNlYd+7lgMl6fMiVtqUF2JvZpSAIakcQuQObj+Q6Z7+UbojJ3XsFF/9wPMkXo9fhHd7JyukysVAKnZEVcrBivx5KX0pfRAgDD/t70wg/GtELZhPQe0d0TkHOVN45VOoUG+MYSZpJIjm3gV6vZHNcRY0jVHdRv26fylYfaqXwkk2R+pNS8i078yLQuXvRV8JXAqJZPzLWHbppPlHuSHimV9RNlhPc/iUGvs+FrrUBoczh0RxX+GzRkHZzan7dxt5zwHRKae5dBFL0NO4oWP8seLmoB2cjgKz6sAL0j8ohNcZctuLb5P8th0nn/0aS/oYl33t760I2jVL2/yGw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(396003)(376002)(39860400002)(136003)(451199021)(2906002)(8936002)(76116006)(91956017)(478600001)(8676002)(5660300002)(41300700001)(316002)(64756008)(66946007)(66476007)(83380400001)(36756003)(66556008)(54906003)(33656002)(66446008)(6916009)(4326008)(6506007)(122000001)(86362001)(38070700005)(38100700002)(186003)(53546011)(26005)(6512007)(6486002)(2616005)(71200400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?O+NI+ykwawSb48N1u6UPISxNIAXEdLF1UAf3ZsnuyRJuGL4M/PLkoqhApvsz?=
 =?us-ascii?Q?P84qxbNXH3y+FlfrHoYPCwuR3Ppib921WLDdKjleu0V4dg+6p5m0pyKZUXtC?=
 =?us-ascii?Q?pyEgf9dvlJQteCTcJd8/ybpx5PwaffYyoptoh+WhenYEFPOFRSkHF/V2YMEp?=
 =?us-ascii?Q?ADcly7IQpzs99k4mBqSBYT6KXI74MgES73/wSuw5xL786mK4vvv86KaiAWjM?=
 =?us-ascii?Q?grAdztEXgHfqfgqpU4WUR1hZAafGfL/4spwQGNnVRK9PdSL/Pnf+eytTuwWP?=
 =?us-ascii?Q?q/l8ntAExytCquFVxijvIlc9zJb6LMVXJWzz4KENvY8sdF44v+pKd9JyV3YU?=
 =?us-ascii?Q?EbKobTXymKH2omUy8SWXpvGSXGNBWY2tlu/vKdhHRbO2X7kVL8i6S0aCsWnf?=
 =?us-ascii?Q?T+DAeN/yE2zhAbs4OWqXekiMMriHdzIO5f+xF1zRackFGTS5WuUlrZA8SJpx?=
 =?us-ascii?Q?Ppn7HFFHIlKEe5Xn9qTjhkDfW/F47nz5a9ZdqdAK6rg10wiKLCuiV1Kz3Ayp?=
 =?us-ascii?Q?q9S5YIb4I3djFBbTOTI/E+hesy1A8X4ZwOz6OIMAE3ix6d/E7anhcDC4zb/H?=
 =?us-ascii?Q?BWauwBYTFyGO0ENLkYtl1RiH+5XBvBT/6OAxwlsmXYb/nzYbxKOUNlBRZNNc?=
 =?us-ascii?Q?8YfizxNz3BW0VF2n4sSZGtIi3UOa5qYScIVHgZW6LKHu3ROJtC/pMzj4YPCL?=
 =?us-ascii?Q?ke7r8hyJpR3EtjjyRqWNem6yB/tImQ7CEEOqEZJKfhfsuuKOAUFVV6lmDwSx?=
 =?us-ascii?Q?Ksz9/nB1MnBf0sn4c9nhgaBAtLFGS/+Cf+mSkJjt1x7Ha1h+1+VU6T5yqJbE?=
 =?us-ascii?Q?BcnfV6vrl6vLDkkBAkmXoQ1nlUO4swsaG0uTWySdrW0sjKnoIVlMhdgOBAz4?=
 =?us-ascii?Q?TQUl8uk1Fp1dHbMlKnHucg6B6kKWn4axOA36lK+CwqhF3b05apd1NMnjZKTH?=
 =?us-ascii?Q?N7eTgwW3miYR54zW7sT8TIWB+wKPfSIc33PuJOy7F6tHWrge3hMUB+MxbCWm?=
 =?us-ascii?Q?L/yZqVX11cs9Qo98Dl6hsVvbvqIkm/8hx0QePR32/HM3/oiJ4fqEzfADB0S5?=
 =?us-ascii?Q?Yx47G2yPueTvj4MGQWSFPQJtaH2S/SukiFIy1uxM25z0a78VDQoi/K5Kkj9H?=
 =?us-ascii?Q?8yeIXMZzKGzMIt2OYwUNn0iWB59VQcbOFZ7KpwRAqb81H8FzdY8AdGDY++/q?=
 =?us-ascii?Q?G+9spoIpTAYGcwh+XDv3y3iVCrzig8iBkDS6zlMEFeZXg5QmTcdKVb4T269b?=
 =?us-ascii?Q?E7itFifZoflDWjSG1tWuNg5gJTLrIIpRwMA7dKIVcih9uOvk5AlzuE/pSpuT?=
 =?us-ascii?Q?dv88oTW9vISp9MeR1Cp39yxVvOOrim9LupqAn0DZG6PD32ElbY3V+fnb/R8a?=
 =?us-ascii?Q?eTJuTq8M7N/n7jC38jLdjgXBJN0DOoBbsEbUSWNJxqlYzJJjCN+uHhO2MOua?=
 =?us-ascii?Q?a0asyPeYQGC+vVXRS0UrqtJqFmHJlN8FV0YtOx+h2rwkdOQOt2XqiO/qg58J?=
 =?us-ascii?Q?poRWmR8dM5rP3ZQN6FAa6avxwKKVxSrDBqVD1FEe/Zl57GWdyI0rfdh+7JOK?=
 =?us-ascii?Q?DCoxkqMSv0/OiTpcGrDp7mhETrYoiuYLEwT+1NlMMV4uM6rTE1p2KsL5cqim?=
 =?us-ascii?Q?NQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EB61812F9CBD594892CA8E40138B3C82@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 0ykzSHw2oh3YeUh+JU16XfisKDENvhStq4Vxk5m2KwCNdEeDKGSma6k+4QBj/6Qi+6XlnnBIGdB91efZWZZtqF+vjbVLHhkh7WH0Wd5wx43DCBuvy7LeG/epppgFOKRVaxktmT+ucdCPncL0UR9u/vjVZuJ1slIC//99tioMh21mGULQROp05SXsMzOe0mVUfMLim4DdJClYDJNBM3kzLmcLAmNMxG/2zGMXiKIE4XgVNmPeTPFsmXexB/kjCTroFL1iHzZ28rfZZX1r4lOERtLjIg2rfyJqSkl59Q0NP1O70Ck+GIrWvyARWvzeFH5jYvXs9RpYAj7OX+CeG5cdK0wgWE3rS/G1UTvRmg5XcSgksC+vLjbDb5mTxfg6kPGxThdffBz1a/4g6XQXxHsh/hsYJktt6+C/hzgFJkK04nVDme//FXTqXGUALA7nAYwkYpRfmm5hoKpM88pjEpzsToivBPvkEfsdNrdWaYBsJvqMShwAWCzO2+k1Tgoo0ug9Ui7h3MGibIIsbb79MgPVsgmgoCVrlkqMpGIEnBansNJM7rv47tDG4jiszqOtrvZoWnBm223MNtaXkCQx9KTSaVTOZDYCBtu8eJIy36eQnCpRDVchXrck3PyuXmoDivaUHfQeh8SMFg13Auv+dsRInVsAhVM8ciV3+02y+e/hxvrMei0h2h6thywfJbfpr4VJIr8srkst2cKows7/5B0A3KPIHuLzSF5qyH4DPmMIvVPkoCdk7jrrP45OmxRqe4eEKHwrIZo6JeK1M2QajMjkS6DVTUtTadHZklr15nE2gH/mt8juhskE5PPfzwz0VUXIzktHYftLSAi8pEhJUi46tdapWCDN0/NjmGUuwbXa88kzqXlUSNun4d+U9W3oaEvi+unIjtDoHFdHjA+mCyEJZw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8af5151d-7761-4586-1887-08db3ddaf11b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2023 17:57:56.0188
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1nxrh4wKRBgCZfKntli7L+KqN7TApcMJwAfoNaOB9f38GNXetYeK7lxgTVJJZk+qkaIFYmcANKTXXIYQL3Bokg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5725
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-15_08,2023-04-14_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 bulkscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304150166
X-Proofpoint-GUID: g8Z-XTwBNfUEAiS8ahDL8MvcWo5uaLVN
X-Proofpoint-ORIG-GUID: g8Z-XTwBNfUEAiS8ahDL8MvcWo5uaLVN
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 14, 2023, at 11:39 PM, Chuck Lever <cel@kernel.org> wrote:
>=20
> On Fri, Apr 14, 2023 at 07:15:42PM -0700, Jakub Kicinski wrote:
>> On Fri, 14 Apr 2023 22:06:59 -0400 Chuck Lever wrote:
>>> On Fri, Apr 14, 2023 at 06:31:13PM -0700, Jakub Kicinski wrote:
>>>> We're getting:
>>>>=20
>>>> net/handshake/.kunitconfig: warning: ignored by one of the .gitignore =
files
>>>>=20
>>>> during allmodconfig build, any idea where that's coming from? =20
>>>=20
>>> As far as I know, all of the .kunitconfig files in the kernel tree
>>> are marked "ignored". I'm not sure why, nor if it's a significant
>>> problem.
>>=20
>> To be clear - no idea what the problem is but I don't think all
>> of them are:
>>=20
>> $ echo a > fs/fat/.kunitconfig
>> $ echo b > mm/kfence/.kunitconfig
>> $ echo c > net/sunrpc/.kunitconfig
>> $ git status
>> Changes not staged for commit:
>>  (use "git add <file>..." to update what will be committed)
>>  (use "git restore <file>..." to discard changes in working directory)
>> modified:   fs/fat/.kunitconfig
>> modified:   mm/kfence/.kunitconfig
>> modified:   net/sunrpc/.kunitconfig
>=20
> The "ignored" list I got from the bot yesterday indeed included
> net/sunrpc/.kunitconfig as well as net/handshake/.kunitconfig, but
> git doesn't actually seem to ignore changes to these files, as you
> demonstrate here.
>=20
> I don't see a specific pattern in the kernel's .gitconfig that
> would exclude .kunitconfig files from change tracking.
>=20
> I can see where this warning might introduce false negative build
> results, but so far I haven't heard that particular complaint about
> net/sunrpc/.kunitconfig.
>=20
> Again, I wasn't sure if this was a significant problem or simply
> noise, so I haven't chased it. If someone on-list has insight,
> please speak up. I can try to have a look at it tomorrow.

OK, shedding a little light on this:

[cel@oracle-102 linux]$ git check-ignore -v .kunitconfig
.gitignore:13:.* .kunitconfig
[cel@oracle-102 linux]$ git status --ignored
On branch upcall-v10
Ignored files:
  (use "git add -f <file>..." to include in what will be committed)
.kunit/
cscope.in.out
cscope.out
cscope.po.out
tools/net/ynl/lib/__pycache__/
tools/testing/kunit/__pycache__/

nothing to commit, working tree clean
[cel@oracle-102 linux]$=20

So,

a) There's a very broad wildcard pattern in .gitignore that
matches all dotfiles, and

b) git actually does not ignore .kunitconfig files.


I'm wondering if this might help the overall situation:

diff --git a/.gitignore b/.gitignore
index 70ec6037fa7a..51117ba29c88 100644
--- a/.gitignore
+++ b/.gitignore
@@ -105,6 +105,7 @@ modules.order
 !.gitignore
 !.mailmap
 !.rustfmt.toml
+!.kunitconfig
   #
 # Generated include files


--
Chuck Lever


