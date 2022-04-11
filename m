Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F10AE4FC3D2
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 20:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241201AbiDKSKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 14:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbiDKSKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 14:10:43 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2076.outbound.protection.outlook.com [40.107.236.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDBA37BEB
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 11:08:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oeXg5emTVXYlh7r/dBLvJ4S4i9FWCeoZ/kzdo8I8F8hl37j17B3t6fc/LW3NS2pirbpSxQRvNSAQu4rCbxcO+PSzSTkDXQ+XX50Tc58XEpFX34g+z3RqPcqJprWLqylmRsR1/4sQWLkQNuWgzcirevj6dROg/hdBSh6Se587aaj3XwxJPtk6+xzxDYG85uDlOE2E5E0E3rF2sRYg4Paha3tTMJeqbquu6EMMOcF+wkRtZEh/dDzN0saVVyGNvEXe3SuQr5vVxSW6ACVUoTs7ZJ1vWyAmvXaot6KKF4h2S+nIKcui4v6cj3EOxSGDhvcTtU4nAzdT4eevioc3LtRN7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D3ifepJvvOhIUOVKzY5WeM1MuNI5WgIPIJtvqT9dx3g=;
 b=Cd61vNFYYhNqZOYpIBvlqQfLVi7/al31E4mGZ3L9xt06U7uJsBW8raaQ2E3RRKaWJHFPLJej17HNM59opHof0i+x9e05iPx0hrthwbqhKN2X7gsX5E9aJWWkhht07+Al0yXrd6nfCHw+1HVQ9aW3jIP7bc5c4aJxwGy8/fJYlKyqgkXPgpCigpe9gtjRA00H3nOdCTetAR1u5kIoKJwnutGN32adiRmosHvhhdmIl179g+Jpw+dUY5AmiF9y4QugO7sAby3NFWXRK/A3/t4KWJVAnmGu2Ux1ftKtpT21wpiq3snN2gIvkwtBlLP24BfHQLmxSKb0feQHhCDbxzwgTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D3ifepJvvOhIUOVKzY5WeM1MuNI5WgIPIJtvqT9dx3g=;
 b=EsWtSDQZG2aeMwtH8j28T2X7YvLRcZzNx7uE1J35m2XTmIg13cNykpkJeCrLmy5pE4j7wjWz+u2eKWt4aiXpep0R8i/nQxGIEBDTLNxQkXqyCSUCS8NC2v+U9YhOd9rIGLlHBzl/dc73z3tq4Cz9+/piybbbEWczBhmuJ+dZ6RwOo/vuP3eA3fdU2bw18zlUxVW0BspD0D4oae5oaY01OPv/RTfjhb/H0s2929BKPbuz1W/2CBgI9kAQTzG1b7wK/TtNVxjmu8OZyPGVODvmseq6cMZzqAkffS/wlB5XQeyB50dAa8/thdoOvZc9oZOlnp4ttdAAjWJu0fAwLkJeDg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
 by MN2PR12MB4471.namprd12.prod.outlook.com (2603:10b6:208:26f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 18:08:27 +0000
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::3887:c9c8:b2de:fe5f]) by SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::3887:c9c8:b2de:fe5f%6]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 18:08:27 +0000
Message-ID: <0d08b6ce-53bb-bffa-4f04-ede9bfc8ab63@nvidia.com>
Date:   Mon, 11 Apr 2022 11:08:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v2 0/8] net: bridge: add flush filtering support
Content-Language: en-US
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     idosch@idosch.org, kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org
References: <20220411172934.1813604-1-razor@blackwall.org>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <20220411172934.1813604-1-razor@blackwall.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0059.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::34) To SJ0PR12MB5504.namprd12.prod.outlook.com
 (2603:10b6:a03:3ad::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ffb365e0-f048-4a34-00d7-08da1be646c3
X-MS-TrafficTypeDiagnostic: MN2PR12MB4471:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB447124E426F1A2FD7BC67DF5CBEA9@MN2PR12MB4471.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J57O1Ma1xoeAcsVufmk9z6knuthbC7mpj8fWc9ymbHZSg8Hl/tV2w5Vu4h+ufHCBaY900u4CJc3gclJqDApYcu7Do3LSRJkSmPejLX4bsQ/FDgZd9xPAjehS24FJlv9Ol5CmKnP08/jE+l04T/6bOv8SlSoIcwX9kkP/pQhDqDGUB0nw1NoXYLPoG82uJDEVrFghtgGfwz2ibQzC/xP83aHj4w7uSWUcrU9TSsO9J+VnAgiG5xkTOPPsp1GAUtcNg0BUggVp10XQEGeKXzhG4dS/5iRY7Sh7V0PEGfi/FvuHVmfaY+rD3gqSTLD0oo63da+ea+he4vDf/cMu3M2YI7sl0yDYcbo4uTWv5SLxAoccbai2BVv95vI9cmks+TG1UmKWu3Vg387PeVqV1K79x9FoZiUEGeE/OZ1SPg/XQzmGDGPTj5rK1UiHwrp4FuRMbwLWlDxKW101stFbLXOXEGeSVgDv1VrLyF/kRFhGBi7copruOx/YIoKH1MAJx3tLoq6Kqd4kFfoNv/FzG0czJcwyfgACdGdXdcgLP+pLcLseKWz6L7D4tCr5cMBQOevvt8GwNbUoVd8tU0GRCQbU7uD2jUj7e3iX9w0sTMjNcheyEcLwaSUjiEs2DbqwDBAghZ9RUWCt4VogobohDQalxG8wkGf4xaKJYoc78vG0BRmFt2DfrtgSD23hPCSjxGJ5iy5IOohC1ZEH1EyfOnFUTGmX3+cWwf5yuL0WCqtTsVc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(2616005)(83380400001)(86362001)(31686004)(26005)(31696002)(2906002)(8936002)(36756003)(53546011)(6506007)(6666004)(6512007)(316002)(5660300002)(6486002)(4326008)(66946007)(38100700002)(66476007)(66556008)(508600001)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UWQrVVh1WUd6clQ0UXZ5WHBEVURlNXlsVm5WWHloWnhtRFdtemsyc1U4TlAy?=
 =?utf-8?B?YTQ0a2FKMFUxeEtuby82OGVNYWJ5U25GMXhDM0cybnJ4TWcyeDZUck5PYmFp?=
 =?utf-8?B?c0R2Yml5ZEVkRC9KVm8xN1l6TmxzSWRpVFR1OUcvU0l2SlM0aUY4dGJwb2pJ?=
 =?utf-8?B?YzNCWkp3LzMvdlVjc3ZIT1ljV0FibnJ6OVRMN0owaGVsVnpjemRUZGR2UWpj?=
 =?utf-8?B?V2d1S3NjNjlzSTZ1TjNubC9JU0VlUlpHS2djRm9RVFBNcmFTUVRwQUJPakE4?=
 =?utf-8?B?aHYrbFQza1dzckdEVFJBK1lsNmRHN2xVU1ZxRldpKzQrNkQ1aE9qcndQa21v?=
 =?utf-8?B?S0FXeEdkUEVtL2hxRTQrUTNSYlFwUHdNbHA1Y0hLMkFQYlpkd1lYTEpNMXAz?=
 =?utf-8?B?VXdJMUNzSzE5T3l0bkw2TWdMelkyVG5VYU16bnpnV2YvQ2l1N01YeVd1NHA5?=
 =?utf-8?B?cGFLd0tXQ1R2N1BMblJiSUorUmdlQmhlU001eURITU9aV3RCNlY1U1ZMTUVq?=
 =?utf-8?B?RDMzTjAvaTN2ckJPWGU5a1hHLzFqdkJGdE96aG90MkRZaGJVSlg4U0Q3WWlZ?=
 =?utf-8?B?R1JBWmh0UlNycUM4aG90T2hUcTBmSCthMGRDRUlOQmVtazFjRER2MFRiVUVx?=
 =?utf-8?B?Z2M1WVM3RDI1bTdXK2dmYTFMcWVOZUVndjYzQmE5N3hKQmV6SHh5ZTJpVkdz?=
 =?utf-8?B?TDFKSm5yODVVM1ZPdDBxdHlyUlgwNSswNGZwSjY3Y2F4VFdkQi80Vm5JTG8r?=
 =?utf-8?B?V3g4ZFRwQVluSUxkU0FPYWpRTlN4WU1neG5uYzUzWCt3Tmh0TmtVMEg3NkRE?=
 =?utf-8?B?bVhjZTlMTEVHTEtPT0w2bDZwK1k0TDZ3cUVWYTh0YjhzZ3l2VVZtdUVjd3hK?=
 =?utf-8?B?YkxyNlhRRTNRT1BZTlI2VnY2bU9pVjVGNVVXcEYrSXJ3a3liZjF6WHNrdHQ1?=
 =?utf-8?B?dmlZVGpwY0ZxTlE3ODFNVk9qY05jNXpvZkEzMHoraElweEJkc0RBZjAzRXNk?=
 =?utf-8?B?Y3M0UHYwTTc0QTlLbHdMZy96WjdoQXdvc3c5M0U1dzREeTlqdWdaajR0b3hQ?=
 =?utf-8?B?MVFBRHkvYUNZclhCTyt1YjFERTZWaldGcTRsbGx4cDZJK3c3UmdLd1h0QStJ?=
 =?utf-8?B?eHVCNVVWazExREtsNkNzRElaZWkxYXZWVHJoK3Iwbm0vUitYNmliUjJsODlC?=
 =?utf-8?B?MjlZVjVFODJZZlAxMmtUalJDbGk0dFdPM2I4bXBya3pYZVk4cWlUYjMwOXFl?=
 =?utf-8?B?YkIrNUFCbTM4Z1dDTVBvNzhHMXFQcjM5S1l0K0J4OHlXQ3ZLS1JVOWdJUC82?=
 =?utf-8?B?eEFsajVoVElzN29PemJWd2RGeXVWSmtBN1ZscWlRd3JUcFRFdUI3YWR2YTJX?=
 =?utf-8?B?aFRCZ1kxWWZXRjBRakZydEQ5bkZhRXpNYUxya3JpK0I5UUlpV0tlbHV0T003?=
 =?utf-8?B?TVFrS08vRnVrMGh5TzZJaGhGOWEwazFDeEdzNy92NXpJRi9FT09wRWYreXNr?=
 =?utf-8?B?QlBUOEdvRTJrSEljODlhdGt4SVUrVy91ZGtkOU5lVllxVXRVVzRwNDRVcGc3?=
 =?utf-8?B?Mi9mUU5ZNXB6dkJDMHJnSVNTb2d4TmpnQTRPWXV5SjA1VExXRU9WbUx4STU1?=
 =?utf-8?B?K0hjUFV5RmFteHF6anArdEUrNkJLcG1SUDh3NDdmZDhsRU45UTZHQUFDMW1x?=
 =?utf-8?B?Z3JMSGMzTlo1cDd3L0xwcFRaMkV2Z3QvRTZGTU9EbDN2WVJYSUtBR2txSUV1?=
 =?utf-8?B?Qit1RTg3OU5FZGc0TVZVQTJoSGt5NXFKNUZhZHBJbUNoYzhDd2hZTjNkRjM1?=
 =?utf-8?B?Q3YybzNNN3J0TnpSSDVsOURHc2tPak9UajJtamJNRHlPVEQwVVB1cmU1aFY4?=
 =?utf-8?B?eS90eHZIMXBWYWpKRTVHNHptRVhwUEJVWmFZN1dyV254cElxYWgwOHJETXUw?=
 =?utf-8?B?NVQ4cGFKTCt1K0NOQTVRbGZ6V1BwMmFzQnN2Q1V3KzVXR0o0OTMxbnBEMXlC?=
 =?utf-8?B?WVJ6cmRwQi9NYUxQMlQ1VzFLMUhZNkNYTEZSREo5NDB6Q1A2WllOem1mSmsz?=
 =?utf-8?B?OFRHemh0cHpHZkZoNlpFcjYxVzcyRms4eUIxSXRBb0l0aDIwUkFwaGd5V1Jz?=
 =?utf-8?B?eGZJRXUvczdOaDdwbWtteE44TS9sdHBkakx6dWl0MDdXM1d0Qmd5S0RSOERZ?=
 =?utf-8?B?WDJQeHY3WE16OFpHNm1TaDIrRUFpNFg5K25WZ21ZcmFaaVpsaW1NRWwxQ1NU?=
 =?utf-8?B?S0xKdk5zSzBaSXpzMzgxRkFkT2IyUVVQTlVIR2VWMWVNL3JXaUYrVnFMN1Rw?=
 =?utf-8?B?YVE3ZXk0NkFOWTduOUNvS2FqekpUMSs3Si9BSHRyckNoTWRwUzJrQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffb365e0-f048-4a34-00d7-08da1be646c3
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 18:08:27.0910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MqB0Bt6NVizjNlXt54/HI+nBFHv2bKXcQFa2b9OPwdbuB+mVNhuEKF2F+5PvRQrI9wFqa+7MoNfFEbI2IDjEOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4471
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/11/22 10:29, Nikolay Aleksandrov wrote:
> Hi,
> This patch-set adds support to specify filtering conditions for a flush
> operation. This version has entirely different entry point (v1 had
> bridge-specific IFLA attribute, here I add new RTM_FLUSHNEIGH msg and
> netdev ndo_fdb_flush op) so I'll give a new overview altogether.
> After me and Ido discussed the feature offlist, we agreed that it would
> be best to add a new generic RTM_FLUSHNEIGH with a new ndo_fdb_flush
> callback which can be re-used for other drivers (e.g. vxlan).
> Patch 01 adds the new RTM_FLUSHNEIGH type, patch 02 then adds the
> new ndo_fdb_flush call. With this structure we need to add a generic
> rtnl_fdb_flush which will be used to do basic attribute validation and
> dispatch the call to the appropriate device based on the NTF_USE/MASTER
> flags (patch 03). Patch 04 then adds some common flush attributes which
> are used by the bridge and vxlan drivers (target ifindex, vlan id, ndm
> flags/state masks) with basic attribute validation, further validation
> can be done by the implementers of the ndo callback. Patch 05 adds a
> minimal ndo_fdb_flush to the bridge driver, it uses the current
> br_fdb_flush implementation to flush all entries similar to existing
> calls. Patch 06 adds filtering support to the new bridge flush op which
> supports target ifindex (port or bridge), vlan id and flags/state mask.
> Patch 07 converts ndm state/flags and their masks to bridge-private flags
> and fills them in the filter descriptor for matching. Finally patch 08
> fills in the target ifindex (after validating it) and vlan id (already
> validated by rtnl_fdb_flush) for matching. Flush filtering is needed
> because user-space applications need a quick way to delete only a
> specific set of entries, e.g. mlag implementations need a way to flush only
> dynamic entries excluding externally learned ones or only externally
> learned ones without static entries etc. Also apps usually want to target
> only a specific vlan or port/vlan combination. The current 2 flush
> operations (per port and bridge-wide) are not extensible and cannot
> provide such filtering.
>
> I decided against embedding new attrs into the old flush attributes for
> multiple reasons - proper error handling on unsupported attributes,
> older kernels silently flushing all, need for a second mechanism to
> signal that the attribute should be parsed (e.g. using boolopts),
> special treatment for permanent entries.
>
> Examples:
> $ bridge fdb flush dev bridge vlan 100 static
> < flush all static entries on vlan 100 >
> $ bridge fdb flush dev bridge vlan 1 dynamic
> < flush all dynamic entries on vlan 1 >
> $ bridge fdb flush dev bridge port ens16 vlan 1 dynamic
> < flush all dynamic entries on port ens16 and vlan 1 >
> $ bridge fdb flush dev ens16 vlan 1 dynamic master
> < as above: flush all dynamic entries on port ens16 and vlan 1 >
> $ bridge fdb flush dev bridge nooffloaded nopermanent self
> < flush all non-offloaded and non-permanent entries >
> $ bridge fdb flush dev bridge static noextern_learn
> < flush all static entries which are not externally learned >
> $ bridge fdb flush dev bridge permanent
> < flush all permanent entries >
> $ bridge fdb flush dev bridge port bridge permanent
> < flush all permanent entries pointing to the bridge itself >
>
> Note that all flags have their negated version (static vs nostatic etc)
> and there are some tricky cases to handle like "static" which in flag
> terms means fdbs that have NUD_NOARP but *not* NUD_PERMANENT, so the
> mask matches on both but we need only NUD_NOARP to be set. That's
> because permanent entries have both set so we can't just match on
> NUD_NOARP. Also note that this flush operation doesn't treat permanent
> entries in a special way (fdb_delete vs fdb_delete_local), it will
> delete them regardless if any port is using them. We can extend the api
> with a flag to do that if needed in the future.
>
> Patch-sets (in order):
>   - Initial flush infra and fdb flush filtering (this set)
>   - iproute2 support
>   - selftests
>
> Future work:
>   - mdb flush support (RTM_FLUSHMDB type)
>
> Thanks to Ido for the great discussion and feedback while working on this.
>
Cant we pile this on to RTM_DELNEIGH with a flush flag ?.

It is a bulk del, and sounds seems similar to the bulk dev del 
discussion on netdev a few months ago (i dont remember how that api 
ended up to be. unless i am misremembering).

neigh subsystem also needs this, curious how this api will work there.

(apologies if you guys already discussed this, did not have time to look 
through all the comments)



