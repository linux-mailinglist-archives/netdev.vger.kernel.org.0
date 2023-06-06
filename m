Return-Path: <netdev+bounces-8429-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73A4672405C
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:02:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 159B12814F7
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:02:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BBB715AC1;
	Tue,  6 Jun 2023 11:02:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEC4468F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 11:02:14 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C93910C7
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 04:02:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9H24HDZZgnetG2Y3FL6YsM+JPH9T5Z9qt9Mpbjyka7F8fzLlcw5r2HpnldlN33grPH46s6kzr/7KO8WYWHeYSiONmor1lK61tE9K3BSfRB55jdY9fWhN5m15LLGi3D8d/c+yNet56Yc7Zb1NWBZta8Wt/nN94Jn6buTnBuUsugevv2YO3jBUdth6NcAU6iPg4CUSJLjcE+BawN94S2no8decuRPYzBIBJzPDzOxmDxK/JzexjBWKi7NCb5FZUeigd9Dfsml3WgqCQk0jZDQsOe00kF2XqQ+97tCBeXQ+rwI9AUeolvM2R2Ww+nPGFbg3dMaexA7OA+9veRqiu/+Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sZSlujsOHdzupUaBpMoETtcf3C9bbHmK0SA6hQwenwg=;
 b=Fg9DSz21ZLfOcv0gT5895a1rcTIoZNu0pj5Ff/jgh6KMxU8adZAFBftDxAk3xZWJN/W/NCfvqhBMqdJU+zf9JeeU5HN0SmuWwknpZpjcZGjx9Ki5RYbtMEBJIzvLoiJbQrzS4sN1joAo5hyoLCbDckqZo4WFZZsqXhLB0ihbsU23wmUwT/+15kllM+QXxwIqrl/bOM1aUa5KqeshGJll2G9rdHQUm0zBWaSykb3XBpAkwZ67QVeCe0PhKalbpJXwaNlxHwgP9S3kbQV596PGMWDT08jHfIpm3rNg5x9VVI1IJtDW/ak9f646J6NW1UCCElMQpjBE5DxoxZk6fnJUQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZSlujsOHdzupUaBpMoETtcf3C9bbHmK0SA6hQwenwg=;
 b=eiFWX/YDGPEJ1HJ2t0g0eCcTZveJUOK23psfmoxHqr+pdQrp9BNj+PMZ4QXiH4bsYQ5LK35KIfOhlIz2EHKgE8Wcuearlbux2DMZGRV3nDbmcbn3fP3BV9tjtB5nF2Ja6sKUdu1W5eSCVvxXCmTgOBn9dWQK/UkTNJ4WD4YCHaE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5398.namprd12.prod.outlook.com (2603:10b6:8:3f::5) by
 DM4PR12MB5817.namprd12.prod.outlook.com (2603:10b6:8:60::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.32; Tue, 6 Jun 2023 11:02:09 +0000
Received: from DM8PR12MB5398.namprd12.prod.outlook.com
 ([fe80::5d1b:c70c:78c9:6b54]) by DM8PR12MB5398.namprd12.prod.outlook.com
 ([fe80::5d1b:c70c:78c9:6b54%6]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 11:02:09 +0000
Message-ID: <5034cfb1-4cd1-a924-ee75-108b8d048ba2@amd.com>
Date: Tue, 6 Jun 2023 12:02:03 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
From: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Subject: Re: [PATCH net-next 6/6] sfc: generate encap headers for TC offload
To: edward.cree@amd.com, linux-net-drivers@amd.com, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Cc: Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
 habetsm.xilinx@gmail.com
References: <cover.1685992503.git.ecree.xilinx@gmail.com>
 <672e66e6a4cf0f54917eddbca7c27a6f0d2823bf.1685992503.git.ecree.xilinx@gmail.com>
Content-Language: en-US
In-Reply-To: <672e66e6a4cf0f54917eddbca7c27a6f0d2823bf.1685992503.git.ecree.xilinx@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P123CA0019.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::15) To DM8PR12MB5398.namprd12.prod.outlook.com
 (2603:10b6:8:3f::5)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5398:EE_|DM4PR12MB5817:EE_
X-MS-Office365-Filtering-Correlation-Id: 89c32225-9ffb-42c8-5c9b-08db667d792f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2zlrNW4ipWpb7px+bE/4GC0BXfwLu4HHd7V8Br2MetkZRcsXabBChVTWxde8ucSDCRdOhXZnb3Ke74MCy1nh/WznZ6TJaYczb+ZnO2JZDb+5xkK1rjJEJKk4hYZaMLXzVIJmG7UdZIRkIep+SGodaZ8xxhqtuhbQdvMFKQaFPnVua1PA35vD632NWGY5a3m/8lfchz2U9cxG4iyWsnsFnafuHq0d+GH/qi1y2oP6h4pmTEpiahwHiz9DMbkmJh/0HY5S2iDzl+7kwdZc+KrKghQpRZeYj3An9J2Rb+2gPMRx5sQgNVjY59G1wnbKREtkIj/nJvM+qrQ9bm6kPCJ5/oIAfKeFWu+FKTIQ1Wx3zeYiCSxPVMewP1eijf83FStfkRiaHhLY+l1RTxvmQ6kRm+PdXuU2fLzOHhRaib0lTYjbCUTIsYFxV3IezuWtf1uRqrpXZRMFaIKSGmV7YRN3RLMRMbW2PJhugBMK0xvxrmJEhjjUQKBjUVr495sedkkmQHmn+CUuG0KRZcd+DK/UeVy7Ja0bELkw0vJdv+w4EOWKvTbcKRTa+yEQJgOqUQR01MfOVeF4+Myj3KpPpCXlUDupF3zJqbPZuLtayVSIQMuilESm6lWU7FWFmHFBUYsiuI9VgQcBi5FB1uGaL+0Qyg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5398.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(366004)(39860400002)(376002)(396003)(451199021)(8676002)(8936002)(478600001)(41300700001)(6506007)(5660300002)(6666004)(316002)(6486002)(26005)(31686004)(4326008)(66556008)(66476007)(66946007)(53546011)(6512007)(2616005)(186003)(2906002)(4744005)(38100700002)(31696002)(86362001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T093NVF0S3E3RWxqM3pYdEk0SllTOTlSdTFYbmRwMFQ1QVo2YTJMSnNvV2NS?=
 =?utf-8?B?V2NqWHdidGFENVFOZmhBTXBEaHpOcUdJczNUaHZHUmlmemFlOGs5bmVkZ3Ev?=
 =?utf-8?B?UTdXMHRsSjNmZjhCeEFhNkJ2QlU0cXN0NzBBSndiQ2hQQnF2ZWlCVWpSREZU?=
 =?utf-8?B?ektpQ21FQ1BqOGl2MlR1bVlQM0hLVUhVdFpCc3dGRnNPd2dURzNQb3BsTTNu?=
 =?utf-8?B?QlNYWm94RldDakt5RVlBTWp5aU5lYUhnRVYzZUlqU1ZCb1ByZnJGL1dSbUxq?=
 =?utf-8?B?cDF5MlQ2RllzN3F2ZjlFMHRkbWVNeGJtWnYzaTdwSG1QZDFQQ2dlemh1d2hI?=
 =?utf-8?B?WU5xeCt3MUk0UVIxQjI5MGMxT1J4QmZNRlRMd1prSjh5eWxOVUU1cXUvUU9u?=
 =?utf-8?B?bjZWZkRMSzRpYm1vUHpNUzMyMnY4TTViVlJYMXlILzJJcC9EVWVwSjA4NnNE?=
 =?utf-8?B?OVY4c1BZWU14UEdYNERZNnE3U0ZndHN2N2IvSnlJLzZvT0krL3c5SXZ2ekFt?=
 =?utf-8?B?L2Z1TUVtbGNwelJ5OG1JSDdPTlJuaW81QUQzOVRwN3FpR1ZTRjltZ0YyckZB?=
 =?utf-8?B?bW9kZUtmTjNSSktZbUxWVU91Uk9XeURydkRFRjAySmVRTGxwMk9DWG8xbS9E?=
 =?utf-8?B?d01YdmlXWTJaZHJLdk1tQmhiVEZrdmRPN1N0QW9McnBvVGN4dnNhYnhWUnNh?=
 =?utf-8?B?ZVhQUE9QSzlWN0ZwVnBHOFlqem5zS1g2R29TL0pBc3NCaHZGd1pWQXdWeGdN?=
 =?utf-8?B?U05OSm9JbDlNa2VXUEFYTmsyZHNoZGNEbmpPYkhVL3p4czhaREhWdk1VUnFK?=
 =?utf-8?B?ZkdOUVBWbkRhTlVUU20vVlFGNGtjUFgzMlV6Qi80SU1SSW0vSUxRbitrcnpt?=
 =?utf-8?B?TlJ4eGNRdmpOQ1BMU2thMkVDY2ZzWnFRYmVRNHRYQ0hENG1YRXN5aHFPSHV1?=
 =?utf-8?B?ZzhRQm1LTnpPTzJBeDJabEM2YXZlL2NkZEdkNVBYSEM4WXB0eisrcTNRRWJm?=
 =?utf-8?B?V09kajEwUUE3THc1RjZTbDBSYzdBd1JjYzB2NHc3MkdaNk9HTjJCTE9JbVFH?=
 =?utf-8?B?cTBjd1FrY0ZueGFxeUZxd1FiTndmd291TjNveFE0cUM2VVYzSjB2V0lMSThI?=
 =?utf-8?B?aThJeE8zaWlSbFFZa3Z3YzFzMUpJV3hscE5kYUtod3VUOXZ2Q095dDlOVlBw?=
 =?utf-8?B?WURDNmdLS2dVNmpzaCs3eFg0azRBK3IxRW5SbitmcHkwQWJyWkl2OWpudEdv?=
 =?utf-8?B?ZzhDbU85MG9mejBTRUxLYXdyRnhxbGgwU082eU9OVHFSTHRYNEtjR3pGSEg3?=
 =?utf-8?B?amhKQnNhNkVaelpXdCttUnJJNVpSL1BtamRyK3RzMjV1UGlYdEtyU1RQb0pX?=
 =?utf-8?B?QlNFbDVCQ3RSSmdGdFY5S0ZDWVhLbE5FU2Rtd0lhdXp0VTNBZG45dTdTR1JE?=
 =?utf-8?B?UGFKSkZOTWdseC9nQVRaV2ppWGhJcVIzNUFHQmJta09hMXRBV1p2NWd0bkhz?=
 =?utf-8?B?ZE9zaWpmZVRCcW9ib0J5UEI1TkNQN2IvK2NxbU9LM1MrSDkwYzFQU3A3QmR1?=
 =?utf-8?B?QndtaVVSTjRaRE1rUWlwQ1k4WHFEaCtuU1pmcXdmZnltaWdzVk56WUJBeG1s?=
 =?utf-8?B?R2tUZmxVVjljWm5ORm5KT2UrWm1rdUpOcUszVFdXTWdKNmtNMitELzhxRFJO?=
 =?utf-8?B?K2ltdllYWnZoL05GSlFRRWxOWkxlOUpUT3ZsVzNDVlhSMmNhZjdsaVpaZEMw?=
 =?utf-8?B?V0pBSG5LQ3E1ZXBtTGpvZ3V3ZEdhRy9hU1FWUitkVngzdktVOGpRbytjSE52?=
 =?utf-8?B?djJxekIzSHdZS3FnR2hMREtGRURHNlBybFVYMkM5L2JNcmdNU2hiMnA3R2d0?=
 =?utf-8?B?bXJCZVNXdjd4L2E4c25IRUFpMXNSbnl3MGoxc3krL0FVZFg0Z0cwZElTV0sr?=
 =?utf-8?B?L2ZHVG4zSG0xZVdMU0pKaXdpUkVjZzhsbDFoZi9jMEt1dWdLUVlRb1lmZzNy?=
 =?utf-8?B?TlhkMHNFTVdTbEdVWUY1REVBb0tkM3lCVTVNVkt3bk56RTMrZEt1bGl0UEZG?=
 =?utf-8?B?Z0lZV29XdlhpeTkzM0hSckVyY1NqV0hRbmtaTW9KTnBvWWlidEhCTHF1WkM5?=
 =?utf-8?Q?s2dLaUN10gmTc5lD3Vc1RQoHm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89c32225-9ffb-42c8-5c9b-08db667d792f
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5398.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 11:02:09.4526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U9v0Q0ZEvYPz26JvDkhcg0w1uCWQecJ+0I120+7VHwguMnHhPbT4VftmO9/1b8I5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5817
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 05/06/2023 20:17, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Support constructing VxLAN and GENEVE headers, on either IPv4 or IPv6,
>  using the neighbouring information obtained in encap->neigh to
>  populate the Ethernet header.
> Note that the ef100 hardware does not insert UDP checksums when
>  performing encap, so for IPv6 the remote endpoint will need to be
>  configured with udp6zerocsumrx or equivalent.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>

