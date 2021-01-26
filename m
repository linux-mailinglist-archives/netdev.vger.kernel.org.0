Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13BE1304D98
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 01:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732661AbhAZXMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:12:02 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54474 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731593AbhAZUsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 15:48:17 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 10QKjRO6026439;
        Tue, 26 Jan 2021 12:47:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=jNPFkPXrU5m3OFKhyU7ix1iQLhQQ546KBj9e5AJURhY=;
 b=Hw/NH9L81XCTa/agf9DlvazAJP51coX71uSl15Kxj7S5uOkpDBhynHM77qNuch0tYiIh
 gyJR4AZ1GE/oaut9N15UFaXNyhWjjUcsc5oqnqmvFvD+DTy4g4hPlsCsjP6NXMKFhnT1
 jIpxBjfo7Ih24+9GBjVsH2fHYXmTEjezthU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 368g67aa1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 26 Jan 2021 12:47:18 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 26 Jan 2021 12:47:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kqKlLPV83oDpwbucO5svqfFcWQfm5Lve12Qh4qEi8C5SFvBMvRXhQKRWYIrK/TOLPW6E0MVt2sfd8sxxvXThY8YD/gsAHDOYXZkk6VLwg65Um25lpT30XHTZWPDViV+G0F700cTDPvWOf0B6goVo8HU5EhaTpfa6cJNDfx2v7rf/9JsHdc/MNKkCnHAGTlWZ2DPblqELajZzDpXB0ctdMuKM93H0ROuKzIBlvp3aF1TOkIMIFDI7PnhsEBcvs3DL6XKWOSkM2LKAnV/GBD2erQqt5j7cZQH+rhDArmWk74P23cTrqVzDZ637Wci2tHi+LEwP+G69oCC7HaIMHP8rdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jNPFkPXrU5m3OFKhyU7ix1iQLhQQ546KBj9e5AJURhY=;
 b=cCEKbwRTE1ASij0sMjQvqtmoAYi+pM87jxqNlyUQex3yxrf/S9CKN8scN9hggi5rkazjy2e7LFFk4NBmAsRbVxlm/lzZdvPeZFuE4irzzs12xaql5BHQM/vkHtmd8KMCR8KB0aB8Uwc9u2gdUDAVB28AGgXLOO7HbncITUX2giM51IEH+eKaG8tjlJsWQ7w9CrwxigFbiuxbJdJ7vZ4pDz4bFeAG7O/DniXIaZNVdpm2pNW571z7ijrAY3Kxp1kDPl3oKVlLBAsE1qjM6JqLj9POh8h37H/emvUhf+a7jInaAtII8Rqm4Pk9o6gYlGV/n20amAOJu1f7xbrIVL01VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jNPFkPXrU5m3OFKhyU7ix1iQLhQQ546KBj9e5AJURhY=;
 b=M9W+OR8arxLl3Y0OBx07ykjQseJMQXUoW6dBJm1+tFHe15BWUtVAakPijeTvG0gTAaFXNe+nJdR5lDyY0Y2zpXAzcZ+TqnD6QqtkyJqDUe3/FCUc2aUV3fPw7gxqyxTjF3kjuLxlC+qTUTe3ct5N00qAOOmfKtvUBEwgithoYXY=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2405.namprd15.prod.outlook.com (2603:10b6:a02:87::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.16; Tue, 26 Jan
 2021 20:47:17 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d13b:962a:2ba7:9e66]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::d13b:962a:2ba7:9e66%3]) with mapi id 15.20.3784.017; Tue, 26 Jan 2021
 20:47:17 +0000
Date:   Tue, 26 Jan 2021 12:47:09 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next v4 2/2] selftests/bpf: verify that rebinding to
 port < 1024 from BPF works
Message-ID: <20210126204659.44qekjsz3gyn5gs7@kafai-mbp>
References: <20210126193544.1548503-1-sdf@google.com>
 <20210126193544.1548503-2-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126193544.1548503-2-sdf@google.com>
X-Originating-IP: [2620:10d:c090:400::5:694d]
X-ClientProxiedBy: MWHPR07CA0001.namprd07.prod.outlook.com
 (2603:10b6:300:116::11) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:694d) by MWHPR07CA0001.namprd07.prod.outlook.com (2603:10b6:300:116::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Tue, 26 Jan 2021 20:47:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: acff4835-856c-4ce1-9fd8-08d8c23b914a
X-MS-TrafficTypeDiagnostic: BYAPR15MB2405:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB240565FC69A3DD0C89E42CF0D5BC9@BYAPR15MB2405.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8OuFmgkBW8u46RLyFxxqXkpWdK1VUSdIFHMiUgeEPGs2saJjtkoyimIMRltvNn7TKXqaE/YOQUi7/cTRGrLd9W84z2X+IwxQdj/aozPz/PK2ncB0EK2sQqLMgG5sW6UFLF2zOdtfcWjikVSM3GQIIG69cn8vqowa7YCKQPt1ipF1HKF8AvmERnTy7GHCRxBEpKArncqKjLedIBsS+GkF0MPUCt3/nq20eTHiKIvoj9PPaXZQumTNL4Jl9CJ9AL3picrwUMriBmIoSAvA6oumKOMiDdrU05XeBVwYXwA/vw53n1iKWoTYAkbrrI8my9b9ANfs3K0Ihd50A91wD9j3g4zeKnL7n2Li2szkkrPe2CHmtskKiVuSNXpZkSYOUMgCZy1UwA4LOOj/bmhYhZSBmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(366004)(376002)(396003)(39860400002)(8676002)(8936002)(558084003)(9686003)(6916009)(5660300002)(1076003)(2906002)(86362001)(6666004)(16526019)(186003)(316002)(66556008)(478600001)(66476007)(33716001)(6496006)(4326008)(66946007)(55016002)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?m0tY+Vjc+8skQQS05OZ0WNxQ4CKaLu627tmo8fXt/W/seFs4Ke8KbmI8vKom?=
 =?us-ascii?Q?/mb7oArg6MI11M8ORxjQ3Af98ithzr5qx3GXWe2kaCx8bx69Td/tUlZN8FTZ?=
 =?us-ascii?Q?539D0nARg/cXzxe8KCruHK62rVAQCFhzKebE4NFWrcDhQfz36/NaYZZtOLQ8?=
 =?us-ascii?Q?F3nf6e+foUsyikUlO/8ZIR1lLQ2H50m2kiV7/3IQHW4ab9Vp9LMioyxvnU59?=
 =?us-ascii?Q?LNcAuMKTYT16mjB39Rx2O3/FgnYMSNzZd+j+5tUrln/n5EIf6f5Ozp35zwz/?=
 =?us-ascii?Q?SjatSq0v6eVqy0UdJyOHaU6euwbjkuu5FkuthCdOYTaTr6e8rC0caWXhx2WM?=
 =?us-ascii?Q?a5c2i+6bZ92A6vqpo+dTl4Vh4wrF2ak2HZjXWcbgr3C4mrX2vV2LeQACqvAW?=
 =?us-ascii?Q?99b7Xa3vF6YBdwMPFQ9HYF4oC2sP25KVXP47W02NxFNvX8i30DGja2XIVz6e?=
 =?us-ascii?Q?I3tHc6dxnchfWyAv3+qotpEAjW4cqdPogmMO3gZ3DH4vOIMWLr30mEUvyvCJ?=
 =?us-ascii?Q?0D4MN0RNgaG2PwZDKBmkidzL2qf3OmvrGCtOBZgwgSMB/3IgMgPZfsfsBjMJ?=
 =?us-ascii?Q?lJMRoq1Y7Kv1eJduGyTSv328Iznf2tWxCOHg/fuZLK7A7KLqdSlDyigLthHO?=
 =?us-ascii?Q?iVGyl4PtilFqm8gGxuG53DvF6/QD9COFyyQIzpOC65UCLpaEelDvneZTtV6x?=
 =?us-ascii?Q?OvwpBuv2v9WeQJiY9ceHeDBsB7I797pe/ePjXy2RRlTyZnrBZLiC8eRqrP0g?=
 =?us-ascii?Q?y0eBA8wGODh6c/k+6AA/YshF1XUYSWiFFN0m/+18n44MjVu8VOV6ZecA6cj7?=
 =?us-ascii?Q?pJ98MPTmb4NQjaW0Jbf37AgLYU/5+mFSFAGqqxsb0wiqL45oU+g8i5EILedd?=
 =?us-ascii?Q?awVU3+ojjqpQPpysUomCTjsgGn16gI4jUV7Y8gIlrVSqtSQf6eOYkPuCIxUR?=
 =?us-ascii?Q?oOBCW99vbt51Ml6QCOYCChalfzbcDpGmMAnYMkwDvlf/QQnFnhMbatYqRhHb?=
 =?us-ascii?Q?DTnwB3gfxr+ObUBzAk19MxjXCGyvymrBno9Sq/OZ9FTxve/1ygCPRtS4huYS?=
 =?us-ascii?Q?frEw5J8eNh3HZ/h7lz5r21P7R8KbslfSqoEDXRnUypXz7JpJTpY=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: acff4835-856c-4ce1-9fd8-08d8c23b914a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 20:47:17.0860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yYOhjw2/8Tp22T+Dq8521cvvzxNJ+oE2GRkXsfzPKnvXfANwCJiimJ8JZkfgtzt4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2405
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-26_11:2021-01-26,2021-01-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 adultscore=0 mlxlogscore=887 mlxscore=0 clxscore=1015 malwarescore=0
 spamscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101260107
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 11:35:44AM -0800, Stanislav Fomichev wrote:
> Return 3 to indicate that permission check for port 111
> should be skipped.
Acked-by: Martin KaFai Lau <kafai@fb.com>
