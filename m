Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C6A3F8D0D
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 19:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243220AbhHZRbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 13:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243168AbhHZRa6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 13:30:58 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF529C0613CF
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 10:30:10 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id x140so7506058ybe.0
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 10:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H1pLhNC6KYj6xtSbCEQcYzGpmuVWT9FKhX5+K+Ucayk=;
        b=t6pmA5rCyKM9N2sknfWDZ4LbPR1e1amqTFZLvR6wK2Zc1weiFrqMrE4a8FfVI45LMb
         mrRrMdXpdgPYNWX10KTSA4PYeOSwrf2mtDR/+nPOYBV+tuN0fyu8Q/5COhoXGcfrPNKG
         RQ+CzuANiF9QrnkL21ISoXWdp+OF2WAaJ1Uz4e8UvbaL6M28M6/a197Bc4G5HwZCJa2P
         flsIOQ/0EJlaOIjsgnyN4xf/ow74S0OPdRp1W/Bn1lAJRqEVpGAVKQx3xViMLm55xSCx
         ySRl2dmdnWh3PckyE2or7bxfNbFmfARLFQFJofDJWE8Nx4uz40rI4JAn0wGGco3ZH32O
         ODJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H1pLhNC6KYj6xtSbCEQcYzGpmuVWT9FKhX5+K+Ucayk=;
        b=HoNWrQ4I0R7jZ/C3+jExC+WgYaUrcPUe11lYTpoHY2mtrRZrtbjBNcavDPqlDDTD9a
         fmeMhNljEHbyz14k3Cpo0H0rPfozRBWMKOgD7h/x76BaSPu7XaUCMHWKfXJHQWvh6GCI
         iGQs+YqVHJ+Q59VuBx1HMcJdQgmJVzLfnbNPeCTMCuCUXJVCi+Bem+kwr6VwoQn1n8HD
         /KGGyOBNoNjsEGFjoy4w2EzNcSJVFXQ8kxi1vyQ5BwcQtpAAUavxUPBhyyzvZU+Ahivz
         +Iwpc1pMsWfUh2Uu3f122jkiTGY2trIG08ZH6T+urj0BXyiVtsFcT7K+vRnnbasxqeIB
         WAZA==
X-Gm-Message-State: AOAM5330+tJCQeQlt42IA3O/TbP5NCsOt3PCsguIGCfxzi1j+axac1z/
        YDxLAya+63GbNvqR8ByBhBCCIOow/6HyoI8ox3FL5w==
X-Google-Smtp-Source: ABdhPJwofSmgGzYxpPFeSD3kewypH8C/hs/fMe8d3LyZt0QJ0QMPeZWUM6rZY0aBZXiBWIlwZRZEEVkixK7Uqv47zeY=
X-Received: by 2002:a25:d213:: with SMTP id j19mr4915512ybg.20.1629999009793;
 Thu, 26 Aug 2021 10:30:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210826074526.825517-1-saravanak@google.com> <20210826074526.825517-3-saravanak@google.com>
 <96014c79-44f6-dea2-2b53-6cbfebac9351@gmail.com>
In-Reply-To: <96014c79-44f6-dea2-2b53-6cbfebac9351@gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 26 Aug 2021 10:29:33 -0700
Message-ID: <CAGETcx96kS=Tfb3DeaBjETsNZHz+EKu8j7VpJfKpnVoQp_QgKw@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] net: dsa: rtl8366rb: Quick fix to work with fw_devlink=on
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 26, 2021 at 4:25 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 8/26/2021 9:45 AM, Saravana Kannan wrote:
> > This is just a quick fix to make this driver work with fw_devlink=on.
> > The proper fix might need a significant amount of rework of the driver
> > of the framework to use a component device model.
> >
> > Signed-off-by: Saravana Kannan <saravanak@google.com>
> > ---
> >   drivers/net/dsa/realtek-smi-core.c | 7 +++++++
> >   1 file changed, 7 insertions(+)
> >
> > diff --git a/drivers/net/dsa/realtek-smi-core.c b/drivers/net/dsa/realtek-smi-core.c
> > index 8e49d4f85d48..f79c174f4954 100644
> > --- a/drivers/net/dsa/realtek-smi-core.c
> > +++ b/drivers/net/dsa/realtek-smi-core.c
> > @@ -394,6 +394,13 @@ static int realtek_smi_probe(struct platform_device *pdev)
> >       var = of_device_get_match_data(dev);
> >       np = dev->of_node;
> >
> > +     /* This driver assumes the child PHYs would be probed successfully
> > +      * before this functions returns. That's not a valid assumption, but
> > +      * let fw_devlink know so that this driver continues to function with
> > +      * fw_devlink=on.
> > +      */
> > +     np->fwnode.flags |= FWNODE_FLAG_BROKEN_PARENT;
>
> Are we positive this is not an issue that applies generally to all DSA
> drivers?

Possibly, but I don't know enough about that framework. Let me respond
to the email from Andrew[1] and give a summary there. We can go from
there.

[1] - https://lore.kernel.org/lkml/YSeTdb6DbHbBYabN@lunn.ch/#t
-Saravana
