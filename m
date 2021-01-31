Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27525309946
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 01:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbhAaAPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 19:15:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbhAaAPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 19:15:11 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CC2C061574;
        Sat, 30 Jan 2021 16:14:31 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id u14so9614943wml.4;
        Sat, 30 Jan 2021 16:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TlZACLBYSiWOJ+PR1UkJhkGCoBOMzhgTmOJYTxZL9PA=;
        b=eHf3+tbIJp2pu2zKGA6AWA/ybCWQXCVKwZNb8zBWbbVK811Tvts9quv+vae59pNXXu
         jyl9rIZ56ADmLYwnju9FXzVXU/P1y2aB4XKbt1rMWPiFWT5p0IJnVEFXjAA7fbdzXX/a
         RG9O4GpkfeblUAGFdc3eKYMcInen+UQszFn7sKlSGqWpiHG68wZk3DGZzS/tZbfuLKCm
         reJOilZQwXCNzJW6Z/c8VidoHSUNZrPSyzPyJP2ywA/dSvPikVODe+a7Ufa45/2K+W6L
         rbZ4OvR7b6+SwJcUWVi93P2fRgXxT8Dvp6V5AItTdel+5C6nwhylgAO8ZHDoOe+hBmTF
         X0qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TlZACLBYSiWOJ+PR1UkJhkGCoBOMzhgTmOJYTxZL9PA=;
        b=WVusL7WpljUpffXokOINqbYh6wF73TmDl5tdIJ/kGI7RmuNg5nrmXJRzxV5hcKnzWu
         DEo2hXioRpUQyJqgxYxBQ3edTElUqbSDynW4L6+GiXHpo8mKAAXWD7so9oBUL2BTwkGm
         r+cg8wRisFluQTcj9a2lM6jYktoyrJ4y0qOarYel92Ofx6vw+8c1xDXYvMK/M3C866wm
         atbLUKOsorbuU0vWqhf6tlq4cNrrFvpG+Sacm71dy6EltB57tMO0TMeTc3vzpyWebERw
         pj9pmSmBH1XSTmz+1lRr75usoIFplbjr6oGt+gmkYqy7emjIrdywrgphb/dZmT4B6DSl
         NC2w==
X-Gm-Message-State: AOAM532zRiLxuCh4DC64juWZEtEPIr1eHktJvtcIoyI2bwujvrjQHnpV
        gl+GosgvikoyELFVTpXFNePHpdFMiLE3npAKUIM=
X-Google-Smtp-Source: ABdhPJwYLU28vfMkVC34u5/L2TH5Z7WULGaf2+EJFPJsenVQwQz2erOC726lGl9LBNij4OxVJ2cXUgl1kc20bpxJu6U=
X-Received: by 2002:a1c:4e:: with SMTP id 75mr9367154wma.150.1612052070192;
 Sat, 30 Jan 2021 16:14:30 -0800 (PST)
MIME-Version: 1.0
References: <20210129195240.31871-1-TheSven73@gmail.com> <20210129195240.31871-2-TheSven73@gmail.com>
 <MN2PR11MB3662C6C13B2D549E339D7DD1FAB89@MN2PR11MB3662.namprd11.prod.outlook.com>
In-Reply-To: <MN2PR11MB3662C6C13B2D549E339D7DD1FAB89@MN2PR11MB3662.namprd11.prod.outlook.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Sat, 30 Jan 2021 19:14:16 -0500
Message-ID: <CAGngYiX-bccoqYW0zQDwseBPADK-eNEcMDA1mhPqQvQC6FS3qQ@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/6] lan743x: boost performance on cpu archs
 w/o dma cache snooping
To:     Bryan Whitehead <Bryan.Whitehead@microchip.com>
Cc:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Alexey Denisov <rtgbnm@gmail.com>,
        Sergej Bauer <sbauer@blackbox.su>,
        Tim Harvey <tharvey@gateworks.com>,
        =?UTF-8?Q?Anders_R=C3=B8nningen?= <anders@ronningen.priv.no>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 30, 2021 at 5:11 PM <Bryan.Whitehead@microchip.com> wrote:
>
> It appears you moved this packet_length assignment from just below the following if block, however  you left out the le32_to_cpu.See next comment

PS this merge snafu is removed completely by the next patch in the set.
So this will not prevent you from reviewing/testing the multi-buffer support,
should you want to.
