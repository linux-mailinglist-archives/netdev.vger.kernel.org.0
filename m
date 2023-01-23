Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 655CB678530
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 19:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbjAWSow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 13:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231823AbjAWSov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 13:44:51 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854AC2139
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 10:44:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gx/oWpJ9mIrlOBEiRy+SStWOHKrpti/Yks3bBZUgvXYUygXZBDrinMqVeZW6bPAKebUAknXLJ/NGV1AuRsqCRfSWReWrsOvELrHN0aawydHaxOI4DiuOGlY6GOlObPP9VjoTjLh9B2NIKs581SyHzegj07oLy/dMyJxeI6IEpPAx9YXsXZNLVQNJRIBoBppq2LisXu9uWwYJ7n89ud6QCREHsYLc2HpuMU0LDj2d2oNN/zyKewyXsS4s+7UbTvIsDaIrh7/v9qlOQBSPDHauJGIGDyK8Clx2ck4lQt0u/MFvn1/QMpjZU5zdHAQpbtcZdihN6+xeRqaExwi30wXQfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7eyrrUBA6kG8AxPa0Cs+Caiil+l9P101QdjAfmBvwqQ=;
 b=kXmGk0QHXDvL2d7GfrhTASNzUWWvJWg7HnS3hV+qjZfJ+ak5FPOlODcBfeiZAQWBO546OXLIauytnfpZW1CcXyRokha8caKViA6Ows6VjtR2W3JEKSZ9CvE42fqS4+fZhk05iy+uKOMiUsLR1blXbUR5uhq8iqiIRowJ5WPR7EmqMH9U9GB+JuM1ONUCNR+I87PfSLm0HYTQ+o6vEWzD7TC2T5a7g8ONQaJSpRmcQWgGmKpregOBBXEgBUAjrGso/xdZ/GIbd8YZE4clZaL3Nidj71hEfDy74rGn1ponmHVNkA6Pk6nGoDgPQ7Omg5Vvmo7Fmt48kH9GIrUplHP9Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7eyrrUBA6kG8AxPa0Cs+Caiil+l9P101QdjAfmBvwqQ=;
 b=kVZSfdoKuhKf4xeZX5SI2VyCMZNGJVklm3myuBMvEXGGX55hsepA4dYOokitYRcsi3a4bZIZcJovgHLVkvmiNbqanlWlX6+gQr7ihbHiH0jzBmtK06pOY6PWp5AH8/Zwi3gd71avUYHUGh2cs1LLMjftI8fgQPYV5zutA0MLfAWax42KxvH1VydRcv2K165W64lgP9GCAnIiVz+RZZCKx9MOBdURNhIT5T195ogFszkS0e9XX/KeqisZVAZlKXsV+wfFUPRH4RapZFHFtHEHxTvBs+D7nn1u9itG0gRufQGIciBxk2hEM5DTyhFX0qb3WmiqxWKA/N9aLezejUgYpQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by SN7PR12MB8147.namprd12.prod.outlook.com (2603:10b6:806:32e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 18:44:48 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::8031:8093:2f25:f2ab%7]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 18:44:48 +0000
From:   Rahul Rameshbabu <rrameshbabu@nvidia.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: Re: [net-next 03/15] net/mlx5: Add adjphase function to support
 hardware-only offset control
References: <87tu0luadz.fsf@nvidia.com> <20230119200343.2eb82899@kernel.org>
        <87pmb9u90j.fsf@nvidia.com> <8da8ed6a-af78-a797-135d-1da2d5a08ca1@intel.com>
        <87r0vpcch0.fsf@nvidia.com> <3312dd93-398d-f891-1170-5d471b3d7482@intel.com>
        <20230120160609.19160723@kernel.org> <87ilgyw9ya.fsf@nvidia.com>
        <Y83vgvTBnCYCzp49@hoboy.vegasvil.org> <878rhuj78u.fsf@nvidia.com>
        <Y8336MEkd6R/XU7x@hoboy.vegasvil.org>
Date:   Mon, 23 Jan 2023 10:44:35 -0800
In-Reply-To: <Y8336MEkd6R/XU7x@hoboy.vegasvil.org> (Richard Cochran's message
        of "Sun, 22 Jan 2023 18:58:48 -0800")
Message-ID: <87y1pt6qgc.fsf@nvidia.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::15) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|SN7PR12MB8147:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a92893d-38e3-43b5-4af2-08dafd71e736
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wBQLgBJuuvbwcRgkPIGPRXl8ND0IeIKFtclkILSAyRRd0Deo/C/IVQ9Kly1RhMLXBX7fQpPIRg+dfA1UUHRWj6kj7NZaBigUwimEuV7I9DjDkWBIj8CLzm4qkGdt9Jo8a9GZOV2adKNi0toMSIy+nFXz8ROO6w3+izlcQL6rv5uBf9HwSDBmpUIXEaU+DclBaSvzEspeRkyP7h72OejNOdskLLxxiJhjNts2fYQt+SiU5SUlaqdVCSSfOOa9entRNVS9XzXBK8jsLZOkttHrlVgKQCuFbSblpisYhuInoNHXFu8ZQR54Y3zZTe/5ZjC8oqCznhEcqke41ZOm2CsMwGnlNfBIx3VSyqLb54LLpHx72ag62r4Xb0xSftes3P2kFByMPWjxJp2dOtrPqi5zTjr1bY99lCzzExLKN0b1FizyhDt6sI/XQmElaNi2O66g/+D9hXnbkIThoAzthGxDvUxwAf3N/dgkiP9zcFMOuTjEU7S90HxY8//gABqRo2j469DpmDGf6SPt+g1122jZYBGfistiOZ5BrNbWKJnAZ7IvEk/gynV+DZMYL1UQG4giCd96bnr4ARH0gfYL+RKMSFhshyy3pFw2Z+Vk1rPpisiW7CqnckDXWFGua2Jf5FCHCyPWAuWScBwgj2xsYfXI1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(376002)(346002)(396003)(136003)(451199015)(66476007)(83380400001)(66946007)(86362001)(66556008)(4326008)(6916009)(8676002)(54906003)(36756003)(316002)(6506007)(6666004)(186003)(6512007)(6486002)(478600001)(2616005)(8936002)(5660300002)(41300700001)(2906002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IeGgHKWKqTDWJOThZtFxQcb4Z3RjVE4lsDIlwlrpePnCAewaJo95xffULtXw?=
 =?us-ascii?Q?Fd9MtPjzcB0eVzdyZpoNMJzT2FSKHbUpDzPwj9pYZaPX7GVz1N4lEpNYI5pl?=
 =?us-ascii?Q?Q9sk0AD2SI7QS1pvEswwBXoNFBG3DyWqLZxIZ8ffqA0WkyBFg+EYx0SpuQF2?=
 =?us-ascii?Q?eZyExlyq/A4QyUnyIWsSPpp9sevaK0QQv0jS3HuPPhDyAXRnU79+0nBBff1f?=
 =?us-ascii?Q?8VBgFLA1rpBBrNkGHfZcyyh9qS3J4REdKrUNhFYYqXn335Y0pZWdJoPvDvkt?=
 =?us-ascii?Q?Z33EBVAblL0SLHJpL98EwSdAlE9GsCzvYTA3Bnd1BB9PbS5YBal0rePyqvS7?=
 =?us-ascii?Q?2aW9kHlPd6qw3hrMSoXCCpaHamEUjD6s8xquEWuzntDoyLvj/skbkStxp0m7?=
 =?us-ascii?Q?OSeVAJL+4mNfWL6FPWRij1fJkqc2N41LEi9LieMoeRgg6oen6575ZYCWQyuD?=
 =?us-ascii?Q?ZWL1K8hg4w9sdyzg4lJUNXYKaVE5M874ihLY54Tzp1sMIRZzI2kVK+fcRCsi?=
 =?us-ascii?Q?lpiMEcsjIhigkI4C9Ee5XAxGKM38zJ2Nv55crBEtdFdLCR/f/BShwVUZY7AZ?=
 =?us-ascii?Q?cS7E++kCeoaL8eI/HSXHH08/MIspeB9xfIW7kbgwpr19aTddp5/2Q678g54p?=
 =?us-ascii?Q?uGycu7vKAQqVtN88sYAjNC7SjVSVkk6iActtpUiJIvQSp3TXN4y9bR3tpwxO?=
 =?us-ascii?Q?eHnWL23IFp0NdTOTm9t6rY2kn/utaP4t2g1XK9Y5fTXAx4TiW9MBzI4zfgMS?=
 =?us-ascii?Q?HuPEUx86ku+cu6XdrJes0qqn+qew0bOT5QXZeAWkoEX/OUv0CXdy8s7T+Qqk?=
 =?us-ascii?Q?7ZgVTJ316MaD0bWaLaBlSj7NwhBDZYL1c0gqUDBTuMM99wZojyYOd3cO45xk?=
 =?us-ascii?Q?1Y+IhuPmEir2zEuHjluJN+/ENg1r23ehl2Oa7H4Xs0JS2Oy2YR478gXYzO0L?=
 =?us-ascii?Q?W8LXAHLV8b6cYecHxUdeMZpKblY5a4gP/VY2TY5SYEfy4Jirnabm9Xlebb5I?=
 =?us-ascii?Q?iKoV9/3Sz4GXu/dLGv7hAwhTrfiruTR53UYuYJ1YhXAm7CQu3z+6G3fGmoC8?=
 =?us-ascii?Q?3La7inbWGYOjK4fFlkDGzRdpE4ek3To5UNf9wjKnITwpDiFZ0Dycz4Tx0NhW?=
 =?us-ascii?Q?yMgFfN3QrwIL/Mn+Zu45gpqko3waiziwXyEvtSwff+EYZtNy/JNs4WqpbqQx?=
 =?us-ascii?Q?athXWSMX5eSFMMiXGpGlIV8GivIDnWLBxO8WR6qf0J8QauUh/Md/0aai7exY?=
 =?us-ascii?Q?DoGCSP4sO16S7K2OXniTzb9G140h6w/Tcjz6jMZuIfnE/RDCwKTEK2N2ktI4?=
 =?us-ascii?Q?iQ/L/PIxlioDFZcT1h8QFBexFFL640Ir10rXS0z4KGCtn1kQUdM4OhsE00z1?=
 =?us-ascii?Q?fjvhlAlRMaVs3wbvjF8pbxgzBdT8epVbdE3hlRsjJuyJWACcwWk0SHKHoXSt?=
 =?us-ascii?Q?AYiGRy4Vyu2j0Awc2y8dumJmnld1PL8hPLQr9EdI/FtdIfaUE3BjUI8UEkCr?=
 =?us-ascii?Q?NvdxCYeerW1gADfTWvAlKhZLAb/1BqK5yIrgaSkVKVbU+eC/Wtazeif7kuB0?=
 =?us-ascii?Q?LJZdYLGR9XC93tzCugCsex+nO0LW5Aqu4Ndc9qVILHXYaqqW3ErQUwByefEO?=
 =?us-ascii?Q?ipE+E9iRMTU1XS2j2cpJ8l6l1aA/TE2sc46sfaEAcsUV5L2WMOVNbb/B0aZE?=
 =?us-ascii?Q?PeNhVA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a92893d-38e3-43b5-4af2-08dafd71e736
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 18:44:48.1385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SkBWSqRA8w4GmetQio9xH2Ng4J/M23FolS0+rvP95cdVas1DcHLc414jCp8n1HJTZ51tFPZ7AVpQIV68jM57rA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8147
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the followup. Have a couple more questions.

On Sun, 22 Jan, 2023 18:58:48 -0800 Richard Cochran <richardcochran@gmail.com> wrote:
> On Sun, Jan 22, 2023 at 06:48:49PM -0800, Rahul Rameshbabu wrote:
>
>> Another question then is can adjtime/ADJ_SETOFFSET make use of this
>> servo implementation on the device or is there a strict expectation that
>> adjtime/ADJ_SETOFFSET is purely a function that adds the offset to the
>> current current time?
>
> ADJ_SETOFFSET == clock_settime.  Drivers should set the time
> immediately.
>
>> If adjphase is implemented by a driver, should
>> ADJ_SETOFFSET try to make use of it in the ptp stack if the offset
>> provided is supported by the adjphase implementation?
>
> No.
>
>
> BTW, as mentioned in the thread, the KernelDoc is really, really bad:
>
>  * @adjphase:  Adjusts the phase offset of the hardware clock.
>  *             parameter delta: Desired change in nanoseconds.
>
> The change log is much better:
>
>     ptp: Add adjphase function to support phase offset control.
>
>     Adds adjust phase function to take advantage of a PHC
>     clock's hardware filtering capability that uses phase offset
>     control word instead of frequency offset control word.
>
> So the Kernel Doc should say something like:
>
>  * @adjphase:  Feeds the given phase offset into the hardware clock's servo.
>  *             parameter delta: Measured phase offset in nanoseconds.

Questions based on the proposed doc change.

1. Can the PHC servo change the frequency and not be expected to reset
   it back to the frequency before the phase control word is issued? If
   it's an expectation for the phase control word to reset the frequency
   back, I think that needs to be updated in the comments as a
   requirement.
2. Is it expected that a PHC servo implementation has a fixed
   configuration? In userspace servo implementations, configuration
   parameters are supported. Would we need devlink parameters to support
   configuring a PHC servo?

>
> Thanks,
> Richard
