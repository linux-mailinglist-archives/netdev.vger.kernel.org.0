Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E8763B61B
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 00:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234754AbiK1Xpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 18:45:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiK1Xpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 18:45:51 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2086.outbound.protection.outlook.com [40.107.243.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915BA2DA8F
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 15:45:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UeFPES9HPcFUI9IaYm2xVIc7NbhRqFqonz8j7Cc8MMKDj23ZjkP3qwiRNObrfcBHIgbQwDt6lXdMBj8b6C84rtjevajw6bXxUWWpR0NFJqLrwtw1jM7zWC1UkFDPRzr7x414B8lK4J82SjZd2xTeR7YYvTSMKFFofPXH9X1DFtKYzfQj/RMDqwpI3QH+jbh2LLk/emAuDkKpeyK4SlEvvWEdXsAzUHv/KrYeZSpkYEs4F57GAC+9MyoSHmUu6QqE+nwcZQuEXJwCVUxSi6A2oKcja3eicQdmuwBilsQHHczfZvayAAlRsnVZsnSk7zpa7PDTjl4cUCVcKd8LRjev1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0yTj1wTDnsxGus1OPBpACSPKcKqhl0hq9sc7X9fLuXI=;
 b=J7sKIXdSnnI/Uyt9weaHfQErqgffvOwpLk62AnVOycnz7dVDwyXpDsHOz/l4P17WbdkYjKCcnm3CelyyidMzStd++yYuT22cblxH2+NhmnSqq8hjw/8791xgFnp4IAmFb4sg2j1tU/erZ/uV4W/kLrGoRcR85zsgM0R+ulwuL+FSAL2vvEwiEUn9v9lhJPtSQVLrXJ7vSC1pCFQi5TuLSeRp+0A8mRH0Bbv7bsZDi3VXjipF2Jt9T4HnPYMBMRslH/NjuyuC/XfEzq8/95w/IItXkyBGkREqPuwMgLJlJAC/2pPzs6qEOq1QHWgbPb0TfMpVxDPlPPGUHZKj9Ixm0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0yTj1wTDnsxGus1OPBpACSPKcKqhl0hq9sc7X9fLuXI=;
 b=3pUoj9lIHQgPM6UYwTjNsMWCRYsPF5EayJ7hN8beXvI64IFR4UdOgE0scFtezR5DJKAys1o1vO8IuGxX/XTpk7L9nXuU5hjBJFvYtMFk0SAp78TfLNytgRvW/gXrpHUeqEn8vjVMlPyrqNPyV3WQUvsy6oGEUZ/J4aPGNyIuOi8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 SA0PR12MB4365.namprd12.prod.outlook.com (2603:10b6:806:96::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Mon, 28 Nov 2022 23:45:48 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::6aee:c2b3:2eb1:7c7b%6]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 23:45:47 +0000
Message-ID: <2acf60f9-1ce0-4853-7b99-58c890627259@amd.com>
Date:   Mon, 28 Nov 2022 15:45:45 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [RFC PATCH net-next 06/19] pds_core: add FW update feature to
 devlink
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, drivers@pensando.io,
        Jacob Keller <jacob.e.keller@intel.com>
References: <20221118225656.48309-1-snelson@pensando.io>
 <20221118225656.48309-7-snelson@pensando.io>
 <20221128102709.444e3724@kernel.org>
 <11905a1a-4559-1e44-59ea-3a02f924419b@amd.com>
 <20221128153315.11535ddd@kernel.org>
Content-Language: en-US
From:   Shannon Nelson <shnelson@amd.com>
In-Reply-To: <20221128153315.11535ddd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29)
 To DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|SA0PR12MB4365:EE_
X-MS-Office365-Filtering-Correlation-Id: 259464ef-ad8d-4fe3-0c02-08dad19aac85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GaDmEnm4qCqW6GBggHOxPrw30N23LKXtKpqnj9gOHaaJBOMbpET32aI75ioTa6jwCsABdSNNV23fmGLkSIwMDfM3LZqPI5/HSHizubQtD8UYFM5g+brr/wGU3mopl637kaV2xgFwLRViGtAA129Ai8FtgQuf8Jt84mUP2XRTpaZp9k4LAfWiBPeHQc5FpLGYsGCdUEOZzRNXamS7TxfA41pEa18UKjIOGMxjHJXfF2qRTcBD9pvxYYyiTLgcpDe+PMgof0LZ9bMDPL9wZ15gvAcAT8Uk8xKTz+baDGmbJC3ZiPWNxgKpQxx2GThvPVr5NLGKWOcJywNnAaE7pR44o80Qoki9TsJv+pazDIH0SVSrqrx9Wo4MiseqQ/iQkHVr5GrIOHIZ/GtfuAJp4kmpsX+DqAUCiXkCQuIbxqcPqZs62UVy5vRcMZT/4QQQLDgxvVaOTHm6owNQlHcLqbBvIzzkMJ1gDf3BRbGqXQShVPY3Nc0CF1vRv27h0c4rfeMjb5HitB2taTWITUC1ISPo6HTI3RR/L69xw7oniRo2BH6pNHD7FEmkQdGQaHvfOaavTLsZ2gx854JO0pEr0mLl0aECj+6WKAFByH4NXgsaJgIdy3cgTQeQEGttNU4qc5kF6on8biOAA7JkFJip5ed3j7KW/pO5b3//yTv/Qpp3cEvRjo6nRFtni2wR92hovhA1TGm4+FfQNb3a/1C2b3yxSzAa3Wf4JHt+CB4sB3lCOkQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(366004)(136003)(346002)(39860400002)(451199015)(6486002)(478600001)(316002)(6916009)(2906002)(4326008)(8676002)(66476007)(66556008)(66946007)(54906003)(38100700002)(6512007)(26005)(2616005)(6506007)(53546011)(31696002)(83380400001)(186003)(5660300002)(8936002)(15650500001)(41300700001)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YlZFUXJmUmIreXRZTW1KS0RJR1pKdmRGMWlHQ01nYlFhQW4yNmxoZjlvVUhu?=
 =?utf-8?B?SW5GZkIrRXJLTXNFSlRtaHRrR2NhT1kwVDdnZlEvUFZhbkFXZVBKM1drYUNZ?=
 =?utf-8?B?dEdVMGJhcXlJb0xsbkRHMzZJZFpWMnVqa3U1czNkM2hMSzc0dW9kVkJ3QklR?=
 =?utf-8?B?dHBjdHIyUHBrc1hmak1pR3hCa3lxMGV3bzRKK3NxbVo0V1FQQVpSRHRuQ0hs?=
 =?utf-8?B?MmxkeGJBZFVSUWthL3BLWTRZK29nZWpzcGxWZ2dsckxNV2pkeEVxL1dFRVRG?=
 =?utf-8?B?R1NoNDhKeUFlVmtvQjZpdEhIT2xpL0ZVYWVVRmZNc2tIU0dDQ1RkcjRjeGxr?=
 =?utf-8?B?MXVZZThraVpyMFVBSTMvMjZZMHJEZHR2V2ZPVXp0ZG56MUt2eC80TW9VVEJn?=
 =?utf-8?B?eWdrT1RoY1NCNmNweDVMWERrYUIzeXRxYUt2bmdqckI4R3BmZlVxaElubTVt?=
 =?utf-8?B?cFA5bzJuL2h3TkI5WWJ6VnA5SnVhTFMrRDlxZTArUWpPM0Uzbit6T1AybXh0?=
 =?utf-8?B?ejR5eDRhTEdjUHp0dk1xdTBQbGZoa3JoMDhkSTQyU3AvSjBuUEg2WCs4ZElt?=
 =?utf-8?B?OUxjeVdjUmx0bFdiUStjQkZxMWZkS3hZd0pJaGZKTnErellGOUhVajRPUjV0?=
 =?utf-8?B?ZkdwQU96V1V6dDRGS3AyYWNrbEVwWE5GT1IxVnNkTFU4TDB6S2dwTmRvY1RY?=
 =?utf-8?B?eEtUUzJHQlo3N3N0RytyMmZCRnorRlA4RTdXQWZaV2hJek4xWmxzZXZSL3M2?=
 =?utf-8?B?N0dja0VpTi8yQTJ0aW5lRFlqNVlXQmh5M3RRMEIrTEw3c3gvc05xT2RNRHhS?=
 =?utf-8?B?dWZ0UlJWQVAzMk1ka3E5QndSZ1NaOGkrc3pBRzhvWFBJV04vL3ZydEluelVF?=
 =?utf-8?B?dngvRUlRczVrbjFmbFVnRDhFQiszR3RpSmhjeXJucVVERHY3bmY0b2ROTEZt?=
 =?utf-8?B?cXh0RE5IbTBQQ2hoQ3pLZ0dtSXVhaFBLWS80NG9qRXB3R2lpRDlDckM5QzMz?=
 =?utf-8?B?Q2pQWXFCVlJ1YkFsOGFWSWQzdFN5Zk1ReUVwUWJCRXlQNEMvY3JIYkJjaVA3?=
 =?utf-8?B?eE51a0hxMWgrK0hORE0rcG8yRzJ3NHdUTHNwS1Baa2dteW42RFBjWGF2R3NG?=
 =?utf-8?B?YnVCRng5WU5HcnIydVRaSWxFdytKUUFsdVoxV0tFVHBWYTRRNWdiWjFORElm?=
 =?utf-8?B?M0dIblE1a0FxTkVWQXVOaDVyNldzVzFzYVBjSVM5NjlRaE9ZSG1abzVlQ2U4?=
 =?utf-8?B?WUJZRXhFdGpoWDNnTEdyUFJRdlFwN1JQVG9Ha2J6SGhsdmJ2ODdZV2lVOFBj?=
 =?utf-8?B?cUZ6cENwVlhqRXg5SWNvL3hyNlF5QWNIN3ZRYkxzNHpzWmNGaVFvdU9aMGtD?=
 =?utf-8?B?V3NybjBpV1lwbTJORk04b09KNHZyYXVhSTU1dHhPMGVSRkhrY1NTOTJuS05B?=
 =?utf-8?B?QWk1dDRhdFdyODc4clpsZDBVb3VCbnQyMWtRUU80c3hNQnM3Nmxzd1UzMk1T?=
 =?utf-8?B?UzlHUDJQci9vY1lCMDZUY1crSW1hYnZqRGNucWRNN3dXUGZRZkRNazIvbExN?=
 =?utf-8?B?TEdjbUxvdGovT3JIRnhWTkx6MGpoZVU0Q1hkM3FoS1haNjN4Z2UrMGRmZWtr?=
 =?utf-8?B?MmRzWjArdHdLaWNvVFpqZlVmVXJONktBYXUxbElrdEM3TG14bzhFMlNGMHRX?=
 =?utf-8?B?M2VaWjRtdGl0MncyMnJlQ3l6Y1N6anduTDNvUVVTZ3FTenBHSlUwNkprT2J5?=
 =?utf-8?B?YTFmM1dSREJSS1p4eVZCQ1NEYlNqOXVhOElmczdWUjZycnMzOWdPRXpmcWFY?=
 =?utf-8?B?QlUxV3dQaXRRMElKa2w2eXAxbXNGQ290WW0zYy9LNzhVaDduSkV2S1hMMXVw?=
 =?utf-8?B?T3hMQzMyeVVBbDBSOVBTYklVd0dqOG1xK1ZaUmVuNHFlRkptSjZMcjdhSkVV?=
 =?utf-8?B?MXJ1OGhqelppR05XWThUbUZqbFhaaVFsQ1h4djB3R1pDUkZObDdyOWNWQ0NL?=
 =?utf-8?B?dytUZDZySTE1TXdjUjBWcVhOczBmWGZTcFhlSmJBUzJ4OEJxNDRRODFlNWJZ?=
 =?utf-8?B?aHdUeGFTZC9EamhCMGFsY2c1YWd1WFJQMFBCVlc4aTZFQ0I4QmdydGQvTXg0?=
 =?utf-8?Q?l91tK2BmFrjgzQbP3CqUdkHK2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 259464ef-ad8d-4fe3-0c02-08dad19aac85
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 23:45:47.7009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: saZKR+bnpzCKfaGOUnN4QbHKCozwgst2sr73FWg8AWoigI2rFwGyk/ld8ZQK5rS++J+WwFcr62rxXn+JUOubmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4365
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/28/22 3:33 PM, Jakub Kicinski wrote:
> On Mon, 28 Nov 2022 14:25:46 -0800 Shannon Nelson wrote:
>> I don't think Intel selects which FW image to boot, but it looks like
>> mlxsw and nfp use the PARAM_GENERIC_FW_LOAD_POLICY to select between
>> DRIVER, FLASH, or DISK.  Shall I add a couple of generic SLOT_x items to
>> the enum devlink_param_fw_load_policy_value and use this API?  For example:
>>
>>        DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_SLOT_0,
>>        DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_SLOT_1,
>>        DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_SLOT_2,
>>        DEVLINK_PARAM_FW_LOAD_POLICY_VALUE_SLOT_3,
> 
> Not the worst idea, although I presume normal FW flashing should switch
> between slots to activate the new image by default? Which means the
> action of fw flashing would alter the policy set by the user. A little
> awkward from an API purist standpoint.

Yes, the action of flashing will set the new bank/slot to use on the 
next boot.  However, we have the ability to select from multiple valid 
images and we want to pass this flexibility to the user rather than 
force them to go through a whole flash sequence just to get to the other 
bank.

> 
> I'd just expose the active "bank" via netlink directly.
> 
>> I could then modify the devlink dev info printed to refer to fw_slot_0,
>> fw.slot_1, and fw.slot_2 instead of our vendor specific names.
> 
> Jake, didn't you have a similar capability in ice?
> 
> Knowing my memory I may have acquiesced to something in another driver
> already. That said - I think it's cleaner if we just list the stored
> versions per bank, no?

We are listing the stored images in the devlink dev info output, just 
want to let the user choose which of those valid images to use next.

Cheers,
sln
