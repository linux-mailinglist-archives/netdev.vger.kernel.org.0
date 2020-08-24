Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5DDB250B1E
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 23:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgHXVtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 17:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgHXVtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 17:49:20 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B858C061574;
        Mon, 24 Aug 2020 14:49:20 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id w25so11385107ljo.12;
        Mon, 24 Aug 2020 14:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZBNOr3dLbhaGKQ/+7SN94aGH7/7LbcuOyLrzFoT4ZEQ=;
        b=aDNHZakiySanWpCNCAOND11zzYlmbAP2XpkwOeLMxWU/QyeMe2D6SLb27s2MgL0QOW
         3/JdM62gjPUx2dNHYwZUXoNEVYHAy0FNz217p8PNn0znEgO1QbaS8lg/FawExmMpgSK1
         VjUi4asXAuej+nJmJsZbzk8vSIJtZQFAxvIjFz7baFaxnMra2tUZInRzFzwIJZK3OS9j
         LShy2bx8EO8C/XVLoo/VFbX2V0lsnaJ38ItqVWouhdxqQMy3yxte3rrBmsRxyP5BNnIp
         uOu0GzMYMnU/hRjneSA0nJwzWBge6ZyEglPP/1ZgqZW/U7nIpk0ZBVRi5Y25j6rC1cEy
         FcNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZBNOr3dLbhaGKQ/+7SN94aGH7/7LbcuOyLrzFoT4ZEQ=;
        b=gxvY0aZK8k9lpEaYWPRmlWzZcpOIudq5N3Lsb8JIuttIFKt/3upkNAiMlJassz+KFp
         L+iZfT3/y/jSc3e9v/Qmn4wwJoGJ0ISmMZhNflubrIB4/BMK/35oXKHU+K59OqWcomRm
         j0Hg0sQEx61I4B/heu8LJ8OxVc+rt6WD7spEO8OvOiMbXzG9JDJuPtg2maI1MdtT/ZGo
         NNFeqLtN8AF/VYqW8I4OcRIN4ndzp4S3oPqFPlSfm5OrawsLPmxZbJmgr0HNAsl+Ic74
         5ghgxktRt1DkOP3rJVN9sVzdF0v17kyLOSEnSo3ld+UuOYhdlA5G/9Wd2Q0fHUR0qzNe
         RA9A==
X-Gm-Message-State: AOAM531ferKSd9pE33iB342Fhph7bf4U1Z3kWsHHYyQveKdz0zBjPZxJ
        vS5wvBJBkmef/9m//e1KldJbsYW1nWl29XdxVqo=
X-Google-Smtp-Source: ABdhPJyfAnZBXWsIZY4ebKHqroRFV8ioGKymaMlezxy8Y8QjrnpC/A6Fkmu2LKS5r1xG/CZyGzWSpgakR20dLNZ/fcU=
X-Received: by 2002:a2e:4e09:: with SMTP id c9mr3565608ljb.283.1598305758523;
 Mon, 24 Aug 2020 14:49:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200821225556.2178419-1-andriin@fb.com>
In-Reply-To: <20200821225556.2178419-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 24 Aug 2020 14:49:07 -0700
Message-ID: <CAADnVQKmUkekx9BmkDnDvHO86ugicUFVZNjOdRzy_2vKpXqxNg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: avoid false unuinitialized variable
 warning in bpf_core_apply_relo
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 3:56 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Some versions of GCC report uninitialized targ_spec usage. GCC is wrong, but
> let's avoid unnecessary warnings.
>
> Fixes: ddc7c3042614 ("libbpf: implement BPF CO-RE offset relocation algorithm")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
