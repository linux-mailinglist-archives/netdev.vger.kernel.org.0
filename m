Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDAC06B8237
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 21:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbjCMUH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 16:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjCMUHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 16:07:55 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D44087377;
        Mon, 13 Mar 2023 13:07:46 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id k10so53395541edk.13;
        Mon, 13 Mar 2023 13:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1678738065;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GiBmsXv0ePWzwqyMcIjHrkWJHCEm3Erfo/N/cMfRs98=;
        b=JbOChwnBmnyovZLjPqQNJBf2FzE26m9XBea2+vx42DAnQmPUIVq974tbH+3tDBR3Rl
         ppWlyq9WHW4HDlg9phiT/4QnJUTQcB3Yl3QXTkrSgkZ6hTKzDrx9Z+QcWFbAKWVwtIbr
         U12wKHwDxE5yxE337J7LG53q3c6sSuf3Knf1xmxiOZVkQUOIZxUrH1fWT6bjDnWBVK7j
         hzcUU9zfyXu9NigaS3Wfz1o6CCUqgcFFATBpiwiIgSfcOYN97W0+zWFEqx+ZFdZjgUo5
         uovLBx/8AFMJupN92HJl7f3ANKTO+3OZE8rHNFKaLYpbFPI1YyoTes8Vb3xk4ZFFmgtu
         Y0cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678738065;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GiBmsXv0ePWzwqyMcIjHrkWJHCEm3Erfo/N/cMfRs98=;
        b=l5THbEe2XqK19RIu0CZoRGd7xnDz2D43c/yWPoAHWuKpgexkBepBiF/sUMHvKHXL8M
         zJtxQVtzSJoAY3HXW9Fn04sqfh8pTt+SFTJwyBTfTv5EyMGbnbnjY7bTdnIYmntUppeH
         F3KuoOuK4O7zwgvrVMh0dilAvRRLTSSPFq+36/T35uyx4HAhPbWHKhhycxCcutkvS9TP
         77GyXKX7PCOiYELfOcddKNlA73TQAG1uC+P8rGdWxwTLn+qcfNJbzLUDyZ9PCErjmKTI
         wpLZ1yqKG3x/nEpXKN7aSqGrU5vQ/fVY44NbEOVm+Xffzwxq3L/BbX3WOJ0GDutI+sFy
         /dTg==
X-Gm-Message-State: AO0yUKWjWRnGugwCGRNYZoLw5J6if/pDs6wZRiRophDTA73qzraQxUAm
        4LmmliV/xTe/uMUwE6IEXOAeTPYplsCfzqBeWJiJe0nPmOw=
X-Google-Smtp-Source: AK7set8jeKafsOelcj8LqLf4chBnnzqFG3jevgBC418WgFcnc7dLfrVFu6YBx6SDoeTt9JSf7zj+8fKZiTdLusmFmBs=
X-Received: by 2002:a17:906:27ce:b0:91f:a4b8:9a4a with SMTP id
 k14-20020a17090627ce00b0091fa4b89a4amr4792596ejc.6.1678738064856; Mon, 13 Mar
 2023 13:07:44 -0700 (PDT)
MIME-Version: 1.0
References: <20230310202922.2459680-1-martin.blumenstingl@googlemail.com>
 <20230310202922.2459680-2-martin.blumenstingl@googlemail.com> <14619a051589472292f8270c2c291204@realtek.com>
In-Reply-To: <14619a051589472292f8270c2c291204@realtek.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Mon, 13 Mar 2023 21:07:33 +0100
Message-ID: <CAFBinCBpeOH4tzrqHxPQ475=HLOWDKfJYLEEigfTmTJwQbGAAw@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 1/9] wifi: rtw88: Clear RTW_FLAG_POWERON early in rtw_mac_power_switch()
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Morgan <macroalpha82@gmail.com>,
        Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Ping-Ke,

On Mon, Mar 13, 2023 at 3:29=E2=80=AFAM Ping-Ke Shih <pkshih@realtek.com> w=
rote:
[...]
> > +       if (!pwr_on)
> > +               clear_bit(RTW_FLAG_POWERON, rtwdev->flags);
> > +
> >         pwr_seq =3D pwr_on ? chip->pwr_on_seq : chip->pwr_off_seq;
> >         ret =3D rtw_pwr_seq_parser(rtwdev, pwr_seq);
> >         if (ret)
>
> This patch changes the behavior if rtw_pwr_seq_parser() returns error whi=
le
> doing power-off, but I dig and think further about this case hardware sta=
ys in
> abnormal state. I think it would be fine to see this state as POWER_OFF.
> Do you agree this as well?
I agree with you. Also I think I should have made it clearer in the
description of the patch that I'm potentially changing the behavior
(and that this is not an issue in my opinion).
If there's any problem during the power on/off sequence then we can't
be fully sure about the power state.
If you have any suggestions how to improve this then please let me know.


Best regards,
Martin
