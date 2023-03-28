Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1726CB8AD
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 09:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbjC1Huv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 03:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232439AbjC1Hut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 03:50:49 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2044.outbound.protection.outlook.com [40.107.20.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698BA40D7;
        Tue, 28 Mar 2023 00:50:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BfeFYeRvZWNmxHQxrNCgh8W5M1Xo2TpncEYZR4gomCBCms0E1WUc9BxQ7Yt1jUfIZs56mX28pZ7/Gd4UKOeAPBglbr9FpqdUK6/m1v2+piJsickhI3/JYo7RYK00f4qi52+Anv6c4mTRXuaMCjSD1lqDBB5kNzwoPfMhYSgPKNssfQ7yi8RyH5MY+eKFjavqBt0d04bmoxarOIPbp3HOOYyGvtfR/dP4YO5Hpmxb099gUalBOGUnD0ECGTk80LbbspOepfRtTlHWRNEnqDY6IbKazSR0XOk5+PCSsIyxPYSGpxipFC4ZZkiIRVK6TG8djZc7EZagnvW31ssyKQQNYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kn8Isedu5ZHAI5xEhdAg+vLqa0pzkRpjr6Vq35BBG2s=;
 b=gIL+RdbP/5FM18k8b6j64ytgJuNpdBqdNHbEn4u9jx7Mx7jjoX7I6mQrQeB8PwMaensf+q5ZgWBrKd3cw4qBJfPFdwwUIAXr4rnAL3K8MhRBT5flebtt53FeJtBYS0b2XJANbnPbwi83jHAF/medVBwii0+Fno1LvwZ0vLD8YvGABOd4ZughRH9MRYf4bBoie5H/3tASIkqKsnIycbFJaO0Z59wssW/9esT7iq9pK4VwnMHs/RZ1GYjl2JD9jknFByY9KEC7d+Xdo8yyJWqch+kvdQRR9PpWZ9p+HtpBL6XHiJkoVq6PoDTKWQvstgJARxhDrfsz8wKk/++YiR8Aig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kn8Isedu5ZHAI5xEhdAg+vLqa0pzkRpjr6Vq35BBG2s=;
 b=EJvshNUCpGiOvCm0PdswCgAp7p+IPS8k9IUme3Tk5FyRppw2tcvSYdn2bWxVHrlXI/UxahEkGPHQVkpjTnsvLVye8oQnSwVfiBFLHWtZZFTi6xelNQnQ0eaCHeqigic8EHYgeKrSts6zgg+T/rNpVAWPVdFG4y+wki3T3e5eWHpQ34/fivx6qihsNlEqUH9x68tZ6BQGbjB+yFUys9grpy3VbtQWC25tqVVHTu1Gk7jMLPHk7ugnjrEYj6Oe63vtXUCuUAg+7SjxqcjcNIfyxHBQESacHqrQx8tw+Y4tKB1BURGKQgxUlqNZmiIdQLVQ5TOookDV9jM6THuyajseog==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM6PR04MB6551.eurprd04.prod.outlook.com (2603:10a6:20b:fa::20)
 by AS5PR04MB9828.eurprd04.prod.outlook.com (2603:10a6:20b:678::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Tue, 28 Mar
 2023 07:50:18 +0000
Received: from AM6PR04MB6551.eurprd04.prod.outlook.com
 ([fe80::4189:2d2a:eb83:5965]) by AM6PR04MB6551.eurprd04.prod.outlook.com
 ([fe80::4189:2d2a:eb83:5965%3]) with mapi id 15.20.6222.030; Tue, 28 Mar 2023
 07:50:18 +0000
Message-ID: <4992e7c4-e424-1fce-b508-ff9eaf2fbf2a@suse.com>
Date:   Tue, 28 Mar 2023 09:50:16 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 1/2] xen/netback: don't do grant copy across page boundary
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>
Cc:     Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20230327083646.18690-1-jgross@suse.com>
 <20230327083646.18690-2-jgross@suse.com>
 <59d90811-bc68-83cd-b7e5-7a8c2e2370d9@suse.com>
 <f519a2d3-6662-35a2-b295-1825924affa8@suse.com>
 <89653286-f05e-1fc1-b6bf-265b7ecaad0d@suse.com>
 <f94dbfe9-f690-8c3e-c251-b0d5f93d32f9@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <f94dbfe9-f690-8c3e-c251-b0d5f93d32f9@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0112.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a3::15) To AM6PR04MB6551.eurprd04.prod.outlook.com
 (2603:10a6:20b:fa::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM6PR04MB6551:EE_|AS5PR04MB9828:EE_
X-MS-Office365-Filtering-Correlation-Id: a363389b-e55e-470d-35bf-08db2f61132b
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b9PdpVQ+5GXmMa9DdQS5zhz6SHOvx0a963w+9MWz1mlhq47rZVtM0Qtm6h8LEEnoZekC3PBNKgyyYMbiiYdzar1Wz8+2uxqf7YGglwumBkx2DIt8gaRpg03o2u7OZoPMvkPzdM1iOhDdmYOjfYPjWxIrrD2hFaCqAW8IWbP6qefU2eGSMhgNBHWz94JHdohV8mxMP8GUjTDAD43+dLxJsPA9nPPJJuyhvRMtdLpcmFmczU42cchewCQEpdke2L12qoNxdgRfm00mk5JlP+vIvJakimEPsk35+4dX9MY4bmh5n4oPIAnLdNdw2dQ+phlAoWZidaNFmwIbXsv2mAU1/vO3Pzn/QDvmdHgEhtFoPYwL6w4smfcnXcFQxTcBYZ3Z8b/josxWcrOqnJztTR38FSRrIWb+HLCfIve+vevfBfRyqDGeWRP1HwOPRyipOBZCiWSiXPGXAeCMNFrY51wGT0EwW8vH0Qsm3/QGjjOCWytQoBVEWCblteUjMp/GF49X/zMAZ5zu+sKGtyNtNDkFP0k2vW/iJlJnw8KnPhwd30L2yE8Fuky9vQCPHaIDrdvmmJhCvAXz0gY65MwAb3UXSYl5I4ajlAZIunc8J6iAnth1BXukcEgkiYCFjHIjhyC0eCDGqApoJ3LvLP7ql2dauQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB6551.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(39860400002)(396003)(366004)(136003)(451199021)(86362001)(31686004)(2616005)(83380400001)(31696002)(53546011)(2906002)(54906003)(186003)(7416002)(38100700002)(6512007)(6506007)(26005)(5660300002)(8936002)(6862004)(41300700001)(36756003)(4326008)(8676002)(66556008)(66946007)(66476007)(6486002)(37006003)(316002)(6636002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?emZlTTk0N284RVhhek93UnZwbVRDVTRRVy80SHVDeGFiYkJoeWg2Q0NtYnB4?=
 =?utf-8?B?KzdBeGcvZjJ1N3FVMUFNVm5SdnN2L1RMK29LTklvQi9VZ1pjN0pha0dpWThz?=
 =?utf-8?B?MVRpNWZwZnBlWG91RHNhRFhRZi9IMS9taExra1U4VUlXMm4rUmhFaEpxY3Vl?=
 =?utf-8?B?cGxqeXRUNHdiTUljMytKZ3FkSGZ6eXAxMHhES3JLa2hlNUJ2THNkUlFhSHN1?=
 =?utf-8?B?WithNUhmcFo1QXNDckg4eEc0ZXd1cXRUUE5xdm84VS90OTUxYWVmckJjTTdH?=
 =?utf-8?B?aFQ3SHlWRCsrVWVUTFVaa1lJWjNrR2p6VENBNTlTYmQyMVRsYW5QNFVzWDNm?=
 =?utf-8?B?Qmg2aU5wQVBCL3lkODE2dGRacFhsNWw4TXhOWk5TYUZlUUJuNklYbUFJRFRK?=
 =?utf-8?B?Wmc0Z0MvNFcwSTVlV2xNRDFZa0tiVTA5a0hkdkRkZi9oUWg1ZnJ5NXZDdm1I?=
 =?utf-8?B?NHVkWnl1WVM0WTNORVFJUTlYZzc5alRpWkdnWFEwOWlBZzY5V0RtMWIvZHhi?=
 =?utf-8?B?T0dLTFNMUnRNTUdZUFkyTHJhWEs3SzVDayttcHJSNlM1aG9lVGN0TXZuREpE?=
 =?utf-8?B?L2hzeUpYS3pyckxpc0ZCK0k4R2diWjBQK3hZYmJ1c0REVTMweEQyUU5vWlNk?=
 =?utf-8?B?dTgrditoUUVNMjg0T2JQNGJSbU5SS24ydlh2eWhHbm5xNVlpNEdvV3IyTGll?=
 =?utf-8?B?ZmNVbU9nbm1XM0I3TTh6SFV2SmN3Qi9iWWl4K2Q1eGlwdDg2UHFSWHhEeDEv?=
 =?utf-8?B?cy9HQ21vQzFZc25hYkRFcFdldmZvNFVnTHI2VG14QlBWSWwwVk9ZcGJCcnFj?=
 =?utf-8?B?NFN5anJuK0pYTDREVEdMcFVHcjlzaTlEZ3I1TjROcUl3bDNkUDVRT3d0MjBL?=
 =?utf-8?B?NDlQTzZ3OVdGWlRWcXJtWVBGWHdJdXpqZWhvUVpNM0NObVBoRTUwSWYvYjdK?=
 =?utf-8?B?cklyRzRZUExhZGFxcWg5dmpYdnk3WllRMENMdmxObFM4YlJ5d21OcDRYVGE4?=
 =?utf-8?B?UHNkaGpyTjh5WGYwMnpBMjlQY0JLcElaRmlGRWpiZTdUQXRHNkZMU0VRaGZ3?=
 =?utf-8?B?RmkxdEhnK05UOTZiOSsza3pOeFNCZVczSTFORjNlZFdJVXFoeEw2TFJqVFUv?=
 =?utf-8?B?bzJTcFRUMlY5WkVIWHNNd21aUTlKc00vc2ZtUTZDaE92TWtFeUIzL0t6MkNz?=
 =?utf-8?B?dUhCZzJkNUc5Y090WUhGaFFPT1F0akdxd1Nha3pIRjQzOWoyTHZzc2Z6NGJQ?=
 =?utf-8?B?T2ZrQSs5L1NUSnhSS2RlM0NkczYxNFRwMzVPUGplcjQ2ajMxNEt5V0t3em1B?=
 =?utf-8?B?WkliYW5jaVBocHczQmU5c2VDNnpPT1VER1A1b09MVmQ0RE9uc1BBa2k3b1J4?=
 =?utf-8?B?cktTUHhyRXpCRXgrY1pUY1dtellhcHBMRTNaMUg0NFB4NVZ5ckI4dnBtVHoy?=
 =?utf-8?B?bTlDZE14b00wRVhtL1lKemM1U0twTGc4QUUyNWpKbXVjZXlDODlwVWI3UW0x?=
 =?utf-8?B?OG15Y3ROVVhCR2NZSzRpVHdWak5vWElpaGQ3dUl5R3NlT0NQdnNvS1JwREN0?=
 =?utf-8?B?S2dOSUtLRGtPb2V2ZjFwdWVPSFNpTmJESyt2c3AwMG5DWlJGZHY2NDhnaGgr?=
 =?utf-8?B?TnFSUS9nT1UzY2pNSkI2eHJVTHBhNFpaN01iV0ZDNEZJMmt2Ty9UaWxJeFhG?=
 =?utf-8?B?czVXTVpUME9rc0VzR2Q1NjNBS2NsYnl2QUErN2JXQWlVbmVMcFNVeXhIK3ha?=
 =?utf-8?B?aVZLbUg5MkNySmROdlRBcE1ndU1yUVY4dy9YcnNTMzQrdkd4R05Hdm9sZ3Q3?=
 =?utf-8?B?dkNQRzlvTmNiZkVSMTFZb1plcTUxRjZuc3NIM0xOT1BzckU0SHdZTmtEeDF1?=
 =?utf-8?B?WmljSGdod1VFZVB4aDVrRXBxN2x5eS9YZTByVDlrQTZFelhOTVNpc1o5TE1R?=
 =?utf-8?B?K1ZSK294Y0FwUC81bGtvV2lDMnFIeEc0cUFxTkFXN2tvbnhwRW16MW8zeENv?=
 =?utf-8?B?ZFVrK1lWL3ZTZDF4alZaLzdwVWIzS1I0OEN1TnNmL2tFRzArcmMraVlEN3hT?=
 =?utf-8?B?czQrbzV2UjNlOVNvNGxjVmZMN2djVnpUazFUS2RFaCtuMllzZERnejlaV1VI?=
 =?utf-8?Q?xipGSvNlIvDXzhwMjxydTATiS?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a363389b-e55e-470d-35bf-08db2f61132b
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6551.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 07:50:18.5419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xOvDimsfZi9JxaCqvWeFe2EveT7el9s9lUodowHRvJnzzWioppFUTDFqNkRoYFpxRP/a/vKfCUkSoPndHnIh0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS5PR04MB9828
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.03.2023 18:22, Juergen Gross wrote:
> On 27.03.23 17:38, Jan Beulich wrote:
>> On 27.03.2023 12:07, Juergen Gross wrote:
>>> On 27.03.23 11:49, Jan Beulich wrote:
>>>> On 27.03.2023 10:36, Juergen Gross wrote:
>>>>> @@ -539,6 +553,13 @@ static int xenvif_tx_check_gop(struct xenvif_queue *queue,
>>>>>    		pending_idx = copy_pending_idx(skb, i);
>>>>>    
>>>>>    		newerr = (*gopp_copy)->status;
>>>>> +
>>>>> +		/* Split copies need to be handled together. */
>>>>> +		if (XENVIF_TX_CB(skb)->split_mask & (1U << i)) {
>>>>> +			(*gopp_copy)++;
>>>>> +			if (!newerr)
>>>>> +				newerr = (*gopp_copy)->status;
>>>>> +		}
>>>>
>>>> It isn't guaranteed that a slot may be split only once, is it? Assuming a
>>>
>>> I think it is guaranteed.
>>>
>>> No slot can cover more than XEN_PAGE_SIZE bytes due to the grants being
>>> restricted to that size. There is no way how such a data packet could cross
>>> 2 page boundaries.
>>>
>>> In the end the problem isn't the copies for the linear area not crossing
>>> multiple page boundaries, but the copies for a single request slot not
>>> doing so. And this can't happen IMO.
>>
>> You're thinking of only well-formed requests. What about said request
>> providing a large size with only tiny fragments? xenvif_get_requests()
>> will happily process such, creating bogus grant-copy ops. But them failing
>> once submitted to Xen will be only after damage may already have occurred
>> (from bogus updates of internal state; the logic altogether is too
>> involved for me to be convinced that nothing bad can happen).
> 
> There are sanity checks after each relevant RING_COPY_REQUEST() call, which
> will bail out if "(txp->offset + txp->size) > XEN_PAGE_SIZE" (the first one
> is after the call of xenvif_count_requests(), as this call will decrease the
> size of the request, the other check is in xenvif_count_requests()).

Oh, indeed - that's the check I've been overlooking. (The messages logged
there could do with also mentioning "Cross page boundary", like the one
in xenvif_count_requests() does.)

Jan
