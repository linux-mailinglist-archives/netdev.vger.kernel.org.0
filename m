Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF99FCB72B
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 11:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731331AbfJDJQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 05:16:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36870 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729379AbfJDJQL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 05:16:11 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 207AC58
        for <netdev@vger.kernel.org>; Fri,  4 Oct 2019 09:16:10 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id w2so2448321wrn.4
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 02:16:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hhPEpgLhkjexE7wGXfmiyqeRzNcW/U3S79ip8ewXhIg=;
        b=RTTloq6sJa3uoZvaw9QCtrmiiMeJgS3TMZJ5TWdLn44QXXxDHNsTghGBC/bZJmvIFE
         R6n+PGkpzGzq1llNH7E0SPkkgq0GnvZun6rBEmvozBJ/EnVmuXwlPOaTz+9/vmnLYFXi
         BtU5Hd9jlDP5mVM+LARZRBoBgcK13PZy9kU2v5hLWEVCReWoOm0xJ4UzHZBtmhsgdulN
         KmrbVJ7rUzpyP8yFhsLKfyx223MuUxffOvPIkmU7G1c1P0Lu4qn8uXjxpvTwhaUhMH+O
         rV5NRVfod3rX0j2fN7O1sTuw/KPEgDPuqJpWJoIAM9l1DBtLvSHE2rE1j3dIR4OWa0Gm
         fLIw==
X-Gm-Message-State: APjAAAVv7mD5l1ao4IGUK2Oz15chz4hHcY8jrWH1e9ptBFLbr81gClnV
        Fgsj4pUZZCC0PL8VshzzNoGr9OjVLCx15oaq/8DuegmuiJfI1KgqAHS+yI9ypuxEQKKfQsvSCeZ
        ovcdh8xsC8INPJ3ox
X-Received: by 2002:a1c:9d15:: with SMTP id g21mr10287382wme.96.1570180568808;
        Fri, 04 Oct 2019 02:16:08 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwYyFXc0psA9cM79xGyuf3QCE7kgh2CziA2e0KZxOqK4U+Rh82+kx6tnfpcYC/+KSgegIYtMA==
X-Received: by 2002:a1c:9d15:: with SMTP id g21mr10287358wme.96.1570180568530;
        Fri, 04 Oct 2019 02:16:08 -0700 (PDT)
Received: from steredhat (host174-200-dynamic.52-79-r.retail.telecomitalia.it. [79.52.200.174])
        by smtp.gmail.com with ESMTPSA id q192sm7660110wme.23.2019.10.04.02.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 02:16:07 -0700 (PDT)
Date:   Fri, 4 Oct 2019 11:16:05 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: Re: [RFC PATCH 00/13] vsock: add multi-transports support
Message-ID: <20191004091605.ayed7iqjhurzrdap@steredhat>
References: <20190927112703.17745-1-sgarzare@redhat.com>
 <PU1P153MB0169970A7DD4383F06CDAB60BF9E0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PU1P153MB0169970A7DD4383F06CDAB60BF9E0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 04, 2019 at 12:04:46AM +0000, Dexuan Cui wrote:
> > From: Stefano Garzarella <sgarzare@redhat.com>
> > Sent: Friday, September 27, 2019 4:27 AM
> >  ...
> > Patch 9 changes the hvs_remote_addr_init(). setting the
> > VMADDR_CID_HOST as remote CID instead of VMADDR_CID_ANY to make
> > the choice of transport to be used work properly.
> > @Dexuan Could this change break anything?
> 
> This patch looks good to me.
> 

Thank you very much for your reviews!

> > @Dexuan please can you test on HyperV that I didn't break anything
> > even without nested VMs?
> 
> I did some quick tests with the 13 patches in a Linux VM (this is not
> a nested VM) on Hyper-V and it looks nothing is broken. :-)
> 

Great :-)

> > I'll try to setup a Windows host where to test the nested VMs
> 
> I suppose you're going to run a Linux VM on a Hyper-V host,
> and the Linux VM itself runs KVM/VmWare so it can create its own child 
> VMs. IMO this is similar to the test "nested KVM ( ..., virtio-transport[L1,L2]"
> you have done.

Yes, I think so. If the Hyper-V transport works well without nested VM,
it should work the same with a nested KVM/VMware.

Thanks,
Stefano
