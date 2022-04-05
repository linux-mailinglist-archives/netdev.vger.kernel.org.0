Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B83114F44FA
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382213AbiDEUEx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447520AbiDEPqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 11:46:37 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1D6A777D
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 07:21:51 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id k2so7867230edj.9
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 07:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=nfFh/LslK5VRLsZhI4Mmp6pAWY+gEeRaK4OFqD/NR0M=;
        b=GNQDZ9c013z7mAHmHIuu53aFVBZVi5GRK3lMmGG2Wkcwajhdu4ejFaQQB8rSSy8Eva
         gQX/706T4TVIO6DTbwenoE4c5Uh2Aj99i5sV2CtFBPy4nFUh3eOw/iN4fHBlqvZis1H9
         1mn6eTBvvOIRt/y+Ga4/cLSmNIgNWOOkuDNYdCPOoUiGIhyvnHQqbI2Udgds7gTOp2oG
         hDadmbCwSDt5ZyjtQnuEhYuPO4h2zJDOEtsI+t+DqGaWsWXlwLAb2RJP80hFJhzJd4tY
         +16OWpwCmVIBe6n476wfhY/aiBpZ3uWrbQREAznh3H5a5IOHhuuxtIXOe5iQpzCyxA11
         gK3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=nfFh/LslK5VRLsZhI4Mmp6pAWY+gEeRaK4OFqD/NR0M=;
        b=uuJHo5cJXXaPZWIemKVXda6AVp60Gvru1VAO2gNgnJ3Ys9Eb0Qu+tbvoZ2vctLBpAX
         XavnEzSVdILywvt8OI1u5Dn2E6FpNRrqnSwWfZkerM1veY+fkuruerCk/5qs2CZqf3Jb
         U+8kQ9P/8dtPSjgT9zeavf7O2oqAGsMTGfLtPq8Wq8CPNxuPiJk5VCTZ2AjX3FHd6yn+
         5VH3lylDiwH+mQXySUc7jcZGeJ2hbtsTh68Ye45GL11xYyk10vAPQP6fH5eWnARAfBbp
         SljChuO5l/B8i7stwjUfuYvIJPVQPe5Q3l/Qaop4gqoQIRB7pWui/cwfXHZrP6jQLGCg
         4itg==
X-Gm-Message-State: AOAM533hY+q3C3H0jAZ/PW8GxmTEBBOpPuCfzlin/ePSHG3jsZKFaWCc
        4nb8M6SWL31QLl66ObaPGHzj0MrRgPc=
X-Google-Smtp-Source: ABdhPJyivcrHZlxGt9BEGAoBn3i1C2Flh0J6Ga1mDysFapOqR4ErhNsUc9qER9AsosP+wyfi6ILB/w==
X-Received: by 2002:a05:6402:84b:b0:419:85:b724 with SMTP id b11-20020a056402084b00b004190085b724mr3920885edz.413.1649168510099;
        Tue, 05 Apr 2022 07:21:50 -0700 (PDT)
Received: from smtpclient.apple (2001-1ae9-370-2000--da09.ip6.tmcz.cz. [2001:1ae9:370:2000::da09])
        by smtp.gmail.com with ESMTPSA id c5-20020a170906d18500b006ce371f09d4sm5507244ejz.57.2022.04.05.07.21.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Apr 2022 07:21:49 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [DSA] fallback PTP to master port when switch does not support it
From:   Matej Zachar <zachar.matej@gmail.com>
In-Reply-To: <YktrbtbSr77bDckl@lunn.ch>
Date:   Tue, 5 Apr 2022 16:21:47 +0200
Cc:     netdev@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <AC44DB40-88EB-4613-ABEA-FA8C1062EA3A@gmail.com>
References: <25688175-1039-44C7-A57E-EB93527B1615@gmail.com>
 <YktrbtbSr77bDckl@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,
thank you for the quick response.

> On 5. 4. 2022, at 0:04, Andrew Lunn <andrew@lunn.ch> wrote:
>=20
>=20
> Did you try just running PTP on the master device? I'm wondering if
> the DSA headers get in the way?

Yes this is exactly the problem as the master device is used as =
=E2=80=9Cconduit interface=E2=80=9D
so the switch is dropping the frames as there are no correct DSA headers =
present.

So running ptp4l on eth0 (master) interface configures the hardware =
time-stamping correctly but no traffic is received.
running it on lan1 (slave) interface you get the packets but no hardware =
time-stamping support.

I though this should be in a way similar to the case when you run ptp4l =
over vlan interfaces (without dsa switch) - it fallbacks to the master =
port.

>=20
> What i don't like about your proposed fallback is that it gives the
> impression the slave ports actually support PTP, when they do not. And
> maybe you want to run different ports in different modes, one upstream
> towards a grand master and one downstream? I suspect the errors you
> get are not obvious. Where as if you just run PTP on the master, the
> errors would be more obvious.
>=20

I=E2=80=99m using switch ports in =E2=80=9Csingle port=E2=80=9D =
configuration so there is lan1 lan2 interfaces connected to different =
network segments.
So it can behave as you described in upstream/downstream configuration =
as =E2=80=9Cboundary=E2=80=9D PTP clock or as a redundancy where
lan1 & lan2 are connected to physically separate networks - including =
switches and cables.=20

>=20
> And this is another advantage of just using master directly. You can
> even use master when the switch ports do support PTP.

I do not see how is that possible as the DSA headers are in the way and =
packets get dropped by the switch but maybe I am missing something.

My second idea was to check the return values and fallback based on that =
so the switch driver could still implement
.get_ts_info and .port_hwtstamp_get/set from dsa_switch_ops struct. This =
was just quick proof to test if it would work over slave interface.

If there is better approach I could explore I=E2=80=99m happy to try.

Matej.

