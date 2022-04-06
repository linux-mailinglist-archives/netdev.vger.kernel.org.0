Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC724F66B1
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238739AbiDFRQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 13:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238769AbiDFRQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 13:16:26 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513363CBE5E;
        Wed,  6 Apr 2022 08:11:49 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id p10so4576664lfa.12;
        Wed, 06 Apr 2022 08:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t9shGsUw2eY5d0NfFfgvuKkr7vH8rDlgXmHGXxXGSHo=;
        b=B5pjk+WtMgzMcwBFokFRZw67hMjZqwn5cibcx0iEannw5JJtMcKiBnzLdvoP1YepmE
         QqeBbw8oElL5K53i7aWmDYDxx3rhVL82Q6wddXFcr1qKZKp0+s+XCHdeMwNzxRK4Ew9F
         9/ZJEk9oIVmoWnZZKKMtewVr6vGy9cFLWoyw9CKuXfy38W+fKebiKvBDzxNq8yKU18Ca
         1i0/qfnXKz1kaIsJtbCQZ+5Yeoms11tBqk8KiDA5QTw/iAkGk8m4iVWYq0sDMC3vYpfh
         zMykbNt6EOfhbu2nMIyxUF7YCcBI3+5oi4MR+hGyyoaHLX+5EXCgI8t05m2ygVUcFqgn
         C4VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t9shGsUw2eY5d0NfFfgvuKkr7vH8rDlgXmHGXxXGSHo=;
        b=ouIIaaIZXZVZazrPOvKhZG8L7VDJ6RKZioQBS/TrXUYfIEqc2DE5/3z+uBHp/17q7t
         LXl5D7tqMR1La0f4arPX4BMNqI9hFqGA1QjHjND+LdmxSADMkw1ohVqrO655ZBZTJA9U
         Bh+gzL9p6NM1sPRV2wSs6V3UQJjPUxkAey1Vtj9P14LkjL08ogXz4bHNmDpIwoyJKaoY
         rZsWGnXcdQCf7CGWl7ZZ7dIxSGUSHBk0WTHTPvWGxoniddd8P7OXm6bLQxWdBZCnu9zb
         FnTg6nylvjbPGtkx3VbiMHsEjeiE22kcARo7PUwKoACnOuJ2xWE/PSFgxuv8afUowevP
         rmBA==
X-Gm-Message-State: AOAM53255BafDmQTjK8/nZPKYL8u8BMFjhh3vmB7vAwMc5IevsIZBot0
        JOr+E/liGEOTow+xd+J6T37E3RT1Cqajyoke478=
X-Google-Smtp-Source: ABdhPJz4N1mouexc73ad7+tp6qPOfsUqgFpdjZKAK2n0DI9xH1ho3WVp6YTyj/W7rNbLrLlEuQ7XV3ZiDJkKkazLijA=
X-Received: by 2002:a05:6512:c0e:b0:44a:b599:f778 with SMTP id
 z14-20020a0565120c0e00b0044ab599f778mr6203179lfu.643.1649257907357; Wed, 06
 Apr 2022 08:11:47 -0700 (PDT)
MIME-Version: 1.0
References: <a77a584b3ce9761eb5dda5828192e1cab94571f0.1649037151.git.lucien.xin@gmail.com>
 <CAFqZXNt=Ca+x7PaYgc1jXq-3cKxin-_=UNCSiyVHjbP7OYUKvA@mail.gmail.com>
 <CADvbK_fTnWhnuxR7JkNYeoSB4a1nSX7O0jg4Mif6V_or-tOy3w@mail.gmail.com>
 <CAFqZXNss=7DMb=75ZBDwL9HrrubkxJK=xu7-kqxX-Mw1FtRuuA@mail.gmail.com>
 <CADvbK_ciV+evm6JY=uVpsHn1W-Cevp+FRzaQtxJO-CpQ392htQ@mail.gmail.com> <CAFqZXNvk0i+WC8O=BhETCPYgaKm1zE29JQHfMety8CA7EKhDtg@mail.gmail.com>
In-Reply-To: <CAFqZXNvk0i+WC8O=BhETCPYgaKm1zE29JQHfMety8CA7EKhDtg@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 6 Apr 2022 11:11:34 -0400
Message-ID: <CADvbK_drixdD3FBiVH+3V=wpN4QjrFZB+oWrGf-XjYKKGNJL0Q@mail.gmail.com>
Subject: Re: [PATCH net] sctp: use the correct skb for security_sctp_assoc_request
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        SElinux list <selinux@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 6, 2022 at 11:04 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
>
> On Wed, Apr 6, 2022 at 4:21 PM Xin Long <lucien.xin@gmail.com> wrote:
> > On Wed, Apr 6, 2022 at 9:34 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> > >
> > > On Tue, Apr 5, 2022 at 1:58 PM Xin Long <lucien.xin@gmail.com> wrote:
> > > > On Mon, Apr 4, 2022 at 6:15 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> > > > >
> > > > > Adding LSM and SELinux lists to CC for awareness; the original patch
> > > > > is available at:
> > > > > https://lore.kernel.org/netdev/a77a584b3ce9761eb5dda5828192e1cab94571f0.1649037151.git.lucien.xin@gmail.com/T/
> > > > > https://patchwork.kernel.org/project/netdevbpf/patch/a77a584b3ce9761eb5dda5828192e1cab94571f0.1649037151.git.lucien.xin@gmail.com/
> > > > >
> > > > > On Mon, Apr 4, 2022 at 3:53 AM Xin Long <lucien.xin@gmail.com> wrote:
> > > > > >
> > > > > > Yi Chen reported an unexpected sctp connection abort, and it occurred when
> > > > > > COOKIE_ECHO is bundled with DATA Fragment by SCTP HW GSO. As the IP header
> > > > > > is included in chunk->head_skb instead of chunk->skb, it failed to check
> > > > > > IP header version in security_sctp_assoc_request().
> > > > > >
> > > > > > According to Ondrej, SELinux only looks at IP header (address and IPsec
> > > > > > options) and XFRM state data, and these are all included in head_skb for
> > > > > > SCTP HW GSO packets. So fix it by using head_skb when calling
> > > > > > security_sctp_assoc_request() in processing COOKIE_ECHO.
> > > > >
> > > > > The logic looks good to me, but I still have one unanswered concern.
> > > > > The head_skb member of struct sctp_chunk is defined inside a union:
> > > > >
> > > > > struct sctp_chunk {
> > > > >         [...]
> > > > >         union {
> > > > >                 /* In case of GSO packets, this will store the head one */
> > > > >                 struct sk_buff *head_skb;
> > > > >                 /* In case of auth enabled, this will point to the shkey */
> > > > >                 struct sctp_shared_key *shkey;
> > > > >         };
> > > > >         [...]
> > > > > };
> > > > >
> > > > > What guarantees that this chunk doesn't have "auth enabled" and the
> > > > > head_skb pointer isn't actually a non-NULL shkey pointer? Maybe it's
> > > > > obvious to a Linux SCTP expert, but at least for me as an outsider it
> > > > > isn't - that's usually a good hint that there should be a code comment
> > > > > explaining it.
> > > > Hi Ondrej,
> > > >
> > > > shkey is for tx skbs only, while head_skb is for skbs on rx path.
> > >
> > > That makes sense, thanks. I would still be happier if this was
> > > documented, but the comment would best fit in the struct sctp_chunk
> > > definition and that wouldn't fit in this patch...
> > >
> > > Actually I have one more question - what about the
> > > security_sctp_assoc_established() call in sctp_sf_do_5_1E_ca()? Is
> > > COOKIE ACK guaranteed to be never bundled?
> > COOKIE ACK could also be bundled with DATA.
> > I didn't change it as it would not break SCTP.
> > (security_inet_conn_established() returns void)
> > But I don't mind changing it if you think it's necessary.
>
> security_inet_conn_established? Are you looking at an old version of
> the code, perhaps? In mainline, sctp_sf_do_5_1E_ca() now calls the new
> security_sctp_assoc_established() hook, which may return an error. But
> even if it didn't, I believe we want to make sure that an skb with
> valid inet headers and XFRM state is passed to the hooks as SELinux
> relies on these to correctly process the SCTP association.
Sorry, I was looking at the old one.
OK, I will post v2 with the fix in sctp_sf_do_5_1E_ca().

Thanks for reviewing.

>
> --
> Ondrej Mosnacek
> Software Engineer, Linux Security - SELinux kernel
> Red Hat, Inc.
>
