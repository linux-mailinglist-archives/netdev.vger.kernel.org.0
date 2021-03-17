Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7516B33E92E
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 06:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhCQFlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 01:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhCQFlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 01:41:07 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E71FFC06174A;
        Tue, 16 Mar 2021 22:41:06 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id t18so383492iln.3;
        Tue, 16 Mar 2021 22:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SGZHipF/MPCKbdoq7rybqIUBE3aLJ87KG0g3vPENnro=;
        b=q0NIRSrqBejVA6Xz4de/uFq+wjipdioEl0vwjHgU5ZRt1WJqLhaLpjMJ7hWhdFB7OT
         pi9TMN5/lHAeVGg8mgQgmBrnaoC/oCicjxnD9ckkCYYnG3LfM2cU1+D6PRXzhReXIKuL
         3j/F2P8PzStz/hMxzSOHjgfYM07HWxtOjxvU9sjBwLJhKfct6QQPUvjdlQxEmYwMabWX
         8D+xD+Uu7uudcEcgxg5541CHykcTFDmc5C15R9lmEl1PvKNJ6yEA+gkIJa/xXTGdT/aN
         f/gA+MC4DG3d9Y3g4ZsIiXKHg9s5iuRdU8f2U+U31eYhkzs00f/yRA5nRq8qkZrAcGt6
         DGBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SGZHipF/MPCKbdoq7rybqIUBE3aLJ87KG0g3vPENnro=;
        b=bqoKdtPTCN/lPLlYELLBytaKd9OoLCtZ8WDBbwYGg9xgzl4lJMpPR8fl1KV/2OZxpL
         +ij125ZN4gpL8k3kt9CtSgIs/8WYV+6gu+BnsEP8yXRONaaRM8uQiknkW3r+RLHllMCD
         vSOT/2fXLsmmScJ8CUzKfJyGjFVNGcYufpObBnYnoDGaSpTMhISezIjowcHSFaHGuT8e
         tlSl/w/O9k37J6st7b2NDwWlfbUeTq4bCpf2T345v7l8Ki+xk141PpkI34oICm2ofA/Z
         1GVX+3j3xVKcLskGDIdOV1SnBNubS8X4d7K/Nkq4QD2fWofUlPmDTb0oyg1P8RBWLRx/
         cB5Q==
X-Gm-Message-State: AOAM5335sbJPsFtWwZon6w/q/ya+RwNR67NR5jvw7VHxAIyDqOWGxPz+
        5YvSyoS8pXizeZ5xdUjj7mvmMEGTW2OXFoXutWA=
X-Google-Smtp-Source: ABdhPJwNbCO7ZAlDw9N/1tUJp9JEaj3Qoal3p3tafLHUEoAEjO+AqUMJeGkcrxbqOio8DSiPp/hnMknMbL8S/IW8gzM=
X-Received: by 2002:a92:d7c7:: with SMTP id g7mr6068711ilq.305.1615959666331;
 Tue, 16 Mar 2021 22:41:06 -0700 (PDT)
MIME-Version: 1.0
References: <1615886833-71688-1-git-send-email-hkelam@marvell.com>
 <1615886833-71688-4-git-send-email-hkelam@marvell.com> <20210316100432.666d9bd5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CALHRZupARnUK5PgRjv9-TmFd9mNUg0Ms55zZEC2VuDcaEBZYLQ@mail.gmail.com> <20210316132709.6b55bcf4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210316132709.6b55bcf4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Wed, 17 Mar 2021 11:10:55 +0530
Message-ID: <CALHRZup50=0yEhEmn8dOPuyNbrimocd6L5b_hkZTB-fRDM5+UA@mail.gmail.com>
Subject: Re: [net PATCH 3/9] octeontx2-af: Do not allocate memory for devlink private
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hariprasad Kelam <hkelam@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        lcherian@marvell.com, Geetha sowjanya <gakula@marvell.com>,
        jerinj@marvell.com, Subbaraya Sundeep <sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 1:57 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 16 Mar 2021 23:33:40 +0530 sundeep subbaraya wrote:
> > On Tue, Mar 16, 2021 at 10:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Tue, 16 Mar 2021 14:57:07 +0530 Hariprasad Kelam wrote:
> > > > From: Subbaraya Sundeep <sbhatta@marvell.com>
> > > >
> > > > Memory for driver private structure rvu_devlink is
> > > > also allocated during devlink_alloc. Hence use
> > > > the allocated memory by devlink_alloc and access it
> > > > by devlink_priv call.
> > > >
> > > > Fixes: fae06da4("octeontx2-af: Add devlink suppoort to af driver")
> > > > Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> > > > Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> > > > Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> > >
> > > Does it fix any bug? Looks like a coding improvement.
> >
> > Without this we cannot fetch our private struct 'rvu_devlink'  from any
> > of the functions in devlink_ops which may get added in future.
>
> "which may get added in future" does not sound like it's fixing
> an existing problem to me :(
>
> If you have particular case where the existing setup is problematic
> please describe it in more detail, or mention what other fix depends
> on this patch. Otherwise sending this one patch for net-next would
> be better IMHO.

Sure will send this one patch to net-next.

Thanks,
Sundeep
