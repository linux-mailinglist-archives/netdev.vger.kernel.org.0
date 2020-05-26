Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7341E29C0
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 20:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbgEZSJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 14:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728945AbgEZSJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 14:09:51 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C04C03E96F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 11:09:51 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id x11so7998668plv.9
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 11:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SwJVwRsf4JLRcqoa9J+40Z33dh8YZfs8m9tFvpvW4ww=;
        b=QV6eN1wz/6AFupUQIoxfvaiVQr3VOLFnMyRTzupBK2x5UnbAlfVQHIl6yfVjKSnMu5
         umzskbig4ieeQkFfLiBEUxyS/rwM3NDzxKtqi8fgYUz362ncGMXqwUf3DjNADPk94joc
         sQer+mGXxLQjq5r5/VevoRSQ49Ax1BoPA19/0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SwJVwRsf4JLRcqoa9J+40Z33dh8YZfs8m9tFvpvW4ww=;
        b=h7Gw5QHHsPq73xhrCfZz3/yNm2h3vMet+efY/y6M8nhQarMBANjDljatnByitDjhhh
         rtZa3Pp+8qLmqHxD6SpXSp53F0ZfowXZXC3eEI+sYbSf6lJ5NRc1Pj+44XbaG9z2lk5f
         Ezh6SKVloBWTttRFHPgsyIWUWXPQ0r26aN+2t0vCXFnBYmKOQpBHy9nM3Vo8850ZS1/F
         6L3pPr3VWkMOeQpUAN5bWZE7bZcDYZqgN2gk9lmjEyv2shT1INNon+Vv2qAsWhZ8Iu0v
         YrMtR02ZSahKHosWWIFQG/3/HXVGV4gdrUTwoCoGfLH5PRn2C8/5W6+BZh6wGj+9NR0u
         LR/Q==
X-Gm-Message-State: AOAM533XmXTothsH0CX62efGnHIvAJEYh0KScCCOX/9fHUB70jQ/SmQq
        COorDcS+BS+PC/qr7giRK3OxIBMjb0AHR3wB8+D72A==
X-Google-Smtp-Source: ABdhPJw0zdtsZqR6XZR5M0EU2Em6fXtef9eG1yF+ia1DKSMmJ8d7PdM5no22jZaDVe0gm/zwiK1kl46oQKDlpGuKAiA=
X-Received: by 2002:a17:902:e903:: with SMTP id k3mr2106595pld.317.1590516590375;
 Tue, 26 May 2020 11:09:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200526145815.6415-1-mcgrof@kernel.org> <20200526145815.6415-7-mcgrof@kernel.org>
In-Reply-To: <20200526145815.6415-7-mcgrof@kernel.org>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Tue, 26 May 2020 11:09:38 -0700
Message-ID: <CACKFLikEm7r82jB=qB3YafPoHp+mK1joOtRKS67a2jyhJegtyA@mail.gmail.com>
Subject: Re: [PATCH v3 6/8] bnxt_en: use new taint_firmware_crashed()
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     jeyu@kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, dchickles@marvell.com,
        sburla@marvell.com, fmanlunas@marvell.com, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, akpm@linux-foundation.org,
        Arnd Bergmann <arnd@arndb.de>, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        Baoquan He <bhe@redhat.com>, peterz@infradead.org,
        tglx@linutronix.de, gpiccoli@canonical.com, pmladek@suse.com,
        tiwai@suse.de, schlad@suse.de, andriy.shevchenko@linux.intel.com,
        derosier@gmail.com, keescook@chromium.org, daniel.vetter@ffwll.ch,
        will@kernel.org, mchehab+samsung@kernel.org, vkoul@kernel.org,
        mchehab+huawei@kernel.org, robh@kernel.org, mhiramat@kernel.org,
        sfr@canb.auug.org.au, linux@dominikbrodowski.net,
        glider@google.com, paulmck@kernel.org, elver@google.com,
        bauerman@linux.ibm.com, yamada.masahiro@socionext.com,
        samitolvanen@google.com, yzaikin@google.com, dvyukov@google.com,
        rdunlap@infradead.org, corbet@lwn.net, dianders@chromium.org,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 7:58 AM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
>
> This makes use of the new module_firmware_crashed() to help
> annotate when firmware for device drivers crash. When firmware
> crashes devices can sometimes become unresponsive, and recovery
> sometimes requires a driver unload / reload and in the worst cases
> a reboot.
>
> Using a taint flag allows us to annotate when this happens clearly.
>
> Cc: Michael Chan <michael.chan@broadcom.com>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Acked-by: Rafael Aquini <aquini@redhat.com>
> Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

Reviewed-by: Michael Chan <michael.chan@broadcom.com>
