Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D0E32FAB1
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 13:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbhCFMe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 07:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbhCFMe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Mar 2021 07:34:27 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F7DC06174A
        for <netdev@vger.kernel.org>; Sat,  6 Mar 2021 04:34:27 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id jt13so9361934ejb.0
        for <netdev@vger.kernel.org>; Sat, 06 Mar 2021 04:34:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rgdXUaiHxPPjp6g/jc8bnPAadPKsR1WA2Z1NBhivIsQ=;
        b=ZQrjMMrWIu8YDYL0UGVVxBuWyRDVm69pjw9DyQEw+z9QGVtOq5SGuxboglyZ+jGPdR
         Zb2AdPcBTWoyE4HJtKhxJAe5L9qBF3o0Hd0quridzYNT5NOCmHKZXt7eQIj2p5yt65Zl
         Z9YqPspuTM0dGj/Qq7oBoxto4lHvdvzo8O4JTfYfv/rsDx7mB9vYhn/XpjpU+N+1PM6I
         uWe84Qa0EaaOKVOwtUFGICeo19wyy9nqyLS+BDjfZwNKu+6EDWFX+6tABKd/uTrvNOd9
         rV3E9a5JvC3DKyxl07orDOLoe/GlqBrX459F4UPIjwl0YHx6srjbTiiFTNaSFocJZtRF
         siRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rgdXUaiHxPPjp6g/jc8bnPAadPKsR1WA2Z1NBhivIsQ=;
        b=MsV02dOv8xAHyPEEFgrZTqs6tWHtxBvHD5Y+YEu5YDVrPnPMBsGxRIvsDkuDlDUqCm
         j9dMWz0Pqpz9bI5vXRUg0HQq0og5h6AHB0goV1kGqI9AIabmPDFGryABYW/ZUZMIphbz
         20mIhLYRxgK6if0ZcrJ1uB6uEFKvQvG972Wirku4Et6OIk++OVPwY+gRgflDgQiDiQ/W
         MY91pNJcZiYnIkJJoFDp3K+QATNLD2PW5lQi0iwc6GiUG7Q62TiFx3akMF7JQngSbGQS
         AZnn4ACbiMYTwIxi+n9F4yCR48xqw5YFtqaHlm6VN+i3FC4Lyg6uZoQ7tU0tRaJqRv0d
         nFQg==
X-Gm-Message-State: AOAM530G/eoEwLtNZWZKdLTG1Ju1q6YLtPaShbiXpU7FhahibhNjgafw
        uTmL//UJDq4V8UVgEOSP/xi5ahOEEtYSzfd7gyA=
X-Google-Smtp-Source: ABdhPJy1xQ3mOuiL6sMfbxH4us7SEzmFrQMY9NaoKyK3pxFI5b24WXBOjY7LT7owA6U5unOk3H8nk2Mbon03kICWFSc=
X-Received: by 2002:a17:906:3856:: with SMTP id w22mr6730213ejc.77.1615034065972;
 Sat, 06 Mar 2021 04:34:25 -0800 (PST)
MIME-Version: 1.0
References: <CA+sq2CdJf0FFMAMbh0OZ67=j2Fo+C2aqP3qTKcYkcRgscfTGiw@mail.gmail.com>
 <20210305150702.1c652fe2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <YELKIZzkU9LxpEE9@lunn.ch>
In-Reply-To: <YELKIZzkU9LxpEE9@lunn.ch>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Sat, 6 Mar 2021 18:04:14 +0530
Message-ID: <CA+sq2CfAsyFHEj=w3=ewTKk-qbF60FcCQNtk9e7_1wxf=tB7QA@mail.gmail.com>
Subject: Re: Query on new ethtool RSS hashing options
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        George Cherian <gcherian@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 6, 2021 at 5:47 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Fri, Mar 05, 2021 at 03:07:02PM -0800, Jakub Kicinski wrote:
> > On Fri, 5 Mar 2021 16:15:51 +0530 Sunil Kovvuri wrote:
> > > Hi,
> > >
> > > We have a requirement where in we want RSS hashing to be done on packet fields
> > > which are not currently supported by the ethtool.
> > >
> > > Current options:
> > > ehtool -n <dev> rx-flow-hash
> > > tcp4|udp4|ah4|esp4|sctp4|tcp6|udp6|ah6|esp6|sctp6 m|v|t|s|d|f|n|r
> > >
> > > Specifically our requirement is to calculate hash with DSA tag (which
> > > is inserted by switch) plus the TCP/UDP 4-tuple as input.
> >
> > Can you share the format of the DSA tag? Is there a driver for it
> > upstream? Do we need to represent it in union ethtool_flow_union?
>
> Sorry, i missed the original question, there was no hint in the
> subject line that DSA was involved.
>
> Why do you want to include DSA tag in the hash? What normally happens
> with DSA tag drivers is we detect the frame has been received from a
> switch, and modify where the core flow dissect code looks in the frame
> to skip over the DSA header and parse the IP header etc as normal.

I understand your point.
The requirement to add DSA tag into RSS hashing is coming from one of
our customer.

>
> Take a look at net/core/flow_dissect.c:__skb_flow_dissect()
>
> This fits with the core ideas of the network stack and offloads. Hide
> the fact an offload is being used, it should just look like a normal
> interface.
>
>         Andrew

Yes, the pkt will look like a normal packet itself.
In our case HW strips the DSA tag from the packet and forwards it to a VF.

Thanks,
Sunil.
