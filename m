Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60094534B99
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 10:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237968AbiEZIU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 04:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231653AbiEZIUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 04:20:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91AC8663CF;
        Thu, 26 May 2022 01:20:24 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24Q6TOod006666;
        Thu, 26 May 2022 08:19:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=Zy0xGULddVRIgYZC8n1rrvovk7JzQwZZCbXUC988X2Y=;
 b=ETVsnX/AEpp+vOuqRaouJK9/mETdeqQUhIN2lQL/OfaAvz/p3VtgUo+SKg5tY4IIR/uR
 1n8My3jw1u4DjWCmHvyZ4DsnhWY2niy2Vj+kN8tgk3EHZAvxl5hjNFdoTiJt7bm2Afss
 MSX+JJdiTUp50/0vDXOoiWGrcTG93AGmgnbNbvZNcPM/JEi/Ie/VTzCaAboVNGQb2SmJ
 clD18oJafzDqO994S3sQDfTVE0QztCmKd+QNAVqbEn6LkdHLjsY5zZul/hT8rAOCAi+r
 2BliUCmSQ2GH7nbIhNC6b7ixlXSDlY3Ki7OaLX0iiCZxVqTNd1CqhGRhcGpEsmqUrJS6 7Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93tc480r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 May 2022 08:19:56 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24Q89xh4015636;
        Thu, 26 May 2022 08:19:56 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g93x0jped-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 May 2022 08:19:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eOg22U3Sa0Ka9CL8IdH2WDmMqJiT8WcYGvdI5zxKFQReM/YwF7iwGD4KRjLKGdNCqwzORaTxthhGutRJTjTAR/ZAF/n6IhjrAO3UKn27tsY+vytiEcdq/4AgIv1xMjIlauES3JQqmFN+d6W2hga10VtT/dLbC9fovp5TEvuaIOgLE+mG9MpLdbPCNeSClBRpP/xuKAWqjCBEs8C7xJ5uGSiUmOTmDYcrVEqlzgCmcestcO4/4+BZtKEMPXiRSdELzHzlfBOfcqFJOnKr8hxvKjY4bvDA8Gxm8noIRrzEULpAw8bxUPfBzqjLbZYls2cbmOldgy/lrCju5eBnDJ/KzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zy0xGULddVRIgYZC8n1rrvovk7JzQwZZCbXUC988X2Y=;
 b=cwgQktqxW2KZDSTu5MlRJJ86NB5taTt6SouFLTMfp6mLHoD0KSY9DUPqVwHlux8H4FHRpJKRSfHWOUTyWIZxrIaIV5dVOuELlIfiLly85sKpTVD0gL/F+tpJkSwkeui7XesSwEpd9xJPuuaIS7TkH3hJ0KGoHYdrS9f/8us0LNnVUOCokDIfYubIPB0nGV/unLigby5D0WvXnK1nmFq2fxQ0I4AGBHPZ8rKZYqSBezDruEaqZ4acyfY+vlUCQD0phnGWjaYHCTrll3TB9duQwzmnNROO3g1VtOFWeZrCCaSuruP538JRQFP3X0dvsJEp8Lxp3Om8fd5vp/VBMtD3bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zy0xGULddVRIgYZC8n1rrvovk7JzQwZZCbXUC988X2Y=;
 b=vp9NENJaz/x+9isDEPGfdeArNKAp857AoK4SlfaxIJFZpduOycVtFwE62JqOKheHOAsYEiUp96U6ro5LVhcfbxdRtG58qgVfidraozivgAF6RLwa7ycHtNBjMYKLhSqc7HOSPEVxI0wf2GfFkUDJ/TgsB0rpcMjSUX8wMBnJFOk=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN8PR10MB3715.namprd10.prod.outlook.com
 (2603:10b6:408:bd::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Thu, 26 May
 2022 08:19:53 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5273.023; Thu, 26 May 2022
 08:19:53 +0000
Date:   Thu, 26 May 2022 11:19:28 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     kernel test robot <lkp@intel.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-riscv@lists.infradead.org,
        linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-parport@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-mm@kvack.org, linux-fbdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, bpf@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, alsa-devel@alsa-project.org
Subject: Re: [linux-next:master] BUILD REGRESSION
 8cb8311e95e3bb58bd84d6350365f14a718faa6d
Message-ID: <20220526081928.GB2146@kadam>
References: <628ea118.wJYf60YnZco0hs9o%lkp@intel.com>
 <20220525145056.953631743a4c494aabf000dc@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525145056.953631743a4c494aabf000dc@linux-foundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0055.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::11)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cf96367-7ac2-4c43-d2db-08da3ef08279
X-MS-TrafficTypeDiagnostic: BN8PR10MB3715:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3715BBD9ACC09563B73F4E238ED99@BN8PR10MB3715.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PB2ELZKg3ACxJLl2VTtsEh+7AVokZSWYmqigbXtSz795s4HRKN9NleNO9/K1Gg8CfKMVSQECY5N3tFpvJA0y2py6al3ZsGO5azRk0lOFfG4cWkyf0nCNm0UhlEh8+nm6ah/ocdCFHZiSohTYewNllOvHAS0OHbDlrsY7lTpeSUFzdsP/gPDiD+eikJgTYQ1lENWdOLwgSbxydW4tz/nEaSacKQYpTM5z2QgGEXCNBTcIQJSA2NpDskuMO41K5G5UG4ODpYqdJT3nHZuPNNC/DXy89nGm32ZnNFuGdwMB/sWxZwMpu+K2bEZ+JDgg1cqaxzNa3VNHK2klCymPKMYXN0Dc8+4w5XPMYobuG/Uvh1IkibKZ9a+TCFFRgC7+fwK1jH6E0rguVgHJ0YjbpdcYb72gp0eFGguZdZzQj94NWQ3mI6TAyLYHH9ajKHsS39r1Zi4TSzVgvSSP9E2lkYJZPGp2hJjwGqwHNLafJFFiBWKX8ThKXNEFPBPW0vZJa89BcJcINhVC5HIIZ3O7GaZ4cMqV6Wg3QaI4+zVz+Do/fsR8L3Sbof+gNa6BgBUqBWxX83fYisLyWEOfxcyNQgxWeho7OeEjXydT5bfsoc0FYvQWeRhmXhEimpjM9jGL/k/ZaFgSPHqgzgRUXVqveVcDikOrfSz5839REdWHx5YxsjKb6ZDinlT5jvDQY4aZHXSd/eEi2qQDjnteQjznvM/hSfwFXjSXX0E7RVKbYVpJCoP4nJJzECYPGAI87JZsEixn4BwnjatkPYCPi9bwpPACgwZ+JyjupEssztMpalmM+Bk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(316002)(8676002)(7416002)(8936002)(44832011)(4326008)(5660300002)(6916009)(6512007)(9686003)(6666004)(6506007)(26005)(508600001)(6486002)(966005)(33656002)(52116002)(66946007)(66556008)(66476007)(2906002)(33716001)(38350700002)(86362001)(1076003)(186003)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+4zbNWam2D0bM/zgUlESN3vhRr+RuDpppDvipKEYxlq+/+5WLyq1NbVkLeDW?=
 =?us-ascii?Q?/5xdzVpgaZTxkeTSK/jed15uikvGdZti4e/bjWBIHzVRZrY3AFrbgr6ZF/2A?=
 =?us-ascii?Q?qLwt/IRWaBSXptp2+gkpryXi+VaVwuYlvp6EnQwyzTK5itTAjvzxpXLLlMcp?=
 =?us-ascii?Q?G5kU6AIFnVFCQjWJYsBuVM0zEtu7SkRRMSRMDZeOXwzA0pMiJFJq0pgNFriB?=
 =?us-ascii?Q?2oCu5CH/AUq29Ex96g4jBPnNAt6bNJ3hAIjrv9jaKA6hA/y7lZV1ktsX3Wte?=
 =?us-ascii?Q?6fsVPdx4iDfSdLvMp8OoVYk2VWj6EkAdCE8/5HPqxARKWxVP5q0zyqc4WFW0?=
 =?us-ascii?Q?wJayDwQ60dV9zGyXFzDSV8sYRLSlT65y8us1C9vhg9XANZaxtS92R9elEpnZ?=
 =?us-ascii?Q?9NVWIA0Jo4mHsNntT9rJHyz0uck1akEI4UaTuEdvpOVY8CWfFIllutagTqhf?=
 =?us-ascii?Q?wN14yWCBwUk19pX2CRTzs4EQSqJokjQ62WmVFW0qDz3EpH++ASQvHA0qZTMx?=
 =?us-ascii?Q?6jNxBblD+6QBSEIYsCVjnCM7hjbXC7qKApZ2ULMd0HkZJdlga8xrJNkhToGh?=
 =?us-ascii?Q?7dyRgsDjyk75IzcHnyE761PHJKtXkht22JIapQiQa2jSnKSF7ciKqbK/Y/LK?=
 =?us-ascii?Q?8QppC+Q5bMpKQOrhVxZSJ5NA5NNqqnOvxY6stvwqqJAkRgDG3HJYOmzwaCxg?=
 =?us-ascii?Q?lVXZdq2wYXzo3xOrCeoUB/JhimW05fevkXx/rdK1e+7agWoAPJLMt6Ekb4/A?=
 =?us-ascii?Q?6bTkogQcoC0aAkN5KjxwSJZGA3wtqAhR8UIAu+hTp+maj+ODjgXIeLzOBHZ6?=
 =?us-ascii?Q?y4+gPf6+lxxIjCsB55xsQLh/B5N5ovPYcUAxomfHYdPKbzue5x8jKIXiEb38?=
 =?us-ascii?Q?mdMf8mC/QFxLoQI0rvaUs9Sn4z+vUiYY6ieCB7s/qT5XLsXavDIqMe/CZWUx?=
 =?us-ascii?Q?lnlXW9RfZyHEJ6DQmtJJzR7tFQx74qhCZuX3sKs9Kz6h6M21cIcosv3EubnE?=
 =?us-ascii?Q?HIwZwyHMQrbVKXR7K3pi2ON9Ju+88Ffgjec5QANLX3hUmFYGbe28WGlcq9j+?=
 =?us-ascii?Q?sKS8rDXUFb6tGH3axtECcJHxeOt5wuAOqVc+yKlxpyoGE+7UyMdph+CFbAKW?=
 =?us-ascii?Q?i2pMHDlVJXjObBcrQ5A40mKOlKUczQWD0BZZGhGTKQyftGS2wX/4oKGX+grT?=
 =?us-ascii?Q?Ke9qqtWOZxVmLZAsWY6GezEXMy4MoLn33zjDzBSrWr0roJxImoda5/oVmjFO?=
 =?us-ascii?Q?m5LDfGW83FC4en3k28R7BPvJ6BfGt7guxnomfqUCsTaNmtN58zZ6fHCld0CN?=
 =?us-ascii?Q?SQiQIOHDQNqz+dInhER2/0Pl7PoszLOev2xY/YJjvICeNlnUKHkPp99LKsOc?=
 =?us-ascii?Q?PcvLx5LMBHf9ibxvwYqKrzOJphMNG5mYp01S4LFV3FRDS+Co826IduITrXvJ?=
 =?us-ascii?Q?S52D79+bD3vl/4ztCbmQ1ugevZPCgttZvtZb3r6JNekk61gVyd6ilpOrhm6q?=
 =?us-ascii?Q?Px/vnlkuNXQ24cL9mkIRZIWdzRffttpAg/ZS5VVj1EhhKKalIMsmVUV1zryX?=
 =?us-ascii?Q?6jna3ld65pLQ7U1SXR/CiEQEeyFXhxkV6yrVvaePxW74eH3i2SCiD1jne8VX?=
 =?us-ascii?Q?qmPV8LiLBkpo57/y0lk1F7o2+700F7SsJGkNLdQnfvymbJ8k0nivUnuuh8zr?=
 =?us-ascii?Q?mEziZXqV0EvxWHMMGogolzXmYKUiSWeIUezVq6TXRX7xuZvwTA54Xtp6RqT/?=
 =?us-ascii?Q?zqU2YjzjLSUA4XkOBDEBDwbCX3i8gXg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cf96367-7ac2-4c43-d2db-08da3ef08279
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2022 08:19:53.5472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lZjCSWnS7E0CEnPSZZADVOZcSG39DtcU73MbtXbgjimWt98cSLIACYRuLaJrN/3v+lc+3vs8ztSeq2jaDARp6QJdhPOUsRD+ssQ94TwvLic=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3715
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-26_02:2022-05-25,2022-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2205260041
X-Proofpoint-ORIG-GUID: 4n9fsYReWhPcGGMgi3Ucw58Ums7lKscl
X-Proofpoint-GUID: 4n9fsYReWhPcGGMgi3Ucw58Ums7lKscl
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 25, 2022 at 02:50:56PM -0700, Andrew Morton wrote:
> On Thu, 26 May 2022 05:35:20 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> > branch HEAD: 8cb8311e95e3bb58bd84d6350365f14a718faa6d  Add linux-next specific files for 20220525
> > 
> > Error/Warning reports:
> > 
> > ...
> >
> > Unverified Error/Warning (likely false positive, please contact us if interested):
> 
> Could be so.
> 
> > mm/shmem.c:1948 shmem_getpage_gfp() warn: should '(((1) << 12) / 512) << folio_order(folio)' be a 64 bit type?
> 
> I've been seeing this one for a while.  And from this report I can't
> figure out what tool emitted it.  Clang?

This is a Smatch warning.

I normally look over Smatch warnings before forwarding kbuild-bot emails
but this email is a grab bag of static checker warnings from different
tools.

This warning has a high rate of false positives so I'm going to disable
it by default.

> 
> >
> > ...
> >
> > |-- i386-randconfig-m021
> > |   `-- mm-shmem.c-shmem_getpage_gfp()-warn:should-((()-)-)-folio_order(folio)-be-a-bit-type
> 
> If you're going to use randconfig then shouldn't you make the config
> available?  Or maybe quote the KCONFIG_SEED - presumably there's a way
> for others to regenerate.
> 
> Anyway, the warning seems wrong to me.
> 
> 
> #define PAGE_SIZE               (_AC(1,UL) << PAGE_SHIFT)
> 
> #define BLOCKS_PER_PAGE  (PAGE_SIZE/512)
> 
> 	inode->i_blocks += BLOCKS_PER_PAGE << folio_order(folio);
> 
> so the RHS here should have unsigned long type.  Being able to generate
> the cpp output would be helpful.  That requires the .config.

The heuristic is that "inode->i_blocks" is a u64 but this .config must
be for a 32bit CPU.

I'm just going to turn off all these warnings until I can figure out a
better heuristic.

regards,
dan carpenter

