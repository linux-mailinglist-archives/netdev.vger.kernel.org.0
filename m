Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1410F275A23
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 16:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgIWOdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 10:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgIWOc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 10:32:59 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093D0C0613D1;
        Wed, 23 Sep 2020 07:32:59 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id t10so307559wrv.1;
        Wed, 23 Sep 2020 07:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GGRsimobAk7x9LK53KoArxzuwgLweU0zv4O8HtxU3QU=;
        b=guhvDUgj7+1dXFzvcpFXADDm35dNnDDQkjJHeoeSzaJ5Jk49QzA0LbQ1uUJMRmIqwc
         l2SUPj2ZQoOdMOS5hGsHo4H1knkD5sIYGO/VRiaxyRC2jHZ/zKDU9gN47kYPszK4MNXD
         zvlKfcAjx8BA0+uvZ0StohuB9f8/NbMirKXB/FBEKrIedceDhM5wH7n9/x80ybGTlIor
         e2m0YG91VSiSjJZNGHO+kHRObIXqJ+Qh9eSEND15zhZMs6dGyFJyh0CDq0NUC7TA+AAu
         8q0oUJIMwgEcEfPf2rQZNOOH3FzqfBm6iZxLzX5h9hNAQBrvgeK2iHank5P0LsFNSoLD
         vkqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GGRsimobAk7x9LK53KoArxzuwgLweU0zv4O8HtxU3QU=;
        b=pgyozQiSLAjks2jLkAgXHCB7RZO+4Mz+8QTzkNOHPB/NQf8mbwwANSiPQstBQIZ6iF
         vijP8VDPgnAssAB/a8SdLkgbUCm5hi7LZ+TrxCe2ndSq1WSmvHhkDmXVObJk6ANe1wCN
         lvZmoax2IG8GFZZeEKRh4gZHA3l61rOO9e+vWDJIq+jeSUVbNDKtUB3XfXfYMPdR5gw4
         XWEGUowTIMkjZidfEzmlLjp66wJIcB3p0gLa4KJ3JuQVOSVfubjOnvRZaUmFWOaYDmxK
         aZDrfXvpKd3Uap853mzdn83qt3i6eSMX6Pqnv1HJHjKJUSfhTFFVyt8IA1MBkrrQcIkN
         +FeQ==
X-Gm-Message-State: AOAM532p/7YEdKPvxl95jp6FJ2PjFjNoPAAgMY195Gb6x7rmjBU9QYIE
        EOG5nrX57VQOHGO28LYmvjWP+JZgPvxPf3RUQyU=
X-Google-Smtp-Source: ABdhPJw3bJWXUQEbxcOWG3BwMQnvs4bzdMoNz2+ECyQzSG2TYRvZiHkcRHjLhdvWlUL3SNf4cg5/E1g2Ls1K+PiJxik=
X-Received: by 2002:adf:9b8b:: with SMTP id d11mr1269065wrc.71.1600871577757;
 Wed, 23 Sep 2020 07:32:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200923090519.361-1-himadrispandya@gmail.com>
 <20200923090519.361-4-himadrispandya@gmail.com> <1600856557.26851.6.camel@suse.com>
 <CAOY-YVkHycXqem_Xr6nQLgKEunk3MNc7dBtZ=5Aym4Y06vs9xQ@mail.gmail.com> <1600870858.25088.1.camel@suse.com>
In-Reply-To: <1600870858.25088.1.camel@suse.com>
From:   Himadri Pandya <himadrispandya@gmail.com>
Date:   Wed, 23 Sep 2020 20:02:45 +0530
Message-ID: <CAOY-YVkciMUgtS7USbBh_Uy_=fVWwMMDeHv=Ub_H3GaY0FKZyQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] net: usb: rtl8150: use usb_control_msg_recv() and usb_control_msg_send()
To:     Oliver Neukum <oneukum@suse.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        pankaj.laxminarayan.bharadiya@intel.com,
        Kees Cook <keescook@chromium.org>, yuehaibing@huawei.com,
        petkan@nucleusys.com, ogiannou@gmail.com,
        USB list <linux-usb@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 7:51 PM Oliver Neukum <oneukum@suse.com> wrote:
>
> Am Mittwoch, den 23.09.2020, 19:36 +0530 schrieb Himadri Pandya:
> > On Wed, Sep 23, 2020 at 3:52 PM Oliver Neukum <oneukum@suse.com> wrote:
> > >
> > > Am Mittwoch, den 23.09.2020, 14:35 +0530 schrieb Himadri Pandya:
>
> > > GFP_NOIO is used here for a reason. You need to use this helper
> > > while in contexts of error recovery and runtime PM.
> > >
> >
> > Understood. Apologies for proposing such a stupid change.
>
> Hi,
>
> sorry if you concluded that the patch was stupid. That was not my
> intent. It was the best the API allowed for. If an API makes it
> easy to make a mistake, the problem is with the API, not the developer.
>
>         Regards
>                 Oliver
>

I meant that it was stupid to change it without properly understanding
the significance of GFP_NOIO in this context.

So now, do we re-write the wrapper functions with flag passed as a parameter?

Regards,
Himadri
