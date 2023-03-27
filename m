Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 009256CA933
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 17:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbjC0Pit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 11:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbjC0Pis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 11:38:48 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2045.outbound.protection.outlook.com [40.107.22.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E4FC2;
        Mon, 27 Mar 2023 08:38:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mE8b7ZaNb7Nq7AODYOmb0kNCBtdxlRgUhU+rstvQ/YvDuMfIIKy8BHApX841ybEdIdETvk6WFRXbW3X2D/uz6BG9UV91wSs0WVWeKzZ4Z+YhJQTcDo7jnq3Oj762L3wB42bvQkxFeKgu92gZt6IDTgTBhO9bVNvhGcyNfjfGsug88yboicxSPMyusO2L0ZGj5Y5SeYjK7dchlnCDda1qCAhU+Mn5MryGk0d8TeRwLa2eFruTcsXMZAN2RETo2xOqRzi2eoa8Fin3UJRpsWb/uz61EOJg0eFzr8FzAgzUF2/+6nUZ2F3Aa0JeyrI21EZxHnrEMC5xTVxugOtCQBTuDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tET5XWsbzJc25vRwP7iQ1JD35iIyc4moy2SuPeyqit4=;
 b=FQOOKmy4atVPDutH6T1dVFvCFx/1WXBOBaZTBhOc5sJWLTYDq6pNqm4OR7LBFIo6L8RN55S+CtaOhGLNeYRxKWS8em4yoT93fIJWUnFg5dXtXfE4WR3rFtYSOmtZNM8TE19sPva9AXZnk3HgxQ73wKe+6TwmKszQPICGM1wowcSCce2ki3IQdrVIInlcdrzNqpLslkwiGxvMRGxRodMS4s2OVEEIuCln2QMfyELKj31RFZ+5g7oSrjU2IG7aFzlSHV4/x218MuI/JZbAlJeh+uVkLfcSurxs98l/RxpuDebgPdgMXGeHZbwv0YSLdoA5rCgv8NanKXvM99KJGY1dTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tET5XWsbzJc25vRwP7iQ1JD35iIyc4moy2SuPeyqit4=;
 b=UHOjdg5pxLhvF4LnWsIsPcO1jvtfkLKitskbrq9N6gOos4pxB3+ellqe5fimcFxlHjoHWmosenaEy3BeTiZZvDGCqfdkoxmbuJnJTjKU+5P3NJFxDgX/fOMuhEGdF3NCCXEIMMRC9rs9fM/fUa0U3JGvXTRQ1TVARnIur2uNqdfUDBTHGy/TZGs+oJ7hgLNeBk4F0d5nIalxlCwVEiuC29eo6k7rv6q2qm2uag5if5snekKCnrfen7mAAdebPfGGC3IvAb/i6dJFprf33oBVYvosa1M2Ef93BNfeHiuuRYB5uNTbjTd7qeY3i9VnN4ph/QK9nRDcuH2XTJ/ZFIs9fQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by PAWPR04MB9957.eurprd04.prod.outlook.com (2603:10a6:102:385::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Mon, 27 Mar
 2023 15:38:43 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::154e:166d:ec25:531b]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::154e:166d:ec25:531b%6]) with mapi id 15.20.6222.029; Mon, 27 Mar 2023
 15:38:43 +0000
Message-ID: <89653286-f05e-1fc1-b6bf-265b7ecaad0d@suse.com>
Date:   Mon, 27 Mar 2023 17:38:44 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
From:   Jan Beulich <jbeulich@suse.com>
Subject: Re: [PATCH 1/2] xen/netback: don't do grant copy across page boundary
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
Content-Language: en-US
In-Reply-To: <f519a2d3-6662-35a2-b295-1825924affa8@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0139.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::10) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB6560:EE_|PAWPR04MB9957:EE_
X-MS-Office365-Filtering-Correlation-Id: af957ac7-806d-4413-a7ab-08db2ed958aa
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7NYbhtp4z21cSgB3y8FAXYG09iXZFSOA3SL+yW2Rl/kFVLiA9z0vjqtGg4ke2n0iFwcBmJwFYcODeC0x3ck7bzdk5pC8Xk+Ic40C+wUta1mSzOJ/JfBvW43bfFLTU3LfwA6MSlRw7GFTQFwcCk353v8jAEAuuZColXhTiAVVCoVSDjwaNTOt+bvvaYDLufim0OlSCP5B3q+GqOLO6IhkwnLtoTFNar+mMSNrFBssw9PzfdO77FOaXHkaY7P9jMEiYqt3sDaWXZiavVSUpsR/kBTBOkgMFVE1/W0h1kEjOlyOVYBt1aGucvJ+kbykz3FldJcomMMAzpqmZjFHt8gWw1qFjpg9pSZg3QLznu1UotZTqvzqI3WkfV+vkInUTZMH7qd0WrtrqAPOJcmsK04AIXeFcsFprPACrGEFyyzKSbDElaMmfzj/VAzCHsU+s8G4T0mT8ippS3WQHIQmrAiIEz/lb2lNP2J6SAwTxGdMiqHUEaeKbVlhdyfFqGUZK/g2TFJkwkzx/+QlQ7J94Q0wscn+mmWUkfelVWeNGcKAIPP9HZhlJ1kMhfxVpGW74jDy+FIaCfWovSfSRiNZXtLuQFAqmIcelnnHMokmATJydpkpY4fSTAHcvuk+/FUDjlptyb0raj0ty/3/AOm7tDvEVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(396003)(376002)(346002)(39860400002)(451199021)(478600001)(31686004)(54906003)(6636002)(2616005)(316002)(37006003)(6512007)(6506007)(26005)(6486002)(66946007)(53546011)(66476007)(66556008)(8676002)(4326008)(31696002)(186003)(86362001)(41300700001)(8936002)(83380400001)(2906002)(36756003)(6862004)(38100700002)(5660300002)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SjJmUXkvMitGSnp5MWpzb2VYNWJFT25lOWlWMVd0Rk9PT20wMnZLOHBKUzBj?=
 =?utf-8?B?YUYySkJzU3AxQ01LVFFLdFJXVEFkSnFCSXpnREV3VHBmNytXbDBhenhBYnVl?=
 =?utf-8?B?SW9GZW12a3duOTcvSzhXVVRJT0laRDI3TEZLOVZmS3RiRjdRMUh2eWNHVUJB?=
 =?utf-8?B?bFVabWc2YmIvb3RJQU4zQUZvcmdLRGdmdUs0MURBYktOblc0Z0s3bEJrVG9V?=
 =?utf-8?B?c0xaOTNIL3BHNXNBeElFS0x4WDA4bDFqT3NNQVhNaTc3MkhkOUJZL1cweTYv?=
 =?utf-8?B?NnNCYlAwZ2FNU3ZqdzdJYnFLd0hkQkFENGk0OFk3aVNYMnB1UGoxRVJDZXpm?=
 =?utf-8?B?RVVIdDVxbS96QTBhY1RQSGo0QUx4NWdKOUdsYlRINzhYVjBRaFRGUFNlRnZY?=
 =?utf-8?B?T3FuSXNzcnRpdzFHTGhjSzVIN1dWV1NUN3I5U1hSVFIxYjJYeVdBZlY0SmVs?=
 =?utf-8?B?UnNzeVJ2Sm04MUVNZnlkZXRpUTh3TkdtczU0V3A2K1NvNnFqVW9qZGFlNnI1?=
 =?utf-8?B?b2FuK1pTUENZYXdVQ21DeDlrM2tXUVJ1QksyTmxHUnZhQU9lQVVvUHpMOGoz?=
 =?utf-8?B?MmViTzZFbDlZbzdGOVVIMkRoMVJqcTROVWZ1TVZFaUI2dlBXN3lyYlRwZzRR?=
 =?utf-8?B?YTVkQWcxbEJKd3hVZStYcE9KSndzbkc2N3Y1R0FOUTZnZFNYRDZRL2czTWtC?=
 =?utf-8?B?b3NKSzl6NHZoQ0FlYUtIQWZwczV2OVdiNkhJTEUrS0docE9pbHg0MlBnRVQz?=
 =?utf-8?B?UlFMUG00T1RVc2JOY0JYdVloNmNsYVpUREVHUkluR3F1YndWU2dVN1F1cXB3?=
 =?utf-8?B?dEk5WWRwbWREZWdCMExGamcrczF6QzV6MFpjTTVrQ2JLazZiNU8yd1pvNFU0?=
 =?utf-8?B?NUJhZzA0N0hoYUhEbTVYUjBhSi9uQjVzVDZnMUMxQlVMaG1MTjdpS1d4Ylpi?=
 =?utf-8?B?dmhGQ3BnYzI3eTFzRmRoQXlYdXdJZDZXQ1Z0MVdKa0gvVlg1bjRSb1hnbUtP?=
 =?utf-8?B?MDUyWkl0SmxVUFBlT1ZOT2d4K1pVYVdVUmRmOEQwb29LK1RuRkh5WGpZOWk3?=
 =?utf-8?B?c3lsRlR1R0lacVFRY1g3WTB6bHhSMnRPaGphTHNTTEZMWUtRS2VXV1dxNGs2?=
 =?utf-8?B?YjNkNWRhK0FYcWYvN292dzdRRGd6N244Zmp6c3AxcVdQd0dsMGhWaVdLUGRW?=
 =?utf-8?B?WXYrUk40RjdsbEZjQ2JIOFYrV2JvSTdtNEl4S0V3dG5IVTZwa3R3M2trV3NQ?=
 =?utf-8?B?SXVuK2lrOU52L2FQVHpZakhpTlVZbmJib3l0c2VUZEIvMXdiVmkxWS9LcVdP?=
 =?utf-8?B?LzBONlNSa3FaYmpTUytPNzFJY3RKeElDeUtsblpDc3FpS0FtNDdPSWg4Y3g4?=
 =?utf-8?B?T2lsV0p4cTJSVmlzMW9ydzgxQll3Y0xYNDJnM2VKS25VL3JSR1o1SENiUkl0?=
 =?utf-8?B?aVcyZ1RlQ1VCelNGc0E2NEpRUHV6ZDI5TTYvYzVsa0hPYTJLZFVITjY1d0VX?=
 =?utf-8?B?cnpMSmxNbGJTMThheWsxVGgzL3I5dTJ5WGZ2QmgyOWIySGFCMjU5QnA2c242?=
 =?utf-8?B?SVppM0VLdHZVdXBLU0E2c3BGNzE0VlJyWERVVzZlRWJmV1BWTld2aGdHR2pT?=
 =?utf-8?B?dFF0L2JFZTd0V29KejRsMkg3TDhGWUZ0Q3dyUGtOWENTR1p5RWJnck9LQkhQ?=
 =?utf-8?B?emI0eXRiajArdmY0dmNHeUdWNlo4VXFFMVVGcHZyQ2U4akNlaFJGT3hjUm9S?=
 =?utf-8?B?aFFDS3IvQ3d6YTd2OW1mQzJEY0JDeWFiYU5qZE1QOUc1a1Q5b2dBQ1ArMTM1?=
 =?utf-8?B?L0lqTGZiNFNvbEdzNzgzY3BzN2tpc3A1c3J5RFhyTUpjRzdzemlBNWo2MHE4?=
 =?utf-8?B?UytLdTM4SWZ6eFE2VWRDVUNab2NsOWtaVE92d3NxSDlqS20yTnRLQXlJV1c1?=
 =?utf-8?B?RVFVT0JWMjJVOVNVR0VMVWU0S0s0S2F6WWxZZ0w3TXRnWnB0RTlyMUs3WUJu?=
 =?utf-8?B?M2VSNkkvNkZacy9md2pwRnlDTDlYczMvakszeXp4Q1lOU2c4c2V6akFveDB6?=
 =?utf-8?B?RktvR20rMlMzRFkwTllERkpZSFRZMk1yNXBDRTUydzZoTC9DRGVvb0lkaFRM?=
 =?utf-8?Q?PFh92a7o8F/Ou5JVU18zlTIm9?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af957ac7-806d-4413-a7ab-08db2ed958aa
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 15:38:43.7533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IL5DYqZ47DtvKirvgABQT+AeYJkIsO9JxFX7hgsjR8nrD9zzfbUCTWkiGuovdgbxSn0eEoLbtsZiFI1fVQI5vA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR04MB9957
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.03.2023 12:07, Juergen Gross wrote:
> On 27.03.23 11:49, Jan Beulich wrote:
>> On 27.03.2023 10:36, Juergen Gross wrote:
>>> @@ -413,6 +418,13 @@ static void xenvif_get_requests(struct xenvif_queue *queue,
>>>   		cop->dest.u.gmfn = virt_to_gfn(skb->data + skb_headlen(skb)
>>>   				               - data_len);
>>>   
>>> +		/* Don't cross local page boundary! */
>>> +		if (cop->dest.offset + amount > XEN_PAGE_SIZE) {
>>> +			amount = XEN_PAGE_SIZE - cop->dest.offset;
>>> +			XENVIF_TX_CB(skb)->split_mask |= 1U << copy_count(skb);
>>
>> Maybe worthwhile to add a BUILD_BUG_ON() somewhere to make sure this
>> shift won't grow too large a shift count. The number of slots accepted
>> could conceivably be grown past XEN_NETBK_LEGACY_SLOTS_MAX (i.e.
>> XEN_NETIF_NR_SLOTS_MIN) at some point.
> 
> This is basically impossible due to the size restriction of struct
> xenvif_tx_cb.

If its size became a problem, it might simply take a level of indirection
to overcome the limitation.

>>> @@ -420,7 +432,8 @@ static void xenvif_get_requests(struct xenvif_queue *queue,
>>>   		pending_idx = queue->pending_ring[index];
>>>   		callback_param(queue, pending_idx).ctx = NULL;
>>>   		copy_pending_idx(skb, copy_count(skb)) = pending_idx;
>>> -		copy_count(skb)++;
>>> +		if (!split)
>>> +			copy_count(skb)++;
>>>   
>>>   		cop++;
>>>   		data_len -= amount;
>>> @@ -441,7 +454,8 @@ static void xenvif_get_requests(struct xenvif_queue *queue,
>>>   			nr_slots--;
>>>   		} else {
>>>   			/* The copy op partially covered the tx_request.
>>> -			 * The remainder will be mapped.
>>> +			 * The remainder will be mapped or copied in the next
>>> +			 * iteration.
>>>   			 */
>>>   			txp->offset += amount;
>>>   			txp->size -= amount;
>>> @@ -539,6 +553,13 @@ static int xenvif_tx_check_gop(struct xenvif_queue *queue,
>>>   		pending_idx = copy_pending_idx(skb, i);
>>>   
>>>   		newerr = (*gopp_copy)->status;
>>> +
>>> +		/* Split copies need to be handled together. */
>>> +		if (XENVIF_TX_CB(skb)->split_mask & (1U << i)) {
>>> +			(*gopp_copy)++;
>>> +			if (!newerr)
>>> +				newerr = (*gopp_copy)->status;
>>> +		}
>>
>> It isn't guaranteed that a slot may be split only once, is it? Assuming a
> 
> I think it is guaranteed.
> 
> No slot can cover more than XEN_PAGE_SIZE bytes due to the grants being
> restricted to that size. There is no way how such a data packet could cross
> 2 page boundaries.
> 
> In the end the problem isn't the copies for the linear area not crossing
> multiple page boundaries, but the copies for a single request slot not
> doing so. And this can't happen IMO.

You're thinking of only well-formed requests. What about said request
providing a large size with only tiny fragments? xenvif_get_requests()
will happily process such, creating bogus grant-copy ops. But them failing
once submitted to Xen will be only after damage may already have occurred
(from bogus updates of internal state; the logic altogether is too
involved for me to be convinced that nothing bad can happen).

Interestingly (as I realize now) the shifts you add are not be at risk of
turning UB in this case, as the shift count won't go beyond 16.

>> near-64k packet with all tiny non-primary slots, that'll cause those tiny
>> slots to all be mapped, but due to
>>
>> 		if (ret >= XEN_NETBK_LEGACY_SLOTS_MAX - 1 && data_len < txreq.size)
>> 			data_len = txreq.size;
>>
>> will, afaict, cause a lot of copying for the primary slot. Therefore I
>> think you need a loop here, not just an if(). Plus tx_copy_ops[]'es
>> dimension also looks to need further growing to accommodate this. Or
>> maybe not - at least the extreme example given would still be fine; more
>> generally packets being limited to below 64k means 2*16 slots would
>> suffice at one end of the scale, while 2*MAX_PENDING_REQS would at the
>> other end (all tiny, including the primary slot). What I haven't fully
>> convinced myself of is whether there might be cases in the middle which
>> are yet worse.
> 
> See above reasoning. I think it is okay, but maybe I'm missing something.

Well, the main thing I'm missing is a "primary request fits in a page"
check, even more so with the new copying logic that the commit referenced
by Fixes: introduced into xenvif_get_requests().

Jan
