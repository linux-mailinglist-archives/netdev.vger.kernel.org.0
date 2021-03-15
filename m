Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5305933C036
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 16:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbhCOPoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 11:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhCOPnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 11:43:37 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C085C06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 08:43:37 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id f73-20020a9d03cf0000b02901b4d889bce0so5348655otf.12
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 08:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fFrwu3LW8iT5IHYlwZ+5clLvwz97tGPL4BoaYeBPlH8=;
        b=BHpTNvjgs+cB10lTaSp7UQMIQW3cMdQsKp0ZW83SfWaS13PSpLlOIsWy/mokQ8rX7S
         ahlgRTpRLsiNQ4p6Pdv48vNmJSJojt1X/PuPtEJuK7zeYExlE0ppCBAz2//oFSn+vU1e
         PYif0MAY7pJKM3YdRSbbZOSsXxlZJ1EbWagRuRt7cUAVYRrlhTJzd4T39a7mnBks5YZT
         qd6v2/ODtPmV0j5LnvbW1CcCu4plyqa4/jst0My/eXsoGmuk7AhFK8nui+fzdXHb2uzA
         wuexRSp6x5j27S0oaYvwXiMongxAuyBn1Ic90tRvmqLlwqNc6N5IuIDgW1myZhtclymt
         RISA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fFrwu3LW8iT5IHYlwZ+5clLvwz97tGPL4BoaYeBPlH8=;
        b=If/Idt4kX5neA3e7wZNS0Jt7y9O/9FmG1YliSEwIi+g4tUAE3Myf4eKNiRxcShQ1i1
         fwsfP9hUwTkaL2Sj67SDHD1yDEP4XMYURytjuowd7NNOO7IzZfAnuwlIUjDFc1E8bVky
         +aEtJQJhaHeYnlmVcXJkhC6FnebhGd5ZhpyrL/Fi21w4qvu7zNCduj8VGcJOmM14pSMf
         mSzn/ywJrZou0DT89kV+VC67S4bdS5cL+JYk9AOWE5t0FDv5TY2N9h8H1dEuDZG8ELeC
         jMnxNSgZWU64OZNaHXmnPfRstQVSu0d62bWgKuYBOgH7f9EBhnTyWoQDZB4HnKEDkPH6
         lTYA==
X-Gm-Message-State: AOAM530g696UZ66uGyZ/XxYq5+8dn7qDRxuyuVberfxsvvdEGu6dadqe
        da1etDFsp7ssndeHskDZmaFWJw==
X-Google-Smtp-Source: ABdhPJxBfNB8sW552D7m+pM0SNiwUxOnXIFkKQLLHfizvxSU0bVI/j7hkprOySfduANdWGfb7VS0vA==
X-Received: by 2002:a9d:65cf:: with SMTP id z15mr14079676oth.310.1615823016476;
        Mon, 15 Mar 2021 08:43:36 -0700 (PDT)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id t19sm7357964otm.40.2021.03.15.08.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 08:43:36 -0700 (PDT)
Date:   Mon, 15 Mar 2021 10:43:34 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Alex Elder <elder@linaro.org>
Subject: Re: [PATCH] iplink_rmnet: Allow passing IFLA_RMNET_FLAGS
Message-ID: <YE+ApoVXRdIYQEdE@builder.lan>
References: <20210313000241.602790-1-bjorn.andersson@linaro.org>
 <CAGRyCJHqkBKZDSK+P=UP2B=DFj5n7LTd+ZwBd7a9LDytNeYJWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGRyCJHqkBKZDSK+P=UP2B=DFj5n7LTd+ZwBd7a9LDytNeYJWw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon 15 Mar 09:23 CDT 2021, Daniele Palmas wrote:

> Hi Bjorn,
> 
> Il giorno sab 13 mar 2021 alle ore 01:02 Bjorn Andersson
> <bjorn.andersson@linaro.org> ha scritto:
> >
> > Parse and pass IFLA_RMNET_FLAGS to the kernel, to allow changing the
> > flags from the default of ingress-aggregate only.
> >
> > Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> > ---
> >  ip/iplink_rmnet.c | 42 ++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 42 insertions(+)
> >
> > diff --git a/ip/iplink_rmnet.c b/ip/iplink_rmnet.c
> > index 1d16440c6900..8a488f3d0316 100644
> > --- a/ip/iplink_rmnet.c
> > +++ b/ip/iplink_rmnet.c
> > @@ -16,6 +16,10 @@ static void print_explain(FILE *f)
> >  {
> >         fprintf(f,
> >                 "Usage: ... rmnet mux_id MUXID\n"
> > +               "                 [ingress-deaggregation]\n"
> > +               "                 [ingress-commands]\n"
> > +               "                 [ingress-chksumv4]\n"
> > +               "                 [egress-chksumv4]\n"
> >                 "\n"
> >                 "MUXID := 1-254\n"
> >         );
> > @@ -29,6 +33,7 @@ static void explain(void)
> >  static int rmnet_parse_opt(struct link_util *lu, int argc, char **argv,
> >                            struct nlmsghdr *n)
> >  {
> > +       struct ifla_rmnet_flags flags = { };
> >         __u16 mux_id;
> >
> >         while (argc > 0) {
> > @@ -37,6 +42,18 @@ static int rmnet_parse_opt(struct link_util *lu, int argc, char **argv,
> >                         if (get_u16(&mux_id, *argv, 0))
> >                                 invarg("mux_id is invalid", *argv);
> >                         addattr16(n, 1024, IFLA_RMNET_MUX_ID, mux_id);
> > +               } else if (matches(*argv, "ingress-deaggregation") == 0) {
> > +                       flags.mask = ~0;
> > +                       flags.flags |= RMNET_FLAGS_INGRESS_DEAGGREGATION;
> > +               } else if (matches(*argv, "ingress-commands") == 0) {
> > +                       flags.mask = ~0;
> > +                       flags.flags |= RMNET_FLAGS_INGRESS_MAP_COMMANDS;
> > +               } else if (matches(*argv, "ingress-chksumv4") == 0) {
> > +                       flags.mask = ~0;
> > +                       flags.flags |= RMNET_FLAGS_INGRESS_MAP_CKSUMV4;
> > +               } else if (matches(*argv, "egress-chksumv4") == 0) {
> > +                       flags.mask = ~0;
> > +                       flags.flags |= RMNET_FLAGS_EGRESS_MAP_CKSUMV4;
> >                 } else if (matches(*argv, "help") == 0) {
> >                         explain();
> >                         return -1;
> > @@ -48,11 +65,28 @@ static int rmnet_parse_opt(struct link_util *lu, int argc, char **argv,
> >                 argc--, argv++;
> >         }
> >
> > +       if (flags.mask)
> > +               addattr_l(n, 1024, IFLA_RMNET_FLAGS, &flags, sizeof(flags));
> > +
> >         return 0;
> >  }
> >
> > +static void rmnet_print_flags(FILE *fp, __u32 flags)
> > +{
> > +       if (flags & RMNET_FLAGS_INGRESS_DEAGGREGATION)
> > +               print_string(PRINT_ANY, NULL, "%s ", "ingress-deaggregation");
> > +       if (flags & RMNET_FLAGS_INGRESS_MAP_COMMANDS)
> > +               print_string(PRINT_ANY, NULL, "%s ", "ingress-commands");
> > +       if (flags & RMNET_FLAGS_INGRESS_MAP_CKSUMV4)
> > +               print_string(PRINT_ANY, NULL, "%s ", "ingress-chksumv4");
> > +       if (flags & RMNET_FLAGS_EGRESS_MAP_CKSUMV4)
> > +               print_string(PRINT_ANY, NULL, "%s ", "egress-cksumv4");
> > +}
> > +
> >  static void rmnet_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
> >  {
> > +       struct ifla_vlan_flags *flags;
> 
> just for my understanding, why not struct ifla_rmnet_flags (though
> they are exactly the same)?
> 

That's a copy-paste or code complete mistake, thanks for spotting it.

Regards,
Bjorn

> Thanks,
> Daniele
> 
> > +
> >         if (!tb)
> >                 return;
> >
> > @@ -64,6 +98,14 @@ static void rmnet_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
> >                    "mux_id",
> >                    "mux_id %u ",
> >                    rta_getattr_u16(tb[IFLA_RMNET_MUX_ID]));
> > +
> > +       if (tb[IFLA_RMNET_FLAGS]) {
> > +               if (RTA_PAYLOAD(tb[IFLA_RMNET_FLAGS]) < sizeof(*flags))
> > +                       return;
> > +               flags = RTA_DATA(tb[IFLA_RMNET_FLAGS]);
> > +
> > +               rmnet_print_flags(f, flags->flags);
> > +       }
> >  }
> >
> >  static void rmnet_print_help(struct link_util *lu, int argc, char **argv,
> > --
> > 2.28.0
> >
