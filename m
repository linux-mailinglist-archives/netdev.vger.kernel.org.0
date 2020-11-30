Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28F52C8B20
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 18:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387603AbgK3RcI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 12:32:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387521AbgK3RcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 12:32:07 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD31C0613CF
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 09:31:27 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id t8so10843386pfg.8
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 09:31:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JrZHBCSgO9uzCa4FiIu4F6rVrfCNjy8joFCsTC+NJ6c=;
        b=zJfQgJPpdmL2tVK8oeypKvVI2EfbBc8oOAtMCvLj+kI3g5i5m1JN+BRR+dXVP18R1B
         vqtTrPmf9gQcOXFk132nyvL2ozRN98+4+BOwzct4oocOTwEiZZEZyEUm5XSO6FTYS487
         8+o+sD1msKy9cfcjCVH4n6oL8scmVwoU+h7tWkj5SNXlV8xPrN2zz5hk/RIeUyYzwNFH
         9jwKyblwCrq73nuFW5JThMpClHC1p/nR87EHxoCDnnT3W3boBnfON6U9fRP8Y/EE1EUB
         NbCIIwCSbIvRk7XXz8TxMCWNueskLTwN4rGPAYK1TyEF6EiZDSw9PYVJbfxQDLKVu5nf
         6zFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JrZHBCSgO9uzCa4FiIu4F6rVrfCNjy8joFCsTC+NJ6c=;
        b=i68In4UZe5Xx7pxIl5ZBYmztq5QrODmFi925JSQiQoXO7XDTVyCSxDQkrXuzNpL8l6
         iAzq1yCzaResw+NLaTfp7BiHBvCskd3EHYbdBMOgFrZkPR1zp1b57ODPNkYZtPlP3KUY
         2FzQGXpNZxdb9W5774zVoycIDhecHOMWp+i8ESnnasGKCmra7gO1vcU4cblZw7/2ewk1
         jyE7q7JYoKA+6nzeH2euoe8Ik7GngEheJ5D5al15dIK8eWIF1azyMm+/anqcgMf1EUHX
         /XHuTTNkzC6zaa6BJrm4R1IpWjSdVgPTnW8N7oT7zwca9z8/VT6RUxeH8Ss4za4oGd+u
         OMtw==
X-Gm-Message-State: AOAM533yQy3i4l6VMBsZDZZ48vYhp8EfbAeMS/k16O5UFuFFd1mItE6I
        qlOQNIRpQ4g5ALntEzqJguU6tk636P2PFHee
X-Google-Smtp-Source: ABdhPJy78r/+NP8e4ermC7mViZ54d6dazRjCjBVWw3G5LIBVcW2rCUVvFKcz+/43DBm7zmtFJmH1xQ==
X-Received: by 2002:aa7:973d:0:b029:18b:23db:7711 with SMTP id k29-20020aa7973d0000b029018b23db7711mr19634337pfg.13.1606757487329;
        Mon, 30 Nov 2020 09:31:27 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id r66sm17631363pfc.114.2020.11.30.09.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 09:31:27 -0800 (PST)
Date:   Mon, 30 Nov 2020 09:31:13 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 4/5] misc: fix compiler warning in ifstat and nstat
Message-ID: <20201130093113.125c0154@hermes.local>
In-Reply-To: <efb6a29fef0e4ca1845956701f670b4b@AcuMS.aculab.com>
References: <20201130002135.6537-1-stephen@networkplumber.org>
        <20201130002135.6537-5-stephen@networkplumber.org>
        <efb6a29fef0e4ca1845956701f670b4b@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Nov 2020 09:18:59 +0000
David Laight <David.Laight@ACULAB.COM> wrote:

> From: Stephen Hemminger
> > Sent: 30 November 2020 00:22
> > 
> > The code here was doing strncpy() in a way that causes gcc 10
> > warning about possible string overflow. Just use strlcpy() which
> > will null terminate and bound the string as expected.
> > 
> > This has existed since start of git era so no Fixes tag.
> > 
> > Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> > ---
> >  misc/ifstat.c | 2 +-
> >  misc/nstat.c  | 3 +--
> >  2 files changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/misc/ifstat.c b/misc/ifstat.c
> > index c05183d79a13..d4a33429dc50 100644
> > --- a/misc/ifstat.c
> > +++ b/misc/ifstat.c
> > @@ -251,7 +251,7 @@ static void load_raw_table(FILE *fp)
> >  			buf[strlen(buf)-1] = 0;
> >  			if (info_source[0] && strcmp(info_source, buf+1))
> >  				source_mismatch = 1;
> > -			strncpy(info_source, buf+1, sizeof(info_source)-1);
> > +			strlcpy(info_source, buf+1, sizeof(info_source));
> >  			continue;  
> 
> ISTM that once it has done a strlen() it ought to use the length
> for the later copy.
> 
> I don't seem to have the source file (I'm guessing it isn't in the
> normal repo), but is that initial strlen() guaranteed not to return
> zero?
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

All this is in the regular iproute2 repo
