Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28E686A4573
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 16:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbjB0PAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 10:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbjB0PAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 10:00:20 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E75F212B2
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 07:00:06 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31REsNlf014169;
        Mon, 27 Feb 2023 14:59:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=l7sqqULlFBC9g9OhFqyLHb8G9k1RNh+M8gdRDMxiP9o=;
 b=gGTMSYBVYOLmumgWvDjppny1tXzWpq2b5fZQjpza0PLWC/qO2vp9rV02qH3/LMtHVVu7
 x2LEd0P8tP0/qXLdqEyKkFnLG8ZwOmuVFCmbVBQ25/X+kIizko04R9Mxe7jbROftyHrW
 T+W3xLrGv+uni3oCcPEgi1otSF2Z5B3eBMhEUKmxvqZ9Wd1XHrm4UyHbOZU8srpLegJo
 qA/hHgi71VQ9cfGLhcqM0vYF+CnbjhM7EITQQNyPRamOMmEgohp0J95CbWLFXIbfNqGV
 IO0GpsBZZ52M0OT7q4xgt7JHoUrCZgKnRPPq+BfQtD2Oh4yB527qKF/yPOfxOxtEZCCl xw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyba23u9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Feb 2023 14:59:44 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31REWwUP015940;
        Mon, 27 Feb 2023 14:59:44 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8s5necn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Feb 2023 14:59:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oT6+8Dc583ILvWb8CM3IEYVRr4KFvCz3595RcBUDYjyoqNkRWh5myHJv2k9Jo75Toyep6a9HPZrfCBhkb7GBfljykrzeE8euRi2eg3ogXWioME/F62Vt9bf7eO6DLusV0Y0jnLSVPUhP+55dEedixABBlSPFuE92n8RML3qpcl+D80sjGZ5PJMiTiS8dh2B+owMLU1QXSzj2DGP+Mlcg3lbTP5hVTp4g13wANoabDFPiimpxf4gVbujIIflKvJdgO/8iEynz2hPoJ8VjKMhggjhBxlcNX3v6teIsDW81Wh9g22xIAaR43eciLUKT2Bbi974E9qMM2KLxf0ExgdRVQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l7sqqULlFBC9g9OhFqyLHb8G9k1RNh+M8gdRDMxiP9o=;
 b=aq824w9AwuMsyLJX90gOXPJ0nwgF90RLZCXTCprRHbiqKtSjtDU0ALhYs50Ozha1Hfj3GV86lJK/l/LEJofIOJEaKbbNr//FyJaxrbj7XJva2Y+0BCBSNOV5wipMIkifblt5pMRqVLICpHU3ZDAfE2ItAwyigOYAxPayszlFwfaQieGgP5SAW818vSp/MoTJnA3dnUjcRDl1DVxjmDvVpuPFKavrW8naEsikZN0UAl4t7Sx3Xtlv3TjgrGkuFaK6LHKuBp3mdC7K4mMXWJ5Dbvkle2fBwZxt8akR6f3cdxCCKP77kPHvVOKCpQ2kNZX3O/ZfuT/rj9P1q4fhbO0V6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l7sqqULlFBC9g9OhFqyLHb8G9k1RNh+M8gdRDMxiP9o=;
 b=Gf5zIPGCE6ZO5B+L6vcHL6gNsAzbsEk/zUv3ZAGVFvHhPKRGRgzxjUA5kml8oEjCdVFaYc+FerlqmPuH+JG6eJ/eoFFbBpF6NiYe70iAbugF9km6hAsM75854npswB+dqzyzrBw2uV5cO7d5l2Y0U5hUfp/0gWCMksgyrCa3fsw=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CY5PR10MB6261.namprd10.prod.outlook.com (2603:10b6:930:43::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.16; Mon, 27 Feb
 2023 14:59:40 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%7]) with mapi id 15.20.6156.016; Mon, 27 Feb 2023
 14:59:40 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Hannes Reinecke <hare@suse.de>
CC:     Chuck Lever <cel@kernel.org>, "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>
Subject: Re: [PATCH v5 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Topic: [PATCH v5 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Index: AQHZSITpzXcU72XpWUqa2tRUnzVdcK7iiYuAgABdpYA=
Date:   Mon, 27 Feb 2023 14:59:40 +0000
Message-ID: <1B595556-0236-49F3-A8B0-ECF2332450D4@oracle.com>
References: <167726551328.5428.13732817493891677975.stgit@91.116.238.104.host.secureserver.net>
 <167726635921.5428.7879951165266317921.stgit@91.116.238.104.host.secureserver.net>
 <17a96448-b458-6c92-3d8b-c82f2fb399ed@suse.de>
In-Reply-To: <17a96448-b458-6c92-3d8b-c82f2fb399ed@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|CY5PR10MB6261:EE_
x-ms-office365-filtering-correlation-id: eedf162f-3f50-43a6-17af-08db18d3406c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wr0YYFxUgANl9o6VzXdkMP46F7lgmWf0MayK+ayeA+K+aWDFoWyeuUbpk5FUPRGF4uEB+OTUfsc24+FpLKqpn3S9u8iejV33+LZExD5w2surp9kj/JcVm5K2EIEY6sYK5I5rdT1FQEKLPanqqW6Ip/LEJvifJohe3chRoFyBsm+z3wPmjcpv4DNE0HByeIkH0F8wvJm4o+13KArSeKPfkOJhT1PpI3klaYzc1f0lSFDr1g4nMratpgJ20mrcap1JLudAyT33h9kkVjrDdojjLi4t1TCOvt9AeA+Cdh2pPuwxsM7lvN4lE+Kmlz7DRTfddDvlN6PRD4txiojayf/imVdwZ1L4s+Ev4ZY2UA/uh7ul+kbTqVLknzHP/Ic65z0SokzJCBb4kPoJV8GnioNdoFz8IAtO8KHvThxNbBapRzPaVMPH7NEYuqz7MtL3eQYEUGiQk68pdcNxj4mENZaiMC1wokc8Mk6cTJQY/NGBW+BQIE6ritghjsWCDHyfb457J0xUhFyhRK5cr/FIW5t60QcmuVP5hxEl2ZFMki8mwrZjqtDBNu6NGLGUTO6sZs/9hoZuFBljfKwzVHSSefFjtolqxijG1l5I04YZm08wlTUTKe6ez4qPQyMY4NcpKkBAXHRGb2pRjCog89hbhyKzet/69UBNqnv/dK0f/zzv1nuh9smm1Bqws0pfL0brJ/qaxanUgMUFtJXFxavLTC8CA8vpbgup0mqRQLR+DwwNQCwmLAMEStj/aJFgRiHLdk3W
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(396003)(366004)(376002)(39860400002)(451199018)(91956017)(66476007)(66946007)(66556008)(6916009)(4326008)(76116006)(8676002)(64756008)(54906003)(66446008)(41300700001)(2906002)(71200400001)(30864003)(8936002)(5660300002)(2616005)(6506007)(53546011)(478600001)(6486002)(26005)(186003)(66899018)(316002)(6512007)(83380400001)(122000001)(86362001)(38070700005)(33656002)(36756003)(38100700002)(21314003)(45980500001)(559001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PMF4G3qFIU0L4yBhL2B4yhqSDbB+37+d4H3rM5uQIwy7iIRyaajwIeI98vIk?=
 =?us-ascii?Q?jJP9OAyxOHtEpJiE5aiKbLpdcLLMeEY4XKUhbcbpmTFXYgFnVFwyEsz6tVAW?=
 =?us-ascii?Q?t0JgyYCoUz0yP4+cY9oCzkdlvmvTl3GBzVN527LHwxALTXN0XENJM+1cc+qe?=
 =?us-ascii?Q?JEjH9Ogh3I9YHTHYG0Zb7FRihGnNEMroEO9cdyssdHmINgneDM3SRUVztW0l?=
 =?us-ascii?Q?3skOrLbWHGqaozc/t+KnSAlsEqBZxJmwh1cfkNW+TtlrSG8WdiyOopkk7UUd?=
 =?us-ascii?Q?Vzd7TceU811q+DWTMtwrVHKschkCl1j0BU5Cx3CxurMcJegZteFD4SGkpO22?=
 =?us-ascii?Q?dl+MLvBpVoGZIhkGflExO5geSio+UaAK5r7g4j213H27rEoZYfVrJIY6X/Y8?=
 =?us-ascii?Q?pYJylCdD2YnA6gVp8tP5O2mSqNNK0yIiAS2A+1XylqhGPOD+O7Zjx0tV7v95?=
 =?us-ascii?Q?+IpvPEQkMoqJ9j3dcmWgmnrpdpK95i9vhkvePbexrNlFr8EQL2SeempeEC1w?=
 =?us-ascii?Q?DE9Kt7EE39K6ZYG3gLJb8tUXgQKZKc2UQCsuaWT1xJiIcg4x9hapyFr+ouNT?=
 =?us-ascii?Q?ACxlxf0Be3hbEiE4ejutIy/iAPGpO+SYw4jRpaQmeBAEacmU74lLnFShuG01?=
 =?us-ascii?Q?fztYOmMknHOlnDYe6jjZ1+tyw5zo36iqWMEkdYqUZxySz0mpC+mCZ4vIjJi8?=
 =?us-ascii?Q?OWriHoh4HqldtpsuO8H5p+A6XN/Af0zW0RaWG0ks+wMkCZ528tjsvb/I045b?=
 =?us-ascii?Q?284WjMTKJC1UWrJQu4uuFtvSKqUSlwedpVUnQT7APx2+nY/5ysuZwT+NIErG?=
 =?us-ascii?Q?E/iTYBvEE+oMbrkNBGMIPA2NJvIzB6gOLCQK1UDjxIVTap3oNTJkGScCwRyY?=
 =?us-ascii?Q?+1m4WMbCYTw12J34VeDs3YO554ekzthZnPlwV9B0M8JI/S7pvEGC3AY7cqx4?=
 =?us-ascii?Q?vkRmplpZ4p3eCT222SCC3viKwOwtwc3n9+RsAVBCcMZ1iHr8Oy+vsRpRmyiO?=
 =?us-ascii?Q?i12os6Pq/uyfDGyrb7e58IV2dk3Ppi7SbVT7hFmrDD3y5keGyhlYnrvw90EP?=
 =?us-ascii?Q?TIVSTBFywSaCfwQphD05HB1akYu5ihd4QKARNULexAKelR+M6Jtc1BzEpBx2?=
 =?us-ascii?Q?sC90QIAuXvrMabiNNq1Mh2BwOUJAri4FbLr5d8/FLLjDxCK1TgP6vE89Kyme?=
 =?us-ascii?Q?S2nif3vg5r27HkpvgEU5W3FjK00R2+BPlAt+8wjHyBseNSMi1/cdbV9twfjd?=
 =?us-ascii?Q?tcBnIEzA7oD8efi+YwzNjDI4Pc5yJoBqE3NjthQcMU1bJ6TNlvg1/aFlFfA3?=
 =?us-ascii?Q?ZLWq0aaTBSlhGlR6ag/t88sYCio7IuctC3pwvXPsdVJVulFEsLsSH3UdyVf2?=
 =?us-ascii?Q?f+EUsFQYQZrXUpSmASYt1tOhWanqqLHY4LvSDfryU3EcVB3IdfQ2kiaQBHGx?=
 =?us-ascii?Q?snT3T5uAYT+9RCevHQ/FhV0csPtP0RZCeHNIDBGD8YgFppV5x8mzTDlR/oiO?=
 =?us-ascii?Q?0IWQqGjFvp8jMFfTcnjH75lqkTjGBuQHF0lnjhVlgUwy4+OL0VM/qoQbUSEg?=
 =?us-ascii?Q?L+B78yJ5lI71dIPES6ud6h851UHyeuUcpd4lnHrdZdBM7OlzXHdZ5l8V6ciJ?=
 =?us-ascii?Q?DA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E6525F457C2B5347BED6E0A31D9CC54E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: MIFXrtDY+q3m7gTAIANhPfvZF7PSNempF4/i7/HQyjnfA70yCvkZk3+PlwJ/U7Z40hx+LNJstFJBtqhzUI2NSDXUtxbhBBttc5fkDMCapfDVvELZFK8v72ARFHJlJ8T80KHfc3rNQ6fxjq64CWmSuU7wU01w08sMxafgi9poajK48NA9BrDN3D61B9Vkw6wNRwoJvCeKNQE2TzFyJfQPqlMK4f9lE+IwU5eNTOlymRR7kyYNovkGI58qWdhq2J9CRfewSpUnnjbvf8t8QTIkhFuFJFNZV7uOAG0kl8nwOCuoAko5qnmEH7dtuLUdblPV6yltbHV00BqJIDplP76PUXdQTlgG4Uo6a9FCyv1Ov/NrPJROjcGQcdjpwbR1tlzalYG28x+CsU+NcjgegvuDEz95aWFdq4DCVub5GLJuT163j/bWBVF+vJqXyuc++yxIRaKvtKA54iffDeYtipw/HumTGxQ5dr9ObLBmeNX43hvzB0QUieGI1dCqgPQIzyD0PJbwnL/WMk8Pt1CyPsx4UiDudXHekYDujOln10ln8zDDWk+i8dHPBKs3jgqYFl4ZTKPQ60RzxgGo7/58cIREU1ubK+6bHUtdRKpfrIR4fdbRWKGXmrZc38DiwAY2tYLUvCQNSk3tZWphnDDzMDte/VhWZv08/OXsVVNJXS6R6Zwq9RBuhqXQh/sQsf8g0Ps+yXXXwBIJX5ERsBoBrCSl4/8ZrCOJfb6isf+hh0eksUu4+s5k5DPN50DDQ/wbu96R9hG4lK8oB+p39y+jNeF1fw0CjHRUe7nyrWMkE2CzwN8T4hq2P/f7xTyWvs7Tjnpmxuq6kcC0Bq9d+9/EWeol93wyBgRjdrtHFs9Vqx6EoggZt/DI2+Jsq770buBKvGrFaVZnHMyyx+w0fyqGAG3z6aLdh3ZIh25zTqumUxHudZU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eedf162f-3f50-43a6-17af-08db18d3406c
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2023 14:59:40.0735
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bKGRLFh431mFgzGxFm2GhMvvZrb2z4tv29A/zTpJAuiSJY5QPJhS1ctoMadFVf3P/i5W0UhRKzviNuiUNECY7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6261
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-27_10,2023-02-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302270114
X-Proofpoint-GUID: Hp8XmpF-Bhrh5B0v-NczCcI7_z6h6T2u
X-Proofpoint-ORIG-GUID: Hp8XmpF-Bhrh5B0v-NczCcI7_z6h6T2u
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 27, 2023, at 4:24 AM, Hannes Reinecke <hare@suse.de> wrote:
>=20
> On 2/24/23 20:19, Chuck Lever wrote:
>> From: Chuck Lever <chuck.lever@oracle.com>
>> When a kernel consumer needs a transport layer security session, it
>> first needs a handshake to negotiate and establish a session. This
>> negotiation can be done in user space via one of the several
>> existing library implementations, or it can be done in the kernel.
>> No in-kernel handshake implementations yet exist. In their absence,
>> we add a netlink service that can:
>> a. Notify a user space daemon that a handshake is needed.
>> b. Once notified, the daemon calls the kernel back via this
>>    netlink service to get the handshake parameters, including an
>>    open socket on which to establish the session.
>> c. Once the handshake is complete, the daemon reports the
>>    session status and other information via a second netlink
>>    operation. This operation marks that it is safe for the
>>    kernel to use the open socket and the security session
>>    established there.
>> The notification service uses a multicast group. Each handshake
>> mechanism (eg, tlshd) adopts its own group number so that the
>> handshake services are completely independent of one another. The
>> kernel can then tell via netlink_has_listeners() whether a handshake
>> service is active and prepared to handle a handshake request.
>> A new netlink operation, ACCEPT, acts like accept(2) in that it
>> instantiates a file descriptor in the user space daemon's fd table.
>> If this operation is successful, the reply carries the fd number,
>> which can be treated as an open and ready file descriptor.
>> While user space is performing the handshake, the kernel keeps its
>> muddy paws off the open socket. A second new netlink operation,
>> DONE, indicates that the user space daemon is finished with the
>> socket and it is safe for the kernel to use again. The operation
>> also indicates whether a session was established successfully.
>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>> ---
>>  Documentation/netlink/specs/handshake.yaml |  134 +++++++++++
>>  include/net/handshake.h                    |   45 ++++
>>  include/net/net_namespace.h                |    5
>>  include/net/sock.h                         |    1
>>  include/trace/events/handshake.h           |  159 +++++++++++++
>>  include/uapi/linux/handshake.h             |   63 +++++
>>  net/Makefile                               |    1
>>  net/handshake/Makefile                     |   11 +
>>  net/handshake/handshake.h                  |   41 +++
>>  net/handshake/netlink.c                    |  340 +++++++++++++++++++++=
+++++++
>>  net/handshake/request.c                    |  246 ++++++++++++++++++++
>>  net/handshake/trace.c                      |   17 +
>>  12 files changed, 1063 insertions(+)
>>  create mode 100644 Documentation/netlink/specs/handshake.yaml
>>  create mode 100644 include/net/handshake.h
>>  create mode 100644 include/trace/events/handshake.h
>>  create mode 100644 include/uapi/linux/handshake.h
>>  create mode 100644 net/handshake/Makefile
>>  create mode 100644 net/handshake/handshake.h
>>  create mode 100644 net/handshake/netlink.c
>>  create mode 100644 net/handshake/request.c
>>  create mode 100644 net/handshake/trace.c
>> diff --git a/Documentation/netlink/specs/handshake.yaml b/Documentation/=
netlink/specs/handshake.yaml
>> new file mode 100644
>> index 000000000000..683a8f2df0a7
>> --- /dev/null
>> +++ b/Documentation/netlink/specs/handshake.yaml
>> @@ -0,0 +1,134 @@
>> +# SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
>> +#
>> +# GENL HANDSHAKE service.
>> +#
>> +# Author: Chuck Lever <chuck.lever@oracle.com>
>> +#
>> +# Copyright (c) 2023, Oracle and/or its affiliates.
>> +#
>> +
>> +name: handshake
>> +
>> +protocol: genetlink-c
>> +
>> +doc: Netlink protocol to request a transport layer security handshake.
>> +
>> +uapi-header: linux/net/handshake.h
>> +
>> +definitions:
>> +  -
>> +    type: enum
>> +    name: handler-class
>> +    enum-name:
>> +    value-start: 0
>> +    entries: [ none ]
>> +  -
>> +    type: enum
>> +    name: msg-type
>> +    enum-name:
>> +    value-start: 0
>> +    entries: [ unspec, clienthello, serverhello ]
>> +  -
>> +    type: enum
>> +    name: auth
>> +    enum-name:
>> +    value-start: 0
>> +    entries: [ unspec, unauth, x509, psk ]
>> +
>> +attribute-sets:
>> +  -
>> +    name: accept
>> +    attributes:
>> +      -
>> +        name: status
>> +        doc: Status of this accept operation
>> +        type: u32
>> +        value: 1
>> +      -
>> +        name: sockfd
>> +        doc: File descriptor of socket to use
>> +        type: u32
>> +      -
>> +        name: handler-class
>> +        doc: Which type of handler is responding
>> +        type: u32
>> +        enum: handler-class
>> +      -
>> +        name: message-type
>> +        doc: Handshake message type
>> +        type: u32
>> +        enum: msg-type
>> +      -
>> +        name: auth
>> +        doc: Authentication mode
>> +        type: u32
>> +        enum: auth
>> +      -
>> +        name: gnutls-priorities
>> +        doc: GnuTLS priority string
>> +        type: string
>> +      -
>> +        name: my-peerid
>> +        doc: Serial no of key containing local identity
>> +        type: u32
>> +      -
>> +        name: my-privkey
>> +        doc: Serial no of key containing optional private key
>> +        type: u32
>> +  -
>> +    name: done
>> +    attributes:
>> +      -
>> +        name: status
>> +        doc: Session status
>> +        type: u32
>> +        value: 1
>> +      -
>> +        name: sockfd
>> +        doc: File descriptor of socket that has completed
>> +        type: u32
>> +      -
>> +        name: remote-peerid
>> +        doc: Serial no of keys containing identities of remote peer
>> +        type: u32
>> +
>> +operations:
>> +  list:
>> +    -
>> +      name: ready
>> +      doc: Notify handlers that a new handshake request is waiting
>> +      value: 1
>> +      notify: accept
>> +    -
>> +      name: accept
>> +      doc: Handler retrieves next queued handshake request
>> +      attribute-set: accept
>> +      flags: [ admin-perm ]
>> +      do:
>> +        request:
>> +          attributes:
>> +            - handler-class
>> +        reply:
>> +          attributes:
>> +            - status
>> +            - sockfd
>> +            - message-type
>> +            - auth
>> +            - gnutls-priorities
>> +            - my-peerid
>> +            - my-privkey
>> +    -
>> +      name: done
>> +      doc: Handler reports handshake completion
>> +      attribute-set: done
>> +      do:
>> +        request:
>> +          attributes:
>> +            - status
>> +            - sockfd
>> +            - remote-peerid
>> +
>> +mcast-groups:
>> +  list:
>> +    -
>> +      name: none
>> diff --git a/include/net/handshake.h b/include/net/handshake.h
>> new file mode 100644
>> index 000000000000..08f859237936
>> --- /dev/null
>> +++ b/include/net/handshake.h
>> @@ -0,0 +1,45 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Generic HANDSHAKE service.
>> + *
>> + * Author: Chuck Lever <chuck.lever@oracle.com>
>> + *
>> + * Copyright (c) 2023, Oracle and/or its affiliates.
>> + */
>> +
>> +/*
>> + * Data structures and functions that are visible only within the
>> + * kernel are declared here.
>> + */
>> +
>> +#ifndef _NET_HANDSHAKE_H
>> +#define _NET_HANDSHAKE_H
>> +
>> +struct handshake_req;
>> +
>> +/*
>> + * Invariants for all handshake requests for one transport layer
>> + * security protocol
>> + */
>> +struct handshake_proto {
>> +	int			hp_handler_class;
>> +	size_t			hp_privsize;
>> +
>> +	int			(*hp_accept)(struct handshake_req *req,
>> +					     struct genl_info *gi, int fd);
>> +	void			(*hp_done)(struct handshake_req *req,
>> +					   int status, struct nlattr **tb);
>> +	void			(*hp_destroy)(struct handshake_req *req);
>> +};
>> +
>> +extern struct handshake_req *
>> +handshake_req_alloc(struct socket *sock, const struct handshake_proto *=
proto,
>> +		    gfp_t flags);
>> +extern void *handshake_req_private(struct handshake_req *req);
>> +extern int handshake_req_submit(struct handshake_req *req, gfp_t flags)=
;
>> +extern int handshake_req_cancel(struct socket *sock);
>> +
>> +extern struct nlmsghdr *handshake_genl_put(struct sk_buff *msg,
>> +					   struct genl_info *gi);
>> +
>> +#endif /* _NET_HANDSHAKE_H */
>> diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
>> index 78beaa765c73..a0ce9de4dab1 100644
>> --- a/include/net/net_namespace.h
>> +++ b/include/net/net_namespace.h
>> @@ -188,6 +188,11 @@ struct net {
>>  #if IS_ENABLED(CONFIG_SMC)
>>  	struct netns_smc	smc;
>>  #endif
>> +
>> +	/* transport layer security handshake requests */
>> +	spinlock_t		hs_lock;
>> +	struct list_head	hs_requests;
>> +	int			hs_pending;
>>  } __randomize_layout;
>>    #include <linux/seq_file_net.h>
>> diff --git a/include/net/sock.h b/include/net/sock.h
>> index 573f2bf7e0de..2a7345ce2540 100644
>> --- a/include/net/sock.h
>> +++ b/include/net/sock.h
>> @@ -519,6 +519,7 @@ struct sock {
>>    	struct socket		*sk_socket;
>>  	void			*sk_user_data;
>> +	void			*sk_handshake_req;
>>  #ifdef CONFIG_SECURITY
>>  	void			*sk_security;
>>  #endif
>> diff --git a/include/trace/events/handshake.h b/include/trace/events/han=
dshake.h
>> new file mode 100644
>> index 000000000000..feffcd1d6256
>> --- /dev/null
>> +++ b/include/trace/events/handshake.h
>> @@ -0,0 +1,159 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#undef TRACE_SYSTEM
>> +#define TRACE_SYSTEM handshake
>> +
>> +#if !defined(_TRACE_HANDSHAKE_H) || defined(TRACE_HEADER_MULTI_READ)
>> +#define _TRACE_HANDSHAKE_H
>> +
>> +#include <linux/net.h>
>> +#include <linux/tracepoint.h>
>> +
>> +DECLARE_EVENT_CLASS(handshake_event_class,
>> +	TP_PROTO(
>> +		const struct net *net,
>> +		const struct handshake_req *req,
>> +		const struct socket *sock
>> +	),
>> +	TP_ARGS(net, req, sock),
>> +	TP_STRUCT__entry(
>> +		__field(const void *, req)
>> +		__field(const void *, sock)
>> +		__field(unsigned int, netns_ino)
>> +	),
>> +	TP_fast_assign(
>> +		__entry->req =3D req;
>> +		__entry->sock =3D sock;
>> +		__entry->netns_ino =3D net->ns.inum;
>> +	),
>> +	TP_printk("req=3D%p sock=3D%p",
>> +		__entry->req, __entry->sock
>> +	)
>> +);
>> +#define DEFINE_HANDSHAKE_EVENT(name)				\
>> +	DEFINE_EVENT(handshake_event_class, name,		\
>> +		TP_PROTO(					\
>> +			const struct net *net,			\
>> +			const struct handshake_req *req,	\
>> +			const struct socket *sock		\
>> +		),						\
>> +		TP_ARGS(net, req, sock))
>> +
>> +DECLARE_EVENT_CLASS(handshake_fd_class,
>> +	TP_PROTO(
>> +		const struct net *net,
>> +		const struct handshake_req *req,
>> +		const struct socket *sock,
>> +		int fd
>> +	),
>> +	TP_ARGS(net, req, sock, fd),
>> +	TP_STRUCT__entry(
>> +		__field(const void *, req)
>> +		__field(const void *, sock)
>> +		__field(int, fd)
>> +		__field(unsigned int, netns_ino)
>> +	),
>> +	TP_fast_assign(
>> +		__entry->req =3D req;
>> +		__entry->sock =3D req->hr_sock;
>> +		__entry->fd =3D fd;
>> +		__entry->netns_ino =3D net->ns.inum;
>> +	),
>> +	TP_printk("req=3D%p sock=3D%p fd=3D%d",
>> +		__entry->req, __entry->sock, __entry->fd
>> +	)
>> +);
>> +#define DEFINE_HANDSHAKE_FD_EVENT(name)				\
>> +	DEFINE_EVENT(handshake_fd_class, name,			\
>> +		TP_PROTO(					\
>> +			const struct net *net,			\
>> +			const struct handshake_req *req,	\
>> +			const struct socket *sock,		\
>> +			int fd					\
>> +		),						\
>> +		TP_ARGS(net, req, sock, fd))
>> +
>> +DECLARE_EVENT_CLASS(handshake_error_class,
>> +	TP_PROTO(
>> +		const struct net *net,
>> +		const struct handshake_req *req,
>> +		const struct socket *sock,
>> +		int err
>> +	),
>> +	TP_ARGS(net, req, sock, err),
>> +	TP_STRUCT__entry(
>> +		__field(const void *, req)
>> +		__field(const void *, sock)
>> +		__field(int, err)
>> +		__field(unsigned int, netns_ino)
>> +	),
>> +	TP_fast_assign(
>> +		__entry->req =3D req;
>> +		__entry->sock =3D sock;
>> +		__entry->err =3D err;
>> +		__entry->netns_ino =3D net->ns.inum;
>> +	),
>> +	TP_printk("req=3D%p sock=3D%p err=3D%d",
>> +		__entry->req, __entry->sock, __entry->err
>> +	)
>> +);
>> +#define DEFINE_HANDSHAKE_ERROR(name)				\
>> +	DEFINE_EVENT(handshake_error_class, name,		\
>> +		TP_PROTO(					\
>> +			const struct net *net,			\
>> +			const struct handshake_req *req,	\
>> +			const struct socket *sock,		\
>> +			int err					\
>> +		),						\
>> +		TP_ARGS(net, req, sock, err))
>> +
>> +
>> +/**
>> + ** Request lifetime events
>> + **/
>> +
>> +DEFINE_HANDSHAKE_EVENT(handshake_submit);
>> +DEFINE_HANDSHAKE_ERROR(handshake_submit_err);
>> +DEFINE_HANDSHAKE_EVENT(handshake_cancel);
>> +DEFINE_HANDSHAKE_EVENT(handshake_cancel_none);
>> +DEFINE_HANDSHAKE_EVENT(handshake_cancel_busy);
>> +DEFINE_HANDSHAKE_EVENT(handshake_destruct);
>> +
>> +
>> +TRACE_EVENT(handshake_complete,
>> +	TP_PROTO(
>> +		const struct net *net,
>> +		const struct handshake_req *req,
>> +		const struct socket *sock,
>> +		int status
>> +	),
>> +	TP_ARGS(net, req, sock, status),
>> +	TP_STRUCT__entry(
>> +		__field(const void *, req)
>> +		__field(const void *, sock)
>> +		__field(int, status)
>> +		__field(unsigned int, netns_ino)
>> +	),
>> +	TP_fast_assign(
>> +		__entry->req =3D req;
>> +		__entry->sock =3D sock;
>> +		__entry->status =3D status;
>> +		__entry->netns_ino =3D net->ns.inum;
>> +	),
>> +	TP_printk("req=3D%p sock=3D%p status=3D%d",
>> +		__entry->req, __entry->sock, __entry->status
>> +	)
>> +);
>> +
>> +/**
>> + ** Netlink events
>> + **/
>> +
>> +DEFINE_HANDSHAKE_ERROR(handshake_notify_err);
>> +DEFINE_HANDSHAKE_FD_EVENT(handshake_cmd_accept);
>> +DEFINE_HANDSHAKE_ERROR(handshake_cmd_accept_err);
>> +DEFINE_HANDSHAKE_FD_EVENT(handshake_cmd_done);
>> +DEFINE_HANDSHAKE_ERROR(handshake_cmd_done_err);
>> +
>> +#endif /* _TRACE_HANDSHAKE_H */
>> +
>> +#include <trace/define_trace.h>
>> diff --git a/include/uapi/linux/handshake.h b/include/uapi/linux/handsha=
ke.h
>> new file mode 100644
>> index 000000000000..09fd7c37cba4
>> --- /dev/null
>> +++ b/include/uapi/linux/handshake.h
>> @@ -0,0 +1,63 @@
>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>> +/* Do not edit directly, auto-generated from: */
>> +/*	Documentation/netlink/specs/handshake.yaml */
>> +/* YNL-GEN uapi header */
>> +
>> +#ifndef _UAPI_LINUX_HANDSHAKE_H
>> +#define _UAPI_LINUX_HANDSHAKE_H
>> +
>> +#define HANDSHAKE_FAMILY_NAME		"handshake"
>> +#define HANDSHAKE_FAMILY_VERSION	1
>> +
>> +enum {
>> +	HANDSHAKE_HANDLER_CLASS_NONE,
>> +};
>> +
>> +enum {
>> +	HANDSHAKE_MSG_TYPE_UNSPEC,
>> +	HANDSHAKE_MSG_TYPE_CLIENTHELLO,
>> +	HANDSHAKE_MSG_TYPE_SERVERHELLO,
>> +};
>> +
>> +enum {
>> +	HANDSHAKE_AUTH_UNSPEC,
>> +	HANDSHAKE_AUTH_UNAUTH,
>> +	HANDSHAKE_AUTH_X509,
>> +	HANDSHAKE_AUTH_PSK,
>> +};
>> +
>> +enum {
>> +	HANDSHAKE_A_ACCEPT_STATUS =3D 1,
>> +	HANDSHAKE_A_ACCEPT_SOCKFD,
>> +	HANDSHAKE_A_ACCEPT_HANDLER_CLASS,
>> +	HANDSHAKE_A_ACCEPT_MESSAGE_TYPE,
>> +	HANDSHAKE_A_ACCEPT_AUTH,
>> +	HANDSHAKE_A_ACCEPT_GNUTLS_PRIORITIES,
>> +	HANDSHAKE_A_ACCEPT_MY_PEERID,
>> +	HANDSHAKE_A_ACCEPT_MY_PRIVKEY,
>> +
>> +	__HANDSHAKE_A_ACCEPT_MAX,
>> +	HANDSHAKE_A_ACCEPT_MAX =3D (__HANDSHAKE_A_ACCEPT_MAX - 1)
>> +};
>> +
>> +enum {
>> +	HANDSHAKE_A_DONE_STATUS =3D 1,
>> +	HANDSHAKE_A_DONE_SOCKFD,
>> +	HANDSHAKE_A_DONE_REMOTE_PEERID,
>> +
>> +	__HANDSHAKE_A_DONE_MAX,
>> +	HANDSHAKE_A_DONE_MAX =3D (__HANDSHAKE_A_DONE_MAX - 1)
>> +};
>> +
>> +enum {
>> +	HANDSHAKE_CMD_READY =3D 1,
>> +	HANDSHAKE_CMD_ACCEPT,
>> +	HANDSHAKE_CMD_DONE,
>> +
>> +	__HANDSHAKE_CMD_MAX,
>> +	HANDSHAKE_CMD_MAX =3D (__HANDSHAKE_CMD_MAX - 1)
>> +};
>> +
>> +#define HANDSHAKE_MCGRP_NONE	"none"
>> +
>> +#endif /* _UAPI_LINUX_HANDSHAKE_H */
>> diff --git a/net/Makefile b/net/Makefile
>> index 0914bea9c335..adbb64277601 100644
>> --- a/net/Makefile
>> +++ b/net/Makefile
>> @@ -79,3 +79,4 @@ obj-$(CONFIG_NET_NCSI)		+=3D ncsi/
>>  obj-$(CONFIG_XDP_SOCKETS)	+=3D xdp/
>>  obj-$(CONFIG_MPTCP)		+=3D mptcp/
>>  obj-$(CONFIG_MCTP)		+=3D mctp/
>> +obj-y				+=3D handshake/
>> diff --git a/net/handshake/Makefile b/net/handshake/Makefile
>> new file mode 100644
>> index 000000000000..a41b03f4837b
>> --- /dev/null
>> +++ b/net/handshake/Makefile
>> @@ -0,0 +1,11 @@
>> +# SPDX-License-Identifier: GPL-2.0-only
>> +#
>> +# Makefile for the Generic HANDSHAKE service
>> +#
>> +# Author: Chuck Lever <chuck.lever@oracle.com>
>> +#
>> +# Copyright (c) 2023, Oracle and/or its affiliates.
>> +#
>> +
>> +obj-y +=3D handshake.o
>> +handshake-y :=3D netlink.o request.o trace.o
>> diff --git a/net/handshake/handshake.h b/net/handshake/handshake.h
>> new file mode 100644
>> index 000000000000..366c7659ec09
>> --- /dev/null
>> +++ b/net/handshake/handshake.h
>> @@ -0,0 +1,41 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Generic netlink handshake service
>> + *
>> + * Author: Chuck Lever <chuck.lever@oracle.com>
>> + *
>> + * Copyright (c) 2023, Oracle and/or its affiliates.
>> + */
>> +
>> +/*
>> + * Data structures and functions that are visible only within the
>> + * handshake module are declared here.
>> + */
>> +
>> +#ifndef _INTERNAL_HANDSHAKE_H
>> +#define _INTERNAL_HANDSHAKE_H
>> +
>> +/*
>> + * One handshake request
>> + */
>> +struct handshake_req {
>> +	struct list_head		hr_list;
>> +	unsigned long			hr_flags;
>> +	const struct handshake_proto	*hr_proto;
>> +	struct socket			*hr_sock;
>> +
>> +	void				(*hr_saved_destruct)(struct sock *sk);
>> +};
>> +
>> +#define HANDSHAKE_F_COMPLETED	BIT(0)
>> +
>> +/* netlink.c */
>> +extern bool handshake_genl_inited;
>> +int handshake_genl_notify(struct net *net, int handler_class, gfp_t fla=
gs);
>> +
>> +/* request.c */
>> +void __remove_pending_locked(struct net *net, struct handshake_req *req=
);
>> +void handshake_complete(struct handshake_req *req, int status,
>> +			struct nlattr **tb);
>> +
>> +#endif /* _INTERNAL_HANDSHAKE_H */
>> diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
>> new file mode 100644
>> index 000000000000..581e382236cf
>> --- /dev/null
>> +++ b/net/handshake/netlink.c
>> @@ -0,0 +1,340 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Generic netlink handshake service
>> + *
>> + * Author: Chuck Lever <chuck.lever@oracle.com>
>> + *
>> + * Copyright (c) 2023, Oracle and/or its affiliates.
>> + */
>> +
>> +#include <linux/types.h>
>> +#include <linux/socket.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/skbuff.h>
>> +#include <linux/inet.h>
>> +
>> +#include <net/sock.h>
>> +#include <net/genetlink.h>
>> +#include <net/handshake.h>
>> +
>> +#include <uapi/linux/handshake.h>
>> +#include <trace/events/handshake.h>
>> +#include "handshake.h"
>> +
>> +static struct genl_family __ro_after_init handshake_genl_family;
>> +bool handshake_genl_inited;
>> +
>> +/**
>> + * handshake_genl_notify - Notify handlers that a request is waiting
>> + * @net: target network namespace
>> + * @handler_class: target handler
>> + * @flags: memory allocation control flags
>> + *
>> + * Returns zero on success or a negative errno if notification failed.
>> + */
>> +int handshake_genl_notify(struct net *net, int handler_class, gfp_t fla=
gs)
>> +{
>> +	struct sk_buff *msg;
>> +	void *hdr;
>> +
>> +	if (!genl_has_listeners(&handshake_genl_family, net, handler_class))
>> +		return -ESRCH;
>> +
>> +	msg =3D genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
>> +	if (!msg)
>> +		return -ENOMEM;
>> +
>> +	hdr =3D genlmsg_put(msg, 0, 0, &handshake_genl_family, 0,
>> +			  HANDSHAKE_CMD_READY);
>> +	if (!hdr)
>> +		goto out_free;
>> +
>> +	if (nla_put_u32(msg, HANDSHAKE_A_ACCEPT_HANDLER_CLASS,
>> +			handler_class) < 0) {
>> +		genlmsg_cancel(msg, hdr);
>> +		goto out_free;
>> +	}
>> +
>> +	genlmsg_end(msg, hdr);
>> +	return genlmsg_multicast_netns(&handshake_genl_family, net, msg,
>> +				       0, handler_class, flags);
>> +
>> +out_free:
>> +	nlmsg_free(msg);
>> +	return -EMSGSIZE;
>> +}
>> +
>> +/**
>> + * handshake_genl_put - Create a generic netlink message header
>> + * @msg: buffer in which to create the header
>> + * @gi: generic netlink message context
>> + *
>> + * Returns a ready-to-use header, or NULL.
>> + */
>> +struct nlmsghdr *handshake_genl_put(struct sk_buff *msg, struct genl_in=
fo *gi)
>> +{
>> +	return genlmsg_put(msg, gi->snd_portid, gi->snd_seq,
>> +			   &handshake_genl_family, 0, gi->genlhdr->cmd);
>> +}
>> +EXPORT_SYMBOL(handshake_genl_put);
>> +
>> +static int handshake_status_reply(struct sk_buff *skb, struct genl_info=
 *gi,
>> +				  int status)
>> +{
>> +	struct nlmsghdr *hdr;
>> +	struct sk_buff *msg;
>> +	int ret;
>> +
>> +	ret =3D -ENOMEM;
>> +	msg =3D genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
>> +	if (!msg)
>> +		goto out;
>> +	hdr =3D handshake_genl_put(msg, gi);
>> +	if (!hdr)
>> +		goto out_free;
>> +
>> +	ret =3D -EMSGSIZE;
>> +	ret =3D nla_put_u32(msg, HANDSHAKE_A_ACCEPT_STATUS, status);
>> +	if (ret < 0)
>> +		goto out_free;
>> +
>> +	genlmsg_end(msg, hdr);
>> +	return genlmsg_reply(msg, gi);
>> +
>> +out_free:
>> +	genlmsg_cancel(msg, hdr);
>> +out:
>> +	return ret;
>> +}
>> +
>> +/*
>> + * dup() a kernel socket for use as a user space file descriptor
>> + * in the current process.
>> + *
>> + * Implicit argument: "current()"
>> + */
>> +static int handshake_dup(struct socket *kernsock)
>> +{
>> +	struct file *file =3D get_file(kernsock->file);
>> +	int newfd;
>> +
>> +	newfd =3D get_unused_fd_flags(O_CLOEXEC);
>> +	if (newfd < 0) {
>> +		fput(file);
>> +		return newfd;
>> +	}
>> +
>> +	fd_install(newfd, file);
>> +	return newfd;
>> +}
>> +
>> +static const struct nla_policy
>> +handshake_accept_nl_policy[HANDSHAKE_A_ACCEPT_HANDLER_CLASS + 1] =3D {
>> +	[HANDSHAKE_A_ACCEPT_HANDLER_CLASS] =3D { .type =3D NLA_U32, },
>> +};
>> +
>> +static int handshake_nl_accept_doit(struct sk_buff *skb, struct genl_in=
fo *gi)
>> +{
>> +	struct nlattr *tb[HANDSHAKE_A_ACCEPT_MAX + 1];
>> +	struct net *net =3D sock_net(skb->sk);
>> +	struct handshake_req *pos, *req;
>> +	int fd, err;
>> +
>> +	err =3D -EINVAL;
>> +	if (genlmsg_parse(nlmsg_hdr(skb), &handshake_genl_family, tb,
>> +			  HANDSHAKE_A_ACCEPT_HANDLER_CLASS,
>> +			  handshake_accept_nl_policy, NULL))
>> +		goto out_status;
>> +	if (!tb[HANDSHAKE_A_ACCEPT_HANDLER_CLASS])
>> +		goto out_status;
>> +
>> +	req =3D NULL;
>> +	spin_lock(&net->hs_lock);
>> +	list_for_each_entry(pos, &net->hs_requests, hr_list) {
>> +		if (pos->hr_proto->hp_handler_class !=3D
>> +		    nla_get_u32(tb[HANDSHAKE_A_ACCEPT_HANDLER_CLASS]))
>> +			continue;
>> +		__remove_pending_locked(net, pos);
>> +		req =3D pos;
>> +		break;
>> +	}
>> +	spin_unlock(&net->hs_lock);
>> +	if (!req)
>> +		goto out_status;
>> +
>> +	fd =3D handshake_dup(req->hr_sock);
>> +	if (fd < 0) {
>> +		err =3D fd;
>> +		goto out_complete;
>> +	}
>> +	err =3D req->hr_proto->hp_accept(req, gi, fd);
>> +	if (err)
>> +		goto out_complete;
>> +
>> +	trace_handshake_cmd_accept(net, req, req->hr_sock, fd);
>> +	return 0;
>> +
>> +out_complete:
>> +	handshake_complete(req, -EIO, NULL);
>> +	fput(req->hr_sock->file);
>> +out_status:
>> +	trace_handshake_cmd_accept_err(net, req, NULL, err);
>> +	return handshake_status_reply(skb, gi, err);
>> +}
>> +
>> +static const struct nla_policy
>> +handshake_done_nl_policy[HANDSHAKE_A_DONE_MAX + 1] =3D {
>> +	[HANDSHAKE_A_DONE_SOCKFD] =3D { .type =3D NLA_U32, },
>> +	[HANDSHAKE_A_DONE_STATUS] =3D { .type =3D NLA_U32, },
>> +	[HANDSHAKE_A_DONE_REMOTE_PEERID] =3D { .type =3D NLA_U32, },
>> +};
>> +
>> +static int handshake_nl_done_doit(struct sk_buff *skb, struct genl_info=
 *gi)
>> +{
>> +	struct nlattr *tb[HANDSHAKE_A_DONE_MAX + 1];
>> +	struct net *net =3D sock_net(skb->sk);
>> +	struct socket *sock =3D NULL;
>> +	struct handshake_req *req;
>> +	int fd, status, err;
>> +
>> +	err =3D genlmsg_parse(nlmsg_hdr(skb), &handshake_genl_family, tb,
>> +			    HANDSHAKE_A_DONE_MAX, handshake_done_nl_policy,
>> +			    NULL);
>> +	if (err || !tb[HANDSHAKE_A_DONE_SOCKFD]) {
>> +		err =3D -EINVAL;
>> +		goto out_status;
>> +	}
>> +
>> +	fd =3D nla_get_u32(tb[HANDSHAKE_A_DONE_SOCKFD]);
>> +
>> +	err =3D 0;
>> +	sock =3D sockfd_lookup(fd, &err);
>> +	if (err) {
>> +		err =3D -EBADF;
>> +		goto out_status;
>> +	}
>> +
>> +	req =3D sock->sk->sk_handshake_req;
>> +	if (!req) {
>> +		err =3D -EBUSY;
>> +		goto out_status;
>> +	}
>> +
>> +	trace_handshake_cmd_done(net, req, sock, fd);
>> +
>> +	status =3D -EIO;
>> +	if (tb[HANDSHAKE_A_DONE_STATUS])
>> +		status =3D nla_get_u32(tb[HANDSHAKE_A_DONE_STATUS]);
>> +
> And this makes me ever so slightly uneasy.
>=20
> As 'status' is a netlink attribute it's inevitably defined as 'unsigned'.
> Yet we assume that 'status' is a negative number, leaving us _technically=
_ in unchartered territory.

Ah, that's an oversight.


> And that is notwithstanding the problem that we haven't even defined _wha=
t_ should be in the status attribute.

It's now an errno value.


> Reading the code I assume that it's either '0' for success or a negative =
number (ie the error code) on failure.
> Which implicitely means that we _never_ set a positive number here.
> So what would we lose if we declare 'status' to carry the _positive_ erro=
r number instead?
> It would bring us in-line with the actual netlink attribute definition, w=
e wouldn't need to worry about possible integer overflows, yadda yadda...
>=20
> Hmm?

It can also be argued that errnos in user space are positive-valued,
therefore, this user space visible protocol should use a positive
errno.


>> +	handshake_complete(req, status, tb);
>> +	fput(sock->file);
>> +	return 0;
>> +
>> +out_status:
>> +	trace_handshake_cmd_done_err(net, req, sock, err);
>> +	return handshake_status_reply(skb, gi, err);
>> +}
>> +
>> +static const struct genl_split_ops handshake_nl_ops[] =3D {
>> +	{
>> +		.cmd		=3D HANDSHAKE_CMD_ACCEPT,
>> +		.doit		=3D handshake_nl_accept_doit,
>> +		.policy		=3D handshake_accept_nl_policy,
>> +		.maxattr	=3D HANDSHAKE_A_ACCEPT_HANDLER_CLASS,
>> +		.flags		=3D GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
>> +	},
>> +	{
>> +		.cmd		=3D HANDSHAKE_CMD_DONE,
>> +		.doit		=3D handshake_nl_done_doit,
>> +		.policy		=3D handshake_done_nl_policy,
>> +		.maxattr	=3D HANDSHAKE_A_DONE_REMOTE_PEERID,
>> +		.flags		=3D GENL_CMD_CAP_DO,
>> +	},
>> +};
>> +
>> +static const struct genl_multicast_group handshake_nl_mcgrps[] =3D {
>> +	[HANDSHAKE_HANDLER_CLASS_NONE] =3D { .name =3D HANDSHAKE_MCGRP_NONE, }=
,
>> +};
>> +
>> +static struct genl_family __ro_after_init handshake_genl_family =3D {
>> +	.hdrsize		=3D 0,
>> +	.name			=3D HANDSHAKE_FAMILY_NAME,
>> +	.version		=3D HANDSHAKE_FAMILY_VERSION,
>> +	.netnsok		=3D true,
>> +	.parallel_ops		=3D true,
>> +	.n_mcgrps		=3D ARRAY_SIZE(handshake_nl_mcgrps),
>> +	.n_split_ops		=3D ARRAY_SIZE(handshake_nl_ops),
>> +	.split_ops		=3D handshake_nl_ops,
>> +	.mcgrps			=3D handshake_nl_mcgrps,
>> +	.module			=3D THIS_MODULE,
>> +};
>> +
>> +static int __net_init handshake_net_init(struct net *net)
>> +{
>> +	spin_lock_init(&net->hs_lock);
>> +	INIT_LIST_HEAD(&net->hs_requests);
>> +	net->hs_pending	=3D 0;
>> +	return 0;
>> +}
>> +
>> +static void __net_exit handshake_net_exit(struct net *net)
>> +{
>> +	struct handshake_req *req;
>> +	LIST_HEAD(requests);
>> +
>> +	/*
>> +	 * This drains the net's pending list. Requests that
>> +	 * have been accepted and are in progress will be
>> +	 * destroyed when the socket is closed.
>> +	 */
>> +	spin_lock(&net->hs_lock);
>> +	list_splice_init(&requests, &net->hs_requests);
>> +	spin_unlock(&net->hs_lock);
>> +
>> +	while (!list_empty(&requests)) {
>> +		req =3D list_first_entry(&requests, struct handshake_req, hr_list);
>> +		list_del(&req->hr_list);
>> +
>> +		/*
>> +		 * Requests on this list have not yet been
>> +		 * accepted, so they do not have an fd to put.
>> +		 */
>> +
>> +		handshake_complete(req, -ETIMEDOUT, NULL);
>> +	}
>> +}
>> +
>> +static struct pernet_operations handshake_genl_net_ops =3D {
>> +	.init		=3D handshake_net_init,
>> +	.exit		=3D handshake_net_exit,
>> +};
>> +
>> +static int __init handshake_init(void)
>> +{
>> +	int ret;
>> +
>> +	ret =3D genl_register_family(&handshake_genl_family);
>> +	if (ret) {
>> +		pr_warn("handshake: netlink registration failed (%d)\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	ret =3D register_pernet_subsys(&handshake_genl_net_ops);
>> +	if (ret) {
>> +		pr_warn("handshake: pernet registration failed (%d)\n", ret);
>> +		genl_unregister_family(&handshake_genl_family);
>> +	}
>> +
>> +	handshake_genl_inited =3D true;
>> +	return ret;
>> +}
>> +
>> +static void __exit handshake_exit(void)
>> +{
>> +	unregister_pernet_subsys(&handshake_genl_net_ops);
>> +	genl_unregister_family(&handshake_genl_family);
>> +}
>> +
>> +module_init(handshake_init);
>> +module_exit(handshake_exit);
>> diff --git a/net/handshake/request.c b/net/handshake/request.c
>> new file mode 100644
>> index 000000000000..1d3b8e76dd2c
>> --- /dev/null
>> +++ b/net/handshake/request.c
>> @@ -0,0 +1,246 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Handshake request lifetime events
>> + *
>> + * Author: Chuck Lever <chuck.lever@oracle.com>
>> + *
>> + * Copyright (c) 2023, Oracle and/or its affiliates.
>> + */
>> +
>> +#include <linux/types.h>
>> +#include <linux/socket.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/skbuff.h>
>> +#include <linux/inet.h>
>> +#include <linux/fdtable.h>
>> +
>> +#include <net/sock.h>
>> +#include <net/genetlink.h>
>> +#include <net/handshake.h>
>> +
>> +#include <uapi/linux/handshake.h>
>> +#include <trace/events/handshake.h>
>> +#include "handshake.h"
>> +
>> +/*
>> + * This limit is to prevent slow remotes from causing denial of service=
.
>> + * A ulimit-style tunable might be used instead.
>> + */
>> +#define HANDSHAKE_PENDING_MAX (10)
>> +
>> +static void __add_pending_locked(struct net *net, struct handshake_req =
*req)
>> +{
>> +	net->hs_pending++;
>> +	list_add_tail(&req->hr_list, &net->hs_requests);
>> +}
>> +
>> +void __remove_pending_locked(struct net *net, struct handshake_req *req=
)
>> +{
>> +	net->hs_pending--;
>> +	list_del_init(&req->hr_list);
>> +}
>> +
>> +/*
>> + * Return values:
>> + *   %true - the request was found on @net's pending list
>> + *   %false - the request was not found on @net's pending list
>> + *
>> + * If @req was on a pending list, it has not yet been accepted.
>> + */
>> +static bool remove_pending(struct net *net, struct handshake_req *req)
>> +{
>> +	bool ret;
>> +
>> +	ret =3D false;
>> +
>> +	spin_lock(&net->hs_lock);
>> +	if (!list_empty(&req->hr_list)) {
>> +		__remove_pending_locked(net, req);
>> +		ret =3D true;
>> +	}
>> +	spin_unlock(&net->hs_lock);
>> +
>> +	return ret;
>> +}
>> +
>> +static void handshake_req_destroy(struct handshake_req *req, struct soc=
k *sk)
>> +{
>> +	req->hr_proto->hp_destroy(req);
>> +	sk->sk_handshake_req =3D NULL;
>> +	kfree(req);
>> +}
>> +
>> +static void handshake_sk_destruct(struct sock *sk)
>> +{
>> +	struct handshake_req *req =3D sk->sk_handshake_req;
>> +
>> +	if (req) {
>> +		trace_handshake_destruct(sock_net(sk), req, req->hr_sock);
>> +		handshake_req_destroy(req, sk);
>> +	}
>> +}
>> +
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
>> +	struct handshake_req *req;
>> +
>> +	/* Avoid accessing uninitialized global variables later on */
>> +	if (!handshake_genl_inited)
>> +		return NULL;
>> +
>> +	req =3D kzalloc(sizeof(*req) + proto->hp_privsize, flags);
>> +	if (!req)
>> +		return NULL;
>> +
>> +	sock_hold(sock->sk);
>> +
>> +	INIT_LIST_HEAD(&req->hr_list);
>> +	req->hr_sock =3D sock;
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
>> +	return (void *)(req + 1);
>> +}
>> +EXPORT_SYMBOL(handshake_req_private);
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
>> + *
>> + * A zero return value from handshake_request() means that
>> + * exactly one subsequent completion callback is guaranteed.
>> + *
>> + * A negative return value from handshake_request() means that
>> + * no completion callback will be done and that @req is
>> + * destroyed.
>> + */
>> +int handshake_req_submit(struct handshake_req *req, gfp_t flags)
>> +{
>> +	struct socket *sock =3D req->hr_sock;
>> +	struct sock *sk =3D sock->sk;
>> +	struct net *net =3D sock_net(sk);
>> +	int ret;
>> +
>> +	ret =3D -EAGAIN;
>> +	if (READ_ONCE(net->hs_pending) >=3D HANDSHAKE_PENDING_MAX)
>> +		goto out_err;
>> +
>> +	ret =3D -EBUSY;
>> +	spin_lock(&net->hs_lock);
>> +	if (sk->sk_handshake_req || !list_empty(&req->hr_list)) {
>> +		spin_unlock(&net->hs_lock);
>> +		goto out_err;
>> +	}
>> +	req->hr_saved_destruct =3D sk->sk_destruct;
>> +	sk->sk_destruct =3D handshake_sk_destruct;
>> +	sk->sk_handshake_req =3D req;
>> +	__add_pending_locked(net, req);
>> +	spin_unlock(&net->hs_lock);
>> +
>> +	ret =3D handshake_genl_notify(net, req->hr_proto->hp_handler_class,
>> +				    flags);
>> +	if (ret) {
>> +		trace_handshake_notify_err(net, req, sock, ret);
>> +		if (remove_pending(net, req))
>> +			goto out_err;
>> +	}
>> +
>> +	trace_handshake_submit(net, req, sock);
>> +	return 0;
>> +
>> +out_err:
>> +	trace_handshake_submit_err(net, req, sock, ret);
>> +	handshake_req_destroy(req, sk);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL(handshake_req_submit);
>> +
>> +void handshake_complete(struct handshake_req *req, int status,
>> +			struct nlattr **tb)
>> +{
>> +	struct socket *sock =3D req->hr_sock;
>> +	struct net *net =3D sock_net(sock->sk);
>> +
>> +	if (!test_and_set_bit(HANDSHAKE_F_COMPLETED, &req->hr_flags)) {
>> +		trace_handshake_complete(net, req, sock, status);
>> +		req->hr_proto->hp_done(req, status, tb);
>> +		__sock_put(sock->sk);
>> +	}
>> +}
>> +
>> +/**
>> + * handshake_req_cancel - consumer API to cancel an in-progress handsha=
ke
>> + * @sock: socket on which there is an ongoing handshake
>> + *
>> + * XXX: Perhaps killing the user space agent might also be necessary?
>=20
> I thought we had agreed that we would be sending a signal to the userspac=
e process?

We had discussed killing the handler, but I don't think it's necessary.
I'd rather not do something that drastic unless we have no other choice.
So far my testing hasn't shown a need for killing the child process.

I'm also concerned that the kernel could reuse the handler's process ID.
handshake_req_cancel would kill something that is not a handshake agent.


> Ideally we would be sending a SIGHUP, wait for some time on the userspace=
 process to respond with a 'done' message, and send a 'KILL' signal if we h=
aven't received one.
>=20
> Obs: Sending a KILL signal would imply that userspace is able to cope wit=
h children dying. Which pretty much excludes pthreads, I would think.
>=20
> Guess I'll have to consult Stevens :-)

Basically what cancel does is atomically disarm the "done" callback.

The socket belongs to the kernel, so it will live until the kernel is
good and through with it.


>> + *
>> + * Request cancellation races with request completion. To determine
>> + * who won, callers examine the return value from this function.
>> + *
>> + * Return values:
>> + *   %0 - Uncompleted handshake request was canceled or not found
>> + *   %-EBUSY - Handshake request already completed
>=20
> EBUSY? Wouldn't be EAGAIN more approriate?

I don't think EAGAIN would be appropriate at all. The situation
is that the handshake completed, so there's no need to call cancel
again. It's synonym, EWOULDBLOCK, is also not a good semantic fit.


> After all, the request is everything _but_ busy...

I'm open to suggestion.

One option is to use a boolean return value instead of an errno.


>> + */
>> +int handshake_req_cancel(struct socket *sock)
>> +{
>> +	struct handshake_req *req;
>> +	struct sock *sk;
>> +	struct net *net;
>> +
>> +	if (!sock)
>> +		return 0;
>> +
>> +	sk =3D sock->sk;
>> +	req =3D sk->sk_handshake_req;
>> +	net =3D sock_net(sk);
>> +
>> +	if (!req) {
>> +		trace_handshake_cancel_none(net, req, sock);
>> +		return 0;
>> +	}
>> +
>> +	if (remove_pending(net, req)) {
>> +		/* Request hadn't been accepted */
>> +		trace_handshake_cancel(net, req, sock);
>> +		return 0;
>> +	}
>> +	if (test_and_set_bit(HANDSHAKE_F_COMPLETED, &req->hr_flags)) {
>> +		/* Request already completed */
>> +		trace_handshake_cancel_busy(net, req, sock);
>> +		return -EBUSY;
>> +	}
>> +
>> +	__sock_put(sk);
>> +	trace_handshake_cancel(net, req, sock);
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(handshake_req_cancel);
>> diff --git a/net/handshake/trace.c b/net/handshake/trace.c
>> new file mode 100644
>> index 000000000000..3a5b6f29a2b8
>> --- /dev/null
>> +++ b/net/handshake/trace.c
>> @@ -0,0 +1,17 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Trace points for transport security layer handshakes.
>> + *
>> + * Author: Chuck Lever <chuck.lever@oracle.com>
>> + *
>> + * Copyright (c) 2023, Oracle and/or its affiliates.
>> + */
>> +
>> +#include <linux/types.h>
>> +#include <net/sock.h>
>> +
>> +#include "handshake.h"
>> +
>> +#define CREATE_TRACE_POINTS
>> +
>> +#include <trace/events/handshake.h>
> Cheers,
>=20
> Hannes
>=20
>=20
>=20

--
Chuck Lever



