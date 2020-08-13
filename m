Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03280243800
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 11:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgHMJxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 05:53:21 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56227 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726048AbgHMJxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 05:53:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597312398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0KScZeNODIkjWl0+wzt1znUJvg/15bvPJ6ZgVRw9LTg=;
        b=YrEWXyleU3Bn0YXr8lmQDGYnbIzQw/qMoQLiFWLYan0xYOReaMGSMJbn6tlBMiWhaxEXUp
        w9dQL/dsUN9FNp100HpPZkEpTpUaUtQFLw4mA8jWDj23UNavmC3enIwRClj1TP4cpUHWuG
        nNqavq0vJPqDm6GsWlhMr8KhkCOwQXY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-IRfodTECNJSxQU5fCVj0HA-1; Thu, 13 Aug 2020 05:53:16 -0400
X-MC-Unique: IRfodTECNJSxQU5fCVj0HA-1
Received: by mail-wm1-f72.google.com with SMTP id c124so1784590wme.0
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 02:53:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=0KScZeNODIkjWl0+wzt1znUJvg/15bvPJ6ZgVRw9LTg=;
        b=Zxo4FE0xmSU89Y+lkgWGRg5+JdYYSI60ZEqQzUDCCqIVJoS+r5BiX1U8vpSjjfeALN
         ra3ZpUztPPL7rlGDHrYOKTA4M3PQp3VBieitYEXGDmJT9/HbZcEP7j/lpPgqK+JRh+na
         /+lvxKLkxyx9Vx2sZMA6CD/nGwE3W+Jz6h0fCOJ13GjKLjtPL3pUU4p7N5ynJH0Bv3By
         YefyJZN5M6Orm08OWUD3Ynl5YgoyLfP1LYFrFdNXRLB73nOHmGt40F7j1IJe0lhl8FPi
         1QB3Bba/EJ/RMz11Jiv9VhPkb78V+w2flf+5jriDLE5+tl4DrTuqn9dSf/SHM33HMvDg
         zlVQ==
X-Gm-Message-State: AOAM530n/Ihr6dLD2NzSgFqzPxOLuj7TK0z+A63gJj2NimkLzev7K30m
        MoDj1AnXyOugPD2nGJItvVozmKs2htRdvDN6uG3nAhzN/Yuqp8FCQ3lUy7sz14x+Usr1JKtZ1fa
        JJibbDEX1Cp1+XHps
X-Received: by 2002:a1c:de88:: with SMTP id v130mr3484644wmg.98.1597312395152;
        Thu, 13 Aug 2020 02:53:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRDvJhW9rp4jMDxQvLyREEnq1gR4BO6Wlzj2ORYNJP/jP7ec2MZraHxN/G075z1Vk8YS7qVw==
X-Received: by 2002:a1c:de88:: with SMTP id v130mr3484635wmg.98.1597312394951;
        Thu, 13 Aug 2020 02:53:14 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id o125sm8791037wma.27.2020.08.13.02.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2020 02:53:14 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BBF22180493; Thu, 13 Aug 2020 11:53:13 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Denis Gubin <denis.gubin@gmail.com>, netdev@vger.kernel.org
Subject: Re: tc -j filter show with actions is not json valid
In-Reply-To: <CAE_-sd=_2Skp4wY51rerHopU0ZiKPDxQ5Hd0F8qZTOrC7qNYRg@mail.gmail.com>
References: <CAE_-sd=_2Skp4wY51rerHopU0ZiKPDxQ5Hd0F8qZTOrC7qNYRg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 13 Aug 2020 11:53:13 +0200
Message-ID: <87sgcqub1y.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Denis Gubin <denis.gubin@gmail.com> writes:

> Hello everybody!
>
> Could you help me, please?
>
> I use Debian 10 and iproute2 version iproute2
>
> dpkg -l iproute2
> iproute2       4.20.0-2 amd64
>
> My problem is this:
> I can't convert "tc -j filter show u32" command to  json format.
> Here it is command:
> tc qdisc add dev eno1 ingress
> tc filter add dev eno1 parent ffff: protocol all u32 match u8 0 0
> action mirred egress mirror dev lo
>
> Have a look:
>
> ~$ tc -j filter show parent ffff: dev eno1
> [{
>         "protocol": "all",
>         "pref": 49152,
>         "kind": "u32",
>         "chain": 0
>     },{
>         "protocol": "all",
>         "pref": 49152,
>         "kind": "u32",
>         "chain": 0,
>         "options": {fh 800: ht divisor 1 }
>     },{
>         "protocol": "all",
>         "pref": 49152,
>         "kind": "u32",
>         "chain": 0,
>         "options": {fh 800::800 order 2048 key ht 800 bkt 0 terminal
> flowid ??? not_in_hw
>   match 00000000/00000000 at 0
>             "actions": [{
>                     "order": 1,
>                     "kind": "mirred",
>                     "mirred_action": "mirror",
>                     "direction": "egress",
>                     "to_dev": "lo",
>                     "control_action": {
>                         "type": "pipe"
>                     },
>                     "index": 1,
>                     "ref": 1,
>                     "bind": 1
>                 }]
>         }
>     }
> ]
>
>
> May be problem when there is actions in tc filter the problem is... I
> don't know about it.
> Have a look:
>
> "options": {fh 800::800 order 2048 key ht 800 bkt 0 terminal flowid
> ??? not_in_hw
>   match 00000000/00000000 at 0
>     "actions":

Looks like the u32 filter code hasn't been converted to JSON output at
all, yet.

> The json output is not valid.
> Has somebody made a patch for fix it?

Don't think so. But it's a fairly straight-forward thing to go through
f_u32.c and converting all the fprintf() calls to the various
print_XXX() functions if you want to give it a shot - just look at one
of the other files for how to use those functions :)

-Toke

