Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381E16B80DE
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbjCMSkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbjCMSja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:39:30 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1D8574D2;
        Mon, 13 Mar 2023 11:38:38 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 8111B5C0129;
        Mon, 13 Mar 2023 14:37:38 -0400 (EDT)
Received: from imap50 ([10.202.2.100])
  by compute4.internal (MEProxy); Mon, 13 Mar 2023 14:37:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=umbraculum.org;
         h=cc:cc:content-type:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; t=1678732658; x=
        1678819058; bh=9epCb7R3dWupKQUyh0Z1HLslQduuZW8uIfO0F3Lwz8g=; b=S
        xba8IZIp1Hec/8n5SUhBxHScMcHJtS1XUdx7AT+GWt7ht6kZDg0GpngDuVbS6WxX
        HoiKAxCj+5KMG+NlkX/fiyZqa9HmBbajib/3QJstU+leiP6yHGpvhXj30NDVqVFQ
        FtJuzNHu4UBys+xMo2Jc/7wYeKR2Ii2uWl09frKKHxykoCToAq+5B8nJb0hA8x7v
        NOTNMb2Q5W2gWjUzuRGz0CKukuJPM4ELi7o6Zawg/M3j4yVQAZA99u8+zkE/3Yd6
        s5stHoJByPYGAjbSNFMyHsagS9Os9EqoBPFCeeFG8NlBAkrwlFhsIQiFSHrOukDS
        6riR6rIcGZFpuNEGQQ6FQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1678732658; x=1678819058; bh=9epCb7R3dWupK
        QUyh0Z1HLslQduuZW8uIfO0F3Lwz8g=; b=PW5O5SPn0YSe6ycNQK58huEK0XzHe
        n56KXI2Q5owzsR4xRf7IV9kX6SWA3bJRN1if7Jt6rFd1r8NKyJ2ecY2xw+FvLh7/
        hDWBEniJc4rCDhwMY6dP3atzNsp2zawLxLIVDkM3HLI8gkE+pMn+bG4Hb0jEi/jP
        TYYASn3OmhHkOnwv5a2aoCRRPNePtyYK8WjzQfXHQ8t1FMP43d0GfRHFpnl4JnxE
        Zcm7TL/wzQ41q+/Q+6yiD+0Rw/F2yGVwH5UlC4rztK9OLKzdYYMR7ZDaZsBm1jVI
        QvzNSc002VrjdcXXgvKSdIgMYAXquj14Z7JKGpWaIs42Wqcm7NC1TuQ3Q==
X-ME-Sender: <xms:cW0PZHyTPcIRIXOWyuml3oKW5VwxKCpP5LxKctqLCgQbEU-00989ug>
    <xme:cW0PZPRP_8xUq4Y6dd9R4am3yWFnm41dpbQ3db3aX1horMT3FJT0tVIpADwkc3Y2T
    DbX8MIkA7JnXyDuFT8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddvgedguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdfl
    ohhnrghsucfuuhhhrhcuvehhrhhishhtvghnshgvnhdfuceojhhstgesuhhmsghrrggtuh
    hluhhmrdhorhhgqeenucggtffrrghtthgvrhhnpeefteekheegiedvieefteejhfeifedv
    veegieffffduveehffevtdetvdefgeehteenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehjshgtsehumhgsrhgrtghulhhumhdrohhrgh
X-ME-Proxy: <xmx:cW0PZBWb2u5NfLhD4kbwdPU5yDZhbc2dAWvcVS7JrWWtCTnY3GTAHg>
    <xmx:cW0PZBhSqIyNWpFPwr2S6OENvbK9F0hT1-LMVIV5Dg-NHkIJi64btQ>
    <xmx:cW0PZJBI0Nca_bcoqZpoKw0Gfdxp_uQ1mHgo17s1lLU0BPYyxNuf-w>
    <xmx:cm0PZOKgADYXjUVsbbLAKCpWIxW1nPAiQA0nsSOsdu5zgze7TmF62g>
Feedback-ID: i06314781:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 7675F1700089; Mon, 13 Mar 2023 14:37:37 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-221-gec32977366-fm-20230306.001-gec329773
Mime-Version: 1.0
Message-Id: <bd639016-8a9c-4479-83b4-32306ad734ac@app.fastmail.com>
In-Reply-To: <20230207104204.200da48a@kernel.org>
References: <20230205201130.11303-1-jsc@umbraculum.org>
 <20230205201130.11303-2-jsc@umbraculum.org>
 <5314e0ba3a728787299ca46a60b0a2da5e8ab23a.camel@redhat.com>
 <135b671b1b76978fb147d5fee1e1b922e2c61f26.camel@redhat.com>
 <20230207104204.200da48a@kernel.org>
Date:   Mon, 13 Mar 2023 19:37:00 +0100
From:   "Jonas Suhr Christensen" <jsc@umbraculum.org>
To:     "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Michal Simek" <michal.simek@xilinx.com>,
        "Harini Katakam" <harini.katakam@amd.com>,
        "Haoyue Xu" <xuhaoyue1@hisilicon.com>,
        huangjunxian <huangjunxian6@hisilicon.com>,
        "Wang Qing" <wangqing@vivo.com>,
        "Yang Yingliang" <yangyingliang@huawei.com>,
        "Esben Haabendal" <esben@geanix.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 1/2] net: ll_temac: Fix DMA resources leak
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 7, 2023, at 19:42, Jakub Kicinski wrote:
> On Tue, 07 Feb 2023 12:36:11 +0100 Paolo Abeni wrote:
>> You can either try change to phys type to __be32 (likely not suitable
>> for -net and possibly can introduce even more warnings elsewhere)
>
> FWIW that seems like the best option to me as well. Let's ignore the
> sparse warning for v3 and try to switch phys to __be32 in a separate
> patch for net-next. No point adding force casts just to have to remove
> them a week later, given how prevalent the problem is.
>
>> or explicitly cast the argument.

I no longer have access to the hardware, so I'm not rewriting the batch. Feel free to take ownership of it and fix what's needed.
