Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65875349CB9
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 00:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbhCYXKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 19:10:37 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35656 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230486AbhCYXKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 19:10:06 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12PN4BZE015662;
        Thu, 25 Mar 2021 16:09:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=Hg5OPtysheGqT2Om1nk+37rUSnTzcNBgUcUyU9JIrfc=;
 b=d8eJNE6l8/qt9FecDvaNSohoR3Ge80MM66GwMeowgP1C2931CwpC0XGCzOjn6Ta1ft+N
 y4D5Ft91j4WbxhGTGOZjKaeDTCEZjfri5QI22bngaT9D7lCSnizvwxBpPymxVGo0dsSA
 NF2sZ+Pyz3X/TBEno3RBxXTb+YN/z3A7RWQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37h13uryb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 25 Mar 2021 16:09:50 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 25 Mar 2021 16:09:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jo8Y+9pyGNvY8W7eFeClvdH8nTq1p1XyPG9DsTSeM8D9WTMQRCmTKK/ePg81bDMH60i6aVLxEcsnFIZHY3V1xt5hSkDzCCvy8HiXLle52HM2yi87wAADfLYSpZMJA3e1whJabZ6J3omhqGVrlM8PxsQKT3J9dlYsCOfHUcZ09fjJKcCFAj2lm8mLT0f/IP3PqCJ8oNtcE69DX709AbWtqcZaENPwt01ZZuRe4fZAvhme9t+/hL/hg8nvJeNqe9gFHgrtpczAiMLquMpUIv3j+ZL/RcjLG1+ARyH8LK9o4D/Y2eMZKsqKVszizJ48oIqG6Qhalmo+d/I+cI2DwAsNAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vqKGsramH49x3FV50M4mX59Cn2ZnJoTDwROWrMFJUqk=;
 b=GswBHAfyCIIzCYQbLHsqJvHh60Jedh1WqrgqtEzBPraqW4q/Zps7Sb/UZfsh2d0JDTeGD8q5Bynjmcs3fszKwBrsC9ZGi2d3qcx44y06DRERi91+OGcmzIKUDL7yz/T4niKs8iaxMdqukDAZeB1dBpWdC5atrRsxNMOneL0RRJ9L5uYaP3bmvQDnXg+0ZwJB4dUVCLgd14QDISeW/EOadv36EQC7/Jsg6jDWP+W4yAKqz6BnbAHbGPV0BW/F/toMxUjay8rBt6cJBqDftkfhKmx741fUsvqC+zpdH76GR27+ok3uFwCj7R6N3TpS0UoUmC8wIP97MUGuKEPyZzChmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BY5PR15MB3667.namprd15.prod.outlook.com (2603:10b6:a03:1f9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Thu, 25 Mar
 2021 23:09:44 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0%5]) with mapi id 15.20.3977.024; Thu, 25 Mar 2021
 23:09:44 +0000
Date:   Thu, 25 Mar 2021 16:09:40 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 03/14] bpf: Support bpf program calling
 kernel function
Message-ID: <20210325230940.2pequmyzwzv65sub@kafai-mbp.dhcp.thefacebook.com>
References: <20210325015124.1543397-1-kafai@fb.com>
 <20210325015142.1544736-1-kafai@fb.com>
 <87wntudh8w.fsf@toke.dk>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87wntudh8w.fsf@toke.dk>
X-Originating-IP: [2620:10d:c090:400::5:815a]
X-ClientProxiedBy: CO2PR04CA0174.namprd04.prod.outlook.com
 (2603:10b6:104:4::28) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:815a) by CO2PR04CA0174.namprd04.prod.outlook.com (2603:10b6:104:4::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26 via Frontend Transport; Thu, 25 Mar 2021 23:09:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84862b8d-72b2-4a37-61e8-08d8efe31409
X-MS-TrafficTypeDiagnostic: BY5PR15MB3667:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB36677290CF456B975FC48333D5629@BY5PR15MB3667.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XIv+xNp3qQ6relwzGSrX2L6HHqis/NwQwCjjeMIThn38XNFPFd+lls4/MRsLIZTrUTnnp1ZCMWyaUU9jwRoc56EsZlCuBVeFzjoD0swAAk7ca9EJPnzazJhIw1jHcilKjpv/DZTNQWybFqOwHaBaHqFuOGqG22BuqJU3Wx4Vxw95KvBAZgRdMqFQaOTm7XjI1GOerTD79INhtf1TeEufaNkFowxG2MNUwT33iL47H02VAdqbZ2v1nw6jH5eJsIguMzIdcA3aLN9vFjnW+GtD7mTYr30a/lVZOXV0mAnR4wwzvRKzXfl9CkiyhvX1TnYKFgoMTqZR/tXYkxzOWBgRyrW8wPth39zyskCY9kPOrLbimOGSRsIzRJO0+YwSlfnSLNcNF1qvR5GskT9Y163SD4B85m0pFpUDxtPTdHpeMS0cGxK2eDoJ713KWLiHQHUR7iVdbVl9+tckVkpR+xpb8exWzFCy/eLB7VocOikRoMMLFo45tv+v/DKkyOKSS2x9g/3zjE7GvlK9/b0mKkvfA9L6cg+wwVFkyho2tcCNap9CKd/n2susoqvt4t+a/OxWQzg7tZ7WqMFsI4SIMCrGHkQkyHfPTl+z4n58C+un5PsS9T5bqS2aRj5fph9Te2TCrCeDWnKgvSpG81O0eL6sVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(376002)(396003)(346002)(136003)(6916009)(1076003)(66574015)(4326008)(54906003)(8676002)(478600001)(316002)(5660300002)(4744005)(8936002)(9686003)(66556008)(6666004)(38100700001)(86362001)(55016002)(66476007)(6506007)(7696005)(52116002)(2906002)(16526019)(186003)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?JduLoottzCjmZAd6d+XG6RP7dsnGDFltyiwUApekqtc8eMVwnWCthvbnkA?=
 =?iso-8859-1?Q?PTV7qghwPsGvAQQaVXhzagaGZ7f9pcap3bRX6BJP2BcT5Tl8aGNX3DWHbM?=
 =?iso-8859-1?Q?+EwQw5An7YSM9vvc0cqwQLY3xQruh/hSrbGzmZ+OfgDXji1FMrD1FUq932?=
 =?iso-8859-1?Q?kFs8vzqUeX59nl0q72LPLvf29CeSGeM2yW6r/AOjHLOUHAuYCzJ7orsRsV?=
 =?iso-8859-1?Q?ECv/oCSmrPWiFPxALUg5ikmdq7BAWX1wrY9wGiouM8zknNZ5PA6oSWdNoP?=
 =?iso-8859-1?Q?iPlshIGoyhykGlN/u5qvbV0ldvypj55xgYEj5Jb5aVZT15BTJRyuo5jS/A?=
 =?iso-8859-1?Q?Rfj2vIXPCcT68N0oSKsd+21GLPg0ZylK+x82Mng6i9FkjuJAyMgWSmIHSw?=
 =?iso-8859-1?Q?cMmKEPpk6Wvg+ttfZ+/Slu6xzf1z3d3BlixOmdH5yEb1hPerkWSg7TvwJ+?=
 =?iso-8859-1?Q?V7BkL+plat1v3BnX3amBHQGXqTDFsWwzHY0SE2VfUJjP11q4WkRY24Zov3?=
 =?iso-8859-1?Q?Q9igsi2Cz4c1iw5/BkoVCVg2rcaA4DpvokMPgApaGn0gfiLDVHiPTyT/+l?=
 =?iso-8859-1?Q?3INKYcGIQsoYwJP2TYK3Laf2cY0J4bEi1oR+EgCCjpszxxAYiSuzMgt/V+?=
 =?iso-8859-1?Q?KuN4jji8hyC/GR058fd1tC1dUCcvK4kd/YrLxWgy9M14biVglP+nGes0W8?=
 =?iso-8859-1?Q?qTlWzFwA7LWYAzeAFPEa63B/LImVkCeTr8w+vV//FthC5A9Y2LHMqsK0RA?=
 =?iso-8859-1?Q?Al/P7vT26JQVZlIraI9YFCUhpEdvVGnbne0AWmQcdQeZfsHdTJDfp5gtYb?=
 =?iso-8859-1?Q?LzpMqkE/eetJOcY42gpjvaNPsQp4HsG0hoNik4rbmvOwhFcZwSAgWrOm1R?=
 =?iso-8859-1?Q?AhPeMTuNAktCqcNgHLg/0lz4r2VlZ+n8X1B3t2uRp2bNC6gQWu4T5c4R3g?=
 =?iso-8859-1?Q?rQjUW0Tz2vJ3hXbGPf8Uz66CEW8JxAHq8L1VzeasicDWrjuTkYuA+BAy1M?=
 =?iso-8859-1?Q?v8TItIPNyYgU06d73cbBvw4ypXqQSFutQEbXFlCIq4Mojb2jsts9XrTo+6?=
 =?iso-8859-1?Q?z1018Ix0F9AvCmAm2uA+qFv8djfeIg3yWKV8LB6trtl9D0/stKyEKqy1fr?=
 =?iso-8859-1?Q?8Wa714McaDPolhXSyj3QoUnqEeXZevr/Szvmhyr8wx1RCEpBE9q4gkE89b?=
 =?iso-8859-1?Q?E0Fok42tEVr9pFcNcQGJAhhF0jAJDg4O/QLWhuyhdCebYNOSd0diNwxSNN?=
 =?iso-8859-1?Q?mxkD6rwGQWGCksbxSJAs0iuceCRE+JBp58BYZWvZtOIUKomWzjw41qpCrV?=
 =?iso-8859-1?Q?D3ouujGuMwi8dcfI9HwXKOZerKPAwZynPnjnN2KFV/3qif8O6OFtNQremJ?=
 =?iso-8859-1?Q?ReQXt8Pcf2TpK8X5l/KqcyRRMSKrgknQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 84862b8d-72b2-4a37-61e8-08d8efe31409
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 23:09:44.7667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yO73OVqsn1Ff6NosHHHhdnXu6MZFQX8OIib6GqzLY3pPBFNZtwZ1FedLax6cBtxI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3667
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: sZEc2Hv_yj7NBclA06gLv-mIyRI_ziTH
X-Proofpoint-ORIG-GUID: sZEc2Hv_yj7NBclA06gLv-mIyRI_ziTH
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_10:2021-03-25,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 clxscore=1015
 bulkscore=0 malwarescore=0 impostorscore=0 phishscore=0 priorityscore=1501
 mlxlogscore=610 adultscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103250171
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 11:02:23PM +0100, Toke Høiland-Jørgensen wrote:
> Martin KaFai Lau <kafai@fb.com> writes:
> 
> > This patch adds support to BPF verifier to allow bpf program calling
> > kernel function directly.
> 
> Hi Martin
> 
> This is exciting stuff! :)
> 
> Just one quick question about this:
> 
> > [ For the future calling function-in-kernel-module support, an array
> >   of module btf_fds can be passed at the load time and insn->off
> >   can be used to index into this array. ]
> 
> Is adding the support for extending this to modules also on your radar,
> or is this more of an "in case someone needs it" comment? :)
It is in my list.  I don't mind someone beats me to it though
if he/she has an immediate use case. ;)
