Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 613CA680716
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 09:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235804AbjA3ILT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 03:11:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235689AbjA3ILR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 03:11:17 -0500
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5118CDBD1
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 00:10:52 -0800 (PST)
Received: by mail-vs1-xe36.google.com with SMTP id 187so11556780vsv.10
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 00:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ymIAXtCd2MxqtYWvrJZz0PEkm0tFm2YFN6GsAuKltPg=;
        b=VjBFoQyvxVbZcRjLUrbibXw4+MT8g0UWQSD5G0+jS0OLvVW/KtzPBQ3zu/A9gW63DF
         f/l3VAfgTqNXiiLTav7jolzt/AvRqrG8xKKncUHoUpkN+9/+rg586QUbOmYg2O/hoYVa
         iGDrVeTGq4FqWr/Zfhu+fazosEJH8l5CAD642AYSppVIR3mh7EEedUIRs2Bn5x4yzMYK
         V68lgUNYYVPPGMEIihaSvz7cwNBmtjzuMUaFDRBLdVIbgcknFyCpeNLdOAsL5Ad0Mun4
         Bp89Q+gJkGPhaIqayZ5HBeoJVUg87pDRxwX1F2+xan/kajjdNkzp/HZTfln2s//WsK/T
         VISQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ymIAXtCd2MxqtYWvrJZz0PEkm0tFm2YFN6GsAuKltPg=;
        b=vnlTMRDwfL6TVDyjY7EEwSbvrSyIvJshqq45TEswaKJpk6e6chbnkOO4ElcoxKY2E0
         dSP8Zvq7zQXYjGqMgr9CNNCYNQoNLIpZ/IkY4i2fifAxO/SBJQYWj0czayEbaG1QFGCF
         2ilYP6m0sSpO817Gjp8ks6GbNVm705yLqCzDMdT81oSZqS4WPnInVSveV46v6WeNhNwS
         BxL5ilzFmtujVv45bU1sWSA5j98N6EkNLHHVMjc4aatEiWWohBPKJyae3+qaGl2DVfOO
         D7eAJgI6BwKY80JbXChchQ09YXF0stxCOH5/fqVfi/JH5e2VzEi2A6t5EiC2S9oMShDQ
         vfyw==
X-Gm-Message-State: AO0yUKXp+Bieq158EvWgr4fucVFJLVfozOtT8bDuuJ3DKqDn1jQQ+RXI
        2fQKAqJteLWOwbbAiSlhgjvCJ8bqu4B+A58l6RBY6B2+mUe6+UcOEus=
X-Google-Smtp-Source: AK7set9o1e8iWYYvaoq70mZHQVo6LDmk5L7AnpPp1CiDFpmmDUsbP/J1TrEQHND2L6dETz8Z0PbBef9gd1pXrlqpqi4=
X-Received: by 2002:a67:d998:0:b0:3eb:8780:ced6 with SMTP id
 u24-20020a67d998000000b003eb8780ced6mr2091574vsj.12.1675066145479; Mon, 30
 Jan 2023 00:09:05 -0800 (PST)
MIME-Version: 1.0
References: <20230124145430.365495-1-jaewan@google.com> <20230124145430.365495-2-jaewan@google.com>
 <Y8//ZflAidKNJAVQ@kroah.com> <CABZjns5FRY+_WD_G=sjiBxjSwaydgL-wgTAR-PSeh-42OTieRg@mail.gmail.com>
 <Y9dWztPR3FxkLv26@kroah.com>
In-Reply-To: <Y9dWztPR3FxkLv26@kroah.com>
From:   Jaewan Kim <jaewan@google.com>
Date:   Mon, 30 Jan 2023 17:08:54 +0900
Message-ID: <CABZjns6nER31ZbBKQ_QKU0Hrh5V5U_W6Q4vGsE7kt7S5YYy3mg@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] mac80211_hwsim: add PMSR capability support
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

On Mon, Jan 30, 2023 at 2:34 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Jan 30, 2023 at 12:48:37AM +0900, Jaewan Kim wrote:
> > On Wed, Jan 25, 2023 at 12:55 AM Greg KH <gregkh@linuxfoundation.org> w=
rote:
> > > > +static int parse_ftm_capa(const struct nlattr *ftm_capa,
> > > > +                       struct cfg80211_pmsr_capabilities *out)
> > > > +{
> > > > +     struct nlattr *tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1];
> > > > +     int ret =3D nla_parse_nested(tb, NL80211_PMSR_FTM_CAPA_ATTR_M=
AX,
> > > > +                                ftm_capa, hwsim_ftm_capa_policy, N=
ULL);
> > > > +     if (ret) {
> > > > +             pr_err("mac80211_hwsim: malformed FTM capability");
> > >
> > > dev_err()?
> >
> > Is dev_err() the printing error for device code?
>
> I am sorry, but I can not understand this question, can you rephrase it?

I just wanted to know better about `dev_err()`,
because all existing code in this file uses `pr_err()`,
and there's no good documentation for `dev_err()`.

Given your answer below, it seems like that `pr_err()` isn't a good
choice in this file.
Am I correct?

>
> > If so, would it be better to propose another change for replacing all
> > pr_err() with dev_err() in this file?
>
> Odds are, yes, but that should be independent of your change to add a
> new feature.

Got it. Then I'll break the consistency in this file for my change,
and also propose another change for using `dev_err()` instead of `pr_err()`=
.

>
> thanks,
>
> greg k-h



--=20
Jaewan Kim (=EA=B9=80=EC=9E=AC=EC=99=84) | Software Engineer in Google Kore=
a |
jaewan@google.com | +82-10-2781-5078
