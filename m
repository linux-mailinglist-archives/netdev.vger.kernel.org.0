Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5A257957B
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 10:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235904AbiGSIqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 04:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236815AbiGSIpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 04:45:54 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70048.outbound.protection.outlook.com [40.107.7.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4466EE1E;
        Tue, 19 Jul 2022 01:45:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=afUPzM/Bx/6plZ/vo/MWnnvJ8J0mgp8T884oXJstLxe/zZDW+oQ6QzO+xCh4xM9PFGUIJ3LBebGCNswe3CF3Vm36NxooxWwi3aF3pKnqp5NDgW3fITIS/3DYtwZnSfEXr8CvKda/mIbTdOSpC+4383xCu7Ro2zk6zJtp1NNo7cJ/0ZHra67qspS+CeaP5GAV1+PyB4DWaz41jjxFvPAWu1Y5Av1AHHoOdxd+lUYVENBUff1gzsVhgsIPgsgIp0z0Uzw/ZD5fzLuoSkzx3hLTT8Ir6k4pqftQXUc3cN356XP0scGKG6YXj8KC7JiP+Isy1pcvqJ6BlKzkKC51IOtw1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Q4/r0YOyxLLW49/5DPCPujTAnYTAxnQ9UszI+se1Jg=;
 b=Ki0OSTQSOwMexmN3ihfNYM6YgvHj7NR/5U5t94sTizrT60EOrSW7g+V/oPBriSELL5VROInb8g13BA0M3UcjJKt4a4DLy5W7mITxFTuqZ+8R4nVt8MWS+QmFqrk+g2osaDKy2APM/pwL6751udjibX2Ff6Uu/WdU435K1MDGm5wADW8JijbLRxcm0jnfEdRGcZy/UsBDR3hqOsuepG2iRHfFSCQsxhsf0hU6bogmDT/VL17IpIYb9pV8n4NZ1IOD5mR9qhwKbJWgynwlOVd2IPCmikswhhF5/yTF3ss8qpOjIIkrMiXe80fEAdKFSdGtlWcoeu4ly7Bf8LcBQfGOxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Q4/r0YOyxLLW49/5DPCPujTAnYTAxnQ9UszI+se1Jg=;
 b=BzG2XEebmApMW6U/AFEEH7hfAwv+cfv2+BZ4GcaawTOJiYWTUGBziycW1HWg3a3fz5Hcf8zco/U3TM2W/rxH/4parw4v1BxZS5cuw6LWyd5LxLOlXFgx1liYnpuFfi187e4PxtLNll9rrr9LEscpIZsd63aE7pXnSvvCZ9GOVUn+Z5q4tjA1WFG/A3T3HuhjjkgxFYVWk4bW9wLOpdrY2AV8keAivUtsP11HvnZoIIU5aKh2cdbl3qu6f5BPYW2/nnYmhOXgPf7/0TkVTubPmZd1N5hJ+DsRhu9An8egUls67i5DegA8SAzriZ3b+wTJvR7NU1X31B8qDwF0XOYH3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by AM6PR04MB5975.eurprd04.prod.outlook.com
 (2603:10a6:20b:9c::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 08:45:49 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::21d5:a855:6e65:cf5d]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::21d5:a855:6e65:cf5d%12]) with mapi id 15.20.5438.023; Tue, 19 Jul
 2022 08:45:49 +0000
Message-ID: <4e061614-851e-0dd4-59b2-7110b1a4c339@suse.com>
Date:   Tue, 19 Jul 2022 10:45:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 1/2] net/cdc_ncm: Enable ZLP for DisplayLink ethernet
 devices
Content-Language: en-US
To:     =?UTF-8?Q?=c5=81ukasz_Spintzyk?= <lukasz.spintzyk@synaptics.com>,
        netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, oliver@neukum.org, kuba@kernel.org,
        ppd-posix@synaptics.com
References: <20220714120217.18635-1-lukasz.spintzyk@synaptics.com>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20220714120217.18635-1-lukasz.spintzyk@synaptics.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0098.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a1::14) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9d7b12e-ae3b-4062-5ed3-08da6963149e
X-MS-TrafficTypeDiagnostic: AM6PR04MB5975:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /Wfy8jzam6X5i9WcvHZJFZqg8EAmFevOnvHs8jt59i/pU2C5Aqj0VEUTht2idskpx197EetrZMijA5m+YI2mgHeBtF3z0mXW64VE+j3n6w7uwcq0vxXOp1RgsqO1wVKA34ghH2LHjeR6lkGgN7bhuEV83r4C8MluCLnbvjX2kUfILtIATWQBX/6fvD0zh9m3iLF4v41x45b/I9OUAicY9koP+EESwsn8t6MPVXEhqMMLsS90oir/Q0nfezAcvygO7Gckk+T7y8Z3bHUwGYVK/NHoOtGgSoH8jdLOLs6pCZz2wTnKCFkhozjEUCd/QSgsfzBUYMQ/Jj8xRPAPD/tP9vmtcPXHrPblyRgr1ns380lhpu97hV9v0uiY4vIrdJHfiHmoS1d/2EuJemUovqm8KoaKcmEe6efItEPXXzAjcSJQvfQaL7smI3oLnzQ8aj1keQeoj6+hGRNA74wEkZSgWrJ6nrqQ6K4dYADRCoJVi1NvEBjoRui+16XBzmG2oF385rOFdbPfmFTJIyZYsLmAKVDb1/akY/hzYkfMH/ysNpuRdSMtyMGtOt8ifiYQfrd9QLyR23ggFIa9qMcljMosKVLxJC6ITfIKTmSD3GW6DmQ8SE7WCu8ys/oi+sckFfO2ogVMlPk1+E4w9AUpNs/iiiKhggUtK9m4pay0fjpqbmrYF5o1JKwt2+NZnWYYSgrsqJFWfRrurn2yJ+XIJLM5s6AdoOc2ErgprpaiiPVHVLoDeKDsSyg/L5DBk4/IQmlgI/oAmMy7Rf72deJvUOReLdPB8QVsD67ceSOh5h3Bo08KNZy2Do1X7X6gsbowtjX5Hi6pycPUiD0NBQsDad2ReA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(39860400002)(376002)(366004)(136003)(396003)(41300700001)(2616005)(66946007)(478600001)(83380400001)(186003)(19627235002)(8676002)(31686004)(86362001)(316002)(6486002)(66556008)(66476007)(36756003)(4326008)(5660300002)(38100700002)(4744005)(31696002)(8936002)(2906002)(6512007)(6506007)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cHl0dm9NYTVFaytHZyt5Mm1sRHNnTmcxZWhWWUZPVys5Z05tcXRJdjUvMU9v?=
 =?utf-8?B?L2tIWFRVTDVRc05iU0EzT3VoUzFwQzRaQXU3NGt4V2NpNXN0NlNkSW0xMjUz?=
 =?utf-8?B?bFBBL0VYaVNLd1JZME45Z2ZScXpOa1pjaUJSdnJkczQwOTE3S0l5bVVPQlJz?=
 =?utf-8?B?OStFNGVTemdCanM0bWtGNUU0SElyMENZVGRMWlQrVFkzZkMwbG5hVkNsMnpr?=
 =?utf-8?B?M25ibVRUK21DWjlNaUdjRGw0U3hyWENBcGxOemFLMEtiZW00cFRvZlptMWd4?=
 =?utf-8?B?WHRxZi82U3p5b1ByS2tZMU5VZm1hSFkrakRFVTZ6anc5bjRBZ25DUXlWT25F?=
 =?utf-8?B?RjhQWmUwNkdEeHhCWHA1SFplS3VlNVJZZkJTbEVycDBBUll4V2VTTHNGalhG?=
 =?utf-8?B?cmQ4Y292WEZ1YkR6WVNmV0lJUmd6OUt1VUtDNXg1SmxLRmVEQ0FONlh6TGVJ?=
 =?utf-8?B?czE5YmZqQTBLdjk0VkxQdnZqdTEwSWJRRXF4Mnd5SVE0RFJyRFFBRzFRNWMv?=
 =?utf-8?B?bUZNREhiUk9oTnVxTHdVOGJ0emVIYXNmcTREZWFnV1FkaEVzZUoxYW9iMGli?=
 =?utf-8?B?L0lxaWtVUWg3dEhoT2l2Z1hhS1htSTJIZkxSaGdwRWJFUEc1b3dKOWE0WnRL?=
 =?utf-8?B?aXdmQVEwVDgreFFXY1Zlc2VxeDk1bm8zUkRtVEQwdEhwaFJ3SktOL0JaWGQv?=
 =?utf-8?B?bTVCNHZVK0IrSmNBWSt6SkZmVmVwWmcxZ2gyYVpUelJQTFl1NDRRbjYxR0dt?=
 =?utf-8?B?QVRvWS9vMzNMNFUrWVBHMEd4a05kVzZjTDhZNjR2dUxkcncwbGpWT2VBUmZz?=
 =?utf-8?B?RGZnV2w4MkpTSytualJ5WC8vUGNrSEN0aG56Q2N3VVdyOFBYTlFzQVpqcnIr?=
 =?utf-8?B?K1d3K1RJSzhUZDBGY2Z2cUZEbXpOUlV4S3JhZzhycTBrK2c2cGhjQ2R6cTFI?=
 =?utf-8?B?bGxpNVBwVEZaVmtuek9DVUhNTUNHSldZdU5xRkZHbkl0ZllJejVGcWlBRXdz?=
 =?utf-8?B?VytuZzdGdkFLdTZzNnA4SEhQWmZpcDZPOG9zQ1dieGtIY2lEckRoSjlEcU9J?=
 =?utf-8?B?UytLM2M4N2hTbzEwRE9yeTA0S3N5eEVublVMZHpGS2dsbCtoeVl1RTllZzFp?=
 =?utf-8?B?QkRtQTVaYXpBNWJLUmhmak82ek5xM0pPZlJBb1Fibk1PTU5nWTExcUJJeEtO?=
 =?utf-8?B?UW5MUlZraTFUNEEyWk04aFhoVm43b0lIcU9Hc0lvTUZkSThvbTdaWElKaTNC?=
 =?utf-8?B?YnZzVy9wenpWU28ydFpWRTgxMWJHL2RLMDFnZFU5MDlQb1IwNFBMVzgrdllF?=
 =?utf-8?B?UXlCL3M4dmpENWd2MEpsc0tGbEZlOVc1dklndk5ZQU5EajdlSXlUMkNTclBK?=
 =?utf-8?B?QXFFUFhpNGp2eUdJUXl0bmRJU05uY3Z6VkZ3L3l2WEt2eFMwMHcyQ3pBZGRE?=
 =?utf-8?B?N3o3M1lGRkxzQi9DQ1NhaDlKd01GUjBWR3BWZktKRGxQT0NqQWxxa2lhTnNS?=
 =?utf-8?B?RmNLVHFaSi9BcjU2QlVKUUZOdjFEdEhVRlp3dTRUeUw4cHJhUWx2ZU1zVUZG?=
 =?utf-8?B?OVNLb1B4R3U3V0ZnM01ZV3MzdUk1RFZ1bGNNMUUrU1ZsZHNhN3JKeEVJQmZD?=
 =?utf-8?B?cGlNUVNOcHpNNGxkdWV4cG5scDBLa0lZdmEvVnRiZVVDejlVeFBOV3N2Qmsr?=
 =?utf-8?B?RW9vcHBYZEM2cXNVdFJUclk2NHpYZ2ZCRGcyeVVhTjg1aFRreTZqMkY5clhG?=
 =?utf-8?B?OGVJbmFEUnpCYXJrWlNSU3ZLQ3BiUzdrOU5FeVJmTTZqOTlXUloxTkNTOHFq?=
 =?utf-8?B?bFZzMkxvM3lHUGVqQXRmQkRTVmp6Z1Zjd2gxbDlFQnB6S3VyVUp3bDZUVkRN?=
 =?utf-8?B?Q1BnWDBPUDFuQlZqVUkrZzRoejExSFpDbFpLMzhzVCt5Y0J3bmJjczRvWFZk?=
 =?utf-8?B?NnBRd25zamFmWmRnR0xvUUdrL25XdFFkWDM5WkQ4akg2clRFc3FmYVBVYWZ4?=
 =?utf-8?B?QTIrQlE0Ukw3U2F6aFEvMkdOQmhYSzh4U0xGTFRXZmdNWGRZZDdpU292TjhF?=
 =?utf-8?B?UG1wcUVENDcrTmxZRC8rb0FtNXNscllxSllNN21YZ005TGR5TE0rTk16azFq?=
 =?utf-8?B?Rm81ellDSlpyU1hkUmY0Q2pxQXQ3WTN1dWFIVXZoSkxITEVJOExhQ2FjcTJ5?=
 =?utf-8?Q?FLrBOo7DkHh4hCwIM3faq/3BKMyA1vBc3+YfAyvt7U0v?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9d7b12e-ae3b-4062-5ed3-08da6963149e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 08:45:49.7448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q4wUhkG1KUT8sqNQvl3Cf+R+5sbvfpyGAEPyI1oX40UCYFT5AwW9qVolYs8grjkwHndh0uuxn9j99Xnb5wbXHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5975
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14.07.22 14:02, Łukasz Spintzyk wrote:
> From: Dominik Czerwik <dominik.czerwik@synaptics.com>
> 
> This improves performance and stability of
> DL-3xxx/DL-5xxx/DL-6xxx device series.
>
Hi,

may I request that you send an additional patch changing the description
of cdc_ncm_info, so that is clear that it does not send ZLP, in
contrast to the new option?

	Regards
		Oliver

