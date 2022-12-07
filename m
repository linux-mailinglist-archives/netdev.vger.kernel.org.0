Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952026457C1
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiLGK1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:27:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiLGK0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:26:47 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2047.outbound.protection.outlook.com [40.107.7.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F28D167F1;
        Wed,  7 Dec 2022 02:26:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=guof3MgiT45x6NbqIP76EMqDx1RJGXf1Pqk3k914FQe4aWG/dbYn0tmtvj3snJa6omgbsBfFOphQZuCiOM5EqTtZZN5pwsMN5WqUAOANlPcpdQxxywb2KZbLAqeIWSm82s+77us0aM6JekTfe1P173WyR7wcMp31ag2Z25mQMMPgDQIqeE/J5q07ad9FQ6UMNy6XZtBpJBvfMsmjKCZgHHeL44ijKC8jj8KTB4AWtvpWiWsNrztkbmtxjkCmp6NbtUWcUFsMEN0y/GLyQBItbkM+I69zwrOIfpOF2Z5g+lEsVqGHgsc2+oCWocyS5TJDafraN1MFucrbTZiUs/Ufbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gp3l8pTrimm7zWLxA86ncTUcquifyA1VTZB+N9mGHYE=;
 b=XVO/2mu1M3/rCN/BjTYjyN6qFeTgbv+qK32o+yrvkCdD3Fzdt6hxCaoflLy5esfQ5hdBOjolwxiJojvTpAXymRiN/hfwHhTgWslMzmfgOGAWzwbeQN8vkaFNyfhNthImRBRXxQITbPePlVkylw/msS60maYWFu71g27ULam/1J/7SH/g8BpavtZ9XP3vi+MH+kJBYT9DskEL4xrtMvJI+noWkeVUPQBUF6XvLGp7YfPDwGLqrJrYNiQmKv7AwzVe8FVN+JXgqTtOYMU7QTRpqLRqBMUOAxce7o2pUzuXyhpOwYTgsTmqsyGmC/psgRzPJSZCRg2PnPs97SmZZ1rxUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gp3l8pTrimm7zWLxA86ncTUcquifyA1VTZB+N9mGHYE=;
 b=JXcKREEn999SJoJmEdQz/1UHROD0bu5J9Y53KL5okCKx3soCWbrzV7/ETo3lx4uY97mdgKwp3nM/3KRWDrxxXAljyDClPDUsO46iKkpbG1rEOuqjGjJFSxEiX25Mb1sSFPY+eHSAND+RxKFOF+wWnyJc8rsRfTTxT1QVWmIpgJ0HiCoOQOfonr4f4Av8a6YqjwCDHjxiudOn7r/j7njgGUSMJnIi6sjgCGZj9jznebhZzrj211G4s7rwbmPzdI2+FHCr/ucBayKUlLrKZZ4XhBitBm4XEBQzz2YsazfngSlVKO2qBgPOPc/62yqbDpULk0p9o2FoqglSYQV0NqPqPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by AS8PR04MB9511.eurprd04.prod.outlook.com (2603:10a6:20b:44b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.15; Wed, 7 Dec
 2022 10:26:41 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::4da2:ea8b:e71e:b8d8]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::4da2:ea8b:e71e:b8d8%4]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 10:26:41 +0000
Message-ID: <0074a007-23a7-f2ff-0b85-47e4263c4d3f@suse.com>
Date:   Wed, 7 Dec 2022 11:26:39 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] xen/netback: fix build warning
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>
Cc:     Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Ross Lagerwall <ross.lagerwall@citrix.com>
References: <20221207072349.28608-1-jgross@suse.com>
 <46128e5c-f616-38c5-0ab2-1825e72985a8@suse.com>
 <f1c89855-22d4-8605-e73e-6658aef148f9@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <f1c89855-22d4-8605-e73e-6658aef148f9@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0166.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::9) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VE1PR04MB6560:EE_|AS8PR04MB9511:EE_
X-MS-Office365-Filtering-Correlation-Id: 35004ae4-5d8a-407b-9827-08dad83d87a4
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zpNHuNVv72EgZIyI6PP578If4nPg0Dj45IaKUL3l7Fovpo7QlvShbufv+ua4i8uiBwGMH7bpuDawbiKSPgTLK3FVY9rvfp04ycBOVeIRtCir+I+LHUqD2iycT5JrJJiDAD1Jn3ZobMS6BrZ/5TDTHbQZu6+ilpaLUOmJMT2xP0iRso+6FXIWvphdBuAp2OUcI0JUKAzZVEMMryg+74zvrxZ3RH9JA9n3DAwRv5ib7uNlXH9S+vMXJ+/lgSMFQgssOfJsYS5cGgRNZNMymIIl7IVpf4D6Z9KP94ywXgEKCVz04uDrmGzZS3omIDYCa8xQZt74Q6UB15uXVm0xTQHhtbmEJy7BfC3pByfgdbh0Scq/PbfpCXpWHkXrW2IqGJvEh4L0g4S5g9IQIYm1oIB/njAZcveVck+vP8oIAAF4eBirbf42Bjbpu7SWilSxgGRjIRlXv6/r2aatQ5gdn0aUdzwuKKCZNXdmH31Cb6TpgGyBIco3DdYodQ/LHGJ5gjVVPLb82ynjSpYyLSxeos4yqfyKYB/NGTODPjzj6FJc/vAU6IGeDgziIuqBYfXi0Fc2L56Os/66qS7N0nu3vuJFf7z9nsk4VOXLra8PkjHGogZfoJvJ42d4PB/3pidBKIb+jv1/M29CCZfn1cnG4CcRCP1AxGUtpLVKNxBIyawyM2+x80zs1PGloRhYpWYVzZ9dBvmJz+su8WwkgFIaUTs/+Bh9yN5/tZYtWTAyASFy3M8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(39860400002)(396003)(136003)(366004)(451199015)(31696002)(4326008)(41300700001)(66899015)(6512007)(6506007)(66476007)(26005)(66946007)(66556008)(8676002)(53546011)(37006003)(86362001)(316002)(83380400001)(8936002)(6862004)(7416002)(31686004)(5660300002)(186003)(6636002)(54906003)(478600001)(2906002)(6486002)(2616005)(38100700002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WDB1b1pCY2haeG1zYWlxNlAyTGRYZlBtR1g4SVNvbU9CakZ5K01Ec1lMNFJ1?=
 =?utf-8?B?dDRyU0RvbnJhQmxUT0JFdUdHOUI2dFMyQ2tMOEMwdENKRFlKWmczTTh2RUsy?=
 =?utf-8?B?OTBDSFFSbnE5NWJBQWMxOWdnd3hoSjQvcUVkL01HR2IvRG05ako3Zm1nd0Yr?=
 =?utf-8?B?Sk02S0MySXFuNjlOeWU2d0trWC9XVGp5RStuVkZidFhGN2xhckFBQmE0QlF0?=
 =?utf-8?B?THZGUHJFK3RDNFpQYllsdkhiamJKbGUzLzh4WmdtWVVUbUc3RzE4cDY3QSts?=
 =?utf-8?B?dW9Cb2QzVmdRSlBIRTZuMkNNUnQ1WEc2YkM0RlRoUlUyekdGUk83OTR1Z1h1?=
 =?utf-8?B?VnpHa2Z2cXJYUVIrTkRwZU5URUNyNDJJbEhhVkRiUU5VRVlKSVpMYTNyZWlo?=
 =?utf-8?B?T1ZxSFRMakZTSFJpaEEwa0tCUm9HUU5VZzZ0a1pCLzgxMjdkeXplS2QraFd4?=
 =?utf-8?B?VWVQSmo0a3V0MUtKRVlyWU9ueE1KNnRYbTBiZHRONGdDMDhBbWF6Q01BeUx3?=
 =?utf-8?B?RVJRTWNhSGFCYVcxaWNUQlRkMDZxM2tBYjhQRVJyWU9KSE83WWN5Y2hQTGN6?=
 =?utf-8?B?dDFkVG5qMmpZODYzYmZhY0dnM0FjWDN6YnBmamZhdm1lbGxDMU5hSnV1SjB0?=
 =?utf-8?B?ZTF1dnhmaGUxbnJUUVIyU0xORk1DWXYwZUQ0cjR5R1hxK1BiRURjRTFCVzhK?=
 =?utf-8?B?dittSTZ0ayt0Y01vNWFHY2FjS2tOMHNHNmk1b1JLNGxJNk9Da0pPZEhVQSs4?=
 =?utf-8?B?VHB3YUQ4UlJJUzM1T01iQW4xOStYWXZ0MklCcmtTa2JZNWVqZldZWWl2NHFm?=
 =?utf-8?B?NDBzbk5teUpaNUxhZUp4VW9RcSszM2dhbkJXZFNjWmJGZ3lRd1Y3a1BnWGxv?=
 =?utf-8?B?VGllRnlLUkN6NnpNSTFZY2FGMC9QVGVVZUR0U3U0NWtuZkh6OFN0aWw3NmMz?=
 =?utf-8?B?K2hMeDNSSTFFUTF2bW1qQTNKcngvUUxzSmowWCtDeDhhdEVkZnVjSHA5VzI0?=
 =?utf-8?B?aGFuQ0xVczY3bE51anBoN2VYUnJGemhGVjVVQW4rRkZCK0JpL1RmaWhYVEhZ?=
 =?utf-8?B?cjRBMGNSRk9sTXoxajJmN0dXV2VOaSsyMDArbSsyd1hnUm5OMnFjVmNlWUk5?=
 =?utf-8?B?aW5SbDdGREYyUUpKSHozNGUvMWdwWlJzSjYxY24yRi9HcEJPN29wZmZlcFRv?=
 =?utf-8?B?MTNGdnNlcHpjWExibkVScjZVeThFQlNsV2VFakJIdXR3RXRaeStwZ2pOUlgv?=
 =?utf-8?B?bktPU2pyL1IzeVltV1RxbEpiRFQ5N0txcEVZUnhBeE13RUZHdlN1YzM1SFU5?=
 =?utf-8?B?WFZBU0h5eFdkVlVjY0luL0ZSTlI1c0NBRHpSUTVEdUlNZ3BDREhINkR6Zjda?=
 =?utf-8?B?K0Ird3hsWmxtb2xPV25XMTBiWG84VXV4ZEpUWTNudGpiNTA0YVJjNS9VSjZa?=
 =?utf-8?B?ZktBSDE5QzdUNCtmeDVoR1VYb0k5c2RPc2tMRWF0Z0JsbHZSclMrTyt5RjV5?=
 =?utf-8?B?WmhUWEdmNjVBZFNVUEltWDY3WUoyWjYydG9WeXBrTlgwcFhVVkVtc2NYMzZo?=
 =?utf-8?B?N282Nk9teDJUS0Ewd2RqVU9rME14V1VuMkV6VThzY25hYW8yVDVySElBSEhM?=
 =?utf-8?B?MHdpNVFGcjFZWWRLY3BMbGRWWm1KLzY3YmxyMG05ZFdHYkY0cGpHSVVYTVY5?=
 =?utf-8?B?Vks3SnRuWUE4SDRhS2hkSDhrditKL1crSW14N3o2R2YvTDNONEhGcXZ6OCtz?=
 =?utf-8?B?UUZybzJRaU0wMGRLbHBpcCtoUmxSeVNkV3JHUVk0K2U2SElFbkJJd0h4L0do?=
 =?utf-8?B?bVdrVFpXYWpuZmRBZVh1blFHK0ROWmtiQzlkU1hSRlRXWENWQmRyQ01ZcFB6?=
 =?utf-8?B?Y0pmb0RmdGhPSW9GYjBLOHdncWZNZFF4aDBIV0FBcjMvUGhvZkIzejZYeTMx?=
 =?utf-8?B?YXFVMXVGM0VMRVc0bEFUaHkrTCthZHRZb3JlUzkrWEphN2xTMUl1TVJCblJh?=
 =?utf-8?B?cmtWTy83NUxJZllGS0d6S1NzZ3RWeDZoczZpQXRKVUZodDhTWXExQkY1QjJE?=
 =?utf-8?B?THc2N2YyM0hhbW5GU0xHVTlLV2UwLytaT25GTUlDNWJvSWp4Q0VvWCtibktZ?=
 =?utf-8?Q?YkEzdVXg8ipN+SDoU5fPoT2FC?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35004ae4-5d8a-407b-9827-08dad83d87a4
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 10:26:41.0255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IAQLOsfK3agoBJ/n59erewJYr1HQ/glJ+gDqRhUNbKkUhaUp397p9s3E29dlNrEdKZ/LBc291LAXAGDy6qlXFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB9511
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.12.2022 11:18, Juergen Gross wrote:
> On 07.12.22 10:25, Jan Beulich wrote:
>> On 07.12.2022 08:23, Juergen Gross wrote:
>>> Commit ad7f402ae4f4 ("xen/netback: Ensure protocol headers don't fall in
>>> the non-linear area") introduced a (valid) build warning.
>>>
>>> Fix it.
>>>
>>> Fixes: ad7f402ae4f4 ("xen/netback: Ensure protocol headers don't fall in the non-linear area")
>>> Signed-off-by: Juergen Gross <jgross@suse.com>
>>
>> Reviewed-by: Jan Beulich <jbeulich@suse.com>
>>
>>> --- a/drivers/net/xen-netback/netback.c
>>> +++ b/drivers/net/xen-netback/netback.c
>>> @@ -530,7 +530,7 @@ static int xenvif_tx_check_gop(struct xenvif_queue *queue,
>>>   	const bool sharedslot = nr_frags &&
>>>   				frag_get_pending_idx(&shinfo->frags[0]) ==
>>>   				    copy_pending_idx(skb, copy_count(skb) - 1);
>>> -	int i, err;
>>> +	int i, err = 0;
>>>   
>>>   	for (i = 0; i < copy_count(skb); i++) {
>>>   		int newerr;
>>
>> I'm afraid other logic (below here) is now slightly wrong as well, in
>> particular
>>
>> 				/* If the mapping of the first frag was OK, but
>> 				 * the header's copy failed, and they are
>> 				 * sharing a slot, send an error
>> 				 */
>> 				if (i == 0 && !first_shinfo && sharedslot)
>> 					xenvif_idx_release(queue, pending_idx,
>> 							   XEN_NETIF_RSP_ERROR);
>> 				else
>> 					xenvif_idx_release(queue, pending_idx,
>> 							   XEN_NETIF_RSP_OKAY);
>>
>> which looks to be intended to deal with _only_ failure of the one shared
>> part of the header, whereas "err" now can indicate an error on any earlier
>> part as well.
> 
> The comment at the end of that loop seems to imply this is the desired
> behavior:
> 
> 		/* Remember the error: invalidate all subsequent fragments. */
> 		err = newerr;
> 	}

This says "subsequent", whereas I was describing a situation where e.g.
the first piece of header copying failed, the 2nd (shared part) succeeded,
and the mapping of the rest of the shared part also succeeded. At the
very least the comment in the code fragment I did quote then has become
stale. Furthermore, if "all subsequent" really meant all, then in the
new first loop this isn't followed either - an error response is sent
only for the pieces where copying failed.

Jan
