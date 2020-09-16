Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D4B26BB80
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 06:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgIPE05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 00:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbgIPE04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 00:26:56 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50F5C06174A;
        Tue, 15 Sep 2020 21:26:54 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id g96so5404176otb.12;
        Tue, 15 Sep 2020 21:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BjCFbGmPmsk7PjTa4PqyTGBZejxzGNrHohCt8u93HL0=;
        b=Rt2LpIbxECIIT5r72IgzJlUWFN/DiqiKJfmOc7EFuBihxuYMIeiU7ZRS4Qr2t5Qb+O
         hjJkiLBms7/rjA2i0o35xAUWE6tLaHPrToLirTEMP4pC2jpvsog3c/uk9McMnaZybDoP
         U+zGR44vxisksgcner/C2JHvIV1eO+4Ja+sPy2nNiTDMDrNR6nm/SXzoeSAk9rbZ2EWT
         6i5wh/oWq0xR4Q+zPkyNwHHnhPs+Ajn4ZqTLYfuHFlv4F47vpKQqEVkr2kH5FWdJtg0Y
         vB6fnlTukD/f/BfvJ40vIg5/l5Oss09QcNDKPEUxF3hakvYV1JvmxzLa/oF7NegdR+RO
         5SXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BjCFbGmPmsk7PjTa4PqyTGBZejxzGNrHohCt8u93HL0=;
        b=nYgTwJanxsCRcCUtJ2ovhy7Ep9eryTKul1S97unmVRfEdE+vEFxO5v6TGjTaEGKQVi
         SFMd6m1X42kzOl81wBJa9HqxSiPibknIyrPviGL2c8qEyyTyPrDp1ZoNBtDt1etngHNC
         VzH772gegEoK5bpNnx4mMakyhegkt2e26I7ASB92yXNiT0OeCypfSIbnHRds0/TcscXB
         hC3hnJg6fYc8gURrPubQe/javTBT99lWSFZJzIMS4c6TjC4wwpBQxFcGrYUgf7699FIw
         HLBWdAXJGqH1H4A5bRV/YbQTVrsigx2URXxeAh8Zp0RIy7IYbt0mByHDEHitfVBU6FW4
         PqAg==
X-Gm-Message-State: AOAM530FcDWj/xapO3L0msTJ+ka2rYD2eHRwoq87Z93CmQnBaAzYUk1o
        ukALoCIOzw1E81G9oPeLUojdIE0Iv4AL3SgprZ5eezlni+yioQ==
X-Google-Smtp-Source: ABdhPJx6Reu4lQxpEQCi6cm/jKU0KJZ1o/chXk6/dcA7ql4ztI76CFS66ybppJIiP6EdnWWUSOkrIPElxCHgo2u0M6w=
X-Received: by 2002:a9d:5a92:: with SMTP id w18mr14967737oth.145.1600230414131;
 Tue, 15 Sep 2020 21:26:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAFCwf12XZRxLYifSfuB+RGhuiKBytzsUTOnEa6FqfJHYvcVJPQ@mail.gmail.com>
 <20200915140418.4afbc1eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf10+_hQOSH4Ot+keE9Tc+ybupvp5JyUhFbvfoy6HseVyZg@mail.gmail.com> <20200915.153449.1384323730053933155.davem@davemloft.net>
In-Reply-To: <20200915.153449.1384323730053933155.davem@davemloft.net>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Wed, 16 Sep 2020 07:26:26 +0300
Message-ID: <CAFCwf10fa7Hq=hMeg9mrfnaFXi9gtJU82BiShE4TpBOg8yuHgQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 1:34 AM David Miller <davem@davemloft.net> wrote:
>
> From: Oded Gabbay <oded.gabbay@gmail.com>
> Date: Wed, 16 Sep 2020 00:20:12 +0300
>
> > I completely understand but you didn't answer my question. How come
> > there are drivers which create netdev objects, and specifically sgi-xp
> > in misc (but I also saw it in usb drivers) that live outside
> > drivers/net ? Why doesn't your request apply to them as well ?
>
> Don't use examples of drivers doing the wrong thing as an excuse for
> you to repeat the mistake.
>
> Ok?
Well, it's not like there is a big red warning near those drivers
saying "this is wrong"...
How could I have known that in advance ?

>
> That kind of argument doesn't work here.
I know that, I just didn't know those drivers did "the wrong thing"

Oded
