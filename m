Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8613D0D93
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 13:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240236AbhGUKqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 06:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237986AbhGUJgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 05:36:20 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C9EC061768;
        Wed, 21 Jul 2021 03:16:57 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id z17so1728527iog.12;
        Wed, 21 Jul 2021 03:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QTF7O5HzF8haTDzz11IYFCmXhr6sJ8z3PRlb5qVd+sA=;
        b=KIdPSwdI4SZOtof5J1rQaLGFzfdd9SgzgF8rKwZZkKepZEdqmY22ElWhF9ffDsaTVo
         d6j+Lc8AZCU5of4jz6fsqMwqv7Q4ZfEQtz1nvNDaufwZ2UUXx1QrCbGbEKbdD2BnDFoW
         k3N/IJ7WSFT+eSQkhbHIAKe/LguadIMTovMhmgJMPyVaXg0YKKtrGpHYI8g5PUhkVFPC
         IpbGaW1uHdcdJaK8aaoPEkpX478TPvohjCNhe4CkHC+6ZoDv0AIN1SfHDyU6ePqSzTmd
         AIY3qtOD3GllH6GNniWvlS6jYdAEpmUQxR7s94SoBeWnsPC9/7ZXMB97UwqrqE5FGfID
         GrnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QTF7O5HzF8haTDzz11IYFCmXhr6sJ8z3PRlb5qVd+sA=;
        b=X3+Dkc/eL/dLOGPjx+U09i62U/dh7WVRIzrQN1XYUws4qwsDHxgEEw6W27FH4SKKO+
         bFhi0fdW/X2/uRBUwAQdCgORJ4IbxTWoVopSad8OMjqmkfnPwa0XWYU0J9s152vC0ywc
         p0gpCe+CyslzmGZeqETtygqy0W7sQvKQso21dS73/M+N9edKUg1Mf3qZk6T4lxkwhiId
         zQXHqwESqQ/58hV8GcEFIpPc89Hu3Bjgx7T80+EcVCxggtG2QN1oe8kuajaPIKZHf4pK
         WeYTI2LKd90rTXiLH3l3Kkm60hJC3keu77qh5gNbRhVF895HawFsBXBTfTAnODtWH4pN
         w1Sw==
X-Gm-Message-State: AOAM530WddpCBiHnSHxFMEAMDEwxOPzuEhNCh9DvBZ1H5uGeXG0P+viK
        OjKwdcELrAWIXYbL+69Q1a31YYmRZs+mmapjixE=
X-Google-Smtp-Source: ABdhPJykrEstufjX8GoCvx9yyd+BDxsJ+ECFNHqexYaSxLEZ0C6NQGFBeEk4yQEF9Jmh7fGyoK27KZS6sI5TkW9KJDs=
X-Received: by 2002:a5d:9f11:: with SMTP id q17mr24971479iot.62.1626862616943;
 Wed, 21 Jul 2021 03:16:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210717142513.5411-1-len.baker@gmx.com>
In-Reply-To: <20210717142513.5411-1-len.baker@gmx.com>
From:   Stanislav Yakovlev <stas.yakovlev@gmail.com>
Date:   Wed, 21 Jul 2021 14:20:45 +0400
Message-ID: <CA++WF2ON8E=FNHj3SqO=OMvx6SBB=Lv517rmCrBTvG+6d=tL3A@mail.gmail.com>
Subject: Re: [PATCH] ipw2x00: Use struct_size helper instead of open-coded arithmetic
To:     Len Baker <len.baker@gmx.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 17 Jul 2021 at 18:25, Len Baker <len.baker@gmx.com> wrote:
>
> Dynamic size calculations (especially multiplication) should not be
> performed in memory allocator function arguments due to the risk of them
> overflowing. This could lead to values wrapping around and a smaller
> allocation being made than the caller was expecting. Using those
> allocations could lead to linear overflows of heap memory and other
> misbehaviors.
>
> To avoid this scenario, use the struct_size helper.
>
> Signed-off-by: Len Baker <len.baker@gmx.com>
> ---
>  drivers/net/wireless/intel/ipw2x00/libipw_tx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>

Looks fine, thanks!

Stanislav.
