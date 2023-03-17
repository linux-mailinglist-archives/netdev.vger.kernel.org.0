Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2423B6BF019
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 18:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbjCQRrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 13:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbjCQRrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 13:47:24 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50E1C4E9C
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 10:47:20 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id bp11so3144346ilb.3
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 10:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679075239;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=93R1RrX9I3twrt6aZ9BIfES4YHf18kk5Xpf+bgkTsFA=;
        b=PD2qfnUU+81DGZ/Rvuz7qAyKjlQLcMvc05j/hoDjoEwA5eiuB0I1CbqP7XBheMmXke
         g5dra7fqS9CghgxlYmNg2qYY2brMqznNLefc6ZOqGnLT6MPAiGHkNQ6gx+PrhMGdnVXM
         skpscbwOFb1soXAcNdPBSttVtIpeHuSZSVYvpKCe36FhLxeHbLLCEjx7Ovj5M80ojbI2
         qWn3hLvatynKRnmwdmyN8Y+O0IF8G97clik6e2tlJsAgtwyWLY2vEbcgkl26NDTOlwic
         sCXyED2OoJlrkuuQIWybn77SwfQeWxZxjZsMdDQhY8XbD7aiy+QPjQfT0dyrw30DICXK
         y4HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679075239;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=93R1RrX9I3twrt6aZ9BIfES4YHf18kk5Xpf+bgkTsFA=;
        b=jyhi1qmpkhzjotVKGrnciMjaswo9Lx3LGrcJqGMKVE0/RGtQVa64kwqZmZs8lxksst
         9o117Mh0g5qhcC1WR70xx17eH6Ryqavs/lNbwjLweiSI50xXE4AcotfvqumR2BABwTVA
         W6k8E+oUnD0hkKClveKO1HOAAmySUiMk2nl6Trs3G23MkjB/rtRN3Wf24bTdmv98+QBb
         3PBu+hT+exBjP9xXdAYgs/NcR9sDoMpnThuEV5M3Pt81zYueMEdHiBs+NBJCYWWzxwwx
         mHdU0nn2N8HU2WWCwX6QdPxJXxaPR3W6tS13AeNIct1RgxkNRm9y6mXpZvtzrXgInURD
         C3+g==
X-Gm-Message-State: AO0yUKVA8IpsIpXRjsUJWB5Wub9GhCyBiD/sKIl09O0EUqdeGVR6dQJc
        1jyoZRvneT8a5meERvtHUiFDLOZvVUNH/HUyxJAmlw==
X-Google-Smtp-Source: AK7set/Jf6pm6FDlnwo8nSk++N9Z/WXrdCRhRo1Z1cj7Y9sWFycQiIrzO9PAtL4vAzyIXcVhNzhnbH2clf7P5qUrcek=
X-Received: by 2002:a92:7b04:0:b0:310:a24c:4231 with SMTP id
 w4-20020a927b04000000b00310a24c4231mr130240ilc.6.1679075239439; Fri, 17 Mar
 2023 10:47:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230317155539.2552954-1-edumazet@google.com> <20230317155539.2552954-10-edumazet@google.com>
 <b9b3e7a2-788b-13ca-91a6-3017c8afbbf4@tessares.net>
In-Reply-To: <b9b3e7a2-788b-13ca-91a6-3017c8afbbf4@tessares.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 17 Mar 2023 10:47:08 -0700
Message-ID: <CANn89i+xOmDmD2=1EQF0U5F5+GQb_HfAWmQD=1FP+6L=qK-E5w@mail.gmail.com>
Subject: Re: [PATCH net-next 09/10] mptcp: preserve const qualifier in mptcp_sk()
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Willem de Bruijn <willemb@google.com>,
        eric.dumazet@gmail.com, MPTCP Upstream <mptcp@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 10:32=E2=80=AFAM Matthieu Baerts
<matthieu.baerts@tessares.net> wrote:
>
> Hi Eric,
>
> On 17/03/2023 16:55, Eric Dumazet wrote:
> > We can change mptcp_sk() to propagate its argument const qualifier,
> > thanks to container_of_const().
> >
> > We need to change few things to avoid build errors:
> >
> > mptcp_set_datafin_timeout() and mptcp_rtx_head() have to accept
> > non-const sk pointers.
> >
> > @msk local variable in mptcp_pending_tail() must be const.
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Matthieu Baerts <matthieu.baerts@tessares.net>
>
> Good idea!
>
> Thank you for this patch and for having Cced me.
>
> It looks good to me. I just have one question below if you don't mind.
>
> (...)
>
> > diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
> > index 61fd8eabfca2028680e04558b4baca9f48bbaaaa..4ed8ffffb1ca473179217e6=
40a23bc268742628d 100644
> > --- a/net/mptcp/protocol.h
> > +++ b/net/mptcp/protocol.h
>
> (...)
>
> > @@ -381,7 +378,7 @@ static inline struct mptcp_data_frag *mptcp_pending=
_tail(const struct sock *sk)
> >       return list_last_entry(&msk->rtx_queue, struct mptcp_data_frag, l=
ist);
> >  }
> >
> > -static inline struct mptcp_data_frag *mptcp_rtx_head(const struct sock=
 *sk)
> > +static inline struct mptcp_data_frag *mptcp_rtx_head(struct sock *sk)
>
> It was not clear to me why you had to remove the "const" qualifier here
> and not just have to add one when assigning the msk just below. But then
> I looked at what was behind the list_first_entry_or_null() macro used in
> this function and understood what was the issue.
>
>
> My naive approach would be to modify this macro but I guess we don't
> want to go down that road, right?
>
> -------------------- 8< --------------------
> diff --git a/include/linux/list.h b/include/linux/list.h
> index f10344dbad4d..cd770766f451 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -550,7 +550,7 @@ static inline void list_splice_tail_init(struct
> list_head *list,
>   * Note that if the list is empty, it returns NULL.
>   */
>  #define list_first_entry_or_null(ptr, type, member) ({ \
> -       struct list_head *head__ =3D (ptr); \
> +       const struct list_head *head__ =3D (ptr); \
>         struct list_head *pos__ =3D READ_ONCE(head__->next); \
>         pos__ !=3D head__ ? list_entry(pos__, type, member) : NULL; \
>  })
> -------------------- 8< --------------------

This could work, but it is a bit awkward.

mptcp_rtx_head() is used  in a context where we are changing the
socket, not during a readonly lookup ?

>
>
> It looks safe to me to do that but I would not trust myself on a Friday
> evening :)
> (I'm sure I'm missing something, I'm sorry if it is completely wrong)
>
> Anyway if we cannot modify list_first_entry_or_null() one way or
> another, I'm fine with your modification!
>
> Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
>

Thanks !
