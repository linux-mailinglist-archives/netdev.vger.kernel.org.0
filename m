Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4491C62E5
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 23:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729256AbgEEVTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 17:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728076AbgEEVTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 17:19:18 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE91C061A0F;
        Tue,  5 May 2020 14:19:18 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id b188so3948352qkd.9;
        Tue, 05 May 2020 14:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SB6TVRtCxdCxrT1yXNPrhg0/u29rKxYYKcDmJbIgyvM=;
        b=F9xmJNy8E/UMIeK2T9AuHcMy5t5J9duAuscVbPwk2iW+Sd5HU+iTXOwyKu5dEASAU4
         OiRq7sXczoIbKOoITUavoS2SnVqtEJpu1rEnDjEN0PZx4rHQddJ3HdorVFbOj+QY7Epr
         e69HtcI8PE5CUyg5gjXSsuD2uZ3kI+c3ByYtQzssUtwMSkiYk33QLYAvDYkYVWJ4uQRo
         B8qB9C87X1fy+sRugcNbo2GbZUJ/VhoEKJvNo7Thohp1002YtCyN5G7RiVAOCLl08imw
         Qy0oNlbzQNtsq6dMINIG/gjNhyxvsLQ9jQxvDTNlAwfQTbqWzwLIjF1czzISR+uciHT5
         PZKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SB6TVRtCxdCxrT1yXNPrhg0/u29rKxYYKcDmJbIgyvM=;
        b=CwG1CwKvEs681NkVOeTDjHfv43Kn1Y3HGo6JfYBgEpUwzZsIDywmF5V2jJWtQ3pJlB
         0H2lopb8GMgmeD6cw4Uc32xmWVnhjgFw/Uz5KOazy/6lhFL8BB8WgU7YlHYzYUJCtoRS
         H7gdxVqv31CC9TUBNWB0o2I31czN9GUYkugRaIu32fwaTvr8WjWpVUiOYRuBX1ftQfxd
         YxU1fhZc1ohpNN9+DnBwfwNXORUOGlYVETIFKHGqG8eWHhsD3gSrMc8rlMKICiRtukgt
         cSSKl7ov/qPJQi1SLy+XNPKo/JaM9jSyFwdGgirZfXoDc0EEgoGB3PgEcRAifKPojgYb
         AKOQ==
X-Gm-Message-State: AGi0Pub/i7LBfoTb8Nch3J0G6ErghRsbZkTpJW/psYq2hfI6MXKmj/Hy
        m+cXcjgruU74DYAG2BJzSlyHLlW9F4H42VRCjWE=
X-Google-Smtp-Source: APiQypKAeUCXd8vQlyKF9wXDf2mX9iBZPbx3HMVi00ztLy/k+zZ1zUnCSh7Ck6PEwGL+n5yIlq30Tx0Ux0Spq1tCT28=
X-Received: by 2002:ae9:e10b:: with SMTP id g11mr6001465qkm.449.1588713557835;
 Tue, 05 May 2020 14:19:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200504062547.2047304-1-yhs@fb.com> <20200504062547.2047362-1-yhs@fb.com>
In-Reply-To: <20200504062547.2047362-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 May 2020 14:19:07 -0700
Message-ID: <CAEf4BzbaGp3rd+qzAXNpXSN=3vePatcs9+XoEtBasyoUyZ7FYg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 01/20] bpf: implement an interface to register
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

On Sun, May 3, 2020 at 11:26 PM Yonghong Song <yhs@fb.com> wrote:
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
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/bpf.h   | 14 ++++++++++++++
>  kernel/bpf/Makefile   |  2 +-
>  kernel/bpf/bpf_iter.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 55 insertions(+), 1 deletion(-)
>  create mode 100644 kernel/bpf/bpf_iter.c
>

[...]
