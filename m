Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6C72A042
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 23:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391782AbfEXVMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 17:12:36 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45196 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391765AbfEXVMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 17:12:36 -0400
Received: by mail-lj1-f194.google.com with SMTP id r76so4377888lja.12;
        Fri, 24 May 2019 14:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mnO/3dMMYrqeh5q3XQqxFXSGbOB5cTFdvh8nhmTed2g=;
        b=mjqmNifl2XKUkgrfNXwI+AkFempUWdOxrx7CvnrxyfAafYj877hgdWLwoO7gl+L8v4
         fJ4tlhbylEfjtyud9kS3TMFL7h9knP/Os94BQyxdLA3rlQy9DhLFC8jJpNBAzvW3yQjf
         aMey56SJ3cj3/kxGspZ8AzlOpntbqB4dyeUMn+Akrqn1AupDkcp7tddobfE/T3iosz/G
         YZn+7+PaKDmCTZ3MwTB5vYw1jKS1p06N/lYADvwjjYVQI+nk4arNOQAbhlGp1rVWvaAK
         geCexSqBwnt3h4+YntZGUkwGKjBS+EHikuYWojfLZwH6KOS9VkrKXWmmPNd34IEN/DfO
         nTXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mnO/3dMMYrqeh5q3XQqxFXSGbOB5cTFdvh8nhmTed2g=;
        b=RF/y8/3+AGN1PTjIi0n527kZB8tlQyicNvpxGgl4ui8+eCvrohn0iWlHhXQr657yYT
         NuS/Vu8U72YCl6YM5XHxrynipn1mhbPWLkTWHjHqssFTzSwkuP0WN0Yi8GLreyWcNp3W
         dbbd/j0MUGGbyfCMc67/pmECMpQsL6+jlJsYlgrybCO0C10asn+pxe/YVphNI7g6Gihc
         fXmV9PhzH1jT3LQgEwXUgm4D/HOxBsO45rwwFI2FLIMpDlXi1iJxqvLUxoE6GhSJLenJ
         8/2L1PGGZ2rxPAno0BmDXXhyYA9VRVM+EtJrStfOqeA9Ozn8CHAdEuzv1EZ86BAxaTTG
         PXxw==
X-Gm-Message-State: APjAAAVHdKmsBzPMmQuYZZp1RMfXiuPux/qefndbhtrRsdIfWddNq3G+
        ubJjJLGH77ewau1cJovANHo/gxmSXmrCjSc8+zY=
X-Google-Smtp-Source: APXvYqyiDKO8As8voWE8lkCaEE73GnCSOHxjDW7wEoRSK3c0c2vXRa+ZOCWMxjjkk0e5Q534zuUlTUAf3kCYKu7fM6k=
X-Received: by 2002:a2e:9d09:: with SMTP id t9mr21086168lji.151.1558732354088;
 Fri, 24 May 2019 14:12:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190524185908.3562231-1-andriin@fb.com>
In-Reply-To: <20190524185908.3562231-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 24 May 2019 14:12:22 -0700
Message-ID: <CAADnVQ+kvMpERwtPJWQFymBDPGJmODXTw1-Dd5H6tQpDzHtBCw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 00/12] BTF-to-C converter
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 11:59 AM Andrii Nakryiko <andriin@fb.com> wrote:
>
> This patch set adds BTF-to-C dumping APIs to libbpf, allowing to output
> a subset of BTF types as a compilable C type definitions. This is useful by
> itself, as raw BTF output is not easy to inspect and comprehend. But it's also
> a big part of BPF CO-RE (compile once - run everywhere) initiative aimed at
> allowing to write relocatable BPF programs, that won't require on-the-host
> kernel headers (and would be able to inspect internal kernel structures, not
> exposed through kernel headers).

Tested. Works. Applied. Thanks!
