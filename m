Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E173CCF595
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 11:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730360AbfJHJEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 05:04:08 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54189 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729624AbfJHJEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 05:04:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570525446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7LiTc03LkyuPHndVZx+YUwXgw6EiaRzqV7jwSwvnOpk=;
        b=LQhu5RVT4GRVgVrcEM6ocA9h4YJkPPv+kCIt5+pLksNKJBmwfXaLBRjSPoc0kJcajB4Gkx
        Cld5uC3H+mz2JAc+XklqDz3UCHKGxJq4XY6ykPIIK2evVCX0EfqtT4RxngKawXe5TNlJT5
        l4LhvW0EQTTpCkLD610p+hG21UbXdB0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-c-aObWILPyW5rO4jeMBF2Q-1; Tue, 08 Oct 2019 05:04:03 -0400
Received: by mail-ed1-f69.google.com with SMTP id o92so10776354edb.9
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 02:04:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=7LiTc03LkyuPHndVZx+YUwXgw6EiaRzqV7jwSwvnOpk=;
        b=blNAN/Td0aKU/NDmtD7ucupfaovAuCy8rgBenOo+IdtAEgEwSFju3rsTPMmzwAfTUK
         bJjiMoalEOspLz2JxM0QlnIo3kWnNtn/SLDvYvdXwBSRVmNe9NBdSZiJiG+e7gCUaA4G
         ij6sbGBD7/YVHfAUY6LhqtsSDSX8v78Ul/W4QLSSoktBcdZE3Cqq2gXx0SqNrraHGysn
         2ktrAHKXVb0DLNqK3NR1fPbS6ltped3sxZ62kzV0s6EaphGRctYshH1Zl254ExY3d5hg
         xA28eY4V65brn2Nea0g9xeiCYCfHiC+LHUzyr/gBj7p0DS22kE2GbPwNxnNMoKHd4gXD
         QFuw==
X-Gm-Message-State: APjAAAUeQ3gYc4QTI0Gc26vmaZz04C8jT4DQkqRF7SRsF6bJL1iDHUPC
        CHsmFUCZHMEdE8cv4bCaxzRYpVxXfCFkr+3utt2V3Ja2IbLk5hBUySA+S0neCRDCOJ0X8CccQHN
        PRs4kpOFZACyP6ZCq
X-Received: by 2002:a17:906:4910:: with SMTP id b16mr26878680ejq.301.1570525442111;
        Tue, 08 Oct 2019 02:04:02 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy8TcSRNTMv0iuCzK8zElHlrqwUttIOMympRata1iDWQHbT79yuK/s2FdSOFlHE1wLapUhP4w==
X-Received: by 2002:a17:906:4910:: with SMTP id b16mr26878663ejq.301.1570525441907;
        Tue, 08 Oct 2019 02:04:01 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id l19sm3806147edb.50.2019.10.08.02.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 02:04:01 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B884C18063D; Tue,  8 Oct 2019 11:04:00 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "Karlsson\, Magnus" <magnus.karlsson@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        maciej.fijalkowski@intel.com, tom.herbert@intel.com
Subject: Re: [PATCH bpf-next 2/4] xsk: allow AF_XDP sockets to receive packets directly from a queue
In-Reply-To: <CAJ+HfNhcvRP34L3px6ipAsCiZdvLXG02brecwB=T-sXMaT5yRw@mail.gmail.com>
References: <1570515415-45593-1-git-send-email-sridhar.samudrala@intel.com> <1570515415-45593-3-git-send-email-sridhar.samudrala@intel.com> <875zkzn2pj.fsf@toke.dk> <CAJ+HfNhcvRP34L3px6ipAsCiZdvLXG02brecwB=T-sXMaT5yRw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 08 Oct 2019 11:04:00 +0200
Message-ID: <878spvlibj.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: c-aObWILPyW5rO4jeMBF2Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> On Tue, 8 Oct 2019 at 08:59, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>>
>> Sridhar Samudrala <sridhar.samudrala@intel.com> writes:
>>
>> >  int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
>> >                   struct bpf_prog *xdp_prog)
>> >  {
>> >       struct bpf_redirect_info *ri =3D this_cpu_ptr(&bpf_redirect_info=
);
>> >       struct bpf_map *map =3D READ_ONCE(ri->map);
>> > +     struct xdp_sock *xsk;
>> > +
>> > +     xsk =3D xdp_get_direct_xsk(ri);
>> > +     if (xsk)
>> > +             return xsk_rcv(xsk, xdp);
>>
>> This is a new branch and a read barrier in the XDP_REDIRECT fast path.
>> What's the performance impact of that for non-XSK redirect?
>>
>
> The dependent-read-barrier in READ_ONCE? Another branch -- leave that
> to the branch-predictor already! ;-) No, you're right, performance
> impact here is interesting. I guess the same static_branch could be
> used here as well...

In any case, some measurements to see the impact (or lack thereof) would
be useful :)

-Toke

