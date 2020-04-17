Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F5F1AD94B
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 10:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729964AbgDQI5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 04:57:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23061 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730076AbgDQI5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 04:57:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587113868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=57oFuPD/q+SMkeSS1ok5ufPqZbzHPN868lU8tZLRaro=;
        b=VZdrBjrZrkRkxSOQbWx1KTvjdExhJWTtZAJYUv3c30/DNe1rj61BDiTn2w7yDYx2ghur1G
        Kd9kEwHUi7vEqmppZ1vGjTY3jbEgVAjsGqjtXF9umDW2+dxniPZhac8uoU23vt0qqdZdx8
        IYrf/TjwQlyuVSRS9fjBbEYcJOtioXk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-QuMMWukUOd2Tv-7RU588og-1; Fri, 17 Apr 2020 04:57:47 -0400
X-MC-Unique: QuMMWukUOd2Tv-7RU588og-1
Received: by mail-wr1-f69.google.com with SMTP id d17so655884wrr.17
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 01:57:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=57oFuPD/q+SMkeSS1ok5ufPqZbzHPN868lU8tZLRaro=;
        b=uTVSe9b246cFnwr8FDdfAJiFe/VB4Y3L5lCrM+bzUfNR3ymmUsVm75FPwIi/n32/ue
         GCIk5yWtpu2DKVOT1wQyj4kxqobu7whXLmppsmUYgWIDo7knspZ53RY1S9vdaSkatteP
         Euz+S8VithaAoGNu9HMxn4L+xEuPCrUb3C7kLw+XKhDd3XiWz/swxbi3Bcr8VE6sqLub
         7xkXvcRVbsnXbIq0CZmOPTuB14pYJyj2+O55htJs8xD+qa+cH3fkDg9osfUqYGn3QHk3
         8S4S3F2TRFTzQkZmRoWTZXi5g/IvrAPsdg2F7xvGI9Bk3zkI3aQ4KKu6R8vqxFUXbOvz
         25YA==
X-Gm-Message-State: AGi0PuZ7nVx/6AZyWByjSmkQp86+KF+0IWXIjG87SVPLHZX4FPekKd9p
        d3/McjnWYK/d3vkWo3hhfn+wDJaM6Jomdw9jGeW4IdSQ+JOzgzMtYmLYhzvymPadavKd9+tk14G
        XyMcDMiCAO1u1zxpf
X-Received: by 2002:a05:600c:4096:: with SMTP id k22mr2101845wmh.99.1587113865721;
        Fri, 17 Apr 2020 01:57:45 -0700 (PDT)
X-Google-Smtp-Source: APiQypKzNTX8c8fQ/vBkdSzMi35lJDuNvId/TTHeWg1TQWoHgILbrk1iRbqaecBOrIQnqlWsFeqPPQ==
X-Received: by 2002:a05:600c:4096:: with SMTP id k22mr2101824wmh.99.1587113865518;
        Fri, 17 Apr 2020 01:57:45 -0700 (PDT)
Received: from redhat.com (bzq-79-183-51-3.red.bezeqint.net. [79.183.51.3])
        by smtp.gmail.com with ESMTPSA id n6sm31931548wrs.81.2020.04.17.01.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 01:57:44 -0700 (PDT)
Date:   Fri, 17 Apr 2020 04:57:41 -0400
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
Message-ID: <20200417045454-mutt-send-email-mst@kernel.org>
References: <20200415024356.23751-1-jasowang@redhat.com>
 <20200416185426-mutt-send-email-mst@kernel.org>
 <b7e2deb7-cb64-b625-aeb4-760c7b28c0c8@redhat.com>
 <20200417022929-mutt-send-email-mst@kernel.org>
 <4274625d-6feb-81b6-5b0a-695229e7c33d@redhat.com>
 <20200417042912-mutt-send-email-mst@kernel.org>
 <fdb555a6-4b8d-15b6-0849-3fe0e0786038@redhat.com>
 <20200417044230-mutt-send-email-mst@kernel.org>
 <73843240-3040-655d-baa9-683341ed4786@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <73843240-3040-655d-baa9-683341ed4786@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 17, 2020 at 04:51:19PM +0800, Jason Wang wrote:
> 
> On 2020/4/17 下午4:46, Michael S. Tsirkin wrote:
> > On Fri, Apr 17, 2020 at 04:39:49PM +0800, Jason Wang wrote:
> > > On 2020/4/17 下午4:29, Michael S. Tsirkin wrote:
> > > > On Fri, Apr 17, 2020 at 03:36:52PM +0800, Jason Wang wrote:
> > > > > On 2020/4/17 下午2:33, Michael S. Tsirkin wrote:
> > > > > > On Fri, Apr 17, 2020 at 11:12:14AM +0800, Jason Wang wrote:
> > > > > > > On 2020/4/17 上午6:55, Michael S. Tsirkin wrote:
> > > > > > > > On Wed, Apr 15, 2020 at 10:43:56AM +0800, Jason Wang wrote:
> > > > > > > > > We try to keep the defconfig untouched after decoupling CONFIG_VHOST
> > > > > > > > > out of CONFIG_VIRTUALIZATION in commit 20c384f1ea1a
> > > > > > > > > ("vhost: refine vhost and vringh kconfig") by enabling VHOST_MENU by
> > > > > > > > > default. Then the defconfigs can keep enabling CONFIG_VHOST_NET
> > > > > > > > > without the caring of CONFIG_VHOST.
> > > > > > > > > 
> > > > > > > > > But this will leave a "CONFIG_VHOST_MENU=y" in all defconfigs and even
> > > > > > > > > for the ones that doesn't want vhost. So it actually shifts the
> > > > > > > > > burdens to the maintainers of all other to add "CONFIG_VHOST_MENU is
> > > > > > > > > not set". So this patch tries to enable CONFIG_VHOST explicitly in
> > > > > > > > > defconfigs that enables CONFIG_VHOST_NET and CONFIG_VHOST_VSOCK.
> > > > > > > > > 
> > > > > > > > > Acked-by: Christian Borntraeger<borntraeger@de.ibm.com>   (s390)
> > > > > > > > > Acked-by: Michael Ellerman<mpe@ellerman.id.au>   (powerpc)
> > > > > > > > > Cc: Thomas Bogendoerfer<tsbogend@alpha.franken.de>
> > > > > > > > > Cc: Benjamin Herrenschmidt<benh@kernel.crashing.org>
> > > > > > > > > Cc: Paul Mackerras<paulus@samba.org>
> > > > > > > > > Cc: Michael Ellerman<mpe@ellerman.id.au>
> > > > > > > > > Cc: Heiko Carstens<heiko.carstens@de.ibm.com>
> > > > > > > > > Cc: Vasily Gorbik<gor@linux.ibm.com>
> > > > > > > > > Cc: Christian Borntraeger<borntraeger@de.ibm.com>
> > > > > > > > > Reported-by: Geert Uytterhoeven<geert@linux-m68k.org>
> > > > > > > > > Signed-off-by: Jason Wang<jasowang@redhat.com>
> > > > > > > > I rebased this on top of OABI fix since that
> > > > > > > > seems more orgent to fix.
> > > > > > > > Pushed to my vhost branch pls take a look and
> > > > > > > > if possible test.
> > > > > > > > Thanks!
> > > > > > > I test this patch by generating the defconfigs that wants vhost_net or
> > > > > > > vhost_vsock. All looks fine.
> > > > > > > 
> > > > > > > But having CONFIG_VHOST_DPN=y may end up with the similar situation that
> > > > > > > this patch want to address.
> > > > > > > Maybe we can let CONFIG_VHOST depends on !ARM || AEABI then add another
> > > > > > > menuconfig for VHOST_RING and do something similar?
> > > > > > > 
> > > > > > > Thanks
> > > > > > Sorry I don't understand. After this patch CONFIG_VHOST_DPN is just
> > > > > > an internal variable for the OABI fix. I kept it separate
> > > > > > so it's easy to revert for 5.8. Yes we could squash it into
> > > > > > VHOST directly but I don't see how that changes logic at all.
> > > > > Sorry for being unclear.
> > > > > 
> > > > > I meant since it was enabled by default, "CONFIG_VHOST_DPN=y" will be left
> > > > > in the defconfigs.
> > > > But who cares?
> > > FYI, please seehttps://www.spinics.net/lists/kvm/msg212685.html
> > The complaint was not about the symbol IIUC.  It was that we caused
> > everyone to build vhost unless they manually disabled it.
> 
> 
> There could be some misunderstanding here. I thought it's somehow similar: a
> CONFIG_VHOST_MENU=y will be left in the defconfigs even if CONFIG_VHOST is
> not set.
> 
> Thanks

Hmm. So looking at Documentation/kbuild/kconfig-language.rst :

        Things that merit "default y/m" include:

        a) A new Kconfig option for something that used to always be built
           should be "default y".


        b) A new gatekeeping Kconfig option that hides/shows other Kconfig
           options (but does not generate any code of its own), should be
           "default y" so people will see those other options.

        c) Sub-driver behavior or similar options for a driver that is
           "default n". This allows you to provide sane defaults.


So it looks like VHOST_MENU is actually matching rule b).
So what's the problem we are trying to solve with this patch, exactly?

Geert could you clarify pls?


> 
> > 

