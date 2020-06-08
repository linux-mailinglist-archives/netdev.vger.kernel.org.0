Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B21C1F15CC
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 11:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729223AbgFHJpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 05:45:40 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:33357 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729243AbgFHJpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 05:45:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591609538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kol/mTHTVhoGIwKuk6EIdanpIihMAd/NI3dQP6aMTfw=;
        b=JK20nP9LVdqx6nPmQRTCMiX97aUjQbwJKGkCwW0l2ricxfYieigpNtiU8l22q33Ha0Lnwj
        oeekL9ZO/M+g/G2n3bfKIXJVpAlUWZewXIev8oEgwXPaCcxW3KSFCL7b9eNX9KXu9EkC3N
        BQvRf7abyO9YMo6/nzKYz3Lsb4K46IA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-CF_VYDk7PfytI_xQT7MGtA-1; Mon, 08 Jun 2020 05:45:36 -0400
X-MC-Unique: CF_VYDk7PfytI_xQT7MGtA-1
Received: by mail-wr1-f72.google.com with SMTP id e7so6963566wrp.14
        for <netdev@vger.kernel.org>; Mon, 08 Jun 2020 02:45:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kol/mTHTVhoGIwKuk6EIdanpIihMAd/NI3dQP6aMTfw=;
        b=oW7cdV/welLV9+c7TE0Nvg20BxM/Y98Co9hA3lyc70XdVP1JoUJem8znfA/nbd+NdW
         CAoKlhMr3X/HQsoTojj47wJNKpYirD9hYXbNw3btTZClPF1HMXLAqQFw+MKqRIkSqhc5
         BIGP9lgX54YibNAA/C5vdSmjjTOaVXemXfBu2Bx1VA6Qdxk2pskuUq1TQCgWAuowNSb8
         qz9aNByL087LxdM4zYKb6VrPR76VSyitntvyAlofvUa/d7BaXkNKjcv0QcJJiKwstv2v
         JzRzPAtH4DNEgkGlx5EmFBPzoOK3gZ1yop7qwGBs9VbrbhtY+hYeBnxJ13jWICnYCnGB
         ByJg==
X-Gm-Message-State: AOAM53054vWH8ghKjDd8l5E8pJZswTCQEgP2WpLVItblNcxKNTvvajYZ
        CloZkvXKsA2bBqbnoa2n97tVzOHK48RabMpgO41iXp7ikfONPoFeh/p5r4DiN38SvEzKlD+a1Ey
        zL81SZTXGuuLrXyAV
X-Received: by 2002:a1c:6606:: with SMTP id a6mr14991260wmc.37.1591609535375;
        Mon, 08 Jun 2020 02:45:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxxXd0c9S/NR+8Ws+FH4J22BlV9unbe3nngLympHYF/P34pWnt/4AiItXOTdFoZndGfb3hfQ==
X-Received: by 2002:a1c:6606:: with SMTP id a6mr14991247wmc.37.1591609535163;
        Mon, 08 Jun 2020 02:45:35 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id o10sm23169984wrj.37.2020.06.08.02.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 02:45:34 -0700 (PDT)
Date:   Mon, 8 Jun 2020 05:45:31 -0400
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
Message-ID: <20200608054453-mutt-send-email-mst@kernel.org>
References: <20200529080303.15449-6-jasowang@redhat.com>
 <20200602010332-mutt-send-email-mst@kernel.org>
 <5dbb0386-beeb-5bf4-d12e-fb5427486bb8@redhat.com>
 <6b1d1ef3-d65e-08c2-5b65-32969bb5ecbc@redhat.com>
 <20200607095012-mutt-send-email-mst@kernel.org>
 <9b1abd2b-232c-aa0f-d8bb-03e65fd47de2@redhat.com>
 <20200608021438-mutt-send-email-mst@kernel.org>
 <a1b1b7fb-b097-17b7-2e3a-0da07d2e48ae@redhat.com>
 <20200608052041-mutt-send-email-mst@kernel.org>
 <9d2571b6-0b95-53b3-6989-b4d801eeb623@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d2571b6-0b95-53b3-6989-b4d801eeb623@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 08, 2020 at 05:43:58PM +0800, Jason Wang wrote:
> > 
> > > Looking at
> > > pci_match_one_device() it checks both subvendor and subdevice there.
> > > 
> > > Thanks
> > 
> > But IIUC there is no guarantee that driver with a specific subvendor
> > matches in presence of a generic one.
> > So either IFC or virtio pci can win, whichever binds first.
> 
> 
> I'm not sure I get there. But I try manually bind IFCVF to qemu's
> virtio-net-pci, and it fails.
> 
> Thanks

Right but the reverse can happen: virtio-net can bind to IFCVF first.

-- 
MST

