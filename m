Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D712D408C
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 12:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730410AbgLILCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 06:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730267AbgLILBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 06:01:53 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3CAC061793;
        Wed,  9 Dec 2020 03:01:12 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id f17so960985pge.6;
        Wed, 09 Dec 2020 03:01:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MKsZH2+iAwgUh8UDFh2dZripOeDuPzMh57usXeoy0CY=;
        b=PtobN+qkKZTUIm3Z46jtCxqfPZ5qOx/6dvovA1iYTJVDHmFO+a2rhs1758yYTQ+k4H
         o+5J6j5AcNAMVeVpAp7vrMoSmL9KXngG20Ofzoa8DD8mtK+wyf/NJjewzF9hQAzLYLtI
         6jblrmw8z2XCD01SDZV2iVGyQGwZjOwtsWcq617+ls42mGL8ToyUg5SD6LFXYUW2U6h3
         U9LjeXul43ThJ2AMcEjBnViTOaJBQvRRg4jzV9bisZIWbW2Uza4DWd52hGGr6Rd9fNfk
         jQhCZKyX4NjyrFTdnLHHi2jtUoUgnyNgsrm+7bZIwv6MRpisKQreDrwtfpcx3O+Un+PG
         /rnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MKsZH2+iAwgUh8UDFh2dZripOeDuPzMh57usXeoy0CY=;
        b=tiShoyIbXXM14gt+VqGDTvbTN0ybOMGh/KnUHQdnkqgapcrDzZNnNCnbx9hbXFg1uz
         fNw5jSwSQzJNuvcyV4+RZM8nDvkOW8L0LVVVFb8opthLrCcew5upV5HnaoAKyWpQvjhq
         HHk0AbMMNwUs8WPo5tEMofNwnJy8hKqHPRz8YULKGKsCP+AyT9JB8ZvxLm0PauZMykbI
         PV/53LJaz3w2WjRtg34ofjxQXSUNRmUKEhix5vk4ddAy1c1iMpFEeVUvXXz3E3jAmMTC
         +LVmfwnZD3wQ3J+hFjNNsCilX4x3xnHhg1FCQeLIRUFp9udAnkxBIvAIRwUdFpCJ+D9W
         Aw8A==
X-Gm-Message-State: AOAM532JbjzXP99PqudCrnGvLYAzjrRNB5R3u7EC23/9KatbdXM/jAo6
        YjKSXwdNU4D82oO0dYIw62br/Q3XOEsP88KbTNU=
X-Google-Smtp-Source: ABdhPJwjF1FoXl7fnHNaReES/WUirms9U5/ouIHB3iXXpgcsDfMHSybf0Zo8utSHuKkU9Lhpmt1u/VwzL8L8+w3d1qc=
X-Received: by 2002:a63:b1e:: with SMTP id 30mr1440855pgl.203.1607511672453;
 Wed, 09 Dec 2020 03:01:12 -0800 (PST)
MIME-Version: 1.0
References: <4d535d35-6c8c-2bd8-812b-2b53194ce0ec@gmail.com> <CAHp75VfBtRS=BA83Q4U9hJ14bO4wW_o44CKs=DBOtWnzqTXO3w@mail.gmail.com>
In-Reply-To: <CAHp75VfBtRS=BA83Q4U9hJ14bO4wW_o44CKs=DBOtWnzqTXO3w@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 9 Dec 2020 13:02:01 +0200
Message-ID: <CAHp75VezKrQAVf4ceJnHq5R8niwMqCme5N5dW0deyVYP3GjO8A@mail.gmail.com>
Subject: Re: [PATCH] PCI: Remove pci_try_set_mwi
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Viresh Kumar <vireshk@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        David Miller <davem@davemloft.net>,
        Lee Jones <lee.jones@linaro.org>,
        Ion Badulescu <ionut@badula.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Peter Chen <Peter.Chen@nxp.com>,
        Felipe Balbi <balbi@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-ide@vger.kernel.org, dmaengine <dmaengine@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-parisc@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 9, 2020 at 12:59 PM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Wed, Dec 9, 2020 at 10:35 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:

...

> > -int pci_try_set_mwi(struct pci_dev *dev)
> > -{
>
> > -#ifdef PCI_DISABLE_MWI
> > -       return 0;
> > -#else
> > -       return pci_set_mwi(dev);
> > -#endif
>
> This seems still valid case for PowerPC and SH.

I see that pci_set_mwi() also has the ifdeffery (I thought it's only
here), so it's fine.

> > -}
> > -EXPORT_SYMBOL(pci_try_set_mwi);

-- 
With Best Regards,
Andy Shevchenko
