Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E42A215C607
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 17:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbgBMP4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 10:56:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58066 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727597AbgBMP4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 10:56:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581609370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4QU7uZENcxRUfqiM7K3X0/JKBCsiyDClS/c2wdkQrjg=;
        b=LX30mLB2eMDZPggmCzaUFvJf1+iWeA9aU8VuG4J6qRlbbAxuFdb2gsfIsQtsjTbcZ49w/k
        Ya3R1wiJGlAPJEKASqE1Pnuxp+MsX7klx+LVctcAbE5KSSkYeTcaAZrDH3e0H55aouyll9
        h3Dova5hufjpw4oeLvrHFVBDRtGNQ9g=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-bXb62qmEN-SRKAHv__7bxw-1; Thu, 13 Feb 2020 10:56:08 -0500
X-MC-Unique: bXb62qmEN-SRKAHv__7bxw-1
Received: by mail-qt1-f200.google.com with SMTP id r9so3932354qtc.4
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 07:56:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4QU7uZENcxRUfqiM7K3X0/JKBCsiyDClS/c2wdkQrjg=;
        b=SBRZKMEQt+x3Qjm9Nbs17x8u93yAp38tN9asVrIqXtByB5nruKtGxHrpT20KfZWnmp
         ADE65aCsNfsiTmPJ7e2CK5fj5eX6U9/FUHmT9KKyBgNOqkEM7DJyQEOPGtS7u1MqkGgL
         7+W8QzuB/Z/5L0n+OknLfNfSAU/oYpp3V/VTFDoI6pQ+uogUivG+aE9Tp6biBSxZiYZW
         BNwVElveqZrQTe6/pnvKZejmH83H8URIOHiuf0cIpys8w5+PJ4BFUPVcAhJxKvW0xbGa
         +gspdvdCE/eFvGlbTEMpHIRhFmMEYbsaz7Yy7M0yB1aUTiCvVRYQGuunxxmVOT+8wP/P
         g4cQ==
X-Gm-Message-State: APjAAAXwsZGbsrMh6tCV6mOeV5RnDK++sHzZ6gppLpRxSWOO7CnGRPvP
        Y1LxIMQbU48oGuJk8EmHwwORV9Ov65ilVZVZby/DFa7erJtUoiQ7Yyfb3P0MPdv3NQQK5UeznY6
        Bc1YkJB6gU4fsc0za
X-Received: by 2002:a05:620a:2194:: with SMTP id g20mr12784460qka.227.1581609367939;
        Thu, 13 Feb 2020 07:56:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqwwTNCl9VOR9NXth70L4mcZCSxDTc7p2/DaWb9KB+fHDHe7f/L4NfXn5L3kN2ExjUDHM2UKSQ==
X-Received: by 2002:a05:620a:2194:: with SMTP id g20mr12784445qka.227.1581609367767;
        Thu, 13 Feb 2020 07:56:07 -0800 (PST)
Received: from redhat.com (bzq-79-176-28-95.red.bezeqint.net. [79.176.28.95])
        by smtp.gmail.com with ESMTPSA id z21sm1523631qka.122.2020.02.13.07.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 07:56:07 -0800 (PST)
Date:   Thu, 13 Feb 2020 10:56:00 -0500
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
Message-ID: <20200213105425-mutt-send-email-mst@kernel.org>
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
> > That bus is exactly what Greg KH proposed. There are other ways
> > to solve this I guess but this bikeshedding is getting tiring.
> 
> This discussion was for a different goal, IMHO.

Hmm couldn't find it anymore. What was the goal there in your opinion?

-- 
MST

