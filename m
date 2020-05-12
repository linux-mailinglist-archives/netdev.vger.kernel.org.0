Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889EC1CFF15
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 22:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730761AbgELUOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 16:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgELUOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 16:14:05 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4670BC061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 13:14:05 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id g16so11499703qtp.11
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 13:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZQnNlOsG2dvpIp3tLLIjxhO2Sz0nSKHvqh6+jc845XE=;
        b=FuIQVBZFzwyq9LzrOWVUNLm7UZp1JnPK7JDqlv1uqxG6anzXvr2/FQ3eIICY6mWQ02
         +elJVANbB8+NUhjiGvaxg5Tw9YbXbGTijP08Y7AZbVbUh2LUwyoNKTN3uR2DqaSikRZ8
         JuyYdUegewIRQg6+Jrnm14Loxv5JL1jPxuVDCvX41pQKfseVPy0EglwC6KT6SfqPbakW
         q9rFKkCK/Qx2K7vUuOw7aczf9spv5c1sbtS5y3ESt7wMfo3dUI+UP+fPL2ViUdYZ4PAJ
         ckv3uAaDJtKXJlF+VeT8zmYURFyqjUKkqFzsTubdG50Pjwnpldg1ECiTuyjA4B381sw1
         7Biw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZQnNlOsG2dvpIp3tLLIjxhO2Sz0nSKHvqh6+jc845XE=;
        b=C5cS1bVjJpma2wujV194UjrqbzWjGd3EHEnrxbnIMb3b0fnWIjuZX2DL0MsjqjsOpO
         MoBIEKmJlllzC5BJUQ/JVIoTqE6gc4BDgTJ/8UX70Ha95kkWDP4KowX0rA4YJnyQXZV8
         fMFBsnLDMEHjTJ+5yQdREXmgOxN+wUaJDNgCYQGq8iufqKLcPNRf49eUo2wJOaDZsZ37
         krePMm8tzOiUg3x87Uc/ziC3LASPgTsFhpoG0+ohwIYN4S421Zzy8gW4+CjSHGtdvhLX
         +OYmQr/WC/8L4imbJ7d5zutK5WMqWILWT5id8DxOkZ8pllGJMFtfkmpjvuRFOkcG8RIo
         /GaA==
X-Gm-Message-State: AGi0PuZbBbjHDBW0MXuyjHBWOiuHslFPHeH6gr44ikZOLVzKviLuIxls
        6AGQfL7J63J6qdMRpZdIIXZU9g==
X-Google-Smtp-Source: APiQypIJoczy+HLrhs09tcunxVOc0QRmsYL/tHM3hHFSUWS9WW9q57WFtBg0wlNKUTNnzJNhfet7eA==
X-Received: by 2002:aed:221c:: with SMTP id n28mr23415092qtc.235.1589314444465;
        Tue, 12 May 2020 13:14:04 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id n20sm8186506qtk.89.2020.05.12.13.14.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 May 2020 13:14:04 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jYbHv-0004El-ID; Tue, 12 May 2020 17:14:03 -0300
Date:   Tue, 12 May 2020 17:14:03 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Maor Gottlieb <maorg@mellanox.com>, linux-rdma@vger.kernel.org,
        Mark Bloch <markb@mellanox.com>,
        Mark Zhang <markz@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH mlx5-next v1 1/4] {IB/net}/mlx5: Simplify don't trap code
Message-ID: <20200512201403.GA16243@ziepe.ca>
References: <20200504053012.270689-1-leon@kernel.org>
 <20200504053012.270689-2-leon@kernel.org>
 <20200508195838.GA9696@ziepe.ca>
 <20200510081714.GA199306@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200510081714.GA199306@unreal>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 10, 2020 at 11:17:14AM +0300, Leon Romanovsky wrote:
> On Fri, May 08, 2020 at 04:58:38PM -0300, Jason Gunthorpe wrote:
> > On Mon, May 04, 2020 at 08:30:09AM +0300, Leon Romanovsky wrote:
> > > +	flow_act->action &=
> > > +		~MLX5_FLOW_CONTEXT_ACTION_FWD_NEXT_PRIO;
> > > +	flow_act->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
> > > +	handle = _mlx5_add_flow_rules(ft, spec, flow_act, dest, num_dest);
> > > +	if (IS_ERR_OR_NULL(handle))
> > > +		goto unlock;
> >
> > I never like seeing IS_ERR_OR_NULL()..
> >
> > In this case I see callers of mlx5_add_flow_rules() that crash if it
> > returns NULL, so this can't be right.
> >
> > Also, I don't see an obvious place where _mlx5_add_flow_rules()
> > returns NULL, does it?
> 
> You are right, I'll replace this IS_ERR_OR_NULL() to be IS_ERR() once
> will take it to mlx5-next.
> 
> Is it ok?

Okay, looks fine, let me know the shared branch commit

Jason
