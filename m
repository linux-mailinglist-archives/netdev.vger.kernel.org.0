Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E3253418F
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 18:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245473AbiEYQc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 12:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiEYQc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 12:32:57 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150D38A325;
        Wed, 25 May 2022 09:32:55 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id i27so42728991ejd.9;
        Wed, 25 May 2022 09:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ryx2Ks43HYE8Q7pTv7hpRWZjiZujiJ46sfljr3BjzG0=;
        b=NPpZSzFaSgHWvSmFoeDIZPsjbed2Di9EuAvKcW/sormA8Ztyk8REmORY9/D0R0M2zw
         6D2PXv/vXzz7DnmMullebBfyvr1LZFTt5I4QsgQF1/E0PVWF8baCO5iWsVBhYalJuhfl
         sUGQbqk+i12Kt959pBkWlhQBgGu7n9Hn1aJ1V2V64/fc+dmUvqFPY+9/b7/gzWkFs3VK
         cZwcovOI0Wu0uw2O+TFZ++4cPASampHPCvuX1fpieI3PVxqNG3LEN+5Ts9GTiv8TdkAS
         bYwG9IkVeg35G2yTurTi9U+4KxOiju45nY/LCv80tKYC/no7AxdUS8YhJvTgK2N2KXkn
         kxvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ryx2Ks43HYE8Q7pTv7hpRWZjiZujiJ46sfljr3BjzG0=;
        b=13LgsFFVEnCoWYDEkOnlOkELKfQlXlkIQQmLBfRLft/FpFEBQiKbkYIji2k/ESFTLt
         NGQwlv5RCR6qnj1pjxXe7ITMHJVUHqXEWglSIQtxtouDZ+RUKGD8pUgGPC1a4vM9IMno
         m1nV4N2yZx4Zc9MSB8d0s0PbpCpeqkx+jLJxh1OuFqW2ZlTZob13HhSaBc08Lft7oTNh
         v9MObJUZhDEm+eA8L6KidG39nRE9XSAok7GQqrL+CGrQ8YzqJNk4FdYDt9mQCvvXYQUp
         inKxtidNuHwWCAijvhAgAzdZsRxq4hdhiGsLmu2kdyvJaoA17m7RTLIFIrS+rB+43oRd
         YL2Q==
X-Gm-Message-State: AOAM530Bq59cCNKzZbkhmnHBqLIAvDcp8eWkQNdcyKStdceZW32TkXJ3
        2YStPIU8yZ9bEwbUuXtAyldh0eK4R4j3XXTOA9wFgRxMVIs=
X-Google-Smtp-Source: ABdhPJxUPXCl6qymWwFnPLD1jls52MPyuKxxnBcdzmyhzzkfM57UgruD6kYw9UPb5p38pPas+gd78OSeedEYvX9VJBk=
X-Received: by 2002:a17:906:9b86:b0:6fe:d37f:b29d with SMTP id
 dd6-20020a1709069b8600b006fed37fb29dmr16148707ejc.327.1653496374359; Wed, 25
 May 2022 09:32:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220521075736.1225397-1-zenczykowski@gmail.com>
 <CAADnVQJcDvyeQ3y=uVDj-7JfqtxE+nJk+d5oVQrBhhQpicYk6A@mail.gmail.com>
 <CANP3RGcn6ta7uZH7onuRwOzx_2UmizEtgOTMKvbMOL8FER0MXQ@mail.gmail.com>
 <CAADnVQKWxzwAbZFAfOB2hxwOVP1mCfwpx30rcdRkCO-4DMxsZw@mail.gmail.com> <CAHo-Oow9u0QGwGuB4u4Uusv_2N70HbWZT6-cM_av8pqwychT9g@mail.gmail.com>
In-Reply-To: <CAHo-Oow9u0QGwGuB4u4Uusv_2N70HbWZT6-cM_av8pqwychT9g@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 25 May 2022 09:32:42 -0700
Message-ID: <CAADnVQJ=wQd7YgZTtTQNv+3z4AwxYS0cWBu_WoJ17vJkjVf65g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: print a little more info about maps via cat /sys/fs/bpf/pinned_name
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 25, 2022 at 9:14 AM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> When it works it's really nice...

Load your own bpf map iterator program and pin anywhere
in bpffs under name of choice and your own access permissions.
See selftests/bpf/progs/bpf_iter_bpf_map.c
