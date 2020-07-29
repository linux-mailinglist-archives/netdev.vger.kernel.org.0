Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253E72327F1
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 01:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgG2XRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 19:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727087AbgG2XRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 19:17:39 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFAC8C061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 16:17:38 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id v5so11761731qvr.1
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 16:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CNYovUSlSozhjxm7p9tVfMHuCUBAJ0fZkcNTQqRsicQ=;
        b=JZ8A9OrcpMQw7PzPFKrIaTCIVLD2r3hrGLUmB44ZHC3F3vwyfHNW6IrA2rhwSkA4mB
         9E9o05ica4z19AspqJB5jNu+Bi7jdnqPHWOQTE+taztWDp9uf2PdE7nxbiGkMiaIjoYk
         jKxvnTs12Q5qOiacW6gc4V/ogWnXKa6CCTs+sv4jhiVqQRllAWCIXi2B0Fyr55ukczeq
         eEiAy8voEoXQ67nVWb1/1H0gznI3A5Xw8PvuoJHei56R1F8OuyzpnWGw7z4LtY0ENnQQ
         IBjjT4oBLSac1y5bMY5giCFreMfXmYgZAUfEH5RTB+p/Aus79d7OO5tHOxxt4H0ONclZ
         8xBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CNYovUSlSozhjxm7p9tVfMHuCUBAJ0fZkcNTQqRsicQ=;
        b=ZB+7bCtePVy2kx/NVNGEXbvb8FIgahx1dJCPl8g0l6Z8pAhf0KCjvCD0pWNXynMUUF
         Bww489NnLER11OyFE3Lcr7yzNBbwRfdo7BhBhQUkYA1eDhFUBvCthZfFvV2jiQFq5ZB3
         h7w9YrCpqG1WY29oEFfgFQUMwvA05rwGNHxCLOmGU29K6ILBKKL+f1ka+V2LMahOt5KU
         cBruFzL83yD3bglzuShYwiRippX5CbrVEy8T9VzLDSUjEQDhhTL6/woUcSWoeFoiwFOX
         W1FFu6j4zCJyXKyyh8jTWsoXVQiSTK3QrVzrtl+rG7uidyO+mCjlwiyxtrgQ0vD5dKRK
         IU+Q==
X-Gm-Message-State: AOAM5305+PU23PGWqCbITltHOLRaY9dUgpY9VXAmHvuhUzdo8nFM0qbP
        dTI+1d7dYof6e3TKciFtwuuNMLg=
X-Google-Smtp-Source: ABdhPJwWxvxIFEhwnipyT4FdwAoC14gZIH4KdL72XuItPweLbh6BVEsu6X7eL92dhU3VK54/jf9HUpA=
X-Received: by 2002:a0c:cc87:: with SMTP id f7mr294971qvl.188.1596064657977;
 Wed, 29 Jul 2020 16:17:37 -0700 (PDT)
Date:   Wed, 29 Jul 2020 16:17:35 -0700
In-Reply-To: <92a04281-8bfb-78ec-25b0-fa7adf8dd9c5@iogearbox.net>
Message-Id: <20200729231735.GD184844@google.com>
Mime-Version: 1.0
References: <20200729003104.1280813-1-sdf@google.com> <92a04281-8bfb-78ec-25b0-fa7adf8dd9c5@iogearbox.net>
Subject: Re: [PATCH bpf-next 1/2] bpf: expose socket storage to BPF_PROG_TYPE_CGROUP_SOCK
From:   sdf@google.com
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/30, Daniel Borkmann wrote:
> On 7/29/20 2:31 AM, Stanislav Fomichev wrote:
[..]
> sock_addr_func_proto() also lists the BPF_FUNC_sk_storage_delete. Should  
> we add
> that one as well for sock_filter_func_proto()? Presumably create/release  
> doesn't
> make sense, but any use case for bind hook?
Right, I didn't think delete makes sense for create/release, but maybe
it does for post_bind :-/
Let me put it on my list, I'll follow up!
