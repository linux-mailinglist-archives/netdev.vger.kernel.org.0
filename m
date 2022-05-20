Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6383B52F12E
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 18:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351976AbiETQ6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 12:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351966AbiETQ6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 12:58:46 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4995E17DDDA;
        Fri, 20 May 2022 09:58:43 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id l13so8688208lfp.11;
        Fri, 20 May 2022 09:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w09xDaFhvCgd5/jtHMQ9zzqMXFg1Hmqji5SOkLVSX04=;
        b=ECOahUtY8/3WYgfZkQ8StYb8HVRRLhv4hCEnNfr7XbEzU6weV+kjDmrqGyjHiBK6SC
         Xkeeh4O081HIQtBhR3/96isJuNtcb54l+0FJ9SZoLYdyNe+5dRDBWpRhHO654doBe5t0
         6w+TMedl8/iTrJYGdIaSqLEv3UqIGRkiJRI0i486D/gMGrBSFTUqZoZx2+bIJa4/8iqt
         uEaXgo2xbtpHgJg7ldB9gKcyXHVZNWT8uaW/yHXmbSv02YUCxx66BjBT3+WtQ+4xnBGg
         /vaB9W6g4zc9CEOfTDCPPY0BCW1rkXvphkqFdUs0X2OEQmDza+or1KjnYgkVs1Kf6N/M
         liTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w09xDaFhvCgd5/jtHMQ9zzqMXFg1Hmqji5SOkLVSX04=;
        b=ijo2sKcAmd10Fak2J1KLZFKvu6oBcZSlED37Ez81QNB0KGOPDgO34P+S/y1rCLnifm
         Pdw6pr0ig2CvbKgcnMktaxk0j3gCfUZQK0BnFF+qp4Tylv3yogGDt8DnU2uP2qlsjfbt
         gZ8SDPtmqAQVFd3ReTYRx0Pz/MEVVm1uwN57Dqa/0StursyPyPuEyaO1CeM3gCkfrpgG
         jCPvWnqohKp5eMP7rxJsAPtDepvacJi1eMDo3d6oL/HNpSF3jOLCnTtJQ0Eh9895h+Bh
         NpYSilD+J290jBhpZ47xXN5gjUBm5Bne1P+QJMb1K4P8wlUPO9YcEpYTkpyq1llLxSRS
         gyuA==
X-Gm-Message-State: AOAM530cE2XmXoXVaPXHGBhYEh+KWeY6yOlsHtpv5gwWy8LYl7Ea073h
        wMsDDfk74B7XOYjKN9a0jLDMGAVXhwoSdRNSt0Q=
X-Google-Smtp-Source: ABdhPJwa9oKuEddMWiH4lSEQYyGZxTDOu6R1NSAWB2r/9keVKQWP4q6vWZWLYvQ45DixG/0ulDuHC60cbYfj/Btl6XQ=
X-Received: by 2002:a05:6512:318f:b0:473:dffc:18c8 with SMTP id
 i15-20020a056512318f00b00473dffc18c8mr7738530lfe.129.1653065921291; Fri, 20
 May 2022 09:58:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220519101656.44513-1-duoming@zju.edu.cn> <87fsl53jic.fsf@kernel.org>
 <257f8e7.216cd.180dc1af4d3.Coremail.duoming@zju.edu.cn> <877d6h37c9.fsf@kernel.org>
In-Reply-To: <877d6h37c9.fsf@kernel.org>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 20 May 2022 18:58:04 +0200
Message-ID: <CAHp75Vd8om_5sC8LDcnRH1oi6pGTmL6AVBrpieZe3HepOXnoGw@mail.gmail.com>
Subject: Re: [PATCH net] net: wireless: marvell: mwifiex: fix sleep in atomic
 context bugs
To:     Kalle Valo <kvalo@kernel.org>
Cc:     duoming@zju.edu.cn,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
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

On Thu, May 19, 2022 at 5:44 PM Kalle Valo <kvalo@kernel.org> wrote:
> duoming@zju.edu.cn writes:
> > On Thu, 19 May 2022 13:27:07 +0300 Kalle Valo wrote:

...

> >> > Fixes: f5ecd02a8b20 ("mwifiex: device dump support for usb interface")
> >> > Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> >>
> >> Have you tested this on real hardware? Or is this just a theoretical
> >> fix?
> >
> > This is a theoretical fix. I don't have the real hardware.
>
> For such patches clearly document that in the commit log, for example
> something like "Compile tested only."

It seems I even missed this part... :-(

-- 
With Best Regards,
Andy Shevchenko
