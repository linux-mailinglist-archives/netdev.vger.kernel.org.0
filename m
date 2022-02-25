Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0CA64C4A36
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 17:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242663AbiBYQNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 11:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242667AbiBYQNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 11:13:31 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE7A7DAB6;
        Fri, 25 Feb 2022 08:12:56 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21PEkLbw011694;
        Fri, 25 Feb 2022 16:12:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=qOIHO9F+iMWkuqRQNfS7RzLmV/jhFTQhaeW/2WIrY+s=;
 b=T1/P6LEIBSbeJ61nRbsiBU+ummEKAP7T5SHmB3PRwxwWlFIrZS6hDvt8WUU75AL8Qd3S
 NNLwVxGx8wa/V8iEtSjLFj0nNdkYPuNwwmJaCuog7oAUbOKEsvtURwpc55kIgXkUYQJv
 P6NbhHCWcVhAzeTSfw2ZRpditcG/d9QaRmYFRGNTR9wso2Z5FLbwi9RjKYS5HALYJ+T3
 Bfb17DRneucui9gh6HmnyblyeoADoCUdxfpCLWgV//qJnAKJR1KHkI7/ObnkxKJLNf9t
 AHFJ9Y6qLUjHykzYPGOgh0UW7xi6JuR2Nkd1UKH0tXTbpGtR8Ze9CttdlBJXjRUPp2R2 8g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ef06b0qr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 16:12:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21PG52ll023712;
        Fri, 25 Feb 2022 16:12:30 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by aserp3030.oracle.com with ESMTP id 3eapkn0fxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 16:12:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJzAf3FEXEtCjYu++qR0L1pkhqcR55xIlHSqX7hx8isHHHd4oMvmLeq5g3nYUuxCP0XYPrrVwYghseZMhYlPFjwxXpEbgA88oV3BsnU1D6G6RTOvrerzweUVx3N2+nHEhm4ZqnncvgBL8qnPF+upQpYLBbOvYyUrCI4eM0dWOtGk55LRsAFCi2L72IJeQPjmw9PG1XYhZUwEAeVKQmvH0UjsDN0+HcR7O2p+aHNXP6SUgD4b85azMvg+kwlcd/kvjLsBD/6+A3X4La4p14QhLBAplSOF1AQjd73prjOszUaRI4sucPP5PbwBaMuuEVAr67bZIBmJLjIcmDO95lfF4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qOIHO9F+iMWkuqRQNfS7RzLmV/jhFTQhaeW/2WIrY+s=;
 b=i6JcQVtUzx0H0IYiIDOswUBYjf8YNNpVQYKDGhuVUiiZr8dMo4eLy1PD8lr6x6sywjTa1AjlaAlC1aG8LG8/SvXyu62HQ0akQnC5SPp6oRbNA/aLHM4DlualdJFFmGTz6oS7FsqC0Mav0fjVgsXIZjw9RcjrdkKvvcrI2k91p9mtJOE6mYcMPaJqf7kCLK5ONy05voBRsSqwlxyNxfXXF2guHaaAFEIi9oCSRKztv+eBaD2oXNVWs7ALhCvpzK4RU9z8YsL86ZzeFNCZanb7/UwHVkWzWWVLyN6yb3evVr/QfFtlGq80ZQmduGGTKhanj9lOUHBRRC7xoaBn7hyL3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qOIHO9F+iMWkuqRQNfS7RzLmV/jhFTQhaeW/2WIrY+s=;
 b=cbsBX6FpxyqYBNqbzVez8M2evIQZPNr1oBX12z1mti90Im0qQPBWELkZFI/YIIGtHHe4pHynF2KjS7qgPSmrSwWnMJOiBOuLt5eQ3s/nVBvO6nYKtdU76g/IGR6pZCVV3slOOlSFX9ctKCdHMGLgfQkH0M9Fa1wadSYKmpITIeA=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by SJ0PR10MB4560.namprd10.prod.outlook.com (2603:10b6:a03:2d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Fri, 25 Feb
 2022 16:12:28 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::517b:68:908d:b931]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::517b:68:908d:b931%3]) with mapi id 15.20.5017.025; Fri, 25 Feb 2022
 16:12:27 +0000
Date:   Fri, 25 Feb 2022 16:12:14 +0000 (GMT)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@MyRouter.home
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
cc:     Alan Maguire <alan.maguire@oracle.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Yucong Sun <sunyucong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH v3 bpf-next 1/4] libbpf: support function name-based
 attach uprobes
In-Reply-To: <CAEf4BzY-Q1SbrKXg-9GZ=2=Gh9kxocmzksn8Xib+rJYs+WSGiQ@mail.gmail.com>
Message-ID: <alpine.LRH.2.23.451.2202251559000.14550@MyRouter.home>
References: <1643645554-28723-1-git-send-email-alan.maguire@oracle.com> <1643645554-28723-2-git-send-email-alan.maguire@oracle.com> <CAEf4BzY-Q1SbrKXg-9GZ=2=Gh9kxocmzksn8Xib+rJYs+WSGiQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
X-ClientProxiedBy: LO2P123CA0104.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::19) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 879fd1b0-1410-4003-a1a2-08d9f8799e0d
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4560:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB45601AF442BC17BB8CF8EEADEF3E9@SJ0PR10MB4560.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: amt0etJpABL2Lc8tKplg45J3BvvqmWqM5N7hOIGhT3jVQo9zV1ymSH6+SWEgKqo2Flbg8YFqH9ezjym+34X2UjOG8l8U5P5USQUQostEDevwvZWNuJVm22cAwViDtysfcj6gBQQd9701Pw7aPVviyXcBlhbPQODm9emXOkuMv7Pz7WSsMVu0D+k7juYhtOaivXdwzeRCrdqO0k0EESRt+y1mzyQZkSlRP5ARSNJnYr+V7f8bIQhhLxgBjosxO/QemBdbRh8RCXY0lAm3+Z/mKMqu3KYMuOpv6WAZHlDEItJ9Kf9kZqzWovpVffLZZbbmSUuHIRXIeNe7n9VD0Fxp6e56Qk/htKVWh/tf1I3PxIKytKpkBOxMN2FODegp18lnP/V15xNV9DtUXyTdiDAVBT3dskQ+kDYrAz6KKUG07eSWxPU7xVzplokj2rysqCoSMpdNQT8BB+EZz1cM6zhgCY/Mr9LEEwWvf+IMrGsDzPskf0oK267G+23OY2dpZ80dQ2uWH9NDFChll5oLc3KgSqh8drUdmN8tofwQf5841iP7JyQxDYqGcI8ZmyrgWDbEYLIecmIwL3ySAwB/xOBOnNRlOdbxo+sitU6dcu8pLrquRF9c+kD263GjD7tyNMo9YggbWq38iamGJP4uG0zJLTvCryjO84U8sZe2dysK0zgYKsE1/fABEIO1RMRwCQKhFJJ/ucMbPAqBEIo0snjaouhk+yyNZALt6cJcrNDrzVU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(8676002)(8936002)(66476007)(66556008)(66946007)(6506007)(2906002)(508600001)(86362001)(52116002)(53546011)(44832011)(6666004)(7416002)(38100700002)(5660300002)(6512007)(9686003)(6486002)(966005)(54906003)(6916009)(186003)(316002)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qctjGcjyLp7oNTY0xRk4/++Mndxry/y7/ZtA+yv/zPl8WXEOtDgsTKRBYsfK?=
 =?us-ascii?Q?x0JhJf4UOqoHxCSKcqMn4FC/CjPMHv/Pl9O8qN9t31o7bJXY8eeIZGkYyPtM?=
 =?us-ascii?Q?+bZT4FCy14tWHkyDEFAOwGOk3iaLPMRyVmr+2qiVdZftc0T5jfDnojrzoWhz?=
 =?us-ascii?Q?kmnDOsbzyf8nFnbSUdVSABbSbYUahEM40uba4g+/mxgTxbLMue8iqy34/1ZC?=
 =?us-ascii?Q?Pc0RI3E5bwH6VYZ+rw1G2iOfssA74Q+zsZIzo78vzIl99h95L192NxZ7FRDM?=
 =?us-ascii?Q?oihjmj3CeX0zNNxEJLAlX3vNt/vyBbJ8sF2Gz8opjQC9Yr2qvpS2t2he2o5A?=
 =?us-ascii?Q?cmFpCb7qQrtMaiR/na2iJWfKBCX5C7JOmiwkBJtLy+tLgl0xSGoCscCnX4Qd?=
 =?us-ascii?Q?4ZEjc/7ZqIk2EH3o9XE+cf/GCkpT/y/YPmhIQDsCtoa+2Nn+mTRK2EToP9QN?=
 =?us-ascii?Q?ELBdkvFCHlUDZev6t+NRj/5Ki1XG8Gw3QRNMBcYlQB8DBz2cx7KVQH1xiX2l?=
 =?us-ascii?Q?8f8NNvrnkQZOsr+2tE1g6a59PP8sJ1mI0lx6KY1Q8gdi5sBtfu/+yCwjYUaJ?=
 =?us-ascii?Q?F3RjF+syzCQJLyTi9MyKApWP9viwl7Dk1OJ+Xqk+GaKLV7zUbAy1l7hysbwo?=
 =?us-ascii?Q?oD1Pl58a+V4QAs0/k9B9UOf5o5YQLDJZIuO63DVlRee/M7xh3Jb8OIRPZFKA?=
 =?us-ascii?Q?XURlrS+TilbmRpL8e7sG3/4xIQ6TUbahM9DhE7CTKX0GYZMJ39M8R2Nvy0cE?=
 =?us-ascii?Q?lfKxk6Iri4gPqUkK4fWtjH8PASYI3KX+9FJ0aWwFNhS8tuaO6gPIY7z+jH5J?=
 =?us-ascii?Q?tj0iMNVFU33VNCedgyLH5EWduJW3YeKJuyn+ATQUtYH8LVDljSUdeGiPpZC3?=
 =?us-ascii?Q?tw+23fxCupJvAlmf8xFuSoqohDrBdI0/RFVs9pnXM4C3Vsjc3mqoKsylzHWS?=
 =?us-ascii?Q?2ZG5Rk0uyTmE27Dda25+5bvcW7Yx0YMP+ZrOTUnruHdJ/UtBPnP6ZgejvxoJ?=
 =?us-ascii?Q?xcyfptpxW0guUugIQ/j4grrLvIbW8FLTCj3lpU+4hl3nVVYdUtcZJURpEQVp?=
 =?us-ascii?Q?l3LNMdCh1LTlOop7NGdMiw8lQvaJRhlMUNnMKVM8xmpe/ltYCQ3JbOCefggf?=
 =?us-ascii?Q?fLauo61HGUz3NZ4wOiyqdz1xO9ho44WNYE/GNQdNmEkcW/ctHucGZmoLB1AP?=
 =?us-ascii?Q?erZ3G/sEgm0trqjkd1OMT0v/q/eDUEKPdKftKPsE6Wnku9zzkgj9NeqHFrGW?=
 =?us-ascii?Q?XLE6wfe+2XZYLjWtGoBJFJDZ61hbkjm9iq5ciIKrcaxfc0rhgg0vYnGcI8cC?=
 =?us-ascii?Q?QU1XKlUiKr1htpmdIccC2X7sSMp/mGpKYULgDCcrc12eOzj1X5zRhA8lAfZS?=
 =?us-ascii?Q?rIx4VazIkvicSTE6/vU80nRsmwdIak6k+eU9TeHQ8fKVc8weF1cLc9scXiaf?=
 =?us-ascii?Q?AsinKJ42AKr0/Ht7JLrDVO53Ew6eSzf6a7QMOZbQzIRrTlA/Khk2E5Uo/gSP?=
 =?us-ascii?Q?DcsVP8Ppwq6n2d8svVYPVDBcKGvBPK77gQUkyKfdgG/PLCH5ZWrGSIQrRqWd?=
 =?us-ascii?Q?MOpOHdi4qjZy+XZp6MxxU87Tg4N1iJGaDWREClra9wa/rSloiU9ZiiSQbz2X?=
 =?us-ascii?Q?X7qfw7z0V7O/Hnup/AkZnoMqyAOJQau3nwLJ6HYNkcvukm597kXK6LPhb9za?=
 =?us-ascii?Q?+QsiVNklsBYTXnWt3m0ZHMU5tdo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 879fd1b0-1410-4003-a1a2-08d9f8799e0d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 16:12:27.8416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KIBMlR94g9ruwa5ayquKyor0YXhJLkICTapBiy5vdkNYPRtTS3XF7HIgpLratiO9uixmylQEJdxhNwn9KeJkWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4560
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10268 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202250095
X-Proofpoint-ORIG-GUID: br5vSRhn-0GabCFfsivKBuclFmh_uKoM
X-Proofpoint-GUID: br5vSRhn-0GabCFfsivKBuclFmh_uKoM
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Feb 2022, Andrii Nakryiko wrote:

> On Mon, Jan 31, 2022 at 8:13 AM Alan Maguire <alan.maguire@oracle.com> wrote:
> >
> > kprobe attach is name-based, using lookups of kallsyms to translate
> > a function name to an address.  Currently uprobe attach is done
> > via an offset value as described in [1].  Extend uprobe opts
> > for attach to include a function name which can then be converted
> > into a uprobe-friendly offset.  The calcualation is done in
> > several steps:
> >
> > 1. First, determine the symbol address using libelf; this gives us
> >    the offset as reported by objdump; then, in the case of local
> >    functions
> > 2. If the function is a shared library function - and the binary
> >    provided is a shared library - no further work is required;
> >    the address found is the required address
> > 3. If the function is a shared library function in a program
> >    (as opposed to a shared library), the Procedure Linking Table
> >    (PLT) table address is found (it is indexed via the dynamic
> >    symbol table index).  This allows us to instrument a call
> >    to a shared library function locally in the calling binary,
> >    reducing overhead versus having a breakpoint in global lib.
> > 4. Finally, if the function is local, subtract the base address
> >    associated with the object, retrieved from ELF program headers.
> >
> > The resultant value is then added to the func_offset value passed
> > in to specify the uprobe attach address.  So specifying a func_offset
> > of 0 along with a function name "printf" will attach to printf entry.
> >
> > The modes of operation supported are then
> >
> > 1. to attach to a local function in a binary; function "foo1" in
> >    "/usr/bin/foo"
> > 2. to attach to a shared library function in a binary;
> >    function "malloc" in "/usr/bin/foo"
> > 3. to attach to a shared library function in a shared library -
> >    function "malloc" in libc.
> >
> > [1] https://www.kernel.org/doc/html/latest/trace/uprobetracer.html
> >
> > Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> > ---
> 
> This looks great and very clean. I left a few nits, but otherwise it
> looks ready (still need to go through the rest of the patches)
> 
> >  tools/lib/bpf/libbpf.c | 250 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tools/lib/bpf/libbpf.h |  10 +-
> >  2 files changed, 259 insertions(+), 1 deletion(-)
> >
>

<snip>
 
> if both the symbol name and requested function name have @ in them,
> what should be the comparison rule? Shouldn't it be an exact match
> including '@@' and part after it?
>

In this case, we might want to support matching on malloc@GLIBC and
malloc@GLIBC_2.3.4; in other words letting the caller decide how
specific they want to be makes sense I think.  So the caller dictates
the matching length via the argument they provide - with the proviso that
if it's just a function name without a "@LIBRARY" suffix it must match 
fully. The problem with the version numbers associated with functions is 
they're the versions from the mapfiles, so the same library version has 
malloc@GLIBC_2.2.5, epoll_ctl@GLIBC_2.3.2 etc.

Thanks for the review! I'm working on incorporating all of these changes
into v4 now.

Alan
