Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49135253B5D
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 03:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgH0B0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 21:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgH0B0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 21:26:11 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EEBFC0617AB
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 18:26:11 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id v9so4549596ljk.6
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 18:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NwQRmtSR03e8Z95YTtgCWBM4ls338szcbW/y+WRctMo=;
        b=PM5UARjGZl7it+68nTblaLTBd77X447PU2c/xp6hmTWdeu4ce4iJZbahk4s2Q5PFaJ
         +v+KyatAlGog4EeZ3cfesfi2mxphBlqnUJ5TOaTqtLfNPbK/tsYe51dE9r+vh8dltGPj
         VBNJl+/9uuOQawkQjvHhrIxa1q93amF+R24gTM/DDjJv7KT63B/rNovbI+fiLtTOY9og
         QlilqKXxN+DnacwnLR1hZm74Zn6LtMNCX+hk7SILdthH7AofhPk49lpUCb8NTyRlUKar
         UlBRatC9I2jMr4qpkzT8ZWALAvc+20hsVv33d1S0hF0nLPPEfOB3+C9Yo+1u1vQOn4Ui
         20DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NwQRmtSR03e8Z95YTtgCWBM4ls338szcbW/y+WRctMo=;
        b=umnPt7ApRLrTYnydMWxQu4+xFVdmL3cIrXNdfhqOFpXhTPXT5l4f4u2CYkc0QkEfcV
         MusjH9T8qaU9PGs1c2eww9OQ0Hrsb82tpmIUMj8iuVs/tHHb6fRLGnW/ZTObpWvuyPIL
         RIdj5UoTI5GEQSXRHZ1whRkav0CvH2bBqNCAjKuJgHM/MKCtc4pyHSzyLSkeCjwLAnc0
         y0xxrKZ1QJsnB6jw+MqQCwf5ttaoQIKf70F5YLjibjdIe+rkZ41WWzXdoHZobUS4DLzs
         +/VPVQHPUVVOFTDGqh8SgSAwvM7im3uMMrwik+OnebGO7g5TVMgNREztImB1xDjJNgsI
         Ab8g==
X-Gm-Message-State: AOAM531w0MFVFtdfk4JbnE6DeldxiRlGofaIw/b0MIK8fqXjx0G+NxL/
        eD8juFFMaER4z/gULrZMLE+NtP44sf0xGlUQb5eZSH2OBIY=
X-Google-Smtp-Source: ABdhPJzfxeyQIyjqzngf0Ic3JmYBl8qWIcdHApqyuYYTCcRsQk5Fv6y+bLFRZIGKwYL6aolr76njLkTX27P4q7r9sUc=
X-Received: by 2002:a2e:5d8:: with SMTP id 207mr7668037ljf.58.1598491569469;
 Wed, 26 Aug 2020 18:26:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200821150134.2581465-1-guro@fb.com> <20200821150134.2581465-7-guro@fb.com>
In-Reply-To: <20200821150134.2581465-7-guro@fb.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Wed, 26 Aug 2020 18:25:58 -0700
Message-ID: <CALvZod49nAYx5Uh1kSkTyZz98xJt9pgaLu0syZxfRb9bfyM1+A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 06/30] bpf: memcg-based memory accounting for
 cgroup storage maps
To:     Roman Gushchin <guro@fb.com>
Cc:     bpf@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linux MM <linux-mm@kvack.org>, Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 8:17 AM Roman Gushchin <guro@fb.com> wrote:
>
> Account memory used by cgroup storage maps including the percpu memory
> for the percpu flavor of cgroup storage and map metadata.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Acked-by: Song Liu <songliubraving@fb.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
