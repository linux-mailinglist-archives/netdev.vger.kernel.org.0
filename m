Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE7B6B60BD
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 21:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjCKU4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 15:56:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjCKU4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 15:56:46 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7FC44C6F6;
        Sat, 11 Mar 2023 12:56:44 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id fd5so274443edb.7;
        Sat, 11 Mar 2023 12:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1678568203;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wG89qGDC53apMqtBOHTRtgFqgYqAhyr7mdrOysqyOUk=;
        b=ZKfWGHw6RRcpr6YKONN9XeUHZ5IAiAD2mfB6TNmsxLwfetbah0ZXY5eTWMcljMaP27
         8IV61+03NE4F+X5MHzGWo+j/mNpAPg07OGJSBhKEAdZ3rXI6Z0xH0EhQROvX3X/L1Myl
         IwsnuHDdvzIIs25yvEvBhTkOxrmlOCh+6yDnexHlkSCBkQwyq9Psp8uqXBecjM7/2n8M
         56OkJE9FmrtDA6xTYyJqlV52uDW9cqkJOClmmBp62w8fWKUccuOk7u+33f+sCsVQ0HyM
         rsUnx0VtNY0pOio4j9i07+NmuuYgJnfUGpmAWDwMQPAu2g7OJA0hTDeV5ZJFynzq01Oz
         jqNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678568203;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wG89qGDC53apMqtBOHTRtgFqgYqAhyr7mdrOysqyOUk=;
        b=5y2tSvNU4H11Run4AdFe4OOun1dmMyQ4N/2L1pEmRck0KlUOZO3iAsULwwHEdF+wYP
         Cg+o1XUcoHbhnIUrVgj0DsC3mXZmiAr/uNYOgF3w98lrpqX7DYwSMUsfagF9vXW39ebF
         UiCh9uim5piSok/26ewZ1OAEWYv/S9L53TCj7GizjzCu2+WPF5Y5zN3g2BJ/PnYPof8g
         dVawhIPxtegUsvQoPBwIpspLr8WKVCzp+asydg6ZMqouzLGF3D+VPubLbysQUfiWGRxG
         UVWX+rbBoWxcJgJ7wIV+lgR1Sy9H59vuyL1BmziqQ8lgDiJQZt95zf2RRaJ3j9hh+MZs
         o5Xg==
X-Gm-Message-State: AO0yUKURr62jkHsqPAvTR7h28JSM8/LKicXToRJ6dYP0fHXE7mTTRb3K
        Za+ii6zu0BBP+IQNUwkQ/HIpfnC2RGYIf6mDumk=
X-Google-Smtp-Source: AK7set+fjGgwpMDd9lM1+8OU+R3Kaa85CmMo0pVrMx2+MYZcrTHwZ7KlV4WOukKoD1BbZY72PNg6s9uocAsnrptj7XE=
X-Received: by 2002:a17:906:3002:b0:8dc:6674:5bac with SMTP id
 2-20020a170906300200b008dc66745bacmr15580598ejz.4.1678568203082; Sat, 11 Mar
 2023 12:56:43 -0800 (PST)
MIME-Version: 1.0
References: <20230310202922.2459680-1-martin.blumenstingl@googlemail.com> <174f91fc-7629-e380-4ca1-56eb39ea24ea@lwfinger.net>
In-Reply-To: <174f91fc-7629-e380-4ca1-56eb39ea24ea@lwfinger.net>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sat, 11 Mar 2023 21:56:32 +0100
Message-ID: <CAFBinCAn7zD-sF+5B1OHztaijt6OHFZWHM-ayxYY0=z0zkaJCg@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 0/9] rtw88: Add SDIO support
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Chris Morgan <macroalpha82@gmail.com>,
        Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Larry,

On Sat, Mar 11, 2023 at 3:16=E2=80=AFAM Larry Finger <Larry.Finger@lwfinger=
.net> wrote:
[...]
> I am not qualified to review the code, but I am integrating this version =
into my
> rtw88 repo at GitHub.com.
>
> It is essential that a successful build is possible after every patch is =
applied
> so that an arbitrary bisection will not fail to build. This patch series =
fails
> after #2 is committed. File mac.c needs symbol SDIO_LOCAL_OFFSET, which w=
as
> moved from mac.h to sdio.h. I resolved this be including sdio.h in mac.c.=
 This
> breaks #3, where you add the include to mac.c. It needs to happen one pat=
ch earlier.
Thank you for spotting and reporting this issue! You are right with
this, I'll add the sdio.h include to mac.c with patch 2 to resolve
this issue as you suggested.

> The other problem for my repo is that it cannot modify
> include/linux/mmc/sdio_ids.h, thus I have to create a local sdio_ids.h to
> contain the new definitions. Once your patches are in the kernel, I will =
be able
> to eliminate this work around.
You can also modify the three SDIO driver files (rtw8821cs.c,
rtw8822bs.c, rtw8822cs.c) and use the literal IDs there if you have to
patch those files anyways.

> I do not have any rtw88 SDIO devices, thus I will not be able to test, bu=
t I
> will pass any information that I get from my users.
That sounds great - thank you!


Best regards,
Martin
