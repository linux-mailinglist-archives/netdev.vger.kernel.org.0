Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 964B631E8F7
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 12:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbhBRLGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 06:06:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:58806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229763AbhBRKx3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 05:53:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 124F264E2F;
        Thu, 18 Feb 2021 10:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613645460;
        bh=+mauu4zzK516jrXaWPgdNQfATDJSsJ1VUxBGABPlp1o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=j0JS1rwmiyvhN/0lV+1Z5jUGa7nTioMWdjfB4udR65b1Ch52/70MFB67tsriI/oKD
         4MYLIul3t5Lc7ak+l/Glltldd74TdFqHkWQw6uwil/fGFA5s/VO0Ye1JjcQ/9tpQ4b
         9R4YYLitYA9sAUc+2m8dUsk9UJsIIBgNJKiUfVAkGepleXcdhWftIlfJbMxTIyjGsc
         P63mchYNNEDAMAeAUyGdEB3UPTsC0k8ycrjZBq+L7eR77pso7KB1nep4w2X3dNdXpA
         xLEyjZqbnfr7gJeckm7a8GnCgO+aogfOFXPB25dsO2jy7FgzNtNTKvEgMTG4BjF71U
         HBTVI7Yi1txLw==
Received: by mail-oi1-f172.google.com with SMTP id l3so1512309oii.2;
        Thu, 18 Feb 2021 02:51:00 -0800 (PST)
X-Gm-Message-State: AOAM531dUdnN3/rZ8b1mkNXfSpXeqUqA7lToWBltihhzZchGCh3wn0lb
        hsd8oelFH0Rra32G8FOpvhZxL+tNfVmXQAXTVF0=
X-Google-Smtp-Source: ABdhPJw3k+cZ0ogFt7p9NsJQjvWygTosL2+oW0gd17nM8Xh0KvZA0Ew5LcZ0AkgOz/XlSM3h/KeWnPX0Jox9y49NEKY=
X-Received: by 2002:a54:4007:: with SMTP id x7mr2182283oie.11.1613645459264;
 Thu, 18 Feb 2021 02:50:59 -0800 (PST)
MIME-Version: 1.0
References: <1613012611-8489-1-git-send-email-min.li.xe@renesas.com>
 <CAK8P3a3YhAGEfrvmi4YhhnG_3uWZuQi0ChS=0Cu9c4XCf5oGdw@mail.gmail.com>
 <OSBPR01MB47732017A97D5C911C4528F0BA8B9@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a2KDO4HutsXNJzjmRJTvW1QW4Kt8H7U53_QqpmgvZtd3A@mail.gmail.com>
 <OSBPR01MB4773B22EA094A362DD807F83BA8B9@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a3k5dAF=X3_NrYAAp5gPJ_uvF3XfmC4rKz0oGTrGRriCw@mail.gmail.com>
 <OSBPR01MB47732AFC03DA8A0DDF626706BA879@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a2TeeLfsTNkZPnC3YowdOS=bFM5yYj58crP6F5U9Y_r-Q@mail.gmail.com>
 <OSBPR01MB47739CBDE12E1F3A19649772BA879@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a2fRgDJZv-vzy_X6Y5t3daaVdCiXtMwkmXUyG0EQZ0a6Q@mail.gmail.com>
 <OSBPR01MB477394546AE3BC1F186FC0E9BA869@OSBPR01MB4773.jpnprd01.prod.outlook.com>
 <CAK8P3a32jF+iCH5Sk82LaozyPJ0n=f92MRdseZwN9aOtf4DwKQ@mail.gmail.com> <OSBPR01MB47737A11F8BFCC856C4A62DCBA859@OSBPR01MB4773.jpnprd01.prod.outlook.com>
In-Reply-To: <OSBPR01MB47737A11F8BFCC856C4A62DCBA859@OSBPR01MB4773.jpnprd01.prod.outlook.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 18 Feb 2021 11:50:43 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3LrkAE9MuMkwMpJ6_5ZYM3m_S-0v7V7qrpY6JaAzHUTQ@mail.gmail.com>
Message-ID: <CAK8P3a3LrkAE9MuMkwMpJ6_5ZYM3m_S-0v7V7qrpY6JaAzHUTQ@mail.gmail.com>
Subject: Re: [PATCH net-next] misc: Add Renesas Synchronization Management
 Unit (SMU) support
To:     Min Li <min.li.xe@renesas.com>
Cc:     Derek Kiernan <derek.kiernan@xilinx.com>,
        Dragan Cvetic <dragan.cvetic@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>,
        gregkh <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 4:28 AM Min Li <min.li.xe@renesas.com> wrote:
> > If the driver can use the same algorithm that is in your user space software
> > today, that would seem to be a nicer way to handle it than requiring a
> > separate application.
> >
>
> Hi Arnd
>
>
> What is the device driver that you are referring here?
>
> In summary of your reviews, are you suggesting me to discard this change
> and go back to PTP subsystem to find a better place for things that I wanna
> do here?

Yes, I mean doing it all in the PTP driver.

        Arnd
