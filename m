Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B83B142A1A
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 13:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbgATMJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 07:09:21 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36703 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726775AbgATMJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 07:09:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579522159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ils+V+DNAQCUc++KUaM/zwaIHOd66hKtcZoyoJKDxck=;
        b=GCe3QNDJRURITeOgI1NabtNtvMz8orHIofX34AArN+lgV3sWaxgxt4DTnAGyrPh1aADYjn
        aawpz8iNZ07iMoXGnsXdxVu35gmunh540+gt1ivhRoo22UplJHXZeu7IW0I8TeBFMZlHjo
        WgSfsE2wUSPtq5/aaveLvPZg/oHbkfQ=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-r16BK_PlNGGuZR1OoI--bQ-1; Mon, 20 Jan 2020 07:09:17 -0500
X-MC-Unique: r16BK_PlNGGuZR1OoI--bQ-1
Received: by mail-qv1-f69.google.com with SMTP id di5so20741481qvb.3
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 04:09:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ils+V+DNAQCUc++KUaM/zwaIHOd66hKtcZoyoJKDxck=;
        b=q7lCWdbvhnpVy0h9fKMIfC8q93DuHZotxL28wIuEAvQIim5yOqP3dcWut3YKLfo1ja
         pENfu5pmXRuGqBt+rolrzuNFVMm0e4qWm5yH9L1T1uej6+aXNl1QhUCi+iEIcUwGu4Cg
         FsZ9s3/UdYXTViMJ4FL/wJ6E+SdFJbt7vdOKRdktjM9nCdtbJWicdPH7/3WvtFNkYVJk
         l6JeB6PEfSoW8hQDuy0Rip8N4f57I1nCcYY1uA8Cu8wVkNWYMEQSLCJUNk5gafgW0Aza
         na10Hv/5Bsq81A7KOLKV9o61etTT2/ASK2/bNqJRUEajIhdCGs8UYkJXriUmn4LpTwmH
         brsg==
X-Gm-Message-State: APjAAAXCJvIB5clUfoyCjZJM79qwu/3EaG0uvpGd4ri7D5sBLsukO8rf
        bEGMaWjCHmIo8qHhCa9rgMqeKmqwF/aQxN9rOhAAChn6fmnYSZ2ruFP9PiI1qggR2QTodMMuMen
        FPz64yivWwEuf7LO0
X-Received: by 2002:ac8:747:: with SMTP id k7mr20536101qth.120.1579522157158;
        Mon, 20 Jan 2020 04:09:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqyPRlGSUNQNiKSICSXdcPuLibX0Cl/JMb+oCpOV4CRtRfGtUmRXGfQQVE1MHMBhude5c31BGg==
X-Received: by 2002:ac8:747:: with SMTP id k7mr20536064qth.120.1579522156954;
        Mon, 20 Jan 2020 04:09:16 -0800 (PST)
Received: from redhat.com (bzq-79-179-85-180.red.bezeqint.net. [79.179.85.180])
        by smtp.gmail.com with ESMTPSA id t2sm15467285qkc.31.2020.01.20.04.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 04:09:15 -0800 (PST)
Date:   Mon, 20 Jan 2020 07:09:07 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Shahaf Shuler <shahafs@mellanox.com>,
        Rob Miller <rob.miller@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>,
        "Bie, Tiwei" <tiwei.bie@intel.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "Liang, Cunming" <cunming.liang@intel.com>,
        "Wang, Zhihong" <zhihong.wang@intel.com>,
        "Wang, Xiao W" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Ariel Adam <aadam@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
Subject: Re: [PATCH 3/5] vDPA: introduce vDPA bus
Message-ID: <20200120070710-mutt-send-email-mst@kernel.org>
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-4-jasowang@redhat.com>
 <20200117070324-mutt-send-email-mst@kernel.org>
 <239b042c-2d9e-0eec-a1ef-b03b7e2c5419@redhat.com>
 <CAJPjb1+fG9L3=iKbV4Vn13VwaeDZZdcfBPvarogF_Nzhk+FnKg@mail.gmail.com>
 <AM0PR0502MB379553984D0D55FDE25426F6C3330@AM0PR0502MB3795.eurprd05.prod.outlook.com>
 <20200119045849-mutt-send-email-mst@kernel.org>
 <d4e7fc56-c9d8-f01f-1504-dd49d5658037@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d4e7fc56-c9d8-f01f-1504-dd49d5658037@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 20, 2020 at 04:44:34PM +0800, Jason Wang wrote:
> 
> On 2020/1/19 下午5:59, Michael S. Tsirkin wrote:
> > On Sun, Jan 19, 2020 at 09:07:09AM +0000, Shahaf Shuler wrote:
> > > > Technically, we can keep the incremental API
> > > > here and let the vendor vDPA drivers to record the full mapping
> > > > internally which may slightly increase the complexity of vendor driver.
> > > What will be the trigger for the driver to know it received the last mapping on this series and it can now push it to the on-chip IOMMU?
> > Some kind of invalidate API?
> > 
> 
> The problem is how to deal with the case of vIOMMU. When vIOMMU is enabling
> there's no concept of last mapping.
> 
> Thanks

Most IOMMUs have a translation cache so have an invalidate API too.

-- 
MST

