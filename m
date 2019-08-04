Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A645780A6C
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 12:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbfHDKWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 06:22:02 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:44287 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbfHDKWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 06:22:01 -0400
Received: by mail-yb1-f194.google.com with SMTP id a14so28285141ybm.11
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 03:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vLfPtMCfmI7WjljqqDP4X8UfYsevSxRLagUmqAWHWtI=;
        b=DVt8ZcgBNHusmd+KtkvN9VmGF+BKXkymyMK1M3BHYHHhD1h6IPsYMKesJU3q31bDp5
         aHrDNLbUYRpzqLAL4jsVt9BYIUmYnsUVlfDNFXsv51IGSBlQJOHhq1RPF2BzIGbSLosO
         PVPHWFi8QijwFIj6ScL9m6ZkEnhDlt+6J23OAXg1h3eu2AQyUnwmjDqg4MGzijp0dVjP
         zhIAIxeyJaP7SFxpNl+PsWNQINe983w5YHoIhSt64i6chqNSPy3SRHNsRK3dPtQPhJA3
         h+MOCLcNhvgU7czFbY5+sSjsGUPh9gf9+oo1k2ae3hksonhScaOYj3xWk3+7x1RFhBL4
         B6sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vLfPtMCfmI7WjljqqDP4X8UfYsevSxRLagUmqAWHWtI=;
        b=F/cRrEsPKHIbgORc5aKCL1sZMkO4fvRv7uJczzTpm3wLafJd+beAcIYHK5QM43Ttob
         jV+s5uzHhtSYswc3sAqojNvh8gOigQN2vhkep1MHOK+l2kEkyUWHGz3I9u+UwNwMXNeY
         wynX1qfMoJPfeWK/EyvT9jtKCHOick9AwopekGZR7/3MDI/alxc9WAaFoRwSuLmpxYf1
         B91wbllnRpOP9W7asxMn91VblXFcGd7c4/PrBYuRhE3L8aBSUAtrXO+QyBOVfe5aR3bE
         /Nhb39Dll2B6ZZ2K0soyYD/N4UnaAWcUdCqVM9VJcqL4JgD6NcG2/8YSjGYrsZ8AAVSn
         XRMQ==
X-Gm-Message-State: APjAAAUoCeaZTRR2vDuTl1wIy5wmXCObDVg7teBf7yTS+3lDGdTa/aGx
        NCk2jvUzB6VcZQYmFxqwLH30aDuxmsfUW5Pi70I=
X-Google-Smtp-Source: APXvYqypeywuY+j8xzIFz/D0io3lAU+3NszwbKw3sUDeWGASqTF2JJIA0DDDC0IHv3aQSYN8CCTjA0M+qfLXv60tieU=
X-Received: by 2002:a25:7909:: with SMTP id u9mr63996223ybc.177.1564914120815;
 Sun, 04 Aug 2019 03:22:00 -0700 (PDT)
MIME-Version: 1.0
References: <1558140881-91716-1-git-send-email-xiangxia.m.yue@gmail.com>
 <CAJ3xEMhAEMBBW=s_iWA=qD23w8q4PWzWT-QowGBNtCJJzHUysA@mail.gmail.com>
 <CAMDZJNV6S5Wk5jsS5DiHMYGywU2df0Lyey9QYzcdwGZDJbjSeg@mail.gmail.com>
 <CAJ3xEMgc6j=+AxRUwdYOT6_cP69fY-ThVVbF+4EqtZGQ+-Sjnw@mail.gmail.com>
 <CAMDZJNU=8BHZJs95knTzuCv=7X3BXbqHrZAznOOcK2m_7QO2Pw@mail.gmail.com>
 <CAJ3xEMj43wFacxR1bfqG8B0yVPiPyCh=DT5S3TojV8S8ZHaDsA@mail.gmail.com> <CAMDZJNWZ=s-yf7vho0zHySD01uOZzbUdcFmgu+Rk=p-nRoHN=A@mail.gmail.com>
In-Reply-To: <CAMDZJNWZ=s-yf7vho0zHySD01uOZzbUdcFmgu+Rk=p-nRoHN=A@mail.gmail.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Sun, 4 Aug 2019 13:21:49 +0300
Message-ID: <CAJ3xEMibW4RZhB7WyQfiiqPjDZoCQMn4iY68rCGx2KtjUO0XMQ@mail.gmail.com>
Subject: Re: [PATCH] net/mlx5e: Allow removing representors netdev to other namespace
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 1, 2019 at 3:44 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> On Wed, May 22, 2019 at 12:49 PM Or Gerlitz <gerlitz.or@gmail.com> wrote:
> > On Wed, May 22, 2019 at 4:26 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:

> > > I review the reps of netronome nfp codes,  nfp does't set the
> > > NETIF_F_NETNS_LOCAL to netdev->features.
> > > And I changed the OFED codes which used for our product environment,
> > > and then send this patch to upstream.

> > The real question here is if we can provide the required separation when
> > vport rep netdevs are put into different name-spaces -- this needs deeper
> > thinking. Technically you can do that with this one liner patch but we have
> > to see if/what assumptions could be broken as of that.

> Can we add a mode parm for allowing user to switch it off/on ?

The kernel model for namespace means a completely new copy of the
networking stack
with new routing tables, new neighbour tables. everything. It also
means netdevices in
different namespaces can't communicate with each other. I tend to
think that our FW/HW
model doesn't support that and hence we can't do proper offloading of
the SW model.

I suggest you approach the current maintainers (Roi and Saeed) to see
if they have different opinion.

Or.
