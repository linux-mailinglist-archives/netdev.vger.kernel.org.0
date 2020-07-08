Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA7F218886
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 15:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729145AbgGHNKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 09:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728997AbgGHNKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 09:10:05 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D42C08C5DC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 06:10:04 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id by13so31887025edb.11
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 06:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cAWQ9SbrQAXiADCgBmSInfQ85nJoCMyan6rYxZoMilc=;
        b=Km5FbpYD7NgyfrLSjBRdosDHDl1d9LX1fG9q1FyHYgZ2IHYQGgSgtxkAv4HQuG5JId
         stHD6xUEU7quBSvh3+JJMXy5et/YSyTrvAsdo3yK41Q9D2zq10oaISH4cItTKVQzIBXl
         56E5y9lEDJw5Tfbf2/iPrYfK/UuSaiwWZlfaZiuE6Sjhz7/zqdRZuwVGLPm0+cD+77Zh
         4NzYrliw6UzzVZVSI6au2J9iRS8A4idkaHFfXxXVf7aiqhgwejTTyvorESX6X6BVATky
         ET4GbQByNMHMml9wwJm/sMbeezCcvdy0PlKTLLWgbxrZDBvjQxfMF5FDUJ9XqyqSIVVV
         HerA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cAWQ9SbrQAXiADCgBmSInfQ85nJoCMyan6rYxZoMilc=;
        b=CUrzK7FWLfKuDsbEAFi8Rw0C5lFJP4Er996ndWHr7OkpZ3PcbCjGnfzAiR9E5+aRtU
         w03a3w0yqc+vr2ij00OGRTFui/L43rBY8HMQ7x3+p/DqKIfAD5y6FvPJVTR0IbKYlXx/
         1utFKiUFaGhQpe66PnvJU4h4DipxpzsnbUeV0jhH9Q50GtWMPfqivmK65t1CbpWKu2qL
         J48Vi8RnUYUE5g0mMkvO+G1ni3FLNcBrXbQC5gefYwtCCbAnie+sBQwoFkPX0EiM51QR
         DIJxDeQDmEMIJUDKi7LQHX6lzR9ajV5ugOIcc6lm88s3vLYAPt5znjw6w+d0StDD/GPy
         tMOQ==
X-Gm-Message-State: AOAM533nX2mcM8svwUhBFPis+APIFzcdu/dUoP6ihWmo2V9jBihwt8cm
        uoy397jpx74uz7qu59At0JcIEo68
X-Google-Smtp-Source: ABdhPJyvDI4sDdHF6QvmgCGopKLHDZhFowsvDGGI0ZzMe0SaIiDrFoiHMztrEBDb47cHPTw9QKxBJA==
X-Received: by 2002:a05:6402:1c86:: with SMTP id cy6mr52587895edb.30.1594213803382;
        Wed, 08 Jul 2020 06:10:03 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id n2sm27452931edq.73.2020.07.08.06.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 06:10:02 -0700 (PDT)
Date:   Wed, 8 Jul 2020 16:10:00 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     roopa@cumulusnetworks.com, netdev@vger.kernel.org
Subject: Re: What is the correct way to install an L2 multicast route into a
 bridge?
Message-ID: <20200708131000.vs4fkjorvob6zyku@skbuf>
References: <20200708090454.zvb6o7jr2woirw3i@skbuf>
 <6e654725-ec5e-8f6d-b8ae-3cf8b898c62e@cumulusnetworks.com>
 <20200708094200.p6lprjdpgncspima@skbuf>
 <0d554adb-29c3-3b4a-d696-4d4bfd567767@cumulusnetworks.com>
 <7a64aacf-51fd-4697-6af9-229bbbe97d0b@cumulusnetworks.com>
 <9621e436-b674-ea12-eabd-9908ca6d5ee8@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9621e436-b674-ea12-eabd-9908ca6d5ee8@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 08, 2020 at 03:55:23PM +0300, Nikolay Aleksandrov wrote:
> On 08/07/2020 14:17, Nikolay Aleksandrov wrote:
> > On 08/07/2020 14:07, Nikolay Aleksandrov wrote:
> >> On 08/07/2020 12:42, Vladimir Oltean wrote:
> >>> On Wed, Jul 08, 2020 at 12:16:27PM +0300, Nikolay Aleksandrov wrote:
> >>>> On 08/07/2020 12:04, Vladimir Oltean wrote:
> [snip]
> >>>>
> >>>
> >>> Thanks, Nikolay.
> >>> Isn't mdb_modify() already netlink-based? I think you're talking about
> >>> some changes to 'struct br_mdb_entry' which would be necessary. What
> >>> changes would be needed, do you know (both in the 'workaround' case as
> >>> well as in 'fully netlink')?
> >>>
> >>> -Vladimir
> >>>
> >>
> >> That is netlink-based, but the uAPI (used also for add/del/dump) uses a fixed-size struct
> >> which is very inconvenient and hard to extend. I plan to add MDBv2 which uses separate
> >> netlink attributes and can be easily extended as we plan to add some new features and will
> >> need that flexibility. It will use a new container attribute for the notifications as well.
> >>
> >> In the workaround case IIRC you'd have to add a new protocol type to denote the L2 routes, and
> > 
> > Actually drop the whole /workaround/ comment altogether. It can be implemented fairly straight-forward
> > even with the struct we got now. You don't need any new attributes.
> > I just had forgotten the details and spoke too quickly. :)
> > 
> >> re-work the lookup logic to include L2 in non-IP case. You'd have to edit the multicast fast-path,
> >> and everything else that assumes the frame has to be IP/IPv6. I'm sure I'm missing some details as
> >> last I did this was over an year ago where I made a quick and dirty hack that implemented it with proto = 0
> >> to denote an L2 entry just as a proof of concept.
> >> Also you would have to make sure all of that is compatible with current user-space code. For example
> >> iproute2/bridge/mdb.c considers that proto can be only IPv4 or IPv6 if it's not v4, i.e. it will
> >> print the new L2 entries as :: IPv6 entries until it's fixed.
> >>
> >> Obviously some of the items for the workaround case are valid in all cases for L2 routes (e.g. fast-path/lookup edit).
> >> But I think it's not that hard to implement without affecting the fast path much or even at all.
> >>
> >> Cheers,
> >>  Nik
> >>
> 
> I found the patch and rebased it against net-next. I want to stress that it is unfinished and
> barely tested, it was just a hack to enable L2 entries and forwarding.
> If you're interested and find it useful please feel free to take it over as
> I don't have time right now.
> 
> Thanks,
>  Nik
> 
> 

Thanks! I'll give it a try, and I'll submit it if I get it to work
properly and see no regressions with IP multicast.

-Vladimir
