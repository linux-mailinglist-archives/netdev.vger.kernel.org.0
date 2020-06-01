Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9221EB1C0
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 00:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbgFAWct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 18:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgFAWct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 18:32:49 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81BEC061A0E;
        Mon,  1 Jun 2020 15:32:47 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id g18so9087878qtu.13;
        Mon, 01 Jun 2020 15:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/BTUzm5I/T2S4Sq+qzDnXjNneOs43YX0KcgqUMnlEaU=;
        b=j5s9SpXA+hOGD2HUU1LOPJgBknH9U/44LpLrQg3HqZ2sXy7lxLMyUyNisYi8CJjWJM
         W+WGKwjuUh6demoNEgT5dxoCloEGWC+CzM7cJkhK39XThVL2IB/B/sSO0Npxs6txYeCt
         jCvX/QoBUYrh9641ja4+HBv15b2UyVuBjPb5ij2cDzmPF4gsI8qp5AVaCzP3p2oBU4wV
         00Xi5YJxo3XDDPYPhXQN87+RQXqCIBZdPCRUdkGZzAvqQmd9hui7agvslk0I8Sx9eZzZ
         fH9zaTbjsZf7HMbgE78xQPDC1K7AX1iMWMCTZf60BKxoPTjW1Md1IXIZTQ/Osj2H7Gi6
         8fXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/BTUzm5I/T2S4Sq+qzDnXjNneOs43YX0KcgqUMnlEaU=;
        b=k8wggmBXYLjIIwuVKPCaNjH9edHQ0cALNKsteuRdX85dPm+wwhC3e4cZcb5+GquCYX
         knSeStpKe0jvz/Jd80b1Na2UWl7fBQCXXU9yUQIKoWHIsDGagXqnybGfREto1vpVHgXo
         K2fmu7bjbZe2nKgTdiv7BjAOBUG6BOxLc5Jnv3X4sU474DRVQwTEfVf4hpOWGHwUzZKB
         hUSOoa+ZSOomW+DwqnY1rgU9W9eW3NxCgIhs5RtYNPTJTJWJ5sGSn3mkavyRR3h8/bmz
         Jqb0YMwFN/dC/7ofWy8pjgLYotfrLsvUBYWGXYWRifyOU1xaxEpxSpXY4Mvvog5bJo5g
         DY8g==
X-Gm-Message-State: AOAM533JIDUBLecQIzpMQvXNBgE7tvgCAM7Q7YxR0V54qJg2duRSwu7g
        WB1ER7e5ZwPXy1Vr2zixtGRW9h7dvp/L2tjZaYurzG6o
X-Google-Smtp-Source: ABdhPJxZPwBRq3DhS6ZyMZYmWYYp/hB0yds1JWTdHcC/nmOxXdyzLaIkRYzRRAa8+mWV6XBdgFdGnnOKz1+Nnbj5W+4=
X-Received: by 2002:ac8:2dc3:: with SMTP id q3mr23573113qta.141.1591050766945;
 Mon, 01 Jun 2020 15:32:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200531082846.2117903-1-jakub@cloudflare.com> <20200531082846.2117903-7-jakub@cloudflare.com>
In-Reply-To: <20200531082846.2117903-7-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 1 Jun 2020 15:32:36 -0700
Message-ID: <CAEf4BzYvfSN_gzkioCPxtvZAt5KyuQBPqr-T9WBKjd8orF5KdQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 06/12] libbpf: Add support for bpf_link-based
 netns attachment
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 31, 2020 at 1:29 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Add bpf_program__attach_nets(), which uses LINK_CREATE subcommand to create

typo: nets -> netns

> an FD-based kernel bpf_link, for attach types tied to network namespace,
> that is BPF_FLOW_DISSECTOR for the moment.
>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

Looks good.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/libbpf.c   | 23 ++++++++++++++++++-----
>  tools/lib/bpf/libbpf.h   |  2 ++
>  tools/lib/bpf/libbpf.map |  1 +
>  3 files changed, 21 insertions(+), 5 deletions(-)
>

[...]
