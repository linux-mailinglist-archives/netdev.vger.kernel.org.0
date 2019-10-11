Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4093CD3CD2
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 11:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbfJKJzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 05:55:33 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:46431 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbfJKJzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 05:55:33 -0400
Received: by mail-ed1-f67.google.com with SMTP id t3so8109329edw.13;
        Fri, 11 Oct 2019 02:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8hoPXDC+s9C+BBsraF6QCIxAJppoYPYRK/IA+JbIMow=;
        b=SY0fhP6aBRiFpoLKFx/gUF4Tck2U3lKERej0/p3zoUbK+LpHRCPo3Lcdqx/zLNSN+y
         0gOmh+K7sQgJVzTQhk+FjRaLHQUZvIBnRq+nrgwVYMhX7p0GKzoCJ0OK1MmQmJGdo7xB
         H/bScAGmI22ClYwB+1YVfh7Ttc5v+j16GHfrtU3YXJd4hh3czmt7vXGM3S+p66n9OLoz
         rZLx9m1vuRhRpkZS3ltuM7v1jND3RbS1CQiXKcgdn8ndeyxeTwQdSjLT9Tct2VuYiKeF
         XFuqdpdyfs1/OaB6xAvKN6f3jhhgg618BTYU00PNUbbpTGyryAqHgnVBWkC9wD5ySPe+
         g+lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8hoPXDC+s9C+BBsraF6QCIxAJppoYPYRK/IA+JbIMow=;
        b=SPU0NCmcS5nZofyafKVtdBXfs8oQl68qhyzsKIhQHtpZOLfkA9oheVNvNdjCPwpDAP
         R4O6weEzgmQ6wNt/2CLbt9LV5NJytpsDDf+d7rnobUzj31ldoctMI0jPHNBSGgX5kvPw
         gud9Tnd306aX3GcR5i7Q97PAZ63cq9ykv8cf10pSZV8hgaSRGrJFLhpVyajnf2liCnxh
         MzdxyCMijV2Jpg6tNiCOFG3wauUAQRqkImDwgNiiYVhOka6Uiv5m0rMMPk5NFQwj5eqn
         6Ah8U8pflnt4eqSGy34cmh44Ra76qD/cPNa43zJTC8grFqCi7zyVkoA+KnRg2GsJqOVB
         jcyQ==
X-Gm-Message-State: APjAAAWmf0kwnx8bFtmKStOOwpNmfA07Sb67VkSEWlvA0BaMx/4s+g8O
        6OGgZHDdHJ/o9LYjYwR+UbccYgUOPW+UXm+wTwE=
X-Google-Smtp-Source: APXvYqx9eON2U3EP3MRvIxzMFOg/hA6mAs3RgdQ+yAt6YG37GmMUG4D2m4YlnAODHDYa7P9oEFvBHyq2DCCTanHMXrk=
X-Received: by 2002:a05:6402:13d6:: with SMTP id a22mr12629963edx.165.1570787731657;
 Fri, 11 Oct 2019 02:55:31 -0700 (PDT)
MIME-Version: 1.0
References: <1570616148-11571-1-git-send-email-Anson.Huang@nxp.com>
 <20191010160811.7775c819@cakuba.netronome.com> <DB3PR0402MB3916FF4583577B182D9BF60CF5970@DB3PR0402MB3916.eurprd04.prod.outlook.com>
 <20191010173246.2cd02164@cakuba.netronome.com> <DB3PR0402MB3916284A326512CE2FDF597EF5970@DB3PR0402MB3916.eurprd04.prod.outlook.com>
 <20191010175320.1fe5f6b3@cakuba.netronome.com> <DB3PR0402MB3916F0AC3E3AEC2AC1900BCCF5970@DB3PR0402MB3916.eurprd04.prod.outlook.com>
In-Reply-To: <DB3PR0402MB3916F0AC3E3AEC2AC1900BCCF5970@DB3PR0402MB3916.eurprd04.prod.outlook.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 11 Oct 2019 12:55:20 +0300
Message-ID: <CA+h21hpp5L-tcJNxXWaJaCKZyFzm-qPzUZ32LU+vKOv99PJ9ng@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: fec_main: Use platform_get_irq_byname_optional()
 to avoid error message
To:     Anson Huang <anson.huang@nxp.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andy Duan <fugang.duan@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "swboyd@chromium.org" <swboyd@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Anson,

On Fri, 11 Oct 2019 at 04:11, Anson Huang <anson.huang@nxp.com> wrote:
>
> Hi, Jakub
>
> > On Fri, 11 Oct 2019 00:38:50 +0000, Anson Huang wrote:
> > > > Hm. Looks like the commit you need is commit f1da567f1dc1 ("driver core:
> > > > platform: Add platform_get_irq_byname_optional()") and it's
> > > > currently in Greg's tree. You have to wait for that commit to make
> > > > its way into Linus'es main tree and then for Dave Miller to pull from Linus.
> > > >
> > > > I'd suggest you check if your patches builds on the net tree:
> > > >
> > > >   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
> > > >
> > > > once a week. My guess is it'll probably take two weeks or so for
> > > > Greg's patches to propagate to Dave.
> > >
> > > Thanks for explanation of how these trees work, so could you please
> > > wait the necessary patch landing on network tree then apply this patch
> > > series, thanks for help.
> >
> > Unfortunately the networking subsystem sees around a 100 patches
> > submitted each day, it'd be very hard to keep track of patches which have
> > external dependencies and when to merge them. That's why we need the
> > submitters to do this work for us and resubmit when the patch can be
> > applied cleanly.
>
> OK, I will resend this patch series once the necessary patch lands on the network
> tree.

What has not been mentioned is that you can't create future
dependencies for patches which have a Fixes: tag.

git describe --tags 7723f4c5ecdb # driver core: platform: Add an error
message to platform_get_irq*()
v5.3-rc1-13-g7723f4c5ecdb

git describe --tags f1da567f1dc # driver core: platform: Add
platform_get_irq_byname_optional()
v5.4-rc1-46-gf1da567f1dc1

So you have to consider whether the patch is really fixing anything
(it is only getting rid of a non-fatal error message).
And it's not reasonable anyway to say that you're fixing the patch
that added the error message in the generic framework.
The fallback logic has always been there in the driver. So you might
want to drop the Fixes: tag when you resend.

>
> Thanks,
> Anson

Regards,
-Vladimir
