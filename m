Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEA25B3B62
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 17:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiIIPDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 11:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiIIPDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 11:03:22 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8325C13A06F
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 08:03:21 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id c2so2064446plo.3
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 08:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=f2YUUwJDAVlUrqV3xfNV9L0eobiqO7cjOCtBa/Texpk=;
        b=GVOkxgZO3Bzf/TyF5L/d+Ft/3uSsoZkdX857zno1xT3763/un3Em9ZyEwDXiROqcuY
         komRCgHjuU8iGyV1u8UBxlhhdJIMQ5kYvURMGKnDUG6I3vZ8CnwuhVA/7EBbt1u+0jeo
         TtOyRWJdtdlWhoLY7SnQ8qOqyC1meLaGU/6LvqflWQFeN9vmt8g+gml0IIDQ02BZaHkP
         MC0T2RwMXrWsow53UiPWYAkIctf7wHtW6FvTnCJsCpPo0K4kuBJYp4Okmih0dSJrG0gV
         lfZFM1wprPU/jfr3XC//pGmoMIES71w1/nzWXH8VRBkeouEy81mV2tGpZRT/fDawwz7s
         Bw0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=f2YUUwJDAVlUrqV3xfNV9L0eobiqO7cjOCtBa/Texpk=;
        b=xV011Cy1Yh9ySnhM1tHIFu1G8TgaxVOLCjq62q8/zLlb8/Rcmd+mDN42uaB2AtjcW1
         5PQiR6ZQI0qOHp2nafQ8s2FfaKoUXQSmhO4ZCUy+X7UGaVJvpYtbBa8K19Pd5PIe1YT/
         0Oz44pKl8RCIGsdaxpTJBxiDA9pcteLun2Uttq4Y4kCCZHKwATCl2H4Gha4v9L28qUOa
         tkqAFeZ9F6E1/DcUviYbZ6hqnw5TNgsL+b1F+s/cRFJ6U+MDVB2xj9AOeafv1szeQvtV
         SVGEIXYXGUyM0BzAzu/u8cXMd8k8Rxdmc/YI6Nkca2701HdGp/eZFmyRFKObaE+17iSm
         qV3Q==
X-Gm-Message-State: ACgBeo2YluHO+50HvhrUsOA2Tzna6H1dEkBdaz4UiYJvYn5CGtZDXVit
        sh/1Pl8sfQZzDOqDXE/4swtYPNog6vWZCg==
X-Google-Smtp-Source: AA6agR5qFcHGmHojntLeZ/4b0aS+aG/IBanxvkEOUo2FhuDhXEmw8+cJxyy5Sm6Np2YYHeCMCpGYow==
X-Received: by 2002:a17:903:3014:b0:176:e498:2340 with SMTP id o20-20020a170903301400b00176e4982340mr14783117pla.119.1662735800914;
        Fri, 09 Sep 2022 08:03:20 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id l9-20020a170902f68900b0016be596c8afsm531130plg.282.2022.09.09.08.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 08:03:20 -0700 (PDT)
Date:   Fri, 9 Sep 2022 08:03:18 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        David Ahern <dsahern@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH iproute2] ip link: add sub-command to view and change
 DSA master
Message-ID: <20220909080318.0b7bbf85@hermes.local>
In-Reply-To: <YxrYrhSRayY03ahF@d3>
References: <20220906082907.5c1f8398@hermes.local>
        <20220906164117.7eiirl4gm6bho2ko@skbuf>
        <20220906095517.4022bde6@hermes.local>
        <20220906191355.bnimmq4z36p5yivo@skbuf>
        <YxeoFfxWwrWmUCkm@lunn.ch>
        <05593f07-42e8-c4bd-8608-cf50e8b103d6@gmail.com>
        <20220908125117.5hupge4r7nscxggs@skbuf>
        <403f6f3b-ba65-bdb2-4f02-f9520768b0f6@kernel.org>
        <20220908072519.5ceb22f8@hermes.local>
        <20220908161104.rcgl3k465ork5vwv@skbuf>
        <YxrYrhSRayY03ahF@d3>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Sep 2022 15:09:50 +0900
Benjamin Poirier <benjamin.poirier@gmail.com> wrote:

> On 2022-09-08 16:11 +0000, Vladimir Oltean wrote:
> > On Thu, Sep 08, 2022 at 07:25:19AM -0700, Stephen Hemminger wrote: =20
> > > On Thu, 8 Sep 2022 08:08:23 -0600 David Ahern <dsahern@kernel.org> wr=
ote: =20
> > > > > Proposing any alternative naming raises the question how far you =
want to
> > > > > go with the alternative name. No user of DSA knows the "conduit i=
nterface"
> > > > > or "management port" or whatnot by any other name except "DSA mas=
ter".
> > > > > What do we do about the user-visible Documentation/networking/dsa=
/configuration.rst,
> > > > > which clearly and consistently uses the 'master' name everywhere?
> > > > > Do we replace 'master' with something else and act as if it was n=
ever
> > > > > named 'master' in the first place? Do we introduce IFLA_DSA_MGMT_=
PORT as
> > > > > UAPI and explain in the documentation "oh yeah, that's how you ch=
ange
> > > > > the DSA master"? "Ahh ok, why didn't you just call it IFLA_DSA_MA=
STER
> > > > > then?" "Well...."
> > > > >=20
> > > > > Also, what about the code in net/dsa/*.c and drivers/net/dsa/, do=
 we
> > > > > also change that to reflect the new terminology, or do we just ha=
ve
> > > > > documentation stating one thing and the code another?
> > > > >=20
> > > > > At this stage, I'm much more likely to circumvent all of this, an=
d avoid
> > > > > triggering anyone by making a writable IFLA_LINK be the mechanism=
 through
> > > > > which we change the DSA master.   =20
> > > >=20
> > > > IMHO, 'master' should be an allowed option giving the precedence of
> > > > existing code and existing terminology. An alternative keyword can =
be
> > > > used for those that want to avoid use of 'master' in scripts. vrf i=
s an
> > > > example of this -- you can specify 'vrf <device>' as a keyword inst=
ead
> > > > of 'master <vrf>' =20
> > >=20
> > > Agreed, just wanted to start discussion of alternative wording. =20
> >=20
> > So are we or are we not in the clear with IFLA_DSA_MASTER and
> > "ip link set ... type dsa master ..."? What does being in the clear even
> > mean technically, and where can I find more details about the policy
> > which you just mentioned? Like is it optional or mandatory, was there
> > any public debate surrounding the motivation for flagging some words,
> > how is it enforced, are there official exceptions, etc? =20
>=20
> There are more details in
> Documentation/process/coding-style.rst, end of =C2=A74.

See Also:

https://inclusivenaming.org/
https://docs.linuxfoundation.org/lfx/project-control-center-pre-release/too=
ls/security/manage-non-inclusive-naming

