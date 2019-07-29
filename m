Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6D178D87
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 16:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbfG2OLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 10:11:44 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38658 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727403AbfG2OLn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 10:11:43 -0400
Received: by mail-qt1-f196.google.com with SMTP id n11so59766954qtl.5
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 07:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PsPDSb+DoW3u43zya3GiTnOJ6HaiQ4dl4ZawUa34njM=;
        b=mqbMtcNlpqUJwY0P+K1+JIC+dj5szUVllgsR5ZkCew4PvzNTl6r1482z5UzsVy19VS
         Eb489kblJC3GJOP3vesEbAXRGvUAv1FlGFAi6r+HvOESOWmfUyXjfS52+AxgJ5PZgt4s
         9pJ8k6jRIzTx7kcT4Wjta2biZwrVbf+eelpSbzuaMKGoR8UH81Z+V0i/9i6/Or8yccff
         QOi1tysAyCk3KuFQz0JvejSjcW1z0OGANHHaPk3YjdzbTPRKWZJgpEKJJAXj/YMjT7lJ
         53ZZpabUQLoWQgitMj50IHYERweSjnx08yIC5DQZYZQxGeBsdZ8Ya75g1clyHWezLxQY
         86yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PsPDSb+DoW3u43zya3GiTnOJ6HaiQ4dl4ZawUa34njM=;
        b=KnA61pWfLdHph5vKVil4Ea7DTnyIxXkMyIvq82lUyxxglKwTjgrR7CaHAdbNYQeXBD
         ksECActJLaSqTDVGysIGWtH17qSmwh5JMiikpoV08H/i5sXsnDcR/J7rOzlZeBxuqsR6
         oIeYdlQXAsw4bGuRSkkneNw/F2X5GZ8z5aSmzQ8kDzHAcFXdB3scAdYKBFXD/mmfJ83C
         lEBOvwtw7HqJg0uIsmd6ZhadC7RZ6XVN/yC6QztLKKiPj7BKRTgzKKbr+llY8thCXY0h
         gru5VNFRlmNxjspON11fLh83Zg1k4ArpTiGxvKhfhbTwvfum2bNns3dO9DMacr8I3jCW
         0FDA==
X-Gm-Message-State: APjAAAUOIw7z20nDC/RmZW63eqxxSzYa+ig9dUF2YNkWYitg5crFGgbq
        1GHO7Wg5LMH9sqWJQo8kh7fEog==
X-Google-Smtp-Source: APXvYqy3TjMKvhup091pqqRhQYwtyDyHn+0QcPM1UqudRdbpqDLZu7FJ2F3QCIxtgvq5+Aamwv+Zwg==
X-Received: by 2002:a0c:bd86:: with SMTP id n6mr80527285qvg.183.1564409502811;
        Mon, 29 Jul 2019 07:11:42 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id l63sm26425544qkb.124.2019.07.29.07.11.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Jul 2019 07:11:42 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hs6NK-000772-1m; Mon, 29 Jul 2019 11:11:42 -0300
Date:   Mon, 29 Jul 2019 11:11:42 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Kamal Heib <kamalheib1@gmail.com>
Cc:     Michal Kalderon <michal.kalderon@marvell.com>,
        ariel.elior@marvell.com, dledford@redhat.com, galpress@amazon.com,
        linux-rdma@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v6 rdma-next 1/6] RDMA/core: Create mmap database and
 cookie helper functions
Message-ID: <20190729141142.GD17990@ziepe.ca>
References: <20190709141735.19193-1-michal.kalderon@marvell.com>
 <20190709141735.19193-2-michal.kalderon@marvell.com>
 <20190725175540.GA18757@ziepe.ca>
 <20190728093051.GB5250@kheib-workstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190728093051.GB5250@kheib-workstation>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 28, 2019 at 12:30:51PM +0300, Kamal Heib wrote:
> > Maybe put this in ib_core_uverbs.c ?
> > 
> > Kamal, you've been tackling various cleanups, maybe making ib_uverbs
> > unloadable again is something you'd be keen on?
> >
> 
> Yes, Could you please give some background on that?

Most of it is my fault from being too careless, but the general notion
is that all of these

$ grep EXPORT_SYMBOL uverbs_main.c uverbs_cmd.c  uverbs_marshall.c  rdma_core.c uverbs_std_types*.c uverbs_uapi.c 
uverbs_main.c:EXPORT_SYMBOL(ib_uverbs_get_ucontext_file);
uverbs_main.c:EXPORT_SYMBOL(rdma_user_mmap_io);
uverbs_cmd.c:EXPORT_SYMBOL(flow_resources_alloc);
uverbs_cmd.c:EXPORT_SYMBOL(ib_uverbs_flow_resources_free);
uverbs_cmd.c:EXPORT_SYMBOL(flow_resources_add);
uverbs_marshall.c:EXPORT_SYMBOL(ib_copy_ah_attr_to_user);
uverbs_marshall.c:EXPORT_SYMBOL(ib_copy_qp_attr_to_user);
uverbs_marshall.c:EXPORT_SYMBOL(ib_copy_path_rec_to_user);
uverbs_marshall.c:EXPORT_SYMBOL(ib_copy_path_rec_from_user);
rdma_core.c:EXPORT_SYMBOL(uverbs_idr_class);
rdma_core.c:EXPORT_SYMBOL(uverbs_close_fd);
rdma_core.c:EXPORT_SYMBOL(uverbs_fd_class);
uverbs_std_types.c:EXPORT_SYMBOL(uverbs_destroy_def_handler);

Need to go into some 'ib_core uverbs support' .c file in the ib_core,
be moved to a header inline, or moved otherwise

Maybe it is now unrealistic that the uapi is so complicated, ie
uverbs_close_fd is just not easy to fixup..

Maybe the only ones that need fixing are ib_uverbs_get_ucontext_file
rdma_user_mmap_io as alot of drivers are entangled on those now.

The other stuff is much harder..

Jason
