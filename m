Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452336D6EF6
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 23:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236440AbjDDV2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 17:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236422AbjDDV2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 17:28:04 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395551BD9;
        Tue,  4 Apr 2023 14:28:02 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id eg48so136026612edb.13;
        Tue, 04 Apr 2023 14:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680643681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F3Vq2XM6fughuFDtm5c57GN5MrdDCrraoSvfrWiblQU=;
        b=Aguc2+EVruaoWDmeWTp/rvZXkJ7uOVa1KmiiPwiNegAiDA4WZWeOUGDz8seHfMwUY1
         1O1rDFP8XJjK1tcN9X2bIIQcg/jVtlzbTGMseEBWMRfnRKkZBBWM1cDR0dbB/ISqGNNP
         d4tdXDCfl4lZ8toTldRZAsSYXn/+r5H1CBkDdna1nnabXPfqho3Ta7lC2FILdYqMEmgU
         tTUfV6iEpFxnNUDEyxtTyAMwcf5t5SisFTpXvumkoqhAAM1y0hXKr9Mdeun4tYt1A4b1
         /QOaBFb9PF02DVewDATyzTI1jd+Fdw17v4aeV/fMvNL6dHc96Z78m1YKzpENPNfQsYDz
         C8Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680643681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F3Vq2XM6fughuFDtm5c57GN5MrdDCrraoSvfrWiblQU=;
        b=jJZ/O2YLYwTvKVTruXg88TjrgsH8bXZF9ut3Qom+fAojALWkHV5vjWPjghmpr++MMU
         5JYCQG5gfGLisN7RWH8htThpnVTsJvjLXqhrh6F7sGrhjuRMZWjwS4xlXGlct2tSWBt+
         LQTCwOD4T8sETmukLSjOMFN852KP16tK6WBmklRpVgbrx2BAszK9IaysjjlaM0jnaIBY
         MxwlCusxMKl+smnaMdeu5PPUHqWHAuh8n2ALcV9P6cBWFOy18zCl8hT5/0zpD19XTBmp
         SBiiib4/v9SIa8PoxHCy29c8UkOuF6rIer48EPAkDY4wGriNGoCtN5Pi8jfiuUYy/SRt
         cgGQ==
X-Gm-Message-State: AAQBX9fVbRPu9kQVisPO6IlR3T72eCC6bN76EHpuCpVWK0gCqCeAO0cw
        Xio62iuUrlyahACOciV4D5xC+srJjz4WymQZDqPBKs83SOc=
X-Google-Smtp-Source: AKy350b9THEdFpt47q44R8kiLay24lRQn+dpAYK09CzKuT0xT0W0dwuzwx4PYA6d/G5OSNmH5bBzzgihj/lFtVstHYU=
X-Received: by 2002:a17:906:3e0d:b0:92f:cbfe:1635 with SMTP id
 k13-20020a1709063e0d00b0092fcbfe1635mr535348eji.6.1680643680653; Tue, 04 Apr
 2023 14:28:00 -0700 (PDT)
MIME-Version: 1.0
References: <20230403202440.276757-1-martin.blumenstingl@googlemail.com>
 <20230403202440.276757-10-martin.blumenstingl@googlemail.com>
 <642c609d.050a0220.46d72.9a10@mx.google.com> <CADcbR4LMY3BF_aNZ-gAWsvYHnRjV=qgWW_qmJhH339L_NgmqUQ@mail.gmail.com>
In-Reply-To: <CADcbR4LMY3BF_aNZ-gAWsvYHnRjV=qgWW_qmJhH339L_NgmqUQ@mail.gmail.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Tue, 4 Apr 2023 23:27:49 +0200
Message-ID: <CAFBinCC2fr42FiC_LqqMf2ASDA_vY1d-NJJLHOF6pW1MjFRAzw@mail.gmail.com>
Subject: Re: [PATCH v4 9/9] wifi: rtw88: Add support for the SDIO based
 RTL8821CS chipset
To:     Chris Morgan <macroalpha82@gmail.com>
Cc:     linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Chris,

On Tue, Apr 4, 2023 at 8:16=E2=80=AFPM Chris Morgan <macroalpha82@gmail.com=
> wrote:
>
> Please disregard. I was building against linux main not wireless-next.
> I have tested and it appears to be working well, even suspend works now.
Thanks for this update - this is great news!
It's good to hear that suspend is now also working fine for you.

It would be awesome if I could get a Tested-by for this patch. This
works by replying to the patch with a line that consists of
"Tested-by: your name <your email address>". See [0] for an example.


Best regards,
Martin


[0] https://lore.kernel.org/linux-wireless/4a76b5fe-c3d6-de44-c627-3f48fafd=
d905@lwfinger.net/
