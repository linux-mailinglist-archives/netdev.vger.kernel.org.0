Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30D0661FC7F
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 19:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbiKGSC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 13:02:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233090AbiKGSBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 13:01:55 -0500
Received: from wnew4-smtp.messagingengine.com (wnew4-smtp.messagingengine.com [64.147.123.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99892275F9;
        Mon,  7 Nov 2022 09:57:52 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id 914BC2B06725;
        Mon,  7 Nov 2022 12:57:51 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 07 Nov 2022 12:57:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1667843871; x=1667847471; bh=XO0EOt7FUL
        YlHx772XzPhlZxOfiZ7lFQETl4I1WXvcg=; b=klF4V71LCsFLTLGSfQCO2GhC0w
        kQIMbHuxgJZeNAK7xyl/7YDpNoneP3xqKBLJYnO66jzScXzMyoxUy/I3l1ACUiiK
        vNfKYI++fpgUfsXLRBKxo2JCXSL3tiuefbSfpODZjyfQLNnNJyKqQ8GDnyJQj9DG
        Hj+scXzFwwYGsuDRSWezLl7DK5WXv3pldgU3QQt6JWC6pBOLTMrUhv72RMnNQmT3
        RndWTLvl5Xd8Ka8qfgesEQC0h66lim69hRV4R/dm58JWdpvWO2ZvB7+CcCAg/jZc
        zOb6FjgjMK33sGn/E+barsv0qb5BJQ9q1+HN9LHHLY3G/KgN9QDDg90wBXMw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1667843871; x=1667847471; bh=XO0EOt7FULYlHx772XzPhlZxOfiZ
        7lFQETl4I1WXvcg=; b=pGRANgAV0DcJOf7vlYTvhFDIlF6AOayveuy+ha/jUeWM
        IWZ96M2iqMaQ5I9AY0mtLQCr4u0GD6ybY2zWzNAAzWj8A7YMf/UQVfBXcRqNqqLn
        /JPf3mFnuJsXBXhtZXabDxo7CTCahQLodbrMxpYtK58QaP8M9k/XiMAHH5lrQVXB
        g9RNCXAXmP3QuDaENlTHfji4d4JVBPVlQlrK0zG7AM0yKBBiKQ5K/eLS0R4AGpbM
        vKtxEyPKzkgejWlQjPpmSR+Xk/8YUPLK1cRTuk/wodvByRMZIpPM6LXFZawD3hqx
        YRDMdUHmOG3qsiJeeOWEwBaJQ5PFQgOF//+KJigEoA==
X-ME-Sender: <xms:HkdpY2uGDFZsnT10eW6fJjnvf5lZ6bQ0_BwnNqxF7m5nE1zc77XxiA>
    <xme:HkdpY7d5s-AH2DcudSREEj3ZK_991OEZ0ysHgI3NevX2swGIHi3pZbPuCuu537Llm
    sHYNMO5JuG-44_QxWw>
X-ME-Received: <xmr:HkdpYxyV2cl7rblH5YJtl5MbZAO9fW_8C-xWWD_JK7R6MrUgVPP6v0QDE8lIkprsX33C1XQlTyZYDk7y0mS9phDhyq0VgvE6q0jiFp-tKw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrvdekgddutdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfhgfhffvvefuffgjkfggtgesthdtredttdertdenucfhrhhomhepufhtvghf
    rghnucftohgvshgthhcuoehshhhrseguvghvkhgvrhhnvghlrdhioheqnecuggftrfgrth
    htvghrnhepveelgffghfehudeitdehjeevhedthfetvdfhledutedvgeeikeeggefgudeg
    uedtnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepsh
    hhrhesuggvvhhkvghrnhgvlhdrihho
X-ME-Proxy: <xmx:HkdpYxMRT3AtP3VP-WxQi50g1hb1Gxo4UBmALBgWPLyZzPzX8Rf7UA>
    <xmx:HkdpY28byU7g2QuwZRXy9U8FRFj07Njhl5lDKYSefVqIuX83OwpnrA>
    <xmx:HkdpY5UEgUdW1KcAZRz2h739EB5voLcNlHtWOAM25ogEj8Atp20REA>
    <xmx:H0dpY9klwZq-OxDzs86W4KdnZPxE5MtRuvB3VJFFQpoHa2qBnFoLHc-FtP4>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Nov 2022 12:57:50 -0500 (EST)
References: <20221103204017.670757-1-shr@devkernel.io>
 <20221103204017.670757-4-shr@devkernel.io>
 <d9761f0b-0a31-1ec9-66b8-371cb22250f9@gnuweeb.org>
User-agent: mu4e 1.6.11; emacs 28.2.50
From:   Stefan Roesch <shr@devkernel.io>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev Mailing List <netdev@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Subject: Re: [RFC PATCH v1 3/3] liburing: add test programs for napi busy poll
Date:   Mon, 07 Nov 2022 09:57:04 -0800
In-reply-to: <d9761f0b-0a31-1ec9-66b8-371cb22250f9@gnuweeb.org>
Message-ID: <qvqwr0yeabqa.fsf@dev0134.prn3.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,URIBL_BLACK autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Ammar Faizi <ammarfaizi2@gnuweeb.org> writes:

> On 11/4/22 3:40 AM, Stefan Roesch wrote:
>> +struct option longopts[] =
>> +{
>> +        {"address"  , 1, NULL, 'a'},
>> +        {"busy"     , 0, NULL, 'b'},
>> +        {"help"     , 0, NULL, 'h'},
>> +        {"num_pings", 1, NULL, 'n'},
>> +        {"port"     , 1, NULL, 'p'},
>> +        {"sqpoll"   , 0, NULL, 's'},
>> +	{"timeout"  , 1, NULL, 't'},
>
> Inconsistent indentation.
>

Version 2 of the patch fixes this.

>> +	if (strlen(opt.addr) == 0) {
>> +		fprintf(stderr, "address option is mandatory\n");
>> +		printUsage(argv[0]);
>> +		exit(-1);
>> +	}
> Don't use integer literal like 0 or -1 as the exit code in tests, use the
> exit code protocol:
>
>   T_EXIT_PASS
>   T_EXIT_FAIL
>   T_EXIT_SKIP
>
> They are defined in test/helpers.h.

Version 2 of the patch uses the above constants.
