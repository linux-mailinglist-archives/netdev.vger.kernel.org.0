Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D910A4F0555
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 20:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238748AbiDBSGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 14:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231703AbiDBSGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 14:06:22 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0363FFA
        for <netdev@vger.kernel.org>; Sat,  2 Apr 2022 11:04:25 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id b189so4536638qkf.11
        for <netdev@vger.kernel.org>; Sat, 02 Apr 2022 11:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C8/TSHx2WIRZ4mg+7W1FRBHfUQ9TPY5mCHEMry5F6Oo=;
        b=STG9gBRSziyPzGSlvVuVU1RLRV5O6nMSwYsfGL1kHXqs+OVkpUsnLx3GDZ1/x7G+ml
         7xG6xfInwz1zfBM0RfinPkCXcN/WKDMCN48Zip+qn2An3DKtUX8UcuSUH47ZRI53++12
         Eh0n3+6xVKgPoybXNPJ4xdR8BwCfulthmGk6feDgVrwqdI1EAtYO2FRiJ146l8Naf2n1
         0QuhafZlOPtwEoQRApcPQt7SQ5sUH/7rlJPh4eYUNwBCTklAUnzCXIUkTKW7Yyx6XaHI
         uXhcB5o/EYDQAirMzCMuhBURUVdbQI/wVqUVva3xqvkxUKegnwUtKZxFIbtjBPjqjBYU
         i4+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C8/TSHx2WIRZ4mg+7W1FRBHfUQ9TPY5mCHEMry5F6Oo=;
        b=rZlibAOGMCWW+luxEen9UV6TWkk4j3tV3tMkboq8AXpFIuzm/BEBxYXBYwvyMqW7Hh
         exYmGCatxbaS8P1kXV73J/hQN+hnKkwtpM7Oz4QSVDCcHlNKBEoXk85xWV+NW3u+gKkQ
         M03dUPRwwgW89crfTcRz6tsnbEkM9F3ukJhViBhRygnMASnHx6eHXlwXpfgR5iPOPoJH
         uhybCAk+Twl8+ZTukBOlPu2Au1GmcdyIqVoeZxDcsQdt22s7ZDB94DcYk5/G3pzqb1pW
         kq+3EqKTt3YTznGmGs8hYEJOXUhC5gfH0rswptHhxpXqOPJATmZfCjhOU6XvNWDzrhVr
         iAFw==
X-Gm-Message-State: AOAM530Wu9wQ92Y41zvQNb6Kgc1nffVFwjkw51DvMCysiixTWNrkx88p
        ahjHvj/Ej22JBLIC6BFAtr65oOehI2XyMwk8n1r9bA==
X-Google-Smtp-Source: ABdhPJxOj/IsytEQpuni6qOJbl0uUQTwdj5v1Vjg6QYzfoysQpo8pzEr8yCEJ/n0mvvXWcrpHiL12+AkGi5nlV0HDkQ=
X-Received: by 2002:a05:620a:1424:b0:67d:2bc6:856b with SMTP id
 k4-20020a05620a142400b0067d2bc6856bmr10190075qkj.434.1648922664855; Sat, 02
 Apr 2022 11:04:24 -0700 (PDT)
MIME-Version: 1.0
References: <E1nZMdl-0006nG-0J@plastiekpoot> <CADVnQyn=A9EuTwxe-Bd9qgD24PLQ02YQy0_b7YWZj4_rqhWRVA@mail.gmail.com>
 <eaf54cab-f852-1499-95e2-958af8be7085@uls.co.za> <CANn89iKHbmVYoBdo2pCQWTzB4eFBjqAMdFbqL5EKSFqgg3uAJQ@mail.gmail.com>
 <10c1e561-8f01-784f-c4f4-a7c551de0644@uls.co.za> <CADVnQynf8f7SUtZ8iQi-fACYLpAyLqDKQVYKN-mkEgVtFUTVXQ@mail.gmail.com>
 <e0bc0c7f-5e47-ddb7-8e24-ad5fb750e876@uls.co.za> <CANn89i+Dqtrm-7oW+D6EY+nVPhRH07GXzDXt93WgzxZ1y9_tJA@mail.gmail.com>
 <CADVnQyn=VfcqGgWXO_9h6QTkMn5ZxPbNRTnMFAxwQzKpMRvH3A@mail.gmail.com>
 <5f1bbeb2-efe4-0b10-bc76-37eff30ea905@uls.co.za> <CADVnQymPoyY+AX_P7k+NcRWabJZrb7UCJdDZ=FOkvWguiTPVyQ@mail.gmail.com>
 <CADVnQy=GX0J_QbMJXogGzPwD=f0diKDDxLiHV0gzrb4bo=4FjA@mail.gmail.com>
 <429dd56b-8a6c-518f-ccb4-fa5beae30953@uls.co.za> <CADVnQynGT7pGBT4PJ=vYg-bj9gnHTsKYHMU_6W0RFZb2FOoxiw@mail.gmail.com>
 <CANn89iJqKmjvJGtRHVumfP0T_SSa1uioFLgUvW+MF2ov2Ec2vQ@mail.gmail.com>
In-Reply-To: <CANn89iJqKmjvJGtRHVumfP0T_SSa1uioFLgUvW+MF2ov2Ec2vQ@mail.gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Sat, 2 Apr 2022 14:04:08 -0400
Message-ID: <CADVnQykexgJ+NEUojiKrt=HTomF0nL8CncF401+mEFkvuge7Rg@mail.gmail.com>
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP connections
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jaco Kroon <jaco@uls.co.za>, Florian Westphal <fw@strlen.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
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

On Sat, Apr 2, 2022 at 12:32 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Sat, Apr 2, 2022 at 9:29 AM Neal Cardwell <ncardwell@google.com> wrote:
> >
> > FWIW those log entries indicate netfilter on the mail client machine
> > dropping consecutive outbound skbs with 2*MSS of payload. So that
> > explains the large consecutive losses of client data packets to the
> > e-mail server. That seems to confirm my earlier hunch that those drops
> > of consecutive client data packets "do not look like normal congestive
> > packet loss".
>
>
> This also explains why we have all these tiny 2-MSS packets in the pcap.
>
> Under normal conditions, autocorking should kick in, allowing TCP to
> build bigger TSO packets.

I have not looked at the conntrack code before today, but AFAICT this
is the buggy section of  nf_conntrack_proto_tcp.c:

        } else if (((state->state == TCP_CONNTRACK_SYN_SENT
                     && dir == IP_CT_DIR_ORIGINAL)
                   || (state->state == TCP_CONNTRACK_SYN_RECV
                     && dir == IP_CT_DIR_REPLY))
                   && after(end, sender->td_end)) {
                /*
                 * RFC 793: "if a TCP is reinitialized ... then it need
                 * not wait at all; it must only be sure to use sequence
                 * numbers larger than those recently used."
                 */
                sender->td_end =
                sender->td_maxend = end;
                sender->td_maxwin = (win == 0 ? 1 : win);

                tcp_options(skb, dataoff, tcph, sender);

Note that the tcp_options() function implicitly assumes it is being
called on a SYN, because it sets state->td_scale to 0 and only sets
state->td_scale to something non-zero if it sees a wscale option. So
if we ever call that on an skb that's not a SYN, we will forget that
the connection is using the wscale option.

But at this point in the code it is calling tcp_options() without
first checking that this is a SYN.

For this TFO scenario like the one in the trace, where the server
sends its first data packet after the SYNACK packet and before the
client's first ACK, presumably the conntrack state machine is
(correctly) SYN_RECV, and then (incorrectly) executes this code,
including the call to tcp_options(), on this first data packet, which
has no SYN bit, and no wscale option. Thus tcp_options() zeroes out
the server's sending state td_scale and does not set it to a non-zero
value. So now conntrack thinks the server is not using the wscale
option. So when conntrack interprets future receive windows from the
server, it does not scale them (with: win <<= sender->td_scale;), so
in this scenario the estimated right edge of the server's receive
window (td_maxend) is never advanced past the roughly 64KB value
offered in the SYN. Thus when the client sends data packets beyond
64KBytes, conntrack declares them invalid and drops them, due to
failing the condition Eric noted above:

   before(seq, sender->td_maxend + 1),

This explains my previous observation that the client's original data
packet transmissions are always dropped after the first 64KBytes.

Someone more familiar with conntrack may have a good idea about how to
best fix this?

neal
