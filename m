Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB5B6D5182
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 21:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbjDCTmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 15:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjDCTl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 15:41:59 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B66C26A9;
        Mon,  3 Apr 2023 12:41:58 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id t10so121608738edd.12;
        Mon, 03 Apr 2023 12:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680550917;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YxDGLkY3AgV1LJ1NKgh+QPL9Z2Q+niKhWjXSsHgdVqk=;
        b=ESSVcu8h+tXGIpKQGUW5MZciMkziOYr/EQJ6In47HzHv768HyLwII12DayfyEws3u8
         y1V7e2HKIGDHxdZLWrbnIpDo+bkQTUx2xBzdU7H+MruNpJxwKresu1RiMWzwtj4ajUD3
         RyVTHMdoPTHYzyej4je5IUJwZOz85U7aYCcBaJbPXgejU3PhXKr0ZhaB5p7l2ASn3ody
         ORpAiJ6pDjc/GVTi8wiBmx96XV4k8u1QC8zO8a2MyN51mfXrzARWDzal+zKOFKSL6hXe
         sFiPZdZo7hGnoKXUOz05c+ihV4j23+mcliFp5wee2CvFXB6bgqzxK658FGNWD7MaPKj9
         068g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680550917;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YxDGLkY3AgV1LJ1NKgh+QPL9Z2Q+niKhWjXSsHgdVqk=;
        b=I61hMjaSJq/CFQE2vMM0K7FWQUjxt1XevRm1rEWLFko014syvcnHqqz/UBW7CHCV6D
         yGb1uLVX+CkvwTk9cLByTdIMcwFKBjeRcaEDzR7NLDlV/7uMbRxypfasyygZWaT0/oWR
         62uxwIlXQTqrQRAPizC0EkjyAFCCuFNafnBx7nPN9jqjYUFVPXN7QuevIMyuYL0bua1B
         jIxH1dcy8p2ya+4cq4wneHk0CesRNup+NMgz1gwbSj8ttOQjNJlPT0la3AjKXK2ifK/5
         K17GKWq4lXvLiqgJ1HdIcaehsO2CAuo1R+cqLrURPjOsM67WWDqju+EVn/V4UWLl6kru
         5B/g==
X-Gm-Message-State: AAQBX9eqtm2SoNuf8ljhH9rgzRbGccOYAFmu3/PHYgjdy3Wfjnqfg3Bi
        V4TA1w95a+YAa2nzAKBU6XAS7MabR2Xh1Z5LCKE=
X-Google-Smtp-Source: AKy350bKv+uglF73a6FGKgUTe6qjlcm/cjVAJSO0AhQJ0YqziM7up/wHJcBRhvmy7kKwvyxPTTLXj11A8Vj8ebQ1CjQ=
X-Received: by 2002:a50:9fad:0:b0:4c1:6acc:ea5 with SMTP id
 c42-20020a509fad000000b004c16acc0ea5mr203405edf.4.1680550916602; Mon, 03 Apr
 2023 12:41:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230108211324.442823-1-martin.blumenstingl@googlemail.com>
 <20230108211324.442823-2-martin.blumenstingl@googlemail.com>
 <20230331125906.GF15436@pengutronix.de> <CAFBinCB8B4-oYaFY4p-20_PCWh_6peq75O9JjV6ZusVXPKSaDw@mail.gmail.com>
 <20230403100043.GT19113@pengutronix.de>
In-Reply-To: <20230403100043.GT19113@pengutronix.de>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Mon, 3 Apr 2023 21:41:45 +0200
Message-ID: <CAFBinCBeZ4EKdx_3erL9vC25Am+uUX+5z2_RkSK9igBAcb5Y1g@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] wifi: rtw88: Move register access from
 rtw_bf_assoc() outside the RCU
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     linux-wireless@vger.kernel.org, tony0620emma@gmail.com,
        kvalo@kernel.org, pkshih@realtek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jernej Skrabec <jernej.skrabec@gmail.com>
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

Hi Sascha,

On Mon, Apr 3, 2023 at 12:00=E2=80=AFPM Sascha Hauer <s.hauer@pengutronix.d=
e> wrote:
[...]
> > There's a module parameter which lets you enable/disable BF support:
> > $ git grep rtw_bf_support drivers/net/wireless/realtek/rtw88/ | grep pa=
ram
> > drivers/net/wireless/realtek/rtw88/main.c:module_param_named(support_bf=
,
> > rtw_bf_support, bool, 0644);
>
> I was a bit too fast reporting this. Yes, there seems to be a problem
> with the RTW8821CU, but it doesn't seem to be related to this patch.
>
> Sorry for the noise.
Thanks for investigating further and confirming that this is not the cause!
And don't worry: we're all human and with complex drivers that can be
impacted by so many things (other APs, phones, antennas, ...) it's
easy to miss a tiny detail (I've been there before).


Best regards,
Martin
