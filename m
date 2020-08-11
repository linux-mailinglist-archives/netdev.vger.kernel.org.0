Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0973C241A72
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 13:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728738AbgHKLdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 07:33:51 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26345 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728755AbgHKLdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 07:33:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597145628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GiCPzZPtpDgWrMbwVo68Gc9UUX4p+0NK8qKoCf+Lg2k=;
        b=gI/FeK23M41k5meXY2J3IjYS42tHdB/K+Q1SVuMTLjw/wOcxZKxrHCBl5TYqCEDw3L38MC
        vOvtkbvH0nJ7WoGChrB5viI0Sqm8a6EcILU1BhptpSKGVDYxRKVdGHZoKy0wL5MbqRxTLb
        0b6Duxx1rjRItchpsi4zA7l+V2aYmWk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-jjsnTWxPOMyZ3etG9hOK_g-1; Tue, 11 Aug 2020 07:33:46 -0400
X-MC-Unique: jjsnTWxPOMyZ3etG9hOK_g-1
Received: by mail-wm1-f70.google.com with SMTP id s4so873614wmh.1
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 04:33:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GiCPzZPtpDgWrMbwVo68Gc9UUX4p+0NK8qKoCf+Lg2k=;
        b=EgVZPJKYulNCaTos6qa0xap9kksPdcDYZpqPwNlEu2le9GYFg4mYEGPd9A78g7uBml
         Fr7yki3aNkrxit0DcRCgp5/LHSWysoHk1t2NuLWEs837O6HXhJBFp3X6ew23aiQYobrk
         qBwo8JH+IpL2ZP2sgI2+l+XXQs3dAyiA6ZmfdCUR1S7sEu12BRgmBgXUiVm6bH6OONKT
         wxL18n7Phe4I61qye4PgH+z5iRq5xP99TPJNeAS0q+Dst2jWrbJCT+ZCL/t75juBGIHH
         SCHNHzoQDAbb/LVRoBo6hVOJQU+Pawa0N8etYTNO2/q5jLnPkGwjo8pX2r/vgFNDkirC
         b8Kg==
X-Gm-Message-State: AOAM530eHom1WXxGeGnM/SdzcQl+A4PbYPKuT3f6XLKuP7ILtmdHhf7s
        nwUd+e0PrSSan6TQByjnhwNCbZn6Pw53sNEOR2IfkUjetoJMTRxIiTzKKGfyyMzFRaXVuLO1duV
        Gan4OQzrCP7UK150t
X-Received: by 2002:a1c:2dcb:: with SMTP id t194mr3499778wmt.94.1597145625674;
        Tue, 11 Aug 2020 04:33:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzEaIvjLTJL/NIBPByzAEwifrGXrzHsoFwTXAZoU9RkSJbGkn6bslOVl7J4dDyoTVHhx7FazQ==
X-Received: by 2002:a1c:2dcb:: with SMTP id t194mr3499766wmt.94.1597145625527;
        Tue, 11 Aug 2020 04:33:45 -0700 (PDT)
Received: from redhat.com ([147.161.8.240])
        by smtp.gmail.com with ESMTPSA id 32sm27064327wrn.86.2020.08.11.04.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 04:33:44 -0700 (PDT)
Date:   Tue, 11 Aug 2020 07:33:26 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eli Cohen <elic@nvidia.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eli@mellanox.com" <eli@mellanox.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Majd Dibbiny <majd@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Shahaf Shuler <shahafs@mellanox.com>
Subject: Re: VDPA Debug/Statistics
Message-ID: <20200811073144-mutt-send-email-mst@kernel.org>
References: <BN8PR12MB342559414BE03DFC992AD03DAB450@BN8PR12MB3425.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB342559414BE03DFC992AD03DAB450@BN8PR12MB3425.namprd12.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 11, 2020 at 11:26:20AM +0000, Eli Cohen wrote:
> Hi All
> 
> Currently, the only statistics we get for a VDPA instance comes from the virtio_net device instance. Since VDPA involves hardware acceleration, there can be quite a lot of information that can be fetched from the underlying device. Currently there is no generic method to fetch this information.
> 
> One way of doing this can be to create a the host, a net device for each VDPA instance, and use it to get this information or do some configuration. Ethtool can be used in such a case
> 
> I would like to hear what you think about this or maybe you have some other ideas to address this topic.
> 
> Thanks,
> Eli

Something I'm not sure I understand is how are vdpa instances created
on mellanox cards? There's a devlink command for that, is that right?
Can that be extended for stats?

-- 
MST

