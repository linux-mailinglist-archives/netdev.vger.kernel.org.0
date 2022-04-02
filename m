Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE844F0215
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 15:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350405AbiDBNZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 09:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355498AbiDBNWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 09:22:53 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5EF251599
        for <netdev@vger.kernel.org>; Sat,  2 Apr 2022 06:21:01 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id z33so5191133ybh.5
        for <netdev@vger.kernel.org>; Sat, 02 Apr 2022 06:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+pryMgvedYxgy8GBeOlmXDihk4D2QfhvARnToMn1fc4=;
        b=YYYxKyvT22y+Chcbmr1N8qXLf+UaEKi0UI9eiJreOkQLS019qnKjBBjSm9Lm3Z2JSt
         vfSZ3Gfex345jqMXBSoYLWrMzxrfl79ycIxGWA3oJf6m1MkKwbouVE7EPOAVLX9WbLCk
         AK5iLw3UOtEgcQcqiTBSP2FqS5DfTauInkVwyRvXht/GYrrUghsGqcSZgnqB5CshswxI
         3EjXZQJP+Gi0hAHEvZmJ5YZXnZ9tMdb8PSDa9J/EBTaM1oBHMKffr2cWcN6aoAoXU9fM
         zYluCFUzQGQ5l+mpZIEEjH7Dqlaa8L7r18QhbqEpmj3aPNTM5oqD3U8xaaceI4zKLrW/
         5jkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+pryMgvedYxgy8GBeOlmXDihk4D2QfhvARnToMn1fc4=;
        b=17dKtj6cUxU43bEayjlcmQCyNiEc152/ySPlJ0T6ujrjalSfSGQhAjX84IoArZhmwa
         EOEMF7csczeoaa6v/5hs1IQeZLv1aaYQnEFjUY2Gn4iwxb5Oc0k6KKTNaEya66qWL2Sa
         iPI3YYvyEuqbPuAq/o5daEg9s1Kz1ad/Fy88CxIa3m8Q2wTHuzO5MaO/u9xdnYkunO57
         6dmwcS1AS4DJINVT2a7mStBjBuxO/SLsTeRpo6N1JQC5bJaSPbTKfCp/8U3IZ6gECOqY
         JPLULgxSqptTDfjfgu6DPiP4KeukT0MqivcPStuoHSMFsjtiNL56iMcOh6Uvgv9K32+i
         VDgA==
X-Gm-Message-State: AOAM5332wSUbtGrNXHiCtzd9UV5FfFLlrzkd4D+cG/iXqokqk+4ecq4g
        FySJirybGG/HLbMzutQaYMmMabIlAsvp3urLy2FquQ==
X-Google-Smtp-Source: ABdhPJw4p/xmrTV8rn1WIatgiSN/dnGYijnkrqNgutdl39P8w6bOTPRkFlhgnyJM3efu3QXAhQifJGtkhFOOsczYtnw=
X-Received: by 2002:a25:8382:0:b0:63d:6201:fa73 with SMTP id
 t2-20020a258382000000b0063d6201fa73mr6901867ybk.55.1648905660742; Sat, 02 Apr
 2022 06:21:00 -0700 (PDT)
MIME-Version: 1.0
References: <E1nZMdl-0006nG-0J@plastiekpoot> <CADVnQyn=A9EuTwxe-Bd9qgD24PLQ02YQy0_b7YWZj4_rqhWRVA@mail.gmail.com>
 <eaf54cab-f852-1499-95e2-958af8be7085@uls.co.za> <CANn89iKHbmVYoBdo2pCQWTzB4eFBjqAMdFbqL5EKSFqgg3uAJQ@mail.gmail.com>
 <10c1e561-8f01-784f-c4f4-a7c551de0644@uls.co.za> <CADVnQynf8f7SUtZ8iQi-fACYLpAyLqDKQVYKN-mkEgVtFUTVXQ@mail.gmail.com>
 <e0bc0c7f-5e47-ddb7-8e24-ad5fb750e876@uls.co.za> <CANn89i+Dqtrm-7oW+D6EY+nVPhRH07GXzDXt93WgzxZ1y9_tJA@mail.gmail.com>
 <CADVnQyn=VfcqGgWXO_9h6QTkMn5ZxPbNRTnMFAxwQzKpMRvH3A@mail.gmail.com>
 <5f1bbeb2-efe4-0b10-bc76-37eff30ea905@uls.co.za> <CADVnQymPoyY+AX_P7k+NcRWabJZrb7UCJdDZ=FOkvWguiTPVyQ@mail.gmail.com>
 <CADVnQy=GX0J_QbMJXogGzPwD=f0diKDDxLiHV0gzrb4bo=4FjA@mail.gmail.com> <429dd56b-8a6c-518f-ccb4-fa5beae30953@uls.co.za>
In-Reply-To: <429dd56b-8a6c-518f-ccb4-fa5beae30953@uls.co.za>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 2 Apr 2022 06:20:49 -0700
Message-ID: <CANn89iKSFXBx9zYuBFH4-uS3UzAUW+fY7d5aiUkfOa1DdbHDxQ@mail.gmail.com>
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP connections
To:     Jaco Kroon <jaco@uls.co.za>
Cc:     Neal Cardwell <ncardwell@google.com>,
        Florian Westphal <fw@strlen.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Wei Wang <weiwan@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sven Auhagen <sven.auhagen@voleatech.de>
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

On Sat, Apr 2, 2022 at 1:42 AM Jaco Kroon <jaco@uls.co.za> wrote:
>
> Hi Neal,
>
> On 2022/04/01 17:39, Neal Cardwell wrote:
> > On Tue, Mar 29, 2022 at 9:03 PM Jaco <jaco@uls.co.za> wrote:
> > ...
> >> Connection setup:
> >>
> >> 00:56:17.055481 IP6 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.59110 > 2a00:145=
0:400c:c07::1b.25: Flags [S], seq 956633779, win 62580, options [mss 8940,n=
op,nop,TS val 3687705482 ecr 0,nop,wscale 7,tfo  cookie f025dd84b6122510,no=
p,nop], length 0
> >>
> >> 00:56:17.217747 IP6 2a00:1450:400c:c07::1b.25 > 2c0f:f720:0:3:d6ae:52f=
f:feb8:f27b.59110: Flags [S.], seq 726465675, ack 956633780, win 65535, opt=
ions [mss 1440,nop,nop,TS val 3477429218 ecr 3687705482,nop,wscale 8], leng=
th 0
> >>
> >> 00:56:17.218628 IP6 2a00:1450:400c:c07::1b.25 > 2c0f:f720:0:3:d6ae:52f=
f:feb8:f27b.59110: Flags [P.], seq 726465676:726465760, ack 956633780, win =
256, options [nop,nop,TS val 3477429220 ecr 3687705482], length 84: SMTP: 2=
20 mx.google.com ESMTP e16-20020a05600c4e5000b0038c77be9b2dsi226281wmq.72 -=
 gsmtp
> >>
> >> 00:56:17.218663 IP6 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.59110 > 2a00:145=
0:400c:c07::1b.25: Flags [.], ack 726465760, win 489, options [nop,nop,TS v=
al 3687705645 ecr 3477429220], length 0
> >>
> >> This is pretty normal, we advertise an MSS of 8940 and the return is 1=
440, thus
> >> we shouldn't send segments larger than that, and they "can't".  I need=
 to
> >> determine if this is some form of offloading or they really are sendin=
g >1500
> >> byte frames (which I know won't pass our firewalls without fragmentati=
on so
> >> probably some form of NIC offloading - which if it was active on older=
 5.8
> >> kernels did not cause problems):
> > Jaco, was there some previous kernel version on these client machines
> > where this problem did not show up? Perhaps the v5.8 version you
> > mention here? Can you please share the exact version number?
> 5.8.14
> >
> > If so, a hypothesis would be:
> >
> > (1) There is a bug in netfilter's handling of TFO connections where
> > the server sends a data packet after a TFO SYNACK, before the client
> > ACKs anything (as we see in this trace).
> >
> > This bug is perhaps similar in character to the bug fixed by Yuchung's
> > 2013 commit that Eric mentioned:
> >
> > 356d7d88e088687b6578ca64601b0a2c9d145296
> > netfilter: nf_conntrack: fix tcp_in_window for Fast Open
> >
> > (2) With kernel v5.8, TFO blackhole detection detected that in your
> > workload there were TFO connections that died due to apparent
> > blackholing (like what's shown in the trace), and dynamically disabled
> > TFO on your machines. This allowed mail traffic to flow, because the
> > netfilter bug was no longer tickled. This worked around the netfilter
> > bug.
> >
> > (3) You upgraded your client-side machine from v5.8 to v5.17, which
> > has the following commit from v5.14, which disables TFO blackhole
> > logic by default:
> >   213ad73d0607 tcp: disable TFO blackhole logic by default
> >
> > (4) Due to (3), the blackhole detection logic was no longer operative,
> > and when the netfilter bug blackholed the connection, TFO stayed
> > enabled. This caused mail traffic to Google to stall.
> >
> > This hypothesis would explain why:
> >   o disabling TFO fixes this problem
> >   o you are seeing this with a newer kernel (and apparently not with a
> > kernel before v5.14?)
> Agreed.
> >
> > With this hypothesis, we need several pieces to trigger this:
> >
> > (a) client side software that tries TFO to a server that supports TFO
> > (like the exim mail transfer agent you are using, connecting to
> > Google)
> >
> > (b) a client-side Linux kernel running buggy netfilter code (you are
> > running netfilter)
> >
> > (c) a client-side Linux kernel with TFO support but no blackhole
> > detection logic active (e.g. v5.14 or later, like your v5.17.1)
> >
> > That's probably a rare combination, so would explain why we have not
> > had this report before.
> >
> > Jaco, to provide some evidence for this hypothesis, can you please
> > re-enable fastopen but also enable the TFO blackhole detection that
> > was disabled in v5.14 (213ad73d0607), with something like:
> >
> >   sysctl -w net.ipv4.tcp_fastopen=3D1
> >   sysctl -w tcp_fastopen_blackhole_timeout=3D3600
>
> Done.
>
> Including sysctl net.netfilter.nf_conntrack_log_invalid=3D6- which
> generates lots of logs, something specific I should be looking for?  I
> suspect these relate:
>
> [Sat Apr  2 10:31:53 2022] nf_ct_proto_6: SEQ is over the upper bound
> (over the window of the receiver) IN=3D OUT=3Dbond0
> SRC=3D2c0f:f720:0000:0003:d6ae:52ff:feb8:f27b
> DST=3D2a00:1450:400c:0c08:0000:0000:0000:001a LEN=3D2928 TC=3D0 HOPLIMIT=
=3D64
> FLOWLBL=3D867133 PROTO=3DTCP SPT=3D48920 DPT=3D25 SEQ=3D2689938314 ACK=3D=
4200412020
> WINDOW=3D447 RES=3D0x00 ACK PSH URGP=3D0 OPT (0101080A2F36C1C120EDFB91) U=
ID=3D8
> GID=3D12
> [Sat Apr  2 10:31:53 2022] nf_ct_proto_6: SEQ is over the upper bound
> (over the window of the receiver) IN=3D OUT=3Dbond0
> SRC=3D2c0f:f720:0000:0003:d6ae:52ff:feb8:f27b
> DST=3D2a00:1450:400c:0c08:0000:0000:0000:001a LEN=3D2928 TC=3D0 HOPLIMIT=
=3D64
> FLOWLBL=3D867133 PROTO=3DTCP SPT=3D48920 DPT=3D25 SEQ=3D2689941170 ACK=3D=
4200412020
> WINDOW=3D447 RES=3D0x00 ACK PSH URGP=3D0 OPT (0101080A2F36C1C120EDFB91) U=
ID=3D8
> GID=3D12
>
> (There are many more of those, and the remote side is Google in this case=
)
>

Great. This confirms our suspicions.

Please try the following patch that landed in 5.18-rc

f2dd495a8d589371289981d5ed33e6873df94ecc netfilter: nf_conntrack_tcp:
preserve liberal flag in tcp options

CC netfilter folks.

Condition triggering the bug :
   before(seq, sender->td_maxend + 1),

I took a look at the code, and it is not clear if td_maxend is
properly setup (or if td_scale is cleared at some point while it
should not)

Alternatively, if conntracking does not know if the connection is
using wscale (or what is the scale), the "before(seq,
sender->td_maxend + 1),"
should not be evaluated/used.

Also, I do not see where td_maxend is extended in tcp_init_sender()

Probably wrong patch, just to point to the code I do not understand yet.

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c
b/net/netfilter/nf_conntrack_proto_tcp.c
index 8ec55cd72572e0cca076631e2cc1c11f0c2b86f6..950082785d61b7a2768559c7500=
d3aee3aaea7c2
100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -456,9 +456,10 @@ static void tcp_init_sender(struct ip_ct_tcp_state *se=
nder,
        /* SYN-ACK in reply to a SYN
         * or SYN from reply direction in simultaneous open.
         */
-       sender->td_end =3D
-       sender->td_maxend =3D end;
-       sender->td_maxwin =3D (win =3D=3D 0 ? 1 : win);
+       sender->td_end =3D end;
+       sender->td_maxwin =3D max(win, 1U);
+       /* WIN in SYN & SYNACK is not scaled */
+       sender->td_maxend =3D end + sender->td_maxwin;

        tcp_options(skb, dataoff, tcph, sender);
        /* RFC 1323:
