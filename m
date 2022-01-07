Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA61486F70
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 02:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345062AbiAGBJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 20:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345068AbiAGBJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 20:09:40 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6F6C061245;
        Thu,  6 Jan 2022 17:09:39 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id t28so1300339wrb.4;
        Thu, 06 Jan 2022 17:09:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8LHh10+xJEwQQJ1HEF7ipZJtQ43xHxuWPeAK1P7zvbk=;
        b=JN1SD8KccynWq4OVrbYAy+R3lCUUI/juBe+hFVtkqWrmpI5vKsSNZabvdiYscWZCF1
         vAGkkFI2vQ6fit6S8Gnaimll1ZFqGANhhGYdNUnll7YgW4mHX0OHNmTtnebQeKdN9bIb
         C6O5fjNVpKOMVULJNeYauUc9INnAoF9jRW5PHiln3smJXTYuAaL16E0yWW0IDXaXvGjJ
         dhWYZMrZUmB+8qbLOnviUaBa71PHF2uU26JZ8uUl1uVbjWneAULd1SfRrXB/CizUfT4z
         +hCNh5S5MCwuGr0RZ2wH8oPJn6OopwEwawjMNOt4uCOEn8gBnNO9UFakeZQZap/4+Lnc
         muug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8LHh10+xJEwQQJ1HEF7ipZJtQ43xHxuWPeAK1P7zvbk=;
        b=fGvSZ2IYKg0FR2SmDvBH05tCEjyN1La80I5FI6X6CTBBqvjV7Y5NMONhCMeta/MN9U
         HUho+vPztdL+4065IjaeG089ZNp9ofutuOXBrDQBlih+UiiDgZd+BZqE+GBNcG7Owr/J
         3HSFfjgFQ+pY6rraT3/nB+96zQF+2WyZB5Dwjm1ZrrK1PlacEvZjPFn6ARQct/igAsy0
         NO5r+pz6aWIOLvHeXN0Y6mbjiAXae/c4D3E1WnEmfWW0P+/fVU4CiXi0kXAkoWeX0tqG
         yVuDtB22Fg33bNGPV6Zy8ITHdGY3kgk70FXdHHL2dufcLGoKHMjobAQzGWM1QzhDnnbX
         UF2Q==
X-Gm-Message-State: AOAM531sCvZUvjOvy/0zVOlaUwm5kukYiH4HHyx0QPXW36aBapgaJRl9
        ciDo1q93iHwvB6eesHrWJiyNWub07j7/jtYt2Ps=
X-Google-Smtp-Source: ABdhPJx4PVmGgpPehu0uD1OCS9wBsXyBQzRPXWGgG1zXN+7yaEwK36YYSylNoOnca5o02K8Zg354zCS6ESvwZ5zo/EY=
X-Received: by 2002:a05:6000:186e:: with SMTP id d14mr54460304wri.205.1641517778464;
 Thu, 06 Jan 2022 17:09:38 -0800 (PST)
MIME-Version: 1.0
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
 <20211222155743.256280-13-miquel.raynal@bootlin.com> <CAB_54W6AZ+LGTcFsQjNx7uq=+R5v_kdF0Xm5kwWQ8ONtfOrmAw@mail.gmail.com>
 <Ycx0mwQcFsmVqWVH@ni.fr.eu.org> <CAB_54W41ZEoXzoD2_wadfMTY8anv9D9e2T5wRckdXjs7jKTTCA@mail.gmail.com>
 <CAB_54W6gHE1S9Q+-SVbrnAWPxBxnvf54XVTCmddtj8g-bZzMRA@mail.gmail.com>
 <20220104191802.2323e44a@xps13> <CAB_54W5quZz8rVrbdx+cotTRZZpJ4ouRDZkxeW6S1L775Si=cw@mail.gmail.com>
 <20220105215551.1693eba4@xps13> <CAB_54W7zDXfybMZZo8QPwRCxX8-BbkQdznwEkLEWeW+E3k2dNg@mail.gmail.com>
 <20220106170019.730f45e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220106170019.730f45e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Thu, 6 Jan 2022 20:09:27 -0500
Message-ID: <CAB_54W5B5QYu=5PSO=_NVndgnXsE_hHyVKf1Y69n_oZpoEP48A@mail.gmail.com>
Subject: Re: [net-next 12/18] net: mac802154: Handle scan requests
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, 6 Jan 2022 at 20:00, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 5 Jan 2022 19:38:12 -0500 Alexander Aring wrote:
> > > Also, just for the record,
> > > - should I keep copying the netdev list for v2?
> >
> > yes, why not.
>
> On the question of lists copied it may make sense to CC linux-wireless@
> in case they have some precedent to share, and drop linux-kernel@.

Yes, that makes sense.

- Alex
