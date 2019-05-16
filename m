Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74C1C20B71
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 17:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbfEPPnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 11:43:32 -0400
Received: from mail-qk1-f179.google.com ([209.85.222.179]:42963 "EHLO
        mail-qk1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbfEPPnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 11:43:32 -0400
Received: by mail-qk1-f179.google.com with SMTP id d4so2526194qkc.9
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 08:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appleguru.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0l9tyIAogy+/HMtSV9NAQokN7JczuqC+PbKxWHbvQfM=;
        b=XrgK6CnShL5SfPbxvyjZeUC9baSTzX1y7O49O1KO1SU0Hhx6TX+lTvKdQt77QRu+8a
         ShBW6GZnDbss0gafiPPK5JYmtm6DOGjJZfbCm1ijgVlr6Op8iYCSy7Iz/W2oaHBFkjjz
         t649eCtu24elh9pHU2O6Ayf5tdx/gNXB9oniw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0l9tyIAogy+/HMtSV9NAQokN7JczuqC+PbKxWHbvQfM=;
        b=UMFUrRxYaVRtDBquwNsXKrQOBFz5ABI+XSIkWeNhn6/W0HeoArk2w5ZnFxmGbQEry4
         QAxGWSb7RBGJfRfu0+GI82Lw4mageA8RTBzGEV4qSI7vRJwk16sMPmgwURf3wA7zQF4u
         OVHdZEvSvyRZHcGKMmWs7EoApU3niDZG21l1fU0TGOcyPFqrfGxSHYF/4/JIE9YeOPLM
         /QYnBRgrxXOFuRONC3hrXzsW/64xZHj8N8U0Pz9v2Xze0pYm9pLsdpjwL9sxJQHZHgWh
         t1bfGwwsJ4tSBlQ+f4/J6hWePFjGTcmfEiJAOpzmy4wVzezuPNt0Z4oC2/5rmye9hLa4
         UPLg==
X-Gm-Message-State: APjAAAULhL+f/1P4joUB8JaCXVdq1/mF5+WlZMdjNKlnVnktaP9THAoa
        5V8VsAMLQv6vjXmDHWEEcjDTbgPv5uGWFg==
X-Google-Smtp-Source: APXvYqyS/AUuKeIEOuea5U/z2vv4Pzy49O3VlKrG3GtmENFk4kqPj2hfKaLPBl8OLGrn3BCLRj+d/g==
X-Received: by 2002:a37:7986:: with SMTP id u128mr41132701qkc.45.1558021410916;
        Thu, 16 May 2019 08:43:30 -0700 (PDT)
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com. [209.85.160.182])
        by smtp.gmail.com with ESMTPSA id r1sm2569336qtp.77.2019.05.16.08.43.30
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 08:43:30 -0700 (PDT)
Received: by mail-qt1-f182.google.com with SMTP id d13so4441583qth.5
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 08:43:30 -0700 (PDT)
X-Received: by 2002:ac8:2cbc:: with SMTP id 57mr20409513qtw.222.1558021410160;
 Thu, 16 May 2019 08:43:30 -0700 (PDT)
MIME-Version: 1.0
References: <CABUuw65R3or9HeHsMT_isVx1f-7B6eCPPdr+bNR6f6wbKPnHOQ@mail.gmail.com>
 <CAF=yD-Kdb4UrgzOJmeEhiqmeKndb9-X5WwttR-X4xd5m7DE5Dw@mail.gmail.com>
In-Reply-To: <CAF=yD-Kdb4UrgzOJmeEhiqmeKndb9-X5WwttR-X4xd5m7DE5Dw@mail.gmail.com>
From:   Adam Urban <adam.urban@appleguru.org>
Date:   Thu, 16 May 2019 11:43:19 -0400
X-Gmail-Original-Message-ID: <CABUuw64qLQM7L1ZPoxxC0bO7VOh0Ppqh89Hz3Q6+BhKtP4s-fQ@mail.gmail.com>
Message-ID: <CABUuw64qLQM7L1ZPoxxC0bO7VOh0Ppqh89Hz3Q6+BhKtP4s-fQ@mail.gmail.com>
Subject: Re: Kernel UDP behavior with missing destinations
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

/proc/net/stat/ndisc_cache show unresolved_discards appears to show 0
unresolved_discards:

entries,allocs,destroys,hash_grows,lookups,hits,res_failed,rcv_probes_mcast,rcv_probes_ucast,periodic_gc_runs,forced_gc_runs,unresolved_discards,table_fulls
00000005,00000005,00000000,00000000,00000000,00000000,00000000,00000000,00000000,000021af,00000000,00000000,00000000
00000005,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000


On Thu, May 16, 2019 at 10:48 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Wed, May 15, 2019 at 3:57 PM Adam Urban <adam.urban@appleguru.org> wrote:
> >
> > We have an application where we are use sendmsg() to send (lots of)
> > UDP packets to multiple destinations over a single socket, repeatedly,
> > and at a pretty constant rate using IPv4.
> >
> > In some cases, some of these destinations are no longer present on the
> > network, but we continue sending data to them anyways. The missing
> > devices are usually a temporary situation, but can last for
> > days/weeks/months.
> >
> > We are seeing an issue where packets sent even to destinations that
> > are present on the network are getting dropped while the kernel
> > performs arp updates.
> >
> > We see a -1 EAGAIN (Resource temporarily unavailable) return value
> > from the sendmsg() call when this is happening:
> >
> > sendmsg(72, {msg_name(16)={sa_family=AF_INET, sin_port=htons(1234),
> > sin_addr=inet_addr("10.1.2.3")}, msg_iov(1)=[{"\4\1"..., 96}],
> > msg_controllen=0, msg_flags=0}, MSG_NOSIGNAL) = -1 EAGAIN (Resource
> > temporarily unavailable)
> >
> > Looking at packet captures, during this time you see the kernel arping
> > for the devices that aren't on the network, timing out, arping again,
> > timing out, and then finally arping a 3rd time before setting the
> > INCOMPLETE state again (very briefly being in a FAILED state).
> >
> > "Good" packets don't start going out again until the 3rd timeout
> > happens, and then they go out for about 1s until the 3s delay from ARP
> > happens again.
> >
> > Interestingly, this isn't an all or nothing situation. With only a few
> > (2-3) devices missing, we don't run into this "blocking" situation and
> > data always goes out. But once 4 or more devices are missing, it
> > happens. Setting static ARP entries for the missing supplies, even if
> > they are bogus, resolves the issue, but of course results in packets
> > with a bogus destination going out on the wire instead of getting
> > dropped by the kernel.
> >
> > Can anyone explain why this is happening? I have tried tuning the
> > unres_qlen sysctl without effect and will next try to set the
> > MSG_DONTWAIT socket option to try and see if that helps. But I want to
> > make sure I understand what is going on.
> >
> > Are there any parameters we can tune so that UDP packets sent to
> > INCOMPLETE destinations are immediately dropped? What's the best way
> > to prevent a socket from being unavailable while arp operations are
> > happening (assuming arp is the cause)?
>
> Sounds like hitting SO_SNDBUF limit due to datagrams being held on the
> neighbor queue. Especially since the issue occurs only as the number
> of unreachable destinations exceeds some threshold. Does
> /proc/net/stat/ndisc_cache show unresolved_discards? Increasing
> unres_qlen may make matters only worse if more datagrams can get
> queued. See also the branch on NUD_INCOMPLETE in __neigh_event_send.
