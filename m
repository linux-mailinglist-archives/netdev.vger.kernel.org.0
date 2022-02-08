Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4789E4AE345
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 23:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386578AbiBHWVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 17:21:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386491AbiBHUmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 15:42:08 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2417FC0612C0
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 12:42:07 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id j14so592502lja.3
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 12:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=1arNLeaBe5R3++hUI9/c4FXwtGni/EUby5Sin47pTdk=;
        b=Lb7EmKUMUybeoFQm61QwAXKAIUC96MWw5KHpW6AXfdODIb97hzU4gI1Jaum5QRmbJD
         I5Uy4zR+U1GCM4wXIgjANF4btuzAUtWHC44SOc56L7XL0ZZaVd6luXrADm0RItW0MYGf
         qMSECZalMnz6eRPrXJzUORG7Hmx3dWAKi4/3I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=1arNLeaBe5R3++hUI9/c4FXwtGni/EUby5Sin47pTdk=;
        b=2Q9IdRF8+nhUMQ6r53fRsv1Ydq6eFYiMnh+Vt+Ih+9sWOBssCNXu5oFBkvp7o+ctiv
         UrN7x+arVB7KmCtt3g/PcB1VAxCWmyGTYQH/vMogOogM3UuS7VIzv04vopn+dszdH4J6
         kordx3Vyv5SqOAL9LAvWTNtNe/K0sEJpHStEI/xo8fzMR49t8G4qoaWJik0RgM1NiNE8
         PjjvPv/o4T5jwUpYC5vN1cM0l9OA4+4AJ6wijJzesSqzcGAEkJ0Km2IYQ3TG6tT8b8Ld
         rGULj6vzg0RFjuzzqeeIBIMYthAREaXKPtDg0/BqwpiAbIV9i2LEp2XG7bhflwZ2pExg
         Pjgw==
X-Gm-Message-State: AOAM531PsyUQZhMKOZ/ZVYw/JK8ARjpHaKFCirB4yG+7q6P7/9jCwfh8
        eAd9sm0LMTCW3JhBHZZ7W8lKgw==
X-Google-Smtp-Source: ABdhPJyxVwpRL74mQEbdgzHrBRw1AQc1y8JfoA1keQTYYNxstmTY9HZuC7hb70h9WGhv/VfOqUrgLw==
X-Received: by 2002:a2e:bf08:: with SMTP id c8mr3872583ljr.281.1644352925372;
        Tue, 08 Feb 2022 12:42:05 -0800 (PST)
Received: from cloudflare.com (2a01-110f-4809-d800-0000-0000-0000-0e00.aa.ipv6.supernova.orange.pl. [2a01:110f:4809:d800::e00])
        by smtp.gmail.com with ESMTPSA id m17sm2052933lfr.24.2022.02.08.12.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 12:42:05 -0800 (PST)
References: <20220207131459.504292-2-jakub@cloudflare.com>
 <202202080631.n8UjqRXy-lkp@intel.com>
 <CAADnVQKGF=YaKvzWZFO1c9bO63XHoiD=i-w-chCeSbaNoRfdwg@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     kernel test robot <lkp@intel.com>, bpf <bpf@vger.kernel.org>,
        kbuild-all@lists.01.org,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Subject: Re: [PATCH bpf-next 1/2] bpf: Make remote_port field in struct
 bpf_sk_lookup 16-bit wide
In-reply-to: <CAADnVQKGF=YaKvzWZFO1c9bO63XHoiD=i-w-chCeSbaNoRfdwg@mail.gmail.com>
Date:   Tue, 08 Feb 2022 21:42:04 +0100
Message-ID: <87y22lqeeb.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 08, 2022 at 08:28 PM CET, Alexei Starovoitov wrote:
> On Mon, Feb 7, 2022 at 2:05 PM kernel test robot <lkp@intel.com> wrote:
>> 7c32e8f8bc33a5f Lorenz Bauer 2021-03-03  1148
>> 7c32e8f8bc33a5f Lorenz Bauer 2021-03-03 @1149   if (user_ctx->local_port > U16_MAX || user_ctx->remote_port > U16_MAX) {
>
> Jakub,
> are you planning to respin and remove that check?

Yes, certainly. Just didn't get to it today.

Can either respin the series or send a follow-up. Whatever works.
