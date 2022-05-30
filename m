Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49EAE537A2E
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 13:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbiE3Lw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 07:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbiE3Lwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 07:52:51 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7563E27CCA
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 04:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1653911568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GNB21eekDD1mf7Q768nH++K7AKu3rAPFrlwXkWKPKeE=;
        b=lqNh9Yj8itgvF0q0PVAHH8TRESA6b47OJWGiDRvk/1MbTXjAFx5poJAc6Zw9kVGnh5p5mR
        FM0K1b+5xMYd6GKFr6TU0Sn+hbJ0f7rrXtKoalH4Cl9NmWwYgMDziG/FbzYcsJLPE4mwOq
        M94X2PAhwUglBxNJuBTtH9pcHk8iOfc=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2054.outbound.protection.outlook.com [104.47.6.54]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-17-S-6fYyGaOkayE2rJSvyFRA-1; Mon, 30 May 2022 13:52:46 +0200
X-MC-Unique: S-6fYyGaOkayE2rJSvyFRA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nse/O5XSfiU1Z3hkzTQjARRH+W1J+dUobt5k0GnGcyqugBUvxASVA5PnmWgHSD6DkPUigIuYG+1e06Gc5Cr6amUIwYX6UFt/RYtb0bUiPBBTzOUdXLsPzEwlQtSZakqixpbYtTgd2gFekjmD83mirF6wvkFFf+SV60Q+s32ZqqvEDCuj9t0z1//v8Bz8GWXCucgLJN5eUbOpRjIf0PYHFAa+iSjE8KuC1MBOfIYryaZJxvYf1YttC7yz8Hbyu+iFTZnqkPFl7JgtNZAHcBxlrT9LQra2LgOyOpLeqZAfs05EiIyrY+ihzt9+1L9P8pBNL+7/eaekhvwG1uEnlxpKaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GNB21eekDD1mf7Q768nH++K7AKu3rAPFrlwXkWKPKeE=;
 b=gUJp5+4EgCHGfmBfwDKO40lEVP+GEeYroMSXk3UyJKyTsAJj3e9FWDQsciVnmWBq+ko+IByanyvWOgCN375z1yPcgx/RXDrUkuqNo/L7oZvOM5drePj2xnuAMKkv2/Ra5OlNs03HPzwn9/IyI6K1CtCQfPn1IU7HP0vrobocKCHEpmURRBAOg2TPzg/zgVaMw42sZ66dvg2H+o1r4rPji9QiauCMTpZuyl4FIWo3/fg6HHmnN6NkX2qv278Bu0YrO1NAFoIiW/Yu2lhO3vKWBrFQezNY1eFKVsUYsJWf4lE4IsDKm0I7XIqpuXchCAswXtXzQluRAEkQKH6DXj6Vdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by AM6PR04MB4182.eurprd04.prod.outlook.com (2603:10a6:209:44::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.19; Mon, 30 May
 2022 11:52:44 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::dfa:a64a:432f:e26b]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::dfa:a64a:432f:e26b%7]) with mapi id 15.20.5293.019; Mon, 30 May 2022
 11:52:44 +0000
Message-ID: <53109b1c-982d-a306-515e-44ea7de2774c@suse.com>
Date:   Mon, 30 May 2022 13:52:41 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] xen/netback: fix incorrect usage of
 RING_HAS_UNCONSUMED_REQUESTS()
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>
Cc:     Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220530113459.20124-1-jgross@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <20220530113459.20124-1-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P195CA0039.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:87::16) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c72ea9c-6fc4-4b6c-0288-08da4232e863
X-MS-TrafficTypeDiagnostic: AM6PR04MB4182:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <AM6PR04MB4182CDD8E924B38F5C2F0BDAB3DD9@AM6PR04MB4182.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VPLqoj1JLqA19WgmfB5Tm6528uUKvaU/0SrvfOL5ImU+v50W+hyoFhqbRHVjNv/F337Z68DsW3CzNRO/z+F3eqrUVctN65s7W42HfPq3BwUjIT/WG0amiLTRAOQk+94mG3Hqnur3F1wxVmqzqYCeKwyenigndBo2xn4+TY3g3kY7jsNQnEQHpQfVsIi9rKbrM19REPKKxLYeSnFib4Nl7e2RXmbERYOpZAZSWkx91E1najTbHf+lUOwVCmUi0V1OWYGPRzANTOYeRiCXHmenMhGteXu/PKxNYJQhDiydePUdNeUclXGqGwb/TQT5Z8M9N7DaF8Oc2CBpUJjP6NcGI4nC4HCOMcBqSeCFKXRtsaO4RheGyj7/WcITpT6HIFTp8ilDbHR5l1YXJg8z6axl0Dt5MtBnuNWLMUBSTrUxn6hLl+rFXgHXHw2jVIuFMEn0yF1YZ7JysRE7ud1nPKy8MWyDozw5fqf7cDNQbL4ttt/bQtKtc7eSUQHHtLTue8adIOQakN26y8laHo9d2ULQB3+92lE2l08mJM9U3utke9xHHoyFWJVgwgbxQ3KFa52zLZJdAAngVhEoFzqadaymMqabWSKvYwBf9NrpXG4mhJqMQ5rl0CBzZ+FzdK838IUb6x6NxudqaBViYLM+0wi844whxXneOMoRVzXFI7jOU1qji3ZXGOniKbYsXL9C6nHr5KA5y2KMmDYNuQ0pLl9wWz5qqZSP8ij3VcaeqnfGI6eX1vIrPvk/bjJW+CaEWNId
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(5660300002)(4326008)(6862004)(8676002)(66476007)(66556008)(508600001)(186003)(83380400001)(6486002)(8936002)(31696002)(86362001)(26005)(6512007)(38100700002)(4744005)(2616005)(53546011)(6506007)(54906003)(2906002)(37006003)(6636002)(6666004)(36756003)(31686004)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SjVjZ1lacU1ZcExsUjZNMGhuSkViSTVMQVBGMjlHOU96emYrcWtZVDJ5VkpN?=
 =?utf-8?B?cStldkxvbWZMMVR3amtjVEx5WnpVTkxKeXl1L1VCdjJneXhUSWRkakdPbHQy?=
 =?utf-8?B?a3JWQ09FeE9lYWdrV3JIR29pak5BNTBMdnhMYWdxYWRoMVZFWW90Z2gzVFN6?=
 =?utf-8?B?ei9tcVMrVURhZEE0MFkvYXZEVjA5QUdzdXJZOGZxMTNpUnJhdjRWTzR2Z0Y1?=
 =?utf-8?B?ZG1qajQ4dnU0OTFtOXB5UjljRG1wWUlJVEh1MDdvWHRFSXpUVTlEb29BSlRT?=
 =?utf-8?B?cndrcExTUjdDUzhHNC9tOUl1R3EvVW1aZGpJRnIwMHVEQzFRT3ZSSnpNU0hl?=
 =?utf-8?B?blFiSHRpSUw3eEtreWhablJMakQ2VXl1bHczM1VpMnE0bjNzVnpVbW5oODU4?=
 =?utf-8?B?N1grSjk5UGhEMTBXN0RDdXNkQUNDeVF6ZUlZN2w4NmtpMjBXUEpmZUNKTHoy?=
 =?utf-8?B?TlM0VWtuNzJqRWNVRFVFcDdUYkY3K3Vyd29QbUJFUm96N2lpQVFJdWdDSXZW?=
 =?utf-8?B?eTkyTUk4T3UwK3VFUzJFTFcvc3lVRDRDNzFZRlhOYmZDYnpQQm5ZWS83L00v?=
 =?utf-8?B?SC8vb0s3K2ZPOUpldDMzV0F4Wk1lNXkvdlZFdmpmcWpOL1VMRWljN2c5dFRn?=
 =?utf-8?B?aFF1WlcxZ2dybEx1WGlWeUZtT2NXZnAwLzRwOHIyOGY3SWNZYThOQlcrVUp1?=
 =?utf-8?B?V1RNTjRocDRyRHFvdDltMFVUQ0wzTm5qR3AwQVpxa01ESXQvTi9ianN4SXFM?=
 =?utf-8?B?UUZzV2FCVDV5VHVQdEMwcjJ3bVRmSWJiUmFHRjlyUW1oY3l3Ukh4Wi9EaWl2?=
 =?utf-8?B?OHdXT0NLNWM0U3pPWjFLMUJKanhHczgvZVY5eFRWVHpkZk8wSnprWkgzaWk0?=
 =?utf-8?B?SmF3a1BEZEh6NTgzSjJYY1dZUkZMWldzajVoc05JdWdMUm9VRU40TXhxZ0VP?=
 =?utf-8?B?dEJOYmcrUTc5b2Y2TGxTZEt6aUsvdmRKalZmS0c1d2pPNit5amRGL1d3alFi?=
 =?utf-8?B?d055SUNGb2kvMWI2bUdueDZzVnlyYTY3a1FpWi9CTzJwRm5LZjJUdlJMRlVr?=
 =?utf-8?B?L1dqNHBub2pXYkM3dFZjUVFPejBtRTdwN1Rrc1dnREVEVEVwN2QxaU5YU1kz?=
 =?utf-8?B?YnA0WVl5V2R4T21qZzhuN0oxeGhTaEFwUzhkMHlpTDFML1J2UndWcVFyOE8x?=
 =?utf-8?B?V2NhMEhuWm1XUjMrZzExS2h2c2ZCcnM3MlpqK2FEOWFBd0NzU2xBTDdYOWdI?=
 =?utf-8?B?a21tNi85MTdMbXRkRlM3dEw3bjM4MjE1bUM5RkJzcVRxZVJ3UDc1aGdFMWxJ?=
 =?utf-8?B?SEVMbnhjYm5HTHFUcEhDSzN2L1RtQkx5bjBmelNZTVVVTys0UFZ2RzhRQ0Qr?=
 =?utf-8?B?KzB3ZGNyeHZxcm8vdjFYREI1a2hqZSt4MjJoZ3F0Z1ZTTWtnbVJJaGJveFIr?=
 =?utf-8?B?UC8wTkZhblhIZkduS3VNd1pmSU5qbWVDOTNYMm9vVHNYNTdyTENjbXd0cjkv?=
 =?utf-8?B?dWJkUUVzcW42NXpRcEJENzVNTzEvWWNidmFwUWxZbWZZUnl1OS9OZE0vcDR4?=
 =?utf-8?B?YndDbFd5cUdPdFVLYmtrVUVLeG1MVVNaRG1ZQUNnS2VjT2dOS3dQQW9WaWZa?=
 =?utf-8?B?ZEN3ajR2RmkxMld0ODBXU0kyTjV5Y3NHM01aZkZDNDBCT3A0c3M1WFhkb2lL?=
 =?utf-8?B?enBIMVkvcXd5MGVVUUxRRzNZL3FWVkpDQktNUmdKdEtSYWFtdWpDZzhYSkFL?=
 =?utf-8?B?aFFKVU1LUFZ6ZnJWY3lLLzl4TnZTYllZK0w1RmFqd2RhSW8xQU9NSWdSRU5u?=
 =?utf-8?B?emVXcmUxYVpHbXN2bFBqNXcrRFdZYWVxandjeDF6OHZJc1NiYU9Nek9BQ3Z5?=
 =?utf-8?B?QUtDaEg4SXVVRHB3anVxV2pmb3FCWVB6NW5nU1lKSmViZHBIRkRlVEwxc3BC?=
 =?utf-8?B?YnRUZzEwQ1F3TWFqaWc2MGFPZmJLdituY09CeWhtYU9OUWZSbEFkRFdyeStV?=
 =?utf-8?B?bnIwb0ZvejFHT3RvTTIrcXAwdzdQZi9aQi9QZ2hXNHE4K3BqRG91a2p1TjBN?=
 =?utf-8?B?R0duaDhEUkNMd2xmR0hUSzdic2lTUnVXTkl6bEFqUGR4dG9MTzNNazVpeGZr?=
 =?utf-8?B?YmRTVzFIRFZvbHFzNmNjbWJmRCs1OVF6UVg2eXU2T05WSWN0RS9jY0JOQjFP?=
 =?utf-8?B?ZmRDbkxUWG5JemY5UmhFMi9yY284c1NIUDAycENlY0xyQncveG1qSDY4NnZP?=
 =?utf-8?B?TGx4R1hFRzJialFIQWFPY0g4bEszbTlaT3JSRkJ6WGhiYnh4cEV3WTJYeHh1?=
 =?utf-8?B?RWpFWWxJbFNkNVZOQjNTbHI3Um9WSlFNWUFVYmFDeVJ0ZTBrZnY0dz09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c72ea9c-6fc4-4b6c-0288-08da4232e863
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2022 11:52:44.2353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EAWoHDN/KEWMx6dAcnFd5Z+ogDqdE3mAhiwBBAc8cBPRYsRpQ8xjG949TI81tGcZoJZkhC+630Wm5pNM/1OpJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4182
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.05.2022 13:34, Juergen Gross wrote:
> Commit 6fac592cca60 ("xen: update ring.h") missed to fix one use case
> of RING_HAS_UNCONSUMED_REQUESTS().
> 
> Reported-by: Jan Beulich <jbeulich@suse.com>
> Fixes: 6fac592cca60 ("xen: update ring.h")
> Signed-off-by: Juergen Gross <jgross@suse.com>

Reviewed-by: Jan Beulich <jbeulich@suse.com>

