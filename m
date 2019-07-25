Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEB9475868
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 21:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfGYTwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 15:52:18 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35366 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfGYTwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 15:52:18 -0400
Received: by mail-lj1-f194.google.com with SMTP id x25so49226912ljh.2
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 12:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mK49DjFaqCAk2WBGk404bZPsENIJ7ymFJnZPmzQeBUw=;
        b=dUlRvJsYATGJSQyPM45nutcveLwf1YLuO1u3Xc+CWEhFv67SPJS32wujcaCDCzNivl
         VEwXlvIaSbN3DJmVqmOkNkeu5piuptQmP5WBNMOiMUayesi3oX4LCGO/K2MqVzGiTkKd
         7L5W5Pgx7FVP5Ci4Ubz4Pw7CRuQF+VTLjSZ4riJV+RkMsE3V5NGDhomC3ATYy51KxWQ4
         gOE/LgmkBBVnm3eRK+uw9jDdXDQc4K1RqrUJDcYrnz+b+RJE1Fhz2M5NjmMVW8Dp8zMv
         LTsLkYiTobaVJO6cpKDlf79LBVy38s2uY7XYhLndewqjxEvtYlXY1NdHr+0r2LwT+0Kp
         8r9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mK49DjFaqCAk2WBGk404bZPsENIJ7ymFJnZPmzQeBUw=;
        b=J1QewmUptC7h5sqvWKBVtarkOyeAtWpr0IL1fdGEyUShTYa4h9qCmUrBRBxSbbtBaS
         twJKjisSi0gvo2Uxq8jdgSetgfSb8eHJW+s9WJheJ8lMQQYboQrAv7tNN2TNbTic6CKg
         2jYbVkqfWSLS0iPBZaKJS20v659afViGbUCgPt/4bQh75NPIerOqo7X4JZqWIz/iMkEG
         uxc1KEOW0yupdMrWMxJbl4JegdX/x1rlTe0C1gagklyY9ZrGIgJw14GJ+qZZxslvfT01
         uhBQwgEWqR+VlGnCiXak23HT/Y8P4GyQ7+ffa6ZpjjSkd4PhpltgIA0hDRzhC53PLS5s
         bJmw==
X-Gm-Message-State: APjAAAXTVXhPNFHL5DnawxWPHs6XQaJF1Ub+F/qC6dH1dzTNPwdfHguU
        Hg3DtAd6Mq+XrlFWdjCdjAfJSyW/QVTKPLlNpNY=
X-Google-Smtp-Source: APXvYqy7t6AIvd/iCfDph9mACf5jLAxllJwlApGb271rTyY4rfBAXUDOl7DOp8ACFnMI6XPikZffCjgR3olwNUPAD0A=
X-Received: by 2002:a2e:9c85:: with SMTP id x5mr18677786lji.139.1564084336828;
 Thu, 25 Jul 2019 12:52:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190725161809.14650-1-sergej.benilov@googlemail.com>
 <20190725162543.GJ21952@lunn.ch> <CAC9-QvATLW0uCzGpeY1kLXs5BBsfNBF_BKCnCz+38_f+STJhog@mail.gmail.com>
 <20190725182029.GK21952@lunn.ch>
In-Reply-To: <20190725182029.GK21952@lunn.ch>
From:   Sergej Benilov <sergej.benilov@googlemail.com>
Date:   Thu, 25 Jul 2019 21:52:05 +0200
Message-ID: <CAC9-QvBZTcobu538=5fUDxm=xnsR+4SbzVF3su69fMPH7R_wzw@mail.gmail.com>
Subject: Re: [PATCH] sis900: add support for ethtool --eeprom-dump
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     venza@brownhat.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jul 2019 at 20:20, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Jul 25, 2019 at 06:41:41PM +0200, Sergej Benilov wrote:
> > On Thu, 25 Jul 2019 at 18:25, Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > > +static int sis900_read_eeprom(struct net_device *net_dev, u8 *buf)
> > > > +{
> > > > +     struct sis900_private *sis_priv = netdev_priv(net_dev);
> > > > +     void __iomem *ioaddr = sis_priv->ioaddr;
> > > > +     int wait, ret = -EAGAIN;
> > > > +     u16 signature;
> > > > +     u16 *ebuf = (u16 *)buf;
> > > > +     int i;
> > > > +
> > > > +     if (sis_priv->chipset_rev == SIS96x_900_REV) {
> > > > +             sw32(mear, EEREQ);
> > > > +             for (wait = 0; wait < 2000; wait++) {
> > > > +                     if (sr32(mear) & EEGNT) {
> > > > +                             /* read 16 bits, and index by 16 bits */
> > > > +                             for (i = 0; i < sis_priv->eeprom_size / 2; i++)
> > > > +                                     ebuf[i] = (u16)read_eeprom(ioaddr, i);
> > > > +                     ret = 0;
> > > > +                     break;
> > > > +                     }
> > > > +             udelay(1);
> > > > +             }
> > > > +     sw32(mear, EEDONE);
> > >
> > > The indentation looks all messed up here.
> >
> > This has passed ./scripts/checkpatch.pl, as you had suggested for the
> > previous patch.
>
> checkpatch just checks for things like tabs vs space.
>
> I would expect the indentation to be more like:
>
>
>         if (sis_priv->chipset_rev == SIS96x_900_REV) {
>                 sw32(mear, EEREQ);
>                 for (wait = 0; wait < 2000; wait++) {
>                         if (sr32(mear) & EEGNT) {
>                                 /* read 16 bits, and index by 16 bits */
>                                 for (i = 0; i < sis_priv->eeprom_size / 2; i++)
>                                         ebuf[i] = (u16)read_eeprom(ioaddr, i);
>                                 ret = 0;
>                                 break;
>                         }
>                         udelay(1);
>                 }
>                 sw32(mear, EEDONE);
>         } else {
>                 signature = (u16)read_eeprom(ioaddr, EEPROMSignature);
>                 if (signature != 0xffff && signature != 0x0000) {
>                         /* read 16 bits, and index by 16 bits */
>                         for (i = 0; i < sis_priv->eeprom_size / 2; i++)
>                                 ebuf[i] = (u16)read_eeprom(ioaddr, i);
>                         ret = 0;
>                 }
>         }
>         return ret;
>

Ok, I see now what you mean.
I fixed the alignment.

This patch is superseded.

> > > Why do you not put the data directly into data and avoid this memory
> > > allocation, and memcpy?
> >
> > Because EEPROM data from 'eeprom->offset' offset and of 'eeprom->len'
> > length only is expected to be returned in 'data'.
>
> O.K.
>
>         Andrew
