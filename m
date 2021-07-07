Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055993BEA4A
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 17:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbhGGPHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 11:07:20 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:48519 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232265AbhGGPHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 11:07:17 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.nyi.internal (Postfix) with ESMTP id 74E98580763;
        Wed,  7 Jul 2021 11:04:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 07 Jul 2021 11:04:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        joshtriplett.org; h=date:from:to:cc:subject:message-id
        :references:mime-version:content-type:in-reply-to; s=fm1; bh=dur
        Rgh7nlNjh4l/qLLgdtIkdBD/i2ynQzWbwrgYOkE0=; b=D1kWJ7ANgTNDNsf4z40
        yRJB50fZ3YDjvDyChljPSdRtQIvs1HU6WWtDehxJz3bodrH6rPpSwX2ZwgKOJTWz
        0a/oATDbiS3JLYYBcwYU1RZivpH/0ELAb3l6QifOp+++EnuNO79aVP/m/LE7LGK3
        LSNMbsMeoK1KvzRGyN1pWeUfOmPUla+tPmHO+Bx+vF9cO2MwOFxOYHpMusQU897Z
        XTlKDoarsRhR8OK8eX4v5N/wjNOLCy+lb+yRc3z4O60ID3vy4PMU5Zirqs6nX1VV
        z9GSd+oWNt0rBa5rLD8SUqHrdLDtUgPTR93vcqS6UMPO8r7RnyFr3GXwPhBBtPis
        /Bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=durRgh
        7nlNjh4l/qLLgdtIkdBD/i2ynQzWbwrgYOkE0=; b=MM/iDmFva6ziaURNaeBSZQ
        BacJzq5FnS1Sa1ZJp7DTRjCCSYg1vK09/1hA+GbKuO7IE1EbpiEr2mxNTdh2UBdm
        jjMMjH8TP0cRhYPze4upy+EJp2xBLIT/OoyEqQuR096fJfFxoJ7d42eUoM+PPI/G
        HdOtWe9mb5V5dH2GBcOFins4x77viESfZELXbJ1RTTapZ1YKQkM7yKO7B6hcQJIs
        Cxq+yYd2oSQ/An9d1rC0fa2FmREhRKeOAXOlkPABz8Sb1GuSx67sdeQEIgmvDQRF
        OGXtxtGlO9DDeVpUtzPIKYQujOtfSQuTtC1bzaYz7EJs2ilwf5/60yKgHKaoXWqQ
        ==
X-ME-Sender: <xms:esLlYLoa-2zNhdTC5z1fMh3BEKiHnJy5nlZMGWe_0yv_dddemclfFg>
    <xme:esLlYFqZWzghkYzoT1YzD2SQ38Ngs5NEGoesCiwCXFOVIn2JUE682jMbNvESRx8De
    mwu_rAyGl6qHZXzAZY>
X-ME-Received: <xmr:esLlYIN_H60V4bzSZY4heMXBDbpgwc1G28Rk3chBRQZvcmro9KOuH66sS70>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrtddvgdekvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheplfhoshhhucfv
    rhhiphhlvghtthcuoehjohhshhesjhhoshhhthhrihhplhgvthhtrdhorhhgqeenucggtf
    frrghtthgvrhhnpeejieethfeufeevvdekfedthfevueeuvddtudeiieevtdelvedtieev
    keduvdeitdenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuih
    iivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepjhhoshhhsehjohhshhhtrhhiphhl
    vghtthdrohhrgh
X-ME-Proxy: <xmx:esLlYO5ooG7hWV3gKBNNY0-ZTMXcMmeCUnS2akti9q-fxaQr1bsOaw>
    <xmx:esLlYK5FPpTTrPp0gVonclmgoihKm4LK3FosNAIdME72kwHE_2Ptyg>
    <xmx:esLlYGibbLKVctHQ6-Zrzx6TN4FKTDr3J96nWP2d58saprWzSM8zWA>
    <xmx:fMLlYMTmnH8_ZQY4sJNLABziuDmN_vpaQjF3FE_wX7wvc1yoMqHAtQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 7 Jul 2021 11:04:25 -0400 (EDT)
Date:   Wed, 7 Jul 2021 08:04:24 -0700
From:   Josh Triplett <josh@joshtriplett.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC 0/4] open/accept directly into io_uring fixed file table
Message-ID: <YOXCeNs0waut1Jh1@localhost>
References: <cover.1625657451.git.asml.silence@gmail.com>
 <48bd91bc-ba1a-1e69-03a1-3d6f913f96c3@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48bd91bc-ba1a-1e69-03a1-3d6f913f96c3@kernel.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 07, 2021 at 07:07:52AM -0600, Jens Axboe wrote:
> On 7/7/21 5:39 AM, Pavel Begunkov wrote:
> > Implement an old idea allowing open/accept io_uring requests to register
> > a newly created file as a io_uring's fixed file instead of placing it
> > into a task's file table. The switching is encoded in io_uring's SQEs
> > by setting sqe->buf_index/file_index, so restricted to 2^16-1. Don't
> > think we need more, but may be a good idea to scrap u32 somewhere
> > instead.
> > 
> > From the net side only needs a function doing __sys_accept4_file()
> > but not installing fd, see 2/4.
> > 
> > Only RFC for now, the new functionality is tested only for open yet.
> > I hope we can remember the author of the idea to add attribution.
> 
> Pretty sure the original suggester of this as Josh, CC'ed.

Thanks for working on this, Pavel!

Original thread at
https://lore.kernel.org/io-uring/20200715004209.GA334456@localhost/T/ in
case that helps.
