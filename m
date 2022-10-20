Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1BB605B4B
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 11:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiJTJgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 05:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiJTJgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 05:36:12 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054A4164BD6
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 02:36:07 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MtMmZ4JNJzVhlh;
        Thu, 20 Oct 2022 17:31:26 +0800 (CST)
Received: from dggpemm500012.china.huawei.com (7.185.36.89) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 20 Oct 2022 17:36:05 +0800
Received: from localhost.huawei.com (10.175.124.27) by
 dggpemm500012.china.huawei.com (7.185.36.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 20 Oct 2022 17:36:04 +0800
From:   gaoxingwang <gaoxingwang1@huawei.com>
To:     <stephen@networkplumber.org>
CC:     <dsahern@gmail.com>, <gaoxingwang1@huawei.com>,
        <gnault@redhat.com>, <liaichun@huawei.com>,
        <netdev@vger.kernel.org>, <yanan@huawei.com>
Subject: Re: [PATCH] maketable: clean up resources
Date:   Thu, 20 Oct 2022 17:36:27 +0800
Message-ID: <20221020093627.2621638-1-gaoxingwang1@huawei.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20221017202914.64cdd5f3@hermes.local>
References: <20221017202914.64cdd5f3@hermes.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500012.china.huawei.com (7.185.36.89)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Oct 2022 20:29:14 -0700	[thread overview]

>On Wed, 12 Oct 2022 17:35:34 +0800
>gaoxingwang <gaoxingwang1@huawei.com> wrote:
>
>> Signed-off-by: gaoxingwang <gaoxingwang1@huawei.com>
>> ---
>>  netem/maketable.c | 3 +++
>>  1 file changed, 3 insertions(+)
>> 
>> diff --git a/netem/maketable.c b/netem/maketable.c
>> index ccb8f0c6..f91ce221 100644
>> --- a/netem/maketable.c
>> +++ b/netem/maketable.c
>> @@ -230,5 +230,8 @@ main(int argc, char **argv)
>>  	inverse = inverttable(table, TABLESIZE, DISTTABLESIZE, total);
>>  	interpolatetable(inverse, TABLESIZE);
>>  	printtable(inverse, TABLESIZE);
>> +	free(table);
>> +	free(inverse)
>> +	close(fp);
>>  	return 0;
>>  }
>
>Why bother. This is a tool only used during builds and this the end
>of the main program so all resources will disappear after return.

I found this issue because a white box scan of the code. Maybe fixing this will save us from the effort to explain it.
