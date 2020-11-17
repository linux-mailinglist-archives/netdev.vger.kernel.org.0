Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA75F2B71A8
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 23:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbgKQWhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 17:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728044AbgKQWhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 17:37:24 -0500
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30461C0613CF;
        Tue, 17 Nov 2020 14:37:24 -0800 (PST)
Received: by mail-vs1-xe43.google.com with SMTP id r14so11993680vsa.13;
        Tue, 17 Nov 2020 14:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FH0fknj5QJLn7ACk6eHCDF4ifC/QH5RQ09fYM2ZGJIo=;
        b=hg1BLUQst6GW972wQO6yoKvxwrDLtitHDX81KV5ZMKYkm1fpa7VVhZgNtu5jPgyT0w
         gZoilM8SDc7ws/l97y7/fGIDQc1xdWxC67c5OrLjxiX4hklbRE2JwNlBc+MTiw5n8IOk
         srJBpwZBOuOOfaDT3UVMLQoiG4/3gXs+Tp1mRJeLhK6ddivscYjHTAnVouU0eEt0Kv/R
         n0a/bj7JZBvYK/3essXFR/8AEWDgwpilXQCa1YTZxAkcq5wI7fqoO7Se5SWBWh1FGXq4
         6pj+SayHv+uwgI8haQTnINfIUgQMtxtFaFMY5kysWywMaqBTll86xwKUv+okb7EknlFX
         BYFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FH0fknj5QJLn7ACk6eHCDF4ifC/QH5RQ09fYM2ZGJIo=;
        b=pOmo5pvnP7W5PoY/thxaup0woFZ8UJNYkju5MPK9C71U+9PRfJd0XNJO3f0e3udYCk
         JNYa5r7yjZycuZXnA3rly4FbBJbtzlK2ovwp1gJxxyE05QRrNIdCCPsYU0T1ynFYACAS
         OuBL6P+tiarokgiHao+3lnOs3nL/rNVTZXRseaMNonbIVFggkjiDUVyuOgRRRo1XuC7S
         3Vst6pdAsNKoQtR4w5fmm5TQpTgTOiW9DLawDPvoOYCBfuqdXgJaVbfyRTDoGA8+T1/R
         YdmfvYAVGhfzk4Sq0fOCSq6csaOPf65eJfWgaerdkNMhwK1W6EqHDyQCsTO0Be+D/wfs
         gckw==
X-Gm-Message-State: AOAM530is4IlV/l88zVpr8OGFBrMxiy3AgtJok4fkIYzjSZ4KNUdP5yX
        FcsCqVcfW6xSP0q7zS8ctN5HRUeCQQzPfMJN4Jc=
X-Google-Smtp-Source: ABdhPJw0dHxEKGFCmqFVt2j3PyuzKce5F1S5+aX55J/xRjd/U8OC7zjcqARyFKNqCL/poMscrkcf+hmqP2z4gvA/Jes=
X-Received: by 2002:a67:ff10:: with SMTP id v16mr1472632vsp.40.1605652643329;
 Tue, 17 Nov 2020 14:37:23 -0800 (PST)
MIME-Version: 1.0
References: <20201116170155.26967-1-TheSven73@gmail.com> <20201117020956.GF1752213@lunn.ch>
 <20201117104756.766b5953@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201117104756.766b5953@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Tue, 17 Nov 2020 17:37:12 -0500
Message-ID: <CAGngYiXtnZ9WTOEtdvz1hnUkiSbJMX+rk6nvmVyhSOX8d5rNFg@mail.gmail.com>
Subject: Re: [PATCH net-next v1] lan743x: replace devicetree phy parse code
 with library function
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Roelof Berg <rberg@berg-solutions.de>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 1:47 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 17 Nov 2020 03:09:56 +0100 Andrew Lunn wrote:
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Applied, thanks!

Thank you Andrew and Jakub !
