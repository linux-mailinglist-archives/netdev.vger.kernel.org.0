Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E40AB6319F9
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 08:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiKUHBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 02:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiKUHBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 02:01:08 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0C8175A9
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 23:01:04 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id l24so2325427edj.8
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 23:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FEdhuNBwcjrSfq3V8p7WNBmlKyeGLF5K9ZAquaFbLe0=;
        b=qolCpLT+VjMjlxSjpKMeuwN756qc4J5YzBVKvcSZAdCJ2U2om1MuvD3uoHg/48yyaS
         i4kno0xvZojD4tzTnah8haWb6GUx0v68zd4458FBSpofON5s4R4wVAa3wQQOo3YPMAO6
         gOpvecqfRTRrIKtgtwr6b6Y1TZ+Z1Q8HwcKTgFn8re4JunarmsXsW4MUSnGcey/vsU6F
         64hSP3hZrYRlKjDUUX6D7fl8STyDx90jtD3YTBfQT4aB2v+brXkQoSk1DNrYOVl9xbMo
         t91R2ZFa/rViY+MUszZOX/Ole/Fn4B92fxPzIekxdWO+Bfk/lXC1KEO8b2qtB1lCPoaK
         PbEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FEdhuNBwcjrSfq3V8p7WNBmlKyeGLF5K9ZAquaFbLe0=;
        b=IVO5nQAzRwV9erpX7j3RLZzQqs7KoGJG2XJ8rucuLvPZpBzqdYLg6j7DQ7tokfz7XB
         Xy1jg33avUbGoaZAdRGlj5VqQ88/+1hHjajVBhHKmmzYuuG0YRcw5nVLeMCox7rTNf15
         tTvk8GkvB8gAgXNI38NhVaafYVr1wD0Q2t2rq/zSYR41+rCjy8dcXa7ohbiQ5WDXotf8
         JWdCq9v81kZHBHnn1drfZgRMPX5/yZKQWUtv1vemCvNZ38jNDRmf0NAEhi7qrIbvb98p
         WbKBIll7ZEsWC79A7gSo5O/hSahsCtOtpGI1hXWoHrc0WtIc+SUNTVZsWhcjzxP8wor9
         FBuQ==
X-Gm-Message-State: ANoB5pl8zAsXlXU9lm+uHDklL338CrDthO87cze56iIGLuKXWpBWsPBc
        5lFMfw9L+9yMCitplst7EvMY+qfNoq8P2KodLOQ=
X-Google-Smtp-Source: AA0mqf6itR3x+AHX7+3a1PogzounLRKd8hdStZ/vq7eQu6aMvTzFZq4FL/oVpD3xiHdulpNz9l2tXLnJ7zyyqocCOp8=
X-Received: by 2002:a05:6402:14:b0:461:deed:6d20 with SMTP id
 d20-20020a056402001400b00461deed6d20mr15473726edu.55.1669014063173; Sun, 20
 Nov 2022 23:01:03 -0800 (PST)
MIME-Version: 1.0
References: <20221109180249.4721-1-dnlplm@gmail.com> <20221109180249.4721-3-dnlplm@gmail.com>
 <20221110173222.3536589-1-alexandr.lobakin@intel.com> <CAGRyCJHmNgzVVnGunUh7wwKxYA7GzSvfgqPDAxL+-NcO2P+1wg@mail.gmail.com>
 <20221116162016.3392565-1-alexandr.lobakin@intel.com> <CAGRyCJHX9WMeHLBgh5jJj2mNJh3hqzAhHacVnLqP_CpoHQaTaw@mail.gmail.com>
 <87tu2unewg.fsf@miraculix.mork.no> <CAGRyCJFnh8iXBCyzNxzxSp9PBCDxXYDVOfeyojNBGnFtNWniLw@mail.gmail.com>
 <80e0a215-4b63-3ff9-3c31-765dbba5e7bb@quicinc.com>
In-Reply-To: <80e0a215-4b63-3ff9-3c31-765dbba5e7bb@quicinc.com>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Mon, 21 Nov 2022 08:00:51 +0100
Message-ID: <CAGRyCJEXLF7pbghH83scyO6mjAP3Emo32sgfQOcTeGSyToctMQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net: qualcomm: rmnet: add tx packets aggregation
To:     "Subash Abhinov Kasiviswanathan (KS)" <quic_subashab@quicinc.com>
Cc:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Il giorno dom 20 nov 2022 alle ore 18:48 Subash Abhinov
Kasiviswanathan (KS) <quic_subashab@quicinc.com> ha scritto:
>
> On 11/20/2022 2:52 AM, Daniele Palmas wrote:
> > Il giorno dom 20 nov 2022 alle ore 10:39 Bj=C3=B8rn Mork <bjorn@mork.no=
> ha scritto:
> >>
> >> Daniele Palmas <dnlplm@gmail.com> writes:
> >>
> >>> Ok, so rmnet would only take care of qmap rx packets deaggregation an=
d
> >>> qmi_wwan of the tx aggregation.
> >>>
> >>> At a conceptual level, implementing tx aggregation in qmi_wwan for
> >>> passthrough mode could make sense, since the tx aggregation parameter=
s
> >>> belong to the physical device and are shared among the virtual rmnet
> >>> netdevices, which can't have different aggr configurations if they
> >>> belong to the same physical device.
> >>>
> >>> Bj=C3=B8rn, would this approach be ok for you?
> >>
> >> Sounds good to me, if this can be done within the userspace API
> >> restrictions we've been through.
> >>
> >> I assume it's possible to make this Just Work(tm) in qmi_wwan
> >> passthrough mode?  I do not think we want any solution where the user
> >> will have to configure both qmi_wwan and rmnet to make things work
> >> properly.
> >>
> >
> > Yes, I think so: the ethtool configurations would apply to the
> > qmi_wwan netdevice so that nothing should be done on the rmnet side.
> >
> > Regards,
> > Daniele
>
> My only concern against this option is that we would now need to end up
> implementing the same tx aggregation logic in the other physical device
> drivers - mhi_netdev & ipa. Keeping this tx aggregation logic in rmnet
> allows you to leverage it across all these various physical devices.

Yes, that's true.

But according to this discussion, the need for tx aggregation seems
relevant just to USB devices (and maybe also a minority of them, since
so far no one complained about it lacking), isn't it?

Regards,
Daniele
