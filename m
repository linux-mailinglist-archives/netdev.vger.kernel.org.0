Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB12639943
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 04:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiK0Dmc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 26 Nov 2022 22:42:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiK0Dmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 22:42:32 -0500
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2400DF1;
        Sat, 26 Nov 2022 19:42:29 -0800 (PST)
Received: by mail-pf1-f170.google.com with SMTP id w79so7462371pfc.2;
        Sat, 26 Nov 2022 19:42:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FucA3Sodw38qvlVLRVvNtzxLWzWTb944v88XDY3XbJY=;
        b=KQsKXfxiaLtAsHNz+uuP5iUFaDUT4D85gZb2vVlOmRwlmwUO2hx54z3sVD7Z9ddyvV
         Ueh/N3pU1ZtoriWKPkQU/eC+KZPnaPXYqL9k5S8y73jIGRhHe/Gdg8LVKizndL63Wr52
         0IE54iuoo0/QDeVN3BVGDmw+A42y1ihGDOL+5joKsWXpNpTa1Krk9PQIoxFL1iSMwXuh
         j1JoZds0Ukqe6c35Jvp++rnNmtZObgnN3O7OQpFXx/bdeLTsLHJ3kO2SrmJE8I/9EYZY
         A7tUHkGbft+12D5rrI6lJDCTN1yu1qvbjWuxTjoZC/OfH8rdO6KC9zAODQQUk+TJ2TWC
         XA9g==
X-Gm-Message-State: ANoB5pklAwcItLyvz9tCj0XGGwVWe4kZmFC94EepQMv4K/oSJLARYV+F
        GoLqxPbfazv9gXjV2hMxotyxbPI7N/7YmRNLZqM=
X-Google-Smtp-Source: AA0mqf4pd0LS9qQTVN4KChy6A06YwOUnjFr7T249St3XDx3faAgp823CKEfuq8gJFBEKhemKCjH0hmTK280KuYTb4i0=
X-Received: by 2002:a62:1a8b:0:b0:572:7c58:540 with SMTP id
 a133-20020a621a8b000000b005727c580540mr27182789pfa.69.1669520549055; Sat, 26
 Nov 2022 19:42:29 -0800 (PST)
MIME-Version: 1.0
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-1-mailhol.vincent@wanadoo.fr> <20221126162211.93322-4-mailhol.vincent@wanadoo.fr>
 <Y4JJ8Dyz7urLz/IM@lunn.ch>
In-Reply-To: <Y4JJ8Dyz7urLz/IM@lunn.ch>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Sun, 27 Nov 2022 12:42:17 +0900
Message-ID: <CAMZ6Rq+K+6gbaZ35SOJcR9qQaTJ7KR0jW=XoDKFkobjhj8CHhw@mail.gmail.com>
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
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Thank you for the review and the interesting comments on the parsing.

On. 27 Nov. 2022 at 02:37, Andrew Lunn <andrew@lunn.ch> wrote:
> > +struct es58x_sw_version {
> > +     u8 major;
> > +     u8 minor;
> > +     u8 revision;
> > +};
>
> > +static int es58x_devlink_info_get(struct devlink *devlink,
> > +                               struct devlink_info_req *req,
> > +                               struct netlink_ext_ack *extack)
> > +{
> > +     struct es58x_device *es58x_dev = devlink_priv(devlink);
> > +     struct es58x_sw_version *fw_ver = &es58x_dev->firmware_version;
> > +     struct es58x_sw_version *bl_ver = &es58x_dev->bootloader_version;
> > +     struct es58x_hw_revision *hw_rev = &es58x_dev->hardware_revision;
> > +     char buf[max(sizeof("xx.xx.xx"), sizeof("axxx/xxx"))];
> > +     int ret = 0;
> > +
> > +     if (es58x_sw_version_is_set(fw_ver)) {
> > +             snprintf(buf, sizeof(buf), "%02u.%02u.%02u",
> > +                      fw_ver->major, fw_ver->minor, fw_ver->revision);
>
> I see you have been very careful here, but i wonder if you might still
> get some compiler/static code analyser warnings here. As far as i
> remember %02u does not limit it to two characters.

I checked, none of gcc and clang would trigger a warning even for a
'make W=12'. More generally speaking, I made sure that my driver is
free of any W=12.
(except from the annoying spam from GENMASK_INPUT_CHECK for which my
attempts to silence it were rejected:
https://lore.kernel.org/all/20220426161658.437466-1-mailhol.vincent@wanadoo.fr/
).

> If the number is
> bigger than 99, it will take three characters. And your types are u8,
> so the compiler could consider these to be 3 characters each. So you
> end up truncating. Which you look to of done correctly, but i wonder
> if some over zealous checker will report it?

That zealous check is named -Wformat-truncation in gcc (I did not find
it in clang). Even W=3 doesn't report it so I consider this to be
fine.

> Maybe consider "xxx.xxx.xxx"?

If I do that, I also need to consider the maximum length of the
hardware revision would be "a/xxxxx/xxxxx" because the numbers are
u16. The declaration would become:

        char buf[max(sizeof("xxx.xxx.xxx"), sizeof("axxxxx/xxxxx"))];

Because no such warning exists in the kernel, I do not think the above
line to be a good trade off. I would like to keep things as they are,
it is easier to read. That said, I will add an extra check in
es58x_parse_sw_version() and es58x_parse_hw_revision() to assert that
the number are not bigger than 99 for the software version (and not
bigger than 999 for the hardware revision). That way the code will
guarantee that the truncation can never occur.

> Nice paranoid code by the way. I'm not the best at spotting potential
> buffer overflows, but this code looks good. The only question i had
> left was how well sscanf() deals with UTF-8.

It does not consider UTF-8. The %u is a _parse_integer_limit() in disguise.
  https://elixir.bootlin.com/linux/v6.1-rc6/source/lib/vsprintf.c#L3637
  https://elixir.bootlin.com/linux/v6.1-rc6/source/lib/vsprintf.c#L70

_parse_integer_limit() just check for ASCII digits so the first UTF-8
character would make the function return.
  https://elixir.bootlin.com/linux/v6.1-rc6/source/lib/kstrtox.c#L65

For example, this:
  "ＦＷ:03.00.06"
would fail parsing because sscanf() will not be able to match the
first byte of the UTF-8 'Ｆ' with 'F'.

Another example:
  "FW:０３.００.０６"
would also fail parsing because _parse_integer_limit() will not
recognize the first byte of UTF-8 '０' as a valid ASCII digit and
return early.

To finish, a very edge case:
  "FW:03.00.0６"
would incorrectly succeed. It will parse "FW:03.00.0" successfully and
will return when encountering the UTF-8 '６'. But I am not willing to
cover that edge case. If the device goes into this level of
perversion, I do not care any more as long as it does not result in
undefined behaviour.


Yours sincerely,
Vincent Mailhol
