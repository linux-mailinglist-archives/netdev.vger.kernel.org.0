Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504371C608E
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 21:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgEETAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 15:00:05 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55736 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728481AbgEETAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 15:00:04 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045Itshe007568;
        Tue, 5 May 2020 11:59:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=KcB9LTyQiycGEB3qczql1Za+tiMv7JSKzZBnq1X/z2o=;
 b=m+70fk62fT394m1fN3D7tb6EP64Wf0+GC8ouhXMYHdDBTXElBVlIOiMlzVXGBllpbHf3
 j/3WMBL0jp1w7wCji6LLHhCVCE6uUvoIhdIcvwPaXxORFoCczgGDqxvLGqA2dMJgZzeh
 06Im/vkZvQ/mOCsWDQ6CEg5QOrUsrC+p4To= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30s6kpr4dr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 05 May 2020 11:59:48 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 5 May 2020 11:59:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Atjh51mHJ9MU28q3hTXuau9kT1d0y+u2bGWsl4gd95SRlvdxJyvfJDlCxtfX1ZPjZnT+FmuFCPLAjOZGYbLDK4hIYERF+IYE3ZJzYbr5oTj+KzfEoz8ahgIt57L5LKWORiYMLLzqnP8SJM8Zt6MnOjJe9vG6EQbjI23jOfW6k2hFzWX0ZstlZeDwftPsf/wG+HzpyjjSFnGIb8XIOM6jzfeWmm0+IEvNvKv/USAuM3IY0aApB9SsEaAJeQl3Lil8LytZkkJXeorYnh3sgXcb6spGbEgGOgYloVRt9kfd1+B6hsRYTlkquOapuJXZ4/5E877UkGHt5EF0XPJze8NcFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KcB9LTyQiycGEB3qczql1Za+tiMv7JSKzZBnq1X/z2o=;
 b=k3E23qfA2MOQoPhG7PcrpeJfBT3UlyeaBUWsrBvpUg8hA1KqYhLnFcjFp3TzhMxuyya+uQ/ICZzfhzjpbCoXLhDnu+m5M2OmvEWeJxQImrCarEtDFly61tcpX8o7EAExNppp/0+qjH4p7C5PRjOlEiMEO9dQj85/Tsf50dHP6roDZny7uYhjhQz47877+QYGwrGVw1XjKQtae+Cbhgi4NQPHZsSkg/pGumwBcC7WIVfP7kEjn20s1gcVttlRCd6lxPHzXllqFGJNuM8s5EWYOH05uYLe+FyJLA20HUv/s5JhBv6l+aIpZtnMna7ZHX1/5HWYOolXcCZFLrv9H779Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KcB9LTyQiycGEB3qczql1Za+tiMv7JSKzZBnq1X/z2o=;
 b=hUMMiW5jyOGnWr3jAIv/MDIPXZiezxuoRDZ0sRF69Fro10a2L7y5AQ20lGeJLLHqF6KzLnURP5nbLajRQ7h9tVmK6nvLUzm6FN18dhFzs/i76oJBEEOnwU3t5uCYTUSMZ/3sGP4UIWrg3NHv0bRQ1JSqRLvtCR2hwdkkngXcQBM=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3818.namprd15.prod.outlook.com (2603:10b6:303:47::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Tue, 5 May
 2020 18:59:47 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%4]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 18:59:47 +0000
Date:   Tue, 5 May 2020 11:59:44 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     John Fastabend <john.fastabend@gmail.com>
CC:     <jakub@cloudflare.com>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>
Subject: Re: [PATCH 1/2] bpf: sockmap, msg_pop_data can incorrecty set an sge
 length
Message-ID: <20200505185944.wkwu47cat4k2awxr@kafai-mbp>
References: <158861271707.14306.15853815339036099229.stgit@john-Precision-5820-Tower>
 <158861288359.14306.7654891716919968144.stgit@john-Precision-5820-Tower>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158861288359.14306.7654891716919968144.stgit@john-Precision-5820-Tower>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR07CA0077.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::18) To MW3PR15MB4044.namprd15.prod.outlook.com
 (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:3100) by BYAPR07CA0077.namprd07.prod.outlook.com (2603:10b6:a03:12b::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Tue, 5 May 2020 18:59:46 +0000
X-Originating-IP: [2620:10d:c090:400::5:3100]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b580c65b-8bb1-4654-2e17-08d7f1267afa
X-MS-TrafficTypeDiagnostic: MW3PR15MB3818:
X-Microsoft-Antispam-PRVS: <MW3PR15MB3818A869842E2D09AE7A7F61D5A70@MW3PR15MB3818.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SVoriE8qgAglQ4Tr5SUrap7PeWA/RUeMcZGN+hspPDCneTKbWwrmvJ7BYaVv55qrbe+9rfomq4789QP5uP5oxBizRF96wwXZf+bVPvJYfBICXy359cQoyhA1CD2IV4gqNL7tbg4OQobJGl02jQf+JSP1mnVIh6oPBrl7TgrFoPQVdfPi/vV0/a+pm9duB1Oi9/1bY5KaG/YDGq49KdAiL5T7PdpyX0Xc7vWxjYzWQJlQoxPeCeg58CJpc1NepxlJAC+yFn1VGahyxrLphFdWgZU8a7KpB3ZGQWKQk9iuSPBLgHdmEZ3DFt7Hx3d8Bma0og2x2S815JzQqXrjWX4MNR9UNoE3uVZelpq8fuv+bDxcCPcdRQRy+UkajyAX6TMcz8HdHkPzMXBh1MaOiSr+DI+6lE2DB4Rm8r58DxIVfKJPA7bEffx4wflhxyNZe32r8UGxSbSwO/6cn9MwVMN8W0C/CZheISgZLEcdIi82+u8PmGOL8z6MMZ2HlSU2NHpO74RM0dLEErdkSKC3ypHbIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(33430700001)(52116002)(6916009)(8936002)(6496006)(4326008)(86362001)(2906002)(55016002)(8676002)(33716001)(498600001)(9686003)(16526019)(33440700001)(186003)(1076003)(66556008)(4744005)(66946007)(5660300002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: SvzPUgyiuPco3sOudFUcJaENHZEw4kL8s2xsBdeO5yIaglJfqR0WsBaXv7Ygvu4S0MNTZmmz2bnYjSufPNsozibDT9gKddbe7m8ClHegTirDjdKWRTzg5DWexQkGaiMKDEiv7NhzQ3j6V6L0TZq7EAmufMThNmMigy70K4BMytlzwdmr/jtwdETuCcSEBAvtBZRzdkrNeT+3YhEhoeIkSFKM3ahbS+Ev/jezvCJ/KIAagmPFn6T02qYh8ZOKumZHA0Ll+fnV1RHXJG/t6jV/IRexs5WZNYtXTL3PzpVaFzSbF6O63aWisPCVPK2hG+o0ZGzOtxhuW1nt/Jig1AvYcy1DFfstijvZ9dM7sXW53R+P2rw/FoWSl7yGcrwVAoCCJmVYDM6ORemu4SOaWTycbxR6z9jY22nto2P7dTL2fshFWm+nWVkdpTa4vwha5Z0dWc8SXprsDAE5xW3kbQrPr9dro5uENSq95LfbQYrRG/AR9zAxuPi/7bnhacSmisQqUVA4mdnEGu3jUQ/Ratw3PcexvDxacQA0muMQB3LLleUAcA6kxjc/LKkA0liSEvn7kei1ul3ONXx/fsuNkYfO1Mymsxaofg/Oc1ADlJoSG/gGeuFfW4s7ZZ+1qUaLkV88V/nIYmEK8bStJMFPruODa4zjWtBgXRhE/iCg6Yp/XI97PtZqyXSmDgZW9782CUwMIDxHNu3GfL2yW9+SgTpoR02sKuUtWMM/GajSum+Tcgg4ZT1gOD8PnDDbbuBXximYQOOgyndy9PTp7BE69qwFcRYOEuDFrXmZm7dnzn8Zdc2LF7sTknFDqbTjGsyzUTuNAbdHyETt+XR0ursuI+FKHw==
X-MS-Exchange-CrossTenant-Network-Message-Id: b580c65b-8bb1-4654-2e17-08d7f1267afa
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 18:59:47.2224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fk3yx5W7qxnhSScCWr3gqykOSNX2LOIUY/eALaYgiH0sDABHeDAS14bxEb3pxNcg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3818
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_10:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0 impostorscore=0
 phishscore=0 mlxscore=0 mlxlogscore=590 priorityscore=1501 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050144
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 04, 2020 at 10:21:23AM -0700, John Fastabend wrote:
> When sk_msg_pop() is called where the pop operation is working on
> the end of a sge element and there is no additional trailing data
> and there _is_ data in front of pop, like the following case,
> 
> 
>    |____________a_____________|__pop__|
> 
> We have out of order operations where we incorrectly set the pop
> variable so that instead of zero'ing pop we incorrectly leave it
> untouched, effectively. This can cause later logic to shift the
> buffers around believing it should pop extra space. The result is
> we have 'popped' more data then we expected potentially breaking
> program logic.
> 
> It took us a while to hit this case because typically we pop headers
> which seem to rarely be at the end of a scatterlist elements but
> we can't rely on this.
> 
> Fixes: 7246d8ed4dcce ("bpf: helper to pop data from messages")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
