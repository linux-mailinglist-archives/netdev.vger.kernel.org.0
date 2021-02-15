Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0F531C205
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 19:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhBOS4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 13:56:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbhBOS4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 13:56:53 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE448C061574;
        Mon, 15 Feb 2021 10:56:12 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id e133so7744017iof.8;
        Mon, 15 Feb 2021 10:56:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=SQSWWhOt4LbW2fWjhsuI5CKPloySwVTsYk4IXTwjQFU=;
        b=ZP7AiuQQwb+LzzsKAczTaTGQlNlKCxx4D+cz+De1UnPJH99Yyd8ITSFE4uE22S1Qte
         gcAAJ7K2NY3nxm3IzxCGYHTbcVv2/szptG2Y6AqmjfrLm3Q90V7mNthxHGfpj49VpiQE
         5awG8eVAgbutOJ+PubkUuf7XMGdO67/YZNDpvqqolvXcsCMc/wt2R7f62HzvValbFwmW
         qQAKPkLe2WXt0dx54IsqQzMVqZPv32U4+2yKEOYW7QxfH2hX/nI+y5woReROE20bQCdp
         gJfKiaDXSr529yITGpny20BT4W5jywe2Lt5hnVyp8ucQDhtCXzSr8X0nbIW1iCruME2U
         UcBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=SQSWWhOt4LbW2fWjhsuI5CKPloySwVTsYk4IXTwjQFU=;
        b=Je/SBsIjBI64Bznsno7lHu/fwZzyDi+SVedU2leIPg2P/MNi+fzrLz0X1N2wdNMQps
         LXOJxO5e8YXtXxgCeTEa5azqZyledRovKF6rb1CqgNEQ5P+Rt8BwpR7XC/7L1Zmx94ra
         PltBS4jSRvqLxmLoWWYtm16c8f3WmfRIXHE4B82v1zrCXWk4KfOAENLYJbUR3zxRXfDH
         7RU94Ud+WJ4XaZ5UhpV+O6y6l0dpcXZk4pxCDxsbxDeju9EL6bFgVSzMb08pNOVhZIaV
         2vvHCT3oqyfIv0TQY3PRvPXls1uMfUjqFaWruseHqV3mBOAfHoZPdtDReM+JfuFiTK/B
         QCsA==
X-Gm-Message-State: AOAM531gi0kfr+u0dxrVBwWA2m+vTKZ8yv5qb174KsAq3I412YWFdTUw
        VTlkGhVwDb/IrPe0vytbHWs=
X-Google-Smtp-Source: ABdhPJxDBGalVRb3HBetwXgyuf6P+Iwt9bJzFCrcNrDn8ulZ4oEa0mOQQRxkSIfzMmFQ0H3DiumhdA==
X-Received: by 2002:a05:6638:2683:: with SMTP id o3mr7339223jat.8.1613415372189;
        Mon, 15 Feb 2021 10:56:12 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id g17sm9852308ilk.37.2021.02.15.10.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 10:56:11 -0800 (PST)
Date:   Mon, 15 Feb 2021 10:56:05 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <602ac3c4ec38f_3ed412084e@john-XPS-13-9370.notmuch>
In-Reply-To: <20210213214421.226357-3-xiyou.wangcong@gmail.com>
References: <20210213214421.226357-1-xiyou.wangcong@gmail.com>
 <20210213214421.226357-3-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next v3 2/5] skmsg: get rid of struct sk_psock_parser
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> struct sk_psock_parser is embedded in sk_psock, it is
> unnecessary as skb verdict also uses ->saved_data_ready.
> We can simply fold these fields into sk_psock, and get rid
> of ->enabled.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  include/linux/skmsg.h | 19 ++++++----------
>  net/core/skmsg.c      | 53 +++++++++++++------------------------------
>  net/core/sock_map.c   |  8 +++----
>  3 files changed, 27 insertions(+), 53 deletions(-)
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
