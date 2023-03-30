Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8F56D0B68
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 18:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbjC3Qf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 12:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbjC3QfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 12:35:24 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC376C167
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 09:35:23 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id eg48so78726031edb.13
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 09:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google; t=1680194122;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2afhFpL4Acf26QforwyN/SKoshRKH28ySdYgRhAiXUQ=;
        b=m9EbkV4Ikp57UTGtRPDa92b5AreZqnzqxROsPeI0DMDpZzWQO2G+Zoi/EKP5p4j0ek
         xy1M+RYE1RzJ+INEKbv+8ePFicHFouy+1zKe6Jtp1nGoJsZaSzn6ShSqLi3ODdO8xmB6
         pg2CN8ghHHLripQCP/UP+wjI/Ak5vTRT/YfZdmOdxju4ejfakkxQ1LGZ0dJsFw0a3CkV
         oghCLR6M+wOARsyS43ykPSbIZVKCJAWelleyfBKeaJVtQAtVK/ryEiDMqFP+6U6jt2yl
         crekKZ3+6BwvSgW2yqYtwaO2Vme9Nim7cHuln8k1u5Zdm0h5XOGvNDEnoN8yoC6nLMlY
         M/1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680194122;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2afhFpL4Acf26QforwyN/SKoshRKH28ySdYgRhAiXUQ=;
        b=rWJ2fLUISl0xvjAN48j53lLedUGtVPH6xixMlCx/yH89lDaFxgcZJH2OmOspyWSyMM
         WqEYvRWS2XrOs6b7+rMcQjTbdcJM5uwU/hv39kOOTjEuz5M8iNBghNv8omByuvejc1J2
         j9R8Qo4FIgWlPW+/P1z+NcVylYtPUZMZubo9hOK1GVQKHmH2D38IluW+LtijqnBk6CNy
         DXmOweHuN86gBztGIKW5KTKAs9G8dwPHrcCNJAKCKqCvIi6SMPsg+OQg/l/OabIPw8wS
         iCkD8XYX+isu0w6qV6vqFEFLi+60nOjiBOosJz68oWAtOhiimRzvZq5irFwgw/eDlTvm
         /xuw==
X-Gm-Message-State: AAQBX9e+48aphXa5Utc+K9rG9kn9X6sFgtIXzc+rKCiNT/+ywW1YBRs3
        hR9h1RHCHLaWlFjJBwpkrts4IncqjybZtPf7JdEloRXrGI7PaWQ3
X-Google-Smtp-Source: AKy350aXiFqW8V2PTtFhJKzVi+bMGpPo+NgxY6yBV90NYIfNp+gCb26N5e2z695S5ywSjJTjE+jEoLTEEKT+eQ56plU=
X-Received: by 2002:a17:906:7217:b0:932:6a2:ba19 with SMTP id
 m23-20020a170906721700b0093206a2ba19mr12346955ejk.14.1680194122338; Thu, 30
 Mar 2023 09:35:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230326233812.28058-1-steev@kali.org> <20230326233812.28058-3-steev@kali.org>
 <ZCVgMuSdyMQhf/Ko@hovoldconsulting.com>
In-Reply-To: <ZCVgMuSdyMQhf/Ko@hovoldconsulting.com>
From:   Steev Klimaszewski <steev@kali.org>
Date:   Thu, 30 Mar 2023 11:35:11 -0500
Message-ID: <CAKXuJqjJjd6SY1g3JW8w53rEVCqgDkJXQ=1iA3qXcF+C9qv1SQ@mail.gmail.com>
Subject: Re: [PATCH v8 2/4] Bluetooth: hci_qca: Add support for QTI Bluetooth
 chip wcn6855
To:     Johan Hovold <johan@kernel.org>
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
        Tim Jiang <quic_tjiang@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Johan,

On Thu, Mar 30, 2023 at 5:10=E2=80=AFAM Johan Hovold <johan@kernel.org> wro=
te:
>
> On Sun, Mar 26, 2023 at 06:38:10PM -0500, Steev Klimaszewski wrote:
> > Add regulators, GPIOs and changes required to power on/off wcn6855.
> > Add support for firmware download for wcn6855 which is in the
> > linux-firmware repository as hpbtfw21.tlv and hpnv21.bin.
> >
> > Based on the assumption that this is similar to the wcn6750
> >
> > Tested-on: BTFW.HSP.2.1.0-00538-VER_PATCHZ-1
> >
> > Signed-off-by: Steev Klimaszewski <steev@kali.org>
> > Reviewed-by: Bjorn Andersson <andersson@kernel.org>
> > Tested-by: Bjorn Andersson <andersson@kernel.org>
> > ---
> > Changes since v7:
> >  * None
>
> Only noticed now when Luiz applied the patches, but why did you drop my
> reviewed-by and tested-by tags from this patch when submitting v8?
>
> For the record:
>
> Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
> Tested-by: Johan Hovold <johan+linaro@kernel.org>
>
Oops, that wasn't intentional! I only meant to drop it on the dts bits
as that part I wanted to make sure I got right based on your comments,
my apologies!
--steev
