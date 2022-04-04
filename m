Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B597D4F10DC
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 10:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbiDDI2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 04:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbiDDI2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 04:28:53 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F03DA33A36;
        Mon,  4 Apr 2022 01:26:57 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id t19so7097764qtc.4;
        Mon, 04 Apr 2022 01:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9B1vDg725ZL75B9hNHdJwVzoV1gBOAZG8QnNdH+UPxA=;
        b=TGG+Z2rYdZzDaSevItzamM42OIU80qWLeqPMTkTiFlEJxRmPVujDHJwDDXgYdExXTl
         Th8He6JC6kEtU2QmNDWKz6+FwBRWhSPyqUENADNgb/wiE37ZcaoNjnJ3tmawIDD9jYqR
         9Yuov0LGuC0CIzVkLbtK8fUjeiQcOA4MjIxh5vmmtxzejMYpLWpuv1jgyDWu8mpe7iOn
         v65RX/l5fJvJtfRlm5L27pG9q8PhaEpuVYzjGrAgxOFyxBDRRHzBXxDasIfbvRNreKu8
         4PqkbsNJdnCE2KX2PjBqSA+E/D1XA+kN+diAKPr8pHdNCYQQJwmHLFAhAE1e3GHaM528
         Am7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9B1vDg725ZL75B9hNHdJwVzoV1gBOAZG8QnNdH+UPxA=;
        b=bpakZlxmPlHBAyJzasGXpvtV2owfTdt/MytiAWMRyte62cG4kRNiXwQxAVGxndOJ7Z
         0hkWMiz2KAKvIRx2hGh1DW1D3wpLYEzEXRK71ud+bkO4YMxr8Sz91lQuaL8hhY2Aj6ZX
         9f+InPjNcfBi9pjmL3oi0Xc1YUkAzZu3eG2RO30MF1yByD/fBN5uIApiOZ48rU76nfVZ
         Xc5F+pEVm1y3t+1SjUt1hgJQs83jDoDpRpz+mm+ZWEqeJLFl14GuGgynTzMWAS2KiXL0
         vhOn+iqq/G8U/fdXscJVpnVgz4A9PMpxudKgmgv43rAwHJnsvSnzYBt7nF303f11yAGQ
         oDmA==
X-Gm-Message-State: AOAM5322kSLtxtv9bSNnu6QdyvWXBzKP6NcRJYuCbWQFL+hryCoa1gIp
        bZoa+np2s+WwcZJT3x4jBYT5gnM2Z7bxcS35qFc=
X-Google-Smtp-Source: ABdhPJyMyNUGjmhcgxdxcxIUEwWFso/oW3ZHbINEDa3SsiRO5EUgB3PU/yUmWSq8iuC7Ed8DE1CELm3ObEm4rETLdHo=
X-Received: by 2002:ac8:598a:0:b0:2e1:e81a:d059 with SMTP id
 e10-20020ac8598a000000b002e1e81ad059mr16436086qte.297.1649060817152; Mon, 04
 Apr 2022 01:26:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220401093554.360211-1-robimarko@gmail.com> <87ilrsuab4.fsf@kernel.org>
 <CAOX2RU4pCn8C-HhhuOzyikjk2Ax3VDcjMKh7N6X5HeMN4xLMEg@mail.gmail.com> <87zgl1s4xr.fsf@kernel.org>
In-Reply-To: <87zgl1s4xr.fsf@kernel.org>
From:   Robert Marko <robimarko@gmail.com>
Date:   Mon, 4 Apr 2022 10:26:46 +0200
Message-ID: <CAOX2RU4+6_64MBxZAT9q0QQvjROteDtAsPiYYYWd-Yjijik91w@mail.gmail.com>
Subject: Re: [PATCH] ath11k: select QRTR for AHB as well
To:     Kalle Valo <kvalo@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 4 Apr 2022 at 09:06, Kalle Valo <kvalo@kernel.org> wrote:
>
> Robert Marko <robimarko@gmail.com> writes:
>
> > On Fri, 1 Apr 2022 at 16:51, Kalle Valo <kvalo@kernel.org> wrote:
> >>
> >> Robert Marko <robimarko@gmail.com> writes:
> >>
> >> > Currently, ath11k only selects QRTR if ath11k PCI is selected, however
> >> > AHB support requires QRTR, more precisely QRTR_SMD because it is using
> >> > QMI as well which in turn uses QRTR.
> >> >
> >> > Without QRTR_SMD AHB does not work, so select QRTR in ATH11K and then
> >> > select QRTR_SMD for ATH11K_AHB and QRTR_MHI for ATH11K_PCI.
> >> >
> >> > Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.5.0.1-01208-QCAHKSWPL_SILICONZ-1
> >> >
> >> > Signed-off-by: Robert Marko <robimarko@gmail.com>
> >> > ---
> >> >  drivers/net/wireless/ath/ath11k/Kconfig | 3 ++-
> >> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >> >
> >> > diff --git a/drivers/net/wireless/ath/ath11k/Kconfig b/drivers/net/wireless/ath/ath11k/Kconfig
> >> > index ad5cc6cac05b..b45baad184f6 100644
> >> > --- a/drivers/net/wireless/ath/ath11k/Kconfig
> >> > +++ b/drivers/net/wireless/ath/ath11k/Kconfig
> >> > @@ -5,6 +5,7 @@ config ATH11K
> >> >       depends on CRYPTO_MICHAEL_MIC
> >> >       select ATH_COMMON
> >> >       select QCOM_QMI_HELPERS
> >> > +     select QRTR
> >> >       help
> >> >         This module adds support for Qualcomm Technologies 802.11ax family of
> >> >         chipsets.
> >> > @@ -15,6 +16,7 @@ config ATH11K_AHB
> >> >       tristate "Atheros ath11k AHB support"
> >> >       depends on ATH11K
> >> >       depends on REMOTEPROC
> >> > +     select QRTR_SMD
> >> >       help
> >> >         This module adds support for AHB bus
> >> >
> >> > @@ -22,7 +24,6 @@ config ATH11K_PCI
> >> >       tristate "Atheros ath11k PCI support"
> >> >       depends on ATH11K && PCI
> >> >       select MHI_BUS
> >> > -     select QRTR
> >> >       select QRTR_MHI
> >> >       help
> >> >         This module adds support for PCIE bus
> >>
> >> I now see a new warning:
> >>
> >> WARNING: unmet direct dependencies detected for QRTR_SMD
> >>   Depends on [n]: NET [=y] && QRTR [=m] && (RPMSG [=n] || COMPILE_TEST [=n] && RPMSG [=n]=n)
> >>   Selected by [m]:
> >>   - ATH11K_AHB [=m] && NETDEVICES [=y] && WLAN [=y] && WLAN_VENDOR_ATH [=y] && ATH11K [=m] && REMOTEPROC [=y]
> >
> > Ahh yeah, since it's SMD then it requires RPMGS which in turn requires
> > more stuff. What do you think about making it depend on QRTR_SMD
> > instead, because without it AHB literally does not work?
>
> To be honest I don't know qrtr well enough to comment right now :)

I dont know details about QRTR as well, but I know that its used for
both AHB and PCI versions for QMI.
AHB versions use it over SMD and without it, AHB support wont work, it
will find the HW model and revision and that's it, only after the
QRTR_SMD is inserted you can use QMI to load the caldata etc.

Regards,
Robert
>
> --
> https://patchwork.kernel.org/project/linux-wireless/list/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
