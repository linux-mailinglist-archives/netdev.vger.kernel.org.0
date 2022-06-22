Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73432555527
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 21:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358974AbiFVT7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 15:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234116AbiFVT7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 15:59:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FB234657;
        Wed, 22 Jun 2022 12:59:38 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25MISoGR021387;
        Wed, 22 Jun 2022 19:59:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=FyCGWcY9BC23TdMpI2NW+NYeJQJ3N1OC+MPACobM99A=;
 b=mvIAFBc/Rl1CEd8danD45YFMlHrrZRpIVbaR1lH6xGOKnQEEAH9i2ruCPmHtD7kHk0JT
 54WTtsv2FD0kpyFS4nYiYx7y2z9xnNaCKYaLY1RSXYiN619NXodGFhD/xF1qpSfPDHGq
 2IiDSiQqnw5LX8GBEZR5DhS9gCuCwf2+tQ5PZhJH/Da+cSSeUVlD8sqnWyxMUZPfMyoz
 1euWcvKenWGdrgeYKHBKTfbubWDxCtwGkBtusve72/Elog8huIUzsX9PzkcjkSFpKPUZ
 pPFlfmfSU1a43vX1dqu4ODKZh2Bb43ewFwQicQ5XKkfXwKkhDCYx2rSIQzKke6S02G1T Zg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs6at1ffg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jun 2022 19:59:31 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25MJudlF011140;
        Wed, 22 Jun 2022 19:59:31 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gtd9vnbyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jun 2022 19:59:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OOIdMSZUKEBLme/Ihwi7rrkuud2WKZMOJ+wtv9qRBkCfmbJvdfqSHdvylcoAuekG0TNhInOSbs8vDTWE7Okl8gd/Axw5AamqVa5kHqKRblOzDXG4LNuNcD/BUH+bDsON16h+kGdC5f7Dg3mNIIyxXKz7TxLfPpREochPTg3u34LvE5+n+ZRLbLqz2XEw5e5lSleepgoKuYVQcsLMREXInxr50DW1h6PNKrIa8E27PV5uY/VdCKHBxGV8DeDjWatXMP1TwGyDhmhIxLeseEfb1J8y+zeycpXRHemJDmYXYaNYnbEe8amkI6dRhLXR2t4hvSxjOwoOK4dl5JB3sEFFZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FyCGWcY9BC23TdMpI2NW+NYeJQJ3N1OC+MPACobM99A=;
 b=DZjs1EIfF5xmNhB88DMgrWlouzg/bmfipVsSyUYuOT++8mz4r/dTnOIznIloCahv3Z6WJE8JSeyxZ3786gL//K/Gz1HoTQhGn9EZoUQxdbaUz6hlpdugKuT0VpnUxNNbSXga2/8C2JSvrSqV19ZG3A9HodmYKlGy0RMHobPwaLmSF82rEn4puXJMEd5bAu+ZaHKonaChxgwUBqBCwq98XhHdt7TIKDrtgfEaFXIySqqoAqqiPlGOxudYMZbzSoZodzTUxSDkbvEAVQf0PFJhxTVdNrBfNuDaHwKdd9h03r2PeKwqTgFcQIh88SJT5MjFRTXtr4OywLoV6asxb93Vug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FyCGWcY9BC23TdMpI2NW+NYeJQJ3N1OC+MPACobM99A=;
 b=QZh19RIjgUk70+nYL9pMMV3rmQ0+8EeXXTSeGE2C3doS/i3Swi/FfMF2dh1OHTtUm33rd2TDGW59RIp80RyOaIK/du2vKaYgtDrur9LRnBgD4wMJvDHIIRhSfPT0vblT5fxaQ+sGSBEFOaQaQ7cOYJSVT+l10f/jWh2c6WdxTz0=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DM4PR10MB6062.namprd10.prod.outlook.com (2603:10b6:8:b7::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.22; Wed, 22 Jun 2022 19:59:29 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::a022:c9:1cd6:8ef0]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::a022:c9:1cd6:8ef0%4]) with mapi id 15.20.5353.022; Wed, 22 Jun 2022
 19:59:27 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Wang Yugui <wangyugui@e16-tech.com>
CC:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "tgraf@suug.ch" <tgraf@suug.ch>, Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH RFC 00/30] Overhaul NFSD filecache
Thread-Topic: [PATCH RFC 00/30] Overhaul NFSD filecache
Thread-Index: AQHYhkIqDsKitGhdzEmSu19Gpo96sa1bwYeAgAAHywCAAA9RgA==
Date:   Wed, 22 Jun 2022 19:59:27 +0000
Message-ID: <F57A580E-07D0-499A-9693-18D82D73ED3A@oracle.com>
References: <165590626293.75778.9843437418112335153.stgit@manet.1015granger.net>
 <20220623023645.F914.409509F4@e16-tech.com>
 <FE520DC8-3C8F-4974-9F3B-84DE822CB899@oracle.com>
In-Reply-To: <FE520DC8-3C8F-4974-9F3B-84DE822CB899@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ed1cd1d-edeb-491f-6c9c-08da5489b68b
x-ms-traffictypediagnostic: DM4PR10MB6062:EE_
x-microsoft-antispam-prvs: <DM4PR10MB6062D6334736A32C104D87C593B29@DM4PR10MB6062.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qewSgS+tNVY7PMKsr5aEDgRYJC1WxR1+rpPXvkOHYLIOYyxJ23Sv+RljQZXu8MT7KDQwd9VYPnhYX2gLkxnnBBtgtA8H83BUO2RG7zl072U/B6qnpLxui6B7wsXYVZCh5nub0dNJ9xbJtBpblR2DNoYV49nS8Ggi4Te0PKUWGSggxXhx/s7WAC7Q4+JB1lDiFTCkZd6nLbGRRe3TJb8XwfLUDp5vU50TaulxodACP4+VhrVMA2ojU3hTCRkPWDsoRqsdhcI6/HtM0ZRoSYUwpproD4hHvZfxUmpt9eog9c5FCw86c5wNHMlBZ1dj+S1cUivk/U2dSWZ8Gm+VyTF3WWTfsicXF/jT6UcMKlA6ch9EXpdF7uZKydihbJjrldgQs50XdEn5jMbGtWiUqlmW0TP1wO1Ian4TauIobBEIQRl6cSob/R1W6CEI3BaPFvybOkW39GuXpf4pnXAfSWNsnhWHDpYWKuJG7OsM5YonDL/9H8aekChI2X35FBvW7uWV4byDqWgoxdA5Zu9upVYC61Xbj/5vr00uPK8RFD0hgsFFoC6FMZyvLUqUnOht76TfeFgftgIBKwtoai9JRDQyhX8pN842sMBjjqIPGJ00sdN9LB1SuuDlQlwsONrVRUCJsms1PgqQl72e7t+XoOnZHICy+k3TpWhidYAvqsgt5VQQqF2sVgCaj3WLOUVZCYMfuZ3++pGti7kXG4LjXFEjvfXthAOp3r/0TGYXlzFljjWa3Guwv4zWbbsu7B0bZrpYGbdNZFuGENlCyHkMsed8w2ggMXxp2Wkm3zB+eGHadBFn1y1/YzEpxbJs3gs6J4W6CBIlCNwRq4LTjM70INdwDQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(346002)(39860400002)(366004)(396003)(64756008)(8676002)(66476007)(316002)(38100700002)(8936002)(86362001)(54906003)(6486002)(66446008)(2616005)(91956017)(4326008)(966005)(33656002)(66946007)(36756003)(76116006)(66556008)(5660300002)(478600001)(6916009)(41300700001)(6512007)(122000001)(53546011)(186003)(71200400001)(6506007)(26005)(2906002)(83380400001)(38070700005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MNhvuaxraWJbmOWCYuk+3FhnNnQEmW5nPdLVFmV7wxq+2g2r+pnaX/sXu4Jk?=
 =?us-ascii?Q?S2OdEy0ZLHfWPgRIkaF7wlbd67k8RaM6ZzaqNYw/x7lEw/vcz4BzhXtvKpa4?=
 =?us-ascii?Q?esSIxHliB/q3/JM/QPYRi64AYpk/isLtbmPgpkvh0SCtXOy+9lpGYSkyRCPX?=
 =?us-ascii?Q?rO1MR9Gcc5pTiS4LnAuCxrnIaxYAD4xJimx+Yoz2ZuYk0nBpf/M7wX6jXWsa?=
 =?us-ascii?Q?aRLAUeY84rclZthZAyUNK74FLbaMcyJCwUVOprO1dzMS8Y5BxHfm++q59aBY?=
 =?us-ascii?Q?vwN580ar/4lGvEG8MobdnubLj5O5sRj+8vf/pgBpQ5Jy5qJSOPoW4RCR+cqc?=
 =?us-ascii?Q?7n0f2Aok7ShoHREeDKjPj7v+aKrfVcJ8Vc+Y2jrdGEWQWwvW88cChA36bdn+?=
 =?us-ascii?Q?kaBS/crhn6UOXqiq1itPrtCyFrsueOxWL16weJ+Qss1bzHSFwewo6kh/eAZc?=
 =?us-ascii?Q?J+VZpM5rrfVlo9tiodURCnJEbXvB0BS6zBau90JbU2y1pVj+aL4vuGVq3n0B?=
 =?us-ascii?Q?mCiGlP5hYs7fgHpgyIspBPPEyxfxrsD7qA5pHojoFavPoSySlcwgU6Hrygoo?=
 =?us-ascii?Q?wUI1wv1E6FtOx8j/4B7Kwu7Dt5MH9xOPUUSWWPiRlZsU7AugGI1YzCkpf9mO?=
 =?us-ascii?Q?cfLAs4msvJLWNDXHf+Fad80wOJr9SVAANGKIOwk3GEYFq39Vr1+jsAlrq77J?=
 =?us-ascii?Q?pQ3JYiKV1fU0MqAfmgmVO1c0i3eHoWARmwcP5JicYuTKgREQXlYpwmMpRPtP?=
 =?us-ascii?Q?qwQaQffiMv3k/Z8Dpl10JfLd3PE5v7WAXQOZ1lj9PyCWISNm82a/vPs/553F?=
 =?us-ascii?Q?j9JJ43W+H4JIaQ+6PlM+8B0BfOIrdRl7+SiVXAY3dNJprCcoCVW0hS1yntsR?=
 =?us-ascii?Q?+0cReH5cdOIyw4UggMGgmPdLbys0Rr7SMichOZ6tvXNzW70kp3EhyKJqTDdN?=
 =?us-ascii?Q?9sloPraWhG0mBorNcTqL37XQtavt24HRBbK6nTM8PrRm9te5RERon5HC6lQR?=
 =?us-ascii?Q?SxVU+fxveWnD2cGsRFGjxU943O+RewLDrfyT5CifLRjmEreL+63EJ08Noqm5?=
 =?us-ascii?Q?Di5vIxKfOmXzaKkXvex/ozb+wj7wamxhUUE0C/ufrKe9wy/9zwWJ/xV9+sIA?=
 =?us-ascii?Q?X03Qe0kc3/so7Dl46RGRTxPhbx/hibc0OtodV20ytQzeQNQQ8iNTPObd1HYw?=
 =?us-ascii?Q?U2azn6R92egHZd24/Ib2bS4pl/u5CKylnrCXhBderFGyPGsMTu6eO+1iAST0?=
 =?us-ascii?Q?SrIvAnqrcsAWUTzpwkfnemEt9Le9KSSIuSqRfsaJ0YmuO1NjPTnk1+ogFt9r?=
 =?us-ascii?Q?5vTVKk43a8vvMNk+zT9345yOTKN35jQKcl0pn/3Nn0tvEgoMZTDJ7DAF9SjF?=
 =?us-ascii?Q?hALV22se7/f06HkJswvD3m61we+sEfGt7hv6Igev+murWivrQeL9Nq5f7Hbi?=
 =?us-ascii?Q?0vXVcKQdZedBW9qxPszRoMx2DBLqwu01j5VFYJwHdMOeW3cnFNVUe5HaYExI?=
 =?us-ascii?Q?GYIGud5YfSdfOyJxi1arPScH9sfx8Ve5m9flHINZIz0XtUTHWZtDUkhh5w0N?=
 =?us-ascii?Q?1Ze6T9+ofIlDLe8dNNUP5Wre8kvEnfaU2FAlhf3qH0mYKtapXZlwJ/NhvFZy?=
 =?us-ascii?Q?Z+9o1Nd5OzW/J4vxLDWCHwYvIp2AjmAsVCMzMafcceP6WvjNr6nQeFEUS8z8?=
 =?us-ascii?Q?Ya4RWgrQTzrSASraFfXb7AC+8KsYBsNY7Isf8pYiEGdzd4Iyjx81XpkGJ1S5?=
 =?us-ascii?Q?yLY5T0L9RF3P4CWqZeGFzCPa/eFDhsA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E2430D540D78A642B98B04E55D83C795@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ed1cd1d-edeb-491f-6c9c-08da5489b68b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2022 19:59:27.5721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h6mA2rliIILSON/gyY2MF7uApSa2+7UXrDApLZkMHl3hNzituoMHqo6eJ6C4i9Q0qYjOFojGGG2h22nJuV7ijA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6062
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-22_06:2022-06-22,2022-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=668 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206220094
X-Proofpoint-ORIG-GUID: t9dYtvMkCWAZPyDLhx9yJE2pYQVj4dg2
X-Proofpoint-GUID: t9dYtvMkCWAZPyDLhx9yJE2pYQVj4dg2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 22, 2022, at 3:04 PM, Chuck Lever III <chuck.lever@oracle.com> wro=
te:
>=20
>=20
>=20
>> On Jun 22, 2022, at 2:36 PM, Wang Yugui <wangyugui@e16-tech.com> wrote:
>>=20
>> Hi,
>>=20
>> fstests generic/531 triggered a panic on kernel 5.19.0-rc3 with this
>> patchset.
>=20
> As I mention in the cover letter, I haven't tried running generic/531
> yet -- no claim at all that this is finished work and that #386 has
> been fixed at this point. I'm merely interested in comments on the
> general approach.
>=20
>=20
>> [ 405.478056] BUG: kernel NULL pointer dereference, address: 00000000000=
00049
>=20
> The "RIP: " tells the location of the crash. Notice that the call
> trace here does not include that information. From your attachment:
>=20
> [ 405.518022] RIP: 0010:nfsd_do_file_acquire+0x4e1/0xb80 [nfsd]
>=20
> To match that to a line of source code:
>=20
> [cel@manet ~]$ cd src/linux/linux/
> [cel@manet linux]$ scripts/faddr2line ../obj/manet/fs/nfsd/filecache.o nf=
sd_do_file_acquire+0x4e1
> nfsd_do_file_acquire+0x4e1/0xfc0:
> rht_bucket_insert at /home/cel/src/linux/linux/include/linux/rhashtable.h=
:303
> (inlined by) __rhashtable_insert_fast at /home/cel/src/linux/linux/includ=
e/linux/rhashtable.h:718
> (inlined by) rhashtable_lookup_get_insert_key at /home/cel/src/linux/linu=
x/include/linux/rhashtable.h:982
> (inlined by) nfsd_file_insert at /home/cel/src/linux/linux/fs/nfsd/fileca=
che.c:1031
> (inlined by) nfsd_do_file_acquire at /home/cel/src/linux/linux/fs/nfsd/fi=
lecache.c:1089
> [cel@manet linux]$
>=20
> This is an example, I'm sure my compiled objects don't match yours.
>=20
> And, now that I've added observability, you should be able to do:
>=20
> # watch cat /proc/fs/nfsd/filecache
>=20
> to see how many items are in the hash and LRU list while the test
> is running.
>=20
>=20
>> [ 405.608016] Call Trace:
>> [ 405.608016] <TASK>
>> [ 405.613020] nfs4_get_vfs_file+0x325/0x410 [nfsd]
>> [ 405.618018] nfsd4_process_open2+0x4ba/0x16d0 [nfsd]
>> [ 405.623016] ? inode_get_bytes+0x38/0x40
>> [ 405.623016] ? nfsd_permission+0x97/0xf0 [nfsd]
>> [ 405.628022] ? fh_verify+0x1cc/0x6f0 [nfsd]
>> [ 405.633025] nfsd4_open+0x640/0xb30 [nfsd]
>> [ 405.638025] nfsd4_proc_compound+0x3bd/0x710 [nfsd]
>> [ 405.643017] nfsd_dispatch+0x143/0x270 [nfsd]
>> [ 405.648019] svc_process_common+0x3bf/0x5b0 [sunrpc]

I was able to trigger something that looks very much like this crash.
If you remove this line from fs/nfsd/filecache.c:

	.max_size		=3D 131072, /* buckets */

things get a lot more stable for generic/531.

I'm looking into the issue now.


>> more detail in attachment file(531.dmesg)
>>=20
>> local.config of fstests:
>> 	export NFS_MOUNT_OPTIONS=3D"-o rw,relatime,vers=3D4.2,nconnect=3D8"
>> changes of generic/531
>> 	max_allowable_files=3D$(( 1 * 1024 * 1024 / $nr_cpus / 2 ))
>=20
> Changed from:
>=20
> 	max_allowable_files=3D$(( $(cat /proc/sys/fs/file-max) / $nr_cpus / 2 ))
>=20
> For my own information, what's $nr_cpus in your test?
>=20
> Aside from the max_allowable_files setting, can you tell how the
> test determines when it should stop creating files? Is it looking
> for a particular error code from open(2), for instance?
>=20
> On my client:
>=20
> [cel@morisot generic]$ cat /proc/sys/fs/file-max
> 9223372036854775807
> [cel@morisot generic]$
>=20
> I wonder if it's realistic to expect an NFSv4 server to support
> that many open files. Is 9 quintillion files really something
> I'm going to have to engineer for, or is this just a crazy
> test?
>=20
>=20
>> Best Regards
>> Wang Yugui (wangyugui@e16-tech.com)
>> 2022/06/23
>>=20
>>> This series overhauls the NFSD filecache, a cache of server-side
>>> "struct file" objects recently used by NFS clients. The purposes of
>>> this overhaul are an immediate improvement in cache scalability in
>>> the number of open files, and preparation for further improvements.
>>>=20
>>> There are three categories of patches in this series:
>>>=20
>>> 1. Add observability of cache operation so we can see what we're
>>> doing as changes are made to the code.
>>>=20
>>> 2. Improve the scalability of filecache garbage collection,
>>> addressing several bugs along the way.
>>>=20
>>> 3. Improve the scalability of the filecache hash table by converting
>>> it to use rhashtable.
>>>=20
>>> The series as it stands survives typical test workloads. Running
>>> stress-tests like generic/531 is the next step.
>>>=20
>>> These patches are also available in the linux-nfs-bugzilla-386
>>> branch of
>>>=20
>>> https://git.kernel.org/pub/scm/linux/kernel/git/cel/linux.git=20
>>>=20
>>> ---
>>>=20
>>> Chuck Lever (30):
>>> NFSD: Report filecache LRU size
>>> NFSD: Report count of calls to nfsd_file_acquire()
>>> NFSD: Report count of freed filecache items
>>> NFSD: Report average age of filecache items
>>> NFSD: Add nfsd_file_lru_dispose_list() helper
>>> NFSD: Refactor nfsd_file_gc()
>>> NFSD: Refactor nfsd_file_lru_scan()
>>> NFSD: Report the number of items evicted by the LRU walk
>>> NFSD: Record number of flush calls
>>> NFSD: Report filecache item construction failures
>>> NFSD: Zero counters when the filecache is re-initialized
>>> NFSD: Hook up the filecache stat file
>>> NFSD: WARN when freeing an item still linked via nf_lru
>>> NFSD: Trace filecache LRU activity
>>> NFSD: Leave open files out of the filecache LRU
>>> NFSD: Fix the filecache LRU shrinker
>>> NFSD: Never call nfsd_file_gc() in foreground paths
>>> NFSD: No longer record nf_hashval in the trace log
>>> NFSD: Remove lockdep assertion from unhash_and_release_locked()
>>> NFSD: nfsd_file_unhash can compute hashval from nf->nf_inode
>>> NFSD: Refactor __nfsd_file_close_inode()
>>> NFSD: nfsd_file_hash_remove can compute hashval
>>> NFSD: Remove nfsd_file::nf_hashval
>>> NFSD: Remove stale comment from nfsd_file_acquire()
>>> NFSD: Clean up "open file" case in nfsd_file_acquire()
>>> NFSD: Document nfsd_file_cache_purge() API contract
>>> NFSD: Replace the "init once" mechanism
>>> NFSD: Set up an rhashtable for the filecache
>>> NFSD: Convert the filecache to use rhashtable
>>> NFSD: Clean up unusued code after rhashtable conversion
>>>=20
>>>=20
>>> fs/nfsd/filecache.c | 677 +++++++++++++++++++++++++++-----------------
>>> fs/nfsd/filecache.h | 6 +-
>>> fs/nfsd/nfsctl.c | 10 +
>>> fs/nfsd/trace.h | 117 ++++++--
>>> 4 files changed, 522 insertions(+), 288 deletions(-)
>>>=20
>>> --
>>> Chuck Lever
>>=20
>> <531.dmesg>
>=20
> --
> Chuck Lever

--
Chuck Lever



