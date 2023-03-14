Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40E626B9BBB
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbjCNQhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbjCNQg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:36:56 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC2FB5AA2
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 09:36:16 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id a13so2538600ilr.9
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 09:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678811775;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=13L16QiSIJUXWXMVq0dDQcwAIXBG8HnE7WXYucsnPSo=;
        b=hSfWlsXANfqRBit5kEXWolu7PWpZV6zCTUJUWX7+zfYtKiv7ufkBvYyoMkELES0Ox9
         NsIGtWVwR4+iCurPl1LokfUHYqzbvdiJ1zCDogc6SXekW5Bfwo+1nrjb5oF2mUvCHiJV
         BikPQC0y6YX6DkISCvIgnY5ufSo+ea6AYeXQy2qvWJEQ7Hq36Jo07GRXnjSP9ya3slrQ
         KdTAU+h0AwEGiUiSmwieUZAz4Z3hnOx5LDpo+0B0o1SxsUsMmDsSuVLsqD1TCRacU9v5
         jkx6Wh5a97f7Keyg/BWpEY1URq/zyXBRMIntnPqOywAnu2Di5b5Gw8s3jXB8mdNXo0dO
         dl1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678811775;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=13L16QiSIJUXWXMVq0dDQcwAIXBG8HnE7WXYucsnPSo=;
        b=Akn+ip7Ci/dJ0Ffh6ZB1XRKL6rGyDQTN2wJpsyRFfWzN3VlRu7U2GQkFO3kWbO+j54
         tKNIz4R4KNQ0K7w0m4C6bA1OVCvdCHkmN8L1fI3HUTaZ4qIID/ufvm9ERcdWAXI7Bn/2
         hvrHhFmj/HZRwEKqnKFyWv3VE6UiqLVgcsWwFTAF8OzcM8CJ+M/wusl4qGqQcK9wK/OF
         p5VZfCNgP1+jhGS9PjJOR/QaxQLNIRcrxPyAUn6YqPkcdxiIeGFuXkUvkeJBJD7hlBoT
         On9FFRYtTzQFwMmph5ME5glggTYm3ppkctHgTEkifhQAb82i+5Zo4lzETTxIOBfqabV0
         BSuA==
X-Gm-Message-State: AO0yUKVg0iO5isnBYKQO0ItRzhskhGWe7VUqNnrDhu8xR9o1mis3cCGv
        I9uJv4Khm4BOwmU5/LzU+g7k6iQL5VhT+9wCv3EOyw==
X-Google-Smtp-Source: AK7set8PUELuR65ngz6g3rn6o8PrE5WRIvt3wJThXJ4kwhVpwdmIn5T9mfCYfIGmLZvFa2tWb8IIPJvkgwxxB4crt3g=
X-Received: by 2002:a92:2613:0:b0:323:1b6:8854 with SMTP id
 n19-20020a922613000000b0032301b68854mr210978ile.10.1678811775323; Tue, 14 Mar
 2023 09:36:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230313075326.3594869-1-jaewan@google.com> <20230313075326.3594869-2-jaewan@google.com>
 <ZA9UrX1I6XXOfnYV@localhost.localdomain>
In-Reply-To: <ZA9UrX1I6XXOfnYV@localhost.localdomain>
From:   Jaewan Kim <jaewan@google.com>
Date:   Wed, 15 Mar 2023 01:36:02 +0900
Message-ID: <CABZjns40eHSBDn3BVg0+Wc6dBOZjvx9ewty4wyOzE0WGrH6Tjw@mail.gmail.com>
Subject: Re: [PATCH v9 1/5] mac80211_hwsim: add PMSR capability support
To:     Michal Kubiak <michal.kubiak@intel.com>
Cc:     gregkh@linuxfoundation.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@android.com, adelva@google.com
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

On Tue, Mar 14, 2023 at 1:52=E2=80=AFAM Michal Kubiak <michal.kubiak@intel.=
com> wrote:
>
> On Mon, Mar 13, 2023 at 07:53:22AM +0000, Jaewan Kim wrote:
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
> Hi,
>
> Just a few style comments and suggestions.
>
> Thanks,
> Michal
>
> > ---
> > V8 -> V9: Changed to consider unknown PMSR type as error.
> > V7 -> V8: Changed not to send pmsr_capa when adding new radio to limit
> >           exporting cfg80211 function to driver.
> > V6 -> V7: Added terms definitions. Removed pr_*() uses.
> > V5 -> V6: Added per change patch history.
> > V4 -> V5: Fixed style for commit messages.
> > V3 -> V4: Added change details for new attribute, and fixed memory leak=
.
> > V1 -> V3: Initial commit (includes resends).
> > ---
> >  drivers/net/wireless/mac80211_hwsim.c | 129 +++++++++++++++++++++++++-
> >  drivers/net/wireless/mac80211_hwsim.h |   3 +
> >  2 files changed, 131 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wirele=
ss/mac80211_hwsim.c
> > index 4cc4eaf80b14..65868f28a00f 100644
> > --- a/drivers/net/wireless/mac80211_hwsim.c
> > +++ b/drivers/net/wireless/mac80211_hwsim.c
> > @@ -719,6 +719,9 @@ struct mac80211_hwsim_data {
> >       /* RSSI in rx status of the receiver */
> >       int rx_rssi;
> >
> > +     /* only used when pmsr capability is supplied */
> > +     struct cfg80211_pmsr_capabilities pmsr_capa;
> > +
> >       struct mac80211_hwsim_link_data link_data[IEEE80211_MLD_MAX_NUM_L=
INKS];
> >  };
> >
> > @@ -760,6 +763,34 @@ static const struct genl_multicast_group hwsim_mcg=
rps[] =3D {
> >
> >  /* MAC80211_HWSIM netlink policy */
> >
> > +static const struct nla_policy
> > +hwsim_ftm_capa_policy[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1] =3D {
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
> > +     [NL80211_PMSR_FTM_CAPA_ATTR_TRIGGER_BASED] =3D { .type =3D NLA_FL=
AG },
> > +     [NL80211_PMSR_FTM_CAPA_ATTR_NON_TRIGGER_BASED] =3D { .type =3D NL=
A_FLAG },
> > +};
> > +
> > +static const struct nla_policy
> > +hwsim_pmsr_capa_type_policy[NL80211_PMSR_TYPE_MAX + 1] =3D {
> > +     [NL80211_PMSR_TYPE_FTM] =3D NLA_POLICY_NESTED(hwsim_ftm_capa_poli=
cy),
> > +};
> > +
> > +static const struct nla_policy
> > +hwsim_pmsr_capa_policy[NL80211_PMSR_ATTR_MAX + 1] =3D {
> > +     [NL80211_PMSR_ATTR_MAX_PEERS] =3D { .type =3D NLA_U32 },
> > +     [NL80211_PMSR_ATTR_REPORT_AP_TSF] =3D { .type =3D NLA_FLAG },
> > +     [NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR] =3D { .type =3D NLA_FLAG }=
,
> > +     [NL80211_PMSR_ATTR_TYPE_CAPA] =3D NLA_POLICY_NESTED(hwsim_pmsr_ca=
pa_type_policy),
> > +     [NL80211_PMSR_ATTR_PEERS] =3D { .type =3D NLA_REJECT }, // only f=
or request.
> > +};
> > +
> >  static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] =
=3D {
> >       [HWSIM_ATTR_ADDR_RECEIVER] =3D NLA_POLICY_ETH_ADDR_COMPAT,
> >       [HWSIM_ATTR_ADDR_TRANSMITTER] =3D NLA_POLICY_ETH_ADDR_COMPAT,
> > @@ -788,6 +819,7 @@ static const struct nla_policy hwsim_genl_policy[HW=
SIM_ATTR_MAX + 1] =3D {
> >       [HWSIM_ATTR_IFTYPE_SUPPORT] =3D { .type =3D NLA_U32 },
> >       [HWSIM_ATTR_CIPHER_SUPPORT] =3D { .type =3D NLA_BINARY },
> >       [HWSIM_ATTR_MLO_SUPPORT] =3D { .type =3D NLA_FLAG },
> > +     [HWSIM_ATTR_PMSR_SUPPORT] =3D NLA_POLICY_NESTED(hwsim_pmsr_capa_p=
olicy),
> >  };
> >
> >  #if IS_REACHABLE(CONFIG_VIRTIO)
> > @@ -3186,6 +3218,7 @@ struct hwsim_new_radio_params {
> >       u32 *ciphers;
> >       u8 n_ciphers;
> >       bool mlo;
> > +     const struct cfg80211_pmsr_capabilities *pmsr_capa;
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
> >  }
> >
> >  static void hwsim_mcast_new_radio(int id, struct genl_info *info,
> > @@ -4445,6 +4478,7 @@ static int mac80211_hwsim_new_radio(struct genl_i=
nfo *info,
> >                             NL80211_EXT_FEATURE_MULTICAST_REGISTRATIONS=
);
> >       wiphy_ext_feature_set(hw->wiphy,
> >                             NL80211_EXT_FEATURE_BEACON_RATE_LEGACY);
> > +     wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_ENABLE_FTM_R=
ESPONDER);
> >
> >       hw->wiphy->interface_modes =3D param->iftypes;
> >
> > @@ -4606,6 +4640,11 @@ static int mac80211_hwsim_new_radio(struct genl_=
info *info,
> >                                   data->debugfs,
> >                                   data, &hwsim_simulate_radar);
> >
> > +     if (param->pmsr_capa) {
> > +             data->pmsr_capa =3D *param->pmsr_capa;
> > +             hw->wiphy->pmsr_capa =3D &data->pmsr_capa;
> > +     }
> > +
> >       spin_lock_bh(&hwsim_radio_lock);
> >       err =3D rhashtable_insert_fast(&hwsim_radios_rht, &data->rht,
> >                                    hwsim_rht_params);
> > @@ -4715,6 +4754,7 @@ static int mac80211_hwsim_get_radio(struct sk_buf=
f *skb,
> >       param.regd =3D data->regd;
> >       param.channels =3D data->channels;
> >       param.hwname =3D wiphy_name(data->hw->wiphy);
> > +     param.pmsr_capa =3D &data->pmsr_capa;
> >
> >       res =3D append_radio_msg(skb, data->idx, &param);
> >       if (res < 0)
> > @@ -5053,6 +5093,77 @@ static bool hwsim_known_ciphers(const u32 *ciphe=
rs, int n_ciphers)
> >       return true;
> >  }
> >
> > +static int parse_ftm_capa(const struct nlattr *ftm_capa, struct cfg802=
11_pmsr_capabilities *out,
> > +                       struct genl_info *info)
> > +{
> > +     struct nlattr *tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1];
> > +     int ret =3D nla_parse_nested(tb, NL80211_PMSR_FTM_CAPA_ATTR_MAX,
> > +                                ftm_capa, hwsim_ftm_capa_policy, NULL)=
;
>
> I would suggest to split declaration and assignment here. It breaks the
> RCT principle and it is more likely to overlook "nla_parse_nested" call.
> I think it would improve the readability when we know that the parsing
> function can return an error.

Thank you for the review, but what's the RCT principle?
I've searched Kernel documentation and also googled it but I couldn't
find a good match.
Could you elaborate on the details?
Most of your comments are related to the RCT, so I'd like to
understand what it is.

>
> > +
> > +     if (ret) {
> > +             NL_SET_ERR_MSG_ATTR(info->extack, ftm_capa, "malformed FT=
M capability");
> > +             return -EINVAL;
> > +     }
> > +
> > +     out->ftm.supported =3D 1;
> > +     if (tb[NL80211_PMSR_FTM_CAPA_ATTR_PREAMBLES])
> > +             out->ftm.preambles =3D nla_get_u32(tb[NL80211_PMSR_FTM_CA=
PA_ATTR_PREAMBLES]);
> > +     if (tb[NL80211_PMSR_FTM_CAPA_ATTR_BANDWIDTHS])
> > +             out->ftm.bandwidths =3D nla_get_u32(tb[NL80211_PMSR_FTM_C=
APA_ATTR_BANDWIDTHS]);
> > +     if (tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX_BURSTS_EXPONENT])
> > +             out->ftm.max_bursts_exponent =3D
> > +                     nla_get_u8(tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX_BURS=
TS_EXPONENT]);
> > +     if (tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX_FTMS_PER_BURST])
> > +             out->ftm.max_ftms_per_burst =3D
> > +                     nla_get_u8(tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX_FTMS=
_PER_BURST]);
> > +     out->ftm.asap =3D !!tb[NL80211_PMSR_FTM_CAPA_ATTR_ASAP];
> > +     out->ftm.non_asap =3D !!tb[NL80211_PMSR_FTM_CAPA_ATTR_NON_ASAP];
> > +     out->ftm.request_lci =3D !!tb[NL80211_PMSR_FTM_CAPA_ATTR_REQ_LCI]=
;
> > +     out->ftm.request_civicloc =3D !!tb[NL80211_PMSR_FTM_CAPA_ATTR_REQ=
_CIVICLOC];
> > +     out->ftm.trigger_based =3D !!tb[NL80211_PMSR_FTM_CAPA_ATTR_TRIGGE=
R_BASED];
> > +     out->ftm.non_trigger_based =3D !!tb[NL80211_PMSR_FTM_CAPA_ATTR_NO=
N_TRIGGER_BASED];
> > +
> > +     return 0;
> > +}
> > +
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
>
> Ditto.
>
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
> > +                     NL_SET_ERR_MSG_ATTR(info->extack, nla, "unsupport=
ed measurement type");
> > +                     return -EINVAL;
> > +             }
> > +     }
> > +     return 0;
> > +}
> > +
> >  static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *i=
nfo)
> >  {
> >       struct hwsim_new_radio_params param =3D { 0 };
> > @@ -5173,8 +5284,24 @@ static int hwsim_new_radio_nl(struct sk_buff *ms=
g, struct genl_info *info)
> >               param.hwname =3D hwname;
> >       }
> >
> > +     if (info->attrs[HWSIM_ATTR_PMSR_SUPPORT]) {
> > +             struct cfg80211_pmsr_capabilities *pmsr_capa =3D
> > +                     kmalloc(sizeof(*pmsr_capa), GFP_KERNEL);
>
> Missing empty line after variable definition.
> BTW, would it not be better to split "pmsr_capa" declaration and
> "kmalloc"? For example:
>
>                 struct cfg80211_pmsr_capabilities *pmsr_capa;
>
>                 pmsr_capa =3D kmalloc(sizeof(*pmsr_capa), GFP_KERNEL);
>                 if (!pmsr_capa) {
>
> I think it would be more readable and you would not have to break the
> line. Also, in the current version it seems more likely that the memory
> allocation will be overlooked.
>
> > +             if (!pmsr_capa) {
> > +                     ret =3D -ENOMEM;
> > +                     goto out_free;
> > +             }
> > +             ret =3D parse_pmsr_capa(info->attrs[HWSIM_ATTR_PMSR_SUPPO=
RT], pmsr_capa, info);
> > +             if (ret)
> > +                     goto out_free;
> > +             param.pmsr_capa =3D pmsr_capa;
> > +     }
> > +
> >       ret =3D mac80211_hwsim_new_radio(info, &param);
> > +
> > +out_free:
> >       kfree(hwname);
> > +     kfree(param.pmsr_capa);
> >       return ret;
> >  }
> >
> > diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wirele=
ss/mac80211_hwsim.h
> > index 527799b2de0f..d10fa7f4853b 100644
> > --- a/drivers/net/wireless/mac80211_hwsim.h
> > +++ b/drivers/net/wireless/mac80211_hwsim.h
> > @@ -142,6 +142,8 @@ enum {
> >   * @HWSIM_ATTR_CIPHER_SUPPORT: u32 array of supported cipher types
> >   * @HWSIM_ATTR_MLO_SUPPORT: claim MLO support (exact parameters TBD) f=
or
> >   *   the new radio
> > + * @HWSIM_ATTR_PMSR_SUPPORT: nested attribute used with %HWSIM_CMD_CRE=
ATE_RADIO
> > + *   to provide peer measurement capabilities. (nl80211_peer_measureme=
nt_attrs)
> >   * @__HWSIM_ATTR_MAX: enum limit
> >   */
> >
> > @@ -173,6 +175,7 @@ enum {
> >       HWSIM_ATTR_IFTYPE_SUPPORT,
> >       HWSIM_ATTR_CIPHER_SUPPORT,
> >       HWSIM_ATTR_MLO_SUPPORT,
> > +     HWSIM_ATTR_PMSR_SUPPORT,
> >       __HWSIM_ATTR_MAX,
> >  };
> >  #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
> > --
> > 2.40.0.rc1.284.g88254d51c5-goog
> >



--=20
Jaewan Kim (=EA=B9=80=EC=9E=AC=EC=99=84) | Software Engineer in Google Kore=
a |
jaewan@google.com | +82-10-2781-5078
