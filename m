Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF1B4D36CB
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237555AbiCIRFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 12:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239253AbiCIREt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 12:04:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C224D616
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 08:54:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 986FA61B45
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 16:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A5FC340EC;
        Wed,  9 Mar 2022 16:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646844849;
        bh=I28x4vPF6t0uPnVCoRS7Xy/BBFkl8YasGtd2HqBon0w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aBB/J2GWubmu81Xw8+Hj0tol8yKUu6oIJUzVAufx4pIriWsFEXub8PYQRoidt/c/z
         dSVZqNVi8mbn7pVTFJbzd3ZeH/F43u6rdvZOoXtJjHxVDDR7N2WptT1owojV2pSrxP
         WhunHJglU8+lz+xSs1tMlhRB3UZM+jO1uxVXe8+BQQGGqdEHPLB3mUGl4MkBwd8RHr
         qe1Wy3IUN45UvDm4svyS2fVnXEAppR4pbEs38ihPVvtPMItn7hW/xuNM+PbtRbtqqz
         UtL3EyfjJeyW/e9iFILjSmW1qGA8efFbWRSxDvZ18hi81pVDytpPn2D7mL64sbKdMs
         SOM8LE36UQhZw==
Date:   Wed, 9 Mar 2022 08:54:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Laight <David.Laight@aculab.com>,
        netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: [RFC net-next] tcp: allow larger TSO to be built under overload
Message-ID: <20220309085407.3ffd2851@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CADVnQykz55R-UVu4RbP=uYBaK309X7oCpDk=JyUy=VudJ7z+ZA@mail.gmail.com>
References: <20220308030348.258934-1-kuba@kernel.org>
        <CANn89iLoWOdLQWB0PeTtbOtzkAT=cWgzy5_RXqqLchZu1GziZw@mail.gmail.com>
        <652afb8e99a34afc86bd4d850c1338e5@AcuMS.aculab.com>
        <CANn89iL0XWF8aavPFnTrRazV9T5fZtn3xJXrEb07HTdrM=rykw@mail.gmail.com>
        <20220308161821.45cb17bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CADVnQykz55R-UVu4RbP=uYBaK309X7oCpDk=JyUy=VudJ7z+ZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Mar 2022 11:42:24 -0500 Neal Cardwell wrote:
> > SGTM! The change may cause increased burstiness, or is that unlikely?
> > I'm asking to gauge risk / figure out appropriate roll out plan.  
> 
> In theory it could cause increased burstiness in some scenarios, but
> in practice we have used this min_rtt-based TSO autosizing component
> in production for about two years, where we see improvements in load
> tests and no problems seen in production.

Perfect, sounds safe to put it in the next point release here, then.
Thank you!
