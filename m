Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41382D9220
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 04:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438473AbgLND6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 22:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438382AbgLND6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 22:58:10 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27873C0613CF
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 19:57:30 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id q22so2875578eja.2
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 19:57:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EJC5ZzsIIq3UAE8aJlS7Xk78x4gMxvFaGCPtz1UbuaQ=;
        b=HwfOEgHg1GNGxCxVE03N9r7iWwYXWMBXk+ZnlrNY5TtBOLwfOJ2Og5DSzJH4jP/7HD
         VbndUjq+bteONBlXkp5z8VAMe7ztwlJalfO2wBgFDERpTsByBrp/TGQBvNsqi4qRYuZF
         z3v5F4J5MrNOY9XgnKWnpiXghRm4BMHgGLOWYXlfrAlNhFDiXc/1dwyo7G5W0J02oOVr
         VbNCmRD+YAl7trsp8BJ5qeT9bpwgiw4crcSmRSQjcPDBFoYTnc6tHKC9ge3JsDF2+VKc
         YZst+BYJoUm3hplXZN0cpflRQWaB+lL6cumUfcZ/nzeS+qkx7HzKklE/OZaNpkZ4FpA2
         km+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EJC5ZzsIIq3UAE8aJlS7Xk78x4gMxvFaGCPtz1UbuaQ=;
        b=hnZJvKiVoHvidMgH+xHL0PTsCO2jdiTPvQuFiS06tOlrgIV9RY1aHGzDY+woi+RdS9
         q3VBzppywts3iVkwJWlzIiIuLQspqm0/K2wqh7MYa9acjQBGvClx9Hpetsf9b1vcEv9v
         33Ago9TzMPFjEONi7/yRLwfYCH7qqwxQaXwj6MSw7F5YY/ahdoRECmqA1QKswkrReZUu
         iqRQF4NFyR3aOF1JQj5ZmP7SQ8SqQAP545bbukIexohbM9F8KT7tHi5OLQBWeL3r0QiZ
         57YicMIX+rq30lDypy8HYa7A3jOF9YoK8j/JGR0UKAikiGVXdWZ9voqpEJFeh+p9e+Zy
         U7ew==
X-Gm-Message-State: AOAM530VTmtjNWDlwphoauW+dbZubcE9bjLvJDzChiODY4UatrhNKzRh
        tvkFF+DV63SxyKoNyzPSPt/0MrLm7/HyoFA/ZAk=
X-Google-Smtp-Source: ABdhPJxMQnRsYVVIOUdbGO0aaSenQceYBxS/yvGzUvqIYRohiCnZmm5BQUteacU5TBSqzP3Z7c/cj6fTCvTpTzcJ+x4=
X-Received: by 2002:a17:906:52d9:: with SMTP id w25mr20332462ejn.504.1607918248919;
 Sun, 13 Dec 2020 19:57:28 -0800 (PST)
MIME-Version: 1.0
References: <1606982459-41752-1-git-send-email-wangyunjian@huawei.com>
 <1607517703-18472-1-git-send-email-wangyunjian@huawei.com>
 <CA+FuTSfQoDr0jd76xBXSvchhyihQaL2UQXeCR6frJ7hyXxbmVA@mail.gmail.com>
 <34EFBCA9F01B0748BEB6B629CE643AE60DB6E3B3@dggemm513-mbx.china.huawei.com>
 <CA+FuTSdVJa4JQzzybZ17WDcfokA2RZ043kh5++Zgy5aNNebj0A@mail.gmail.com>
 <CAF=yD-LF+j1vpzKDtBVUi22ZkTCEnMAXgfLfoQTBO+95D6RGRA@mail.gmail.com>
 <75c625df-3ac8-79ba-d1c5-3b6d1f9b108b@redhat.com> <CAF=yD-+Hcg8cNo2qMfpGOWRORJskZR3cPPEE61neg7xFWkVh8w@mail.gmail.com>
In-Reply-To: <CAF=yD-+Hcg8cNo2qMfpGOWRORJskZR3cPPEE61neg7xFWkVh8w@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 13 Dec 2020 22:56:52 -0500
Message-ID: <CAF=yD-JHO3SaxaHAZJ8nZ1jy8Zp4hMt1EhP3abutA5zczgTv5g@mail.gmail.com>
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

On Sun, Dec 13, 2020 at 10:54 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Sun, Dec 13, 2020 at 10:30 PM Jason Wang <jasowang@redhat.com> wrote:
> >
> >
> > On 2020/12/14 =E4=B8=8A=E5=8D=889:32, Willem de Bruijn wrote:
> > > On Sat, Dec 12, 2020 at 7:18 PM Willem de Bruijn
> > > <willemdebruijn.kernel@gmail.com> wrote:
> > >>>>> afterwards, the error handling in vhost handle_tx() will try to
> > >>>>> decrease the same refcount again. This is wrong and fix this by d=
elay
> > >>>>> copying ubuf_info until we're sure there's no errors.
> > >>>> I think the right approach is to address this in the error paths, =
rather than
> > >>>> complicate the normal datapath.
> > >>>>
> > >>>> Is it sufficient to suppress the call to vhost_net_ubuf_put in the=
 handle_tx
> > >>>> sendmsg error path, given that vhost_zerocopy_callback will be cal=
led on
> > >>>> kfree_skb?
> > >>> We can not call kfree_skb() until the skb was created.
> > >>>
> > >>>> Or alternatively clear the destructor in drop:
> > >>> The uarg->callback() is called immediately after we decide do datac=
opy
> > >>> even if caller want to do zerocopy. If another error occurs later, =
the vhost
> > >>> handle_tx() will try to decrease it again.
> > >> Oh right, I missed the else branch in this path:
> > >>
> > >>          /* copy skb_ubuf_info for callback when skb has no error */
> > >>          if (zerocopy) {
> > >>                  skb_shinfo(skb)->destructor_arg =3D msg_control;
> > >>                  skb_shinfo(skb)->tx_flags |=3D SKBTX_DEV_ZEROCOPY;
> > >>                  skb_shinfo(skb)->tx_flags |=3D SKBTX_SHARED_FRAG;
> > >>          } else if (msg_control) {
> > >>                  struct ubuf_info *uarg =3D msg_control;
> > >>                  uarg->callback(uarg, false);
> > >>          }
> > >>
> > >> So if handle_tx_zerocopy calls tun_sendmsg with ubuf_info (and thus =
a
> > >> reference to release), there are these five options:
> > >>
> > >> 1. tun_sendmsg succeeds, ubuf_info is associated with skb.
> > >>       reference released from kfree_skb calling vhost_zerocopy_callb=
ack later
> > >>
> > >> 2. tun_sendmsg succeeds, ubuf_info is released immediately, as skb i=
s
> > >> not zerocopy.
> > >>
> > >> 3. tun_sendmsg fails before creating skb, handle_tx_zerocopy correct=
ly
> > >> cleans up on receiving error from tun_sendmsg.
> > >>
> > >> 4. tun_sendmsg fails after creating skb, but with copying: decrement=
ed
> > >> at branch shown above + again in handle_tx_zerocopy
> > >>
> > >> 5. tun_sendmsg fails after creating skb, with zerocopy: decremented =
at
> > >> kfree_skb in drop: + again in handle_tx_zerocopy
> > >>
> > >> Since handle_tx_zerocopy has no idea whether on error 3, 4 or 5
> > >> occurred,
> > > Actually, it does. If sendmsg returns an error, it can test whether
> > > vq->heads[nvq->upend_idx].len !=3D VHOST_DMA_IN_PROGRESS.
> >
> >
> > Just to make sure I understand this. Any reason for it can't be
> > VHOST_DMA_IN_PROGRESS here?
>
> It can be, and it will be if tun_sendmsg returns EINVAL before
> assigning the skb destructor.

I meant returns an error, not necessarily only EINVAL.

> Only if tun_sendmsg released the zerocopy state through
> kfree_skb->vhost_zerocopy_callback will it have been updated to
> VHOST_DMA_DONE_LEN. And only then must the caller not try to release
> the state again.
