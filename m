Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E907859CE90
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 04:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239237AbiHWCc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 22:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235768AbiHWCc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 22:32:28 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84AF95C341;
        Mon, 22 Aug 2022 19:32:27 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id q81so2287585iod.9;
        Mon, 22 Aug 2022 19:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=CnrT01jRgnkD6sQ11+EqvOQcHbSfJWNGFwJDCL2hAgA=;
        b=JLueLcIE4+E5lxu0riv133D13DyGP/qyEbK5FVQe4sixFkN3kLC/XaUDhMOKs7QR0E
         PQlvoO2Hjx7N1UazeivvKcyK0h/Rb2/0wvdfCypQnjz4EPH8nLTBDBitY5JmTjDj04EP
         Y6mXW1piktMRYM0WVZhfljq9vNl712X4mKmW24m0FA32/IwkiUfHDl1MXSga6ZHhFziO
         6P+G++MM7YIEXuL+e8yLZEkAFDh29lAilW3BNstsiq/PrDNI59CWXk6I5NpJ/Z0VKt8t
         uNlIPLB01QHie4BnZxZz22+nfLvAehXQd3TkDP+arCT8sTyYgbgbwE0L+reBAuYnt1Ma
         4j4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=CnrT01jRgnkD6sQ11+EqvOQcHbSfJWNGFwJDCL2hAgA=;
        b=xU9vQP6PUjPSZZqBo0ZI6MO2btNGeV/AOEL334xJPXasO2UjPPCdJ1GeOSGgsxCPqT
         ffcLZWsa2fiRu6L0YF6qbUs7HLztkb3nmzH9zXTXKjY/xVpeIqoGXd9FkHqw1a7tRJXM
         O4L/Xtgvtvs04fHqT0Tot9UxIi/Zrh3FiSdJRu7BhkM/34iJbDP+T9cF+tRa7NY44yBS
         MmfRxJ13Jp8M8xRM7vAHG7GpJ1MNCF8sbiGy6l2rjIXtAG4oQ4UAQlcRvwVWj861GDXQ
         7EbXOWjGjCvrzzJmxN2kGSXFHAenh+jWegKIZhD9vAxYKcnfpfi053IYdjXxm+fnjFyx
         UnFQ==
X-Gm-Message-State: ACgBeo2JD6GR3FFPb83LBxqsV+7I1yFa9tLRp5fbucBO4kDXXeC1SbIW
        sj9ditr/HHOYDsZadY+qHgP89aLPdQikpEsRvzA=
X-Google-Smtp-Source: AA6agR6NV1DCPdo8gtrNxwMx+estIwLzyJ0y9MRutEhiOPqV6KgveU/baZIydXpfSjgOR5V2rjU0PHHVqLqcJ0LeFMs=
X-Received: by 2002:a05:6638:2381:b0:346:c583:9fa0 with SMTP id
 q1-20020a056638238100b00346c5839fa0mr10621772jat.93.1661221946916; Mon, 22
 Aug 2022 19:32:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220822235649.2218031-1-joannelkoong@gmail.com>
In-Reply-To: <20220822235649.2218031-1-joannelkoong@gmail.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Tue, 23 Aug 2022 04:31:49 +0200
Message-ID: <CAP01T74LUHjpnVOtwV1h7ha4Dqz0EU5zjwojz-9gWPCN6Gih0Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 0/3] Add skb + xdp dynptrs
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     bpf@vger.kernel.org, andrii@kernel.org, daniel@iogearbox.net,
        ast@kernel.org, kafai@fb.com, kuba@kernel.org,
        netdev@vger.kernel.org
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

On Tue, 23 Aug 2022 at 02:06, Joanne Koong <joannelkoong@gmail.com> wrote:
>
> This patchset is the 2nd in the dynptr series. The 1st can be found here [0].
>
> This patchset adds skb and xdp type dynptrs, which have two main benefits for
> packet parsing:
>     * allowing operations on sizes that are not statically known at
>       compile-time (eg variable-sized accesses).
>     * more ergonomic and less brittle iteration through data (eg does not need
>       manual if checking for being within bounds of data_end)
>

Just curious: so would you be adding a dynptr interface for obtaining
data_meta slices as well in the future? Since the same manual bounds
checking is needed for data_meta vs data. How would that look in the
generic dynptr interface of data/read/write this set is trying to fit
things in?



> When comparing the differences in runtime for packet parsing without dynptrs
> vs. with dynptrs for the more simple cases, there is no noticeable difference.
> For the more complex cases where lengths are non-statically known at compile
> time, there can be a significant speed-up when using dynptrs (eg a 2x speed up
> for cls redirection). Patch 3 contains more details as well as examples of how
> to use skb and xdp dynptrs.
>
> [0] https://lore.kernel.org/bpf/20220523210712.3641569-1-joannelkoong@gmail.com/
>
> --
