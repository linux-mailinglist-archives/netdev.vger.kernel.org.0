Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF0B2AC6B0
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 22:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730187AbgKIVLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 16:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgKIVLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 16:11:09 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B7AC0613CF;
        Mon,  9 Nov 2020 13:11:09 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id f16so10371723otl.11;
        Mon, 09 Nov 2020 13:11:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ffJlmLjI1LxmQKvS2WnW7bcoolnwblQDAh0y1MpPzfA=;
        b=Hp9lxi8B1/DgblzGap4loUDg1qIMW6662Rz2j5oJhF991vRI85wWL9W8hWuiBM8M84
         MDshGGRrejg7yviPamY0b6j1xg7/IUMF+/+2eOG6I/a0cDV661/m7ZT/tC1J3pToI8SH
         T6mjDLturs1Rb5BoXfOWeF2rpi7qNIJ4Nf4+QDHoCOrpKujjLjA2eFOfsJenllwWcALh
         1gu4OAD+BibxUPyLFR5IHyymwGnIYHkRSUjnziE9ic1AbGi/Lq/q9BLFyrULhRuyO1d4
         ocYjRAg7WI2KaKQnoy0VDm7iHgp/nWjUNJLuBWOjPQO5GlOkwSAj79gq3y9rGyma34Tq
         CsYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ffJlmLjI1LxmQKvS2WnW7bcoolnwblQDAh0y1MpPzfA=;
        b=Hnft9BVhTaIJdW/lSrTXmJRgsNmXc7UQ5A9pWKT6GsC7/jMwta4z2fiWB0F48VanqK
         M7XxzUR/sQMWEsezOWydaC13cB3Ib0ihVmkYsrf+8FaDNz3liY8q+exbdf5gMmdvU39P
         8xL574Brxh/2XNOkY0ZM6jdC6L5uFQSAOAuvVgfnKe0WawGRGBFTeIXPSkckNhORaVK9
         0k5pxOA7AKA/mGVSQL5wv36FZbo41xXTaLlX8SKBRfLPZFalcIZwvBP2Up95hb88Pv0w
         CVKqNuVRNpystrUrZZQXZrkUHGeQks+F1jgDnX3vv/VpDh3eHrl0U7MjpotB7sA6Hcin
         SjtA==
X-Gm-Message-State: AOAM530bPF334SJg+9oU9OioP+jKyTBMAKSANul71PLVNI/qnRnNO2d3
        XTns5eDJGhn6/jY9HwtlP2OJzaIBRCbLBQ==
X-Google-Smtp-Source: ABdhPJyMMb0vc7gpgYWoRFFDPQ7mMhV5sYo98bKd0BJL7Hd/IXx7fTrkqclB06EXCy3S/p6RFzySKQ==
X-Received: by 2002:a05:6830:1015:: with SMTP id a21mr12378595otp.143.1604956268705;
        Mon, 09 Nov 2020 13:11:08 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 33sm2767395otr.25.2020.11.09.13.11.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 13:11:08 -0800 (PST)
Date:   Mon, 09 Nov 2020 13:10:59 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org,
        bpf@vger.kernel.org
Message-ID: <5fa9b06383a48_8c0e2087e@john-XPS-13-9370.notmuch>
In-Reply-To: <1604498942-24274-7-git-send-email-magnus.karlsson@gmail.com>
References: <1604498942-24274-1-git-send-email-magnus.karlsson@gmail.com>
 <1604498942-24274-7-git-send-email-magnus.karlsson@gmail.com>
Subject: RE: [Intel-wired-lan] [PATCH bpf-next 6/6] i40e: use batched xsk Tx
 interfaces to increase performance
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Use the new batched xsk interfaces for the Tx path in the i40e driver
> to improve performance. On my machine, this yields a throughput
> increase of 4% for the l2fwd sample app in xdpsock. If we instead just
> look at the Tx part, this patch set increases throughput with above
> 20% for Tx.
> 
> Note that I had to explicitly loop unroll the inner loop to get to
> this performance level, by using a pragma. It is honored by both clang
> and gcc and should be ignored by versions that do not support
> it. Using the -funroll-loops compiler command line switch on the
> source file resulted in a loop unrolling on a higher level that
> lead to a performance decrease instead of an increase.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_ethtool.c |   2 +-
>  drivers/net/ethernet/intel/i40e/i40e_main.c    |   4 +-
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c    |  14 ++-
>  drivers/net/ethernet/intel/i40e/i40e_txrx.h    |   3 +-
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c     | 127 ++++++++++++++++++-------
>  5 files changed, 110 insertions(+), 40 deletions(-)
> 

LGTM, although I mostly just reviewed the API usage. Maciej's seems like
a nice cleanup.

Acked-by: John Fastabend <john.fastabend@gmail.com>
