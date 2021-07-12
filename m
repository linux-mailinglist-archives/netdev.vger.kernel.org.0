Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0DF93C620B
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 19:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235231AbhGLRjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 13:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235721AbhGLRjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 13:39:11 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46251C0613DD;
        Mon, 12 Jul 2021 10:36:23 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id q190so18775970qkd.2;
        Mon, 12 Jul 2021 10:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Emwz+MroLadtaus1ZoD+3F9Z96hqXE/E+8R+5ln7fMM=;
        b=m1Jcei9QukGoT633lCszLCXO1mdVwS3wmhn/hCFQj/CYwOOV8u82O4wnTXC+Eq9/L8
         SsiuF8hb1pP0fDCWWgb6SV3nsvmIQEhTCwSrbGLzK+RHxVckZqTMZMQ3iGnz+JTf5fzQ
         RR5xObjV2HS0JuzJSyEHiMbpmepBN72NXoakSZQJzuDPe4iAlbWNGXFSJUaROCPrOIFH
         swfKB1BjDx1tzbQWX9BwTi369FHDRO58W/cWcPI8T1JuPQguDd8Lbxrs8kEQgPe+YnUm
         hqXBUfRyneBa7ebsTOWT5JGa/U2snzXz0rXHRVO1WZx5s3imjuWcCmkKhlksRFYpmQBE
         nPkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Emwz+MroLadtaus1ZoD+3F9Z96hqXE/E+8R+5ln7fMM=;
        b=tYG2Z+pi1AaibzP4dHO6MglwQsb/trK7LHT+MZEwH+XQTvsR736QSMZdWSL+c2Z00F
         P9xFMMnrsDlntIZr90QIqSnm/+teFo7hjBYjpuqBWwpK+bpzMoxVgQcfBsqWuJEVsH+r
         kX/u0sDchZDKTdOklx3JHj/+wBis2bps0gbHfvXTXnoRdWc5DfaSbTpAYG29KIQDW39J
         Oi2fAKuAYx0MZkPQuzHLqMo2xhud3meHgYHt1Qe9PlUT0aKy88rxFS4n3ybMr/OFaAyQ
         PPYHwhCGjP/3AXaBCWxQEp18HjWavxK9D6S01LdQ4/MkcPHxs5bh1E1EnTspGZzaDBWT
         R5GQ==
X-Gm-Message-State: AOAM533/UdVeYIsmQ9tp1U7BzEpch/mwV+EfFsUnDuY8kKnfMt6zyBFi
        TvoVr35+Mjxch6FIgN8CCqU=
X-Google-Smtp-Source: ABdhPJzqZc640HKSHL/7SPFK/TmnXkWXqIXVa9+BvpACOK9aofuzc5GTaEEPWqbFLtFPW69UYETCgw==
X-Received: by 2002:a37:9986:: with SMTP id b128mr54733413qke.485.1626111382346;
        Mon, 12 Jul 2021 10:36:22 -0700 (PDT)
Received: from Zekuns-MBP-16.fios-router.home (cpe-74-73-56-100.nyc.res.rr.com. [74.73.56.100])
        by smtp.gmail.com with ESMTPSA id bm42sm6496869qkb.97.2021.07.12.10.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 10:36:21 -0700 (PDT)
Date:   Mon, 12 Jul 2021 13:36:19 -0400
From:   Zekun Shen <bruceshenzk@gmail.com>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [EXT] [PATCH] [net][atlantic] Fix buff_ring OOB in
 aq_ring_rx_clean
Message-ID: <YOx9k4vDcerEEbWn@Zekuns-MBP-16.fios-router.home>
References: <YOtc3GEEVonOb1lf@Zekuns-MBP-16.fios-router.home>
 <6ded0985-7707-4bde-adb2-ee1f411055d7@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ded0985-7707-4bde-adb2-ee1f411055d7@marvell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 06:33:37PM +0200, Igor Russkikh wrote:
> From code analysis, the only way how ->next could be overflowed - is a
> hardware malfunction/data corruption.
Yes. The unchecked index field is within a buffer ring, which I assume is a DMA region.
A faulty or compromised hardware could trigger the OOB bug. Leaving it undetected could
cause memory corruption, so the patch returns with I/O error.

> Software driver logic can't lead to that field overflow.
> I'm not sure how fuzzing can lead to that result.. Do you have any details?
The fuzzer we used is targeting the hardware input vector including MMIO and DMA.

> Even if it can, then we should also do a similar check in `if (buff->is_eop)` case below,
> since it also uses similar sequence to run through `next` pointers.
Thanks for pointing out. That should be checked too.
