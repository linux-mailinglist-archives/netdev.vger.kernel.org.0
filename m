Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFEDD6BD86C
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 19:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjCPS5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 14:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjCPS5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 14:57:19 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5335DCF53
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 11:57:11 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id x13so11609448edd.1
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 11:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google; t=1678993030;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ISoDwGmCZfIt1++Qrq4EaM3UW6i2EJ00oUlk42ZAa4k=;
        b=V34nuHzb1E1n6ArHtHa/MyOWRtt1PmPMxzBmbNZ70ayTY98fyYvgyrBPtlxZTjt10O
         lcuHVx7snGom/yUxsRx5nKqnb/yl03a4EWJTrGqyjjo68Aqsy/DQRWfmH0L322qjXkGZ
         YjDrMlA56pufnTtXHbENe3k35Br34XL7XIt6c+nHVpCgUU+HYpwxYx0CnXzmoW4cVZew
         oKJl3xnnxfcomJvZQc3MUZDsx7bqVXIanxILdL7nKWbL6VJfpIGqwQRmRtHzNy+ayTDD
         NehCB+jT9oMLIKdvSeqa2/tp5E0ZbFN4UP3ZoIzXLCtYfzk8Cs2RRd3Pi3Fcz52Be0Ry
         JcpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678993030;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ISoDwGmCZfIt1++Qrq4EaM3UW6i2EJ00oUlk42ZAa4k=;
        b=oABYgkBDJEWmjNeXB80FMmPqkTt+MOHLkdGLhskUvPEjJHWIBYwaFjH9ABWySow9V1
         wAvacPUpqDVQZ804OdelJc9JvKQhpfytE+u8XNA0PJVz6vfJhUej1NviSx/8yTbLV+MW
         R1KNphj74G7EtRXH7AE+zaJ8Poe+en6Sq1Bk1in31mVPMyMySjGSyLqSx9BqvUGXOcgo
         NRX3krjSWxh6Y0om3d9e2nmCb2u/sLGOlmx9HuL/aeDXC0aZUUUhgBZHvD1Mc6xet9Mx
         VKJ1HFD7psymFnZGe5sCwnX9ZLwdaboWRxqZbPUudqviv3L0hy1ma2CobHiNhnMfs2vQ
         RMtQ==
X-Gm-Message-State: AO0yUKXVYcZOYk/aXtISi1eKoyjXYhhx7UKyXico7tYUKgWUVOzhATXr
        YAGH6a1ScFlF09oUkKCjIwo5JmhRFC73xjWl+z2c+w==
X-Google-Smtp-Source: AK7set8R6MPvl1jYDipFYGi3DvPwtseUsQ8EVHZ1VfSLTTmEQjtyKWaAM4IDrmaaOglEDFXN0af7mz8G306mXMeEY84=
X-Received: by 2002:a50:f683:0:b0:4fc:473d:3308 with SMTP id
 d3-20020a50f683000000b004fc473d3308mr360427edn.8.1678993030292; Thu, 16 Mar
 2023 11:57:10 -0700 (PDT)
MIME-Version: 1.0
References: <20230316034759.73489-1-steev@kali.org> <20230316034759.73489-3-steev@kali.org>
 <f7be8db9-0bdd-644d-c7a0-4321041c5028@molgen.mpg.de>
In-Reply-To: <f7be8db9-0bdd-644d-c7a0-4321041c5028@molgen.mpg.de>
From:   Steev Klimaszewski <steev@kali.org>
Date:   Thu, 16 Mar 2023 13:56:59 -0500
Message-ID: <CAKXuJqiPKJ_Jus2gwA94gQAb-7-PBAZL4CSaFcxpx3+UXBYS-A@mail.gmail.com>
Subject: Re: [PATCH v6 2/4] Bluetooth: hci_qca: Add support for QTI Bluetooth
 chip wcn6855
To:     Paul Menzel <pmenzel@molgen.mpg.de>
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
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>,
        Tim Jiang <quic_tjiang@quicinc.com>,
        Johan Hovold <johan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 4:58=E2=80=AFAM Paul Menzel <pmenzel@molgen.mpg.de>=
 wrote:
>
> Dear Steev,
>
>
> Thank you for your patch. Some nits.
>
> Am 16.03.23 um 04:47 schrieb Steev Klimaszewski:
> > Added regulators,GPIOs and changes required to power on/off wcn6855.
>
> Please add a space after the comma.
>
Good catch, sorry about that, will do in v7!

> > Added support for firmware download for wcn6855.
>
> You might want to use imperative mood (Add =E2=80=A6).
>
Bah, I'd seen others mention this, and still did it in mine :/

> How did you test this? What firmware files did you use?
>
> Maybe mention, that the assumption is, that it=E2=80=99s identical to WCN=
6750?
>
Are you wanting the firmware used in the commit message?  I think I've
seen similar in e.g. ath11k patches like:

"Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.1.0.1-00887-QCAMSLSWPLZ-1"

something like that?  The firmware itself is already in
linux-firmware.  I figured it wasn't imperative to the patch and it's
in the cover letter but I can definitely throw it in the commit
message!


> > Signed-off-by: Steev Klimaszewski <steev@kali.org>
> > Reviewed-by: Bjorn Andersson <andersson@kernel.org>
> > Tested-by: Bjorn Andersson <andersson@kernel.org>
> > ---
>
> [=E2=80=A6]
>
>
> Kind regards,
>
> Paul
