Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7BC25F661
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 11:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbgIGJXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 05:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728034AbgIGJXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 05:23:16 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD56C061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 02:23:15 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id y194so7047210vsc.4
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 02:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GBjC6LgsXmyRTFlOrXgXx23bviroU6DrK6ZiFWBgik0=;
        b=Ix+SP49aOyHAg/LDL0Qfvoem123dBoUolQTXi7YjAo0uuVk0297CdTiC3zll82eiwX
         OIFk0d2c4pI1jm7uoNB+hwGS3lkU8t7LXUp6g4NOn2lP+TWO8ZA8MyLksvKmEndRpFb0
         G/uPQAgjEp3FLZCxIan72e6ghxZ7gtTcR/E7gbQDdNupo19nZ9Nml1dklJqEMvRmhUnm
         ZIzaYQ+BE1Fejp3GRiEF1iqePsK/WCtnvvWykHLUtCg4WE52KTCMDSEim0hNOIqhrgTl
         S+YIF8ZYPswYhgGPHgM0VYOfnPiGcDLpV5YPbvmiINDTKy+5aqHrG7Xpm2O1jGCzxrdO
         Cubw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GBjC6LgsXmyRTFlOrXgXx23bviroU6DrK6ZiFWBgik0=;
        b=oPMzjy0bSs+J69v8jWf/he9VQEyuLTagqheu8m91N5nF9Oefut2u2FXKeQdG9ZEgh/
         SIVEVJoe8qt0nU4joO/ONolG3AZl4kvtMUTLtd634BIH0T924pXWlYY7gTMI6Id/kuZY
         n5Dnw7X8pnW7/I/of6XGlzJypIA480zynkiv/jJkhMrvKpQ8Dyx2Snjr3iGB5V48/ytT
         f2CJQWK8IQ/QcWJvZpwFtXaqswLFc4M8mH605YQGaDZxz4ajlG7++gJes1J/4HM1DTuH
         P53EsdkyM3njz/Z+Jc+j0EDn3Vx8k9JgZ7Zatnx7Fx/XdtuFgT0H0jlYRy9N57qM7IMF
         1v0g==
X-Gm-Message-State: AOAM531QTGqJPGHrhyXS6HMbKlygHuRnH3wf/spR7Djxiw3aNdH+ZLkX
        PikNeNhSkupdVHy/FUpXB72Auw8VCZ2HIQ==
X-Google-Smtp-Source: ABdhPJzDJARdWNMA/gWFthuiWO3b6F5Q+1otA62Eq4pRqe+XieQmv/c7t8+59TNScn6MNjIyTKlypQ==
X-Received: by 2002:a67:e190:: with SMTP id e16mr1856001vsl.5.1599470594154;
        Mon, 07 Sep 2020 02:23:14 -0700 (PDT)
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com. [209.85.217.45])
        by smtp.gmail.com with ESMTPSA id n8sm2353815vkk.13.2020.09.07.02.23.12
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 02:23:13 -0700 (PDT)
Received: by mail-vs1-f45.google.com with SMTP id c127so1311398vsc.1
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 02:23:12 -0700 (PDT)
X-Received: by 2002:a67:ebc4:: with SMTP id y4mr11763629vso.119.1599470592359;
 Mon, 07 Sep 2020 02:23:12 -0700 (PDT)
MIME-Version: 1.0
References: <1599286273-26553-1-git-send-email-tanhuazhong@huawei.com> <20200906114153.7dccce5d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200906114153.7dccce5d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 7 Sep 2020 11:22:33 +0200
X-Gmail-Original-Message-ID: <CA+FuTSfeEuTLAGJZkzoMUvx+0j3dY265i8okPLyDO6S-8KHdbQ@mail.gmail.com>
Message-ID: <CA+FuTSfeEuTLAGJZkzoMUvx+0j3dY265i8okPLyDO6S-8KHdbQ@mail.gmail.com>
Subject: Re: [PATCH net-next 0/2] net: two updates related to UDP GSO
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Huazhong Tan <tanhuazhong@huawei.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        salil.mehta@huawei.com, yisen.zhuang@huawei.com,
        linuxarm@huawei.com,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 6, 2020 at 8:42 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 5 Sep 2020 14:11:11 +0800 Huazhong Tan wrote:
> > There are two updates relates to UDP GSO.
> > #1 adds a new GSO type for UDPv6
> > #2 adds check for UDP GSO when csum is disable in netdev_fix_features().
> >
> > Changes since RFC V2:
> > - modifies the timing of setting UDP GSO type when doing UDP GRO in #1.
> >
> > Changes since RFC V1:
> > - updates NETIF_F_GSO_LAST suggested by Willem de Bruijn.
> >   and add NETIF_F_GSO_UDPV6_L4 feature for each driver who support UDP GSO in #1.
> >   - add #2 who needs #1.
>
> Please CC people who gave you feedback (Willem).
>
> I don't feel good about this series. IPv6 is not optional any more.
> AFAIU you have some issues with csum support in your device? Can you
> use .ndo_features_check() to handle this?
>
> The change in semantics of NETIF_F_GSO_UDP_L4 from "v4 and v6" to
> "just v4" can trip people over; this is not a new feature people
> may be depending on the current semantics.
>
> Willem, what are your thoughts on this?

If that is the only reason, +1 on fixing it up in the driver's
ndo_features_check.
