Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C8A44E0AE
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 04:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbhKLDPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 22:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhKLDPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 22:15:14 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C42C061766;
        Thu, 11 Nov 2021 19:12:24 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id u18so13084105wrg.5;
        Thu, 11 Nov 2021 19:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kyyZCz/c64azEPJMrNfaspdkXcPIMlzhsfOAzsY+TAE=;
        b=bFrZhtd396ogw8yZKWVmQz4qUxlLV3mRx+DOSPzglfO68HAdSTIzTziS3BGLnLkzp1
         nraR4q1e7wgtKrk0UiP8xV+WbTz+wtgEjKznjqLTT//V6ylR3EHiqcpC5FKY3MfpSM/Y
         KpQGLPykD4Rj3uPh+qJ/noKbKrY8yTB7Ewvwy6i339xRqB1+nhw8Sspgz0B7Rzk0556w
         zIsRa+34BXvVh88xpriCafP4dVUC2X8nWL4u+cCiquTDqhnE7+X4hp2tiG+uY7j3E5Wg
         7NU4oVfBv1t4r0e20OWisng37Gre2J35pGBz2HQ/y+0+NDhxZUXSVa7IdzDm19IEnGEp
         v+9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kyyZCz/c64azEPJMrNfaspdkXcPIMlzhsfOAzsY+TAE=;
        b=S3nuG+i9m5qO3gWB9rkEw7YDD/AkkZezi/w+SsB1qUIDeDN5TWs0WD36UQ0UHboZy1
         zHJgWS4/yvrS4UeUQFbB2uWA2cNEhN4nT7P3brZN6Nqf4AuXqACGcGzuBao+vN4XRd6J
         0ZkLjHCYt9saSgJvNjAE9iKB8DOxhlozTlVQSThSRCzZQzvm9AkWAkYwbK62LbMpArEB
         AA+3bBQiOdyOIo2eHGaA9XjOeNnrkZ0E1b4ZdJ8KRVhN2+A1jI0Q2hqGF3j+XhOsI72D
         0WS49T/w1viIWibWPS1WCJmATpOgLVB/NEZrlSKR2BZJGKWZUFE3wcCEyUeQUu6Kgi66
         iUXw==
X-Gm-Message-State: AOAM530goV7c4PdhgQDcdqhV04BG5ip5tGMZgVKIKGAm8yiJfI3NNQaE
        Ufg8GwBqg6ImK86tK5disDsYYKefoV7+Onu6E48=
X-Google-Smtp-Source: ABdhPJxhzBSjyltJHOdHti0F2wT56KUnqMQSEjQAo0b9yjUNN3VlovELHxvMToJqLnIdVLSPtlclqXwgqOH/Gqymh/0=
X-Received: by 2002:a5d:658c:: with SMTP id q12mr14618865wru.34.1636686743350;
 Thu, 11 Nov 2021 19:12:23 -0800 (PST)
MIME-Version: 1.0
References: <20211111145847.1487241-1-mudongliangabcd@gmail.com>
In-Reply-To: <20211111145847.1487241-1-mudongliangabcd@gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Thu, 11 Nov 2021 22:12:12 -0500
Message-ID: <CAB_54W6K+FTTRxLbUHp8csBbtJf=E+JU-zd3q7mQZpa-LHTX8A@mail.gmail.com>
Subject: Re: [PATCH v2] net: ieee802154: fix shift-out-of-bound in nl802154_new_interface
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, 11 Nov 2021 at 09:59, Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> In nl802154_new_interface, if type retrieved from info->attr is
> NL802154_IFTYPE_UNSPEC(-1), i.e., less than NL802154_IFTYPE_MAX,
> it will trigger a shift-out-of-bound bug in BIT(type) [1].
>
> Fix this by adding a condition to check if the variable type is
> larger than NL802154_IFTYPE_UNSPEC(-1).
>

Thanks.

I just sent another patch to fix this issue. The real problem here is
that the enum type doesn't fit into the u32 netlink range as I
mentioned some months ago. [0] Sorry for the delayed fix.

- Alex

[0] https://lore.kernel.org/linux-wpan/CAB_54W62WZCcPintGnu-kqzCmgAH7EsJxP9oaeD2NVZ03e_2Wg@mail.gmail.com/T/#t
