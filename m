Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63CCB2D9196
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 02:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437738AbgLNBeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 20:34:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbgLNBeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 20:34:01 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9F2C0613CF
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 17:33:20 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id j22so2331941eja.13
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 17:33:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ufj2Iq9YciaonnGoHIm8LQWHySzfZ2ZpGbsx76Hg1BQ=;
        b=LwO7WtZLLeatk7VoGpFQVD0BI0Df/ahV0fiCGA9HYtyFC9Nhj3/cRrgfxY7XcWjTwj
         RHtFejRX9uYdrOJCgVg+DM4kRCQwfv+kBMiXLpWl1VJQcD5qDNWaDQI88u2nNcKoEpj+
         cBnP5SFI6U7D1eIbzyraz6kcHVq7CgVENkINlY8ta23wpPYKA/CfDxR64dunLjW2EkBe
         8QIe9LYMpCuqVjIHw0DbJqkbKqOyf+yUCpXJ4J4tw/1hOg/5+7lqO69saC8bJofj3J2N
         CnZ8ldgszIwrQH9x5qz3/cHQ7YIsj+H1AJZxUIuRILLJX0TOZ3RAH4GWkQ21vszD7KEF
         E4FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ufj2Iq9YciaonnGoHIm8LQWHySzfZ2ZpGbsx76Hg1BQ=;
        b=iuGjr7adLe51DFMXAcl03zu4i8p2JiqmmJybZbpoZq6jJ5fqeR8oT4hZ8431f+HvVd
         Je1K3c10xP+08W29mASK6Irvt/6nPte0cMZAUK/8fDRMSom9LeWEVvZN0TX5TmUNmwus
         +tGk8zWDNNwCfelhGhgoPz39qc0Bn02uTPQa7O8a2+oPR+IIXzUWNJvHvdmPB2Nh3Q0V
         RadLBXn239Gg0V+7xF5VIy4GrB+FaQGWIXS5BBGak5lHD4cpn8xxPujOLPbRwXmCzqV/
         eF3HOMV0YZElnWEJcIH6p/oU3taFEB84Ej8SnUH1nshrXLdO2srTf7LFABjSrl/Q5Vix
         2q6Q==
X-Gm-Message-State: AOAM5325Uu3auyZVp9gNkfVuhxqNd1d55CvZ0b5JOfuHqucsSkurH8f8
        7nfg+vlLHQ29ENKXDJlsZQvbw0afJb1ZrnHHacY=
X-Google-Smtp-Source: ABdhPJxvt8CvJ9cemskE/wqcGLeQe/L3TdIfTkPerfoBZb6XZ6IL2on8BCxwz6RAvlsqRwaIuwX+pR35XXSaqoMB1bQ=
X-Received: by 2002:a17:906:1796:: with SMTP id t22mr4429019eje.11.1607909599492;
 Sun, 13 Dec 2020 17:33:19 -0800 (PST)
MIME-Version: 1.0
References: <1606982459-41752-1-git-send-email-wangyunjian@huawei.com>
 <1607517703-18472-1-git-send-email-wangyunjian@huawei.com>
 <CA+FuTSfQoDr0jd76xBXSvchhyihQaL2UQXeCR6frJ7hyXxbmVA@mail.gmail.com>
 <34EFBCA9F01B0748BEB6B629CE643AE60DB6E3B3@dggemm513-mbx.china.huawei.com> <CA+FuTSdVJa4JQzzybZ17WDcfokA2RZ043kh5++Zgy5aNNebj0A@mail.gmail.com>
In-Reply-To: <CA+FuTSdVJa4JQzzybZ17WDcfokA2RZ043kh5++Zgy5aNNebj0A@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 13 Dec 2020 20:32:43 -0500
Message-ID: <CAF=yD-LF+j1vpzKDtBVUi22ZkTCEnMAXgfLfoQTBO+95D6RGRA@mail.gmail.com>
Subject: Re: [PATCH net v2] tun: fix ubuf refcount incorrectly on error path
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>,
        "huangbin (J)" <brian.huangbin@huawei.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 12, 2020 at 7:18 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> > > > afterwards, the error handling in vhost handle_tx() will try to
> > > > decrease the same refcount again. This is wrong and fix this by delay
> > > > copying ubuf_info until we're sure there's no errors.
> > >
> > > I think the right approach is to address this in the error paths, rather than
> > > complicate the normal datapath.
> > >
> > > Is it sufficient to suppress the call to vhost_net_ubuf_put in the handle_tx
> > > sendmsg error path, given that vhost_zerocopy_callback will be called on
> > > kfree_skb?
> >
> > We can not call kfree_skb() until the skb was created.
> >
> > >
> > > Or alternatively clear the destructor in drop:
> >
> > The uarg->callback() is called immediately after we decide do datacopy
> > even if caller want to do zerocopy. If another error occurs later, the vhost
> > handle_tx() will try to decrease it again.
>
> Oh right, I missed the else branch in this path:
>
>         /* copy skb_ubuf_info for callback when skb has no error */
>         if (zerocopy) {
>                 skb_shinfo(skb)->destructor_arg = msg_control;
>                 skb_shinfo(skb)->tx_flags |= SKBTX_DEV_ZEROCOPY;
>                 skb_shinfo(skb)->tx_flags |= SKBTX_SHARED_FRAG;
>         } else if (msg_control) {
>                 struct ubuf_info *uarg = msg_control;
>                 uarg->callback(uarg, false);
>         }
>
> So if handle_tx_zerocopy calls tun_sendmsg with ubuf_info (and thus a
> reference to release), there are these five options:
>
> 1. tun_sendmsg succeeds, ubuf_info is associated with skb.
>      reference released from kfree_skb calling vhost_zerocopy_callback later
>
> 2. tun_sendmsg succeeds, ubuf_info is released immediately, as skb is
> not zerocopy.
>
> 3. tun_sendmsg fails before creating skb, handle_tx_zerocopy correctly
> cleans up on receiving error from tun_sendmsg.
>
> 4. tun_sendmsg fails after creating skb, but with copying: decremented
> at branch shown above + again in handle_tx_zerocopy
>
> 5. tun_sendmsg fails after creating skb, with zerocopy: decremented at
> kfree_skb in drop: + again in handle_tx_zerocopy
>
> Since handle_tx_zerocopy has no idea whether on error 3, 4 or 5
> occurred,

Actually, it does. If sendmsg returns an error, it can test whether
vq->heads[nvq->upend_idx].len != VHOST_DMA_IN_PROGRESS.

> either all decrement-on-error cases must be handled by
> handle_tx_zerocopy or none.
>
> Your patch chooses the latter. Makes sense.
>
> But can this still go wrong if the xdp path is taken, but no program
> exists or the program returns XDP_PASS. And then the packet hits an
> error path, such as ! IFF_UP?
