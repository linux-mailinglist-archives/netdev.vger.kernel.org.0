Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66DB9CBD42
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 16:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388968AbfJDOcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 10:32:05 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:46795 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388883AbfJDOcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 10:32:05 -0400
Received: by mail-io1-f68.google.com with SMTP id c6so13871990ioo.13
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 07:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=aJenVMA+f4GgBI3kWbVc03KsvaObVfng4qs31GG5jnc=;
        b=T8KDVBHY7r4wf+ZeBl9C0pR8LVl4xgaupcjBZztEUrbhZdR9dHwSMN03xRWWRZYDKc
         ewneYPE1TyYsTyrlLjohoqRnfPT9EBFHbsLL0cMTqQtumvb1yYbQxJYcGJNONehfVz6v
         tCufTDsUkbGlnDf38w4gbaHF7Mfn9V531sxQ55ll0ozqC5KlSS3o3NMI4CiswZczg23T
         g3pd2SKJ80BtKXWy0kNmyDb6WPpgzJOxGRoYzDViautBtFnULogKG9G1IBEoI0OgCcRs
         A8EPl6ADq1hyNn+I5OG8nOptW7uTWo8xvivuCDKTbztbxSF1uiNCzH/sKv3u5G+nlC/j
         07vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=aJenVMA+f4GgBI3kWbVc03KsvaObVfng4qs31GG5jnc=;
        b=s0QQU3c+x2cZ1jw7ZsAo15Mq+kYVfru+44t05cozUzWhdE0mqHuMPGcV2/DGTLiWgH
         Fmsyi+ZWI0TIDirXL71PoMr//6493xDGILQVjQ9hsTJ9QCbMDSPI0JKSMzvA89FtOknv
         ZctQG6MKa0iJRphjB1QsEOzmsET2N66bybmrrxHDcOVseXM2uZNoPiqVZ6Up3WIdPQBF
         k7BI2+qIMlefOF3FF8951sf/1AQHVRUFnnw68oEaTzZrPIR0Zoq3EyAuDpwYM+yeX3U5
         9fszwbR3cKGoOIzoWUSbpeOXMFI7B9P9qdlE1T3VKZflN9uSD859B5XwZuU9zywUWWgK
         mUMQ==
X-Gm-Message-State: APjAAAXrGSQnx7K/sAIw+b9qShuPyiuTB7GKb8yf1xrjRfAvyXaeNMcx
        Hp2XTe2gCmGBdbUM9cj1/qA=
X-Google-Smtp-Source: APXvYqzlwClCtOgbZHNBD3WrvASbYaW9w7JcGD1EHmNK7DP0AyRcLpLnQt2a51mKN5uSZBkoXrcsYQ==
X-Received: by 2002:a05:6e02:c03:: with SMTP id d3mr16366224ile.229.1570199524424;
        Fri, 04 Oct 2019 07:32:04 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id g68sm2713957ilh.88.2019.10.04.07.32.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 07:32:03 -0700 (PDT)
Date:   Fri, 04 Oct 2019 07:31:54 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        davejwatson@fb.com, borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        atul.gupta@chelsio.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Message-ID: <5d9757da7e8b6_f6f2ad7ea6e45b45c@john-XPS-13-9370.notmuch>
In-Reply-To: <20191003181859.24958-1-jakub.kicinski@netronome.com>
References: <20191003181859.24958-1-jakub.kicinski@netronome.com>
Subject: RE: [PATCH net-next 0/6] net/tls: separate the TLS TOE code out
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> Hi!
> 
> We have 3 modes of operation of TLS - software, crypto offload
> (Mellanox, Netronome) and TCP Offload Engine-based (Chelsio).
> The last one takes over the socket, like any TOE would, and
> is not really compatible with how we want to do things in the
> networking stack.
> 
> Confusingly the name of the crypto-only offload mode is TLS_HW,
> while TOE-offload related functions use tls_hw_ as their prefix.
> 
> Engineers looking to implement offload are also be faced with
> TOE artefacts like struct tls_device (while, again,
> CONFIG_TLS_DEVICE actually gates the non-TOE offload).
> 
> To improve the clarity of the offload code move the TOE code
> into new files, and rename the functions and structures
> appropriately.
> 
> Because TOE-offload takes over the socket, and makes no use of
> the TLS infrastructure in the kernel, the rest of the code
> (anything beyond the ULP setup handlers) do not have to worry
> about the mode == TLS_HW_RECORD case.
> 
> The increase in code size is due to duplication of the full
> license boilerplate. Unfortunately original author (Dave Watson)
> seems unreachable :(
> 
> Jakub Kicinski (6):
>   net/tls: move TOE-related structures to a separate header
>   net/tls: rename tls_device to tls_toe_device
>   net/tls: move tls_build_proto() on init path
>   net/tls: move TOE-related code to a separate file
>   net/tls: rename tls_hw_* functions tls_toe_*
>   net/tls: allow compiling TLS TOE out
> 
>  drivers/crypto/chelsio/Kconfig            |   2 +-
>  drivers/crypto/chelsio/chtls/chtls.h      |   5 +-
>  drivers/crypto/chelsio/chtls/chtls_main.c |  20 ++--
>  include/net/tls.h                         |  37 +-----
>  include/net/tls_toe.h                     |  77 ++++++++++++
>  net/tls/Kconfig                           |  10 ++
>  net/tls/Makefile                          |   1 +
>  net/tls/tls_main.c                        | 124 ++-----------------
>  net/tls/tls_toe.c                         | 139 ++++++++++++++++++++++
>  9 files changed, 257 insertions(+), 158 deletions(-)
>  create mode 100644 include/net/tls_toe.h
>  create mode 100644 net/tls/tls_toe.c
> 
> -- 
> 2.21.0
> 

Looks good to me, nice bit of cleanup.

Acked-by: John Fastabend <john.fastabend@gmail.com>
