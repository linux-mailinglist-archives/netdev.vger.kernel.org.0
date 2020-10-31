Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1D22A1A41
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 20:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbgJaTTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 15:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725786AbgJaTTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 15:19:50 -0400
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC9BC0617A7
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 12:19:49 -0700 (PDT)
Received: by mail-vk1-xa42.google.com with SMTP id y10so2166990vkl.5
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 12:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wwf1XRuzqH8iDHRAKdxul3V5TY+R1Lm9WGQNmM2sOaM=;
        b=BNPxEwa+WTE2Lxke8s7Ayr8UVA9ODk8sISCXedOqCyXoDTasLUrAOudyVTHHHIUBm8
         MTO7HWokQ5KJ3cPE3S8gG9RNkwWrVvvb4WRKRMwYiQgvZYWtLdM6TFzfHFnnnb93DH9o
         R0CU4iS/o9jwIW7OEreGqoYwTdThGw6ffU7NNxmsywaDEtsEgNda1iBKSp8Gu8Ak6ko4
         Jx9btHFG04Ubami2QJwSqP8joV7aEgZfvnrMRECLssImVvzFA+9jTBwIA2/yh9P4YNY5
         1S8MkdYjDZFmVDjqXCGqYj/y52VxUB2Bef8YL9geYZ0GxsHYDPBSi+skjpP0HsoHSe2w
         28gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wwf1XRuzqH8iDHRAKdxul3V5TY+R1Lm9WGQNmM2sOaM=;
        b=i50u2OZa9I24p+wnw+J0Sp8kDY64RhTTT3a0UnixMKf1PDgNuc4RTzZDDgzYCSQw9n
         wDs862nHRhoYl3fndp2+xpmWzTdFIZzzbS6jKsSLn1rlOz4S6UX1fQpeRbAye8GvZ/rj
         b1p/a/r6y/fucmFsrw2crHVk6IPR2AKNuGdpS/sUFkjaQ8hvtdbmSB9GfD5d543aGxHu
         t1wWi8YhJJ/kKwgewE8Xl2WgAeg2p0dMe0jDgiJtWMyUpOxdYBWmLEIIB83DL1mUCZ6M
         NbjOSFGVapphjRzBZRO03I7h1Pk10mIoj/eZikpm5xFx0OWme3AqB4p0MearE9tHLiUR
         B8Bg==
X-Gm-Message-State: AOAM532UUQ/6CV1+Gdy96/ltl2dOiRxwzxu5VTz4XoUxPa5puthpyrQh
        SVvmwaeKfkIu5hVBSrqrw8Mz0mQhV+I=
X-Google-Smtp-Source: ABdhPJzJRCR11NUWLPlbQv4qLnZppKnFVkhnyUW4sg1+fQs9IRPMajtjEL72WONXFQ9MiL+Xksd12w==
X-Received: by 2002:a1f:2bd5:: with SMTP id r204mr10150039vkr.8.1604171988338;
        Sat, 31 Oct 2020 12:19:48 -0700 (PDT)
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com. [209.85.217.51])
        by smtp.gmail.com with ESMTPSA id 70sm1088715uaj.1.2020.10.31.12.19.46
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 12:19:46 -0700 (PDT)
Received: by mail-vs1-f51.google.com with SMTP id h5so5287644vsp.3
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 12:19:46 -0700 (PDT)
X-Received: by 2002:a05:6102:52b:: with SMTP id m11mr1067435vsa.28.1604171985842;
 Sat, 31 Oct 2020 12:19:45 -0700 (PDT)
MIME-Version: 1.0
References: <20201028145015.19212-1-schalla@marvell.com> <20201028145015.19212-12-schalla@marvell.com>
In-Reply-To: <20201028145015.19212-12-schalla@marvell.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 31 Oct 2020 15:19:09 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdVszdtPvpasE2FpZ97WRP1uV5UJMC5KjrnziTUY8UQOw@mail.gmail.com>
Message-ID: <CA+FuTSdVszdtPvpasE2FpZ97WRP1uV5UJMC5KjrnziTUY8UQOw@mail.gmail.com>
Subject: Re: [PATCH v8,net-next,11/12] crypto: octeontx2: add support to
 process the crypto request
To:     Srujana Challa <schalla@marvell.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-crypto@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        schandran@marvell.com, pathreya@marvell.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 5:52 PM Srujana Challa <schalla@marvell.com> wrote:
>
> Attach LFs to CPT VF to process the crypto requests and register
> LF interrupts.
>
> Signed-off-by: Suheil Chandran <schandran@marvell.com>
> Signed-off-by: Srujana Challa <schalla@marvell.com>
> ---
>  drivers/crypto/marvell/octeontx2/Makefile     |   2 +-
>  .../marvell/octeontx2/otx2_cpt_common.h       |   3 +
>  .../marvell/octeontx2/otx2_cpt_reqmgr.h       | 145 +++++
>  drivers/crypto/marvell/octeontx2/otx2_cptlf.h |   7 +
>  .../marvell/octeontx2/otx2_cptvf_main.c       | 196 +++++++
>  .../marvell/octeontx2/otx2_cptvf_mbox.c       |  26 +
>  .../marvell/octeontx2/otx2_cptvf_reqmgr.c     | 532 ++++++++++++++++++
>  7 files changed, 910 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/crypto/marvell/octeontx2/otx2_cptvf_reqmgr.c


> +static int init_tasklet_work(struct otx2_cptlfs_info *lfs)
> +{
> +       struct otx2_cptlf_wqe *wqe;
> +       int i, ret = 0;
> +
> +       for (i = 0; i < lfs->lfs_num; i++) {
> +               wqe = kzalloc(sizeof(struct otx2_cptlf_wqe), GFP_KERNEL);
> +               if (!wqe) {
> +                       ret = -ENOMEM;
> +                       goto cleanup_tasklet;
> +               }
> +
> +               tasklet_init(&wqe->work, cptlf_work_handler, (u64) wqe);
> +               wqe->lfs = lfs;
> +               wqe->lf_num = i;
> +               lfs->lf[i].wqe = wqe;
> +       }
> +       return 0;
> +cleanup_tasklet:

nit: here and elsewhere, please leave an empty line between the return
statement and subsequent label.
