Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1994507A66
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 21:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345567AbiDSTnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 15:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233847AbiDSTnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 15:43:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E889F403DD;
        Tue, 19 Apr 2022 12:40:22 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23JIc9QW024754;
        Tue, 19 Apr 2022 19:40:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=8sM6FeFXDnCNhHJgp9rwZ7df9bNZPUQSK9c5e9DLV10=;
 b=gbL+28G+H5/1LRo9HyequsYPO+0iqzlXl8022jmrq+vUiyaRugxyX3hrSbzDSGL8ZYAa
 NZHfOi814rn0vV2wWRMY6LuVuY5EUJFmA/0S/jUpwb0Noy0H5XzZK0uQoAi9hk+8hQzV
 kyQCzEC6TITYZ10jJJE/68Dyqr7RaiYpYe1obfd2aDXdxDVkFZW6pj8d2/Aht88NoQ3q
 aWC0aFWnjfoJvUz5FaZr1G8hzUIv/l866ij2UTnuLD53HwQjhaYv/Zj1wnY4ktoiu0Sc
 38ZStJ95xc62vhZXDhfL8Qoe3BFwBmeE2SNlj2Fbii3phoicoOpZVlPu+QQu4HRkTOLa bg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffnp9ex3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 19:40:14 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23JJQh5P040925;
        Tue, 19 Apr 2022 19:40:12 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3ffm891qmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 19:40:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VVz5cnZzKVvlC1s6iWEbaHqNhUPOzv3VlVR7T2vWVub0TLnyyW7ABgY4Wco+7KAo2JVMGriicJeRjePjsMDVFIkDAn7HKTyunf/avRbPwlthiu+bGm5VjKFdbX9+YGf52jvKecIlzfy/OWBngCXsJi3ajLDG6mrIMI5oXlL5DiTSgYOYhvA9LOaeuBEvdttrFXkHHiLdB5iTjtPJfQ0VKMXlDw8xVqN5PF+LGlvLoxLq8isBO1kodhrszi0T8Puae732unhM6XqcetrvXsVnEB9iwx2+GLBXIDU2yEttoK+wz+2UNyLYmzqi7cYgjQyCH/Knn6vMSjz/xOshkYqOSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8sM6FeFXDnCNhHJgp9rwZ7df9bNZPUQSK9c5e9DLV10=;
 b=BRORaBAsYmkznNC6GnDmTjbbB3TP7i4iVV4k11hkN6wfddlel/p3rZavdm9HT2Yze8YkGfylagrJQ1o0riMqDd70uebsyw8JRujkm+G1z73DCKQfYYgq1qWAximmu/m2psaUELX5f5CUqBjuNG/CF2QXyVq4PeiYGO44foJgbWEDRE5w6jisb+kRTFER4aU2AK3tSXDcBMlM85a9JA+5kbmM5GqWv6hIyuH23L6G93xM3vv/ixfZMfXYLAwKFPQBL3VotyTqef46gsnb4YU6kqK3v/IMuPtXvQy84BXIhDN1qFoKYEL9h8TJz4hyWlnTHnt7huuFlzpLe34yQXPc9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8sM6FeFXDnCNhHJgp9rwZ7df9bNZPUQSK9c5e9DLV10=;
 b=A4aVRvrhPuTxFjIn0uY6Gs+9RarOJvqQ4469Y6EppVwixJUqTnc1Is/f/sQB5YR9JmMQT67qekeSa2J556x6BRzehaTwn/Iwtwqi9Rfj953zqzMoXTHvRhDHo7WkWn1WAVuhL/q9nSGCb0qPE+qRekfueuC9otY2xuJjQDdkI6Y=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by BN0PR10MB5333.namprd10.prod.outlook.com (2603:10b6:408:115::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Tue, 19 Apr
 2022 19:40:10 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::f427:92a0:da5d:7d49]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::f427:92a0:da5d:7d49%7]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 19:40:10 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Trond Myklebust <trondmy@hammerspace.com>
CC:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "simo@redhat.com" <simo@redhat.com>,
        "ak@tempesta-tech.com" <ak@tempesta-tech.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "borisp@nvidia.com" <borisp@nvidia.com>
Subject: Re: [PATCH RFC 08/15] SUNRPC: Add RPC_TASK_CORK flag
Thread-Topic: [PATCH RFC 08/15] SUNRPC: Add RPC_TASK_CORK flag
Thread-Index: AQHYU0UH7NIJR860dUOYblj2e849Maz2i/EAgAEAwYCAAA1cAIAACfaA
Date:   Tue, 19 Apr 2022 19:40:10 +0000
Message-ID: <B7355D85-1CCF-4836-9B85-E6C9E019CD9E@oracle.com>
References: <165030062272.5246.16956092606399079004.stgit@oracle-102.nfsv4.dev>
 <165030072175.5246.14868635576137008067.stgit@oracle-102.nfsv4.dev>
 <a771c65353d0805fc5f028fa56691ee762d6843f.camel@hammerspace.com>
 <AE1190F4-EDE4-4C2D-94C9-02A5EDAAFBC6@oracle.com>
 <36618d90e44961aed7b40c4640952fd574fce60c.camel@hammerspace.com>
In-Reply-To: <36618d90e44961aed7b40c4640952fd574fce60c.camel@hammerspace.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c814be9-2790-4374-78af-08da223c6a2f
x-ms-traffictypediagnostic: BN0PR10MB5333:EE_
x-microsoft-antispam-prvs: <BN0PR10MB5333E1B1D4A08FEFB0BA11E293F29@BN0PR10MB5333.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SmsNWy4YtQDi8ma4AE4DyqCnn13lHItcPLsZEYVIUw7Rl19/X1S1dYPJSues0uk9Sr/mxzti6Anz9yXUH3tKFb/PvoQVi6kyeR0x5NLfj/a5RkGfEnIcK8sbEAxGq5aFQ50cwzEhrrEIHf9gqrdIOqPfTSV0jDAyNUYRb514Y7uL9MIxLsKoQAqALjfzYHL9PZuOHPsRcLqj3P0/1pRc/zggiR3hf8FHhvWVsP6fsqovcCvQe+4RujYno9TL3+HyFbmp6OnBjW9Xow6b/5AvuTZyyfVS6zwtKzYmGvHb6IH807WwEJ4gfa+YtkB6L6kYCaML/uOA4UiqGjSmMGYdmHB95MBdenTmCRCh/gkjgJIXnCxzrBTAysTacR10vACQ8ESIUm3uOenzuzYbaffcckl2wpsXoTt5Uxt/KZAEiq4ph32B6HYeahCstRKgiqs80OrI+hB7O/+tMIMAs9ccss5VOWoZygF/UBsugTu5Rerj7oCWaEAtuj1v+Sl52ep4k7X632E6e1K24ssfkkZ8VpOfD9pACZry/I7ITAQ3IbKk/V28oP40P1gUPfcaMOw5rwR3ICOI05omY+tBkvFjDf8r4sHlLEbhkOp5sQwrm8O+AoxbEjxMa635lbTNDvuohq10v5vq1Wvw6NSEQPJ7GuEnHUnpQL+e3Yx4jHOHVRa1N+mFvgRIdX0pFaldhz5mV0NyYuEeXJ1s6brw3jWvJnnGm4G7ScZ+x89a/OOl9c0p6WX/aG3PYiuDbnUz2GU/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(8936002)(53546011)(122000001)(8676002)(76116006)(4326008)(33656002)(508600001)(83380400001)(5660300002)(36756003)(66476007)(54906003)(71200400001)(186003)(6486002)(91956017)(66556008)(64756008)(26005)(6506007)(6916009)(66946007)(86362001)(316002)(38100700002)(6512007)(66446008)(2616005)(38070700005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8xmoy22Y/2vkwO2khRzfk276rPKErJa0gNJ6JWmYTzmndQNFMDan0RUGgt9O?=
 =?us-ascii?Q?7W1TGcijE2xwOfTmSOd8VdoVIgNn2kBvP7MKnu2gg4Zm0HQfHsj3DH8oXCZI?=
 =?us-ascii?Q?VAqDiyBXyOo5/p36G0kEGjB+d9P0ZJUxDYlmMEsl06jiHmGZaaNfE6a2KlOR?=
 =?us-ascii?Q?mZdu0q1F9uzlQSCJXEA/KGyBi5j1wmd/uzPD3/yo/JsZno9172bjoqEdJKMs?=
 =?us-ascii?Q?WGHRyZbX7E4LW6z2AZiBZq6qT4WtoVdFhIzLcNfbK07JUGKs6BdOUEMfiY5M?=
 =?us-ascii?Q?fJNlA5pBOOBcUhMPgGy3iBKxqGhpTJe6ynRONH9iz3JwsLBVHSF55RMZfn6h?=
 =?us-ascii?Q?HGUUmHalavgXZ34pi/AZ3dl625l3+/6qjkGbDloqgj/8dlkprkoW2LXB227o?=
 =?us-ascii?Q?1FSFZ2pVqIp+CibRePyW6mbdMv3a1x6BkN/zA6gYX6buVwhzr4tXA+M8gOlZ?=
 =?us-ascii?Q?liF1Yi8G70oEOy1NIfwvNyl1JtEob80mBz5gOCQ3dUgN+feK87aj4AuWFdMJ?=
 =?us-ascii?Q?QJgzWHRqVrkAhZPNSv65cM0IAEHEfSl1AMnysY17nOYrvDCdMJ5AYznfbR89?=
 =?us-ascii?Q?siNQUFAK5YEBOGIhTh8QYM1oKKPDlCgqPUlrXndCblP/TMx6LwgWbzvKQi3T?=
 =?us-ascii?Q?xLFyLl8jDEIUeHjNHfQatvFsL15RrcPl2CfHqAkUDOw949HweQWnlQNFjr7W?=
 =?us-ascii?Q?Oi2Rkwb0xFcAU5hQRpRYBwPeCaMSj4MQJHurNsgl4GG/b/qeWbMqfVPoWqSQ?=
 =?us-ascii?Q?r9KEgBxi81o0Su6g5K9TQVfW8LLNY6/kFSlTMcxRdqsTyfTkyFSDb4Qog2Li?=
 =?us-ascii?Q?z645FWfNZxgHgDgio0bTuqw2jCf9bl+NKAJ5avKm6Okm6viKTZ5HOEZ05HEQ?=
 =?us-ascii?Q?ka8ltv8NuhTPLS2sCFVOx5cz9LOj6eq54JRQeXk7HAa8B1uUMKCy+0upbT0m?=
 =?us-ascii?Q?qfVEDARpgFVBDr8q1zKWGgOPDinzvXnkR+AUhH+5f8y+qgtLF7dhuvOCPMYz?=
 =?us-ascii?Q?yQ3mm7niha+mafSTOH8PnwM5u0SzJToaWptYdUNenHw90XaAvIqbXKeY2hBW?=
 =?us-ascii?Q?5DtD8MYClZKGvUvPwRF0mJxxTluI0S5oKmUspr2jP8qP1gANFeaOpYQjf3GB?=
 =?us-ascii?Q?4ehjN4HXyv7tHIOzPX8UaDWldqvyTFbpjys26Kk3Bw4xEojgqLnPyAYAniOf?=
 =?us-ascii?Q?8UNP1SazJK1uJY72IzI6Rd+2Nv+X3oAllQJPSNkMcMm7RW/a1+6vCxP83k6F?=
 =?us-ascii?Q?V9xol5ELuq9w1yPTAYdkkoqUPvudq3B7qi9tBfb/KKFWFuf4W/ZCt/F7gyA2?=
 =?us-ascii?Q?HU86OOIBOAmgDq2eHox5ERjdTCeppm52r+p+4Vg3H1GhevAaODxzh97OzQZH?=
 =?us-ascii?Q?w2RK1bgkFbLjrHeB1B4bXuSP7SlXTD94REUD2P2ovvsXElQXzpNE9xsAkyAH?=
 =?us-ascii?Q?wFeKMZKPyLwOz+HQUe+4Gp/3xaIEIQ1ls/oirNUADorKZve8hrWVCXqw2HaX?=
 =?us-ascii?Q?KU2AkJyM9x44N2u6+tvGS7noC0aoIRWDXF2C9zxto0FvPgBqxN1qjbSDiGWb?=
 =?us-ascii?Q?yL9prdKWWYw+/Qtv8iwLwEszfsQERFGdheIUE3rbcAsX8LcaEhvDQIIoKbES?=
 =?us-ascii?Q?LOSxXyH0SUzPIaWXgY5ecHAeCghC4IMmnqcbaZGTZ0AKodDl4+Yy7b+AA8Yb?=
 =?us-ascii?Q?dmAcnNo1Y2xVKPIoQjf7E9PwjDR2dSJ7GavGnVFUBoyIlIna3dBAdHFeS5wW?=
 =?us-ascii?Q?q6myeIinlqYldk0pLLgWEZcZhVlTTpU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CCA815AB4FC1AC479E9A3206739D3865@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c814be9-2790-4374-78af-08da223c6a2f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2022 19:40:10.0287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FcHnq8nCDMNIlaHVyXFuRkkp6mTg+OyXL6RxPVFM2ZT8PNkf+a1NMkro5donsHi+RCaY75iyrW3NPISCey8tWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5333
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-19_07:2022-04-15,2022-04-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204190110
X-Proofpoint-ORIG-GUID: wWBQEIw0JjFBAdLu1n6rFZh2iyaKQLzn
X-Proofpoint-GUID: wWBQEIw0JjFBAdLu1n6rFZh2iyaKQLzn
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 19, 2022, at 3:04 PM, Trond Myklebust <trondmy@hammerspace.com> wr=
ote:
>=20
> On Tue, 2022-04-19 at 18:16 +0000, Chuck Lever III wrote:
>>=20
>>=20
>>> On Apr 18, 2022, at 10:57 PM, Trond Myklebust
>>> <trondmy@hammerspace.com> wrote:
>>>=20
>>> On Mon, 2022-04-18 at 12:52 -0400, Chuck Lever wrote:
>>>> Introduce a mechanism to cause xprt_transmit() to break out of
>>>> its
>>>> sending loop at a specific rpc_rqst, rather than draining the
>>>> whole
>>>> transmit queue.
>>>>=20
>>>> This enables the client to send just an RPC TLS probe and then
>>>> wait
>>>> for the response before proceeding with the rest of the queue.
>>>>=20
>>>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>>>> ---
>>>>  include/linux/sunrpc/sched.h  |    2 ++
>>>>  include/trace/events/sunrpc.h |    1 +
>>>>  net/sunrpc/xprt.c             |    2 ++
>>>>  3 files changed, 5 insertions(+)
>>>>=20
>>>> diff --git a/include/linux/sunrpc/sched.h
>>>> b/include/linux/sunrpc/sched.h
>>>> index 599133fb3c63..f8c09638fa69 100644
>>>> --- a/include/linux/sunrpc/sched.h
>>>> +++ b/include/linux/sunrpc/sched.h
>>>> @@ -125,6 +125,7 @@ struct rpc_task_setup {
>>>>  #define RPC_TASK_TLSCRED               0x00000008      /* Use
>>>> AUTH_TLS credential */
>>>>  #define RPC_TASK_NULLCREDS             0x00000010      /* Use
>>>> AUTH_NULL credential */
>>>>  #define RPC_CALL_MAJORSEEN             0x00000020      /* major
>>>> timeout seen */
>>>> +#define RPC_TASK_CORK                  0x00000040      /* cork
>>>> the
>>>> xmit queue */
>>>>  #define RPC_TASK_DYNAMIC               0x00000080      /* task
>>>> was
>>>> kmalloc'ed */
>>>>  #define        RPC_TASK_NO_ROUND_ROBIN         0x00000100    =20
>>>> /*
>>>> send requests on "main" xprt */
>>>>  #define RPC_TASK_SOFT                  0x00000200      /* Use
>>>> soft
>>>> timeouts */
>>>> @@ -137,6 +138,7 @@ struct rpc_task_setup {
>>>> =20
>>>>  #define RPC_IS_ASYNC(t)                ((t)->tk_flags &
>>>> RPC_TASK_ASYNC)
>>>>  #define RPC_IS_SWAPPER(t)      ((t)->tk_flags &
>>>> RPC_TASK_SWAPPER)
>>>> +#define RPC_IS_CORK(t)         ((t)->tk_flags & RPC_TASK_CORK)
>>>>  #define RPC_IS_SOFT(t)         ((t)->tk_flags &
>>>> (RPC_TASK_SOFT|RPC_TASK_TIMEOUT))
>>>>  #define RPC_IS_SOFTCONN(t)     ((t)->tk_flags &
>>>> RPC_TASK_SOFTCONN)
>>>>  #define RPC_WAS_SENT(t)                ((t)->tk_flags &
>>>> RPC_TASK_SENT)
>>>> diff --git a/include/trace/events/sunrpc.h
>>>> b/include/trace/events/sunrpc.h
>>>> index 811187c47ebb..e8d6adff1a50 100644
>>>> --- a/include/trace/events/sunrpc.h
>>>> +++ b/include/trace/events/sunrpc.h
>>>> @@ -312,6 +312,7 @@ TRACE_EVENT(rpc_request,
>>>>                 { RPC_TASK_TLSCRED, "TLSCRED"
>>>> },                        \
>>>>                 { RPC_TASK_NULLCREDS, "NULLCREDS"
>>>> },                    \
>>>>                 { RPC_CALL_MAJORSEEN, "MAJORSEEN"
>>>> },                    \
>>>> +               { RPC_TASK_CORK, "CORK"
>>>> },                              \
>>>>                 { RPC_TASK_DYNAMIC, "DYNAMIC"
>>>> },                        \
>>>>                 { RPC_TASK_NO_ROUND_ROBIN, "NO_ROUND_ROBIN"
>>>> },          \
>>>>                 { RPC_TASK_SOFT, "SOFT"
>>>> },                              \
>>>> diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
>>>> index 86d62cffba0d..4b303b945b51 100644
>>>> --- a/net/sunrpc/xprt.c
>>>> +++ b/net/sunrpc/xprt.c
>>>> @@ -1622,6 +1622,8 @@ xprt_transmit(struct rpc_task *task)
>>>>                 if (xprt_request_data_received(task) &&
>>>>                     !test_bit(RPC_TASK_NEED_XMIT, &task-
>>>>> tk_runstate))
>>>>                         break;
>>>> +               if (RPC_IS_CORK(task))
>>>> +                       break;
>>>>                 cond_resched_lock(&xprt->queue_lock);
>>>>         }
>>>>         spin_unlock(&xprt->queue_lock);
>>>>=20
>>>>=20
>>>=20
>>> This is entirely the wrong place for this kind of control
>>> mechanism.
>>=20
>> I'm not sure I entirely understand your concern, so bear with
>> me while I try to clarify.
>>=20
>>=20
>>> TLS vs not-TLS needs to be decided up front when we initialise the
>>> transport (i.e. at mount time or whenever the pNFS channels are set
>>> up). Otherwise, we're vulnerable to downgrade attacks.
>>=20
>> Downgrade attacks are prevented by using "xprtsec=3Dtls" because
>> in that case, transport creation fails if either the AUTH_TLS
>> fails or the handshake fails.
>>=20
>> The TCP connection has to be established first, though. Then the
>> client can send the RPC_AUTH_TLS probe, which is the same as the
>> NULL ping that it already sends. That mechanism is independent
>> of the lower layer transport (TCP in this case).
>>=20
>> Therefore, RPC traffic must be stoppered while the client:
>>=20
>> 1. waits for the AUTH_TLS probe's reply, and
>>=20
>> 2. waits for the handshake to complete
>>=20
>> Because an RPC message is involved in this interaction, I didn't
>> see a way to implement it completely within xprtsock's TCP
>> connection logic. IMO, driving the handshake has to be done by
>> the generic RPC client.
>>=20
>> So, do you mean that I need to replace RPC_TASK_CORK with a
>> special return code from xs_tcp_send_request() ?
>=20
>=20
> I mean the right mechanism for controlling whether or not the transport
> is ready to serve RPC requests is through the XPRT_CONNECTED flag. All
> the existing generic RPC error handling, congestion handling, etc
> depends on that flag being set correctly.
>=20
> Until the TLS socket has completed its handshake protocol and is ready
> to transmit data, it should not be declared connected. The distinction
> between the two states 'TCP is unconnected' and 'TLS handshake is
> incomplete' is a socket/transport setup detail as far as the RPC xprt
> layer is concerned: just another set of intermediate states between
> SYN_SENT and ESTABLISHED.

First, TLS is technically an upper layer protocol. It's not
part of the transport protocol. This is exactly how it's
implemented in the Linux kernel. And, TLS works on transports
other than TCP, so that makes it a reasonable candidate for
treatment in the generic client rather than in a particular
transport mechanism.

Second, the "intermediate states" would be /outside/ of SYN_SENT
and ESTABLISHED. A TCP transport has to be in the ESTABLISHED
state (ie, the transport's connection handshake has to be
complete) before any TLS traffic can go over it.

Most importantly, the client has to send an RPC message first
before it can start a TLS handshake. The RPC-with-TLS protocol
specification requires that the handshake be preceded with the
NULL AUTH_TLS request, which is an RPC. Otherwise, there's no
way for the server end to know when to expect a handshake.

In today's RPC client, the underlying connection has to be in
the XPRT_CONNECTED state before the RPC client can exchange any
RPC transaction, including AUTH_TLS NULL.

To make it work the way you've suggested, we would have to build
a mechanism that could send the AUTH_TLS NULL and receive and
parse its reply /before/ the client has put the transport into
the XPRT_CONNECTED state, and that NULL request would have to
be driven from inside the transport instance (not via the FSM
where all other RPC traffic originates).

Do you have any suggestions about how to make this last point
less painful?


--
Chuck Lever



