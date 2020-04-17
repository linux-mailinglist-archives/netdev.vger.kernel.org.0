Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637521AD88C
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 10:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729763AbgDQIaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 04:30:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29469 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729732AbgDQI37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 04:29:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587112197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sq2go4oE4wkjjJo/d/qCXW8H/F2CZmjvC27LSvnbq6k=;
        b=dHsko3NR6rka/qtPRVA3eqRLGXE1KoWuOiKb3yQ970F9UhN+NqNwHkp19p/Xu955dD+/q9
        WmJavrh4+WW+PjuqgzvLUAODRhCtHjruB18NQbOvNZdQFFRXOeyEqr2A58HZo34JBC/vc4
        dyMCJpj0yIyLVSxjGEqSTCvoydl8ZnU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-haZXoYk-N5-BTmuo_dRiVQ-1; Fri, 17 Apr 2020 04:29:56 -0400
X-MC-Unique: haZXoYk-N5-BTmuo_dRiVQ-1
Received: by mail-wr1-f72.google.com with SMTP id q10so631414wrv.10
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 01:29:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=sq2go4oE4wkjjJo/d/qCXW8H/F2CZmjvC27LSvnbq6k=;
        b=bTchWKEHVZ0/7pK1MbzerM67E07cMLCqOuyE+plE8fF7S3p0v5S1ZX3jvgSD9Tl6JI
         WE14ojO4LY+/VFvB9pGOsHDpI6Qo6p5m2gV32536SXhjedlc86ZAaZdyOVrwG5xcqck6
         uTSW4BoVIfxXgs+HLpr/ony8K8wgA7ge8lyDZMnpd57R1Ztnd20WTsVeQex6gHYQzYcS
         QVfhrcf3tzKCmzr+qa6x7Q/FrvydOzf3yGiKxR7dzrV5zxkoYfmLH9rAW8RE9z/FU7eR
         eseupyWX0CUK0hcfYrZHUHUewY/WIo4e323+ZVrETQezk76DMX9IW7uhBqTpcOjKiIPD
         7jRg==
X-Gm-Message-State: AGi0PuYJJU++b7aOrdWcBALqt0yzt56fQ8qmrkXlueV5bmGNUW0X7lMS
        uufW1XCUAMTYziX5w16yocONEu9fMtZEGRQ4UPFPjtsFig1K8F7Xsot1lED36acp8I1F13SdPOC
        9/njo6w39BNIJdBZZ
X-Received: by 2002:a05:600c:2214:: with SMTP id z20mr2319813wml.189.1587112195127;
        Fri, 17 Apr 2020 01:29:55 -0700 (PDT)
X-Google-Smtp-Source: APiQypJKNV66xDbZPbEJ9pvldY03mzn5rKaoaGWZw2nM8sRe1qQQQA0lQolXxgIpPJn0ZvUYcb5Wmw==
X-Received: by 2002:a05:600c:2214:: with SMTP id z20mr2319790wml.189.1587112194907;
        Fri, 17 Apr 2020 01:29:54 -0700 (PDT)
Received: from redhat.com (bzq-79-183-51-3.red.bezeqint.net. [79.183.51.3])
        by smtp.gmail.com with ESMTPSA id k133sm7277794wma.0.2020.04.17.01.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 01:29:54 -0700 (PDT)
Date:   Fri, 17 Apr 2020 04:29:50 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, geert@linux-m68k.org,
        tsbogend@alpha.franken.de, benh@kernel.crashing.org,
        paulus@samba.org, heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH V2] vhost: do not enable VHOST_MENU by default
Message-ID: <20200417042912-mutt-send-email-mst@kernel.org>
References: <20200415024356.23751-1-jasowang@redhat.com>
 <20200416185426-mutt-send-email-mst@kernel.org>
 <b7e2deb7-cb64-b625-aeb4-760c7b28c0c8@redhat.com>
 <20200417022929-mutt-send-email-mst@kernel.org>
 <4274625d-6feb-81b6-5b0a-695229e7c33d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4274625d-6feb-81b6-5b0a-695229e7c33d@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 03:36:52PM +0800, Jason Wang wrote:
> 
> On 2020/4/17 下午2:33, Michael S. Tsirkin wrote:
> > On Fri, Apr 17, 2020 at 11:12:14AM +0800, Jason Wang wrote:
> > > On 2020/4/17 上午6:55, Michael S. Tsirkin wrote:
> > > > On Wed, Apr 15, 2020 at 10:43:56AM +0800, Jason Wang wrote:
> > > > > We try to keep the defconfig untouched after decoupling CONFIG_VHOST
> > > > > out of CONFIG_VIRTUALIZATION in commit 20c384f1ea1a
> > > > > ("vhost: refine vhost and vringh kconfig") by enabling VHOST_MENU by
> > > > > default. Then the defconfigs can keep enabling CONFIG_VHOST_NET
> > > > > without the caring of CONFIG_VHOST.
> > > > > 
> > > > > But this will leave a "CONFIG_VHOST_MENU=y" in all defconfigs and even
> > > > > for the ones that doesn't want vhost. So it actually shifts the
> > > > > burdens to the maintainers of all other to add "CONFIG_VHOST_MENU is
> > > > > not set". So this patch tries to enable CONFIG_VHOST explicitly in
> > > > > defconfigs that enables CONFIG_VHOST_NET and CONFIG_VHOST_VSOCK.
> > > > > 
> > > > > Acked-by: Christian Borntraeger<borntraeger@de.ibm.com>  (s390)
> > > > > Acked-by: Michael Ellerman<mpe@ellerman.id.au>  (powerpc)
> > > > > Cc: Thomas Bogendoerfer<tsbogend@alpha.franken.de>
> > > > > Cc: Benjamin Herrenschmidt<benh@kernel.crashing.org>
> > > > > Cc: Paul Mackerras<paulus@samba.org>
> > > > > Cc: Michael Ellerman<mpe@ellerman.id.au>
> > > > > Cc: Heiko Carstens<heiko.carstens@de.ibm.com>
> > > > > Cc: Vasily Gorbik<gor@linux.ibm.com>
> > > > > Cc: Christian Borntraeger<borntraeger@de.ibm.com>
> > > > > Reported-by: Geert Uytterhoeven<geert@linux-m68k.org>
> > > > > Signed-off-by: Jason Wang<jasowang@redhat.com>
> > > > I rebased this on top of OABI fix since that
> > > > seems more orgent to fix.
> > > > Pushed to my vhost branch pls take a look and
> > > > if possible test.
> > > > Thanks!
> > > 
> > > I test this patch by generating the defconfigs that wants vhost_net or
> > > vhost_vsock. All looks fine.
> > > 
> > > But having CONFIG_VHOST_DPN=y may end up with the similar situation that
> > > this patch want to address.
> > > Maybe we can let CONFIG_VHOST depends on !ARM || AEABI then add another
> > > menuconfig for VHOST_RING and do something similar?
> > > 
> > > Thanks
> > Sorry I don't understand. After this patch CONFIG_VHOST_DPN is just
> > an internal variable for the OABI fix. I kept it separate
> > so it's easy to revert for 5.8. Yes we could squash it into
> > VHOST directly but I don't see how that changes logic at all.
> 
> 
> Sorry for being unclear.
> 
> I meant since it was enabled by default, "CONFIG_VHOST_DPN=y" will be left
> in the defconfigs.

But who cares? That does not add any code, does it?

> This requires the arch maintainers to add
> "CONFIG_VHOST_VDPN is not set". (Geert complains about this)
> 
> Thanks
> 
> 
> > 

