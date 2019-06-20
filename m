Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0081C4C64E
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 06:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731067AbfFTElG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 00:41:06 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44846 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbfFTElG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 00:41:06 -0400
Received: by mail-lj1-f194.google.com with SMTP id k18so1328673ljc.11;
        Wed, 19 Jun 2019 21:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FFdFnoNnAiDrKBDnBQl6IzC73ew0CForrhj2N/+lPpI=;
        b=htKUfnGk/fy8vMOz+kSidx/BLqorR8tSiJNAfViwlK2xEi3kj1M+k3hyE2dZPZbNGD
         lytFv5G24a5jrUy3okmx/snZPB5r2BaqCJlZhwij071xnGPbTDEY3fe0uMG8zKDC5csC
         9h4aO1Fw04jd5Q356Q9NFhUGEjibKnCXOLLCww0s1Arm1oQbP+++Je0asa0OqzfhmX3g
         Rp/oEyhGO0BPcd8e8/Z+Ots4FGPYsyoL9xYkAMZCSqwaWRF/FHEbcWPwxLPZZSmW71VY
         f/OP3Wllcbnc9fwIUoLtkFXH8EcVjZT0BfkEBPZsLEiwyKupQqKkb94YSkQJGc+3H0vI
         T2eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FFdFnoNnAiDrKBDnBQl6IzC73ew0CForrhj2N/+lPpI=;
        b=XcgyA8ys8L8AV1x3AEFxmA2xeEn/q1sNmkBr5nz1dUK5MKD2t+gOo3w2RQyrjg6vZT
         BcWQWv0Gcok+gFsGUf1UVjldfTu1+c+mpsS1kKmTCaXL2FOdk0omHuPXYINZAOCSYhEe
         1Z1WArmkCOfY+HwXqF6XrZZrqX7xMyYeeTTLuh/3lLIvUtgZm6zg0jIjesDXq/GXZIEc
         e1OdIAbPZyBl11QijrNyZGGw4GMdIBfQ3HKwjQWVP/rrif4GfclQU5HdoBCMw/HPSuPy
         hwCpmhNOIbcxsUJtFoJkxHCoETAoNz+G1E4NZl26gXF5Wh3yApgYyy7lX/148IybnYwQ
         VujQ==
X-Gm-Message-State: APjAAAW6req+AeXuztcM4W3LD6Sr/b035EYtfRISP0HurGyL7g5pDoQq
        7gH89lOEuoF8TFi7WSHFUtPfOpyFSEoM5hlleXc=
X-Google-Smtp-Source: APXvYqykxJrfIijUvjolMDf4P69c8DbVQ4kUxhAabpLgUasSGfYtRzQNIUcKgaa0J3UBzcmMV4e+ROSEFBGO1E4QLBA=
X-Received: by 2002:a2e:9dca:: with SMTP id x10mr36621568ljj.17.1561005663593;
 Wed, 19 Jun 2019 21:41:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190619160207.GA26960@embeddedor>
In-Reply-To: <20190619160207.GA26960@embeddedor>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 19 Jun 2019 21:40:52 -0700
Message-ID: <CAADnVQLpvxcX34TgAXK7ydkSUKxiedDymF=2REcjC_7mVKpe+w@mail.gmail.com>
Subject: Re: [PATCH][bpf] bpf: verifier: add break statement in switch
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 19, 2019 at 9:02 AM Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
>
> Notice that in this case, it's much clearer to explicitly add a break
> rather than letting the code to fall through. It also avoid potential
> future fall-through warnings[1].
>
> This patch is part of the ongoing efforts to enable
> -Wimplicit-fallthrough.
>
> [1] https://lore.kernel.org/patchwork/patch/1087056/
>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

this type of changes are not suitable for bpf tree.
Pls submit both as single patch to bpf-next
