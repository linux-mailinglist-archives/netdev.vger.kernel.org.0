Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E56049429B
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 22:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357452AbiASVrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 16:47:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343606AbiASVrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 16:47:40 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A7DC061574;
        Wed, 19 Jan 2022 13:47:39 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id u18so5444141edt.6;
        Wed, 19 Jan 2022 13:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pSWfoK1jnmO+T32koJ6nJsxNdVBxnqdtz0oVErlAr6A=;
        b=PKLGbfleH5LN1drzDaSbqbsouBfvIOd5yUNFexmLU43zTI+g/ocZNTKQC7d9T6+2vO
         B62w2pqphP+3i5XI6e28Mdc8J9sWkofstcAWt/4i1ESTYxwBf0DirC+NWw6PF8UwsGdH
         HiqbXpnTtcI9hWh9pntLSI1GhRKxi51S/C1GjXUzVkC/5xz61b2uLJs9PNQs6xp7KOUu
         nGBx1TUS5gpKH1Tei37toDjFiz4ICl+/IxLq79Ww/e8oekLthPtuyEiEM0DXvo5dr0gn
         dQgR9VkT11kWZL3uLGQyoaPoDI/ik4C9SrByHXx87gVGKgUtuJfRSjVWtthG0n+DU8QA
         d4Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pSWfoK1jnmO+T32koJ6nJsxNdVBxnqdtz0oVErlAr6A=;
        b=Ez6RAS956Yvz1Q2opnXBrj7002anh93Alc8841fmvwAI9Q1WJUl3Rwjvyvgwup71C6
         7U0JqHyqRYuYEviLW9OfhHWRu1FPMY5KcWX5puhDsH3t//u0MzuMDMhVFf74Y0xRHaDp
         hPbbNobAhtQJCezCc9AsMyNcFqvtAckgbxjP0V49Z35Dwbut/I7xOPay0Mglc0nB2ofn
         G+9gc9TutzkRbF2fH1c+i6o9Qd6KAj/g7kAbcAh/ovaY+E/TH/IJ2fzhZzR2IDxBDXF+
         VtnLXogM49gRztDkaSTrEC6Bz6soltk5fkuw1HvBchMuzy12IL5pwsS7cgCJ0fMl8n+l
         9bFg==
X-Gm-Message-State: AOAM531QMQosLLfA6bNVXAp7FZ68s2YeCT2uvKGbMpOPJoQ6ZL16uOFG
        tXnsVYZU0QD1/wSbF/ap8utU6J9oLJUsQ77/3gA=
X-Google-Smtp-Source: ABdhPJw5ae+enqKq3tZAGEBdViyh1ObmCrWMSZh4dhwe3Lb0DW+cB4ZJueiWhsgjeqrAiAIqIeXqdHPsxGLmQv86w/0=
X-Received: by 2002:aa7:c0c9:: with SMTP id j9mr3582784edp.270.1642628857879;
 Wed, 19 Jan 2022 13:47:37 -0800 (PST)
MIME-Version: 1.0
References: <20220117142919.207370-1-marcan@marcan.st> <20220117142919.207370-4-marcan@marcan.st>
In-Reply-To: <20220117142919.207370-4-marcan@marcan.st>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 19 Jan 2022 23:45:55 +0200
Message-ID: <CAHp75VfZ+thU+AWeOQSC9Dqq3MO+GMb_8oPxqMEbaxYTH0PH5A@mail.gmail.com>
Subject: Re: [PATCH v3 3/9] brcmfmac: firmware: Do not crash on a NULL board_type
To:     Hector Martin <marcan@marcan.st>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        SHA-cyfmac-dev-list@infineon.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 17, 2022 at 4:30 PM Hector Martin <marcan@marcan.st> wrote:
>
> This unbreaks support for USB devices, which do not have a board_type
> to create an alt_path out of and thus were running into a NULL
> dereference.

In v5.16 we have two call sites:

1.
  if (cur->type == BRCMF_FW_TYPE_NVRAM && fwctx->req->board_type) {
    ...
    alt_path = brcm_alt_fw_path(cur->path, fwctx->req->board_type);

2.
  alt_path = brcm_alt_fw_path(first->path, fwctx->req->board_type);
  if (alt_path) {
    ...

Looking at them I would rather expect to see (as a quick fix, the
better solution is to unify those call sites by splitting out a common
helper):

  if (fwctx->req->board_type) {
    alt_path = brcm_alt_fw_path(first->path, fwctx->req->board_type);
  else
    alt_path = NULL;
   ...


> @@ -599,6 +599,9 @@ static char *brcm_alt_fw_path(const char *path, const char *board_type)
>         char alt_path[BRCMF_FW_NAME_LEN];
>         char suffix[5];
>
> +       if (!board_type)
> +               return NULL;


-- 
With Best Regards,
Andy Shevchenko
