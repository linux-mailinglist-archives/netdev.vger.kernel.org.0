Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE7526AE31
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 21:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbgIORHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 13:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbgIOQsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 12:48:33 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71DCC061356
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 09:36:56 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id r9so4813569ioa.2
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 09:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E1zHw0XeuL4dlY2QFEYUyucdLBRDAvQdUCIhzYvG7so=;
        b=R9TESOzQDWifSPgyqICUAwBgB89dU9aKoUGfKcNI7CWNmMibzoBuDVnIIjT5hkpdwN
         PqHISEYfRgwP8lg5gOabpcngfVrMtJSIgwnNLe/ivuyoPAqqGcgLMllTY3W+wwfsQHvv
         oUw4dr5YGouogoFnUPLukYTygv59ctRT4/nS3WmAGcJ95+wnQwPrQ5+KXMIKdhCEmr/f
         To0NVcSenjSyVb/9+oDLepY0HMSv8FfmQbDXgcVu0K0AQ5KmsFuiZEI1U0y525qSmB1G
         e5JWChotdR/5gj/6cyoA+jqDecWd/v2bQaAQX/9ZqsFQ9UYXLPk+rZN4w2+qDhC+vU1H
         4KLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E1zHw0XeuL4dlY2QFEYUyucdLBRDAvQdUCIhzYvG7so=;
        b=I0dlX2JJQ1mNesJXO2oYDOkNQ3+yLt7IBAVYuXrmpt0hYR05xanhe2/9fzu4G7cPEI
         siEcoWCql0GmibVNGsajZKmQ/9GXBc6YZtMcNX4Mg6gzKLYYeM55ZrVJkgNjggmfZzGT
         r0KEqISpDs763ZcgIarLnMTw16swbrFrqHFqUMGbmJA9RB57IniCzXGgvSqnVsenw9Eq
         ZZnsM3oPehxrPwQu+oOAZUcE+kJp6ii5aBxwFUTGD0hplKeKEC0vO2VmUcMmucy0QUyk
         CRHBJ2hYrcOJH/w39MzKioEq3/KdpJAa6j4+YzUxZHPoTB3z3aufc0/hLsbE+8n8SPkM
         TVrA==
X-Gm-Message-State: AOAM530I9KZSuMrsZnIyaVK9Nw9/Pf9Vb51Mjg8+GfV5yozxd/0Nn2Tj
        o46suqLt4An2Mwqvs/Cd2gBzSaACdtDe/MQFzCs=
X-Google-Smtp-Source: ABdhPJzm1hJgZtPTLVw4S/wTkG3Dh8vgmYzifLih1j3NSyXmLDwqaL8OAsSLdE/5KJF8UxFu8Pq2iMt20Gbejw/xyjc=
X-Received: by 2002:a05:6638:237:: with SMTP id f23mr19178297jaq.142.1600187816163;
 Tue, 15 Sep 2020 09:36:56 -0700 (PDT)
MIME-Version: 1.0
References: <1599117498-30145-1-git-send-email-sundeep.lkml@gmail.com>
 <20200903121803.75fb0ade@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR18MB3298899BF15F266144EE8760C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
 <20200904083709.GF2997@nanopsycho.orion> <BY5PR18MB3298EB53D2F869D64D7F534DC62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
 <20200904121126.GI2997@nanopsycho.orion> <BY5PR18MB3298C4C84704BCE864133C33C62D0@BY5PR18MB3298.namprd18.prod.outlook.com>
 <20200904133753.77ce6bc7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CALHRZuoa8crCaOAkEqyBq1DnmVqUgpv_jzQboMNZcU_3R4RGvg@mail.gmail.com>
 <CALHRZuo9w=NJ4B6hw4afhoY21rAbqxBTZnLKN4+A=q21wNPPjQ@mail.gmail.com> <20200915091212.3b857f80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200915091212.3b857f80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Tue, 15 Sep 2020 22:06:45 +0530
Message-ID: <CALHRZupiMFJXb6_Abd6qbyZJzjdpMCy_t+DWQs7zU9cXtuhWGA@mail.gmail.com>
Subject: Re: [EXT] Re: [net-next PATCH 0/2] Introduce mbox tracepoints for Octeontx2
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 9:42 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 15 Sep 2020 21:22:21 +0530 sundeep subbaraya wrote:
> > > > Make use of the standard devlink tracepoint wherever applicable, and you
> > > > can keep your extra ones if you want (as long as Jiri don't object).
> > >
> > > Sure and noted. I have tried to use devlink tracepoints and since it
> > > could not fit our purpose I used these.
> >
> > Can you please comment.
>
> Comment on what? Restate what I already said? Add the standard
> tracepoint, you can add extra ones where needed.

We did look at using the devlink tracepoint for our purpose and found
it not suitable for our current requirement.
As and when we want to add new tracepoints we will keep this in mind
to see if we can use the devlink one.

So was just checking if Jiri is okay with this.
