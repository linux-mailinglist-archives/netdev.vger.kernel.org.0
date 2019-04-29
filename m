Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 899E9E1A0
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 13:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbfD2Lxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 07:53:42 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33807 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727710AbfD2Lxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 07:53:42 -0400
Received: by mail-qk1-f193.google.com with SMTP id n68so5719577qka.1;
        Mon, 29 Apr 2019 04:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ul3c2O3zwznvdJ2VWLEgrsmh159CqjtjQ+hgeDcNwY4=;
        b=HuZFc5ePa7AJFbqznb8x/lUp6/h59MQryQi8/rWThiHTxOjiWm5LKCmp8BgG6YK8LZ
         fNwEHTHFiv5b9+jBzKLhS2wJBdsItP7KrsjH8AoBmaQ0E9bXigWK7hjySGrA6xPmHIxx
         RiPFtHz4nt7VxMxYRYY/Jm4kARXpz+bLLDQiEJQe/oG3iVWHcYlSiv5FaqFS3Rs+Oixe
         39IqiWVumWrTvfcrBFa/etCooT7DnG1uNzOy9mBCIalypHFdJVmKzm9cchzfcheqym9d
         IYcg4eJaciFCMxSy2M55YPNLqG05hclnWdGrN0DOYSKY+DiYMG8w2BMr4J0G+KpAEpPj
         XnIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ul3c2O3zwznvdJ2VWLEgrsmh159CqjtjQ+hgeDcNwY4=;
        b=kSp2eEknOduYCUw7Ud0XRntZ7oY3/BjcAzI4nGvyfds9mzAfDcZ9gsnhor9W0+srf6
         01Pl1O1oEVFU9aNJEic8Ii+eMqhvuSILES38Q+hP/tvjyEiFxSbun9iB4gh3VCxWpkG2
         X3KPl7yF+c+y+/JPcV1MCcGcyLEu/t1o302ID2dzCENLhDbbvKRXG0R6U2qlW3GT+66e
         uRoxyH6JaumCALcBoJgYnEFDl9lH3G1ss2USVvXmTnvzgMQFmnpJ9IYrsoy/zM7KOqMf
         iGCb3e1uHXVx2P71I68L++YAws8nMCmdyfAlu6R2EqcoF/tNYK2pHqKc4VgxMnq6GBA8
         TxDw==
X-Gm-Message-State: APjAAAWp3vIUN63mEX5paXJ6NElsga0ENC3Ij/rJJOuQtgubnoVr3ZPP
        bGNaXipRxLLYQk74KLStNVM=
X-Google-Smtp-Source: APXvYqy9C+GC6hVUvyex3SiTIjfQFK6razfe984ib1jzWD4yky4fY8yHVckWYLoELwlxERJatzcQeg==
X-Received: by 2002:a37:4ad4:: with SMTP id x203mr44615380qka.21.1556538821340;
        Mon, 29 Apr 2019 04:53:41 -0700 (PDT)
Received: from localhost.localdomain ([168.181.49.3])
        by smtp.gmail.com with ESMTPSA id l199sm15827216qke.54.2019.04.29.04.53.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Apr 2019 04:53:39 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 89307180CF6; Mon, 29 Apr 2019 08:53:36 -0300 (-03)
Date:   Mon, 29 Apr 2019 08:53:36 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH net] sctp: avoid running the sctp state machine
 recursively
Message-ID: <20190429115336.GF13306@localhost.localdomain>
References: <3a5d5e96521a5f53ed36ca85219294c34be7d0ef.1556518579.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a5d5e96521a5f53ed36ca85219294c34be7d0ef.1556518579.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 02:16:19PM +0800, Xin Long wrote:
> Ying triggered a call trace when doing an asconf testing:
> 
>   BUG: scheduling while atomic: swapper/12/0/0x10000100
>   Call Trace:
>    <IRQ>  [<ffffffffa4375904>] dump_stack+0x19/0x1b
>    [<ffffffffa436fcaf>] __schedule_bug+0x64/0x72
>    [<ffffffffa437b93a>] __schedule+0x9ba/0xa00
>    [<ffffffffa3cd5326>] __cond_resched+0x26/0x30
>    [<ffffffffa437bc4a>] _cond_resched+0x3a/0x50
>    [<ffffffffa3e22be8>] kmem_cache_alloc_node+0x38/0x200
>    [<ffffffffa423512d>] __alloc_skb+0x5d/0x2d0
>    [<ffffffffc0995320>] sctp_packet_transmit+0x610/0xa20 [sctp]
>    [<ffffffffc098510e>] sctp_outq_flush+0x2ce/0xc00 [sctp]
>    [<ffffffffc098646c>] sctp_outq_uncork+0x1c/0x20 [sctp]
>    [<ffffffffc0977338>] sctp_cmd_interpreter.isra.22+0xc8/0x1460 [sctp]
>    [<ffffffffc0976ad1>] sctp_do_sm+0xe1/0x350 [sctp]
>    [<ffffffffc099443d>] sctp_primitive_ASCONF+0x3d/0x50 [sctp]
>    [<ffffffffc0977384>] sctp_cmd_interpreter.isra.22+0x114/0x1460 [sctp]
>    [<ffffffffc0976ad1>] sctp_do_sm+0xe1/0x350 [sctp]
>    [<ffffffffc097b3a4>] sctp_assoc_bh_rcv+0xf4/0x1b0 [sctp]
>    [<ffffffffc09840f1>] sctp_inq_push+0x51/0x70 [sctp]
>    [<ffffffffc099732b>] sctp_rcv+0xa8b/0xbd0 [sctp]
> 
> As it shows, the first sctp_do_sm() running under atomic context (NET_RX
> softirq) invoked sctp_primitive_ASCONF() that uses GFP_KERNEL flag later,
> and this flag is supposed to be used in non-atomic context only. Besides,
> sctp_do_sm() was called recursively, which is not expected.
> 
> Vlad tried to fix this recursive call in Commit c0786693404c ("sctp: Fix
> oops when sending queued ASCONF chunks") by introducing a new command
> SCTP_CMD_SEND_NEXT_ASCONF. But it didn't work as this command is still
> used in the first sctp_do_sm() call, and sctp_primitive_ASCONF() will
> be called in this command again.
> 
> To avoid calling sctp_do_sm() recursively, we send the next queued ASCONF
> not by sctp_primitive_ASCONF(), but by sctp_sf_do_prm_asconf() in the 1st
> sctp_do_sm() directly.
> 
> Reported-by: Ying Xu <yinxu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
