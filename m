Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16A0D6C4BE9
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 14:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjCVNf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 09:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbjCVNf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 09:35:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31EB21C7C2
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 06:35:25 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32MCY2xk018782;
        Wed, 22 Mar 2023 13:35:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=43DGtrHHomipomAHWAu7tV8etGYa2ZbR9mm+/Vp1NIQ=;
 b=PlEzHR0ypndDly/odrJ9zXqsBifXwAtg9o77Qkbt2/v03/lAIgpG2nlMdT+af7C7ryWO
 PdAlRBPjho0PAxvYGusWL31OZIi9eDEGnMMBGDlNRdXrdBjYg/DHZn8qeNVxSLRiSLqn
 3tQeTXujES4ppha6z4aggF3Jx21SrRmreeIdmo3t8OkmpngPpUVhZSzxf1k/ioBcjMAh
 K57adLH2IBXSeKMePNPh6PIsB+PuB4aI1UGTpWtCe/tiDz9rDaVwX7gEhiItXYu76RHo
 SG1HNth6u7u7ASaB/GUXxVxLnXz57SwFHuOAZFeb4ZU2y018x2QKgpuJOvPYDQN4+b9Y eA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd3qdrva9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Mar 2023 13:35:10 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32MDJ3LK013248;
        Wed, 22 Mar 2023 13:35:10 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pg2f0ggd4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Mar 2023 13:35:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h7Rya2CiBDBA3MmOCWzrDVdncMnT7OYBxTEm/qh7EOUxO0tcAlWz/o8i/oM6YBVCzm9CuB5IvAxVgZ9SfJKdMLLhCT28jutYZ7b/YaohMXhpdTdoyXp1xlTMnHcbg8TlDwfQ/8SD02CAVeiSdhh0LQzxIkptbckzV/RjrHysoJmFSaHy99PzFCDTOGux0kWPRQJEtkrcSCYNPDI4OONbBNO93wWSh4oiFKj+qSKS8lc5+3StsJW1cXfnDiZja3pz7cOSXnFUEzi1mXXKbFYkqBuIGXLVlK6fWisrOdRHuDRjAtc8V06rBOtn6T+IuUhRHa99Yr3whx5GYj01w9pp5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=43DGtrHHomipomAHWAu7tV8etGYa2ZbR9mm+/Vp1NIQ=;
 b=U8GOnITRZdVe01+W5VKUkwwElskKLnECXB3QeyIU5m5LGD7mU/hSEq0USRc0U1Y+sCN0x3IXSJ54NjS4yPHu6IIkNKcuJDZUmWV5NPkWE3CtdZ3SWFlRP4Ng+w84q5v9Ok+DMXIeNnkBLYOYw7pwtd1cYZeKOOuOJN1ZMDJnLd2ZYATRuXNavPeXLTqgaHr07JZ5kZNnOGmk3IIRPIIPvxMqXjD5xDN0AdCHtmQn/UzZPzT62u9PEOr0nqvC98eLgdzz5UOOXv1uQCj8KhY9VJkM/p2OXlI68pO4HRwGwNYb8b40a6vjhYc/c40jqXA9r3CcmIHUcKBBSaT73+lUgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=43DGtrHHomipomAHWAu7tV8etGYa2ZbR9mm+/Vp1NIQ=;
 b=WkTht4pK93if3LtFfoWHIPa2E9RSNZuh5u29AXgL9PdyLs6TuleYG6CfkXHJSiZcO0dA8dgkCDVuj818hqsIAqVsvZvwg6N2wfR+Qw0gt3TrPWoxP/L1HOSf8k7DUs/Uxkphy2VJEzR3gcC4HiDBf8aWae6vXR+/X5CkJ6ic7/w=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CH0PR10MB5241.namprd10.prod.outlook.com (2603:10b6:610:c5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 13:35:07 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%8]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 13:35:07 +0000
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
Thread-Index: AQHZWbVGJzLbQ29BsEW987typvYRiq8FHPAAgAAqL4CAAT/BgIAAS+8A
Date:   Wed, 22 Mar 2023 13:35:07 +0000
Message-ID: <1BD8AD98-0775-4E65-ABC5-23A83AC98D4B@oracle.com>
References: <167915594811.91792.15722842400657376706.stgit@manet.1015granger.net>
 <167915629953.91792.17220269709156129944.stgit@manet.1015granger.net>
 <3dc6b9290984bc07ae5ac9c5a9fba01742b64f84.camel@redhat.com>
 <674AEE9C-BDB7-440E-902E-73918D6E2370@oracle.com>
 <dc32e3654de0bee5d8c6cf64375fa491b89d655f.camel@redhat.com>
In-Reply-To: <dc32e3654de0bee5d8c6cf64375fa491b89d655f.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|CH0PR10MB5241:EE_
x-ms-office365-filtering-correlation-id: 51301288-aa75-410f-85a3-08db2ada4042
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pGhKEhLZlM1utVWoNtc0u6vHopnKEmCoZ6m6pNTgzvjLp0fdJ0oHmEbNTDRiJvNKpesJt9PJHfXEYgsIwVHYq8Ne+b1CgLcqL09qIcTT6R3DSUqlJJE3MOktV38/zvQWCxco5OOeBLYNHFrbvNQmncE3FfJnPtewm5gRv7xzlo3wnhHmRc2SuwDeZO0VlIsbcnLfJsoPN+CY8F106zPsig7ksLkftaTNGx/f/wHFg+UCsrUF0SABC+JC/k6eTFsNttV8dj39QsfrukdLcJ8X2AyKAt0lCiL2UaxOIAKiC2ta1vosKclVi6ROA1LutCss/IlA/zfrLhL8xSfMhtEaTWAKa9FZbjD/MYcHKi5Bo3QE1G6QVlDFf26MjiFplgD5LCQguRHCTFdNmxR0oPdHXMTTopI+Rn1CC5asGeJbPiPSQi8b+jQfMN/ircKITd0hUEeCLzIYoj5HnWhF2jAgWx9iB5vq5Wo2jP3RERzhrpXs7KRiXVnPdCT6IRBDl2/57cvs3Hm3xzZ0PRZOhDBLTpSvAmlLyudyu9f+gmbdBqwk+m8OMOixH+Kup/WvT8EVPxVGQ/1PLe8iGvu26qx6onVqDcMBR3QXdSdfCkP7WrXOuk9Tn+BxpZU9YlnVXBi1grqDgY0ZGRQgu45ZO9ZkuGhvszquzFdLZANMyofcl+HlrILeiv9hEj+FjkffRXDzQbSVhhRnnxSb/vve2iHyXAFVgCLbr5LxsLUgunYUNqkDgyhjUAUAg/rHVGAWF3OT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(346002)(136003)(376002)(396003)(366004)(451199018)(66899018)(6512007)(2616005)(107886003)(71200400001)(26005)(5660300002)(53546011)(186003)(478600001)(6486002)(6506007)(83380400001)(316002)(122000001)(33656002)(38100700002)(86362001)(91956017)(38070700005)(36756003)(66946007)(41300700001)(76116006)(54906003)(64756008)(8676002)(66476007)(8936002)(4326008)(66556008)(6916009)(2906002)(66446008)(21314003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1wa7s4DM9E4dlmBDyMYedWVuHUFY19bBfjiz1XDE/0+k7Su4hWJviSO38cig?=
 =?us-ascii?Q?Xta9wEBBvEBPwq0sh15JL2MKl7jbov2HwDHJ4BWcBOWfn6IFFn4W25JiFuEk?=
 =?us-ascii?Q?ntEnjbQAgaB51enu2/tp1CadSQZOO2im8g4tuvTLl4IhQMzToPcZ2fZw4d3o?=
 =?us-ascii?Q?78NyspScMR1mFKEOhR2mkP8vuPGCz+78xgNpYRbns/APlgdnLiTTgnwof+3i?=
 =?us-ascii?Q?Bj5YsUXSg5elmKiTMQ/cdKG73IyqucwQTaQoPreyiLYeibJTx/H76oa1D3JH?=
 =?us-ascii?Q?EaQGhAQyf4ybwsrLacV2ZuMrXvJlCbMBgMBBKHN8HZXWoceScBBX3X6cztsC?=
 =?us-ascii?Q?689OVx7b7idV3QWns35SUU2Y0m7YzsGlED9q6z57SOxlN3g8fgtwo34WZb9e?=
 =?us-ascii?Q?j5rP/0CVjqrWvS5etQ0b5di8EuDJCpScO5DSu+KJ6BZnkysqaDMYTfBiPd4R?=
 =?us-ascii?Q?Psc4Er/P8tmLOSug3pvSkTGkMP/9Y2nb84YjZfvCB9Jg/fnDEFhvQVEjUAJq?=
 =?us-ascii?Q?7qN1QYe6W/3wyC+ldcG9jkKJ3q/SrJUMUPM+yrhTFjmvT6HrJQvOCTDIu3n5?=
 =?us-ascii?Q?Zu/m+Slo36c5itFxOzqT8sdW1dM08bAw9Z5w/AVwMkF5UiU3xzJw5hdrtpa5?=
 =?us-ascii?Q?tHmv5nOiLJRtYfWk83WRbJBWiuseywxbJ6qytTU3/Y7A7CDw2kF6E/FC5xkq?=
 =?us-ascii?Q?I2Z7AQqui/K4sqMYZ2JDXa1YW8fKmyp0WhW0PMnhNlfbJ8dbTWNPbll19FQ+?=
 =?us-ascii?Q?laUzdEcP1QbRuL890h3dATQszx1wANUP/2FEOMhyXJOCDU+oo+LiLATY05FK?=
 =?us-ascii?Q?k2KCE/rlTK8BlmB8jkFvEBB4iQyfU+p5xboXwZsMNetEg/0ZrT8uLVHmd85P?=
 =?us-ascii?Q?h5st4YcFW5YjsOLwLlwR0RHO+/w7CcMawbKm/nAFAI3m+evqqiG0P4kVzZFb?=
 =?us-ascii?Q?Yxuths5wL2iBoH8rEn1FseXJDE4TVFEee2rnPNLceKvaW0XbOv+lWmQfI9AW?=
 =?us-ascii?Q?1F9feUod+fRiehf2T7HZ2U3j6B61lH/Kifxfyr18cu6PSHJHGCY9qqbH8ya+?=
 =?us-ascii?Q?LDSdNRgaKasA5qkT67y9SNcO2EF79kv1CemMA1qyVtLfOf6cCRLR1RFNlfmb?=
 =?us-ascii?Q?yDdBPccvLRugf+ZMElmoJRrEIc9LfosE2gBQyKo1O/Yj8s93ZKMm/FZGrjiM?=
 =?us-ascii?Q?fNGUZ9kjXKbFpbTVMM1rrixdTOCjShdd88aFzXlQnNur3xuA9mjsMFAo1QQR?=
 =?us-ascii?Q?x2vyHx1WqQHo6ormXDgAnfa3NcwGdN4P51bo9mOd0dr/Fp+IBcjtQMDObjcf?=
 =?us-ascii?Q?OttaLZfzNXZajU1U/CsMgElflzo4SOCbjLNQ6pXUzZSLeKaPZ7AjSQVxwK7F?=
 =?us-ascii?Q?5m/m/qf/mDwdEtAn2VRkt7wJhNfWmE5ReXfKGbFp5y614Ro3MEK1DPD71D6T?=
 =?us-ascii?Q?GUfpaz5NXerh1e3kDv2ZdKpeDbPp3t6035ERkpMc4amAqE0YLvNtcBEvCwU4?=
 =?us-ascii?Q?fjqwBRoCpgTbbs6eH4kVrusluOwv/tsc1SCdB6toIZHPdyGI9Qky2B/nwKjy?=
 =?us-ascii?Q?5A/hfRnZIEGASqarKhOb7LVx42Zt9YOiinc3nXZpRdfzmrJWJDz32zTr9UIQ?=
 =?us-ascii?Q?aw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4A4215AE4A92C04B9D589D077C6B66B0@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: RoGwSrpmhJpFzqphj09ALb7Lera0TIPShGv9Pja/Xy1VPgpJsvleHl2Hyf5Drwbe/r08T4ZBsYhgTN8XruSRPzFuYl0+JX/0udB0XaJ/YL6E4hsnavuuW3YpGUyOyXRtooAU8AQzFOnXmOdiUQgIFYp+wYbUlrd+rlhZZi86568B+idaardVhD7ftof1kq7ajM+vx7+6oEVRKzSTkNY7IrtBLyYxQqZ7xOsrGOUX3w3KtJRi9mqXTzKuom8TJii8xbX3DC306O9LZHFIIVUDIxnx+aRioV+pZ9xzaybQHa7wpQgHXhkVB6OT3kb0t/lDxP/md4eukfozH/LMYD+Vz6iM9LivpZ+rUGshmEjVwj/xBvLsW5E202cjGNoCWTshUJ+QwrXP1o8vCavKuK9ggQ0p4IxkHBK0ipHwdvG18zf/aeTTTkZejRskZw8wZ2GKFQb1eyHqhB9+SY+92V3kGEvUyTW57aXyeHcEQvDOO3CuZCwQpFq9sH5qcxcSH9L6Jz3G8Blej74CoIfmCzq9siLtJ9NLC/R2Ukf3Gm53Sj6pmb1XrVKP1fAffNU+lv3PTYNN5Z2BKkQs0IkAApLxIadouzgvIeSl11QW5P1FO+5dt5a7Ch9m+1VvitgzeE7D2ZC1QIPHERNB6HLoYn5fL2Ks23sJDfHk9H19N/Sw2s7YG8V42zRmbcgsLxrc/69kpj59m730rrIpsqBy74JoVMup0a4DLxGV/OVd9CXPbY7Mu8VYkTYE0h31fj+9suFVTh1ujVWfU0avXlotXjj+FEZS9tf52FRlwWfTP4zN0Plp8YozrUdol1sUlzuuPUQF8OZCWouPxppHhSpZFgGCrKIikpHFVCq8kZGx36+k33Ri2capDKbRdyC0NA68LY1Dx1FLluf/VzMCW0ance2tZg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51301288-aa75-410f-85a3-08db2ada4042
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2023 13:35:07.2083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VB4Ideurm2pu5x9iS2HyIxl+ouSmqpW+tDCyOAlA1df5MD1xUL6xyQhfzT6AqXTSko6A7NIqYiR0lKdbGlDA+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5241
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_11,2023-03-22_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303220099
X-Proofpoint-GUID: WdZl7A3oQkU9yD2YmysA-HXXrkRDopH8
X-Proofpoint-ORIG-GUID: WdZl7A3oQkU9yD2YmysA-HXXrkRDopH8
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 22, 2023, at 5:03 AM, Paolo Abeni <pabeni@redhat.com> wrote:
>=20
> On Tue, 2023-03-21 at 13:58 +0000, Chuck Lever III wrote:
>>=20
>>> On Mar 21, 2023, at 7:27 AM, Paolo Abeni <pabeni@redhat.com> wrote:
>>>=20
>>> On Sat, 2023-03-18 at 12:18 -0400, Chuck Lever wrote:
>>>> +/**
>>>> + * handshake_req_alloc - consumer API to allocate a request
>>>> + * @sock: open socket on which to perform a handshake
>>>> + * @proto: security protocol
>>>> + * @flags: memory allocation flags
>>>> + *
>>>> + * Returns an initialized handshake_req or NULL.
>>>> + */
>>>> +struct handshake_req *handshake_req_alloc(struct socket *sock,
>>>> +					  const struct handshake_proto *proto,
>>>> +					  gfp_t flags)
>>>> +{
>>>> +	struct sock *sk =3D sock->sk;
>>>> +	struct net *net =3D sock_net(sk);
>>>> +	struct handshake_net *hn =3D handshake_pernet(net);
>>>> +	struct handshake_req *req;
>>>> +
>>>> +	if (!hn)
>>>> +		return NULL;
>>>> +
>>>> +	req =3D kzalloc(struct_size(req, hr_priv, proto->hp_privsize), flags=
);
>>>> +	if (!req)
>>>> +		return NULL;
>>>> +
>>>> +	sock_hold(sk);
>>>=20
>>> The hr_sk reference counting is unclear to me. It looks like
>>> handshake_req retain a reference to such socket, but
>>> handshake_req_destroy()/handshake_sk_destruct() do not release it.
>>=20
>> If we rely on sk_destruct to release the final reference count,
>> it will never get invoked.
>>=20
>>=20
>>> Perhaps is better moving such sock_hold() into handshake_req_submit(),
>>> once that the request is successful?
>>=20
>> I will do that.
>>=20
>> Personally, I find it more clear to bump a reference count when
>> saving a copy of the object's pointer, as is done in _alloc. But if
>> others find it easier the other way, I have no problem changing
>> it to suit community preferences.
>=20
> I made the above suggestion because it looks like the sk reference is
> not released in the handshake_req_submit() error path, but anything
> addressing that would be good enough for me.

Indeed, that was a bug. I've avoided that by re-arranging things
as discussed.


> [...]
>=20
>>>=20
>>>> +/**
>>>> + * handshake_req_cancel - consumer API to cancel an in-progress hands=
hake
>>>> + * @sock: socket on which there is an ongoing handshake
>>>> + *
>>>> + * XXX: Perhaps killing the user space agent might also be necessary?
>>>> + *
>>>> + * Request cancellation races with request completion. To determine
>>>> + * who won, callers examine the return value from this function.
>>>> + *
>>>> + * Return values:
>>>> + *   %true - Uncompleted handshake request was canceled or not found
>>>> + *   %false - Handshake request already completed
>>>> + */
>>>> +bool handshake_req_cancel(struct socket *sock)
>>>> +{
>>>> +	struct handshake_req *req;
>>>> +	struct handshake_net *hn;
>>>> +	struct sock *sk;
>>>> +	struct net *net;
>>>> +
>>>> +	sk =3D sock->sk;
>>>> +	net =3D sock_net(sk);
>>>> +	req =3D handshake_req_hash_lookup(sk);
>>>> +	if (!req) {
>>>> +		trace_handshake_cancel_none(net, req, sk);
>>>> +		return true;
>>>> +	}
>>>> +
>>>> +	hn =3D handshake_pernet(net);
>>>> +	if (hn && remove_pending(hn, req)) {
>>>> +		/* Request hadn't been accepted */
>>>> +		trace_handshake_cancel(net, req, sk);
>>>> +		return true;
>>>> +	}
>>>> +	if (test_and_set_bit(HANDSHAKE_F_REQ_COMPLETED, &req->hr_flags)) {
>>>> +		/* Request already completed */
>>>> +		trace_handshake_cancel_busy(net, req, sk);
>>>> +		return false;
>>>> +	}
>>>> +
>>>> +	__sock_put(sk);
>>>=20
>>> Same here.
>>=20
>> I'll move the sock_hold() to _submit, and cook up a comment or two.
>=20
> In such comments please also explain why sock_put() is not needed here
> (and above). e.g. who is retaining the extra sk ref.

One assumes that the API consumer would have a reference, but
perhaps these call sites should be replaced with sock_put().


>>> Side note, I think at this point some tests could surface here? If
>>> user-space-based self-tests are too cumbersome and/or do not offer
>>> adequate coverage perhaps you could consider using kunit?
>>=20
>> I'm comfortable with Kunit, having just added a bunch of tests
>> for the kernel's SunRPC GSS Kerberos implementation.
>>=20
>> There, however, I had clearly defined test cases to add, thanks
>> to the RFCs. I guess I'm a little unclear on what specific tests
>> would be necessary or valuable here. Suggestions and existing
>> examples are very welcome.
>=20
> I *think* that a good start would be exercising the expected code
> paths:
>=20
> handshake_req_alloc, handshake_req_submit, handshake_complete
> handshake_req_alloc, handshake_req_submit, handshake_cancel
> or even
> tls_*_hello_*, tls_handshake_accept, tls_handshake_done
> tls_*_hello_*, tls_handshake_accept, tls_handshake_cancel

These aren't user APIs, not sure this kind of testing is
especially valuable. I'm thinking maybe the netlink
operations would be a better thing to unit-test, and that
might be better done with user space tests...?


> plus explicitly triggering some errors path e.g.=20
>=20
> hn_pending_max+1 consecutive submit with no accept
> handshake_cancel after handshake_complete
> multiple handshake_complete on the same req
> multiple handshake_cancel on the same req

OK. I'm wondering if a user agent needs to be running
for these, in which case, running Kunit in its stand-
alone mode (ie, under UML) might not work at all.

Just thinking out loud... Kunit after all might not be
the right tool for this job.


--
Chuck Lever


