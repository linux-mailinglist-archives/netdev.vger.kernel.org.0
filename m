Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7708F2C5E04
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 00:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391870AbgKZW67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 17:58:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387854AbgKZW66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 17:58:58 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944CAC061A04
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 14:58:58 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id v14so4564467lfo.3
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 14:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VbvO5dSdtAz5yP7JQHiIG1ZdO1uj9eGKYWf4GFyY1IA=;
        b=AXQCh7ItXLxQL7RPXxI9PmAwNgVP3m5Gkdxa4nXbi/PqAWMB+a5uF5mGwr/tTuWmbO
         RfU5WPrD05w16aiz/mTchVug/oC+KMZhocEN15F/F216or6fvMS5/bJIwGn137Ulz1bB
         neHOHr8N1PONM2ACa+iojvrnlDqiBbyzSFMf4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VbvO5dSdtAz5yP7JQHiIG1ZdO1uj9eGKYWf4GFyY1IA=;
        b=dHEGsGO//U6znojipFqslCWIJQtXwpjxUYySRLwWl6/8Ax0YAJWWMa6htmFD9ml0Jb
         ARyGZDlJNMXYb+9poSgucgcr5asje+R7RjoUSm3QeTmToo+aI1MHDpfe3xRprpg3WfjG
         i0gHvmF7D9gYAWip5V+b/SXJ+ByKVjO7tGK60+cFffPGuDnmI7HuDdAh9kNJ2k3Aka+C
         j8sMvcMRXd/jioq3Ym87OUanAEDjE8lw5ZvEcqkLi4teP+cL1YI9/bV0bAJHbHGBENm0
         Qm8vzegdTFugdN4Y5VtnRG0OjmdvdM2Lnj5+bOctjrs4ivpxEcK30itR3Uhq0uVUeJDi
         /f5Q==
X-Gm-Message-State: AOAM532PZoC5Gkmv+KWMZnHBspeMNQlJZjW87GlJfHFjyW048Ol43W2l
        0VVJlM6NUD++KEtClfjV246zrIgS4jTJ8ofgBewBTQ==
X-Google-Smtp-Source: ABdhPJyDJTzaXWmgcQh/C5YbKg9A7ZBSQoloICvgELj4MleifAxlMR5NLUXrrYD0v/cqQ4ynKfv0I0aACxVCPoYW5WY=
X-Received: by 2002:a19:418d:: with SMTP id o135mr2252176lfa.329.1606431537041;
 Thu, 26 Nov 2020 14:58:57 -0800 (PST)
MIME-Version: 1.0
References: <20201126164449.1745292-1-revest@google.com> <20201126164449.1745292-3-revest@google.com>
In-Reply-To: <20201126164449.1745292-3-revest@google.com>
From:   KP Singh <kpsingh@chromium.org>
Date:   Thu, 26 Nov 2020 23:58:46 +0100
Message-ID: <CACYkzJ5fJUP606eq9qLJcOP+-yGHc8eVQadcTQk2GBWuBCd2cw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/6] bpf: Expose bpf_sk_storage_* to iterator programs
To:     Florent Revest <revest@chromium.org>
Cc:     bpf <bpf@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Florent Revest <revest@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 26, 2020 at 5:45 PM Florent Revest <revest@chromium.org> wrote:
>
> Iterators are currently used to expose kernel information to userspace
> over fast procfs-like files but iterators could also be used to
> manipulate local storage. For example, the task_file iterator could be
> used to initialize a socket local storage with associations between
> processes and sockets or to selectively delete local storage values.
>
> Signed-off-by: Florent Revest <revest@google.com>
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Acked-by: KP Singh <kpsingh@google.com>
