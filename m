Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3884B319CE8
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 11:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbhBLK5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 05:57:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbhBLK5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 05:57:10 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9489DC0613D6
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 02:56:14 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id h26so12492238lfm.1
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 02:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5p98chmjZ1paANKxh0xvpJUxvwk5iTCCl2wXTp6kE4A=;
        b=ldHm6zf/knVFl/iODnIB4Z7QWak9Yq30LCVAEY0zVK3s6qwxRvu+63jMGxf2Pq6V6w
         zwmNPQXwJ58FewxLvgCDLP7EH5rCiYt7j7mn0lAOxYB6m226XFReZsK++oP8XaVh41s2
         8pdxGFr/YKU0zjcX7J0oMp+fOMAHXX94Ni7fo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5p98chmjZ1paANKxh0xvpJUxvwk5iTCCl2wXTp6kE4A=;
        b=JFary8djboIOxMywk+0YlC893UgAOd24mbnC7uKDbRqpfK7iTXlWfywLTgFXIIKitI
         lHJa4GawlgCc0Ykz6JEsPrQKmhGTugDEfhM505f5sa+quHu5xJ/+t0zlgZJ/GRs1PBOl
         QOvmqpes0TJDgJZxSX+Q61A7d/46YDJNUeuLpRlQwBQ1WiNded1CvwJSAIbucxMNXRLR
         uS89wPQNVA7NUVkrhv7QIe/g8IRiP1d7CTqvPQ8lVd4+bdjyHZaC8fhm21yz4DUILnBV
         A2BWrYKo4anTL6u0q6OUYxTLGvwbnEOEnh1mdDem6ci66aM1sXN0BTYJTDNBod4LjQPc
         3f+g==
X-Gm-Message-State: AOAM531AuBXZDfUx9kT5vcmcMd+7iammJ42nOeNJdXZVKDm4jddQGPi4
        9/hLDCDHJgf5s7Kp3bxWC5vPiCgBuL53UIaVnmZb/g==
X-Google-Smtp-Source: ABdhPJxeLOc/PP0Ezqtu2e/mPHDaLarwtif9hcBXG1ZxnHTxVhZ0Gmish5TBnvwXv7FDKBnQOgbCZb7jub3txewj1Tc=
X-Received: by 2002:ac2:52bc:: with SMTP id r28mr567890lfm.451.1613127373154;
 Fri, 12 Feb 2021 02:56:13 -0800 (PST)
MIME-Version: 1.0
References: <20210210022136.146528-1-xiyou.wangcong@gmail.com> <20210210022136.146528-3-xiyou.wangcong@gmail.com>
In-Reply-To: <20210210022136.146528-3-xiyou.wangcong@gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Fri, 12 Feb 2021 10:56:01 +0000
Message-ID: <CACAyw98HxkT99rA-PDSGqOyRgSxGoye_LQqR2FmK8M3KwgY+JQ@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 2/5] skmsg: get rid of struct sk_psock_parser
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Feb 2021 at 02:21, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> From: Cong Wang <cong.wang@bytedance.com>
>
> struct sk_psock_parser is embedded in sk_psock, it is
> unnecessary as skb verdict also uses ->saved_data_ready.
> We can simply fold these fields into sk_psock, and get rid
> of ->enabled.

Looks nice, can you use sk_psock_strp_enabled() more? There are a
couple places in sock_map.c which test psock->saved_data_ready
directly.


--
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
