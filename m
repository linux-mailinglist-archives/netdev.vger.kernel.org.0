Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3A6A32C3DF
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354417AbhCDAI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:08:27 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61662 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1841818AbhCCGiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 01:38:13 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1236TFNS007277;
        Tue, 2 Mar 2021 22:37:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=nmZ/QRKEopt2Vhi6TycDTvlQ+yCzAjGTHqv6bhmP1AE=;
 b=FVdYkxTXjpNjLFngnEA9aikfVH9ZbAVtY05aqXIZHifW92tN1ZoTo0ctRjTxR+8pMCJe
 pgGcfekLR6kFOArku6TiDAA1FIde/6dDpsr/4bv9h1n0DM+g7SW9fBKBVWEkt7g3q+b1
 ZmgGdFc5mLZQwimfEneTRsAjbxKPn+EZa8k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 372107s1u0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 02 Mar 2021 22:37:19 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 2 Mar 2021 22:37:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HZApg8BOpUe1VnqcvYtT+A3ha4IP6Vp9iGyvbgB9U4GrDJgylGzERWNMDfqP/rDZngbwCn1SOZZ1yBiYaMICTP3pqgnRNpwXMyShDWan/r9N0j2qm3TXXc3kfy3AIPYLiVkp40lSeOdBU6bXTtWc1bm5SrW6bnohlhm5b5SLrownzym4+K+zYR7mYjud7Ny5O1Pd6OjWPeePYI1+aE1J/PR+GSr8XVucdkLTG6RFV8sa25H5wfA3tJS/JOwWooQs1EEiAy+S/h4SSAWPxrRR7Zx8riWS67PbBwdfPYn0APy5o4A27kKIpSlV4X62XM0ZMtpzhbSPBOp91b0LA1IBzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nmZ/QRKEopt2Vhi6TycDTvlQ+yCzAjGTHqv6bhmP1AE=;
 b=PChMhSJbRkmrlyPa9ki66JAaqegxm5v2JDWAVa9N7zIq02/TQkFe0IsLyWtAGQ61VWCuAM8lHBMqAI0pQpe8Cv2s206yO6I/Cexd1jETJ8FFSbxCJdGCkXABtetDivSRmvp5XCIA1LbLoSGEAjJe0zeVgz3fVzFCoRUWOG2UVBJ0I+HjUUTGvOWetDm5TEqVxyMnqSL/qFuSv0Nu5C1wQfZTmjh8Cq8NhGgQPpb8B66Ca3tVKDuvkqqdN4ZfrtB9MBiXkPkhtJPDvVjRBA1AsGGUYUsSNqskgZSgafUAg52Eue3xECh6QS1NdhCngIDPMgiinLdVII9WtskpydaOlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (52.132.118.155) by
 SA1PR15MB4658.namprd15.prod.outlook.com (13.101.86.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3912.17; Wed, 3 Mar 2021 06:37:17 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.3890.030; Wed, 3 Mar 2021
 06:37:17 +0000
Subject: Re: [Patch bpf-next v2 8/9] sock_map: update sock type checks for UDP
To:     Cong Wang <xiyou.wangcong@gmail.com>, <netdev@vger.kernel.org>
CC:     <bpf@vger.kernel.org>, <duanxiongchun@bytedance.com>,
        <wangdongdong.6@bytedance.com>, <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
References: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
 <20210302023743.24123-9-xiyou.wangcong@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <258c3229-1e60-20d9-e93f-9655ae969b6e@fb.com>
Date:   Tue, 2 Mar 2021 22:37:12 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
In-Reply-To: <20210302023743.24123-9-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:e54b]
X-ClientProxiedBy: MW4PR04CA0350.namprd04.prod.outlook.com
 (2603:10b6:303:8a::25) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::1a32] (2620:10d:c090:400::5:e54b) by MW4PR04CA0350.namprd04.prod.outlook.com (2603:10b6:303:8a::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 3 Mar 2021 06:37:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7c59218-8c18-4d5c-44a9-08d8de0eca00
X-MS-TrafficTypeDiagnostic: SA1PR15MB4658:
X-Microsoft-Antispam-PRVS: <SA1PR15MB4658A07BA3ED0E7EBE6B34E6D3989@SA1PR15MB4658.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5hDAk6xBmyLNMnb7PxXUOO2Xu2n5NR0NDu/ndWSwlbcZtw27cXslbUCHpanBdKB2YwBR1LTvjOGOJNIw7JH/XGeoTR2EOuJrXgfOHOFPQAOs8pQdb6J0FC3hnUYr66VK5u5zDPxW0zk+t7N/zKW5aE3dUrad2OIe/rjYdr3UdeFuqCsEVv3FXaCvlhoXnvyhlBAQ3pTlv1Jg2xNhyIRgqSDdBun8OEs+A7U60JMahLBLN4yGMzveh4+03a3w29BrrQrPW6W93OAwdY8uqTu/jxEOBS2GePenuX/PvBtslGAdzAfwoorluZIp1TA2hrL565/SufrSHLtY3r6z1/gYdUffZWFceN/c3ayuA7a/YBqdj30IrjU8DS30tRT+zsg0RdZ6EBK1L+5rdJ07mptWg76C71ZC0Xw9B5b5XHRgkZDgRrqeIiu7ZN6Aowysqr5BeuNYN4PNtagv3edlrKZQeCUbanOKJUeF3dnzW2c/TFpsSxY2xDk1gj3TRuuYg/cEgpNkcgeFR7NwSoF+dNUAjj6C/Q22viVO5mWauLEAlNuxQUQZ6KVAl7QAJS5TTTVTsI+BB8NWb184ml6ncf3BVfeSKP9pdgtNKUw1ccckx+o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(39850400004)(366004)(346002)(396003)(8676002)(86362001)(53546011)(31686004)(316002)(52116002)(6666004)(8936002)(54906003)(31696002)(36756003)(83380400001)(15650500001)(7416002)(66556008)(66476007)(5660300002)(66946007)(2906002)(4326008)(186003)(16526019)(6486002)(2616005)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WjFaMTBNeVIyOTFQRHBYNk1xdytlbHVLRVpyZzVTZ09zcWpGeUgvdUowYkhG?=
 =?utf-8?B?eXlMWVpqQ0VTL2Z0a1NDUzkrZ2dMa2dQc0VaSUlJUXRteGgrV3FmNjd0Um5C?=
 =?utf-8?B?eWEvZExIZnltRk5MSFhTdm9icStucDRmZXI3c3lvd2QyMGNtbmJRR0pqeUx0?=
 =?utf-8?B?bVlqZWs4enphZjhGNmUvZFg3UkRaZm9pamtQRDBJYlE0S0gzVjVkS25ZbWQ1?=
 =?utf-8?B?bWg0VTd3OXA0VmVYS2JlYnNycVZ0dFBVNEEzSE9ySEtUdjlnTTR6V1ErcDNn?=
 =?utf-8?B?WHNtRGdaWmV2YkFPZUxQQ0IySE1CQmRUSys3UVVoZ1VjbHZwM2hRTm1DT3Vr?=
 =?utf-8?B?cWFzcnF5a1JvSDdJZ1FEVVIvbmgrYy9RRVh6MHUxZzBNN0tIdlJ2aTdYaHFO?=
 =?utf-8?B?bGRiSDZSa1V0RWh4c3lhYjhzNG8xZ2tvTmV4Q21tUU03T2NLTmRGUkU3aVo4?=
 =?utf-8?B?ZW5rN004YWVwNzZjYlNXY2dCVlo1eCtrTUlqRlVOSDgyYURHMm1sNFZXZEZW?=
 =?utf-8?B?azdGT291emp6aTlxeUxSNXBnbUVsMy9xbE5UQVprczZqcFh4bk5sV3IxY2pM?=
 =?utf-8?B?TXpIVC91cGVmZmhLNmQvN0hOTjlWS1p4dzNYS2NEOUhMMVo0aWI1T25NZjk4?=
 =?utf-8?B?S2xsbU5wU3BqSWFpOFV4dG43TUdhb2JFZ2oxeUYzL1RIY0xSQWIzUWcwc0xz?=
 =?utf-8?B?RTREK214WTdIUUl6eG9OL2ZzMnJLbWNCSjdFQU5RL1kzRlAvcXJCY2k0QzZE?=
 =?utf-8?B?WGRoTFdKSk9YTGJJVkgwcU1UT1ZpeWV4NWNpQlFWelI4MkcrWmM5RHI3YVc5?=
 =?utf-8?B?bC9MREZCMGVjbWpaNDBuM3NzQVk0K3VEb3g5TjhUam8xL0xiRzhVdi9ZMTFJ?=
 =?utf-8?B?enBRSU1iSFR1eHBzeXRtdmV0L21kOUdta0sxRWRKcjBQVk1tdEFxMi9ZSzY1?=
 =?utf-8?B?dExDVDNKYUJSTmxYT1dPT3lMOTgzRHl1OTVac05xN0duS0FmNnhsV0pOUGdN?=
 =?utf-8?B?UWI3bzVYU3UvL1dtd00rQk5CSnp4ZFRHVGlFcTdpR1RTZVYwN0xaYmpQZG9V?=
 =?utf-8?B?a1d6akxSY1A1amVGeDBxR3d0emV4ZVMydkJuMkNOYi9GdHNTaDJ6Vk9uMDhz?=
 =?utf-8?B?TjhLZU9FbCtGZk5ON0RWODNlZFNQdGl3Z2RCYnBlay9UeGdtQWRUN0pCbC9t?=
 =?utf-8?B?NHpDdjk4eHV2Z3FHZytvRFhGRmFoYVd1U1ZWbmsxRWR0RzZqbm0xOGIveDlS?=
 =?utf-8?B?NmF5cStVbzZLcGo3dFFGc0VZNVN0b1FLaDh6QXh5ZGVSYzQ1Z1QrYTNyTjU3?=
 =?utf-8?B?UVJpU1NQcHZ4a1JaamRRUm4rZHRuV25LR0d3MCtFOGZ1T0VCZmdvaUV6Lzgr?=
 =?utf-8?B?MlQ2S1ZWVWsxeEdjejZXd2hmdms3U0U2VzFzK3dyMEhoSlMzTHFWWUdUUGtr?=
 =?utf-8?B?cDY2aFVOVW1JUTJmS3hpbXpoc3VwUlZaTGRGODh2WGNtNXQ1TGV5SXllcEFx?=
 =?utf-8?B?SmJZWDZBUXhyNGVPb0o1VmRSLytnQVAzYjNIOE5zUUw3aG5YdlQ5alFIY0hr?=
 =?utf-8?B?bFNRTi8rQjhOSVd2dkE1d2JKZ1ZuRmVNb0YyVkZUdXRnWHA3ckxLajRNa0Ft?=
 =?utf-8?B?UVBxWElhbXMyRk5YcDVvaEdrcHdYSGxydzBPdnJLY1JROWh4TjVXUFdjNGZP?=
 =?utf-8?B?M3gvdElMVUFMZ29WcjlRdEsrQUFJcCswdU1KajN3RVpaYWZLUjl6S2hXK0hR?=
 =?utf-8?B?cmU4UndUTUY0V0Q0MFFYQlc5RXV4TGY0SHNaWnlzOHBlR3dEbnM3ZGNCUGRC?=
 =?utf-8?Q?7sCFzks56bjQ85bG3grR+nZkXy7hCejkIPD1k=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e7c59218-8c18-4d5c-44a9-08d8de0eca00
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2021 06:37:17.3858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GnQ4tPLurDOMmQlMzU7IpgTVI/uP1RrAaF7C/GUvCp0BQCK0nuP/xM78ZdJnunFs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4658
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-02_08:2021-03-01,2021-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 adultscore=0 malwarescore=0 clxscore=1015 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103030049
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/1/21 6:37 PM, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> Now UDP supports sockmap and redirection, we can safely update
> the sock type checks for it accordingly.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>   net/core/sock_map.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index 13d2af5bb81c..f7eee4b7b994 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -549,7 +549,10 @@ static bool sk_is_udp(const struct sock *sk)
>   
>   static bool sock_map_redirect_allowed(const struct sock *sk)
>   {
> -	return sk_is_tcp(sk) && sk->sk_state != TCP_LISTEN;
> +	if (sk_is_tcp(sk))
> +		return sk->sk_state != TCP_LISTEN;
> +	else
> +		return sk->sk_state == TCP_ESTABLISHED;

Not a networking expert, a dump question. Here we tested
whether sk_is_tcp(sk) or not, if not we compare
sk->sk_state == TCP_ESTABLISHED, could this be
always false? Mostly I missed something, some comments
here will be good.

>   }
>   
>   static bool sock_map_sk_is_suitable(const struct sock *sk)
> 
