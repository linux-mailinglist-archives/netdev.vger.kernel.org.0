Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2758F3D3777
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 11:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbhGWId4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 04:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234248AbhGWIdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 04:33:54 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7D0C061575;
        Fri, 23 Jul 2021 02:14:27 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id h8so901828ede.4;
        Fri, 23 Jul 2021 02:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NbPHQYpccgPPXxdL13skEjBuFu+tUEk7CeKyHs3IKUg=;
        b=AWh/MIF8BIuxg8k9PNUfHx51+ad2EfWGynApPZiWxTlYcCX2TcCnTgC8/1D3Mco4JV
         h9ZtzDdwZTZR+XialRBeb6vU3D0izXMF+HO07euIKTefo1B9aRNgOgy5HE41RrUqQxUA
         bgbgOsgiNaJSR7vDIveXA0sAWcYeNtpjmyYnAxtS4tRY8arjYRBhDCrNIl5H3E4PW6yy
         0V27JEGve+H2gxzSxB3+3C+EviDlGgfad0BPVMEqHq6yIbuvUX6HsBpt2AkAC+FK04N+
         VH9R0n0I+VqY8TuU37svYGHguqBOGLx3YVo+xznpjwtjY0XpHrKr1WgyuQPDY/hDH6Cg
         3ThQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NbPHQYpccgPPXxdL13skEjBuFu+tUEk7CeKyHs3IKUg=;
        b=lLkoneAWcW4pFtw+DyQiTInAbQy07EACWuwMrulrF1AiGE7ip/UMGJwwLIo8XcNPtz
         K2z/lhKCYMPNCS8e9cWrQ+ZCKJ4L6u4hrmnQv1I1qwBf/Kd1efBQ0Qxc1dcctL4cKeVl
         0esy2l/JAXLDM/xsagDDS5UJVyCHmd++CTon0Sec1hdhUZLxJrVEGHlfUAoC1VM0YRIW
         Wp+DpWvBGMcQLUusLVNCSp+6ryV+7u7sB5zcH5u1QgwnehRb5AZ49Fykzkrmijk7zrK0
         OSHFXBgxJEhFcAEj7WN1DxDIfOGmRSIOGWXZR5z9DH3VjTHxq3qB+cuw0HiiNYAhxMv0
         3eDg==
X-Gm-Message-State: AOAM5302PuTXR9cSN9rvkTZT7NpvOjGym0KqGeubRa2cJpu4FbNiq38f
        JKR9KuHOumDcPEKUnFA4cIqZSy98u9tjXYWjExU=
X-Google-Smtp-Source: ABdhPJzniKTCol/NCrMd3ZkwCvOZwc4YHuCnfiYTstlFcAkt0DW9QXjlFFdHkOPPjyGRPda94lMnAZm6pVFXZQQLZ9E=
X-Received: by 2002:aa7:d4c2:: with SMTP id t2mr4372223edr.241.1627031666105;
 Fri, 23 Jul 2021 02:14:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210723050919.1910964-1-mudongliangabcd@gmail.com> <d2b0f847dbf6b6d1e585ef8de1d9d367f8d9fd3b.camel@sipsolutions.net>
In-Reply-To: <d2b0f847dbf6b6d1e585ef8de1d9d367f8d9fd3b.camel@sipsolutions.net>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Fri, 23 Jul 2021 17:13:59 +0800
Message-ID: <CAD-N9QWDNvo_3bdB=8edyYWvEV=b-66Tx-P6_7JGgrSYshDh0A@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: free the object allocated in wiphy_apply_custom_regulatory
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        Ilan Peer <ilan.peer@intel.com>,
        syzbot+1638e7c770eef6b6c0d0@syzkaller.appspotmail.com,
        linux-wireless@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 4:37 PM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Fri, 2021-07-23 at 13:09 +0800, Dongliang Mu wrote:
> > The commit beee24695157 ("cfg80211: Save the regulatory domain when
> > setting custom regulatory") forgets to free the newly allocated regd
> > object.
>
> Not really? It's not forgetting it, it just saves it?

Yes, it saves the regd object in the function wiphy_apply_custom_regulatory.

But its parent function - mac80211_hwsim_new_radio forgets to free
this object when the ieee80211_register_hw fails.

>
> +       new_regd = reg_copy_regd(regd);
> +       if (IS_ERR(new_regd))
> +               return;
> +
> +       tmp = get_wiphy_regdom(wiphy);
> +       rcu_assign_pointer(wiphy->regd, new_regd);
> +       rcu_free_regdom(tmp);
>
> > Fix this by freeing the regd object in the error handling code and
> > deletion function - mac80211_hwsim_del_radio.
>
> This can't be right - the same would affect all other users of that
> function, no?

The problem occurs in the error handling code of
mac80211_hwsim_new_radio, not wiphy_apply_custom_regulatory. My commit
message may be not very clear.

So I think the code in the mac80211_hwsim_del_radio paired with
mac80211_hwsim_new_radio should be changed correspondingly. If I miss
any problems, please let me know.

I have successfully tested my patch in the syzbot dashboard [1].

[1] https://syzkaller.appspot.com/bug?extid=1638e7c770eef6b6c0d0

>
> Perhaps somewhere we have a case where wiphy->regd is leaked, but than
> that should be fixed more generally in cfg80211?
>
> johannes
>
