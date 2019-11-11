Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49C5CF6D65
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 04:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfKKDqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 22:46:07 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37084 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbfKKDqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 22:46:06 -0500
Received: by mail-pg1-f194.google.com with SMTP id z24so8567785pgu.4
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 19:46:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=AqhM9u1bzCnw7qhUa4mHnqgFKW6TzFtxLFQ8BM/epMs=;
        b=SOIlwK5mjoyFW/tXHeVmYa4IK11qYjcalG4RreXwkjwE6o05256yuTEZ4tqlNqlfGD
         shDyAVTcAHfRAPjk0HgUUKt78RLGstgu/5t3Xt/YTXXdCjfzs9mSIpOwHV2fBRUr4arr
         AimZYIbgl6d67DxMbwVkHuQhEjqCZvV6SfPQ8uDxtE9RoCr+xi1KecnA+sD5oHcnju5t
         dFGKlm2zNCLvQWMxLDvuJZZCdRP6iqrhDPSdCZijkrYJ/JogxXmCgPyhTq2g5iRb3//X
         4ZXSpxzZA92++uyYySNgIfmELbtXgsdpqUoyYO5dKpkYYGsBdF1TrYchrVlxN9pAY8EW
         +iRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=AqhM9u1bzCnw7qhUa4mHnqgFKW6TzFtxLFQ8BM/epMs=;
        b=oIfn5wPLlLpYZkG51Y33ozoXAWmYUCGUzD9gKvllkPQqx7Ni71+RkvO0k/h0ue3F+K
         Z8WXnSNeq0L5hA2bgfpV8NDTZQbtpKxQn+CPAgA+Q9uoOlm9jrHUl1JYMy8i7Bx2dhy4
         ijcbLbEaM9uET0Yuorst2IFyKjDQ0P3Jr7ZcmQgB5lkWgnN1ETc793iDQB6B2b+HtDXG
         Evk5H8vxo6SooaWzaV/7iODGIXJYjCOQlZamBGZWogZLDD/55yRIC7s3so9eHj7j6A47
         CeP6S14zZcospHHJUWS1L3UfXh7zgRH4Mb10u2O2fEgHSDrBgjaWyfF5g4PArh+l4RHJ
         jqzA==
X-Gm-Message-State: APjAAAWmKMs+5daZmi6QJzmll6eJb+4NLlTkObG0Ez6JikEs+EvSl1aH
        xk5vu0lSyFR7WFcaigEdMx1Q2g==
X-Google-Smtp-Source: APXvYqyvsmmGRubdY0eCp6Hd53IA2QHIUdVnV/J9ottQSlb0FTBMpy9oBY7rLSA0rhkW3bsD3dRtVQ==
X-Received: by 2002:a63:86c6:: with SMTP id x189mr25278222pgd.341.1573443966052;
        Sun, 10 Nov 2019 19:46:06 -0800 (PST)
Received: from cakuba (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id w8sm12009631pfi.60.2019.11.10.19.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2019 19:46:05 -0800 (PST)
Date:   Sun, 10 Nov 2019 19:46:01 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Parav Pandit <parav@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David M <david.m.ertman@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191110194601.0d6ed1a0@cakuba>
In-Reply-To: <20191110091855.GE1435668@kroah.com>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107153234.0d735c1f@cakuba.netronome.com>
        <20191108121233.GJ6990@nanopsycho>
        <20191108144054.GC10956@ziepe.ca>
        <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20191108111238.578f44f1@cakuba>
        <20191108201253.GE10956@ziepe.ca>
        <20191108134559.42fbceff@cakuba>
        <20191109004426.GB31761@ziepe.ca>
        <20191109092747.26a1a37e@cakuba>
        <20191110091855.GE1435668@kroah.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 Nov 2019 10:18:55 +0100, gregkh@linuxfoundation.org wrote:
> > What I'm missing is why is it so bad to have a driver register to
> > multiple subsystems.  
> 
> Because these PCI devices seem to do "different" things all in one PCI
> resource set.  Blame the hardware designers :)

See below, I don't think you can blame the HW designers in this
particular case :)

> > For the nfp I think the _real_ reason to have a bus was that it
> > was expected to have some out-of-tree modules bind to it. Something 
> > I would not encourage :)  
> 
> That's not ok, and I agree with you.
> 
> But there seems to be some more complex PCI devices that do lots of
> different things all at once.  Kind of like a PCI device that wants to
> be both a keyboard and a storage device at the same time (i.e. a button
> on a disk drive...)

The keyboard which is also a storage device may be a clear cut case
where multiple devices were integrated into one bus endpoint.

The case with these advanced networking adapters is a little different
in that they are one HW device which has oodles of FW implementing
clients or acceleration for various networking protocols.

The nice thing about having a fake bus is you can load out-of-tree
drivers to operate extra protocols quite cleanly.

I'm not saying that's what the code in question is doing, I'm saying 
I'd personally like to understand the motivation more clearly before
every networking driver out there starts spawning buses. The only
argument I've heard so far for the separate devices is reloading subset
of the drivers, which I'd rate as moderately convincing.
