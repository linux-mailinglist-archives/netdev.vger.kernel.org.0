Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B07463747D
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 09:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiKXIxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 03:53:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbiKXIxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 03:53:48 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D2B9BA30;
        Thu, 24 Nov 2022 00:53:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QE8qqjIzVGUlG9VC7zmIl+ydc5Y424yV4bIrir9iUvpQXV0sKRXD3zODJ/3IRTe4unJuiyuW+Pl6K9mT9RUww4q0kXPWg6b+7XvdFGrqigHsqmi3xv0/A5P8GLjm2wqAlB0wVF/kaGQnHsuk1dEuzL65ILxizPzEoGSFLsOtbdQc92E0nCLfdOnjuyoRv3mzp9pdmveiAGoCqmr7tn/EwMUcyMNA+V0Yzg/1WsOmu0RZ4gyfK818p/+ncgesZFGVZBpMfxxn9IzQt/5lA2yK24AfLuQwZzjCEuktQJWUAcykf1R0RuRjuuyYv38s1NeRFg6UKSEbUsCFT8DRPLfjvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VNt7/vJXD4oJYjP9+x38GsXNe0l7RqQhT2sMyKgH5NY=;
 b=eNUgnZoSKlJdF6sxuSq3AjBH88IRNj3AszukMKTh5SPRKx0onXlzBJzZ3IRXkksPrCHkrm66dDbL9trG/9tVwtJs5XjQEdY4lMGdwbtsH3ezxNPRoTE5679E6uXUjVlXEDjN/GsDbyozCP/hGeca3YFMcMH5gMCmadOfqQ/9b5WO/g1xLurjYeuH7wQWngpW4R26H8Q56U47NHH0Mu1CLQypKb04cjzXt+nUcp/m4i12YLem4GYaEF2hD1Vx9OB7Fcv1ccdxm+i/NwSrOlHbDgj5weTU9XmfaE8QYDHaevGeMiVhisCo1XecUJkgQ8m4+KF91YCle1La6DYGmMlmkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VNt7/vJXD4oJYjP9+x38GsXNe0l7RqQhT2sMyKgH5NY=;
 b=qLYz+LV7nOZ0oJAWsYalYJR3MHa4CxmCAOf3xNoH/aC/7qI962RoeH/nvqvEdKmCpkVEK2xbezQBgB9zTWKpelpNnAECmV3OJxV1/HB23AzU1uhjzkQZjgK+ZWkMkj1I81FYOBZrm2fCOFhHrCX0jDSfoKuCWRgXuXrpawDBQVDe/Ue4fU2jSuonq+xkSMFuIM5bDBOt61s/OoguFDPhAM7MlHKenDn5xNUvRvjIkEE3N0vCME3z/W3UXCbgPPzeSleORj3cZ9ppUd2TMQ5ashmMLXyjWLfO7MQYRunMgtL0Bd7P3k96nnDuN/Gi2cjTERtSNwoT6K91CYz2+0mINw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15)
 by MW4PR12MB7032.namprd12.prod.outlook.com (2603:10b6:303:20a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Thu, 24 Nov
 2022 08:53:43 +0000
Received: from MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::62b2:b96:8fd1:19f5]) by MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::62b2:b96:8fd1:19f5%4]) with mapi id 15.20.5857.019; Thu, 24 Nov 2022
 08:53:43 +0000
Date:   Thu, 24 Nov 2022 09:53:37 +0100
From:   Jiri Pirko <jiri@nvidia.com>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] net: devlink: devlink_nl_info_fill: populate default
 information
Message-ID: <Y38xEYaUurDqesA1@nanopsycho>
References: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr>
 <20221122201246.0276680f@kernel.org>
 <CAMZ6RqJ8_=h1SS7WmBeEB=75wsvVUZrb-8ELCDtpZb0gSs=2+A@mail.gmail.com>
 <20221123190649.6c35b93d@kernel.org>
 <CAMZ6RqJ_rjbbwAfKzA3g2547D5vMke2KBnWCgBVmQqLcev1keg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZ6RqJ_rjbbwAfKzA3g2547D5vMke2KBnWCgBVmQqLcev1keg@mail.gmail.com>
X-ClientProxiedBy: FR0P281CA0104.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::15) To MN0PR12MB5979.namprd12.prod.outlook.com
 (2603:10b6:208:37e::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB5979:EE_|MW4PR12MB7032:EE_
X-MS-Office365-Filtering-Correlation-Id: e99ca03c-e29e-4bad-1df0-08dacdf9633b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sd0eV4kxWF9W/QpuwVaJj7HpgaMZ/EmhVpUTtcMMnwUzsZDqssECcmuh8fJ/hTNiqxLSjXl6tYHSWF/9aCx9Pel9Lpe4TPF9F7x/77vyRHKFulE0EmdAxg1/oDvebTb8cklnEBCtYjqYF55IXRuM/NfPbChgo9RiX9nTOALie3hRYU7xWxYoyrsUGokrs5YNEEgMDWWR9ym0lFygDLQOq62yoRCsvV12qwvNH93soTVtq0aNP+YjeZooMzLaRk9Low/zgaJnYH67RJhveG7iPurB83hPlDT7KZxyxFrQWsTrZ9K2Rf2u21fbbGE0I4IPFfb0wgzi+sxyLDHIT1byXcce13rvz69KadU1UWapJ2iieG4GXmtxzZAIwXsFF/n/qvO7UZGA7v0QP5nAReWc1kFs0T3CTBda0grnzUzDFIqVmw4GJCFH3v9dD4psW2RGZRbKDOTo1LXlhzpMEYObCmrjPyyPqakgScBpsjCHjbIuWh0dGKxrLUplIpYb/cA8peS2TnBzaRN5eleKKBOjwBMC8fV81W3qCK9fBhMfZJK9fyclkri6+s1JRuipAvkEmiO/4/jugCiDnO1DhISyetJKZT+xufCSeOb1llDUFH1J3PahHMSWJZO1yuB7SJuo6QRcfzMSAHU1Kw5t9lFfOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5979.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(451199015)(316002)(6916009)(54906003)(5660300002)(66556008)(8676002)(186003)(2906002)(8936002)(83380400001)(4326008)(66946007)(66476007)(41300700001)(38100700002)(26005)(6666004)(9686003)(478600001)(6512007)(86362001)(33716001)(6506007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PwYUD8LkmqO2YQb7mXGq9r0wjNWY0x6T0EkyhP+bxmrb4/O5hAcAiA0YMyNv?=
 =?us-ascii?Q?6NK49TxLvsE6W3hicpmDRKfyLhhtNEeS2x5PAQY8JLFyoUHv5+mrRO/Bi3LC?=
 =?us-ascii?Q?qTSCqMFELIPZ4XxqGxw+XuMDRKGXrrxqv++Ofu76LlS57h5nMsH2+T0fLbVc?=
 =?us-ascii?Q?KWI6Yj2a/9t3tIxxM3RTdadwHm6yV8dGSAUlcgtzK+1QZaL5Pb7yK51Zklzf?=
 =?us-ascii?Q?pXMmNzQqBswSQvf69FZif8XyHXxPjAAj0Z5M6l7bHNqL5kE77Vf6fGWR8xqm?=
 =?us-ascii?Q?TOxmPfDZWCk6nkFikmS3l1i3itwRx3iZMIUzXdrEfi8ukKN4KWhLLuzhHfXo?=
 =?us-ascii?Q?akfXSY2x7FASFAgA6zAmBV9U0V8zfDWU1HqCk7qZPcidlkL3IRVA2z0eeCPm?=
 =?us-ascii?Q?bUq7H6XtePiNp8EHQsZiEUDMFIHVHzTw/UHmxyEr/G6MeHefowBIZ/dvnhQ+?=
 =?us-ascii?Q?5O/01IRSLe+SiMiKvfISqmKlenMdKrgs/ioyXCnC+zKMTyuflyOFt81tORFK?=
 =?us-ascii?Q?8cuf19cjcPoFfv+t/PY985cRy/zP1yjhCXTkOfFzXTc8iECvBRTENsHqNuz1?=
 =?us-ascii?Q?3MJ24HGNdrc/O7IHOGLEXTsUV8Zmzfi1UQc2wqlJBOu7Cj4Mva1rK9lOloSp?=
 =?us-ascii?Q?nsqEtacQrtyBb+y7l8789EyxKV/be/qEwZkAWXzsOAxI3eX/BTHJj8ttbVRA?=
 =?us-ascii?Q?ztpZSn/BWc78nD4t4OHAbNRGyymBErJ/WPhZHhnREbiglddYMxVRpOuYRXsg?=
 =?us-ascii?Q?xujAQuumDQlGlu1ktZSc9Y95+xzMeZ2NG8YKdJd7ud8ogkdJ7zsH4pWkFl6S?=
 =?us-ascii?Q?8VOc89/s32pLyYwrxzm5M+x92QlIOzhVA67wlOm7LPjipjTfjynCd/9c/267?=
 =?us-ascii?Q?Tgq71t5gY7xK8PndqPFxWgDix9YuzcQBRUf9LABW+d0NH8spL7BqqfC8+4OK?=
 =?us-ascii?Q?fr7cL7n9xCHq18nBSAkVg8xw99I18QqMV16hWkRx04h7xB8LNCOLF2egTyzi?=
 =?us-ascii?Q?Hom1j1t+fITqQ3rNojI6558N/v1+cXGOG0JbjrfJ4EdxWs7xT6nlRiVXDVQw?=
 =?us-ascii?Q?0yef0YL7XbRqvIP/40DcJnB1O6vIJSgt7F+VQR57w72VnafMZU06v3G0JCZ6?=
 =?us-ascii?Q?BCb7DkM68cIainJuQRpUjHvxWdElzp8MMscJc9XZLIdmyqSSKKbT4BzaFrKc?=
 =?us-ascii?Q?dRVat/S4Y5sOyvAVNg95SY1A5uny1rg3OjDpuB0rv9saF4mbk9sLFqeugd9t?=
 =?us-ascii?Q?tms/b87BAzzNRHjxZrmDlgI7qpe/TxBvbmtcP5HVjs32bhahKJYpyx/XXQ4p?=
 =?us-ascii?Q?PI2O+cZqQq3TVBCSrMIpZ5T/2geY+iPP13yMaa77v42yfbJR8vldaQNYX+kj?=
 =?us-ascii?Q?ofqN5xr4L3JwLku4o66tWjRrGsPZMLMJGjrNt+JY83LQE2CAOowG51u68msV?=
 =?us-ascii?Q?frDQOhEb6yfoSl/ZlSp9ne5fwuFieArN6xiJE/vU/9DghttkLxX7GgQozNsg?=
 =?us-ascii?Q?0/28ZbXY5vaXwl8WQ2Lv1jfGEo+mv5rnO2bqnPhxXfiU54jmOkum/N6anhCb?=
 =?us-ascii?Q?XM5gGzk8Vr+9xpOYvqLhC5QXo1zbiFSjdeffnbkb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e99ca03c-e29e-4bad-1df0-08dacdf9633b
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5979.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 08:53:43.4212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gwkij2Ru9GOz+1f5lYAq+D+PGP2j6sYO+KkM9BSDbMDH4Nk/DbXCbeXRWQ3nLvbx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7032
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Nov 24, 2022 at 06:33:58AM CET, mailhol.vincent@wanadoo.fr wrote:
>On Thu. 24 Nov. 2022 at 12:06, Jakub Kicinski <kuba@kernel.org> wrote:
>> On Wed, 23 Nov 2022 18:42:41 +0900 Vincent MAILHOL wrote:
>> > I see three solutions:
>> >
>> > 1/ Do it in the core, clean up all drivers using
>> > devlink_info_driver_name_put() and make the function static (i.e.
>> > forbid the drivers to set the driver name themselves).
>> > N.B. This first solution does not work for
>> > devlink_info_serial_number_put() because the core will not always be
>> > able to provide a default value (e.g. my code only covers USB
>> > devices).
>> >
>> > 2/ Keep track of which attribute is already set (as you suggested).
>> >
>> > 3/ Do a function devlink_nl_info_fill_default() and let the drivers
>> > choose to either call that function or set the attributes themselves.
>> >
>> > I would tend to go with a mix of 1/ and 2/.
>>
>> I think 2/ is best because it will generalize to serial numbers while
>> 1/ will likely not. 3/ is a smaller gain.
>>
>> Jiri already plumbed thru the struct devlink_info_req which is on the
>> stack of the caller, per request, so we can add the bool / bitmap for
>> already reported items there quite easily.
>
>Sorry, let me clarify the next actions. Are you meaning that Jiri is
>already working on the bitmap implementation and should I wait for his
>patches first? Or do you expect me to do it?

I'm not.
