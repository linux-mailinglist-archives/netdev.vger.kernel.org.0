Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7704A4F04E4
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 18:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358108AbiDBQbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 12:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358098AbiDBQbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 12:31:20 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA906556
        for <netdev@vger.kernel.org>; Sat,  2 Apr 2022 09:29:27 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id v13so4458627qkv.3
        for <netdev@vger.kernel.org>; Sat, 02 Apr 2022 09:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RD/SL3A/PB4aGwlwZcvxfJZV+KuZPOFqFnL5Aicr83A=;
        b=EpjYyPmehIo12xnnLZ4Q6ZXMqEnarR4szn/QCyQ3uDWA6cFGtxBie775H9pvpahSAZ
         qa2bE7oTrxUF0cg/DSrDD6VyCM95/wfbW3cRlPJ2STJ1g2YeWOcQ4v07TXqoqKQiKHep
         abcVkm/IKpiTI+GDn34ZZpzYaBuoiAOSx6wfYhNmCJT+hgZ0qenHL+Tzgq7tjAxLIASc
         Zab5/8rDYsF2wRYXLlKTLlZZUyZfSX7cLV7tUNq8xbbUH2HmPM8MgRWN5qtx1ZWRfi4Y
         pVIZpCicOoINqIKMBwEmRAFdnU/Lk+j40FGbBrXdZkLkr3I4qYCoWGPQxJg6JyZlaO+R
         uacw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RD/SL3A/PB4aGwlwZcvxfJZV+KuZPOFqFnL5Aicr83A=;
        b=5l0k0eCEFPH9dxmT0ujrKt9nA35ezgiG6lnkACdqvVGX0GOGK5hF50k24QFKF4snzm
         t5nL7e88qi1Tt5/K+eBwDwNmb+tnrafq+5APDh6S0ob0MSKaKWUfyX72UXuV/n8DtIl+
         aTT58noZlw1KDnUPaVbZI08uXPGg6ftIyPKlewlO1ign8o1D0q1uU6jOLeCdJzLpZ5Ov
         ouJSgoweSMAWfVJtUOPMJZJ1SgZSge9tsASrkyH6Fd0WxhneJIQZlY0qTu+utKdNAcoX
         nnWxgpfb6Tg7xQogulkBwDhSsJx/li0JkBN9/SmpmXoGbtdPVn3cCTrh5EcDaMbSi+SS
         8ktA==
X-Gm-Message-State: AOAM533cHAUmcdKQToIVRy3u+eBdO1NyouhQKJTCMRV3KfmFu/FbUGUU
        6ijMu8QBlXwkJAir/gRM3020vVjGP1U1y1jfCZ4RhA==
X-Google-Smtp-Source: ABdhPJzfaNIPQ5JupJfh1qHMWDuQu+LB5oF6f/JsYyZHDn0e19hzYZZ8z5sFdmynH60Hi5MGZjjnUJtliSX7AWrDteg=
X-Received: by 2002:a37:bdc4:0:b0:67b:4cce:b058 with SMTP id
 n187-20020a37bdc4000000b0067b4cceb058mr9639516qkf.395.1648916966668; Sat, 02
 Apr 2022 09:29:26 -0700 (PDT)
MIME-Version: 1.0
References: <E1nZMdl-0006nG-0J@plastiekpoot> <CADVnQyn=A9EuTwxe-Bd9qgD24PLQ02YQy0_b7YWZj4_rqhWRVA@mail.gmail.com>
 <eaf54cab-f852-1499-95e2-958af8be7085@uls.co.za> <CANn89iKHbmVYoBdo2pCQWTzB4eFBjqAMdFbqL5EKSFqgg3uAJQ@mail.gmail.com>
 <10c1e561-8f01-784f-c4f4-a7c551de0644@uls.co.za> <CADVnQynf8f7SUtZ8iQi-fACYLpAyLqDKQVYKN-mkEgVtFUTVXQ@mail.gmail.com>
 <e0bc0c7f-5e47-ddb7-8e24-ad5fb750e876@uls.co.za> <CANn89i+Dqtrm-7oW+D6EY+nVPhRH07GXzDXt93WgzxZ1y9_tJA@mail.gmail.com>
 <CADVnQyn=VfcqGgWXO_9h6QTkMn5ZxPbNRTnMFAxwQzKpMRvH3A@mail.gmail.com>
 <5f1bbeb2-efe4-0b10-bc76-37eff30ea905@uls.co.za> <CADVnQymPoyY+AX_P7k+NcRWabJZrb7UCJdDZ=FOkvWguiTPVyQ@mail.gmail.com>
 <CADVnQy=GX0J_QbMJXogGzPwD=f0diKDDxLiHV0gzrb4bo=4FjA@mail.gmail.com> <429dd56b-8a6c-518f-ccb4-fa5beae30953@uls.co.za>
In-Reply-To: <429dd56b-8a6c-518f-ccb4-fa5beae30953@uls.co.za>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Sat, 2 Apr 2022 12:29:10 -0400
Message-ID: <CADVnQynGT7pGBT4PJ=vYg-bj9gnHTsKYHMU_6W0RFZb2FOoxiw@mail.gmail.com>
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP connections
To:     Jaco Kroon <jaco@uls.co.za>
Cc:     Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>,
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

)

On Sat, Apr 2, 2022 at 4:42 AM Jaco Kroon <jaco@uls.co.za> wrote:
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

Thanks for the client kernel version! (5.8.14)

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

Thanks for running that experiment and reporting your data! That was
super-informative. So it seems like we have a working high-level
theory about what's going on and where, and we just need to pinpoint
the buggy lines in the netfilter conntrack code running on the mail
client machines.

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

FWIW those log entries indicate netfilter on the mail client machine
dropping consecutive outbound skbs with 2*MSS of payload. So that
explains the large consecutive losses of client data packets to the
e-mail server. That seems to confirm my earlier hunch that those drops
of consecutive client data packets "do not look like normal congestive
packet loss".

neal
