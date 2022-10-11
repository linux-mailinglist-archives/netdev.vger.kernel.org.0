Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 008A95FADF6
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 10:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiJKIDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 04:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiJKIDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 04:03:24 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BBA7C1F6;
        Tue, 11 Oct 2022 01:03:23 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id g9so8478361qvo.12;
        Tue, 11 Oct 2022 01:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Har4yFeCgOSIR75xmzHnKi7+0/DdgcGnqVSyzGu67iQ=;
        b=hFWvHe2rL9DfymigRuvA6mSzLM5EJsqf/AmSbJ3BlPX01OzM7F00Tdx3rX2cJ0I1Zc
         EP1i1JRBGeTSscfXsfHMQY4Cl8eni5mGjr+86QjD4+RedSJx1u9ZISolpI3VWQ12aAGj
         LEjeeZolJQe/JFQHqUMd37yHkOxczAUHY0tdYV9NQZ9DnYB+oRcfREzC8OlI6PXSu/7k
         HJWVaSC/tLoCW4Er/KhnPU3M5AO6oCsfmEkQIxg+SoIJ9shBgwmH8vDz4bpWw88MkHg+
         ffeZf5h3DJCvl+YSdO4UNZZHrvkMCZT7iZVL8hXAdPjBWiYDURKTrePz8VRXjBlWfv1M
         EVTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Har4yFeCgOSIR75xmzHnKi7+0/DdgcGnqVSyzGu67iQ=;
        b=2z1fV/cjYX8SMWgtk6oxucnwOeBePPsAJtJKMFfuoYkFSzILwneR84jwsUKvzNhC9t
         hsoRJT7oDNHe6w5sG0CxlFCBP7lpywRC9zGZr1SrM5KBPiYrdyTLlz1nK/z9mYu44CYz
         tYhyTpIDNwN6qXrLj2U2WkCtWwGx/0HZRVIWhPCWuzE8jgal8oufEd4p5fK7WQB5m/Hk
         F8grNQc289vVvRGGrtNA++hkaPY+FrYh8eWBZG5Wxbi9l26LkWxKS3w8EY/znrhkMnmV
         Fe0/xiifXZu+dzaoLGiJug5hFnRz1pdZca4u9CobC5NSKUJs5iO++DJkcu5Ft06bYjbe
         QgMA==
X-Gm-Message-State: ACrzQf1y3ZH4emxzgGv94ldcLIDPYfjwvM0/B+hOuVrmloIIeKqAqIqN
        +G2G7BJqChJXgaOHflVDoOIFaJP8qwTOU0FQyWI=
X-Google-Smtp-Source: AMsMyM6xuX36W2rDkfJiTmjD1m6OTf85cPSViXo9CUCEFAaBcpegkti3X9ZLI/wHgQL6hRbRsTg3mHMuupU8+4qOYyo=
X-Received: by 2002:a05:6214:f65:b0:4b3:f4f2:fcaa with SMTP id
 iy5-20020a0562140f6500b004b3f4f2fcaamr8320798qvb.48.1665475401976; Tue, 11
 Oct 2022 01:03:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220826114700.2272645-1-eyal.birger@gmail.com>
 <20220826114700.2272645-4-eyal.birger@gmail.com> <Y0UQC0oycrGs4Zad@shredder>
In-Reply-To: <Y0UQC0oycrGs4Zad@shredder>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Tue, 11 Oct 2022 11:03:10 +0300
Message-ID: <CAHsH6GthqZe6-Q0GQpLVRUwy=7XmqdZFoxUSe+o_PWS+wHNZoQ@mail.gmail.com>
Subject: Re: [PATCH ipsec-next,v4 3/3] xfrm: lwtunnel: add lwtunnel support
 for xfrm interfaces in collect_md mode
To:     Ido Schimmel <idosch@idosch.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, dsahern@kernel.org,
        contact@proelbtn.com, pablo@netfilter.org,
        nicolas.dichtel@6wind.com, razor@blackwall.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org
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

Hi Ido,

On Tue, Oct 11, 2022 at 9:41 AM Ido Schimmel <idosch@idosch.org> wrote:
>
> On Fri, Aug 26, 2022 at 02:47:00PM +0300, Eyal Birger wrote:
> > diff --git a/net/core/lwtunnel.c b/net/core/lwtunnel.c
> > index 9ccd64e8a666..6fac2f0ef074 100644
> > --- a/net/core/lwtunnel.c
> > +++ b/net/core/lwtunnel.c
> > @@ -50,6 +50,7 @@ static const char *lwtunnel_encap_str(enum lwtunnel_encap_types encap_type)
> >               return "IOAM6";
> >       case LWTUNNEL_ENCAP_IP6:
> >       case LWTUNNEL_ENCAP_IP:
> > +     case LWTUNNEL_ENCAP_XFRM:
> >       case LWTUNNEL_ENCAP_NONE:
> >       case __LWTUNNEL_ENCAP_MAX:
> >               /* should not have got here */
>
> Eyal,
>
> The warning at the bottom can be triggered [1] from user space when the
> kernel is compiled with CONFIG_MODULES=y and CONFIG_XFRM=n:
>
>  # ip route add 198.51.100.0/24 dev dummy1 encap xfrm if_id 1
>  Error: lwt encapsulation type not supported.
>
> Original report is from a private syzkaller instance which I have
> reduced to the command above.
>
> Thanks

Thanks for the report!

Submitted a fix muting the warning for this case.

Eyal.
