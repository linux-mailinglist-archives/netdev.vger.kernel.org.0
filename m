Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2198249288
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 03:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgHSBtq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 18 Aug 2020 21:49:46 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:46284 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726372AbgHSBtp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 21:49:45 -0400
Received: from dggeme751-chm.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id A45ED5EB70E9F5F51687;
        Wed, 19 Aug 2020 09:49:43 +0800 (CST)
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme751-chm.china.huawei.com (10.3.19.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Wed, 19 Aug 2020 09:49:42 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1913.007;
 Wed, 19 Aug 2020 09:49:43 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     David Miller <davem@davemloft.net>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "kafai@fb.com" <kafai@fb.com>, "ast@kernel.org" <ast@kernel.org>,
        "jakub@cloudflare.com" <jakub@cloudflare.com>,
        "zhang.lin16@zte.com.cn" <zhang.lin16@zte.com.cn>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: Avoid strcmp current->comm with warncomm when warned
 >= 5
Thread-Topic: [PATCH] net: Avoid strcmp current->comm with warncomm when
 warned >= 5
Thread-Index: AdZ1ytv+wdP6UYOgWUmWGFIMW1oMuA==
Date:   Wed, 19 Aug 2020 01:49:43 +0000
Message-ID: <cdcd79834e5145718a224f0610b01a3c@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> wrote:
>From: Miaohe Lin <linmiaohe@huawei.com>
>Date: Tue, 18 Aug 2020 07:41:32 -0400
>
>> @@ -417,7 +417,7 @@ static void sock_warn_obsolete_bsdism(const char 
>> *name)  {
>>  	static int warned;
>>  	static char warncomm[TASK_COMM_LEN];
>> -	if (strcmp(warncomm, current->comm) && warned < 5) {
>> +	if (warned < 5 && strcmp(warncomm, current->comm)) {
>>  		strcpy(warncomm,  current->comm);
>>  		pr_warn("process `%s' is using obsolete %s SO_BSDCOMPAT\n",
>>  			warncomm, name);
>
>We've been warning about SO_BSDCOMPAT usage for almost 20 years, I think we can remove this code completely now.

Looks sane. Will do. Many thanks.

