Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 625AB824C2
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 20:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730065AbfHESSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 14:18:17 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34766 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729566AbfHESSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 14:18:17 -0400
Received: by mail-lj1-f196.google.com with SMTP id p17so80099144ljg.1
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 11:18:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5iD60MN3ezKI1+xt5FlPDcJaTEoPJLW96DLDKH2MmR0=;
        b=iE+FUtbyhQBReXMFs/AskWLcvgd/yodYoWtSWjYVtfM97u9sBuci9qk0yCIzukFC8d
         wUBE9LYy0tnIdS/lsXHZ1oeGWKYBVTO3iE25fZGdyQraWv8mukTqdR30cur2nhoKMi+Z
         Tk7UdVlEzDzNFVJkAGktvGRDy6xJg/ofMPtTa9DJI9hVTx7vP7DU+PsOoV4c0QtQnPlO
         E/3X0OKflMisCILEvRf746yJxw4TBP5+/p0JLM81DkyTjjZKDV4XYAqRRB6kExgbrQ6Q
         7QXZUlNrYLaNUj5J8yjjddR3bywcVwktBU4L+ET5a3f0UgRLj7WjP2HeCIsCpOj4NzVV
         /M9w==
X-Gm-Message-State: APjAAAVg6m0h+lzGH5kquN/qje1yRM8mDp6VX/epKKfRVt4cC5P8KJ1D
        HB1TeZM/Ej08PtoJFSHA51SyJ3xdvokXGfStm/CsRjafRws=
X-Google-Smtp-Source: APXvYqzBELw4G2jCqYxgIDkXE9OFhaWwBRVhy7Ub8mvdIqBjWO2i1v3mF9Q01T8rDZyiz+sIt0VO0YHuvz2HFjdenWM=
X-Received: by 2002:a2e:9643:: with SMTP id z3mr80490301ljh.43.1565029095550;
 Mon, 05 Aug 2019 11:18:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190731183116.4791-1-mcroce@redhat.com> <20190805.105800.1380680189003158228.davem@davemloft.net>
In-Reply-To: <20190805.105800.1380680189003158228.davem@davemloft.net>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Mon, 5 Aug 2019 20:17:39 +0200
Message-ID: <CAGnkfhxRV=2G6Sxf_nZQekeXLsf64QkKqfN-9pN_Mi6Y+=nXRA@mail.gmail.com>
Subject: Re: [PATCH net] mvpp2: fix panic on module removal
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@free-electrons.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 5, 2019 at 7:58 PM David Miller <davem@davemloft.net> wrote:
>
> From: Matteo Croce <mcroce@redhat.com>
> Date: Wed, 31 Jul 2019 20:31:16 +0200
>
> > mvpp2 uses a delayed workqueue to gather traffic statistics.
> > On module removal the workqueue can be destroyed before calling
> > cancel_delayed_work_sync() on its works.
> > Fix it by moving the destroy_workqueue() call after mvpp2_port_remove().
>
> Please post a new version with the flush_workqueue() removed.

Hi,

I thought that it was already merged:

https://lore.kernel.org/netdev/20190801121330.30823-1-mcroce@redhat.com/

Let me know if it's ok already.

Regards,
-- 
Matteo Croce
per aspera ad upstream
