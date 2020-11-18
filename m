Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DAE52B867F
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 22:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgKRVUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 16:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgKRVUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 16:20:47 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC18C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 13:20:46 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id k65so3084228ybk.5
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 13:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KMhQReRtisQCLWwZY0Qya20ywEC4J4hZ6sMiK5oDuY4=;
        b=bHLuk9JKx8EBpSkdOY8YbM9n4NT/BbU7PTdhbTm345ZcomyOUTN1Hpm45/KNCKOiiF
         urTGmBIY6mST50d4wjWpnM2Q5rOBxwf4Cc57RIO/VvSUTN8JVhGoIyc2RDt/qXDZIj+C
         eIyEct5p/U9aJsgb8qk094nTwTNUd2fdZeeWtPejp7nzJq7t6IEug6nusily7srJroUz
         aR4a53Rk81yxx9CvDbFAT3e8Z7/PTXYlF5HwvJ8X49qn0KUn5mnc3lnQJuAQqYWAlzy/
         KU4QmEXjb8Hk+QkFNPWi4otM4RIEixxVKPjN0C0DVpd7Y90mI0jK70EsrRmPnfvgCicI
         rgWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KMhQReRtisQCLWwZY0Qya20ywEC4J4hZ6sMiK5oDuY4=;
        b=BiZbjehMSjb+8Ey3Vjl+czL3vYuFEqMKwr7eH2w57faPtOiRaSgQI29hpCWBHH+gSU
         yM8hD02xViYgWh//NejzwSaCkDs51/IAAVA6P2T0rWBrhJoTHgqPV+2LPh2MxTbtLVNT
         mPY76qp8egYK90gAAY+9DWGUUEcJcpRv7YSTuAufXhA12gf+HqsA3uIqT/Bf7r4CJtuF
         C2jKT8oowbtcL7vONucOz/G9wxdzAA+JV0dQ5r5O1JclVfb6cmPB72Nuc9r9xeE2kQCr
         zv+uHPl9XptzU3wWyFLzyYVxtiRYKd8U24symXRRv79QNNbxkbq/mNfrBarVqgbjhEFh
         5VSQ==
X-Gm-Message-State: AOAM5324HHd6WZeAb5Xpn9NVLrqoCr3BSDb/CHmt2ISDi98GR1vyLzcO
        fnV4btJnzH4OOy4VdW+W3H8L5cGPTxdut0c7KJ6fng==
X-Google-Smtp-Source: ABdhPJxOhKAndWUtvUdyvc+cR6E0nqhlqukRkNiETzmhN0fs1KUhLKEE9LTtj2j45+o+ZYNAnQWj9w0E8V67xAqcu2M=
X-Received: by 2002:a25:a4a1:: with SMTP id g30mr8826381ybi.195.1605734445925;
 Wed, 18 Nov 2020 13:20:45 -0800 (PST)
MIME-Version: 1.0
References: <20201118191009.3406652-1-weiwan@google.com> <20201118191009.3406652-3-weiwan@google.com>
 <8578cfd8-dcaf-5a86-7803-922ee27d9e90@infradead.org>
In-Reply-To: <8578cfd8-dcaf-5a86-7803-922ee27d9e90@infradead.org>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 18 Nov 2020 13:20:34 -0800
Message-ID: <CAEA6p_BN7XRxc7Avw0rx5N+j_iGqVqB8gpok6AMaHkf2kjPNCA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/5] net: add sysfs attribute to control napi
 threaded mode
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Felix Fietkau <nbd@nbd.name>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Hillf Danton <hdanton@sina.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 12:36 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> On 11/18/20 11:10 AM, Wei Wang wrote:
> > From: Paolo Abeni <pabeni@redhat.com>
> >
> > this patch adds a new sysfs attribute to the network
> > device class. Said attribute is a bitmask that allows controlling
> > the threaded mode for all the napi instances of the given
> > network device.
> >
> > The threaded mode can be switched only if related network device
> > is down.
> >
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
> > Signed-off-by: Wei Wang <weiwan@google.com>
> > Reviewed-by: Eric Dumazet <edumazet@google.com>
>
> Hi,
>
> Could someone describe the bitmask (is it a bit per instance of the
> network device?).
> And how to use the sysfs interface, please?
>

It is 1 bit per napi. Depending on the driver implementation, 1 napi
could correspond to 1 tx queue, or 1 rx queue, or 1 pair of tx/rx
queues.
To set bits in the bit mask, you could do:
echo 0-14 > /sys/class/net/<dev>/threaded
to set consecutive bits.
or:
echo 0,2,4,6,8 >  /sys/class/net/<dev>/threaded
to set individual bits.

To clear the bit mask, you could do:
echo > /sys/class/net/<dev>/threaded

> > ---
> >  net/core/net-sysfs.c | 103 +++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 103 insertions(+)
> >
> > diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> > index 94fff0700bdd..df8dd25e5e4b 100644
> > --- a/net/core/net-sysfs.c
> > +++ b/net/core/net-sysfs.c
>
>
> thanks.
> --
> ~Randy
>
