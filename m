Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD196AAC37
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 20:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjCDTtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 14:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjCDTtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 14:49:13 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7558010AAA
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 11:49:12 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 324ITIxV030213;
        Sat, 4 Mar 2023 19:48:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=HEiXjEVdB/2++fpaM3qWtz0hlgLH2sG8RSHTwF3vfLI=;
 b=EzoGQA8TOWEBbGjnnLmDhNzf/2p/82i0qEilH4l4RSNgTMMmGo5Ui/iur6DmwknbOmq2
 x/r1gn8g0W3WQKxTfBjYi6dTVOkbOq5/J0SeWYQ+J1EjtC+nbuxAgTeuAubaPp3yZ9ui
 TON9HgOYxmSSdzOUtrX6u9hAhUzJs77TBRk+1TaPlNZux/uH5EJ8BC1KeV0Gq9k7sHP4
 rPoqCMNlPxKiriWYUMZf0kw/DqxgALS34bAZuhfjaPVo0853XQirSOPvdbrcMArhudsp
 x92diU0CDX7h9pmQ8j1Pd9DMjC9C8ldb6wOWCjGZe5zsSuLpyqE817pfapOlnK3a6lt4 cg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p415hrmch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 04 Mar 2023 19:48:55 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 324JbWJP021364;
        Sat, 4 Mar 2023 19:48:55 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p3ve3kp6a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 04 Mar 2023 19:48:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QQ9KcNS0FDTM3OdqbXfXbae6m5zLkeg2ccMllskiLWA1V3H2/1C+9BZkyeiizpZ++2lyibsZi/aQMPFyFk0vj8ld+AvTKdT/wF6qOXIwJea2EieUwTh9ZmDv5MzlnNnaJzp2i9fREv+lYdiqf+H1I4oP4I9DrZaXyrBvL+4RZN11fHkRf+ehxLUUSR0EpiOHqhv4D6thAm92iOyhXZcogz5HEZQL/bJNjy0srMTYomUfdP1h03XwFV0/WSz8AK+LOSNgtQDGyWWHezqGbaHNlel4kHOxn7xiOZ1niTdMgt5ZBGqFx49wL9K9OrQTs7XSPFPi6ESaki4PS7fFQNf0EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HEiXjEVdB/2++fpaM3qWtz0hlgLH2sG8RSHTwF3vfLI=;
 b=Ocxp6W4prfcTRB1GtUfe/8wRraR8FgT09g+nV8qrutic7a1YINhldr/e/Cu9x6+Zb09pvOVEoAG+v3WbYzNdf6oxCgHHDKBoA2si53vhjsFPiKg6I0lvfKeNKn9dZcCwhFqmOPbt6a4UnLkZqiczTPwUvyXpZ3sqxRom49R8dUNH22ogrt+ReVUwOOv3VqrRG7weO83ZhunQT1ffi27wNUacw1HK58HkG+2UAOQVKbdnLUesDMYUTW6S/q/nvtZl6vQmymAsPaQap1A3z8ZWzzOC5dD8djDgsD7JSrGA2kOXTPz2g0x+dp9z0sXPrwC+MJ3xNFHPVV1GK+vW/2AbAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HEiXjEVdB/2++fpaM3qWtz0hlgLH2sG8RSHTwF3vfLI=;
 b=hxLsfcFwg/WSCMDPzKeXLrZn8wG0YaQm54dVs5ETjrb2KqMubUkfSDgyciMCKFCbDtuGcvmCnucy5ugb/ObmfedKwH1Rq6F9iTzkFW4HVlhembaL3D9fVeOYhdQ91Yk7BHCpigfPKroOlu74I6i7cEf1LYujyNcORAZhlYQ1waA=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by PH7PR10MB5770.namprd10.prod.outlook.com (2603:10b6:510:126::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Sat, 4 Mar
 2023 19:48:51 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%8]) with mapi id 15.20.6156.025; Sat, 4 Mar 2023
 19:48:51 +0000
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
Thread-Index: AQHZTgEx5sDM5wq7q0GXZWBkY2YJz67p5A6AgAD8h4CAAAVfAIAAGZ8AgAAJGoA=
Date:   Sat, 4 Mar 2023 19:48:51 +0000
Message-ID: <C236CECE-702B-4410-A509-9D33F51392C2@oracle.com>
References: <167786872946.7199.12490725847535629441.stgit@91.116.238.104.host.secureserver.net>
 <167786949141.7199.15896224944077004509.stgit@91.116.238.104.host.secureserver.net>
 <20230303182131.1d1dd4d8@kernel.org>
 <62D38E0F-DA0C-46F7-85D4-80FD61C55FD3@oracle.com>
 <83CDD55A-703B-4A61-837A-C98F1A28BE17@oracle.com>
 <20230304111616.1b11acea@kernel.org>
In-Reply-To: <20230304111616.1b11acea@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|PH7PR10MB5770:EE_
x-ms-office365-filtering-correlation-id: 2b008317-42b2-4cba-2543-08db1ce97ae5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qd6CV6lNdIZ9IYhoG0ODI8b5kDzXJzUhZDKsLJ78k7jRNcyJ1UoA6NHW964SZCB2AkK/xQ3Z0V7vm9Wzd2ej3oo7YNplo+lv6HVw2i4O3f+ecld14RJDQpkEdmpayuiPBAuN94RJTu8mMT6rjYPXz/KbnQeBpT7mTQ+HnC0fu6mpVi24J1aEDaO7TFllQ9movOpQWqWhWqKcssabajzScEF1eDGo/2PfSlKpr7zOZQoJNIM+Hslt5ozbWoktpUWjvq8slaY/slHog+CmsM7ES5kmR47XTXTWoQUlJhcyWJEJLq8/bib2HzGw+453LOb0fc3dI0Cs0WxndGQQcPx+59WZvfrM4Y2lVrzZ1O9teH7myhFvkC4tUNyeRcwGVo//1ZFMBer57LJVjmfxn3mo/O5Xhoe91A9hFhc0u0xAemFEDZnK+NwdHamPBFagG1JY41BXxVHeGOJPUBtbQ2hRQ8dSJp8i2gQJ50Nvgf1DADVcNjZdgB9ung6N0EQ+8JL355a5Cvcia/v8yv+/NQEPoS9T2BMTTl31tYytKXunQTcYp9USIHGheCeLEoQTXG7/fjPshXhwcn99UUZkqNs18uNBumuLd5fq0OLMFXZKqEgkpFlKE7f4H4MwNBAadiZQkriHrdg1cefwIfdxuC5nWR3RIsVHV3ZnxebRFthZEyobzI6Rc8xxjxwsmApL0d64hfRw6/7lWoyG/fgW91yfXItOP163iXehOzWMLdHwE34=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(366004)(136003)(346002)(376002)(451199018)(33656002)(36756003)(5660300002)(4326008)(8936002)(66446008)(64756008)(8676002)(6916009)(41300700001)(2906002)(38100700002)(122000001)(38070700005)(86362001)(6486002)(66946007)(76116006)(71200400001)(107886003)(91956017)(66476007)(66556008)(53546011)(316002)(478600001)(54906003)(6512007)(186003)(26005)(2616005)(6506007)(83380400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vy8eawOYRx+od23heziIEfctpj58PWpqZEzhH584QvjqoBLkgCRblQPjUu6A?=
 =?us-ascii?Q?q67MXiKVZ75KGbsFQ1FExQv/sUzyLgHRLW1ks+X0TKTQkGFQRj7nxKsvtChV?=
 =?us-ascii?Q?tmbPth1uiN0PWRlN7L/ontufg4E5cW3ziSmVzJh0ch2wA2vOJ2KKI6cP/ylR?=
 =?us-ascii?Q?XHoreA1xaQZxg1R91enaQRJDTccigqbTE4iTl1CCr2yZahf6OAg86pUyxTNs?=
 =?us-ascii?Q?H/xcDgNtpfqpX7B5+2oljcg4zao0UKGL+U012GKQiNa1hnXgvvqWYgf5lVAE?=
 =?us-ascii?Q?AWaqN9Tm+jzBlUfqCNefJpyLvgP8YRmLq/7Snto3mIjUDAxX9wn2rZ8CBCIJ?=
 =?us-ascii?Q?v3zjyo6NLqIYuZOmm3xCyiTq+PCyyPCkQp0YNdThxnhtNvBYCqZHwd5lNvfJ?=
 =?us-ascii?Q?npi1bsUnxvWazgRStnzbGx1oPShYgBdNIJlFFKNQH8nxF4JOGhnLZ8TmSTvQ?=
 =?us-ascii?Q?bENYuuS9rwn4g9x2GdJCus0t8P2o4JQMm+LaAZR07N7f545gNiZGI8XceGOH?=
 =?us-ascii?Q?/WuOgdGcJvMz5JhhBSJ4gY3VmZjz0+1Ho5+57PFBoFVmqxl0mYwNlJMKMbez?=
 =?us-ascii?Q?0q6m2ApmLXu9KgeXjru5EfNQdscFe2SrFIvrsbkLt1AqFf2tdQB5Y1/ahCmV?=
 =?us-ascii?Q?GiQF5Aww+Kbm8JZpqMjySsyqumd5sSFmBUVjisl9Cq7M0vri+LSX61e6S/JF?=
 =?us-ascii?Q?ErFRLafuY0J3Wh4p5JVrwXSuI0OR2NZgKwOydysIHZiZVV3gIuOundVmErGU?=
 =?us-ascii?Q?uKSG6eJYFqRR84RjZxiA2CIS5YrS8ViYEZ70IUc1M+8UdJJ4w2CR99hYZJCN?=
 =?us-ascii?Q?bIiHvKpeS9Y3RY5SYEcUF2qPUKZvVeyqNw57fTgI2UwID4EPnFB1U7Ly8Rkm?=
 =?us-ascii?Q?B1zryogHua30izn+6fxw4Jy4C0heiR1v9oO2FU9SIZi0peEIobk7QWn1nxZr?=
 =?us-ascii?Q?KVNO2BcPt3Qzveus9nmgCMjVKhesre3QV/6faBnhM4BlbcxVfAnfGAY8qb56?=
 =?us-ascii?Q?8U+m3pUHXiiUkYbiufgvzBUGdZMTih+9l1rZWQL1uzQrcPCNw5Hg8EV1vHaL?=
 =?us-ascii?Q?SHZDwfDR73Re1lSiyXCO5TICKBsY/RfrXem5ZtblIcQkyFG3/C7cfhSY1hhU?=
 =?us-ascii?Q?pMTNwugiuXLJFZzXDD2/w4lyui4NqJQWi2FOEh5yeQE9noYKMirAO+cRXOAW?=
 =?us-ascii?Q?ZrvCq3ab8gSsjfahs/DNsL969xKShc0hKVFg7qENWGEHhKzuj+3pOayEz6pe?=
 =?us-ascii?Q?NQQOUTLWvoEg10rvJzFBaz+OWfmm9gMwxWtGqq9RMTQBkEhbRw0UDk+9WAp2?=
 =?us-ascii?Q?px38Q5IwEkLLkEHDGFAaQl5HuK8MmsjsMuSttKx0GMAyrY1NuMrdUuxNl/+P?=
 =?us-ascii?Q?h5Q59+ZWhuOL4a94WlaAKN5xkVPwyZSVgBEHecbSANw6mNA2gkhMdwmQB+ct?=
 =?us-ascii?Q?0vmzenrqC5RkfijzBDIAAPRigKGKU3z/wUGli1IkKcaQIOnRZ6JGK4ry5Ne0?=
 =?us-ascii?Q?zeaTTtSzxIuta9WD44erDoOSPosOKoKpFIeTkvX+Ib17apHv9m/Uxq+47/72?=
 =?us-ascii?Q?sRhQh8+ma3s/0aP3OEutkU87S2k5l8fF3ZKDO8BlHQj8s/YAN0PeYz8oTba9?=
 =?us-ascii?Q?WA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F759C154CA32714CA9A62B0C98381FE8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 350IqDywwP79IFgEY7dS7qMD2iFypIIyclL2+Pl+kEIMGouu9FRl0yjcl4iCj2exNjmDOO8i17wRW/ycCWFb/foT4TR5Mv6+PreIR4bLNA8EvropwI5xUuPAKToPp7H6PmzMnYrAI7syfRP1X553af6ae2uVUIvvxW3iQRaKHhMJX+98B1BTKnpOQJcE0kKNCOJlmvoLsRC/xhwsbrfpL5tiRv1AaCEOewMkUPN0MCCDtSV6xIjWSI8Ll8VXzApCmfpMDUhfztPWASYG8ITp/yvseDZQrSRXun/702/ZZp6jdiyJfObzi5bb39pjTi8H35GjJb9omhRdUjryht/zAv7aJ20bYjzaJ450YVKB2F47w/nllDcYyXHmXGlWgOESga19n8l/kR/UDm282BvUPAhty2wvdZwi0bDG+P2KM/+ZHqaifU2HhRvJJKfZr33OvZb2OoG4e7HNv6ZFyoBdEwbQEM3zQESM7v9ZfcHa9CMQjWysyXHmchE+eikS4WDKj0up3OiVhwZsrtv6W4S4n1IrhTKyDsssnnJ4dfe2z2XoMYYCxPlW/ZPQszJZDd1WWyRdpbgfRUU0i8UrEdHguB51ptGSc92zXho3RKkdJIHRorLW80pkiE3lsCvoKMw+EptLrdOudOh7GlE8sHCbCEyYdF/1z+670+2PT1anjEHEMBPEvZZsQHfkbmgFOX+AKts7llV3YRSWspwtSKfgoGES0rmNAdS0wWAhHMkiOcREbvykB0NPv4veJirbgB8u7PZCNPNFMOEHO0LKJrATdHkhxoTlgaso87/NzliKMfLdrajMdy9DdVtM+wy2ia2MtyhHN3+ygbmf1nubVIV2xy8cGAPn5k+v7va2m/JGg74A931p+R9gR1Rifw9DTvCVFiUBDjgVAt4UJPJgMpe7xw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b008317-42b2-4cba-2543-08db1ce97ae5
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2023 19:48:51.7544
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mAi6fnWGY4z0ugFMSa03QWDrAaSatU4CuvYYpkP1WbgAYg/pbgPm5axLFdI9WDti1VaNtvE1WJKllEoGyF6DXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5770
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-04_12,2023-03-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303040172
X-Proofpoint-GUID: icKTX8M2sRaJKxRyjAaZfhICgLCHYPB5
X-Proofpoint-ORIG-GUID: icKTX8M2sRaJKxRyjAaZfhICgLCHYPB5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Mar 4, 2023, at 2:16 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Sat, 4 Mar 2023 17:44:34 +0000 Chuck Lever III wrote:
>>> I couldn't find a way to have the generated source appear
>>> in the middle of a source file. But I see that's not the
>>> way others are doing it, so I have added separate files
>>> under net/handshake for the generated source and header
>>> material. Two things, though:
>>>=20
>>> 1. I don't see a generated struct genl_family. =20
>>=20
>> Some experimentation revealed that this is because the spec
>> was a "genetlink-c" spec which prevents the generation of
>> "struct genl_family".
>>=20
>> But switching it to a "genetlink" spec means it wants my
>> main header to be linux/handshake.h, and it won't allow the
>> use of "uapi-header" to put that header somewhere else (in
>> my case, I thought linux/net/handshake.h was more appropriate).
>=20
> Hm, include/uapi/linux/net/ does not exist and I did not foresee
> the need :)  We just need to allow it in the schema, right?
>=20
> diff --git a/Documentation/netlink/genetlink.yaml b/Documentation/netlink=
/genetlink.yaml
> index 62a922755ce2..5594410963b5 100644
> --- a/Documentation/netlink/genetlink.yaml
> +++ b/Documentation/netlink/genetlink.yaml
> @@ -33,6 +33,9 @@ additionalProperties: False
>   protocol:
>     description: Schema compatibility level. Default is "genetlink".
>     enum: [ genetlink ]
> +  uapi-header:
> +    description: Path to the uAPI header, default is linux/${family-name=
}.h
> +    type: string
>=20
>   definitions:
>     description: List of type and constant definitions (enums, flags, def=
ines).

Somehow it's working as I had it. I can't fathom where the
generated source file is including include/uapi/linux/handshake.h
from, but <shrug> it's generating properly and compiling now.

I see others, such as fou, also appear to work just the
same way as I structured it. So, false alarm, I hope.


>>> 2. The SPDX tags in the generated source files is "BSD
>>>  3-clause", but the tag in my spec is "GPL-2.0 with
>>>  syscall note". Oddly, the generated uapi header still
>>>  has the latter (correct) tag.
>=20
> I was trying to go with least restrictive licenses for the generated
> code. Would BSD-3-clause everywhere be okay with you?

IIUC we cannot generate source code from a GPL-encumbered
specification and label that code with a less-restrictive
license. Isn't generated source code a "derived" artifact?

The spec lives in the kernel tree, therefore it's covered.
Plus, my employer requires that all of my contributions
to the Linux kernel are under GPL v2.

I'd prefer to see all my generated files get a license
that matches the spec's license.

You could add an spdx object in the YAML schema, and output
the value of that object as part of code generation.

To be safe, I'd also find a suitably informed lawyer who
can give us an opinion about how this needs to work. I've
had a similar discussion about the license status of a
spec derived from source code, so I'm skeptical that we
can simply replace the license when going to code from
spec.

If you need to require BSD-3-clause in this area, I can
request an exception from my employer for the YAML that
is contributed as part of the handshake mechanism.

Sorry to make trouble -- hopefully this discussion is also
keeping you out of trouble too.


--
Chuck Lever


