Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF6B2C5704
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 15:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391022AbgKZOWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 09:22:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388748AbgKZOWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 09:22:49 -0500
Received: from mail-vk1-xa43.google.com (mail-vk1-xa43.google.com [IPv6:2607:f8b0:4864:20::a43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B55AC0613D4;
        Thu, 26 Nov 2020 06:22:49 -0800 (PST)
Received: by mail-vk1-xa43.google.com with SMTP id v185so493243vkf.8;
        Thu, 26 Nov 2020 06:22:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dPNuedcPIqOl+YqSwaPvo2b+a8uPqyggfoKumSYgsD4=;
        b=Lsde4qdhM06nKRX/VaymIBd6YLLcJ1yoIwfekLPfi/k9ffzCmbB2USPyAayLJiV9q3
         GfDvbUhu3Q4Ltri67fnFIg41PiUtjxSt5ZRTS7By4l4dVMIN/G+K0OVFgUnRHitHQLS0
         fnYlB6o3RPGceRUmRzMjDY+nC+4Lp85+dFzhsSDAZLWE9EIYsjCt4iimxyJzQjoaLiCT
         GEt7X1ELBQLjKT8jzOkRQWtfUXhCltJAOu/5d0DrsC5Jnel1LnWx3cWvQCfQDQMp0itC
         MfrkleldCDH6MI0MazMtLxgzvDIjWm88pgXlW3dcB3fXDkvOlDp7fG3LkpGC6BdCsxMc
         NMTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dPNuedcPIqOl+YqSwaPvo2b+a8uPqyggfoKumSYgsD4=;
        b=NeVLp3CUvFI6TMExQxVT4KytufuJexgV+ZFKeVVn/9G252xH6iJ0Onc8MN/2eaHtlO
         qybNSRGM1JkbyX4QyqlUOjKYfFpaVRZj8sU9n9eZB7wzMFYQpkNB5u0mBvdJHpP3Dfok
         28uoKBQ0ZAtpJmIXv6o6cAIioxEv9RYUQ4Sg99ABQ48cW3J0+mmgcXxKL4g1HaijwTMn
         cF8C47fC8S9qvwGwWtXf32irAT7h/DnJPj0MDcQwfJIsxGSkLaLpDF1vV9rV84ysfpLk
         2+2GUSafOBHJ4L9Tx2lqZV/RRYNLfGB1rSdZinvNKD+UbpQu9UEtcS7hL0+3yIiH23Fp
         2Qgg==
X-Gm-Message-State: AOAM530/QPjtUuAeGv3MBJalAsN+Ie8InJnPS2LTiv1Z0rhWM1MD1keK
        tUxk9eymNj5kENl7QplME1sjmu309d/rdLqSH4I=
X-Google-Smtp-Source: ABdhPJzq6AenRluSNTe1H3AmMaVwhHXnsftESP3ZuB4q3EZrjG64cbq4JIoH/Bca8vucaaeNwgfn+5i83AsdOVw3T8k=
X-Received: by 2002:a1f:5587:: with SMTP id j129mr2075212vkb.0.1606400568566;
 Thu, 26 Nov 2020 06:22:48 -0800 (PST)
MIME-Version: 1.0
References: <220201101203820.GD1109407@lunn.ch> <20201101223556.16116-1-sbauer@blackbox.su>
 <20201103173815.506db576@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201103173815.506db576@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Thu, 26 Nov 2020 09:22:37 -0500
Message-ID: <CAGngYiXFJTQN3+-HC7L0F5cVfXBpPLS3O4gbaSdMmNurzgnwGw@mail.gmail.com>
Subject: Re: [PATCH v3] lan743x: fix for potential NULL pointer dereference
 with bare card
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Sergej Bauer <sbauer@blackbox.su>, Andrew Lunn <andrew@lunn.ch>,
        Markus.Elfring@web.de,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, Sergej,

On Tue, Nov 3, 2020 at 8:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon,  2 Nov 2020 01:35:55 +0300 Sergej Bauer wrote:
> > This is the 3rd revision of the patch fix for potential null pointer dereference
> > with lan743x card.
>
> Applied, thanks!

I noticed that this went into net-next. Is there a chance that it could also be
added to net? It's a real issue on 5.9, and the patch applies cleanly there.
