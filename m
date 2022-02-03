Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66DEE4A8CD4
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 20:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353911AbiBCT7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 14:59:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbiBCT7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 14:59:32 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7296C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 11:59:32 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id m6so12252909ybc.9
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 11:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h9M4nKvmcJpaWHD/IndaPEH6tyG4vcbdD18YlGrzAxQ=;
        b=kXt4lFR9hkjubzWElPnBH/wyOkRz30nCLpp+JXuGO5ogyTyauGcAWPtCBXFeg6RF1O
         eHd3WMb6j+xFenBLrZmgWBhLjErnHeCL+QANXyAmPftUjDPd9MVbuIvas3QJz+YffuCq
         hQn5jos+Bwn8htTjYUcWaadj20Bi0ztcq/XwbAXKmmkBG0TbhvbbVA3w94Wmpt5S0217
         rHCUMDkFMGyPCH8bgsGbqcWdoDU6W1CUTgHj3mvPzU/UUgFKaCISLD/ztdtaSuXUFgfb
         NeEojWtwODEydzt3+yPjBnwBYett9m8CdPlbVh8vRSKRz3VsCy4ux5oaAESw20h9sMbx
         qwIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h9M4nKvmcJpaWHD/IndaPEH6tyG4vcbdD18YlGrzAxQ=;
        b=mxZFJw63O2/U7+xcXqDKNCdjhJ0YNYXQ/iLljzRSWvzIR3W+TBVblUe/6dy/riH6cE
         qJlczdQ96VhRn66cM2iNTL6ahMley6Q1gWWHE5aHCnzgPWC9L6dFXqu+G3qeqU6W1XeH
         R0CUK0Ju8MIEDRmET0eG/OspDbiQwf/XKxxb/A2e4rFjeNm4woA57hBE+OvA+cNGwJid
         DyJYQHMbQRTz0ayhxf1r4HmmDmZFSr73OV2u1F7KPeuaTUHQbjF8Fg+goWo+p7r7MZRf
         hAsMOi1lWyuK7Y8pTThSGa9CKJ3sNr7h+oOtjZEkNkENPyKvZyLy93BA3bBavNkH3nSj
         NEyg==
X-Gm-Message-State: AOAM531fJg/V7IrPrJxPRBngS5ej5SR0TVorAtv02luf+VQ0OJa5Cyxh
        Gal6YWl2W8A3NdMe3gl0lm8CqT92LLBVRddluA9egu4KH3n5R/2f
X-Google-Smtp-Source: ABdhPJxL6WYY0ppoqFVx/L3AIdt0f2n9yN+matHijheovEiqwKdMO6EnhbpgHcif98rLVDk+eAj5W30PzZXIr6dkzNg=
X-Received: by 2002:a25:4f41:: with SMTP id d62mr48686478ybb.156.1643918371603;
 Thu, 03 Feb 2022 11:59:31 -0800 (PST)
MIME-Version: 1.0
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
 <20220203015140.3022854-6-eric.dumazet@gmail.com> <0d3cbdeee93fe7b72f3cdfc07fd364244d3f4f47.camel@gmail.com>
 <CANn89iK7snFJ2GQ6cuDc2t4LC-Ufzki5TaQrLwDOWE8qDyYATQ@mail.gmail.com> <CAKgT0UfWd2PyOhVht8ZMpRf1wpVwnJbXxxT68M-hYK9QRZuz2w@mail.gmail.com>
In-Reply-To: <CAKgT0UfWd2PyOhVht8ZMpRf1wpVwnJbXxxT68M-hYK9QRZuz2w@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Feb 2022 11:59:20 -0800
Message-ID: <CANn89iKzDxLHTVTcu=y_DZgdTHk5w1tv7uycL27aK1joPYbasA@mail.gmail.com>
Subject: Re: [PATCH net-next 05/15] ipv6/gso: remove temporary HBH/jumbo header
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 11:45 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:

> It is the fact that you are adding IPv6 specific code to the
> net/core/skbuff.c block here. Logically speaking if you are adding the
> header in ipv6_gro_receive then it really seems li:ke the logic to
> remove the header really belongs in ipv6_gso_segment. I suppose this
> is an attempt to optimize it though, since normally updates to the
> header are done after segmentation instead of before.

Right, doing this at the top level means we do the thing once only,
instead of 45 times
if the skb has 45 segments.
