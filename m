Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E3C6C4B87
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 14:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbjCVNTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 09:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbjCVNTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 09:19:20 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711D05D887
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 06:19:16 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id d75a77b69052e-3e0965f70ecso67861cf.0
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 06:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679491155;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4DEfB60tdIGGHy+2AD41Cg2wp32c/s2a8XTIzsgGUAQ=;
        b=UxSJSCCNXrFgKtq8kpb93OBDWEx0IWm+tUbJ0bi0Sl8gP6lYCGwg4IVRxAKKnOnAKZ
         9arXjYn3sKID1ITSRqhEdPb8G4VL2Z6AxUzVqoONQYW8hOJHE7FfgvzBDJhsg2pWfnyS
         yeyD+KYmAU433QQ7HDEi0oowPhI7njFpYM4mXTmnWREUpIyvQYhhQ+YhTHLxDkxNe2Xt
         sUDwP3gz1FpFiNyVnthOoUuxucrgllPWQTkR6RLP1ivns6y2ya8cO9EOEErk0/vvGWnf
         /0TYRxT8cdiU1C99tkyt2kgugv7CR3rEHbdUmZAkYFcLWK5JYYg9Qpll5NiBkxwnwXqW
         +bqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679491155;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4DEfB60tdIGGHy+2AD41Cg2wp32c/s2a8XTIzsgGUAQ=;
        b=d3GlPpPwdGwXBQZTXKGxeydzfhUjg1Ym8ht267mAEAJ9sMXiOxfnNwvXc4bdIhBKXO
         1tvIMjd4KkBizE/A29PZ3mJsbOizWenQWHaQ4XWnUfpKgdx84hyjr8EwzZ9d+rSfPp/+
         +RtgtEaI6h2bkn5nlWE3lDLVDcuZKs7vr3wuH8b0oU7A/ID3Cq+8Ega2a36x753r6LaZ
         JOz4ZQf9zL1OXzjorjWF8t0dcE93rDfh9EsdxrLY7dL/G4pn7npnKWN0PvyVVP1g/Rj/
         8QCuQ6HmYNOiYpjp+R2ElaI/KDhcMD3Ij/Hy9MDi9i9opP/q9kuOCD98CzBDpZFiFgmX
         KNXw==
X-Gm-Message-State: AO0yUKUE4uGxndNudAcG8A0gjdkZwTPFxON5h4w3sNltG3NEffvEBHG/
        B+smgdfvHFUUphgR9lFdGpB3/UEyN4fwl4/dBGC+sw==
X-Google-Smtp-Source: AK7set91FotVwi1kCv9D/MGvwz4WXHIYVIYJBiyhMUlfbhKJ25Z45cJ8kvXJVWDSiPyoEmKvtuCzNUTryUm0qHKv3es=
X-Received: by 2002:a05:622a:188f:b0:3df:6cbb:c76 with SMTP id
 v15-20020a05622a188f00b003df6cbb0c76mr316575qtc.13.1679491155326; Wed, 22 Mar
 2023 06:19:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230313075326.3594869-1-jaewan@google.com> <20230313075326.3594869-5-jaewan@google.com>
 <ZA99U1TMrUfZhk4G@localhost.localdomain>
In-Reply-To: <ZA99U1TMrUfZhk4G@localhost.localdomain>
From:   Jaewan Kim <jaewan@google.com>
Date:   Wed, 22 Mar 2023 22:19:00 +0900
Message-ID: <CABZjns5OUoBO46EY8Li9RNZ9rDMnN_Uq2euAYZMchddu6m42ww@mail.gmail.com>
Subject: Re: [PATCH v9 4/5] mac80211_hwsim: add PMSR abort support via virtio
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

On Tue, Mar 14, 2023 at 4:45=E2=80=AFAM Michal Kubiak <michal.kubiak@intel.=
com> wrote:
>
> On Mon, Mar 13, 2023 at 07:53:25AM +0000, Jaewan Kim wrote:
> > PMSR (a.k.a. peer measurement) is generalized measurement between two
> > devices with Wi-Fi support. And currently FTM (a.k.a. fine time
> > measurement or flight time measurement) is the one and only measurement=
.
> >
> > Add necessary functionalities for mac80211_hwsim to abort previous PMSR
> > request. The abortion request is sent to the wmedium where the PMSR req=
uest
> > is actually handled.
> >
> > In detail, add new mac80211_hwsim command HWSIM_CMD_ABORT_PMSR. When
> > mac80211_hwsim receives the PMSR abortion request via
> > ieee80211_ops.abort_pmsr, the received cfg80211_pmsr_request is resent =
to
> > the wmediumd with command HWSIM_CMD_ABORT_PMSR and attribute
> > HWSIM_ATTR_PMSR_REQUEST. The attribute is formatted as the same way as
> > nl80211_pmsr_start() expects.
> >
> > Signed-off-by: Jaewan Kim <jaewan@google.com>
> > ---
> > V7 -> V8: Rewrote commit msg
> > V7: Initial commit (split from previously large patch)
> > ---
> >  drivers/net/wireless/mac80211_hwsim.c | 61 +++++++++++++++++++++++++++
> >  drivers/net/wireless/mac80211_hwsim.h |  2 +
> >  2 files changed, 63 insertions(+)
> >
> > diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wirele=
ss/mac80211_hwsim.c
> > index a692d9c95566..8f699dfab77a 100644
> > --- a/drivers/net/wireless/mac80211_hwsim.c
> > +++ b/drivers/net/wireless/mac80211_hwsim.c
> > @@ -3343,6 +3343,66 @@ static int mac80211_hwsim_start_pmsr(struct ieee=
80211_hw *hw,
> >       return err;
> >  }
> >
> > +static void mac80211_hwsim_abort_pmsr(struct ieee80211_hw *hw,
> > +                                   struct ieee80211_vif *vif,
> > +                                   struct cfg80211_pmsr_request *reque=
st)
> > +{
> > +     struct mac80211_hwsim_data *data =3D hw->priv;
> > +     u32 _portid =3D READ_ONCE(data->wmediumd);
> > +     struct sk_buff *skb =3D NULL;
> > +     int err =3D 0;
> > +     void *msg_head;
> > +     struct nlattr *pmsr;
>
> Please use RCT style.
>
> > +
> > +     if (!_portid && !hwsim_virtio_enabled)
> > +             return;
> > +
> > +     mutex_lock(&data->mutex);
> > +
> > +     if (data->pmsr_request !=3D request) {
> > +             err =3D -EINVAL;
> > +             goto out_err;
> > +     }
> > +
> > +     if (err)
> > +             return;
>
> Redundant code - err is always zero in this place, isn't it?

removed.

>
> > +
> > +     skb =3D genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
> > +     if (!skb)
> > +             return;
>
> Return from the function while the mutex is still locked.
> I guess 'goto' should be used here like for other checks in this
> function.

great catch. Thank you so much.

>
> > +
> > +     msg_head =3D genlmsg_put(skb, 0, 0, &hwsim_genl_family, 0, HWSIM_=
CMD_ABORT_PMSR);
> > +
> > +     if (nla_put(skb, HWSIM_ATTR_ADDR_TRANSMITTER, ETH_ALEN, data->add=
resses[1].addr))
> > +             goto out_err;
> > +
> > +     pmsr =3D nla_nest_start(skb, HWSIM_ATTR_PMSR_REQUEST);
> > +     if (!pmsr) {
> > +             err =3D -ENOMEM;
> > +             goto out_err;
> > +     }
> > +
> > +     err =3D mac80211_hwsim_send_pmsr_request(skb, request);
> > +     if (err)
> > +             goto out_err;
> > +
> > +     err =3D nla_nest_end(skb, pmsr);
> > +     if (err)
> > +             goto out_err;
> > +
> > +     genlmsg_end(skb, msg_head);
> > +     if (hwsim_virtio_enabled)
> > +             hwsim_tx_virtio(data, skb);
> > +     else
> > +             hwsim_unicast_netgroup(data, skb, _portid);
> > +
> > +out_err:
> > +     if (err && skb)
> > +             nlmsg_free(skb);
>
> I suggest to reorganize that code (or at least rename the label "out_err"
> to "out" maybe?) to separate error path and normal path more clearly.

renamed to out.

>
> > +
> > +     mutex_unlock(&data->mutex);
> > +}
> > +
> >  #define HWSIM_COMMON_OPS                                     \
> >       .tx =3D mac80211_hwsim_tx,                                \
> >       .wake_tx_queue =3D ieee80211_handle_wake_tx_queue,        \
> > @@ -3367,6 +3427,7 @@ static int mac80211_hwsim_start_pmsr(struct ieee8=
0211_hw *hw,
> >       .get_et_stats =3D mac80211_hwsim_get_et_stats,            \
> >       .get_et_strings =3D mac80211_hwsim_get_et_strings,        \
> >       .start_pmsr =3D mac80211_hwsim_start_pmsr,                \
> > +     .abort_pmsr =3D mac80211_hwsim_abort_pmsr,
> >
> >  #define HWSIM_NON_MLO_OPS                                    \
> >       .sta_add =3D mac80211_hwsim_sta_add,                      \
> > diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wirele=
ss/mac80211_hwsim.h
> > index 98e586a56582..383f3e39c911 100644
> > --- a/drivers/net/wireless/mac80211_hwsim.h
> > +++ b/drivers/net/wireless/mac80211_hwsim.h
> > @@ -83,6 +83,7 @@ enum hwsim_tx_control_flags {
> >   *   are the same as to @HWSIM_CMD_ADD_MAC_ADDR.
> >   * @HWSIM_CMD_START_PMSR: request to start peer measurement with the
> >   *   %HWSIM_ATTR_PMSR_REQUEST.
> > + * @HWSIM_CMD_ABORT_PMSR: abort previously sent peer measurement
> >   * @__HWSIM_CMD_MAX: enum limit
> >   */
> >  enum {
> > @@ -96,6 +97,7 @@ enum {
> >       HWSIM_CMD_ADD_MAC_ADDR,
> >       HWSIM_CMD_DEL_MAC_ADDR,
> >       HWSIM_CMD_START_PMSR,
> > +     HWSIM_CMD_ABORT_PMSR,
> >       __HWSIM_CMD_MAX,
> >  };
> >  #define HWSIM_CMD_MAX (_HWSIM_CMD_MAX - 1)
> > --
> > 2.40.0.rc1.284.g88254d51c5-goog
> >

Done for reverse christmas tree style.


--
Jaewan Kim (=EA=B9=80=EC=9E=AC=EC=99=84) | Software Engineer in Google Kore=
a |
jaewan@google.com | +82-10-2781-5078
