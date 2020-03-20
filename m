Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77ED218C66C
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 05:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgCTEYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 00:24:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56718 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725996AbgCTEYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 00:24:50 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02K4ORs6021892;
        Thu, 19 Mar 2020 21:24:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=XZWWh/mG7PeIkuVv5hj2IhN3imo98qMlzNv516BDpQ8=;
 b=PwQD3H1Vl+wjAM2NqhArZukeaCn018eHvPpysgCWA/WKD3eBqafzp6gQiHpCLomL7og8
 kA5cZj8MaGJMQR/B1XUi5gDCQSTlSaAbvNvk2dx4hyItJL/g9ZvJolini3ZxkCdUGJ+w
 nRoT5kzdN5rryFrKgu0jIpcfHA+TPLguAYk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yu9avv063-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Mar 2020 21:24:27 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 19 Mar 2020 21:24:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=djfKrwyvRhkGCTQthy5x3CofvG1o2dvtJZe2iTCDHCvTpIej2bB26ahozEK071wLvwnhrTzOKGbe6vtmxpwTQ63XmwNXySst8V+njNBk9wOsyV1Ls/qd+4z0M4qrUWAIzVo+5IzBsBdnhTuii27qOHTDLFxD9Ibgpe6g83akcVL1fxcPR1ntTs2jNa64vgx2ylVXEGgSYz6g5SGbyP6VTrbxUu6HmVxYKxIVNYoTU2nrIhZiYnOr9rriT5AW0e4ZjxYuEgYWr+/uw46g3ZdietWWNqH1PXS2Q5xDlrEzD6IZ2q0cL8mCBYk5iDnU7YlC81FFYZ77Q+iiCqi03Fan+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XZWWh/mG7PeIkuVv5hj2IhN3imo98qMlzNv516BDpQ8=;
 b=Sr2KvFoUV5E/TsFyD/wBjrH0pAPo9De4PmkYBl+pa2zbsH9X81x8MT+uiZAzlXm4XPic419untQ2QAWAYVmchb93BSlEgi15/zqTsOyRV8kyDNvd22UC5qu3x8zoG0as3Cxs5Tc5XE7Ow2dXv4X2eesFBXio+bmGtV4AOwBRYF5gGzcA8CjR3aFjqrYGhgbVT/bWVwyi0C9mfM+hRXl+qSbbPd7QH+jwhh0KECHkBLHBZxqUkLxvWgsuOV7fPNd1m+yfCpvFB5vZ1zQhVGFJx3yD9DHg4VmkA6oXAZctnyZEOGycFoPKfebDiEPMSkl+OPPSKw+cqf1wzhiGw1qNng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XZWWh/mG7PeIkuVv5hj2IhN3imo98qMlzNv516BDpQ8=;
 b=GLdYQfeSx3TgJja9uHg3kvdJzrCQ7VzoJxLTOsVF9I3oy+1R/2MjNaXHFun/ZIBBeiOqGAHvZMuAa08gart26dNan1EjMhMMbDFDKjs6ZmZudRKhTf/aVXcye7qsK9blJeEauRD3MhjltDGwTseYJ/Hs3qO5GjXzjvYD2oTwvnE=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3772.namprd15.prod.outlook.com (2603:10b6:303:4c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.18; Fri, 20 Mar
 2020 04:23:51 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2835.017; Fri, 20 Mar 2020
 04:23:51 +0000
Subject: Re: [PATCH bpf-next 2/2] bpf: tcp: Make tcp_bpf_recvmsg static
To:     YueHaibing <yuehaibing@huawei.com>, <lmb@cloudflare.com>,
        <daniel@iogearbox.net>, <jakub@cloudflare.com>,
        <john.fastabend@gmail.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <andrii.nakryiko@gmail.com>
References: <20200319124631.58432-1-yuehaibing@huawei.com>
 <20200320023426.60684-1-yuehaibing@huawei.com>
 <20200320023426.60684-3-yuehaibing@huawei.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <f3fb3edd-f853-324f-ad32-04e0d5b0239b@fb.com>
Date:   Thu, 19 Mar 2020 21:23:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <20200320023426.60684-3-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR1601CA0014.namprd16.prod.outlook.com
 (2603:10b6:300:da::24) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:c5b) by MWHPR1601CA0014.namprd16.prod.outlook.com (2603:10b6:300:da::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20 via Frontend Transport; Fri, 20 Mar 2020 04:23:49 +0000
X-Originating-IP: [2620:10d:c090:400::5:c5b]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0baed666-f58d-473e-6d3f-08d7cc867e21
X-MS-TrafficTypeDiagnostic: MW3PR15MB3772:
X-Microsoft-Antispam-PRVS: <MW3PR15MB3772992C00666B30B971544AD3F50@MW3PR15MB3772.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:182;
X-Forefront-PRVS: 03484C0ABF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(376002)(396003)(39860400002)(136003)(366004)(199004)(6512007)(478600001)(31696002)(6486002)(86362001)(4326008)(2616005)(8676002)(8936002)(36756003)(81166006)(81156014)(66946007)(31686004)(186003)(52116002)(66476007)(16526019)(2906002)(4744005)(66556008)(7416002)(5660300002)(53546011)(316002)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3772;H:MW3PR15MB3883.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hGLLweNlkAzf2xvtVY6PwBIecS1u9TAwvnh+OWDjo3Ce5K1teJ3LtX0emU29lQNu+b0Y3XI0499rSleOekVTOM2GOpvTmA67ofYmdOI3YxxOx4CTCv2+gBUS4JE0fm0DMOQO7ioBJuOBMID5b1daWJkYDlyE0D8UqYQcs9A8pQ2SS5bVR+ru/uV8okOlnt+uAe4ybKlFLnJijWFG8wuvsqwRHldYpHzJmO5f4CvKnRtAJWfjB04OW32aFiOidEStSA7twbdWLCzwQLk/2yBMOzWdsNk75tGAIrSCRlJXhc1OOBUCKOg6D38BYlZ8rpLB4iPDHlnAF5Tm5H8MpntFP7b8/eQofsEvWLrtsvGVFHzLlTmkrziKRHU1jawVN3s0/KMcEvPoKKnHbIPNSQGqrmpUW40yp+h5AuPwA8YGUfQKIt36LgHnEDH4/pjP+xjM
X-MS-Exchange-AntiSpam-MessageData: 5K3MSSurklLRcLUJSj5h5S4F3QmFHK9lAtgsfkB58jLyw8lOKPnPU1A9qntHLqQebgWh9xX3+3x7igHOOLtD69TVHyHGyRFRRT1mX06C9OHSQb2jKTQe22Tz7QT9m/0ZGo2y1vbdF6dDjh/rapX6+cYkuBtWcqzbyIju/vbzIIdVUM/+bXuYkbz1ytUlTVMf
X-MS-Exchange-CrossTenant-Network-Message-Id: 0baed666-f58d-473e-6d3f-08d7cc867e21
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 04:23:51.2248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g0EU/fhFNq78SgKzvi2w+zQRva+a6w7ZSnwoFYcCBcygteiYJQNa40qHQK6aqYwD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3772
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-19_10:2020-03-19,2020-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 clxscore=1015 adultscore=0
 suspectscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 mlxlogscore=937 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003200019
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/19/20 7:34 PM, YueHaibing wrote:
> After commit f747632b608f ("bpf: sockmap: Move generic sockmap
> hooks from BPF TCP"), tcp_bpf_recvmsg() is not used out of
> tcp_bpf.c, so make it static and remove it from tcp.h. Also move
> it to BPF_STREAM_PARSER #ifdef to fix unused function warnings.
>
Fixes: f747632b608f ("bpf: sockmap: Move generic sockmap hooks from BPF 
TCP")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>   include/net/tcp.h  |   2 -
>   net/ipv4/tcp_bpf.c | 124 ++++++++++++++++++++++-----------------------
>   2 files changed, 62 insertions(+), 64 deletions(-)

Other than the above fixes,
Acked-by: Yonghong Song <yhs@fb.com>
