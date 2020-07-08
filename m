Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B70B5218401
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 11:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbgGHJmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 05:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725949AbgGHJmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 05:42:04 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0084C08C5DC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 02:42:03 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id o18so45206716eje.7
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 02:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i+mgJkcy6YPfI3WA4aAUbSJJVrX4FUftvYtU8JJ14iA=;
        b=koTbbF6twkw65CxQL6Lqiw2wJLkCKIMjgIJ7YGJS0fvx6o2NVisHmslYfrn4XwCjgE
         l8Ifst9FD6bViRYRgLF0xAiZ33bIurUvooHIPuMOcpDLONMb5GDUnCZ+kPoFWlyhSiJC
         OlnGEjwWMB/GRO3EPrjQWfbSxFRdnkHy4G1dHOdyWQvrAef/xXFV/NNyHJpCmyuMyQsD
         y9rSa7EdrKxQAHf+5rYQQR7r8o8RuMR7kGBajK8pIWDHTNhNvUu5BoY/M+pJV728vjhc
         3HeYrEsxPUd3xo0Jm6b1MWxG2rS19xPnv/3kGtFJvAXI0YXHELlK8j4WKk3J9GkM1UMf
         8FVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i+mgJkcy6YPfI3WA4aAUbSJJVrX4FUftvYtU8JJ14iA=;
        b=OliDoCbcF3uB88e0alxJf+/W2f0yJwn1P2CzpMEjtEBMFMOne5ucKiz1z8xYnln3FC
         Bw93h6R9pql2t30QybtX51VRIqH9YjNBjc/viq3KJd1scgGclzvrDJIWDqQ0LKDarr7t
         jQzFFKe790VMlCG/Opb3tRViMdPi24yj42SoOptIaCUd4AW+BFefeCoPSBK0GEeuyVwC
         xFKv7tj4lOo8tDOeSyqFc+wl9hieYjRxD6Rjz+7ThNiljS6mYo/Tu0jED51ni6wNUfe8
         Ot60QiJjerrzW5Zfz/SOZFUZXIn63G7Sn4502w5FVQlBlJj3mfoHedVT9xw/LyAJXnUv
         nOoA==
X-Gm-Message-State: AOAM53190QF4so/4trXsGeHA9k4+deCdDrG/nr2KTdAba90Q7ZFzwLfK
        p/UcSffVtqvvS5clCpAXimOU1WJl
X-Google-Smtp-Source: ABdhPJysnWLdONdR8x37Ri9H5rSagSwJRlT2k9l9D7HJxNiyKJeOxam/98fI4wjgkgiVakOQUUGijg==
X-Received: by 2002:a17:907:2654:: with SMTP id ar20mr48244374ejc.62.1594201322493;
        Wed, 08 Jul 2020 02:42:02 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id p9sm1708153ejd.50.2020.07.08.02.42.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 02:42:02 -0700 (PDT)
Date:   Wed, 8 Jul 2020 12:42:00 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     roopa@cumulusnetworks.com, netdev@vger.kernel.org
Subject: Re: What is the correct way to install an L2 multicast route into a
 bridge?
Message-ID: <20200708094200.p6lprjdpgncspima@skbuf>
References: <20200708090454.zvb6o7jr2woirw3i@skbuf>
 <6e654725-ec5e-8f6d-b8ae-3cf8b898c62e@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e654725-ec5e-8f6d-b8ae-3cf8b898c62e@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 08, 2020 at 12:16:27PM +0300, Nikolay Aleksandrov wrote:
> On 08/07/2020 12:04, Vladimir Oltean wrote:
> > Hi,
> > 
> > I am confused after reading man/man8/bridge.8. I have a bridge br0 with
> > 4 interfaces (eth0 -> eth3), and I would like to install a rule such
> > that the non-IP multicast address of 09:00:70:00:00:00 is only forwarded
> > towards 3 of those ports, instead of being flooded.
> > The manual says that 'bridge mdb' is only for IP multicast, and implies
> > that 'bridge fdb append' (NLM_F_APPEND) is only used by vxlan. So, what
> > is the correct user interface for what I am trying to do?
> > 
> > Thank you,
> > -Vladimir
> > 
> 
> Hi Vladimir,
> The bridge currently doesn't support L2 multicast routes. The MDB interface needs to be extended
> for such support. Soon I'll post patches that move it to a new, entirely netlink attribute-
> based, structure so it can be extended easily for that, too. My change is motivated mainly by SSM
> but it will help with implementing this feature as well.
> In case you need it sooner, patches are always welcome! :)
> 
> Current MDB fixed-size structure can also be used for implementing L2 mcast routes, but it would
> require some workarounds. 
> 
> Cheers,
>  Nik
> 
> 

Thanks, Nikolay.
Isn't mdb_modify() already netlink-based? I think you're talking about
some changes to 'struct br_mdb_entry' which would be necessary. What
changes would be needed, do you know (both in the 'workaround' case as
well as in 'fully netlink')?

-Vladimir
