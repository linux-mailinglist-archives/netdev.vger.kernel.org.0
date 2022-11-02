Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A142D6162E6
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 13:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbiKBMot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 08:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiKBMor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 08:44:47 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2049.outbound.protection.outlook.com [40.107.220.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44DA638B8
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 05:44:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lr2yFTZKbv8fYoWAYNU0xwDweqeaG36tiCz7abs9797IVNMM5r0GShIQ8VBdP4XEH6R3x4FZiqPJxtJeT2H8d/cse8p7pOdQNxaYht2Kbqw5hM18+mHaFjT2bZhqConwkxr5H+w3pUmwAQgge5+j1x+cOUftce+g4kT5wugj7EEi3RdVI1rXJzMlv2VVCbrOiEmLp1PTkSPh9m4MDV5i5EpB00rFZ7lxKESC3iaHUf9A/Cd2j+bKqUxkjV3MhrFGQX0aHOdaq3iEvBW5zWs1XQx3PAkwLgGt/7ilnvjHVoZJyOyHpYDFJJgvpytiScvqw8TPwGy5rAEfBBPSPo3FbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8r63N1IPxcP0YVkIKiUPWuKN95Kq9ok4iXby3iDHAwU=;
 b=El8IR9fNiudfT6ogCFpRu674kvveevImkCejBqosmLHNWtXhbA9xF10/TOW0q4AHNnrvMRv49yqnS/Cdc+DfJ+wZmyBS56/sDMwb1bIrgIldRGqaETvqSqiIE9GpOD4bfebB+YtfVCXOVlA+wpYWA+UJVia3+GuS/YFiRWt/L9u+AHvnKOAbEnejgS8ZaUqR23K5HsIN5UdYA1JnGPLXy/zcWE7+q2ov4X3n9Qc5gvXZFl7Jw8QbJ3uzRvIY+4Yvo97HkfnxIP6u9DKyoiK1/CDU4JXMalH4ZhXpD06vWcNFeKQS7ko5dm2SYV77JprJ5Ulv2BUPTw5wAua6zdXf2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8r63N1IPxcP0YVkIKiUPWuKN95Kq9ok4iXby3iDHAwU=;
 b=NetatcVexRgzNzyHrI7maa6vzxnlvGIMEKU8N+6kqD4L1qKuBHGW37vSO5Wg0AtJHnwzBv5O2vgjqlFEFVNAkK7SD1GwMgKj9oLXMyN9c/YiI99pj9y1hVFwQ8fh92CYhSlq2JmLzgJn5jvCy/M9SL38GzIuqJpak16HkiWOasTL+CzsCMWS+pFa+OjxCT3r2ZalEou9mEq5cRGKQulEpc3IllvsS1d0f9YMGFW2fPkAlHEKdg1n4OkanbZLobrPywF5WteQoH4iV2pPxCODzVD8Vwv4zlz4VWqHUZ9SQPLJTUpFHTZ+XgNIXlEmlfbSYMDvhvDLYlLCcJrh1nvzkw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 CH0PR12MB5266.namprd12.prod.outlook.com (2603:10b6:610:d1::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.22; Wed, 2 Nov 2022 12:44:44 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::fe97:fe7a:9ed0:137c]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::fe97:fe7a:9ed0:137c%3]) with mapi id 15.20.5746.028; Wed, 2 Nov 2022
 12:44:44 +0000
Message-ID: <ceeadd10-51c4-9afb-58b4-ff113b8829b9@nvidia.com>
Date:   Wed, 2 Nov 2022 14:44:36 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH net-next] ethtool: Fail number of channels change when it
 conflicts with rxnfc
Content-Language: en-US
To:     Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
References: <20221031100016.6028-1-gal@nvidia.com>
 <20221031182348.3e8ddb4e@kernel.org>
 <d6068a1d-bf73-950d-749e-70fbbbda489b@intel.com>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <d6068a1d-bf73-950d-749e-70fbbbda489b@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0596.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:295::10) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|CH0PR12MB5266:EE_
X-MS-Office365-Filtering-Correlation-Id: 049828e4-3300-447f-641c-08dabcd004c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iBZOdXCW5jmCF1BaN/SKlkPQYp5ZbczNVcWH2fLX8ZU1KyJUzFAYMQ1/gTY4OvmJ/1CqceFA7q0ox8CDA6qGOV5Gn6qTTZ2jKQefFNnWLsegSsNxPrueyg8Pb/wv6aC9qfb3NUuP1FBcZLXhz7DdpZWofFG7NazWaBa/KB0oMEOGiwepV9uXA3hBgr7e+TaPQXdfYJTiHPbW8yoMfGx/mWcahETAU0H7EYTgIluesY8QxBt2mQZda4/IJgCTkZpJzIDtH7lGfF/RcdDn0ss6q+BO5ObrRSQ4ZHgDBzYQNordZVSLvcLWGyWdpqW4RFR3jJ13CMSEEo9q0lWdEhoCFD8AACSfuHtMVEveNnLmGQNXU7bJqVgQsNTjs8nX937yVitdj/edYZVuRSH4WPW3OmmEmB3d271GgHoKc7EwD34UGWtbkMntumZ/bHfjjRqvcRt47FtUgXzD9x4InzKUq+dgWdAl/MUncSoTqfKuhH5IS+rxM+F90bDiKSXhy7uDxDNEehvgmDXPKOSFa8yfizD35drN15vynjQ6KuFn8q5b6ebSieORjcVunbkG2YA8gOueVwapqGCPA+7HTFOoTyQY/gZZTuKiw2ohNd16eqJHnevsNZBeeLL9Sd/XZz+uPFsMgCfXEgAOp6tuChHKuoo3uDkn26rKGrkH1Hu/hrntK7dFtLTGt/+I8g24U/7Bq+DoQACAkJawRESkTA6Dt5cKcFCZBcdNm4J5ElBpDX3FIzoGhDSI3LbHuOQj99Xwc++81mPA70+/XQh048HtIgxYli8TbBXGbATodYuOGiOGRlT5xQzaWVgKlDtpW97j
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(376002)(366004)(346002)(451199015)(316002)(54906003)(110136005)(8936002)(5660300002)(36756003)(4326008)(8676002)(66476007)(66946007)(66556008)(86362001)(31696002)(41300700001)(26005)(6512007)(6506007)(53546011)(83380400001)(2616005)(186003)(6486002)(6666004)(38100700002)(107886003)(478600001)(31686004)(2906002)(17423001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VmV5OXByVXU1VndkS1E0K0FYT1ZsVWlVWkFwdmRjN1A0TXBPQ3pmNDBLUEpU?=
 =?utf-8?B?TUt0VTY2UmFWU2lmVno5cjFtQUs4ejEwOFhUeWQzVnpFZksySTFhVk1xNzNK?=
 =?utf-8?B?TDZVSkhFS3A4L0hEZUsyclNNK2tieWlzMVIxZWN4YklKblFSWHVDaHZtVSs2?=
 =?utf-8?B?NTFqMUc1SWgzRlZXMXY4Y25tVDQwVFBQUkk2dzQxOVpFa1BBc3I1N3ExalRS?=
 =?utf-8?B?ZUVWVUZBMWZlQTE4b0VLOXNBRWNyQnpiMEM1YUhRa2U0eUJvUkMrRm9vb2xk?=
 =?utf-8?B?NGNiQVVtLzZoVjY3Z1dVNlJSQ09vYWZmU2wzd1dIdWxxWDVuTTNUZXlnUWNC?=
 =?utf-8?B?VEhFbzQyN2xzbjlxUzVXUGhBQWRiUlZ1Qnc0M2tzeVpXb3ozMm91WkxrSkRY?=
 =?utf-8?B?b29jU2FwbVJXSUxPeVduamI1b3NrODRFdkhWanBMK3FoSTNReXJneWlNTEdP?=
 =?utf-8?B?RExLTnBCYkYwNGc5T05sR1hhbTJhQmdGMjJYOXY4cWZiVmJUYUpiUnZOemdT?=
 =?utf-8?B?MFlQZStMSVRnVXJqbEpYd3R3VlFOSHFQL21hMnBzdU5DNUlucW9LOEhHMThp?=
 =?utf-8?B?L3p4ajdpeHdnOFg4OGtYZFNCTlVqU0txTm9NMERsTVBEZHM5VWptNlpiNFQy?=
 =?utf-8?B?N1FHdzFqQWQzZTlJUkJtWkpZY1B4YXpwaHIrRWZPVTNoQy9xNGdDZjBkS1p4?=
 =?utf-8?B?aUZ4OWNkOGYyTytzWXUwazBuUU13eXgzaktjMkh5NnAxYUx0ZXZOY0w5eVh3?=
 =?utf-8?B?MHhhRWRyVnRQbW96SlZuVDk0NTdlS3A3NXAwNGRnVStBZjhYRlFUT0pyZFF5?=
 =?utf-8?B?a1JEQmtUNTI2c3FjdGM3NE8xc0tRMU13a3hGcjhJNkJjcW9zMURpK0FOaWFu?=
 =?utf-8?B?SWxCQTFtcDEvcnNPcUV3NnNjRUo3SE5scFlrY0dYbitDaSt2Nk5sR0JWZzJG?=
 =?utf-8?B?MWpXRm96b2NTSUZDWkJUVjUySDNwWnpYaVF0N3o5Ym5rNnZScW9md0hVK2xy?=
 =?utf-8?B?QzVnd002VTdYTDMxS3Uzc256K2JlVGFEQS9KSUFiTEt2OE5vNW5jK2RLcWJB?=
 =?utf-8?B?ZWQzdjcvQUpScjBMZ3ZnaHhkb2hka2tmaGY2d1RpZ1UyWlYxOWNkYll2MUYz?=
 =?utf-8?B?T2hnSG4wUmMyandEaGZuNHk3WEoxSEtpMk9ILytFOXJCb2REWStNSFVlckdD?=
 =?utf-8?B?eWswaXJxSGJUcmVqY0lZUEZVaGlRQWZZOGh3Nk1jVVEzUmJJYXdERkh0blVY?=
 =?utf-8?B?dnhjYUdwL2ZDOXQ3dHZnV21iUDBFL3k2ZFFMYnRTY2JuKzlCa0pRV0RUcTR3?=
 =?utf-8?B?eUVIQjZxU244MTJoTlZYSkU0RUlRaU5tK0ZFT2ZwVEpNOVZ0aExNT2RmTDE5?=
 =?utf-8?B?N3BMbkk0MVBqa3VXNEhDdXNiYVB5QnhabkpLaWtsMm5YVUpFbnBLZzZLRi8w?=
 =?utf-8?B?WWxjQ0k1RVBOTFdaL2NqcldhUEpNOG1BeS9Sd3pIeXNTU0xUbmpLUFprbHdW?=
 =?utf-8?B?Qm1IRzFNU0JSeFEvY0xVMW1SOStZSDRGZkorT0tLTEwrVXBCQlpoaEJrN051?=
 =?utf-8?B?c3pTczJEcGpBaUhGK0l5ZGVkdVlMa3c1cnNKKy9FbkM2QzMveHRhK3hiM29y?=
 =?utf-8?B?dWNKRHJpU0pZeTNDZjU4Q25XZmRQYnYveExaNHM2RG1zamowWHJFdXROcVRC?=
 =?utf-8?B?bjlZOVg0RE1CUWJyUitqVkhRcll5ODQ5TE4yVUxnUGVOR0V1a21udkZmYkZi?=
 =?utf-8?B?T3pweFJBZWs2Sm9MZG9oSWllWStpY3NWYU1FbWxCMFJROTU5WHNMSGttWHNR?=
 =?utf-8?B?RTdSem1VS3FXMGVyUzBUajd2R3FHdmdZRWhYZ096d1hkblhPcVRkc2NyZHRj?=
 =?utf-8?B?TlRMMjJzb2pZb0Vyc3hlUHpydWdkZWdRWDYxWUZsb1d0SnhpME5xYWdhaE9O?=
 =?utf-8?B?VmhzN25jTEdGUExyQy9kbklUQkp1c2pEK1R6eEQ2YmR4cXAvWHJid0twbVow?=
 =?utf-8?B?UlVSRnJ1MjErMWNCUnFrVmdWN252cGlWSjdYQ3FGSkhMNDlJcjdqaUlrZHFP?=
 =?utf-8?B?RllBaS9yaW15UHpvSXo2Rk52K0kxR3NOT3Z2VjQveno5ejI0b1ZtOS8yM3JO?=
 =?utf-8?Q?5VJKxO1HjZPDNJeWvA6KA4cQu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 049828e4-3300-447f-641c-08dabcd004c9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2022 12:44:44.7904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LFq/I/KLdPXkje/aWnNFyRW1yMYCMHrRe3j0EN5vtsGcKBRlFa7U+qoOuW+sooEa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5266
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/11/2022 18:50, Jacob Keller wrote:
>
>
> On 10/31/2022 6:23 PM, Jakub Kicinski wrote:
>> On Mon, 31 Oct 2022 12:00:16 +0200 Gal Pressman wrote:
>>> Similar to what we do with the hash indirection table [1], when network
>>> flow classification rules are forwarding traffic to channels greater
>>> than the requested number of channels, fail the operation.
>>> Without this, traffic could be directed to channels which no longer
>>> exist (dropped) after changing number of channels.
>>>
>>> [1] commit d4ab4286276f ("ethtool: correctly ensure {GS}CHANNELS
>>> doesn't conflict with GS{RXFH}")
>>
>> Have you made sure there are no magic encodings of queue numbers this
>> would break? I seem to recall some vendors used magic queue values to
>> redirect to VFs before TC and switchdev. If that's the case we'd need
>> to locate the drivers that do that and flag them so we can enforce this
>> only going forward?
>
> I believe these all use the same encoding defined by
> ethtool_get_flow_spec_ring and ethtool_get_flow_spec_vf, at least
> that's what ixgbe uses.
>
> This sets the lower 32 bits as the queue index and the next 8 bits as
> the VF identifier as defined by ETHTOOL_RX_FLOW_SPEC_RING and
> ETHTOOL_RX_FLOW_SPEC_RING_VF.
>
> It looks like this change should just exempt ring_cookie with
> ethtool_get_flow_spec_vf as non-zero?
>
> We maybe ought to mark this whole thing as deprecated now given the
> advances in TC.

Oh, I was not aware of this encoding scheme, shouldn't VF rules be added
on the VF interface?
What is this used for?

How does the PF verify the rules are in range for the VF queues?
Anyway, I'll go ahead and verify that VF == 0 in the if statement.

Thanks for the review!
