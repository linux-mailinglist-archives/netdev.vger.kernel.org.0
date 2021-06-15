Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFAD3A89C6
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 21:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbhFOTxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 15:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbhFOTxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 15:53:05 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FDC1C061574;
        Tue, 15 Jun 2021 12:51:00 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id u18so256424pfk.11;
        Tue, 15 Jun 2021 12:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Tmn7Qs27sSC17wg+6pi/G56sByOCg1rr24W9UoH5oRo=;
        b=AEW3YvA+PHWywV7H/jrnAFE/mjA14AFvBLdSP2YYo+4IbWudhW3aVLiFuXdZ/Frdj1
         3PNNkpRk4v05vttaidUgqZQ416Q+ePKHPQfyyyAijo5H1PCUkvHom1N24AMHax47oc+R
         sZrNibho2qVqps++bIFyYuv4a6gkp5KyJyycLpOfXi93MQLfNU8zpstODqfLIwvnNvfp
         ygl+8PnDM1/3/heskVFoNqS7Q35oGRLbMFlxCDWk99Xss+6H3n8hSHpDCfJPj4S/tjVA
         3UyDAhVwZmm129op8ErQJOTPadoEvQDETHuHcjs8zUmBDTaUnbXC1bbELL/v5FwkBVvy
         UO1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Tmn7Qs27sSC17wg+6pi/G56sByOCg1rr24W9UoH5oRo=;
        b=QFyqPiow3S9Ikzr0RRWgcl3QhXf5uy3pE88v32709dDEHNxJAs0Ie6XYr/ymiY+ijT
         kp9HYUVDcUGUUvIG2UgIkYMcF9F7VNb9T6SrLev2StdeJnmTP8UG+ki40vcPTcTPEmrb
         h3WBv16s4KFgnR4As0kxMDVocxvdFBXHXEeqIBH8+ZkHeml102UvbOE6vefyfjXHVNej
         yMGt1EC/AKciGKk/GItfDZHtoLqSggeZ4kCdBnPFbV+yKICw9KNUe+DNsX1Rq7uxIVba
         tXP/WhMEwu9kLfhllxC8obR73dUUQ/ICNcziTngoiQYCF5KallPGIbgzlAU6SPnSO1A3
         9RsQ==
X-Gm-Message-State: AOAM5316NItXf3UcoGp+CwJKKagvl4oZP2K0o1drss9Y4H0XRhPcOZTB
        JNV9U1pvoI3BB8EELMldDVYLqeuSIYanlug4LKR/bAv3WuoVKo8j
X-Google-Smtp-Source: ABdhPJyaFJ17QXCrI4dW/f6IRBXohJ1AwMqYeFCfuAe7mj1IAIfIYLVGSnzcTEuIG2mMv/Hlh2ci/uEIyNxxFEX+CB8=
X-Received: by 2002:a05:6a00:139c:b029:2f7:102c:5393 with SMTP id
 t28-20020a056a00139cb02902f7102c5393mr6179944pfg.40.1623786659779; Tue, 15
 Jun 2021 12:50:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210613183520.2247415-1-mw@semihalf.com> <20210613183520.2247415-2-mw@semihalf.com>
 <YMZdvt4xlev3JQhF@lunn.ch> <CAHp75VdMsYJMCwH2o14e7nJBTj6A38dkcZJ+0WQfnW=keOyoAg@mail.gmail.com>
 <CAPv3WKeubNaxpv442d57bEqA1ZtPcTXOswcsuCsregW_2Akdww@mail.gmail.com>
In-Reply-To: <CAPv3WKeubNaxpv442d57bEqA1ZtPcTXOswcsuCsregW_2Akdww@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 15 Jun 2021 22:50:43 +0300
Message-ID: <CAHp75VfO5p-SpDWhJ+BFuG3-2YW+4-rBn-SLR2s0z8Po-CHcqA@mail.gmail.com>
Subject: Re: [net-next: PATCH 1/3] net: mvmdio: add ACPI support
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "jaz@semihalf.com" <jaz@semihalf.com>,
        "gjb@semihalf.com" <gjb@semihalf.com>,
        "upstream@semihalf.com" <upstream@semihalf.com>,
        "Samer.El-Haj-Mahmoud@arm.com" <Samer.El-Haj-Mahmoud@arm.com>,
        "jon@solid-run.com" <jon@solid-run.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 6:09 PM Marcin Wojtas <mw@semihalf.com> wrote:
> niedz., 13 cze 2021 o 22:08 Andy Shevchenko
> <andy.shevchenko@gmail.com> napisa=C5=82(a):
> > On Sunday, June 13, 2021, Andrew Lunn <andrew@lunn.ch> wrote:

> > The better approach is to switch to devm_get_clk_optional() as I have d=
one in several drivers, IIRC recently in mvpp2
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/com=
mit/?id=3Dcf3399b731d36bc780803ff63e4d480a1efa33ac
>
> Yes, this would be a nice improvement, however the
> devm_get_clk_optional requires clock name (type char *) - mvmdio uses
> raw indexes, so this helper unfortunately seems to be not applicable.

As far as I can read the code it smells like devm_clk_bulk_get_optional().
Am I mistaken?

--=20
With Best Regards,
Andy Shevchenko
