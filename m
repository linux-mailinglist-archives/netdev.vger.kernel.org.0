Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E0C29DAC9
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390504AbgJ1XbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390419AbgJ1XbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 19:31:01 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21483C0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 16:31:01 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id n15so863748wrq.2
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 16:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:to:cc:subject:from:date:message-id
         :in-reply-to;
        bh=W1Dl+QaPfxMTjj4UulyNUgtvAyjIHGDf68WllbdWntY=;
        b=qf1+AW+eAqZhroz3A8tzHdJbVfa1vzHWorxkzrLRNQHfEBN/GPwZyMdN8PrVlF1d6b
         pxMvfnwViZ4EcG+GghVFBTEOKoySLVVQghypz56fTiCtND5NmoJl/feWWx1p8N6vzCvL
         lxJ7EZ6iX5+Yg8DyzbNuOHMCqDlZf95sZx3U5AYUTsbHzjEfX72j/DKn8jq1I13Zz1aI
         cTXffUXdsvUy8vVVEPC5X3WhZCA73I1nA+l6bIuIVuM3C2p78FjYzIDkMLmbATkBnTFd
         zWF0ooS8RxBAgDqId5V2jeEs+L9Ykaj5QQnMI/4ZV8TL+P9u2I5ojREad2QCKr/ZxVde
         4o8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:to:cc:subject:from
         :date:message-id:in-reply-to;
        bh=W1Dl+QaPfxMTjj4UulyNUgtvAyjIHGDf68WllbdWntY=;
        b=OJwFlM0h0Jvb+iebiybI2V08IOhf5sgTbQCiQZ9OsbYZyX9i++4aY3TVXzvYiB2xDa
         sCy1MIn1qTcJEQ2vy3i7jWmWXskJtiDjWDKiMw5LmhrrhEFPIIxcg/UasXymRubqqKhJ
         zobVzDx+CqxBemMdC+mldhXf+KQmr1NIJYDpE7yl8lXUjO1nk1o6RA9pl4AUdv4wp5pF
         ByS6OLcUAURwZv7MRZiSkDa4Tn+/kCMVk8XRV/I+p83UsViZglfwp3RcIYK7KU2nUsFf
         2791A3w1LvKh6ZmRgRjDF9Ib6zhJCa6XKY26fkbrCa774KKQguQjkO9LfZDBhVsJ0OzU
         tCNA==
X-Gm-Message-State: AOAM53191ev/DZs5R88EC24fm1ACOLvtFmj1jORBWByS1kRFIm3nEQQQ
        mhtarlwudTtNtdT0qz8VTwVEO755yfbGvyPO
X-Google-Smtp-Source: ABdhPJwqI2o4Ra4GRnM34qnuAYmkCreylO7kzegAmTUsIBlZRxzOtkvxbqv5j+WDGhg196NSZEiecw==
X-Received: by 2002:a05:651c:124f:: with SMTP id h15mr3240503ljh.123.1603894506788;
        Wed, 28 Oct 2020 07:15:06 -0700 (PDT)
Received: from localhost (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id g16sm542555lfd.59.2020.10.28.07.15.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 07:15:06 -0700 (PDT)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
To:     "Vladimir Oltean" <olteanv@gmail.com>
Cc:     <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH 2/4] net: dsa: link aggregation support
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
Date:   Wed, 28 Oct 2020 15:03:15 +0100
Message-Id: <C6OKWDSV75FQ.1YBMNPWQ63810@wkz-x280>
In-Reply-To: <20201028005855.2xgvheizr5cz6s3a@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed Oct 28, 2020 at 3:58 AM CET, Vladimir Oltean wrote:
> When you use dsa_broadcast, it is reachable from _all_ switch trees, not
> from "the" switch tree. This was added to support "islands" of
> inter-compatible DSA switches separated by other DSA switches with
> incompatible taggers. Not sure if it was a voluntary decision to use
> that as opposed to plain dsa_port_notify. Not a problem either way.

You're right, I want dsa_port_notify. I will change it and also remove
the tree_index from the notifier info struct.

> > +	/* For multichip systems, we must ensure that each hash bucket
> > +	 * is only enabled on a single egress port throughout the
> > +	 * whole tree.
>
> Or else?
> I don't really understand this statement.

Or else we will send the same packet through multiple ports. I.e. if
we have swp0..2 in a LAG with bucket config like this:

Bucket#  swp0  swp1  swp2
      0     Y     n     n
      1     Y     n     n
      2     Y     n     n
      3     Y     Y     n
      4     n     Y     n
      5     n     Y     n
      6     n     n     Y
      7     n     n     Y

Packets that hash to bucket 3 would be sent out through both swp0 and
swp1, which the receiver would interpret as two distinct packets with
the same contents.

I will reword it to make it more clear.

> > +	struct dsa_lag *lag;
> > +	unsigned long busy =3D 0;
>
> Reverse Christmas notation please?

I have no excuses. :)

> > -	if (obj->orig_dev !=3D dev)
> > +	if (!(obj->orig_dev =3D=3D dev ||
> > +	      (dp->lag && obj->orig_dev =3D=3D dp->lag->dev)))
>
> A small comment here maybe?

Yep, will do.

Thanks,
Tobias
