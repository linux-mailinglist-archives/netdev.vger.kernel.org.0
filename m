Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97222437FA4
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 22:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234591AbhJVUyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 16:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234641AbhJVUx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 16:53:56 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB953C061235
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 13:50:29 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id ec8so6176934edb.6
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 13:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+d2CaObfBOm0DEZI7LFevuwT2A85c2k11FF9kn6JOB4=;
        b=YyRhU71WmQxT9yhXnH/BycWfW4ZcwavhNIblfAUNimIkHUArxo6TnChijCPBYgwgdy
         KnaHYQ5g1mm4U8IHq74tggdiXuR0DtQmYswL/UmOesr0ZqUt4wIRnyf5JNMt5cQDPikD
         l/NHDJ0Pqy0FLb2opTFaktCSt5pSGlNd8SIZlHr7VCauV/S3vs4AqeV6AofCWtHuhzLI
         WsoM8ZQqRRjaIelcfjJBQmIbHdXcoPTytuKQkVENehqAJNou9cLKIXj/EtPUbbnfqgSb
         mHK2fn+cdMi6gE1Op2ZiXunqto+fCQE14a+DlfvboI+cWZG1vr/iImRTqlwFB6mVHXSD
         a8WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+d2CaObfBOm0DEZI7LFevuwT2A85c2k11FF9kn6JOB4=;
        b=GE/XKhxiwjFpENkJrh0RMsF608lstPPG3hXv1yKzEBdz5HAhqxWggUBvl9qdf4GlIt
         lfRGsM/iTn+D0c/Ko1vtLhjBRoCA6BjjzVxreQn4UkPfwrpyIIdi3mWj0bVSQY47VNPP
         HWhJMa6BX/Ju0DsUC2bpn5T2KPycWjICH1dUVSiR/rLrEJYfjSL1OUjbfgQ2vo0D8Hdo
         ERxFWUCoyzzS4sF+IW3CZHpBj/K8GQuReq74Qo+z/mUU5hgRmR4Jir26I4E0TaKG1WiQ
         GoDsFcEGLYTIJQZSaEJDwKEsjAF8HE1SA1gJW/JjV0AZvWV7LGRWOTlf6Hyj21Bljd1n
         fAZg==
X-Gm-Message-State: AOAM532hntPPbr1sMpp+nOvA8475+m/I3iON715KV1aQEBokkVjRDnVn
        Y2q14snKEDIQg59LKl8ZfZo=
X-Google-Smtp-Source: ABdhPJx7fPBpcjeVZiEuAx3qGH67vbXL3inDzeEG62c1Vw/egdZ/M+j9IK2v257+D+IW/kN1OSq+7w==
X-Received: by 2002:a50:da48:: with SMTP id a8mr3023938edk.146.1634935828475;
        Fri, 22 Oct 2021 13:50:28 -0700 (PDT)
Received: from skbuf ([188.25.174.251])
        by smtp.gmail.com with ESMTPSA id h18sm4195251ejt.29.2021.10.22.13.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 13:50:28 -0700 (PDT)
Date:   Fri, 22 Oct 2021 23:50:26 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: Re: [PATCH v3 net-next 3/9] net: mscc: ocelot: serialize access to
 the MAC table
Message-ID: <20211022205026.r3gsuzlkkw34qywl@skbuf>
References: <20211022172728.2379321-1-vladimir.oltean@nxp.com>
 <20211022172728.2379321-4-vladimir.oltean@nxp.com>
 <9628072d-612a-ec6f-ce18-03c7f95ad5dd@gmail.com>
 <20211022180052.5dqafsdv7sa2bckw@skbuf>
 <YXMLT4McTTuCb098@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXMLT4McTTuCb098@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 09:04:47PM +0200, Andrew Lunn wrote:
> On Fri, Oct 22, 2021 at 09:00:52PM +0300, Vladimir Oltean wrote:
> > On Fri, Oct 22, 2021 at 10:34:04AM -0700, Florian Fainelli wrote:
> > > On 10/22/21 10:27 AM, Vladimir Oltean wrote:
> > > > DSA would like to remove the rtnl_lock from its
> > > > SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE handlers, and the felix driver uses
> > > > the same MAC table functions as ocelot.
> > > > 
> > > > This means that the MAC table functions will no longer be implicitly
> > > > serialized with respect to each other by the rtnl_mutex, we need to add
> > > > a dedicated lock in ocelot for the non-atomic operations of selecting a
> > > > MAC table row, reading/writing what we want and polling for completion.
> > > > 
> > > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > > ---
> > > >  drivers/net/ethernet/mscc/ocelot.c | 53 +++++++++++++++++++++++-------
> > > >  include/soc/mscc/ocelot.h          |  3 ++
> > > >  2 files changed, 44 insertions(+), 12 deletions(-)
> > > > 
> > > > diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> > > > index 4e5ae687d2e2..72925529b27c 100644
> > > > --- a/drivers/net/ethernet/mscc/ocelot.c
> > > > +++ b/drivers/net/ethernet/mscc/ocelot.c
> > > > @@ -20,11 +20,13 @@ struct ocelot_mact_entry {
> > > >  	enum macaccess_entry_type type;
> > > >  };
> > > >  
> > > > +/* Must be called with &ocelot->mact_lock held */
> > > 
> > > I don't know if the sparse annotations: __must_hold() would work here,
> > > but if they do, they serve as both comment and static verification,
> > > might as well use them?
> > 
> > I've never come across that annotation before, thanks.
> > I'll fix this and the other issue and resend once the build tests for
> > this series finish.
> 
> If sparse cannot figure it out, mv88e6xxx has:
> 
> static void assert_reg_lock(struct mv88e6xxx_chip *chip)
> {
>         if (unlikely(!mutex_is_locked(&chip->reg_lock))) {
>                 dev_err(chip->dev, "Switch registers lock not held!\n");
>                 dump_stack();
>         }
> }
> 
> which is a bit heavier in weight, but the MDIO bus transaction will
> dominate the time for such operations, not checking a mutex.

Yes, and then there's also lockdep_assert_held. I knew about those.

Truth be told, I thought sparse would be smarter. But I tested with this
program:

#include <stdio.h>

# define __must_hold(x)	__attribute__((context(x,1,1)))
# define __acquires(x)	__attribute__((context(x,0,1)))
# define __releases(x)	__attribute__((context(x,1,0)))
# define __acquire(x)	__context__(x,1)
# define __release(x)	__context__(x,-1)

static void __acquires(a) lock(int a)
{
	__acquire(a);
}

static void __releases(a) unlock(int a)
{
	__release(a);
}

static void __must_hold(a) fn(int a)
{
	printf("%s: %d\n", __func__, a);
}

int main(int argc, char **argv)
{
	int a = 0;

	unlock(a);
	fn(a);
	lock(a);

	return 0;
}

and it doesn't see any problem whatsoever. It's only good to detect
context imbalances that aren't annotated.

Then I noticed Johannes Berg's sparse commit 2479d0f7819b ("Revert the
context tracking code"), and this discussion:
https://www.spinics.net/lists/linux-sparse/msg03934.html

so.... yeah. It's just about as useful as a very pretentious comment.

I don't know, I can send another version that replaces the __must_hold
with something else, but I'd rather not sprinkle around lockdep_assert_held()
calls the same I did with a static analyzer attribute like it's nothing...
