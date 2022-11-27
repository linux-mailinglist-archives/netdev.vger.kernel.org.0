Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1FF063994C
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 05:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiK0Ebb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 26 Nov 2022 23:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiK0Eba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 23:31:30 -0500
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25B211165;
        Sat, 26 Nov 2022 20:31:28 -0800 (PST)
Received: by mail-pg1-f172.google.com with SMTP id 6so7106578pgm.6;
        Sat, 26 Nov 2022 20:31:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CteW4hw2jCRa5JT0Vlb8v5AcbwE2HjAD8s0GhhqMFcA=;
        b=Git9cSZdtdh5qhea4rl/bBWT7lUnaVb2rD/FE2EUEA5e23jWQBWJKMEM+N/FnUl4+N
         Iugh7QU5GPmK48ErUKvGurd7Yvqb2PT2+5/4t8ITYbU3YN0gBvRxTV5dvkxAcM6d5001
         ToWkcOrMaxzxq6i8PyGfIYekDlgviwQqXbA6dbJVzvakRXpKuQni22M7Il13Y0o5Yc3v
         zS6pWnySMx0/ikkRutmXJU0weOkgG61bS1MkNynUg0ZArOscF6xUUS+GKbIjPyjk+nMr
         ui6pdUS6F5zbu1nSkJW8mXDMpgqQUZhmLizEucx61iQfajmNl/R0SigCfw6ubPffZK9p
         KE8A==
X-Gm-Message-State: ANoB5plS26EwuV0qscZk/9pM9L7eXid1JMBRDZO/0tmIEQDcVVOEYo/s
        n1ajWWXWDAZ0+c3/9owG6uyopQ7dZA4Moc+PR0g=
X-Google-Smtp-Source: AA0mqf5BYiHM8hLHpaRN0oIDbM6NRQdH2nijyfkxKZf2Jzl46Ijzhx4BVNQ0+xHlXBijQ1XwqzTihuDdHDpEscdI7Ic=
X-Received: by 2002:a62:6d02:0:b0:562:3411:cb3a with SMTP id
 i2-20020a626d02000000b005623411cb3amr26276270pfc.60.1669523488298; Sat, 26
 Nov 2022 20:31:28 -0800 (PST)
MIME-Version: 1.0
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-1-mailhol.vincent@wanadoo.fr> <20221126162211.93322-4-mailhol.vincent@wanadoo.fr>
 <Y4JJ8Dyz7urLz/IM@lunn.ch> <CAMZ6Rq+K+6gbaZ35SOJcR9qQaTJ7KR0jW=XoDKFkobjhj8CHhw@mail.gmail.com>
In-Reply-To: <CAMZ6Rq+K+6gbaZ35SOJcR9qQaTJ7KR0jW=XoDKFkobjhj8CHhw@mail.gmail.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Sun, 27 Nov 2022 13:31:17 +0900
Message-ID: <CAMZ6Rq+-RH4QhBkdm_y60U1AaqEON5Mbii9N9p=zT_2AMY9gmw@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] can: etas_es58x: export product information
 through devlink_ops::info_get()
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun. 27 Nov. 2022 at 12:42, Vincent MAILHOL
<mailhol.vincent@wanadoo.fr> wrote:
> Hi Andrew,
>
> Thank you for the review and the interesting comments on the parsing.
>
> On. 27 Nov. 2022 at 02:37, Andrew Lunn <andrew@lunn.ch> wrote:
> > > +struct es58x_sw_version {
> > > +     u8 major;
> > > +     u8 minor;
> > > +     u8 revision;
> > > +};
> >
> > > +static int es58x_devlink_info_get(struct devlink *devlink,
> > > +                               struct devlink_info_req *req,
> > > +                               struct netlink_ext_ack *extack)
> > > +{
> > > +     struct es58x_device *es58x_dev = devlink_priv(devlink);
> > > +     struct es58x_sw_version *fw_ver = &es58x_dev->firmware_version;
> > > +     struct es58x_sw_version *bl_ver = &es58x_dev->bootloader_version;
> > > +     struct es58x_hw_revision *hw_rev = &es58x_dev->hardware_revision;
> > > +     char buf[max(sizeof("xx.xx.xx"), sizeof("axxx/xxx"))];
> > > +     int ret = 0;
> > > +
> > > +     if (es58x_sw_version_is_set(fw_ver)) {
> > > +             snprintf(buf, sizeof(buf), "%02u.%02u.%02u",
> > > +                      fw_ver->major, fw_ver->minor, fw_ver->revision);
> >
> > I see you have been very careful here, but i wonder if you might still
> > get some compiler/static code analyser warnings here. As far as i
> > remember %02u does not limit it to two characters.
>
> I checked, none of gcc and clang would trigger a warning even for a
> 'make W=12'. More generally speaking, I made sure that my driver is
> free of any W=12.
> (except from the annoying spam from GENMASK_INPUT_CHECK for which my
> attempts to silence it were rejected:
> https://lore.kernel.org/all/20220426161658.437466-1-mailhol.vincent@wanadoo.fr/
> ).
>
> > If the number is
> > bigger than 99, it will take three characters. And your types are u8,
> > so the compiler could consider these to be 3 characters each. So you
> > end up truncating. Which you look to of done correctly, but i wonder
> > if some over zealous checker will report it?
>
> That zealous check is named -Wformat-truncation in gcc (I did not find
> it in clang). Even W=3 doesn't report it so I consider this to be
> fine.
>
> > Maybe consider "xxx.xxx.xxx"?
>
> If I do that, I also need to consider the maximum length of the
> hardware revision would be "a/xxxxx/xxxxx" because the numbers are
> u16. The declaration would become:
>
>         char buf[max(sizeof("xxx.xxx.xxx"), sizeof("axxxxx/xxxxx"))];
>
> Because no such warning exists in the kernel, I do not think the above
> line to be a good trade off. I would like to keep things as they are,
> it is easier to read. That said, I will add an extra check in
> es58x_parse_sw_version() and es58x_parse_hw_revision() to assert that
> the number are not bigger than 99 for the software version (and not
> bigger than 999 for the hardware revision). That way the code will
> guarantee that the truncation can never occur.

Never mind. I forgot that I already accounted for that. The "%2u"
format in sscanf() will detect if the number is three or more digits.
So I am thinking of leaving everything as-is.

> > Nice paranoid code by the way. I'm not the best at spotting potential
> > buffer overflows, but this code looks good. The only question i had
> > left was how well sscanf() deals with UTF-8.
>
> It does not consider UTF-8. The %u is a _parse_integer_limit() in disguise.
>   https://elixir.bootlin.com/linux/v6.1-rc6/source/lib/vsprintf.c#L3637
>   https://elixir.bootlin.com/linux/v6.1-rc6/source/lib/vsprintf.c#L70
>
> _parse_integer_limit() just check for ASCII digits so the first UTF-8
> character would make the function return.
>   https://elixir.bootlin.com/linux/v6.1-rc6/source/lib/kstrtox.c#L65
>
> For example, this:
>   "ＦＷ:03.00.06"
> would fail parsing because sscanf() will not be able to match the
> first byte of the UTF-8 'Ｆ' with 'F'.
>
> Another example:
>   "FW:０３.００.０６"
> would also fail parsing because _parse_integer_limit() will not
> recognize the first byte of UTF-8 '０' as a valid ASCII digit and
> return early.
>
> To finish, a very edge case:
>   "FW:03.00.0６"
> would incorrectly succeed. It will parse "FW:03.00.0" successfully and
> will return when encountering the UTF-8 '６'. But I am not willing to
> cover that edge case. If the device goes into this level of
> perversion, I do not care any more as long as it does not result in
> undefined behaviour.
>
>
> Yours sincerely,
> Vincent Mailhol
