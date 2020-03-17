Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1684218772F
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 01:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733284AbgCQA5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 20:57:41 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19164 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733274AbgCQA5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 20:57:41 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02H0u96G020694;
        Mon, 16 Mar 2020 17:57:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=kh5G2WdewTq+jYJUVUZKe6zM2Yjsjydwro1zuPEyszM=;
 b=EvAGEg9AAq6zUpzFpIq7NF+vTdfPLUvuRs5Ddzp6MNMyybNuuWM6CaQUTDRK1ZFDvv/H
 AuhNNWWCR9fbj+ivKGPOyykgWf0BEtiyvXV+YcS7GjDVkCvhGKmLDUqP/yEKFLZ5aIXU
 0HyQGu6WzRp51XLX9PUsTHxhbpUXZDQi5gc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yrw0pt9ys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 16 Mar 2020 17:57:26 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 16 Mar 2020 17:57:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HaOeujGgDMuOC9rvue1K3+rsiEEVvjhjW859YOQAs35NehFcpD+Pyzpd5ReFrfdF3+WeYcFEPkC2UOIw14fxwhmL6C3rA5tsej8RYRVTA13Re+L8dI5wBnzTWHoaQcjpFbOoGBWJ8LPbSCOInA8LQknOsChgKyl2SzVktyh7r/HckLOMVHFbZlVbWZsaecGPVf/ilod93lVn2+dvPz4xLJk2s9PO6o/AiuNvMsdSf62fDOxUj5os+2mjCp3bc0bbEg1bMAbkbjeBFlw8aFoxernOHdDenOO/5GSFWhVqp+L3CTatSbkPH/86FrgE/IHwcsFX226f8wx2d8SnLGxEpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kh5G2WdewTq+jYJUVUZKe6zM2Yjsjydwro1zuPEyszM=;
 b=Amr1XflxV2Rh56UEsVsmZCUHODKsN87Vnys3dPK73JZ9hYzR6uoo8m4QwqUvvjW4X59YMeMSqg8W+hDbkJOwgwE//9Nfh9sPu7cKJFemfECihxJge7iH+qgdylFIPbD7mgIr1KoBW6dHEqrpm+QXg6UCvqIPAVzO1KfLcychZY58jCbLeIr8iaIx8VFdPESs44R3Ct3g0B7+2a774oBiKMvgU3UbQ/5b5CbvxMvQH45BTxDugkj3ppbodS82mc1uXiShQr5EgAnrOEamfJG+hLe/yiFYkvCs2xS9nuMlwAirALEwFbdV00R9VT1f8kdiDYDWaG/b1y13H25wHUnVCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kh5G2WdewTq+jYJUVUZKe6zM2Yjsjydwro1zuPEyszM=;
 b=lBs0aa8NYLutWXs8oxupd2N9j5+n8429CzqqWkC0q++vPcGWPls8ZqPjGkkP64WAjeFobzLOFeiy9GhW5FpX1vbYHcBPCgy2AJrnb27VBkkdz3e/Gb/+UJ+4elySTgetLXWbP00tJeNXPXUWf9PAOnJ5xKwKB7UXnh8SwF2gV7s=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB2758.namprd15.prod.outlook.com (2603:10b6:a03:14d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.18; Tue, 17 Mar
 2020 00:57:25 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 00:57:25 +0000
Date:   Mon, 16 Mar 2020 17:57:21 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Quentin Monnet <quentin@isovalent.com>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 4/4] bpftool: Add struct_ops support
Message-ID: <20200317005721.vhruudlmhr637uto@kafai-mbp>
References: <20200316005559.2952646-1-kafai@fb.com>
 <20200316005624.2954179-1-kafai@fb.com>
 <da2d5a6c-3023-bb27-7c45-96224c8f4334@isovalent.com>
 <20200317002452.a4w2pu6vbv4cvsid@kafai-mbp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317002452.a4w2pu6vbv4cvsid@kafai-mbp>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR08CA0060.namprd08.prod.outlook.com
 (2603:10b6:300:c0::34) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:e745) by MWHPR08CA0060.namprd08.prod.outlook.com (2603:10b6:300:c0::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.22 via Frontend Transport; Tue, 17 Mar 2020 00:57:24 +0000
X-Originating-IP: [2620:10d:c090:400::5:e745]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2614afe0-df18-4209-cc28-08d7ca0e2806
X-MS-TrafficTypeDiagnostic: BYAPR15MB2758:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB27580876A8C610CE2DABC13BD5F60@BYAPR15MB2758.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(376002)(396003)(39860400002)(366004)(136003)(199004)(9686003)(81166006)(8936002)(6916009)(55016002)(186003)(16526019)(6666004)(1076003)(5660300002)(86362001)(66556008)(66946007)(66476007)(8676002)(2906002)(54906003)(316002)(81156014)(4326008)(52116002)(478600001)(33716001)(6496006);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2758;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RRyMIdkStREnQqjKAKIN6h/Dpt4hKbcqVk2hqo9+0RpapkehAXmih/KSZmHesCcT1AW780dRmc/HP8Ixjii2w5eM+6IfMBHXdPllJPS0IXxzGIgN4AVtJbDVvFVuXmhAtWMlJG4jvk3DzPvESKzqnd3WsPc8o5l5y/TylB55MtJs6rmuB1IftkjushhVNWJXS5sKkhCH43Z4zHiostRY0sW3GNfr0WH0diAIYTdAVwradqrlS5mJ3FDlU1nOpE549cYBnqdO/Us6IGB0Dl2pSsrhE/aQXxwmg2ZKpw5JIw96+JDBXNkRCM9/1hR2r+grVkN2FIUXpZuFFyN8wUsEm1tVDOt/C07vJtVuyZ9uf92JJURYirUQAuQqmDPZmfLMLNA9qou7Ir1qpPEE4jPRdNLCM6HTiahKzTHPSoSnl0jL9xlmIsP5wIjnGGHoJNRc
X-MS-Exchange-AntiSpam-MessageData: NG3kmGFFNobiWOagQDZZveYu5gkw4+UI4GqT4r/UFnEfSzDHAofuzAoyS/kw7cqB2CAhmTmhqCxbp4NKXUe/uC4mYkQQ6ruygo7Tywc50K+IWcCclx/0TWP9gAc+A3+MKPWyX75Z1ipwb/i06rguhiRUadEtdMPAksN29jMjn/RJfAAf9UMuELCVGPNKMthO
X-MS-Exchange-CrossTenant-Network-Message-Id: 2614afe0-df18-4209-cc28-08d7ca0e2806
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2020 00:57:24.8490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DCJm+DvPFZ94KYg6Xh8vllSgGtDg61wwrpBo68NXxL0CawskqJ8V4YkQQFtz4Sei
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2758
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-16_11:2020-03-12,2020-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999 impostorscore=0
 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003170001
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 16, 2020 at 05:24:52PM -0700, Martin KaFai Lau wrote:
> On Mon, Mar 16, 2020 at 11:54:28AM +0000, Quentin Monnet wrote:
> 
> > [...]
> > 
> > > +static int do_unregister(int argc, char **argv)
> > > +{
> > > +	const char *search_type, *search_term;
> > > +	struct res res;
> > > +
> > > +	if (argc != 2)
> > > +		usage();
> > 
> > Or you could reuse the macros in main.h, for more consistency with other
> > subcommands:
> > 
> > 	if (!REQ_ARGS(2))
> > 		return -1;
> Thanks for the review!
> 
> I prefer to print out "usage();" whenever possible but then "-j" gave
> me a 'null' after a json error mesage ...
> 
> # bpftool -j struct_ops unregister
> {"error":"'unregister' needs at least 2 arguments, 0 found"},null
> 
> Then I went without REQ_ARGS(2) which is similar to a few existing
> cases like do_dump(), do_updaate()...etc in map.c.
> 
> That was my consideration.  However, I can go back to use REQ_ARGS(2)
> and return -1 without printing usage.  no strong preference here.
After another look,  I will keep it as is since REQ_ARGS() is a "<"
check.  "argc != 2" is the correct check here.  Otherwise,
allowing 'bpftool struct_ops unregister name cubic dctcp' looks weird.
