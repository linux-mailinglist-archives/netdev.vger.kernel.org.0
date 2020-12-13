Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8A42D8ABA
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 01:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439940AbgLMATA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 19:19:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbgLMAS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 19:18:59 -0500
Received: from mail-vk1-xa44.google.com (mail-vk1-xa44.google.com [IPv6:2607:f8b0:4864:20::a44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE981C0613CF
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 16:18:19 -0800 (PST)
Received: by mail-vk1-xa44.google.com with SMTP id k9so3031276vke.4
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 16:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/H+T2rO16oywKEC4ZjUTgkusa3PshH0cBx2kr1UDE/Y=;
        b=VgEIJO+ocNvU9Sd2VBg8gyc60lHua3q5wN1OIcd14NxtcHw6YwvzoJjTCOTQ/7weFJ
         Xyg5zaVVeB1KHR4B9ZRnCS/BvynCyVXIGKBzgJzjliYazYk7LA1nVokcJ/mYz1aCoz5A
         7egBbfnOUjpWSOMIzVp90QsNFO4jTe2cwztZ/EiA0texZgszIhKn+D0hJT1fKsS5cjlt
         W1F7vV2wxHwyAYf9gHXDELfAv6mupoZd/Byh000AFuXFtqide+CWWiT9+ACgWWdXYfuC
         MOIz+ilYT0E8YopMkKD9t5o2KA5SUAGi8VkjP8FJoHHomYZEY/0VxsNvXw/6HCPcWiOi
         3sbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/H+T2rO16oywKEC4ZjUTgkusa3PshH0cBx2kr1UDE/Y=;
        b=FND5zpm2zrYsNm6rfDd5gZ7BVq7K/inEhhjJ233n3Fyea4V2GdL0k21CLPVjSw/fIi
         ZQy62IgUyyC2zobEhnthdAaOOAnvHBFjedRyd1s5w1oS/wdGx4+bF0P5x+lrCbnajI81
         zyJv9mFIif4cZC20yStb84bHt1v5t4AK1kN4X3Czd79Tt3Elx6bQWdXClfRXLF57bkX1
         O2sUNUDf68xkcMOO3MEr7MziaNOX5F564KAGNo+g8+NpSH+4rA7Cfrb22F2nqIaZkAgE
         VgkPLiLO6yMQ9d/d8wK//DIcBA0ig8hqmI3XMSXxS95FWlsFcQSutLcuOquz/jJH+O8X
         +1Uw==
X-Gm-Message-State: AOAM532PUebp7uUHoSzfy6ceg8JDrSUwv52wyPtI16K11TohNOzd/scb
        z1a7obP6aVIY3dDtOFhqiadlRf7Enuc=
X-Google-Smtp-Source: ABdhPJwNscjNeLZp0J8gTvKJV7d6GW9nPCsc4Lyr840fRnG8NbzkvDa1skkipWmPVoVhU7oRNF3B0w==
X-Received: by 2002:a1f:36d4:: with SMTP id d203mr18655950vka.22.1607818697523;
        Sat, 12 Dec 2020 16:18:17 -0800 (PST)
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com. [209.85.217.54])
        by smtp.gmail.com with ESMTPSA id y14sm272978uag.11.2020.12.12.16.18.15
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Dec 2020 16:18:16 -0800 (PST)
Received: by mail-vs1-f54.google.com with SMTP id x4so6948385vsp.7
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 16:18:15 -0800 (PST)
X-Received: by 2002:a67:bd0a:: with SMTP id y10mr16985677vsq.28.1607818695444;
 Sat, 12 Dec 2020 16:18:15 -0800 (PST)
MIME-Version: 1.0
References: <1606982459-41752-1-git-send-email-wangyunjian@huawei.com>
 <1607517703-18472-1-git-send-email-wangyunjian@huawei.com>
 <CA+FuTSfQoDr0jd76xBXSvchhyihQaL2UQXeCR6frJ7hyXxbmVA@mail.gmail.com> <34EFBCA9F01B0748BEB6B629CE643AE60DB6E3B3@dggemm513-mbx.china.huawei.com>
In-Reply-To: <34EFBCA9F01B0748BEB6B629CE643AE60DB6E3B3@dggemm513-mbx.china.huawei.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 12 Dec 2020 19:17:39 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdVJa4JQzzybZ17WDcfokA2RZ043kh5++Zgy5aNNebj0A@mail.gmail.com>
Message-ID: <CA+FuTSdVJa4JQzzybZ17WDcfokA2RZ043kh5++Zgy5aNNebj0A@mail.gmail.com>
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

> > > afterwards, the error handling in vhost handle_tx() will try to
> > > decrease the same refcount again. This is wrong and fix this by delay
> > > copying ubuf_info until we're sure there's no errors.
> >
> > I think the right approach is to address this in the error paths, rather than
> > complicate the normal datapath.
> >
> > Is it sufficient to suppress the call to vhost_net_ubuf_put in the handle_tx
> > sendmsg error path, given that vhost_zerocopy_callback will be called on
> > kfree_skb?
>
> We can not call kfree_skb() until the skb was created.
>
> >
> > Or alternatively clear the destructor in drop:
>
> The uarg->callback() is called immediately after we decide do datacopy
> even if caller want to do zerocopy. If another error occurs later, the vhost
> handle_tx() will try to decrease it again.

Oh right, I missed the else branch in this path:

        /* copy skb_ubuf_info for callback when skb has no error */
        if (zerocopy) {
                skb_shinfo(skb)->destructor_arg = msg_control;
                skb_shinfo(skb)->tx_flags |= SKBTX_DEV_ZEROCOPY;
                skb_shinfo(skb)->tx_flags |= SKBTX_SHARED_FRAG;
        } else if (msg_control) {
                struct ubuf_info *uarg = msg_control;
                uarg->callback(uarg, false);
        }

So if handle_tx_zerocopy calls tun_sendmsg with ubuf_info (and thus a
reference to release), there are these five options:

1. tun_sendmsg succeeds, ubuf_info is associated with skb.
     reference released from kfree_skb calling vhost_zerocopy_callback later

2. tun_sendmsg succeeds, ubuf_info is released immediately, as skb is
not zerocopy.

3. tun_sendmsg fails before creating skb, handle_tx_zerocopy correctly
cleans up on receiving error from tun_sendmsg.

4. tun_sendmsg fails after creating skb, but with copying: decremented
at branch shown above + again in handle_tx_zerocopy

5. tun_sendmsg fails after creating skb, with zerocopy: decremented at
kfree_skb in drop: + again in handle_tx_zerocopy

Since handle_tx_zerocopy has no idea whether on error 3, 4 or 5
occurred, either all decrement-on-error cases must be handled by
handle_tx_zerocopy or none.

Your patch chooses the latter. Makes sense.

But can this still go wrong if the xdp path is taken, but no program
exists or the program returns XDP_PASS. And then the packet hits an
error path, such as ! IFF_UP?
