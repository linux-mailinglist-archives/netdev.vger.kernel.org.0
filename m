Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF926151598
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 07:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgBDGCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 01:02:02 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37099 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726189AbgBDGCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 01:02:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580796120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RjdsRkXe77yTljkA9sXafvBdByUVdvxrTgCwvbrVV0w=;
        b=IbZjKwymJRgcTd3G6CGpLYAAv/ZFkF/CWUlC6k+vRLFkS2YTObk0LNK01tDBooKAUPWT5K
        M384Klin7NjILn5tULnraagONCrQx9R5wNKPiT6m6BmgtQBMB2kRpxVLeD0UKTT+wUp02O
        JRZusD1TMGIr4V9rW38iELK/zhKy2gw=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-6bo9LKfjN4-Cgtfka9TYqA-1; Tue, 04 Feb 2020 01:01:58 -0500
X-MC-Unique: 6bo9LKfjN4-Cgtfka9TYqA-1
Received: by mail-qv1-f71.google.com with SMTP id n11so11058667qvp.15
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 22:01:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RjdsRkXe77yTljkA9sXafvBdByUVdvxrTgCwvbrVV0w=;
        b=nFjIQiW4Zr5M2CI2gHLaaxyBOF8OIknvmr6ZDcHZROq7sO//91HJbnrAulH7tzI12E
         uBhOv75sAxhtLkuA6b1WJZHmFSgEtwzIzr5Rb5ymAdhP/m1V3oH92ULcqXehY3goGcjv
         YfIbXQX57DkbKqRDyzUVhUPoVqcLYk/4egkEaoppHWuaOwvM1gN2H+MzpnyVjSYAo2Ar
         RouCJBMVGmLapjaw2A2N3LUh7CPrkk2sx1GKtWLlZk/5oUdY9uhSXaVrD82VafSfFvwW
         QGGtnJU4LZPHDQ/b/Zlm1Ns6EfTBDhl9/W37gkko2yJCk+OPk4hUlUHYXmVTkmbU4cGN
         DBqw==
X-Gm-Message-State: APjAAAXHWsbt8x4+5DaTJT7jivkWV+DF2644jBjhgUVq0dA5GtXfMzEV
        9awaKE4+hDuFMkV25BqeFdmZOqn0k4FXL1JaypIU3zjWoVF1TEG2PWZ5g7Z8yM7l/r22cZB+OdE
        OSfDOXFcbfaSPd3+z
X-Received: by 2002:a05:620a:102c:: with SMTP id a12mr25836911qkk.95.1580796117496;
        Mon, 03 Feb 2020 22:01:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqwdvK3Ipy2qMCfUzq1ylzYT9IbitByfrekyORfLE2eptvuEIqJ12IuGLk9Wtkttgxshu+/I4A==
X-Received: by 2002:a05:620a:102c:: with SMTP id a12mr25836873qkk.95.1580796117247;
        Mon, 03 Feb 2020 22:01:57 -0800 (PST)
Received: from redhat.com (bzq-109-64-11-187.red.bezeqint.net. [109.64.11.187])
        by smtp.gmail.com with ESMTPSA id u24sm10612793qkm.40.2020.02.03.22.01.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 22:01:56 -0800 (PST)
Date:   Tue, 4 Feb 2020 01:01:48 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Tiwei Bie <tiwei.bie@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, shahafs@mellanox.com, jgg@mellanox.com,
        rob.miller@broadcom.com, haotian.wang@sifive.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        rdunlap@infradead.org, hch@infradead.org, jiri@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com,
        maxime.coquelin@redhat.com, lingshan.zhu@intel.com,
        dan.daly@intel.com, cunming.liang@intel.com, zhihong.wang@intel.com
Subject: Re: [PATCH] vhost: introduce vDPA based backend
Message-ID: <20200204005306-mutt-send-email-mst@kernel.org>
References: <20200131033651.103534-1-tiwei.bie@intel.com>
 <7aab2892-bb19-a06a-a6d3-9c28bc4c3400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7aab2892-bb19-a06a-a6d3-9c28bc4c3400@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 04, 2020 at 11:30:11AM +0800, Jason Wang wrote:
> 5) generate diffs of memory table and using IOMMU API to setup the dma
> mapping in this method

Frankly I think that's a bunch of work. Why not a MAP/UNMAP interface?

-- 
MST

