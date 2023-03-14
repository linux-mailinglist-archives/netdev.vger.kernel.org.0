Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97446B9B8C
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjCNQcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjCNQcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:32:00 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDE05C112
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 09:31:52 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id e9e14a558f8ab-3179d0e6123so4565ab.1
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 09:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678811511;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Y1LWMDvp70VjhJxNTf4TqK4SYZSesz05vfqqHjFILQ=;
        b=Qw2iB0LW9i6cHJnlzWKGguqzWrCGS6T4a5nePyNG8HNiuAnyZ7emZj0vPtaE83I70G
         gRDzc/IExmBFwPrp8JdTk87zqdWccKc13nyLte1lBPOKQ47g1oHFFFfGB/VDwlVFPtvF
         ORRpsNAu/8ZyPh6iTp/uK+V4Nr1UvDLmAepnhEn30u375Hnq5a4jNlt8JsOWitEQ9W36
         +itd+/SFplJmYjb/PwvJ7I7X+bX4K8ujC53Z8l8atGf9e16kNueqQJUPZ3S57FY4V11B
         76I5DrB+mGKzf882RevNd4zJLyL2Awq0/rHN6Sh8FpRMP4CN3J8U0hlNJiDr0J86PYFV
         NNng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678811511;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Y1LWMDvp70VjhJxNTf4TqK4SYZSesz05vfqqHjFILQ=;
        b=jhnr/VLNSsTvHM6mvw4alHVjhmY3oK9R8uc/bkzez7k+74CLKNlG55cj004H1a/QSx
         VtvCdvMqNLZz7xHTl9EHxRsGd7lT3f4roC50EDqvbqYRW9oZY+H7UzvcgOxRX/JQKss4
         gALflzeV+PlFLQl4eHCdrqXpLxZUBHcPXYJin7qgcyqzPrmo/8NJcz1+osVOF6lkdRy9
         7E2mD4fAY1kkHmMlx1fKwAK/YzfyLhgM9UOMgwmTXMWXZ+rprNMlgTV0XZlZJavD4h/1
         wpecGjkd3D+GISkFlmAPm/c3kYqyRr490c+gTfO9zNP8skzhNihLhJNVtM+t6F3rmxwu
         eFZw==
X-Gm-Message-State: AO0yUKVYlaQCJPSrK4LNNPgYhaMxcONrdb98hMb0XBTzfL4pf4VH8AEF
        XueNzLaiPGTaZ8N7KFQiCGIrspRniKN/wNU0K5dtuQ==
X-Google-Smtp-Source: AK7set+gdBfxTmIr6Lc2VxxQGoFrJatKK0IyoPUfPqzm1eVppmpwQ4jgUQ9Mlh0zGtu78P4uaJmNxIjskWF2P/bmBXw=
X-Received: by 2002:a05:6e02:1409:b0:311:1424:47f1 with SMTP id
 n9-20020a056e02140900b00311142447f1mr14480ilo.0.1678811511156; Tue, 14 Mar
 2023 09:31:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230313075326.3594869-1-jaewan@google.com> <20230313075326.3594869-6-jaewan@google.com>
 <ZA+G3Rr+ibEL+2cX@localhost.localdomain>
In-Reply-To: <ZA+G3Rr+ibEL+2cX@localhost.localdomain>
From:   Jaewan Kim <jaewan@google.com>
Date:   Wed, 15 Mar 2023 01:31:38 +0900
Message-ID: <CABZjns6=8-cxQbUh2510eQ0B6C80hzMNDxFyY7zxgLY+NJTRGQ@mail.gmail.com>
Subject: Re: [PATCH v9 5/5] mac80211_hwsim: add PMSR report support via virtio
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

On Tue, Mar 14, 2023 at 5:26=E2=80=AFAM Michal Kubiak <michal.kubiak@intel.=
com> wrote:
>
> On Mon, Mar 13, 2023 at 07:53:26AM +0000, Jaewan Kim wrote:
> > PMSR (a.k.a. peer measurement) is generalized measurement between two
> > devices with Wi-Fi support. And currently FTM (a.k.a. fine time measure=
ment
> > or flight time measurement) is the one and only measurement.
> >
> > Add the necessary functionality to allow mac80211_hwsim to report PMSR
> > result. The result would come from the wmediumd, where other Wi-Fi
> > devices' information are kept. mac80211_hwsim only need to deliver the
> > result to the userspace.
> >
> > In detail, add new mac80211_hwsim attributes HWSIM_CMD_REPORT_PMSR, and
> > HWSIM_ATTR_PMSR_RESULT. When mac80211_hwsim receives the PMSR result wi=
th
> > command HWSIM_CMD_REPORT_PMSR and detail with attribute
> > HWSIM_ATTR_PMSR_RESULT, received data is parsed to cfg80211_pmsr_result=
 and
> > resent to the userspace by cfg80211_pmsr_report().
> >
> > To help receive the details of PMSR result, hwsim_rate_info_attributes =
is
> > added to receive rate_info without complex bitrate calculation. (i.e. s=
end
> > rate_info without adding inverse of nl80211_put_sta_rate()).
> >
> > Signed-off-by: Jaewan Kim <jaewan@google.com>
> > ---
> > V7 -> V8: Changed to specify calculated last HWSIM_CMD for resv_start_o=
p
> >           instead of __HWSIM_CMD_MAX for adding new CMD more explicit.
> > V7: Initial commit (split from previously large patch)
> > ---
> >  drivers/net/wireless/mac80211_hwsim.c | 379 +++++++++++++++++++++++++-
> >  drivers/net/wireless/mac80211_hwsim.h |  51 +++-
> >  2 files changed, 420 insertions(+), 10 deletions(-)
> >
>
> General comment: there are many lines exceeding 80 characters (the limit
> for net).
> The rest of my comments - inline.

We can now using 100 columns
because 80 character limit is deprecated

Here's previous discussion thread:
https://patchwork.kernel.org/project/linux-wireless/patch/20230207085400.22=
32544-2-jaewan@google.com/#25217046

>
> Thanks,
> Michal
>
> > diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wirele=
ss/mac80211_hwsim.c
> > index 8f699dfab77a..d1218c1efba4 100644
> > --- a/drivers/net/wireless/mac80211_hwsim.c
> > +++ b/drivers/net/wireless/mac80211_hwsim.c
> > @@ -752,6 +752,11 @@ struct hwsim_radiotap_ack_hdr {
> >       __le16 rt_chbitmask;
> >  } __packed;
> >
> > +static struct mac80211_hwsim_data *get_hwsim_data_ref_from_addr(const =
u8 *addr)
> > +{
> > +     return rhashtable_lookup_fast(&hwsim_radios_rht, addr, hwsim_rht_=
params);
> > +}
> > +
> >  /* MAC80211_HWSIM netlink family */
> >  static struct genl_family hwsim_genl_family;
> >
> > @@ -765,6 +770,76 @@ static const struct genl_multicast_group hwsim_mcg=
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
> > +     [NL80211_PMSR_FTM_RESP_ATTR_TX_RATE] =3D NLA_POLICY_NESTED(hwsim_=
rate_info_policy),
> > +     [NL80211_PMSR_FTM_RESP_ATTR_RX_RATE] =3D NLA_POLICY_NESTED(hwsim_=
rate_info_policy),
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
> > +     [NL80211_PMSR_RESP_ATTR_DATA] =3D NLA_POLICY_NESTED(hwsim_pmsr_re=
sp_type_policy),
> > +};
> > +
> > +static const struct nla_policy
> > +hwsim_pmsr_peer_result_policy[NL80211_PMSR_PEER_ATTR_MAX + 1] =3D {
> > +     [NL80211_PMSR_PEER_ATTR_ADDR] =3D NLA_POLICY_ETH_ADDR_COMPAT,
> > +     [NL80211_PMSR_PEER_ATTR_CHAN] =3D { .type =3D NLA_REJECT },
> > +     [NL80211_PMSR_PEER_ATTR_REQ] =3D { .type =3D NLA_REJECT },
> > +     [NL80211_PMSR_PEER_ATTR_RESP] =3D NLA_POLICY_NESTED(hwsim_pmsr_re=
sp_policy),
> > +};
> > +
> > +static const struct nla_policy
> > +hwsim_pmsr_peers_result_policy[NL80211_PMSR_ATTR_MAX + 1] =3D {
> > +     [NL80211_PMSR_ATTR_MAX_PEERS] =3D { .type =3D NLA_REJECT },
> > +     [NL80211_PMSR_ATTR_REPORT_AP_TSF] =3D { .type =3D NLA_REJECT },
> > +     [NL80211_PMSR_ATTR_RANDOMIZE_MAC_ADDR] =3D { .type =3D NLA_REJECT=
 },
> > +     [NL80211_PMSR_ATTR_TYPE_CAPA] =3D { .type =3D NLA_REJECT },
> > +     [NL80211_PMSR_ATTR_PEERS] =3D NLA_POLICY_NESTED_ARRAY(hwsim_pmsr_=
peer_result_policy),
> > +};
> > +
> >  static const struct nla_policy
> >  hwsim_ftm_capa_policy[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1] =3D {
> >       [NL80211_PMSR_FTM_CAPA_ATTR_ASAP] =3D { .type =3D NLA_FLAG },
> > @@ -822,6 +897,7 @@ static const struct nla_policy hwsim_genl_policy[HW=
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
> > @@ -3403,6 +3479,292 @@ static void mac80211_hwsim_abort_pmsr(struct ie=
ee80211_hw *hw,
> >       mutex_unlock(&data->mutex);
> >  }
> >
> > +static int mac80211_hwsim_parse_rate_info(struct nlattr *rateattr,
> > +                                       struct rate_info *rate_info,
> > +                                       struct genl_info *info)
> > +{
> > +     struct nlattr *tb[HWSIM_RATE_INFO_ATTR_MAX + 1];
> > +     int ret;
> > +
> > +     ret =3D nla_parse_nested(tb, HWSIM_RATE_INFO_ATTR_MAX,
> > +                            rateattr, hwsim_rate_info_policy, info->ex=
tack);
> > +     if (ret)
> > +             return ret;
> > +
> > +     if (tb[HWSIM_RATE_INFO_ATTR_FLAGS])
> > +             rate_info->flags =3D nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_F=
LAGS]);
> > +
> > +     if (tb[HWSIM_RATE_INFO_ATTR_MCS])
> > +             rate_info->mcs =3D nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_MCS=
]);
> > +
> > +     if (tb[HWSIM_RATE_INFO_ATTR_LEGACY])
> > +             rate_info->legacy =3D nla_get_u16(tb[HWSIM_RATE_INFO_ATTR=
_LEGACY]);
> > +
> > +     if (tb[HWSIM_RATE_INFO_ATTR_NSS])
> > +             rate_info->nss =3D nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_NSS=
]);
> > +
> > +     if (tb[HWSIM_RATE_INFO_ATTR_BW])
> > +             rate_info->bw =3D nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_BW])=
;
> > +
> > +     if (tb[HWSIM_RATE_INFO_ATTR_HE_GI])
> > +             rate_info->he_gi =3D nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_H=
E_GI]);
> > +
> > +     if (tb[HWSIM_RATE_INFO_ATTR_HE_DCM])
> > +             rate_info->he_dcm =3D nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_=
HE_DCM]);
> > +
> > +     if (tb[HWSIM_RATE_INFO_ATTR_HE_RU_ALLOC])
> > +             rate_info->he_ru_alloc =3D
> > +                     nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_HE_RU_ALLOC]);
> > +
> > +     if (tb[HWSIM_RATE_INFO_ATTR_N_BOUNDED_CH])
> > +             rate_info->n_bonded_ch =3D nla_get_u8(tb[HWSIM_RATE_INFO_=
ATTR_N_BOUNDED_CH]);
> > +
> > +     if (tb[HWSIM_RATE_INFO_ATTR_EHT_GI])
> > +             rate_info->eht_gi =3D nla_get_u8(tb[HWSIM_RATE_INFO_ATTR_=
EHT_GI]);
> > +
> > +     if (tb[HWSIM_RATE_INFO_ATTR_EHT_RU_ALLOC])
> > +             rate_info->eht_ru_alloc =3D nla_get_u8(tb[HWSIM_RATE_INFO=
_ATTR_EHT_RU_ALLOC]);
> > +
> > +     return 0;
> > +}
>
> Lines in the function above often exceed 80 chars.
>
> > +
> > +static int mac80211_hwsim_parse_ftm_result(struct nlattr *ftm,
> > +                                        struct cfg80211_pmsr_ftm_resul=
t *result,
> > +                                        struct genl_info *info)
> > +{
> > +     struct nlattr *tb[NL80211_PMSR_FTM_RESP_ATTR_MAX + 1];
> > +     int ret;
> > +
> > +     ret =3D nla_parse_nested(tb, NL80211_PMSR_FTM_RESP_ATTR_MAX,
> > +                            ftm, hwsim_ftm_result_policy, info->extack=
);
> > +     if (ret)
> > +             return ret;
> > +
> > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_FAIL_REASON])
> > +             result->failure_reason =3D nla_get_u32(tb[NL80211_PMSR_FT=
M_RESP_ATTR_FAIL_REASON]);
> > +
> > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_BURST_INDEX])
> > +             result->burst_index =3D nla_get_u16(tb[NL80211_PMSR_FTM_R=
ESP_ATTR_BURST_INDEX]);
> > +
> > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_ATTEMPTS]) {
> > +             result->num_ftmr_attempts_valid =3D 1;
> > +             result->num_ftmr_attempts =3D
> > +                     nla_get_u32(tb[NL80211_PMSR_FTM_RESP_ATTR_NUM_FTM=
R_ATTEMPTS]);
> > +     }
> > +
> > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_NUM_FTMR_SUCCESSES]) {
> > +             result->num_ftmr_successes_valid =3D 1;
> > +             result->num_ftmr_successes =3D
> > +                     nla_get_u32(tb[NL80211_PMSR_FTM_RESP_ATTR_NUM_FTM=
R_SUCCESSES]);
> > +     }
> > +
> > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_BUSY_RETRY_TIME])
> > +             result->busy_retry_time =3D
> > +                     nla_get_u8(tb[NL80211_PMSR_FTM_RESP_ATTR_BUSY_RET=
RY_TIME]);
> > +
> > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_NUM_BURSTS_EXP])
> > +             result->num_bursts_exp =3D nla_get_u8(tb[NL80211_PMSR_FTM=
_RESP_ATTR_NUM_BURSTS_EXP]);
> > +
> > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_BURST_DURATION])
> > +             result->burst_duration =3D nla_get_u8(tb[NL80211_PMSR_FTM=
_RESP_ATTR_BURST_DURATION]);
> > +
> > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_FTMS_PER_BURST])
> > +             result->ftms_per_burst =3D nla_get_u8(tb[NL80211_PMSR_FTM=
_RESP_ATTR_FTMS_PER_BURST]);
> > +
> > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_RSSI_AVG]) {
> > +             result->rssi_avg_valid =3D 1;
> > +             result->rssi_avg =3D nla_get_s32(tb[NL80211_PMSR_FTM_RESP=
_ATTR_RSSI_AVG]);
> > +     }
> > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_RSSI_SPREAD]) {
> > +             result->rssi_spread_valid =3D 1;
> > +             result->rssi_spread =3D
> > +                     nla_get_s32(tb[NL80211_PMSR_FTM_RESP_ATTR_RSSI_SP=
READ]);
> > +     }
> > +
> > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_TX_RATE]) {
> > +             result->tx_rate_valid =3D 1;
> > +             ret =3D mac80211_hwsim_parse_rate_info(tb[NL80211_PMSR_FT=
M_RESP_ATTR_TX_RATE],
> > +                                                  &result->tx_rate, in=
fo);
> > +             if (ret)
> > +                     return ret;
> > +     }
> > +
> > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_RX_RATE]) {
> > +             result->rx_rate_valid =3D 1;
> > +             ret =3D mac80211_hwsim_parse_rate_info(tb[NL80211_PMSR_FT=
M_RESP_ATTR_RX_RATE],
> > +                                                  &result->rx_rate, in=
fo);
> > +             if (ret)
> > +                     return ret;
> > +     }
> > +
> > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_RTT_AVG]) {
> > +             result->rtt_avg_valid =3D 1;
> > +             result->rtt_avg =3D
> > +                     nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_RTT_AVG=
]);
> > +     }
> > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_RTT_VARIANCE]) {
> > +             result->rtt_variance_valid =3D 1;
> > +             result->rtt_variance =3D
> > +                     nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_RTT_VAR=
IANCE]);
> > +     }
> > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_RTT_SPREAD]) {
> > +             result->rtt_spread_valid =3D 1;
> > +             result->rtt_spread =3D
> > +                     nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_RTT_SPR=
EAD]);
> > +     }
> > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_DIST_AVG]) {
> > +             result->dist_avg_valid =3D 1;
> > +             result->dist_avg =3D
> > +                     nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_DIST_AV=
G]);
> > +     }
> > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_DIST_VARIANCE]) {
> > +             result->dist_variance_valid =3D 1;
> > +             result->dist_variance =3D
> > +                     nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_DIST_VA=
RIANCE]);
> > +     }
> > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_DIST_SPREAD]) {
> > +             result->dist_spread_valid =3D 1;
> > +             result->dist_spread =3D
> > +                     nla_get_u64(tb[NL80211_PMSR_FTM_RESP_ATTR_DIST_SP=
READ]);
> > +     }
> > +
> > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_LCI]) {
> > +             result->lci =3D nla_data(tb[NL80211_PMSR_FTM_RESP_ATTR_LC=
I]);
> > +             result->lci_len =3D nla_len(tb[NL80211_PMSR_FTM_RESP_ATTR=
_LCI]);
> > +     }
> > +
> > +     if (tb[NL80211_PMSR_FTM_RESP_ATTR_CIVICLOC]) {
> > +             result->civicloc =3D nla_data(tb[NL80211_PMSR_FTM_RESP_AT=
TR_CIVICLOC]);
> > +             result->civicloc_len =3D nla_len(tb[NL80211_PMSR_FTM_RESP=
_ATTR_CIVICLOC]);
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static int mac80211_hwsim_parse_pmsr_resp(struct nlattr *resp,
> > +                                       struct cfg80211_pmsr_result *re=
sult,
> > +                                       struct genl_info *info)
> > +{
> > +     struct nlattr *tb[NL80211_PMSR_RESP_ATTR_MAX + 1];
> > +     struct nlattr *pmsr;
> > +     int rem;
> > +     int ret;
> > +
> > +     ret =3D nla_parse_nested(tb, NL80211_PMSR_RESP_ATTR_MAX, resp,
> > +                            hwsim_pmsr_resp_policy, info->extack);
>
> You are assigning the value to "ret" variable but you are never using
> it. Is the check for "ret" missing?
>
> > +
> > +     if (tb[NL80211_PMSR_RESP_ATTR_STATUS])
> > +             result->status =3D nla_get_u32(tb[NL80211_PMSR_RESP_ATTR_=
STATUS]);
> > +
> > +     if (tb[NL80211_PMSR_RESP_ATTR_HOST_TIME])
> > +             result->host_time =3D nla_get_u64(tb[NL80211_PMSR_RESP_AT=
TR_HOST_TIME]);
> > +
> > +     if (tb[NL80211_PMSR_RESP_ATTR_AP_TSF]) {
> > +             result->ap_tsf_valid =3D 1;
> > +             result->ap_tsf =3D nla_get_u64(tb[NL80211_PMSR_RESP_ATTR_=
AP_TSF]);
> > +     }
> > +
> > +     result->final =3D !!tb[NL80211_PMSR_RESP_ATTR_FINAL];
> > +
> > +     if (tb[NL80211_PMSR_RESP_ATTR_DATA]) {
>
> How about using a negative logic in here to decrease indentation?
> For example:
>
>         if (!tb[NL80211_PMSR_RESP_ATTR_DATA])
>                 return ret;
>
> > +             nla_for_each_nested(pmsr, tb[NL80211_PMSR_RESP_ATTR_DATA]=
, rem) {
> > +                     switch (nla_type(pmsr)) {
> > +                     case NL80211_PMSR_TYPE_FTM:
> > +                             result->type =3D NL80211_PMSR_TYPE_FTM;
> > +                             ret =3D mac80211_hwsim_parse_ftm_result(p=
msr, &result->ftm, info);
> > +                             if (ret)
> > +                                     return ret;
> > +                             break;
> > +                     default:
> > +                             NL_SET_ERR_MSG_ATTR(info->extack, pmsr, "=
Unknown pmsr resp type");
> > +                             return -EINVAL;
> > +                     }
> > +             }
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +static int mac80211_hwsim_parse_pmsr_result(struct nlattr *peer,
> > +                                         struct cfg80211_pmsr_result *=
result,
> > +                                         struct genl_info *info)
> > +{
> > +     struct nlattr *tb[NL80211_PMSR_PEER_ATTR_MAX + 1];
> > +     int ret;
> > +
> > +     if (!peer)
> > +             return -EINVAL;
> > +
> > +     ret =3D nla_parse_nested(tb, NL80211_PMSR_PEER_ATTR_MAX, peer,
> > +                            hwsim_pmsr_peer_result_policy, info->extac=
k);
> > +     if (ret)
> > +             return ret;
> > +
> > +     if (tb[NL80211_PMSR_PEER_ATTR_ADDR])
> > +             memcpy(result->addr, nla_data(tb[NL80211_PMSR_PEER_ATTR_A=
DDR]),
> > +                    ETH_ALEN);
> > +
> > +     if (tb[NL80211_PMSR_PEER_ATTR_RESP]) {
> > +             ret =3D mac80211_hwsim_parse_pmsr_resp(tb[NL80211_PMSR_PE=
ER_ATTR_RESP], result, info);
> > +             if (ret)
> > +                     return ret;
> > +     }
> > +
> > +     return 0;
> > +};
> > +
> > +static int hwsim_pmsr_report_nl(struct sk_buff *msg, struct genl_info =
*info)
> > +{
> > +     struct nlattr *reqattr;
> > +     const u8 *src;
> > +     int err, rem;
> > +     struct nlattr *peers, *peer;
> > +     struct mac80211_hwsim_data *data;
>
> Please use RCT formatting.
>
> > +
> > +     src =3D nla_data(info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER]);
> > +     data =3D get_hwsim_data_ref_from_addr(src);
> > +     if (!data)
> > +             return -EINVAL;
> > +
> > +     mutex_lock(&data->mutex);
> > +     if (!data->pmsr_request) {
> > +             err =3D -EINVAL;
> > +             goto out_err;
> > +     }
> > +
> > +     reqattr =3D info->attrs[HWSIM_ATTR_PMSR_RESULT];
> > +     if (!reqattr) {
> > +             err =3D -EINVAL;
> > +             goto out_err;
> > +     }
> > +
> > +     peers =3D nla_find_nested(reqattr, NL80211_PMSR_ATTR_PEERS);
> > +     if (!peers) {
> > +             err =3D -EINVAL;
> > +             goto out_err;
> > +     }
> > +
> > +     nla_for_each_nested(peer, peers, rem) {
> > +             struct cfg80211_pmsr_result result;
> > +
> > +             err =3D mac80211_hwsim_parse_pmsr_result(peer, &result, i=
nfo);
> > +             if (err)
> > +                     goto out_err;
> > +
> > +             cfg80211_pmsr_report(data->pmsr_request_wdev,
> > +                                  data->pmsr_request, &result, GFP_KER=
NEL);
> > +     }
> > +
> > +     cfg80211_pmsr_complete(data->pmsr_request_wdev, data->pmsr_reques=
t, GFP_KERNEL);
> > +
> > +out_err:
>
> How about renaming this label to "out" or "exit"?
> The code below is used for error path as well as for a normal path.
>
> > +     data->pmsr_request =3D NULL;
> > +     data->pmsr_request_wdev =3D NULL;
> > +
> > +     mutex_unlock(&data->mutex);
> > +     return err;
> > +}
> > +
> >  #define HWSIM_COMMON_OPS                                     \
> >       .tx =3D mac80211_hwsim_tx,                                \
> >       .wake_tx_queue =3D ieee80211_handle_wake_tx_queue,        \
> > @@ -5072,13 +5434,6 @@ static void hwsim_mon_setup(struct net_device *d=
ev)
> >       eth_hw_addr_set(dev, addr);
> >  }
> >
> > -static struct mac80211_hwsim_data *get_hwsim_data_ref_from_addr(const =
u8 *addr)
> > -{
> > -     return rhashtable_lookup_fast(&hwsim_radios_rht,
> > -                                   addr,
> > -                                   hwsim_rht_params);
> > -}
> > -
> >  static void hwsim_register_wmediumd(struct net *net, u32 portid)
> >  {
> >       struct mac80211_hwsim_data *data;
> > @@ -5746,6 +6101,11 @@ static const struct genl_small_ops hwsim_ops[] =
=3D {
> >               .doit =3D hwsim_get_radio_nl,
> >               .dumpit =3D hwsim_dump_radio_nl,
> >       },
> > +     {
> > +             .cmd =3D HWSIM_CMD_REPORT_PMSR,
> > +             .validate =3D GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALID=
ATE_DUMP,
> > +             .doit =3D hwsim_pmsr_report_nl,
> > +     },
> >  };
> >
> >  static struct genl_family hwsim_genl_family __ro_after_init =3D {
> > @@ -5757,7 +6117,7 @@ static struct genl_family hwsim_genl_family __ro_=
after_init =3D {
> >       .module =3D THIS_MODULE,
> >       .small_ops =3D hwsim_ops,
> >       .n_small_ops =3D ARRAY_SIZE(hwsim_ops),
> > -     .resv_start_op =3D HWSIM_CMD_DEL_MAC_ADDR + 1,
> > +     .resv_start_op =3D HWSIM_CMD_REPORT_PMSR + 1, // match with __HWS=
IM_CMD_MAX
>
>
> >       .mcgrps =3D hwsim_mcgrps,
> >       .n_mcgrps =3D ARRAY_SIZE(hwsim_mcgrps),
> >  };
> > @@ -5926,6 +6286,9 @@ static int hwsim_virtio_handle_cmd(struct sk_buff=
 *skb)
> >       case HWSIM_CMD_TX_INFO_FRAME:
> >               hwsim_tx_info_frame_received_nl(skb, &info);
> >               break;
> > +     case HWSIM_CMD_REPORT_PMSR:
> > +             hwsim_pmsr_report_nl(skb, &info);
> > +             break;
> >       default:
> >               pr_err_ratelimited("hwsim: invalid cmd: %d\n", gnlh->cmd)=
;
> >               return -EPROTO;
> > diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wirele=
ss/mac80211_hwsim.h
> > index 383f3e39c911..92126f02c58f 100644
> > --- a/drivers/net/wireless/mac80211_hwsim.h
> > +++ b/drivers/net/wireless/mac80211_hwsim.h
> > @@ -82,8 +82,8 @@ enum hwsim_tx_control_flags {
> >   * @HWSIM_CMD_DEL_MAC_ADDR: remove the MAC address again, the attribut=
es
> >   *   are the same as to @HWSIM_CMD_ADD_MAC_ADDR.
> >   * @HWSIM_CMD_START_PMSR: request to start peer measurement with the
> > - *   %HWSIM_ATTR_PMSR_REQUEST.
> > - * @HWSIM_CMD_ABORT_PMSR: abort previously sent peer measurement
> > + *   %HWSIM_ATTR_PMSR_REQUEST. Result will be sent back asynchronously
> > + *   with %HWSIM_CMD_REPORT_PMSR.
> >   * @__HWSIM_CMD_MAX: enum limit
> >   */
> >  enum {
> > @@ -98,6 +98,7 @@ enum {
> >       HWSIM_CMD_DEL_MAC_ADDR,
> >       HWSIM_CMD_START_PMSR,
> >       HWSIM_CMD_ABORT_PMSR,
> > +     HWSIM_CMD_REPORT_PMSR,
> >       __HWSIM_CMD_MAX,
> >  };
> >  #define HWSIM_CMD_MAX (_HWSIM_CMD_MAX - 1)
> > @@ -151,6 +152,8 @@ enum {
> >   *   to provide peer measurement capabilities. (nl80211_peer_measureme=
nt_attrs)
> >   * @HWSIM_ATTR_PMSR_REQUEST: nested attribute used with %HWSIM_CMD_STA=
RT_PMSR
> >   *   to provide details about peer measurement request (nl80211_peer_m=
easurement_attrs)
> > + * @HWSIM_ATTR_PMSR_RESULT: nested attributed used with %HWSIM_CMD_REP=
ORT_PMSR
> > + *   to provide peer measurement result (nl80211_peer_measurement_attr=
s)
> >   * @__HWSIM_ATTR_MAX: enum limit
> >   */
> >
> > @@ -184,6 +187,7 @@ enum {
> >       HWSIM_ATTR_MLO_SUPPORT,
> >       HWSIM_ATTR_PMSR_SUPPORT,
> >       HWSIM_ATTR_PMSR_REQUEST,
> > +     HWSIM_ATTR_PMSR_RESULT,
> >       __HWSIM_ATTR_MAX,
> >  };
> >  #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
> > @@ -288,4 +292,47 @@ enum {
> >       HWSIM_VQ_RX,
> >       HWSIM_NUM_VQS,
> >  };
> > +
> > +/**
> > + * enum hwsim_rate_info -- bitrate information.
> > + *
> > + * Information about a receiving or transmitting bitrate
> > + * that can be mapped to struct rate_info
> > + *
> > + * @HWSIM_RATE_INFO_ATTR_FLAGS: bitflag of flags from &enum rate_info_=
flags
> > + * @HWSIM_RATE_INFO_ATTR_MCS: mcs index if struct describes an HT/VHT/=
HE rate
> > + * @HWSIM_RATE_INFO_ATTR_LEGACY: bitrate in 100kbit/s for 802.11abg
> > + * @HWSIM_RATE_INFO_ATTR_NSS: number of streams (VHT & HE only)
> > + * @HWSIM_RATE_INFO_ATTR_BW: bandwidth (from &enum rate_info_bw)
> > + * @HWSIM_RATE_INFO_ATTR_HE_GI: HE guard interval (from &enum nl80211_=
he_gi)
> > + * @HWSIM_RATE_INFO_ATTR_HE_DCM: HE DCM value
> > + * @HWSIM_RATE_INFO_ATTR_HE_RU_ALLOC:  HE RU allocation (from &enum nl=
80211_he_ru_alloc,
> > + *   only valid if bw is %RATE_INFO_BW_HE_RU)
> > + * @HWSIM_RATE_INFO_ATTR_N_BOUNDED_CH: In case of EDMG the number of b=
onded channels (1-4)
> > + * @HWSIM_RATE_INFO_ATTR_EHT_GI: EHT guard interval (from &enum nl8021=
1_eht_gi)
> > + * @HWSIM_RATE_INFO_ATTR_EHT_RU_ALLOC: EHT RU allocation (from &enum n=
l80211_eht_ru_alloc,
> > + *   only valid if bw is %RATE_INFO_BW_EHT_RU)
> > + * @NUM_HWSIM_RATE_INFO_ATTRS: internal
> > + * @HWSIM_RATE_INFO_ATTR_MAX: highest attribute number
> > + */
> > +enum hwsim_rate_info_attributes {
> > +     __HWSIM_RATE_INFO_ATTR_INVALID,
> > +
> > +     HWSIM_RATE_INFO_ATTR_FLAGS,
> > +     HWSIM_RATE_INFO_ATTR_MCS,
> > +     HWSIM_RATE_INFO_ATTR_LEGACY,
> > +     HWSIM_RATE_INFO_ATTR_NSS,
> > +     HWSIM_RATE_INFO_ATTR_BW,
> > +     HWSIM_RATE_INFO_ATTR_HE_GI,
> > +     HWSIM_RATE_INFO_ATTR_HE_DCM,
> > +     HWSIM_RATE_INFO_ATTR_HE_RU_ALLOC,
> > +     HWSIM_RATE_INFO_ATTR_N_BOUNDED_CH,
> > +     HWSIM_RATE_INFO_ATTR_EHT_GI,
> > +     HWSIM_RATE_INFO_ATTR_EHT_RU_ALLOC,
> > +
> > +     /* keep last */
> > +     NUM_HWSIM_RATE_INFO_ATTRS,
> > +     HWSIM_RATE_INFO_ATTR_MAX =3D NUM_HWSIM_RATE_INFO_ATTRS - 1
> > +};
> > +
> >  #endif /* __MAC80211_HWSIM_H */
> > --
> > 2.40.0.rc1.284.g88254d51c5-goog
> >

Many Thanks,

--=20
Jaewan Kim (=EA=B9=80=EC=9E=AC=EC=99=84) | Software Engineer in Google Kore=
a |
jaewan@google.com | +82-10-2781-5078
