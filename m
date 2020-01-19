Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 978CE141D34
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 10:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgASJ7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 04:59:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38535 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726619AbgASJ7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 04:59:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579427972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9RBsez8nF60syx6uO6vVLgbM1Sl7Se03CnUJjUyZLN0=;
        b=Ttp0ogmmb+20ovN+AY/MU81VoXX/6cKDaCHOkEahXcc6WXi2BjiTNg7O0rqATJ/CeZEOur
        coZvpjUB/dzpl4F/klbNTxRNpNGvee1aQVPP6gDukQfufDqCwypHjB8hj7sIFUD1kerrA0
        qJHeY30HLQRiJBEuelj8lKsV1A7rrAQ=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-3EDmVQQoNAOeP-t9fuo3Xg-1; Sun, 19 Jan 2020 04:59:30 -0500
X-MC-Unique: 3EDmVQQoNAOeP-t9fuo3Xg-1
Received: by mail-qk1-f200.google.com with SMTP id k10so18527354qki.2
        for <netdev@vger.kernel.org>; Sun, 19 Jan 2020 01:59:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9RBsez8nF60syx6uO6vVLgbM1Sl7Se03CnUJjUyZLN0=;
        b=LL8i0GunUJW3uqfslt7fMvKeCIPti8Y5gh5AqcSX+nJNvus4zMGmiyCipTWqWWOn7y
         NVBkDX4OXYVCRqJVL7Jh6Vo8ryCz9W6wKdKodDW/IlPyBSXBzIUX46E/SXGZjq3nPDIP
         /WC8qc4r/RLMcj/WHIwgJ4HFJTBCwu0S1ZFm8oIeDohNPZ+QACbpNozvRi80a6zqn+e5
         NpNcvIP/PEh3oCDQhj+/l8HO4zYsmpxJ3I/Nfr8OfOSzcYf2xxENf4G/F6Pg8nVJi0st
         Txj4MuKWcAVInKkxB4WCXVqHDW6mnXdxng4kf5wNsNYgLTDSRl5WETrSNkhL6KcDOQR0
         bdlA==
X-Gm-Message-State: APjAAAUr8qJeBFqPJITRPAemI8/830ajwsowKp57H0M6nFlzD/DqUg6g
        KcutZS63y4mGLwncX9DgcetxHhiltfXv2QWw7rSSYIRJSvaAggufdWbYxpm9ed6dFh+QkJYeTWv
        HZF5eK/M3z7naRliu
X-Received: by 2002:a05:620a:166a:: with SMTP id d10mr45426261qko.37.1579427970353;
        Sun, 19 Jan 2020 01:59:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqyQHb/giklfzhDUxPQigzeGmKW4ihwH4cIVdw4qNSRvx+9dDqW3AslJF469jKiTK5R9qVYMmg==
X-Received: by 2002:a05:620a:166a:: with SMTP id d10mr45426237qko.37.1579427970157;
        Sun, 19 Jan 2020 01:59:30 -0800 (PST)
Received: from redhat.com (bzq-79-179-85-180.red.bezeqint.net. [79.179.85.180])
        by smtp.gmail.com with ESMTPSA id h1sm16162903qte.42.2020.01.19.01.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jan 2020 01:59:28 -0800 (PST)
Date:   Sun, 19 Jan 2020 04:59:20 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Shahaf Shuler <shahafs@mellanox.com>
Cc:     Rob Miller <rob.miller@broadcom.com>,
        Jason Wang <jasowang@redhat.com>,
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
Message-ID: <20200119045849-mutt-send-email-mst@kernel.org>
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-4-jasowang@redhat.com>
 <20200117070324-mutt-send-email-mst@kernel.org>
 <239b042c-2d9e-0eec-a1ef-b03b7e2c5419@redhat.com>
 <CAJPjb1+fG9L3=iKbV4Vn13VwaeDZZdcfBPvarogF_Nzhk+FnKg@mail.gmail.com>
 <AM0PR0502MB379553984D0D55FDE25426F6C3330@AM0PR0502MB3795.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR0502MB379553984D0D55FDE25426F6C3330@AM0PR0502MB3795.eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 19, 2020 at 09:07:09AM +0000, Shahaf Shuler wrote:
> >Technically, we can keep the incremental API 
> >here and let the vendor vDPA drivers to record the full mapping 
> >internally which may slightly increase the complexity of vendor driver. 
> 
> What will be the trigger for the driver to know it received the last mapping on this series and it can now push it to the on-chip IOMMU?

Some kind of invalidate API?

-- 
MST

