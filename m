Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1690617CC8
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 13:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbiKCMiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 08:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbiKCMhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 08:37:23 -0400
X-Greylist: delayed 628 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 03 Nov 2022 05:37:13 PDT
Received: from refb01.tmes.trendmicro.eu (refb01.tmes.trendmicro.eu [18.185.115.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C012313FB2
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 05:37:13 -0700 (PDT)
Received: from 104.47.13.52_.trendmicro.com (unknown [172.21.10.213])
        by refb01.tmes.trendmicro.eu (Postfix) with ESMTPS id 8DF6E1002ED13
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 12:26:45 +0000 (UTC)
Received: from 104.47.13.52_.trendmicro.com (unknown [172.21.173.179])
        by repost01.tmes.trendmicro.eu (Postfix) with SMTP id E20B21000044D;
        Thu,  3 Nov 2022 12:26:42 +0000 (UTC)
X-TM-MAIL-RECEIVED-TIME: 1667478400.125000
X-TM-MAIL-UUID: 9e29e5a8-3280-4fba-8f7d-b0c3b909d680
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (unknown [104.47.13.52])
        by repre01.tmes.trendmicro.eu (Trend Micro Email Security) with ESMTPS id 1EC9710000EF9;
        Thu,  3 Nov 2022 12:26:40 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FnEDXbsxXGFJvIEoZ44g4hcwTwWmEnXzfAJmc7ygbwR1BF215319vKNgGtHC2HaHbEG0EV3mbKZ5Z5pLV/MTM8joPYxDHnhUq7X+D930fC5l9uhVONfSO9x4RC/qwAKgSUxnnF+WogGrmRR2WVQyDghqTVif+YYmxYL7AL15Yk0xfn1VXci4x6fthu02zY+DxTmDffsBOoWuDiNFmUo+8qepRVmcGM37JRIiIgIiX/Bs3/oifMOsC60sIu/8JzXIZIk8YXvf/fnwERKIl9FSknQWvbyPQPbICiRXsK/EcLqo4vevhQ4/4MpFZPsUscVHV+jANAfW17xzX2LaKVkjeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c6h1JHrpQSZUxqnQ1hzCFvLyvuxpyevAcfgnvnDBduc=;
 b=dLF1tlobC0fc9zDJeNRRFXl58FrZs2Mk5C50zNWdM3tsfddHlr1QqGvpGAnrnZ1E4dQ9h+soTvigrNZUZX9qVssLgPXhbdNgb8Yr1DiqgFM2TMhpX1/IoZboco+iy3nYdFS4F/ANVim9hWCBFcVfjhVoPOi7GnJLRzpZgX83TDvAvo8EAo6fOgetIQLoJPB7xrS59q7O+MMbarQFDD4YDNv+sQ09QPKVKTbLe0ZXuQ0E3FGO58/ABqYO2fo7kYwAE/W+/Q22s4Qo1JALHUOWzIiku5yl0Mzw7I6Z6DxHsPbnm9YBij51GyUJGrWtG6Ke3vpciEzusMf7arWYfbdYWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=opensynergy.com; dmarc=pass action=none
 header.from=opensynergy.com; dkim=pass header.d=opensynergy.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=opensynergy.com;
Message-ID: <8bd1dc3b-e1f0-e7f9-bf65-8d243c65adb5@opensynergy.com>
Date:   Thu, 3 Nov 2022 13:26:35 +0100
From:   Harald Mommer <hmo@opensynergy.com>
Subject: Re: [virtio-dev] [RFC PATCH 1/1] can: virtio: Initial virtio CAN
 driver.
To:     Arnd Bergmann <arnd@kernel.org>,
        Harald Mommer <harald.mommer@opensynergy.com>
Cc:     virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>,
        Stratos Mailing List <stratos-dev@op-lists.linaro.org>
References: <20220825134449.18803-1-harald.mommer@opensynergy.com>
 <CAK8P3a1biW1qygRS8Mf0F5n8e6044+W-5v+Gnv+gh+Cyzj-Vjg@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAK8P3a1biW1qygRS8Mf0F5n8e6044+W-5v+Gnv+gh+Cyzj-Vjg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0044.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:22::11) To VI1PR04MB4352.eurprd04.prod.outlook.com
 (2603:10a6:803:4a::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB4352:EE_|DU2PR04MB8968:EE_
X-MS-Office365-Filtering-Correlation-Id: e4e3d54d-ddf6-4203-5f06-08dabd96a726
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +RsK+M+AJCmiCEZjcOsnlMpBBortuWGGSGn0oDNlqHjNNiOmz4su1B+442+jUTM0P/BUF352u7leGB6mHyPeQCZYL3uxdU0edo/XDltBR6sPxRkdJuFFNY/zF9mmEuv0nGK3+XqswHq0JWNIx6kdPjo3KxAGdOHundOs3VAvQpNUORt+mgK7a+xehGfq3oQv1CdDxJ41lZiIPIeZ+mWr8ssU/7WPS9Vhs//4lPl42MFXELvGWh2/15fKADIqEwgkUsAXM2i9noFmznWWHm7ocuRSzWH/4alK+/Ikelf3kSeeo2nbivVLiWYsg+qbhI8myVrow2tj3bekgTYmcrHcIj6WDJyOKvhvA5CEnYkIDDEB/EqftEfIZG/GuEkzBxahbcHzPWPgYg6gWLynpBKQipLQ0HijhMPa2fJiYkUFdC/8t94aNDjW4PwmXwY07hMBRM9Xz9Rr4uGuZeXKN0YaCmrdJoIgFhH7ZxprZnO//9Jr+V0TT9JEiH9JeSvyhMnbWOYFDVK9yadsWkwFbJOio5QwkWGH60gUaX70QfbEnUnH8w2sNTDXH83esBZsNzZY695ufs2RIbk73izqQbIK1FYaYhxLhGhRLtU8EJyXIhfvwg+BIkrCUhfSS0beqvJbi45oiix0SZ0qGo7vc38fCFv9t24ozcoFzmVNMYt1fJFdGeJ+F0HbUv5vjDCreb9Tlkib2jHDdB/3mWnciZQea8vZ0vg1v7WhEF422S7TtSdcSetWbu4kzneYYeh9Y9n4rbGD0ltFhh2m+wVu01wf9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4352.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39840400004)(136003)(366004)(346002)(376002)(451199015)(5660300002)(7416002)(36756003)(31696002)(110136005)(316002)(42186006)(2616005)(2906002)(83380400001)(8676002)(66574015)(15974865002)(53546011)(478600001)(41300700001)(8936002)(966005)(26005)(38100700002)(54906003)(66556008)(186003)(6636002)(4326008)(66946007)(66476007)(31686004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3FwK1VkR2cwVUhsVWZHWW0rN1JIaGJDbnJxUmdSTVQwRS9Db29heFhFWlk1?=
 =?utf-8?B?aTRXb3BuNXN6T0tIeE51NE5lRXpTbms2Q1lRSlQ5OHlwN1Z4M2xTVnNxVk1o?=
 =?utf-8?B?NHdCSjU3Z0tQUmZPN2ZLZnFnbnlaQWpsZ0tzQ05MZnhhQUhqQ2l0QlVZRGZY?=
 =?utf-8?B?MStZdGo1YndSc1JwcVJER3NGcVBnK1l4TlVIMmI3UXkwVW5UbWE5Zm9uR3Az?=
 =?utf-8?B?OFNNV21Cc0VHYU5KOWtYZEgwM0k3SXRWU0JKdmdZc0dKaHp0VG9EU1JFRkdt?=
 =?utf-8?B?dVcxc2NqNkR0Z0FDVmhCdHNtUkR0aEw2RlozUktBSDZ5Qk5kS3BCbGEyUHNu?=
 =?utf-8?B?N2UwUXd2QTBPdzQxV1k1R0RxSkZEUkhTOWdVZUppTHZ6V2g1T2RkMVV3WE5C?=
 =?utf-8?B?b1h3U1pLYXFNbWk2WmRsbEtaWTA5UE9SRFRiOGkxRklQQXdjY1EvK0p0QnNC?=
 =?utf-8?B?L0tDRGNNTStiQnJheWtSdXRWOVFvYzNkZXg0ekZrbXdibnYzSkZKbWZ1Z2Z5?=
 =?utf-8?B?dmdmS0hRZDc0Ui90K0xQOExoNUVVOVN3amdFWTA3Q09Id0c2bHgzN3lLZy8r?=
 =?utf-8?B?Um9NWlZTKzFndWpuRTF3eHBIL1VvRU5JU2xtZE9ETFJvTFQ4OGFiMnBUVytW?=
 =?utf-8?B?cEdabzVYc0poYVUweElnQk5VL2hIWGZmaVJxeG5lQWRyTGVMODdnRzhjUS96?=
 =?utf-8?B?b3pHU2RyMXFWY0Q1QjVjRU9DRjdmdVpaWklsVEE4MGlhK3ZydExENm8vN0M3?=
 =?utf-8?B?S21ldDBvNXN6NnNhK0pUOFBGOHNWQk5SSC9PVmQ1WHcwOTFSdGNneFhpckZT?=
 =?utf-8?B?OGhnVUp3QWdsdTg2Rkd3QkNmYUxNTUVic0R6UENxdnpWUCtubUVEZDJHRTk0?=
 =?utf-8?B?bXJiYlBrUU5NWXpZdDhzcThFZkc0UnpKbmJtSkFkTXhlYjZoK0ZucnFRMjNt?=
 =?utf-8?B?V0pMeExOK3BpN2tQTFFndngrd2hUc0x3cVhvdUJVbkMvYmJQNWlZaVhJc0g2?=
 =?utf-8?B?dUNJRUJkWi90Y0ViZ29qOXJQYmk3WDRrWFVTazY4K1NBZ0tJVk1TckVKZUJk?=
 =?utf-8?B?QXR2Nml1TmJPUlNIU1NsSGoyQ1lNcFhPbkY1Wml6bVRLdDlNTGhRTFovRFZz?=
 =?utf-8?B?WUpUSHBIR0loVmRpNFdHdmI5QTYyUnE5ZFNYdGNqV2RxdVJwbVN4UU9xczYx?=
 =?utf-8?B?MXNsMEM2RlBaV05uRFhJWmk3eGpDVlFDelpKTFpZODdDa2c1NnpFcjdXcUxT?=
 =?utf-8?B?bWx6eUIvUERxZ0hHYUczbGFsdkZJWHZTOWZDdXZkcFFUZUFpRHBLTWttVnBR?=
 =?utf-8?B?UHowNWRDNzQrWkY0bnZDa1NWTkJZbVdnOHkxMHE5ZEJzT3lRZmtEYXVEQ0hJ?=
 =?utf-8?B?S1FUYis1ZGc4cmRieHh4amttWGpCcWdTRnBFcEU5RjNCN0Y0eUF3L1Z5VVFH?=
 =?utf-8?B?ZGxqTmRSZ0lyditZNm1kRzRoQzQxanFCV0ltMHJnb2lKK1Zra1d6M3lYZmdj?=
 =?utf-8?B?SDZKajJKb1ZqUlJhQXRIOHNyYkZhNnNiTFYrYTk0VktzWHhCekFpZVN0eWls?=
 =?utf-8?B?SSt2bWcwc1RHMitsSnN6cldzdlZmbVFYd0FFcE51MGVFQ253Q0pNanVBbEFt?=
 =?utf-8?B?aGRVcmJFOGVLZGkzUC82SVBteW5na0UxN1pXV2dkcnNSbmZFQ1BKRml3RTlN?=
 =?utf-8?B?NUF0ZFo5QTFMc3lwcHJITDJnRXlGMjY3ZytWbWllcUhoTzNoYjdtVWtvaEds?=
 =?utf-8?B?dTI5a0g4U2xVb1Q3YnIxTlpLdHQ2dlZxa0RjcXZJemx2Mk9pZDZIV21WdE45?=
 =?utf-8?B?L3kvVEdRak40Nk0vL1NObForZksvWGc2Uk94MnVyZlU2UUZxS1lreUszR0Ns?=
 =?utf-8?B?MWNlL2dIWU5WbnFXSkwzbm96eWRFaG5GL0ZmUTNFSmFFeGJyQnVTSU10aDRD?=
 =?utf-8?B?WGRBWWZaekxWRFk5a0JOQnYyMTJ6N1FqV2EwRElnU0Y1OUdhcFQvdktDdTZp?=
 =?utf-8?B?L1lISUJHNndiTU40N0hjc3FaNHB3aWlZS3IrbEExaUw4WUx3N1RtWDRHV3Jj?=
 =?utf-8?B?THUzNVh0UTJSdGdUcEY2YlAyYlR0VHgxV0s3MU1BQTlxbjk5NmVKLzZQdXEy?=
 =?utf-8?Q?E1XhKNzjMHbD3S+hMTuOkWTPs?=
X-OriginatorOrg: opensynergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4e3d54d-ddf6-4203-5f06-08dabd96a726
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4352.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 12:26:37.6525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 800fae25-9b1b-4edc-993d-c939c4e84a64
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: scDQcL9up1IWgQAplQ1ZmsEeZxBWcDGsNJ+Sv4b0j3mwrz8fcJD57c2s7BBs6hZUZDUsww2NzXl9irbZiBAngQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8968
X-TM-AS-ERS: 104.47.13.52-0.0.0.0
X-TMASE-Version: StarCloud-1.3-9.0.1006-27240.007
X-TMASE-Result: 10--29.113600-4.000000
X-TMASE-MatchedRID: CxmI61mtwh8Mek0ClnpVp/HkpkyUphL9twpUiv21DA1YvmOtXa0QtskL
        YhUb9pRGkr0FrqCfb7InLmQ5uRWv6OM08db7ghTyr7+qhZS/khk81ck8U80WljVjvc93O9dkTSP
        2Btg+yJIKO0eM7yB2CY2K7KVlHjc1V6HcTxi1U3IRW4LR41Fi8thQO8CvZj/Xr2Nc3LZSfUzv8k
        ZFnw+AJ+XlwEOTvvBbxmJ07fhF3NYKbSsTn+PpZL9A3Bl1/DcVZR+OFNkbtdqQKzOM4NfokjB9c
        cde3hbUkpmfpJcM4Z1gX8R64XHMAFATqJs9uVXRkkRQ7aojOUssvqYk4iz+9tzONa1Rspx32Si3
        /7YtpVQKJfF2LeZOjxUdpRsHdnPRTVAfo9STYMPFVAV8vDjN/xLBqTl41fL7LX3qyf3ewG84Xl0
        2e/71aavwj8I7UQ27ljJAdOzA62NiRyRv3W9D/ovefyp1glN0N6i7v/DQHPxeyFNJCwUtpwFVKn
        tB9/BKL2EYbInFI5spXwl0WAcKdAYNrhTpT76cxDiakrJ+SplzGpNq69FY/rDGRtqVMwHzhJYdi
        ckmV30yJ+sK5xb1gugtChoj0LN9Sp+k3BvxVD/P01G0ZRd+f6zghBiD4bcIMSHb0jFJZjKhk3jS
        p0gMqe77waxZPlCdOFJ4aT8hbQDxrvYshHXJZgPZZctd3P4BQR7lWMXPA1u8j0eQ+IUAHb/ESxz
        77lNOnqLFFS6LrrW3M9iBM2wV6b9jX++auvv+rMZ+BqQt2Nr4qCLIu0mtILll+XI+GnGsKZQ/22
        HSWdXptcPKPQdKdV6FsbmBH8YvhEdIg1vQVch+yskgwrfsC30tCKdnhB581B0Hk1Q1KyLUZxEAl
        FPo8/cUt5lc1lLgkU6UkIr/V+1nME/Jsn/m+g==
X-TMASE-XGENCLOUD: c95e908c-b9db-4d75-8aeb-9ba82c2b3bd6-0-0-200-0
X-TM-Deliver-Signature: 7A9E8796444867F5DB001197ADFC53EF
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=opensynergy.com;
        s=TM-DKIM-20210503141657; t=1667478402;
        bh=U1U87Poykp+Eyg5ndHVvV0AJzwai4v6fQ5yB8AJ+qEs=; l=10152;
        h=Date:From:To;
        b=SOOcHV3I5L2wph4pD33pJWLNWIVF0tA3DccLWCvbe+4LkZwP36WoLzqCdMw5caw8j
         PY435+wgl9Dykc2Os1s0+w+zTLo+kCigtcEEah8fDM+eqnHndMiuvQMOwCztXa1XLT
         MWgednYjOI+FtMQRF4kQrZHFhW8CIG6vpPyJ/86E9PGWMHjO1lH1CxOkRWU0LIwleu
         MwqDKbaPJOM7QfBd/4xKgu/5VziwxZUu6va286J+9vPk+r/wFkYyu7zD9mS5/zks/+
         1CRDHSrTBRSt1s4aZJiAvM5QNxwgO8vxKWcj3wjsz4PBTwUpLlwuI4hMLh+gUF4MBz
         HbLiMwImmZvIw==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

currently in the preparation that changed code can go out to the list.

On 25.08.22 20:21, Arnd Bergmann wrote:

>
>>   drivers/net/can/Kconfig                 |    1 +
>>   drivers/net/can/Makefile                |    1 +
>>   drivers/net/can/virtio_can/Kconfig      |   12 +
>>   drivers/net/can/virtio_can/Makefile     |    5 +
>>   drivers/net/can/virtio_can/virtio_can.c | 1176 +++++++++++++++++++++++
>>   include/uapi/linux/virtio_can.h         |   69 ++
> Since the driver is just one file, you probably don't need the subdirectory.
Easy to do, makes the changes smaller.
>> +struct virtio_can_tx {
>> +       struct list_head list;
>> +       int prio; /* Currently always 0 "normal priority" */
>> +       int putidx;
>> +       struct virtio_can_tx_out tx_out;
>> +       struct virtio_can_tx_in tx_in;
>> +};
> Having a linked list of these appears to add a little extra complexity.
> If they are always processed in sequence, using an array would be
> much simpler, as you just need to remember the index.

The messages are not necessarily processed in sequence by the CAN stack. 
CAN is priority based. The lower the CAN ID the higher the priority. So 
a message with CAN ID 0x100 can surpass a message with ID 0x123 if the 
hardware is not just simple basic CAN controller using a single TX 
mailbox with a FIFO queue on top of it.

Thinking about this the code becomes more complex with the array. What I 
get from the device when the message has been processed is a pointer to 
the processed message by virtqueue_get_buf(). I can then simply do a 
list_del(), free the message and done.

>> +#ifdef DEBUG
>> +static void __attribute__((unused))
>> +virtio_can_hexdump(const void *data, size_t length, size_t base)
>> +{
>> +#define VIRTIO_CAN_MAX_BYTES_PER_LINE 16u
> This seems to duplicate print_hex_dump(), maybe just use that?
Checked where it's still used. The code is not disabled by #ifdef DEBUG 
but simply commented out. Under this circumstances it's for now best to 
simply remove the code now and also the commented out places where is 
was used at some time in the past.
>> +
>> +       while (!virtqueue_get_buf(vq, &len) && !virtqueue_is_broken(vq))
>> +               cpu_relax();
>> +
>> +       mutex_unlock(&priv->ctrl_lock);
> A busy loop is probably not what you want here. Maybe just
> wait_for_completion() until the callback happens?

Was done in the same way as elsewhere 
(virtio_console.c/__send_control_msg() & 
virtio_net.c/virtnet_send_command()). Yes, wait_for_completion() is 
better, this avoids polling.

>> +       /* Push loopback echo. Will be looped back on TX interrupt/TX NAPI */
>> +       can_put_echo_skb(skb, dev, can_tx_msg->putidx, 0);
>> +
>> +       err = virtqueue_add_sgs(vq, sgs, 1u, 1u, can_tx_msg, GFP_ATOMIC);
>> +       if (err != 0) {
>> +               list_del(&can_tx_msg->list);
>> +               virtio_can_free_tx_idx(priv, can_tx_msg->prio,
>> +                                      can_tx_msg->putidx);
>> +               netif_stop_queue(dev);
>> +               spin_unlock_irqrestore(&priv->tx_lock, flags);
>> +               kfree(can_tx_msg);
>> +               if (err == -ENOSPC)
>> +                       netdev_info(dev, "TX: Stop queue, no space left\n");
>> +               else
>> +                       netdev_warn(dev, "TX: Stop queue, reason = %d\n", err);
>> +               return NETDEV_TX_BUSY;
>> +       }
>> +
>> +       if (!virtqueue_kick(vq))
>> +               netdev_err(dev, "%s(): Kick failed\n", __func__);
>> +
>> +       spin_unlock_irqrestore(&priv->tx_lock, flags);
> There should not be a need for a spinlock or disabling interrupts
> in the xmit function. What exactly are you protecting against here?

I'm using 2 NAPIs, one for TX and one for RX. The RX NAPI just receives 
RX messages and is of no interest here. The TX NAPI handles the TX 
messages which have been processed by the virtio CAN device in 
virtio_can_read_tx_queue(). If this was done without the TX NAPI this 
would have been done by the TX interrupt directly, no difference.

In virtio_can_start_xmit()

* Reserve putidx - done by an own mechanism using list operations in 
tx_putidx_list

Could be that it's simpler to use idr_alloc() and friends getting those 
numbers to get rid of this own mechanism, not sure yet. But this needs a 
locks as it's based on a linked list and the list operation has to be 
protected.

* Add the TX message to the pending list

Again a list operation which has to be protected.

* Try to send the message

Now it may happen that at the same time while we do something with the 
lists in virtio_can_start_xmit() the function virtio_can_read_tx_queue() 
is active accessing the same queue. Comment above virtqueue_add_sgs(): 
"Caller must ensure that we don't call this with other virtqueue 
operations at the same time (except when noted)."

Also tried, virtqueue_add_sgs() needs this lock.

* And then there is also a list operation on failure of the function

But the code needed to reworked to understand the necessity of each lock 
again.

> As a further optimization, you may want to use the xmit_more()
> function, as the virtqueue kick is fairly expensive and can be
> batched here.
Looked elsewhere how it works and did.
>> +       kfree(can_tx_msg);
>> +
>> +       /* Flow control */
>> +       if (netif_queue_stopped(dev)) {
>> +               netdev_info(dev, "TX ACK: Wake up stopped queue\n");
>> +               netif_wake_queue(dev);
>> +       }
> You may want to add netdev_sent_queue()/netdev_completed_queue()
> based BQL flow control here as well, so you don't have to rely on the
> queue filling up completely.
Not addressed, not yet completely understood.
>> +static int virtio_can_probe(struct virtio_device *vdev)
>> +{
>> +       struct net_device *dev;
>> +       struct virtio_can_priv *priv;
>> +       int err;
>> +       unsigned int echo_skb_max;
>> +       unsigned int idx;
>> +       u16 lo_tx = VIRTIO_CAN_ECHO_SKB_MAX;
>> +
>> +       BUG_ON(!vdev);
> Not a useful debug check, just remove the BUG_ON(!vdev), here and elsewhere
A lot of BUG_ON() were removed when not considered useful, some were 
reworked to contain better error handling code when this was possible, 
others were kept to ease further development. If anyone catches 
something would be seriously broken and had to be fixed in the code. But 
this then we want to know.
>> +
>> +       echo_skb_max = lo_tx;
>> +       dev = alloc_candev(sizeof(struct virtio_can_priv), echo_skb_max);
>> +       if (!dev)
>> +               return -ENOMEM;
>> +
>> +       priv = netdev_priv(dev);
>> +
>> +       dev_info(&vdev->dev, "echo_skb_max = %u\n", priv->can.echo_skb_max);
> Also remove the prints, I assume this is left over from
> initial debugging.
Yes, this thing was overall too noisy.
>> +
>> +       register_virtio_can_dev(dev);
>> +
>> +       /* Initialize virtqueues */
>> +       err = virtio_can_find_vqs(priv);
>> +       if (err != 0)
>> +               goto on_failure;
> Should the register_virtio_can_dev() be done here? I would expect this to be
> the last thing after setting up the queues.
Doing so makes the code somewhat simpler and shorter = better.
>> +static struct virtio_driver virtio_can_driver = {
>> +       .feature_table = features,
>> +       .feature_table_size = ARRAY_SIZE(features),
>> +       .feature_table_legacy = NULL,
>> +       .feature_table_size_legacy = 0u,
>> +       .driver.name =  KBUILD_MODNAME,
>> +       .driver.owner = THIS_MODULE,
>> +       .id_table =     virtio_can_id_table,
>> +       .validate =     virtio_can_validate,
>> +       .probe =        virtio_can_probe,
>> +       .remove =       virtio_can_remove,
>> +       .config_changed = NULL,
>> +#ifdef CONFIG_PM_SLEEP
>> +       .freeze =       virtio_can_freeze,
>> +       .restore =      virtio_can_restore,
>> +#endif
> You can remove the #ifdef here and above, and replace that with the
> pm_sleep_ptr() macro in the assignment.

This pm_sleep_ptr(_ptr) macro returns either the argument when 
CONFIG_PM_SLEEP is defined or NULL. But in struct virtio_driver there is

#ifdef CONFIG_PM   int(*freeze) ...;   int(*restore) ...; #endif

so without CONFIG_PM there are no freeze and restore structure members.

So

   .freeze = pm_sleep_ptr(virtio_can_freeze)

won't work.

>> diff --git a/include/uapi/linux/virtio_can.h b/include/uapi/linux/virtio_can.h
>> new file mode 100644
>> index 000000000000..0ca75c7a98ee
>> --- /dev/null
>> +++ b/include/uapi/linux/virtio_can.h
>> @@ -0,0 +1,69 @@
>> +/* SPDX-License-Identifier: BSD-3-Clause */
>> +/*
>> + * Copyright (C) 2021 OpenSynergy GmbH
>> + */
>> +#ifndef _LINUX_VIRTIO_VIRTIO_CAN_H
>> +#define _LINUX_VIRTIO_VIRTIO_CAN_H
>> +
>> +#include <linux/types.h>
>> +#include <linux/virtio_types.h>
>> +#include <linux/virtio_ids.h>
>> +#include <linux/virtio_config.h>
> Maybe a link to the specification here? I assume the definitions in this file
> are all lifted from that document, rather than specific to the driver, right?
>
>           Arnd

The driver as made in parallel to the specification work. So there is no 
finished specification yet. To avoid traffic (mistake here) I've not 
sent the patch to the specification to all mailing lists.

Patch to the virtio specification is now here:

https://lore.kernel.org/all/20220825133410.18367-1-harald.mommer@opensynergy.com/

This was made on top of https://github.com/oasis-tcs/virtio-spec.git 
commit 26ed30ccb049

Harald

As mentioned, the updated code will be sent out to the list(s) soon.

-- 
Dipl.-Ing. Harald Mommer
Senior Software Engineer

OpenSynergy GmbH
Rotherstr. 20, 10245 Berlin

Phone:  +49 (30) 60 98 540-0 <== Zentrale
Fax:    +49 (30) 60 98 540-99
E-Mail:harald.mommer@opensynergy.com

www.opensynergy.com

Handelsregister: Amtsgericht Charlottenburg, HRB 108616B
Geschäftsführer/Managing Director: Regis Adjamah

