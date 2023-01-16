Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D97C66D048
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 21:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbjAPUhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 15:37:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbjAPUhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 15:37:21 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D84823321
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 12:37:20 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-4b6255ce5baso394922817b3.11
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 12:37:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9RoM0mB0MVM+QY5p+sezg308iT7lODqTjqQyXjZcZSo=;
        b=VtpJkIKYCshPtcW4g0pUlC33Bv/2YJuJSGLsEro9AA+Dc5E+8yVxEdpG6JPIIJ157D
         gXAaAqw0CEZZd2WdsM2KejYrT5r5/pSzhNaCiWGvTNZlko128yAeJXnOQiYIKS0dlto7
         l1gyr/zNa+Y8/LLdCWSOnj4TQL/UyzWXcC/pvuwGZVlSUz0V5V1yGFaD9N0N5gUR2SU5
         FFtkeSAizYsdce67TMg77qsvrHbPZSVsUk0vhqc+GuRpOHlzQIWsCGb5RkIlWRdvV4Y0
         KYJwg92c9GVVuVzlq9GJiGtF5WKHGAKtuj3BKzikK1nfmdJ9ynZHIq8EalZANNlHHR5+
         ToMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9RoM0mB0MVM+QY5p+sezg308iT7lODqTjqQyXjZcZSo=;
        b=6E8QJgHHfzpmFXZ35fkyUF/H0w3neLuTSuoAuc+bOz/7RGb9nnXES2oDjct3bYPhwd
         iAUV9sQZy/+7f0BbbC4Wm5DlzAAKm8fBpMvlp0RvK9/jklq3LcQwq9NbPLJz5XADVt8t
         9EeL5AsPgifekjf29Z0aaj9JrQ/yniD5EDWmg+14Mhrx4oJl+pq9i4HeWl0AvGrvZcES
         xb2iTsszS2so3wDaujwNfFflyx5KlOl9noZLl16DtPYLdYpu3zY2fQzOY87IQLvPLpWa
         bAvHn0KyBdDGkPX5xHVBoNuwLcTck0+secQOQr7mc6QTAdPXGQI3DFB09YU3yWCizCR/
         KfEg==
X-Gm-Message-State: AFqh2ko5S3+8tJmjIwsjvslPtm9pZAPHMx2mTpPQFdI+ik1NsEjzJsSN
        vGkzRPeMPO7T0lHnXKppm6RnZ4FUZhHXik4/5cFpWA==
X-Google-Smtp-Source: AMrXdXuYggmK9kB/4TQ9+JB5/IkVCykWoOEB3Fqc9B4qTedUIdcIKLtJE0gasV3IdhnVDYif9tZsGi1AhVUAsWQTn/M=
X-Received: by 2002:a05:690c:954:b0:4ef:2ac3:7ce0 with SMTP id
 cc20-20020a05690c095400b004ef2ac37ce0mr74792ywb.489.1673901439563; Mon, 16
 Jan 2023 12:37:19 -0800 (PST)
MIME-Version: 1.0
References: <cover.1673666803.git.lucien.xin@gmail.com> <de91843a7f59feb065475ca82be22c275bede3df.1673666803.git.lucien.xin@gmail.com>
 <b0a1bebc-7d44-05bc-347c-94da4cf2ef27@gmail.com> <CADvbK_cxQa0=ximH1F2bA-r0Q2+nMGAsSKhbaKzFTHOrcCF11A@mail.gmail.com>
 <CANn89iK4oSgoxJVkXO5rZXLzG1xw-xP31QbGHGvjhXqR2SSsRQ@mail.gmail.com>
 <CADvbK_c+RAFyrwuL+dfU3hc5U+ytOHC=TQ_xrkvXb4bB7XKjEA@mail.gmail.com>
 <CANn89iLtF3dNcMkMGagCSfb+p5zA3Fa-DV9f9xMHHU_TX2CvSw@mail.gmail.com>
 <b73e2dd1-d7bc-e96b-8553-1536a1146f3c@gmail.com> <CANn89iKc9HiswDGVVUBGDUef3V74Cq0pWdAG-zMK79pC6oDyEA@mail.gmail.com>
 <CADvbK_coggEMCELtAejSFzHnqBQp=BERvMJ1uqkF-iy8-kdo7w@mail.gmail.com>
In-Reply-To: <CADvbK_coggEMCELtAejSFzHnqBQp=BERvMJ1uqkF-iy8-kdo7w@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 16 Jan 2023 21:37:08 +0100
Message-ID: <CANn89i+OeD6Tmj0eyn=NK8M6syxKEQYLQfv4KUMmMGBh98YKyw@mail.gmail.com>
Subject: Re: [PATCH net-next 09/10] netfilter: get ipv6 pktlen properly in length_mt6
To:     Xin Long <lucien.xin@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>,
        network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
Content-Type: text/plain; charset="UTF-8"
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

On Mon, Jan 16, 2023 at 8:10 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Mon, Jan 16, 2023 at 11:02 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Mon, Jan 16, 2023 at 4:08 PM David Ahern <dsahern@gmail.com> wrote:
> > >
> >
> > > not sure why you think it would not be detected. Today's model for gro
> > > sets tot_len based on skb->len. There is an inherent trust that the
> > > user's of the gro API set the length correctly. If it is not, the
> > > payload to userspace would ultimately be non-sense and hence detectable.
> >
> > Only if you use some kind of upper protocol adding message integrity
> > verification.
> >
> > > >
> > > > As you said, user space sniffing packets now have to guess what is the
> > > > intent, instead of headers carrying all the needed information
> > > > that can be fully validated by parsers.
> > >
> > > This is a solveable problem within the packet socket API, and the entire
> > > thing is opt-in. If a user's tcpdump / packet capture program is out of
> > > date and does not support the new API for large packets, then that user
> > > does not have to enable large GRO/TSO.
> >
> > I do not see this being solved yet.
> I think it's common that we add a feature that is disabled by
> default in the kernel if the userspace might not support it.

One critical feature for us is the ability to restrict packet capture
to the headers only.

Privacy is a key requirement.

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=3e5289d5e3f98b7b5b8cac32e9e5a7004c067436

So please make sure that packet captures truncated to headers will
still be understood by tcpdump


>
> >
> > We have enabled BIG TCP only for IPv6, we do not want the same to
> > magically be enabled for ipv4
> > when a new kernel is deployed.
> >
> > Make sure that IPV4 BIG TCP is guarded by a separate tunable.
> I can understand this.
>
> Thanks.
