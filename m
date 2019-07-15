Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 317A069B7C
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 21:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731114AbfGOThA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 15:37:00 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39260 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730997AbfGOTg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 15:36:59 -0400
Received: by mail-pl1-f196.google.com with SMTP id b7so8812836pls.6;
        Mon, 15 Jul 2019 12:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZMZFpCm9N/xOShc4hGeJhjqpU1dBVFQxn4gJ5Yr8VYU=;
        b=ouMD/x07ooCJnj+NYt5TApE5G94vM5KbLQmbdXlQVy+akuMZEEpCrtND7YKQG5YUeA
         SwDKVhCmMNrLmoEdYnhOUJT7p2Js7T5gKnlL5psag4uSjc/eacvG09R20QX9ob1r4KGQ
         JPUttDZsH8R58YIqWxPGf4pAOehWEDqdzpRPAvVxKz6f5hK1dym19x1TE2jRz8hHVpx0
         UqQueUQ86Wq4EhgMr8yelYxObVmxnTeT2kl+gzYOROR0JeUAJOE9lJYDracn4NTfoh3G
         4sWnaSWux8Tb332IFGX3aPQu0kyiBn2izgQl68gsJm9ydw4yE3c+5dgMn2bBWXbyvUpu
         ia4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZMZFpCm9N/xOShc4hGeJhjqpU1dBVFQxn4gJ5Yr8VYU=;
        b=pjoc49IbJaKxLbKZHaDkuSsUjMEMsW2JWNGT5AaHLqMFSWOJOAq18yLvOkrKR1P+JH
         kkwYYQlaf3z7N5v95S/GqjSofPmtWvf+v6DylRp9DQD6BmsU3XUsDVKeActTjeMq1FZy
         TDrOCBE8xQRnEBGANGBKV5hldREo79BQ6BLNVqyzbHPqOnqv/M+VWLmpWEa2zi3RO1mS
         PMG/PJpvPJcifrLcRoThHsDzhvE0uPZ105rBAG8UlmsWcOg67VPd5DaAGJn2fgDyViIs
         UnDrd+vXZBgM9tsLNQ0ScptjZV4tUTaqHYprEIVkSZ3wl7s7ipkWtWiOwL/GUg8UL1mu
         dMdQ==
X-Gm-Message-State: APjAAAVGGjRN61LDLVDxX6DugNO8PAZ69Tjpvt8+V4ZctAMworLBQ4kI
        aJkg+vg1LLpgDyUfVOdB3Ts=
X-Google-Smtp-Source: APXvYqxiXiuWWcy55kFQPdkmhXEuhD4sgNJY5WWi5qbrL1Ybmgv+FOQ8bkjHLfFA1omJ8iRmDA1Qtg==
X-Received: by 2002:a17:902:4aa3:: with SMTP id x32mr28971983pld.119.1563219418289;
        Mon, 15 Jul 2019 12:36:58 -0700 (PDT)
Received: from bharath12345-Inspiron-5559 ([103.110.42.33])
        by smtp.gmail.com with ESMTPSA id n19sm18786840pfa.11.2019.07.15.12.36.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2019 12:36:57 -0700 (PDT)
Date:   Tue, 16 Jul 2019 01:06:38 +0530
From:   Bharath Vedartham <linux.bhar@gmail.com>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     akpm@linux-foundation.org, ira.weiny@intel.com,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Enrico Weigelt <info@metux.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Matt Sickler <Matt.Sickler@daktronics.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        YueHaibing <yuehaibing@huawei.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        kvm@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] mm/gup: Use put_user_page*() instead of put_page*()
Message-ID: <20190715193638.GC21161@bharath12345-Inspiron-5559>
References: <1563131456-11488-1-git-send-email-linux.bhar@gmail.com>
 <deea584f-2da2-8e1f-5a07-e97bf32c63bb@nvidia.com>
 <20190715065654.GA3716@bharath12345-Inspiron-5559>
 <1aeb21d9-6dc6-c7d2-58b6-279b1dfc523b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1aeb21d9-6dc6-c7d2-58b6-279b1dfc523b@nvidia.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 15, 2019 at 11:10:20AM -0700, John Hubbard wrote:
> On 7/14/19 11:56 PM, Bharath Vedartham wrote:
> > On Sun, Jul 14, 2019 at 04:33:42PM -0700, John Hubbard wrote:
> >> On 7/14/19 12:08 PM, Bharath Vedartham wrote:
> [...]
> >> 1. Pull down https://github.com/johnhubbard/linux/commits/gup_dma_core
> >> and find missing conversions: look for any additional missing 
> >> get_user_pages/put_page conversions. You've already found a couple missing 
> >> ones. I haven't re-run a search in a long time, so there's probably even more.
> >> 	a) And find more, after I rebase to 5.3-rc1: people probably are adding
> >> 	get_user_pages() calls as we speak. :)
> > Shouldn't this be documented then? I don't see any docs for using
> > put_user_page*() in v5.2.1 in the memory management API section?
> 
> Yes, it needs documentation. My first try (which is still in the above git
> repo) was reviewed and found badly wanting, so I'm going to rewrite it. Meanwhile,
> I agree that an interim note would be helpful, let me put something together.
> 
> [...]
> >>     https://github.com/johnhubbard/linux/commits/gup_dma_core
> >>
> >>     a) gets rebased often, and
> >>
> >>     b) has a bunch of commits (iov_iter and related) that conflict
> >>        with the latest linux.git,
> >>
> >>     c) has some bugs in the bio area, that I'm fixing, so I don't trust
> >>        that's it's safely runnable, for a few more days.
> > I assume your repo contains only work related to fixing gup issues and
> > not the main repo for gup development? i.e where gup changes are merged?
> 
> Correct, this is just a private tree, not a maintainer tree. But I'll try to
> keep the gup_dma_core branch something that is usable by others, during the
> transition over to put_user_page(), because the page-tracking patches are the
> main way to test any put_user_page() conversions.
> 
> As Ira said, we're using linux-mm as the real (maintainer) tree.
Thanks for the info! 
> 
> thanks,
> -- 
> John Hubbard
> NVIDIA
