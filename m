Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C425AB0BBA
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 11:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730919AbfILJl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 05:41:56 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:44942 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730470AbfILJl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 05:41:56 -0400
Received: by mail-lf1-f67.google.com with SMTP id q11so3848393lfc.11
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 02:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6RSUOvSNksdnUYSmi7ImPO3GUMvdFvOcyPQJVj+uUBA=;
        b=dIWOPJqfucag4BHcYnnZ8GmQSV6fzoImY8SV/+J5Q6xJ3aWO4AT2VTggjkxgR0kaoJ
         v8m6K2FcP12vy5m8vMZ9283lPrNaHC7wZZo2pkaHnmWlT3g3fnM2Bu+LYlAodlbGuBwi
         I2WLDFUsZVxBPG74qJg+RQcmKS3pfsG5+qwFk0i8wKxxImYTJp5UFlY60k9ESRM9VTA6
         d6cVhUfPH8R+dJUOzgwuQugXU2vKstME/JbmXgCWgdopIuRCH000mUWKBDUdw7dXdmmj
         C8x8iW0j4L5GKZt2PBNup3YxIoGZGeBiQVT57scO4bqnpybmLeCm52julMK78TA+I0g7
         cqbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6RSUOvSNksdnUYSmi7ImPO3GUMvdFvOcyPQJVj+uUBA=;
        b=NZRVbTudNMZpPYawIGVGULKBhlf45mPfsCXxgHuMrIof5sp1CKzkIgceJ5u/ZS7jrd
         Af0W01VxJe2teWNMVUCJLawZTdluQYNVXjknzUc/5WaDMp55LEyT5iunFaUtUFGsvZDJ
         9/1LLT8112jhs973h4F5xVubT1vUsXa1bdDsCKpA1r7u+o5bFZOccJ9bjyotfxSufvsm
         Z3EoYJDBhFeZlcrnJctxfzV24y1duF0DJqxpPktUdmmw+6n6p1Vw0BYM/2/x8R1JrypG
         yNecyhocauFqsyD7lkGMcDhMz8hU+dsh8MVdZZhfeKYQoOxMvqDA5OL1/ECHi0zokqLB
         fHCw==
X-Gm-Message-State: APjAAAWwZ2djarhnJ6GrD1zrub/qUs6dkfHwd7X1KCN9SRJxvDGvthqt
        n3EyXA4qswGdWD83tjqh6Q3/tSHy0cMSdZthEloDr5yTgS7C3FYd
X-Google-Smtp-Source: APXvYqz+NHIm3ClqeP49m5uOlZRwSCiWVPrJwTDKiLWdx7zhe9GVGvQS+zPe9EJmnmVbo3ibul2QuWqxgyHRCCkBksk=
X-Received: by 2002:a19:48c3:: with SMTP id v186mr27253402lfa.141.1568281314260;
 Thu, 12 Sep 2019 02:41:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190911075215.78047-1-dmitry.torokhov@gmail.com>
 <20190911075215.78047-5-dmitry.torokhov@gmail.com> <20190911092514.GM2680@smile.fi.intel.com>
 <20190911093914.GT13294@shell.armlinux.org.uk> <20190911094619.GN2680@smile.fi.intel.com>
 <20190911095149.GA108334@dtor-ws>
In-Reply-To: <20190911095149.GA108334@dtor-ws>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 12 Sep 2019 10:41:43 +0100
Message-ID: <CACRpkdbTErKxFBr__tj391FHwUTxC7ZF_m94tC8-VHzaynBsnw@mail.gmail.com>
Subject: Re: [PATCH 04/11] net: phylink: switch to using fwnode_gpiod_get_index()
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 10:51 AM Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:

> If we are willing to sacrifice the custom label for the GPIO that
> fwnode_gpiod_get_index() allows us to set, then there are several
> drivers that could actually use gpiod_get() API.

We have:
gpiod_set_consumer_name(gpiod, "name");
to deal with that so no sacrifice is needed.

Yours,
Linus Walleij
