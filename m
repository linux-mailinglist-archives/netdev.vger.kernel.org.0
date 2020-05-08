Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B871CB6F8
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 20:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgEHSTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 14:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726817AbgEHSTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 14:19:08 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E562AC061A0C;
        Fri,  8 May 2020 11:19:07 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id q10so2298165ile.0;
        Fri, 08 May 2020 11:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O/3gHY0XxZcoarI4hNnf3tnPigBycbxAeYs29KWw4F4=;
        b=KpOwNLs/avOgSsUwgGhlML9529qdiAE67B0zWgJXHc9mXfIEIwc11WqWzYege6x8Lg
         9dDX7rIqxwWv5cZzXVGcPHamz1sJALHLMc5aUEVHLcZeL/vMXFCNIwG6ZFtP39HQUQoY
         Lqj0VBB+fMFAaRZ6Kn0HwOJdXasvRpW/NA7wjkKRykGR0O5Va1cdRtfvGBb58mBAHxSE
         iaum9ncjL5Y6xRvChiKYIjEn/QdpgyH9MNkq8lcQrBO9Md8TO8wdKc5nUo18+ra/GZMH
         Bqv+9fuwN8hkGou3cRAjmau18/O2KiVzgo1crzjXPAqTrSDwLbfDihNUsbSlvkmnAzpk
         2TnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O/3gHY0XxZcoarI4hNnf3tnPigBycbxAeYs29KWw4F4=;
        b=r/Jjk6rOYb/fRS7Y02oddqVLTqc+qIlJBYju51/JgpHDEZdpyN6kpbTX8HEBBGAbsg
         pR9AARxQ+SWkRYl8ijR+c8pHqb1CaiE8jkrp3zjIZjBeiEWAPqUuBL6djglmHpBxVK2u
         NyQVDq25tJYpgSQ2hIlqBGKveUYBoF0gnO9E+AfpOShE/LSKaHOJPOh0+vME4HaeMwJv
         cp+WjULxm4AfiFzetYlNOzySa5gxinAUdZXWQtHGthGKtHPsAEKu4l2egdJaNC7i4ybl
         PfVy8+7jDemFQ6Up0CaS9N/r8ygCUkpGPYuD/7wCjaddi9QdkIlvd9NtuXl/5FXqDUkT
         B8Hw==
X-Gm-Message-State: AGi0PuZC6/nYIIOM4nw8lnp2uAV2yK4VTzi4Fbb+TyUqZQx4+RCxgUmH
        2gqBJkpVJYmKhSlQG9f4xF/Ns9FWoL+rHmoxBYY=
X-Google-Smtp-Source: APiQypKeS6vP5OTbiAvjIvfMRUS6MivK42tqHnN1ZEz7QpvapzLSip92n3mlwusStpIwmlPIvSnKXnFbmy/miwTEyD8=
X-Received: by 2002:a92:a053:: with SMTP id b19mr3862393ilm.156.1588961947265;
 Fri, 08 May 2020 11:19:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200507053915.1542140-1-yhs@fb.com> <20200507053915.1542238-1-yhs@fb.com>
In-Reply-To: <20200507053915.1542238-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 May 2020 11:18:56 -0700
Message-ID: <CAEf4BzZL0e02nsEyYOqGZkFfOuDxCDuqPBDXWe9Do40D93nZFw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 01/21] bpf: implement an interface to register
 bpf_iter targets
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 10:39 PM Yonghong Song <yhs@fb.com> wrote:
>
> The target can call bpf_iter_reg_target() to register itself.
> The needed information:
>   target:           target name
>   seq_ops:          the seq_file operations for the target
>   init_seq_private  target callback to initialize seq_priv during file open
>   fini_seq_private  target callback to clean up seq_priv during file release
>   seq_priv_size:    the private_data size needed by the seq_file
>                     operations
>
> The target name represents a target which provides a seq_ops
> for iterating objects.
>
> The target can provide two callback functions, init_seq_private
> and fini_seq_private, called during file open/release time.
> For example, /proc/net/{tcp6, ipv6_route, netlink, ...}, net
> name space needs to be setup properly during file open and
> released properly during file release.
>
> Function bpf_iter_unreg_target() is also implemented to unregister
> a particular target.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

Lost my initial ack? :) Here we go again:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/bpf.h   | 15 +++++++++++
>  kernel/bpf/Makefile   |  2 +-
>  kernel/bpf/bpf_iter.c | 59 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 75 insertions(+), 1 deletion(-)
>  create mode 100644 kernel/bpf/bpf_iter.c
>

[...]
