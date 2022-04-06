Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A664F576B
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 10:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236302AbiDFHQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 03:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1452335AbiDFGnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 02:43:55 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5382407E19
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 21:42:17 -0700 (PDT)
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 1157F3F85F
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 04:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1649220135;
        bh=Mt/wIr8VCHfxx+fAT86RPcS+1hpBF4cXlsZS+mb9xdE=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=iUxOvNG6YajEHp0kF2JdMv/52tmbHq5DRlxwkH+QUcg186VpeTNqgoccW2JMMf2ji
         aP7tWesAOlh6pHj1OzkqU7c6smWgkFYBL7yBhaKMOSyJ14hbkhkW12sawK/pUvi7Yw
         lYgPqOYRWOwXz4ljmXdLj6ArCxWZ+cqnnqwBt/fjlN0sxSYvZMWiMVFqWPTN5xzDbP
         aWgYrLG1F/g7Uqala43Zwlised96gzeiFSPeobgq2uL7nOv3AR4ZI9/yfPLqI0XTel
         2IEpUtCd0CgjJ8eAp9bMLrQGmTyWbhivmr0TKSE1NZURD8wsmC2jbxiHGecGzS/Zi/
         WMzYmJUcOYaJg==
Received: by mail-ot1-f71.google.com with SMTP id a6-20020a9d5c86000000b005cb42f070c3so752996oti.18
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 21:42:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mt/wIr8VCHfxx+fAT86RPcS+1hpBF4cXlsZS+mb9xdE=;
        b=qnLwIPKRuzjOHKtrglYCppVKaalCC1zZxarT27X7GWmLk7LrzmYr+IU3tvOg+fT9qI
         u7xzHVCdVSMnnu1cvycIKMTJ9s1zHMpOFulkrKYSTlc/CcSUFHOOrJ41ySZUKwe5NQh7
         JuyYsUQZOAonHGyC5VN58TIxBuXGw/dqXP9cHNdqqdiq/ug8waO4lfKd0kYRH6KeqsLC
         n/j/ql2I6Zd5KqD7DWMpaAsMsgo4PA/H1ToShxYKyF3npD71sEOgGG3RTj/B+9BCz8PU
         ZZ7Gpfy3lsoiO5H3J6XUlUKjitafVqY5xSHJN+e1VeYgzMHlwzw7R+QPLHOxbsjPdPCL
         lCTQ==
X-Gm-Message-State: AOAM533HcyGYJMr5cnNR5DzOVtS3dtD3sBIyjgs7ST/NbAu5fK0BdDLk
        /HR1E8q/Vh3i8J9wiuLAaj2zxUskj2JD1+6yfY/nYQ+z3EFl+S/2ubD2gsZ+AgcFD2geXc9awVx
        Q6BuGYfYC5cNsjjg7llk5tH+Wj8wiP7lUXn8fQWqag2I7yCovhQ==
X-Received: by 2002:a05:6830:2456:b0:5ce:7f4:c702 with SMTP id x22-20020a056830245600b005ce07f4c702mr2472255otr.269.1649220130607;
        Tue, 05 Apr 2022 21:42:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHon0m0wisgENa7vRcxIQKSklrsxRLeAHmcisDb0KZ+faoRnPeYjrTDc6wEXCRXA5PMWMjLRWCaPLy2KtTmTE=
X-Received: by 2002:a05:6830:2456:b0:5ce:7f4:c702 with SMTP id
 x22-20020a056830245600b005ce07f4c702mr2472245otr.269.1649220130353; Tue, 05
 Apr 2022 21:42:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220325035735.4745-1-chris.chiu@canonical.com>
In-Reply-To: <20220325035735.4745-1-chris.chiu@canonical.com>
From:   Chris Chiu <chris.chiu@canonical.com>
Date:   Wed, 6 Apr 2022 12:41:58 +0800
Message-ID: <CABTNMG2z33a6FgsBPbj=cFN9umVdhF8nXwsnVkkF--PYbeGS7Q@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] rtl8xxxu: Fill up more TX information
To:     kvalo@kernel.org, Jes.Sorensen@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     code@reto-schneider.ch, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 25, 2022 at 11:57 AM Chris Chiu <chris.chiu@canonical.com> wrote:
>
> The antenna information is missing in rtl8xxxu and txrate is NULL
> in 8188cu and 8192cu. Fill up the missing information for iw
> commands.
>
> Chris Chiu (2):
>   rtl8xxxu: feed antenna information for cfg80211
>   rtl8xxxu: fill up txrate info for gen1 chips
>
>  .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 104 +++++++++++++-----
>  1 file changed, 75 insertions(+), 29 deletions(-)
>
> --
> 2.25.1
>

Gentle ping. Any comment or suggestion is appreciated. Thanks
