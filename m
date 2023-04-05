Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1006D79EE
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 12:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237725AbjDEKjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 06:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237721AbjDEKja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 06:39:30 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD0C5258;
        Wed,  5 Apr 2023 03:39:28 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id fi11so16399192edb.10;
        Wed, 05 Apr 2023 03:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680691167;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m+OWu93YrqWr/zEhqySFx58McOCzQoD5fkplN4ZAYNo=;
        b=UcAaRKILFQhDt9GYBtqWAuPWyKKq3Wv0oCYW98FzjwYGpYFlAQBd0gX8sXr8sXfOcc
         H9mRKWpZsNHzJO9W9WxtztHw2l9kH1IUc5cTzn8GSLIb2RMB1xhkeTQygJDWmWGKlAtV
         sMJC0E0+CwsZkSJL5gk3RjeZmekFyy1u/LwX/hlthyWWvu3TmEEeLOdL/+mPtwu99pBz
         etKgL7/OBB5KFwkIuiJRZevnzr/gMEOK22WjQ9Ta7MIFsPBHarBAlyoqPI1G4SXU9YPL
         zKeHwpjm175J2OQAeHten/PwxILkALiqoYPDYIOJycn39KNijhtfBN13R+JpTy7KS8Tk
         owyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680691167;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m+OWu93YrqWr/zEhqySFx58McOCzQoD5fkplN4ZAYNo=;
        b=xQA8Y2C4SysHCyDkoGFP90ccI5wX/F6xSpLsQkZFEFmRBnAYDH7I9k+x60vgIxexP1
         EB3ZljFH6g6pgFpTsCqcRImpAAh8UF0MMnNTvav4IQjFMrRa/TGNaAwWNTHiWf+2bIY5
         2YibxsYtsXuEfp52AOJ8r7K8SdzZkI/8ovaGeLFuL4HEyoG5ORRTrQ20YkQ1684ZDlo2
         nu3PYyuSNpB6tmJt2Z7za72Pp1D3x7/rcQSSuT40K1btxVFSTcpsNqMhGSAdutgCvTWd
         bhhipMhmorPMoXJdnNjcpl01/1amm2tsFo31BDamsOF4zQWKtH+Azx0jTQqqtq4m7hRB
         evaA==
X-Gm-Message-State: AAQBX9e2Qzvte5r+kdlXzUj2b17+T8rTKWdoB9F1ls6KwDo2/ozIWRhJ
        P+7+lBNViprNGGfL39I7JmkjC8rE9/jq9AKQBg0=
X-Google-Smtp-Source: AKy350aLbijKiNdkK8SHm4i29BovFlyRXNTjWiSHmeQXz0hOZ9d1gr6/yFY+oc4DYB8xrmBFC2F21GmCtMlZC+NLB1M=
X-Received: by 2002:a17:907:8c0b:b0:92f:41e4:e48b with SMTP id
 ta11-20020a1709078c0b00b0092f41e4e48bmr1293430ejc.6.1680691166633; Wed, 05
 Apr 2023 03:39:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230405093945.3549491-1-michael.wei.hong.sit@intel.com>
In-Reply-To: <20230405093945.3549491-1-michael.wei.hong.sit@intel.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Wed, 5 Apr 2023 12:39:15 +0200
Message-ID: <CAFBinCDUX0O1E7_cToxvrCjWboSSX1Dj5rUaC6OcRT5=Vyrn5g@mail.gmail.com>
Subject: Re: [PATCH net 1/1] net: stmmac: check fwnode for phy device before
 scanning for phy
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, hkallweit1@gmail.com, andrew@lunn.ch,
        Shahab Vahedi <Shahab.Vahedi@synopsys.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>,
        Zulkifli Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        hock.leong.kweh@intel.com
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

On Wed, Apr 5, 2023 at 11:40=E2=80=AFAM Michael Sit Wei Hong
<michael.wei.hong.sit@intel.com> wrote:
>
> Some DT devices already have phy device configured in the DT/ACPI.
> Current implementation scans for a phy unconditionally even though
> there is a phy listed in the DT/ACPI and already attached.
>
> We should check the fwnode if there is any phy device listed in
> fwnode and decide whether to scan for a phy to attach to.y
>
> Reported-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Fixes: fe2cfbc96803 ("net: stmmac: check if MAC needs to attach to a PHY"=
)
> Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
This also works great on my X96 Air (and I presume it will fix all
other Amlogic boards):
Tested-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>


Thanks a lot for being so quick with this fix!
