Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B735237740B
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 22:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhEHUmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 16:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbhEHUmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 16:42:32 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F55CC061574;
        Sat,  8 May 2021 13:41:29 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id ge1so7621774pjb.2;
        Sat, 08 May 2021 13:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NRPHusgi1pQtuzZNcISMSpWg+CEKh/yMry5lbQzE+s8=;
        b=DC4XHcPSH0LGQwi2Ry7p7T140RMGMBZYYI5fZk3wfObatqYjYGtefitYilrxKph+Kg
         /C4tbLm8MbLwIZUOmprOOAx8EsfATkG0AUqiwborO6USUJvGE4ENFOOoR9fZi8tYysWu
         N4MHgvQEHa0IMMBdvwsl0TombHDRGhj3UDvOEZvytaGPMm4inBA+oXDjVhoN7z6/PglN
         0US4S+3iNxUrGZ3N50PdpF/ph7ui8usB5SpFju9Wp33cyx5VyXta2ZDu5qB+ti3CMQTF
         B6YC6KfRqnKvWKnn/q44cXKZC4k4Pr0cOaYCZDKmH6gp/MvLencEh//470mPNBI6+RXa
         fJbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NRPHusgi1pQtuzZNcISMSpWg+CEKh/yMry5lbQzE+s8=;
        b=RnFvB3sgbTJXhrNTHX93Ga5zEep8Fg8+xI+9ENu+yzWLKdgWxQewXQNN+H0AfbaRlg
         33lKIl824GPV/IndARrKH1i1PSfgT7xyWrTACS3IE1tSUzUvbWRC8vNG9Bm+yDa5krG0
         Uyk554iUbYOWqdzFgUGfWbPglmGavhmcUpCLXp+Ma8imiWZG8LoBBrNYgTE22WI/kjDi
         HjK1a0ckn0kjGa1VyksoX51ylh+CnbijYfe9WTWF+3Hz29NAHZhYGTmc6Ne/hmSEyKKn
         YrrZivU33y3mx4WQh39QL7omc2Cognllb9lErwPir5DH6CdexX+Kf/45NIOp5FDXoi6r
         d7oQ==
X-Gm-Message-State: AOAM532Sq6Qg2LhxNNzEKCn1UX2I6FuVML5oFCmH881j2KcXDvRgXfCc
        YZoWAwK7q5zJ2Dj4cSKNu4vMFYnxT81BbOrt/eU=
X-Google-Smtp-Source: ABdhPJz/fX3iasS9h4PGjkXBR6cJrV70/xBEBGpTSFIG11vf6kqtS01ZkW6tnqruQ4i0ix9AFXuT2CdF9Vb8Pb1jx0A=
X-Received: by 2002:a17:90b:1d8a:: with SMTP id pf10mr31117544pjb.145.1620506489121;
 Sat, 08 May 2021 13:41:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
 <20210426025001.7899-5-xiyou.wangcong@gmail.com> <87mtt7ufbl.fsf@cloudflare.com>
In-Reply-To: <87mtt7ufbl.fsf@cloudflare.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 8 May 2021 13:41:18 -0700
Message-ID: <CAM_iQpU_JR8ntXBYO0ReQLtXE8CCPoCOJtPTXfY8JQav1C-kDw@mail.gmail.com>
Subject: Re: [Patch bpf-next v3 04/10] af_unix: set TCP_ESTABLISHED for
 datagram sockets too
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Jiang Wang <jiang.wang@bytedance.com>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 7, 2021 at 1:18 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Mon, Apr 26, 2021 at 04:49 AM CEST, Cong Wang wrote:
> > diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> > index 8968ed44a89f..c4afc5fbe137 100644
> > --- a/net/unix/af_unix.c
> > +++ b/net/unix/af_unix.c
> > @@ -1206,6 +1206,8 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
> >               unix_peer(sk) = other;
> >               unix_state_double_unlock(sk, other);
> >       }
> > +
> > +     sk->sk_state = other->sk_state = TCP_ESTABLISHED;
>
> `other` can be NULL. In such case we're back to UNCONNECTED state.

Right, we also need to move the sk_state back to TCP_CLOSE
after disconnecting.

Thanks.
