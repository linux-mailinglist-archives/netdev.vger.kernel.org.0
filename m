Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78AC5E5620
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 00:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbiIUWMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 18:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiIUWMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 18:12:51 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27826A5705
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 15:12:50 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id z97so10823908ede.8
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 15:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=8GbQ3Mfinwd6r1sMG2YjNleTdihes+CqHWAOwQ6w4uY=;
        b=gYt8sIzFZZFusyT9qRFM2LvMtGyfnwzNNKkllsCCMYrtfudUDRMdUY4ltJNJ31gGkU
         Ipd3+LJuHW75XbJ4CdV0uWAxT3TFblldGsub6PtqSXBPCNgAP+lmGcq35AWQVFlt55fF
         Ogldh0CunuH719E4RC2J1ToST6eoBsGPbKipkDoyI2/5M62XWVK1XCg97KOD6Cc/bQwc
         Xbm5UrUk/Jrg+TkfqY1d7r5SjgjDIabKqWsVxA9kzeYi+rIRRW1/rpOPd/4Q1QJeM1p7
         +X+K0wUy4DrV0CWP3rACWEWsm4oz2VPTlF2V7T7Ns7ggScF8OdZXXe1frUO7fXxGtZZA
         g6lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=8GbQ3Mfinwd6r1sMG2YjNleTdihes+CqHWAOwQ6w4uY=;
        b=RNJ82sYf2n3UA2tzB7sNEcynLJ1CN4YyZJkr5c7770FxzeSc16b9WloPSKtpF/wSqP
         srgK7rc6tTW0UqRzlS+TBkPXfpenkTxSn4UraNMqMG4lY7B4Nx202tTKoP95w2o3CxeZ
         XoHMLX5SOf/E4/lHx+/ww+T7qFy96w5eGkvW9BZUQsXhctGPTbc7c9ojaqYBK0S1xCDi
         BrPW754dSIiBHdscS5QmjkvUoGqekXyZSTh88TF9eSDQuGxwTAESZgXwH6/SpovlXE5h
         NlSPxyasZDPpLTReRqLFTEQH/6WOGV3fCR4h/2XEr5E5k+qWRPmaAbIBKZmmgamWwPtO
         3oCw==
X-Gm-Message-State: ACrzQf3tGRATXaVRwCeUUrpRy8nKVWhh0YBAD/wxZK/PXwbvxtbN5441
        kM+Vvi/c5FV5dsvgTmvzs9wuetoaklOJtocLxvU=
X-Google-Smtp-Source: AMsMyM4RaHEYKNX3KYzs5qdoetS5YlKpGEPhxnRsMP52Hp/d2w6qvJLgPNjQWMMFEvGt1HZZavat/clo6LoQPdUUV70=
X-Received: by 2002:a05:6402:26cf:b0:451:70af:ecc5 with SMTP id
 x15-20020a05640226cf00b0045170afecc5mr232244edd.287.1663798368487; Wed, 21
 Sep 2022 15:12:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220921210921.1654735-1-floridsleeves@gmail.com> <YyuA13q/B236lZ6U@codewreck.org>
In-Reply-To: <YyuA13q/B236lZ6U@codewreck.org>
From:   Li Zhong <floridsleeves@gmail.com>
Date:   Wed, 21 Sep 2022 15:12:38 -0700
Message-ID: <CAMEuxRo-QctyufOmAxZdoNrPE57KFd0MLa-kQftmhpHQfkWkJQ@mail.gmail.com>
Subject: Re: [PATCH net-next v1] net/9p/trans_fd: check the return value of parse_opts
To:     asmadeus@codewreck.org
Cc:     netdev@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, linux_oss@crudebyte.com, lucho@ionkov.net,
        ericvh@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 21, 2022 at 2:23 PM <asmadeus@codewreck.org> wrote:
>
> Li Zhong wrote on Wed, Sep 21, 2022 at 02:09:21PM -0700:
> > parse_opts() could fail when there is error parsing mount options into
> > p9_fd_opts structure due to allocation failure. In that case opts will
> > contain invalid data.
>
> In practice opts->rfd/wfd is set to ~0 before the failure modes so they
> will contain exactly what we want them to contain: something that'll
> fail the check below.
>
> It is however cleared like this so I'll queue this patch in 9p tree when
> I have a moment, but I'll clarify the commit message to say this is
> NO-OP : please feel free to send a v2 if you want to put your own words
> in there; otherwise it'll be something like below:
> ----
> net/9p: clarify trans_fd parse_opt failure handling
>
> This parse_opts will set invalid opts.rfd/wfd in case of failure which
> we already check, but it is not clear for readers that parse_opts error
> are handled in p9_fd_create: clarify this by explicitly checking the
> return value.
> ----
>

Thanks for the patient reply! I agree that the check on
opts.rfd/wft against ~0 will prevent error even if it fails
memory allocation. But currently the error log is
'insufficient options', which is kind of misleading and the
error code returned is -ENOPROTOOPT instead of -ENOMEM, which
I guess would be better if we distinguish between them.

>
> Also, in practice args != null doesn't seem to be checked before (the
> parse_opt() in client.c allows it) so keeping the error message common
> might be better?
> (allocation failure will print its own messages anyway and doesn't need
> checking)
>
> >
> > Signed-off-by: Li Zhong <floridsleeves@gmail.com>
> > ---
> >  net/9p/trans_fd.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
> > index e758978b44be..11ae64c1a24b 100644
> > --- a/net/9p/trans_fd.c
> > +++ b/net/9p/trans_fd.c
> > @@ -1061,7 +1061,9 @@ p9_fd_create(struct p9_client *client, const char *addr, char *args)
> >       int err;
> >       struct p9_fd_opts opts;
> >
> > -     parse_opts(args, &opts);
> > +     err = parse_opts(args, &opts);
> > +     if (err < 0)
> > +             return err;
> >       client->trans_opts.fd.rfd = opts.rfd;
> >       client->trans_opts.fd.wfd = opts.wfd;
> >
