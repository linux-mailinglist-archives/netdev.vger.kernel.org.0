Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280F864AB14
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 00:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbiLLXFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 18:05:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiLLXFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 18:05:04 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE2EB1B1F8;
        Mon, 12 Dec 2022 15:05:02 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id vv4so32214210ejc.2;
        Mon, 12 Dec 2022 15:05:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=I+VqCCItjAiTuX36aatqQBDZyZjTv4h4HG8Pe66pjAI=;
        b=KW5X/h1YAN0FAfC+aGcTAdIGMd059e/9Yl1Bm6UpOk0vGgmhtI6dRaaHQcwCmxXzUJ
         zZrgg0/c/kIMmt4rW8HADYfnkqO3FNk0miGTfnnecxzvLC6tkRQZF2taXMOprjv/ncYC
         o9ymkrqoVAVm4HLgWGvpTDh5sIdBoFTskHXRab+cY7K8IKh2vbE5H9q1jDYSMinIq0Za
         52Gx+igOq0dat/NBcPBELoHFd9pTJfhAU8u2I5rxY2a2ur30/yRetuCd60nOHSVPRQRc
         bC1zGg9XpUcetchAEtcdmck+PDNzXmh/AVzcI/+1F66Ynj3hD7egD3I2EULpmGqkunTO
         oxHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I+VqCCItjAiTuX36aatqQBDZyZjTv4h4HG8Pe66pjAI=;
        b=e6Hj79DPPbpV+sY1/iRcyze2glMZPqUhCijmlHP875BwLmWquhgymL7vnvH9THi07s
         z/az0j7kk42phoRFHSzB89YdlElJHM5HJ+Dhyw9xwFR/tWeIT/2+5Gow5Ah7OAfNxSXn
         Kz5KnwP8pLrms25EnSKVcKl1LYplksTSgjl9ib38JjQrHV1p/qXImZ5gfb53a/3Cnfx/
         S3kYo3W5EPaDmXxtqGeMmXu6/Rbw1to65/jh/eQpXc7doO0ug1jjw67uRHvgRXX0mgIJ
         UAWidtXq+xZCJqc8E8ACqx6V5AdILQDOdeBxPgmOQJVyiDITXFIA901ZMt4a5SUIwBsj
         6paQ==
X-Gm-Message-State: ANoB5pkPQ5nxbYFUgbq0JL0vQG0MMWo2/vrFI/dYvTBhm/cwQz+1K1Lg
        XhiX0yTg5rE68mJq09uuoac49c0KH9ZKNmva2Jb30b3/e3I=
X-Google-Smtp-Source: AA0mqf6ELP5N3gVuA0hEEYlwbXIIXYRbnIGBt1ZLeFjuSRpzzP0nmw5UGivqPay49MZnRihpQMmal45uHX7SwIvhLQc=
X-Received: by 2002:a17:906:2594:b0:7c0:8d06:33f8 with SMTP id
 m20-20020a170906259400b007c08d0633f8mr34495675ejb.150.1670886301219; Mon, 12
 Dec 2022 15:05:01 -0800 (PST)
MIME-Version: 1.0
References: <20221209220651.i43mxhz5aczhhjgs@skbuf> <20221210004423.32332-1-koshchanka@gmail.com>
In-Reply-To: <20221210004423.32332-1-koshchanka@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 13 Dec 2022 01:04:49 +0200
Message-ID: <CA+h21hruzcind_Wkr7xsRK8x4ygZAg-x--vY_O_Opqtjh3dqOA@mail.gmail.com>
Subject: Re: [PATCH] lib: packing: replace bit_reverse() with bitrev8()
To:     Uladzislau Koshchanka <koshchanka@gmail.com>
Cc:     netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Dec 2022 at 02:47, Uladzislau Koshchanka
<koshchanka@gmail.com> wrote:
>
> Remove bit_reverse() function.  Instead use bitrev8() from linux/bitrev.h +
> bitshift.  Reduces code-repetition.
>
> Signed-off-by: Uladzislau Koshchanka <koshchanka@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
