Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227D31C60BD
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 21:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729118AbgEETFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 15:05:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42812 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728853AbgEETFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 15:05:31 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 045J3Wub024104;
        Tue, 5 May 2020 12:05:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=g3mavX37+IbnL5JO09ZKYJNwsk4xa2P2Q9gg2Yr2WDA=;
 b=Ttgk6/+BWwed0fNKtDVuAl/KQSk8PC7SxJ4mqy4sxB0QaLkPCrht7qwXVWwpJR67DJ8i
 9zka45wFQNSCHjUwGUPmz/QQ7u23dApWGjMFFPcu9K70DnMt0IpmiW3G8Z3gh23aw4Lw
 /5XRsEfHiDcLqs3PORqJlpqpXVqOcfYljwY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30srsed0ky-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 05 May 2020 12:05:16 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 5 May 2020 12:05:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OP65rD2lv2UJ4oppyKHtfTmJRWAOLrzAepb3PJagaCc+rGIrHvOUjNfCcHwu4O+SgMhUsvBZ/+980AoONR4i1O+MDplZmcO9BM3NjHN91Z5pL8f4OZfgsVpPcTLkf/eXV8PlxmyskZElWtQXkCc2iqxsiNF2pFda+n9EqVKHRA6Baax7n9CXSLHaK/7mS1EJDxboFr5wNbSV6w43EgCdAeOnsiSwUnkI9L06CW9ExtyKPfQaqTd1mD3iVRXSm2w67SaBPzV/lEk8dJ2LqaNbGpqEU5AIRcSO7Yc/mKSPJWw3ec5lgJ9Av/gMfkjIgXtyZPfRXCL9XZaam/uePPiqbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g3mavX37+IbnL5JO09ZKYJNwsk4xa2P2Q9gg2Yr2WDA=;
 b=TVoV7jo8qbxAhFJOsRsTrI6FyssUt02HbahYxI7iaKliV7cVEX5JvFS1zdeGPOF6v3oWx9j8POHKvpzpK0oldAuZadYlJnR/cPd462mzKKbBGYA6DIrHh/NqkbRS/sK7Mt9mMaWC3dHeazKTO8d1+VA1wSWMdnD/jLJzBfR287IrpFDrvkhrcXh3e10qORENI7wMey/kjYvqwi8gd4W2/hRatxurD5+MO8YmZAnt0I3c1QKXjSm5S0+BIIIp/uRLoqQqkJyeG4HAfZyI1kk5R8zJjpcF9s7sNv+PmtJXZKC5bZ1GqfxqHsuTLP3gwwrKV/+QNF9jfd87HBhoo2vH1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g3mavX37+IbnL5JO09ZKYJNwsk4xa2P2Q9gg2Yr2WDA=;
 b=AJ7L/EHXz+c8BpGfE+82EczG0Thzo7QeXfAm9zb6qTPxVi4hTIXiFxS212ieKgkCT7UfhhmVnSEq1vbQq1zyAH6dyOJFXqVTxtobCXjjE/2JNMYt+sEjjbV3H8AwRmdEMANEtY9SwWHoAzP2UPnJxItfLEJKMMx7iBkFw1IIgEw=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
 by MW3PR15MB3946.namprd15.prod.outlook.com (2603:10b6:303:4c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Tue, 5 May
 2020 19:05:15 +0000
Received: from MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0]) by MW3PR15MB4044.namprd15.prod.outlook.com
 ([fe80::e5c5:aeff:ca99:aae0%4]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 19:05:15 +0000
Date:   Tue, 5 May 2020 12:05:12 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     John Fastabend <john.fastabend@gmail.com>
CC:     <jakub@cloudflare.com>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>, <ast@kernel.org>
Subject: Re: [PATCH 2/2] bpf: sockmap, bpf_tcp_ingress needs to subtract
 bytes from sg.size
Message-ID: <20200505190512.5pxrhf3mzh2cj65b@kafai-mbp>
References: <158861271707.14306.15853815339036099229.stgit@john-Precision-5820-Tower>
 <158861290407.14306.5327773422227552482.stgit@john-Precision-5820-Tower>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158861290407.14306.5327773422227552482.stgit@john-Precision-5820-Tower>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR01CA0070.prod.exchangelabs.com (2603:10b6:a03:94::47)
 To MW3PR15MB4044.namprd15.prod.outlook.com (2603:10b6:303:4b::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:3100) by BYAPR01CA0070.prod.exchangelabs.com (2603:10b6:a03:94::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Tue, 5 May 2020 19:05:14 +0000
X-Originating-IP: [2620:10d:c090:400::5:3100]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 251838a0-a02a-4a29-bb19-08d7f1273e2e
X-MS-TrafficTypeDiagnostic: MW3PR15MB3946:
X-Microsoft-Antispam-PRVS: <MW3PR15MB3946CD1005CC1908E86353D3D5A70@MW3PR15MB3946.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9ZHRcHFZ3qWnk0UdctvEZ5frFyKx5GmWIoV+HMydBt0FlToTztCRdPuhIbx3E1G2KdanmagycKpTjvgqgTSh4x5HvriGV/LsPRNJe6EM5Urh/iLM+ukID9Y883eWzMcoVkXH8lllvtUBGGvwmNhl3N3YD/itGpl3Mj6QQqFUp4erpIDL9KFAxbma6XgeP0j4hOKCLbCapfbsQKoWkSCJFKy3Am/HZFQ0epU0rQ5ANFfYrrW66NI4ssEINLI1bfbX8ErqhjEv/n2rWez2EhwfEcFk4xMcFCu43K11jWG9rJd6+TtyV3krlTJy+D8jgFpDU/+Fpm/VOJyoasUVCGyGY6kj/Tf+O8rvNihmDXBk5lyq+zS/FhQHQFvYiQfRknMTYK8avZOIrRKBsCkWROT7GKPsSGXsrutYDkMj5T+XZsbFJFswXFqpySmI3GfFz2PERIkL4LDQW+DeAaJwGPNd8zsYXOoUdNj5ZlnWePPAFJivcgvFHGK7c/t4kTihQw13jz+RAsibdLnBqZMFIlrKKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB4044.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(33430700001)(52116002)(6916009)(8936002)(6496006)(4326008)(86362001)(2906002)(55016002)(8676002)(33716001)(498600001)(9686003)(16526019)(33440700001)(186003)(1076003)(66556008)(66946007)(5660300002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: H463DPFnWwtQ3vMOcKl6mhYdxJl+9jGU1NHDqqLgRXoeMuODo7qKcUAXmBLEvHxu0SI8cI7bySb/WjMvzrChJ8rIgEpfYz1zzBkzZHz7x/gweewA2saTCFL6rZEpoXayTGMbYkyqdrhUPpyA/4mVeg4MJmxjiyTj/kcz8swhFGO2D7X5vHzW0hsEu7rniTGz+Zm+eYn3CDkurnMkfBy+Jcia+2TlQOP5ZepPZEJpvhS1HhZMkWoNKDP8+iO6a6+HpTKW7RaG14Lc9g6D1PQgvzcql0sDWdzZGqOwtiCi7skby8pY+VoQbQ2esTIE8Wk8Y1cO9kson1DHfwizd918VX/ePOxkYUBUdCimXAsEvTNrnRpQcLp0dXtnhkmUZ8MLLs390MDpiWcb1KYcZ83J8LUn3+s1fEQ+wVXfNBbsQkZ0P4SnNCZc4UawyMfA0qJQl+l4QCTicueEQAMfrKhVRWXB6EjDbO+LQW1uff7pE6vhltEclH08aJ+Qo1t30MrUvCNXLceENMpvjU10hEVW1yTEdWvp8y+nd/AjHOF0UOFh7c24cTcGDD2stsfIYGBux3JLD3xrSrsvbPPYvv+oNpTJlplOis06lVgLLUM5Zned9QkAoTMXqg8IDoaof86VU/4Je46gjT+oLjo1X+9y2w886Eagw1r1N4dWzvwSTlsra6p/AhG2sTkDlqy8YU0Hc+1++O/gXgbY5UeRhFzo/p0H2ZeG/4XJ323V/4mcLLiSjJXfYZcYCPt2Sp1NWYn2SU/64OC/T2xKI93pJiQiHaU3ByDlFjUJR+LMlImGKbDDJKIXjwYMwLFoflqMXQ/mVHzbiXIGDFL0eWdmzaUsbA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 251838a0-a02a-4a29-bb19-08d7f1273e2e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 19:05:14.8649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CkyJ/8irJfijWL4JGdXsHi6CnTfhiBS9UobXQ9r86YssSJF0J3Ih06I6H3YXF2Jp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3946
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-05_10:2020-05-04,2020-05-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=558
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 phishscore=0
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=2
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050145
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 04, 2020 at 10:21:44AM -0700, John Fastabend wrote:
> In bpf_tcp_ingress we used apply_bytes to subtract bytes from sg.size
> which is used to track total bytes in a message. But this is not
> correct because apply_bytes is itself modified in the main loop doing
> the mem_charge.
> 
> Then at the end of this we have sg.size incorrectly set and out of
> sync with actual sk values. Then we can get a splat if we try to
> cork the data later and again try to redirect the msg to ingress. To
> fix instead of trying to track msg.size do the easy thing and include
> it as part of the sk_msg_xfer logic so that when the msg is moved the
> sg.size is always correct.
> 
> To reproduce the below users will need ingress + cork and hit an
> error path that will then try to 'free' the skmsg.
> 
> [  173.699981] BUG: KASAN: null-ptr-deref in sk_msg_free_elem+0xdd/0x120
> [  173.699987] Read of size 8 at addr 0000000000000008 by task test_sockmap/5317
> 
> [  173.700000] CPU: 2 PID: 5317 Comm: test_sockmap Tainted: G          I       5.7.0-rc1+ #43
> [  173.700005] Hardware name: Dell Inc. Precision 5820 Tower/002KVM, BIOS 1.9.2 01/24/2019
> [  173.700009] Call Trace:
> [  173.700021]  dump_stack+0x8e/0xcb
> [  173.700029]  ? sk_msg_free_elem+0xdd/0x120
> [  173.700034]  ? sk_msg_free_elem+0xdd/0x120
> [  173.700042]  __kasan_report+0x102/0x15f
> [  173.700052]  ? sk_msg_free_elem+0xdd/0x120
> [  173.700060]  kasan_report+0x32/0x50
> [  173.700070]  sk_msg_free_elem+0xdd/0x120
> [  173.700080]  __sk_msg_free+0x87/0x150
> [  173.700094]  tcp_bpf_send_verdict+0x179/0x4f0
> [  173.700109]  tcp_bpf_sendpage+0x3ce/0x5d0
> 
> Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
