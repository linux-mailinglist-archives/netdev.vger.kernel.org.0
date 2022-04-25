Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B18150EBAF
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 00:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235671AbiDYWYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 18:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343497AbiDYV2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 17:28:22 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBFDF1C
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 14:25:14 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id y14so15262986pfe.10
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 14:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u7hl5IFxDI2eHkQRlXGbeDMciir9ECH93wIEe4AG2EI=;
        b=OJOPp5x6ocU08AevEsYvyRugrSR63fLG3uhAcQNzXko/tlxNS4dLzOSy6TOP4qTHY7
         3EylhuL4O3ShsCABXnEpCklGW1WYN4raTNoymTAYIRqGXUEl6Pd7wkV6q4QoxJB36ehW
         Z10y5YmwWpTLQKr+I6SmSdiEvgO7Z5w7qAOqxdJX1O/OgGy2hd1r4OgWbtXlqRkG3vBy
         dqnqJJ0XY4tRDVxOtEGc7LoAMyO+f6qCYGMSM+56h9NWqZZyV8J59JVP39MUs4eZ7Ui1
         TDm+0paEaftGWOhnk73QHvi7K0Bun+9M0L1zTcqLMstbZCosXO6LusdaQsTPlrg1qShU
         bd6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u7hl5IFxDI2eHkQRlXGbeDMciir9ECH93wIEe4AG2EI=;
        b=BtNwVfAcOuKAQylsKnLpf018PQK/HDGJPMaTxLpWBh5iZaJScemAtD6bfqUTiuPoFO
         hdKbRBUW5VRtjvMUGy8DH7sE38Y016+KZCK9xSEQ/dfaxlBX4zs+2QC/220XKK8rIxRR
         Qeek0Dmhbom2ZniBEl9c4RE3WAGpcaCHSZ0wA4xhjP4rHQYv4AsAhgTOXt97D8+787UK
         UzlhXTwlHchU2ZK9BdgtU4FPwU3xTZIZLHNN5Cyhzj7C63W1IXYkhmUd2YKycnzKbBp6
         pzFkAzHQlKPSk6AELQH89hGsRjYZ9ooRpW1TySTidjyR3N3N0DST52Hq9juEpj+qwYe6
         rg3w==
X-Gm-Message-State: AOAM532oMKwee7ZuPsR5SEo3SbuZYYi84MNy9bWEuU91Xm9X3WGCSPfM
        rhYyKPqK5GYAeUwP1ez+BaRmMZArsY9aJJPiySEmLw==
X-Google-Smtp-Source: ABdhPJyjvuSyMhaDXA5uS4wqJXkzuCx/QHOdMUNQ0WA32JkkTRIkvO9Y+T/QmJNrakGd6o2JPiD3KA9ScfGvzuSGj78=
X-Received: by 2002:a63:42:0:b0:3a8:47f7:bf0d with SMTP id 63-20020a630042000000b003a847f7bf0dmr16823748pga.276.1650921914481;
 Mon, 25 Apr 2022 14:25:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220424051022.2619648-1-asmadeus@codewreck.org> <20220424051022.2619648-5-asmadeus@codewreck.org>
In-Reply-To: <20220424051022.2619648-5-asmadeus@codewreck.org>
From:   Quentin Monnet <quentin@isovalent.com>
Date:   Mon, 25 Apr 2022 22:25:03 +0100
Message-ID: <CACdoK4+WVdXz0jqKijF+wg=1M9V-=JpBHeJD5RJfNzq67TD+5A@mail.gmail.com>
Subject: Re: [PATCH 4/4] tools/bpf: replace sys/fcntl.h by fcntl.h
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Apr 2022 at 06:11, Dominique Martinet <asmadeus@codewreck.org> wrote:
>
> musl does not like including sys/fcntl.h directly:
>     1 | #warning redirecting incorrect #include <sys/fcntl.h> to <fcntl.h>
>
> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>

Acked-by: Quentin Monnet <quentin@isovalent.com>
