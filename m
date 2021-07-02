Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945233B9C86
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 08:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhGBG5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 02:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbhGBG5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 02:57:32 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10AD5C061762;
        Thu,  1 Jul 2021 23:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=+qqL3stcL81zEanpn177V008fhVVVkp46u6dRYOk8jE=;
        t=1625208900; x=1626418500; b=MPZAzch1bIKh9tGzRdo3GF5LQgPdbEUhuzDTvOfBZmSIjsK
        B4AIn5ItCPMUldEfC2Lifz51HM6Rreqdv/+S9x2Pj64rineD1Kp7L2gvGMtwcXvLnp2nxXewBPPeZ
        8f/iBDYF1riboecutohjZwUF97E933/gHSqT9Dhsjz939q6F0Mkfef1QXIyPGLb9hKKgO705kY8Ev
        1Zkb0uqi9iZD91GcYuW70gU5WV/x5+53xgYl9UHHDOIRgs0cXCC1sLJOvvYlMFNTFiIgY9MVKO+aI
        R/MPbzPwhB98E3WKKHl8NC2lEiLaIluJdq16/ML8r+DKxw1da7g7Tce6w+zwClQQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lzD4g-00EYPk-1G; Fri, 02 Jul 2021 08:54:54 +0200
Message-ID: <56afa72ef9addbf759ffb130be103a21138712f9.camel@sipsolutions.net>
Subject: Re: Posible memory corruption from "mac80211: do not accept/forward
 invalid EAPOL frames"
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Davis Mosenkovs <davikovs@gmail.com>, Felix Fietkau <nbd@nbd.name>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Fri, 02 Jul 2021 08:54:53 +0200
In-Reply-To: <CAHQn7pJY4Vv_eWpeCvuH_C6SHwAvKrSE2cQ=cTir72Ffcr9VXg@mail.gmail.com> (sfid-20210701_225432_954258_7B6FE103)
References: <CAHQn7pKcyC_jYmGyTcPCdk9xxATwW5QPNph=bsZV8d-HPwNsyA@mail.gmail.com>
         <a7f11cc2-7bef-4727-91b7-b51da218d2ee@nbd.name>
         <YNtdKb+2j02fxfJl@kroah.com>
         <872e3ea6-bbdf-f67c-58f9-4c2dafc2023a@nbd.name>
         <CAHQn7pJY4Vv_eWpeCvuH_C6SHwAvKrSE2cQ=cTir72Ffcr9VXg@mail.gmail.com>
         (sfid-20210701_225432_954258_7B6FE103)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-07-01 at 23:54 +0300, Davis Mosenkovs wrote:
> 
> > > > It seems that the 4.4 backport is broken. The problem is the fact that
> > > > skb_mac_header is called before eth_type_trans(). This means that the
> > > > mac header offset still has the default value of (u16)-1, resulting in
> > > > the 64 KB memory offset that you observed.

Agree.

> > > > I think that for 4.4, the code should be changed to use skb->data
> > > > instead of skb_mac_header. 4.9 looks broken in the same way.
> > > > 5.4 seems fine, so newer kernels should be fine as well.

Also agree.

> > > Thanks for looking into this, can you submit a patch to fix this up in
> > > the older kernel trees?
> > Sorry, I don't have time to prepare and test the patches at the moment.
> > 
> If testing procedure mentioned in my first email is sufficient (and
> using skb->data is the correct solution in kernel trees where current
> code doesn't work properly), I can make and test the patches.
> Should I do that?

Yes, please do.

Thanks,
johannes

