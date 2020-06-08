Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7744F1F1A0F
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 15:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729762AbgFHN3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 09:29:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24996 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728988AbgFHN3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 09:29:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591622948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tAi5RnB11l/kNjeRk8ozS/jXDdeHeIrWEjaZ8oVwPv4=;
        b=OKWyGkd1pwRdILQTXpSQDQc08uqv3GrWExbVtJsi5G6VY4qEoneqpvj355/9vUc5oPCq39
        b0hAfVVJvOIMfJxHmHDod1+H2tYQfw0B5CIEd2/SM0nb8FgCd1wh2XaPZltsmWUsWce+Oa
        Nes9MmkTGdEclkNrlmd0DAM7bOsHiuY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-mj6KAqz1Owms7CRGBLTngg-1; Mon, 08 Jun 2020 09:29:06 -0400
X-MC-Unique: mj6KAqz1Owms7CRGBLTngg-1
Received: by mail-wr1-f70.google.com with SMTP id m14so7147708wrj.12
        for <netdev@vger.kernel.org>; Mon, 08 Jun 2020 06:29:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=tAi5RnB11l/kNjeRk8ozS/jXDdeHeIrWEjaZ8oVwPv4=;
        b=SvjPa3VsdeihEZl5VI053XsVS9fBDFk6oGzCgEx234Hdgwy9u072YbO9tYULBsrCzz
         7CwXk1AEot3LWQN43FH2HvyFf3eRrkinFls62Q2vx3QHBemUsg5w2r7LVWf7E2rsO4uD
         Z8c8mGTjVzvkezwhqCB5KOk5UglGGUhnM2Gr0exOg+/D+IcJvvxL7AHWVOrKPP/ZqHOh
         CmVDCCh75Y1oi9QwDOcqIuZnA5HdLI4kxvYjmEuH7Sjj2vPq8ckILdFyFPUGN/elJxr3
         ADeQvpcYtiIiNj8xtEW7I2h+AaKo0vAb0ttaDMfnDDwMita1rJtnF6xmzyhQLCk/BtNs
         WW8A==
X-Gm-Message-State: AOAM53257QFpajS8pH6KIAEU+selbpss1rTPMAMAPSG/71lCKNIw/HXi
        bV0dB+wLo8dW8BfzXOWqpBT8Kz0oNcZAVowqBTOPT7mPqVocyjyvIkd++wSh/2JnADlCD/QsNaP
        XhFos98yXoWUdvjLP
X-Received: by 2002:a5d:4a45:: with SMTP id v5mr23250529wrs.223.1591622945519;
        Mon, 08 Jun 2020 06:29:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxLsV4zKcIqO3YHdQC1Vbu08DLKVYtIAwGXFJX9rmOu7fddWNahirZvRHnTir6Z4zHxaZCpjg==
X-Received: by 2002:a5d:4a45:: with SMTP id v5mr23250502wrs.223.1591622945243;
        Mon, 08 Jun 2020 06:29:05 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id o20sm24303052wra.29.2020.06.08.06.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 06:29:04 -0700 (PDT)
Date:   Mon, 8 Jun 2020 09:29:01 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.miller@broadcom.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn, eli@mellanox.com
Subject: Re: [PATCH 5/6] vdpa: introduce virtio pci driver
Message-ID: <20200608092530-mutt-send-email-mst@kernel.org>
References: <20200607095012-mutt-send-email-mst@kernel.org>
 <9b1abd2b-232c-aa0f-d8bb-03e65fd47de2@redhat.com>
 <20200608021438-mutt-send-email-mst@kernel.org>
 <a1b1b7fb-b097-17b7-2e3a-0da07d2e48ae@redhat.com>
 <20200608052041-mutt-send-email-mst@kernel.org>
 <9d2571b6-0b95-53b3-6989-b4d801eeb623@redhat.com>
 <20200608054453-mutt-send-email-mst@kernel.org>
 <bc27064c-2309-acf3-ccd8-6182bfa2a4cd@redhat.com>
 <20200608055331-mutt-send-email-mst@kernel.org>
 <61117e6a-2568-d0f4-8713-d831af32814d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <61117e6a-2568-d0f4-8713-d831af32814d@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 08, 2020 at 06:07:36PM +0800, Jason Wang wrote:
> 
> On 2020/6/8 下午5:54, Michael S. Tsirkin wrote:
> > On Mon, Jun 08, 2020 at 05:46:52PM +0800, Jason Wang wrote:
> > > On 2020/6/8 下午5:45, Michael S. Tsirkin wrote:
> > > > On Mon, Jun 08, 2020 at 05:43:58PM +0800, Jason Wang wrote:
> > > > > > > Looking at
> > > > > > > pci_match_one_device() it checks both subvendor and subdevice there.
> > > > > > > 
> > > > > > > Thanks
> > > > > > But IIUC there is no guarantee that driver with a specific subvendor
> > > > > > matches in presence of a generic one.
> > > > > > So either IFC or virtio pci can win, whichever binds first.
> > > > > I'm not sure I get there. But I try manually bind IFCVF to qemu's
> > > > > virtio-net-pci, and it fails.
> > > > > 
> > > > > Thanks
> > > > Right but the reverse can happen: virtio-net can bind to IFCVF first.
> > > 
> > > That's kind of expected. The PF is expected to be bound to virtio-pci to
> > > create VF via sysfs.
> > > 
> > > Thanks
> > > 
> > > 
> > > 
> > Once VFs are created, don't we want IFCVF to bind rather than
> > virtio-pci?
> 
> 
> Yes, but for PF we need virtio-pci.
> 
> Thanks
> 

(Ab)using the driver_data field for this is an option.
What do you think?

-- 
MST

