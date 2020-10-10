Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5CF289F19
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 10:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729734AbgJJIBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 04:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728994AbgJJIBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 04:01:33 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D752AC0613CF;
        Sat, 10 Oct 2020 01:01:32 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 132so2292123pfz.5;
        Sat, 10 Oct 2020 01:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KSgS/yaA0WF+r8iYDZJ1qn48JHFSJ548EMw3n9b8mbU=;
        b=LssJWxpoRbxx7KVR2+T5gSPxakRpYk6ThunpIt+Ve3cPrj5sgsz/qaoCTHtsNkj3HT
         4xfTln987yLxtBF9PIfnNjeaQcHir7T4LoSGNVAL1UYj+1WcPU3gdvS5mZTYlE072oph
         ipJ6quiW3LuChTwlIlHeHy4rOFT7kO6tS4T9+Q972sLdjyxHTG+yIkAVO6G4tEiQw+9B
         PzgafSNPQsXLYKU0ngebl7SaUu44t3KYiA9P/KjygNRwcGGIAqcxdEca4GrJN0e1L3y+
         no5gO6j8h9Dp/yHYFf6/RKnF8ySQjiT+a36TkMzJOLegLjxACtDcIFWTnijcyaLzQOOA
         6DBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KSgS/yaA0WF+r8iYDZJ1qn48JHFSJ548EMw3n9b8mbU=;
        b=RoxJr+rCTfJrZXIldAnKN2HSRhnCgXIDuHL9AH/XNekQxA3bh9/VHtuRwdLrAgDxGg
         AqBKrU/7ViA2/pH5R03M7zOLVeoXJRei2ZTbf3OGOFEeiBA7h9nvvL9TjV2WhloiyDiE
         gkbAEdt7cmaP4YUWmjxxRzTDumaQy50y8mTC5cv6QgzoHqMAcxLQqK5NSYf+CSdirdfG
         g9qgzp0fp6ZTwKWR3DEDbWMkyhrOr7kbJBa2tXstsMx9dQyb+3M0qlrzEq/Outz1TRD0
         xNCABva034Rn1qX/IdxEx2JVXCIO3ycBz4HGgseTRD2OzJ6Dk6jqRZckTQnZuQFRika+
         Ovmw==
X-Gm-Message-State: AOAM5302TXNn/TxrPQrotLwnLR/XCuzxWARmyamu42rUa4NfFvJ5FAml
        jSuLKH8ZDnzlrQ/CBUyxMbk=
X-Google-Smtp-Source: ABdhPJzG0ttUOIjGPCl8WvqSp8YIkg1fTjAgioAxSxWF5XuiRy+45rzLYEYO6JrWt5Dl9mBgeP7rfQ==
X-Received: by 2002:a65:60d0:: with SMTP id r16mr6494572pgv.348.1602316892230;
        Sat, 10 Oct 2020 01:01:32 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id 84sm12866551pfx.120.2020.10.10.01.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 01:01:31 -0700 (PDT)
Date:   Sat, 10 Oct 2020 17:01:26 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     devel@driverdev.osuosl.org, Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 5/6] staging: qlge: clean up debugging code in the
 QL_ALL_DUMP ifdef land
Message-ID: <20201010080126.GC14495@f3>
References: <20201008115808.91850-1-coiby.xu@gmail.com>
 <20201008115808.91850-6-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008115808.91850-6-coiby.xu@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-08 19:58 +0800, Coiby Xu wrote:
> The debugging code in the following ifdef land
>  - QL_ALL_DUMP
>  - QL_REG_DUMP
>  - QL_DEV_DUMP
>  - QL_CB_DUMP
>  - QL_IB_DUMP
>  - QL_OB_DUMP
> 
> becomes unnecessary because,
>  - Device status and general registers can be obtained by ethtool.
>  - Coredump can be done via devlink health reporter.
>  - Structure related to the hardware (struct ql_adapter) can be obtained
>    by crash or drgn.
> 
> Suggested-by: Benjamin Poirier <benjamin.poirier@gmail.com>
> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
> ---
>  drivers/staging/qlge/qlge.h         |  82 ----
>  drivers/staging/qlge/qlge_dbg.c     | 688 ----------------------------
>  drivers/staging/qlge/qlge_ethtool.c |   2 -
>  drivers/staging/qlge/qlge_main.c    |   7 +-

Please also update drivers/staging/qlge/TODO accordingly. There is still
a lot of debugging code IMO (the netif_printk statements - kernel
tracing can be used instead of those) but this patch is a substantial
improvement.
