Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2920B4C1C82
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 20:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244375AbiBWTrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 14:47:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243072AbiBWTrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 14:47:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 534FC264B
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 11:46:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645645592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/bAiudKI6GofrW8sW/IFMs0kLNUEycD7Kq3Myy+FN6M=;
        b=ZtuaU1UVU67qatBqa+maG9vSQ9IHt6L1qhEp4GfZqJPXm4QzVDhvQwVHPBHFQHxjiAfvRR
        GVO+xaNYma376l7N4RBIk1hAoJKM4tN6SfKFYOLgXjCQ+yXn39Sc3QhQUaU3c0ncLhFZxF
        5SAeee3InR7ngR99h2v/RldL/ZiKh4Q=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-a1XFkwF-Om2FGgJgMEx0Fw-1; Wed, 23 Feb 2022 14:46:30 -0500
X-MC-Unique: a1XFkwF-Om2FGgJgMEx0Fw-1
Received: by mail-wr1-f72.google.com with SMTP id g15-20020adfbc8f000000b001e9506e27ddso7625322wrh.22
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 11:46:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/bAiudKI6GofrW8sW/IFMs0kLNUEycD7Kq3Myy+FN6M=;
        b=nN7vDUF/uxRJzam4KcPJATKu2J94On1Vc/mMmtDLbru5nXfdzAmpNnJbUJuirTLWJk
         0iKSBbl4F7YF9j+e/GR2JKCyv/6znDqd+OVF2vitA1xedu1igEX+x4hHZsoElKoyLR7t
         Y0rwC/HjTdPsA+sT8cPAmBYO30pEFhgyxiPrieE1pHPVJrjEOBxLAMdoeZ0BP/cxbw2k
         NNeEgp5y1Inzoc4KGpOuB0AFguOX5B6KYs6D1DL7OdecwL3X8HQwIG+E4IyQq0NSgZ26
         xidvQyR7OHsbm7tCTKPwQOFgU1NaTsnmt4TN675+qrqdJ6udzwN8hDdUzlTZlLp9O+NC
         1g2Q==
X-Gm-Message-State: AOAM533lhOyHG12mvyHV5rKR0Z2q5Hkbzy6080yfOjWGue9X391w0H1g
        ShIiQuqH8Z0/a4DlVY9fcXFqxlwlQ69/yjGaWXMjKn/uR12Qz8FNAnmSGq9xUcrAuVsHhskOM7+
        UemSSQ+GaOd1HF1ER
X-Received: by 2002:a05:600c:2e0c:b0:37c:3615:c52 with SMTP id o12-20020a05600c2e0c00b0037c36150c52mr954430wmf.43.1645645589743;
        Wed, 23 Feb 2022 11:46:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJySrmeSB07rBtB2QvOGOMo8elbjh4NQ55HnawWX7yIAHPRtBLl0KqZraOKFQZWcMFevBUfseQ==
X-Received: by 2002:a05:600c:2e0c:b0:37c:3615:c52 with SMTP id o12-20020a05600c2e0c00b0037c36150c52mr954416wmf.43.1645645589449;
        Wed, 23 Feb 2022 11:46:29 -0800 (PST)
Received: from debian.home (2a01cb058d3818005c1e4a7b0f47339f.ipv6.abo.wanadoo.fr. [2a01:cb05:8d38:1800:5c1e:4a7b:f47:339f])
        by smtp.gmail.com with ESMTPSA id x11sm395152wmi.37.2022.02.23.11.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Feb 2022 11:46:27 -0800 (PST)
Date:   Wed, 23 Feb 2022 20:46:24 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Eric Dumazet <edumazet@google.com>,
        "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vasily Averin <vvs@virtuozzo.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: vlan: allow vlan device MTU change follow real
 device from smaller to bigger
Message-ID: <20220223194624.GD19531@debian.home>
References: <CANn89iKyWWCbAdv8W26HwGpM9q5+6rrk9E-Lbd2aujFkD3GMaQ@mail.gmail.com>
 <YhQ1KrtpEr3TgCwA@gondor.apana.org.au>
 <8248d662-8ea5-7937-6e34-5f1f8e19190f@huawei.com>
 <CANn89iLf2ira4XponYV91cbvcdK76ekU7fDW93fmuJ3iytFHcw@mail.gmail.com>
 <20220222103733.GA3203@debian.home>
 <20220222152815.1056ca24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20220223112618.GA19531@debian.home>
 <20220223080342.5cdd597c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20220223165836.GC19531@debian.home>
 <20220223093749.6b33345a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223093749.6b33345a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 23, 2022 at 09:37:49AM -0800, Jakub Kicinski wrote:
> On Wed, 23 Feb 2022 17:58:36 +0100 Guillaume Nault wrote:
> > On Wed, Feb 23, 2022 at 08:03:42AM -0800, Jakub Kicinski wrote:
> > > I meant
> > > 
> > >   ip link set dev vlan0 mtu-policy blah
> > > 
> > > but also
> > > 
> > >   ip link set dev bond0 mtu-policy blah
> > > 
> > > and
> > > 
> > >   ip link set dev macsec0 mtu-policy blah2
> > >   ip link set dev vxlan0 mtu-policy blah2
> > > 
> > > etc.  
> > 
> > Unless I'm missing something, that looks very much like what I proposed
> > (these are all ARPHRD_ETHER devices). It's just a bit unclear whether
> > "ip link set dev vlan0 mtu-policy blah" applies to vlan0 or to the vlans
> > that might be stacked on top of it (given your other examples, I assume
> > it's the later).
> 
> No, sorry I thought it would be clear, we need that neuralink ;)
> It applies to the device on which it's configured. What I mean
> is that bond, macsec, mpls etc have the same "should it follow 
> the MTU of the lower device" problem, it's not vlan specific.
> Or am I wrong about that?

Ok, I get it now, sorry for being slow :). But I wouldn't consider mpls
and vxlan. We have no device type for mpls. For vxlan (and other ip
tunnels) the virtual device isn't directly tied to a physical device.
Also, ip tunnels can resort to fragmentation in case of small MTU on
the output device, so following MTU changes is not a hard requirement
as with vlans.

For other devices, we'd probably have to take into account the fact
that some of them need to have a smaller MTU due to their extra header
(that can be the case for some stacked vlans scenarios).

But honnestly, I don't believe it's worth the extra complexity.

> > > To be honest I'm still not clear if this is a real problem.
> > > The patch does not specify what the use case is.  
> > 
> > It's probably not a problem as long as we keep sane behaviour by
> > default. Then we can let admins opt in for something more complex or
> > loosely defined.
> 
> What I meant was - does anyone actually flip the MTU of their
> interfaces back and forth while the system is running. Maybe
> people do.

In my experience people often try to upgrade their MTU, which is prone
to failure because all nodes on the ethernet segment need to be
upgraded at once (and people like unmanageably big ethernet segments).
So reverting to the previous configuration is often needed.
Another reason for back and forth modifications is fat fingers: change
the MTU of a device, realise that was the wrong one, restore settings
and reapply on the correct device.

More importantly, one path people take to upgrade their MTU is to
ensure that all their traffic is vlan encapsulated, then higher the MTU
of the ethernet device, and finally higher the MTU of each vlan on a
case by case basis. In such scenarios, you certainly _don't_ want the
vlans to follow the MTU of their parent device, no matter if their MTU
is the default one, if it's equal to the current MTU of the eth
interface, if it was ever modified since the creation of the device,
or any other situation heuristics might use.

