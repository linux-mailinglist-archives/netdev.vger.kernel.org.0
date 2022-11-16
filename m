Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F5062B006
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 01:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbiKPAad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 19:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiKPAac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 19:30:32 -0500
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C538B1F600;
        Tue, 15 Nov 2022 16:30:31 -0800 (PST)
Received: by mail-pg1-f180.google.com with SMTP id f3so8738293pgc.2;
        Tue, 15 Nov 2022 16:30:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZYHGI3jLNlZEliAN2rIJksm2B5bhLJHcux1Z9oNJmdY=;
        b=UYgYP/fHQ+aREmugo3hri0nH3SoWPpREWafSYMtt7Vcag6rRLR9wCWIZILtJTxzK2Z
         fx5f5pzCOkiAsZjZPm3p8B5IkaLzrc/hlrD39uUtU4NQHEAEktKN76JzQkXX+I4UGDYi
         deDZQ29w87aF6VDZL5wZ2IdAKJH+fJd2epv4VEgPkB0Uf9vZ5UZVCXk54Sx1c0Un6fF4
         aWQj4cZesQuvi8aUWjSnYiZaIluwTqmWWWlTn2QYWiA7RY1V7tJkOPeYOT7OQ6SDDd6g
         G1Y6FfjrztTBX44o/5zHH1edaDmdalgtLzImds201uVtzM1pq+/DvrnF0d5IUNvNRkj0
         8ESw==
X-Gm-Message-State: ANoB5pnfI3iMFESPEAfuB+btoEMCB71RKMOdeMbKGU76SSSBg8eRfENz
        CB6z8eZOkPAyd46o6QG9yN5SuQqsmgJ0pXlrKw25kXQJusSU2Q==
X-Google-Smtp-Source: AA0mqf4EyP5874AvCyj085gpv3Bcq+rDW4K9uchgSQtJJbGOZbhhyZK5iQ8YmUdyTOnHHA6U8oje2F1HRUPPpoZdpMk=
X-Received: by 2002:aa7:8759:0:b0:56b:a795:e99c with SMTP id
 g25-20020aa78759000000b0056ba795e99cmr20849785pfo.14.1668558631188; Tue, 15
 Nov 2022 16:30:31 -0800 (PST)
MIME-Version: 1.0
References: <20221111030838.1059-1-mailhol.vincent@wanadoo.fr>
 <20221113083404.86983-1-mailhol.vincent@wanadoo.fr> <20221114212718.76bd6c8b@kernel.org>
 <CAMZ6RqJ-2_ymLiGuObmBLRDpNNy0ZpMCeRU2qgNPvq2oArnX8A@mail.gmail.com> <20221115082830.61fffeab@kernel.org>
In-Reply-To: <20221115082830.61fffeab@kernel.org>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Wed, 16 Nov 2022 09:30:19 +0900
Message-ID: <CAMZ6Rq+Vdbt0rGwS1zCak4THPk=PY1DPxtUxXmLbvgFnnMmV8w@mail.gmail.com>
Subject: Re: [PATCH net-next v3] ethtool: doc: clarify what drivers can
 implement in their get_drvinfo()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Petr Machata <petrm@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        linux-kernel@vger.kernel.org,
        Leon Romanovsky <leonro@mellanox.com>,
        Leon Romanovsky <leonro@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue. 16 Nov. 2022 at 01:28, Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 15 Nov 2022 16:52:39 +0900 Vincent MAILHOL wrote:
> > - * @fw_version: Firmware version string; may be an empty string
> > - * @erom_version: Expansion ROM version string; may be an empty string
> > + * @fw_version: Firmware version string; drivers can set it; may be an
> > + *     empty string
> > + * @erom_version: Expansion ROM version string; drivers can set it;
> > + *     may be an empty string
>
> "drivers can set it" rings a little odd to my non-native-English-
> -speaker's ear. Perhaps "driver-defined;" ? Either way is fine, tho.

I am not a native speaker either so I won't argue here. Changed to
"driver defined" in v4.

> >   * @bus_info: Device bus address.  This should match the dev_name()
> >   *     string for the underlying bus device, if there is one.  May be
> >   *     an empty string.
> > @@ -180,9 +182,10 @@ static inline __u32 ethtool_cmd_speed(const
> > struct ethtool_cmd *ep)
> >   * Users can use the %ETHTOOL_GSSET_INFO command to get the number of
> >   * strings in any string set (from Linux 2.6.34).
> >   *
> > - * Drivers should set at most @driver, @version, @fw_version and
> > - * @bus_info in their get_drvinfo() implementation.  The ethtool
> > - * core fills in the other fields using other driver operations.
> > + * Majority of the drivers should no longer implement the
> > + * get_drvinfo() callback.  Most fields are correctly filled in by the
> > + * core using system information, or populated using other driver
> > + * operations.
>
> SG! Good point on the doc being for the struct. We can make the notice
> even stronger if you want by saying s/Majority of the/Modern/

"Modern drivers should no longer..." sounds like an unconditional
interdiction. I changed it to "Modern drivers no longer have to..." to
nuance the terms and suggest that they remain some edge cases.

I sent the v4 but messed up the In-Reply-To tag so it became a new thread:
https://lore.kernel.org/netdev/20221115233524.805956-1-mailhol.vincent@wanadoo.fr/T/#u


Yours sincerely,
Vincent Mailhol
