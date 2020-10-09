Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC284289A2E
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 23:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391227AbgJIVHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 17:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390858AbgJIVHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 17:07:47 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC4DC0613D2;
        Fri,  9 Oct 2020 14:07:47 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 132so1302171pfz.5;
        Fri, 09 Oct 2020 14:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gVTKRLRA1bITbnGpMOm5I3FA6j0mKsRrWvCnJEPhELI=;
        b=L0Hkgq6t7Zloy5xbD8h1YUHYqWe+QN3xPiRxfGRN3UEpWrgOKv6yHfN3MHhkPh+EwY
         9BVwAb956bLJDrLLE1iovwKzxedmBuQTztl8plWJIwEWcn6KIyZuRtr02Yo3DGsBZcEh
         PLxTcvcha/jyMMWeFzzsSGLyMYtKfTts9ZZ/NokvlWtA+sdKs8i6pHpfooJfi/Wk/UBW
         o+HbPg3ZDJ6mdFktt7n60mq4Ysk5BgxO80/AaXfsomebfxpividIzMy0BENRvGCMxINd
         3DJl6a7Ty6dHbvPd1bz1zfxZnhyBweFKPZIEzxF+mfi+mh2jaSD9lBBfrBLYtBBSEGL9
         yyYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gVTKRLRA1bITbnGpMOm5I3FA6j0mKsRrWvCnJEPhELI=;
        b=IzoxjQ5DdjVJRDeCcHe5yAPGp4u+YN6JcKICBEJB8k8SvVCJPsGxoZovknoao7mOIL
         yA/Kpx30fONIs0UWnBS1FVhwgc6WfzPx3KJnZ860bUPADX7V2OZDzxYV8QdboxbtFs5e
         1Xx7AEoptaumonsrb1lriD9i4uE+Kg1TxZk2LZDRyYLONU0SaHxXnKW0PZdb501W73ZO
         O8tAZfXg5SqU24bw86yyC/9dP+mQInZieCuSGc9flPwIUIF03revkrDHOn1jhol9FF6m
         CrhLmjkzAmpOBcANto1zYYqBD1cpUVONzRF1VRYXkNg7QMSUiGlLYoJvbOPsgEBxbk8Q
         pDDA==
X-Gm-Message-State: AOAM5311aBXvd1HTsahpZ/We+uh+F5A7hjerpGB9KQ6fc2F0dbfYMxhT
        nIC4TjdkHqUZQ2PYjbnK27E=
X-Google-Smtp-Source: ABdhPJwT0OCimKOcTOANq7D5WEdgMVpijp8gqNNFWWyDFh0xuz+vDPldjXoA8eZbU3jkRckMEFZUgg==
X-Received: by 2002:a63:cc42:: with SMTP id q2mr5090623pgi.216.1602277667114;
        Fri, 09 Oct 2020 14:07:47 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:db42])
        by smtp.gmail.com with ESMTPSA id d128sm12096685pfd.94.2020.10.09.14.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 14:07:46 -0700 (PDT)
Date:   Fri, 9 Oct 2020 14:07:44 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>, maze@google.com,
        lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        eyal.birger@gmail.com
Subject: Re: [PATCH bpf-next V3 0/6] bpf: New approach for BPF MTU handling
Message-ID: <20201009210744.xa55r6sanggqv5ou@ast-mbp>
References: <160216609656.882446.16642490462568561112.stgit@firesoul>
 <20201009093319.6140b322@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <5f80ccca63d9_ed74208f8@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f80ccca63d9_ed74208f8@john-XPS-13-9370.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 09, 2020 at 01:49:14PM -0700, John Fastabend wrote:
> Jakub Kicinski wrote:
> > On Thu, 08 Oct 2020 16:08:57 +0200 Jesper Dangaard Brouer wrote:
> > > V3: Drop enforcement of MTU in net-core, leave it to drivers
> > 
> > Sorry for being late to the discussion.
> > 
> > I absolutely disagree. We had cases in the past where HW would lock up
> > if it was sent a frame with bad geometry.
> > 
> > We will not be sprinkling validation checks across the drivers because
> > some reconfiguration path may occasionally yield a bad packet, or it's
> > hard to do something right with BPF.
> 
> This is a driver bug then. As it stands today drivers may get hit with
> skb with MTU greater than set MTU as best I can tell. Generally I
> expect drivers use MTU to configure RX buffers not sure how it is going
> to be used on TX side? Any examples? I just poked around through the
> driver source to see and seems to confirm its primarily for RX side
> configuration with some drivers throwing the event down to the firmware
> for something that I can't see in the code?
> 
> I'm not suggestiong sprinkling validation checks across the drivers.
> I'm suggesting if the drivers hang we fix them.

+1

I've seen HW that hangs when certain sizes of the packet.
Like < 68 byte TX where size is one specific constant.
I don't think it's a job of the stack or the driver to deal with that.
It's firmware/hw bug.
