Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7063A8E63
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 03:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhFPBdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 21:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbhFPBdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 21:33:19 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DD6C061574;
        Tue, 15 Jun 2021 18:31:14 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id l15-20020a05683016cfb02903fca0eacd15so863615otr.7;
        Tue, 15 Jun 2021 18:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bdWCIiSOW/s0MZlmPAOty1fkqegkRbIQeTFWMhV1jV4=;
        b=PZH0nDGpZJzVuFQETD0ktLDMM7cO+9RIo1IkhsU6liVnazq//noXj+7wIXWpvuob8M
         3cu9CPX7HJR1oXlx9dwWEv6je73JxtNrn4PNgy6/Es0/gtkqGaKtrekE5zrkWYTfs1pj
         R3VyWmhhS3soTjTC00pMMCF7k10EiPRNZ4uFOm3zhwjAOIKXO500/miU878CrU0PtWyR
         K/iVQlNOmRoDUGcOF2J5O6gHG8eq7kYzXiM0Tf/9wPpwRD0mzbgAEhkSQEMAq1oavEMG
         JCT5yvmRr3Nffn+Dt4MohniPJy/JatiSyh8nAnSM4TfjtAaJIhOdV8fEAe1m3uOvGYFG
         aoAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bdWCIiSOW/s0MZlmPAOty1fkqegkRbIQeTFWMhV1jV4=;
        b=oWr8NaJ9N/ckHoxY2w2HV/MpPYQgpagkPexG05/vRKyCP4UmThb9aarJm1dbI1b1dT
         50bEDM2VQBRPcWK8iepWQBJrFK/88t1G7MMyhKUNBU4DESzjUZZe0FdxrjzOOIQHJyTk
         lg8WZEPV9wuBLPlnFy9ybPMAMfqG5nej7CrNaE7NswokSSS96G3kMsqMyV3q3Qavyogb
         CWf2hOybFoEeAWhg7dvda6k/Tk35Eywt6gtrtml7FwQmqbmz5HRTcKiz0bgTcj/oh/am
         ++Wwv6EoRVSvwg5UkUOeoKgK/yp250FjRqZQ6JNK5QhZ7MIzpD4IBghP2kd/AczBoEPQ
         QIUA==
X-Gm-Message-State: AOAM530lAFuCRW/CvI6p7FgpptVfpF8WYaHwASO5kj6ktVTnArYz5ctS
        IASAjD0tMUi+f3AXU0J8tbHAlhlo4FtY/DBtNkZsY9RbU3BL
X-Google-Smtp-Source: ABdhPJwCACqspiGaKFTVOcgXMedQdoCM7CDVIcF94bpPJbrd+ygkHOAp7566P+LmNAN34S9xXHrONQiL07dQinx03bY=
X-Received: by 2002:a9d:200a:: with SMTP id n10mr1639132ota.287.1623807073699;
 Tue, 15 Jun 2021 18:31:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210615175526.19829-1-george.mccollister@gmail.com> <20210615232242.3j4z5irr7abfhtwz@skbuf>
In-Reply-To: <20210615232242.3j4z5irr7abfhtwz@skbuf>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Tue, 15 Jun 2021 20:31:01 -0500
Message-ID: <CAFSKS=OEM7bn2G6qXYQ16=9NUUpa-DhN=Nabc8P_E+7spUqKkQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: xrs700x: forward HSR supervision frames
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 6:22 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Tue, Jun 15, 2021 at 12:55:26PM -0500, George McCollister wrote:
> > Forward supervision frames between redunant HSR ports. This was broken
> > in the last commit.
> >
> > Fixes: 1a42624aecba ("net: dsa: xrs700x: allow HSR/PRP supervision dupes
> > for node_table")
>
> It would be good if you could resend with the Fixes: line not wrapped
> around. There are several scripts around which won't parse that.

WIll do. I was wondering which way was correct and figured scripts
should be smart enough to parse it especially since all it should
really need is Fixes: $HASH. Oh well.

>
> > Signed-off-by: George McCollister <george.mccollister@gmail.com>
> > ---
>
> Otherwise the change looks reasonably clean, and it agrees with what IEC
> 62439-3:2018 does seem to imply in "5.3.4 DANH forwarding rules" that
> HSR_Supervision frames should be forwarded and without discarding
> duplicates. For PRP, of course the DANP does not forward packets between
> the redundant ports, so it does not forward PRP_Supervision packets
> either.

Yeah the tricky part with HSR supervision frames is you must forward
if the other port has received the duplicate frame but not if the
frame has been sent out the port you're about to send from already. At
first I set the mirror bit in addition to the allow bit and activity
was on completely solid as supervision frames looped around.

>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Thanks
