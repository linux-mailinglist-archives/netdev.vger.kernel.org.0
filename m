Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC7F5DB38F
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 19:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394274AbfJQRki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 13:40:38 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46319 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729302AbfJQRki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 13:40:38 -0400
Received: by mail-lj1-f196.google.com with SMTP id d1so3417980ljl.13
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 10:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=nCas3wIsezQ7Ota7kj7tPiR9E0F8WzvSl03swr1pjEU=;
        b=lDmR4/Fw5aqwF9Ql2z3KMI+HaK4vdraB3fJinNginHBw6Awy9IAyRnRCLLmdHKIwVg
         Knl5lzXAs6mlalgpwetOQEJGHAJwnSOATMk08RygHWRE34Lt8Pc2PXV8X7QHs6TSDitR
         46RaXGej9hftIS47FcPVn2Q//S2OZ+x2Jh45PucghFXADRNuyHN92X+ohC8c9Fj0Mn9C
         NH6IXfPfUS3KEJbw3fsuXV0q8UhLIzVzpubNILS84IHnM+Ykmw6FcLntr0+l5+5THkQ/
         89UAi0keQ/aEzAcaqTvI+15/rpwyZlJIjSkQAYaWdxfG0kbIvugnVdgXSEPxbfba1b6q
         nI+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=nCas3wIsezQ7Ota7kj7tPiR9E0F8WzvSl03swr1pjEU=;
        b=qt9Ces/RGD73SfxLwRepPGhI/McUh3bC7ptXqU60aTqaWKXxuvPum3XjN4zoY+e7sD
         owi01/Sl2OumPNsrg/Dz67svBxrTZBgBf36ZBYL7+6KN9shKmHrDxhW6dPwmyMGRh846
         SWXcXd0HBGfdnjJ9ioS6K2qu6sqZWMxfzoMrMC1483SCLnyPneViUQ8iXKMHNHYMEd9Y
         9wePhWZnoBbbyIOZaF/NB1mjuyYYwKU4grTKQRF5cUv5dwn7OJwaGERgh36uOznsiWnq
         t6EVZJkbb9LkX7R71K7d14LQAlni1qK2F0YLl2ug40NE3MVJJ3k2VeoNp98KfozRBVxo
         pGxA==
X-Gm-Message-State: APjAAAUMLRzHihDNI+CC/emf6Et93wpeOXb3FqKcO1vcbL02nyBVwIUn
        t829qjYMrjmsPN50hZETEwcgeA==
X-Google-Smtp-Source: APXvYqy6XesNK4XA5ymeIkq9d11eUGmWi24uGU3UH6mYlTCT/IkzoWIJUpvCr/Mzqd4fHNhZMQlCLw==
X-Received: by 2002:a2e:8183:: with SMTP id e3mr3354229ljg.14.1571334036024;
        Thu, 17 Oct 2019 10:40:36 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t10sm1208239ljt.68.2019.10.17.10.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 10:40:35 -0700 (PDT)
Date:   Thu, 17 Oct 2019 10:40:25 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Robert Beckett <bob.beckett@collabora.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: Re: [net-next 2/7] igb: add rx drop enable attribute
Message-ID: <20191017104025.31f00c97@cakuba.netronome.com>
In-Reply-To: <c04a2fbd630e91435eab985abfaf3bcb6a8d60d5.camel@collabora.com>
References: <20191016234711.21823-1-jeffrey.t.kirsher@intel.com>
        <20191016234711.21823-3-jeffrey.t.kirsher@intel.com>
        <20191016165531.26854b0e@cakuba.netronome.com>
        <a575469d3b2a12d24161d0c6b0a6bff538e066b6.camel@collabora.com>
        <20191017084433.18bce3d4@cakuba.netronome.com>
        <c04a2fbd630e91435eab985abfaf3bcb6a8d60d5.camel@collabora.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Oct 2019 18:04:22 +0100, Robert Beckett wrote:
> On Thu, 2019-10-17 at 08:44 -0700, Jakub Kicinski wrote:
> > On Thu, 17 Oct 2019 12:24:03 +0100, Robert Beckett wrote:  
> > > On Wed, 2019-10-16 at 16:55 -0700, Jakub Kicinski wrote:  
> > > > On Wed, 16 Oct 2019 16:47:06 -0700, Jeff Kirsher wrote:    
> > > > > From: Robert Beckett <bob.beckett@collabora.com>
> > > > > 
> > > > > To allow userland to enable or disable dropping packets when
> > > > > descriptor
> > > > > ring is exhausted, add RX_DROP_EN private flag.
> > > > > 
> > > > > This can be used in conjunction with flow control to mitigate
> > > > > packet storms
> > > > > (e.g. due to network loop or DoS) by forcing the network
> > > > > adapter to
> > > > > send
> > > > > pause frames whenever the ring is close to exhaustion.
> > > > > 
> > > > > By default this will maintain previous behaviour of enabling
> > > > > dropping of
> > > > > packets during ring buffer exhaustion.
> > > > > Some use cases prefer to not drop packets upon exhaustion, but
> > > > > instead
> > > > > use flow control to limit ingress rates and ensure no dropped
> > > > > packets.
> > > > > This is useful when the host CPU cannot keep up with packet
> > > > > delivery,
> > > > > but data delivery is more important than throughput via
> > > > > multiple
> > > > > queues.
> > > > > 
> > > > > Userland can set this flag to 0 via ethtool to disable packet
> > > > > dropping.
> > > > > 
> > > > > Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
> > > > > Tested-by: Aaron Brown <aaron.f.brown@intel.com>
> > > > > Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>    
> > > > 
> > > > How is this different than enabling/disabling flow control..
> > > > 
> > > > ethtool -a/-A    
> > > 
> > > Enabling flow control enables the advertisement of flow control
> > > capabilites and allows negotiation with link partner.  
> > 
> > More or less. If autoneg is on it controls advertised bits,
> > if autoneg is off it controls the enabled/disable directly.
> >   
> > > It does not dictate under which circumstances those pause frames
> > > will
> > > be emitted.  
> > 
> > So you're saying even with pause frames on igb by default will not
> > backpressure all the way to the wire if host RX ring is full/fill
> > ring
> > is empty?  
> 
> Correct.
> Honestly I personally considered it a bug when I first saw it.
> 
> see e6bdb6fefc590
> 
> Specifically it enables dropping of frames if multiple queues are in
> use, ostensibly to prevent head of line blocking between the different
> rx queues.
> 
> This patch says that that should be a user choice, defaulting to the
> old behaviour.

I'd say just always enable it then. Honestly if it's statically enabled
with multi queue (which I presume is the default?) then there's no need
for us to ponder the uAPI questions. I can't think of anyone flipping
that flag to disabled...

Flow control is supposed to prevent _all_ drops it can, AFAIU.

If we get an actual user request to change it we can revisit.
