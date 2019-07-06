Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDF3D60F44
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 08:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbfGFGtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 02:49:02 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54425 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfGFGtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 02:49:02 -0400
Received: by mail-wm1-f65.google.com with SMTP id p74so8007413wme.4
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 23:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PkY22paQafH7ovcei4w38Csq5vJvhM1OVUCaK/orVRc=;
        b=SLvvjHnNUEubxPjGPWCzDLPzDzHpJTQpg9fTMmwaX0Z1+5gAl7lZjXbjUWfxwykduP
         nE3MPburXOoIk6Zzd+1j1mbCGbwb5kD2OTxROcQSsJ6JR3ReAOR/+VA2JF1fLBnQQpYp
         XWHoonJt4DhQt683d5mK47G2WumCJ6Z5l8dpWPM/kYW6NCyXWpsrhWSCFnBKI9T1sW7v
         70rSCcxgITsLNpXLw6f7PBWb5rXEHV1Fm433HkNASGqVhhqRdEnqFkfVgbqejUOSCx9u
         5ZkBJyDZPZcfRbGMHl/hSEvpR2uuio+aXYOITp6Lw6HWunoaZ1VlcRCxS2YJ5d9+aijY
         RLgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PkY22paQafH7ovcei4w38Csq5vJvhM1OVUCaK/orVRc=;
        b=eXWHEavcg3s+HTKoc/DtDaTcM5qrwiiDfKlFojX/vtDYsYC5OrVndkqy0C3dGhzvIy
         CX7FtcWzXO7Z0cfKcLwKkgZ+YA3gJKTo4TXuDg2+1nIgFwLTiMafUH2oymoUhwe4VZn5
         40+WPYN9qr986NHhguUehXiR1m/Uf/Sc65nUS6qwA3YOwsh3iyxyOsq0ZMbNYN0bBMdD
         981to82oW+aZFH6JY9gJg92UwgbjOtz7aL1X2AwTzR1SoGVdSW4eSNLiA4GfVtLfo7pA
         FGKbr2CWNSFJB6f6PSIVgmBuJSvy5UHUp4Y2pFn/O+9EMOTbmckb+pmgYZmhzWiLq/bA
         +FGw==
X-Gm-Message-State: APjAAAV8H2S9VcUobbP03rKvHstdagKMfeDcfxcZpbXFlQppl15tqCF6
        5k9R8uZJl5N0OZdTKX8xyDopgjIUzmxUhLk70MXQofnz
X-Google-Smtp-Source: APXvYqyZ9ybCCfZsU9WLN3bjf4WXABH/jeGvr5DsnVGu7DZURZ3VCvx30quB3qOFe82fdFKppr038Xlcv4kHgQvD910=
X-Received: by 2002:a1c:1bd7:: with SMTP id b206mr2047553wmb.85.1562395739710;
 Fri, 05 Jul 2019 23:48:59 -0700 (PDT)
MIME-Version: 1.0
References: <07e0518ac689f5919890a38634df38edf95d34a1.1562000095.git.lucien.xin@gmail.com>
 <20190702.150811.1940085234903099096.davem@davemloft.net> <CADvbK_emyKTg8=ye8n2ZTBx0QFK9gPL02aVDfn44DuyUTP-ofw@mail.gmail.com>
In-Reply-To: <CADvbK_emyKTg8=ye8n2ZTBx0QFK9gPL02aVDfn44DuyUTP-ofw@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 6 Jul 2019 14:48:48 +0800
Message-ID: <CADvbK_eDnUMSaoT65hco2PF5-f1PO=CKBeMPz3sTRZvg5qKGVA@mail.gmail.com>
Subject: Re: [PATCH net-next] tipc: use rcu dereference functions properly
To:     David Miller <davem@davemloft.net>
Cc:     network dev <netdev@vger.kernel.org>,
        Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 3, 2019 at 4:33 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Wed, Jul 3, 2019 at 6:08 AM David Miller <davem@davemloft.net> wrote:
> >
> > From: Xin Long <lucien.xin@gmail.com>
> > Date: Tue,  2 Jul 2019 00:54:55 +0800
> >
> > > For these places are protected by rcu_read_lock, we change from
> > > rcu_dereference_rtnl to rcu_dereference, as there is no need to
> > > check if rtnl lock is held.
> > >
> > > For these places are protected by rtnl_lock, we change from
> > > rcu_dereference_rtnl to rtnl_dereference/rcu_dereference_protected,
> > > as no extra memory barriers are needed under rtnl_lock() which also
> > > protects tn->bearer_list[] and dev->tipc_ptr/b->media_ptr updating.
> > >
> > > rcu_dereference_rtnl will be only used in the places where it could
> > > be under rcu_read_lock or rtnl_lock.
> > >
> > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> >
> > In the cases where RTNL is held, even if rcu_read_lock() is also taken,
> > we should use rtnl_dereference() because that avoids the READ_ONCE().
> Right, that's what I did in this patch.
>
> But for the places where it's sometimes called under rtnl_lock() only and
> sometimes called under rcu_read_lock() only, like tipc_udp_is_known_peer()
> and tipc_udp_rcast_add(), I kept rcu_dereference_rtnl(). makes sense?
Hi, David, I saw this patch in "Changes Requested".

I've checked all places with this patch, no function calling rcu_dereference()
and rcu_dereference_rtnl() will be ONLY called under rtnl_lock() protection.
So I can't see a problem with it.

Do I need to resend?
