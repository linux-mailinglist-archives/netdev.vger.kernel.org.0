Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7322CC6DE
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 20:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731219AbgLBTl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 14:41:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53501 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729160AbgLBTl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 14:41:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606938002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t4Melsy9FouRA7tpp5dgLYyf1tl5Ex/RlsncrB8JZuw=;
        b=NOxYX5LY606/6RPGpo3vATZ5JCMRyCflL3/Q3n3z1jwsUdMIq67OYSw81G7yMunTQDznu5
        V/ZaFQeFBo5qo8/asm/JKpHEA8f2zG4Ors/RbQgEzQSJPzYbJDRoCx/+Bv2SmG6UZlrggP
        cwiqNCGVALRFwbJETk+YY3UP4+j3pPU=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-WUVGb1OGOEWxGCV87VZGKQ-1; Wed, 02 Dec 2020 14:40:01 -0500
X-MC-Unique: WUVGb1OGOEWxGCV87VZGKQ-1
Received: by mail-oo1-f69.google.com with SMTP id o128so1329383ooo.11
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 11:40:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t4Melsy9FouRA7tpp5dgLYyf1tl5Ex/RlsncrB8JZuw=;
        b=BnT6EHQEe44kJYboAFP35mWWW5nHS0uaj+ulT0ttQr3U4OXW2+DvAOw9zYNMLPlB6I
         b1qZImBLaqx/shIjmPdOfUKdMXZay7k4vFvTVFTJ6WB4OBzdbs1kyJMVSgXvgcmMq2vO
         UhGgajjNjhbiVWbn+Mrd527/bFpHIq+IxxOUgomK/UAwq6OE17OVsswHnpAvXEzIKKz3
         2xkg+ySM0kzICNHcSe3YG80ho0ziDmjI3LeQmbSef/9Olysb0NGJfbGLkRxqXTa9j/Bz
         cnfBGi0UjDHr7KW2GoGCkG8MiuV+GxRiIwm3fsEwkemfPo+r5ZfW9ulndfnkZH/5ovMU
         ibTQ==
X-Gm-Message-State: AOAM532q5r8qbuqk45oN81MB0L5c6xxZhmM7y48ue3en8yodUIBzTkc0
        MYr388Cr75rcmVRaAXFAMxL/9xcU7i4LGHGpXXtfSzE3lBztxdYZuSBuhnpp82/v+2vhmv7C6vq
        bmdcjP5fOk3PoPwZRMPENwuiarcMv1Ce8
X-Received: by 2002:aca:6255:: with SMTP id w82mr2658965oib.5.1606938000371;
        Wed, 02 Dec 2020 11:40:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzOlSQMI5TPESzvcnQmnIH/U9UC+f0GqKimPWfRRvS7hiDpvoTOgDAUfPapidvwk2bAEB18yp+lk2/wrsXoPz4=
X-Received: by 2002:aca:6255:: with SMTP id w82mr2658954oib.5.1606938000111;
 Wed, 02 Dec 2020 11:40:00 -0800 (PST)
MIME-Version: 1.0
References: <20201123031716.6179-1-jarod@redhat.com> <20201202173053.13800-1-jarod@redhat.com>
 <20201202095320.7768b5b3@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CAKfmpSeGEpjVxw5J=tNBYc2bZEY-z7DbQeb2TcekbqkiBe7O6g@mail.gmail.com> <20201202112256.59a97b9c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201202112256.59a97b9c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Wed, 2 Dec 2020 14:39:49 -0500
Message-ID: <CAKfmpSfffy5Rq6LaRCVEguo0-ahZ+6dfj_M18WhJxKtmSybagw@mail.gmail.com>
Subject: Re: [PATCH net v2] bonding: fix feature flag setting at init time
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ivan Vecera <ivecera@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Davis <tadavis@lbl.gov>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 2, 2020 at 2:23 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 2 Dec 2020 14:03:53 -0500 Jarod Wilson wrote:
> > On Wed, Dec 2, 2020 at 12:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Wed,  2 Dec 2020 12:30:53 -0500 Jarod Wilson wrote:
> > > > +     if (bond->dev->reg_state != NETREG_REGISTERED)
> > > > +             goto noreg;
> > > > +
> > > >       if (newval->value == BOND_MODE_ACTIVEBACKUP)
> > > >               bond->dev->wanted_features |= BOND_XFRM_FEATURES;
> > > >       else
> > > >               bond->dev->wanted_features &= ~BOND_XFRM_FEATURES;
> > > > -     netdev_change_features(bond->dev);
> > > > +     netdev_update_features(bond->dev);
> > > > +noreg:
> > >
> > > Why the goto?
> >
> > Seemed cleaner to prevent an extra level of indentation of the code
> > following the goto and before the label, but I'm not that attached to
> > it if it's not wanted for coding style reasons.
>
> Yes, please don't use gotos where a normal if statement is sufficient.
> If you must avoid the indentation move the code to a helper.
>
> Also - this patch did not apply to net, please make sure you're
> developing on the correct base.

Argh, I must have been working in net-next instead of net, apologies.
Okay, I'll clarify the description per what Jay pointed out and adjust
the code to not include a goto, then make it on the right branch.

-- 
Jarod Wilson
jarod@redhat.com

