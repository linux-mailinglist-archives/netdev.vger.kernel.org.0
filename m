Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB0818C65F
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 05:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgCTEWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 00:22:32 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58332 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726843AbgCTEWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 00:22:32 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02K4ED5g027043;
        Thu, 19 Mar 2020 21:21:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=8G0HHu8Jd+FMx9Fj6xY8SPQ1Prm8lUI6Exwa6CtRNfA=;
 b=JDBdpwHm+rYH5JTIHoXJUk9NIhKdO4ysZSDkHpffHnDXcnJdTCDGJCnDE00qfruVZgS7
 EaIpLfNV4euolubAO0CtsU6HG8HsAKqvhV3i+NWe09Silb6YB5qqfnha1DOIB9zyDHDi
 xeRQ2CLEzC7bCeySzMN5pOaLXbo2AEEOh9Y= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yvf4hsu96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 19 Mar 2020 21:21:54 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 19 Mar 2020 21:21:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TXwaklvg1kbWITSUBwy1FhKjkjhjDDfsWoHdBVVVk4F+bSxs16pcopvoMeXAJxMcBlN9g3fnjBNTbgGGoAqDcfyOAjkffIUMoLTid+bPune4ZFVG5zS4/jkwumVqQZVwI7g2CiqpzCdrIcqKLkaChehNFw7kSwsB18ueXfNoDjcu006C9tMk5px55uSqjopsPm+a0dlQDZ6LCqMJ9eiLXGmHJBQUjgrhq07wo2oVu+Nd8tFHTp0RNEFUhEyDi/J2wnZoMrqp1Bmv7TBIQrJr+yCOrAqzkUsWepWDMNQVRN7CjlPTDopVy9IoztGnCjUK5xKNVpFAmk/c6TF2fOoTIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8G0HHu8Jd+FMx9Fj6xY8SPQ1Prm8lUI6Exwa6CtRNfA=;
 b=Ho4kGGu4CGjOlvxtAL47QgCPp8Xn7vWU/zY0Dg+efyyMx4r09/7ZSzrhDVxvhVeuD5dsRxS0ZXgFaY9qVlMXfAkkdlcAkUSXOdi/jYPh38gIxrEUSbi87I0RxCLBlEKNkRc3EunDelN2U7sdlQIdIWEXuCDa5gZhHmyFoksX3JIqbIgVjtiDcq2VYB2tilTafW5ofZ/aKwbYE0jRjAvk+aUddaORv8QrFqpFqC33o9xAW1hfCOgOtAgfFuBUgZyzl+ryzUMNGIzqnhXRIFSs1aOphRWvzDykcU6yYBrbfLTWjs7vpHWJ7HEeihn4fb21NLxaUdUgIsZJjx8uz8T2fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8G0HHu8Jd+FMx9Fj6xY8SPQ1Prm8lUI6Exwa6CtRNfA=;
 b=igfjL+uhTl06ojrrRG5RLJaCzERlrVx3IeTCxUmHWJVwj2Y5V2FLq3ye6DaNdE9uM4La6wApvv6urDuhoIV2ndqskDkAxOnFzyQmluwBptccpHoQ3jYXMkyLMs8agNyY8Zm+6+p4BUa7aHODPbDkOgTqQyOUK4vjmWHkdguz4k8=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3772.namprd15.prod.outlook.com (2603:10b6:303:4c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.18; Fri, 20 Mar
 2020 04:21:52 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2835.017; Fri, 20 Mar 2020
 04:21:52 +0000
Subject: Re: [PATCH bpf-next 1/2] bpf: tcp: Fix unused function warnings
To:     YueHaibing <yuehaibing@huawei.com>, <lmb@cloudflare.com>,
        <daniel@iogearbox.net>, <jakub@cloudflare.com>,
        <john.fastabend@gmail.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <andrii.nakryiko@gmail.com>
References: <20200319124631.58432-1-yuehaibing@huawei.com>
 <20200320023426.60684-1-yuehaibing@huawei.com>
 <20200320023426.60684-2-yuehaibing@huawei.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <d18a19a0-f147-03ad-b8a5-4b502199cd72@fb.com>
Date:   Thu, 19 Mar 2020 21:21:49 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <20200320023426.60684-2-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR1601CA0017.namprd16.prod.outlook.com
 (2603:10b6:300:da::27) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:c5b) by MWHPR1601CA0017.namprd16.prod.outlook.com (2603:10b6:300:da::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.18 via Frontend Transport; Fri, 20 Mar 2020 04:21:51 +0000
X-Originating-IP: [2620:10d:c090:400::5:c5b]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb67bd70-d7c1-4460-aff5-08d7cc86373f
X-MS-TrafficTypeDiagnostic: MW3PR15MB3772:
X-Microsoft-Antispam-PRVS: <MW3PR15MB37725AFDF5B4CC3A201BE48FD3F50@MW3PR15MB3772.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:87;
X-Forefront-PRVS: 03484C0ABF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(376002)(396003)(39860400002)(136003)(366004)(199004)(6512007)(478600001)(31696002)(6486002)(86362001)(4326008)(2616005)(8676002)(8936002)(36756003)(81166006)(81156014)(66946007)(31686004)(186003)(52116002)(66476007)(16526019)(2906002)(4744005)(66556008)(7416002)(5660300002)(53546011)(316002)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3772;H:MW3PR15MB3883.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4ACjmar80qtnxSRfEQeL9EMv0AzIPuZpvaTUDGDtNdLDBVH6wb5yuqCZGrVLYLoprlw+xuxFCdEtOfKOAp4qusAyI22uhkzBiHR4o0VZNu4qmC52kPXfiekSdStnB7qfSUeAEzGzY4fJLwuzMmEvFNZsWNOeJGMyMfahVjYAgz7Qq2IJwQ7KbQBsdTL3LB2m20I1Dxc6stcU2HnmXgcyaR0CLQEIM4xNjUPQ2WeuBgNX5XoGCzbtFfZFG3WBY2RksbtSsT8AFg52ObpLN1+FwPevZ1GbjKu7mw/rZhZsv+2ppBsTlQngieiJgLoYNzbRF4zOOktg6WhMJLuuTaPkQ8Fv6gg5Gztb5BRwTN8MV7Yq+oXD+MgiI1Fpxz9sHpqh/F7OTgmc2gUHGAqW9pAeXEq6cQwOsbNddNNlUppenPCxDpwFkOz56C3AxEfDt27q
X-MS-Exchange-AntiSpam-MessageData: QSHBR23z0u19IoN2OM1hRovUSAQsB38cCx3i4dCG/p4nfGdUokANJJjvzetu/c6+pATC3SQlK/QJLPnvyYxyeFNnuB2jezKZ79xiQkascMT0L23ZRL5a8Pmjft6O+zD0JrTkx33MfTXY1vZuzrTfudhgu2GHPzbuFlOEv7Z5n1lhCRxvYZ09ujdFrsSTcufw
X-MS-Exchange-CrossTenant-Network-Message-Id: bb67bd70-d7c1-4460-aff5-08d7cc86373f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2020 04:21:52.3198
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YUJVGnD++0ApbYWEa5uX75Cfrcpzr5ecz3OrGDZ2sJHPswXDCYCjp4jMbctujn8E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3772
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-19_10:2020-03-19,2020-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=999 priorityscore=1501 mlxscore=0 clxscore=1011 adultscore=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003200018
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/19/20 7:34 PM, YueHaibing wrote:
> If BPF_STREAM_PARSER is not set, gcc warns:
> 
> net/ipv4/tcp_bpf.c:483:12: warning: 'tcp_bpf_sendpage' defined but not used [-Wunused-function]
> net/ipv4/tcp_bpf.c:395:12: warning: 'tcp_bpf_sendmsg' defined but not used [-Wunused-function]
> net/ipv4/tcp_bpf.c:13:13: warning: 'tcp_bpf_stream_read' defined but not used [-Wunused-function]
> 
> Moves the unused functions into the #ifdef

Maybe explicit "into the #ifdef CONFIG_BPF_STREAM_PARSER"?

> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: f747632b608f ("bpf: sockmap: Move generic sockmap hooks from BPF TCP")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
> Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>

Acked-by: Yonghong Song <yhs@fb.com>

