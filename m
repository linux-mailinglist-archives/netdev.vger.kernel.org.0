Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A5C3EF1AE
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 20:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbhHQST1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 14:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233710AbhHQSTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 14:19:23 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E69C0613CF
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 11:18:50 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id a126so18291ybg.6
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 11:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TBVcCCEdlO1yhz6WJT/d6lJBLllOBmmuLQRQh1bNX7c=;
        b=fSfj2Sg1dNld8yWG8Qmz1EN96Elxqe/tci3kMJtgUh3PjpmnXOuQHxZbQ0tncfLJ6z
         FHoUptAtje18yQbtyKjbO+J4UVn36Hnl/xxzACrG+r3AJx6L61J1bBZoxWJNQmUHU7NB
         U8qTfHtTaOgbKtmO8P+/VOkJ7zceFFLkol8a8yT+JhLixpeeCD5ecFjSjoPQaOxQ511q
         C4HE4ktussXQFbZkEroyrytK+MMhQWOD+HRVN8IBQAoXCu6c3W5MQCnOqXqr7q9e6nPw
         HGqQW3M2l/MOD5hACsnHLEYsrk3D9Xz4x8+ZwFE8djU/xCMkl9g41W6D/wYGSAT4fcmv
         rTFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TBVcCCEdlO1yhz6WJT/d6lJBLllOBmmuLQRQh1bNX7c=;
        b=Dh3O+wAxVLY9rUf1m+V7t3qbPt9wM4BMBAEFuvyMsF1sj0PV/NHF/Qv41Mfj7FthKY
         FlRLaNxuMHlv+qECznXTNdxSm0SrMqZ83wFVshKpuJbM553MTsXjnwiID0giu7RTAocQ
         Rt8YLoPe+FQeHMI5OFNcN9VzQv6s36TTrnuuJtgVAdRa6TuZCbpQrYBvowJ5zHHM0Rg5
         WdYxTHkT3K1muoBieiNY3xqB9WkAH+VsG9TLWztgBzzOHqlpWoVLy8LcqRk5g/pl3w52
         Jqv41Qx822KTsX6sm0BargmpxynGOIdB/NCILgACdMmaD8IZpZV/M//nJMo4acR98Ncx
         SF5g==
X-Gm-Message-State: AOAM532vzuEUyN/on/ybw5glZG5qdNsLRdevTOPo4/mMDjswiZIEuAsp
        2PAJR70cSK+HFzjViIve8hMrFf/ZQWOLYR4PIAgPbA==
X-Google-Smtp-Source: ABdhPJzRbf9aP2PWwJSev85a1GxBJvMupMHuRJJUIWPWxbZT87rDvgi0p7qBLFb+UHdFKiObOoN7nYoAkSrlniwwwVI=
X-Received: by 2002:a25:d1c2:: with SMTP id i185mr6232718ybg.466.1629224329242;
 Tue, 17 Aug 2021 11:18:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210814023132.2729731-1-saravanak@google.com>
 <20210814023132.2729731-3-saravanak@google.com> <YRffzVgP2eBw7HRz@lunn.ch>
 <CAGETcx-ETuH_axMF41PzfmKmT-M7URiua332WvzzzXQHg=Hj0w@mail.gmail.com> <CAL_JsqJa_8sxdKit_UKHwkuOhK9L=SDYuRAD0vsY7pRE6sM3Qg@mail.gmail.com>
In-Reply-To: <CAL_JsqJa_8sxdKit_UKHwkuOhK9L=SDYuRAD0vsY7pRE6sM3Qg@mail.gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Tue, 17 Aug 2021 11:18:13 -0700
Message-ID: <CAGETcx_MiezJGoJP8LOfVACU0dQbJmcqcwugded_tJ+OLrECPw@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] of: property: fw_devlink: Add support for
 "phy-handle" property
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Frank Rowand <frowand.list@gmail.com>,
        Android Kernel Team <kernel-team@android.com>,
        devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 2:11 PM Rob Herring <robh+dt@kernel.org> wrote:
>
> On Mon, Aug 16, 2021 at 3:43 PM Saravana Kannan <saravanak@google.com> wrote:
> >
> > On Sat, Aug 14, 2021 at 8:22 AM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > Hi Saravana
> > >
> > > > Hi Andrew,
> > > >
> > >
> > > > Also there
> > > > are so many phy related properties that my head is spinning. Is there a
> > > > "phy" property (which is different from "phys") that treated exactly as
> > > > "phy-handle"?
> > >
> > > Sorry, i don't understand your question.
> >
> > Sorry. I was just saying I understand the "phy-handle" DT property
> > (seems specific to ethernet PHY) and "phys" DT property (seems to be
> > for generic PHYs -- used mostly by display and USB?). But I noticed
> > there's yet another "phy" DT property which I'm not sure I understand.
> > It seems to be used by display and ethernet and seems to be a
> > deprecated property. If you can explain that DT property in the
> > context of networking and how to interpret it as a human, that'd be
> > nice.
>
> For net devices, you can have 2 PHYs. 'phys' is the serdes phy and
> 'phy-handle' is the ethernet (typically) phy. On some chips, a serdes
> phy can do PCS (ethernet), SATA, PCIe.
>
> 'phy' is deprecated, so ignore it. The one case for displays I see in
> display/exynos/exynos_hdmi.txt should be deprecated as well.
>
> There's also 'usb-phy' which should be deprecated.

Thanks for the explanation Rob. I'll ignore phy and usb-phy unless it
becomes an issue for any future changes/improvements.

-Saravana


-Saravana
