Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5B94B9E77
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 12:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239671AbiBQLSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 06:18:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234011AbiBQLSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 06:18:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 078E1125596
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 03:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645096695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rluMdUX42Bz6AnNz4rNBAMY3uivA4hbkOP/qxqIto1I=;
        b=JMc/pX6ESEl+8bRahrUz7hMLa2Qw0iVytobBJ2OA5Cgop5Ji5UhRHRRUMfDIIYwGEMwCYH
        LrFhrqiDbaxBJZjzGApi4RbsoqNBpPG4dGRPZlF9wsIff/wm7ljSmIyCOCw8NN548rv3A1
        5MTFu00yq0tKgBDC1vNBc0ZjOveKRps=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-512-j-eCUzACPviXjpJ7DpzliA-1; Thu, 17 Feb 2022 06:18:14 -0500
X-MC-Unique: j-eCUzACPviXjpJ7DpzliA-1
Received: by mail-wr1-f71.google.com with SMTP id v17-20020adf8b51000000b001e336bf3be7so2177609wra.1
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 03:18:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rluMdUX42Bz6AnNz4rNBAMY3uivA4hbkOP/qxqIto1I=;
        b=6fdgrRJhByEnw6pDsGsSbjv4PqxoG3xukAtz9Pxdf+cbOCT0Fmapy3n3oUhG2AHMrq
         mAh59LthHKZWEvzJIv9kOsXDGw8upRZ7sayowC/8Y2IwiuCyzQAqW71BFsG6/aCCCDzg
         CzqsygVml5e0o/C2cNC/NSewPpE97RWu8Ww9/dR3yNZ7Mbfyvt/1xRyltrA68clxxGGt
         VG6u3YHEoPusMr+1EQcPUotlnPd4i7jJAPLZyv8dcPYw2q2nZxtXGp7rjShhNsT+pzqC
         k0iYKPF6G1zT40wXNWMUyydcFs18K4xX8bTEVjMaGOIfi6XTXnULCRxWz6cUCLdK4PLL
         5iVA==
X-Gm-Message-State: AOAM532Z4I8sqf8yRsFY57P0msUHAAxi7x6sFgfNK4/WT1d+H6a6VOa0
        FCQxn/Ok6rPDhpox8QkVkON7R5vlU+0FpUHkKr908dJQezmOe86GzQ0sMFc974zq5u93xr0tBv/
        vMEfWbd4wbHrM/rgk
X-Received: by 2002:a5d:6d85:0:b0:1e2:f9f9:ab97 with SMTP id l5-20020a5d6d85000000b001e2f9f9ab97mr1876429wrs.469.1645096692793;
        Thu, 17 Feb 2022 03:18:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzg4Fuag+kZ16DSH9MN8SQ1oKWHrLC6hiWspAJXu/pLoNH68nFkZtjFc4nGqy1iX+uafMSjQA==
X-Received: by 2002:a5d:6d85:0:b0:1e2:f9f9:ab97 with SMTP id l5-20020a5d6d85000000b001e2f9f9ab97mr1876415wrs.469.1645096692540;
        Thu, 17 Feb 2022 03:18:12 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id p16sm1064696wmq.18.2022.02.17.03.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 03:18:10 -0800 (PST)
Date:   Thu, 17 Feb 2022 12:18:08 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [RFC iproute2] tos: interpret ToS in natural numeral system
Message-ID: <20220217111808.GA9766@pc-4.home>
References: <20220216194205.3780848-1-kuba@kernel.org>
 <20220216222352.GA3432@pc-4.home>
 <0b4b5a8f8e9e48248bee3208d8f13286@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b4b5a8f8e9e48248bee3208d8f13286@AcuMS.aculab.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 10:44:19PM +0000, David Laight wrote:
> From: Guillaume Nault
> > Sent: 16 February 2022 22:24
> > 
> > On Wed, Feb 16, 2022 at 11:42:05AM -0800, Jakub Kicinski wrote:
> > > Silently forcing a base numeral system is very painful for users.
> > > ip currently interprets tos 10 as 0x10. Imagine user's bash script
> > > does:
> > >
> > >   .. tos $((TOS * 2)) ..
> > >
> > > or any numerical operation on the ToS.
> > >
> > > This patch breaks existing scripts if they expect 10 to be 0x10.
> > 
> > I agree that we shouldn't have forced base 16 in the first place.
> > But after so many years I find it a bit dangerous to change that.
> 
> Aren't the TOS values made up of several multi-bit fields and
> very likely to be documented in hex?

In theory, they are. But as far as the kernel is concerned, they're
just plain integers with no significance (apart from some constraints
preventing the use of some values). Users are free to choose their own
values.

> I'm not sure $((TOS * 2)) (or even + 2) makes any sense at all.
> 
> What it more horrid that that base 0 treats numbers that start
> with a 0 as octal - has anyone really used octal since the 1970s
> (except for file permissions).

Right, but that'd be consistent with the rest of iproute2, so users
should be aware of this trap at this point (or most likely, they never
prefix their values with 0). Anyway, I think we agreed that it's now
too late to modify the base.

> I have written command line parsers that treat 0tnnn as decimal
> while defaulting to hex.
> That does make it easier to use shell arithmetic for field (like
> addresses) that you would never normally specify in decimal.
> 
> > 
> > What about just printing a warning when the value isn't prefixed with
> > '0x'? Something like (completely untested):
> > 
> > @@ -535,6 +535,12 @@ int rtnl_dsfield_a2n(__u32 *id, const char *arg)
> >  	if (!end || end == arg || *end || res > 255)
> >  		return -1;
> >  	*id = res;
> > +
> > +	if (strncmp("0x", arg, 2))
> > +		fprintf(stderr,
> > +			"Warning: dsfield and tos parameters are interpreted as hexadecimal values\n"
> > +			"Use 'dsfield 0x%02x' to avoid this message\n", res);
> 
> Ugg.

Not nice, I agree. But what else can we do without breaking backward
compatibility?
This is similar to the warning we have when creating a new vxlan device
without specifying the destination port:

  # ip link add type vxlan vni 200 remote 2001:db8::1
  vxlan: destination port not specified
  Will use Linux kernel default (non-standard value)
  Use 'dstport 4789' to get the IANA assigned value
  Use 'dstport 0' to get default and quiet this message

> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

