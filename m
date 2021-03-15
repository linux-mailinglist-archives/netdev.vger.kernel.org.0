Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5591833BC62
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 15:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbhCOOYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 10:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbhCOOX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 10:23:58 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB8EC06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 07:23:50 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id x9so9179692qto.8
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 07:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kmnR7tHBWz7rPe9gnXoSj9G85HhiSKfVDWHGo2UE52g=;
        b=KxCn0jQtIdd4LTSY/QbdVrv/hPftI3fbaZgoljpYYeTNad0ychtr7nBAoJlo4+VrLF
         0bQF/wpRrbqoKJNbCtiICvh86fLN+2Dr1G8JrhutOd5/IeTvK+qbWvolflRlaZimTtNj
         lbH686OCHN4HVTv2Sr8/ViKKWzP/Hqnsxl38dLvsxy6ywXSDNmcOL1p8LUpg7Lhzdog2
         tU0GtLltO6KyQ2tAJYzxkXgWuFXGHysTYjFDCakBch9cuT+RiXfvHeHxpY3I1ZxqB2S1
         qmTRPooXsFXQVYSy+GDGkx9CxKzXjMEXCb0Tz/62rvs2JHHwYyO9V+dP5XFKrBXOEiU+
         oqug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kmnR7tHBWz7rPe9gnXoSj9G85HhiSKfVDWHGo2UE52g=;
        b=FcOYkWJJWr6w9PdoRnGrrbR8Py5vtmCc85tgzWXKaJZ/Yq/iPFyp51klAlg4Anuayp
         7Jw+Vbc7SNf8fpDg/ZfVmgHE3sR8eUOxXRmRL+l74QaNOvdiw+luZKjfhpEwJd54tOdZ
         YLQFUrjmT30uzMp0iJXVba8EKe0uIA5fYsItyNDOOpc4MMJ9re/GSJU+Ac5i64F86J7j
         2UmY7DOI+A0j+kEJkoXXH0HORdTgPS0Ds8KbbcTyrnu97tZuA4NSfIdrXIz2ReJ6rLFT
         mE5+ccdyQoFcsvloMn20e6NqqblVTcupQh1ksMG7DOlq9ZjtoYkD2QFuWku0ImHLjIsz
         zimg==
X-Gm-Message-State: AOAM531kHqgbYoNqCGUXADEFf884egsLY3HUNG828uvP7CyrXFamPZDi
        3z1Zbuh1xReHATFK0ZdeG/3qTTPQmwRwrBX6LCvQ3FANmq/zyQ==
X-Google-Smtp-Source: ABdhPJyKs/LMAEtL1LJeSB0p/rhYYfCFphJ03zW9C9lrcDiB5nsrAxht6F+FRNHsqtk6/cg854HE8UHsF2GSga4vsK4=
X-Received: by 2002:aed:20a8:: with SMTP id 37mr22335862qtb.170.1615818229685;
 Mon, 15 Mar 2021 07:23:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210313000241.602790-1-bjorn.andersson@linaro.org>
In-Reply-To: <20210313000241.602790-1-bjorn.andersson@linaro.org>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Mon, 15 Mar 2021 15:23:36 +0100
Message-ID: <CAGRyCJHqkBKZDSK+P=UP2B=DFj5n7LTd+ZwBd7a9LDytNeYJWw@mail.gmail.com>
Subject: Re: [PATCH] iplink_rmnet: Allow passing IFLA_RMNET_FLAGS
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        Alex Elder <elder@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bjorn,

Il giorno sab 13 mar 2021 alle ore 01:02 Bjorn Andersson
<bjorn.andersson@linaro.org> ha scritto:
>
> Parse and pass IFLA_RMNET_FLAGS to the kernel, to allow changing the
> flags from the default of ingress-aggregate only.
>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
>  ip/iplink_rmnet.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
>
> diff --git a/ip/iplink_rmnet.c b/ip/iplink_rmnet.c
> index 1d16440c6900..8a488f3d0316 100644
> --- a/ip/iplink_rmnet.c
> +++ b/ip/iplink_rmnet.c
> @@ -16,6 +16,10 @@ static void print_explain(FILE *f)
>  {
>         fprintf(f,
>                 "Usage: ... rmnet mux_id MUXID\n"
> +               "                 [ingress-deaggregation]\n"
> +               "                 [ingress-commands]\n"
> +               "                 [ingress-chksumv4]\n"
> +               "                 [egress-chksumv4]\n"
>                 "\n"
>                 "MUXID := 1-254\n"
>         );
> @@ -29,6 +33,7 @@ static void explain(void)
>  static int rmnet_parse_opt(struct link_util *lu, int argc, char **argv,
>                            struct nlmsghdr *n)
>  {
> +       struct ifla_rmnet_flags flags = { };
>         __u16 mux_id;
>
>         while (argc > 0) {
> @@ -37,6 +42,18 @@ static int rmnet_parse_opt(struct link_util *lu, int argc, char **argv,
>                         if (get_u16(&mux_id, *argv, 0))
>                                 invarg("mux_id is invalid", *argv);
>                         addattr16(n, 1024, IFLA_RMNET_MUX_ID, mux_id);
> +               } else if (matches(*argv, "ingress-deaggregation") == 0) {
> +                       flags.mask = ~0;
> +                       flags.flags |= RMNET_FLAGS_INGRESS_DEAGGREGATION;
> +               } else if (matches(*argv, "ingress-commands") == 0) {
> +                       flags.mask = ~0;
> +                       flags.flags |= RMNET_FLAGS_INGRESS_MAP_COMMANDS;
> +               } else if (matches(*argv, "ingress-chksumv4") == 0) {
> +                       flags.mask = ~0;
> +                       flags.flags |= RMNET_FLAGS_INGRESS_MAP_CKSUMV4;
> +               } else if (matches(*argv, "egress-chksumv4") == 0) {
> +                       flags.mask = ~0;
> +                       flags.flags |= RMNET_FLAGS_EGRESS_MAP_CKSUMV4;
>                 } else if (matches(*argv, "help") == 0) {
>                         explain();
>                         return -1;
> @@ -48,11 +65,28 @@ static int rmnet_parse_opt(struct link_util *lu, int argc, char **argv,
>                 argc--, argv++;
>         }
>
> +       if (flags.mask)
> +               addattr_l(n, 1024, IFLA_RMNET_FLAGS, &flags, sizeof(flags));
> +
>         return 0;
>  }
>
> +static void rmnet_print_flags(FILE *fp, __u32 flags)
> +{
> +       if (flags & RMNET_FLAGS_INGRESS_DEAGGREGATION)
> +               print_string(PRINT_ANY, NULL, "%s ", "ingress-deaggregation");
> +       if (flags & RMNET_FLAGS_INGRESS_MAP_COMMANDS)
> +               print_string(PRINT_ANY, NULL, "%s ", "ingress-commands");
> +       if (flags & RMNET_FLAGS_INGRESS_MAP_CKSUMV4)
> +               print_string(PRINT_ANY, NULL, "%s ", "ingress-chksumv4");
> +       if (flags & RMNET_FLAGS_EGRESS_MAP_CKSUMV4)
> +               print_string(PRINT_ANY, NULL, "%s ", "egress-cksumv4");
> +}
> +
>  static void rmnet_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
>  {
> +       struct ifla_vlan_flags *flags;

just for my understanding, why not struct ifla_rmnet_flags (though
they are exactly the same)?

Thanks,
Daniele

> +
>         if (!tb)
>                 return;
>
> @@ -64,6 +98,14 @@ static void rmnet_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
>                    "mux_id",
>                    "mux_id %u ",
>                    rta_getattr_u16(tb[IFLA_RMNET_MUX_ID]));
> +
> +       if (tb[IFLA_RMNET_FLAGS]) {
> +               if (RTA_PAYLOAD(tb[IFLA_RMNET_FLAGS]) < sizeof(*flags))
> +                       return;
> +               flags = RTA_DATA(tb[IFLA_RMNET_FLAGS]);
> +
> +               rmnet_print_flags(f, flags->flags);
> +       }
>  }
>
>  static void rmnet_print_help(struct link_util *lu, int argc, char **argv,
> --
> 2.28.0
>
