Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 614D0E8CA4
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 17:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390345AbfJ2Q1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 12:27:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48250 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390374AbfJ2Q1Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 12:27:24 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9C9DDC0528DD
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 16:27:23 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id h4so8782297wrx.15
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 09:27:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=C6bDuPajdG9JVS65/nNfvWestag5Xwy94+uZABzDGas=;
        b=SEfvTB+m4fWHDrrkZ7EiI3JXvs3uQfEQUmYlYMmDwGEFz5MEFuhznXgbfE5bawxDRO
         FNBWSMTZukQWbPfuTsBXElAoxifsVqIiqcYsTHy4uQLfQY5aeLxKQ7zgLrkuAuN5cEHg
         l/d4Qx6CiDrCW/SLLC6DbR2MIGzfmNDZEhCzpidebyZWfOF76tL33g8Kk70thbmO4JjQ
         NT+rLpnZE00D7IEhY5Y5HpkAhW46jEU+7QVJv1oJoMJYMEZS4c9d+9QFQFlaDJsoO3aS
         s+vM1MA3MFn7dCLIz2UgvvE5qiAkj7fmdrqKWYTGm6dmUGxaVnoXKf3S0Y0e01KklbPy
         1HrQ==
X-Gm-Message-State: APjAAAXbxcLtOkMuZCeMl5v6Zc2qwmVVFttF0RqVC2zha8L4RvXuVeYM
        hrNHP2odN/3tAzGvejZ4FtbNBP3uzk2onfl6Q32DO0gURRcpJCcmMsj5kHqVSFeQn3aKngPXR+c
        25jeg0p0sAPdQYOxm
X-Received: by 2002:a7b:c924:: with SMTP id h4mr5203724wml.143.1572366442237;
        Tue, 29 Oct 2019 09:27:22 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwqcoHXB/eGlbAvP8/zQv1DhxCc9oHsJCpQ0Me1i12d1jrxIWteVIy4TZqjG4WQmNpAjkkq4g==
X-Received: by 2002:a7b:c924:: with SMTP id h4mr5203696wml.143.1572366441980;
        Tue, 29 Oct 2019 09:27:21 -0700 (PDT)
Received: from steredhat (94.222.26.109.rev.sfr.net. [109.26.222.94])
        by smtp.gmail.com with ESMTPSA id v10sm4015055wmg.48.2019.10.29.09.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 09:27:21 -0700 (PDT)
Date:   Tue, 29 Oct 2019 17:27:12 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>,
        Adit Ranadive <aditr@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>, Andy king <acking@vmware.com>,
        Aditya Sarwade <asarwade@vmware.com>,
        George Zhang <georgezhang@vmware.com>,
        Jorgen Hansen <jhansen@vmware.com>
Cc:     netdev@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        linux-hyperv@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Arnd Bergmann <arnd@arndb.de>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dexuan Cui <decui@microsoft.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 00/14] vsock: add multi-transports support
Message-ID: <20191029162712.fn5rgxrwdrbxuehw@steredhat>
References: <20191023095554.11340-1-sgarzare@redhat.com>
 <20191027080146.GA4472@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191027080146.GA4472@stefanha-x1.localdomain>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 27, 2019 at 09:01:46AM +0100, Stefan Hajnoczi wrote:
> On Wed, Oct 23, 2019 at 11:55:40AM +0200, Stefano Garzarella wrote:
> > This series adds the multi-transports support to vsock, following
> > this proposal: https://www.spinics.net/lists/netdev/msg575792.html
> > 
> > With the multi-transports support, we can use VSOCK with nested VMs
> > (using also different hypervisors) loading both guest->host and
> > host->guest transports at the same time.
> > Before this series, vmci-transport supported this behavior but only
> > using VMware hypervisor on L0, L1, etc.
> > 
> > RFC: https://patchwork.ozlabs.org/cover/1168442/
> > RFC -> v1:
> > - Added R-b/A-b from Dexuan and Stefan
> > - Fixed comments and typos in several patches (Stefan)
> > - Patch 7: changed .notify_buffer_size return to void (Stefan)
> > - Added patch 8 to simplify the API exposed to the transports (Stefan)
> > - Patch 11:
> >   + documented VSOCK_TRANSPORT_F_* flags (Stefan)
> >   + fixed vsock_assign_transport() when the socket is already assigned
> >   + moved features outside of struct vsock_transport, and used as
> >     parameter of vsock_core_register() as a preparation of Patch 12
> > - Removed "vsock: add 'transport_hg' to handle g2h\h2g transports" patch
> > - Added patch 12 to register vmci_transport only when VMCI guest/host
> >   are active
> 
> Has there been feedback from Jorgen or someone else from VMware?  A
> Reviewed-by or Acked-by would be nice since this patch series affects
> VMCI AF_VSOCK.
> 

Unfortunately not for now, I'm adding to this thread some VMware guys that
reviewed latest vmci patches.

Would be nice to have your feedback for these changes.

Thanks in advance,
Stefano
