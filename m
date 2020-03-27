Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41C7D1957A8
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 14:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbgC0NBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 09:01:24 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:40258 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726742AbgC0NBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 09:01:24 -0400
Received: by mail-lf1-f65.google.com with SMTP id j17so7759577lfe.7
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 06:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZTyqYe2EhROEgjdHMES6I6F+k1BvbZGmjuDZBofHaR0=;
        b=TZlG7/oCUljXt49y2C3fjScWErRdvS4VkWkBTPOxDrN+HCt/jH8GLeVak3Rzw5b94H
         fzXJLt7R8kaKWAPMXB//p+OaQTJ53NwS9ds2JAyfuJEg8PYoTWbIlNMWduoQXY/6YMVV
         +Vx41tct2aURhjykpr+oHGwdT+X+avLOWnmRJL4Av8nmq3GA7iD05zlCZnK2WtbKkDUF
         o8rMydACLm53RM4zaXiLCBM9qmBz8eK7he5A0Nn/PPXalH/whbS+48UZTP5kMLQPr2tc
         xkDkPp//HmIMvHVMa9PqC3GUEf/G7te7sFVNXxg4Ca/NqFwgGoaIjgFFq3mxDkqpUcPY
         782A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZTyqYe2EhROEgjdHMES6I6F+k1BvbZGmjuDZBofHaR0=;
        b=IQg5Cd6TERsXVpXs/TzTelcD6cVBq1AzEkIoNsmORvFclCy1hGzrQIecqNzQDMpns4
         IUWiKAFJNph5BvKIZ/NWVJHLuZdXHiBfiZMb90D9AirefipzYeL+tXlVnAde1HrZ8iR4
         wnCyHw7SalYmGBZSM560CI0NXrJBVmOBQbN2Ruwq3UtKK0ym1zv8lfMnBLMra19tnBg+
         gE7iGeN9Zqxvy4GrzORWuAREojHvraA23UoMjZDaaMaVQOESpjAqIapaqmIhnYXKORfC
         X1czdi5/bB/Fy3nBM5c8fiSSaX3RoKt8KOW+FGJ1RQHzzobmxvYhiEA3oTwcdzDMCkKX
         EVxg==
X-Gm-Message-State: ANhLgQ1ZddyxizrAv7q2p20eavYNqkqEAyHVznUv1qW/PWypLZbs19p3
        4ErE5bRlpUYITjKmzLiCRlB0HeRioTZsgIl5gfH9B1NAZ45vPA==
X-Google-Smtp-Source: ADFU+vt3Xpw+dex3yA6mR1zuUJBbGLuZfq2obCt8RPaaVfNM2GF8J8OMll9MywM/01pbMiHdeEK0Umft4HqovT0C9Yo=
X-Received: by 2002:a05:6512:68b:: with SMTP id t11mr9348534lfe.214.1585314080479;
 Fri, 27 Mar 2020 06:01:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200326224040.32014-1-olteanv@gmail.com> <20200326224040.32014-6-olteanv@gmail.com>
 <ca7e48c2-249a-9066-045f-04708474ef8a@gmail.com>
In-Reply-To: <ca7e48c2-249a-9066-045f-04708474ef8a@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 27 Mar 2020 15:01:09 +0200
Message-ID: <CA+h21hq4ck2AhKfJtJvEHkpeYRsTWtXBBPxczo+oaN7X5QZvKw@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 5/8] net: dsa: b53: add MTU configuration support
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        murali.policharla@broadcom.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Mar 2020 at 01:16, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 3/26/2020 3:40 PM, Vladimir Oltean wrote:
> > From: Murali Krishna Policharla <murali.policharla@broadcom.com>
> >
> > It looks like the Broadcomm switches supported by the b53 driver don't
>                             ^= one too many m's, the attempt to acquire
> Qualcomm failed a few years ago :)
>

I knew you guys were jealous of their extra m!

> > support precise configuration of the MTU, but just a mumbo-jumbo boolean
> > flag. Set that.

I'm more concerned of the mumbo-jumbo, in fact. Right now, DSA sets
dev->mtu = mtu in slave.c. But for hardware like this, it would be
confusing to do that. I would do dev->mtu = JMS_MIN_SIZE or dev->mtu =
JMS_MAX_SIZE depending on configuration, so that the user isn't led
into thinking that their exact requested value went into the hardware.
Any ideas on how I could structure things differently for that?

> >
> > Also configure BCM583XX devices to send and receive jumbo frames when
> > ports are configured with 10/100 Mbps speed.
> >
> > Signed-off-by: Murali Krishna Policharla <murali.policharla@broadcom.com>
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
>
> [snip]
>
> > +static int b53_change_mtu(struct dsa_switch *ds, int port, int mtu)
> > +{
> > +     struct b53_device *dev = ds->priv;
> > +     bool enable_jumbo;
> > +     bool allow_10_100;
> > +
> > +     if (is5325(dev) || is5365(dev))
> > +             return -EOPNOTSUPP;
> > +
> > +     enable_jumbo = (mtu >= JMS_MIN_SIZE);
> > +     allow_10_100 = (dev->chip_id == BCM58XX_DEVICE_ID);
>
> I believe this was meant to be BCM583XX_DEVICE_ID to be consistent with
> the previous patch version. With that:
>

Ok.

> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> --
> Florian
