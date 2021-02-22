Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32EE3216C9
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 13:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhBVMfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 07:35:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbhBVMdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 07:33:43 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A49C061574
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 04:32:54 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id n10so14183796wmq.0
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 04:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=V9F50EK0Q8zCGFxB+1uR1BuJV7kQ98LuLS69LykNs2Q=;
        b=hJAt76MiQkPmwJW7zRlmlHKD2Pgulo/mo7FAO3fnJlxg9rhJt6HeCibdMrdL5yq+Nc
         DCFjD0t/BJW6mTr6tOVchbxbJsmo+/p2L1vUIotMxKs04xlmxp56mD2IwBaziE4UAvkV
         KCy8xZJcKbtgL2NXUBUvPw0fw0H2syMluGhfA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=V9F50EK0Q8zCGFxB+1uR1BuJV7kQ98LuLS69LykNs2Q=;
        b=ACLZYjjNbAo3sfeOLHyB9BiVTzXPx0AbX6vk8BD0kvorsKwg8b93EVM6M0M2tvNSna
         2MM5E4VWZxQkXH98aV96Vz/5OhQ1+0ulnJtezT/rfO/lviaoNIHCJ9fo0TaLJ++s7bom
         8JVlxwlWA8y4rHSjbhKvRc9Dhwgzf+vvWdPEx2/HUEF0s0CdajFBKvXt8tX7N0qTpiwJ
         wkmBN5WRXaUVkBqbUtuMGzDVF4LbZL1nDq56FULbfjxT3Y8BQXEsVF2/5yf830b72j5+
         Y/bkh6hC6MNkYOIjbmNCpwtmbgp5ku8AVw9671EaZ/2umLL/n8pbbmoSFJ5vHgZ+jQjL
         dICw==
X-Gm-Message-State: AOAM532x9CfE37i4sUd7rIVV7tUKJp1gX3OgMy+tn/P6FCAck2QX+zyk
        S2N8XOIgWu63pIlgktg/edXWQp7JKqEwaX0R
X-Google-Smtp-Source: ABdhPJzc+Lir2UYjCZ5dHJDCjJXh5hZQBKGvUHdr7M2bbfK+8oP5E2JcUpM3bU9OvyVQ5W6ui2vFuA==
X-Received: by 2002:a1c:e446:: with SMTP id b67mr20206427wmh.65.1613997173009;
        Mon, 22 Feb 2021 04:32:53 -0800 (PST)
Received: from cloudflare.com (79.184.34.53.ipv4.supernova.orange.pl. [79.184.34.53])
        by smtp.gmail.com with ESMTPSA id w4sm24907658wmc.13.2021.02.22.04.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 04:32:52 -0800 (PST)
References: <20210220052924.106599-1-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>
Subject: Re: [Patch bpf-next v6 0/8] sock_map: clean up and refactor code
 for BPF_SK_SKB_VERDICT
In-reply-to: <20210220052924.106599-1-xiyou.wangcong@gmail.com>
Date:   Mon, 22 Feb 2021 13:32:51 +0100
Message-ID: <877dn0470s.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 20, 2021 at 06:29 AM CET, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>
> This patchset is the first series of patches separated out from
> the original large patchset, to make reviews easier. This patchset
> does not add any new feature or change any functionality but merely
> cleans up the existing sockmap and skmsg code and refactors it, to
> prepare for the patches followed up. This passed all BPF selftests.
>
> To see the big picture, the original whole patchset is available
> on github: https://github.com/congwang/linux/tree/sockmap
>
> and this patchset is also available on github:
> https://github.com/congwang/linux/tree/sockmap1
>
> ---

Thanks for the effort. It definitely looks like an improvement to me.

-Jakub
