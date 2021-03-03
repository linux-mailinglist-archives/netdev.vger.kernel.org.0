Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2350532C49D
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447121AbhCDAPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:15:33 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26864 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234297AbhCCSxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 13:53:30 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 123IfExM021368;
        Wed, 3 Mar 2021 10:50:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=8K0vqIMsHtcjYVGJfNV64qmZ9AhzKT45gOpbZoWX0h4=;
 b=R8tlBZXa835LMptSrizaYxNa9YqbgN8JC+33DcmKa4GS52g1SntZvTEeWA/QSjcYzEa1
 glw+srXjuwVDDztTLEifwPiVjTQUTlBwsvAgBSY+FIYHx1nK5xyjS7Ltnz5sKviTD4D8
 26BWg/f75TGEhtrJzkVi6PbIrBn7cTsrz8c= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3727rejt2c-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 03 Mar 2021 10:50:45 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 3 Mar 2021 10:50:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F2HnEV0eUvKRqPeDG811ejCV7yrZGA7cCyTzv3MW5SDuggrjJHLv1j2TQxJaeUyuEzuYRZx0k508HPKYlgrZdXeB6CrfAE5nabLvyaitidwNBeaub3VcfDjq9BcS/f/b2BqQqlL/HPrGHbQf2zA6EK2ozXtFJqrR79nNfMjeDTUVqWSdm0roFOb6qZPsQHF1Vg4x0e9I3s3myTWDX+h0etWztzve6NoZTcnHirhOpWKFT8G0hInQcNwyVLic9oTpzkLTHfUB5tmXf6BbwNa6nwKbJdfC+G5HniInbHTIW36gyOoEYbJiObP5eCzK4xGOvJUlC5tSEpu1C53DN5oRuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8K0vqIMsHtcjYVGJfNV64qmZ9AhzKT45gOpbZoWX0h4=;
 b=jHGIphSxMaRv9QnzAxMmm9p3NP+h0CbYki/zkG++7QBWnJpSQFa0HDosnqzBQSrmq/Hp67FwdFee23uumVoRfH2KNf38fPsZyM00GC1hIJ8H2t9AIO/LC8VhvluNyFBdJPkk/ry+f6rsyd5TOvBxbMCRIz2B7wfdGguiwlUVCHf4mFHYk6cBSJ/JWhNL15VKL4VI1lcLSFnQ+hAUbaoEvuJEqodSogRcBOD91jbuI0m2Rc4NP+B4SQJJgwdrDkNsoIWBvK5F+zQYQspLHnYzlkowj7b36IM0yQt3ClK1YFlYkbYE2HUthLk8XUji+4v0Bz1J5EOgoTcFuxDJqEzPiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3920.namprd15.prod.outlook.com (2603:10b6:806:82::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 3 Mar
 2021 18:50:42 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.3890.030; Wed, 3 Mar 2021
 18:50:42 +0000
Subject: Re: [Patch bpf-next v2 8/9] sock_map: update sock type checks for UDP
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, <duanxiongchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
References: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
 <20210302023743.24123-9-xiyou.wangcong@gmail.com>
 <258c3229-1e60-20d9-e93f-9655ae969b6e@fb.com>
 <CAM_iQpXM+kyi=LFe0YygYuVE7kcApVGJ9f2A-D=ST2nFPusttg@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <33a6d38b-28dd-0c38-05a0-6fa09290fbea@fb.com>
Date:   Wed, 3 Mar 2021 10:50:38 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
In-Reply-To: <CAM_iQpXM+kyi=LFe0YygYuVE7kcApVGJ9f2A-D=ST2nFPusttg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:94d2]
X-ClientProxiedBy: MW4PR04CA0301.namprd04.prod.outlook.com
 (2603:10b6:303:82::6) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e1::1a32] (2620:10d:c090:400::5:94d2) by MW4PR04CA0301.namprd04.prod.outlook.com (2603:10b6:303:82::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 3 Mar 2021 18:50:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 883cc523-9e38-4ca1-f690-08d8de753f2e
X-MS-TrafficTypeDiagnostic: SA0PR15MB3920:
X-Microsoft-Antispam-PRVS: <SA0PR15MB392012775D0560D3DE6AFF87D3989@SA0PR15MB3920.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9dQzDw6syOor1GnawP7D5h//C34YrEtyYZ1LLmWMBywdkYnBiIs5b6zMtOKSxPLtK09F/m4EA2T1YUyn93JRl3eGTzKhKL9RTf3XknPBqVA2bSQVzYficvV9y9VgqCBnhW112wj7GSs+7cbGIpQo4R+t5W5a0mt/xujkt0U2P5Assl7w1yrWGTxp6j1p/I78BjYCbYxfiOkYfwOAu5VD7Ntf9O99hELsDjbAGmn1YkbvkZ4h57yeQGfezO+BD+8zHDmoEXRCEf1wOe4cJWN+rCEdnhs37DO+FNtggOhuJpQPUTcOC0d3eAVKogG1xCK7P6yZLDtzXxSQDE46KHxTeUOEiJy61z3it/c3VgxXjCYILrH/agwiotJFqAu2SNQQBz1NAWFbgVcXFLSbZjAzm0jvaBEopn3LfOLNMUGWWJmiWWZxR+65dno2XX2AD7DMV7nqn6ZzPmvjASJ6MM/n0KEMTJtBR5PUfAsjTNvKD3Ti6ftEAbCSMs24xbt1HU+Xb/ZDr/XbA6S764DEYPWYaQ5IYSHeU164y2zKJoHLWLlQ+XhPkdUM0EBtu5n8q1UqpekLRNNiaRAEoLaFvqa7saehEmZ6PQEJJ3iub/hmBtE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(136003)(376002)(39860400002)(366004)(66946007)(66476007)(5660300002)(66556008)(15650500001)(36756003)(2616005)(7416002)(83380400001)(478600001)(2906002)(186003)(6486002)(16526019)(53546011)(4326008)(31686004)(316002)(52116002)(8936002)(6666004)(8676002)(86362001)(31696002)(6916009)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bGpucGZaTGJiVGlOTW8zVkFLSHFveEZJaVVnN2xsSDlaVHVBaWw2N3A4UTRC?=
 =?utf-8?B?RXd1K0RLWEc4d1Myd0l4UmprQWloeG4wYmxpY2VZa05ydnJrSEFSd2ZwT29o?=
 =?utf-8?B?U21kL1pwS1YvYWlNNFVRdnlZOGdvSmRLY1RSQU5Yek50N1oySnZ6MFhYMnhO?=
 =?utf-8?B?NjZsVStZdWhaZDBsdjNXMFYwRUM1eEZ0WGlPNTdLZkl2Y1FZMDBBeVpRSVpY?=
 =?utf-8?B?b0dWTUlTOVdhRkVMMGdLTnJmdWJJeEtYV0Q3Zk03Wmx4Z1pITGFSOXZSanI2?=
 =?utf-8?B?TCtWUDJEalRZaWZ0YXMrVHJRdTZIOHd6bjFFMmVWVHg0dnNtVVUrUmVoSGdL?=
 =?utf-8?B?amQ2NE9EUm5uN2k2U20xV3JmYUdnSVYvYURLSVdCRERnQXhVVHJ3VGNhb253?=
 =?utf-8?B?Mk4vbjRyL1ZnOVFFTlZodlN6bXBlem1TSW9TWktnZlVJYW5hSmdrSnFxR0ZE?=
 =?utf-8?B?RXo2L2tON3l6dkVwcHEzVkhHRjQwUEJYV0dsZEdQRnJQTUl2WUcyWU8xOS9J?=
 =?utf-8?B?MjZrenFKbW5HMkpMT0FIWU0zQS91MFZ6a3BnTkZRYnFpaU9nd2E3dnBldHJM?=
 =?utf-8?B?bUJ3NzNpR3NlcFM3elpIQ21QREtwcFFjemNDNUR0ZERZOGwxemkvbTVKN0tI?=
 =?utf-8?B?Um0yY0FvR201dGl0aWM5c0JlVFhKUVRjK0U5MnFCV2Y3Rkl3NVZDZkYvUmVp?=
 =?utf-8?B?NGhHRnNPd3BWRWMyWlhZLzBxMktZMGRWVUl1OVNKR1BNdm5xTHNIdG1FOWly?=
 =?utf-8?B?Wk9NZmNvUWc4OFpIMWcyczJCaFlFQ1JKcnF0N0E2STNhbmRzREtoM25aMU5a?=
 =?utf-8?B?RnNNS21pUEZaRUdvakxQdUFoR01IOEhOLzNzTndLT2M1NmN4N0p6c1BtQk5k?=
 =?utf-8?B?RHRnRFMxR3VYMWFaY1c5THg1Z2pRbFRzK25pUjJQZE1UVXI5NUh1SjBYc25D?=
 =?utf-8?B?TXl6Wk5xaDhnallxczQzYVE1VDNKWURvTjB2UEZ5cDlTZXpNUGh1dzN4Slo2?=
 =?utf-8?B?eG5ObExoRnorRzFHWWY3ams4RjJxZFltQnVpdzhYY0tuUWFvV1FZenVRTHBK?=
 =?utf-8?B?Q3JUV1F0SHoreGNWZ2NoU2lBbEQwRUsvVUZsWEpvTlhzNmNOdmRrcUQxTHhx?=
 =?utf-8?B?aTZVUW1HNkJTMUJ3a1pUL3JkQ29lTTlydjMyZmZkZjdJSTA5WHNaOEI2YnF0?=
 =?utf-8?B?M2luM3plejRqcjdYcDRLOFBNcnR1SVNYVWEwLy9sa3BPN1ErWWZqbjhhVEw3?=
 =?utf-8?B?bmQzT0xrZXVJZDVQdVBtYmlvRERObGlGN3poUDRWbzY1RDNqODdCdlZYU3lo?=
 =?utf-8?B?eWxOQTVZOVhlZndJNTJjRm44TEhiVmMvL2Z4enlNL2hTdGJhbDBvZ0RhVjZF?=
 =?utf-8?B?S2R6bWgralVPbGVCTlFzMUtNZzNtWExiM2VhbUpOYjE1clVDWVpieXVsRFhw?=
 =?utf-8?B?Q0xTdE1zdTVmb2tXUGJXTWR5dXhkK1IwK3BkK2wxYkZmbXM3YkNZTSt6djhG?=
 =?utf-8?B?ckduai9sSVorTFR4bGo1cTU3UHhxQzNJOW1tM01wdUNYTUlKQzZBajZaK0xC?=
 =?utf-8?B?QUZ4ZForQ2htVzN5aDBmMnJhRFBWRWpRTlJNaWpVdWxndHhaN1Y5SDFSTHJL?=
 =?utf-8?B?K3hBeDdPeXpFR2Q2LzFHQmNsbm44NzUrclhRcGRqVTM3TWpiUHNxU3pMcEJi?=
 =?utf-8?B?NlZnQ2pWRWh2cENMcnhuUC9iUE54RzFmTk9uZ0FRSjM3WWdTaFRJRk8xUTBn?=
 =?utf-8?B?dkJxZFh5bWF1U0NoeklGcVNnTHNjTXBHb05hYVUzbWVSUnFQTFRuQk5UOWdx?=
 =?utf-8?B?bmxaaW16V2duelcyUWgxZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 883cc523-9e38-4ca1-f690-08d8de753f2e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2021 18:50:42.7186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3e0tndnUi2lijsfI2E8VxjpWfpQmJj7kQCrLTNJJ35UvHgV5c+0D4NV4uisoIuGx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3920
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-03_06:2021-03-03,2021-03-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 priorityscore=1501 spamscore=0 adultscore=0 clxscore=1015
 phishscore=0 lowpriorityscore=0 mlxlogscore=999 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103030130
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/3/21 10:02 AM, Cong Wang wrote:
> On Tue, Mar 2, 2021 at 10:37 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 3/1/21 6:37 PM, Cong Wang wrote:
>>> From: Cong Wang <cong.wang@bytedance.com>
>>>
>>> Now UDP supports sockmap and redirection, we can safely update
>>> the sock type checks for it accordingly.
>>>
>>> Cc: John Fastabend <john.fastabend@gmail.com>
>>> Cc: Daniel Borkmann <daniel@iogearbox.net>
>>> Cc: Jakub Sitnicki <jakub@cloudflare.com>
>>> Cc: Lorenz Bauer <lmb@cloudflare.com>
>>> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
>>> ---
>>>    net/core/sock_map.c | 5 ++++-
>>>    1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
>>> index 13d2af5bb81c..f7eee4b7b994 100644
>>> --- a/net/core/sock_map.c
>>> +++ b/net/core/sock_map.c
>>> @@ -549,7 +549,10 @@ static bool sk_is_udp(const struct sock *sk)
>>>
>>>    static bool sock_map_redirect_allowed(const struct sock *sk)
>>>    {
>>> -     return sk_is_tcp(sk) && sk->sk_state != TCP_LISTEN;
>>> +     if (sk_is_tcp(sk))
>>> +             return sk->sk_state != TCP_LISTEN;
>>> +     else
>>> +             return sk->sk_state == TCP_ESTABLISHED;
>>
>> Not a networking expert, a dump question. Here we tested
>> whether sk_is_tcp(sk) or not, if not we compare
>> sk->sk_state == TCP_ESTABLISHED, could this be
>> always false? Mostly I missed something, some comments
>> here will be good.
> 
> No, dgram sockets also use TCP_ESTABLISHED as a valid
> state. I know its name looks confusing, but it is already widely
> used in networking:
> 
> net/appletalk/ddp.c:    sk->sk_state = TCP_ESTABLISHED;
> net/appletalk/ddp.c:            if (sk->sk_state != TCP_ESTABLISHED)
> net/appletalk/ddp.c:            if (sk->sk_state != TCP_ESTABLISHED)
> net/ax25/af_ax25.c:     sk->sk_state    = TCP_ESTABLISHED;
> net/ax25/af_ax25.c:             case TCP_ESTABLISHED: /* connection
> established */
> net/ax25/af_ax25.c:     if (sk->sk_state == TCP_ESTABLISHED &&
> sk->sk_type == SOCK_SEQPACKET) {
> net/ax25/af_ax25.c:             sk->sk_state   = TCP_ESTABLISHED;
> net/ax25/af_ax25.c:     if (sk->sk_state != TCP_ESTABLISHED && (flags
> & O_NONBLOCK)) {
> net/ax25/af_ax25.c:     if (sk->sk_state != TCP_ESTABLISHED) {
> net/ax25/af_ax25.c:             if (sk->sk_state != TCP_ESTABLISHED) {
> net/ax25/af_ax25.c:             if (sk->sk_state != TCP_ESTABLISHED) {
> net/ax25/af_ax25.c:             if (sk->sk_state != TCP_ESTABLISHED) {
> net/ax25/af_ax25.c:     if (sk->sk_type == SOCK_SEQPACKET &&
> sk->sk_state != TCP_ESTABLISHED) {
> net/ax25/ax25_ds_in.c:                  ax25->sk->sk_state = TCP_ESTABLISHED;
> net/ax25/ax25_in.c:             make->sk_state = TCP_ESTABLISHED;
> net/ax25/ax25_std_in.c:                         ax25->sk->sk_state =
> TCP_ESTABLISHED;
> net/caif/caif_socket.c: CAIF_CONNECTED          = TCP_ESTABLISHED,
> net/ceph/messenger.c:   case TCP_ESTABLISHED:
> net/ceph/messenger.c:           dout("%s TCP_ESTABLISHED\n", __func__);
> net/core/datagram.c:        !(sk->sk_state == TCP_ESTABLISHED ||
> sk->sk_state == TCP_LISTEN))
> ...
> 
> Hence, I believe it is okay to use it as it is, otherwise we would need
> to comment on every use of it. ;)

That is okay. Thanks for explanation!

> 
> Thanks.
> 
