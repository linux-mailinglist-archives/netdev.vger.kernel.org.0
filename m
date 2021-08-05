Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 857B33E13A8
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 13:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240890AbhHELPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 07:15:10 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:37148 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240777AbhHELPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 07:15:09 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175BE2Fk017366;
        Thu, 5 Aug 2021 11:14:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ygDm9jETBzA5gCXRq2wO9HkKk3whkRXoMvqPuIuAS9w=;
 b=CRPlivzveBIL0d/Ec/NEdJ6mzIJiJegzFJwmSoB2U/IlarvDoBbqugfO+5zTZaisP2lA
 0pbVrsStUIRXTfBqJJsP5XrElcVstysON8Kmy/+fJIOAy5w9/J4ec6t/smUJb+ESkbwE
 XOk8MWzpFGdetnQp7G4n16bEOo8/uI1Je/QRA49p05NuDk0sOQpUCTF6ote03UQ2bLW+
 qp3qDt9qGn4q0k5EDVYEVOqyjexczsTVpb05kU0sI3zOuBT2fU7KNvHuDINqFSNml/+a
 bu6rUNBKqKCd4VYba4gLAnZsxzy1WrpbyS4bJI8wLGrykuUUQQy9Z0IJs1elzW/rqUeU SQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ygDm9jETBzA5gCXRq2wO9HkKk3whkRXoMvqPuIuAS9w=;
 b=eLIjNkNzJ83B45oKWR2X+rm4zOFys4VhS2ppKtsosl/Ydg6baYsyTxUKIPiJ4WO55hKZ
 Qwb9G8Ye1p5PqXIK3ZwjkLJUBBpC29zAjZSbk7PBWyQ3tcwz7lY7iNPdH/sNKTvDbILt
 7x+Wfsq0jWKuWXXtGTqE2HgY0URl+NnivehPu9i18gLzj4MXTEovVOZpcR2aaG36VOhO
 9TxTrmABstDqHCggZEcHYo02Bj8FLYx0JPB+PXoD6vFApWsNOACZW4qxJ4cMe5zuYw3q
 9NSXMhm72gv3h6iemjQH2sIPId6/RtrI9KdhKQVd6PYjwQ53o5GsxznNKVzZSOwkadsi +g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7wqua1js-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 11:14:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 175BAD4i097861;
        Thu, 5 Aug 2021 11:14:37 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by aserp3030.oracle.com with ESMTP id 3a78d8ef1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 11:14:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VzWvUJ9hjaBs+ektkUk9sojmxosUILr9YVpl3ctemd8IxObR6svmM1IWs4gQGxv7coal6ERmgbdABXoiDdhXqQOQCUX6j2pnPsy0tyy8+i91i5XdYGVoggQyZ7XaZv7cRlQba4TOW2ObhhtGjTDuyoWUwwT6ateR1wpFW2+A7CkFHO6bVkTvnZjhkRZlrDv5qr64NQALoT7h1PFtvouoWBjVC5ylnPKYyB1hC12dMtWjFYB6d3eDMcVGoXdcurohEd5b8saFRNY92zu1PJcdR0k5Ri8RD2cWy2qPJU2lJ/4sXfF5KDP1ux5hHK+kITzEfR6wJrV3Elzra/+h3qHUqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ygDm9jETBzA5gCXRq2wO9HkKk3whkRXoMvqPuIuAS9w=;
 b=RkErUeSv5NBfbG1MFHV2fLJIMQPtMBSVPrAsDzr4eInYfkLgPbGAKnttSsJRLNOwGacn18tO7yi/Ly+f4NlNLXVFZfB8HI7hwH4bIfH6hGzvMrFHE2PgbdwW0zKvp1A4aUH2las+NH9AFRJjTCfL8YXSlCtB2o9WRrNiFHYMlU65jfygGg148K4Aod/DAsM2wOcUSrWlSischy7mXFuh5d1eNou67L4TNtkspU8EjxuEf2yRbg2y9CsQPNdrKzMhWiYov1uKdYl+clCbFcZcqjOh9b1wpXfRLaUDTfKjNH8u8MfRqWhaHSKTgRQoa9/h2lI0c48AkqAh8Fal/+BVyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ygDm9jETBzA5gCXRq2wO9HkKk3whkRXoMvqPuIuAS9w=;
 b=EIV1PvC4KTP+xQBb5cKwHiB65cPhjHNgDQkQuUeIWZyygyukpAN7s7k7AILW07Vsy3en/Wi7n60k+ih8MTYbEFWhhSzVPw5f/TzfYo0ITUKtfBDBHfbCjCeqSzQE1UHpH/438HeEHx5pvGVxX4qnf0JGHWxgp3f/3FlnyCsNlSI=
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3168.namprd10.prod.outlook.com (2603:10b6:208:129::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Thu, 5 Aug
 2021 11:14:35 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::b899:276f:7d36:751c]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::b899:276f:7d36:751c%7]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 11:14:35 +0000
Date:   Thu, 5 Aug 2021 12:14:25 +0100 (IST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Daniel Borkmann <daniel@iogearbox.net>
cc:     Alan Maguire <alan.maguire@oracle.com>, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        quentin@isovalent.com, toke@redhat.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next 0/3] tools: ksnoop: tracing kernel function
 entry/return with argument/return value display
In-Reply-To: <9fab5327-b629-c6bf-454c-dffe181e1cb1@iogearbox.net>
Message-ID: <alpine.LRH.2.23.451.2108051210470.19742@localhost>
References: <1628025796-29533-1-git-send-email-alan.maguire@oracle.com> <9fab5327-b629-c6bf-454c-dffe181e1cb1@iogearbox.net>
Content-Type: text/plain; charset=US-ASCII
X-ClientProxiedBy: LO4P123CA0102.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::17) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2a02:6900:8208:1848::16ae) by LO4P123CA0102.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:191::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Thu, 5 Aug 2021 11:14:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa88660f-86ff-45e7-f9d2-08d958023528
X-MS-TrafficTypeDiagnostic: MN2PR10MB3168:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB3168A496359C76F73BC1007BEFF29@MN2PR10MB3168.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vf9bN1pyaqyEo1weC7d13n8bnelM+lb8LiFEmbXSf8AYT/eobLY83shfifE7ZEj3IEaaJtPopzDkCoje1bpsv1WESVDptBuf26rtadysQRHhnhmuS8oNL8h1YHIRh6nOzVCjq2nM3zQlpyS/OF5wgjliDDQbtv6PRIrxse8Qrccj3dHycyDTDkpChOe9lmCUncIQydIoAbY2oPW/5b9teSt/jET15p6W35mAFyuzDAaeOFKqUBs7I+4g6EE5rqplci1+VZ7s2hck7m2MJ2CpZvCA7vz8uQW/GQUDSONx9GkVf8Jizy4KEKD3IVIEKtzRKLMxT3bPHgDhHeHTvVFWmvganRHOqKSVj0YknVabeoEefnbKCcTY0ReH4djH6tEunIg9VPqE/JkraP6sPVQkJ4+j0tV7CIxnp5SRD7QoefZpJss94mqkjho32oGEtfr71jhMkUgfGBectvz39e52Hsjp2iXERaJDTNqPpXcooWvekdV/Ue75VFMs1FEam/vL2PCSo4BiqdpT7KOQqlRJHm7jngsQJCt5evNb9V12kG6awznHCyfH7tX+Jrrw3lemdb59oT7rucqmFuihyXRsXb8sAKe1fLw3Wnva8RfpumNxzGZUK6w1MPaifEDP1SEcjvk8eJrJECojBS5bVbVRtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(396003)(366004)(376002)(478600001)(8936002)(44832011)(4326008)(316002)(6506007)(8676002)(52116002)(38100700002)(186003)(6666004)(5660300002)(6916009)(53546011)(9686003)(86362001)(6486002)(6512007)(66556008)(33716001)(9576002)(66476007)(66946007)(2906002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uZ/PksgAjIijOX3u/+6Zl2i5n+Su839Vn5YEQ6XToe77PPNIEKVn0jZ+OX78?=
 =?us-ascii?Q?bO88offxdIu2pqIk1K5t7ZzwgHTsbAlDgHPeMBrxHm+CVf2kx62wajlWP/fz?=
 =?us-ascii?Q?8XXCZbUIi/IuTYVVrqgUCJlZcYkDQIDtj7Xjh82apAzUbpziHiOsiIGwOKep?=
 =?us-ascii?Q?q5qJ8BOnEFuTq0R/LJrpLjSVxaghwJn8eC1XgznoFdO3W5ncx2zh41Ys8X5v?=
 =?us-ascii?Q?FFhNOHGxlzMz7LlpT7qTjnw2wHgVlujA6raeLk2sRmSCi9Z0Ck2W11WRpY93?=
 =?us-ascii?Q?6ke2Q2L/5ArnUEbxLdFkJ/GatTl/P4QI7ohwkQIfpq1/HX6/E70ZB5qMBs+B?=
 =?us-ascii?Q?7hYfN3PSb+FB/yqb4tA+22iR5ABLpoQjBGNwy4YkW0ZvnDf0lVUVRTjgZYjA?=
 =?us-ascii?Q?8LJA5l/vxz95r5FaxxNHyLpfUK4s5RDCsQ5aPklIatceUPjbOEKiLp2fbKT0?=
 =?us-ascii?Q?hax75xYO/6dK2uVdsloW67DMTWcS7Ar4+2A6K/6iOoxYLCl0WgS9e+ruJjJr?=
 =?us-ascii?Q?OqT23v3g6jN43uHuRRXv65FRAbWvWttkhyHYk+GpILwaweM3aRFfBvjuOhA1?=
 =?us-ascii?Q?N7eCEX0J2HtlzR06+nAk9zzto+svk6Au3X8EJ9H4DLbvmzTzUCzj1GSQNnmg?=
 =?us-ascii?Q?h7ghmDlbWnaR462UNmAUCbHW/Z0FLB0prvostibvzZ0yIf+7wh3PFRTYYzoq?=
 =?us-ascii?Q?c8J6iME3y5GSICNHpWj8z/UTPSD1C9eA5Y5Ub0J6EBNSV6ryJEHHp5VaNbNR?=
 =?us-ascii?Q?h0iVuOgM+IehQO2T3TVmv5gLsFyc3l1aR7QCEJXo1euLAOIen/zU4ceuf1PW?=
 =?us-ascii?Q?ksTDQmwCno04C3OF/VEctPxVfQ/8EjzdsRe5n3jj6SaGnyvXtKZyqLhIw15b?=
 =?us-ascii?Q?KOFZptIO3L2mLf3MFNUgH4fX6nIgwon/hIJka0Huwm4OieOlTB4SOwyL1sTX?=
 =?us-ascii?Q?9hnj1rxkNjoWGz5XJ5G86du2ggXkQMscS0kTcavbe77NqW1CfL6Y0z3l8qq9?=
 =?us-ascii?Q?43c7BHqpIMjYeQnKRXQDLmmJ8mrRbv7ZkI7blnF6qrABA2j4vIb94NEaQuYK?=
 =?us-ascii?Q?R61HkVYCcotdPNDU3xbVSuWlYz1yKT7gGacCB2IFP8sgEjgnrFlxZlAR5tpi?=
 =?us-ascii?Q?RmYGp/8dHk/R5noNJ+THmV5ckfR/4wheFcezBWxX65grJFv3/3gZCND34HqG?=
 =?us-ascii?Q?Ben6A6LhWbNeRBXIuiQhZ2fnPm02NAH/EU4VUVTWhGu5jhstdqs0x0TFqM+6?=
 =?us-ascii?Q?zIenhXuOXJ14N6jgNNiH8tOm/3wlfVnpxeQlo95ORPm0YGZVe1PdcGlHIRR/?=
 =?us-ascii?Q?tFd+UIKuH5Y3cXZJ9ZFAAcebb5cV45Rh4Js88eKEbGzr0g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa88660f-86ff-45e7-f9d2-08d958023528
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2021 11:14:35.7311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J6p2S7ZwXYkE6PQRaArheSl3P3eXYbTCZKzJ3lCyJqJAVrKp4B9NfMyg0Zwtf+MwNuwtblNi8wi8ixqYT5u4Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3168
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10066 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108050068
X-Proofpoint-GUID: AnQiOFRJqqOus3lDmlQciJrCvc08G2EN
X-Proofpoint-ORIG-GUID: AnQiOFRJqqOus3lDmlQciJrCvc08G2EN
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 4 Aug 2021, Daniel Borkmann wrote:

> Hi Alan,
> 
> On 8/3/21 11:23 PM, Alan Maguire wrote:
> > Recent functionality added to libbpf [1] enables typed display of kernel
> > data structures; here that functionality is exploited to provide a
> > simple example of how a tracer can support deep argument/return value
> > inspection.  The intent is to provide a demonstration of these features
> > to help facilitate tracer adoption, while also providing a tool which
> > can be useful for kernel debugging.
> 
> Thanks a lot for working on this tool, this looks _super useful_! Right now
> under tools/bpf/ we have bpftool and resolve_btfids as the two main tools,
> the latter used during kernel build, and the former evolving with the kernel
> together with libbpf. The runqslower in there was originally thought of as
> a single/small example tool to demo how to build stand-alone tracing tools
> with all the modern practices, though the latter has also been added to [0]
> (thus could be removed). I would rather love if you could add ksnoop for
> inclusion into bcc's libbpf-based tracing tooling suite under [0] as well
> which would be a better fit long term rather than kernel tree for the tool
> to evolve. We don't intend to add a stand-alone tooling collection under the
> tools/bpf/ long term since these can evolve better outside of kernel tree.
> 

Sounds good; I'll look into contributing the tool to bcc.

Thanks!

Alan
