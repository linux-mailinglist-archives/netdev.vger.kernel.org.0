Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05AA8695AAC
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 08:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjBNHbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 02:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBNHbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 02:31:20 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C485510C
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 23:31:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a58RLuX+q4kM7DICUGtfqOUeSjHTVDlU6AgBLHoElvIfbR3VrV4dZ++32LOrtc9XhzEW0GVdS67XByOaYH+aTZ0+Ev/ATVEb4eDVeTCBkpobpRfkzYDK9iVBvrYXSRpy46SMC+Eu+CF0liAX/aYvocw5y/nHslNU2cRcRBh6gfQjAn2NYjXiV03xHOlOQjqvvX/bj5fqZJZJ5VuMBTApMbSrpH744vDuMdMQNGBuadFVWf/Yn0IQd+pJWxPHoO2i4C/CrU3f9oyPynnE3EWSadcJTkI4Gf+yNS3Pt+uX66gKd/qo6QoSLlUlEgyW0qnQt1NyoQxSJXr5La2TRyuy8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZR9hACzRs2KUE++tvQCivunTpl2U/U1Xz45fzdv0hgc=;
 b=SkJlTsVveCsR8uxa14JpHV7sYbv1etu7TXw0Ib3Txq+cmD8hl9SMWP5yFnmlfdqMyQMgifraI5ZrQlZQgoMLSEKqSBwXWKdZGlJAychBsk9rfiyXzVZFkXFl4Z1SP6Boc85f3jaayF+/vb7MetgPRb7A2ENg7nh9B2Gl09/trtNL4kKyQ8rriIBSo2aDIkV0FcneCWpwkX+qHTfFmdd9BQJE8CXA62OiH609RKMS9n+b40jWT36njpObuZVzg23x/4PK3USr0ri+Fz9/6NHhMpwE5jaHjgQhmdGxGv9JgBINEtYropZXKCxk4mjvLuZXzlBAwz7euKg/K/LZtIFfxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZR9hACzRs2KUE++tvQCivunTpl2U/U1Xz45fzdv0hgc=;
 b=L7oQ1dIuGOTCa6yeOSCIGPWnLk6F71UqFlhX5z9cnRlqPj43G4AkDpa30qTmrNV15rLr3T0qdBdBpQ866SZhZCjUugTknEfIL+7ladJCkdusayKWBIkBiVZrk4ymchMu5Zw8WeS+5XIuiZB2jJpZrGz3hpP2ABOPYtlb4gMVPjdwRgaZtmPyMnKI5KI02nFjawKwJfgzutuLP8kJ/b8+PIzUaz9hJNK+Nuf5lBlwIQafJU8rlT64SjSAGAW99apudeogBCKECmJ1E9NtiQ2/BTVghLvqsavceiyklaqBzQyzq1pQP+UyCCzLGmansjTPTvFmQF93hfd3j3sMG6eh5A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BN9PR12MB5258.namprd12.prod.outlook.com (2603:10b6:408:11f::20)
 by CH0PR12MB5076.namprd12.prod.outlook.com (2603:10b6:610:e3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Tue, 14 Feb
 2023 07:31:16 +0000
Received: from BN9PR12MB5258.namprd12.prod.outlook.com
 ([fe80::75a7:9c68:f95f:9fff]) by BN9PR12MB5258.namprd12.prod.outlook.com
 ([fe80::75a7:9c68:f95f:9fff%8]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 07:31:16 +0000
Message-ID: <b4300690-f9a3-5de6-08f8-0b3430db7fd8@nvidia.com>
Date:   Tue, 14 Feb 2023 09:31:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [net-next 01/15] net/mlx5: Lag, Let user configure multiport
 eswitch
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
References: <20230210221821.271571-1-saeed@kernel.org>
 <20230210221821.271571-2-saeed@kernel.org>
 <20230210200329.604e485e@kernel.org>
 <db85436e-67a3-4236-dcb5-590cf3c9eafa@nvidia.com>
 <20230213180246.06ae4acd@kernel.org>
Content-Language: en-US
From:   Mark Bloch <mbloch@nvidia.com>
In-Reply-To: <20230213180246.06ae4acd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0029.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::17)
 To BN9PR12MB5258.namprd12.prod.outlook.com (2603:10b6:408:11f::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5258:EE_|CH0PR12MB5076:EE_
X-MS-Office365-Filtering-Correlation-Id: c6df2fad-e0f2-4fde-84f6-08db0e5d7549
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /sh1gggdJeeqXcvzEfW/oDfxZuD2g6rAMbmbpygYo+UI7I8Ij8iMj+CtN3lbIbKHwcA5sTMX2/OI+RV79JVRQhQFTtfBZ/f4FjwvCfbedeyHXIMIibvgk7tUgOUjngyQcd34n9IslPK415s2XGCLlFSleUNzXvrnZRPpDxH7xMnBextbmPo66dFOqA8nn5ybjTroqtpFgb1jxTFtvVf+z3tMJ+ezOFsKaU3tmqzm1SSfIVWZf/kyXMHtlxXwo751THes+0krvT8A160VFV1OeP529wkWMAClp6PQ4JWD+yyNZxcSv6+KZ1XSGkAfEfdNmi5xXnJiHF/AbuLHXHGH53aMdezB2BLNu6O/Kv2LNBO1CeagPWYRpnasTeC4krnbcDZGeZxmEpfcKGhqv9976+8EE0ytD3KIrjegpAbYgIxmo3tTQHrHjLFRVG1VCXtMtipCZ2Xd9XrGm3G/QVEPVN5lQsP8i80muByVO5OywSN8D98WdCzz8rrMTZm38nWfaCAQYIY41Znhqc1whQZrwBwur2oV1SRVcd6H1NC8phae3rj/nWufPeScs0KvafVCHjlUlwpSzpFdTKhF2YsLEs1o+FTUXKngnWEQdwZQw5aHNIhLq+cz2AFERBduiJQJWOxQf5K1bi0+t9fc4tBST5UxAxD3ihjdSS7rQO8vIth8k91CcSN4gTOvFNWibqwwI4zl4WjYaDclS24Qu7n/+mopbrG/0fKKttOTjHALZt8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5258.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(366004)(376002)(39860400002)(136003)(451199018)(6916009)(4326008)(26005)(6506007)(53546011)(54906003)(31696002)(6486002)(186003)(8936002)(38100700002)(6512007)(316002)(6666004)(107886003)(478600001)(8676002)(86362001)(5660300002)(83380400001)(36756003)(41300700001)(66476007)(66946007)(2616005)(66899018)(66556008)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dmJ1UkQrNzcwbVBFMDFSdmExZDFFWHh4YTlvcG4yTzg2c0Y4SzNHczBsVFNl?=
 =?utf-8?B?YldLQS9MNngzQ2FuWDlDS3BOQmFqQnJTR1VsblZaaWVRNjNSS0lUa01mVzBM?=
 =?utf-8?B?WHhXU1k5bzhMcTQ0NzhKdzdwL3VJYmlsMkYyQnV4dkY4T3FmWFcwUVVQZS9h?=
 =?utf-8?B?WjUvSVUzcXFyNTM5MmNOenJ3eERzRlJiYTBnN0VxWGFNVjBRV2lnUUVLVHRY?=
 =?utf-8?B?dWxtVXk2ZjJPYmY2RUtHd3FPTTVPSlB4ZUFZZDBhRnN4Rjh2Sjl1WExhenRt?=
 =?utf-8?B?VlpZYmNmZG1pS1hjc1dEQWtCOWhkWC9OSGlwOFBqYjE5b2p2SFJpZWg4TmJG?=
 =?utf-8?B?NEFlVCtUdll6eE5JU002VHNwQWJxTGtmS1Q3ZVNDdWk4N2RmcHduaHRocG1y?=
 =?utf-8?B?Mk1WRyt0SnZEME5NUXpjcS9KSU5NbzVKdUxadGw0ZlpmSXU1RmhnWnZReWwv?=
 =?utf-8?B?UHVXc3ZJVlVxdklVSy8wQU43ZkZtN0RoSWZURWZRR3czdjdoT2tPbjlJNzla?=
 =?utf-8?B?VHUwMmdOeW5rRk9ndTI0Y0ZYSTNGbHpCeEFldC9tQmxhVisvZzN2T0JOMFpX?=
 =?utf-8?B?dHR3OFc5Rjkvb044bDFYMjBnT0NhL1VxcnRmeEY0MEtLaTEvVGE0cWhjTlYw?=
 =?utf-8?B?bWtwUWRwVEI2eHd2RFYvc2N0Z2tYajQwcjVocUluK1Fvbk8vUWp4cFNCclR1?=
 =?utf-8?B?d24zcVU3bmZuY3RiVllvald5ay9pd0JNZitDcCtGaDZhYTZUV0RIV1kzOXRJ?=
 =?utf-8?B?MW95VzdOVVVKUHBQUTNJZHdEQ2wyMjVhOVVna09iREdWSk9wREExci80NXlB?=
 =?utf-8?B?UHNKOUlaWFRSQzZnWHh5QlpELzdJenBucnhZZUFNMUR6VUh3cEJqeXVERmZa?=
 =?utf-8?B?aWFJcEtHR3dmN3Q0bHZyOTlFaDBGMklWdUdYaHI0bFdXdG56SU52a25vYlFa?=
 =?utf-8?B?aFp4L3hORCtrVXBwZHVuaU5NeFRUN3hSTHNqL2g5SEpwVUhMZHNRYzZ1U2lJ?=
 =?utf-8?B?dTY5eGdNZmZVSmhjUE5vL3RTWm9QVC9LVkdPQ2crWG90YUtja3U0WGI5eENF?=
 =?utf-8?B?ZU1ZQVIwVkVLSHNwMmRLNDFka1ozYnNCWXBCZ3FjZ09uZ2I1ZzFmaUJSSUhO?=
 =?utf-8?B?cnhwWFluekNvNytCRzc3MFhycm5jNG44MXJHNmJWMDhOK1V4ZjhKdmp5aW44?=
 =?utf-8?B?SkJGRUZyTVZZL3hVakJESHFTckdOanZYUzRURUw2UUZNdkRyVU03U21uRmsy?=
 =?utf-8?B?M1BIY25QS2x5SEdTQUR0b2lLWEc1NWQyZ01OTTFNNC9Od0xKSmM2ejdjSGRB?=
 =?utf-8?B?Wk9zcGVVdlZIVVZoS0loQ3ozQzA2czNVb3FPekY5dU5FalZrZnVQN1VYdlk0?=
 =?utf-8?B?TlQzUUJZQmwxTnBaem5VWnNOSnk0Vng4V21VNGJKbU9ETkJkQUZBVHlFMHl3?=
 =?utf-8?B?QkdUNXBxYjcvWFU5bXlCTDVad0wzMjFURDllUklGUlYvRlE4RlNZcnpxcUkv?=
 =?utf-8?B?a05rRk8vVnZJRFF6dFA4SXZoUGxObFBmK2dvcnRENHVPRmptYUswbXZ4RDNm?=
 =?utf-8?B?MzhlNVlmbFY0OEVucElWdG5GZnFjOHBFdnN5Si9pSnFNN1BnT2FmbFRHSjR5?=
 =?utf-8?B?TGlqTjkxKzI3T0h6b1dPTGhDZzZUSUF5d3VXWWYxcWJBT0gyeU1LdkpQQzdQ?=
 =?utf-8?B?MGlXYng4WWhWVXBnbzQ2NVRoLytUM3ZWSWxMbTE4RmFQTWw0eHNSWGVqUldM?=
 =?utf-8?B?clJWVytaWXUvSHdPS2kyV1QvZDhwSWtYUU1hanJxcGZITS8zSVBGSzFjd3BP?=
 =?utf-8?B?MjhkdjhwQmNXYzN1OWQxOFN0TnVMWnBlbStJdVVmckZxMFhRK3ZMVWJsYW9o?=
 =?utf-8?B?dkZMT2tRbXR5M0tWTHFrNWpPVnZNN0lEYVBRSERTQ3VENDVnV25wbkhNOVc5?=
 =?utf-8?B?SFp0WTZKVTJJVFhNOFkxQjNxMmJMQUdzemlyNjB6SFhzdmYwZjZrTWdTU0l3?=
 =?utf-8?B?cnQ5eTRLZndMWUlzU0duWXROek1lY2w3M0ZCckNKNXBtU1RYdWxoSUxVVUxF?=
 =?utf-8?B?NUR2NmYrc2JESEVZZzNwcm9jSURqaEJJYkowUjJmR2xSSXQ5ejBBeWNYN0lw?=
 =?utf-8?Q?N6VASJLO/eiwppy98AB+L7q/a?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6df2fad-e0f2-4fde-84f6-08db0e5d7549
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5258.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 07:31:16.7431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: as0t6CvJACTgPHzSXJIra93NoezzhonvT5Pw2UNotzoTS7NaQV755KxraA2OPA40c5nOgdXKlQzAXqcKNex/TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5076
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 14/02/2023 4:02, Jakub Kicinski wrote:
> On Mon, 13 Feb 2023 21:00:16 +0200 Mark Bloch wrote:
>> I agree with you this definitely should be the default. That was
>> the plan in the beginning. Testing uncovered that making it the default
>> breaks users. It changes the look and feel of the driver when in switchdev
>> mode, the customers we've talked with are very afraid
>> it will break their software and actually, we've seen real breakages
>> and I fully expect more to pop up once this feature goes live.
> 
> Real breakages as in bugs that are subsequently addressed or inherent
> differences which customers may need to adjust their code for?

It will require changes to the code to deal with.

> Either way we need the expectation captured in the docs - 
> an "experimental" warning or examples of cases which behave differently.

Will talk with Roi and ask him to add proper documentation for this feature.

> 
>> We've started reaching out to customers and working with them on updating
>> their software but such a change takes time and honestly, we would like to
>> push this change out as soon as possible and start building
>> on top of this new mode. Once more features that are only possible in this
>> new mode are added it will be an even bigger incentive to move to it.
>>
>> We believe this parameter will allow customers to transition to the new
>> mode faster as we know this is a big change, let's start the transition
>> as soon as possible as we know delaying it will only make things worse.
>> Add a flag so we can control it and in the future, once all the software
>> is updated switch the flag to be the default and keep it for legacy
>> software where updating the logic isn't possible.
> 
> Oh, the "legacy software where updating the logic isn't possible"
> sounds concerning. Do we know what those cases are? Can we perhaps
> constrain them to run on a specific version of HW (say starting with
> CX8 the param will no longer be there and only the right behavior will
> be supported upstream)?

While I can encourage customers to update their software to deal with
this new mode it's up to them. As you already know, it's hard to change
customers infrastructure so quickly. These things take time. They plan
on running multiple hardware generations on top of the same software.
I'll keep pushing on making this mode the default one.

> 
> I'm speaking under assumption that the document+deprecate plan is okay
> with Jiri.

Will talk with Jiri and get his input.
