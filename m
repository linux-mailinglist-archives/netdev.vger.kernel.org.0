Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3ABB3E0A98
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 00:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbhHDWxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 18:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbhHDWxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 18:53:17 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5190C0613D5
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 15:53:03 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id q6so4791197oiw.7
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 15:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wvjJXIAyDtPL/Ndk/Btj800bsnjEboaOCHdw/tjENlE=;
        b=NvgNV1BmOyqa+ONMf/ndrJq3FcJ7c5LtBMHtnvF0HO93XBKfRK4RrR34Cc/uKakySh
         m7ZcUjTOAWSAAigDKMZlCvF7srO4sHeRrHLUrLoJxffYgyd+VQBKS40QzRAd432FN48J
         RSWCYqHIZn95SJUMdLqpkiUnfZs96ZUZQ7ggQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wvjJXIAyDtPL/Ndk/Btj800bsnjEboaOCHdw/tjENlE=;
        b=aqcOsgy4mTiutqY9L03DvIetHozVW064gsVdKPLCXf+bVA215RBkm2JuXiubJtxdZG
         wQLzy8WsKifBQ+HAu5qvC4puM6dpzUr78sVKXstQoEZH396XaTuRgaR4LFTyjaAo7HOG
         etdgG2bfnlCX34iZdDCq1SwNVIDgpYzy5/2Edudnhqbc+Ya7HMejFI0/jz87ahyMQ/ki
         Yb5dTJ0PCLXsnQXLmD74XqGvdVYdocgXgIFaImQWjMNcwsHnj1oTp198g3XXF+5SZozE
         t5+pHMUGKffyKN6T1+60ldMaZIvMGKyW4sjZXfY/A5+jVDd8SBHrrYBCclwJTjEZ3fzK
         DIgw==
X-Gm-Message-State: AOAM533n8oxiEXOQ7YEPmsFx+P9ijw5+iuzFSs6jdZUF9c9a/dR0c2Zq
        QT6cBO3CpIJ/4z4JcaFglz3+a0cKzVzKcg==
X-Google-Smtp-Source: ABdhPJzhQHB519WJdQY/hZ9yVDZUa0VBsqHVYHj6VJAcEloc0Kh6eCXVWovDIGt/CYxX8vYNNfUmjg==
X-Received: by 2002:aca:4e91:: with SMTP id c139mr1261340oib.72.1628117582858;
        Wed, 04 Aug 2021 15:53:02 -0700 (PDT)
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com. [209.85.167.170])
        by smtp.gmail.com with ESMTPSA id r1sm532747ooi.21.2021.08.04.15.53.02
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 15:53:02 -0700 (PDT)
Received: by mail-oi1-f170.google.com with SMTP id u10so4824761oiw.4
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 15:53:02 -0700 (PDT)
X-Received: by 2002:aca:110d:: with SMTP id 13mr7258895oir.77.1628117166068;
 Wed, 04 Aug 2021 15:46:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210804020305.29812-1-islituo@gmail.com>
In-Reply-To: <20210804020305.29812-1-islituo@gmail.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Wed, 4 Aug 2021 15:45:54 -0700
X-Gmail-Original-Message-ID: <CA+ASDXPxMBeVwb+708Z5ZwKsNmBhcAE1AwbbRvsQMDiNaGJXQQ@mail.gmail.com>
Message-ID: <CA+ASDXPxMBeVwb+708Z5ZwKsNmBhcAE1AwbbRvsQMDiNaGJXQQ@mail.gmail.com>
Subject: Re: [PATCH] mwifiex: drop redundant null-pointer check in mwifiex_dnld_cmd_to_fw()
To:     Tuo Li <islituo@gmail.com>
Cc:     amit karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        baijiaju1990@gmail.com, TOTE Robot <oslab@tsinghua.edu.cn>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 3, 2021 at 7:03 PM Tuo Li <islituo@gmail.com> wrote:
>
> There is no case in which the variable cmd_node->cmd_skb has no ->data,
> and thus the variable host_cmd is guaranteed to be not NULL. Therefore,
> the null-pointer check is redundant and can be dropped.
>
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Tuo Li <islituo@gmail.com>

Tested-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Brian Norris <briannorris@chromium.org>
