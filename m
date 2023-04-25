Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBA86EE332
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 15:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233986AbjDYNg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 09:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234297AbjDYNgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 09:36:39 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D7813FAD
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 06:36:18 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id A7CE33200908;
        Tue, 25 Apr 2023 09:36:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 25 Apr 2023 09:36:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682429777; x=1682516177; bh=Bt8RyG+czE7kB
        /lZO/xvsbOVG+O9kaUNsvcGQuo+Nw4=; b=SskvPagj9ByqB8ZhNQrS5isWbhYhl
        0K8DjiRWXe0kW0rYEIZPmulUKeZJMKBfwNc2/Qy4SXxI22YlgBOT0VFQx69pXrmM
        TfwFwwTGRka/W1p6L230LpJdKvo/BBuPrGMV2mI/G4pH7jmaXPb7PdZMm2kxomDI
        2LdU+cepAJx0fd+eh/0Fu//oMmC2EMvBF8fHW43X5Ot6+Tp4mLg/h7OxExBU1PuN
        78r+aQEUGtLflFocupTe5wD8h+jIGHtzd3KfH/VM7oLG9D7tlQJhgobyzdf4kVYU
        SzWGuimG5PQXs559NLx+2z1DyazhEmHnG+n0RBz1lY2yjy2kpP/Y84Ing==
X-ME-Sender: <xms:UNdHZKwEsvPbJsq0qFP82XtoXHmXB9TmAKuMREX5AhlFAZSpCDGVpw>
    <xme:UNdHZGShhHEDABaXRsRp8xqKUIIcRlIUDaoL_RX6I4Tbd3f_pilSYObMS44YGBl27
    JWSA6pEo0U5ygM>
X-ME-Received: <xmr:UNdHZMXnCPZl-BQVICVvq1ifDmKpciZlgl9U5_BEJNOUPN2dmOtc8f9Cibz4g9nk0bXPzFvDJFZLtJ-T2JAoqLb7hOY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeduvddgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:UNdHZAgZhYZG0U07JqzBAUL_WxQEyVBaoZZClNUJeeT3eYGqjxWRsw>
    <xmx:UNdHZMCczBq5QE_qC93gaFrhCFDU0evfI3xqeD57Q2LKe25kcEacjQ>
    <xmx:UNdHZBLa2b8xzV3eVwoSlR36kezpHPc2MDRKYUNO42A2yxFh9FJHUA>
    <xmx:UddHZKBMqW_-OVEhi_6S2jMS6_EBqCgOVi88SJMzPxCz-ltV2Lc4Tg>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 25 Apr 2023 09:36:15 -0400 (EDT)
Date:   Tue, 25 Apr 2023 16:36:12 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, simon.horman@corigine.com
Subject: Re: [PATCH net-next v5 3/5] net/sched: act_pedit: check static
 offsets a priori
Message-ID: <ZEfXTLmTZUzVA4m4@shredder>
References: <20230421212516.406726-1-pctammela@mojatatu.com>
 <20230421212516.406726-4-pctammela@mojatatu.com>
 <ZEfD5e1MI+LUZVau@shredder>
 <f331c935-85b6-5e1a-d01b-57041aa12419@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f331c935-85b6-5e1a-d01b-57041aa12419@mojatatu.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 09:27:32AM -0300, Pedro Tammela wrote:
> Can you run the syzkaller corpus with the following patch?

The C reproducer allows anyone to test a fix without any special
dependencies. The reproducer triggers the issue without the fix and does
not trigger the issue with the fix.

Thanks
