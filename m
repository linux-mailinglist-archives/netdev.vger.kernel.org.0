Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39D12161D0
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 01:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgGFXDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 19:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbgGFXDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 19:03:12 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A852DC061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 16:03:11 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id e15so36732975edr.2
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 16:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JWkCpXScroA2bJSzEtEb5Yx/DaaZTadHtRitzt1JbJk=;
        b=eXzmxyzyTT3PIK+pxOidovOVfpJwX+le2BRxAUkRTWin6it3WIFK6+a3Nh3PY9r2cL
         6LwABLQoQkv0i5ezZNuB9pyxD87PPyrhRSxxcjWma7McZv6RZsY6v7H9XXyEJcJ7Iu2i
         WochK5aSwsbj36ltziyCCaBhG/RFsGfcGOn6zctvErPW6YLxzwNwoU24kee291+fZI64
         oBoW9loEU+VXjqO9Dl4LQzfCIGfNdKrFfH9vk6kCZjDuLV0aiKcdE3vMoER6YzuYjz22
         hQqID/+mDEJBh2fBiFYQtEZ92u8r/BSMPVgBBSNf1Z4++h9mIExY7zsepa1PDFM+0adg
         /4zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JWkCpXScroA2bJSzEtEb5Yx/DaaZTadHtRitzt1JbJk=;
        b=XEyYkieF/S9jAkfrB4pbVH+7zyd2f15wTH6WbHJWXeblmrJk8Q4IB89VtRYFJ406Xr
         Y0Tua15IrHYBRFe+C4OHAQtN5Wzk/rtu1XEwZE8W7j22mglTHzuNQ5F2pMU+H3HPVTgO
         B/hMljrMyhCEqvMBG0lphmSqIwrmB1XCgOmWN6bFleK5dYGaSbAimTuQs2tJnUbW/O8Q
         ro3GisMf/v6OuhfX32v+jcEJjaU4qo51srAdOu765yLAYfd8Ih9jdxajvriHt6qW6DvU
         n71dG5jArB4QNUDaflzO3gKpvd9HvauWIS5lvMA1tnucExxjX0smrhhQNbZVEcIATURf
         R27g==
X-Gm-Message-State: AOAM530zVvfv6uKYBW1j8jvnPS0P9SIsGLNHdpZd6t4N69eHz2ZJ4tvn
        afaxdTv2thnhke8ceSE0E7oFL4z+slz9jv7fDu4N2Q==
X-Google-Smtp-Source: ABdhPJyVuFki/ZtPZ4Ma9OT4MWhdXP1IudP5hfiY2MCbZVdr2Z7zP+1YqvmsEtc5UN/mvfl81WhK9wDNaeYvf62GYO8=
X-Received: by 2002:aa7:d043:: with SMTP id n3mr60634615edo.102.1594076588926;
 Mon, 06 Jul 2020 16:03:08 -0700 (PDT)
MIME-Version: 1.0
References: <57185aae-e1c9-4380-7801-234a13deebae@linux.intel.com>
 <20200524063519.GB1369260@kroah.com> <fe44419b-924c-b183-b761-78771b7d506d@linux.intel.com>
 <s5h5zcistpb.wl-tiwai@suse.de> <20200527071733.GB52617@kroah.com>
 <20200629203317.GM5499@sirena.org.uk> <20200629225959.GF25301@ziepe.ca>
 <20200630103141.GA5272@sirena.org.uk> <20200630113245.GG25301@ziepe.ca>
 <936d8b1cbd7a598327e1b247441fa055d7083cb6.camel@linux.intel.com>
 <20200701065915.GF2044019@kroah.com> <8b88749c197f07c7c70273614dd6ee8840b2b14d.camel@linux.intel.com>
In-Reply-To: <8b88749c197f07c7c70273614dd6ee8840b2b14d.camel@linux.intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 6 Jul 2020 16:02:57 -0700
Message-ID: <CAPcyv4g9xCMh5cQF0qbObpHX5ckMK_SWPO12BcXF2ijn8MnckA@mail.gmail.com>
Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF client
To:     Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>, nhorman@redhat.com,
        sassmann@redhat.com, Fred Oh <fred.oh@linux.intel.com>,
        lee.jones@linaro.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 6:44 AM Ranjani Sridharan
<ranjani.sridharan@linux.intel.com> wrote:
[..]
> > > Hi Jason,
> > >
> > > We're addressing the naming in the next version as well. We've had
> > > several people reject the name virtual bus and we've narrowed in on
> > > "ancillary bus" for the new name suggesting that we have the core
> > > device that is attached to the primary bus and one or more sub-
> > > devices
> > > that are attached to the ancillary bus. Please let us know what you
> > > think of it.
> >
> > I'm thinking that the primary person who keeps asking you to create
> > this
> > "virtual bus" was not upset about that name, nor consulted, so why
> > are
> > you changing this?  :(
> >
> > Right now this feels like the old technique of "keep throwing crap at
> > a
> > maintainer until they get so sick of it that they do the work
> > themselves..."
>
> Hi Greg,
>
> It wasnt our intention to frustrate you with the name change but in the
> last exchange you had specifically asked for signed-off-by's from other
> Intel developers. In that process, one of the recent feedback from some
> of them was about the name being misleading and confusing.
>
> If you feel strongly about the keeping name "virtual bus", please let
> us know and we can circle back with them again.

Hey Greg,

Feel free to blame me for the naming thrash it was part of my internal
review feedback trying to crispen the definition of this facility. I
was expecting the next revision to come with the internal reviewed-by
and an explanation of all the items that were changed during that
review.

Ranjani, is the next rev ready to go out with the review items
identified? Let's just proceed with the current direction of the
review tags that Greg asked for, name changes and all, and iterate the
next details on the list with the new patches in hand.
