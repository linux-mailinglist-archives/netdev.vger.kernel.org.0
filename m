Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9305132F7
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 13:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345816AbiD1L7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234745AbiD1L7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:59:43 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC38E888D8
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 04:56:28 -0700 (PDT)
Received: from kwepemi100020.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KpvFb2SGFzfbD9;
        Thu, 28 Apr 2022 19:55:31 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi100020.china.huawei.com (7.221.188.48) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 28 Apr 2022 19:56:26 +0800
Received: from [127.0.0.1] (10.67.101.149) by kwepemm600017.china.huawei.com
 (7.193.23.234) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 28 Apr
 2022 19:56:26 +0800
Subject: Re: [PATCH ethtool-next v2 2/2] ethtool: add support to get/set tx
 push by ethtool -G/g
To:     sundeep subbaraya <sundeep.lkml@gmail.com>,
        Guangbin Huang <huangguangbin2@huawei.com>
References: <20220421084646.15458-1-huangguangbin2@huawei.com>
 <20220421084646.15458-3-huangguangbin2@huawei.com>
 <CALHRZupJSiwAVzsvRvQiwBDSOaykLLJYKWbHQZjweHd0mrUvtA@mail.gmail.com>
CC:     <mkubecek@suse.cz>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <lipeng321@huawei.com>, Subbaraya Sundeep <sbhatta@marvell.com>
From:   "wangjie (L)" <wangjie125@huawei.com>
Message-ID: <b5a0bb41-f29e-69c1-7a4b-6bd72221925e@huawei.com>
Date:   Thu, 28 Apr 2022 19:56:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <CALHRZupJSiwAVzsvRvQiwBDSOaykLLJYKWbHQZjweHd0mrUvtA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.149]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/4/27 21:46, sundeep subbaraya wrote:
> Hi Guangbin,
>
> On Thu, Apr 21, 2022 at 3:47 PM Guangbin Huang
> <huangguangbin2@huawei.com> wrote:
>>
>> From: Jie Wang <wangjie125@huawei.com>
>>
>> Currently tx push is a standard feature for NICs such as Mellanox, HNS3.
>> But there is no command to set or get this feature.
>>
>> So this patch adds support for "ethtool -G <dev> tx-push on|off" and
>> "ethtool -g <dev>" to set/get tx push mode.
>>
>> Signed-off-by: Jie Wang <wangjie125@huawei.com>
>> ---
>>  ethtool.8.in    | 4 ++++
>>  ethtool.c       | 1 +
>>  netlink/rings.c | 7 +++++++
>>  3 files changed, 12 insertions(+)
>>
>> diff --git a/ethtool.8.in b/ethtool.8.in
>> index 12940e1..a87f31f 100644
>> --- a/ethtool.8.in
>> +++ b/ethtool.8.in
>> @@ -199,6 +199,7 @@ ethtool \- query or control network driver and hardware settings
>>  .BN rx\-jumbo
>>  .BN tx
>>  .BN rx\-buf\-len
>> +.BN tx\-push
>>  .HP
>>  .B ethtool \-i|\-\-driver
>>  .I devname
>> @@ -573,6 +574,9 @@ Changes the number of ring entries for the Tx ring.
>>  .TP
>>  .BI rx\-buf\-len \ N
>>  Changes the size of a buffer in the Rx ring.
>> +.TP
>> +.BI tx\-push \ on|off
>> +Specifies whether TX push should be enabled.
>>  .RE
>>  .TP
>>  .B \-i \-\-driver
>> diff --git a/ethtool.c b/ethtool.c
>> index 4f5c234..4d2a475 100644
>> --- a/ethtool.c
>> +++ b/ethtool.c
>> @@ -5733,6 +5733,7 @@ static const struct option args[] = {
>>                           "             [ rx-jumbo N ]\n"
>>                           "             [ tx N ]\n"
>>                           "             [ rx-buf-len N]\n"
>> +                         "             [ tx-push on|off]\n"
>>         },
>>         {
>>                 .opts   = "-k|--show-features|--show-offload",
>> diff --git a/netlink/rings.c b/netlink/rings.c
>> index 119178e..a53eed5 100644
>> --- a/netlink/rings.c
>> +++ b/netlink/rings.c
>> @@ -47,6 +47,7 @@ int rings_reply_cb(const struct nlmsghdr *nlhdr, void *data)
>>         show_u32(tb[ETHTOOL_A_RINGS_RX_JUMBO], "RX Jumbo:\t");
>>         show_u32(tb[ETHTOOL_A_RINGS_TX], "TX:\t\t");
>>         show_u32(tb[ETHTOOL_A_RINGS_RX_BUF_LEN], "RX Buf Len:\t\t");
>> +       show_bool("tx-push", "TX Push:\t%s\n", tb[ETHTOOL_A_RINGS_TX_PUSH]);
>>
>>         return MNL_CB_OK;
>>  }
>> @@ -105,6 +106,12 @@ static const struct param_parser sring_params[] = {
>>                 .handler        = nl_parse_direct_u32,
>>                 .min_argc       = 1,
>>         },
>> +       {
>> +               .arg            = "tx-push",
>> +               .type           = ETHTOOL_A_RINGS_TX_PUSH,
>> +               .handler        = nl_parse_u8bool,
>> +               .min_argc       = 0,
>
> Why min_argc is 0 ? Thanks for syncing kernel headers. I have patch for adding
> cqe-size command and will send after these are merged.
>
> Sundeep
I will revise it in v2.
>> +       },
>>         {}
>>  };
>>
>> --
>> 2.33.0
>>
>
> .
>

