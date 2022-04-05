Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E36C4F3DE6
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 22:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243990AbiDEOXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381525AbiDEMya (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 08:54:30 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C701ECEC;
        Tue,  5 Apr 2022 04:58:36 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id d5so22747843lfj.9;
        Tue, 05 Apr 2022 04:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kHEqj5M158n+dGH/l2poz1rrg1KKwE9IbzvYK9DFF6U=;
        b=VoVtihAxFWewhd6ZlzhhBU39ctV48Q8C4dQJB6R/JTmzssVOUh5k1I5yDPQOAoA7vO
         NxTh7DNeI5r/a5xP8vj98bA/UPIGYJ1xTbB9tRmoF/G+LtwRrhn/ytBOuFaT5knOifoz
         DMgYASiCFphlLhS9HUtpEiv5kq5nbLKqAUGHUSscxGERDm9jK68tW0OUsI6GTct2LnEC
         3dPzZuckfY9g+wyYOlgH/04UxxyI91UVyGWlk2LqtB+qRVxQALwE2kc+sys7jfggX1Jh
         H/1fmf6grIF2KRC6rl2/2assPNDu9L02KhjMgH1aYEVEZ42UWAc7oNaBRBe5FvIprv8p
         O3Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kHEqj5M158n+dGH/l2poz1rrg1KKwE9IbzvYK9DFF6U=;
        b=fYFdrLDG3VBuuCsVn7lRHsmSNHIDFxCJZJYWlYbqq/Sj3WhnGL9QPNxWMaz70eegVK
         2LI8uRdz2XYdv+u1MWSwyjUtrYdXbk3m/mxGTt/eMKO7WWoM6O58ckfEc0duKnh1xVSH
         yhf/z64JBqIK2rDtTxBulmV5j5xODBQ03H7wqGSIgUJ4V++iRxujLYKeww7Omu0qqjhG
         ekoLXwuqKkG3T6vwSYbXapArAR/fxMvfZ2Zgl++32dto6df1VVk55vQqeyC8us4qvOt4
         pcXMwt0ntqWqfrdH0X8sGLD9WZdKAv+T0xEpyAEispGhrp1XqGSGKne8eINJzfmoFoDq
         Z26A==
X-Gm-Message-State: AOAM531W+pETYIJjM2Yy0af4w1hbMrBVKSys+YGEipTjR7aMXKX7tpP8
        Fi1eni00cF+qv6+SSpHjbV1MFB+9REWP07H1sO8=
X-Google-Smtp-Source: ABdhPJzHY2DzJ/dKMTTA6hLzbE+/2cS2FWiicU36xSAhh2CeuZ55sVJEEyj7egPZFO5r6QCyKTgaktYWG3fYXdcd9Rw=
X-Received: by 2002:ac2:510f:0:b0:44a:5ccc:99fb with SMTP id
 q15-20020ac2510f000000b0044a5ccc99fbmr2399027lfb.38.1649159914944; Tue, 05
 Apr 2022 04:58:34 -0700 (PDT)
MIME-Version: 1.0
References: <a77a584b3ce9761eb5dda5828192e1cab94571f0.1649037151.git.lucien.xin@gmail.com>
 <CAFqZXNt=Ca+x7PaYgc1jXq-3cKxin-_=UNCSiyVHjbP7OYUKvA@mail.gmail.com>
In-Reply-To: <CAFqZXNt=Ca+x7PaYgc1jXq-3cKxin-_=UNCSiyVHjbP7OYUKvA@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 5 Apr 2022 07:58:20 -0400
Message-ID: <CADvbK_fTnWhnuxR7JkNYeoSB4a1nSX7O0jg4Mif6V_or-tOy3w@mail.gmail.com>
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

On Mon, Apr 4, 2022 at 6:15 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
>
> Adding LSM and SELinux lists to CC for awareness; the original patch
> is available at:
> https://lore.kernel.org/netdev/a77a584b3ce9761eb5dda5828192e1cab94571f0.1649037151.git.lucien.xin@gmail.com/T/
> https://patchwork.kernel.org/project/netdevbpf/patch/a77a584b3ce9761eb5dda5828192e1cab94571f0.1649037151.git.lucien.xin@gmail.com/
>
> On Mon, Apr 4, 2022 at 3:53 AM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > Yi Chen reported an unexpected sctp connection abort, and it occurred when
> > COOKIE_ECHO is bundled with DATA Fragment by SCTP HW GSO. As the IP header
> > is included in chunk->head_skb instead of chunk->skb, it failed to check
> > IP header version in security_sctp_assoc_request().
> >
> > According to Ondrej, SELinux only looks at IP header (address and IPsec
> > options) and XFRM state data, and these are all included in head_skb for
> > SCTP HW GSO packets. So fix it by using head_skb when calling
> > security_sctp_assoc_request() in processing COOKIE_ECHO.
>
> The logic looks good to me, but I still have one unanswered concern.
> The head_skb member of struct sctp_chunk is defined inside a union:
>
> struct sctp_chunk {
>         [...]
>         union {
>                 /* In case of GSO packets, this will store the head one */
>                 struct sk_buff *head_skb;
>                 /* In case of auth enabled, this will point to the shkey */
>                 struct sctp_shared_key *shkey;
>         };
>         [...]
> };
>
> What guarantees that this chunk doesn't have "auth enabled" and the
> head_skb pointer isn't actually a non-NULL shkey pointer? Maybe it's
> obvious to a Linux SCTP expert, but at least for me as an outsider it
> isn't - that's usually a good hint that there should be a code comment
> explaining it.
Hi Ondrej,

shkey is for tx skbs only, while head_skb is for skbs on rx path.

Thanks.

>
> >
> > Fixes: e215dab1c490 ("security: call security_sctp_assoc_request in sctp_sf_do_5_1D_ce")
> > Reported-by: Yi Chen <yiche@redhat.com>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/sctp/sm_statefuns.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
> > index 7f342bc12735..883f9b849ee5 100644
> > --- a/net/sctp/sm_statefuns.c
> > +++ b/net/sctp/sm_statefuns.c
> > @@ -781,7 +781,7 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
> >                 }
> >         }
> >
> > -       if (security_sctp_assoc_request(new_asoc, chunk->skb)) {
> > +       if (security_sctp_assoc_request(new_asoc, chunk->head_skb ?: chunk->skb)) {
> >                 sctp_association_free(new_asoc);
> >                 return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
> >         }
> > @@ -2262,7 +2262,7 @@ enum sctp_disposition sctp_sf_do_5_2_4_dupcook(
> >         }
> >
> >         /* Update socket peer label if first association. */
> > -       if (security_sctp_assoc_request(new_asoc, chunk->skb)) {
> > +       if (security_sctp_assoc_request(new_asoc, chunk->head_skb ?: chunk->skb)) {
> >                 sctp_association_free(new_asoc);
> >                 return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
> >         }
> > --
> > 2.31.1
> >
>
> --
> Ondrej Mosnacek
> Software Engineer, Linux Security - SELinux kernel
> Red Hat, Inc.
>
