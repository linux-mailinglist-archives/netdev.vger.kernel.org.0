Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90678293150
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 00:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388341AbgJSWg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 18:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388333AbgJSWg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 18:36:26 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED410C0613CE;
        Mon, 19 Oct 2020 15:36:25 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id w11so556144pll.8;
        Mon, 19 Oct 2020 15:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3LnmzR0q/ws5cE1pDcIgvetl2imJASrTHrTXQbd+sfA=;
        b=oQZz3I53O6Oc2sr3Oc9F2xw37mI/wEYXFuQ8F0DZ1AT4/epLMy4YZ4YTiUwYWI+S9X
         ChaV69cZrI71ItNipS/GKEtJitB66CyS3av0pZrFlb9bpkgvT2pu7jyj4DJZpltaceWB
         orFdDXZd+UvEuNAt3j1z4DTwzo3q6gg6/XrF/CtjQs57X/P0nfcNiuLB2FACQ3181BjI
         B9Oj2jD4N+ez7cMUAwy6gVx+kI/9tJqGW/89Zj9CW+9TwihPyAM7E76jeQDLLhhZw3hY
         9V5/oW84fctN1g88+bRT74XhDCW+DgGN4fMGAnKMK0AWOJEagMrmIAw0qK/nIwbWaRm2
         UNpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3LnmzR0q/ws5cE1pDcIgvetl2imJASrTHrTXQbd+sfA=;
        b=eQAdL+4Iv0wiIPzpfzc6VJtL/T/dFv0ZjubDdEOlPbBvQwnh3LP8vIhHctPPDILzOw
         p0tXjqhZmm8BE9Ok6jrX+xrRK9ZCYATg7zSoLcD4eJdkkHAQeOrpPdMehF3LEttzBDI5
         ulgqCJBmxLsoTOz8qtESvjYxu1VbrDuEBz2gHNQP7HFiIVtPCpkoo1o1GPjhGY1W37uH
         g82M7f7ylITLw8L4Gi4JxdA4bUVvHwEghZG4SYNgN16cN0f7fF0K9LUKBhD7laOXsCn+
         9S/KcyH3J5o5HeMAEOn7cgghWW1ARP/wzxOqCnQGD9H+woTC2H9sujjakm/CFJ9880xv
         TDNg==
X-Gm-Message-State: AOAM530hlinu+R09pjalYGKzk2t9VoOM/8m8l5TN2Ni9sL01/5QvGRyq
        LuRwXjdGczxUZuXvj9uDGLVAQadHjVCIkTIJ1VY=
X-Google-Smtp-Source: ABdhPJzW3kdQHwc39I8I06PvhmSjRsDqL8os5OsLCdufGOL2HqAPpoRHLYiwqQ1Ptw6VRhvkMREX+qbdU2y34X+TfcI=
X-Received: by 2002:a17:902:d90d:b029:d5:ee36:3438 with SMTP id
 c13-20020a170902d90db02900d5ee363438mr1871844plz.77.1603146985567; Mon, 19
 Oct 2020 15:36:25 -0700 (PDT)
MIME-Version: 1.0
References: <20201019104942.364914-1-xie.he.0141@gmail.com> <20201019142226.4503ed65@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201019142226.4503ed65@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 19 Oct 2020 15:36:14 -0700
Message-ID: <CAJht_EMNza4ChbhnCvEKQkYs14SpcjdajnDA6okr9actVzQp9Q@mail.gmail.com>
Subject: Re: [PATCH net] drivers/net/wan/hdlc: In hdlc_rcv, check to make sure
 dev is an HDLC device
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 2:22 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Looks correct to me. I spotted there is also IFF_WAN_HDLC added by
> 7cdc15f5f9db ("WAN: Generic HDLC now uses IFF_WAN_HDLC private flag.")
> would using that flag also be correct and cleaner potentially?
>
> Up to you, just wanted to make sure you considered it.

Oh, Yes! I see IFF_WAN_HDLC is set for all HDLC devices. I also
searched through the kernel code and see no other uses of
IFF_WAN_HDLC. So I think we can use IFF_WAN_HDLC to reliably check if
a device is an HDLC device. This should be cleaner than checking
ndo_start_xmit.

Thanks! I'll change this patch to use IFF_WAN_HDLC.
