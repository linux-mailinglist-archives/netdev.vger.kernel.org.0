Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2D5524BF62
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 15:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728599AbgHTNsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 09:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728153AbgHTNmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 09:42:13 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6EA9C061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 06:42:12 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id z3so1661329ilh.3
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 06:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1ZnMXf43kjV6GLlPjISvan6YMRqHT6O13gZaPxNOsSE=;
        b=bAVWRnFheiNzPDP2kxfjhqyLVJYXSnzV6yBEMGJERLfpZKFlIqs8nKnCQdnIUl9uSa
         ThX83AerrRlh1VF9vlLs837IZN6rLPzx7QYESHYg793hYx/9mLRbtvPNgYRFxHvoFInQ
         jDP6jvOjIL0F+5NdcD2KUFun8z4j3hjG2fmnfjUGtuKBjBp2FWdT++gMt45xDBzYm7DT
         zG5WRxiXrngHL41dunlFQVak0icty1ePZfzTEcDjHtbUP0EwmC5rvXnSBVN6yBGuFKU2
         JgUUyzh2rU5M090ye2ETRZXSTcrhErWoPsq7EyQY7L701X0i6N2HZmUlZiPjrCfvwPoO
         1AZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1ZnMXf43kjV6GLlPjISvan6YMRqHT6O13gZaPxNOsSE=;
        b=ER4ybE+GpeNqkzjxhYGYUWVEx5mGPV/GENyKZbiPD9A2uRd5FtLRzVtDprDhbORmaE
         OLijqctq2k5XAKVYgzx1W+7SoCX4WplALnXt9AUTSrffK4glQ1Et1plPQNt7l4qa4sA5
         u0VnasSFdVncs600W/nKI6znV0d7HcQe3zr02U+4UkOQnlgw8PBXaJfGt6Fh7fxUhg3t
         RSloZwqgzD3NVp1n5HExwqqv+5dMIkFXS0gzmZGWUlmjwSKO/BB/lwdRLHjLSTuMbC2X
         uaPYpfdpT8JHbXVRXshjCqInl34YvAMeJmBNYwN0swZlxOLOZkYUbKKSqkdnL4ZFELBM
         +F1w==
X-Gm-Message-State: AOAM531kCBvmouc22mCZj8f7+q5WymwVyv9olfDzUsQBP6Dtl8o3kyBC
        m+3zJcbJXKqFEg6pj03R8nzi+drIW5XzpYDrBV4DcUgL/Ao=
X-Google-Smtp-Source: ABdhPJwL/Fu84OEWchSpUcjdq3TgjzQDeEQYNO8ovCpl/CZjKPNjOUCkLRbG7+j3Kpvf6aX+8pFjGkmCKGSxNJvbVIg=
X-Received: by 2002:a05:6e02:e8d:: with SMTP id t13mr2670966ilj.211.1597930932273;
 Thu, 20 Aug 2020 06:42:12 -0700 (PDT)
MIME-Version: 1.0
References: <1597770557-26617-1-git-send-email-sundeep.lkml@gmail.com>
 <1597770557-26617-4-git-send-email-sundeep.lkml@gmail.com> <20200819100036.00007b24@intel.com>
In-Reply-To: <20200819100036.00007b24@intel.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Thu, 20 Aug 2020 19:12:01 +0530
Message-ID: <CALHRZuoaQLa_KZjq_uLPgeEtSmrsFhB80ibqcPRM=xuTZZ7NQA@mail.gmail.com>
Subject: Re: [PATCH v6 net-next 3/3] octeontx2-pf: Add support for PTP clock
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, sgoutham@marvell.com,
        Aleksey Makarov <amakarov@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Aug 19, 2020 at 10:30 PM Jesse Brandeburg
<jesse.brandeburg@intel.com> wrote:
>
> sundeep.lkml@gmail.com wrote:
>
> > From: Aleksey Makarov <amakarov@marvell.com>
> >
> > This patch adds PTP clock and uses it in Octeontx2
> > network device. PTP clock uses mailbox calls to
> > access the hardware counter on the RVU side.
> >
> > Co-developed-by: Subbaraya Sundeep <sbhatta@marvell.com>
> > Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> > Signed-off-by: Aleksey Makarov <amakarov@marvell.com>
> > Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
>
> Besides that this driver doesn't have copyrights, I don't see many
> problems with this part of the patch. I would like to see some of the
> other patches have my comments addressed.
>
> For this patch:
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

Thank you,
Sundeep
