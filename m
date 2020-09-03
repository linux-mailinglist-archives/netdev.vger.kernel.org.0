Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8839725C6D5
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 18:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbgICQbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 12:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbgICQb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 12:31:28 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F161C061244
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 09:31:28 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id u126so3494315iod.12
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 09:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g0U5uqyM3pJk73lNvjVxrExB7i3CCpu9+kRCPVxj8v4=;
        b=TnSflDCXCPsrs++JVO1DaZD0LPBEinHiK99neyhWlzRX6ntfWpEj0umjVas+iFe7PV
         Fp5EC4zfvIgkNCyt1v0u3NZatnT3uKZc8+IY/NI5GO4L3XOtAAoX+NFXbnL+0BaUabSg
         EXyeQ1369wtR/prMF457u5YRO7GqizoPI6fb6u4hhr8siBncEFAFQTnv2OrWQ+OeXV73
         K/AfrO1R8qT089gBZgKXzC4p0qKPCuIgDnzCSo2RK+eVlp+rwXCUpx9KbklrVf8EZdRq
         26pQ4+7dnfE/Mk4eQ2zT7xLoT1vOkxXp5xxVrPOTBG+mNf6kbXmEGX86Er1z4Ek0NtQp
         R+TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g0U5uqyM3pJk73lNvjVxrExB7i3CCpu9+kRCPVxj8v4=;
        b=hGfFDeDTY+QV6N6nfNQwEd0Kpxqh2/cxvcgwKzcvmbEPHGL9RkjHh1CA2uUunOM6lN
         2NxOhyYd8PFMJwv8BnOMZA4gMUsRKE++lXFpk3ATw+SlD8Q5jYcnBcW01oaCAukjGLVm
         Po1e3PwjNL9gFo0fOKy4qfgNMNYJpOt6qqEsR1nIQ5V1SP5q5Xv/b+XGtJqFDoC3MZx6
         fgcrcHlVMp0NcSMJcUHj5uNJhOokWzYlyJDpPWeYJixT11u61eYTefhXCIJH+UJOWDJa
         TU9imIScZlD+XGgBxv3aFI0Dho/Jsh4B6jVcU8uKIl0P9oMn8UoWTvLjwfWkHqvbPJjS
         973A==
X-Gm-Message-State: AOAM531fcu+g06B81bqElWg2CSoZP+0bI7/7bU//mioZkrKckhLl9GYM
        0/4mun967gT/1Xq9cMZKacHFhFIh7CmAwOwaYu/GtQ==
X-Google-Smtp-Source: ABdhPJyPQFg6VtNrk4mxFB9Hl8M1ceG272vSBYpJyGK6MO45XnND81qQDYMq7zk3JniNVG1wHAxfcCAMesk6LZQk7ao=
X-Received: by 2002:a02:cd2e:: with SMTP id h14mr4237427jaq.6.1599150687075;
 Thu, 03 Sep 2020 09:31:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200901215149.2685117-5-awogbemila@google.com>
 <20200901173410.5ce6a087@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAL9ddJciz2MD8CYqdbFLhYCKFk=ouHzzEndQwmcfQ-UqNNgJxQ@mail.gmail.com> <20200902.160831.2194160080454145229.davem@davemloft.net>
In-Reply-To: <20200902.160831.2194160080454145229.davem@davemloft.net>
From:   David Awogbemila <awogbemila@google.com>
Date:   Thu, 3 Sep 2020 09:31:16 -0700
Message-ID: <CAL9ddJc9oCBijLtvGRmuMFNarKVcUwyPLhZD6HtLLubmXWFNmg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/9] gve: Add support for dma_mask register
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks, I'll adjust this.

On Wed, Sep 2, 2020 at 4:08 PM David Miller <davem@davemloft.net> wrote:
>
> From: David Awogbemila <awogbemila@google.com>
> Date: Wed, 2 Sep 2020 11:42:37 -0700
>
> > I don't think there is a specific 24-bit device in mind here, only
> > that we have seen 32-bit addressing use cases where the guest ran out
> > of SWIOTLB space and restricting to GFP_DMA32 helped.. so we thought
> > it would be natural for the driver to handle the 24 bit case in case
> > it ever came along.
>
> You should add such support when the situation presents itself, rather
> than prematurely like this.
>
> Thank you.
