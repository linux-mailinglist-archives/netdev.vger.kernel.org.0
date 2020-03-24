Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C868190880
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 10:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgCXJHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 05:07:43 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:34714 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgCXJHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 05:07:42 -0400
Received: by mail-ed1-f67.google.com with SMTP id i24so19885087eds.1
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 02:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bQnFnqK7h413XXIlxDFzP8O+9cc8lrJac9qTaZqSQS0=;
        b=t1ujTDW4YTE8dsigKUO/VxsVS71b+LcGHAa5fRY2Ki9+PZKuk8gs/S9VLwcHoqYr77
         YutV/9XW+56IBaxB3akURPJBWnklIlR4ebslz2VWBMZxbx+fMeRRFEGkfA6vYKyR0Cpn
         2HBHyrjt6EC+gY/hhExusyHuczht2y35+zbxUnZt5BBzNGTMVdq87XvHJQQE/H8tqjpi
         +19cdxR73dls9jeYq7Sk4GEEWOuQgJNJvltj8nmjSyt76hrmQG2ZrpYxDQqBVRC2Kz2Q
         i8c3tRxcWEX4qGlLyNsPUlzUvL5eV5K7VycMnMEkSSsJcbtHcAqeAWD45GYbwZJHg0J6
         yDyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bQnFnqK7h413XXIlxDFzP8O+9cc8lrJac9qTaZqSQS0=;
        b=Ehm44uZO+g67i9dFq8BGsgZ+RpY4mgM2UYfG3z3oOu1d11ogk5qdwtFkgHSTfDSc4Z
         6/X3irO9ga4nhi4Vq5CZQOXLBH6ekViUW8z5SsEI7TWp1tBsnMylBrNj/RCv04GaEu84
         cmXj9yQYYABCUCXMdl8PtxtD/MlAoFd85tK4oqs5C8EPr+Rpadq3tQk5+2VoTUrj27n3
         tT66g5vci/LsIUgSDn8HZ69jNHGB6ndfHu7Rp+IjXyVOvm5AnSkuUMhn++R9+Ju7Y+pF
         k7olE4tLQhbwMxgONUVcgsfxh9DACxLlcsxREP7KCuXlPKUQBu8mln8eqrt/L4+JoEuN
         FBRQ==
X-Gm-Message-State: ANhLgQ1IGVDFzQ7D70q78nqqkTO8dFilQ1NTT7pOoXhgH89lCyYf0a7C
        uZy0XhCbi0s91ZIdP08qv3kE6OOx8E/PveJH/bE=
X-Google-Smtp-Source: ADFU+vuLsLUlkj+xdqR+8T9NP9P6V/s1H655YtyTm+ioSTeRtVj1chfvo1mf4n0oTNq3eTYbC35R908beiFAS29pCog=
X-Received: by 2002:a17:906:d286:: with SMTP id ay6mr22001028ejb.113.1585040860143;
 Tue, 24 Mar 2020 02:07:40 -0700 (PDT)
MIME-Version: 1.0
References: <AM0PR04MB7041125938BF9A9225B5A8B286F10@AM0PR04MB7041.eurprd04.prod.outlook.com>
In-Reply-To: <AM0PR04MB7041125938BF9A9225B5A8B286F10@AM0PR04MB7041.eurprd04.prod.outlook.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 24 Mar 2020 11:07:29 +0200
Message-ID: <CA+h21hpwEV8dwZPWSRpKzt1UocVfv+N_JOj7ZYWG9egcJZ9Rpw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/4] net: dsa: sja1105: unconditionally set
 DESTMETA and SRCMETA in AVB table
To:     Christian Herber <christian.herber@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>, "Y.b. Lu" <yangbo.lu@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christian,

On Tue, 24 Mar 2020 at 09:39, Christian Herber <christian.herber@nxp.com> wrote:
>
> >+static int sja1105_init_avb_params(struct sja1105_private *priv)
> >+{
> >+       struct sja1105_avb_params_entry *avb;
> >+       struct sja1105_table *table;
> >+
> >+       table = &priv->static_config.tables[BLK_IDX_AVB_PARAMS];
> >+
> >+       /* Discard previous AVB Parameters Table */
> >+       if (table->entry_count) {
> >+               kfree(table->entries);
> >+               table->entry_count = 0;
> >+       }
> >+
> >+       table->entries = kcalloc(SJA1105_MAX_AVB_PARAMS_COUNT,
> >+                                table->ops->unpacked_entry_size, GFP_KERNEL);
> >+       if (!table->entries)
> >+               return -ENOMEM;
> >+
> >+       table->entry_count = SJA1105_MAX_AVB_PARAMS_COUNT;
> >+
> >+       avb = table->entries;
> >+
> >+       /* Configure the MAC addresses for meta frames */
> >+       avb->destmeta = SJA1105_META_DMAC;
> >+       avb->srcmeta  = SJA1105_META_SMAC;
> >+
> >+       return 0;
> >+}
> >+
>
> Would it be possible to use the MAC address of the connected eth as destination? This is nicer also when going over multiple cascaded switches.
>
> Christian

The current destination MAC is 01:80:C2:00:00:0E, which is already a
bridge link-local multicast address that switches are supposed to trap
towards the CPU and not forward.
The way things work right now is that the driver assumes user space
will add the multicast MAC addresses required for PTP operation on the
slave net device, and DSA will propagate those addresses to the master
port as well.
I think your suggestion might make a difference when the PTP user
space stack exits, and the slave ports are operating in standalone
(non-bridged) mode. There is an issue in that case, where the switch
still sends RX timestamps (since nobody disabled RX timestamping via
the ioctl), but the multicast MAC address is no longer in the DSA
master's RX filter. So the kernel log is spammed by the state machine
in net/dsa/tag_sja1105.c getting upset about meta frames being
expected but not received.
If anything, I'm a bit worried about the source MAC address (currently
22:22:22:22:22:22) which is potentially non-unique, although I need to
do more testing to see if this is actually a problem. I have a board
with a DSA switch acting as 3 DSA masters on 3 ports, on each port
having cascaded a sja1105 switch, and source address learning (of
22:22:22:22:22:22) on the top-level DSA switch is what concerns me.

Thanks,
-Vladimir
