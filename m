Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D0332513A
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 15:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbhBYOGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 09:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbhBYOG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 09:06:28 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92ECFC061574;
        Thu, 25 Feb 2021 06:05:46 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id q9so5022839ilo.1;
        Thu, 25 Feb 2021 06:05:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HNl+j7XzE9le/Y31giKwsRpFTGZ7bjJThJ0wX9igwH8=;
        b=baHr+Xh3tv9Bdb+XoKmQUT9GL9l7XRNx9hYgZ7qLwYG1/GEO48svlhtydDF/9BcBGo
         GgzM9davIc4/iApPPohit9eW5KwggmmrksyqK7+TXOkIq+6p2vaa3RCOcZ5nKhWkmF6g
         T67x5PN2ySCLhGivJOxiRifenWB3VQ8NkpYWvfWtDrlwFCEdTNzc8rknvA4bCOY75oIQ
         8p0u/rlwmEZXpwmgO30KJtuJXWIzp49kn2+LtR4a4ko+u12GDVPvD2Tfmyx3+5Wi/X5b
         2b1ZAkLFS3KLXgMCYKBEHAnQB+QoS2bx0LKfAatFMsrltWZFnTGHBDwCjF3QB5SiYcdG
         Uajg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HNl+j7XzE9le/Y31giKwsRpFTGZ7bjJThJ0wX9igwH8=;
        b=lJJEbbAC+asTjN9wjXviqQbNsF3XR5MTUGr9PLeung15XzwADViURNsvICci2MYcRn
         PkgfkytPGtpj4IPXGCCALXhxiDOYdRUuU3YaPP1rvTmQk9xmZDyqpOHo7HpjjTWg/+4b
         NXpI8X+L5fxFEzUGkjNPfrsHAMqacouPF+pmV+H6IYn/kpHU1RLeksAlfVhvd2SlcyAJ
         dJ4mkUioO/WZhznaNUAhZATvMHoyOZE+CgRwIPmJrhbk1hWOhkjWGmI85vjfHjkj27+c
         lcQdoKb9e3xeTtUZfrJbNZtU5AVYTLNOML3HU7XIYwNLPyikQe9YVHwUd/GAi4Se/O+8
         ZpdA==
X-Gm-Message-State: AOAM532awyppG4sAUByG0vKXvwmxZuMBRGIWkG0Dy/gnyEua0FJd8bWm
        wHbDALXrbRJ0ColVH031ZBjxmYaikET92lfRv57+2jQHfzYys4nM
X-Google-Smtp-Source: ABdhPJz0P18YYZxzzf7UIrdHDGO788LiCP1JN3bOCD2fP/I5ywm2cOAKId/FNlzRb02eOEioa7cSvTKeVlT1Sio3m+k=
X-Received: by 2002:a92:d201:: with SMTP id y1mr2733142ily.129.1614261945979;
 Thu, 25 Feb 2021 06:05:45 -0800 (PST)
MIME-Version: 1.0
References: <20210220065654.25598-1-heiko.thiery@gmail.com>
 <20210222190051.40fdc3e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEyMn7ZM7_pPor0S=dMGbmnp0hmZMrpquGqq4VNu-ixSPp+0UQ@mail.gmail.com>
 <20210223142726.GA4711@hoboy.vegasvil.org> <CAEyMn7Za9z9TUdhb8egf8mOFJyA3hgqX5fwLED8HDKw8Smyocg@mail.gmail.com>
 <20210223161136.GA5894@hoboy.vegasvil.org> <CAEyMn7YwvZD6T=oHp2AcmsA+R6Ho2SCYYkt2NcK8hZNUT7_TSQ@mail.gmail.com>
In-Reply-To: <CAEyMn7YwvZD6T=oHp2AcmsA+R6Ho2SCYYkt2NcK8hZNUT7_TSQ@mail.gmail.com>
From:   Heiko Thiery <heiko.thiery@gmail.com>
Date:   Thu, 25 Feb 2021 15:05:32 +0100
Message-ID: <CAEyMn7Yjug3S=2mRC8uA=_+Tdxe=m6G-ga1YuupLSx3mPqUoug@mail.gmail.com>
Subject: Re: [PATCH 1/1] net: fec: ptp: avoid register access when ipg clock
 is disabled
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Fugang Duan <fugang.duan@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

Am Do., 25. Feb. 2021 um 14:49 Uhr schrieb Heiko Thiery
<heiko.thiery@gmail.com>:
>
> Hi Richard,
>
> Am Di., 23. Feb. 2021 um 17:11 Uhr schrieb Richard Cochran
> <richardcochran@gmail.com>:
> >
> > On Tue, Feb 23, 2021 at 04:04:16PM +0100, Heiko Thiery wrote:
> > > It is not only the PHC clock that stops. Rather, it is the entire
> > > ethernet building block in the SOC that is disabled, including the
> > > PHC.
> >
> > Sure, but why does the driver do that?
>
> That is a good question. I tried to understand the clock
> infrastructure of the imx8 but it looks quite complicated. I cannot
> find the point where all the stuff is disabled.

But the explanation why it is currently disabled that way can be found
in the commit 91c0d987a9788dcc5fe26baafd73bf9242b68900.

-- 
Heiko
