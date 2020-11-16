Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF19B2B503A
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 19:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgKPSwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 13:52:15 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35692 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728490AbgKPSwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 13:52:15 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AGIpl8c028075;
        Mon, 16 Nov 2020 10:52:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=TOB9QsqhzVFgF1309vQTZ3fgK+q/PstYZ827yOHhNNI=;
 b=TOaJrce/GH7JzuEj6pYljorV579TGdAGpkyet+Dij0juWQJ1SW06MbLotIYMLVVYfvWk
 cMAbOWtt58FGe+LuaAIjvruXZmYhfVxgpCWM12hcK1Ua3vPEv8hFJednExiBuwRpZTAB
 447d2834uCC9PxYuQjgH3nx183NpELwrqzw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34tymd6ec2-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 16 Nov 2020 10:52:01 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 16 Nov 2020 10:51:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBOqliDz4XatORfTSTbkILU8CbEtjjVIkbzh6OgToLtHtXXjgN93vX6wToWFFyzQ+AymO41WJN2MiE98eIZ/lV3nxSVfD8W3GuZ9KirdVf+/dibzg0pkTHAlu9NFiceg/zGAVVQ+dB/E0rIiaL4Gf5RsTWX8/R3icmwLy6/gQOJ99zhnvVasZGbNuGZFGuR9K69C8VF064LSf0kDdOqSWaMv/va7ra8eRBCS6huz4WajWvkPmwXhqJzZ2T3xBCpCWBUMenAf5y+r+A+aK51RtF93FJkEIwjS4qcc9YNY5m2Fx/gMTiJ2MmMzuwfSb2YtQFxJZMfs/+dNG2CZvLx8ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOB9QsqhzVFgF1309vQTZ3fgK+q/PstYZ827yOHhNNI=;
 b=TAgucAdp35X80tw7hykkKXHG8TYuqjT2GSoC2+JOIi2DXdsH9hk38Kgo2jTEZkDsNRycJK08XXblcpKQP2Cap5d1fA1XXasEGkJcPBX0FoKbXhdoFAsKMHMV7G/AbUnZ/ituoqMCS/0UtXuj/0biQ4DH8V7i+r0mjf2jk/Oc2FuIWYluU8daWMVmxyhICm9p7AD4QV7PdKexAWX2cyeOh3dxhSPyFdv8RqzPL+L6CdZyo19iG840UJXXgIwjVt0u1yurub1o0aGBjGmV+4nJNi+5MIoW+2k4FxtxvznS0qdkND2PWtmyTcEV/JuM44egpibG9ASw2KZm25lkdgCOLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOB9QsqhzVFgF1309vQTZ3fgK+q/PstYZ827yOHhNNI=;
 b=Gjl2QN3ZFWl91LiNisB1sDm2CBJJ1ZcUJYooltbnOe/kimHc+RDKcTfwDfrpyZshlJbACy/cBoRI1H6ddr54/MRmrud4wtmwSy9e3Co38he53pFLrLY1Mc1+lGCPsP7RFrsFTw+Je2Sp22BvDXQvn5w0PS9mukyAZLFBmb2YcC4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB4087.namprd15.prod.outlook.com (2603:10b6:a02:bd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Mon, 16 Nov
 2020 18:51:58 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3564.028; Mon, 16 Nov 2020
 18:51:58 +0000
Date:   Mon, 16 Nov 2020 10:51:51 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v2 bpf-next 3/4] bpf: Allow using bpf_sk_storage in
 FENTRY/FEXIT/RAW_TP
Message-ID: <20201116185151.iannqczqxmcj6xr4@kafai-mbp.dhcp.thefacebook.com>
References: <20201112211255.2585961-1-kafai@fb.com>
 <20201112211313.2587383-1-kafai@fb.com>
 <20201114171720.50ae0a51@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201116173734.a5efp2rvg43762ut@kafai-mbp.dhcp.thefacebook.com>
 <20201116100004.1bc5e70e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201116183749.6aaknb5ptvzlp7ss@kafai-mbp.dhcp.thefacebook.com>
 <20201116104340.60692716@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116104340.60692716@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Originating-IP: [2620:10d:c090:400::5:8f7f]
X-ClientProxiedBy: CO2PR04CA0007.namprd04.prod.outlook.com
 (2603:10b6:102:1::17) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:8f7f) by CO2PR04CA0007.namprd04.prod.outlook.com (2603:10b6:102:1::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28 via Frontend Transport; Mon, 16 Nov 2020 18:51:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a95bccc5-3da0-47c3-a4a2-08d88a60b233
X-MS-TrafficTypeDiagnostic: BYAPR15MB4087:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB40871A2C37C1D9A83FE4A36ED5E30@BYAPR15MB4087.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8wPB644xyU0N6+mNUTeJP0bccRsi5n038P7qXhyE+xjCx6BFoG7MPbK3w0wHLpC3qqvd/UTe9tlJxHVLiJXV5VZaeEAa+MQ82yxW1Uwp6BtR8jO/07pAEc9FILzo7JKRc7FJPGK8MGitGi7hYnxD1gKy5w4q3+6yBMLr4FXm4LfNdiD6Q2VVoRMtZ/+bYNfDCiv0CWvHQyX8pAP2wRCFFHVM/r1IaABJqSF/fZM/4xmR+Sa2roFjkrlN82UZ44ZcQFbjoOKJnNBOfz3XTknBKtROLW3mV5cpyaz/4NLtjhb28EV/G/sxYk+F/94YeBhS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(396003)(136003)(366004)(55016002)(9686003)(186003)(2906002)(16526019)(4326008)(478600001)(7696005)(52116002)(6916009)(8936002)(54906003)(316002)(8676002)(4744005)(6506007)(6666004)(86362001)(5660300002)(66556008)(66476007)(1076003)(66946007)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: gkk3F2xalRYdTYLGVvIBs1GC/eKDmv5vbTwMX1Oevu16O5k1vZaNMDJCb2IWcL06iwP8iyLOrH8lrQJ43aYMdXkQEJNWS+/6P5sg6SgQQu8VcEpWlUUA8IrgPAI9o7b0/lOx1qF6bJq/O13wyR3d8jhpSGZCRF7+ZYlAvp/7EQ5Gfe67Volxm1eyhPMjfv8Itagz6MEcsK4xhrdqoU6/ndI6lWAmqeGbUH29onbXxVUVKuyPFw5MgvMSdAOCFaRdPZ1KDl596afTx2WSn9n+xMd/FXME7SsHVFToxz9bbKiSS9Jrvdri/WdQaVnp1Z8yr1MqADLE1IUmHP3nxK+rvDHEb1vkNhyFBH9sNElWPCA2qVGhS9xbnfeTp9fq8Qe9AG5otULdy2QiS5ron2t7hC8pS8zLxF/HmKXMcULgah2DiImZnF6k+IK+fK2TBIzqQeI2lNsZD1iejsUwa6Cdere1X95Udm0sk0eZkfEMkVy89zBKfjuH+Wqvf/Q/ZIdBVPURxTaLLaMCPnyx3xnmR8e3rkSxsrH2hYQKGAta/qoUK647mA8BJfkf8VPsAIZ3tCwAb75HR1KISysc7vQJHhTdzC+I/DpiEwWjiiQia05knSgac8q9AVlbW818C69HQgUccnCu6Dxeqjx9xqGwDd6GsGJ4XUqOZiwqKXW8BxWnyGu+wyw00BeucepdT9Kut2E9stSDId+GhjeJSLCF9KMswHoD+IVdDaTsS4PoAk03f+elipusczCRJUcHgZY/N+B1VXbaoSQJqV090tKo19FZHoMbnUVQX+wVUsGbxySnw32vgSPzxhTfqVP6g8+MUz6Lwj2trhafhDb0SM7ZVlmTAslFCMwBIAECcQbU94LQHXfLPnGtlDjnwYmsBamc2R9575zNbtQDdNXvLu+VH534FuzCJMqlL01Tr8kPmxg=
X-MS-Exchange-CrossTenant-Network-Message-Id: a95bccc5-3da0-47c3-a4a2-08d88a60b233
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2020 18:51:58.5356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K0sz9GclizEWRJ8bD11mcSP/jyNP5rsf3afjENAhGK/U6NCYQzAEWvDyciGpfjWt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4087
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_09:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 suspectscore=1 mlxscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 phishscore=0
 mlxlogscore=705 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011160111
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 10:43:40AM -0800, Jakub Kicinski wrote:
> On Mon, 16 Nov 2020 10:37:49 -0800 Martin KaFai Lau wrote:
> > On Mon, Nov 16, 2020 at 10:00:04AM -0800, Jakub Kicinski wrote:
> > > Locks that can run in any context but preempt disabled or softirq
> > > disabled?  
> > Not exactly. e.g. running from irq won't work.
> > 
> > > Let me cut to the chase. Are you sure you didn't mean to check
> > > if (irq_count()) ?  
> > so, no.
> > 
> > From preempt.h:
> > 
> > /*
> >  * ...
> >  * in_interrupt() - We're in NMI,IRQ,SoftIRQ context or have BH disabled
> >  * ...
> >  */
> > #define in_interrupt()          (irq_count())
> 
> Right, as I said in my correction (in_irq() || in_nmi()).
> 
> Just to spell it out AFAIU in_serving_softirq() will return true when
> softirq is active and interrupted by a hard irq or an NMI.
I see what you have been getting at now.

Good point. will post a fix.
