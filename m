Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 212091A0D1B
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 13:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgDGLzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 07:55:51 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:45765 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbgDGLzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 07:55:51 -0400
Received: by mail-qk1-f195.google.com with SMTP id m67so75263qke.12
        for <netdev@vger.kernel.org>; Tue, 07 Apr 2020 04:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ceAe9s5g1bpqs/xuk9UoBUiTWj0Xhc3RDSdNgpswe0Q=;
        b=MgUm0WOp8c8FLGB7Ig9nz5OKFLDWqyBHiLaWKxbCjl1iyEUxM/1XZNr5O+NhZHo4fe
         R0Z4TJCHZYXh8L+/cnbal1UBc20KEWoa0ukvwx3SVgDGMMOhhguGv0RYFu+d5DyTCIBf
         jHKEw9N6iCFhBkxiuxyt5R7nS9hQi5T4HbwpN5hDyOlI7PsUtPVBvNEooBibfPsXyt+K
         nJWpiDXZcDh8f06MQ4IXCB9B6lojiTIDGV51LtXY/UuE+bzimWeak/KA3iFWTFKX3bks
         //GWpDCzc5fL8Z5Y01nEBk8UUbKsTx46WlNeMjhIq1HC7P85+dHAmmuXmnPMDcmhHg+B
         IOIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ceAe9s5g1bpqs/xuk9UoBUiTWj0Xhc3RDSdNgpswe0Q=;
        b=Xsvj2c8B8PqY2xkJaQv9D3ATiHelbPB7CQ+mFFxsnLUURAHTcYtjv1foyQGH4Hd816
         csuzsz88BiJCHoePu5l8mdeIEKjZTsPhgNuR4AtrfecF2bWntmtSdmhlni8rx8RJYo9i
         vk+DhK7k0EKbMgvyp5sP+U4mSi/YWzB+g/Jcgg8zpYlVM+G0b7ie4pF7lFly97FfQnkT
         ZsNyn/W1mU2v7SaPXNqzbj5Nsa4TA116fkhPOfiBD227Gesg637jzoKxTL0jsrnb0yhY
         jDfcS4Db2JjfQP0uHMUyEjIb491MjguvvCE/a8k+mWkVuAtFUQRnUNYCu51vOYVNWjuQ
         dL/Q==
X-Gm-Message-State: AGi0PuYnMs98VW6z295GF5MgGVcZ2t6GjhXcS8JCQX128RkjXyaxVPFW
        bMKBgZm5M8ykhiqEqqxuPzAinw==
X-Google-Smtp-Source: APiQypI6tyZXZJ/lR2tBYH+vI4JsVy0kISJi44Lw4iUz36y6gU16DjHD+k1n8fMNxZYuWTBREupC8w==
X-Received: by 2002:a05:620a:91d:: with SMTP id v29mr1681222qkv.424.1586260549945;
        Tue, 07 Apr 2020 04:55:49 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id q13sm7074962qki.136.2020.04.07.04.55.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 Apr 2020 04:55:49 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jLmpY-0007fp-Nb; Tue, 07 Apr 2020 08:55:48 -0300
Date:   Tue, 7 Apr 2020 08:55:48 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        syzbot <syzbot+9627a92b1f9262d5d30c@syzkaller.appspotmail.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Rafael Wysocki <rafael@kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: WARNING in ib_umad_kill_port
Message-ID: <20200407115548.GU20941@ziepe.ca>
References: <00000000000075245205a2997f68@google.com>
 <20200406172151.GJ80989@unreal>
 <20200406174440.GR20941@ziepe.ca>
 <CACT4Y+Zv_WXEn6u5a6kRZpkDJnSzeGF1L7JMw4g85TLEgAM7Lw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+Zv_WXEn6u5a6kRZpkDJnSzeGF1L7JMw4g85TLEgAM7Lw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 07, 2020 at 11:56:30AM +0200, Dmitry Vyukov wrote:
> > I'm not sure what could be done wrong here to elicit this:
> >
> >  sysfs group 'power' not found for kobject 'umad1'
> >
> > ??
> >
> > I've seen another similar sysfs related trigger that we couldn't
> > figure out.
> >
> > Hard to investigate without a reproducer.
> 
> Based on all of the sysfs-related bugs I've seen, my bet would be on
> some races. E.g. one thread registers devices, while another
> unregisters these.

I did check that the naming is ordered right, at least we won't be
concurrently creating and destroying umadX sysfs of the same names.

I'm also fairly sure we can't be destroying the parent at the same
time as this child.

Do you see the above commonly? Could it be some driver core thing? Or
is it more likely something wrong in umad?

Jason
