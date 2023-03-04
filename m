Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 296506AAC63
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 21:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjCDUT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 15:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjCDUTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 15:19:25 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349661ABFF
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 12:19:22 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 324B09eC029246;
        Sat, 4 Mar 2023 20:19:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=D6OHDVbk5VdJdGrun72aEPKd7q8HqSXlejqMlK+FRfg=;
 b=Ju3m1TMlSI5JX8F+AWVDvf6wk0WRzfPBT1aH1DDkXQNxs3Em96/eQ0ygqAI6qSWNjGs6
 34TquabH3JvzYWBOGVyK7AWNNr6Db9gkQIFpMf+Q8XQlsbCL7/1QthxwusRTTqXoRpzT
 lpnhXpjq+mvXSsgt8cZW4VwznwPhVVRV3I931skBvgUxTx5Pf7VUwhxGblZ9l8VnOkau
 rDzsTFeeX0/matDxrB06YOhrgYooX54d+9JQW5dh1caOWFvjKEpE/nclBor7z0AwTon1
 74RPtHwL+uTrfK+hqlR+XRT7O+ja1hCtGiJsgFNKCQ7rlE/wn9fym2zVujsI30QOBzxP Ug== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p416wgn3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 04 Mar 2023 20:19:11 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 324JcxC4000831;
        Sat, 4 Mar 2023 20:19:09 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p3ve93spt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 04 Mar 2023 20:19:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XzXgex1pjVR+5nzS3F2BdBbbsC2oRdQJfhdJ6OyD15UkUDcsLJ3tPo1EgV3C1htlsO813Q7zHidowAPaZBM8spxaZcLHKTvcYrov+CZkqqmxn6ZV52wC1KbJP5AM4n5sTKkzupUM5FbyZOP+59akk/yPMc8aWjRdoouX7b9SPnn645kYKyfjxF2dWsV4n1E/iPU6PdpVMkKYj7kJRYZDMBRYIZJhrI/9lazPGCWqOu867bhJ68mwjFy117UOiP/9sZ1mQ4MOk1cUUVH0pHDrSzHVPjt6oONPzAaF2IF4ie7zR2Q/sAqCcqEizOaVXVmgFikbm9DB/JRqxne4CVcpGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D6OHDVbk5VdJdGrun72aEPKd7q8HqSXlejqMlK+FRfg=;
 b=O+9JUF8o6spc9Z2vM/UdG/hH3N1fqlV/lQiiR3OfLK2h23NzcCkl3pUp5gHB5KfwYiVpGTtBW3omoRQI3EiNb9G5qSrTx8bUVcKmFlfHq7yZOTWUUFmVRxObIR8auirihgCxTqVdv8src7C4gopSryPfkwq5EnWu2xjb9ljAWWdAZJiZGDa+NopIqU9RtaiNOhKTFykPf4m9FINw/FJD1P2veeB+oXDL6V6WH515H6zRwGNHYUSo40YJE0rTc4uZX4nAd+9NzmAlR1yaXvEV0Oxf1nYoiTOiJW85aU9HxSavOxxC6PRk3vdCt2yOioIiLze9gO1Hmjvldnd72BxHdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D6OHDVbk5VdJdGrun72aEPKd7q8HqSXlejqMlK+FRfg=;
 b=yom52UJj9QzXc6yUXh6oIsdG36FoogGQSyn0dOZFbPzvSPKtI/J3yYpTmkWdMWeu3ThDaH0l5Vt/PL+qP9KLdr08v7GE04PSH8sa343h6AxxVXfUJ/nBOlQKsqq6Na4nYn7fRcLTNtgEyJDizO0GR9t/LguwWywyaNj8WcWP4x4=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SN4PR10MB5798.namprd10.prod.outlook.com (2603:10b6:806:20d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.23; Sat, 4 Mar
 2023 20:19:07 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%8]) with mapi id 15.20.6156.025; Sat, 4 Mar 2023
 20:19:07 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Chuck Lever <cel@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>,
        John Haxby <john.haxby@oracle.com>
Subject: Re: [PATCH v6 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Topic: [PATCH v6 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Index: AQHZTgEx5sDM5wq7q0GXZWBkY2YJz67p5A6AgAD8h4CAAAVfAIAAGZ8AgAAJGoCAAANvAIAABQOA
Date:   Sat, 4 Mar 2023 20:19:06 +0000
Message-ID: <0C0B6439-B3D0-46F3-8CD2-6AACD0DDE923@oracle.com>
References: <167786872946.7199.12490725847535629441.stgit@91.116.238.104.host.secureserver.net>
 <167786949141.7199.15896224944077004509.stgit@91.116.238.104.host.secureserver.net>
 <20230303182131.1d1dd4d8@kernel.org>
 <62D38E0F-DA0C-46F7-85D4-80FD61C55FD3@oracle.com>
 <83CDD55A-703B-4A61-837A-C98F1A28BE17@oracle.com>
 <20230304111616.1b11acea@kernel.org>
 <C236CECE-702B-4410-A509-9D33F51392C2@oracle.com>
 <20230304120108.05dd44c5@kernel.org>
In-Reply-To: <20230304120108.05dd44c5@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|SN4PR10MB5798:EE_
x-ms-office365-filtering-correlation-id: 295285eb-77af-459f-3196-08db1cedb4d9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wZ6UG8EeMUB5NsyZjFuIKyKaamRpcMRQLG3msav26QqYKlp6BcTGb5b+okwF4PrfJp+O/4HhmqmpPJHiQAB75JyhV6ZdZPjvxDwla7g/lWdkMminVAywGavRPi8S6Gv1u6/L8TNyfs732/K/PcAvId3w/WWNkOUACh0Z4JfeYkbLPWKifdv2WSl7LXOJ9Vttrb9MTuF0mPlQVGnMu007xW4a/Wmrmq/RS6WHXGZ1h1P6faurjydwY9AMs6pecPOzNK39vQLFroERpuXdaX5OK0j3m6lT1vllmCfeEsQ2Wf7F4OPJQHRxl1vofC041h3Pgi2gdDFpDvWoSBiW6xSEEqrQ/n67trl/taPJY5sFY0oLJpZvEarikCSIWs+I9vHGOqKbvnMju5TqkLZ5K4rQuGJUAOBoaYEobajITlCp1/jPzdLSxGxNOTiZQts8k6vrD6pMGitUQbTiGwK9CJP4Y8Y5KygWSyQwh+cAJLW78KaHhdJQEK3jdJJsItkG0zVJRqvwEkmuzrJBJYkPxOMV2KiLYmZaKn4g91h1uTfnYnroUOxt5xBJRppldLod3wlWXOwgM9ZI7hrK0ht9s7pgcO9YHbmZqDlIhwMVHdy6GxVOCfGodiPIudAnpMdRJtgg9d7hvARGiabK0HgoLD6gciwuUsLM0JYV+TxRbGnK/16VnqeMB56duKYdi0Nbf7g/nQoQldEDgqtWHRBA+45HyMNtCo/coWoZgAiozXoyR+8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(396003)(346002)(136003)(39860400002)(451199018)(8936002)(6512007)(6506007)(26005)(41300700001)(186003)(33656002)(2616005)(36756003)(83380400001)(2906002)(53546011)(107886003)(66446008)(66476007)(5660300002)(66556008)(64756008)(54906003)(6486002)(66946007)(38070700005)(76116006)(478600001)(316002)(86362001)(8676002)(6916009)(4326008)(38100700002)(122000001)(91956017)(71200400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MPbfxqptGyJU7PvLqLv2THfgoYerUohBF+vi+vCJb/60Gk3ZVSSfQy9WSc5U?=
 =?us-ascii?Q?cHqUXQOjuKsvAcXD/jLX8FDeZvGFbvQmSPKyDsUXWFPH+Pl5LJSYNw/p69/v?=
 =?us-ascii?Q?hmU/Cmbm0dR2JIZkPW/yDiw11JehH7FrPITAqynA/Xzs6miZjV/o6F42zqMh?=
 =?us-ascii?Q?wgZ1cqKWUG6WXKHW652QGksW2OMJfwJXBXbc70jT/ltWou8MPNEM9k8Ejf27?=
 =?us-ascii?Q?jPU88GGuPNtQX5znJApmwSn4eLrlllpLoQsZ08IyOEluStD1eUZOHLsn2ylX?=
 =?us-ascii?Q?WWkr4DgdbJ9wFyLUHz1jDdkRGenArUtVIgixXR1fnwzxerGqTWaneEFWj/Em?=
 =?us-ascii?Q?sqSmwoBubhgb0UVbTqxwfSFaLD0xqKqTJ5cJnwMdhf0QsXrt1PCZOVHUlIKl?=
 =?us-ascii?Q?BcFjFhv3vGQvFroEhuG5tOTfCvqZNdkzQf9iWu56G2pXT9XpjwOkqzdvoTl0?=
 =?us-ascii?Q?e0v+HApGuVdL6FCwI4BM47yNq9km03cCNmAMe7OiM3uB1E9YXJohJ979S9CQ?=
 =?us-ascii?Q?fG2SBlVWDt0cLgBDDay/2JJWY3XQ8okpA8qAyOLsyYyA8jkaHLF7TOymCPuz?=
 =?us-ascii?Q?NAh3Y2MVP6nXood9HOrGnI31Cx6ROGppf8i5FRzbI//XHAJkyEbIZCET5DOl?=
 =?us-ascii?Q?iyknUVWF+48Mcqqk65/veD8DRpMGYV5sEvr8NtS8eRRcT8+7Ld34Tm2I/Uu9?=
 =?us-ascii?Q?OS6bO4HTguQSLr7Bk5jCHnCGNZPcPUpJpy7JpXN9cYfBzIPNFbLUU5j7mdJj?=
 =?us-ascii?Q?alYPHh0amueLeA5V3NdpCTGDEu5czaxDXp4adj8UnB6yLqg6M2y0L+T09TIg?=
 =?us-ascii?Q?46cvOLzLFG1U0RYmKPJqzRHAVJb0WfvvbMFyDwqP3bjHBNn37mlwLtpUOVI0?=
 =?us-ascii?Q?O/1KE2R9Pysf+XMlyKUUn+HUunhdRrAzBTYRX/t/1FLL7/eUemmOp5jwd4S6?=
 =?us-ascii?Q?eVNDj6EG1yDR7ndKELNtp5kCzlg5sOqWz1Z1k4yn7hqlXMqupDqUuqU/fGCw?=
 =?us-ascii?Q?SWiJrXTfpSLit537rkd6qJg8ZelovUXUnkjxv7n1JfHUMxOatpO2hhbE7nye?=
 =?us-ascii?Q?6Uyz4DRphHDbGJbbEpw9W2bLiMN8cY2xQ7GK64VoGWxr3w809/jQ17hVxhTy?=
 =?us-ascii?Q?II3zvIZJBzfPWyxcYI8AKQOjaReYSQW1pnVa6jZweNTg1zbtNmpeHXMCTKwb?=
 =?us-ascii?Q?1nZcMWl3lv7SQhHbLiZXNW9o4s2Llg/S47SstOvyTzOPesedcfGQSmMgp70x?=
 =?us-ascii?Q?REEht+danKgf2AqPsoniWmHHBImcAJhTak58lZPV6q+08u7y+sC0cGBMVuBN?=
 =?us-ascii?Q?ykK+Ztr+svFuPUax5rkvTEHUA8VkvX7fD8ONAyMbjPbkZjQZKEjfrxhe3Wpg?=
 =?us-ascii?Q?369yDyFWe1NE6dgBnsI2ApVg56138QV/xG1Jii4sGZAWjgbQOUyuA4lXr4u9?=
 =?us-ascii?Q?oAlWFNPs7PW9vUhQlalbik493Ra8Pt+HYOJjRmRATKXSgR3pzWPi4/90eAHV?=
 =?us-ascii?Q?NIJb9GCTMGzw17WquWr8Qovrm+Fy3MPEZfrF2/MrxHWak19EWnT6PZMEL1ej?=
 =?us-ascii?Q?qGgTVdfHE+Q1INQBMyRJx4BF0VSqD98y2A0HmSSatr8RmHIvR4vKQHhkBkDb?=
 =?us-ascii?Q?Pw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A4D62A8E1FC1E4448964D447AEA5668A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: M27bgZuIMlTxo0VGMuHvcJidNULipEZfmF/vLS5BF/45ZipJ0Xc4PTpMhCDCE2zSXFBEk8eJOKz2f6LzCYbLQdDvn3/M3ta5va6p0uySumyxJgKKw7rW19S6GXXSIBHOLex+No1T7OWrNcMgmodymk1f9Pz/mmfgLBgGioTSSlCkWSrTIsefV+PxFm5ZNZ3T6zx/bprCnZ18sjV2mqJexjmKpZEDTa873CHr2z08wHsszdnS6CeE4a611Nk310YEwKb1akAFksi0aKYO9Zh45kiK4jH53qzBd96tHzhsldSdB8LEYeypl0CBmuypDVctDfwIRQ6t5KaylDkNab05AR/UsvHkIZg8lnIyN5fjtab8Ipor/Pwe5sLY30FtR2yGsx1phF2j1vknyqthnA6swVg/A88JpSXUzGczoMk2l/Y6wSXl3qKn7iyJVQuum608hPDdvuFY+rnG7P5sbHnkgE/K/EfWiBLSC0fPlshUvrVA59UMoet5MFdWb8UPUTE1n9oiNnD3BlOctHP8JEKP+plkoOr3wSN4reRaAljIxDHsOMmLpNpcaPoQI0zljPHrTBzcSMeM0uXmEukZljkbBaKL107bQmMIC2GyQ5c6Uow2IyoD02KbkhjvRLTAzvhxTmGu83rWbpY+QWBIDnvWRrftCV4jnqKNnibWucr0VUcmL0fI9qVAbqYJRILvT2fSk6eut28V6JMrL8cDK+lYsy9LYvnTa/1YxvImpf2qVJGrQst/+ki4H7hcNMVt7OcaQwzVUxDtn5K4eIU2g+3KEeAJvm3BfpTBfkCjci3klb15O25VQ1coCFzCbzv3BmWsFvuzUDOT7pw+EMnJwF0+H2bKdCrDVwn6ygoBpmMSwgffdqzPY+AuFLUsxPmfz6eqAv5yglCTobvYe/weAWtSIw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 295285eb-77af-459f-3196-08db1cedb4d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2023 20:19:06.9861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RP0IhlHkmkDQA5eA52yXgJDGQ7NOdomdUI/xEOAD6O6AxdJvWDPlpg0MinoMuFlol8j9cH8UvbvoyR3zXHM9xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5798
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-04_12,2023-03-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303040176
X-Proofpoint-GUID: nxiYtrzbf94sAzDN3DV5zDVoAHQpb0Zj
X-Proofpoint-ORIG-GUID: nxiYtrzbf94sAzDN3DV5zDVoAHQpb0Zj
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 4, 2023, at 3:01 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Sat, 4 Mar 2023 19:48:51 +0000 Chuck Lever III wrote:
>>>>> 2. The SPDX tags in the generated source files is "BSD
>>>>> 3-clause", but the tag in my spec is "GPL-2.0 with
>>>>> syscall note". Oddly, the generated uapi header still
>>>>> has the latter (correct) tag. =20
>>>=20
>>> I was trying to go with least restrictive licenses for the generated
>>> code. Would BSD-3-clause everywhere be okay with you? =20
>>=20
>> IIUC we cannot generate source code from a GPL-encumbered
>> specification and label that code with a less-restrictive
>> license. Isn't generated source code a "derived" artifact?
>>=20
>> The spec lives in the kernel tree, therefore it's covered.
>> Plus, my employer requires that all of my contributions
>> to the Linux kernel are under GPL v2.
>>=20
>> I'd prefer to see all my generated files get a license
>> that matches the spec's license.
>>=20
>> You could add an spdx object in the YAML schema, and output
>> the value of that object as part of code generation.
>>=20
>> To be safe, I'd also find a suitably informed lawyer who
>> can give us an opinion about how this needs to work. I've
>> had a similar discussion about the license status of a
>> spec derived from source code, so I'm skeptical that we
>> can simply replace the license when going to code from
>> spec.
>>=20
>> If you need to require BSD-3-clause in this area, I can
>> request an exception from my employer for the YAML that
>> is contributed as part of the handshake mechanism.
>=20
> The choice of BSD was to make the specs as easy to use as possible.
> Some companies may still be iffy about GPL, and it's all basically
> an API, not "real code".
>=20
> If your lawyers agree we should require BSD an all Netlink specs,
> document that and make the uAPI also BSD.
>=20
>> Sorry to make trouble -- hopefully this discussion is also
>> keeping you out of trouble too.
>=20
> I was hoping choice of BSD would keep me out of trouble :)
> My second choice was to make them public domain.. but lawyers should
> like BSD-3-clause more because of the warranty statement.

The issue is that the GPL forces our hand. Derived code
is under GPL if the spec is under GPL. The 3 existing
specs in Documentation/netlink/specs are unlabeled, and
therefore I think would be subsumed under the blanket
license that other kernel source falls under.

I don't think you can simply choose a license for
the derived code. The only way to fix this so that the
generated code is under BSD-3-clause is to explicitly
re-license the specs under Documentation/netlink/specs/
as BSD-3-clause. (which is as easy as asking the authors
for permission to do that - I assume this stuff is new
enough that it won't be difficult to track them down).

Again, it would be convenient for contributors in this
area to specify the spec and code license in the YAML
spec. Anyone can contribute under BSD-3-clause or GPL,
but the code and spec licenses have to match, IMO.

I can start with the LF first to see if we actually have
a problem.


--
Chuck Lever


