Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE7452CC624
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 20:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731053AbgLBTFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 14:05:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24670 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728673AbgLBTFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 14:05:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606935847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BZgI58oXHnLe7xcVyIIW1J7sjpmZ6zrQ31yH/5NDy4s=;
        b=N2qcUPR7YuRxWEULPcuFdbt1g85lydp/ZLNM1mvaqOCDolDReVzQ/DHrc9acv4yc5EqMWc
        5uP6salKTu1EG/pRsAyHS3Gl72JpyPH82/chXLnCfHw3xG/0Ulktc20njkGlGDeN5xzYM9
        TM9YZq4W342h5BrT6kzeLKq1roEmL0M=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-ijfoqRNaMNiqRbwpE_zA2g-1; Wed, 02 Dec 2020 14:04:05 -0500
X-MC-Unique: ijfoqRNaMNiqRbwpE_zA2g-1
Received: by mail-oo1-f70.google.com with SMTP id w2so1285772ooo.12
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 11:04:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BZgI58oXHnLe7xcVyIIW1J7sjpmZ6zrQ31yH/5NDy4s=;
        b=Xc0k24QmxHuwn3z3Ra5KrTxLF+lEj3L2aXXdKsm+ADnelN/0OEf0V+JuqblsxzYw+X
         Jda/9wvc/3sTKbB9rfRLcztNuFgwv8eoAlap0z4a0CP5tOoas74OSuc+Ggp0+3L3gMAW
         AaPReQlt8YnjPgbXgD28+FyajJVif3JQrNIo2bVj2vFEkfn3Fctqoq/1eJ7p+7WkWTSg
         ES9U4+zJLSVI02aWI0ft/J+cU5ymQYreYnE7/vcRAgUPy03foRxN3OhS+zbBDOrNOGnI
         PG0+8Kk5C0ukZOAy3W1hJUacmt6xeIQvBRNlqpHmwaZ5o1XfRM/4hLg7MNzPLfoUsEKK
         f88w==
X-Gm-Message-State: AOAM5311LecUZnKYfG+i10Eo3lmOA/GoMwPpTmM7eejCYaoa6+OH0qZh
        53BL9FcdJRj4ebt8M8GtgXq0N31ueu1VKe8lgb7fR8gunC+qO011vhPupduGXLV9fkQC56t2x/v
        NRibuWuyjJFNt9w0K17heQcZA5ox+gbrB
X-Received: by 2002:a05:6830:1348:: with SMTP id r8mr3038183otq.277.1606935844827;
        Wed, 02 Dec 2020 11:04:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzUH+ZXAQb+AdM8CiBQehYvNzfMgjhkJV49Ixz42Onq7ltupuKx5k2d8ROb0C8KzlRxRwOoBUc8VMgMH+BcTuM=
X-Received: by 2002:a05:6830:1348:: with SMTP id r8mr3038119otq.277.1606935843969;
 Wed, 02 Dec 2020 11:04:03 -0800 (PST)
MIME-Version: 1.0
References: <20201123031716.6179-1-jarod@redhat.com> <20201202173053.13800-1-jarod@redhat.com>
 <20201202095320.7768b5b3@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201202095320.7768b5b3@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Wed, 2 Dec 2020 14:03:53 -0500
Message-ID: <CAKfmpSeGEpjVxw5J=tNBYc2bZEY-z7DbQeb2TcekbqkiBe7O6g@mail.gmail.com>
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

On Wed, Dec 2, 2020 at 12:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed,  2 Dec 2020 12:30:53 -0500 Jarod Wilson wrote:
> > +     if (bond->dev->reg_state != NETREG_REGISTERED)
> > +             goto noreg;
> > +
> >       if (newval->value == BOND_MODE_ACTIVEBACKUP)
> >               bond->dev->wanted_features |= BOND_XFRM_FEATURES;
> >       else
> >               bond->dev->wanted_features &= ~BOND_XFRM_FEATURES;
> > -     netdev_change_features(bond->dev);
> > +     netdev_update_features(bond->dev);
> > +noreg:
>
> Why the goto?

Seemed cleaner to prevent an extra level of indentation of the code
following the goto and before the label, but I'm not that attached to
it if it's not wanted for coding style reasons.

-- 
Jarod Wilson
jarod@redhat.com

