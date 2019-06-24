Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3AD519EF
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 19:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbfFXRrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 13:47:09 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42873 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726351AbfFXRrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 13:47:08 -0400
Received: by mail-pg1-f194.google.com with SMTP id k13so1338754pgq.9
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 10:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J/VyRhhi+tkSnQF+bKuV1UGRzxDMAqV/2Rdzw8GybhY=;
        b=uFac5Oy94YSkgvc3eg4Zqizhnxe3EOkpa1HCTTLoiZ8IoUAU8kigZ2onXpKFXNInDH
         Pms+9LCtil+SKSqKsOZEDg+cLchhjY50hJelFfLeSMKMvxqPNQiCMR4xZspb9YFJEk8l
         HiXANbiQUJEvZQdkNsTikRiIvqkPr9WOhj6vr10NaE9skrviGYaO37EYYjPaAZc/KO5H
         S8MKLLdhpyNw00PTXWsIjmBIhcMYlUpxEhYrMXu+HckxDxkFpVdIi9Valcbvxdke9y+S
         NJLRxC8BrRGMqgyLhCy4WzcmniNmHuDfZuO/MVgvXjRnY+UHWU+8VDIJVG24iddnKXuz
         dBwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J/VyRhhi+tkSnQF+bKuV1UGRzxDMAqV/2Rdzw8GybhY=;
        b=Wf3xdG7RFB3HCvRxGCJB6sWiJXrJUTEjiPEgg4n89uv1ropWEKg89PFk//T9EOhy4s
         mcGP/MGipurLbhgUYStIPSpCSrHsuhHG9ESxVw+TWeR5q30MwejdYPF4PKYC5FEPrd1z
         WYw3k20+FOOiXRZMwDSoTd8OJ4f/HXv1hxqC9kuFfiT7xYBVETYCzCq5+5tVCOVTa0x/
         OUlYPUhf6lzBHPBXfGIDtGy25qZ0FtUk/Mc6QEbJApkFhXdWtxIOwt8PVQZFplRVgxnv
         oR/nsic9Imqd6TNFYCcBp6nXdZLI95mOTOLqUnMA6t5RvgkatqWS/4Z7zhbha2a2pzvD
         Yxug==
X-Gm-Message-State: APjAAAV7/psGMVe6MR6xBAoUP6Fy2W937+1jHBphbRMl7MyeI00htOiw
        3FAFglljHGVFBM9vChowLvML22a/uZcvI0jNGT4=
X-Google-Smtp-Source: APXvYqyHuIKT0NZelswaroVQMsfFpKsp8VGLub7YTiusG3BpfgFWu1HAsNOdMBvpVRObp+V7KK9+lvoqldw0P5yccQg=
X-Received: by 2002:a17:90a:634a:: with SMTP id v10mr24262680pjs.16.1561398427896;
 Mon, 24 Jun 2019 10:47:07 -0700 (PDT)
MIME-Version: 1.0
References: <1560259713-25603-1-git-send-email-paulb@mellanox.com>
 <1560259713-25603-2-git-send-email-paulb@mellanox.com> <87d0jkgr3r.fsf@toke.dk>
 <da87a939-9000-8371-672a-a949f834caea@mellanox.com> <877e9sgmp1.fsf@toke.dk>
 <20190611155350.GC3436@localhost.localdomain> <CAM_iQpX1jFBYCLu1t+SbuxKDMr3_c2Fip0APwLebO9tf_hqs8w@mail.gmail.com>
 <20190614192403.GK3436@localhost.localdomain> <CAM_iQpWLrRKKr4v6sUWeFfaJDJe4tGHdCAfUttxV4oQim=-9Bw@mail.gmail.com>
 <db10725e-d31a-efda-e57e-9978fd680c92@mellanox.com>
In-Reply-To: <db10725e-d31a-efda-e57e-9978fd680c92@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 24 Jun 2019 10:46:55 -0700
Message-ID: <CAM_iQpX5Ti2F23BTEs7RqDZW_sbWFAT5Fak2vbdBsjGAp-WmpQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net/sched: Introduce action ct
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
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

On Thu, Jun 20, 2019 at 12:32 AM Paul Blakey <paulb@mellanox.com> wrote:
>
>
> On 6/18/2019 7:03 PM, Cong Wang wrote:
> > On Fri, Jun 14, 2019 at 12:24 PM Marcelo Ricardo Leitner
> > <marcelo.leitner@gmail.com> wrote:
> >> On Fri, Jun 14, 2019 at 11:07:37AM -0700, Cong Wang wrote:
> >>> On Tue, Jun 11, 2019 at 9:44 AM Marcelo Ricardo Leitner
> >>> <marcelo.leitner@gmail.com> wrote:
> >>>> I had suggested to let act_ct handle the above as well, as there is a
> >>>> big chunk of code on both that is pretty similar. There is quite some
> >>>> boilerplate for interfacing with conntrack which is duplicated.
> >>> Why do you want to mix retrieving conntrack info with executing
> >>> conntrack?
> >> To save on the heavy boilerplate for interfacing with conntrack.
> >>
> >>> They are totally different things to me, act_ctinfo merely retrieves
> >>> information from conntrack, while this one, act_ct, is supposed to
> >>> move packets to conntrack.
> >> Seems we have a different understanding for "move packets to
> >> conntrack": conntrack will not consume the packets after this.
> >> But after act_ct is executed, if not with the clear flag, skb will now
> >> have the skb->_nfct entry available, on which flower then will be able
> >> to match. So in essence, it is also fetching information from
> >> conntrack.
> > Interesting. Is it because cls_flower uses conntrack for flow dissection?
> > What's the reason behind?
> >
> > Again, I am still not convinced to do L3 operations in L2, skb->_nfct
> > belongs to conntrack which is L3, no matter the packet is consumed
> > or not.
> >
> > Thanks.
>
> I'm not sure what you mean, the reason behind what?


Yes, which should be the most important info in changelog.


>
> We use conntrack to track, mark the packet with conntrack info, and
> execute nat, then we push the
>
> headers back to continue processing the next action. This action will
> probably be followed by
>
> goto chain or reclassify and then cls_flower can be used to match on
> conntrack state and metadata via the new flow dissector change.
>

Sounds cool, but again why do we have to do this in L2?

Also, I am not sure if cls_flower really matches packets with any
conntrack state, from my quick glance of its code. Is this feature
merged in upstream?

Is this for ingress only? For egress, packets coming down from L3
so they should already have conntrack state as long as it is enabled?

Sorry for asking many questions here, because your changelog is too
short. :-/

Thanks.
