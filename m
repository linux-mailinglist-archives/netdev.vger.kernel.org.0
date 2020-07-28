Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2F5230B67
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 15:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730112AbgG1NY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 09:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729984AbgG1NY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 09:24:57 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A584FC061794;
        Tue, 28 Jul 2020 06:24:57 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id o1so9902053plk.1;
        Tue, 28 Jul 2020 06:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ANecPKxc0/I+j4txAHsemmobB7jeFpVIkoQwGkyZTmY=;
        b=UwcoIU469IpINOG9wZJAPb1PTIjLewpQ2ZLHrZHeuCWIKYFT0vMeZj5rUfWPOuc7jq
         yRdd5f3IDUlONxlXQ7C8yt7foMQuSa1cg71UWkLpd5qDY6qNB7BpP8XigiHPaIS0bU3q
         nNw9a9wOCSc0vNxVanJQxQwEBRg4foBZKmNeynEM3uzG+0Xz05JCpx7Ez06ILw7ZMvlH
         V0GfFTIbNVCMhZwF6BV+VduLqgGb5jqzSp4bCX7pKl8pNY2yqWs+B32jh0+fQBbsyks1
         LFaHA3a4ckhvOdHtksqG8ZUO4j8n7eMTPrCnnUcIGRBSg61MxgWR5wImco1QGLMKRLNu
         G8nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ANecPKxc0/I+j4txAHsemmobB7jeFpVIkoQwGkyZTmY=;
        b=taJWlDAf1Z8OeV7gPg/6Ot7+g9uezFVeixz67Ljnoo3qyT8ACg2evsOAODrFU3XuNr
         Yu5W1bkDs72SMOPISEc7XCE/HyFZRKVd3+2w9dY1h9i+qvby/qZwl9lkVW+u4IyW3x71
         Fqkmh3frdF7Kr/Nvu78fHv+58X+Vvi9P3kqBPwUp3cBtGWIi+HEv7pJCztSd1yiavEeh
         Mpl/DXripZwLx/RFERWW8WwQmV/B34Z1W6vT/l8JNRdA49inGflqz2f+TF6x94gF6cbi
         FU1UHGP9NTQ6QrElMy7EG8MugZapm0h0dD2E/as5198hJTo8Sd2KbQr5wG9WatvKrnX1
         BNfQ==
X-Gm-Message-State: AOAM5306zixDNRLjFjxQxxJOuUVCBWla/DT5tFZP2i3AYxOo548VG2rv
        5DGfZuzbg2M2DAnN9Kt7av65ZTPDLhROO11e7xc=
X-Google-Smtp-Source: ABdhPJwP58Tnr1enZMkfGQ3iNYRNFO6xyw9fYrTI8eLb2r/Gdj6R4MRJD24NfG0JaD+t7gsuCNbamlg4wYckrgsN0X0=
X-Received: by 2002:a17:902:4b:: with SMTP id 69mr7494548pla.18.1595942697197;
 Tue, 28 Jul 2020 06:24:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200727122242.32337-1-vadym.kochan@plvision.eu>
 <20200727122242.32337-4-vadym.kochan@plvision.eu> <CAHp75Vcaa0-s6FEUw0YqoEDi=uVRcJiDvwA+ye4cNxwkK6eb+g@mail.gmail.com>
 <20200728123006.GA10391@plvision.eu>
In-Reply-To: <20200728123006.GA10391@plvision.eu>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 28 Jul 2020 16:24:42 +0300
Message-ID: <CAHp75VcdpwqpRqm99aHivTkEsxF6-4SENVz09oV=JJTjh8eyVA@mail.gmail.com>
Subject: Re: [net-next v4 3/6] net: marvell: prestera: Add basic devlink support
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mickey Rachamim <mickeyr@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 3:30 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:
> On Mon, Jul 27, 2020 at 04:07:07PM +0300, Andy Shevchenko wrote:
> > On Mon, Jul 27, 2020 at 3:23 PM Vadym Kochan <vadym.kochan@plvision.eu> wrote:

...

> > > +       err = devlink_register(dl, sw->dev->dev);
> > > +       if (err) {
> > > +               dev_warn(sw->dev->dev, "devlink_register failed: %d\n", err);
> > > +               return err;
> > > +       }
> > > +
> > > +       return 0;
> >
> >   if (err)
> >     dev_warn(...);
> >
> >   return err;
> Would not it better to have 'return 0' at the end to visually indicate
> the success point ?

Up to you. Actually just noticed that you are using dev_warn() for
error. It should be dev_err().

-- 
With Best Regards,
Andy Shevchenko
