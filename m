Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A4C2A662A
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729768AbgKDOOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:14:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbgKDOOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 09:14:49 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB70FC0613D3;
        Wed,  4 Nov 2020 06:14:48 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id 141so27329673lfn.5;
        Wed, 04 Nov 2020 06:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S4tBycIgGpMbcu0VMkG4KdXUec3BMb9c9CGZHnWqcbY=;
        b=Uby3FcRKI9yEd+t292wdoGg6qfKgNlGfPsu1x0mVGxqu4Y47S9/9jU5Vxln+Ev3Qhx
         QbyLO4xbXEt4pFY2a6mKUgkwVQd8WgbDmCqx2kIdEjJ02R7HeuRwxSJPlT7xxEDIDXuB
         BWexSWV6ahCPrWKjTIXgATLahYkMiPwplw5+TyHp2UIwyIXwY1U2G6kx/jypkG/dWjJI
         3rXYCOA7tQeqDXObwuVj2T52B7EBFN44hOsCOKfkH06qOtYgOvqf/oqzYihC2vhVVubS
         DDE+VGcMLLIizqcQ+bRTmv8Bc3vRrrV/Ij/sPzOUEo6F3pc2QmtXHDqPP9GtETPHGBy5
         Bodg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S4tBycIgGpMbcu0VMkG4KdXUec3BMb9c9CGZHnWqcbY=;
        b=tPTectZPSSOQxtLRMrS60dR1ysdU2KwEvmW5PmlUtOcNQzSIcrzpZHSUa9JkR4ay7Y
         PAQju79J18kBVE0DPQAuT9lidAut9yDVarAS6iqUmhrRapq78xuxmzKQkjUYfiWuT2iB
         LrXbmK8nCnvMFV0K561fkI/VOBsie88Og4NxGzYMEaIMIeh/eH5FBf8geFOA5D3ln5h8
         9L3WzQZyMjtdg8BcUYhgXZOxOq4Tl9asy64AEhNUrJTNRLU3oinMr81MUMUpvhxJqPud
         L43vVIYYwUXJP0Ort9r3Yhbcqg/fXPwnSlSK3e3a9B5fsfMWd0ppmiGklHVwnrm4ClR/
         pa8Q==
X-Gm-Message-State: AOAM531rmbd5rQtqv5lZ0cUCrWmw+PfXDXLEfKSNn0KlhJvReyQTZVZb
        ujwoV4ev4oN/gL6DGcGFAIlBPrl5wjlW0oqOLaM=
X-Google-Smtp-Source: ABdhPJxEdf8jIlmGFSZss8OzuKYQRSQfRi7r+QLtsgBNuf5OdXFYraddLIW7vnv6yeGfmeHJX8IG9l5UycMrveELxFs=
X-Received: by 2002:a19:220d:: with SMTP id i13mr9204844lfi.37.1604499287209;
 Wed, 04 Nov 2020 06:14:47 -0800 (PST)
MIME-Version: 1.0
References: <20201102143828.5286-1-menglong8.dong@gmail.com> <067c94269abed15f777ac078a216be314c935fd5.camel@nvidia.com>
In-Reply-To: <067c94269abed15f777ac078a216be314c935fd5.camel@nvidia.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 4 Nov 2020 22:14:35 +0800
Message-ID: <CADxym3bWqziz1-rHEZXC10JBgfO0Jc5S9nWEW2s3G09VvWioTA@mail.gmail.com>
Subject: Re: [PATCH] net: bridge: disable multicast while delete bridge
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "dong.menglong@zte.com.cn" <dong.menglong@zte.com.cn>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Nik,

On Wed, Nov 4, 2020 at 12:26 AM Nikolay Aleksandrov <nikolay@nvidia.com> wrote:
>
> On Mon, 2020-11-02 at 22:38 +0800, Menglong Dong wrote:
> > From: Menglong Dong <dong.menglong@zte.com.cn>
> >
> > This commit seems make no sense, as bridge is destroyed when
> > br_multicast_dev_del is called.
> >
> > In commit b1b9d366028f
> > ("bridge: move bridge multicast cleanup to ndo_uninit"), Xin Long
> > fixed the use-after-free panic in br_multicast_group_expired by
> > moving br_multicast_dev_del to ndo_uninit. However, that patch is
> > not applied to 4.4.X, and the bug exists.
> >
> > Fix that bug by disabling multicast in br_multicast_dev_del for
> > 4.4.X, and there is no harm for other branches.
> >
> > Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
> > ---
> >  net/bridge/br_multicast.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
> > index eae898c3cff7..9992fdff2951 100644
> > --- a/net/bridge/br_multicast.c
> > +++ b/net/bridge/br_multicast.c
> > @@ -3369,6 +3369,7 @@ void br_multicast_dev_del(struct net_bridge *br)
> >       hlist_for_each_entry_safe(mp, tmp, &br->mdb_list, mdb_node)
> >               br_multicast_del_mdb_entry(mp);
> >       hlist_move_list(&br->mcast_gc_list, &deleted_head);
> > +     br_opt_toggle(br, BROPT_MULTICAST_ENABLED, false);
> >       spin_unlock_bh(&br->multicast_lock);
> >
> >       br_multicast_gc(&deleted_head);
>
> This doesn't make any sense. It doesn't fix anything.
> If 4.4 has a problem then the relevant patches should get backported to it.
> We don't add random changes to fix older releases.
>
> Cheers,
>  Nik
>
> Nacked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

Thanks for your patient explanation, and I see it now~

Cheers,
Menglong Dong
