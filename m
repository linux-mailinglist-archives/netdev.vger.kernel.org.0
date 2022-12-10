Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B82648E3A
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 11:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiLJKvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 05:51:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbiLJKu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 05:50:58 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327451C12E
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 02:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qDFOCp8xGZjhvcpjBI18iWLXCGce+evVOb7dtZx8Uso=; b=0B1urZeCoUWDgjaGJvB0YgPbyB
        uyM9EowfkZXhG55iJGb6ir8Cp+8NXKNW4hjNMJFXUGpRzAX6bjG+4holdbU2Xqhx85MB27cxfRC/F
        0F6N+Zd/NZTNpjOtBBhSbTmMKoM/REsRR0OzVmhA32b1dH3ELo8k/TWtKVhKQr/KaI3E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p3xR4-004x1e-Kn; Sat, 10 Dec 2022 11:50:26 +0100
Date:   Sat, 10 Dec 2022 11:50:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        peppe.cavallaro@st.com, Voon Weifeng <weifeng.voon@intel.com>,
        Rayagond Kokatanur <rayagond@vayavyalabs.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Antonio Borneo <antonio.borneo@st.com>,
        Tan Tee Min <tee.min.tan@intel.com>
Subject: Re: [PATCH net] stmmac: fix potential division by 0
Message-ID: <Y5RkcmMxK0rmDHtz@lunn.ch>
References: <Y4f3NGAZ2rqHkjWV@gvm01>
 <Y4gFt9GBRyv3kl2Y@lunn.ch>
 <Y4iA6mwSaZw+PKHZ@gvm01>
 <Y4i/Aeqh94ZP/mA0@lunn.ch>
 <20221206182823.08e5f917@kernel.org>
 <Y5CZp0QJVejOpWSY@lunn.ch>
 <87v8mne09m.fsf@kurt>
 <Y5EvKciMg3Nkj8ln@lunn.ch>
 <Y5GuHEn161H35/xZ@gvm01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5GuHEn161H35/xZ@gvm01>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 10:27:56AM +0100, Piergiorgio Beruto wrote:
> > > 
> > > Here's the Altera manual:
> > > 
> > >  https://www.intel.com/content/www/us/en/docs/programmable/683126/21-2/functional-description-of-the-emac.html
> > > 
> > > Table 183 shows the minimum PTP frequencies and also states "Therefore,
> > > a higher PTP clock frequency gives better system performance.".
> > > 
> > > So, I'd say using a clock of 2.5MHz seems possible, but will result in
> > > suboptimal precision.
> > 
> > Thanks for the info. So i seems like the correct fix is to camp to
> > 0xff, rather than mask with 0xff.

> Andrew, given your comment, do you wish me to re-post the patch with
> this fix? Or wait for more feedback first?

Please post a patch. Often the only way to get feedback is to break systems :-(

In this case, clamping actually seems like it could fix systems, not
break them.

      Andrew
