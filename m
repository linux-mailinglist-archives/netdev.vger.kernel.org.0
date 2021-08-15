Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809793EC704
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 05:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235530AbhHODmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 23:42:54 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:49187 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233848AbhHODmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 23:42:51 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 8415C320046E;
        Sat, 14 Aug 2021 23:42:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 14 Aug 2021 23:42:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        joshtriplett.org; h=date:from:to:cc:subject:message-id
        :references:mime-version:content-type:in-reply-to; s=fm1; bh=fsc
        QQUiCrfJu2B/FroGWlGgv8rX7vCHNTDmiXT/+3qg=; b=HPv8LWAWIBoYE5/gick
        zpULfhUf6sx7a1h7vcfHUgp1AgSThKYiQzOu30lYEEcOzBfdHr0fnSSJO1eI+ShK
        IOY2S8GA5uWCjzzN6Fm3TXcIVOaY/XsKXk0MpxWbJQr+vKCgbnop28IU0dye3V1Q
        BdB+TfzzOCI8MgQv/P/zA5OLC/N0isk8eWObyLRW23Wzl1067q1efxRMLYQ3fsKi
        VLrzYLOyDvghyfn/ql0Q5IsUbsjdoUUzSLu1rOWeFCAcNQ/QAQEVa1gtrMvcouWK
        aOLCXSr/ktBmntQexAZ/ABZT839MvkaAL5aodmmVrXaKKhixhBC4PYBfc8b99ob1
        eJA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=fscQQU
        iCrfJu2B/FroGWlGgv8rX7vCHNTDmiXT/+3qg=; b=d+z6GWPiqYOBUwIpYT1EfA
        RH4GJXsLkVCjT5UzWtYBuB5mjFBddQG51Emp7tRed027+Co8+84j3eOfnByCrh4k
        opaagkyrbb99WWcfmRb9xHXIkp9mV08voXfJsXDF6uT3p5u6irKQ7QK8x1rXSxqP
        Eihu0qU5Ja/NG09ZeFMxGosz781ChYQwSQ+Mug9xajxbnRCb9v+ohjujj1prlVc2
        pAotL1nY7A6DfI4p/oal8QBGV4XsSHxiZWFmUgZCkg62yxBcTQeZeUVZAeCBClQZ
        sFV/DBrpv31EptWIDhXr51Fb7HffAD1mxR2sEGFU33cJOIJMfwU8OevTE2fEYYig
        ==
X-ME-Sender: <xms:G40YYUF4FvkiJFFeg_I5hrmGYAHz4QmNNZm-7Qipk8gZ46H7UtpsyA>
    <xme:G40YYdW1fcC-33jHu3-S1lRhgPJlRdgCSHPIkVL_PnB4cxtNEVDeXLi1ZhlYdjGu3
    4jWdvnUU9pZgbkkPgE>
X-ME-Received: <xmr:G40YYeIhoDRCkO_EcoFaoZp9Xgq5sqhntVKOhCH5IzWNAknxv2YXwDJQFh0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrkeekgdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheplfhoshhhucfv
    rhhiphhlvghtthcuoehjohhshhesjhhoshhhthhrihhplhgvthhtrdhorhhgqeenucggtf
    frrghtthgvrhhnpeegtdfgfeeghfevgeelgfefieegudeuheekkedtueeutefgheffveeg
    ueeiteehteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehjohhshhesjhhoshhhthhrihhplhgvthhtrdhorhhg
X-ME-Proxy: <xmx:G40YYWHl2sPJlA_guR2wf2xBF-0xv6S14MAo5N_HJdPAP1AzPD_BTQ>
    <xmx:G40YYaWU-N3gGS-BJ4x3RJhuyca4bRn9avBmB12pLKVD6dqRo_TNuw>
    <xmx:G40YYZMkZncHJS7lVrDrfb4U7GiQdQuLUUUlp0OSP3sAvtvWxLGU4Q>
    <xmx:HY0YYcJvhvTrtcO6Vz0dxTK721wJE0ScOWeoOWAMs1HKKVk1mSYnIg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 14 Aug 2021 23:42:18 -0400 (EDT)
Date:   Sat, 14 Aug 2021 20:42:17 -0700
From:   Josh Triplett <josh@joshtriplett.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH v2 0/4] open/accept directly into io_uring fixed file
 table
Message-ID: <YRiNGTL2Dp/7vNzt@localhost>
References: <cover.1628871893.git.asml.silence@gmail.com>
 <YRbBYCn29B+kgZcy@localhost>
 <bcb6f253-41d6-6e0f-5b4b-ea1e02a105bc@gmail.com>
 <5cf40313-d151-9d10-3ebd-967eb2f53b1f@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5cf40313-d151-9d10-3ebd-967eb2f53b1f@kernel.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 14, 2021 at 05:03:44PM -0600, Jens Axboe wrote:
> What's the plan in terms of limiting the amount of direct descriptors
> (for lack of a better word)? That seems like an important aspect that
> should get sorted out upfront.
[...]
> Maybe we have a way to size the direct table, which will consume entries
> from the same pool that the regular file table does? That would then
> work both ways, and could potentially just be done dynamically similarly
> to how we expand the regular file table when we exceed its current size.

I think we'll want a way to size the direct table regardless, so that
it's pre-allocated and doesn't need to be resized when an index is used.
Then, we could do one of two equally easy things, depending on what
policy we want to set:

- Deduct the full size of the fixed-file table from the allowed number
  of files the process can have open. So, if RLIMIT_NOFILE is 1048576,
  and you pre-allocate 1000000 entries in the fixed-file table, you can
  have no more than 48576 file descriptors open. Stricter, but
  potentially problematic: a program *might* expect that it can
  dup2(some_fd, nofile - 1) successfully.

- Use RLIMIT_NOFILE as the maximum size of the fixed-file table. There's
  precedent for this: we already use RLIMIT_NOFILE as the maximum number
  of file descriptors you can have in flight over UNIX sockets.

I personally would favor the latter; it seems simple and
straightforward.
