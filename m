Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3713EC6E0
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 05:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235077AbhHODbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 23:31:50 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:40109 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233848AbhHODbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 23:31:49 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id F34C73200495;
        Sat, 14 Aug 2021 23:31:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sat, 14 Aug 2021 23:31:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        joshtriplett.org; h=date:from:to:cc:subject:message-id
        :references:mime-version:content-type:in-reply-to; s=fm1; bh=cM4
        DX2lhZr7xluQil3c+RS5Cm5n79DJ7je3T1iCiJkQ=; b=rsDQe+Kt5YffBNxlowO
        nPdIbp2mt6q7z8Kj0qwpJ3hVHtSCHvppjapQnBj4YMDKWtEDYbc8qT9STz67G6X1
        E9c9sHpGvpTMSbWe92Df/Yh9Z3PVXVSgrU6F1zKU548DPTP7l3Mn97MTqFUBwlQH
        Ye30GF/MuOHy8T72a1+wWVZjtgKwbPmozX2tZajnfoT9/OI5+OehuhzWAhsvbgzr
        dS+aTxbjg5GDP6Lt1eVf1zIo6Z4h2saeU20V00PtgNg4THaqX9/ryBaeGH1lI8bq
        jLT7od2he9ZYv2f5uSJDdtcyj1iRw3h3R87rniaMRR3DgwRnU3Rwyx1E65KiHbk1
        j5A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=cM4DX2
        lhZr7xluQil3c+RS5Cm5n79DJ7je3T1iCiJkQ=; b=fdXoxvPe1qoqoiClYkXb+2
        iGqUghOaQf9Q0luhsIzdoPle1k/8JL/OnaPRFRnCk/sjdzQCCHVYyN3BUTImZrw3
        FJD9DoNETFZzN/pvV7Y1QV57yx5rnEcWdAP42Z1gonjOAjCyXv9EAWNMuEpqL+Ta
        U7pQFlMc8hk2NGe4xaaws4ysN0/qmp8SnCVnH2cPpHN38GiZwbpctpf9i5BOSde9
        9yn7Ndxs4xd7LPzAxb0iSvIvx+KZpOQHhtB8QBrssIVUDwvAhBRplUdvjsgDjV9k
        cCCdEEi5KNRXsxr20ugh5JmDk1HO6RfFJCmqsvc3hR0exS3IF9iIgkI8nqHj90IA
        ==
X-ME-Sender: <xms:hYoYYYK93iDeqrESxFkZUXxdJF_u8bbDq3-u4oTZqlpwh2hwFP8q7A>
    <xme:hYoYYYKY59Su5g5aBreROCPXBv13XQP1plMRkZ3nktbL1I5QfJ_fZ-0eHOxbozeEy
    dmR6xcAIbe1xcYP_pc>
X-ME-Received: <xmr:hYoYYYsT2QQFPWDcGAXjExVbnqDchM-gUZcuW-0yHuIkdLjBMJPSVxA91QQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrkeekgdejvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheplfhoshhhucfv
    rhhiphhlvghtthcuoehjohhshhesjhhoshhhthhrihhplhgvthhtrdhorhhgqeenucggtf
    frrghtthgvrhhnpeegtdfgfeeghfevgeelgfefieegudeuheekkedtueeutefgheffveeg
    ueeiteehteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehjohhshhesjhhoshhhthhrihhplhgvthhtrdhorhhg
X-ME-Proxy: <xmx:hYoYYVagA-s4AiMnrysbQfzlwhTWStPsrVqdvb3v4FVOfU2zdlS9kg>
    <xmx:hYoYYfZMJPJjA6SCh11XqDjpo7Ulszm926KGBNxdm1PxwwscSi7wVA>
    <xmx:hYoYYRBlSH4ST7xF3nuGTk54e25oA0HZNbVobxD-JSMaDvbxy951mQ>
    <xmx:hooYYUOHXmB-yHdyjYIBqzK3E9c_Z-60od8X2qrNMACEkV7ZVkoU5g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 14 Aug 2021 23:31:16 -0400 (EDT)
Date:   Sat, 14 Aug 2021 20:31:15 -0700
From:   Josh Triplett <josh@joshtriplett.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH v2 0/4] open/accept directly into io_uring fixed file
 table
Message-ID: <YRiKg7tV+8oMtXtg@localhost>
References: <cover.1628871893.git.asml.silence@gmail.com>
 <YRbBYCn29B+kgZcy@localhost>
 <bcb6f253-41d6-6e0f-5b4b-ea1e02a105bc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcb6f253-41d6-6e0f-5b4b-ea1e02a105bc@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 14, 2021 at 01:50:24PM +0100, Pavel Begunkov wrote:
> On 8/13/21 8:00 PM, Josh Triplett wrote:
> > Rather than using sqe->file_index - 1, which feels like an error-prone
> > interface, I think it makes sense to use a dedicated flag for this, like
> > IOSQE_OPEN_FIXED. That flag could work for any open-like operation,
> > including open, accept, and in the future many other operations such as
> > memfd_create. (Imagine using a single ring submission to open a memfd,
> > write a buffer into it, seal it, send it over a UNIX socket, and then
> > close it.)
> > 
> > The only downside is that you'll need to reject that flag in all
> > non-open operations. One way to unify that code might be to add a flag
> > in io_op_def for open-like operations, and then check in common code for
> > the case of non-open-like operations passing IOSQE_OPEN_FIXED.
> 
> io_uring is really thin, and so I absolutely don't want any extra
> overhead in the generic path, IOW anything affecting
> reads/writes/sends/recvs.

There are already several checks for valid flags in io_init_req. For
instance:
        if ((sqe_flags & IOSQE_BUFFER_SELECT) &&
            !io_op_defs[req->opcode].buffer_select)
                return -EOPNOTSUPP;
It'd be trivial to make io_op_defs have a "valid flags" byte, and one
bitwise op tells you if any invalid flags were passed. *Zero* additional
overhead for other operations.

Alternatively, since there are so few operations that open a file
descriptor, you could just add a separate opcode for those few
operations. That still seems preferable to overloading a 16-bit index
field for this.

With this new mechanism, I think we're going to want to support more
than 65535 fixed-file entries. I can easily imagine wanting to handle
hundreds of thousands of files or sockets this way.

> The other reason is that there are only 2 bits left in sqe->flags,
> and we may use them for something better, considering that it's
> only open/accept and not much as this.

pipe, dup3, socket, socketpair, pidfds (via either pidfd_open or a
ring-based spawn mechanism), epoll_create, inotify, fanotify, signalfd,
timerfd, eventfd, memfd_create, userfaultfd, open_tree, fsopen, fsmount,
memfd_secret.

Of those, I personally would *love* to have at least pipe, socket,
pidfd, memfd_create, and fsopen/fsmount/open_tree, plus some manner of
dup-like operation for moving things between the fixed-file table and
file descriptors.

I think this is valuable and versatile enough to merit a flag. It would
also be entirely reasonable to create separate operations for these. But
either way, I don't think this should just be determined by whether a
16-bit index is non-zero.

> I agree that it feels error-prone, but at least it can be wrapped
> nicely enough in liburing, e.g.
> 
> void io_uring_prep_openat_direct(struct io_uring_sqe *sqe, int dfd,
> 				 const char *path, int flags,
> 				 mode_t mode, int slot_idx);

That wrapper wouldn't be able to handle more than a 16-bit slot index
though.

> > Also, rather than using a 16-bit index for the fixed file table and
> > potentially requiring expansion into a different field in the future,
> > what about overlapping it with the nofile field in the open and accept
> > requests? If they're not opening a normal file descriptor, they don't
> > need nofile. And in the original sqe, you can then overlap it with a
> > 32-bit field like splice_fd_in.
> 
> There is no nofile in SQEs, though
> 
> req->open.nofile = rlimit(RLIMIT_NOFILE);

nofile isn't needed for opening into the fixed-file table, so it could
be omitted in that case, and another field unioned with it. That would
allow passing a 32-bit fixed-file index into open and accept without
growing the size of their structures. I think, with this new capability,
we're going to want a large number of fixed files available.

In the SQE, you could overlap it with the splice_fd_in field, which
isn't needed by any calls other than splice.

- Josh Triplett
