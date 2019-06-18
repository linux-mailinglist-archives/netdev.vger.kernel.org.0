Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABEBB4A622
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 18:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbfFRQDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 12:03:52 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38166 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729320AbfFRQDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 12:03:52 -0400
Received: by mail-pf1-f195.google.com with SMTP id a186so7916133pfa.5
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 09:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dczz5zgwbgg1guB6e3ADRU38B5wXKVmi34uwnCDC2Ic=;
        b=HoAYDleCDAkCDwBilQd5Sk9GOq9lTAGaI73DTp+pbcxKVTRryCY73mIuF7xoloKPe8
         g3FXdlZrF42AMYfrwXdQtZjTbnyziD87Zy7z+MeWTjDEZGBNtqu4Xus+gDpc73f9ojmx
         b2bk4SvvZk3fngGFF7kVL9PUodmrbS+7NEVRgT8EE0tnBt/2utXN0mYa/lrZasJFIBE5
         jmc2A8S1XSXCfZyQJ9utYWpsGYdC/k2JFYpFNm8NPGWWsn8Ws5vJbjHfiXCj5abFO73V
         yKtygD/hSKPs0lVUPAyAUsfhkZykPZ7/frJ6sNU1GFccAwkhEH5Ve/DKvVvm1VwjCuMf
         UGaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dczz5zgwbgg1guB6e3ADRU38B5wXKVmi34uwnCDC2Ic=;
        b=fNzPiFGVpk4c8AdkqmDDi5Lm2gxQWz4KXJfcDsrgZBjoLWu/mq8AiZW7PyP6C2vaLo
         iHm2sbUQLPUadIS7jwG8YIAPjkuBQrKkAE4ribA+y9/m3Ozw8JVCzuma8MTUsQkYRODO
         kpGZWFdeHuX++l+LF6ESJe1pVakLTcKhDWvqMSQFasmbffg4QIZiMjlnNefkKTGuqiGY
         LslXxIXrX381KXiAru7Hid9VL7/n7GQXquBOzSoulN1NwxxqLnQg/kFAJjHGdfHtIOon
         RG1UeIAYRdP16h+sinFL2AkToEdhU2uxJhCYJ3WtBuV8oM6dPnnh6QbrKlGq7uMq5HGx
         NSQg==
X-Gm-Message-State: APjAAAX6oKCtH80jNR3G2LZVu3a7qTLHhh9tf/x0KN8wTyiJQzw2RJ0e
        Unp2L/9rw7fsNfj6q9xF+fgeisu5jxfoGp0OWGE=
X-Google-Smtp-Source: APXvYqyUSxf1topCG53CmQcLjew+7tjtLeSzb+28HdaCMpXATBgWmsSADYWUpf87QmqAkn/E0BcsHvRCCCTzFXV8w78=
X-Received: by 2002:aa7:804c:: with SMTP id y12mr118157346pfm.94.1560873831476;
 Tue, 18 Jun 2019 09:03:51 -0700 (PDT)
MIME-Version: 1.0
References: <1560259713-25603-1-git-send-email-paulb@mellanox.com>
 <1560259713-25603-2-git-send-email-paulb@mellanox.com> <87d0jkgr3r.fsf@toke.dk>
 <da87a939-9000-8371-672a-a949f834caea@mellanox.com> <877e9sgmp1.fsf@toke.dk>
 <20190611155350.GC3436@localhost.localdomain> <CAM_iQpX1jFBYCLu1t+SbuxKDMr3_c2Fip0APwLebO9tf_hqs8w@mail.gmail.com>
 <20190614192403.GK3436@localhost.localdomain>
In-Reply-To: <20190614192403.GK3436@localhost.localdomain>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 18 Jun 2019 09:03:39 -0700
Message-ID: <CAM_iQpWLrRKKr4v6sUWeFfaJDJe4tGHdCAfUttxV4oQim=-9Bw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net/sched: Introduce action ct
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Paul Blakey <paulb@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>,
        Rony Efraim <ronye@mellanox.com>,
        "nst-kernel@redhat.com" <nst-kernel@redhat.com>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>,
        Kevin Darbyshire-Bryant <kevin@darbyshire-bryant.me.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 12:24 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Fri, Jun 14, 2019 at 11:07:37AM -0700, Cong Wang wrote:
> > On Tue, Jun 11, 2019 at 9:44 AM Marcelo Ricardo Leitner
> > <marcelo.leitner@gmail.com> wrote:
> > > I had suggested to let act_ct handle the above as well, as there is a
> > > big chunk of code on both that is pretty similar. There is quite some
> > > boilerplate for interfacing with conntrack which is duplicated.
> >
> > Why do you want to mix retrieving conntrack info with executing
> > conntrack?
>
> To save on the heavy boilerplate for interfacing with conntrack.
>
> >
> > They are totally different things to me, act_ctinfo merely retrieves
> > information from conntrack, while this one, act_ct, is supposed to
> > move packets to conntrack.
>
> Seems we have a different understanding for "move packets to
> conntrack": conntrack will not consume the packets after this.
> But after act_ct is executed, if not with the clear flag, skb will now
> have the skb->_nfct entry available, on which flower then will be able
> to match. So in essence, it is also fetching information from
> conntrack.

Interesting. Is it because cls_flower uses conntrack for flow dissection?
What's the reason behind?

Again, I am still not convinced to do L3 operations in L2, skb->_nfct
belongs to conntrack which is L3, no matter the packet is consumed
or not.

Thanks.
