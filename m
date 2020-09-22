Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE0B27417F
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 13:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbgIVLtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 07:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbgIVLtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 07:49:41 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96612C0613CF
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 04:49:41 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id c62so5433060qke.1
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 04:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1D8ju+sMCrprb+0b/yOahK+eYVzPNlNBaX9NLNExdtI=;
        b=muDDi0pTHyd9JBABm8RyGLvWbVcMxru6wlVrHBiDJUY0jrq7Ma6mMxfMSYqQR2sE7S
         n6oWDLWu5dVTDb7iJrAWfjxmSdDqSDAJJW9NGZCBpfYbdyI9g1jOOFjEAzn7/UzcB7vf
         6kHbhNt0CKfpSocliMKcT3ueUyylf+kgqxUPyKzVGLicVzXOW+EPcdqsXV6Z51wTI+Lq
         mFn1Jmghmfz+QaX+PmjcpkzNu4kwAmbrY1iH3ow2hdHyCneXpKtLqwPJ9kIdYF1wt1Fy
         7Ad6pYgKKRqILeVv4+7BbG5JUDTj8gXQYUqzkQ2twtMOgHE/dr3KehrG6Q9VeF5IoCH0
         WnTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1D8ju+sMCrprb+0b/yOahK+eYVzPNlNBaX9NLNExdtI=;
        b=dq4q9mejhdm6UgyPS89vOIX5134cnahRfOU8qsFRYaXJRLqrHXUHlEzj8KYwX+qLsW
         SGTRbuQhBJdFb+LQKNP5JQzj+XprFMXvpgh7eW7ettsTJlsqVdrb2f69BU02DeH38fH6
         RgR/N2xeHmEYb/Q7FUj02+10m6BPZxjIuRr4HBFQOsciLzqdDeyh8LMe53nY7mtLdAoj
         +KMoAbQAHXKPEwRQk2M28azKqePd16FHnN4Lrkg+wLUaTdgqUNwFfJi85ll8TclVYfQb
         l+1rVM83JoiIxiKVs2+Dz7gvdCJpGD6zxFNiMC6TFek1CMtMrmOaVUiCcnxDSIqppftU
         P4sg==
X-Gm-Message-State: AOAM531DascLZpNkC/t0oabm4e9LvutOLdbDOO9XmwXefp8LnmZ0Ra0K
        qkPH4/zqOog+v2vJuxo9Ni496w==
X-Google-Smtp-Source: ABdhPJynCuK8vUTw9DbgSp3TWPoe/lJE1NnbKoGAO/to47jv50SynIh4q+Mrv7MDzz74la/2EhiNeA==
X-Received: by 2002:a37:c203:: with SMTP id i3mr4203326qkm.155.1600775380815;
        Tue, 22 Sep 2020 04:49:40 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id q142sm11081340qke.48.2020.09.22.04.49.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 04:49:40 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kKgnj-0030YZ-N6; Tue, 22 Sep 2020 08:49:39 -0300
Date:   Tue, 22 Sep 2020 08:49:39 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Oded Gabbay <oded.gabbay@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Leon Romanovsky <leon@kernel.org>,
        Gal Pressman <galpress@amazon.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
Message-ID: <20200922114939.GF8409@ziepe.ca>
References: <20200918121905.GU869610@unreal>
 <20200919064020.GC439518@kroah.com>
 <20200919082003.GW869610@unreal>
 <20200919083012.GA465680@kroah.com>
 <CAFCwf122V-ep44Kqk1DgRJN+tq3ctxE9uVbqYL07apLkLe2Z7g@mail.gmail.com>
 <20200919172730.GC2733595@kroah.com>
 <20200919192235.GB8409@ziepe.ca>
 <20200920084702.GA533114@kroah.com>
 <20200921115239.GC8409@ziepe.ca>
 <20200921142053.1d2310f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921142053.1d2310f6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 02:20:53PM -0700, Jakub Kicinski wrote:
> I'd wager the only reason you expose the netdevs at all is for link
> settings, stats, packet capture and debug. You'd never run TCP traffic
> over those links. And you're fighting against using Linux APIs for the
> only real traffic that runs on those links - RDMA(ish) traffic.

The usual working flow is to use something like TCP to exchange
connection information then pivot to RDMA for the actual data
flow. This is why a driver like this could get away with such a low
performance implementation for a 100G NIC, it is just application boot
metadata being exchanged.

Sniffing probably won't work as typically the HW will capture the RoCE
traffic before reaching Linux - and the Linux driver couldn't handle a
100G flow anyhow. Stats might not work either.

As far as the "usual rules" we do require that accelerator devices
sharing a netdev are secure in the concept of netdev userspace
security. They can access the assigned RoCEv2 UDP port but cannot do
things like forge src IP/MAC addresses, violate VLANs, reach outside
net namespaces, capature arbitary traffic, etc.

This stuff is tricky and generally requires HW support. Someone has to
audit all of this and ensure it meets the netdev security requirements
too, otherwise it will need CAP_NET_RAW to function. Obviously this
requires seeing enough of a userspace implementation to understand how
the design approaches verbs 'Address Handles' and so forth.

RDMA HW has had errors before and when discovered it was blocked with
CAP_NET_RAW until new chip revs came out, this is something I take
very seriously.

Jason
