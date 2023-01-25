Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9A4E67ABAF
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 09:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234832AbjAYI3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 03:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235022AbjAYI3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 03:29:09 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2083.outbound.protection.outlook.com [40.107.92.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C8B73FF06
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 00:29:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H9p69n3L6Nc75uStEh0wd57wEriUIh68zLH5j3U7jo9VR1Na/6MWaT5l2g1XFT9Q0FOaWCWAeiZJsY3T+U4G6oKiAnkJj2B9H1byZN9aRohslaSh7bmnl7fFakzeKOn30pUskW/FVOOaJQ+6Rqd0evL8VVDbZV5Dugxxkn43agegKZsqsO7r0TB8oGFrLD7lL+LKsHP6nTip+boTxrdczTA+++TfB+wqlVVMbZtksfM48s0WLocTNNQnf61ApCwnoV1oQ6JDBsqW/2uClwo/IGINmMJ0cv7HkKCLVAjZiF8bwHYOORO6p9fiJ4GKhtM40Ar+2HbffZ1DsmPDQWSHJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JsZwej55mAODPfa3IG0EnAG5j8lzEP9BDJ4rynQlCXE=;
 b=BZMeFdS12otZJoeWgaiYFcNorsTX6swl1+vIfE6M1KlBJ/pQXy69Qrzc1p5m6dTVQkr4r3dmqZcEiGqTeqndsyXEQAVp4IBY3BWFYhermhMFRNgCovRBsxpkyD6uQd5lw/WrtB61rop4Iw5TYrB69li1RNEszFSl5wvpA2qjfmpaJaRL1C0Tc8SLHwlzK4gtr3xCDg+W+9mpEabNvnMIqycT2wlfakZSgcxCLma0ciVTQded6NK37l8Dud+niuM7YRN2Ej++CXXckzQnFqyFyYsfXIg1TDbvS4EDc4xbeq5owobuSE47fk69abbFcsYKtIY9xEDbyzRsfFQAueWlSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JsZwej55mAODPfa3IG0EnAG5j8lzEP9BDJ4rynQlCXE=;
 b=rGx0znBIDOLyNG30oZPp0DdKRw3OLYEKosiJsosfUXQzKDmKI6wIUx9Qj7M+BRRU+5jEmCiedMH+kaTLe8DmcnjDGIKrRN7Lcp+uGBSXV95r//JH3E+OShqR8X1H1Nd+252xN76C1OoH1VaTmhiD9t4ySVjK6OSlgLMhBsrDDm5mX9sVC+HPL1kv8fubVg+677IhpAySHV93DKBtgBjxgA5pUIXazR6liHC87cn6uPP58st1yw/TU06s4H++JaAbzEUrjCy3Tu1Pw0WQdV8ZYuPrSPKp4Tzbo6ndoIN+bT9PViPyA1s2gR2GJqldINvDk4GbCms0gRFwTDTr19o96g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 IA1PR12MB7542.namprd12.prod.outlook.com (2603:10b6:208:42e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 08:29:02 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::d01c:4567:fb90:72b9]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::d01c:4567:fb90:72b9%3]) with mapi id 15.20.6002.033; Wed, 25 Jan 2023
 08:29:02 +0000
Message-ID: <fc8f0ae6-de4f-0468-201f-298abf21e91a@nvidia.com>
Date:   Wed, 25 Jan 2023 10:28:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [net-next 03/15] net/mlx5: Add adjphase function to support
 hardware-only offset control
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bar Shapira <bar.shapira.work@gmail.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>,
        Richard Cochran <richardcochran@gmail.com>
References: <87r0vpcch0.fsf@nvidia.com>
 <3312dd93-398d-f891-1170-5d471b3d7482@intel.com>
 <20230120160609.19160723@kernel.org> <87ilgyw9ya.fsf@nvidia.com>
 <Y83vgvTBnCYCzp49@hoboy.vegasvil.org> <878rhuj78u.fsf@nvidia.com>
 <Y8336MEkd6R/XU7x@hoboy.vegasvil.org> <87y1pt6qgc.fsf@nvidia.com>
 <Y88L6EPtgvW4tSA+@hoboy.vegasvil.org>
 <8fceff1b-180d-b089-8259-cd4caf46e7d2@gmail.com>
 <Y9AuU4zSQ0++RV7z@hoboy.vegasvil.org> <20230124164832.71674574@kernel.org>
Content-Language: en-US
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20230124164832.71674574@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0637.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::14) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|IA1PR12MB7542:EE_
X-MS-Office365-Filtering-Correlation-Id: f6e65cfa-7723-41b9-1289-08dafeae3661
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bc5FKMIDEu1rrYsFn/A6Cbqzmj8aXA+kXhChxFEUHkFXmKHO7ytWgq0l/RK3g1nSwRI7zgrnRqTz2XCdSpPE0TWFKVH8bdmu3IxHNqweCIix0LUCISWUoOjPzJa0/CfkVww7x3bmANwJMG1L8DGNlssi0Gd3XblMmZVzXP7MhuboWbPsCAslKaVrmnTvo9PThZX5eNQTspgUNBt1EJphvLw6iFsjmwDAylxbDLGXT8tK8CB4Ouwj/WPG6H3nkIMWyRT9UXM3QF8xK5WbKjqay9u2R3fQ8Gy4JzjMF5UXj9PszunwJ3RcxuFo/3YX8AIYLr1/RNTAfWG4/oO2/WfWh1PLBAnixPDsDvr3nAYsqdrXZ/1J3AoXg7FWQ+SEAFjwUyEQs77KPLUQeXtWcmnaxbJJvpjdc/DrVU1dBYNx6IM+rO0Q8gJ48+URhK9PYaB2rRAC6j+aXkabHHwKUI2dNnBB1ZCkNPWhgpS6c8Di1sHcXV7P+eJcLZV/qN8HdlUtFc5qVxiYrGZ8FSnwzNGKZYB1atAX4tSq9JfL1i1nLCK3DrlE3IChwV4402lRWsjVfNkVkiJdJhZmSMl5vhaFSItcG+cZThy+owGSDtJgTt/cY3J1K60dqW4qU7Bwt6w0k4KFT4PXrfK0NX9PshBLZN3QWyeJP5lBYwwm+Q7ZdPY9ILUiskDEgl1K720i4ye+xK2KAwaF1QFjlKQmeKSQWt2JDFPagWB1DHlfc1Qyt5I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(451199018)(36756003)(38100700002)(53546011)(6512007)(6666004)(83380400001)(41300700001)(86362001)(8936002)(6506007)(26005)(5660300002)(7416002)(4744005)(66946007)(186003)(316002)(66556008)(8676002)(66476007)(6486002)(31696002)(2906002)(6916009)(54906003)(478600001)(31686004)(4326008)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0NNYUJ3Wkx2OFZqY3VJVENkQmlwN3NhL1E5RkJPa2o3YW5kT0dsUkQwdDA4?=
 =?utf-8?B?QlNvbHhnVjZGQTRTcW1HNk52ejRORmlleFh2RU1INE9yM1BtUFl3eWVVRlBn?=
 =?utf-8?B?Z3M5eHY4QlpqcHg1WDhmdU1kSTZ3ZTA5QXBqT2xtTGwwVXZ4QkVQMDlWR0NI?=
 =?utf-8?B?QnRnaUNrN0NkOVFuUlU5WmxtaDA5UFdyWkVNMUJIYWJ3S2tRdFdsc2NxT29W?=
 =?utf-8?B?eXZ0RGxGcjZHY2F2R0FaVnh3WFI2OUF0cVJqY0hGbnBoazhTa1NzTE9BRjRT?=
 =?utf-8?B?bUVEc29VeXVERk9rQnlaSitLckNkL2FqbFZmWlBRRzZNZmZpRHprQVJTT2wx?=
 =?utf-8?B?L2g3T3BzTTg2YXN5RzBrS29vRUlzWkNCaGVPTGpQSjFqQ2ljNU9TYlc2dGZj?=
 =?utf-8?B?WC95VEF2V3BJWExZMUQ2UHVPU3FSS1d6SmIrUEo5WGJOTTVGNEpCQkZMSHBu?=
 =?utf-8?B?MC9wNmFLMFl6cjVxM0pBRWViZFVGbkpiUytoQWpDc0p6alQxUW5PL2RPaWFZ?=
 =?utf-8?B?ZWU5STRIeG1EdXR5OXFSdS9iNitmTDJhVkVOaVNsd0dqblhJL1dZdEk5Q29H?=
 =?utf-8?B?OGQyYzJiWWxsNVIvNXJDLzhjODhLcTRmNU5zQVllQWNXZ0wwZHY2TllxSVBn?=
 =?utf-8?B?TE1yK2krM2UxS21pR096SXRYNXA5TVlaS290SVZnMTluTkdkMkpNcDJvTk02?=
 =?utf-8?B?dUNGQ2FEM1ZVSkpCZS9tbS9NVDBDUnlvUkJ4bTUxOXNCK1BONzJOaXR0SEJW?=
 =?utf-8?B?VVdyS0hpaEcyVFArQ0RqYVR5OExNdXhTWXcvcFI3VFdUNkNpWERqZUZLOThn?=
 =?utf-8?B?MmNrSGpXWk9BQ2xSRXBHUVh3cktQcDg0dTA4WnpCcUdicW9kSzIvVGxoR1N3?=
 =?utf-8?B?SExBdXFDSVQ2NEpORHZ1Vi9iYVBIZXBXWTlrdkQwNFlkU2tZY2FmZkx5SmlJ?=
 =?utf-8?B?TXplTmdrS1N5Y2ZrZXZhVkMwdGxKY3Z4bS9kYkp6VmJJWlVDZ2puMitTZ2JX?=
 =?utf-8?B?SDBuLzZaQ2pCSUZYYi9lb0hqUWloN1hielRhYmtuUWlja3hHeWRTTnFyUDZa?=
 =?utf-8?B?SzlxMWRxZjYzNkVBNERKWG8wN3NTWlVxVCs0emlRTTRtU3RiTHg0dUVMOFhT?=
 =?utf-8?B?SGY1SlZDY3BDc0t4clY2QlRSUlUzdjN3OHZ3eFFlejJsaFpQL2pNdUxJcVNU?=
 =?utf-8?B?YWxsU2lVbG12ZllVVXVXb20wZUtCSzBwdklld044T1htSVBqcGUwTG9ENlZp?=
 =?utf-8?B?Z0k0SkpEZTZCRmNpTDNDamxpLzVvSG81ZnVYcEVYdVVXdUcvdStBU3pRN21o?=
 =?utf-8?B?clUwNXF5YXJvNkhpTkdVRU5Uend3ZEZQL3dqamJXL2hmb0QvWkRpdGpRT24z?=
 =?utf-8?B?TlFFRVZWN09lZ3Y0WjFldVcxNEFlUWZyRTYvU2dsWENWTEg2VVpPMXZ4Nm5Z?=
 =?utf-8?B?aWpaR2tjQTJob0ZWSmdPRGFyd3p6K3I2MzZKcUNtbmg3S2hUZzJDbGxaaXIz?=
 =?utf-8?B?M21LdmMrM3Y1ZFJTMENhejRtam14TnhwZkRvL2UwS1UxSlBDS2xZZUVmeTFs?=
 =?utf-8?B?WUdaUXZXV2VSWlppTm5hWGprMnJIazJwWG1IQ3FwcEhsWU9Xc2N4eS9peXpX?=
 =?utf-8?B?YUs2SlRYM0JpQjZuRGhiNlYxcEZQeU1SMEIycDJqdld4UWZpRC9ISWZwN3Zm?=
 =?utf-8?B?aHRRZUdZajc1QkNxK2tpaElxY1BSWlU2NitWTE91bGxvT3BLOFlDcEN0SWJl?=
 =?utf-8?B?T3ptYUEzVHRDcUpvaGNobk11YXViQUgyUmdPVEQ2UHgvaHNHYUp3ald1cGhq?=
 =?utf-8?B?TVVHZzBTMWgveW52dnZOMjRQTEhHUDFVVG0yUXdUUmVtM0V0SlhpTnZsT3R2?=
 =?utf-8?B?WmhHakE1Q0wvKzFUYTNUVHYzZFBCSElaZThmandnY1g3TG52ZXpmcnJac0ZI?=
 =?utf-8?B?cWdodlJGcm0wNVowSS9rOWQ5Nnl0MExhbGZpT0h5N3hpL1JkVXVjWm1uWDFD?=
 =?utf-8?B?dTV2VmROZExRUzczNTY2cmg1YW41cVlsZEJtSFpyTVBDZ1M1c2FDdzZOYkEz?=
 =?utf-8?B?azJFWHV3L3I2QTIvSXRLR25YYXFjYWJuQnowZGZIVG80bzNZbEc1VGh0QjdG?=
 =?utf-8?Q?Kt3WuwzDnWMlL41uS0/UA+oZ1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6e65cfa-7723-41b9-1289-08dafeae3661
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 08:29:01.9254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ks0XLIZpB0YVO1WcWNOA9pUdOU3NI7VVjktTOxI6xSd+uL7xnTpOXKZRtk7UpgUt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7542
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/01/2023 2:48, Jakub Kicinski wrote:
> On Tue, 24 Jan 2023 11:15:31 -0800 Richard Cochran wrote:
>> On Tue, Jan 24, 2023 at 12:33:05PM +0200, Bar Shapira wrote:
>>> I guess this expectation should be part of the documentation too, right? Are
>>> there more expectations when calling adjphase?  
>>
>> I'll gladly ack improvements to the documentation. I myself won't
>> spend time on that, because it will only get ignored, even when it is
>> super clear.  Like ptp_clock_register(), for example.
> 
> IMHO it is a responsibility of maintainers to try to teach, even if not
> everyone turns out to be a diligent listener/reader. I've looked for
> information about this callback at least twice in the last 6 months.
> 
> nVidia folks, could you please improve the doc, in that case? 
> I think you also owe me the docs for your "debug" configuration 
> of hairpin queues in debugfs.

I have patches converting the hairpin debugfs to devlink params, the
write debugfs files will be reverted.
