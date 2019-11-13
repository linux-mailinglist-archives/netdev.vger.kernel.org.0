Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFAB2F9FE5
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 02:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfKMBKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 20:10:40 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36561 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbfKMBKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 20:10:40 -0500
Received: by mail-qk1-f194.google.com with SMTP id d13so322116qko.3
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 17:10:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=x4YFBIiHP3tCKfwv97TZ757tOJUp27Y5Do0dHlzfclI=;
        b=QERGBFTyG9wdBTFp7VvuvhC6JZVqyULsImeZgRHIeSlgWqX2NrLL1g9oPpO45Z4eUt
         YvXYpeNIfE+cJ+n30iDAhvkg3Yf0ELXT5MXXW1MDihHj9BhEw8kM4Ogpn/oBVW4xXMRW
         Fpk3iJ1t4CWUOIjgu4+If4i18DuRTRBu53pBq5PfaQBoPZ69+swRtlqpZ7xh/CJdSkkC
         vVyIKmewN/+3CLKwTvx/xJ8NygO8TwM11L3fZ2X7M/LhNDg+ii9xxBhUXCHlMll6N8Y0
         LK5rZQtflkF0LeaH0zZ+1opFmFk9c8vuUvNKJGg0S8dgqCkNpSG30daLcNT8ewrF3O1C
         sN3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=x4YFBIiHP3tCKfwv97TZ757tOJUp27Y5Do0dHlzfclI=;
        b=TWCSpCofHp9cXYSpMgKU2y1P4SatVoF+8mL8XxmPg+RAIHiCAw4JI7E//IeUTxAM0W
         m9p52E4AbNVxuoGCLXSQ0EtcvWi4UGFVGbgEiACLReaz7XwPpdy2P5mmtespsZ5xGdy0
         3MOBHHwtMNX2Z4NS7pyKy2l/KtVMHvVeI9PzqtrC1m3xJxbTObwZBGR19W/W11g4dHyt
         eN0/yIuHxI0Iy6ZqciuLDjEI6y0aWj0wFDLOgojJUEFK9UcQRKVQbLw2tCKxoCv4L+7j
         q8nzofu3Fzghrz9YyIwrYX0crrdyfFqkBJdUhzlSUQW2uZwDtwgz5ithdoja8ezkJsDT
         GcPQ==
X-Gm-Message-State: APjAAAU+GjXh1QuNG8xbpghByklM5ipCvNFKsaHgtVvTEcGk//bGoCKu
        jVOJCkdK0qEOXOucosTc5whW+ZJ2M3A=
X-Google-Smtp-Source: APXvYqyitxsQDB6HMcZCN4768pg3s3fONA6MVe4C0LLl/bVmjU3sQC5+WrnupP6ZibkERkepRR7RuA==
X-Received: by 2002:a37:5942:: with SMTP id n63mr344942qkb.432.1573607439189;
        Tue, 12 Nov 2019 17:10:39 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-180.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.180])
        by smtp.gmail.com with ESMTPSA id d126sm212681qkc.93.2019.11.12.17.10.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Nov 2019 17:10:38 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1iUhB8-0005eu-Au; Tue, 12 Nov 2019 21:10:38 -0400
Date:   Tue, 12 Nov 2019 21:10:38 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        Kiran Patil <kiran.patil@intel.com>
Subject: Re: [net-next 1/1] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191113011038.GC19615@ziepe.ca>
References: <20191111192219.30259-1-jeffrey.t.kirsher@intel.com>
 <20191112212826.GA1837470@kroah.com>
 <20191113000819.GB19615@ziepe.ca>
 <AM0PR05MB48662DEDDE4750D399B8181ED1760@AM0PR05MB4866.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR05MB48662DEDDE4750D399B8181ED1760@AM0PR05MB4866.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 13, 2019 at 01:03:44AM +0000, Parav Pandit wrote:
 
> A small improvement below, because get_drvdata() and set_drvdata()

Here it was called 'devdata' not the existing drvdata - so something
different, I was confused for a bit too..

> is supposed to be called by the bus driver, not its creator.  And
> below data structure achieve strong type checks, no void* casts, and
> exactly achieves the foo_device example.  Isn't it better?

> mlx5_virtbus_device {
> 	struct virtbus_device dev;
> 	struct mlx5_core_dev *dev;
> };

This does seem a bit cleaner than using the void * trick (more, OOPy
at least)

Jason
