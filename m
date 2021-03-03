Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72F532C392
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354401AbhCDAI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:08:26 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23632 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355208AbhCCG1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 01:27:14 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12369XSY027310;
        Tue, 2 Mar 2021 22:26:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=spxVmSpcCjZeY+kyZdBZBYHUtH0Ks3ZU6W+yZX7dhjg=;
 b=iJdH3Zb4zYhpPRoOrMcukNIjxLh2iGqGyYCy8kav7ckXw3KOqt3fsj7vfxtZrIkyZdGo
 V5wiuw0XIa/Tgov34/zZlxdMhJ/xIDHlUnGjFkcp/UgOubP3MTpBuFEdVyDHT3Q7Lw2P
 xenAq8A2pwRS7vemZwbR7Go3X82AA5odhLw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 372107s0en-19
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 02 Mar 2021 22:26:18 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 2 Mar 2021 22:26:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IWEe9uc9ih6wtlx/IutmZ6sNAk9AIV6Uqz9bYI5fwoj+yxQl9NXd8pMdxbOjcBQ1aJlgsnAJO54W+gqTUWkK+y0cBseCwEkC9BC7LNZMlsH+AI3t+zz5ApXxmqh346XwHGD1QL0OsE2YQjrDwiIOxM+03rmpWviBJptoL5gri21cxXxtf3T53xWfCecxOEvQVe66dwQU0FoOqMj/dcDoXp9zxxOixwgX11z9JHe0SwgdCHoCtmk/MnDdfbFgzFGxuKhGo4XVbi/KA8rqezlyWxPQR45+ciPvcTiKvqGmu1h3OUiQ884rs1jQjjjTLFHVHS2HPb/NW6k61jx8La4i1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=spxVmSpcCjZeY+kyZdBZBYHUtH0Ks3ZU6W+yZX7dhjg=;
 b=XY+HLEdGrMS3S9IphaHUO4pX/j/IzjG/ZFuMal//yoclI8j75zEnZ95bQKyTlu2dogH74V8HXHPDgjz5l7vY5mL7wtRzQUcJlS2mgZClTiqqaiYg01RHSGqD0futjqLZjbZE2kRy7Hz9ZRTLPe0SLOJlPgDkcLOPAeLZ/d6gz/bIM8SWfIuGU6Pfj1NB4rc07u3+xc7sPLKg1mCTlt2BC0UfyPeU/s38TAhAqRdiWM6SIrZ05+hDRpF3D9j4Gebz/G2XCKYGQKO90KajLLXex000ticfPU9zKuqLiZpXUlvX5a/hmkKH6VyWwkR42GHBmoP8dwBi+Vs+oqXdpCxLNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3933.namprd15.prod.outlook.com (2603:10b6:806:83::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 3 Mar
 2021 06:26:13 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.3890.030; Wed, 3 Mar 2021
 06:26:13 +0000
Subject: Re: [Patch bpf-next v2 4/9] udp: implement ->read_sock() for sockmap
To:     Cong Wang <xiyou.wangcong@gmail.com>, <netdev@vger.kernel.org>
CC:     <bpf@vger.kernel.org>, <duanxiongchun@bytedance.com>,
        <wangdongdong.6@bytedance.com>, <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
References: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
 <20210302023743.24123-5-xiyou.wangcong@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <ac8ecae9-7b8c-9c27-8b2d-7f091976579d@fb.com>
Date:   Tue, 2 Mar 2021 22:26:10 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
In-Reply-To: <20210302023743.24123-5-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:e54b]
X-ClientProxiedBy: SJ0PR03CA0136.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::21) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::1a32] (2620:10d:c090:400::5:e54b) by SJ0PR03CA0136.namprd03.prod.outlook.com (2603:10b6:a03:33c::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 3 Mar 2021 06:26:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0394f2f-d9df-4825-16ab-08d8de0d3e29
X-MS-TrafficTypeDiagnostic: SA0PR15MB3933:
X-Microsoft-Antispam-PRVS: <SA0PR15MB3933D71B87EF05D3D4370AF9D3989@SA0PR15MB3933.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:115;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: on1VhE9FVBspnHP/VlXx0NzEj/WWPsrXoRSBzGTaJ0ahVXg86HTiGI3Nm7EydAOjcgo0NcybA1b0rjOZMAOppFRk+OlFKs95kg/kTzElQnIW4eGcFjR+aZGPF40xQm/Balp/3LsbOfNC8Fkx+7TzkTZ4G0gRCT6EZbaQnryfeZstkO6N3lkHH0yapOrKh1HftYZF2RtpYJTMVCabNnDpYrWNOHxOZWWyTCPWHCQkKh1wG6IKzBobn7sK/6y9GudnQr6zNzHAXZ1oYrlrMvXxZcOAujFYKFKPgaeUQtjyUJ9vzsNTiXmHU5jkc0xFrkPYAmb8QRCPWc8pnc4VPIfK/CyasUCEh1ZIzIRtwmoMtcloXMcC2DpscwfS45uHyROVKouYem6VIOpb0jhALFSO3nBaqjXkqtO+uNsYGhnoNneAERH8KxlRpCcgZWcpmiSsNMYy9PneXn2chgJ8LKrI4QQfLU8LntPwx0M5IKmkwspz5DUDSbotWUgmlG6FR02ufCyqxcxPycIbIqvUXIPEkXIrlSd8Hy2xlErBxbi6xktWi8cxYEDF5O7sgmz4wobbTwMY3HkveToZ7nWEBQaHWpqarp17cK/uNj8pL/8/Dgc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(346002)(136003)(396003)(376002)(52116002)(53546011)(54906003)(8676002)(83380400001)(316002)(66556008)(66476007)(4326008)(66946007)(478600001)(6486002)(5660300002)(7416002)(36756003)(8936002)(31686004)(2616005)(86362001)(2906002)(186003)(16526019)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OFhjeEZqS09PaFRtUGV5NXRwU0VmUldYaFFPNWtCaXI0aGRLTGpTeVBGQUFY?=
 =?utf-8?B?NC9YVWhPSE92WEU0MDZENWV0RWdaQThBOGRCdTBhSzlXd1BOUjBnNWNLN0k2?=
 =?utf-8?B?T2ZhU1dIMmlsUXlBaVdjU2U2bmFrS01NNE9tVTFrNnN4eFVrZFN3NFVnME5k?=
 =?utf-8?B?Uno4amVNOE1vb0RlU2pCNUlxQnJTSDhkY3BqWFQybUs5VWI5WDZETXlYWlph?=
 =?utf-8?B?VU5lTGQxYlJqVk9EQUVpSEZLYndUa0FTMjFrOVF2Vmt1dWd0cU1SZlFkWGJz?=
 =?utf-8?B?Wi9GWWp0THlZblNQV3Z1S3Yvbzk3a2tveFlHZ3hUNmRJODcva1lWZllHV0c1?=
 =?utf-8?B?ZTlKbXJ5OW9Pb1VWWU0waThiTVB6V2xYVDV5djZHWFU1eFBySnptb1lBZTVy?=
 =?utf-8?B?Q28yNmhtK1lTcjBDQjQ2S2pPU3RieDNXeTlNbEpGL2tTUGRGc0xhTjVkeGhk?=
 =?utf-8?B?SHd2bTBFK2hpOWszTDlsOGxUUUthLytMZ3JpdnZwSU9OM29OR1JPZUUzUFA4?=
 =?utf-8?B?K2oyVXZpY2lYNHNBeEo0NGYvbHpHeEsydFRveVh3MGx6c2pITTQ4MCtiakxm?=
 =?utf-8?B?ZHlXQzYxcjUwNXdZSnpia1dZVzdER3cvWnFrRWVwcU0zcTE0L21LTStiWkEw?=
 =?utf-8?B?RTJ5cmJVNUpWQUFld1NnN1IxRXJEMUZsZ2dCWktCcC9DTEZGWGpHRkxob3dE?=
 =?utf-8?B?V3ljVEY1Ymp2V1NRbWFuSUlidUNGZkNQNi9ITmFGa0JIQnhWWWFRazlya3ZU?=
 =?utf-8?B?ZkFZZmNEbUJ0Tk1VUFNsaVdjNm40RlJ1Mk9kWlNWSFlYL2JJSHBZNis4aUhh?=
 =?utf-8?B?clRGY1dVRER5SzdFTHA0clJVOW0wSTZMaXp6Qncyc2c4K2JnVm1nb1F3OXQ3?=
 =?utf-8?B?YWlHLzdSUmV3dEt3ZWExNzk3YkExVFB2YTQ0N1owVGtUWm9PYkhMY2F6anpR?=
 =?utf-8?B?T0RyUDdqWjlTOWxWeUpkNWN2emVWbmhrQTdmalBtMm9ad251S09FUlhrNTRF?=
 =?utf-8?B?eWlGWG1jZENaUWl5OFRGYjIyaGd3bHoxRXA3UitvNGJJemFlZlpQOC9mQUlN?=
 =?utf-8?B?ZStoZ2VNZ3VWVW51VXBocitiSXU1Wit6S0NGZVZWMVdYSGlUd2NZSlUxRXFI?=
 =?utf-8?B?Z01Hb2ljN0lGNDllZ0lmd0tDSjlhZ3hYdVRBbzVKdHBDMXE0TjJzeWZ2L1Nw?=
 =?utf-8?B?L2JOS2lrQ0N3S21NME5rUlZZU3VoNzhidVhhRk1VK3p4RlNWUjBaeHBudHVX?=
 =?utf-8?B?MmZsUDJrVGZjdlE1SS9qRmxWWWIvM3NZK0tnUWFlUWtES1JsWGJIRUFxbVg4?=
 =?utf-8?B?UUdna2RsN2JMN29zS1lraGJzRXJFSzBxcytLWm02aVppTTMzRnkyZGd5OTlh?=
 =?utf-8?B?MmxsaEpkcUkydStLVXV5cEdUS2ZDUk5uSVFnZlRHQVU3eUlGRnFmcmpuY3Qx?=
 =?utf-8?B?b1FWallFbW9qQmRNUjV5dFhES1R6TEZabWhmald5M29uQldBcngzbW5paXlJ?=
 =?utf-8?B?cUJzUmFhYmcxdlpBcmJhTFhEWHY2QVFYay9mMUpNQXZ2UmlRU0tyVzFKRThv?=
 =?utf-8?B?OGZEb2diMEhqS0pJQ2IvVkdlTmpiWnJTeVlMYmN3d1VSeFJ5dnN6U291eGFV?=
 =?utf-8?B?WXoySVBrcVZVQXl6OTZvdnI5cDBkR3JpMFN3NFQyOFk3RVBLUCszQlZLV3lY?=
 =?utf-8?B?LzE5cENDY1dKZDBaQm15RVB4Nk1VcmhRNk4xeTlsNjBya1I4VnlWY0NFMmRs?=
 =?utf-8?B?NFQ5eVNNYkh6THNRTU1QQmRacnBkSG83a09kVHFlNUkraVlGM3NMU1U2UGtN?=
 =?utf-8?B?TjBsaUR2K1c2RHJxajZaUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d0394f2f-d9df-4825-16ab-08d8de0d3e29
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2021 06:26:13.3565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HJAGZe8sYyO6+a5LSm//DbJldH5jbIG+HmKi3EO+Y8kX9GpHNrA/55yeivs/DcAS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3933
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-02_08:2021-03-01,2021-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 adultscore=0 malwarescore=0 clxscore=1011 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103030048
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/1/21 6:37 PM, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>

Some even simple commit message here will be preferred
compared to empty commit message.

> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>   include/net/udp.h  |  2 ++
>   net/ipv4/af_inet.c |  1 +
>   net/ipv4/udp.c     | 34 ++++++++++++++++++++++++++++++++++
>   3 files changed, 37 insertions(+)
> 
> diff --git a/include/net/udp.h b/include/net/udp.h
> index 5264ba1439f9..44a94cfc63b5 100644
> --- a/include/net/udp.h
> +++ b/include/net/udp.h
> @@ -330,6 +330,8 @@ struct sock *__udp6_lib_lookup(struct net *net,
>   			       struct sk_buff *skb);
>   struct sock *udp6_lib_lookup_skb(const struct sk_buff *skb,
>   				 __be16 sport, __be16 dport);
> +int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
> +		  sk_read_actor_t recv_actor);
>   
>   /* UDP uses skb->dev_scratch to cache as much information as possible and avoid
>    * possibly multiple cache miss on dequeue()
[...]
