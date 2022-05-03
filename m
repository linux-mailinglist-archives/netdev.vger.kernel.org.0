Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C56EC518936
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 17:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239057AbiECQBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 12:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238844AbiECQBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 12:01:48 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9AE131DFF;
        Tue,  3 May 2022 08:58:15 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id t11so13723540qto.11;
        Tue, 03 May 2022 08:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=66qLlJx7nKrNSsQ33ieGox6v7vdk5wYAsgHq0JYbR7U=;
        b=GU7ZZ/4jdmm749iUiJVRCIcPeLZcuoc09ThrWS55XaIe0iWJcOrq3NCgG1FOka+F3C
         ZmkSJ4HFoVOyzzf3+xlOWOJxi8mU+ckUhZbyIJXEeYec1x43FV5KAfgJOvN439PiZtkm
         NlUdvMEqaNQt2RyjERWTx84VUQGo6QHDQjHxe+/Gp4FLE1v87lDZ3a91JQAS5D7IBdA8
         gguUf+C8ZN4inU2sk1Gx5IZtDWh99fsY8eiH8tumQCfFSYWNMJ0QeahN1MKGK0GsZPBl
         XbmlDVpzpFHBnLSaGQxOQotypnLnwC9WJzN3nj7AUNPbERXgPqM/nwm7NPRA5tG+BqCB
         k2sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=66qLlJx7nKrNSsQ33ieGox6v7vdk5wYAsgHq0JYbR7U=;
        b=0+SqBgxTyXPAIpHgYOnVZ0ZeZ/XgFrU8ANyLLX5eBMoApQ3ON7kzonxorU+CUGjW6i
         p6xgUeSGOPaaxj0h32w60kWzucMoaPwauZJN7Odlrv6SWArJPObqECnI0Z688HbfRIgv
         PKnCR0lTHgpXB+pNYRYjB2cpQQ7cDKEDRzFmGDYVy5+/t9ryzaeo8F26on+LqXL9bXST
         KcnMvKaf89b3Ub4olCHHgSsXDfvadGk7nyZaEUwOp9Cf6woyqqWcqt242bWH/DcmRPK2
         9ZSEGIIuIFXnWiZyfuBcvLLepyVv6+2PdLiHZbhIvrthXWFVGRFFs52RYliBDvtVOCv+
         RSDQ==
X-Gm-Message-State: AOAM530uMGKxMiyzmkShtNYFl72CrIcRlm1dBNh47mhZs1MbAII3aS2Y
        E1/fRO51QTSO1drGIT6uaUunKziTb+4adFJ0EgA=
X-Google-Smtp-Source: ABdhPJwSVdBAXX6iPX6P1vVEDTK43ohrO2wPIvLWaEqfD4QNwUWnOiDyLgYzKn27UDN3LLuxuLcLlcHI870+g4wbN44=
X-Received: by 2002:a05:622a:155:b0:2f3:9484:c38e with SMTP id
 v21-20020a05622a015500b002f39484c38emr15379813qtw.494.1651593494861; Tue, 03
 May 2022 08:58:14 -0700 (PDT)
MIME-Version: 1.0
References: <20211009221711.2315352-1-robimarko@gmail.com> <163890036783.24891.8718291787865192280.kvalo@kernel.org>
 <CAOX2RU5mqUfPRDsQNSpVPdiz6sE_68KN5Ae+2bC_t1cQzdzgTA@mail.gmail.com>
 <09a27912-9ea4-fe75-df72-41ba0fa5fd4e@gmail.com> <CAOX2RU6qaZ7NkeRe1bukgH6OxXOPvJS=z9PRp=UYAxMfzwD2oQ@mail.gmail.com>
 <EC2778B3-B957-4F3F-B299-CC18805F8381@slashdirt.org> <CAOX2RU7FOdSuo2Jgo0i=8e-4bJwq7ahvQxLzQv_zNCz2HCTBwA@mail.gmail.com>
 <CAOX2RU7d9amMseczgp-PRzdOvrgBO4ZFM_+hTRSevCU85qT=kA@mail.gmail.com>
 <70a8dd7a-851d-686b-3134-50f21af0450c@gmail.com> <7DCB1B9A-D08E-4837-B2FE-6DA476B54B0D@slashdirt.org>
In-Reply-To: <7DCB1B9A-D08E-4837-B2FE-6DA476B54B0D@slashdirt.org>
From:   Robert Marko <robimarko@gmail.com>
Date:   Tue, 3 May 2022 17:58:03 +0200
Message-ID: <CAOX2RU7kF8Da8p_tHwuE-8YMXr5ZtWU2iL6ZY+UR+1OvGcyn+w@mail.gmail.com>
Subject: Re: [PATCH] ath10k: support bus and device specific API 1 BDF selection
To:     Thibaut <hacks@slashdirt.org>
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Feb 2022 at 22:55, Thibaut <hacks@slashdirt.org> wrote:
>
> Hi,
>
> > Le 16 f=C3=A9vr. 2022 =C3=A0 22:19, Christian Lamparter <chunkeey@gmail=
.com> a =C3=A9crit :
> >
> > Hi,
> >
> > On 16/02/2022 14:38, Robert Marko wrote:
> >> Silent ping,
> >> Does anybody have an opinion on this?
> >
> > As a fallback, I've cobbled together from the old scripts that
> > "concat board.bin into a board-2.bin. Do this on the device
> > in userspace on the fly" idea. This was successfully tested
> > on one of the affected devices (MikroTik SXTsq 5 ac (RBSXTsqG-5acD))
> > and should work for all MikroTik.
> >
> > "ipq40xx: dynamically build board-2.bin for Mikrotik"
> > <https://git.openwrt.org/?p=3Dopenwrt/staging/chunkeey.git;a=3Dcommit;h=
=3D52f3407d94da62b99ba6c09f3663464cccd29b4f>
> > (though I don't think this link will stay active for
> > too long.)
>
> IMHO Robert=E2=80=99s patch addresses an actual bug in ath10k whereby the=
 driver sends the same devpath for two different devices when requesting bo=
ard-1 BDF, which doesn=E2=80=99t seem right.
>
> Your proposal is less straightforward than using unmodified board-1 data =
(as could be done if the above bug did not occur) and negates the previous =
efforts not to store this data on flash (using instead the kernel=E2=80=99s=
 documented firmware sysfs loading facility - again possible without the ab=
ove issue).
>
> HTH
> T-Bone

Kalle, any chance of reviewing this?
It just brings the board data in line with caldata as far as naming goes.

Regards,
Robert
