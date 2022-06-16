Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A25D54E5E3
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 17:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377478AbiFPPVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 11:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232449AbiFPPVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 11:21:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FD93136D;
        Thu, 16 Jun 2022 08:21:01 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GD9b7Y029767;
        Thu, 16 Jun 2022 15:20:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=VXZpH9Ui9uFOQns/MWxO8PXR9n0CWDiMSaHA1bCiKuE=;
 b=Lmasv0023QJ5X/QOOTZbLP2SpAld0EyIe9hlsLE3Q2GobCKr7LaPyd0CQ3Qftj/qNFZu
 t7YqpkYSxWqt7d6adPlOSGJ6Ct2N/XdMvK9y9zMQST8YulMglQl7qtVDZsa/q/l/oQRd
 6W6Yb7eEBufWG8ivU4vCXQbbFK8CrK7IBr/if05+JlJQ23mt87UMOQFJFQ4Nr4ifoLcN
 yth+kl53b1EMTmZcYpPPflno3UWYQ4S7HEFX4odyK3KyPT3NGtckSyBGnRMMDo3ONHj1
 zJJGjUCbaiJV24W+szP+qANIUFGfcZMRi5L4LC9xZoBudqCa4lLlTRjMAFhuy1es6tGi oQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmjx9kbcw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 15:20:25 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25GFId6j004052;
        Thu, 16 Jun 2022 15:20:24 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gprbsxpa5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 15:20:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eQ+XjqFj8G3TvdhmMT3Eibre8T30etKGP+bdvva9n/ED03w111drMYNhqcdo1CW44HKMREE9rmfOwWR0Ry0BIBpZhwXkdY0usg1C9Jv57R08oSv90U0wwT8JBkZKNJDVhVlYB/6AAeQsYm7xAis0koRmtiDohdoBAeSIQn5Sy/Jjo9pieO0Fy4HREM4Znccv+s1tBxk8rwlrXKYb0uMnJ+yQ4SLTSd7QzypZFKXBl1FrVry0rwwBF4beuYSFhNLTDNbzxoyOZmFpZLzLIxNfG0LyGrt6r4qqZ/NIax9DtTutiuPFA7cixmkJXTiQARW7qeP8CIv/4uoomwsYzFw8dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VXZpH9Ui9uFOQns/MWxO8PXR9n0CWDiMSaHA1bCiKuE=;
 b=Qv06nncsdFJUbxAvA/EQH9w00fjv3Ql1jUKp9ebdz05Pr+j325b3HdCH3dHPkbe3nsXNhPcaMD8wqcOPdhgpFyPxc/d0Cg4XupOUG5jMvZMsg+7BL/cLNmuc7ZaIEjkT8s2XMEXCFCo4+8rtmGKIcYHPeq9J6RJetohdj9X2AnEAxCdjmgUzMgku0U7A+jEI82XUSo1BKQ1qwckHLXxJuqQYQs+FQIigEve0aqdPtO7Q5mALl8HDNO3EvXvuyVlvMtt34VawF/HeXDeaRUhQDgkgDNdHeIzefno1DtIg+KQ1D+skyJ6rKQC7QOYWrv6WiG/9hLCmNVaWhFQ4P189JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VXZpH9Ui9uFOQns/MWxO8PXR9n0CWDiMSaHA1bCiKuE=;
 b=ADguvuwhCCG257SiUy/70dVIlOKLpkyMZCyFJ5yf5iiGW/suKRMSqKbbcGWqmp7SmSKBCavnS9Zex+NpcZvGT11Tgh00d7xvbIdBPE2ma1YjrurVmb2qhkbJ7ptRZSYzFeF7rhP4fw+3/Ko2FrSpc63eX90Xuzs4QCa5Nvlp18I=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by SN6PR10MB2864.namprd10.prod.outlook.com
 (2603:10b6:805:d6::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Thu, 16 Jun
 2022 15:20:22 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5332.020; Thu, 16 Jun 2022
 15:20:21 +0000
Date:   Thu, 16 Jun 2022 18:19:48 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] p54: Fix an error handling path in p54spi_probe()
Message-ID: <20220616151948.GD16517@kadam>
References: <297d2547ff2ee627731662abceeab9dbdaf23231.1655068321.git.christophe.jaillet@wanadoo.fr>
 <CAAd0S9DgctqyRx+ppfT6dNntUR-cpySnsYaL=unboQ+qTK2wGQ@mail.gmail.com>
 <f13c3976-2ba0-e16d-0853-5b5b1be16d11@wanadoo.fr>
 <df6b487b-b8b7-44fc-7c2d-e6fd15072c14@gmail.com>
 <20220616103640.GB16517@kadam>
 <9fa854e1-ad88-9c18-ca68-5709dc1c7906@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9fa854e1-ad88-9c18-ca68-5709dc1c7906@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0053.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4e::18)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4ff236c-4f0b-44a8-36f6-08da4fabbaab
X-MS-TrafficTypeDiagnostic: SN6PR10MB2864:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB286496F854F10DE33C84E3F38EAC9@SN6PR10MB2864.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HqSG2B0nsO7iLl2aW/6ijVdZUwmGtY62Z5TjxQQh85qE16mfKADYgtDsjsUFmCQcftkqvKjPv7f7QVjbYke+lhCGYgJww8TjmkGXNALC1MklG2jTGqTnXF+VoRLfwdbNGwY/tE3e8TJrz23Lnwaaf640fa5LpWE98VdTg9hvGIk4vmTTT3jRjfmzgPP0lCNayutCnN0cQWOj6T+wG3qAYgOCWIVr7QJ/zcIwfshYS0XUEo8ujn2a8030Kd9QVm9qE66vhm6KVaGau1o6WDtEDkE2vZxjlX2R5Q/iVNxmwkKRhJ6HpnMF98nD1cTfl+dSRakGOYHzVtij+HE6ZVuz9punznJOyR/D/qzmTyu281nMA0n17XAOWfybTSQ9Ugyn+81LR5jlyCSq62oXVXZw0hd5I0a5IeWyJVejfITTMasVy3Kgj217MdSV5eSlf6gYmQNNyHQwyoQvmFqDUZCO4U/uPzO3di+p/6NLBopN/6Y4IMbiKxPYGBb5ukO6zStrnYua1hUFLwUxTisT+qRUS4Mq/DiN0XLBb0jFQY1fVj3cYmyhNuUic7djAI+etMhT6mXMsrLvrw6W9OaptR03pDe1e88+vTtXcIpJLnhoPu1/MgM1xLhsWob4epBV2g8jw05CvBapprgcyz8fi2fQiOdG5nVuReOUx45ryriepi/xaUItwrli+T9zhywZpq7O3ZxoU+1sI6EfuyC140EBJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(26005)(9686003)(6512007)(83380400001)(6506007)(6916009)(6666004)(52116002)(53546011)(186003)(8936002)(7416002)(2906002)(1076003)(33716001)(5660300002)(33656002)(66946007)(86362001)(44832011)(6486002)(508600001)(38100700002)(38350700002)(66556008)(54906003)(66476007)(8676002)(4326008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m8zX4k5f8xzpkGCeWn8USzfWi3vFMy+TBax5a2hvuKDBVAm8AR2PSg5xn7J7?=
 =?us-ascii?Q?IuV73phk3qCjYwlVzhb/DxVpwfZSbHOQwjTh3RUO/KMxe7mGiz9XCcvkC8Q6?=
 =?us-ascii?Q?oCkdHmvOoh4bOWKqIaLA1uWpLjPSAGTLmNU7EInHdVUUG3JzYdAp7+9SZodl?=
 =?us-ascii?Q?oHUamowU9SoOZN0Si5smqLwprY4jnVSjuN9E8vFa5dmGSKMezzZ93E/KjVDw?=
 =?us-ascii?Q?HMfjpK6eKublCrca+MCr6HEYIoerziEiSSPzF9RkmtsZsjx2f6/c963C7lSP?=
 =?us-ascii?Q?gpscidfYIfbuAFdEaXkdCXNJUxRWD46oKbKv/Ya33IF/sfWFjJsPmyy2o7YO?=
 =?us-ascii?Q?N5RsSMhoTZ4kJOmQeNdeowChxZGH39kLdfdxgn3ASG0d1Wq5dMr3HnJhgJvg?=
 =?us-ascii?Q?0FTnRjvDjSvItCu+fFbRbuMyRNvT88zCwabIS6Bd9m+uTPctzQ2yR6r2fWb2?=
 =?us-ascii?Q?86ZHSSh3pxS5pUG4b2+AbnMuLciO1/gvxX+k03jkeBMhWJVDLG/ezJ6+wlGs?=
 =?us-ascii?Q?E1/74byX6aEuadYyqtPn/I4OCx++sqk3TEgJP3HKJj+zoh2hYaj2D61TS2Vi?=
 =?us-ascii?Q?ubaTUPaaZ29sXf/2GlLT4FVQd74j3r9fQbXPqzq8/fQoLNOpRFtD57upLaSz?=
 =?us-ascii?Q?GXLWaeyhAxRBY38TYJUkE2t0no0bl3HBRJB1AMAjFnVMbpdEc65uSB20xDZk?=
 =?us-ascii?Q?gwSouvs4SO4NZUESzat+FYaZclMKaOzbzGzsFcnBTAK/0lZj9fj7sWsHobxy?=
 =?us-ascii?Q?qcUUqMWvP4hgB4ueZ7AGJMlZIYwz29dHz/TKpf7Al+Fvl2jVWJfTmysjmysD?=
 =?us-ascii?Q?CaosmBOww1/Mj4UDF4Ozmv0sWsiBt2fuHoEMigo1cgvOIwVIxJYyRHsme929?=
 =?us-ascii?Q?5far0S9lvEHtHrbpsgMKYFtQ39t0rju+n2Wj43XyOLPnRmbCXzoM8IOHwdgy?=
 =?us-ascii?Q?K3fWI3vOLs2TNFQllwImOxOZrDo1SmWK9+YbyZh0oA8IF5AnAVtC0tq69Ev8?=
 =?us-ascii?Q?23Y6lu2kq+oKD1okFTnp3/K74JESanrLtp//tv0eHWcKBEbSwcFpnXJGR2Fw?=
 =?us-ascii?Q?jQ26iilr7ULIdbmq7jL/YVem/9jqDg/lbojDhWtdMS/K2ozwos3YqBG87AwZ?=
 =?us-ascii?Q?Ii6jCrZSIEGoVelXQUKlEGidJ4VzNYMD1nmOjfoxII9z241TgLfKC9If0Bjb?=
 =?us-ascii?Q?HiQQpV7GMzJyXlfcAXO+8Sn5AyAPeTjIJuVih+dpyzGq47DSd4DbCwGO4ulF?=
 =?us-ascii?Q?eP0sVk9dXFj34BTSAVAgueLaax2XPhcz4Xx6T5P+j7gHltSLpdQ5aSST5s1C?=
 =?us-ascii?Q?c40oLiLT7pp94jRr0DhyIfVHPYm6LIfel8nDbOcLuLrGGu14GmI9mQd5HBJH?=
 =?us-ascii?Q?vQ/CRMFlX2eDk/mx7J/sXZekQssbYzt/LaSCoFDCfm593zEBkZezwy0haVeS?=
 =?us-ascii?Q?GsWi0gZkl+ZjW0KwxcvuUA/A73hr92nXOeJsYUSySkF9nIbtPfEGx6HS4t5e?=
 =?us-ascii?Q?kQoXmdx2uXYDg70LSSol4MxjXOuYTgEfbpm5DOxPSdUEVJ/DFMO8uU85cngW?=
 =?us-ascii?Q?4CBFqAgP21t6HnoLh2BhIemnvhACbIFieXqBPT6g9vKuM3WtejRxvPYvl8Dt?=
 =?us-ascii?Q?qhzRHt+YYpJLVluAvQs5Nfxv1sFfZ8iNd/g6dvkPaiLxM2cIQhLdQsEGSQZM?=
 =?us-ascii?Q?p1gAILHYPV5loTz1cCMsY9809FEm2fZLinaWurW1/EP54ARBAnoGemocVbmm?=
 =?us-ascii?Q?nLLE6X9qDn08sL1VBkCdsBLG0h2QIhI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4ff236c-4f0b-44a8-36f6-08da4fabbaab
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 15:20:21.8787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qIViIzuloCKINilLIdV8fUHJSaN7NFQYiZlAE6keFk1RT64EhAng6IZ4e04r04kI1Y1bz0A+P3xs3zj4IOsAq0wRjLw/ukQNPSMZK/b5UYo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2864
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-16_11:2022-06-16,2022-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=960 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206160063
X-Proofpoint-ORIG-GUID: dk00lEazTZr7yimuDOBejB5bdSiuPLjb
X-Proofpoint-GUID: dk00lEazTZr7yimuDOBejB5bdSiuPLjb
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 16, 2022 at 03:13:26PM +0200, Christian Lamparter wrote:
> On 16/06/2022 12:36, Dan Carpenter wrote:
> > > > If it deserves a v3 to axe some lines of code, I can do it but, as said
> > > > previously,
> > > > v1 is for me the cleaner and more future proof.
> > > 
> > > Gee, that last sentence about "future proof" is daring.
> > 
> > The future is vast and unknowable but one thing which is pretty likely
> > is that Christophe's patch will introduce a static checker warning.  We
> > really would have expected a to find a release_firmware() in the place
> > where it was in the original code.  There is a comment there now so no
> > one is going to re-add the release_firmware() but that's been an issue
> > in the past.
> > 
> > I'm sort of surprised that it wasn't a static checker warning already.
> > Anyway, I'll add this to Smatch check_unwind.c
> > 
> > +         { "request_firmware", ALLOC, 0, "*$", &int_zero, &int_zero},
> > +         { "release_firmware", RELEASE, 0, "$"},
> 
> hmm? I don't follow you there. Why should there be a warning "now"?
> (I assume you mean with v2 but not with v1?).

Yep.  Generally, static checkers assume that functions clean up after
themselves on error paths so there would be a warning in
p54spi_request_firmware().  This is the easiest kind of static analysis
to implement and it's the way most kernel error handling is written.

> If it's because the static
> checker can't look beyond the function scope then this would be bad news
> since on the "success" path the firmware will stick around until
> p54spi_remove().

Presumably Christophe found this bug with static analysis already but
my guess is that it has a lot of false positives?

Eventually the leak in the probe function would be found with static
analysis as well.  The truth is that there are a lot of leaks so I'm
already a bit overwhelmed fixing the ones that I know about.

It would be fairly simple to make a high quality resource leak checker
which is specific to probe functions.  But the thing is that leaks in
probe functions are not really exploitable.  Also some devices are
needed for the system to boot so often the devs don't care about about
cleaning up...  My motivation is low.

regards,
dan carpenter

