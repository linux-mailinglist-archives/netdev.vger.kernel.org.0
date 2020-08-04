Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A45E23B19F
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 02:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbgHDAVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 20:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729028AbgHDAVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 20:21:36 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD178C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 17:21:36 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id j9so29318096ilc.11
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 17:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZwrZ/5dFq1sBv+X9Uiqa92EcKiVqb9UU7ci8j7I1Fnk=;
        b=k3pnMMSbMjd+CYB4adAxUGJFyq+9pq/55Jruk7vdRMsVsjGMT8J3NZeo824LpBZsds
         RA+9onymwoVvuXL74LhbaHxjOZ35APqqMek8lwMRnr/OmmaPu6rCDbTrJvVepL6Bl8vA
         +u0U8OBGVfOQY7ziPlH68ze61n720WIoCAa/mA/pBBg9csft5AiiprpKK8LbrQ8oxvbn
         26UATPmqZBUmOIBho/vKKp/hew/PUY0kMD1eqvpwpU9II6+EmdwoEn9eQ7JGCUonrpJC
         jQECFQ4eRHACpOi6r+/VtdFg8dSmQNOC/++9599eHcLe8zfQvg1awtTWpKV9tVTlTSkk
         aFBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZwrZ/5dFq1sBv+X9Uiqa92EcKiVqb9UU7ci8j7I1Fnk=;
        b=RsBQvytYWTP7h3wc3ZvrZy86iG3XtxOXRgSkye3njnlXKB2CsfB9NoBa9OEFjRYAcM
         WobmZ+tSknaqkaFBovCXTmwt/tig0G2QxFEILvkpuO/5AwteSoQeeJk2pKpbqx+9Zo6v
         K2b+eGGmeczM+ZgKEWHiBEo5Tkg3zbcQKAj8CG1sNOAmr1ZX/BnUPTvvIHcKFHY858Pk
         W6Z6bx46ZUZSfK1oXmNlWeN6H1yNpCvnffR6QHE0Z5VXIquWHHiC0BGQYtiSIlMr69hZ
         pUhkg5nfP5SoG4qunqIDb9zyK9gC6uw9PRNqGEz+apBvBMidezHXlIB6NBDJLylpckDL
         gNCA==
X-Gm-Message-State: AOAM532bftedc/9V2/cDzgZgS72SDHTFFy5fmXHY9/utHx31layLD9wf
        NikEpKHlsotH0kq89nkJIPSVbydIaHebnKn+aT7cAw==
X-Google-Smtp-Source: ABdhPJwM4VyTE222fb4qkOuBgUMqkotVtrKqwecGTk1OvbKm3zuAS7KI0LqxAU1wLDEHkuml0+qLYNgcqxW6DMIUrfU=
X-Received: by 2002:a92:d5ca:: with SMTP id d10mr2059591ilq.216.1596500495985;
 Mon, 03 Aug 2020 17:21:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200803231013.2681560-1-kafai@fb.com> <20200803231039.2682896-1-kafai@fb.com>
In-Reply-To: <20200803231039.2682896-1-kafai@fb.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 3 Aug 2020 17:21:24 -0700
Message-ID: <CANn89iLWG=r1mpZB4W2LtyBSo0Ee1pkkt2-GBC5Ru_F3ugzw-w@mail.gmail.com>
Subject: Re: [RFC PATCH v4 bpf-next 04/12] tcp: Add saw_unknown to struct tcp_options_received
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 3, 2020 at 4:10 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> In a later patch, the bpf prog only wants to be called to handle
> a header option if that particular header option cannot be handled by
> the kernel.  This unknown option could be written by the peer's bpf-prog.
> It could also be a new standard option that the running kernel does not
> support it while a bpf-prog can handle it.
>
> This patch adds a "saw_unknown" bit to "struct tcp_options_received"
> and it uses an existing one byte hole to do that.  "saw_unknown" will
> be set in tcp_parse_options() if it sees an option that the kernel
> cannot handle.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>
