Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18DBA6A0D2A
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 16:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbjBWPjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 10:39:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233362AbjBWPjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 10:39:18 -0500
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237B12CC67
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 07:38:38 -0800 (PST)
Received: by mail-vs1-xe2a.google.com with SMTP id j14so16127507vse.3
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 07:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677166715;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dmPUQkQTbE8eRJKaiDBS9EG9WYoYRiytveYx8LKoV3Q=;
        b=eC3Xq+PKE/1Xhh+6mZeylQQ2L/0kWT5o/XbnSjFULf81MnfwQ/E0dJ9t8fClZsI5u3
         TBA/4oGPo38DkVRRbnYZffmgqQUHfYaA2yY4ApjWmzLf29G1pMwgng2gUTFoMrHu/yS9
         pzqiCP6Mm11GnF/q4BhslqIYNSQTLT1TH5s+JSl5/ypyY5CuZVagdJV/pz2b+biznsrA
         HlgzfyZ1kmU2+xFeUwSd44VYbTf+FvyvZmLYdJkYXdy+misCXD//he4O+q/05Q0FKaH9
         n6EzHDiJ1AjbXoV+zfcIoW9hPOyh4iybrSyyuY0yhDe4e7mwj9jn1L9WiPdBArbZ0IRB
         5CQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677166715;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dmPUQkQTbE8eRJKaiDBS9EG9WYoYRiytveYx8LKoV3Q=;
        b=GUs002RvuGt9X931iByfhXvtOhRT0v0SMSbvOILy2GE9jnp6gBja4FpqY5u17DvNOq
         GPPIYTUl86GZbWiR8fJhG9vVSNIvMKm31XUTdBSY9Bk/9sQNwiPnDVhoBGqS1V2A0ZaH
         YTx93+cAchBd6IHO2Ql7X0JuSvwZdaSjrN91Vuq9NPZA+2EHjUrDPaw+WiytX/9vGraB
         NeYhrG2N1i4bsClNow+7UzGQR3b3ocH/gbS4Nkwopjk5P+zvdNyCK4/odfSGa6Ku5WhJ
         B1DN4Oo7VEnX/Et7QW77/hxs5Org9viorg5ZfXVNU0+dkiyu+tIL/rOUBbLwN8+Rhjhm
         j4xA==
X-Gm-Message-State: AO0yUKWU1RgVOs7WlQ0fN9ESPCr/oEtFHUkFpLDhgE2exHo7TfY4HWrW
        G0xD4NHUL8RzW1LuZ7TVp+vh7KwVvDTSRDr0AGwIQSdGbLJTzt8FJKu2hw==
X-Google-Smtp-Source: AK7set+2jVgMlqvrsX+qtMb0HOJvBdtKIBTkcI8RrHtsRc+tbTPnsB9EnSG/jCvq/C9kne60ReStws5XBm0ZUEohRu4=
X-Received: by 2002:a05:6102:1485:b0:414:90d8:5be7 with SMTP id
 d5-20020a056102148500b0041490d85be7mr2681616vsv.75.1677166714910; Thu, 23 Feb
 2023 07:38:34 -0800 (PST)
MIME-Version: 1.0
References: <20230207085400.2232544-1-jaewan@google.com> <20230207085400.2232544-3-jaewan@google.com>
 <fbe6f8eb820b29f0cc932a63ad84253d0cef93c3.camel@sipsolutions.net>
In-Reply-To: <fbe6f8eb820b29f0cc932a63ad84253d0cef93c3.camel@sipsolutions.net>
From:   Jaewan Kim <jaewan@google.com>
Date:   Fri, 24 Feb 2023 00:38:23 +0900
Message-ID: <CABZjns4r_CJ-paj1FQ-SMFJMQW7rkXnvx5w98zYRgf6UQSnfkw@mail.gmail.com>
Subject: Re: [PATCH v7 2/4] mac80211_hwsim: add PMSR request support via virtio
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

On Thu, Feb 16, 2023 at 3:07 AM Johannes Berg <johannes@sipsolutions.net> w=
rote:
>
> On Tue, 2023-02-07 at 08:53 +0000, Jaewan Kim wrote:
> >
> >
> > +static int mac80211_hwsim_send_pmsr_ftm_request_peer(struct sk_buff *m=
sg,
> > +                                                  struct cfg80211_pmsr=
_ftm_request_peer *request)
>
> this ...
>
> > +{
> > +     struct nlattr *ftm;
> > +
> > +     if (!request->requested)
> > +             return -EINVAL;
> > +
> > +     ftm =3D nla_nest_start(msg, NL80211_PMSR_TYPE_FTM);
> > +     if (!ftm)
> > +             return -ENOBUFS;
> > +
> > +     if (nla_put_u32(msg, NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE, request-=
>preamble))
> > +             return -ENOBUFS;
> > +
> > +     if (nla_put_u16(msg, NL80211_PMSR_FTM_REQ_ATTR_BURST_PERIOD, requ=
est->burst_period))
> > +             return -ENOBUFS;
>
> and this ... etc ...
>
> also got some really long lines that could easily be broken
>
> > +     chandef =3D nla_nest_start(msg, NL80211_PMSR_PEER_ATTR_CHAN);
> > +     if (!chandef)
> > +             return -ENOBUFS;
> > +
> > +     err =3D cfg80211_send_chandef(msg, &request->chandef);
> > +     if (err)
> > +             return err;
>
> So this one I think I'll let you do with the export and all, because
> that's way nicer than duplicating the code, and it's clearly necessary.
>
> > +static int mac80211_hwsim_send_pmsr_request(struct sk_buff *msg,
> > +                                         struct cfg80211_pmsr_request =
*request)
> > +{
> > +     int err;
> > +     struct nlattr *pmsr =3D nla_nest_start(msg, NL80211_ATTR_PEER_MEA=
SUREMENTS);
>
> I'm not going to complain _too_ much about this, but all this use of
> nl80211 attributes better be thoroughly documented in the header file.
>
> > + * @HWSIM_CMD_START_PMSR: start PMSR
>
> That sounds almost like it's a command ("start PMSR") but really it's a
> notification/event as far as hwsim is concerned, so please document
> that.
>
> > + * @HWSIM_ATTR_PMSR_REQUEST: peer measurement request
>
> and please document the structure of the request that userspace will get
> (and how it should respond?)
>
> > +++ b/include/net/cfg80211.h
> > @@ -938,6 +938,16 @@ int cfg80211_chandef_dfs_required(struct wiphy *wi=
phy,
> >                                 const struct cfg80211_chan_def *chandef=
,
> >                                 enum nl80211_iftype iftype);
> >
> > +/**
> > + * cfg80211_send_chandef - sends the channel definition.
> > + * @msg: the msg to send channel definition
> > + * @chandef: the channel definition to check
> > + *
> > + * Returns: 0 if sent the channel definition to msg, < 0 on error
> > + **/
>
> That last line should just be */
>
> > +int cfg80211_send_chandef(struct sk_buff *msg, const struct cfg80211_c=
han_def *chandef);
>
> I think it'd be better if you exported it as nl80211_..., since it
> really is just a netlink thing, not cfg80211 functionality.

Sorry about the late response but could you elaborate to me in more
detail on this?
Where header file would be the good place if it's exporting it as nl80211_.=
..?

Here are some places that I've considered but don't seem like a good candid=
ate.

- include/net/cfg80211.h: proposed by current patch with name
cfg80211_send_chandef.
- include/uapi/linux/nl80211.h: only contains enums. doesn't seem like
a good place.

net/wireless/nl80211.h seems like your suggestion, but I can't find
how to include this from mac80211_hwsim.c.

I may need to EXPORT_SYMBOL(nl80211_send_chandef) and also declare it
to the cfg80211.h,
but I'm not sure because I can't find any existing example.

>
> It would also be good, IMHO, to split this part out into a separate
> patch saying that e.g. hwsim might use it like you do here, or even that
> vendor netlink could use it where needed.
>
> johannes



--=20
Jaewan Kim (=EA=B9=80=EC=9E=AC=EC=99=84) | Software Engineer in Google Kore=
a |
jaewan@google.com | +82-10-2781-5078
