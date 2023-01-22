Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1909C676BDF
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 10:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjAVJdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 04:33:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbjAVJdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 04:33:51 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2046.outbound.protection.outlook.com [40.107.102.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D47F14E9A
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 01:33:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eWavVECcWcbpyFiqGkEwqFBub6erLu0TxT2PxV6yqAD1bnZreLEvKtJvzTYN1xxJhNcpn77T22dxI3t/zWdP3Jtadvhrm+5iMxelpi1kx/TFve+jFor1314Yv66FON2OkvAP6x/qWrZNSseG6UTXNQyWiGx6Iln0j0ypIXf/WAa+aZdxsIVZV2rBQVtZOQOdDWl+V6OJw7SlpycL0FyWuFTurV6wXxZlQuBANMU1JjEIkSgZp+F8SW53eGq5uWB+Sr4VhD40+a2BD5OdyjMKOgctlXMAK1CnqWIzbjP0nYMmveHeYwMu01hPw0fscs0M/UY0sthGsKZ7vLvl2sRZXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z+IX1fl2olB36V5yVoXoOxDGvR0K4KDrsASYazTaOVI=;
 b=S95S9CLnNb6C301MDrU3QQkQe6fJC6rvlo1k9t/nRwc2CXP3amXQTzRQW/zAQQJFIYC4/4urJy5vQZnPKc/MsWteD/xANt5Kh5CXCPfbGOUd+ae3pv4ZCSq0qf5aLDuB5Ce20uqrI8z26jPHqvEUfruKz8TfX3gMzQUPR5WitQLefb8zEvXFPy4i5FX3m7AqyAhHKmqJD3J9/NXAU0DPVOMCCLQZNujgoE9syeAwZvIOPpPb3Iky3Cafz9iBWPsDtGK0fzFvR63CuOPICsjsriMDbYNoayf+Tx1qbwXRO1tewG6lg9sElmIHsVJf9RWpwu5mTmameRF9SDOGAr6gIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z+IX1fl2olB36V5yVoXoOxDGvR0K4KDrsASYazTaOVI=;
 b=SOZRBzRWhWcso/XuthWy316aIKK4I7+UFxMvQuodWgvBWAdjeWDm5n5J2uIzps84zm10SkgPpAgCEha4TL9qJUsftwNaSP9GOcWQbu+CKA0wyTJDHPuCbUpV1OrSp/JLlYkmH/cKMBIW0ok4AWa5fvfta+Pnn/9ipj1OhxoZuHI9xseO0lBiuHHHsZjYZLHDglEiPYKT3v8hLzrxQncrC6xB2+g01CoC2rx4paTStMVWzSANnh7SH+9hv3LnvnXBOmkOJ25aVyTJaN+n8vlHCKOL3RjS19+bexuHhsaGKsNiRSKgzp0AhTukExshOqRl3S950fwmEEXHMmxOplbOcw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB5629.namprd12.prod.outlook.com (2603:10b6:510:141::10)
 by MW6PR12MB7070.namprd12.prod.outlook.com (2603:10b6:303:238::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Sun, 22 Jan
 2023 09:33:45 +0000
Received: from PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::5e6:6b81:fa63:c367]) by PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::5e6:6b81:fa63:c367%9]) with mapi id 15.20.6002.028; Sun, 22 Jan 2023
 09:33:45 +0000
Message-ID: <c11cf7d6-4ebc-2d90-0bad-503ac092d821@nvidia.com>
Date:   Sun, 22 Jan 2023 11:33:35 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 0/4] net/sched: cls_api: Support hardware miss to
 tc action
Content-Language: en-US
To:     Edward Cree <ecree.xilinx@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
References: <20230112105905.1738-1-paulb@nvidia.com>
 <CAM0EoMm046Ur8o6g3FwMCKB-_p246rpqfDYgWnRsuXHBhruDpg@mail.gmail.com>
 <164ea640-d6d4-d8bd-c7d9-02350e382691@nvidia.com>
 <CAM0EoM=FaRBWqxPv=jZdV_SZxqw26_yhK__q=o-9vqypSdMV1w@mail.gmail.com>
 <912be77b-3723-33a7-8fee-05262b94efa1@gmail.com>
From:   Paul Blakey <paulb@nvidia.com>
In-Reply-To: <912be77b-3723-33a7-8fee-05262b94efa1@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0260.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::13) To PH0PR12MB5629.namprd12.prod.outlook.com
 (2603:10b6:510:141::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB5629:EE_|MW6PR12MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: 39ed3f84-b20d-4a48-af80-08dafc5bc18c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: COymYdo3SPASN5zwN3IYPhVTKVxB1nAMs+c49Grq2qqXAfYOTda4VddR25X0kPoGBx/uBBIwptvYn63K09sj7m/QUuMLQHXW+cQ3Il13fHGUQWcWV8F0XREn3sqA6btDvuXjzkHpvMr+3k4eYfoo7yPjDUDZS7MuWTgomgxaRS9Yq5BqT/fKNXRoLgEIc8qnPrKLzPAh2b2Pr8rHUss/7VU8i3GEiN34gz6auEdYA8MKsb1eHFpJ1vJvcH5N11ap1xB2RqLp/9iK1vTIYekHwIjPCnlqEjYp3jRthI/AUTcvd4eehMTbax/CVkKXh4ZaibuJ55lBWhvqJRT7ljosy0UJsPlMfojOUNxUq3hg+GgkSlvKkhRaBNrkChYbs0C63j1eAUU3X5Um2dd975MFSrCAyIP8gJEAyIbwdexLhV937ir1PtOOX1KpS5/vLPtec+3Qmbjy6CKbqYI5u48HsQoVexcrWmmOxNGiCrsMeEVljaTW4J5xll6X0h4YTGpPdP2x8LaI+XXx8blO242MAcD+r7VXWIYmJmzqSTY9Li3b8gmnFNlAiXkdoePpBZBSQ5dj2bqB0GjFsTQ3K+5HgmMcdzYnucjVrOYNr/1wCo6zEXpnbR/I3rc5p+XUvagVRc2wh9r8Iyd/cOBsn6i/zOEnGejbq/dmDQvE6EvtVZoAjnvIRaxffuv1izC3380GZdTkJJ1Hx3haGyKgmBSRPS8nQ5wSPuzWLVzzlyCqRC0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5629.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199015)(2906002)(54906003)(31696002)(110136005)(316002)(31686004)(86362001)(107886003)(6666004)(186003)(26005)(53546011)(6506007)(5660300002)(6512007)(2616005)(8936002)(66946007)(6486002)(8676002)(4326008)(66556008)(66476007)(478600001)(38100700002)(36756003)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bTlSNkVUL2lqT1doSHhobWxTeUFOc2JHTEphWStTT0dqbmwvZVZkaDluUkpH?=
 =?utf-8?B?aDgxdTJMb203TStjYzMzTTRpeE1IM1l0WmNZTlh3NDg3OXRubWxmMFk1MTly?=
 =?utf-8?B?Qkpka01IR3l3cHExWHM4cS9GVTdTMHllTHVFcFp2clhwTkZmVDk2NDhLaWhj?=
 =?utf-8?B?NnlmaTlXT2czUXpjVEx1M0JuakUwdlRTZXdtVE1QUTNRMXR4Y25yRUdKb3Jn?=
 =?utf-8?B?ZW5ienZodE1wYjRIUlpxbW9ZNXNvLzdCeEtqaExjME5MMGFjUEtnQ1JFZUdn?=
 =?utf-8?B?RkY3bzRRWjU1RlM0bHdjTkZ2RDEzbGt0cTJwQ2JwR21sMHRVVTcvRG91SzRM?=
 =?utf-8?B?bW1aVkUvbnJmTlN5YmZPQXVnSnVrakpLdlJlRzhOTDkzU1hnenNTaHdXZEVp?=
 =?utf-8?B?eEFUQ2IvWGx3UnZNNDcvdnNkajdFeEJRcUdMcFBkQzRwWVdsNHg4eVFoVFFY?=
 =?utf-8?B?cFluUE5JQXVPWFprczMwUkQ3NGVEb3ZvcHIyVk4xU2hjZWRBRHhwVmpIYkJY?=
 =?utf-8?B?UkdJMmF2WUMwSVNWczZmMThqUFAwS2NDVExJK1g3T3k2dzNjWWlaeDlZY2cy?=
 =?utf-8?B?ZytyZDN3WkZJb1VucEMvWE1FVHJZNEMrVlhJbnFUOTZSUXRhY0tVa2FML05T?=
 =?utf-8?B?UTk1Y3YvZ0h5NXNqbEVQQVpwUGx4bUtNV3BKQ1RIR2E5VGNZWFlkWEd1TnQ2?=
 =?utf-8?B?YkpuM281cUFkWmVtdUFveEh3YjExei9ZVitQTWVsV1Z3cWZDeGFoWjJQWDdi?=
 =?utf-8?B?RWtvNjA1bnVHN2lxT1FzNzFsNzFleERveTJWd3NRc2ZxTGNCMmFrd2pPYjB0?=
 =?utf-8?B?YjZXYTZiU2NzbW8xazllOGlZM0FZR3pKaU96dXVkSjlwZ21wNUxsamI4dXE2?=
 =?utf-8?B?TlEvRWtpUTFBNUlWZ05nMWdCUStnUUhrNzdjaHR0OWFONFpkWDNHb3I4czBr?=
 =?utf-8?B?Zkl1dFV2QWpVNmd5Y3V3bDNBdTdvYkxBcm1KL0JHSDVaVzRRdGVTS0QyMkxj?=
 =?utf-8?B?SG5vYTR3NnNDaGVOak9DTGtYTy8rU3JlOVNscExqaXUyRXplNDFSUUZIUXF5?=
 =?utf-8?B?bW5ybkQyL0JoL1lPYnhRTkl3VExIcjU0eG9Obi9pNWcwem02TmZBZVUvaUJz?=
 =?utf-8?B?NTRJbGFEMVFQbzNWb3VQK3oybmVKQXNsZE1FNFUwZCtLY0owU0J1RnNOcUpG?=
 =?utf-8?B?djJDVkN1L0tSaTZhTlY2bDh6UEZhbFF2UFNYL1hMcjdseUdJOEpvREpQeFJ4?=
 =?utf-8?B?MEd4V0IzRDJqbFZWZjNqc0krV0FFZmtHTU8wU3N1YU11S1N2MittSEs4bGNy?=
 =?utf-8?B?SnV2MGQ3Tm1uZ1JqMEI2cFVHdmJQTXZTZkEzRDlDMVJKc0VYZDhUS3h6Ukcz?=
 =?utf-8?B?MWpGcHRFRDJBcm1XcytGUXhrandSeFhPM2JIY1d0RGtoRVhoTjZUZ21NS1M1?=
 =?utf-8?B?S0hob2ZyNjE0YjZnaXU4eGhTb0FPRGtlaEVncUdWNmJUTWpWYmh3bDdQcWZa?=
 =?utf-8?B?Z3U1NUVCN0szVUl6aHBoN3RGK0ZUc0VyTzcyS3Q3QWhNTFRDSnV6dzFvTDNs?=
 =?utf-8?B?L3pEZC85K1I5eG10Z2pyVTZXSjZjeEZ6RjRhRFV5cGxCTVZZKzdmT2grdXZG?=
 =?utf-8?B?eG5KRUlHQXkvWVViSXl5eVRScTdDaXA4UjJxWjU5dm0yUmZKTi8vQ3lYb1lm?=
 =?utf-8?B?TzBPNWFoNVBldUhJWUpkMWJKekZLYitDVk1xS1N2bUhYaDd4TFFHNHB2WHVx?=
 =?utf-8?B?bzc0bjJTcFY1MXhnSy9hYjNROFdnOHZvQWlScmd0bkJrTWdzVnlJNXB4dGpv?=
 =?utf-8?B?dHdFMVAyT0ViMlVYSUlGOTdENzMzcmlYbDBCcExpN1hVV3QvWjgwY1AvTGpi?=
 =?utf-8?B?d2NwOHA2d3BGVVViTVFRbFRZY3VBR3QzUnBnOVZ3T0x5bjJpczl2elBmWFVH?=
 =?utf-8?B?RGNrYmxwZ1dkdkxLTFE5MThlQmVpWlZYRXNaWEpIZVI1YmpPbEFCeU92OUNh?=
 =?utf-8?B?Q2xWS0c3QlZyamdwRXA4YnE2UXhkWWVHczFCU2tNNk1hdUp6Um5CZXlIckNu?=
 =?utf-8?B?NHBBTG1pb0IwUmJBbTI1a1ZnVUxlUG9jMHJvc3JoZHE5WFNoQXBIbmljekxs?=
 =?utf-8?Q?aHyGXBkrIXGCcqMgYzZXXYUiv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39ed3f84-b20d-4a48-af80-08dafc5bc18c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5629.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2023 09:33:44.8447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wp/Z6bAjcer2SFFqAlIHI2vaNYi3j70bZ0Q2r4qw0sv8eKswhhRIQH2Q8OzTPuoBNRBt5aBpVHUPOJ1IbvA/Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7070
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20/01/2023 13:54, Edward Cree wrote:
> On 17/01/2023 13:40, Jamal Hadi Salim wrote:
>> I agree that with your patch it will be operationally simpler. I hope other
>> vendors will be able to use this feature (and the only reason i am saying
>> this is because you are making core tc changes).
> FTR at AMD/sfc we wouldn't use this as our HW has all action execution after
>   all match stages in the pipeline (excepting actions that only control match
>   behaviour, i.e. ct lookup), so users on ef100 HW (and I'd imagine probably
>   some other vendors' products too) would still need to rewrite their rules
>   with skbmark.
> I mention this because this feature / patch series disconcerts me.  I wasn't
>   even really happy about the 'miss to chain' feature, but even more so 'miss
>   to action' feels like it makes the TC-driver offload interface more complex
>   than it really ought to be.
> Especially because the behaviour in some cases is already weird even with a
>   fully offloadable rule; consider a match-all filter with 'action vlan push'
>   and no further actions (specifically no redirect).  AIUI the HW will push
>   the vlan, then deliver to the default destination (e.g. repr if the packet
>   came from a VF), at which point TC SW will apply the same rule and perform
>   the vlan push again, leading (incorrectly) to a double-tagged packet.



If I understand correctly, a "action vlan push" which in SW would return 
OK to end classification or CONTINUE to continue to next prio (not sure 
what the default for this action is), then we don't offload such rules, 
as we require a endpoint (goto/drop/mirred), but if we did, I guess we 
would have used this series to point to end of the last run action list 
continuing as software would (returning OK or CONTINUE in the right 
context) or not do the vlan push and jump right before it saving having 
to match again. This might need a small change to allow jumping to the 
end of the action list.

> So it's not really about 'miss', there's a more fundamental issue with how
>   HW offload and the SW path interact.  And I don't think it's possible to
>   guaranteed-remove that issue without a performance cost (skb ext is
>   expensive and we don't want it on *every* RX packet), so users will always
>   need to consider this sort of thing when writing their TC rules.

We have the skb ext only when hardware already did some stuff (offloaded 
something), so what ever it did hopefully pays for using the skb ext, 
and I think this is the case. And of course we strive for full offload 
so this case would be an exception.

> 
> TBH doing an IP address pedit before a CT lookup seems like a fairly
>   contrived use case to me.  Is there a pressing real-world need for it, or
>   are mlx just adding this support because they can?
>  > -ed

Of course, we see when users want to set up stateless NAT outside of 
action CT.

Paul.
