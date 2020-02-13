Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA30515C65A
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 17:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387460AbgBMP7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 10:59:47 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32689 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728921AbgBMP7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 10:59:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581609584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YjESY5U+42gtKNpvEnDRTyHV+mXqJmvUAfYgrE7ny0Y=;
        b=iEuMHtMDQJGT4zIAt7kB0SgAoxppHf57ldT9HPdxkD0viABA+r+tkEXUR26GeUm2ouQMxX
        vUkUtdcFyX4wI0ATfy/TXFUoxc11eKOZpJAsUid0VKbVNl1tF78z1mQaMh5JdrbWqT7eGe
        ssShISjdGZKx/w8/nlOOL0vz229uI1U=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-dqVVk65GM3qLgjOd3AZ9NQ-1; Thu, 13 Feb 2020 10:59:42 -0500
X-MC-Unique: dqVVk65GM3qLgjOd3AZ9NQ-1
Received: by mail-qk1-f198.google.com with SMTP id n126so3986771qkc.18
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 07:59:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YjESY5U+42gtKNpvEnDRTyHV+mXqJmvUAfYgrE7ny0Y=;
        b=rB6snREfSMfTIOFidURDTVqlVM9NmpCB2Y/rAFQr30enpP4WnEYFF0WeYHtgFqPsaJ
         lDgu6miBNZGZTLTneuesKzhKo/2HnP707ZwAEoz6ZWW71h2Xh9BnKACGj5KJrPSsjJ+z
         IiElPFAknVovI+yqeiN0Nij7x+lcCyLsQ6wlaCN8xRuzECrOfNYxR5577XXLbTKA7t/P
         Cj4WLSY8ilASutiCbMaCgSHDRT/nobYcL6/Gjar7cyRm3EV6r1d2fBYE+puJWfp4XvI6
         ZSF/gap0X78TZo9FEFNWpxLrpWiDpQw/mYR5RYS9yQvCVH3J8QgMzPQCrzReipl6AKet
         A04Q==
X-Gm-Message-State: APjAAAVjNEQ89f0leHto0ja7pXMe7YqDnlNI6umV2/+yxhr5yGKEyoJ8
        UaoFkOIJ1/d9BT36ftlh49cwGRhhDLNJ3VwuLHsOZ4USmtF9CppIhFPnXarfYijqJRBsq6zFMpd
        WWHqxQr5/4rkJ2vJT
X-Received: by 2002:a37:648c:: with SMTP id y134mr12655817qkb.112.1581609582442;
        Thu, 13 Feb 2020 07:59:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqwblUv4o0toVmVYl/HEAfrRzni+p8oGrxwrOCdC64VBDuyyCDEhJs814GPsgJHzOlkKNS9BGQ==
X-Received: by 2002:a37:648c:: with SMTP id y134mr12655792qkb.112.1581609582252;
        Thu, 13 Feb 2020 07:59:42 -0800 (PST)
Received: from redhat.com (bzq-79-176-28-95.red.bezeqint.net. [79.176.28.95])
        by smtp.gmail.com with ESMTPSA id b7sm1490925qka.67.2020.02.13.07.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 07:59:41 -0800 (PST)
Date:   Thu, 13 Feb 2020 10:59:34 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, tiwei.bie@intel.com,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com,
        xiao.w.wang@intel.com, haotian.wang@sifive.com,
        lingshan.zhu@intel.com, eperezma@redhat.com, lulu@redhat.com,
        parav@mellanox.com, kevin.tian@intel.com, stefanha@redhat.com,
        rdunlap@infradead.org, hch@infradead.org, aadam@redhat.com,
        jiri@mellanox.com, shahafs@mellanox.com, hanand@xilinx.com,
        mhabets@solarflare.com
Subject: Re: [PATCH V2 3/5] vDPA: introduce vDPA bus
Message-ID: <20200213105743-mutt-send-email-mst@kernel.org>
References: <20200210035608.10002-4-jasowang@redhat.com>
 <20200211134746.GI4271@mellanox.com>
 <cf7abcc9-f8ef-1fe2-248e-9b9028788ade@redhat.com>
 <20200212125108.GS4271@mellanox.com>
 <12775659-1589-39e4-e344-b7a2c792b0f3@redhat.com>
 <20200213134128.GV4271@mellanox.com>
 <ebaea825-5432-65e2-2ab3-720a8c4030e7@redhat.com>
 <20200213150542.GW4271@mellanox.com>
 <20200213103714-mutt-send-email-mst@kernel.org>
 <20200213155154.GX4271@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213155154.GX4271@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 13, 2020 at 11:51:54AM -0400, Jason Gunthorpe wrote:
> The 'class' is supposed to provide all the library functions to remove
> this duplication. Instead of plugging the HW driver in via some bus
> scheme every subsystem has its own 'ops' that the HW driver provides
> to the subsystem's class via subsystem_register()

Hmm I'm not familiar with subsystem_register. A grep didn't find it
in the kernel either ...

-- 
MST

