Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBDF92543F8
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 12:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgH0KpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 06:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgH0Ko7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 06:44:59 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C50C061264;
        Thu, 27 Aug 2020 03:44:58 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id x7so4911198wro.3;
        Thu, 27 Aug 2020 03:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jHZbJ00C/f1K1DaZMLb0eY9W+8FWEJIJdHMmXmrVo2E=;
        b=CWltxGSqJqTnBvTSqb044t2/wgwetRPVnoGQy++DNRNCyk2xQLZOMzxwDszpWyIMJO
         2UnJmIQpyDzlX2SsQo6KZUeIr4gB5+gCrxEgFrwNWAAe/75o7PMcNI0u65YjG9YG6ODH
         njANnMzoXh7jMcj7ZyfAyhMG12cWr+EXjyn70VNNUr3yXFGxxY6qg7GnmKH+B9u3xn/U
         WKiUgbgzYFBxrLqgKSvDhdRXg0Y0dwRMLrkX20F3xIqpiWw+wAw3CpO2POWq2m/ACM1d
         pTcLwlz5FB5JaFIHz4nrDrI4aWrOUp3ueVsWSo+3Om8ulic6d893MVSHuV5kUDd3kOxt
         c7aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jHZbJ00C/f1K1DaZMLb0eY9W+8FWEJIJdHMmXmrVo2E=;
        b=OSCJQAVR8f+kpb6cdQrdTzTV34zbkfNxUKT8ZF6krSa1Gq07gtuY9srT6Xy5Da/zGS
         WphTRjBnmXZC3+sEvNbhEx8f0hU76D/sNTd2yrjn+AodQkX8Uiqc7DFSrdN8AZ6lqSHf
         wq5bA6s2X8f0a64CsRbxAuhBS+ZKPQHuH4Goe4lvhTrFUn8Nqbz+ZYOWatfxmUOdhL8c
         l802GB1FB+g2vGYDXTt3o457VpjDyJw8MREHc7cVsRIccH22M/ESsj5uhBKfZ8k/86jG
         YH3LYoYYKbyEs4QQNU8/fRDB9YlXWwdSI8oPhzf+7xpBqi4K6zNQnzMFsE0t8yapRjRH
         jtOQ==
X-Gm-Message-State: AOAM530LQddgZitI/PcVQvU3Yimx91Q3iqAYkTDTuZdCHXj06rxutHdX
        adLNa9yEcSnJb8Y5f+EMevNFeZA5WzKLeqpMz/Y=
X-Google-Smtp-Source: ABdhPJx/nnMNZzdz51vNTwqRRAqSdXIEeo5csO5i7hm5GF700/WOBx/88e08iEWcI7Y3UO4eC2wffxgx1/oGC+i/voc=
X-Received: by 2002:adf:f483:: with SMTP id l3mr6596174wro.148.1598525097155;
 Thu, 27 Aug 2020 03:44:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200817090637.26887-2-allen.cryptic@gmail.com> <20200827101540.6589BC433CB@smtp.codeaurora.org>
In-Reply-To: <20200827101540.6589BC433CB@smtp.codeaurora.org>
From:   Allen Pais <allen.cryptic@gmail.com>
Date:   Thu, 27 Aug 2020 16:14:45 +0530
Message-ID: <CAEogwTB=S6M6Xp4w5dd_W3b6Depmn6Gmu3RmAf96pRankoJQqg@mail.gmail.com>
Subject: Re: [PATCH 01/16] wireless: ath5k: convert tasklets to use new
 tasklet_setup() API
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, jirislaby@kernel.org,
        mickflemm@gmail.com, mcgrof@kernel.org, chunkeey@googlemail.com,
        Larry.Finger@lwfinger.net, stas.yakovlev@gmail.com,
        helmut.schaa@googlemail.com, pkshih@realtek.com,
        yhchuang@realtek.com, dsd@gentoo.org, kune@deine-taler.de,
        Kees Cook <keescook@chromium.org>, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, b43-dev@lists.infradead.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
>
> Allen Pais <allen.cryptic@gmail.com> wrote:
>
> > In preparation for unconditionally passing the
> > struct tasklet_struct pointer to all tasklet
> > callbacks, switch to using the new tasklet_setup()
> > and from_tasklet() to pass the tasklet pointer explicitly.
> >
> > Signed-off-by: Romain Perier <romain.perier@gmail.com>
> > Signed-off-by: Allen Pais <allen.lkml@gmail.com>
> > Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>
> Patch applied to ath-next branch of ath.git, thanks.
>
> c068a9ec3c94 ath5k: convert tasklets to use new tasklet_setup() API
>
> --
> https://patchwork.kernel.org/patch/11717393/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

Could you please drop these and wait for V2. A change was proposed
for from_tasklet() api. The new API should be picked shortly. I will send out
the updated version early next week.

Thanks,
- Allen
