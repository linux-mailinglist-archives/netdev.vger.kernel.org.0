Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7636B14EF32
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 16:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729265AbgAaPJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 10:09:38 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43940 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729099AbgAaPJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 10:09:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580483376;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DaMzG7j5hfavsM/tX6p+KhaqCTHy5nE6qpG+pzfaT80=;
        b=GdRURIDxP4YiU/xSfXbwJbYiKRn0itvj8nsP3KHKIqE3yeIiUF/xjPDw3Plx9vqYgmhL3H
        jUYYMtc/e2/icX4ttU8J2VfOewqmA5OQYB6dIIXLdCJ1FnXw2sb5wXzeP6tsBt9kWcv+bj
        PprYW6cjT7z3Ys4Tjq0GK32fL0ARRxQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-a_FY67wiNE6ZaSZqGvdMhQ-1; Fri, 31 Jan 2020 10:09:34 -0500
X-MC-Unique: a_FY67wiNE6ZaSZqGvdMhQ-1
Received: by mail-wr1-f69.google.com with SMTP id z15so3521036wrw.0
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 07:09:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:reply-to:to:cc:date
         :in-reply-to:references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=DaMzG7j5hfavsM/tX6p+KhaqCTHy5nE6qpG+pzfaT80=;
        b=QvTZ5p2a24gTxt7hA2bOVXmeavbGZyFmAKn9TBly4FXfDw1Pm0unyPs0tMKXawh3Ce
         skET8CUj0a7OJLEbjkGzxsSnW3WLmI78Tzik/WPMNF1Fxe33526sRAIM5gIAoxvnMeYO
         vavnAhZ+KEk6Pv5EZpD+RTJX4mv5t3lI4NznD+L7WVzI2xuh2EGNc2XZQa8VCN0PfHJe
         kv9xgxFOCDUp/L9sm2WYzh91p+GAG06iExmBrKtgqONIu4mVckPUz4vbZLn8TefuHDG9
         wpr+diiF4NYiCQFizTtrSibp0L/WVTsBWrKb1s7cQXA1Mti5jKCxFZh1ijC9qqh/QfCP
         yN9A==
X-Gm-Message-State: APjAAAVzVPKrwR1EpTLjgrHooiEOsoaxRpw7CC1TOpnrKVkLevEneWvJ
        05XrJn20D0VIXjO0VwGT8Yh/RKUOd0pBCarA0jmFjMXsZAD826QcpsWt95SF36vVO6YTzXUUFLb
        7RmV595Mbe5cu1aQp
X-Received: by 2002:a05:6000:1201:: with SMTP id e1mr6885472wrx.386.1580483373410;
        Fri, 31 Jan 2020 07:09:33 -0800 (PST)
X-Google-Smtp-Source: APXvYqxFiXQ6KIz5mbcCS+r7PfK9URqBPG0wJRaLorpGi9uV7v/ivo0ecmDCFWE5XZXnQmkJr3cFbQ==
X-Received: by 2002:a05:6000:1201:: with SMTP id e1mr6885435wrx.386.1580483372975;
        Fri, 31 Jan 2020 07:09:32 -0800 (PST)
Received: from [192.168.2.3] (ip4-46-175-179-179.net.iconn.cz. [46.175.179.179])
        by smtp.gmail.com with ESMTPSA id a1sm12153345wrr.80.2020.01.31.07.09.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 07:09:32 -0800 (PST)
Message-ID: <7d2c26ac18d0ce7b76024fec86a9b1a084ad3fd3.camel@redhat.com>
Subject: Re: [PATCH net v2] phy: avoid unnecessary link-up delay in polling
 mode
From:   Petr Oros <poros@redhat.com>
Reply-To: poros@redhat.com
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        ivecera@redhat.com
Date:   Fri, 31 Jan 2020 16:09:31 +0100
In-Reply-To: <69228855-7551-fc3c-06c5-2c1d9d20fe0c@gmail.com>
References: <20200129101308.74185-1-poros@redhat.com>
         <20200129121955.168731-1-poros@redhat.com>
         <69228855-7551-fc3c-06c5-2c1d9d20fe0c@gmail.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heiner Kallweit píše v St 29. 01. 2020 v 22:01 +0100:
> On 29.01.2020 13:19, Petr Oros wrote:
> > commit 93c0970493c71f ("net: phy: consider latched link-down status in
> > polling mode") removed double-read of latched link-state register for
> > polling mode from genphy_update_link(). This added extra ~1s delay into
> > sequence link down->up.
> > Following scenario:
> >  - After boot link goes up
> >  - phy_start() is called triggering an aneg restart, hence link goes
> >    down and link-down info is latched.
> >  - After aneg has finished link goes up. In phy_state_machine is checked
> >    link state but it is latched "link is down". The state machine is
> >    scheduled after one second and there is detected "link is up". This
> >    extra delay can be avoided when we keep link-state register double read
> >    in case when link was down previously.
> > 
> > With this solution we don't miss a link-down event in polling mode and
> > link-up is faster.
> > 
> 
> I have a little problem to understand why it should be faster this way.
> Let's take an example: aneg takes 3.5s
> Current behavior:
> 
> T0: aneg is started, link goes down, link-down status is latched
>     (phydev->link is still 1)
> T0+1s: state machine runs, latched link-down is read,
>        phydev->link goes down, state change PHY_UP to PHY_NOLINK
> T0+2s: state machine runs, up-to-date link-down is read
> T0+3s: state machine runs, up-to-date link-down is read
> T0+4s: state machine runs, aneg is finished, up-to-date link-up is read,
>        phydev->link goes up, state change PHY_NOLINK to PHY_RUNNING
> 
> Your patch changes the behavior of T0+1s only. So it should make a
> difference only if aneg takes less than 1s.
> Can you explain, based on the given example, how your change is
> supposed to improve this?
> 


I see this behavior on real hw:
With patch:
T0+3s: state machine runs, up-to-date link-down is read
T0+4s: state machine runs, aneg is finished (BMSR_ANEGCOMPLETE==1),
       first BMSR read: BMSR_ANEGCOMPLETE==1 and BMSR_LSTATUS==0,
       second BMSR read: BMSR_ANEGCOMPLETE==1 and BMSR_LSTATUS==1,
       phydev->link goes up, state change PHY_NOLINK to PHY_RUNNING

line: 1917 is first BMSR read
line: 1921 is second BMSR read

[   24.124572] xgene-mii-rgmii:03: genphy_restart_aneg()
[   24.132000] xgene-mii-rgmii:03: genphy_update_link(), line: 1895, link: 0
[   24.139347] xgene-mii-rgmii:03: genphy_update_link(), line: 1917, status:
0x7949
[   24.146783] xgene-mii-rgmii:03: genphy_update_link(), line: 1921, status:
0x7949
[   24.154174] xgene-mii-rgmii:03: genphy_update_link(), line: 1927, link: 0

. supressed 3 same messages in T0+1,2,3s

[   28.609822] xgene-mii-rgmii:03: genphy_update_link(), line: 1895, link: 0
[   28.629906] xgene-mii-rgmii:03: genphy_update_link(), line: 1917, status:
0x7969
^^^^^^^^^^^^^^^ detected BMSR_ANEGCOMPLETE but not BMSR_LSTATUS
[   28.644590] xgene-mii-rgmii:03: genphy_update_link(), line: 1921, status:
0x796d
^^^^^^^^^^^^^^^ here is detected BMSR_ANEGCOMPLETE and BMSR_LSTATUS
[   28.658681] xgene-mii-rgmii:03: genphy_update_link(), line: 1927, link: 1

--------------------------------------------------------------------------------
---

Without patch:
T0+3s: state machine runs, up-to-date link-down is read
T0+4s: state machine runs, aneg is finished (BMSR_ANEGCOMPLETE==1),
       here i read link-down (BMSR_LSTATUS==0),
T0+5s: state machine runs, aneg is finished (BMSR_ANEGCOMPLETE==1),
       up-to-date link-up is read (BMSR_LSTATUS==1),
       phydev->link goes up, state change PHY_NOLINK to PHY_RUNNING

line: 1917 is first BMSR read (status is zero because without patch it is readed
once)
line: 1921 is second BMSR read

[   24.862702] xgene-mii-rgmii:03: 1768: genphy_restart_aneg
[   24.869070] xgene-mii-rgmii:03: genphy_update_link(), line: 1895, link: 0
[   24.876409] xgene-mii-rgmii:03: genphy_update_link(), line: 1917, status: 0x0
[   24.885999] xgene-mii-rgmii:03: genphy_update_link(), line: 1921, status:
0x7949
[   24.893401] xgene-mii-rgmii:03: genphy_update_link(), line: 1927, link: 0

. supressed 3 same messages in T0+1,2,3s

[   29.319613] xgene-mii-rgmii:03: genphy_update_link(), line: 1895, link: 0
[   29.326408] xgene-mii-rgmii:03: genphy_update_link(), line: 1917, status: 0x0
[   29.333557] xgene-mii-rgmii:03: genphy_update_link(), line: 1921, status:
0x7969
^^^^^^^^^^^^^^^ detected BMSR_ANEGCOMPLETE but not BMSR_LSTATUS
[   29.340923] xgene-mii-rgmii:03: genphy_update_link(), line: 1927, link: 0

[   30.359713] xgene-mii-rgmii:03: genphy_update_link(), line: 1895, link: 0
[   30.366507] xgene-mii-rgmii:03: genphy_update_link(), line: 1917, status: 0x0
[   30.373650] xgene-mii-rgmii:03: genphy_update_link(), line: 1921, status:
0x796d
^^^^^^^^^^^^^^^ here is detected BMSR_ANEGCOMPLETE and BMSR_LSTATUS
[   30.381016] xgene-mii-rgmii:03: genphy_update_link(), line: 1927, link: 1

I tried many variants and it is deterministic behavior. Without patch is delay
one second longer due to later detect link up after aneg finish

-Petr


> And on a side note: I wouldn't consider this change a fix, therefore
> it would be material for net-next that is closed at the moment.
> 
> Heiner
> 
> > Changes in v2:
> > - Fixed typos in phy_polling_mode() argument
> > 
> > Fixes: 93c0970493c71f ("net: phy: consider latched link-down status in polling mode")
> > Signed-off-by: Petr Oros <poros@redhat.com>
> > ---
> >  drivers/net/phy/phy-c45.c    | 5 +++--
> >  drivers/net/phy/phy_device.c | 5 +++--
> >  2 files changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
> > index a1caeee1223617..bceb0dcdecbd61 100644
> > --- a/drivers/net/phy/phy-c45.c
> > +++ b/drivers/net/phy/phy-c45.c
> > @@ -239,9 +239,10 @@ int genphy_c45_read_link(struct phy_device *phydev)
> >  
> >  		/* The link state is latched low so that momentary link
> >  		 * drops can be detected. Do not double-read the status
> > -		 * in polling mode to detect such short link drops.
> > +		 * in polling mode to detect such short link drops except
> > +		 * the link was already down.
> >  		 */
> > -		if (!phy_polling_mode(phydev)) {
> > +		if (!phy_polling_mode(phydev) || !phydev->link) {
> >  			val = phy_read_mmd(phydev, devad, MDIO_STAT1);
> >  			if (val < 0)
> >  				return val;
> > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > index 6a5056e0ae7757..05417419c484fa 100644
> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -1930,9 +1930,10 @@ int genphy_update_link(struct phy_device *phydev)
> >  
> >  	/* The link state is latched low so that momentary link
> >  	 * drops can be detected. Do not double-read the status
> > -	 * in polling mode to detect such short link drops.
> > +	 * in polling mode to detect such short link drops except
> > +	 * the link was already down.
> >  	 */
> > -	if (!phy_polling_mode(phydev)) {
> > +	if (!phy_polling_mode(phydev) || !phydev->link) {
> >  		status = phy_read(phydev, MII_BMSR);
> >  		if (status < 0)
> >  			return status;
> > 


