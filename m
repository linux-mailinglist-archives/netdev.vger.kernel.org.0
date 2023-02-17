Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0234569A4FD
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 06:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjBQFLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 00:11:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjBQFLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 00:11:53 -0500
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0669436FD8
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 21:11:52 -0800 (PST)
Received: by mail-vs1-xe30.google.com with SMTP id m1so4409903vst.7
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 21:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1676610711;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X/Dj+ehLi2Fo8i5Aht/l7woa+ksy5T0F7TwKPSzLatE=;
        b=g84QV7DbPNI6gq0tNEEDF2kRlpftcNef+HvitGEX+nMySR1DDvIvWTvfwfd9phLVjU
         poH+oOUBqZiiWBUbHHfVAI3SdF0FwNitXJdZ/veoEnoxGadus9XI99N6rS16xAlUwWs6
         fUtutlPnWPe0HoLbOYwt+lDWMi1WI4uhNIcIJ+zu+jdtMn+tP/CZoF76obFoypJ8Fus2
         baEmtbK810csDrV9KqTVA2PRyCAgKdIN7Zv2Tl3gwPir6/m6lWKF/GDzimeUMEuMQLbc
         H1S5i6aKEodPmD72fhzjoz0k8GzRiAhRCjOe7Qx1hMZsgmtbovgOrT5/XN8hCs9AzcIT
         GeiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676610711;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X/Dj+ehLi2Fo8i5Aht/l7woa+ksy5T0F7TwKPSzLatE=;
        b=EeyTL0mHqzGfGemf0MdNWt9IDM3U0ueLuqa6I1whx2kvMYfQUrZNKhTMjwPTJakFMf
         Bir03B2V0XdX9AH3Xd3lMZZFIgSatjColLM0ENyl/zloukM7P2NErQs98uAanl9zunD4
         P9U8roi/c5lREVia7YBip91iTUP2hr28CZQQxPyAqHncMYo5urlU/ugpD+7f4c3ld7rO
         YIy8zt7pWleCotg/ueVCY8rJPY69+KTIZijCJUdUMhf3LCP4Hg/OjieGkNUJXMkK1gkn
         I5ER4Z7xjjJ26WjuIUybD2cx6uO9hrKYBBxpr1ZQ0K77NSQyD++h2GHrpHr6E/bFEStQ
         VyEg==
X-Gm-Message-State: AO0yUKVbOLsCLPacD9qxYMKMbLukfAOotXdBXqYXht5f3SmTzTMAnZzX
        pBbGl6fAWh9y11x+vJB9tz7QWskaoP/NlUBeADU1lg==
X-Google-Smtp-Source: AK7set87BWJ5pTI29zjtBphw3P4iRlnNpvJAn97Z6/ipDWdUG/MKUEBoaEcW0lQwXxVcfxwChL6NuGpRnIpIBsHQSvI=
X-Received: by 2002:a05:6102:20cb:b0:412:11a1:428e with SMTP id
 i11-20020a05610220cb00b0041211a1428emr1431324vsr.86.1676610710914; Thu, 16
 Feb 2023 21:11:50 -0800 (PST)
MIME-Version: 1.0
References: <20230207085400.2232544-1-jaewan@google.com> <20230207085400.2232544-2-jaewan@google.com>
 <6ad6708b124b50ff9ea64771b31d09e9168bfa17.camel@sipsolutions.net>
In-Reply-To: <6ad6708b124b50ff9ea64771b31d09e9168bfa17.camel@sipsolutions.net>
From:   Jaewan Kim <jaewan@google.com>
Date:   Fri, 17 Feb 2023 14:11:38 +0900
Message-ID: <CABZjns42zm8Xi-BU0pvT3edNHuJZoh-xshgUk3Oc=nMbxbiY8w@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] mac80211_hwsim: add PMSR capability support
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com, adelva@google.com
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

On Thu, Feb 16, 2023 at 3:01 AM Johannes Berg <johannes@sipsolutions.net> w=
rote:
>
> On Tue, 2023-02-07 at 08:53 +0000, Jaewan Kim wrote:
> > PMSR (a.k.a. peer measurement) is generalized measurement between two
> > Wi-Fi devices. And currently FTM (a.k.a. fine time measurement or fligh=
t
> > time measurement) is the one and only measurement. FTM is measured by
> > RTT (a.k.a. round trip time) of packets between two Wi-Fi devices.
> >
> > This change allows mac80211_hwsim to be configured with PMSR capability=
.
> > The capability is mandatory to accept incoming PMSR request because
> > nl80211_pmsr_start() ignores incoming the request without the PMSR
> > capability.
> >
> > This change adds HWSIM_ATTR_PMSR_SUPPORT, which is used to set PMSR
> > capability when creating a new radio. To send extra details,
> > HWSIM_ATTR_PMSR_SUPPORT can have nested PMSR capability attributes defi=
ned
> > in the nl80211.h. Data format is the same as cfg80211_pmsr_capabilities=
.
> >
> > If HWSIM_ATTR_PMSR_SUPPORT is specified, mac80211_hwsim builds
> > cfg80211_pmsr_capabilities and sets wiphy.pmsr_capa.
>
> I feel kind of bad for even still commenting on v7 already ... :)
>
> Sorry I didn't pay much attention to this before.
>
>
> > +static const struct nla_policy
> > +hwsim_ftm_capa_policy[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1] =3D {
>
> This feels a bit iffy to have here, but I guess it's better that
> defining new attributes for all this over and over again.

I'm sorry but could you rephrase what you expect here?
Are you suggesting to define new sets of HWSIM_PMSR_* enums
instead of using existing enums NL80211_PMSR_*?

>
> > +     [NL80211_PMSR_FTM_CAPA_ATTR_ASAP] =3D { .type =3D NLA_FLAG },
> > +     [NL80211_PMSR_FTM_CAPA_ATTR_NON_ASAP] =3D { .type =3D NLA_FLAG },
> > +     [NL80211_PMSR_FTM_CAPA_ATTR_REQ_LCI] =3D { .type =3D NLA_FLAG },
> > +     [NL80211_PMSR_FTM_CAPA_ATTR_REQ_CIVICLOC] =3D { .type =3D NLA_FLA=
G },
> > +     [NL80211_PMSR_FTM_CAPA_ATTR_PREAMBLES] =3D { .type =3D NLA_U32 },
> > +     [NL80211_PMSR_FTM_CAPA_ATTR_BANDWIDTHS] =3D { .type =3D NLA_U32 }=
,
> > +     [NL80211_PMSR_FTM_CAPA_ATTR_MAX_BURSTS_EXPONENT] =3D NLA_POLICY_M=
AX(NLA_U8, 15),
> > +     [NL80211_PMSR_FTM_CAPA_ATTR_MAX_FTMS_PER_BURST] =3D NLA_POLICY_MA=
X(NLA_U8, 31),
>
> Could add some line-breaks where it's easy to stay below 80 columns. Not
> a hard rule, but still reads nicer.
>
> > +     if (param->pmsr_capa)
> > +             ret =3D cfg80211_send_pmsr_capa(param->pmsr_capa, skb);
>
> I'm not a fan of exporting this function to drivers - it feels odd. It's
> also not really needed, since once the new radio exists the user can
> query it through cfg80211. I'd just remove this part, along with the
> changes in include/ and net/
>
> > @@ -4445,6 +4481,8 @@ static int mac80211_hwsim_new_radio(struct genl_i=
nfo *info,
> >                             NL80211_EXT_FEATURE_MULTICAST_REGISTRATIONS=
);
> >       wiphy_ext_feature_set(hw->wiphy,
> >                             NL80211_EXT_FEATURE_BEACON_RATE_LEGACY);
> > +     wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_ENABLE_FTM_R=
ESPONDER);
> > +
> >
>
> no need for the extra blank line.
>
> > +static int parse_ftm_capa(const struct nlattr *ftm_capa, struct cfg802=
11_pmsr_capabilities *out,
> > +                       struct genl_info *info)
>
> That line also got really long, unnecessarily.
>
> > +{
> > +     struct nlattr *tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1];
> > +     int ret =3D nla_parse_nested(tb, NL80211_PMSR_FTM_CAPA_ATTR_MAX,
> > +                                ftm_capa, hwsim_ftm_capa_policy, NULL)=
;
>
> should have a blank line here I guess.
>
> > +static int parse_pmsr_capa(const struct nlattr *pmsr_capa, struct cfg8=
0211_pmsr_capabilities *out,
> > +                        struct genl_info *info)
> > +{
> > +     struct nlattr *tb[NL80211_PMSR_ATTR_MAX + 1];
> > +     struct nlattr *nla;
> > +     int size;
> > +     int ret =3D nla_parse_nested(tb, NL80211_PMSR_ATTR_MAX, pmsr_capa=
,
> > +                                hwsim_pmsr_capa_policy, NULL);
> > +     if (ret) {
>
> same here for both of those comments
>
> >
> > +     if (info->attrs[HWSIM_ATTR_PMSR_SUPPORT]) {
> > +             struct cfg80211_pmsr_capabilities *pmsr_capa =3D
> > +                     kmalloc(sizeof(struct cfg80211_pmsr_capabilities)=
, GFP_KERNEL);
>
> sizeof(*pmsr_capa), also makes that line a lot shorter
>
> > + * @HWSIM_ATTR_PMSR_SUPPORT: claim peer measurement support
>
> This should probably explain that it's nested, and what should be inside
> of it.
>
> johannes


Dear Johannes Berg,

First of all, thank you for the review.

I left a question for clarification. I'll send another patchset when I
address your feedback correctly.

BTW,  can I expect you to review my changes for further patchsets?
I sometimes get conflicting opinions (e.g. line limits)
so it would be a great help if you take a look at my changes.


--
Jaewan Kim (=EA=B9=80=EC=9E=AC=EC=99=84) | Software Engineer in Google Kore=
a |
jaewan@google.com | +82-10-2781-5078
