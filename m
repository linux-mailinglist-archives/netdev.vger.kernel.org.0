Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECB127106
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 22:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729917AbfEVUsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 16:48:21 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33637 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729844AbfEVUsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 16:48:21 -0400
Received: by mail-qt1-f193.google.com with SMTP id m32so4172709qtf.0;
        Wed, 22 May 2019 13:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=G5boRka6LErFKZkdroC0NV9iO3Vd7G5nF4rXK1yz2U8=;
        b=eu/9N7KKLH9z0YlKArH+NVPWMQSMmwRBPdWBx4VRDW+jeCvPCgQJMvkpi5EhYeMXdR
         9M6Fm+eatc5DO33e/0HogtW8dsUNuYkdU3iK8HFh4DX95uutqUKCLGF4WcqBw2IWQS/j
         jsqF1lPG1YOYNpPk16O1NCRMl/e2gly0jDxzwm1CcvlV2yIyJgEOY1pbJXkFqzCAu8KK
         dB/OvouCnSyoqBG//uSLUz1jHT4ug3cN5XHvVW9ldEtPUwaDJ+U0TwYwiJJ1x9eFUjDG
         lE8pSrXWU5sckIWuwhsxb7wbgnp5UEaBfwzO0W5sftftIHKMPkNdj1x9CAXdaoAIifcU
         foiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=G5boRka6LErFKZkdroC0NV9iO3Vd7G5nF4rXK1yz2U8=;
        b=n1qDn7/YY23YOX+t7zbxxEU635ujlZ5Ss1HXXlnoF58FYnoMkWlOVL+0Oi6irTZbl1
         /m3WYBl5JowhQpdilog43QnaBVOgttr8eBkXBbKv8UZPa5Dt9WSM1XsaVwgL3gWGK+IZ
         w4f3IYM6gRM2TVqKtiMWPQa4/L839dNgBhCUAqYwfr7l5DgcvnSvL7/crwBe1aHiu/6d
         MN++gleTh+GZL9rY/s/AfzanlNf5BjdOUgp5RZwVDI58pqCOIsATblEtsG6yqgLrSr6J
         UDs7g1/3YiA2DKNcK+P+vjfJPDkMcuObEhWLijPRUGLzxapGs8nzd+/zEFjR0talqo0s
         beaQ==
X-Gm-Message-State: APjAAAUPsKLEyo7g+4sg6CLy+tVrLEhIu1GKQjW0gFhKL1gWiO/x2KEN
        OOy4JGJIXSFQeEh2fZ7Ut4xBGVyv+k2nDAxDykA=
X-Google-Smtp-Source: APXvYqwDHcAzr1/IZu+EbeSlw0S4ndZW5fkhoIflQszB41kS2rY4ynS5rL2b8U+kd5I53tXWWf9TOU+0/sIqtV2cB/4=
X-Received: by 2002:a0c:d442:: with SMTP id r2mr75141196qvh.9.1558558100315;
 Wed, 22 May 2019 13:48:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190522125353.6106-1-bjorn.topel@gmail.com> <20190522104129.57719c34@cakuba.netronome.com>
In-Reply-To: <20190522104129.57719c34@cakuba.netronome.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 22 May 2019 22:48:09 +0200
Message-ID: <CAJ+HfNhkntaYv7EaZc4Besm5Gj7epdN-mXFj2UaN=Pu-7pu+zw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/2] net: xdp: refactor the XDP_QUERY_PROG and
 XDP_QUERY_PROG_HW code
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 May 2019 at 19:41, Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Wed, 22 May 2019 14:53:50 +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> > Shout out to all XDP driver hackers to check that the second patch
> > doesn't break anything (especially Jakub). I've only been able to test
> > on the Intel NICs.
>
> Please test XDP offload on netdevsim, that's why we have it! :)
> At the minimum please run tools/testing/selftests/bpf/test_offload.py
>

Yikes, I did not know about this. Thanks for pointing it out! I'll do
that from now on!

Thanks,
Bj=C3=B6rn

> Now let me look at the code :)

Thanks! :-)
