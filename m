Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97C062406A6
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 15:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgHJNhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 09:37:09 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:23640 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726633AbgHJNhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 09:37:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597066627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b/qxK5C6ePLAWVdlOOgywCTwX3DZjSUnV1UIiKmwyDg=;
        b=ByifV7GicXk5g52Pd+PddF/ZmZK90SKpSc/SKRlwYM/GN8KH32yHm/6q2oqeWaLLDBSCvl
        SUiU2qsPS8uc7juaP78BHWvoJvgx7ZkRQGSvE+NBUpgSJvHtHdZq3Qo5gZyuKRN5KOgd9+
        300ONfMR68viGohDoqV31stCwn6QHSs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-cqTwun9NPmWBmAu0VcthhQ-1; Mon, 10 Aug 2020 09:37:05 -0400
X-MC-Unique: cqTwun9NPmWBmAu0VcthhQ-1
Received: by mail-wm1-f69.google.com with SMTP id q15so2874502wmj.6
        for <netdev@vger.kernel.org>; Mon, 10 Aug 2020 06:37:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=b/qxK5C6ePLAWVdlOOgywCTwX3DZjSUnV1UIiKmwyDg=;
        b=LRCGrRQfwA/tNL3UcUPJfjJsBAhRowsBzUsViQs55yOk0NXjUie9zepobXzWjSwAhj
         AYEK8QhtB1e3JhDRi1OgAnQHuK1DN38EUUNlkFj9ob31QMGsZ459g0VFjPCbHgMHnouv
         7D7icINhrAdk+JXc4Wq9tfmgKAjbb0R2Jc1wxPGVrA6csOFOaHH7Lygt8jLaX7hyEtpi
         tIFUqL8mgCp5BkTxv7gk75Lyj+1pqAG1DKGNmB1RNjJkyI4+HH7noN7TLotqRtxbuMB7
         t3aJHGC6RSZN76S5ytVJReGj/H7wW2fIhq+mq8WGAe6jb1XBAj67iPil5QzJie1Gkgfu
         2JkA==
X-Gm-Message-State: AOAM533eoXCWEkpAlvQdMi4B+8rbWcfqDSwe3pyyYoSUpbffuGTWdRA9
        142++oYYvhzPDgzH0IITwSNXttlOlhMAnt0o3oXqy4N7V5QA+0LmM6evLpf/lxfSqQFNSGo4ROM
        SdvtiHWKf4riQ4nlQ
X-Received: by 2002:a1c:5f44:: with SMTP id t65mr23851985wmb.99.1597066624612;
        Mon, 10 Aug 2020 06:37:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyntbXKihSaGm5opEK+za7CdlaF4OJ93oO4OKkytJl8FaoN1WxNcKI6KM/HsYZNiaqGUVp/wQ==
X-Received: by 2002:a1c:5f44:: with SMTP id t65mr23851960wmb.99.1597066624455;
        Mon, 10 Aug 2020 06:37:04 -0700 (PDT)
Received: from redhat.com (bzq-109-67-41-16.red.bezeqint.net. [109.67.41.16])
        by smtp.gmail.com with ESMTPSA id f12sm21591802wmc.46.2020.08.10.06.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2020 06:37:03 -0700 (PDT)
Date:   Mon, 10 Aug 2020 09:37:00 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        alex.williamson@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, eli@mellanox.com, shahafs@mellanox.com,
        parav@mellanox.com
Subject: Re: [PATCH V5 1/6] vhost: introduce vhost_vring_call
Message-ID: <20200810093630-mutt-send-email-mst@kernel.org>
References: <20200731065533.4144-1-lingshan.zhu@intel.com>
 <20200731065533.4144-2-lingshan.zhu@intel.com>
 <5e646141-ca8d-77a5-6f41-d30710d91e6d@redhat.com>
 <d51dd4e3-7513-c771-104c-b61f9ee70f30@intel.com>
 <156b8d71-6870-c163-fdfa-35bf4701987d@redhat.com>
 <20200804052050-mutt-send-email-mst@kernel.org>
 <14fd2bf1-e9c1-a192-bd6c-f1ee5fd227f6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <14fd2bf1-e9c1-a192-bd6c-f1ee5fd227f6@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 05, 2020 at 10:16:16AM +0800, Jason Wang wrote:
> 
> On 2020/8/4 下午5:21, Michael S. Tsirkin wrote:
> > > > > >    +struct vhost_vring_call {
> > > > > > +    struct eventfd_ctx *ctx;
> > > > > > +    struct irq_bypass_producer producer;
> > > > > > +    spinlock_t ctx_lock;
> > > > > It's not clear to me why we need ctx_lock here.
> > > > > 
> > > > > Thanks
> > > > Hi Jason,
> > > > 
> > > > we use this lock to protect the eventfd_ctx and irq from race conditions,
> > > We don't support irq notification from vDPA device driver in this version,
> > > do we still have race condition?
> > > 
> > > Thanks
> > Jason I'm not sure what you are trying to say here.
> 
> 
> I meant we change the API from V4 so driver won't notify us if irq is
> changed.
> 
> Then it looks to me there's no need for the ctx_lock, everyhing could be
> synchronized with vq mutex.
> 
> Thanks

Jason do you want to post a cleanup patch simplifying code along these
lines?

Thanks,


> > 
> > 

