Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6090750FB5C
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 12:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349430AbiDZKuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 06:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346469AbiDZKtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 06:49:31 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46972AC6F
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 03:45:34 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-2f7d19cac0bso70511557b3.13
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 03:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nathanrossi.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1LbavT3LkvBnPpf+Xg/axGsnbaFHBATYMxSGbn93c9A=;
        b=cIg12B0GcGwK6aaDPRlq4eNs7XBHGZROmNxN9pbLNI2/ziSDKEC4sgQ55w+XG4xL/R
         MOI39pNJYUAWUqc9Y8BZXm21OQqK26E2NcASnlhKxZkdTBhq/HTiryR/v+4kA7VKbBTg
         Hsy3CO4GKV89QUNmn9y4KDQ3CFfWtt8sn6GNqty8VscXO2Guj3y1gHCXbOLtj/TN8Qnw
         rWemHgAeKY+8WK6rlObkeXIqq4Xkt6RAklG0BaqwKncvRGBBruVg2OtY61akuyXqchRI
         S7bYVLDDlq99ydH3IyvGYTEHFy9KSkm9dDLEfWq0Mx0Mm8ZDfxgMub8sDNIHfSeRGZ4X
         S9DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1LbavT3LkvBnPpf+Xg/axGsnbaFHBATYMxSGbn93c9A=;
        b=iFhWhd3JyWsSi82pt1c1r6nBeGAcBMrLTmzyGaRpy55tUoMEzNz7Y0UzoVyoJtjoI3
         A+B3nz4fRWReHQPyK5pYldf0sQH2PaHcxDZtdg3m9ulZokIzoTd7ewwthjpXcYPbNEdl
         XoJE6EkU6vf4WhTthiJCJJpCVJ1TldbGpd/B4oAuhLJbemN9Xdjz80o73hbv48XhdBgw
         WY8mJExZg/HCaFWhe+n1lQlX0tA+Rt+M4TPoR3rpJSTin70lzA4uyn867qL1DrFLjOpK
         /2RSkqFiIeP4zYOG3kM5EEHy9tQ0GwKMAi26CBeus+V2VzHEvRrGMAFrOA5Y1bKCvhWH
         yUDg==
X-Gm-Message-State: AOAM532/28EGS3n8nHqrY8KKgGTvdmS2/SRagX+Gu4UQTq1Y9+gdr1uC
        uOln8c4MRrRds24jAnWb92vStruhy0U+SvEADdnTvA==
X-Google-Smtp-Source: ABdhPJxSgedRHX+4qH42vMO9+QfPTLyf0S87cc+CNQ2WoHxOmWy0B46391HnRsFebUzXIignQYzmAWSYQ8TO8Btl0mc=
X-Received: by 2002:a81:3648:0:b0:2eb:c4c2:2920 with SMTP id
 d69-20020a813648000000b002ebc4c22920mr20999279ywa.291.1650969933910; Tue, 26
 Apr 2022 03:45:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220423132035.238704-1-nathan@nathanrossi.com>
 <20220423152523.1f38e2d8@thinkpad> <43773a65a27cb714e3319b06b0215fcb0471aae6.camel@redhat.com>
In-Reply-To: <43773a65a27cb714e3319b06b0215fcb0471aae6.camel@redhat.com>
From:   Nathan Rossi <nathan@nathanrossi.com>
Date:   Tue, 26 Apr 2022 20:45:22 +1000
Message-ID: <CA+aJhH0Eg4BnohkQupLW0u473-WmuTXD0u2ShZfU19XN7JD-ew@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: Skip cmode writable for mv88e6*41 if unchanged
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Apr 2022 at 17:50, Paolo Abeni <pabeni@redhat.com> wrote:
>
> Hello,
>
> On Sat, 2022-04-23 at 15:25 +0200, Marek Beh=C3=BAn wrote:
> > On Sat, 23 Apr 2022 13:20:35 +0000
> > Nathan Rossi <nathan@nathanrossi.com> wrote:
> >
> > > The mv88e6341_port_set_cmode function always calls the set writable
> > > regardless of whether the current cmode is different from the desired
> > > cmode. This is problematic for specific configurations of the mv88e63=
41
> > > and mv88e6141 (in single chip adddressing mode?) where the hidden
> > > registers are not accessible.
> >
> > I don't have a problem with skipping setting cmode writable if cmode is
> > not being changed. But hidden registers should be accessible regardless
> > of whether you are using single chip addressing mode or not. You need
> > to find why it isn't working for you, this is a bug.
>
> For the records, I read the above as requiring a fix the root cause, so
> I'm not applying this patch. Please correct me if I'm wrong.

You are correct. Sorry I forgot to reply to this thread after posting
the root cause fix.

For reference the root cause fix to the issue mentioned by this patch
is https://lore.kernel.org/netdev/20220425070454.348584-1-nathan@nathanross=
i.com/.

Thanks,
Nathan

>
> Thanks,
>
> Paolo
>
