Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1B376B006D
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 09:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbjCHIBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 03:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbjCHIBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 03:01:08 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E82A9CFDA
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 00:01:00 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id f14so6482524iow.5
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 00:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678262459;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C0+AS3gtrUxH0AAKG/6TszL/DWdRZE8OAHj8il1hKwQ=;
        b=QmrPHuYEKG0G19EFphK73Gi+xR/MkTBgE7KSJ7DthT2etNnXCStl7e5VFSSWfrar81
         N+Ny3XYJl/Jhrlmur0I9gHpP9Mj4mgsw5eDh6BBSiBn8fKLkJnEIforgbzpYTPY/aZ0Z
         s79pkb8LoAPBx9UjZZoDzP0T0ajYvPmWal/naNbIXrbxHTGpXxWysYldSrpGYtJfBf+m
         LGr/wSVYO0aC1vFovD3ELPYbUeXL9csxOfOHBLeu++aDUr8SvjtgtxIeeoI2kIkstxi8
         nKI5X208oWYyCAiJz4M8Ro0JOF3/eW7WJphCuvzAAjDDrfGSIjcxXSy0aqNQm6hxsHeI
         mjMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678262459;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C0+AS3gtrUxH0AAKG/6TszL/DWdRZE8OAHj8il1hKwQ=;
        b=i6zz/po86zZpkd2imrvNuHqdxvbajb3TwBjysJGCh54Bj1Ek6+EfBiCXxiBRKkJ58V
         ZUM6HygaNC9+V+9YglbQPRn+35MWTlwl7m5Jb+AFZKlq41wE3UnTproK+qVT7J3B2ylu
         LswRwUP0m+ff43vNK3b85OSsNonjs6PhHdFcCPjS2wRvS/n39qQh+bB5wwC+XP6oVkR4
         2iGDFLqd0er0jtESOVA6rDKKotq2wTmQILA0MTmLT8joSRhkpxpzuLtoULfgF72Dp45H
         KN8qG/pBaD+gD9mICd2S4FWwDoN7O22ZL+zkGysfMWlk296LjQKocvwIcmS/gWMAwCiI
         yYsQ==
X-Gm-Message-State: AO0yUKX4fGk5KaZUBHB4RqmYK1AQuU3mF40kfnnTT6qNSFsmfGyYX+7A
        S4ub0gkZOritCNZ0z3Zo5QXqN2i5id9wgket9jloYw==
X-Google-Smtp-Source: AK7set+DYJT3w/6Pe8aHcLLryHHPTCgfpg/e4dy2tN2xppYMj0CaA96hJGC/4xcGw+VyilaG2u20BCMeV6vLKWlB2bs=
X-Received: by 2002:a6b:6a11:0:b0:745:68ef:e410 with SMTP id
 x17-20020a6b6a11000000b0074568efe410mr8091493iog.0.1678262459288; Wed, 08 Mar
 2023 00:00:59 -0800 (PST)
MIME-Version: 1.0
References: <20230302160310.923349-1-jaewan@google.com> <20230302160310.923349-2-jaewan@google.com>
 <ZAYa4oteaDVPGOLp@corigine.com>
In-Reply-To: <ZAYa4oteaDVPGOLp@corigine.com>
From:   Jaewan Kim <jaewan@google.com>
Date:   Wed, 8 Mar 2023 08:00:47 +0000
Message-ID: <CABZjns6=CM7qYPEDnhP=ZpJqMaA=yWw6vSMPOTRnk87PsYY4yg@mail.gmail.com>
Subject: Re: [PATCH v8 1/5] mac80211_hwsim: add PMSR capability support
To:     Simon Horman <simon.horman@corigine.com>
Cc:     gregkh@linuxfoundation.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@android.com, adelva@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 6, 2023 at 4:55=E2=80=AFPM Simon Horman <simon.horman@corigine.=
com> wrote:
>
> On Thu, Mar 02, 2023 at 04:03:06PM +0000, Jaewan Kim wrote:
> > PMSR (a.k.a. peer measurement) is generalized measurement between two
> > Wi-Fi devices. And currently FTM (a.k.a. fine time measurement or fligh=
t
> > time measurement) is the one and only measurement. FTM is measured by
> > RTT (a.k.a. round trip time) of packets between two Wi-Fi devices.
> >
> > Add necessary functionality to allow mac80211_hwsim to be configured wi=
th
> > PMSR capability. The capability is mandatory to accept incoming PMSR
> > request because nl80211_pmsr_start() ignores incoming the request witho=
ut
> > the PMSR capability.
> >
> > In detail, add new mac80211_hwsim attribute HWSIM_ATTR_PMSR_SUPPORT.
> > HWSIM_ATTR_PMSR_SUPPORT is used to set PMSR capability when creating a =
new
> > radio. To send extra capability details, HWSIM_ATTR_PMSR_SUPPORT can ha=
ve
> > nested PMSR capability attributes defined in the nl80211.h. Data format=
 is
> > the same as cfg80211_pmsr_capabilities.
> >
> > If HWSIM_ATTR_PMSR_SUPPORT is specified, mac80211_hwsim builds
> > cfg80211_pmsr_capabilities and sets wiphy.pmsr_capa.
> >
> > Signed-off-by: Jaewan Kim <jaewan@google.com>
>
> Thanks for your patch, a few comments below.
>
> > diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wirele=
ss/mac80211_hwsim.c
> > index 4cc4eaf80b14..79476d55c1ca 100644
> > --- a/drivers/net/wireless/mac80211_hwsim.c
> > +++ b/drivers/net/wireless/mac80211_hwsim.c
>
> ...
>
> > @@ -3186,6 +3218,7 @@ struct hwsim_new_radio_params {
> >       u32 *ciphers;
> >       u8 n_ciphers;
> >       bool mlo;
> > +     const struct cfg80211_pmsr_capabilities *pmsr_capa;
>
> nit: not related to this patch,
>      but there are lots of holes in hwsim_new_radio_params.
>      And, I think that all fields, other than the new pmsr_capa field,
>      could fit into one cacheline on x86_64.
>
>      I'm unsure if it is worth cleaning up or not.
>
> >  };
> >
> >  static void hwsim_mcast_config_msg(struct sk_buff *mcast_skb,
> > @@ -3260,7 +3293,7 @@ static int append_radio_msg(struct sk_buff *skb, =
int id,
> >                       return ret;
> >       }
> >
> > -     return 0;
> > +     return ret;
>
> This change seems unrelated to the rest of the patch.

I asked to change this in the prior patch v3.

>
> >  }
> >
> >  static void hwsim_mcast_new_radio(int id, struct genl_info *info,
>
> ...
>
> > +static int parse_pmsr_capa(const struct nlattr *pmsr_capa, struct cfg8=
0211_pmsr_capabilities *out,
> > +                        struct genl_info *info)
> > +{
> > +     struct nlattr *tb[NL80211_PMSR_ATTR_MAX + 1];
> > +     struct nlattr *nla;
> > +     int size;
>  +      int ret =3D nla_parse_nested(tb, NL80211_PMSR_ATTR_MAX, pmsr_capa=
,
> > +                                hwsim_pmsr_capa_policy, NULL);
> > +
> > +     if (ret) {
> > +             NL_SET_ERR_MSG_ATTR(info->extack, pmsr_capa, "malformed P=
MSR capability");
> > +             return -EINVAL;
> > +     }
> > +
> > +     if (tb[NL80211_PMSR_ATTR_MAX_PEERS])
> > +             out->max_peers =3D nla_get_u32(tb[NL80211_PMSR_ATTR_MAX_P=
EERS]);
> > +     out->report_ap_tsf =3D !!tb[NL80211_PMSR_ATTR_REPORT_AP_TSF];
> > +     out->randomize_mac_addr =3D !!tb[NL80211_PMSR_ATTR_RANDOMIZE_MAC_=
ADDR];
> > +
> > +     if (!tb[NL80211_PMSR_ATTR_TYPE_CAPA]) {
> > +             NL_SET_ERR_MSG_ATTR(info->extack, tb[NL80211_PMSR_ATTR_TY=
PE_CAPA],
> > +                                 "malformed PMSR type");
> > +             return -EINVAL;
> > +     }
> > +
> > +     nla_for_each_nested(nla, tb[NL80211_PMSR_ATTR_TYPE_CAPA], size) {
> > +             switch (nla_type(nla)) {
> > +             case NL80211_PMSR_TYPE_FTM:
> > +                     parse_ftm_capa(nla, out, info);
> > +                     break;
> > +             default:
> > +                     WARN_ON(1);
>
> WARN_ON doesn't seem right here. I suspect that the following is more fit=
ting.
>
>                 NL_SET_ERR_MSG_ATTR(...);
>                 return -EINVAL;
>

Not using NL_SET_ERR_MSG_ATTR(...) is intended to follow the pattern
of net/wireless/pmsr.c,
where unknown type isn't considered as an error.

--=20
Jaewan Kim (=EA=B9=80=EC=9E=AC=EC=99=84) | Software Engineer in Google Kore=
a |
jaewan@google.com | +82-10-2781-5078
