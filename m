Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEED01AD26C
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 23:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbgDPV6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 17:58:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37352 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728126AbgDPV6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 17:58:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587074328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M6rrlZafhN6r+ubaAk51QbjlJxlyC5zfccAUUw8zuIQ=;
        b=EjmCqUQUNepT3q3TW1CAHlKf2tMfLu4nMJKIy1zPpfGVeqUj+ElCpAo4zLQPZhwCXpBVu1
        9Rp/DQbzQCdVt2o0QbZ/Q6GOS5dmqCyND45j3kuW1wwS50PuIchk4gxnv3LdCjT2AMUQei
        22JbU079yHy5dxanIpDwXN6/Z7bLTWE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-H31Bjav8MnO25uLQCFkbbg-1; Thu, 16 Apr 2020 17:58:47 -0400
X-MC-Unique: H31Bjav8MnO25uLQCFkbbg-1
Received: by mail-wm1-f70.google.com with SMTP id 72so1860359wmb.1
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 14:58:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M6rrlZafhN6r+ubaAk51QbjlJxlyC5zfccAUUw8zuIQ=;
        b=eKLj1CZvH49KKXLE+rBqz/nKcmjcwf5r2qIk2sAZOg/4U6ZomPHTZPKT71QMEvGWm9
         ze8+IehxzVLOcgzCgZhAffo4N4jk00Cjmv4+m9jUPcjauS4TEZI64ZvVGjGz1EEmeBPf
         0dsYuB044cux7xe3aDJQJDWF7QOcAEKePRD2daH6PpsaiQIiPEf68f45lttCGQ7pFGR4
         /s2uXNgALOwYBB3ZAMrHVncx+/7ZSSZhx0nHUZspgsRPAH5KmGGSwuRUMoX8+jI/P20T
         AzqXy67Yk/TFjjPJyl9YCG6DPonjHA4R60qwE30HKKuoJ3x5FkCAevKY8qmwfnCuteBN
         A5nQ==
X-Gm-Message-State: AGi0PuYciNF1M5tiIc/Ebnu23X2/Ygt2m6fXhTnigeAXLBD+t5FwDUcU
        aYg65yrHCdmj2bpSc12cMuEb5QfeSHFS88tTzpQh8HQCMBt5nX7cMDm2z+cxSb8Pce6/lVdJgwg
        yJKbuXrF4tCUWRU9Q
X-Received: by 2002:a05:600c:2f17:: with SMTP id r23mr6583317wmn.81.1587074325858;
        Thu, 16 Apr 2020 14:58:45 -0700 (PDT)
X-Google-Smtp-Source: APiQypJuACRXU/ZXNyriL39YVRQFFxgHb4YC1TCpFzp0oXAv3mKwmNTGsmU40akcPlLbxfOx28D8Wg==
X-Received: by 2002:a05:600c:2f17:: with SMTP id r23mr6583297wmn.81.1587074325695;
        Thu, 16 Apr 2020 14:58:45 -0700 (PDT)
Received: from redhat.com (bzq-79-183-51-3.red.bezeqint.net. [79.183.51.3])
        by smtp.gmail.com with ESMTPSA id f79sm5629022wme.32.2020.04.16.14.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 14:58:45 -0700 (PDT)
Date:   Thu, 16 Apr 2020 17:58:42 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, ashutosh.dixit@intel.com,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Markus Elfring <elfring@users.sourceforge.net>,
        eli@mellanox.com, eperezma@redhat.com,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>, hulkci@huawei.com,
        "Cc: stable@vger.kernel.org, david@redhat.com, dverkamp@chromium.org,
        hch@lst.de, jasowang@redhat.com, liang.z.li@intel.com, mst@redhat.com,
        tiny.windzz@gmail.com," <jasowang@redhat.com>,
        matej.genci@nutanix.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        yanaijie@huawei.com, YueHaibing <yuehaibing@huawei.com>
Subject: Re: [GIT PULL] vhost: cleanups and fixes
Message-ID: <20200416175644-mutt-send-email-mst@kernel.org>
References: <20200414123606-mutt-send-email-mst@kernel.org>
 <CAHk-=wgVQcD=JJVmowEorHHQSVmSw+vG+Ddc4FATZoTp9mfUmw@mail.gmail.com>
 <20200416081330-mutt-send-email-mst@kernel.org>
 <CAHk-=wjduPCAE-sr_XLUdExupiL0bOU5GBfpMd32cqMC-VVxeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjduPCAE-sr_XLUdExupiL0bOU5GBfpMd32cqMC-VVxeg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 10:01:51AM -0700, Linus Torvalds wrote:
> On Thu, Apr 16, 2020 at 5:20 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > Well it's all just fallout from
> 
> What? No. Half of it seems to be the moving of "struct vring" around
> to other headers and stuff.
> 
> And then that is done very confusingly too, using two different
> structures both called "struct vring".
> 
> No way can I pull that kind of craziness as a "fix".
> 
>                 Linus

OK, I'll just disable vhost on that config for now - it was
suggested previously. Thanks for the comment and sorry about geeting it
wrong!


-- 
MST

