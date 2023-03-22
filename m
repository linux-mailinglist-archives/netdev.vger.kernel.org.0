Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4F06C4B7B
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 14:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbjCVNSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 09:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjCVNS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 09:18:28 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBF12D15D
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 06:18:21 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id d75a77b69052e-3ddbf70d790so68131cf.1
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 06:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679491100;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MVcT4Vr5pjck0KVxO2FqMhWxbHx7E/RNWtjLZ5TaL3g=;
        b=FTOrCnqYZKN3PHt0fDH78WXvWJZzAxQfUCWdfWOIKaQPONr15+xWXM4xAk1Np13wm1
         svdelPHENjTdREwclTaTNSbPPNE5Fkp1+mITZe8bF13I+DQutSpb2l1F/AWPZsWMpZSV
         3X5ig3Xj+VbRHEYxW5hrE+ZH90sb3hP5a9iq6EYiZOYSGUOHvVqrwVRCunUQXJ3IOY4L
         G8tNqRlOM9CF1HPW06Ygn10Om0Uo73nn1F63xuwvcjiasfBO9hF39BkqfrH01r6XiiaR
         3hTP09Ie/Lwj8pJ5/FMeeK+sp85U+SmP/ffuA8iJZ58f3wtCPZTlGBDKGgCJGcMaFYLv
         THnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679491100;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MVcT4Vr5pjck0KVxO2FqMhWxbHx7E/RNWtjLZ5TaL3g=;
        b=vpWBWE3iKzkAg1U3UmeUS5JmJwI9KDLMZUrLtwN3bGFkquxLEAgvocNztBeWQXwXRc
         NLgLo823/gGxJBJZAZnCZYrJOSpV89+HK7uFb5ayh2HV+UDHyzYvFNMQvyNihC9PyLbL
         d5anwBFH7IkL/DxBfDNGwcS6Ap0I9nusUBC9Pj9mZS8JGwb/6Pr366gNrzztGlOkJuCy
         ECqIGQvrRFNzG/wHS8lxsAPVAjSvOUcNUswDk7K4snidRT88IO6Le++fL9RTyvbv6lIE
         8WDwO4Bf9M8Ezs6EIaIb/ikcHhR8hcgP8XontRHN+b2dGmGKpCMKFWBSINNe5JtLjPvF
         869Q==
X-Gm-Message-State: AO0yUKWgD6jHB8KVFORGA19j+tPNrLNtag/5oLJ8Uli9e8+cFDtOa9mA
        b1udF11cyyshEqeVSxUVMP9lcDx3WAqmFWDCq6rqfw==
X-Google-Smtp-Source: AK7set+a9l36uemT5L0vCtO7ts1oJtjjiSywRrIGC7ta7FMyVeBusieqCg1KtaxhHOcgDIvxqdI0BXCpq1hIFnX2wF4=
X-Received: by 2002:a05:622a:1493:b0:3de:8cbe:47af with SMTP id
 t19-20020a05622a149300b003de8cbe47afmr273244qtx.9.1679491100523; Wed, 22 Mar
 2023 06:18:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230313075326.3594869-1-jaewan@google.com> <20230313075326.3594869-2-jaewan@google.com>
 <ZA9UrX1I6XXOfnYV@localhost.localdomain> <CABZjns40eHSBDn3BVg0+Wc6dBOZjvx9ewty4wyOzE0WGrH6Tjw@mail.gmail.com>
 <ZBDEoDeEUb6BQsf6@localhost.localdomain>
In-Reply-To: <ZBDEoDeEUb6BQsf6@localhost.localdomain>
From:   Jaewan Kim <jaewan@google.com>
Date:   Wed, 22 Mar 2023 22:18:07 +0900
Message-ID: <CABZjns7eNXhi9XeaYw7oFw6_oVEr937-jqX9baZtg6+qf6cJrQ@mail.gmail.com>
Subject: Re: [PATCH v9 1/5] mac80211_hwsim: add PMSR capability support
To:     Michal Kubiak <michal.kubiak@intel.com>
Cc:     gregkh@linuxfoundation.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@android.com, adelva@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 4:02=E2=80=AFAM Michal Kubiak <michal.kubiak@intel.=
com> wrote:
>
> On Wed, Mar 15, 2023 at 01:36:02AM +0900, Jaewan Kim wrote:
> > On Tue, Mar 14, 2023 at 1:52=E2=80=AFAM Michal Kubiak <michal.kubiak@in=
tel.com> wrote:
> > >
> > > On Mon, Mar 13, 2023 at 07:53:22AM +0000, Jaewan Kim wrote:
> > > > PMSR (a.k.a. peer measurement) is generalized measurement between t=
wo
> > > > Wi-Fi devices. And currently FTM (a.k.a. fine time measurement or f=
light
> > > > time measurement) is the one and only measurement. FTM is measured =
by
> > > > RTT (a.k.a. round trip time) of packets between two Wi-Fi devices.
> > > >
> > > > Add necessary functionality to allow mac80211_hwsim to be configure=
d with
> > > > PMSR capability. The capability is mandatory to accept incoming PMS=
R
> > > > request because nl80211_pmsr_start() ignores incoming the request w=
ithout
> > > > the PMSR capability.
> > > >
> > > > In detail, add new mac80211_hwsim attribute HWSIM_ATTR_PMSR_SUPPORT=
.
> > > > HWSIM_ATTR_PMSR_SUPPORT is used to set PMSR capability when creatin=
g a new
> > > > radio. To send extra capability details, HWSIM_ATTR_PMSR_SUPPORT ca=
n have
> > > > nested PMSR capability attributes defined in the nl80211.h. Data fo=
rmat is
> > > > the same as cfg80211_pmsr_capabilities.
> > > >
> > > > If HWSIM_ATTR_PMSR_SUPPORT is specified, mac80211_hwsim builds
> > > > cfg80211_pmsr_capabilities and sets wiphy.pmsr_capa.
> > > >
> > > > Signed-off-by: Jaewan Kim <jaewan@google.com>
> > >
> > > Hi,
> > >
> > > Just a few style comments and suggestions.
> > >
> > > Thanks,
> > > Michal
> > >
> > > > ---
> > > > V8 -> V9: Changed to consider unknown PMSR type as error.
> > > > V7 -> V8: Changed not to send pmsr_capa when adding new radio to li=
mit
> > > >           exporting cfg80211 function to driver.
> > > > V6 -> V7: Added terms definitions. Removed pr_*() uses.
> > > > V5 -> V6: Added per change patch history.
> > > > V4 -> V5: Fixed style for commit messages.
> > > > V3 -> V4: Added change details for new attribute, and fixed memory =
leak.
> > > > V1 -> V3: Initial commit (includes resends).
> > > > ---
> > > >  drivers/net/wireless/mac80211_hwsim.c | 129 ++++++++++++++++++++++=
+++-
> > > >  drivers/net/wireless/mac80211_hwsim.h |   3 +
> > > >  2 files changed, 131 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wi=
reless/mac80211_hwsim.c
> > > > index 4cc4eaf80b14..65868f28a00f 100644
> > > > --- a/drivers/net/wireless/mac80211_hwsim.c
> > > > +++ b/drivers/net/wireless/mac80211_hwsim.c
> > > > @@ -719,6 +719,9 @@ struct mac80211_hwsim_data {
> > > >       /* RSSI in rx status of the receiver */
> > > >       int rx_rssi;
> > > >
> > > > +     /* only used when pmsr capability is supplied */
> > > > +     struct cfg80211_pmsr_capabilities pmsr_capa;
> > > > +
> > > >       struct mac80211_hwsim_link_data link_data[IEEE80211_MLD_MAX_N=
UM_LINKS];
> > > >  };
> > > >
> > > > @@ -760,6 +763,34 @@ static const struct genl_multicast_group hwsim=
_mcgrps[] =3D {
> > > >
> > > >  /* MAC80211_HWSIM netlink policy */
> > > >
> > > > +static const struct nla_policy
> > > > +hwsim_ftm_capa_policy[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1] =3D {
> > > > +     [NL80211_PMSR_FTM_CAPA_ATTR_ASAP] =3D { .type =3D NLA_FLAG },
> > > > +     [NL80211_PMSR_FTM_CAPA_ATTR_NON_ASAP] =3D { .type =3D NLA_FLA=
G },
> > > > +     [NL80211_PMSR_FTM_CAPA_ATTR_REQ_LCI] =3D { .type =3D NLA_FLAG=
 },
> > > > +     [NL80211_PMSR_FTM_CAPA_ATTR_REQ_CIVICLOC] =3D { .type =3D NLA=
_FLAG },
> > > > +     [NL80211_PMSR_FTM_CAPA_ATTR_PREAMBLES] =3D { .type =3D NLA_U3=
2 },
> > > > +     [NL80211_PMSR_FTM_CAPA_ATTR_BANDWIDTHS] =3D { .type =3D NLA_U=
32 },
> > > > +     [NL80211_PMSR_FTM_CAPA_ATTR_MAX_BURSTS_EXPONENT] =3D NLA_POLI=
CY_MAX(NLA_U8, 15),
> > > > +     [NL80211_PMSR_FTM_CAPA_ATTR_MAX_FTMS_PER_BURST] =3D NLA_POLIC=
Y_MAX(NLA_U8, 31),
> > > > +     [NL80211_PMSR_FTM_CAPA_ATTR_TRIGGER_BASED] =3D { .type =3D NL=
A_FLAG },
> > > > +     [NL80211_PMSR_FTM_CAPA_ATTR_NON_TRIGGER_BASED] =3D { .type =
=3D NLA_FLAG },
> > > > +};
> > > > +
> > > > +static const struct nla_policy
> > > > +hwsim_pmsr_capa_type_policy[NL80211_PMSR_TYPE_MAX + 1] =3D {
> > > > +     [NL80211_PMSR_TYPE_FTM] =3D NLA_POLICY_NESTED(hwsim_ftm_capa_=
policy),
> > > > +};
> > > > +
> > > > +static const struct nla_policy
> > > > +hwsim_pmsr_capa_policy[NL80211_PMSR_ATTR_MAX + 1] =3D {
> > > > +     [NL80211_PMSR_ATTR_MAX_PEERS] =3D { .type =3D NLA_U32 },
> > > > +     [NL80211_PMSR_ATTR_REPORT_AP_TSF] =3D { .type =3D NLA_FLAG },
> > > > +     [NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR] =3D { .type =3D NLA_FL=
AG },
> > > > +     [NL80211_PMSR_ATTR_TYPE_CAPA] =3D NLA_POLICY_NESTED(hwsim_pms=
r_capa_type_policy),
> > > > +     [NL80211_PMSR_ATTR_PEERS] =3D { .type =3D NLA_REJECT }, // on=
ly for request.
> > > > +};
> > > > +
> > > >  static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + =
1] =3D {
> > > >       [HWSIM_ATTR_ADDR_RECEIVER] =3D NLA_POLICY_ETH_ADDR_COMPAT,
> > > >       [HWSIM_ATTR_ADDR_TRANSMITTER] =3D NLA_POLICY_ETH_ADDR_COMPAT,
> > > > @@ -788,6 +819,7 @@ static const struct nla_policy hwsim_genl_polic=
y[HWSIM_ATTR_MAX + 1] =3D {
> > > >       [HWSIM_ATTR_IFTYPE_SUPPORT] =3D { .type =3D NLA_U32 },
> > > >       [HWSIM_ATTR_CIPHER_SUPPORT] =3D { .type =3D NLA_BINARY },
> > > >       [HWSIM_ATTR_MLO_SUPPORT] =3D { .type =3D NLA_FLAG },
> > > > +     [HWSIM_ATTR_PMSR_SUPPORT] =3D NLA_POLICY_NESTED(hwsim_pmsr_ca=
pa_policy),
> > > >  };
> > > >
> > > >  #if IS_REACHABLE(CONFIG_VIRTIO)
> > > > @@ -3186,6 +3218,7 @@ struct hwsim_new_radio_params {
> > > >       u32 *ciphers;
> > > >       u8 n_ciphers;
> > > >       bool mlo;
> > > > +     const struct cfg80211_pmsr_capabilities *pmsr_capa;
> > > >  };
> > > >
> > > >  static void hwsim_mcast_config_msg(struct sk_buff *mcast_skb,
> > > > @@ -3260,7 +3293,7 @@ static int append_radio_msg(struct sk_buff *s=
kb, int id,
> > > >                       return ret;
> > > >       }
> > > >
> > > > -     return 0;
> > > > +     return ret;
> > > >  }
> > > >
> > > >  static void hwsim_mcast_new_radio(int id, struct genl_info *info,
> > > > @@ -4445,6 +4478,7 @@ static int mac80211_hwsim_new_radio(struct ge=
nl_info *info,
> > > >                             NL80211_EXT_FEATURE_MULTICAST_REGISTRAT=
IONS);
> > > >       wiphy_ext_feature_set(hw->wiphy,
> > > >                             NL80211_EXT_FEATURE_BEACON_RATE_LEGACY)=
;
> > > > +     wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_ENABLE_F=
TM_RESPONDER);
> > > >
> > > >       hw->wiphy->interface_modes =3D param->iftypes;
> > > >
> > > > @@ -4606,6 +4640,11 @@ static int mac80211_hwsim_new_radio(struct g=
enl_info *info,
> > > >                                   data->debugfs,
> > > >                                   data, &hwsim_simulate_radar);
> > > >
> > > > +     if (param->pmsr_capa) {
> > > > +             data->pmsr_capa =3D *param->pmsr_capa;
> > > > +             hw->wiphy->pmsr_capa =3D &data->pmsr_capa;
> > > > +     }
> > > > +
> > > >       spin_lock_bh(&hwsim_radio_lock);
> > > >       err =3D rhashtable_insert_fast(&hwsim_radios_rht, &data->rht,
> > > >                                    hwsim_rht_params);
> > > > @@ -4715,6 +4754,7 @@ static int mac80211_hwsim_get_radio(struct sk=
_buff *skb,
> > > >       param.regd =3D data->regd;
> > > >       param.channels =3D data->channels;
> > > >       param.hwname =3D wiphy_name(data->hw->wiphy);
> > > > +     param.pmsr_capa =3D &data->pmsr_capa;
> > > >
> > > >       res =3D append_radio_msg(skb, data->idx, &param);
> > > >       if (res < 0)
> > > > @@ -5053,6 +5093,77 @@ static bool hwsim_known_ciphers(const u32 *c=
iphers, int n_ciphers)
> > > >       return true;
> > > >  }
> > > >
> > > > +static int parse_ftm_capa(const struct nlattr *ftm_capa, struct cf=
g80211_pmsr_capabilities *out,
> > > > +                       struct genl_info *info)
> > > > +{
> > > > +     struct nlattr *tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1];
> > > > +     int ret =3D nla_parse_nested(tb, NL80211_PMSR_FTM_CAPA_ATTR_M=
AX,
> > > > +                                ftm_capa, hwsim_ftm_capa_policy, N=
ULL);
> > >
> > > I would suggest to split declaration and assignment here. It breaks t=
he
> > > RCT principle and it is more likely to overlook "nla_parse_nested" ca=
ll.
> > > I think it would improve the readability when we know that the parsin=
g
> > > function can return an error.
> >
> > Thank you for the review, but what's the RCT principle?
> > I've searched Kernel documentation and also googled it but I couldn't
> > find a good match.
> > Could you elaborate on the details?
> > Most of your comments are related to the RCT, so I'd like to
> > understand what it is.
> >
>
> RCT stands for "reverse christmas tree" order of declaration.
> That means the longest declaration should go first and the shortest last.
> For example:
>
> struct very_long_structure_name *ptr;
> int abc, defgh, othername;
> long ret_code =3D 0;
> u32 a, b, c;
> u8 i;
>
> As far as I know, it is a good practice of coding style in networking.
>
> Thanks,
> Michal
>


Thank you for the info.

I managed to find the relevant information from netdev doc with the name RC=
S.
https://www.kernel.org/doc/html//latest/process/maintainer-netdev.html

Let me follow your suggestion to inherit style guide from netdev,
although there isn't a lint check nor existing RCS style code in mac80211_h=
wsim.

> > >
> > > > +
> > > > +     if (ret) {
> > > > +             NL_SET_ERR_MSG_ATTR(info->extack, ftm_capa, "malforme=
d FTM capability");
> > > > +             return -EINVAL;
> > > > +     }
> > > > +
> > > > +     out->ftm.supported =3D 1;
> > > > +     if (tb[NL80211_PMSR_FTM_CAPA_ATTR_PREAMBLES])
> > > > +             out->ftm.preambles =3D nla_get_u32(tb[NL80211_PMSR_FT=
M_CAPA_ATTR_PREAMBLES]);
> > > > +     if (tb[NL80211_PMSR_FTM_CAPA_ATTR_BANDWIDTHS])
> > > > +             out->ftm.bandwidths =3D nla_get_u32(tb[NL80211_PMSR_F=
TM_CAPA_ATTR_BANDWIDTHS]);
> > > > +     if (tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX_BURSTS_EXPONENT])
> > > > +             out->ftm.max_bursts_exponent =3D
> > > > +                     nla_get_u8(tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX_=
BURSTS_EXPONENT]);
> > > > +     if (tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX_FTMS_PER_BURST])
> > > > +             out->ftm.max_ftms_per_burst =3D
> > > > +                     nla_get_u8(tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX_=
FTMS_PER_BURST]);
> > > > +     out->ftm.asap =3D !!tb[NL80211_PMSR_FTM_CAPA_ATTR_ASAP];
> > > > +     out->ftm.non_asap =3D !!tb[NL80211_PMSR_FTM_CAPA_ATTR_NON_ASA=
P];
> > > > +     out->ftm.request_lci =3D !!tb[NL80211_PMSR_FTM_CAPA_ATTR_REQ_=
LCI];
> > > > +     out->ftm.request_civicloc =3D !!tb[NL80211_PMSR_FTM_CAPA_ATTR=
_REQ_CIVICLOC];
> > > > +     out->ftm.trigger_based =3D !!tb[NL80211_PMSR_FTM_CAPA_ATTR_TR=
IGGER_BASED];
> > > > +     out->ftm.non_trigger_based =3D !!tb[NL80211_PMSR_FTM_CAPA_ATT=
R_NON_TRIGGER_BASED];
> > > > +
> > > > +     return 0;
> > > > +}
> > > > +
> > > > +static int parse_pmsr_capa(const struct nlattr *pmsr_capa, struct =
cfg80211_pmsr_capabilities *out,
> > > > +                        struct genl_info *info)
> > > > +{
> > > > +     struct nlattr *tb[NL80211_PMSR_ATTR_MAX + 1];
> > > > +     struct nlattr *nla;
> > > > +     int size;
> > > > +     int ret =3D nla_parse_nested(tb, NL80211_PMSR_ATTR_MAX, pmsr_=
capa,
> > > > +                                hwsim_pmsr_capa_policy, NULL);
> > >
> > > Ditto.
> > >
> > > > +
> > > > +     if (ret) {
> > > > +             NL_SET_ERR_MSG_ATTR(info->extack, pmsr_capa, "malform=
ed PMSR capability");
> > > > +             return -EINVAL;
> > > > +     }
> > > > +
> > > > +     if (tb[NL80211_PMSR_ATTR_MAX_PEERS])
> > > > +             out->max_peers =3D nla_get_u32(tb[NL80211_PMSR_ATTR_M=
AX_PEERS]);
> > > > +     out->report_ap_tsf =3D !!tb[NL80211_PMSR_ATTR_REPORT_AP_TSF];
> > > > +     out->randomize_mac_addr =3D !!tb[NL80211_PMSR_ATTR_RANDOMIZE_=
MAC_ADDR];
> > > > +
> > > > +     if (!tb[NL80211_PMSR_ATTR_TYPE_CAPA]) {
> > > > +             NL_SET_ERR_MSG_ATTR(info->extack, tb[NL80211_PMSR_ATT=
R_TYPE_CAPA],
> > > > +                                 "malformed PMSR type");
> > > > +             return -EINVAL;
> > > > +     }
> > > > +
> > > > +     nla_for_each_nested(nla, tb[NL80211_PMSR_ATTR_TYPE_CAPA], siz=
e) {
> > > > +             switch (nla_type(nla)) {
> > > > +             case NL80211_PMSR_TYPE_FTM:
> > > > +                     parse_ftm_capa(nla, out, info);
> > > > +                     break;
> > > > +             default:
> > > > +                     NL_SET_ERR_MSG_ATTR(info->extack, nla, "unsup=
ported measurement type");
> > > > +                     return -EINVAL;
> > > > +             }
> > > > +     }
> > > > +     return 0;
> > > > +}
> > > > +
> > > >  static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_inf=
o *info)
> > > >  {
> > > >       struct hwsim_new_radio_params param =3D { 0 };
> > > > @@ -5173,8 +5284,24 @@ static int hwsim_new_radio_nl(struct sk_buff=
 *msg, struct genl_info *info)
> > > >               param.hwname =3D hwname;
> > > >       }
> > > >
> > > > +     if (info->attrs[HWSIM_ATTR_PMSR_SUPPORT]) {
> > > > +             struct cfg80211_pmsr_capabilities *pmsr_capa =3D
> > > > +                     kmalloc(sizeof(*pmsr_capa), GFP_KERNEL);
> > >
> > > Missing empty line after variable definition.
> > > BTW, would it not be better to split "pmsr_capa" declaration and
> > > "kmalloc"? For example:
> > >
> > >                 struct cfg80211_pmsr_capabilities *pmsr_capa;
> > >
> > >                 pmsr_capa =3D kmalloc(sizeof(*pmsr_capa), GFP_KERNEL)=
;
> > >                 if (!pmsr_capa) {
> > >
> > > I think it would be more readable and you would not have to break the
> > > line. Also, in the current version it seems more likely that the memo=
ry
> > > allocation will be overlooked.
> > >
> > > > +             if (!pmsr_capa) {
> > > > +                     ret =3D -ENOMEM;
> > > > +                     goto out_free;
> > > > +             }
> > > > +             ret =3D parse_pmsr_capa(info->attrs[HWSIM_ATTR_PMSR_S=
UPPORT], pmsr_capa, info);
> > > > +             if (ret)
> > > > +                     goto out_free;
> > > > +             param.pmsr_capa =3D pmsr_capa;
> > > > +     }
> > > > +
> > > >       ret =3D mac80211_hwsim_new_radio(info, &param);
> > > > +
> > > > +out_free:
> > > >       kfree(hwname);
> > > > +     kfree(param.pmsr_capa);
> > > >       return ret;
> > > >  }
> > > >
> > > > diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wi=
reless/mac80211_hwsim.h
> > > > index 527799b2de0f..d10fa7f4853b 100644
> > > > --- a/drivers/net/wireless/mac80211_hwsim.h
> > > > +++ b/drivers/net/wireless/mac80211_hwsim.h
> > > > @@ -142,6 +142,8 @@ enum {
> > > >   * @HWSIM_ATTR_CIPHER_SUPPORT: u32 array of supported cipher types
> > > >   * @HWSIM_ATTR_MLO_SUPPORT: claim MLO support (exact parameters TB=
D) for
> > > >   *   the new radio
> > > > + * @HWSIM_ATTR_PMSR_SUPPORT: nested attribute used with %HWSIM_CMD=
_CREATE_RADIO
> > > > + *   to provide peer measurement capabilities. (nl80211_peer_measu=
rement_attrs)
> > > >   * @__HWSIM_ATTR_MAX: enum limit
> > > >   */
> > > >
> > > > @@ -173,6 +175,7 @@ enum {
> > > >       HWSIM_ATTR_IFTYPE_SUPPORT,
> > > >       HWSIM_ATTR_CIPHER_SUPPORT,
> > > >       HWSIM_ATTR_MLO_SUPPORT,
> > > > +     HWSIM_ATTR_PMSR_SUPPORT,
> > > >       __HWSIM_ATTR_MAX,
> > > >  };
> > > >  #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
> > > > --
> > > > 2.40.0.rc1.284.g88254d51c5-goog
> > > >


--
Jaewan Kim (=EA=B9=80=EC=9E=AC=EC=99=84) | Software Engineer in Google Kore=
a |
jaewan@google.com | +82-10-2781-5078
