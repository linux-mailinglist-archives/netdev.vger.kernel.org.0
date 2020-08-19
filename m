Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A7E24A64E
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 20:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgHSSv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 14:51:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38654 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726211AbgHSSvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 14:51:23 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07JIdtJR018015;
        Wed, 19 Aug 2020 11:51:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Z/m5e6zUxv7FtlH5Rp9OEp26xDFzP/SZeI6TX1e9qSA=;
 b=HTQlu+YWksM5hDzXIHl1/z/31b/MGMubHzpfBetfTnSeFgUMsAPnUQgihO8tDRZrDrge
 Yb7u1W2q+lJMJC76FkRXHI4RsUTvAUYfCVdGIkwB/M0YO+t41v2NINiySjXui5nsC3a+
 yW7iXqbcg36XYOGIQuTli39ZxZlIfCq2VDc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3318g0gd40-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 Aug 2020 11:51:05 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 19 Aug 2020 11:50:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tv9sRA2Fl3XSwItJ+C/HA+uE4IxvwLeQ/U7zNEPtiozcXBSt0iFAD8/OGsnMVonHnTxYQvucqz8V9f/gG+QOwTtaz9GuS2DH4esPg/J13Yd9ezNY8v/e4I/KMPQDU63i4JQmDpiHKaQZN7rEB3I8noEsFZiHG8H/p7ETYY1Skzq2jLK/oURxhuWJNXwmexkUvF9ohEhQHdboM/rlEzm35SKCyQnnLgMQjnDuineGq5NMP0eaPSAn3abyS05QcKMWgakm0wgT9+GxZw6kOlpptPWfUhSMpQy5HJuu3IkNZC+Ku1LMIDCceILJiOIbfqTZd2el3jDtU/pWjsMGRr2QmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/m5e6zUxv7FtlH5Rp9OEp26xDFzP/SZeI6TX1e9qSA=;
 b=nKIMwmbCH6B31Wr3shEDqExCt4eQaoOqZE1UfxLwbnZ7EOelekVqw+gJ8J6S3mQzHpz7EJQvyvHDcuJmJ8wBDuJdCLTWHNIfCZO3prIigJrKjYxSqFAlrBqMFvuOP2AATj3BJ5Kt5ZT2Z47PBcy0eWBEMB6uHOF0dmGAN4F3OCNMm3FAcJid4pKPE9Qw5fGzpSQ/SZxUt6ZgE/Ybk0+L7AT5oLmj7odjT1IPWL5zc9UMfnmCz/5yoUxmGgVcvF+lGz7Lxer+3VWD5ijpTw+Ly1yeNNqd3FCuouzi7/DocQIZFb8AAt4OWeZP2HX1lTDhmS1DVyOV9EwJSBDjx1h+BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/m5e6zUxv7FtlH5Rp9OEp26xDFzP/SZeI6TX1e9qSA=;
 b=fDqXS/XihhPNr139vSOsVNljf5MEQdYtA7w3DSD87fEml745yMzM6IQMKEwTpOqkZoIWtWKXDE4gmC6z4o0KFW7KgYTapgjOlifMdbvOh0xYjMJwFeTrnuzHZxByCdN04O9ls+woGUAlUARuQKQKMnAidTSDz7QJGjcOTXpxKSc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2407.namprd15.prod.outlook.com (2603:10b6:a02:8d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Wed, 19 Aug
 2020 18:50:45 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 18:50:45 +0000
Subject: Re: [PATCH bpf-next 2/6] bpf: sockmap: merge sockmap and sockhash
 update functions
To:     Lorenz Bauer <lmb@cloudflare.com>, <jakub@cloudflare.com>,
        <john.fastabend@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
CC:     <kernel-team@cloudflare.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200819092436.58232-1-lmb@cloudflare.com>
 <20200819092436.58232-3-lmb@cloudflare.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <597f4cbd-a0ca-87ae-09a7-534f6fac2d45@fb.com>
Date:   Wed, 19 Aug 2020 11:50:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200819092436.58232-3-lmb@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0113.namprd02.prod.outlook.com
 (2603:10b6:208:35::18) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11e8::10d3] (2620:10d:c091:480::1:d29f) by BL0PR02CA0113.namprd02.prod.outlook.com (2603:10b6:208:35::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Wed, 19 Aug 2020 18:50:43 +0000
X-Originating-IP: [2620:10d:c091:480::1:d29f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac43ff62-c919-4d15-9954-08d84470c7f2
X-MS-TrafficTypeDiagnostic: BYAPR15MB2407:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2407F2E21100DF668117E9FFD35D0@BYAPR15MB2407.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:287;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b3JxDanoviuboHCZEu7PjYWoz52BOGcBOdEuvFSZMEispVYp29NB9Ci8yqWE6ghCcMFgKHn+MAMfwTrDdy/oDTMgVkGJzPkcBHhw6vYJduBkKG7Yp19t4vo6yh+qAiIbFQYH0n78ledWcHbWIUEjNiXlxo+zFXVupTaK8L9CAwnf3L0Gsea2RkMChx5Go+nDhf2ER2g4CXTN6p5KuIpHIJf00PbQwzL9Vqxx7/2hETagQr8JLtmqZDAcyYpiWnUwWEH1F2j+2bnQ1wfp2of1qVL3inX3zwwMiq0pCRTZICtW0S1KtkVH39r+dhOpmK7COg6DNpbAHBz/Sn5iS0k9l4CsbHxXe1MuQ3Kmhjei2/CrloHopq3cUcVTE5TjE1qo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(136003)(39860400002)(396003)(31696002)(83380400001)(66946007)(7416002)(2906002)(478600001)(6486002)(31686004)(558084003)(8676002)(316002)(2616005)(110136005)(36756003)(186003)(66556008)(52116002)(53546011)(4326008)(66476007)(8936002)(86362001)(16526019)(5660300002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 2PRkQ3Ec6b/CmmPV2pTR/JvVj8EMPs0koGwavaBuaaqd78+br2SIBh7ldkHKWQ5ma2DX8UZ4DSZG1W/u8uFCORvv/23dREz6ehhmdozPvb9alX/PkaIHftqH/avN6hIy+Gy+A6AO0cWtblVMIBpI7Vk9Xez3p4lm9uQRM1kPOJ84ZADEXT5eXUaxhssvrMJXgmJ1hDg/EabV3HuLImnp3AFglUxenAeArSXqwqhH8lFwgoBd1D8HPqJWh/q6AaCFsCCzLLUMzksyiLEVq36B/rOizo0UREMqMr7Jx9Re4H27FtMEnrk6lxPvKfoo9gG5nglQzihazcknAiiJegY7KARKmGiuA+9WWCHhxPVJAU594jDaXWUzHTRd0nF4Ar/vV8zIwiw4xjlZot0lgkCRP19O53Z6o/gnN3XIEm8XU+5iXuiqwWYRYyUs37bqh4k0Y6cVyKLIGW1k83p93WDg0VRZa5haIeU3PHKtlkRZQitGxQc4y8B7w8iqt3xXSQKX873hqoWFWyfaioE2oB/+doZA5dBB3Cz1pq3StV8izvpJMfkkPzRfTlpj7Ym5VaHFeItBiUKRYwB2XRsSyTtFeEi6MMuHkNqH4JkrD2SvUVBKJexgNMu96kRojLbmgR117DJQO8/uYj1rLJqDwKEoQfLpuc6efOd534Xy6sBqnWcz/FtG1BpR3EQ1dNeLPcyD
X-MS-Exchange-CrossTenant-Network-Message-Id: ac43ff62-c919-4d15-9954-08d84470c7f2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 18:50:45.6744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b7zSIL39jzbo///dvg7vsfHfv749S0K7n5rDgeHHY+Bei6KYH5tPP5vTNPBeMjh6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2407
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_11:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 clxscore=1011 bulkscore=0 priorityscore=1501
 mlxlogscore=881 suspectscore=0 mlxscore=0 adultscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190151
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/20 2:24 AM, Lorenz Bauer wrote:
> Merge the two very similar functions sock_map_update_elem and
> sock_hash_update_elem into one.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>

Acked-by: Yonghong Song <yhs@fb.com>
