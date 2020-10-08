Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368812870E8
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 10:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbgJHIpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 04:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgJHIpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 04:45:18 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA98C061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 01:45:18 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id t9so5616084wrq.11
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 01:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7fysVU0GsmajiKe/OvGhT5E2NiSU5/Ggs+Q8zR3Tu48=;
        b=T7k1cj2q5TKYhy457f4t8iBLThVyJTpBIejmQXBpTuMWFs/rzZ7kO6IqTNcnaxg9VJ
         hAa1gD801AKP2e86/Fvayj3s/vxwMsVy1jwoNbFcDJEwRtbOGXO5dvf3xMit1/9XV1+O
         cmpAUiGzJkoQoilG2YZEXf7vIBkKuEOJDsjf3Pg8WM13I9sFe9Wj/jL6WPimsWeeTH9G
         yVL9/WrZjuhLNdFd19C5oGSv+nzBbvLC4Uo54vjCPgNc8uZUkpDCaqcIQvOoN8Oeeae6
         fj8YScDGpjWMg+jOgRgbz/hPndv0q4fm4YLKWA1r+ZrCDLbEHSarYGlt9UrSLeuYD5Li
         y1hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7fysVU0GsmajiKe/OvGhT5E2NiSU5/Ggs+Q8zR3Tu48=;
        b=K8evlbp2DNaAZZ8uhn8SYLQUc36I8skq52Uel3XdgYboKGw/PZ6QVnpCarD1WbPjhe
         5kdEsUTS3CwqdvWJ2igpFdpNfxnppD19GCbSo33aTprTFcteEeDfEgeW+NVT48IJNjtw
         EIhJQYOcqNgXoeID0U7zSNY1lcxqTqYSprPdvThp8lC6D7qTl4a70EOCI7h2jK3tNLWs
         1mmMi1cvne47WusRo5IrqVN2S9A5apJ5W1VD2rjXYH+E0K2mtIw7p4qrJJo5BSuVqVmC
         a1i271QWZXeaiPEqd9QW35PswdHC2AF0tumb6xe+7Y2pzMbSpSc4Q0e65xM6VoJDuW/0
         UKHg==
X-Gm-Message-State: AOAM531Ws30m4bO/B/Uxh9GAG7disUakq+9DEOy/onpsCwci4sNzw11r
        CUIbTaiBVFP/k2e9ZgNgkfwj6TwZgzrQ3KPS4JQ=
X-Google-Smtp-Source: ABdhPJzNAtT4Ll5rEL/LhtoO1bxg398bgwL7+gx7xZDyekFsAFEWnZcA1ep/SuJqaVHjbNhE0GlkNfQtfpOcOx/l8jc=
X-Received: by 2002:a5d:4282:: with SMTP id k2mr7625047wrq.270.1602146717105;
 Thu, 08 Oct 2020 01:45:17 -0700 (PDT)
MIME-Version: 1.0
References: <20201008041250.22642-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20201008041250.22642-1-xiyou.wangcong@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 8 Oct 2020 16:45:05 +0800
Message-ID: <CADvbK_dwh4SFL1KbX=GhxW_O=cZLoPcXC9RjYpZd4=tWrm0LBA@mail.gmail.com>
Subject: Re: [Patch net] tipc: fix the skb_unshare() in tipc_buf_append()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        syzbot <syzbot+e96a7ba46281824cc46a@syzkaller.appspotmail.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 12:12 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> skb_unshare() drops a reference count on the old skb unconditionally,
> so in the failure case, we end up freeing the skb twice here.
> And because the skb is allocated in fclone and cloned by caller
> tipc_msg_reassemble(), the consequence is actually freeing the
> original skb too, thus triggered the UAF by syzbot.
Do you mean:
                frag = skb_clone(skb, GFP_ATOMIC);
frag = skb_unshare(frag) will free the 'skb' too?

>
> Fix this by replacing this skb_unshare() with skb_cloned()+skb_copy().
>
> Fixes: ff48b6222e65 ("tipc: use skb_unshare() instead in tipc_buf_append()")
> Reported-and-tested-by: syzbot+e96a7ba46281824cc46a@syzkaller.appspotmail.com
> Cc: Xin Long <lucien.xin@gmail.com>
> Cc: Jon Maloy <jmaloy@redhat.com>
> Cc: Ying Xue <ying.xue@windriver.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  net/tipc/msg.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/tipc/msg.c b/net/tipc/msg.c
> index 52e93ba4d8e2..681224401871 100644
> --- a/net/tipc/msg.c
> +++ b/net/tipc/msg.c
> @@ -150,7 +150,8 @@ int tipc_buf_append(struct sk_buff **headbuf, struct sk_buff **buf)
>         if (fragid == FIRST_FRAGMENT) {
>                 if (unlikely(head))
>                         goto err;
> -               frag = skb_unshare(frag, GFP_ATOMIC);
> +               if (skb_cloned(frag))
> +                       frag = skb_copy(frag, GFP_ATOMIC);
>                 if (unlikely(!frag))
>                         goto err;
>                 head = *headbuf = frag;
> --
> 2.28.0
>
