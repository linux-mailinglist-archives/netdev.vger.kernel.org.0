Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14147539705
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 21:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242547AbiEaTcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 15:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbiEaTcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 15:32:01 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44032996BB
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 12:31:59 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id v1so2284115qtx.5
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 12:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i/QwWu70ex48l5KLIiX4ky+goU8KwWMMAyPZw+RolfU=;
        b=F+/1vumnzj6/CY5hCc3CJLB3+7wxawFXP3jsG/VSt3FRYJAmYnJJopysb+tC8bXTAB
         JQI+i015cqyd4FA2vZA8GvHkglSKXT1RDm50MVvh9L5LvRwsP0AOuD4PE/qnP7FeKXZj
         V2pLX05L0bUr+K2KFv7TQPUpj52K34ivBYUWPxvW8NFJuH+cYNnayWCUJ4hp6gXkFSR6
         qIQV6HEHWaAh/n7PrR8Nt+I5CiH6UahlUasBPluT86wLnsVOWtFK5XtBRzNUBNAfVGeg
         ZQTVRHQhnL1kwFshe7iz3ODJWbKMosjORWekTqN2peayczA2zIqNu7vMrD92M2Fkmfdb
         1mEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i/QwWu70ex48l5KLIiX4ky+goU8KwWMMAyPZw+RolfU=;
        b=OiwLqZ+jRTOTU10z4ZbZXwLHrUozXR00S79uUUZjavc/cT+zPyXLT9c0mB0tcNaYqN
         XVnt0hFUplsvKKqrRuOyihA5ylbbz/a0orOEto5BzmAZ4pPyWdZY0fxGaFaTxVlgNHoN
         +jHvFllqeKC0KAvFS9b0OfBa0/bBFajp1r3IyBndFAswyY4woeptJTxTOjnAilu+F3IC
         0iu6Bq8Lm5g/AZTBN0K723tvBrjap0zMmThBd47RMY48rXiHDxsO0w9BhJkmPrgQPLs8
         38bVfnVUZOZfWV9SG4h/kgU4z210nP9IGYqcC4OCg091mDLwi17yRxCiASx/MZQCubDw
         kTEg==
X-Gm-Message-State: AOAM53003eCP2rJYS8Eaff47ckD3IZfXdPCEtyY5hVKMIA1SxX2Qs+4t
        kIYcmzkrwenOM7ZIsuRopUke4DVGe2c=
X-Google-Smtp-Source: ABdhPJxTabQT1B40Gh55bKDe15GV0HAo4oyxn+8/SoxjAcbBpZv/BIkcW15nznhc8iGsYze5v1khdw==
X-Received: by 2002:a05:622a:1d1:b0:2f9:34d3:d900 with SMTP id t17-20020a05622a01d100b002f934d3d900mr37342819qtw.89.1654025518372;
        Tue, 31 May 2022 12:31:58 -0700 (PDT)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id a5-20020a05620a124500b0069fc13ce1d6sm9939255qkl.7.2022.05.31.12.31.57
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 12:31:57 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id f34so12583763ybj.6
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 12:31:57 -0700 (PDT)
X-Received: by 2002:a25:1005:0:b0:65c:cfe6:3e70 with SMTP id
 5-20020a251005000000b0065ccfe63e70mr12941417ybq.513.1654025517403; Tue, 31
 May 2022 12:31:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220531185933.1086667-1-eric.dumazet@gmail.com> <20220531185933.1086667-2-eric.dumazet@gmail.com>
In-Reply-To: <20220531185933.1086667-2-eric.dumazet@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 31 May 2022 15:31:20 -0400
X-Gmail-Original-Message-ID: <CA+FuTSf_27LFtjFF8bQpnoNzohD_Qm0HLEptetbP-aaxBoohjg@mail.gmail.com>
Message-ID: <CA+FuTSf_27LFtjFF8bQpnoNzohD_Qm0HLEptetbP-aaxBoohjg@mail.gmail.com>
Subject: Re: [PATCH net 1/2] net: add debug info to __skb_pull()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 31, 2022 at 2:59 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> While analyzing yet another syzbot report, I found the following
> patch very useful. It allows to better understand what went wrong.
>
> This debug info is only enabled if CONFIG_DEBUG_NET=y,
> which is the case for syzbot builds.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: Willem de Bruijn <willemb@google.com>

The skb_dump output (including packet headers) on these bugs will make
root causing these failures a lot easier in the future. Thanks!
