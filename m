Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2A46C4B85
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 14:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbjCVNT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 09:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbjCVNTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 09:19:12 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3E92CFC4
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 06:19:05 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id d75a77b69052e-3d7aef37dccso68871cf.0
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 06:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679491145;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QnSJkDxbuJSOP2omYqJWXJiIXtqsN+hXQRJ0Te3TQM0=;
        b=tOWW0pplRF4tD+WHArVYrR9GuU2Oi+PdYQK1+Rr0k975ZaQWbTfQKNuYOuD7EhiMu2
         6wGGvtc4ZcilgwK133bgLC3vkeAwMbiwONjvtI+qGmPPL0tr+fr9vFjUGZPJjzYZMRVc
         uI9e0ddRZKTO/d4730R8LYcTFx8F/Gq7U1wt1iNV9t8EZxrrivunxY5eGYZObppgupdS
         CttnxySFFwZ5BkfzLHccJ8xsmBF8RCKEyHLle6J/NlDOnvhZQBgHi3w24KcP9hQtneNi
         KScN/HnYamuPQjPNVvVUDGglkqzmsXCufuonMsP6/VmdA1qO86OWom6hAw48+Pfw+ar/
         6TWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679491145;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QnSJkDxbuJSOP2omYqJWXJiIXtqsN+hXQRJ0Te3TQM0=;
        b=J4ocDiTAhyqOx1SmSndt/fX//a9iLBZXEKrg2ZOgRSQU+yaMYdKGR4tGUYDJSJnCaq
         W4rRue3fpgyjQJI7Z7pNNc1quNA/KoQUqkUIrC0KgScN1dpvhad/WbHJRcHOMLw8wGzs
         43Ab8EOLCAljiz73DIIq57hRC/KF593PAW3/1gbl5OihnVQd1wZ66Ec/Qs63QSG3QAhH
         +2+17ZKs6ZLSjZypcJIPlOeNN3GkDlYyMCiCZZYnrQkyH7n6h5tZ0YSd/QM0i5uADQbA
         FXORc/6qndQlTkpWZj8vo5BT8sUwJlCzCFhsNIFDEvhVuRZtjdvND11a9Mk1GUo0ALTB
         3sLg==
X-Gm-Message-State: AO0yUKX/gD8sjEXk7t/usJxO5P63H6hg+9V9lfNvE1HvYl6fCe18P/Tn
        Lj2Rb3j1B3twHKjootEzpDKgt49jxmqoN/gVYjeypg==
X-Google-Smtp-Source: AK7set+xQ+/jHKrZ8G98trdpO4AlAx2CgQ6ek3fMCs8yoeVP+wqg742F/kUglup1MLh0vLQe/Bvez9CS1Ta3shzqcsk=
X-Received: by 2002:ac8:7d14:0:b0:3b9:f696:c754 with SMTP id
 g20-20020ac87d14000000b003b9f696c754mr295023qtb.5.1679491144609; Wed, 22 Mar
 2023 06:19:04 -0700 (PDT)
MIME-Version: 1.0
References: <20230313075326.3594869-1-jaewan@google.com> <20230313075326.3594869-6-jaewan@google.com>
 <ZA+G3Rr+ibEL+2cX@localhost.localdomain> <CABZjns6=8-cxQbUh2510eQ0B6C80hzMNDxFyY7zxgLY+NJTRGQ@mail.gmail.com>
 <ZBDBbZYSmBWIVOVh@localhost.localdomain>
In-Reply-To: <ZBDBbZYSmBWIVOVh@localhost.localdomain>
From:   Jaewan Kim <jaewan@google.com>
Date:   Wed, 22 Mar 2023 22:18:51 +0900
Message-ID: <CABZjns48pZKTgHKziRmKiwQ6jfznqHnczUg+DVdAUtVg59kS+Q@mail.gmail.com>
Subject: Re: [PATCH v9 5/5] mac80211_hwsim: add PMSR report support via virtio
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

On Wed, Mar 15, 2023 at 3:48=E2=80=AFAM Michal Kubiak <michal.kubiak@intel.=
com> wrote:
>
> On Wed, Mar 15, 2023 at 01:31:38AM +0900, Jaewan Kim wrote:
> > On Tue, Mar 14, 2023 at 5:26=E2=80=AFAM Michal Kubiak <michal.kubiak@in=
tel.com> wrote:
> > >
> > > On Mon, Mar 13, 2023 at 07:53:26AM +0000, Jaewan Kim wrote:
> > > > PMSR (a.k.a. peer measurement) is generalized measurement between t=
wo
> > > > devices with Wi-Fi support. And currently FTM (a.k.a. fine time mea=
surement
> > > > or flight time measurement) is the one and only measurement.
> > > >
> > > > Add the necessary functionality to allow mac80211_hwsim to report P=
MSR
> > > > result. The result would come from the wmediumd, where other Wi-Fi
> > > > devices' information are kept. mac80211_hwsim only need to deliver =
the
> > > > result to the userspace.
> > > >
> > > > In detail, add new mac80211_hwsim attributes HWSIM_CMD_REPORT_PMSR,=
 and
> > > > HWSIM_ATTR_PMSR_RESULT. When mac80211_hwsim receives the PMSR resul=
t with
> > > > command HWSIM_CMD_REPORT_PMSR and detail with attribute
> > > > HWSIM_ATTR_PMSR_RESULT, received data is parsed to cfg80211_pmsr_re=
sult and
> > > > resent to the userspace by cfg80211_pmsr_report().
> > > >
> > > > To help receive the details of PMSR result, hwsim_rate_info_attribu=
tes is
> > > > added to receive rate_info without complex bitrate calculation. (i.=
e. send
> > > > rate_info without adding inverse of nl80211_put_sta_rate()).
> > > >
> > > > Signed-off-by: Jaewan Kim <jaewan@google.com>
> > > > ---
> > > > V7 -> V8: Changed to specify calculated last HWSIM_CMD for resv_sta=
rt_op
> > > >           instead of __HWSIM_CMD_MAX for adding new CMD more explic=
it.
> > > > V7: Initial commit (split from previously large patch)
> > > > ---
> > > >  drivers/net/wireless/mac80211_hwsim.c | 379 ++++++++++++++++++++++=
+++-
> > > >  drivers/net/wireless/mac80211_hwsim.h |  51 +++-
> > > >  2 files changed, 420 insertions(+), 10 deletions(-)
> > > >
> > >
> > > General comment: there are many lines exceeding 80 characters (the li=
mit
> > > for net).
> > > The rest of my comments - inline.
> >
> > We can now using 100 columns
> > because 80 character limit is deprecated
> >
> > Here's previous discussion thread:
> > https://patchwork.kernel.org/project/linux-wireless/patch/2023020708540=
0.2232544-2-jaewan@google.com/#25217046
>
> Oh, sorry, so it's my mistake.
> I mainly had an experience with ethernet drivers, where we still check
> the limit 80 characters.
>
> Thanks,
> Michal
>
> >
> > >
> > > Thanks,
> > > Michal
> > >
> > > > diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wi=
reless/mac80211_hwsim.c
> > > > index 8f699dfab77a..d1218c1efba4 100644
> > > > --- a/drivers/net/wireless/mac80211_hwsim.c
> > > > +++ b/drivers/net/wireless/mac80211_hwsim.c
> > > > @@ -752,6 +752,11 @@ struct hwsim_radiotap_ack_hdr {
> > > >       __le16 rt_chbitmask;
> > > >  } __packed;
> > > >
> > > > +static struct mac80211_hwsim_data *get_hwsim_data_ref_from_addr(co=
nst u8 *addr)
> > > > +{
> > > > +     return rhashtable_lookup_fast(&hwsim_radios_rht, addr, hwsim_=
rht_params);
> > > > +}
> > > > +
> > > >  /* MAC80211_HWSIM netlink family */
> > > >  static struct genl_family hwsim_genl_family;
> > > >
> > > > @@ -765,6 +770,76 @@ static const struct genl_multicast_group hwsim=
_mcgrps[] =3D {
> > > >
> > > >  /* MAC80211_HWSIM netlink policy */
> > > >
> > > > +static const struct nla_policy
> > > > +hwsim_rate_info_policy[HWSIM_RATE_INFO_ATTR_MAX + 1] =3D {
> > > > +     [HWSIM_RATE_INFO_ATTR_FLAGS] =3D { .type =3D NLA_U8 },
> > > > +     [HWSIM_RATE_INFO_ATTR_MCS] =3D { .type =3D NLA_U8 },
> > > > +     [HWSIM_RATE_INFO_ATTR_LEGACY] =3D { .type =3D NLA_U16 },
> > > > +     [HWSIM_RATE_INFO_ATTR_NSS] =3D { .type =3D NLA_U8 },
> > > > +     [HWSIM_RATE_INFO_ATTR_BW] =3D { .type =3D NLA_U8 },
> > > > +     [HWSIM_RATE_INFO_ATTR_HE_GI] =3D { .type =3D NLA_U8 },
> > > > +     [HWSIM_RATE_INFO_ATTR_HE_DCM] =3D { .type =3D NLA_U8 },
> > > > +     [HWSIM_RATE_INFO_ATTR_HE_RU_ALLOC] =3D { .type =3D NLA_U8 },
> > > > +     [HWSIM_RATE_INFO_ATTR_N_BOUNDED_CH] =3D { .type =3D NLA_U8 },
> > > > +     [HWSIM_RATE_INFO_ATTR_EHT_GI] =3D { .type =3D NLA_U8 },
> > > > +     [HWSIM_RATE_INFO_ATTR_EHT_RU_ALLOC] =3D { .type =3D NLA_U8 },
> > > > +};
> > > > +
> > > > +static const struct nla_policy
> > > > +hwsim_ftm_result_policy[NL80211_PMSR_FTM_RESP_ATTR_MAX + 1] =3D {
> > > > +     [NL80211_PMSR_FTM_RESP_ATTR_FAIL_REASON] =3D { .type =3D NLA_=
U32 },
> > > > +     [NL80211_PMSR_FTM_RESP_ATTR_BURST_INDEX] =3D { .type =3D NLA_=
U16 },
> > > > +     [NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_ATTEMPTS] =3D { .type =
=3D NLA_U32 },
> > > > +     [NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_SUCCESSES] =3D { .type =
=3D NLA_U32 },
> > > > +     [NL80211_PMSR_FTM_RESP_ATTR_BUSY_RETRY_TIME] =3D { .type =3D =
NLA_U8 },
> > > > +     [NL80211_PMSR_FTM_RESP_ATTR_NUM_BURSTS_EXP] =3D { .type =3D N=
LA_U8 },
> > > > +     [NL80211_PMSR_FTM_RESP_ATTR_BURST_DURATION] =3D { .type =3D N=
LA_U8 },
> > > > +     [NL80211_PMSR_FTM_RESP_ATTR_FTMS_PER_BURST] =3D { .type =3D N=
LA_U8 },
> > > > +     [NL80211_PMSR_FTM_RESP_ATTR_RSSI_AVG] =3D { .type =3D NLA_U32=
 },
> > > > +     [NL80211_PMSR_FTM_RESP_ATTR_RSSI_SPREAD] =3D { .type =3D NLA_=
U32 },
> > > > +     [NL80211_PMSR_FTM_RESP_ATTR_TX_RATE] =3D NLA_POLICY_NESTED(hw=
sim_rate_info_policy),
> > > > +     [NL80211_PMSR_FTM_RESP_ATTR_RX_RATE] =3D NLA_POLICY_NESTED(hw=
sim_rate_info_policy),
> > > > +     [NL80211_PMSR_FTM_RESP_ATTR_RTT_AVG] =3D { .type =3D NLA_U64 =
},
> > > > +     [NL80211_PMSR_FTM_RESP_ATTR_RTT_VARIANCE] =3D { .type =3D NLA=
_U64 },
> > > > +     [NL80211_PMSR_FTM_RESP_ATTR_RTT_SPREAD] =3D { .type =3D NLA_U=
64 },
> > > > +     [NL80211_PMSR_FTM_RESP_ATTR_DIST_AVG] =3D { .type =3D NLA_U64=
 },
> > > > +     [NL80211_PMSR_FTM_RESP_ATTR_DIST_VARIANCE] =3D { .type =3D NL=
A_U64 },
> > > > +     [NL80211_PMSR_FTM_RESP_ATTR_DIST_SPREAD] =3D { .type =3D NLA_=
U64 },
> > > > +     [NL80211_PMSR_FTM_RESP_ATTR_LCI] =3D { .type =3D NLA_STRING }=
,
> > > > +     [NL80211_PMSR_FTM_RESP_ATTR_CIVICLOC] =3D { .type =3D NLA_STR=
ING },
> > > > +};
> > > > +
> > > > +static const struct nla_policy
> > > > +hwsim_pmsr_resp_type_policy[NL80211_PMSR_TYPE_MAX + 1] =3D {
> > > > +     [NL80211_PMSR_TYPE_FTM] =3D NLA_POLICY_NESTED(hwsim_ftm_resul=
t_policy),
> > > > +};
> > > > +
> > > > +static const struct nla_policy
> > > > +hwsim_pmsr_resp_policy[NL80211_PMSR_RESP_ATTR_MAX + 1] =3D {
> > > > +     [NL80211_PMSR_RESP_ATTR_STATUS] =3D { .type =3D NLA_U32 },
> > > > +     [NL80211_PMSR_RESP_ATTR_HOST_TIME] =3D { .type =3D NLA_U64 },
> > > > +     [NL80211_PMSR_RESP_ATTR_AP_TSF] =3D { .type =3D NLA_U64 },
> > > > +     [NL80211_PMSR_RESP_ATTR_FINAL] =3D { .type =3D NLA_FLAG },
> > > > +     [NL80211_PMSR_RESP_ATTR_DATA] =3D NLA_POLICY_NESTED(hwsim_pms=
r_resp_type_policy),
> > > > +};
> > > > +
> > > > +static const struct nla_policy
> > > > +hwsim_pmsr_peer_result_policy[NL80211_PMSR_PEER_ATTR_MAX + 1] =3D =
{
> > > > +     [NL80211_PMSR_PEER_ATTR_ADDR] =3D NLA_POLICY_ETH_ADDR_COMPAT,
> > > > +     [NL80211_PMSR_PEER_ATTR_CHAN] =3D { .type =3D NLA_REJECT },
> > > > +     [NL80211_PMSR_PEER_ATTR_REQ] =3D { .type =3D NLA_REJECT },
> > > > +     [NL80211_PMSR_PEER_ATTR_RESP] =3D NLA_POLICY_NESTED(hwsim_pms=
r_resp_policy),
> > > > +};
> > > > +
> > > > +static const struct nla_policy
> > > > +hwsim_pmsr_peers_result_policy[NL80211_PMSR_ATTR_MAX + 1] =3D {
> > > > +     [NL80211_PMSR_ATTR_MAX_PEERS] =3D { .type =3D NLA_REJECT },
> > > > +     [NL80211_PMSR_ATTR_REPORT_AP_TSF] =3D { .type =3D NLA_REJECT =
},
> > > > +     [NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR] =3D { .type =3D NLA_RE=
JECT },
> > > > +     [NL80211_PMSR_ATTR_TYPE_CAPA] =3D { .type =3D NLA_REJECT },
> > > > +     [NL80211_PMSR_ATTR_PEERS] =3D NLA_POLICY_NESTED_ARRAY(hwsim_p=
msr_peer_result_policy),
> > > > +};
> > > > +
> > > >  static const struct nla_policy
> > > >  hwsim_ftm_capa_policy[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1] =3D {
> > > >       [NL80211_PMSR_FTM_CAPA_ATTR_ASAP] =3D { .type =3D NLA_FLAG },
> > > > @@ -822,6 +897,7 @@ static const struct nla_policy hwsim_genl_polic=
y[HWSIM_ATTR_MAX + 1] =3D {
> > > >       [HWSIM_ATTR_CIPHER_SUPPORT] =3D { .type =3D NLA_BINARY },
> > > >       [HWSIM_ATTR_MLO_SUPPORT] =3D { .type =3D NLA_FLAG },
> > > >       [HWSIM_ATTR_PMSR_SUPPORT] =3D NLA_POLICY_NESTED(hwsim_pmsr_ca=
pa_policy),
> > > > +     [HWSIM_ATTR_PMSR_RESULT] =3D NLA_POLICY_NESTED(hwsim_pmsr_pee=
rs_result_policy),
> > > >  };
> > > >
> > > >  #if IS_REACHABLE(CONFIG_VIRTIO)
> > > > @@ -3403,6 +3479,292 @@ static void mac80211_hwsim_abort_pmsr(struc=
t ieee80211_hw *hw,
> > > >       mutex_unlock(&data->mutex);
> > > >  }
> > > >
> > > > +static int mac80211_hwsim_parse_rate_info(struct nlattr *rateattr,
> > > > +                                       struct rate_info *rate_info=
,
> > > > +                                       struct genl_info *info)
> > > > +{
> > > > +     struct nlattr *tb[HWSIM_RATE_INFO_ATTR_MAX + 1];
> > > > +     int ret;
> > > > +
> > > > +     ret =3D nla_parse_nested(tb, HWSIM_RATE_INFO_ATTR_MAX,
> > > > +                            rateattr, hwsim_rate_info_policy, info=
->extack);
> > > > +     if (ret)
> > > > +             return ret;
> > > > +
> > > > +     if (tb[HWSIM_RATE_INFO_ATTR_FLAGS])
> > > > +             rate_info->flags =3D nla_get_u8(tb[HWSIM_RATE_INFO_AT=
TR_FLAGS]);
> > > > +
> > > > +     if (tb[HWSIM_RATE_INFO_ATTR_MCS])
> > > > +             rate_info->mcs =3D nla_get_u8(tb[HWSIM_RATE_INFO_ATTR=
_MCS]);
> > > > +
> > > > +     if (tb[HWSIM_RATE_INFO_ATTR_LEGACY])
> > > > +             rate_info->legacy =3D nla_get_u16(tb[HWSIM_RATE_INFO_=
ATTR_LEGACY]);
> > > > +
> > > > +     if (tb[HWSIM_RATE_INFO_ATTR_NSS])
> > > > +             rate_info->nss =3D nla_get_u8(tb[HWSIM_RATE_INFO_ATTR=
_NSS]);
> > > > +
> > > > +     if (tb[HWSIM_RATE_INFO_ATTR_BW])
> > > > +             rate_info->bw =3D nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_=
BW]);
> > > > +
> > > > +     if (tb[HWSIM_RATE_INFO_ATTR_HE_GI])
> > > > +             rate_info->he_gi =3D nla_get_u8(tb[HWSIM_RATE_INFO_AT=
TR_HE_GI]);
> > > > +
> > > > +     if (tb[HWSIM_RATE_INFO_ATTR_HE_DCM])
> > > > +             rate_info->he_dcm =3D nla_get_u8(tb[HWSIM_RATE_INFO_A=
TTR_HE_DCM]);
> > > > +
> > > > +     if (tb[HWSIM_RATE_INFO_ATTR_HE_RU_ALLOC])
> > > > +             rate_info->he_ru_alloc =3D
> > > > +                     nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_HE_RU_ALLO=
C]);
> > > > +
> > > > +     if (tb[HWSIM_RATE_INFO_ATTR_N_BOUNDED_CH])
> > > > +             rate_info->n_bonded_ch =3D nla_get_u8(tb[HWSIM_RATE_I=
NFO_ATTR_N_BOUNDED_CH]);
> > > > +
> > > > +     if (tb[HWSIM_RATE_INFO_ATTR_EHT_GI])
> > > > +             rate_info->eht_gi =3D nla_get_u8(tb[HWSIM_RATE_INFO_A=
TTR_EHT_GI]);
> > > > +
> > > > +     if (tb[HWSIM_RATE_INFO_ATTR_EHT_RU_ALLOC])
> > > > +             rate_info->eht_ru_alloc =3D nla_get_u8(tb[HWSIM_RATE_=
INFO_ATTR_EHT_RU_ALLOC]);
> > > > +
> > > > +     return 0;
> > > > +}
> > >
> > > Lines in the function above often exceed 80 chars.
> > >
> > > > +
> > > > +static int mac80211_hwsim_parse_ftm_result(struct nlattr *ftm,
> > > > +                                        struct cfg80211_pmsr_ftm_r=
esult *result,
> > > > +                                        struct genl_info *info)
> > > > +{
> > > > +     struct nlattr *tb[NL80211_PMSR_FTM_RESP_ATTR_MAX + 1];
> > > > +     int ret;
> > > > +
> > > > +     ret =3D nla_parse_nested(tb, NL80211_PMSR_FTM_RESP_ATTR_MAX,
> > > > +                            ftm, hwsim_ftm_result_policy, info->ex=
tack);
> > > > +     if (ret)
> > > > +             return ret;
> > > > +
> > > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_FAIL_REASON])
> > > > +             result->failure_reason =3D nla_get_u32(tb[NL80211_PMS=
R_FTM_RESP_ATTR_FAIL_REASON]);
> > > > +
> > > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_BURST_INDEX])
> > > > +             result->burst_index =3D nla_get_u16(tb[NL80211_PMSR_F=
TM_RESP_ATTR_BURST_INDEX]);
> > > > +
> > > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_ATTEMPTS]) {
> > > > +             result->num_ftmr_attempts_valid =3D 1;
> > > > +             result->num_ftmr_attempts =3D
> > > > +                     nla_get_u32(tb[NL80211_PMSR_FTM_RESP_ATTR_NUM=
_FTMR_ATTEMPTS]);
> > > > +     }
> > > > +
> > > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_SUCCESSES]) {
> > > > +             result->num_ftmr_successes_valid =3D 1;
> > > > +             result->num_ftmr_successes =3D
> > > > +                     nla_get_u32(tb[NL80211_PMSR_FTM_RESP_ATTR_NUM=
_FTMR_SUCCESSES]);
> > > > +     }
> > > > +
> > > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_BUSY_RETRY_TIME])
> > > > +             result->busy_retry_time =3D
> > > > +                     nla_get_u8(tb[NL80211_PMSR_FTM_RESP_ATTR_BUSY=
_RETRY_TIME]);
> > > > +
> > > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_NUM_BURSTS_EXP])
> > > > +             result->num_bursts_exp =3D nla_get_u8(tb[NL80211_PMSR=
_FTM_RESP_ATTR_NUM_BURSTS_EXP]);
> > > > +
> > > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_BURST_DURATION])
> > > > +             result->burst_duration =3D nla_get_u8(tb[NL80211_PMSR=
_FTM_RESP_ATTR_BURST_DURATION]);
> > > > +
> > > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_FTMS_PER_BURST])
> > > > +             result->ftms_per_burst =3D nla_get_u8(tb[NL80211_PMSR=
_FTM_RESP_ATTR_FTMS_PER_BURST]);
> > > > +
> > > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_RSSI_AVG]) {
> > > > +             result->rssi_avg_valid =3D 1;
> > > > +             result->rssi_avg =3D nla_get_s32(tb[NL80211_PMSR_FTM_=
RESP_ATTR_RSSI_AVG]);
> > > > +     }
> > > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_RSSI_SPREAD]) {
> > > > +             result->rssi_spread_valid =3D 1;
> > > > +             result->rssi_spread =3D
> > > > +                     nla_get_s32(tb[NL80211_PMSR_FTM_RESP_ATTR_RSS=
I_SPREAD]);
> > > > +     }
> > > > +
> > > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_TX_RATE]) {
> > > > +             result->tx_rate_valid =3D 1;
> > > > +             ret =3D mac80211_hwsim_parse_rate_info(tb[NL80211_PMS=
R_FTM_RESP_ATTR_TX_RATE],
> > > > +                                                  &result->tx_rate=
, info);
> > > > +             if (ret)
> > > > +                     return ret;
> > > > +     }
> > > > +
> > > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_RX_RATE]) {
> > > > +             result->rx_rate_valid =3D 1;
> > > > +             ret =3D mac80211_hwsim_parse_rate_info(tb[NL80211_PMS=
R_FTM_RESP_ATTR_RX_RATE],
> > > > +                                                  &result->rx_rate=
, info);
> > > > +             if (ret)
> > > > +                     return ret;
> > > > +     }
> > > > +
> > > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_RTT_AVG]) {
> > > > +             result->rtt_avg_valid =3D 1;
> > > > +             result->rtt_avg =3D
> > > > +                     nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_RTT=
_AVG]);
> > > > +     }
> > > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_RTT_VARIANCE]) {
> > > > +             result->rtt_variance_valid =3D 1;
> > > > +             result->rtt_variance =3D
> > > > +                     nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_RTT=
_VARIANCE]);
> > > > +     }
> > > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_RTT_SPREAD]) {
> > > > +             result->rtt_spread_valid =3D 1;
> > > > +             result->rtt_spread =3D
> > > > +                     nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_RTT=
_SPREAD]);
> > > > +     }
> > > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_DIST_AVG]) {
> > > > +             result->dist_avg_valid =3D 1;
> > > > +             result->dist_avg =3D
> > > > +                     nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_DIS=
T_AVG]);
> > > > +     }
> > > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_DIST_VARIANCE]) {
> > > > +             result->dist_variance_valid =3D 1;
> > > > +             result->dist_variance =3D
> > > > +                     nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_DIS=
T_VARIANCE]);
> > > > +     }
> > > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_DIST_SPREAD]) {
> > > > +             result->dist_spread_valid =3D 1;
> > > > +             result->dist_spread =3D
> > > > +                     nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_DIS=
T_SPREAD]);
> > > > +     }
> > > > +
> > > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_LCI]) {
> > > > +             result->lci =3D nla_data(tb[NL80211_PMSR_FTM_RESP_ATT=
R_LCI]);
> > > > +             result->lci_len =3D nla_len(tb[NL80211_PMSR_FTM_RESP_=
ATTR_LCI]);
> > > > +     }
> > > > +
> > > > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_CIVICLOC]) {
> > > > +             result->civicloc =3D nla_data(tb[NL80211_PMSR_FTM_RES=
P_ATTR_CIVICLOC]);
> > > > +             result->civicloc_len =3D nla_len(tb[NL80211_PMSR_FTM_=
RESP_ATTR_CIVICLOC]);
> > > > +     }
> > > > +
> > > > +     return 0;
> > > > +}
> > > > +
> > > > +static int mac80211_hwsim_parse_pmsr_resp(struct nlattr *resp,
> > > > +                                       struct cfg80211_pmsr_result=
 *result,
> > > > +                                       struct genl_info *info)
> > > > +{
> > > > +     struct nlattr *tb[NL80211_PMSR_RESP_ATTR_MAX + 1];
> > > > +     struct nlattr *pmsr;
> > > > +     int rem;
> > > > +     int ret;
> > > > +
> > > > +     ret =3D nla_parse_nested(tb, NL80211_PMSR_RESP_ATTR_MAX, resp=
,
> > > > +                            hwsim_pmsr_resp_policy, info->extack);
> > >
> > > You are assigning the value to "ret" variable but you are never using
> > > it. Is the check for "ret" missing?
> > >
> > > > +
> > > > +     if (tb[NL80211_PMSR_RESP_ATTR_STATUS])
> > > > +             result->status =3D nla_get_u32(tb[NL80211_PMSR_RESP_A=
TTR_STATUS]);
> > > > +
> > > > +     if (tb[NL80211_PMSR_RESP_ATTR_HOST_TIME])
> > > > +             result->host_time =3D nla_get_u64(tb[NL80211_PMSR_RES=
P_ATTR_HOST_TIME]);
> > > > +
> > > > +     if (tb[NL80211_PMSR_RESP_ATTR_AP_TSF]) {
> > > > +             result->ap_tsf_valid =3D 1;
> > > > +             result->ap_tsf =3D nla_get_u64(tb[NL80211_PMSR_RESP_A=
TTR_AP_TSF]);
> > > > +     }
> > > > +
> > > > +     result->final =3D !!tb[NL80211_PMSR_RESP_ATTR_FINAL];
> > > > +
> > > > +     if (tb[NL80211_PMSR_RESP_ATTR_DATA]) {
> > >
> > > How about using a negative logic in here to decrease indentation?
> > > For example:
> > >
> > >         if (!tb[NL80211_PMSR_RESP_ATTR_DATA])
> > >                 return ret;
> > >
> > > > +             nla_for_each_nested(pmsr, tb[NL80211_PMSR_RESP_ATTR_D=
ATA], rem) {
> > > > +                     switch (nla_type(pmsr)) {
> > > > +                     case NL80211_PMSR_TYPE_FTM:
> > > > +                             result->type =3D NL80211_PMSR_TYPE_FT=
M;
> > > > +                             ret =3D mac80211_hwsim_parse_ftm_resu=
lt(pmsr, &result->ftm, info);
> > > > +                             if (ret)
> > > > +                                     return ret;
> > > > +                             break;
> > > > +                     default:
> > > > +                             NL_SET_ERR_MSG_ATTR(info->extack, pms=
r, "Unknown pmsr resp type");
> > > > +                             return -EINVAL;
> > > > +                     }
> > > > +             }
> > > > +     }
> > > > +
> > > > +     return 0;
> > > > +}
> > > > +
> > > > +static int mac80211_hwsim_parse_pmsr_result(struct nlattr *peer,
> > > > +                                         struct cfg80211_pmsr_resu=
lt *result,
> > > > +                                         struct genl_info *info)
> > > > +{
> > > > +     struct nlattr *tb[NL80211_PMSR_PEER_ATTR_MAX + 1];
> > > > +     int ret;
> > > > +
> > > > +     if (!peer)
> > > > +             return -EINVAL;
> > > > +
> > > > +     ret =3D nla_parse_nested(tb, NL80211_PMSR_PEER_ATTR_MAX, peer=
,
> > > > +                            hwsim_pmsr_peer_result_policy, info->e=
xtack);
> > > > +     if (ret)
> > > > +             return ret;
> > > > +
> > > > +     if (tb[NL80211_PMSR_PEER_ATTR_ADDR])
> > > > +             memcpy(result->addr, nla_data(tb[NL80211_PMSR_PEER_AT=
TR_ADDR]),
> > > > +                    ETH_ALEN);
> > > > +
> > > > +     if (tb[NL80211_PMSR_PEER_ATTR_RESP]) {
> > > > +             ret =3D mac80211_hwsim_parse_pmsr_resp(tb[NL80211_PMS=
R_PEER_ATTR_RESP], result, info);
> > > > +             if (ret)
> > > > +                     return ret;
> > > > +     }
> > > > +
> > > > +     return 0;
> > > > +};
> > > > +
> > > > +static int hwsim_pmsr_report_nl(struct sk_buff *msg, struct genl_i=
nfo *info)
> > > > +{
> > > > +     struct nlattr *reqattr;
> > > > +     const u8 *src;
> > > > +     int err, rem;
> > > > +     struct nlattr *peers, *peer;
> > > > +     struct mac80211_hwsim_data *data;
> > >
> > > Please use RCT formatting.
> > >
> > > > +
> > > > +     src =3D nla_data(info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER]);
> > > > +     data =3D get_hwsim_data_ref_from_addr(src);
> > > > +     if (!data)
> > > > +             return -EINVAL;
> > > > +
> > > > +     mutex_lock(&data->mutex);
> > > > +     if (!data->pmsr_request) {
> > > > +             err =3D -EINVAL;
> > > > +             goto out_err;
> > > > +     }
> > > > +
> > > > +     reqattr =3D info->attrs[HWSIM_ATTR_PMSR_RESULT];
> > > > +     if (!reqattr) {
> > > > +             err =3D -EINVAL;
> > > > +             goto out_err;
> > > > +     }
> > > > +
> > > > +     peers =3D nla_find_nested(reqattr, NL80211_PMSR_ATTR_PEERS);
> > > > +     if (!peers) {
> > > > +             err =3D -EINVAL;
> > > > +             goto out_err;
> > > > +     }
> > > > +
> > > > +     nla_for_each_nested(peer, peers, rem) {
> > > > +             struct cfg80211_pmsr_result result;
> > > > +
> > > > +             err =3D mac80211_hwsim_parse_pmsr_result(peer, &resul=
t, info);
> > > > +             if (err)
> > > > +                     goto out_err;
> > > > +
> > > > +             cfg80211_pmsr_report(data->pmsr_request_wdev,
> > > > +                                  data->pmsr_request, &result, GFP=
_KERNEL);
> > > > +     }
> > > > +
> > > > +     cfg80211_pmsr_complete(data->pmsr_request_wdev, data->pmsr_re=
quest, GFP_KERNEL);
> > > > +
> > > > +out_err:
> > >
> > > How about renaming this label to "out" or "exit"?
> > > The code below is used for error path as well as for a normal path.
> > >
> > > > +     data->pmsr_request =3D NULL;
> > > > +     data->pmsr_request_wdev =3D NULL;
> > > > +
> > > > +     mutex_unlock(&data->mutex);
> > > > +     return err;
> > > > +}
> > > > +
> > > >  #define HWSIM_COMMON_OPS                                     \
> > > >       .tx =3D mac80211_hwsim_tx,                                \
> > > >       .wake_tx_queue =3D ieee80211_handle_wake_tx_queue,        \
> > > > @@ -5072,13 +5434,6 @@ static void hwsim_mon_setup(struct net_devic=
e *dev)
> > > >       eth_hw_addr_set(dev, addr);
> > > >  }
> > > >
> > > > -static struct mac80211_hwsim_data *get_hwsim_data_ref_from_addr(co=
nst u8 *addr)
> > > > -{
> > > > -     return rhashtable_lookup_fast(&hwsim_radios_rht,
> > > > -                                   addr,
> > > > -                                   hwsim_rht_params);
> > > > -}
> > > > -
> > > >  static void hwsim_register_wmediumd(struct net *net, u32 portid)
> > > >  {
> > > >       struct mac80211_hwsim_data *data;
> > > > @@ -5746,6 +6101,11 @@ static const struct genl_small_ops hwsim_ops=
[] =3D {
> > > >               .doit =3D hwsim_get_radio_nl,
> > > >               .dumpit =3D hwsim_dump_radio_nl,
> > > >       },
> > > > +     {
> > > > +             .cmd =3D HWSIM_CMD_REPORT_PMSR,
> > > > +             .validate =3D GENL_DONT_VALIDATE_STRICT | GENL_DONT_V=
ALIDATE_DUMP,
> > > > +             .doit =3D hwsim_pmsr_report_nl,
> > > > +     },
> > > >  };
> > > >
> > > >  static struct genl_family hwsim_genl_family __ro_after_init =3D {
> > > > @@ -5757,7 +6117,7 @@ static struct genl_family hwsim_genl_family _=
_ro_after_init =3D {
> > > >       .module =3D THIS_MODULE,
> > > >       .small_ops =3D hwsim_ops,
> > > >       .n_small_ops =3D ARRAY_SIZE(hwsim_ops),
> > > > -     .resv_start_op =3D HWSIM_CMD_DEL_MAC_ADDR + 1,
> > > > +     .resv_start_op =3D HWSIM_CMD_REPORT_PMSR + 1, // match with _=
_HWSIM_CMD_MAX
> > >
> > >
> > > >       .mcgrps =3D hwsim_mcgrps,
> > > >       .n_mcgrps =3D ARRAY_SIZE(hwsim_mcgrps),
> > > >  };
> > > > @@ -5926,6 +6286,9 @@ static int hwsim_virtio_handle_cmd(struct sk_=
buff *skb)
> > > >       case HWSIM_CMD_TX_INFO_FRAME:
> > > >               hwsim_tx_info_frame_received_nl(skb, &info);
> > > >               break;
> > > > +     case HWSIM_CMD_REPORT_PMSR:
> > > > +             hwsim_pmsr_report_nl(skb, &info);
> > > > +             break;
> > > >       default:
> > > >               pr_err_ratelimited("hwsim: invalid cmd: %d\n", gnlh->=
cmd);
> > > >               return -EPROTO;
> > > > diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wi=
reless/mac80211_hwsim.h
> > > > index 383f3e39c911..92126f02c58f 100644
> > > > --- a/drivers/net/wireless/mac80211_hwsim.h
> > > > +++ b/drivers/net/wireless/mac80211_hwsim.h
> > > > @@ -82,8 +82,8 @@ enum hwsim_tx_control_flags {
> > > >   * @HWSIM_CMD_DEL_MAC_ADDR: remove the MAC address again, the attr=
ibutes
> > > >   *   are the same as to @HWSIM_CMD_ADD_MAC_ADDR.
> > > >   * @HWSIM_CMD_START_PMSR: request to start peer measurement with t=
he
> > > > - *   %HWSIM_ATTR_PMSR_REQUEST.
> > > > - * @HWSIM_CMD_ABORT_PMSR: abort previously sent peer measurement
> > > > + *   %HWSIM_ATTR_PMSR_REQUEST. Result will be sent back asynchrono=
usly
> > > > + *   with %HWSIM_CMD_REPORT_PMSR.
> > > >   * @__HWSIM_CMD_MAX: enum limit
> > > >   */
> > > >  enum {
> > > > @@ -98,6 +98,7 @@ enum {
> > > >       HWSIM_CMD_DEL_MAC_ADDR,
> > > >       HWSIM_CMD_START_PMSR,
> > > >       HWSIM_CMD_ABORT_PMSR,
> > > > +     HWSIM_CMD_REPORT_PMSR,
> > > >       __HWSIM_CMD_MAX,
> > > >  };
> > > >  #define HWSIM_CMD_MAX (_HWSIM_CMD_MAX - 1)
> > > > @@ -151,6 +152,8 @@ enum {
> > > >   *   to provide peer measurement capabilities. (nl80211_peer_measu=
rement_attrs)
> > > >   * @HWSIM_ATTR_PMSR_REQUEST: nested attribute used with %HWSIM_CMD=
_START_PMSR
> > > >   *   to provide details about peer measurement request (nl80211_pe=
er_measurement_attrs)
> > > > + * @HWSIM_ATTR_PMSR_RESULT: nested attributed used with %HWSIM_CMD=
_REPORT_PMSR
> > > > + *   to provide peer measurement result (nl80211_peer_measurement_=
attrs)
> > > >   * @__HWSIM_ATTR_MAX: enum limit
> > > >   */
> > > >
> > > > @@ -184,6 +187,7 @@ enum {
> > > >       HWSIM_ATTR_MLO_SUPPORT,
> > > >       HWSIM_ATTR_PMSR_SUPPORT,
> > > >       HWSIM_ATTR_PMSR_REQUEST,
> > > > +     HWSIM_ATTR_PMSR_RESULT,
> > > >       __HWSIM_ATTR_MAX,
> > > >  };
> > > >  #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
> > > > @@ -288,4 +292,47 @@ enum {
> > > >       HWSIM_VQ_RX,
> > > >       HWSIM_NUM_VQS,
> > > >  };
> > > > +
> > > > +/**
> > > > + * enum hwsim_rate_info -- bitrate information.
> > > > + *
> > > > + * Information about a receiving or transmitting bitrate
> > > > + * that can be mapped to struct rate_info
> > > > + *
> > > > + * @HWSIM_RATE_INFO_ATTR_FLAGS: bitflag of flags from &enum rate_i=
nfo_flags
> > > > + * @HWSIM_RATE_INFO_ATTR_MCS: mcs index if struct describes an HT/=
VHT/HE rate
> > > > + * @HWSIM_RATE_INFO_ATTR_LEGACY: bitrate in 100kbit/s for 802.11ab=
g
> > > > + * @HWSIM_RATE_INFO_ATTR_NSS: number of streams (VHT & HE only)
> > > > + * @HWSIM_RATE_INFO_ATTR_BW: bandwidth (from &enum rate_info_bw)
> > > > + * @HWSIM_RATE_INFO_ATTR_HE_GI: HE guard interval (from &enum nl80=
211_he_gi)
> > > > + * @HWSIM_RATE_INFO_ATTR_HE_DCM: HE DCM value
> > > > + * @HWSIM_RATE_INFO_ATTR_HE_RU_ALLOC:  HE RU allocation (from &enu=
m nl80211_he_ru_alloc,
> > > > + *   only valid if bw is %RATE_INFO_BW_HE_RU)
> > > > + * @HWSIM_RATE_INFO_ATTR_N_BOUNDED_CH: In case of EDMG the number =
of bonded channels (1-4)
> > > > + * @HWSIM_RATE_INFO_ATTR_EHT_GI: EHT guard interval (from &enum nl=
80211_eht_gi)
> > > > + * @HWSIM_RATE_INFO_ATTR_EHT_RU_ALLOC: EHT RU allocation (from &en=
um nl80211_eht_ru_alloc,
> > > > + *   only valid if bw is %RATE_INFO_BW_EHT_RU)
> > > > + * @NUM_HWSIM_RATE_INFO_ATTRS: internal
> > > > + * @HWSIM_RATE_INFO_ATTR_MAX: highest attribute number
> > > > + */
> > > > +enum hwsim_rate_info_attributes {
> > > > +     __HWSIM_RATE_INFO_ATTR_INVALID,
> > > > +
> > > > +     HWSIM_RATE_INFO_ATTR_FLAGS,
> > > > +     HWSIM_RATE_INFO_ATTR_MCS,
> > > > +     HWSIM_RATE_INFO_ATTR_LEGACY,
> > > > +     HWSIM_RATE_INFO_ATTR_NSS,
> > > > +     HWSIM_RATE_INFO_ATTR_BW,
> > > > +     HWSIM_RATE_INFO_ATTR_HE_GI,
> > > > +     HWSIM_RATE_INFO_ATTR_HE_DCM,
> > > > +     HWSIM_RATE_INFO_ATTR_HE_RU_ALLOC,
> > > > +     HWSIM_RATE_INFO_ATTR_N_BOUNDED_CH,
> > > > +     HWSIM_RATE_INFO_ATTR_EHT_GI,
> > > > +     HWSIM_RATE_INFO_ATTR_EHT_RU_ALLOC,
> > > > +
> > > > +     /* keep last */
> > > > +     NUM_HWSIM_RATE_INFO_ATTRS,
> > > > +     HWSIM_RATE_INFO_ATTR_MAX =3D NUM_HWSIM_RATE_INFO_ATTRS - 1
> > > > +};
> > > > +
> > > >  #endif /* __MAC80211_HWSIM_H */
> > > > --
> > > > 2.40.0.rc1.284.g88254d51c5-goog
> > > >
> >
> > Many Thanks,
> >
> > --
> > Jaewan Kim (=EA=B9=80=EC=9E=AC=EC=99=84) | Software Engineer in Google =
Korea |
> > jaewan@google.com | +82-10-2781-5078

Done for everything except for line limits.
Thank you for the reviews.


--
Jaewan Kim (=EA=B9=80=EC=9E=AC=EC=99=84) | Software Engineer in Google Kore=
a |
jaewan@google.com | +82-10-2781-5078
