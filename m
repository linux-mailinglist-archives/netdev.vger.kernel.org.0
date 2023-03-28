Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4176CCD2E
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 00:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjC1WYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 18:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjC1WYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 18:24:17 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2713C18C;
        Tue, 28 Mar 2023 15:24:16 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id d18so11711005vsv.11;
        Tue, 28 Mar 2023 15:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680042255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3hV4mF2b0dl2HSibnf9nr0pb1AQqYGr+MNkEtckwW7k=;
        b=cQORJnlRDchWjuaNEryk4uM+AOPyNCb6zOXE09BFNsoSlr9KadX/dQVxqqqLYCwwwA
         qbS1OOWmpdW1+7thlRH0E9YExCZG9a0bvKex8PuqD0P+QmH5VRHOZBCgnU1Lly7XqZeu
         V/XlwpxzEpgRO11XlC7gO2FPn0GJhttWZjPegRjxoqhJvPiBys16rSFynukkOtTnBNjg
         1v0IoN285P1gej/OPmp32fpqTHTwlMoTsC1Y+hVtEU/qv2wzBnR6ENxyl9v9La0/Gosq
         5pDjmXDx7bJr/QV8g/lc4FkijEXTAdy29tmwADAorKB+XsG7fEgIkQQYR5QPEtCC0yVu
         72tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680042255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3hV4mF2b0dl2HSibnf9nr0pb1AQqYGr+MNkEtckwW7k=;
        b=P3Y5rVy214ahI51qzjWR4pt4bmc4XhAmgTRNCakfxxj2EQAEu7LB0vDfjFiOyK2aF8
         cx3H8gbN72tt5ZBuQ/a+7Z8pRZ71/x5L5g1/VI24xXGyxt8xRAn4gtJcKsamb4RMz9sj
         UsWz892Eu/x9ZMVpeHWjtJhg1XXLULUHlMMCKsmIOAaM0vNI+t0Rw2GxJFXBYrz80bFl
         fkbXD+9eLl13YUX2BpxXDDoGBYfC1HXRs19vZVwQ3Di56ccXIBvDb0b/+2/8drBKT6MW
         cvu4sao2UMxq3Ll5DYUCp9hvKjRADpPhU8Bt8uAg2nJsS16jyPhFvZYUw55/T5QhE7X+
         NVPw==
X-Gm-Message-State: AAQBX9fqIPHQvtwZ57Mb/VMM4K+8+whjm/8VMFtNmsZQNNkA5dEd0CGO
        oRpf66ev41P5z5NxwU5Mnwr9/PA1KfaR5PSRrVo=
X-Google-Smtp-Source: AKy350ajcy3flcngdcS/3J8JR8+oUIps5mm3giuR1XfAf9uxGXxeJ7tglG5TxULmk32FQUIJ6D2GdqDmjtNP8dLE43w=
X-Received: by 2002:a67:e01a:0:b0:421:947e:4470 with SMTP id
 c26-20020a67e01a000000b00421947e4470mr9658700vsl.2.1680042255092; Tue, 28 Mar
 2023 15:24:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230326233812.28058-1-steev@kali.org> <20230326233812.28058-5-steev@kali.org>
In-Reply-To: <20230326233812.28058-5-steev@kali.org>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 28 Mar 2023 15:24:02 -0700
Message-ID: <CABBYNZLh2_dKm1ePH3jMY8=EzsbG1TWkTLsgqY1KyFopLNHN6A@mail.gmail.com>
Subject: Re: [PATCH v8 4/4] arm64: dts: qcom: sc8280xp-x13s: Add bluetooth
To:     Steev Klimaszewski <steev@kali.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>,
        Johan Hovold <johan@kernel.org>
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

Hi Steev,

On Sun, Mar 26, 2023 at 4:38=E2=80=AFPM Steev Klimaszewski <steev@kali.org>=
 wrote:
>
> The Lenovo Thinkpad X13s has a WCN6855 Bluetooth controller on uart2,
> add this.
>
> Signed-off-by: Steev Klimaszewski <steev@kali.org>

I would like to merge this set but this one still doesn't have any
Signed-off-by other than yours.

> ---
> Changes since v7:
>  * Drop regulator now in a different patchset from Johan
>  * Fix alphabetization
>
> Changes since v6:
>  * Remove allowed-modes as they aren't needed
>  * Remove regulator-allow-set-load
>  * Set regulator-always-on because the wifi chip also uses the regulator
>  * cts pin uses bias-bus-hold
>  * Alphabetize uart2 pins
>
> Changes since v5:
>  * Update patch subject
>  * Specify initial mode (via guess) for vreg_s1c
>  * Drop uart17 definition
>  * Rename bt_en to bt_default because configuring more than one pin
>  * Correct (maybe) bias configurations
>  * Correct cts gpio
>  * Split rts-tx into two nodes
>  * Drop incorrect link in the commit message
>
> Changes since v4:
>  * Address Konrad's review comments.
>
> Changes since v3:
>  * Add vreg_s1c
>  * Add regulators and not dead code
>  * Fix commit message changelog
>
> Changes since v2:
>  * Remove dead code and add TODO comment
>  * Make dtbs_check happy with the pin definitions
>
>  .../qcom/sc8280xp-lenovo-thinkpad-x13s.dts    | 70 +++++++++++++++++++
>  1 file changed, 70 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts b=
/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
> index da79b5465a1b..129c5f9a2a61 100644
> --- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
> +++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
> @@ -24,6 +24,7 @@ / {
>         aliases {
>                 i2c4 =3D &i2c4;
>                 i2c21 =3D &i2c21;
> +               serial1 =3D &uart2;
>         };
>
>         wcd938x: audio-codec {
> @@ -1102,6 +1103,32 @@ &txmacro {
>         status =3D "okay";
>  };
>
> +&uart2 {
> +       pinctrl-0 =3D <&uart2_default>;
> +       pinctrl-names =3D "default";
> +
> +       status =3D "okay";
> +
> +       bluetooth {
> +               compatible =3D "qcom,wcn6855-bt";
> +
> +               vddio-supply =3D <&vreg_s10b>;
> +               vddbtcxmx-supply =3D <&vreg_s12b>;
> +               vddrfacmn-supply =3D <&vreg_s12b>;
> +               vddrfa0p8-supply =3D <&vreg_s12b>;
> +               vddrfa1p2-supply =3D <&vreg_s11b>;
> +               vddrfa1p7-supply =3D <&vreg_s1c>;
> +
> +               max-speed =3D <3200000>;
> +
> +               enable-gpios =3D <&tlmm 133 GPIO_ACTIVE_HIGH>;
> +               swctrl-gpios =3D <&tlmm 132 GPIO_ACTIVE_HIGH>;
> +
> +               pinctrl-0 =3D <&bt_default>;
> +               pinctrl-names =3D "default";
> +       };
> +};
> +
>  &usb_0 {
>         status =3D "okay";
>  };
> @@ -1222,6 +1249,21 @@ hastings_reg_en: hastings-reg-en-state {
>  &tlmm {
>         gpio-reserved-ranges =3D <70 2>, <74 6>, <83 4>, <125 2>, <128 2>=
, <154 7>;
>
> +       bt_default: bt-default-state {
> +               hstp-bt-en-pins {
> +                       pins =3D "gpio133";
> +                       function =3D "gpio";
> +                       drive-strength =3D <16>;
> +                       bias-disable;
> +               };
> +
> +               hstp-sw-ctrl-pins {
> +                       pins =3D "gpio132";
> +                       function =3D "gpio";
> +                       bias-pull-down;
> +               };
> +       };
> +
>         edp_reg_en: edp-reg-en-state {
>                 pins =3D "gpio25";
>                 function =3D "gpio";
> @@ -1389,6 +1431,34 @@ reset-n-pins {
>                 };
>         };
>
> +       uart2_default: uart2-default-state {
> +               cts-pins {
> +                       pins =3D "gpio121";
> +                       function =3D "qup2";
> +                       bias-bus-hold;
> +               };
> +
> +               rts-pins {
> +                       pins =3D "gpio122";
> +                       function =3D "qup2";
> +                       drive-strength =3D <2>;
> +                       bias-disable;
> +               };
> +
> +               rx-pins {
> +                       pins =3D "gpio124";
> +                       function =3D "qup2";
> +                       bias-pull-up;
> +               };
> +
> +               tx-pins {
> +                       pins =3D "gpio123";
> +                       function =3D "qup2";
> +                       drive-strength =3D <2>;
> +                       bias-disable;
> +               };
> +       };
> +
>         usb0_sbu_default: usb0-sbu-state {
>                 oe-n-pins {
>                         pins =3D "gpio101";
> --
> 2.39.2
>


--=20
Luiz Augusto von Dentz
