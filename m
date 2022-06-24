Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E84559D6F
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 17:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbiFXPaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 11:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiFXPaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 11:30:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8B330573;
        Fri, 24 Jun 2022 08:30:22 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25OF2L07000997;
        Fri, 24 Jun 2022 15:30:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=JV1cvxcsltYFOObHL6qA94q8e7UzDL5D8CmL1rDeTSE=;
 b=dtXUCYPSXx6VqmyAzNHNlR1oDJ/eCZj7Of2a7oHn+0UkJmZ5jVJzZELcsv2kJSxgGkHG
 55gzgaY5hlvZSsuIPYw4+8XMfJbxCeF/p8gVTDVNOU6HHlQscRlG4kYv1Y18Ym2Tfgx2
 A8N9IOrYqiakHyTQ1YkWcav7crGD7sS2Vt7wKGAejtwQgy+iWzQZ32hz4gp5/2eazddk
 2VBMUnV9i3cOFN1Zm8o+t5wGO59rkM1iSgqKm2tvbkTUQpBIKpHoC7kVJyyfV8n0YhWJ
 YblABej8dSvIJWI/L3ogJr4wzWnATxecSnVkJAgBtqavwXsIZR2wm9swEpmB/Z+RA5X/ Lw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs54cwyt7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jun 2022 15:30:16 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25OFBEZA014209;
        Fri, 24 Jun 2022 15:30:15 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gtf5fq253-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jun 2022 15:30:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gkTOIEN2gGWtMrfxC1Jt+LhHWmfvL0kKMDP+yqGW2bjpqs6srhgseHVZr91KPtZGgiQXqN8agC/HPK3wBQWAZAp9mMiNh7FFM91ueuwrQoW6Ca/0Z22WZJKKlSvShnkQATcbC6OEEE/tWW8+jmEkifcudaTBTukjynFjMC35vmEJNq3jxFH5O9cyj9vp0LBl00E9QFrfzyM/CjAb8+7xy2EurrfS5hDJJ3zgVihS4QgoFmxmj5qz21oMftIES/OFzpBTojOOfv38CkFZvfQB1VViiSLr5/yKAPudaCSsKnYty9qa60Vz82TKQbkgU7kxBoE/1i7BnGwmTfOlFVQZrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JV1cvxcsltYFOObHL6qA94q8e7UzDL5D8CmL1rDeTSE=;
 b=cgURoopATPjhXZER7301eT+M+yKHNjc/cAS6yoICKKEErLILNaIXFYpskUlEn9+Z8AEMBD7Uwz+WK8qA8f++w12OiPRw1O23/te08ePFOgjtOjMnsHREwB9QRblG1j7VqPmXTzgTu2nj1x1Kvr5/ZOVpWXFKQXI84/hUzO4Onlnq3FATUU2Cie6nO6ulyOPj35FbdzLwfONqHqUZ1O8pl9hcmJ8Yy9VfAaUy4ypZJ22acUCBJSviqKRaeEWAIjv1aL7N4dH4iwydYmCbv9zlTg/SDGB9DOvo1desUWr4YorR5rgo+KtceDtCdCjSuMxq+eub8+nMwmDc/WhP4nPH4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JV1cvxcsltYFOObHL6qA94q8e7UzDL5D8CmL1rDeTSE=;
 b=rt3tQOk3/yYJAayxwrkV2OLtomNrPjGnZM+3CSJ3MBD8Ty4P4IN4+IH1ehCF0Y+//DitTQzfiJ2N5Aj3oVXDc/mOPjYWDVYPtsd9VORcUn3X2xvJvOhvXJVos6n/tvVcb9vaTbo+By6J+UuvcGGhvnt6UhIUVqrRm9IqJ8GsypU=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CO1PR10MB4755.namprd10.prod.outlook.com (2603:10b6:303:9f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Fri, 24 Jun
 2022 15:30:11 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::9920:1ac4:2d14:e703]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::9920:1ac4:2d14:e703%5]) with mapi id 15.20.5373.017; Fri, 24 Jun 2022
 15:30:11 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Wang Yugui <wangyugui@e16-tech.com>
CC:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "tgraf@suug.ch" <tgraf@suug.ch>, Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH RFC 00/30] Overhaul NFSD filecache
Thread-Topic: [PATCH RFC 00/30] Overhaul NFSD filecache
Thread-Index: AQHYhkIqDsKitGhdzEmSu19Gpo96sa1bwYeAgAAHywCAAA9RgIAA2ruAgACBMACAABKgAIABauOA
Date:   Fri, 24 Jun 2022 15:30:11 +0000
Message-ID: <11579827-F7FE-49FA-9D32-D98C138796B1@oracle.com>
References: <20220623170218.7874.409509F4@e16-tech.com>
 <0292A2FC-7725-47FC-8F08-CCB8500D8E1D@oracle.com>
 <20220624015121.06F3.409509F4@e16-tech.com>
In-Reply-To: <20220624015121.06F3.409509F4@e16-tech.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce2cbfcd-6742-4e02-be00-08da55f66dc7
x-ms-traffictypediagnostic: CO1PR10MB4755:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1VkFqWbKd8uG37IhKOhFEJ50/vDPPDFeBYVbQry9B618maqBM+A9gPp8I4pCbcx9wz3iXykCT7FYh3Qb+2hr97qybUdpJxnDU3Wcoqc4o0zPJ331NMhq9EGCMYLNCxAv6gF0ChnL+4uvw67OrTVmVpsJq5P4DSAp7vSiJR4gfoPBXzJEHO8z7iMW2JxhXn2KNIddbgletDWmL+Jk2LIi2uTmwDjoKQZyRH90+IoIy3YjbnJqRixxutUvhKQjiJFXz91bURrjRr6UY2mzXUHx1uDv6xDwP9MUNHPpMtpq8kXYbXzgKOMS/QtBZxaqIZ4yYfQhaLxZDWEeBRVJdJnNs1U4OVNSmniI3AKX62g+IT0rNi97LQG5Fv3gG5j1aL2agd9viiu4B6mkVkqEaZ4fJMId+kH6CHm9J5c65mXD/xOmDr6S2CSkrQdZClFnr6qgaN0rtoZNj1RkYKNr9SQXbVsymZDvP/YF3LdhTUcJS6KhI3yIoPD7RHf7aKf+YAiuVhLO83D7Ntva3nzADX3yuoMviiI25wb/IG0kQ/HoFs2SUdc0Citew8nDt27oo8anFuq0pIg1cT0869YkGIqIZgIWewODjP4zon+nP0PZtT/hEvULqM8ptBpfTTduplEqJdwr4dYrG8XjGTpJj8X+v/S0Z/z3fnQpSLnd770al7PgCvNRxHfoWNvPfx6n8XmK6+4cKrIDQ+VNxUpFhbECKrmQNEhHphPWBdahh56315wWGHn/sGuiVv10qWSipY7KwSxM5JkvMRutCOKsHSDyjCDFic/2yXTEUmN4EbWUsiPiPsvEP09MTP2D0un62/ajgpXfXsotsOO+XNyPZRMDAw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(376002)(346002)(366004)(39860400002)(6512007)(54906003)(316002)(33656002)(36756003)(2616005)(5660300002)(26005)(66556008)(66946007)(64756008)(4326008)(66476007)(41300700001)(53546011)(6506007)(71200400001)(38070700005)(83380400001)(91956017)(6916009)(2906002)(478600001)(6486002)(76116006)(66446008)(186003)(8676002)(122000001)(8936002)(86362001)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gQUvnAAOs6Yotlc3bFFw1zxB0oXZ1S+p7V2Bnt4LT9zGq2ArzJ4HGcQ71ylb?=
 =?us-ascii?Q?+F0pZ0vaoszvuxAEa7+Zzha3Vend0bxqwyaRlBN+0yLBqYxiBpO9BCQJTdBc?=
 =?us-ascii?Q?RhJEwwLbidAuLsns4AZJrVFOd8Cx3JYDP+T5JIYZXuWPLuajD08PagAhO3BN?=
 =?us-ascii?Q?4G2B2wuhETS+zXvmT+4B4r8kO/lYyRRrIyST3vqgFkOqafp5LXIOO/hN1Mfy?=
 =?us-ascii?Q?GV0Dd3Ro+s/KTvqYR5FYQX3x+TKR3TeLP8bNdLVd/OSBmsqokgojRjw59Pw5?=
 =?us-ascii?Q?kt6oRQsl1KDwvXF5xOH5l+sRDd8ZmjKE+8kASpH5RYMKfRK/rnaAqXFJ6Zvb?=
 =?us-ascii?Q?IugAQVUCiKHH4LadZdeXnViGQGlIN8iyU+lnZFJslRjtwL+ENrHGLChDZBAb?=
 =?us-ascii?Q?vqGwMuJOKHqGY2lQO5AJesnbfgFs1x9czAiiTfDXMMfJirbHKMNNHO9MpxLV?=
 =?us-ascii?Q?MPpQe3AM+QEZ6/Salf75qB5KKYfy7A9Ymt9bS06+gx0h1vDlhWiNC/vObXBb?=
 =?us-ascii?Q?Tn0/QLa+QynTVbqxqvx8nI/B34f5w4yQWyXsQ2TARngFY3jPTvDD2umGtgap?=
 =?us-ascii?Q?6hTaOlmzXcSftAkruAnwE6yFU8T9+L5jbk8ov31gO/wPaNiX/3EzRGtyPQbQ?=
 =?us-ascii?Q?Ni5RdBVDw9Ok2PN7jwyOCvNWz6B/E0zf/xhxqN70rYZmcr0HvH+kIragpx0N?=
 =?us-ascii?Q?K7m+O7bYzxAiK9l3GDVTjdTB+6JAenbRRY+Ek+N8svMsbaW96piD2CLeYPaw?=
 =?us-ascii?Q?VDr2llEoIfTqTlXKWnavcqKDYHQnPAh3L0hk7PkKqzu9EAR2MZWpOLDOual1?=
 =?us-ascii?Q?/vQ6++DSmPLoNrdF8xONUYLRoKjohNkXt5/dHMj292GqXcIgnW9QXonfLqh6?=
 =?us-ascii?Q?xnd3L/Syvoc5xeZZNzziOkeVnxBNjnZknrAz+oUvij4wkHa6+i7W5w4wrTMR?=
 =?us-ascii?Q?MTfBjf3sPMSQUHJtC8Gt0RHds0HAFyuFdn+88C+l46+jD76iI4YQ+ubErDTa?=
 =?us-ascii?Q?kNoXjel4iCZPaJYn973JHmcCYNvxOxFQa5jsEjfYIm9g9k2F5CZfyHKJS2u7?=
 =?us-ascii?Q?ISyRB/e0hQ15R/vQ6/ybl94K1zWD9hwwXNIYNYPOzVJgufJQypClcJYIuSFD?=
 =?us-ascii?Q?JO8XVxJgRuyvLLLgLDTnjJDZ8nf1DbUWBI4cCtBZXLQyAEEW+Xx4O/PViuAf?=
 =?us-ascii?Q?rqWHuWYKTjiaHZbq82kqWZ/rxKZA+SYAdNg1bx1PJpxxtMpwM7lHgtYVRpq1?=
 =?us-ascii?Q?IbyPEnL4YIrCBsTeQ39hj+uOTdn+pGydUr478jSvrMBp1zijKk81LEoaRh/3?=
 =?us-ascii?Q?tcVW4uw90Ubn/J3DdgxccQxWg/LA2MOdUD5i2ponIWizzFEvcIjlF9SxDuEe?=
 =?us-ascii?Q?qwMJd/tKBkAQo3kPZK3AIIcL1yz2uYym6lzaFEKCNkFLk63qQdu7gU0MEDnl?=
 =?us-ascii?Q?epqiSCBoO3ZSrzlm5/3kdesyOv2y/AHsiVSrc2056aVe3awdfVWS+cuIoPuV?=
 =?us-ascii?Q?9UyQW+qSv2p3Nn9isgwXKd8qSPFxPtxJA3qWHbpjN+BUeEQBqNlAyAZ3H4W7?=
 =?us-ascii?Q?DJzIhswjxSuByFZyQh9wWNkQKPClBKPs+YflTy1URlt2GwOjouqfS4dAxcRX?=
 =?us-ascii?Q?6Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2014D138C26B5E41A07B3394800BBAE3@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce2cbfcd-6742-4e02-be00-08da55f66dc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2022 15:30:11.7843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wxzDE2olwrBbeBCOQp9aFzYl1MUCufNNROY/obEg+n8DdHLLlfpkawYYVaUTOUB+F//Qf5ePW14cfzEGEZCe9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4755
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-24_07:2022-06-23,2022-06-24 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=740 mlxscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206240059
X-Proofpoint-GUID: 3cvnVbaEmv9XvCvBtAcSChuvv9CjJc7W
X-Proofpoint-ORIG-GUID: 3cvnVbaEmv9XvCvBtAcSChuvv9CjJc7W
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 23, 2022, at 1:51 PM, Wang Yugui <wangyugui@e16-tech.com> wrote:
>=20
> Hi,
>=20
>>> On Jun 23, 2022, at 5:02 AM, Wang Yugui <wangyugui@e16-tech.com> wrote:
>>>=20
>>> Hi,
>>>=20
>>>>> On Jun 22, 2022, at 3:04 PM, Chuck Lever III <chuck.lever@oracle.com>=
 wrote:
>>>>>> On Jun 22, 2022, at 2:36 PM, Wang Yugui <wangyugui@e16-tech.com> wro=
te:
>>>>>>=20
>>>>>> Hi,
>>>>>>=20
>>>>>> fstests generic/531 triggered a panic on kernel 5.19.0-rc3 with this
>>>>>> patchset.
>>>>>=20
>>>>> As I mention in the cover letter, I haven't tried running generic/531
>>>>> yet -- no claim at all that this is finished work and that #386 has
>>>>> been fixed at this point. I'm merely interested in comments on the
>>>>> general approach.
>>>>>=20
>>>>>=20
>>>>>> [ 405.478056] BUG: kernel NULL pointer dereference, address: 0000000=
000000049
>>>>>=20
>>>>> The "RIP: " tells the location of the crash. Notice that the call
>>>>> trace here does not include that information. From your attachment:
>>>>>=20
>>>>> [ 405.518022] RIP: 0010:nfsd_do_file_acquire+0x4e1/0xb80 [nfsd]
>>>>>=20
>>>>> To match that to a line of source code:
>>>>>=20
>>>>> [cel@manet ~]$ cd src/linux/linux/
>>>>> [cel@manet linux]$ scripts/faddr2line ../obj/manet/fs/nfsd/filecache.=
o nfsd_do_file_acquire+0x4e1
>>>>> nfsd_do_file_acquire+0x4e1/0xfc0:
>>>>> rht_bucket_insert at /home/cel/src/linux/linux/include/linux/rhashtab=
le.h:303
>>>>> (inlined by) __rhashtable_insert_fast at /home/cel/src/linux/linux/in=
clude/linux/rhashtable.h:718
>>>>> (inlined by) rhashtable_lookup_get_insert_key at /home/cel/src/linux/=
linux/include/linux/rhashtable.h:982
>>>>> (inlined by) nfsd_file_insert at /home/cel/src/linux/linux/fs/nfsd/fi=
lecache.c:1031
>>>>> (inlined by) nfsd_do_file_acquire at /home/cel/src/linux/linux/fs/nfs=
d/filecache.c:1089
>>>>> [cel@manet linux]$
>>>>>=20
>>>>> This is an example, I'm sure my compiled objects don't match yours.
>>>>>=20
>>>>> And, now that I've added observability, you should be able to do:
>>>>>=20
>>>>> # watch cat /proc/fs/nfsd/filecache
>>>>>=20
>>>>> to see how many items are in the hash and LRU list while the test
>>>>> is running.
>>>>>=20
>>>>>=20
>>>>>> [ 405.608016] Call Trace:
>>>>>> [ 405.608016] <TASK>
>>>>>> [ 405.613020] nfs4_get_vfs_file+0x325/0x410 [nfsd]
>>>>>> [ 405.618018] nfsd4_process_open2+0x4ba/0x16d0 [nfsd]
>>>>>> [ 405.623016] ? inode_get_bytes+0x38/0x40
>>>>>> [ 405.623016] ? nfsd_permission+0x97/0xf0 [nfsd]
>>>>>> [ 405.628022] ? fh_verify+0x1cc/0x6f0 [nfsd]
>>>>>> [ 405.633025] nfsd4_open+0x640/0xb30 [nfsd]
>>>>>> [ 405.638025] nfsd4_proc_compound+0x3bd/0x710 [nfsd]
>>>>>> [ 405.643017] nfsd_dispatch+0x143/0x270 [nfsd]
>>>>>> [ 405.648019] svc_process_common+0x3bf/0x5b0 [sunrpc]
>>>>=20
>>>> I was able to trigger something that looks very much like this crash.
>>>> If you remove this line from fs/nfsd/filecache.c:
>>>>=20
>>>> 	.max_size		=3D 131072, /* buckets */
>>>>=20
>>>> things get a lot more stable for generic/531.
>>>>=20
>>>> I'm looking into the issue now.
>>>=20
>>> Yes. When '.max_size =3D 131072' is removed, fstests generic/531 passed=
.
>>=20
>> Great! Are you comfortable with this general approach for bug #386?
>=20
> It seems a good result for #386.
>=20
> fstests generic/531(file-max: 1M) performance result:
> base(5.19.0-rc3, 12 bits hash, serialized nfsd_file_gc): 222s
> this patchset(.min_size=3D4096): 59s
> so, a good improvement for #386.
>=20
> It seems a good(acceptable) result for #387 too.
> the period of 'text busy(exec directly from the back-end of nfs-server)'
> is about 4s.

I was surprised to learn that NFSv4 doesn't close those files outright,
that they remain in the filecache for a bit. I think we can do better
there, but I haven't looked closely at that yet.

I see that files are left open on the server by crashed NFSv4 clients too.
That will result in the server becoming unusable after significant
uptime, which I've seen on occasion (because I crash my clients a lot)
but never looked into until now.=20


--
Chuck Lever



