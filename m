Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C79664E17
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 22:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233956AbjAJVdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 16:33:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234532AbjAJVcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 16:32:02 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1E862187;
        Tue, 10 Jan 2023 13:30:45 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id x10so16689605edd.10;
        Tue, 10 Jan 2023 13:30:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZJnwnc5E+1MLELDC7o5cz4xsXsnNcb/YZtVXOSbVGQM=;
        b=ffc6MUlkQ0X5tBxAD0ODQUSrf3G4bar1Ib6jYjNkau5gT1LELy0fCeqlRSZw/AetaA
         TjRdeHzmxmXsxTXqcWStVRXDyuUScfhuoabmo3GIWFofczqAiAdQNkgzN1mcbM/F9fMS
         IhslGWIqhAbyoxW9+ZXVfxci4SQqA+K0Xb2Zmfho4P1ut+lLhAM1hvbbNJlDNiC/izhr
         7ZQRDKcp71++pwdfUMUUpknqknG92KLKpkOFJ7dz62gyBqp8e2OJVCJGY3eTpT3QO/Nn
         Gl7gS8tjs6RAwLVs1wMdL2VThNrX2Sxbvvk9ujao59XLiNcSjHEJEjDOSzrgo7Oi2koU
         RJKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZJnwnc5E+1MLELDC7o5cz4xsXsnNcb/YZtVXOSbVGQM=;
        b=HxLK4exN4E7uiHtKqRuadsReC7VMHUjn/+5S9nAev/xFR+YMyMwOhbvxcFJ8ohwD+d
         N3oTjTGy/8wAw2IzNmvqcBj9FZjFh9OcLlOqOV6Uy8+WbBj9MPTHb2IvmrNJAfMPX1qX
         n4BfaH3jiTV2d/KxL96WeZHGP9jRTPKlAfNyBDDv2cl1OTf4momhK0eL78sjJNw1XJNU
         lRakIeVZEPv52p+eKbKOPqaFq6XaHp+B3iaW+5O3cm/hrHV7hRO+B2MkqGcyouWUvgbE
         ELQoU/qa3K5wYUOYI4HaV3Uw3E9Lsh8grMT1ZsOa3A1+S+EXrpsVdN8VBaR/lJ/oSWd9
         9eWw==
X-Gm-Message-State: AFqh2kpm0Ae0rTerEoLGVvkScf/eR4VclDjmK4ailrY9aSbTNb3Kj+76
        ija2AuB/JcqZmYCWynuMwaYtBWtQQz5CK3nfxN3u17oF
X-Google-Smtp-Source: AMrXdXusR0El+e7mEpubh+SpbS/bDLXT6q9dk2fGUC3Igm74IVif0Oiaxjfc8AmnsRFJsATqSYMPrPg+Sb8r44KBuCM=
X-Received: by 2002:aa7:cb03:0:b0:499:c265:752a with SMTP id
 s3-20020aa7cb03000000b00499c265752amr672040edt.257.1673386234874; Tue, 10 Jan
 2023 13:30:34 -0800 (PST)
MIME-Version: 1.0
References: <20230108211324.442823-1-martin.blumenstingl@googlemail.com>
In-Reply-To: <20230108211324.442823-1-martin.blumenstingl@googlemail.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Tue, 10 Jan 2023 22:30:23 +0100
Message-ID: <CAFBinCCD9mK5_LNRh3aj5sTHOZFfMTbF1zaxCMM8YaqZdKdYhg@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] wifi: rtw88: Three locking fixes for existing code
To:     kvalo@kernel.org
Cc:     linux-wireless@vger.kernel.org, tony0620emma@gmail.com,
        pkshih@realtek.com, s.hauer@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kalle,

On Sun, Jan 8, 2023 at 10:13 PM Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:
>
> This series consists of three patches which are fixing existing
> behavior (meaning: it either affects PCIe or USB or both) in the rtw88
> driver.
In reply to an earlier version of this series you wrote [0]:
> BTW wireless-next or wireless-testing are the preferred baselines for
> wireless patches. Of course you can use other trees if you really want,
> but please try to make sure they apply to wireless-next. Conflicts are
> always extra churn I would prefer to avoid.
Noted.
Additionally I just tested it and can confirm that these patches apply
fine (without any fuzz) on top of the wireless tree.


Best regards,
Martin


[0] https://lore.kernel.org/linux-wireless/87mt6qfvb1.fsf@kernel.org/
