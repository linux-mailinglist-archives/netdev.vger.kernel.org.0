Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66ACD63DA20
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 17:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiK3QA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 11:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiK3QAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 11:00:55 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5828E2D76C;
        Wed, 30 Nov 2022 08:00:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=OUNGczKLtoTFfHGD0SF31C8NuWnHJPpbTjgMWEvvmPg=; b=ufOCFYwR5jmgFZ3usHJpYBuEmt
        aiF0jisuM22MFMausqtbapSe3Pz2QEGhWVSNaYyVnah0yrEUxcDpCu2+n4jNBC07GQFULP0628044
        qzhQ9UbsD9ueFdAibw2zUEObHsFLRzVca2ISt2M5nFK6l7/5ZhJEqKNp0DrjzW9acFjc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0PVp-003yHF-B4; Wed, 30 Nov 2022 17:00:41 +0100
Date:   Wed, 30 Nov 2022 17:00:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jerry.Ray@microchip.com
Cc:     olteanv@gmail.com, f.fainelli@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3] dsa: lan9303: Add 3 ethtool stats
Message-ID: <Y4d+KcqQQzKBpo8z@lunn.ch>
References: <20221128205521.32116-1-jerry.ray@microchip.com>
 <20221128210515.kqvdshlh3phmdpxx@skbuf>
 <MWHPR11MB1693C29AFEAE5386D0EE3AEFEF159@MWHPR11MB1693.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1693C29AFEAE5386D0EE3AEFEF159@MWHPR11MB1693.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 03:57:35PM +0000, Jerry.Ray@microchip.com wrote:
> >>  static void lan9303_get_ethtool_stats(struct dsa_switch *ds, int port,
> >>                                     uint64_t *data)
> >>  {
> >>       struct lan9303 *chip = ds->priv;
> >> -     unsigned int u;
> >> +     unsigned int i, u;
> >>
> >>       for (u = 0; u < ARRAY_SIZE(lan9303_mib); u++) {
> >>               u32 reg;
> >>               int ret;
> >>
> >> -             ret = lan9303_read_switch_port(
> >> -                     chip, port, lan9303_mib[u].offset, &reg);
> >> -
> >> +             /* Read Port-based MIB stats. */
> >> +             ret = lan9303_read_switch_port(chip, port,
> >> +                                            lan9303_mib[u].offset,
> >> +                                            &reg);
> >
> >Speaking of unrelated changes...
> >
> 
> Cleaning up a warning generated from checkpatch

Cleanups a good, but please put them in a patch of their own.

https://www.kernel.org/doc/html/v4.10/process/submitting-patches.html#separate-your-changes

   3) Separate your changes

   Separate each logical change into a separate patch.

Andrew

