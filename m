Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B311F3F5115
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 21:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbhHWTOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 15:14:34 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54073 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231747AbhHWTOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 15:14:33 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 785645C01EB;
        Mon, 23 Aug 2021 15:13:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 23 Aug 2021 15:13:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        joshtriplett.org; h=date:from:to:cc:subject:message-id
        :references:mime-version:content-type:in-reply-to; s=fm1; bh=C4Y
        iITZLwd1FjTu1OcR03tOrxxe1bILHAoD/r95KPyA=; b=bowK4U65RhRyDD0/6nz
        kkN88O9v7TSy2myiNzHU11aMTem0HyXom+u0ipoGEusFSLlBimTIbDGU69oKL9tN
        Ro1E+tnbkAPiGy5Hw3yh5ZfZf4qRqxTvcT2AzzUlL2BBNn4t6twIRd3sYz5RYD/4
        7+UJe3fz4s66SDBWrKWg1E3mPQDljiswMRO+zkVzJq8IYtcfpO9wvdqOfvblUKK4
        rlf9+Wl+NUS+MxDhATWfExbhHrOEmIWyEBQ60astJhobGiLqf2XmjzbkOHcnf+mi
        FMM45gqNwJmn5eVR3SNMsreGCxSnOZGjWvFuh8bFIQkk30Gn4KfnaDSTiwEqhc1n
        WoA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=C4YiIT
        ZLwd1FjTu1OcR03tOrxxe1bILHAoD/r95KPyA=; b=RpNw4RGCsz9BUChMAYN8IO
        FKq4cX04tbcC9Ua/JM3uZ/7TxGRRAxC7/QyuXJY5jdDsIAh6t36IudXAHYlhVxBs
        Xq2UZD2xkt5BHFAqSFIvygdyNGUVTJaETKRjMC4eKsemRuG71o3tpT83hgeNiTw0
        4fWsDcrEMPpMHzt8oc+J0D7AO+ojHTsndmNNLLVIImYgSkHo9FbFJl+bjtkSlO/j
        o/5fMDfP1F377RiWO7fwpwSCH8D/llZwTfxTND9UDVkRvWNxCZjh+TyG6C5jMnhS
        DOmaVmFqx/qebxJ2YlQXJF+MHFY5j2QGWwJ3xrcCjCJ705UPAfT0U/hn0SrTLRdA
        ==
X-ME-Sender: <xms:bPMjYY4bVl6P0wsvXduso8KnC-dFL9AEXrJZIUE395UDIcAK39WdhQ>
    <xme:bPMjYZ5rSVp-GTbH9U19kSMvjM6DCUJ06skfXHDeBIect_1rbgCIVTkLhlDXwHgXI
    cMVxO5Rt7JUKcOidC0>
X-ME-Received: <xmr:bPMjYXce-5goCi7B3_sp9_D5ZiEpjlPR4Ba2lf6JaQ5StCp8UeOXN_2AvNNjg6WTDV29ZUA-SFJ2JpI7GZJbJsCYTS8bHw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddthedgudefiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheplfhoshhh
    ucfvrhhiphhlvghtthcuoehjohhshhesjhhoshhhthhrihhplhgvthhtrdhorhhgqeenuc
    ggtffrrghtthgvrhhnpeegtdfgfeeghfevgeelgfefieegudeuheekkedtueeutefgheff
    veegueeiteehteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpehjohhshhesjhhoshhhthhrihhplhgvthhtrdhorhhg
X-ME-Proxy: <xmx:bPMjYdJO4kzITS3RZjhQfWmabWZgXSbdMARIluHthVkNVOMJ-uuy6w>
    <xmx:bPMjYcL_BxF87dO7Mdclh0ebkaCSfOllC9Am8jcBgfT8d7H5JXp7tg>
    <xmx:bPMjYezN7vPeUcFdwE8w0pmNGa0XSj2thWcVPjBppMDFWCQtumRxcA>
    <xmx:bfMjYU-A2Qe3arxoxcfSX0zoKYEXPyorKhAVMTxv5PpZgica6Wwoxg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 23 Aug 2021 15:13:46 -0400 (EDT)
Date:   Mon, 23 Aug 2021 12:13:45 -0700
From:   Josh Triplett <josh@joshtriplett.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH v3 0/4] open/accept directly into io_uring fixed file
 table
Message-ID: <YSPzab+g8ee84bX7@localhost>
References: <cover.1629559905.git.asml.silence@gmail.com>
 <7fa72eec-9222-60eb-9ec6-e4b6efbfc5fb@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fa72eec-9222-60eb-9ec6-e4b6efbfc5fb@kernel.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 21, 2021 at 08:18:12PM -0600, Jens Axboe wrote:
> On 8/21/21 9:52 AM, Pavel Begunkov wrote:
> > Add an optional feature to open/accept directly into io_uring's fixed
> > file table bypassing the normal file table. Same behaviour if as the
> > snippet below, but in one operation:
> > 
> > sqe = prep_[open,accept](...);
> > cqe = submit_and_wait(sqe);
> > io_uring_register_files_update(uring_idx, (fd = cqe->res));
> > close((fd = cqe->res));
> > 
> > The idea in pretty old, and was brough up and implemented a year ago
> > by Josh Triplett, though haven't sought the light for some reasons.
> > 
> > The behaviour is controlled by setting sqe->file_index, where 0 implies
> > the old behaviour. If non-zero value is specified, then it will behave
> > as described and place the file into a fixed file slot
> > sqe->file_index - 1. A file table should be already created, the slot
> > should be valid and empty, otherwise the operation will fail.
> > 
> > we can't use IOSQE_FIXED_FILE to switch between modes, because accept
> > takes a file, and it already uses the flag with a different meaning.
> > 
> > since RFC:
> >  - added attribution
> >  - updated descriptions
> >  - rebased
> > 
> > since v1:
> >  - EBADF if slot is already used (Josh Triplett)
> >  - alias index with splice_fd_in (Josh Triplett)
> >  - fix a bound check bug
> 
> With the prep series, this looks good to me now. Josh, what do you
> think?

I would still like to see this using a union with the `nofile` field in
io_open and io_accept, rather than overloading the 16-bit buf_index
field. That would avoid truncating to 16 bits, and make less work for
expansion to more than 16 bits of fixed file indexes.

(I'd also like that to actually use a union, rather than overloading the
meaning of buf_index/nofile.)

I personally still feel that using non-zero to signify index-plus-one is
both error-prone and not as future-compatible. I think we could do
better with no additional overhead. But I think the final call on that
interface is up to you, Jens. Do you think it'd be worth spending a flag
bit or using a different opcode, to get a cleaner interface? If you
don't, then I'd be fine with seeing this go in with just the io_open and
io_accept change.

- Josh Triplett
