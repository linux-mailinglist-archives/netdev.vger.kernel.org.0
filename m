Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC902D921C
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 04:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438419AbgLND4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 22:56:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438400AbgLND4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 22:56:17 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339D0C061794
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 19:55:37 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id w1so15949939ejf.11
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 19:55:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=d4TOJ0OhuO8aQINr4ymrDs96mPIyR6ulw4ivnTC1GK0=;
        b=HV27Sistxdj6DbrnPLahKB8aC9AzdKctIUA7IQzRETHqMP5bdprl/0bs+86B1e7FfR
         vx4O6GGYoach9taVZwSRzeh9Gc5eIVGZxlaKE6KiWiko7ujtOU3kBLtLr2nVAj7/5dXZ
         YPk3Qa9UfBK18jH+k/k/0A219ia9BmrdEOET05kxyF4YUHP9Zr7AWnF3edROwPNoMI+a
         PYEE8eJ0/N7VN9nrtC85AQRoKG3QIvU9rubr7LjdX+O6hOsiz8wcADLySBxA24S60iwD
         P0lM7vP7Jx94mjfUspjFOu55ZpGsLw28tT2mfH7NSAdeysgqgUhFW29bGBS+TujWi7v/
         1ysQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=d4TOJ0OhuO8aQINr4ymrDs96mPIyR6ulw4ivnTC1GK0=;
        b=kLqaeRY75JULFwpuZbVyYiaIsJmZm84vE5DmdqaD7E35v7wrpuX5zHKInprKjlZFZG
         B8k+XyXavyW1nDjmst55uinhDOY3UFVBJPv0SAB9vR3hlYk9lJh2N6VDipUGNeXNRBIy
         TncuSKFpow3sS2HVCZmbXAqP+ISwdEoeX6KJyX07qjqMm0yQ96gkcLWgHQdTrYdC0zp3
         bbi0GJjcL3i4DYBWmWCqCkInx2uHf7HDXJ7uDOOVa+rcQQJxZ5JwZS8aya9eNaguzYWb
         VkDpaQVLTJuOo4Nk6zQyTT+IeE+B1C8XfY+Gg1vO21X1YK+Ozxw8/WpdyBjMupZaVlzR
         P8jA==
X-Gm-Message-State: AOAM532Oxr4V3R59hkIaL+W5hpcSU9yLQIb4UQXrXZXXQ9oBeNb1eC9P
        w34n9Ry7mVt/RtCIZrU1CZwoRA5Ii3Y3y6xAr98=
X-Google-Smtp-Source: ABdhPJzvPrPpJv94YN3ajoeyIC0cBwCW9IBY1P/wA7dhs00SjshhvOaFHBhVUSiN3JqL4anEOgkVTaUVxvvI//wQDpE=
X-Received: by 2002:a17:906:4348:: with SMTP id z8mr21550852ejm.119.1607918135935;
 Sun, 13 Dec 2020 19:55:35 -0800 (PST)
MIME-Version: 1.0
References: <1606982459-41752-1-git-send-email-wangyunjian@huawei.com>
 <1607517703-18472-1-git-send-email-wangyunjian@huawei.com>
 <CA+FuTSfQoDr0jd76xBXSvchhyihQaL2UQXeCR6frJ7hyXxbmVA@mail.gmail.com>
 <34EFBCA9F01B0748BEB6B629CE643AE60DB6E3B3@dggemm513-mbx.china.huawei.com>
 <CA+FuTSdVJa4JQzzybZ17WDcfokA2RZ043kh5++Zgy5aNNebj0A@mail.gmail.com>
 <CAF=yD-LF+j1vpzKDtBVUi22ZkTCEnMAXgfLfoQTBO+95D6RGRA@mail.gmail.com> <75c625df-3ac8-79ba-d1c5-3b6d1f9b108b@redhat.com>
In-Reply-To: <75c625df-3ac8-79ba-d1c5-3b6d1f9b108b@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 13 Dec 2020 22:54:59 -0500
Message-ID: <CAF=yD-+Hcg8cNo2qMfpGOWRORJskZR3cPPEE61neg7xFWkVh8w@mail.gmail.com>
Subject: Re: [PATCH net v2] tun: fix ubuf refcount incorrectly on error path
To:     Jason Wang <jasowang@redhat.com>
Cc:     wangyunjian <wangyunjian@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>,
        "huangbin (J)" <brian.huangbin@huawei.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 13, 2020 at 10:30 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2020/12/14 =E4=B8=8A=E5=8D=889:32, Willem de Bruijn wrote:
> > On Sat, Dec 12, 2020 at 7:18 PM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> >>>>> afterwards, the error handling in vhost handle_tx() will try to
> >>>>> decrease the same refcount again. This is wrong and fix this by del=
ay
> >>>>> copying ubuf_info until we're sure there's no errors.
> >>>> I think the right approach is to address this in the error paths, ra=
ther than
> >>>> complicate the normal datapath.
> >>>>
> >>>> Is it sufficient to suppress the call to vhost_net_ubuf_put in the h=
andle_tx
> >>>> sendmsg error path, given that vhost_zerocopy_callback will be calle=
d on
> >>>> kfree_skb?
> >>> We can not call kfree_skb() until the skb was created.
> >>>
> >>>> Or alternatively clear the destructor in drop:
> >>> The uarg->callback() is called immediately after we decide do datacop=
y
> >>> even if caller want to do zerocopy. If another error occurs later, th=
e vhost
> >>> handle_tx() will try to decrease it again.
> >> Oh right, I missed the else branch in this path:
> >>
> >>          /* copy skb_ubuf_info for callback when skb has no error */
> >>          if (zerocopy) {
> >>                  skb_shinfo(skb)->destructor_arg =3D msg_control;
> >>                  skb_shinfo(skb)->tx_flags |=3D SKBTX_DEV_ZEROCOPY;
> >>                  skb_shinfo(skb)->tx_flags |=3D SKBTX_SHARED_FRAG;
> >>          } else if (msg_control) {
> >>                  struct ubuf_info *uarg =3D msg_control;
> >>                  uarg->callback(uarg, false);
> >>          }
> >>
> >> So if handle_tx_zerocopy calls tun_sendmsg with ubuf_info (and thus a
> >> reference to release), there are these five options:
> >>
> >> 1. tun_sendmsg succeeds, ubuf_info is associated with skb.
> >>       reference released from kfree_skb calling vhost_zerocopy_callbac=
k later
> >>
> >> 2. tun_sendmsg succeeds, ubuf_info is released immediately, as skb is
> >> not zerocopy.
> >>
> >> 3. tun_sendmsg fails before creating skb, handle_tx_zerocopy correctly
> >> cleans up on receiving error from tun_sendmsg.
> >>
> >> 4. tun_sendmsg fails after creating skb, but with copying: decremented
> >> at branch shown above + again in handle_tx_zerocopy
> >>
> >> 5. tun_sendmsg fails after creating skb, with zerocopy: decremented at
> >> kfree_skb in drop: + again in handle_tx_zerocopy
> >>
> >> Since handle_tx_zerocopy has no idea whether on error 3, 4 or 5
> >> occurred,
> > Actually, it does. If sendmsg returns an error, it can test whether
> > vq->heads[nvq->upend_idx].len !=3D VHOST_DMA_IN_PROGRESS.
>
>
> Just to make sure I understand this. Any reason for it can't be
> VHOST_DMA_IN_PROGRESS here?

It can be, and it will be if tun_sendmsg returns EINVAL before
assigning the skb destructor.

Only if tun_sendmsg released the zerocopy state through
kfree_skb->vhost_zerocopy_callback will it have been updated to
VHOST_DMA_DONE_LEN. And only then must the caller not try to release
the state again.
