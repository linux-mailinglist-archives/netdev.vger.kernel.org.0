Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9674121BD2C
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 20:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbgGJSq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 14:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbgGJSq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 14:46:56 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB7BDC08C5DC;
        Fri, 10 Jul 2020 11:46:55 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id l6so6266715qkc.6;
        Fri, 10 Jul 2020 11:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DWR/kYX/X9VuxY7GMojpR4V7v0VHZ65RP2JxAjwnR38=;
        b=l5gl0TkBFcz4FatWZbM2MVdQlypsD/dhoBl/fAqtJjpbPBsd1erfgc7RSlVR1HZHzd
         DJu/vszKVL/lOK3EkS6AHGldMu24KAHoYTRsl8xb5X7nIRRmxGgJOsNC7OLTMwmM6tBP
         tWfabSKhUtmB+CuC03O5xRR+ya9ysnUMwv+NZDw2zH/yFl3KxazAvpnN0L50Js2fShno
         IK81IUdeT3YiNR0kxlX3jaWSgGqS0q/20TEfwVLrW6SLyLYT+FKgwY4YxmBfb6UL3W5L
         PTInLPQT0nLLmGfvtOSmIJBHZeHo23aXTVzicgz1vMPhK5A/SQNpos4/OU9CDQJ2etTE
         nThw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DWR/kYX/X9VuxY7GMojpR4V7v0VHZ65RP2JxAjwnR38=;
        b=mR8WdOQqk4BIMhjelJ5GToepecMfSGetGfoRkl1tRHHlrTJo0Sr/Wyo67b3cBCkJl1
         236PCOlC3deILbVo9FN/SWBr1Vpay+0W+Pmx/IPQnXirVL8OopJdPZmX9GylgkVvQ2b9
         sBcAEeClz8uTWnmAj+L266w1b20U2Gl5mmOR8AGR4r2jmhpuFZSs2rpjuZMRPUynqZ4V
         6oJUK5OnbtACrYiMyhCXXq3DQ1FUO+EkcZv9UG0lYFmlyRSU9qDuVfi8ADQf1CVB58hZ
         VGs2yr/aYIDKLh7/HzOj9weFxGs58Tt6puIpvyzMWrM16h2EldPjiVs2LPnrdoXv1O5W
         JQQg==
X-Gm-Message-State: AOAM532ySL7hqnH8OlTV88cSL9JshMzUdZLFd6f/8hWXvmHxX+vwIff6
        /ttHEqY4x/WVS6hWN2+VAlodAw0EuLo0+XSkg+cBoAAD
X-Google-Smtp-Source: ABdhPJxVtHU08ueV5sT+YmvY2/MwgcDFc+Goujup9MKPgQnipEJ4FyxLxYI/VHnPxHDNVDoo1AygmJF0nS67qgI5b5Q=
X-Received: by 2002:a05:620a:2409:: with SMTP id d9mr72382500qkn.36.1594406814958;
 Fri, 10 Jul 2020 11:46:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200710092035.28919-1-ethercflow@gmail.com>
In-Reply-To: <20200710092035.28919-1-ethercflow@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 10 Jul 2020 11:46:43 -0700
Message-ID: <CAEf4BzY1KZ8=xMtWugvME_YwRf0GxTkQ6TN0DzoOCEi0fwRiFQ@mail.gmail.com>
Subject: Re: [PATCH] bpf: fix fds_example SIGSEGV error
To:     Wenbo Zhang <ethercflow@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 2:21 AM Wenbo Zhang <ethercflow@gmail.com> wrote:
>
> The `BPF_LOG_BUF_SIZE`'s value is `UINT32_MAX >> 8`, so define an array
> with it on stack caused an overflow.
>
> Signed-off-by: Wenbo Zhang <ethercflow@gmail.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  samples/bpf/fds_example.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>

[...]
