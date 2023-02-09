Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50897690E63
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 17:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjBIQfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 11:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjBIQfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 11:35:16 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2895CBDD
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 08:35:14 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 319G9FQW025304;
        Thu, 9 Feb 2023 16:35:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=z6E32geP5u+Ey7mZ4EcFx62o96RVcy3/cLGeZX5yxxM=;
 b=YG/Fi50rE6CZ4NQJSXKROoUIVb7AFFDWywj5vXoli+KNsbZQkFPGd7x6gNy6EJ0X+Tkt
 u4jaS/eNkufg2mow7JhUyw+3dKAzp8IYwtGuUOuaNjHtM8f44jQUwpkuxnxlVWShNq8n
 PNl7SVqRbPZvZFhP3ACIA3c14KTTMJBViYGLBc7ZB4JBJjMmMwAj9phNCNHcXM+Yyl4g
 Z4GuTDnhnZg//F+69Xmp3l4euKSZWKUKWOAoBMM5W1o+UQ6TCo9p++ozuxY3p2b17qDP
 ZlE10KwMfaUwwJaFSa4AON8gwjZ8rMZ5yqEp+MrAzJknfyg3YVZJ2cR3ojs3dXNZMzwF Ew== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdsdu5tm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Feb 2023 16:35:03 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 319FH3KK002648;
        Thu, 9 Feb 2023 16:35:02 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2043.outbound.protection.outlook.com [104.47.73.43])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtfkmnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Feb 2023 16:35:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i9Cy0ogqNW4GQkXyb/MRIWnRMfBldfRdv/Dyz7EK8kEhttLijQtia/N6hCEfksU9JMEbp+Fh0GvmpvlFnsZGBHcmb16NLbW6iPaNbZ3hHav72N6Z77UBAxaWQYdGYbBpGNxTDU8fD0NsVhPqZCFLuOtJpgaolzM+SM4gjUTOv6dcoDcMoLVPbVHoOy6ekYlFY3jPmYFvHV+2dTx+ifVcH5Mm6isZNI/Cf2KSWwuiPBvPaH50Fk5PFtovf0rqPZiZu212M9/79URZdZRzVfrImPG2hZRZ6VVLkhSJh+i8Xtjr6X2yB9nLhzOj0xysFAZoIczb0ND5mu6uf67FI5I95A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z6E32geP5u+Ey7mZ4EcFx62o96RVcy3/cLGeZX5yxxM=;
 b=Amo7fZfP+QaUJcuyn/YF/jH0hIHwTjBca6dOMKzvoE21A7GFr3NBwDYHC70/9FfEPPvV+Q+l+u3K3z9XNZLFf0d88/akCQyGlSRPOnWrE/mYdye/kRdwEJcKKrfrKJcq4iA3tmpfjY7gqVNB5vs7PAcbFP3hkeP/WA6gPMluuozeUHzA5Lz6xHrm8+JajMSa2tblcwTkrXpJQbUx8uKtXnokv+EVlijO2qAoU/KgUdF8oB9+epldv4ySqjk7mOrPXOK8djhEspXR3f616meqsxkhJup+S7cjT57aD2kioHcyhQYqZVoNuHTDsQwfLyULPZwaHdEJ2YtGarR4cIPDMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z6E32geP5u+Ey7mZ4EcFx62o96RVcy3/cLGeZX5yxxM=;
 b=ZHTrSP57Td5V6nDeaY6a9uKhd/PoPjRB/7peB50746CsSwNJP8OeI/IHceSSgeJKew8sKUS/qDXdmlw6piEYFioHLb8ZUXYKEcHD3uI3t33kZB9ktqKp53ORYyizmunv79LYwszZ6AkOcCQmqYy9dsERPwZjvxkMHrYvWoj1cmA=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CY5PR10MB6009.namprd10.prod.outlook.com (2603:10b6:930:2a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 16:34:59 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%6]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 16:34:59 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Paolo Abeni <pabeni@redhat.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>
Subject: Re: [PATCH v3 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Topic: [PATCH v3 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Index: AQHZPEvN++FMdi3fdkGdZmQw8wcosK7Gwc0AgAAFWQCAAAknAA==
Date:   Thu, 9 Feb 2023 16:34:58 +0000
Message-ID: <1A3363FD-16A1-4A4B-AB30-DD56AFA5FFB0@oracle.com>
References: <167580444939.5328.5412964147692077675.stgit@91.116.238.104.host.secureserver.net>
 <167580607317.5328.2575913180270613320.stgit@91.116.238.104.host.secureserver.net>
 <20230208220025.0c3e6591@kernel.org>
 <5D62859B-76AD-431C-AC93-C42A32EC2B69@oracle.com>
 <a793b8ae257e87fd58e6849f3529f3b886b68262.camel@redhat.com>
In-Reply-To: <a793b8ae257e87fd58e6849f3529f3b886b68262.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|CY5PR10MB6009:EE_
x-ms-office365-filtering-correlation-id: 73c08e87-e894-4fca-13f1-08db0abb95b4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c0oHOAPZGcGxuMhspMSouHcCpapsZLIwcu9g4V/McvplXIzMoA3l33VWNMxXHAXT/rGS3XRFi6e8yxrXPpJPvAfGnC27OU2925LAiAp++5Dcc/E5RNfMzGK1tD2HPDTpl04RVEkekieFwcLCckC+zZI1eLrXKVnKKUZVDU3a/ouoeD8eJEgsXWzbMg6i0lfzA62asU9Qwo81Mz7d/4xpSXBk105V4LgBGC7gBZlcDTgQ0jbBKjCrISVFo+cJGqcCzbkfUcvcO167fZl4zs8MUuqcsKcoIloSUGCr4RjgG2pZinFnGbxJjBnhAnard2BA3XtIcAJQLYNFHYrDbpyUGcDhXvAVmaT5945qkRNc/FApXXPjwYlp5l5YZDB6u1fhLNxCqYHDwzhaKzKE32Ki4LpA17thjiKmhpqeD1MZxHMvVtaf4+igE28WvEIHX/FjsWaZKrDGknepRQlScqGHALFE0Rvg5NjEeoMngq8p5UE29rBQYjMSY01OAogL+zRbYvLxCUQIfI14bUQTOmE5vET4Xfdl859LxBKnOuF63HIQP35CIXoJL2zZQhJbhV2iDe5oooF3Xyaml8PF/GYUpeP/jwJb88SjByLnca9i0efTEA7XJe3WDmHbt7WQrFBug8PdS/SLdqiukNy5a8uICO4BJMvypIs2PS9yq1qgQKfOYJ/emZb6Gr08ZmxOFizuc+nr2qyJgoavofA5ieJWZI8a7ODetKI7qGxzd2LdDPs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(136003)(346002)(39860400002)(376002)(451199018)(316002)(54906003)(41300700001)(38100700002)(2616005)(122000001)(38070700005)(83380400001)(86362001)(8936002)(5660300002)(478600001)(71200400001)(6486002)(36756003)(2906002)(76116006)(26005)(186003)(53546011)(6916009)(66556008)(6512007)(64756008)(8676002)(4326008)(33656002)(91956017)(66446008)(6506007)(66946007)(66476007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eZ6+ASXiMo/RKmt6o/GLWKvV/wHX5aFg8h7Mhd+YfDQ8tgfSrC+b/QslrSd4?=
 =?us-ascii?Q?4pODyOtCD0eJYJfQJvc856omDNfR1ZLWWZSzkKtHX1k+tV6krg+10j9+kpS6?=
 =?us-ascii?Q?fD613d+V4wpaqi0tz7i1mJxTc67R8FruFdH2GpA68Am1OYcmxAYoPWTUAPOz?=
 =?us-ascii?Q?B1eJ/hO+EMJPDxbWpEW3ormfTHG7BirKjS2hXAFrFjKoXBPkdSI8mT3lRHXN?=
 =?us-ascii?Q?wPTF7wlsQZyawnF3Zpycy/UuZ7SOrXlja78bF0vho6dYAo/bDEKkCBzRvjrL?=
 =?us-ascii?Q?tpkptBQuUDQ4Z4AzN2fC1iTjXT5tEHi8fMLW+FvDfIpU9JA5atwsvUiLTCRp?=
 =?us-ascii?Q?ajabXGc+/vFgXw1yIEXZWgdMSdj92gUp+3KAv7VlEAY1htb+yjDG+HpZBHwT?=
 =?us-ascii?Q?spAzMUrmkuIcwj2mtzVmhPLtII4BzScB+6+b1QR60ZToo9IlJqxKViJHr3wq?=
 =?us-ascii?Q?D5Z/PZw/cAwrhxxn63TMbBaKcH1dnuy/HIWE8aicvE2a7My7NqTMOrys+BWb?=
 =?us-ascii?Q?vAqz5rANjfTz+XSRmlC1ZAWhglvCCpfBsjVFvaCcUQDxCyXEsvV7TUFKRKKp?=
 =?us-ascii?Q?4Z8SMTiFH3LDKv7Cl+paYb9qMPsHcoNEsNqrzcizmQh90GegUkn+G/xtJmsx?=
 =?us-ascii?Q?iH/5JccffQOLBww7n1+6wgwKwy3B3JiN+nw3Cy7d4SGNoyMe2DSdkJ9Ekuf0?=
 =?us-ascii?Q?KKGdhV/Nykf70X6pM/m5eCBcWaqTfOlPrKhBz64+GGgPDGwhQP9K3Dsr8eNS?=
 =?us-ascii?Q?Qr2WjIA8q/jx13t8i4YPQrtkHDa+gPYyvFAWVchikwN3+3ip0fSIgG0Kh3C4?=
 =?us-ascii?Q?+nNcr+EZ55zgFCt+o9Kx8VOhMwMNYTsfzYKHMPux4g3UOTp8sMtNaYTQCzkR?=
 =?us-ascii?Q?yyOQ1dyF2gCiSsMFsWEw/SNakneh3HzpEgJ3StWqPsivxC3bkD7LlwheeRYN?=
 =?us-ascii?Q?lf2YFW9QSc6j07OA4uXQ36cVbaPpyzlyywnzcezpLMi5Av+O/eLuwwoGtkFf?=
 =?us-ascii?Q?twY8XB0NFY/4fzS+LkrP2zLDOrmfeX+7/QdQQvBZfkXLFXeE3vviG9d/v/To?=
 =?us-ascii?Q?2UPhgKKhAdeYq7ktxDGGo2s8iYe8DJ7ltofL1kSRIlO/DSIMYXAbko200vro?=
 =?us-ascii?Q?7ZwIkJgsRh/zobQ4jbO+Ag7kyP59OlQh9JWni/zDKjBxLNrekf0FnHWgKLzs?=
 =?us-ascii?Q?/J+CSuaeysj+YwKb76aitAAkn7lB2SnkuovuzzHXiSdWU4Xmz4jU99SoiILd?=
 =?us-ascii?Q?2XH/Jn0vG2gBWsUbAdT7Xi0coooOEicDYbKD+RUk4tvKU1QcWxX3cxzw4tA0?=
 =?us-ascii?Q?wyBRsntTGqE/tLEmWDeB87i2Zii7yW4QG5pvvid4DoOAsTGqkdLoLMtoTx88?=
 =?us-ascii?Q?u1eYBYJupByshj++Wy8F1unVs/jbrNTNEJiByDRrmjYFYQG1j/64sQuTj9Ak?=
 =?us-ascii?Q?FmU65jPW6YTARYmwqdmTpkiNtCfB1IGG4ohcSFEMoM7S9MqiZlaE0yGx0yBz?=
 =?us-ascii?Q?3a3nY55h2i7pgbFrnwJc9JRfc3eAxaNt6LAR2nxwIAYij6AqkYdvQ9TmiVUf?=
 =?us-ascii?Q?9V3RHErH4CVU+v1YDBoHbG23/wsXQyJNfm9mF4xuz24gqzYuGgMliA13787q?=
 =?us-ascii?Q?6A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D58F03DED8C8C14A9B49249C089626CA@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: i+vlGlcktFLM5sXNdjRLUpr2Db5TnCaMZubyMIUX0ag7appBPTWpYytDlPjV+/PisNX+Ft6pubjO78dJ2tywKoOQa3JrE6bzYIJ+ZkvxHOhoRZn1d504mcs9ea+Slzt4fICn5LV7+4zyRyA02BaCzdYnXrsDDeHKIOEga2wwmjyoETfsxVQKYlIYzTUVBwrHai5+ZWlONWCBqgipKzDVPuS7ge+cSyybcMOM0Ah0cLxu8ftviyo+wx483ObsbCeGq182lVtnPOXXonJekkg4XD46qbN0m+52VXauqo63LECkpYII/jALKDVrzQDUf2g4WWtI3TscFU97IA4v7uknEd4MgZo6I6yNFKHHITDL4ftd8KviHPUt8Y/PUcLHeT6ncTxOPiCwuXVsiRSeTacG6CU/7pFUZ2LhRAvVEyrSyKxgZTL9St8E7kgcZom8tH+1/pLZgznTIawejaKgXaOKdrJkBfcJzH/Cteh53nW+Ht0BvnBhHHR/knIgdO7BWiRIkiWw0bZmCwWO6yna0tdKsJ8xVHHXg5m/WNs64Ve5vRHxNARcgw0LMFFmiTquoGK2NEE0S/5yuUGbaeLsXozNSEyF0I/5AxA+W5oEP3kkcie+asdWccC2fceyPqnHQX+h4JsKLhxDdXSxG1i67FUwIFClUN3Ncdsg5DvrylCvO8aAlB5S3pC6as6vphmF0SMC1Lg/7qx5RyLEUEIXy7/+DhVFrdlT3mK8SZQh8LlU3DFXR0oOBKEXfT1tloSdbPZeBz4l8O/khZ8R0XgrE8BZORBGEeyLf5W+tS5+y6dwQNEvIiTiGFEin95AT8RQYRNFewl9PwRv+aTZaeJ1a1fwNYq4vLiM0Oze4UFIDf8AVyhzE7+p0XGaP01up1ea2NXUaum3nAlnUjD0ki7/WWvXiQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73c08e87-e894-4fca-13f1-08db0abb95b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 16:34:58.9669
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O0ABEUOy4w01OZvVBo4RY/SgDTWKYVHmUSLomgHO0qXnuVidKkpcX64hsHtS1pS/AjNsuJw/yl4k2+soHF9TGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6009
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-09_13,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302090157
X-Proofpoint-ORIG-GUID: COB1KZoM3XSeMBlzoeA1OhVfKNph_6mh
X-Proofpoint-GUID: COB1KZoM3XSeMBlzoeA1OhVfKNph_6mh
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 9, 2023, at 11:02 AM, Paolo Abeni <pabeni@redhat.com> wrote:
>=20
> On Thu, 2023-02-09 at 15:43 +0000, Chuck Lever III wrote:
>>> On Feb 9, 2023, at 1:00 AM, Jakub Kicinski <kuba@kernel.org> wrote:
>>>=20
>>> On Tue, 07 Feb 2023 16:41:13 -0500 Chuck Lever wrote:
>>>> diff --git a/tools/include/uapi/linux/netlink.h
>>>> b/tools/include/uapi/linux/netlink.h
>>>> index 0a4d73317759..a269d356f358 100644
>>>> --- a/tools/include/uapi/linux/netlink.h
>>>> +++ b/tools/include/uapi/linux/netlink.h
>>>> @@ -29,6 +29,7 @@
>>>> #define NETLINK_RDMA		20
>>>> #define NETLINK_CRYPTO		21	/* Crypto layer */
>>>> #define NETLINK_SMC		22	/* SMC monitoring */
>>>> +#define NETLINK_HANDSHAKE	23	/* transport layer sec
>>>> handshake requests */
>>>=20
>>> The extra indirection of genetlink introduces some complications?
>>=20
>> I don't think it does, necessarily. But neither does it seem
>> to add any value (for this use case). <shrug>
>=20
> To me it introduces a good separation between the handshake mechanism
> itself and the current subject (sock).
>=20
> IIRC the previous version allowed the user-space to create a socket of
> the HANDSHAKE family which in turn accept()ed tcp sockets. That kind of
> construct - assuming I interpreted it correctly - did not sound right
> to me.
>=20
> Back to these patches, they looks sane to me, even if the whole
> architecture is a bit hard to follow, given the non trivial cross
> references between the patches - I can likely have missed some relevant
> point.

One of the original goals was to support other security protocols
besides TLS v1.3, which is why the code is split between two
patches. I know that is cumbersome for some review workflows.

Now is a good time to simplify, if we see a sensible opportunity
to do so.


> I'm wondering if this approach scales well enough with the number of
> concurrent handshakes: the single list looks like a potential bottle-
> neck.

It's not clear how much scaling is needed. I don't have a strong
sense of how frequently a busy storage server will need a handshake,
for instance, but it seems like it would be relatively less frequent
than, say, I/O. Network storage connections are typically long-lived,
unlike http.

In terms of scalability, I am a little more concerned about the
handshake_mutex. Maybe that isn't needed since the pending list is
spinlock protected?

All that said, the single pending list can be replaced easily. It
would be straightforward to move it into struct net, for example.


--
Chuck Lever



