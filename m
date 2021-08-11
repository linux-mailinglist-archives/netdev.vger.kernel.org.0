Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 168B33E96EE
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 19:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhHKRip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 13:38:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25933 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230400AbhHKRik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 13:38:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628703495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6tCiBXyEPPVHcytD6Q7sBcV/4LPCan3AiWP5HZnI2c4=;
        b=OYNZMCCDWzMQA4PilthT0QWNBKStE3qlZj+egfJWE8pKGP5UbsQom5XYBd8e62uPZj+Ord
        aX/hIzXiJIKozEOEe+Z6J4p5nVOsubSe9OCWGPXWrmZYsi1o3ZrhptSOXYzxIXnnc6v10e
        I9AN2YrjfG3DrlC+1tL03cJY3k/tUsQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-Keq2CtzvNOuE2hTXD7UqNw-1; Wed, 11 Aug 2021 13:38:14 -0400
X-MC-Unique: Keq2CtzvNOuE2hTXD7UqNw-1
Received: by mail-wr1-f70.google.com with SMTP id a9-20020a0560000509b029015485b95d0cso1013332wrf.5
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 10:38:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=6tCiBXyEPPVHcytD6Q7sBcV/4LPCan3AiWP5HZnI2c4=;
        b=jW9V07FHbG+HJ0JXkQAcwF1H9LirvswojBZdWt7nOeHY3fgg0geZeykVkryQ/W4aFR
         hDEFmEts2k9LxJfjCHscd7xa6+i3zNaN7tzyGwRuQvy+C/lEXB4/YEi+oksSuMs58yas
         mCtNvbNxlyp1ouWvhafFxqg9OQzbA5q1t4OzIfEIieMKQwgQJdkGFR3+KqVzkjL3nRzR
         DvTjbupLHybvUhmJt1TAMd1gY+Pem7Kb0hcBE6tP4Gp6/XpuKLVzdPyf3Rld7JY5VPs/
         DbMh+8zvzdGNYfCXhJVI+gHEEmheV7Ba5OinwugC4PMiQ3QmceA1VHdG7U9TkxwAG8R8
         cgqg==
X-Gm-Message-State: AOAM531uQoC2z9ZfuOIQLmO4e/O5+kOIG5hBnDSfRMJL5Sfwk3JNxj7x
        PMhXGQ7QCaV9rB7ymPsIZhf/cpF4bZn3PtEAhETi1Y73OjIQTcmDPGeJSBZANv2tyvNP9kGPKs6
        mAOiUIq88avNwzD8U
X-Received: by 2002:a5d:4e4f:: with SMTP id r15mr4511387wrt.346.1628703493608;
        Wed, 11 Aug 2021 10:38:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBKcCmyDX18C7DbXsG1LgPCGgWfobdmtNU6zwx/hvy49vfqyb0tHvKV1pHDmAur3B0NTSeKQ==
X-Received: by 2002:a5d:4e4f:: with SMTP id r15mr4511375wrt.346.1628703493439;
        Wed, 11 Aug 2021 10:38:13 -0700 (PDT)
Received: from pc-32.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id b10sm8505245wrn.9.2021.08.11.10.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 10:38:13 -0700 (PDT)
Date:   Wed, 11 Aug 2021 19:38:11 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     James Carlson <carlsonj@workingcode.com>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Chris Fowler <cfowler@outpostsentinel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-ppp@vger.kernel.org" <linux-ppp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ppp: Add rtnl attribute IFLA_PPP_UNIT_ID for specifying
 ppp unit id
Message-ID: <20210811173811.GE15488@pc-32.home>
References: <20210807163749.18316-1-pali@kernel.org>
 <20210809122546.758e41de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210809193109.mw6ritfdu27uhie7@pali>
 <20210810153941.GB14279@pc-32.home>
 <BN0P223MB0327A247724B7AE211D2E84EA7F79@BN0P223MB0327.NAMP223.PROD.OUTLOOK.COM>
 <20210810171626.z6bgvizx4eaafrbb@pali>
 <2f10b64e-ba50-d8a5-c40a-9b9bd4264155@workingcode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2f10b64e-ba50-d8a5-c40a-9b9bd4264155@workingcode.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 02:11:11PM -0400, James Carlson wrote:
> On 8/10/21 1:16 PM, Pali Rohár wrote:
> > On Tuesday 10 August 2021 16:38:32 Chris Fowler wrote:
> > > Isn't the UNIT ID the interface number?  As in 'unit 100' will give me ppp100?
> > 
> > If you do not specify pppd 'ifname' argument then pppd argument 'unit 100'
> > will cause that interface name would be ppp100.
> > 
> > But you are free to rename interface to any string which you like, even
> > to "ppp99".
> > 
> > But this ppp unit id is not interface number. Interface number is
> > another number which has nothing with ppp unit id and is assigned to
> > every network interface (even loopback). You can see them as the first
> > number in 'ip -o l' output. Or you can retrieve it via if_nametoindex()
> > function in C.
> 
> Correct; completely unrelated to the notion of "interface index."
> 
> > ... So if people are really using pppd's 'unit' argument then I think it
> > really make sense to support it also in new rtnl interface.
> 
> The pppd source base is old.  It dates to the mid-80's.  So it predates not
> just rename-able interfaces in Linux but Linux itself.
> 
> I recall supported platforms in the past (BSD-derived) that didn't support
> allowing the user to specify the unit number.  In general, on those
> platforms, the option was accepted and just ignored, and there were either
> release notes or man page updates (on that platform) that indicated that
> "unit N" wouldn't work there.
> 
> Are there users on Linux who make use of the "unit" option and who would
> mourn its loss?  Nobody really knows.  It's an ancient feature that was
> originally intended to deal with systems that couldn't rename interfaces
> (where one had to make sure that the actual interface selected matched up
> with pre-configured filtering rules or static routes or the like), and to
> make life nice for administrators (e.g., making sure that serial port 1 maps
> to ppp1, port 2 is ppp2, and so on).
> 
> I would think and hope most users reach for the more-flexible "ifname"
> option first, but I certainly can't guarantee it.  It could be buried in a
> script somewhere or (god forbid) some kind of GUI or "usability" tool.
> 
> If I were back at Sun, I'd probably call it suitable only for a "Major"
> release, as it removes a publicly documented feature.  But I don't know what
> the considerations are here.  Maybe it's just a "don't really care."

I'm pretty sure someone, somewhere, would hate us if we broke the
"unit" option. The old PPP ioctl API has been there for so long,
there certainly remains tons of old tools, scripts and config files
that "just work" without anybody left to debug or upgrade them.

We can't just say, "starting from kernel x.y.z the unit option is a
noop, use ifname instead" as affected people surely won't get the
message (and there are other tools beyond pppd that may use this
kernel API).

But for the netlink API, we don't have to repeat the same mistake.

