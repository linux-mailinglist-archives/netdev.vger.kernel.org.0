Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8364BC562
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 05:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239581AbiBSEon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 23:44:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbiBSEom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 23:44:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AED625B6FF;
        Fri, 18 Feb 2022 20:44:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAD5BB827A7;
        Sat, 19 Feb 2022 04:44:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445E7C004E1;
        Sat, 19 Feb 2022 04:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645245860;
        bh=mcFRwpcou2f0jfEOUOdjkrmzLbcaBD1AsEOi6p51Dtg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=un4bOyPF93khUlydyZsagiewxlkQEciXte7SjYs9SloDP3kQhQjMlwoMP84EUJkWz
         RcYbVtKS7wdwTAUt6gh8cZzjKg/suJdiFZyhAGAdFzZ9JlH+JYAscQia499En9S0jt
         C8tgksfYvKUYFJ0kDMLe2l9Rv3RtPWEi4ERG3ZMHtm+bsvkL5SEy+SclDn7TjrUcur
         4k3wCnNnZYU9B05QcAyuF6JvnYexG40rNVSjLs8HouopBMNnqayZq6LrwppiE8GSPX
         Rj4tyPjhrbbQ3bnsiRSWDNUTnlUokpAOSjnGoE2dNdLio4I0DsPHiO/73+1c2PE9YM
         ilb/3He5KsAFQ==
Date:   Fri, 18 Feb 2022 20:44:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcin Wojtas <mw@semihalf.com>,
        Jeremy Linton <jeremy.linton@arm.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [BUG/PATCH v3] net: mvpp2: always set port pcs ops
Message-ID: <20220218204419.63962fbc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAPv3WKe-=+zqkNKD1rkk0uU6t5Z=aixeHD+fp8tZqbGn0sgyZA@mail.gmail.com>
References: <20220214231852.3331430-1-jeremy.linton@arm.com>
        <CAPv3WKe-=+zqkNKD1rkk0uU6t5Z=aixeHD+fp8tZqbGn0sgyZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 19 Feb 2022 00:49:27 +0100 Marcin Wojtas wrote:
> wt., 15 lut 2022 o 00:18 Jeremy Linton <jeremy.linton@arm.com> napisa=C5=
=82(a):
> > Booting a MACCHIATObin with 5.17, the system OOPs with
> > a null pointer deref when the network is started. This
> > is caused by the pcs->ops structure being null in
> > mcpp2_acpi_start() when it tries to call pcs_config().
> >
> > Hoisting the code which sets pcs_gmac.ops and pcs_xlg.ops,
> > assuring they are always set, fixes the problem.

> > Fixes: cff056322372 ("net: mvpp2: use .mac_select_pcs() interface")
> > Suggested-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>

> You can add my:
> Reviewed-by: Marcin Wojtas <mw@semihalf.com>

Perfect, thanks everyone!=20

It's now 5a2aba71cd26 ("net: mvpp2: always set port pcs ops") in net.
