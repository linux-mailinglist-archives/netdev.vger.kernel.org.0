Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2C64EF79E
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 18:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348944AbiDAQP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 12:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350424AbiDAQNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 12:13:54 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE886CD302
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 08:39:41 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id 10so2439138qtz.11
        for <netdev@vger.kernel.org>; Fri, 01 Apr 2022 08:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NStYi8rXtYWop4V2MnxgWp7QtmI7tN/4ns3xchJYyfU=;
        b=RcBEDEhwGNG4pz2bKGcoUjhgTPL//Nw9SMozlKIJc/XyK5WeU3Z51Nq9I6OP26Qego
         NZCnXhVVX0/YyfUzn51W4PEJVv9q+AWibLf4tNKLhoRnytOvEeL67wZA0WTNC58XbncV
         rN5RfSRPM7HXo31kmDUNKIW48ke86Nc6RlBpatVt2QpyHllYeIRubzqOhP01RSyFeJTv
         63toCKRjluEIi2Ud+b3w19ZNRaYRwhS0j4Kvym9j1GLh3X7v5squ5E9kC17IF3iC1t6Q
         xGzYu8R9+oKaCVw+geZf/roX+EFERpJpHQ3Ok5K8/7qADlsejiKMbNh7EPMQf4vOGXuS
         OsfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NStYi8rXtYWop4V2MnxgWp7QtmI7tN/4ns3xchJYyfU=;
        b=EfJCVHYS/jLrZapqvqY+JGwqihyrCgRjY4InVHMdJby//tJMgnlfXaOvNSbkmEJFvZ
         tbm3Jfw1d4K6+EC0bmhPIaVyLSL9n5nyjMI6ts3Lx0c6f19i/pYZgWm0OnvbkxQ0IGc4
         Dg0x32CKTEg+uDhjkg7KMzD157ycw5NKPd+V+VbnQq/DV38EYCx9UjwniFS8e3NjC0o2
         7u4MqGXTeNtj+Hpbza32noadrkoKawgDHVoNYuzSMQ5jPUmXwv5zdLPbIqNYxjXkUlGu
         q3Ao3UzAaNlUGOVwRWj1CDtqH7RS25E1U2jGJ6i2MSxVTnEHk3Hz/+lLII53RIGAXVym
         OMrQ==
X-Gm-Message-State: AOAM531QCdmqRGoOM8igxEjPtOeTqkCDO5wDwSoHu8cgElCTkR7B3XhO
        KPLwcOKfSlHij+3n42JJfFp/2eHYof4JrVPp6U8mOA==
X-Google-Smtp-Source: ABdhPJwQDqagA7/Uue9NFuWCMhrm/bBHXbtSwxNv7+uqSSiCMCYxX/856COy5CwMZFSp16jLb6Y8mXhI8vhvcRppTkU=
X-Received: by 2002:ac8:7f0d:0:b0:2e1:e894:9f16 with SMTP id
 f13-20020ac87f0d000000b002e1e8949f16mr8818981qtk.183.1648827580616; Fri, 01
 Apr 2022 08:39:40 -0700 (PDT)
MIME-Version: 1.0
References: <E1nZMdl-0006nG-0J@plastiekpoot> <CADVnQyn=A9EuTwxe-Bd9qgD24PLQ02YQy0_b7YWZj4_rqhWRVA@mail.gmail.com>
 <eaf54cab-f852-1499-95e2-958af8be7085@uls.co.za> <CANn89iKHbmVYoBdo2pCQWTzB4eFBjqAMdFbqL5EKSFqgg3uAJQ@mail.gmail.com>
 <10c1e561-8f01-784f-c4f4-a7c551de0644@uls.co.za> <CADVnQynf8f7SUtZ8iQi-fACYLpAyLqDKQVYKN-mkEgVtFUTVXQ@mail.gmail.com>
 <e0bc0c7f-5e47-ddb7-8e24-ad5fb750e876@uls.co.za> <CANn89i+Dqtrm-7oW+D6EY+nVPhRH07GXzDXt93WgzxZ1y9_tJA@mail.gmail.com>
 <CADVnQyn=VfcqGgWXO_9h6QTkMn5ZxPbNRTnMFAxwQzKpMRvH3A@mail.gmail.com>
 <5f1bbeb2-efe4-0b10-bc76-37eff30ea905@uls.co.za> <CADVnQymPoyY+AX_P7k+NcRWabJZrb7UCJdDZ=FOkvWguiTPVyQ@mail.gmail.com>
In-Reply-To: <CADVnQymPoyY+AX_P7k+NcRWabJZrb7UCJdDZ=FOkvWguiTPVyQ@mail.gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 1 Apr 2022 11:39:24 -0400
Message-ID: <CADVnQy=GX0J_QbMJXogGzPwD=f0diKDDxLiHV0gzrb4bo=4FjA@mail.gmail.com>
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP connections
To:     Jaco Kroon <jaco@uls.co.za>
Cc:     Eric Dumazet <edumazet@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 29, 2022 at 9:03 PM Jaco <jaco@uls.co.za> wrote:
...
> Connection setup:
>
> 00:56:17.055481 IP6 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.59110 > 2a00:1450:4=
00c:c07::1b.25: Flags [S], seq 956633779, win 62580, options [mss 8940,nop,=
nop,TS val 3687705482 ecr 0,nop,wscale 7,tfo  cookie f025dd84b6122510,nop,n=
op], length 0
>
> 00:56:17.217747 IP6 2a00:1450:400c:c07::1b.25 > 2c0f:f720:0:3:d6ae:52ff:f=
eb8:f27b.59110: Flags [S.], seq 726465675, ack 956633780, win 65535, option=
s [mss 1440,nop,nop,TS val 3477429218 ecr 3687705482,nop,wscale 8], length =
0
>
> 00:56:17.218628 IP6 2a00:1450:400c:c07::1b.25 > 2c0f:f720:0:3:d6ae:52ff:f=
eb8:f27b.59110: Flags [P.], seq 726465676:726465760, ack 956633780, win 256=
, options [nop,nop,TS val 3477429220 ecr 3687705482], length 84: SMTP: 220 =
mx.google.com ESMTP e16-20020a05600c4e5000b0038c77be9b2dsi226281wmq.72 - gs=
mtp
>
> 00:56:17.218663 IP6 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.59110 > 2a00:1450:4=
00c:c07::1b.25: Flags [.], ack 726465760, win 489, options [nop,nop,TS val =
3687705645 ecr 3477429220], length 0
>
> This is pretty normal, we advertise an MSS of 8940 and the return is 1440=
, thus
> we shouldn't send segments larger than that, and they "can't".  I need to
> determine if this is some form of offloading or they really are sending >=
1500
> byte frames (which I know won't pass our firewalls without fragmentation =
so
> probably some form of NIC offloading - which if it was active on older 5.=
8
> kernels did not cause problems):

Jaco, was there some previous kernel version on these client machines
where this problem did not show up? Perhaps the v5.8 version you
mention here? Can you please share the exact version number?

If so, a hypothesis would be:

(1) There is a bug in netfilter's handling of TFO connections where
the server sends a data packet after a TFO SYNACK, before the client
ACKs anything (as we see in this trace).

This bug is perhaps similar in character to the bug fixed by Yuchung's
2013 commit that Eric mentioned:

356d7d88e088687b6578ca64601b0a2c9d145296
netfilter: nf_conntrack: fix tcp_in_window for Fast Open

(2) With kernel v5.8, TFO blackhole detection detected that in your
workload there were TFO connections that died due to apparent
blackholing (like what's shown in the trace), and dynamically disabled
TFO on your machines. This allowed mail traffic to flow, because the
netfilter bug was no longer tickled. This worked around the netfilter
bug.

(3) You upgraded your client-side machine from v5.8 to v5.17, which
has the following commit from v5.14, which disables TFO blackhole
logic by default:
  213ad73d0607 tcp: disable TFO blackhole logic by default

(4) Due to (3), the blackhole detection logic was no longer operative,
and when the netfilter bug blackholed the connection, TFO stayed
enabled. This caused mail traffic to Google to stall.

This hypothesis would explain why:
  o disabling TFO fixes this problem
  o you are seeing this with a newer kernel (and apparently not with a
kernel before v5.14?)

With this hypothesis, we need several pieces to trigger this:

(a) client side software that tries TFO to a server that supports TFO
(like the exim mail transfer agent you are using, connecting to
Google)

(b) a client-side Linux kernel running buggy netfilter code (you are
running netfilter)

(c) a client-side Linux kernel with TFO support but no blackhole
detection logic active (e.g. v5.14 or later, like your v5.17.1)

That's probably a rare combination, so would explain why we have not
had this report before.

Jaco, to provide some evidence for this hypothesis, can you please
re-enable fastopen but also enable the TFO blackhole detection that
was disabled in v5.14 (213ad73d0607), with something like:

  sysctl -w net.ipv4.tcp_fastopen=3D1
  sysctl -w tcp_fastopen_blackhole_timeout=3D3600

And then after a few hours, check to see if this blackholing behavior
has been detected:
  nstat -az | grep -i blackhole
And see if TFO FastOpenActive attempts have been cut to a super-low rate:
  nstat -az | grep -i fastopenactive

thanks,
neal
