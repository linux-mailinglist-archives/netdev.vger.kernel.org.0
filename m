Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF546C3388
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 14:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjCUN7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 09:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbjCUN7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 09:59:33 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79541170E
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 06:59:12 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32LBiFsr012418;
        Tue, 21 Mar 2023 13:58:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=tbfqF8gbjpT5v4/a7QHkpmyDXFJpk1WCcyC4PJhYSJo=;
 b=iqWv+TxhxBLvK18NBsILXUVTQob+zlRi7iHBUzO/L4q0JHQbrCeYCTtazUoLPCIPPaUD
 A5/8y/MekhBWBoQc7PbHDuRgbY05hOeI7KZ/w4shNIS9mmApkrKgf/LE97dwS7rGQczW
 Dph4H+9ju4ZDoVFtjsEBCK+HtCh4Hg7D9bigKQOyXZTWk3/LAXNGanJ64PWhaGN4qAgG
 AHS5QkODbFrp/s/m4Si5eM2wVtZ7Xnf6JCHdrz1N0TqLabCXwX+3V31g21UaRepbjPlE
 ZLq1omOGStM6o/QRXavTR0+NalNScn3RuZaHSyU6+lQnKmoBv8eqwqw9yVbfzHKWXyJJ Bw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd4wt6a6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 13:58:57 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32LDWQoD038653;
        Tue, 21 Mar 2023 13:58:56 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pd3rd8sa6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 13:58:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WBfRUbNDT4oJcXozCM53JQwz73ifmEZZMrvlo6/cdbNU61CQ1DkMChyNBbdAHAwnj5IbQJvaxnfPHqcm5KuwCAWsul1OqlSyzpxcvwwxP7iR97Es0v7vmz2EVDti9UWKuOzeTiXftatIczWXbvmhI2N2y2OBd1ScY9pbXlCoroEw1bPq5Q/LVQSvez/dCV9LzGCZ1QyS8Y+RA/waRGVjvM8+4Ks7XuFPcXqTEN/wNFdkLGh75QiO8dOrKOpbjgsfOzwroEHAbibDkltv5STr+PgtvnjWAQI8B60c4qhLAF392+7zzNU9+uv24aMJ+0SvA4L1gnXjyH0Oy7cO9I2N+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tbfqF8gbjpT5v4/a7QHkpmyDXFJpk1WCcyC4PJhYSJo=;
 b=H0zVlHUuAFkEgtHPgp9JMCFpQlrwjRykw6Iie6Ysou18zduemVJ8FuO7aL4H4lDDU0bW98E6uW8DhitqULcYfgKCcpTgeqj+x9plh0uSdYmlaVli9Sn/4ArKCOazJEoH82MnnwuCS+bVgByA0158AoQBANTG9dsttGgdubzyUsmbVEcDaqYUU06xeIM/1wlYSAa9PeiSrob01MBArwJfhTax4nbtoeC6yA+X1eM0Jm8t/rfddv8XVyEorIFnfOQKTBH0thtg5GskE7rPKd4STjJU9NugSHK+iiePfuHtTYQxhIAhuCdaOUQdkwLlLHvj9+L1NHVlcdnEBVKkFVaHTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tbfqF8gbjpT5v4/a7QHkpmyDXFJpk1WCcyC4PJhYSJo=;
 b=ysFS+5nkiKq9UbL37bQvQr/m4yjwq1/mR9OPxhS1r1sP6UII8KZrk6avnxqF8M+y9apjV+hZleQIXa10YWIoiK8G4LtVwNaqQoyVEf9ZTQvO7DRgb3F8je5pVVgNR2/Yzw0BtF3ujddtmOEauw3IFi0wG6FFIk9c0KkhohvjIj4=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by BN0PR10MB5270.namprd10.prod.outlook.com (2603:10b6:408:120::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 13:58:54 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%8]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 13:58:54 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Paolo Abeni <pabeni@redhat.com>
CC:     Chuck Lever <cel@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>,
        John Haxby <john.haxby@oracle.com>
Subject: Re: [PATCH v7 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Topic: [PATCH v7 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Index: AQHZWbVGJzLbQ29BsEW987typvYRiq8FHPAAgAAqL4A=
Date:   Tue, 21 Mar 2023 13:58:54 +0000
Message-ID: <674AEE9C-BDB7-440E-902E-73918D6E2370@oracle.com>
References: <167915594811.91792.15722842400657376706.stgit@manet.1015granger.net>
 <167915629953.91792.17220269709156129944.stgit@manet.1015granger.net>
 <3dc6b9290984bc07ae5ac9c5a9fba01742b64f84.camel@redhat.com>
In-Reply-To: <3dc6b9290984bc07ae5ac9c5a9fba01742b64f84.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|BN0PR10MB5270:EE_
x-ms-office365-filtering-correlation-id: f77ee0a4-a712-4af8-9e8c-08db2a14688d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jZLoQZwwANOeloFCrMnJPfUyRfg0Sqlmu+AWESpEnhf/YAtxHwNhMCqbDFWFnqlUNF110+2fvmlsRDO4Tzu2ZedzZGoutsvPPFjspVnPBUA5ZWa717ZPVlAEAq/iW9VYTq+wZVzhaTDYEzrnq0jr64TDCjm3rmHCwdUbPFlNKRvhWMQ6d6kbYFkKM3BqOEX99HCowHs8StnpBR8iA+EE/QnjVnWMsmpU/X6pSizMhqtp/l92+8vrC1zfewBBSqcPU09SeJ4t1ZGaYWctHCiQIv3EWKg7gvXCQ+0z44gqOi4XNVy7BBEy0v6Izn933eOhOAVb5TI074uEwcJWDE6M/KoVQXtwk+fI9uvNT62lmCclrg6rLxKwX68vtUFAsflOMDvi18TuckY7ZEkMYTPmqFSC6/DmOn9izvd27SpPLhtN2N4R9OUahBxgkQT4pW7T8PtwaVv5ucJKvVfGPDDBgnuzJV5WTJcpyalvetTGD+vm9vhCv5ehk5cpZ8WclgBD35McpOJd/fji01tOjKOC6Vp6DoqWTQ2En0vEHByMJrfoo8Ch4TtsZdujBLvmcvO2aFrkamRIhSs295aNBq5PmaUFr6aaoV6csxl40xcV1Zf0S/mujb68cq5WMLNy/Z/BWY7B058f5S7NByrc41MtWTsHav8KIFjiCXtrRXr6DZTlu6QCCCMdZL1bLae/je8wOlJ5lItGaFIKqN7zzDAHOzDd68DZ5Pcgzd2uRn0n0vZAKtTpNQIIp9SQdunU57Gg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(39860400002)(136003)(376002)(451199018)(2616005)(83380400001)(86362001)(38070700005)(38100700002)(91956017)(36756003)(66446008)(8936002)(64756008)(66476007)(6916009)(4326008)(66556008)(8676002)(66946007)(2906002)(41300700001)(76116006)(122000001)(33656002)(478600001)(26005)(5660300002)(6506007)(6486002)(186003)(53546011)(6512007)(54906003)(71200400001)(107886003)(316002)(66899018)(21314003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0KYQ+SbcCtjEnVyE+yP1O7CreQDPMpLvk5bvHb5cYQY9G7c/tNW6bF3fVBCE?=
 =?us-ascii?Q?HTB3b7CIXzY1UpCs3F7O01wkkQIwIw1OqzIPHXUi2tawq81/7KSXw7dlENyD?=
 =?us-ascii?Q?IYv34inPWHxFru6RLQRASDNo9Fqsbmw9LBLc0x9ig+lgeTsnYZVInWtgHvPV?=
 =?us-ascii?Q?yq6DXVKNJBRZ+3kqvA2JbT0GFyhcQJbfHmxSwclE4KL58PAF966cLWITGf4e?=
 =?us-ascii?Q?q9Q7dPJDRDwMf+UOLg1vlnOZ/x9g4FuLHAKdcFsYpnybgPWJK7Tw1ZG6ffJy?=
 =?us-ascii?Q?rqSBIb5OTa8/0+kh3FmGvM/m+//8VqlM7GcAyEaaeROaWvMWOb7Zk87mtPeX?=
 =?us-ascii?Q?7ntXyU8sSG2X1F+hmdm5//GzwCBNHdwfxhojwlfJvVvVv34xvLqngf2PgjiL?=
 =?us-ascii?Q?4upx+MoltHOfy3hZ4dOQZJbcXs6szXWCL4b7vi+Kgn17Gv6brkpc9asgyc6V?=
 =?us-ascii?Q?xLG7mHo77ZATLiW/S14FpnVA4bYLfjypOJHRyY0Zd+DO5GPwq3w2dsyWCTaa?=
 =?us-ascii?Q?e4I0Dkrsn8tu3wXFQBNTrV19kDH5rle9RvIZGfK/lraMUgq4pF8u3DhO/b7o?=
 =?us-ascii?Q?HlJisSkRYRz8LK1LGRsjbHYXirGUd/oJ8Y+kxBCm91fx7eocA16RTiuiwS0M?=
 =?us-ascii?Q?6pVzeSVh5c9wvtVnG7LLs2OMYhnOJRX7PzBymr7490J3DMgBkcus+SOGi6ra?=
 =?us-ascii?Q?ONrCaeecUM2uP7JatSq85FrgZOQGoWoYYIwUj9Hb46lxuQzT0LzmtaO0vxkg?=
 =?us-ascii?Q?AreTWRvronzQCl9/tuxfhattyssUK5zoW6DC+NDzTHXgOqviD+aWgEBMC7AA?=
 =?us-ascii?Q?trjNiqki/GKcfMjFGR/tRRAMwwqJjLN4jkPfA58KEXeNohJp8+TIgbIqYMGc?=
 =?us-ascii?Q?WB1kXBTV6aRAgHEohf+FBk3uir+OLakOHhsgyA5j66OoxI/5++T4oLVCYilC?=
 =?us-ascii?Q?hi0KfBtORGTP1//QQcHAGhAS9nKjh2Tw6vTk132a7/aQ//hi6mxoqQRzZj0y?=
 =?us-ascii?Q?JS5STrNqMFD73hjz2K69EwuycK9ZyniBbeqJIfOK5vRjYWIqd74bZiuAiLkD?=
 =?us-ascii?Q?Xqs12W36PMtslo2TzeaBN2dMW8P292hb2QB2VcqLhHeEY4l4NlcTPeAlXh/K?=
 =?us-ascii?Q?AvBQ9Ta5vVb0KMvDz3MSn5Jtyaoaw3+5DR79ud89JFlW5FyYMVpwInLtpwMr?=
 =?us-ascii?Q?DvMV5X+h2fpHwkmgQatIMXNihj/fPKg006ciSXUnyU0em4hFY1pe4nsEYFbS?=
 =?us-ascii?Q?10q0y8iqRkKxUNVG/lq4ue7rSb+Bw4lWbmw5YBgLR++Kdn4nJ5GKRDaSiWy9?=
 =?us-ascii?Q?wUpship9cDLQsDJWo1RE+wdHq+1zaR6IA/m1oFNVac8Hzd2gr9q/GHl06wHp?=
 =?us-ascii?Q?e+E4i18aX3FCZ3IuVw/8MFI6I9vQyW/9m+ZiDD/5c/o6cIjqCkrsb+A2E18b?=
 =?us-ascii?Q?WhBRmU67+Dhwys6TytifGTPtk1lxhZpR+1JqLi2YMe5uoDAFX8DaDkAM22SV?=
 =?us-ascii?Q?/GiRr15kaOnInOP7kW2WcLSSWuqcm8TGZN2hHb8P/cVHin+PKjm7ynO92/2y?=
 =?us-ascii?Q?uuVMwqknqEwRqSuDhilrWQl1sguTfJHA1rIz95SJ+MbYG627X6I7nqtCn3X0?=
 =?us-ascii?Q?pA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A2336C22631AC246921119B663453AD6@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Bi08BL0TfNvijCsu0eczpeqOxyLhDB6FeAffCdbXYZfHB2+EJVaIOmTBcUsxQup4f5o6/tBYEP92IoTAjlBOmiqpELAZiMh6eAz1/kS645AfvQ7uVCFUoiZxa1LysBwzzwN+ySgaZbogQEvQbXMIzsHXK+QpPdNiJ1nN6jPBhj+56H6Kkw1QVixxrsJM94pq/z2WSNKQeSeTMQPSdeKpvg8DKKrQTw7cAla8OCqmXjdXAenS7dbbniSni0OgfJPssNw+Y6Kw83n/1va8QdSKY9KezTlIzzQuegyzywVC8b60RvFF1xSbu/x+BofmuvHoukDPdagwvKLN19i2scChtwIrRUGMfmpZ1WyICNJN5ACz6q+OyRzuxat6nVJ/cGShEnCuDlZnRR4bbGibyB9UzBj1l0sRtW/rqXYmdgZpX2NVQ7Y6IA3fG7ur1OCVj+39Hx3ysk4NOYpw0t1s9dCWbnxiIdNdUHWMPBCJXRe7jPMWyqJLZONilBoT+3k1iyhmuT/LB6OjJhPoisMo/8hqk5UVKgYPFMyh5ZuLA1wZsV4qxJ4J9p3j6CDQhVNOD1GJmiAqWWACW0Ng913XNdeUoikYYLTo/0FL77I+qfS+PWDZIemT8BfFdviAOkVfy50n114G5YG8a0eA6TlwbOAc460YHmI2/31+RzfnL/0F3/lA/P6pHck/i5j2uMWkL4016d0PlVWWa0B+LNVVeDu/BzsbzJSh6bEOrPA810dd3rwWbjcTy0XQwE3+XOohsnH1CT7kbetwAxqJOqEZDrp9s9Ei/w24ueDUpvH7eOb6zsVGCW68hP00FDbX1h6ngvDCyvKaEG2VnzfK7zuHne/rJpw3DWeVSviRoS+3uUgkMxGoGvY2mZNIBvB7FHLLuqwlxlv5q1kOzJleuyy0QBIwwQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f77ee0a4-a712-4af8-9e8c-08db2a14688d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2023 13:58:54.4568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dNIgAdsBf04aRYl+uA3H9uiLlF8529cAj+vLeu720N5q7c9k/wvWO+iRBMSmWo2tryFJkG4hPj6HUhMqe+ZgJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5270
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-21_10,2023-03-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303210109
X-Proofpoint-GUID: yxOV2s3ts9FW3P-NgOPnSI17PJ4VNrG2
X-Proofpoint-ORIG-GUID: yxOV2s3ts9FW3P-NgOPnSI17PJ4VNrG2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 21, 2023, at 7:27 AM, Paolo Abeni <pabeni@redhat.com> wrote:
>=20
> On Sat, 2023-03-18 at 12:18 -0400, Chuck Lever wrote:
>> +/**
>> + * handshake_req_alloc - consumer API to allocate a request
>> + * @sock: open socket on which to perform a handshake
>> + * @proto: security protocol
>> + * @flags: memory allocation flags
>> + *
>> + * Returns an initialized handshake_req or NULL.
>> + */
>> +struct handshake_req *handshake_req_alloc(struct socket *sock,
>> +					  const struct handshake_proto *proto,
>> +					  gfp_t flags)
>> +{
>> +	struct sock *sk =3D sock->sk;
>> +	struct net *net =3D sock_net(sk);
>> +	struct handshake_net *hn =3D handshake_pernet(net);
>> +	struct handshake_req *req;
>> +
>> +	if (!hn)
>> +		return NULL;
>> +
>> +	req =3D kzalloc(struct_size(req, hr_priv, proto->hp_privsize), flags);
>> +	if (!req)
>> +		return NULL;
>> +
>> +	sock_hold(sk);
>=20
> The hr_sk reference counting is unclear to me. It looks like
> handshake_req retain a reference to such socket, but
> handshake_req_destroy()/handshake_sk_destruct() do not release it.

If we rely on sk_destruct to release the final reference count,
it will never get invoked.


> Perhaps is better moving such sock_hold() into handshake_req_submit(),
> once that the request is successful?

I will do that.

Personally, I find it more clear to bump a reference count when
saving a copy of the object's pointer, as is done in _alloc. But if
others find it easier the other way, I have no problem changing
it to suit community preferences.


>> +
>> +	INIT_LIST_HEAD(&req->hr_list);
>> +	req->hr_sk =3D sk;
>> +	req->hr_proto =3D proto;
>> +	return req;
>> +}
>> +EXPORT_SYMBOL(handshake_req_alloc);
>> +
>> +/**
>> + * handshake_req_private - consumer API to return per-handshake private=
 data
>> + * @req: handshake arguments
>> + *
>> + */
>> +void *handshake_req_private(struct handshake_req *req)
>> +{
>> +	return (void *)&req->hr_priv;
>> +}
>> +EXPORT_SYMBOL(handshake_req_private);
>> +
>> +static bool __add_pending_locked(struct handshake_net *hn,
>> +				 struct handshake_req *req)
>> +{
>> +	if (!list_empty(&req->hr_list))
>> +		return false;
>> +	hn->hn_pending++;
>> +	list_add_tail(&req->hr_list, &hn->hn_requests);
>> +	return true;
>> +}
>> +
>> +void __remove_pending_locked(struct handshake_net *hn,
>> +			     struct handshake_req *req)
>> +{
>> +	hn->hn_pending--;
>> +	list_del_init(&req->hr_list);
>> +}
>> +
>> +/*
>> + * Returns %true if the request was found on @net's pending list,
>> + * otherwise %false.
>> + *
>> + * If @req was on a pending list, it has not yet been accepted.
>> + */
>> +static bool remove_pending(struct handshake_net *hn, struct handshake_r=
eq *req)
>> +{
>> +	bool ret;
>> +
>> +	ret =3D false;
>=20
> Nit: merge the initialization and the declaration
>=20
>> +
>> +	spin_lock(&hn->hn_lock);
>> +	if (!list_empty(&req->hr_list)) {
>> +		__remove_pending_locked(hn, req);
>> +		ret =3D true;
>> +	}
>> +	spin_unlock(&hn->hn_lock);
>> +
>> +	return ret;
>> +}
>> +
>> +/**
>> + * handshake_req_submit - consumer API to submit a handshake request
>> + * @req: handshake arguments
>> + * @flags: memory allocation flags
>> + *
>> + * Return values:
>> + *   %0: Request queued
>> + *   %-EBUSY: A handshake is already under way for this socket
>> + *   %-ESRCH: No handshake agent is available
>> + *   %-EAGAIN: Too many pending handshake requests
>> + *   %-ENOMEM: Failed to allocate memory
>> + *   %-EMSGSIZE: Failed to construct notification message
>> + *   %-EOPNOTSUPP: Handshake module not initialized
>> + *
>> + * A zero return value from handshake_request() means that
>> + * exactly one subsequent completion callback is guaranteed.
>> + *
>> + * A negative return value from handshake_request() means that
>> + * no completion callback will be done and that @req has been
>> + * destroyed.
>> + */
>> +int handshake_req_submit(struct handshake_req *req, gfp_t flags)
>> +{
>> +	struct sock *sk =3D req->hr_sk;
>> +	struct net *net =3D sock_net(sk);
>> +	struct handshake_net *hn =3D handshake_pernet(net);
>> +	int ret;
>=20
> Nit: reverse xmas tree. In this case you have to split declaration and
> initialization ;)

Interesting. I like reverse-xmas, but I thought that the initialization
of these variables would take precedent. I'll clean this up.


>> +
>> +	if (!hn)
>> +		return -EOPNOTSUPP;
>> +
>> +	ret =3D -EAGAIN;
>> +	if (READ_ONCE(hn->hn_pending) >=3D hn->hn_pending_max)
>> +		goto out_err;
>> +
>> +	req->hr_odestruct =3D sk->sk_destruct;
>> +	sk->sk_destruct =3D handshake_sk_destruct;
>> +	spin_lock(&hn->hn_lock);
>> +	ret =3D -EOPNOTSUPP;
>> +	if (test_bit(HANDSHAKE_F_NET_DRAINING, &hn->hn_flags))
>> +		goto out_unlock;
>> +	ret =3D -EBUSY;
>> +	if (!handshake_req_hash_add(req))
>> +		goto out_unlock;
>> +	if (!__add_pending_locked(hn, req))
>> +		goto out_unlock;
>> +	spin_unlock(&hn->hn_lock);
>> +
>> +	ret =3D handshake_genl_notify(net, req->hr_proto->hp_handler_class,
>> +				    flags);
>> +	if (ret) {
>> +		trace_handshake_notify_err(net, req, sk, ret);
>> +		if (remove_pending(hn, req))
>> +			goto out_err;
>> +	}
>> +
>> +	trace_handshake_submit(net, req, sk);
>> +	return 0;
>> +
>> +out_unlock:
>> +	spin_unlock(&hn->hn_lock);
>> +out_err:
>> +	trace_handshake_submit_err(net, req, sk, ret);
>> +	handshake_req_destroy(req);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL(handshake_req_submit);
>> +
>> +void handshake_complete(struct handshake_req *req, unsigned int status,
>> +			struct genl_info *info)
>> +{
>> +	struct sock *sk =3D req->hr_sk;
>> +	struct net *net =3D sock_net(sk);
>> +
>> +	if (!test_and_set_bit(HANDSHAKE_F_REQ_COMPLETED, &req->hr_flags)) {
>> +		trace_handshake_complete(net, req, sk, status);
>> +		req->hr_proto->hp_done(req, status, info);
>> +		__sock_put(sk);
>=20
> Is unclear to me who acquired the reference released above?!? If that
> is the reference acquire by handshake_req_alloc(), I think it's cleaner
> moving the sock_put() in handshake_req_destroy() or
> handshake_req_destroy()
>=20
>> +	}
>> +}
>> +
>> +/**
>> + * handshake_req_cancel - consumer API to cancel an in-progress handsha=
ke
>> + * @sock: socket on which there is an ongoing handshake
>> + *
>> + * XXX: Perhaps killing the user space agent might also be necessary?
>> + *
>> + * Request cancellation races with request completion. To determine
>> + * who won, callers examine the return value from this function.
>> + *
>> + * Return values:
>> + *   %true - Uncompleted handshake request was canceled or not found
>> + *   %false - Handshake request already completed
>> + */
>> +bool handshake_req_cancel(struct socket *sock)
>> +{
>> +	struct handshake_req *req;
>> +	struct handshake_net *hn;
>> +	struct sock *sk;
>> +	struct net *net;
>> +
>> +	sk =3D sock->sk;
>> +	net =3D sock_net(sk);
>> +	req =3D handshake_req_hash_lookup(sk);
>> +	if (!req) {
>> +		trace_handshake_cancel_none(net, req, sk);
>> +		return true;
>> +	}
>> +
>> +	hn =3D handshake_pernet(net);
>> +	if (hn && remove_pending(hn, req)) {
>> +		/* Request hadn't been accepted */
>> +		trace_handshake_cancel(net, req, sk);
>> +		return true;
>> +	}
>> +	if (test_and_set_bit(HANDSHAKE_F_REQ_COMPLETED, &req->hr_flags)) {
>> +		/* Request already completed */
>> +		trace_handshake_cancel_busy(net, req, sk);
>> +		return false;
>> +	}
>> +
>> +	__sock_put(sk);
>=20
> Same here.

I'll move the sock_hold() to _submit, and cook up a comment or two.


> Side note, I think at this point some tests could surface here? If
> user-space-based self-tests are too cumbersome and/or do not offer
> adequate coverage perhaps you could consider using kunit?

I'm comfortable with Kunit, having just added a bunch of tests
for the kernel's SunRPC GSS Kerberos implementation.

There, however, I had clearly defined test cases to add, thanks
to the RFCs. I guess I'm a little unclear on what specific tests
would be necessary or valuable here. Suggestions and existing
examples are very welcome.


--
Chuck Lever


