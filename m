Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4285A2E19E4
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 09:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgLWIWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 03:22:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727775AbgLWIWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 03:22:02 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D93AC061793
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 00:21:21 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id r7so17730475wrc.5
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 00:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xCgAcM2zJXz2tYkyh6YBwPXZD93lL3eP2t44LAAIMqc=;
        b=VcaD4Zmz2ZTl2f86HVvCWDFT59gagppGVrnTcZ1bwmc8WJp6WjjocW7KL9gZ6j8WNp
         U/7v2atJzUqCwDirE8uaupPpjMuh3Oo9xT3h4s6+29loVhQjAJhLTwTVNqyvSNhyiaI5
         fPo/aSqFraT8n4O70n/N6LRhybnbTc6PWkZodRBj5y8ahvqTKzXX9upTszeyV1A5VYu1
         U7hsVrjatitiJpHx+DDzBqUAKuk0CdCOQg7wEw4xIIbFcUT2Tr9n1z3oKKNEswh1TR/U
         kVzvcQWnYCT6mqFUO7/IpwfpXK7VaA5c7sqdqs8Bg9d1vZVG/F9JuWrN9ZaaLFC6y6ED
         2MSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xCgAcM2zJXz2tYkyh6YBwPXZD93lL3eP2t44LAAIMqc=;
        b=IfJUg6T1HR1TwNfJf9J61eKBTSgrgH14DjbzgUcCrbaZP5OZQvIvTuu3LnrQwns7R2
         1llKQNsq5z6WIfvkbQWjJhd/IaagHjAEot9f8A7dz0RtLHuee4kff3CbTqjo5zdnTrv5
         hiWNkKUdLZeP3oW/s+8xK/Y53R9Oz4hHf9iKImyT0LMFJKQ124BFnu38xkGUNkPNfnB5
         gKO8QGXg2cF2rJLw4a60UnLXp2SGPamQH6uo3d9k9NZAZMs+OBtBveexQbjy7FP1YfR+
         VxHZQyST119bMSKMwY6frDjtaESvaLR/jDizZcXEoLajYdzZ6p0kwxNW9ZxrasMUtrjF
         fafQ==
X-Gm-Message-State: AOAM533g4pwisiEHemJ9+kM8NCncu8hnddilkK/oJkrLx0QGW33K4xMX
        Hf7qzQ81ua98vy0U+yXbF309pEVWSqspHyVG2Is=
X-Google-Smtp-Source: ABdhPJyQD4NG0TjivqR01JoubjqyczV8neIUJq28oPS04uYsKmuZo/DveNKmCMG3NtGypAdPpDjBn2qaeTIWSBPDFnE=
X-Received: by 2002:a5d:6a83:: with SMTP id s3mr28759297wru.334.1608711680352;
 Wed, 23 Dec 2020 00:21:20 -0800 (PST)
MIME-Version: 1.0
References: <20201219214034.21123-1-ljp@linux.ibm.com> <20201222184615.13ba9cad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201222184615.13ba9cad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Wed, 23 Dec 2020 02:21:09 -0600
Message-ID: <CAOhMmr6c2M68fj0Mec=vhHr7krYkB8Bih-koC9o9F=0CJOCQgQ@mail.gmail.com>
Subject: Re: [PATCH net] ibmvnic: continue fatal error reset after passive init
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Lijun Pan <ljp@linux.ibm.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 8:48 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 19 Dec 2020 15:40:34 -0600 Lijun Pan wrote:
> > Commit f9c6cea0b385 ("ibmvnic: Skip fatal error reset after passive init")
> > says "If the passive
> > CRQ initialization occurs before the FATAL reset task is processed,
> > the FATAL error reset task would try to access a CRQ message queue
> > that was freed, causing an oops. The problem may be most likely to
> > occur during DLPAR add vNIC with a non-default MTU, because the DLPAR
> > process will automatically issue a change MTU request.
> > Fix this by not processing fatal error reset if CRQ is passively
> > initialized after client-driven CRQ initialization fails."
> >
> > Even with this commit, we still see similar kernel crashes. In order
> > to completely solve this problem, we'd better continue the fatal error
> > reset, capture the kernel crash, and try to fix it from that end.
>
> This basically reverts the quoted fix. Does the quoted fix make things
> worse? Otherwise we should leave the code be until proper fix is found.

Yes, I think the quoted commit makes things worse. It skips the specific
reset condition, but that does not fix the problem it claims to fix.
The effective fix is upstream SHA 0e435befaea4 and a0faaa27c716. So I
think reverting it to the original "else" condition is the right thing to do.
