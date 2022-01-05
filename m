Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFEF4856F3
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 17:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242090AbiAEQ7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 11:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242066AbiAEQ67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 11:58:59 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0C6C061245
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 08:58:58 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id o185so92732279ybo.12
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 08:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z6pqyye0/PaHUQriyKleOlbyJsUfxkh1QL2j8RSpJyA=;
        b=mVDSnu8huiM5DtWWp9z7VMWG32aMRnhUPdwIqNzEI1fPRQhdlKNJzMAvzK5kpTWRbQ
         Oui6R8821dDrYlsFUEiSgc4veMY6bOyubM9hCPQ3REGYJU9FwuYf+SJTwqKRmzQ3P+IR
         nBt7fzgNkMm/vNCB0AuZPmiZ0wa2E8+yYeKOpvCGE6J6t7c09WYqReAisD4pCXzc58Zp
         ezTsiyXxNUdsFDeNO1Gfh6a4qxTugcmKLXEYAJEbkxJC+8i+zrRptwN5nBqlNdJoEp5U
         P7Hyy1i7pmTawIcvYeSe8Dy9dzz3pw4fiNeIYEHf9OK6xKh/7HdUGUnBV4GFv+nPelQ6
         ie4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z6pqyye0/PaHUQriyKleOlbyJsUfxkh1QL2j8RSpJyA=;
        b=4gX01Gr7vlKC+eVq44Ijt7vFbL0bgQe4+/ZQKtr61pHrq6piOgGC0C63B6zwkEWzbp
         mQajgHHnvDBu3YCBEg2at5o/+ZkBA8B6QSfHic9Bf6uBBYmW0Ry070T9t5LnQbQ1szC1
         xs+b9P9TVGzckNfi+n5AqoIYc0tkAGAR0YOTqyu2cptIoLaQ4RMk8ZX+kq+oIiUv+9hq
         EumSVe00zL1R9fkcbo3zmBPuQ4TBrkTyeoMlkjeSVu3hbDmMEBmslGr7AuyZKPYMc/kU
         jNNlqmw+RItZcnPm5SamCTQwutloagv4bYNH1nK9dsJqWv31BwZ60N4DlxO9bw2Nk4qJ
         Jrpw==
X-Gm-Message-State: AOAM533jEzLJh7AahhpjgNIWRM4eX8Ax1/cMAbOZMlmYIQvRoox5vvWS
        lbs/eSD5Ad94gtHo5FTITXvisSpe9jfu11J9EDdBucXnFXo=
X-Google-Smtp-Source: ABdhPJzDEWxH+q6zzAm6iCqrC4AMQbzP+mcNpTDK1OlXuqqTk+0IO6TcD76E0wrFfpV/6Eu3bXPpcnKiXLoaqa5r7O0=
X-Received: by 2002:a25:9d82:: with SMTP id v2mr68646248ybp.383.1641401937822;
 Wed, 05 Jan 2022 08:58:57 -0800 (PST)
MIME-Version: 1.0
References: <20211207013039.1868645-1-eric.dumazet@gmail.com>
 <20211207013039.1868645-12-eric.dumazet@gmail.com> <5836510f3ea87678e1a3bf6d9ff09c0e70942d13.camel@sipsolutions.net>
 <CANn89i+yzt=Y_fgjYJb3VMYCn7aodFVRbZ9hUjb0e4+T+d14ww@mail.gmail.com>
 <c14b5872799b071145c79a78aab238884510f2a9.camel@sipsolutions.net>
 <CANn89iLYo8XQbKGxT=pKQepe8FeELx0pnpMWjKS8n93uHwNJ5Q@mail.gmail.com>
 <e2f0315e65052b7ff798e61100a02f624a609afb.camel@sipsolutions.net> <20220105085744.52015420@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220105085744.52015420@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 5 Jan 2022 08:58:46 -0800
Message-ID: <CANn89iJh_rUgL1MPuABJrwaXRMpakpLBiJ7uX=z84O+NaP5OYQ@mail.gmail.com>
Subject: Re: [PATCH net-next 11/13] netlink: add net device refcount tracker
 to struct ethnl_req_info
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000070761605d4d8ab5e"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000070761605d4d8ab5e
Content-Type: text/plain; charset="UTF-8"

On Wed, Jan 5, 2022 at 8:57 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 04 Jan 2022 17:23:51 +0100 Johannes Berg wrote:
> > > diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
> > > index ea23659fab28..5fe8f4ae2ceb 100644
> > > --- a/net/ethtool/netlink.c
> > > +++ b/net/ethtool/netlink.c
> > > @@ -627,7 +627,6 @@ static void ethnl_default_notify(struct net_device
> > > *dev, unsigned int cmd,
> > >         }
> > >
> > >         req_info->dev = dev;
> > > -       netdev_tracker_alloc(dev, &req_info->dev_tracker, GFP_KERNEL);
> >
> > So I had already tested both this and explicitly doing
> > netdev_tracker_free() when req_info is freed, both work fine.
> >
> > Tested-by: Johannes Berg <johannes@sipsolutions.net>
> >
> > Just wasn't sure it was correct or I was missing something. :)
>
> Hi Eric, I didn't see this one submitted, is it coming?
> No rush, just checking if it fell thru the cracks.

Yes, this is coming ;)

--00000000000070761605d4d8ab5e
Content-Type: image/gif; name="cleardot.gif"
Content-Disposition: attachment; filename="cleardot.gif"
Content-Transfer-Encoding: base64
Content-ID: <f_ky1sbj5a0>
X-Attachment-Id: f_ky1sbj5a0

R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==
--00000000000070761605d4d8ab5e--
