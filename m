Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46D5E63B6E6
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 02:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234949AbiK2BLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 20:11:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234944AbiK2BLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 20:11:02 -0500
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D85C40464;
        Mon, 28 Nov 2022 17:11:00 -0800 (PST)
Received: by mail-pg1-f171.google.com with SMTP id 62so11533914pgb.13;
        Mon, 28 Nov 2022 17:11:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=678Rz0nlTDvk01JF3xLjph/IJ0sNRc7bNOs5ipe5d6A=;
        b=jf8Q1PR/4P9u3jYcvDFODSFtVeFcZ9uSnHLrScN2sz9Upc1Oqs631sH+3R2/gIBv1s
         kTGzc8w4Bx8ua7bsCEV9mcNWm6f0TMCs0+SmgAAe1Ghb0YKX/CGoo6RV8XsNAfzaIojZ
         3Bb1kOPXzPLlNR90BGayiTI1wvEHEz6EtMcxfWs2rfJVo+B46i2+4Roks16Amoao0OrH
         Bml9AuG+nsijPr3ZuZTalwn2AAWGpMhxDJNrWqHtIWp3yMeCBOJo5EAWBYNEQmD0sVHR
         E2RVghMCgN0i4sRWPxwRA6T6jcXvd16ueRNguPxkf0KnTjW9rm9/p5OHLo5PkCEJ1Byy
         53sQ==
X-Gm-Message-State: ANoB5pmdxRoOoXYjhbq/mWIwpk/Hvd8TkxAWGy4SgaZN31WVBcnLFiwF
        u7qovRdUoL/MKMIcpUvJjwjRImLp8nnliieRl7k=
X-Google-Smtp-Source: AA0mqf6g455B4kdX0QwF3SkDnGxNnFGnm/CGRMIZz8vQWon94mfO2b8uzYbTZ44P0SHZ1J702h8xcHpRTwPx/UOfwrs=
X-Received: by 2002:a62:1a8b:0:b0:572:7c58:540 with SMTP id
 a133-20020a621a8b000000b005727c580540mr36086790pfa.69.1669684259924; Mon, 28
 Nov 2022 17:10:59 -0800 (PST)
MIME-Version: 1.0
References: <20221129000550.3833570-1-mailhol.vincent@wanadoo.fr>
 <20221129000550.3833570-3-mailhol.vincent@wanadoo.fr> <CO1PR11MB5089EEF30335EC3CEDA8FCB7D6129@CO1PR11MB5089.namprd11.prod.outlook.com>
In-Reply-To: <CO1PR11MB5089EEF30335EC3CEDA8FCB7D6129@CO1PR11MB5089.namprd11.prod.outlook.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Tue, 29 Nov 2022 10:10:48 +0900
Message-ID: <CAMZ6RqKy0Jnybz933tzjAPCX88KhKMC67RaN01yoFJxekvgLHg@mail.gmail.com>
Subject: Re: [PATCH net-next v5 2/4] net: devlink: remove devlink_info_driver_name_put()
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Dimitris Michailidis <dmichail@fungible.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Shannon Nelson <snelson@pensando.io>,
        "drivers@pensando.io" <drivers@pensando.io>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Vadim Fedorenko <vadfed@fb.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vadim Pasternak <vadimp@mellanox.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "oss-drivers@corigine.com" <oss-drivers@corigine.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Shijith Thotton <sthotton@marvell.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jacob,

Thanks for the review!

On Tue. 29 Nov. 2022 at 09:23, Keller, Jacob E <jacob.e.keller@intel.com> wrote:
> > -----Original Message-----
> > From: Vincent Mailhol <vincent.mailhol@gmail.com> On Behalf Of Vincent
> > Mailhol
> > Sent: Monday, November 28, 2022 4:06 PM
> > To: Jiri Pirko <jiri@nvidia.com>; netdev@vger.kernel.org; Jakub Kicinski
> > <kuba@kernel.org>
> > Cc: David S . Miller <davem@davemloft.net>; Eric Dumazet
> > <edumazet@google.com>; Paolo Abeni <pabeni@redhat.com>; linux-
> > kernel@vger.kernel.org; Boris Brezillon <bbrezillon@kernel.org>; Arnaud Ebalard
> > <arno@natisbad.org>; Srujana Challa <schalla@marvell.com>; Kurt Kanzenbach
> > <kurt@linutronix.de>; Andrew Lunn <andrew@lunn.ch>; Florian Fainelli
> > <f.fainelli@gmail.com>; Vladimir Oltean <olteanv@gmail.com>; Michael Chan
> > <michael.chan@broadcom.com>; Ioana Ciornei <ioana.ciornei@nxp.com>;
> > Dimitris Michailidis <dmichail@fungible.com>; Yisen Zhuang
> > <yisen.zhuang@huawei.com>; Salil Mehta <salil.mehta@huawei.com>;
> > Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> > <anthony.l.nguyen@intel.com>; Sunil Goutham <sgoutham@marvell.com>; Linu
> > Cherian <lcherian@marvell.com>; Geetha sowjanya <gakula@marvell.com>;
> > Jerin Jacob <jerinj@marvell.com>; hariprasad <hkelam@marvell.com>;
> > Subbaraya Sundeep <sbhatta@marvell.com>; Taras Chornyi
> > <tchornyi@marvell.com>; Saeed Mahameed <saeedm@nvidia.com>; Leon
> > Romanovsky <leon@kernel.org>; Ido Schimmel <idosch@nvidia.com>; Petr
> > Machata <petrm@nvidia.com>; Simon Horman <simon.horman@corigine.com>;
> > Shannon Nelson <snelson@pensando.io>; drivers@pensando.io; Ariel Elior
> > <aelior@marvell.com>; Manish Chopra <manishc@marvell.com>; Jonathan
> > Lemon <jonathan.lemon@gmail.com>; Vadim Fedorenko <vadfed@fb.com>;
> > Richard Cochran <richardcochran@gmail.com>; Vadim Pasternak
> > <vadimp@mellanox.com>; Shalom Toledo <shalomt@mellanox.com>; linux-
> > crypto@vger.kernel.org; intel-wired-lan@lists.osuosl.org; linux-
> > rdma@vger.kernel.org; oss-drivers@corigine.com; Jiri Pirko
> > <jiri@mellanox.com>; Herbert Xu <herbert@gondor.apana.org.au>; Hao Chen
> > <chenhao288@hisilicon.com>; Guangbin Huang
> > <huangguangbin2@huawei.com>; Minghao Chi <chi.minghao@zte.com.cn>;
> > Shijith Thotton <sthotton@marvell.com>; Vincent Mailhol
> > <mailhol.vincent@wanadoo.fr>
> > Subject: [PATCH net-next v5 2/4] net: devlink: remove
> > devlink_info_driver_name_put()
> >
> > Now that the core sets the driver name attribute, drivers are not
> > supposed to call devlink_info_driver_name_put() anymore. Remove it.
> >
>
> You could combine this patch with the previous one so that in the event of a cherry-pick its not possible to have this function while the core inserts the driver name automatically.
>
> I think that also makes it very clear that there are no remaining in-tree drivers still calling the function.
>
> I don't have a strong preference if we prefer it being separated.

The first patch is already pretty long. I do not expect this to be
cherry-picked because it does not fix any existing bug (and if people
really want to cherry pick, then they just have to cherry pick both).
On the contrary, splitting makes it easier to review, I think.

Unless the maintainers as me to squash, I want to keep it as-is.


Yours sincerely,
Vincent Mailhol
