Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3403A1681
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 16:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237367AbhFIOFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 10:05:48 -0400
Received: from mail-qk1-f179.google.com ([209.85.222.179]:44710 "EHLO
        mail-qk1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233831AbhFIOFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 10:05:45 -0400
Received: by mail-qk1-f179.google.com with SMTP id c18so8628289qkc.11
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 07:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sVDNoaWoIPr7Gu4coKMJidA6UIIH0xz9k9qbnaUz7J8=;
        b=iJlKlERUuUveDc52H/UBA4htInK4K98sw+1Ayz5oJXTmrF3qACSyduBsb0JjEwQMbW
         ycrNqdQx56ME5dn/De9p3wL0Y5LDoCl0r1CzB1xal9bZjuZ2Lcycymm2p6t40CRI7EeY
         NAIMSO4IkFVKArQiizkiU7Siv/hUHBEfOzSg1hw/VZ+dQl2xGtKZ0vd77slE0ppBEqet
         VzHufD8GqHZumWetOrjl7FHXX1G5VB0iolsPxAna3f+3qdYYefzPLEY1frWC9Hi1WgJl
         q7gfYQu/rwO3Cb5o5e82+AHRWYP3iex+sMZ1A4Cxu8pZ8O0+G8liV2wJaXQ8tnjE7wTh
         SWFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sVDNoaWoIPr7Gu4coKMJidA6UIIH0xz9k9qbnaUz7J8=;
        b=TBxPDRitgozycwyBjsPOP81kXJIQcwxHDWyGCMSXPHuqe2cbXoQE3py2lKPMJfXuDt
         pOfAxqwhSMLFzHDdQo2jvr0ugQJO0KFePF0Ohrn6Yl5ZykehqajvUS9dWFmrFyVxVBCX
         0wMNTm948Im222+YUOyTLqEf0/S3ljbY2g9pi4PZEqR8LMnL2UYzcPjnzHwkPf8mTfN5
         0cCrH+cQ3f/ul+j+a0TWIp9VpONsH+0wdqJXZ0EFuLcqcBc7QtIwQyv5qev3Z94Jrzx2
         3vZVhcxpiMGv8+1Hc/duX6OQhNHCD+6T4SESCeUD+dbrDLbLra3C/jFXpTt2WmW/dl7Q
         6zfg==
X-Gm-Message-State: AOAM531JVNCNZEsqo2yv6QWmlj94EBlM0hxPVeoOlV3I5f1e/WL0In5o
        dVPY9TYI2TPi4SW0rc2V0I/uJbfRiBOos6vBQ/fGeA==
X-Google-Smtp-Source: ABdhPJwlk2i2QGb5aCViuWJX+eoq6tbslIAd6c4NjfiqRzuaqx1Qhw3+Qm2upFCUr66Dek9NsQIgBkV2/OBf55wIx8I=
X-Received: by 2002:a37:a1d5:: with SMTP id k204mr16597525qke.300.1623247370731;
 Wed, 09 Jun 2021 07:02:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210609134714.13715-1-mcroce@linux.microsoft.com>
In-Reply-To: <20210609134714.13715-1-mcroce@linux.microsoft.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Wed, 9 Jun 2021 16:02:39 +0200
Message-ID: <CAPv3WKdhyb=o=v0oj+gVWWH3yfqQ1EqBcR-1y4R39x_-Or72-w@mail.gmail.com>
Subject: Re: [PATCH net-next 0/2] mvpp2: prefetch data early
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sven Auhagen <sven.auhagen@voleatech.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Matteo,


=C5=9Br., 9 cze 2021 o 15:47 Matteo Croce <mcroce@linux.microsoft.com> napi=
sa=C5=82(a):
>
> From: Matteo Croce <mcroce@microsoft.com>
>
> These two patches prefetch some data from RAM so to reduce stall
> and speedup the packet processing.
>
> Matteo Croce (2):
>   mvpp2: prefetch right address
>   mvpp2: prefetch page
>
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>

Thank you for the patches, they seem reasonable, however I'd like to
stress it on the CN913x setup @10G - I should have some slot for that
closer to EOW.

Best regards,
Marcin
