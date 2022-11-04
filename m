Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCCB961985B
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 14:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbiKDNpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 09:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbiKDNpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 09:45:05 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A323218B06
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 06:45:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RPTB8Ge7XKMuMoHy9OKbImWjuloiKxWzoEJX/Z3tr8pDhzGuJH/qv2xJ5P+gr2+d4bShMh5ATuIY6Na6pknDy0bL/HSW0WPQlSoPRoAeoJNwwXQjClsUUogFgLZPbajH1Z1WPBfQHtkNtLTX8Bo8YOJUVpq8yVCubnjXBIPx0Zd0gOGqxfqZVwUHFrN5XWSgEQBEngrhCzQ+ndlpx6j3Ly6aiepQhCD71GQvHTXxCeB83XwzS+fa40ok0IsO3IFExG4s23/N5Gscpa3D5uDkPuvWs03/KJcNB2vEZgSTo8jvrZwIK6RqePF/jIy2gobpYU8xwDtJG2dyLn0LQb+BmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BEObfxKDZp+xid34EZtcN+5VU1h9rn9sPgJk/ZrwWoo=;
 b=eVd+hTlRom1d37ETX/XPdCiM+KpEdzEVAUz65FQ2/2Q6VGZ7bHXidALIby1Q1HpNrVXS4UNe8iYc1dtBG5dwz8kXehrf4yxNbIpdQU0WgmoaXsEhxUpU9O7OKFhKKTUREzFrTrZ6xSc6xbXFbX9F2eNhS5CCqglCvjS0ln4KchOgg5vDCZqc5Jil3vQpecz1cLTURWKcXy7yiK8xZbkTKJx0BcIfX7cwfAQqrlWTjizBdWOOQOqRVAdSCvJJ46V3/UtQSHa4xJmis5GBkh9+Wn9Pil4hSICpd/4vYDSCSqr1S7ohodavOh0KBO/LKWbg877WWAMxfVObdEeCuGkrng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BEObfxKDZp+xid34EZtcN+5VU1h9rn9sPgJk/ZrwWoo=;
 b=Kqoerk7rv9espjdF7Mk3VLouHXmk8qJOQuNqmW2D0SSkUFwuPFGd1cboT1ohHiCPwzlSHDbCs9nnb9W9aeLorqeNszBqBm+VjATErU7BEc3HMrq6XiMQvqXCJDSv5kLi1hbjhV+sE3fsmWpbqU+ITyx3xHvoyMSI6ZNJP7rx5SQCXL53U0iH7Nr2mE1eTf7Yw7ON/wuYCi5IDcBD4DV1y9mLBwvXj27pvGIRRsKsRCUwej7OLi3bsPvjN/3lPXXrjwA/dZD71vEKSYkVHEHMD5CrGv2sHQPZGLm+6r5txzoNg+kEkV2GxPEIi5L4OWecTjOEraNCg3xvsB6q4mVqzA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by BL1PR12MB5317.namprd12.prod.outlook.com (2603:10b6:208:31f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Fri, 4 Nov
 2022 13:45:02 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::d4e5:aaf6:b98a:e5a9]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::d4e5:aaf6:b98a:e5a9%4]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 13:45:02 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Shai Malin <smalin@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Or Gerlitz <ogerlitz@nvidia.com>,
        Yoray Zack <yorayz@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        "aurelien.aptel@gmail.com" <aurelien.aptel@gmail.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>
Subject: Re: [PATCH v7 01/23] net: Introduce direct data placement tcp offload
In-Reply-To: <20221103185713.5d2ec13b@kernel.org>
References: <20221025135958.6242-1-aaptel@nvidia.com>
 <20221025135958.6242-2-aaptel@nvidia.com>
 <20221025153925.64b5b040@kernel.org>
 <DM6PR12MB3564FB23C582CEF338D11435BC309@DM6PR12MB3564.namprd12.prod.outlook.com>
 <20221026092449.5f839b36@kernel.org>
 <DM6PR12MB356448156B75DD719E24E41DBC329@DM6PR12MB3564.namprd12.prod.outlook.com>
 <20221028084001.447a7c05@kernel.org>
 <DM6PR12MB356475DB9921B7E8D7802C14BC379@DM6PR12MB3564.namprd12.prod.outlook.com>
 <20221031164744.43f8e83f@kernel.org>
 <DM6PR12MB35648F8F904D783E59B7CE01BC389@DM6PR12MB3564.namprd12.prod.outlook.com>
 <253k04ct08y.fsf@mtr-vdi-124.i-did-not-set--mail-host-address--so-tickle-me>
 <20221103185713.5d2ec13b@kernel.org>
Date:   Fri, 04 Nov 2022 15:44:57 +0200
Message-ID: <253eduiu946.fsf@mtr-vdi-124.i-did-not-set--mail-host-address--so-tickle-me>
Content-Type: text/plain
X-ClientProxiedBy: LO6P265CA0028.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ff::12) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|BL1PR12MB5317:EE_
X-MS-Office365-Filtering-Correlation-Id: b3317b08-5a83-4827-b94a-08dabe6ac5bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: niVT1ckAQphryybhd0lWXLzemn+ZYH/W8wC/RPFUmQpKm+DA+/b4n4/+tdwBWDYiztwjW6ZFC6c1TBh9WmxP8H9zdrIGsnLcargj5KiI/P5GwVhweowheGvMamwJS+xg52kXD+2aiWLJrXU9Zver9fYJC5EEKEq0UsO26XdIuwQx71rvCKyQuqvQC/paT8WMVjK6i+Uc/IUcREXWFcVwta71nLdt6BZkRSnUub8cIEhcKuysR4lCqJhXQxUBn2vkKuWmCzS4oY0w7+4PXgwqLxKrcHd6/uwLeLy8ffFTGO3j5ICnKWg9niZvv3XGqmLkHd6WCfpPKAWKR054iJnjm+Zx9EuW/Jn3mMGv6LMMDQM9OZsrTF39r8dNlm3DQfeg+9SHD+tlceG01iB7WHddUlh27Bm+obkZA+ssfIpBf3fWJswYnEllDJDSDrS04qLVA47bUf+p7woHpayhex2r8MQBWnjHc4HymZht32TZ11B/UQhrlUP+iWDwPvi0lPvsxj3Tt681eGcTNQXtJpZD7kcz+kJ0VdP3f4tThFYycbGTqoQI6F+UlT77xC6DhYAG73kunIsr4CpMiZM287TOQwapJiB5p/h9DPtOWXopdYj3Rn7ZRsvEIW/PhCFOgTFNTxO+38O3OxQzWzOJPETxv1r+1F7x/Fp3JxHyaGPPqjXeEaLNSynoV156WnO07f6efXNq3QiDh4swX/uFJvxcpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(366004)(39860400002)(376002)(396003)(451199015)(6916009)(478600001)(7416002)(6506007)(66556008)(8676002)(6486002)(54906003)(186003)(6666004)(9686003)(26005)(5660300002)(6512007)(66476007)(2906002)(83380400001)(66946007)(41300700001)(8936002)(4326008)(38100700002)(316002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/ISNt7pr94lf7jKOBtkm9PaXNSECujgLrp4MbhxORXHwmqiQziAHHIpeQ+tk?=
 =?us-ascii?Q?17UYpNXrwLIPSOP1nA+95svFRV/YDWtmFK/KqLDppi6ofhXVdTjuct2Dgx6f?=
 =?us-ascii?Q?pJA+88fpVxFRSRHlWx2PoQU7F2Ow4roR9ut335NtnP1oLiFtEWJeWCYVQTYU?=
 =?us-ascii?Q?HueIHcc7Bc1LAqzXqSdvCj4ihYLLsn3as+P8ssijDIMUZ4Z/lf/2QeyoQTnB?=
 =?us-ascii?Q?ywYHGG47oT43H73i0w0AapE0+E3I6F6eZNWjqHNGhWMzq2eVVDZmia8rA0o9?=
 =?us-ascii?Q?D1wbKy6KQgzHEtKPy7Bnl98sN891Me5QUV18sBN1Y1oqhQox43/HOcy7MSP7?=
 =?us-ascii?Q?SUNR0+NRcHq3knmVMh5HUnq+amAzWVEw8aeSa3sMwRWQa5G0DgvVHrefr3hJ?=
 =?us-ascii?Q?5UFTBYRCltmifruVJeFKRJdlDu1F2QBTmb0F7WzYLSzZVizvsisoiPewer4U?=
 =?us-ascii?Q?e2fQ2gMj+uO9IiSt2XtksAzPlBGYLXpZtpLDVA8+Vnluo9N2KlXHAuUYGuAq?=
 =?us-ascii?Q?Nk8MLf9nRWGEkhHkeT2CycjWLhOeEDRYi5bL/is9YFgONE7YaOrrxMELAzZj?=
 =?us-ascii?Q?JvCv6KYSF9Z3s3daV8kmN7otJE4af0J2Ytqxx6eFyXCWbkx7lhPaHf8C/FzZ?=
 =?us-ascii?Q?HI+KqqVT5peNZmUdEdrnUacdQ9hmTTgrUsT/VCTguNwNpdFlPrqghqUaGMg1?=
 =?us-ascii?Q?0AG13sSgE+ycswSoCzW43T27R5JAlMreQbxFWPGxjawYSY5W38Iz8LbExgGG?=
 =?us-ascii?Q?ml5o3qHG9w98YTm5TE595yxG/ocG9FS6DQcGhw3FxTm1bFIfxuLaxIJ9/WxV?=
 =?us-ascii?Q?ZtQ2c2/4Z8m0Ln5TCgVT29zqSugIm+xI/GIW6yOPbHy58M8qFbPWrLuoJoEp?=
 =?us-ascii?Q?8nhkZbcRJZNQWCmQVtD2WGbcM0daNP4qaaOoUWGmES3n/3SrOaAS1wVbhcXR?=
 =?us-ascii?Q?ZxqKNJl2iE73TfVVq3V7/JphD/eMNkkH3x3JogufY5p6/cSCbBzcsEWWC3V7?=
 =?us-ascii?Q?UvQ4xGNQsVTuBxlHQ4aYPxVOOHPCnMB06CdFqtDCcKhScEtBq9ah6uzbIe6c?=
 =?us-ascii?Q?gstefTJZa12eT5GLx9JP3o2i0l9WzTxjYB+IIEmA9kR2+8UWOYrsRPLswgjm?=
 =?us-ascii?Q?6jjV6KnfaZ1UDiZ7eFS8k8jfNcAsGyzhQpMAA3n2EcIUA83FT2BvuJIAeKQM?=
 =?us-ascii?Q?0A86CKA2rlNXRV4kcODdaZq74ZKOFvfVi3rX8EcLNF2gwUHupYPBU53jft22?=
 =?us-ascii?Q?PfF/692TeI0h5fGONtfahTUfqlnJNsUoes0b7U0U6GbYVJ8+8vC3gkM23jbn?=
 =?us-ascii?Q?FKSO5aQMY9YGdk8RVnwKIFBt0vNevqJSFsxZTNAm8RTkk0D1W1DMHrJ58AXP?=
 =?us-ascii?Q?gHZGPfAqIMC/Vn2wFzcRIOl7gcTf2ytltJdEGMuSXCwdE8neT+jOq3R6zV4D?=
 =?us-ascii?Q?inCdRPa3swMQ/GjMwd7Zkabaesl2iqqiwvYKHDDyHjLV7alyps/y9vOuX/B4?=
 =?us-ascii?Q?emlQ/XOJIundHMhKymUkVNqttcAvydzleCA90LeuzXAKxk6XzmWpRqqXzHfU?=
 =?us-ascii?Q?H8Do9aHU8+A9rMOKuElTi14ZzgTfG3ANMKdIarcu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3317b08-5a83-4827-b94a-08dabe6ac5bd
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 13:45:02.5170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B3lA1T97xMbkusZeIaUp0QpfRzYb8pyg7lklitg+j8ETc5KCf5EbIppEa/NhbfMdcafbWiptOiSxXCV2MFPoIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5317
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski kuba@kernel.org writes:
> Sounds good. Just to be clear - I was suggesting:
>
>         net_device_ops->ddp_ulp_ops->set_ulp_caps()
>
> so an extra indirection, but if you're worried about the overhead
> an ndo is fine, too.

Sure, thanks.

>> We add ETHTOOL messages to get and set ULP caps:
>>
>> - ETHTOOL_MSG_ULP_CAPS_GET: get device ulp capabilities
>> - ETHTOOL_MSG_ULP_CAPS_SET: set device up capabilities
>
> ULP or DDP? Are you planning to plumb TLS thru the same ops?
> Otherwise ULP on its own may be a little too generic of a name.

TLS is not in our scope. It was originally used as a reference.
We will use the term "ULP_DDP".

>
>> The GET reply code can use ethnl_put_bitset32() which does the job of
>> sending bits + their names as strings.
>>
>> The SET code would apply the changes to netdev->ulp_ddp_caps.caps_active.
>>
>> # Statistics
>>
>> If the ETHTOOL_MSG_ULP_CAPS_GET message requests statistics (by
>
> Would it make sense to drop the _CAPS from the name, then?
> Or replace by something more general, like INFO?

Ok, we will drop the _CAPS.

>>    # query ULP stats of $dev
>>    ethtool -u|--ulp-get --include-statistics <dev>
>
> -I|--include-statistics ?

Could you please elaborate what is the comment?

>>    # set $cap to $val on device $dev
>>    -U|--ulp-set <dev> <cap> [on|off]
>
> Sounds good!

Since -u is taken we are going with -J/-j and --ulp-ddp to keep it
consistent with the netlink flags.

> Thanks for describing the options! I definitely prefer ethtool/netlink.

Great, we will add it in v8.

Thanks
