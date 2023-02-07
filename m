Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCFE68D1EA
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 09:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbjBGI71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 03:59:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjBGI70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 03:59:26 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB04910253
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 00:59:24 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id 74so17417790ybl.12
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 00:59:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CaxS6EpL5w6ocG82blrMmstWHwofs6k8a+tRF9LfQDw=;
        b=f1PljROUghLMjMFQFCc3rxdCf0fbesaR2LMygx9C0rh1uSycFW8UXht2PTs1NoNTtz
         BKJaMfMchRDvSELPU8VFfAiaqaw1F6CEX2iewr0TeY0XJiTYjHE5+IThvIY6/ZqAqx4b
         09UQYjLpXIGpxLHk56nYwUebeuINZei+d5gohvZs3Vz+T99Qmmy4EjzLhCYvYIaRul6R
         ucjJzjXABN1tlkiBFo1qeJb4x7a8AS59zGizmg2QQ9OO8LGavPQeNtcnt8+CXdosguID
         SYP4kP9Vt8ccLhvVqVUfnQ8zkiZxwN8zbQmnp8g84jlTHss5EeSCdI8bDJTHybDSG96S
         NXkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CaxS6EpL5w6ocG82blrMmstWHwofs6k8a+tRF9LfQDw=;
        b=Wqw+CDOqkFaNRLj/imAGlxFYvfL05a8Mz4HknBaqM2YViF/TKHUbKJtwriiLMDT6kO
         ViBLuJFbyl+XKegD6rF3pyrm0OemPobDcS7OCU15DwIBfjyBVoe2FzXSu8+rn7vCYDlb
         zNkufBL/zycZSW/x74D64ZpaHHqsRIltQSgfswljHKR2jkmyD25MwZyc9sesBx5cSyU+
         Ts9QqDK4898a6aV1uzpEnLVIyiLiwTwnTgLZWJZsIJ90CqCdlC+JegKWNvhTTA6ByGz5
         O0asjeUYVK9XrgYTA5AN7J/BmzPqILqiUE7y2eX8B7haLUz9GtUVTk3Lf9iNxuuAilkZ
         ODJA==
X-Gm-Message-State: AO0yUKX0I8ZqOhFpw6j7dDEhmj4U6HscELVkT4C20U6li4dWS55VRgHW
        lXem/KNsRO8TqTclVJcYHPFOdjl/y/9aBKkDrwLxAg==
X-Google-Smtp-Source: AK7set+mURMiiklEZ3l7JY6AkL8LYf7S/aS0Emv1Lx6jL/BBt2uH3fzDES/vWEjcpvGhcuW1EOcZVkJKkmzTGJLIg5s=
X-Received: by 2002:a25:4212:0:b0:7cc:bda4:1bf6 with SMTP id
 p18-20020a254212000000b007ccbda41bf6mr261169yba.220.1675760363767; Tue, 07
 Feb 2023 00:59:23 -0800 (PST)
MIME-Version: 1.0
References: <20230124145430.365495-1-jaewan@google.com> <20230124145430.365495-3-jaewan@google.com>
 <Y8/+duv3y1drM5Wm@kroah.com>
In-Reply-To: <Y8/+duv3y1drM5Wm@kroah.com>
From:   Jaewan Kim <jaewan@google.com>
Date:   Tue, 7 Feb 2023 17:59:12 +0900
Message-ID: <CABZjns6mAVDL+wHjzKE09kHzPL-9NA3CSAPGmKvegSmOsUOjcA@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] mac80211_hwsim: handle FTM requests with virtio
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
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

On Wed, Jan 25, 2023 at 12:51 AM Greg KH <gregkh@linuxfoundation.org> wrote=
:
>
> On Tue, Jan 24, 2023 at 02:54:30PM +0000, Jaewan Kim wrote:
> > This CL allows mac80211_hwsim to receive FTM request and send FTM respo=
nse.
>
> What is a "CL"?
>
> What is "FTM"?
FTM (fine time measurement) is measuring time between two Wi-Fi devices wit=
h .
Added the description to this commit message, in addition to the cover rati=
on.

>
> And why is this line not wrapped at 72 columns like your editor asked
> you do when you committed it?  :)
>
> > It passthrough request to wmediumd and gets response with virtio
> > to get the FTM information with another STA.
>
> What is "STA"?
It's an abbreviation of station, and it means Wi-Fi enabled device.
(term from IEEE 802.11 spec).
Changed to use simpler terms.

>
> >
> > This CL adds following commands
>
> Again, what is "CL"?
>
> >  - HWSIM_CMD_START_PMSR: To send request to wmediumd
> >  - HWSIM_CMD_ABORT_PMSR: To send abort to wmediumd
> >  - HWSIM_CMD_REPORT_PMSR: To receive response from wmediumd
>
> Why isn't this 3 different patches?  One per thing you are adding?

Let me split and upload the next patches.

>
> > Request and response are formatted the same way as pmsr.c.
> > One exception is for sending rate_info -- hwsim_rate_info_attributes is
> > added to send rate_info as is.
>
> I do not understand what this last sentence means, sorry.
>
> >
> > Signed-off-by: Jaewan Kim <jaewan@google.com>
> > ---
> > V5 -> V6: Added per change patch history.
> > V4 -> V5: N/A.
> > V3 -> V4: Added more comments about new commands in mac80211_hwsim.
> > V1 -> V3: Initial commit (includes resends).
> > ---
> >  drivers/net/wireless/mac80211_hwsim.c | 679 +++++++++++++++++++++++-
> >  drivers/net/wireless/mac80211_hwsim.h |  54 +-
> >  include/net/cfg80211.h                |  10 +
> >  net/wireless/nl80211.c                |  11 +-
> >  4 files changed, 737 insertions(+), 17 deletions(-)
> >
> > diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wirele=
ss/mac80211_hwsim.c
> > index 84c9db9178c3..4191037f73b6 100644
> > --- a/drivers/net/wireless/mac80211_hwsim.c
> > +++ b/drivers/net/wireless/mac80211_hwsim.c
> > @@ -721,6 +721,8 @@ struct mac80211_hwsim_data {
> >
> >       /* only used when pmsr capability is supplied */
> >       struct cfg80211_pmsr_capabilities pmsr_capa;
> > +     struct cfg80211_pmsr_request *pmsr_request;
> > +     struct wireless_dev *pmsr_request_wdev;
> >
> >       struct mac80211_hwsim_link_data link_data[IEEE80211_MLD_MAX_NUM_L=
INKS];
> >  };
> > @@ -750,6 +752,13 @@ struct hwsim_radiotap_ack_hdr {
> >       __le16 rt_chbitmask;
> >  } __packed;
> >
> > +static struct mac80211_hwsim_data *get_hwsim_data_ref_from_addr(const =
u8 *addr)
> > +{
> > +     return rhashtable_lookup_fast(&hwsim_radios_rht,
> > +                                   addr,
> > +                                   hwsim_rht_params);
>
> Odd line wrapping :(

Done.

>
> > +}
> > +
> >  /* MAC80211_HWSIM netlink family */
> >  static struct genl_family hwsim_genl_family;
> >
> > @@ -763,6 +772,81 @@ static const struct genl_multicast_group hwsim_mcg=
rps[] =3D {
> >
> >  /* MAC80211_HWSIM netlink policy */
> >
> > +static const struct nla_policy
> > +hwsim_rate_info_policy[HWSIM_RATE_INFO_ATTR_MAX + 1] =3D {
> > +     [HWSIM_RATE_INFO_ATTR_FLAGS] =3D { .type =3D NLA_U8 },
> > +     [HWSIM_RATE_INFO_ATTR_MCS] =3D { .type =3D NLA_U8 },
> > +     [HWSIM_RATE_INFO_ATTR_LEGACY] =3D { .type =3D NLA_U16 },
> > +     [HWSIM_RATE_INFO_ATTR_NSS] =3D { .type =3D NLA_U8 },
> > +     [HWSIM_RATE_INFO_ATTR_BW] =3D { .type =3D NLA_U8 },
> > +     [HWSIM_RATE_INFO_ATTR_HE_GI] =3D { .type =3D NLA_U8 },
> > +     [HWSIM_RATE_INFO_ATTR_HE_DCM] =3D { .type =3D NLA_U8 },
> > +     [HWSIM_RATE_INFO_ATTR_HE_RU_ALLOC] =3D { .type =3D NLA_U8 },
> > +     [HWSIM_RATE_INFO_ATTR_N_BOUNDED_CH] =3D { .type =3D NLA_U8 },
> > +     [HWSIM_RATE_INFO_ATTR_EHT_GI] =3D { .type =3D NLA_U8 },
> > +     [HWSIM_RATE_INFO_ATTR_EHT_RU_ALLOC] =3D { .type =3D NLA_U8 },
> > +};
> > +
> > +static const struct nla_policy
> > +hwsim_ftm_result_policy[NL80211_PMSR_FTM_RESP_ATTR_MAX + 1] =3D {
> > +     [NL80211_PMSR_FTM_RESP_ATTR_FAIL_REASON] =3D { .type =3D NLA_U32 =
},
> > +     [NL80211_PMSR_FTM_RESP_ATTR_BURST_INDEX] =3D { .type =3D NLA_U16 =
},
> > +     [NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_ATTEMPTS] =3D { .type =3D NL=
A_U32 },
> > +     [NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_SUCCESSES] =3D { .type =3D N=
LA_U32 },
> > +     [NL80211_PMSR_FTM_RESP_ATTR_BUSY_RETRY_TIME] =3D { .type =3D NLA_=
U8 },
> > +     [NL80211_PMSR_FTM_RESP_ATTR_NUM_BURSTS_EXP] =3D { .type =3D NLA_U=
8 },
> > +     [NL80211_PMSR_FTM_RESP_ATTR_BURST_DURATION] =3D { .type =3D NLA_U=
8 },
> > +     [NL80211_PMSR_FTM_RESP_ATTR_FTMS_PER_BURST] =3D { .type =3D NLA_U=
8 },
> > +     [NL80211_PMSR_FTM_RESP_ATTR_RSSI_AVG] =3D { .type =3D NLA_U32 },
> > +     [NL80211_PMSR_FTM_RESP_ATTR_RSSI_SPREAD] =3D { .type =3D NLA_U32 =
},
> > +     [NL80211_PMSR_FTM_RESP_ATTR_TX_RATE] =3D
> > +             NLA_POLICY_NESTED(hwsim_rate_info_policy),
> > +     [NL80211_PMSR_FTM_RESP_ATTR_RX_RATE] =3D
> > +             NLA_POLICY_NESTED(hwsim_rate_info_policy),
> > +     [NL80211_PMSR_FTM_RESP_ATTR_RTT_AVG] =3D { .type =3D NLA_U64 },
> > +     [NL80211_PMSR_FTM_RESP_ATTR_RTT_VARIANCE] =3D { .type =3D NLA_U64=
 },
> > +     [NL80211_PMSR_FTM_RESP_ATTR_RTT_SPREAD] =3D { .type =3D NLA_U64 }=
,
> > +     [NL80211_PMSR_FTM_RESP_ATTR_DIST_AVG] =3D { .type =3D NLA_U64 },
> > +     [NL80211_PMSR_FTM_RESP_ATTR_DIST_VARIANCE] =3D { .type =3D NLA_U6=
4 },
> > +     [NL80211_PMSR_FTM_RESP_ATTR_DIST_SPREAD] =3D { .type =3D NLA_U64 =
},
> > +     [NL80211_PMSR_FTM_RESP_ATTR_LCI] =3D { .type =3D NLA_STRING },
> > +     [NL80211_PMSR_FTM_RESP_ATTR_CIVICLOC] =3D { .type =3D NLA_STRING =
},
> > +};
> > +
> > +static const struct nla_policy
> > +hwsim_pmsr_resp_type_policy[NL80211_PMSR_TYPE_MAX + 1] =3D {
> > +     [NL80211_PMSR_TYPE_FTM] =3D NLA_POLICY_NESTED(hwsim_ftm_result_po=
licy),
> > +};
> > +
> > +static const struct nla_policy
> > +hwsim_pmsr_resp_policy[NL80211_PMSR_RESP_ATTR_MAX + 1] =3D {
> > +     [NL80211_PMSR_RESP_ATTR_STATUS] =3D { .type =3D NLA_U32 },
> > +     [NL80211_PMSR_RESP_ATTR_HOST_TIME] =3D { .type =3D NLA_U64 },
> > +     [NL80211_PMSR_RESP_ATTR_AP_TSF] =3D { .type =3D NLA_U64 },
> > +     [NL80211_PMSR_RESP_ATTR_FINAL] =3D { .type =3D NLA_FLAG },
> > +     [NL80211_PMSR_RESP_ATTR_DATA] =3D
> > +             NLA_POLICY_NESTED(hwsim_pmsr_resp_type_policy),
>
> Are you sure these line-wraps are needed?  We can go to 100 columns now,
> right?

Done for here and other places.

>
> > +};
> > +
> > +static const struct nla_policy
> > +hwsim_pmsr_peer_result_policy[NL80211_PMSR_PEER_ATTR_MAX + 1] =3D {
> > +     [NL80211_PMSR_PEER_ATTR_ADDR] =3D NLA_POLICY_ETH_ADDR_COMPAT,
> > +     [NL80211_PMSR_PEER_ATTR_CHAN] =3D { .type =3D NLA_REJECT },
> > +     [NL80211_PMSR_PEER_ATTR_REQ] =3D { .type =3D NLA_REJECT },
> > +     [NL80211_PMSR_PEER_ATTR_RESP] =3D
> > +             NLA_POLICY_NESTED(hwsim_pmsr_resp_policy),
> > +};
> > +
> > +static const struct nla_policy
> > +hwsim_pmsr_peers_result_policy[NL80211_PMSR_ATTR_MAX + 1] =3D {
> > +     [NL80211_PMSR_ATTR_MAX_PEERS] =3D { .type =3D NLA_REJECT },
> > +     [NL80211_PMSR_ATTR_REPORT_AP_TSF] =3D { .type =3D NLA_REJECT },
> > +     [NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR] =3D { .type =3D NLA_REJECT=
 },
> > +     [NL80211_PMSR_ATTR_TYPE_CAPA] =3D { .type =3D NLA_REJECT },
> > +     [NL80211_PMSR_ATTR_PEERS] =3D
> > +             NLA_POLICY_NESTED_ARRAY(hwsim_pmsr_peer_result_policy),
> > +};
> > +
> >  static const struct nla_policy
> >  hwsim_ftm_capa_policy[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1] =3D {
> >       [NL80211_PMSR_FTM_CAPA_ATTR_ASAP] =3D { .type =3D NLA_FLAG },
> > @@ -780,7 +864,7 @@ hwsim_ftm_capa_policy[NL80211_PMSR_FTM_CAPA_ATTR_MA=
X + 1] =3D {
> >  };
> >
> >  static const struct nla_policy
> > -hwsim_pmsr_type_policy[NL80211_PMSR_TYPE_MAX + 1] =3D {
> > +hwsim_pmsr_capa_type_policy[NL80211_PMSR_TYPE_MAX + 1] =3D {
> >       [NL80211_PMSR_TYPE_FTM] =3D NLA_POLICY_NESTED(hwsim_ftm_capa_poli=
cy),
> >  };
> >
> > @@ -790,7 +874,7 @@ hwsim_pmsr_capa_policy[NL80211_PMSR_ATTR_MAX + 1] =
=3D {
> >       [NL80211_PMSR_ATTR_REPORT_AP_TSF] =3D { .type =3D NLA_FLAG },
> >       [NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR] =3D { .type =3D NLA_FLAG }=
,
> >       [NL80211_PMSR_ATTR_TYPE_CAPA] =3D
> > -             NLA_POLICY_NESTED(hwsim_pmsr_type_policy),
> > +             NLA_POLICY_NESTED(hwsim_pmsr_capa_type_policy),
> >       [NL80211_PMSR_ATTR_PEERS] =3D { .type =3D NLA_REJECT }, // only f=
or request.
> >  };
> >
> > @@ -823,6 +907,7 @@ static const struct nla_policy hwsim_genl_policy[HW=
SIM_ATTR_MAX + 1] =3D {
> >       [HWSIM_ATTR_CIPHER_SUPPORT] =3D { .type =3D NLA_BINARY },
> >       [HWSIM_ATTR_MLO_SUPPORT] =3D { .type =3D NLA_FLAG },
> >       [HWSIM_ATTR_PMSR_SUPPORT] =3D NLA_POLICY_NESTED(hwsim_pmsr_capa_p=
olicy),
> > +     [HWSIM_ATTR_PMSR_RESULT] =3D NLA_POLICY_NESTED(hwsim_pmsr_peers_r=
esult_policy),
> >  };
> >
> >  #if IS_REACHABLE(CONFIG_VIRTIO)
> > @@ -3142,16 +3227,578 @@ static int mac80211_hwsim_change_sta_links(str=
uct ieee80211_hw *hw,
> >       return 0;
> >  }
> >
> > -static int mac80211_hwsim_start_pmsr(struct ieee80211_hw *hw, struct i=
eee80211_vif *vif,
> > +static int mac80211_hwsim_send_pmsr_ftm_request_peer(struct sk_buff *m=
sg,
> > +                                                  struct cfg80211_pmsr=
_ftm_request_peer *request)
> > +{
> > +     void *ftm;
>
> Are you sure this is void?  Why isn't this a pointer to a real structure
> that you are asking for?

Done.

>
> > +
> > +     if (!request || !request->requested)
> > +             return -EINVAL;
>
> How can these happen?

I agree, and I think that the field `requested` seems useless.
But let me check the variable as long as it exists and existing code
sets the value to `true` in pmsr.c.

>
> > +
> > +     ftm =3D nla_nest_start(msg, NL80211_PMSR_TYPE_FTM);
> > +     if (!ftm)
> > +             return -ENOBUFS;
> > +
> > +     if (nla_put_u32(msg, NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE,
> > +                     request->preamble))
> > +             return -ENOBUFS;
> > +
> > +     if (nla_put_u16(msg, NL80211_PMSR_FTM_REQ_ATTR_BURST_PERIOD,
> > +                     request->burst_period))
> > +             return -ENOBUFS;
> > +
> > +     if (request->asap &&
> > +         nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_ASAP))
> > +             return -ENOBUFS;
> > +
> > +     if (request->request_lci &&
> > +         nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_REQUEST_LCI))
> > +             return -ENOBUFS;
> > +
> > +     if (request->request_civicloc &&
> > +         nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_REQUEST_CIVICLOC)=
)
> > +             return -ENOBUFS;
> > +
> > +     if (request->trigger_based &&
> > +         nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_TRIGGER_BASED))
> > +             return -ENOBUFS;
> > +
> > +     if (request->non_trigger_based &&
> > +         nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_NON_TRIGGER_BASED=
))
> > +             return -ENOBUFS;
> > +
> > +     if (request->lmr_feedback &&
> > +         nla_put_flag(msg, NL80211_PMSR_FTM_REQ_ATTR_LMR_FEEDBACK))
> > +             return -ENOBUFS;
> > +
> > +     if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_NUM_BURSTS_EXP,
> > +                    request->num_bursts_exp))
> > +             return -ENOBUFS;
> > +
> > +     if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_BURST_DURATION,
> > +                    request->burst_duration))
> > +             return -ENOBUFS;
> > +
> > +     if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_FTMS_PER_BURST,
> > +                    request->ftms_per_burst))
> > +             return -ENOBUFS;
> > +
> > +     if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_NUM_FTMR_RETRIES,
> > +                    request->ftmr_retries))
> > +             return -ENOBUFS;
> > +
> > +     if (nla_put_u8(msg, NL80211_PMSR_FTM_REQ_ATTR_BSS_COLOR,
> > +                    request->bss_color))
> > +             return -ENOBUFS;
> > +
> > +     nla_nest_end(msg, ftm);
> > +
> > +     return 0;
> > +}
> > +
> > +static int mac80211_hwsim_send_pmsr_request_peer(struct sk_buff *msg,
> > +                                              struct cfg80211_pmsr_req=
uest_peer *request)
> > +{
> > +     void *peer, *chandef, *req, *data;
>
> Same here, why void * when you konw the types being used?
Done.
>
> > +     int err;
> > +
> > +     peer =3D nla_nest_start(msg, NL80211_PMSR_ATTR_PEERS);
> > +     if (!peer)
> > +             return -ENOBUFS;
> > +
> > +     if (nla_put(msg, NL80211_PMSR_PEER_ATTR_ADDR, ETH_ALEN,
> > +                 request->addr))
> > +             return -ENOBUFS;
> > +
> > +     chandef =3D nla_nest_start(msg, NL80211_PMSR_PEER_ATTR_CHAN);
> > +     if (!chandef)
> > +             return -ENOBUFS;
> > +
> > +     err =3D cfg80211_send_chandef(msg, &request->chandef);
> > +     if (err)
> > +             return err;
> > +
> > +     nla_nest_end(msg, chandef);
> > +
> > +     req =3D nla_nest_start(msg, NL80211_PMSR_PEER_ATTR_REQ);
> > +     if (request->report_ap_tsf &&
> > +         nla_put_flag(msg, NL80211_PMSR_REQ_ATTR_GET_AP_TSF))
> > +             return -ENOBUFS;
> > +
> > +     data =3D nla_nest_start(msg, NL80211_PMSR_REQ_ATTR_DATA);
> > +     if (!data)
> > +             return -ENOBUFS;
> > +
> > +     mac80211_hwsim_send_pmsr_ftm_request_peer(msg, &request->ftm);
> > +     nla_nest_end(msg, data);
> > +     nla_nest_end(msg, req);
> > +     nla_nest_end(msg, peer);
> > +
> > +     return 0;
> > +}
> > +
> > +static int mac80211_hwsim_send_pmsr_request(struct sk_buff *msg,
> > +                                         struct cfg80211_pmsr_request =
*request)
> > +{
> > +     int err;
> > +     void *pmsr;
>
> and here (hint larger variables go before smaller ones usually, right?)
Done.
>
> > +
> > +     pmsr =3D nla_nest_start(msg, NL80211_ATTR_PEER_MEASUREMENTS);
> > +     if (!pmsr)
> > +             return -ENOBUFS;
> > +
> > +     if (nla_put_u32(msg, NL80211_ATTR_TIMEOUT, request->timeout))
> > +             return -ENOBUFS;
> > +
> > +     if (!is_zero_ether_addr(request->mac_addr)) {
> > +             if (nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, request->mac=
_addr))
> > +                     return -ENOBUFS;
> > +             if (nla_put(msg, NL80211_ATTR_MAC_MASK, ETH_ALEN,
> > +                         request->mac_addr_mask))
> > +                     return -ENOBUFS;
> > +     }
> > +
> > +     for (int i =3D 0; i < request->n_peers; i++) {
> > +             err =3D mac80211_hwsim_send_pmsr_request_peer(msg,
> > +                                                         &request->pee=
rs[i]);
>
> Is this line wrap needed?
Unwrapped. Here and other places.

>
> > +             if (err)
> > +                     return err;
> > +     }
> > +
> > +     nla_nest_end(msg, pmsr);
> > +
> > +     return 0;
> > +}
> > +
> > +static int mac80211_hwsim_start_pmsr(struct ieee80211_hw *hw,
> > +                                  struct ieee80211_vif *vif,
> >                                    struct cfg80211_pmsr_request *reques=
t)
> >  {
> > -     return -EOPNOTSUPP;
> > +     struct mac80211_hwsim_data *data =3D hw->priv;
> > +     u32 _portid =3D READ_ONCE(data->wmediumd);
>
> Why READ_ONCE()?
>
> Shouldn't you only access this after the lock is held?
>
> thanks,
>
> greg k-h

It's intended behavior although I don't know details about the decision beh=
ind.
According to the commit a1910f9cad2b4b9cc0d5d326aa65632a23c16088
("mac80211_hwsim: fix wmediumd_pid"),
ACCESS_ONCE() is used instead of locking when synchronization was needed.

--
Jaewan Kim (=EA=B9=80=EC=9E=AC=EC=99=84) | Software Engineer in Google Kore=
a |
jaewan@google.com | +82-10-2781-5078
