Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5DCD5AB8CE
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 21:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbiIBTRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 15:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiIBTRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 15:17:51 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB04F32E6
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 12:17:50 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id cb8so2285782qtb.0
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 12:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=PMseM3cB0vE/Sq9/CaEhniq9J0pDE9Yjgz9Ktl3o20w=;
        b=HWyFedFiR71SCl5iT0Nq2BCaFZNU7SYXqE0kHnCPeoiXgZbKlUj9lawHThb5A8kkRV
         Ah8Esgvy8QM3W8PkAn2nYnwX8u6jM9ejcNwX7xc87iJpj4P8tJ6qAW9rCiAGUV78ZaCG
         cwMCcB5A9KSMeUfLk0ZL9XccCTE35+ORZSVF7/yDnRYX/0wdMBhSIYwbSTO46di7fNWR
         reVhrxezyl+ooySmtZenlV/m7Ik6yf+IRDwlPXyM7iDanibMhojWKRAfamiNpn1fbjoA
         heNrO/NlEDjEZrV49zyW7I7kti6sLiTb9Du0NUeyJUXHu9z4hEiUaIW2ODBBJYajoglw
         tMCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=PMseM3cB0vE/Sq9/CaEhniq9J0pDE9Yjgz9Ktl3o20w=;
        b=30A6fG/kXPv0eOuX2QPALkptJKXUas0bEJIK8uYKE68MDF195CFuZDxzF03rHNQez+
         Gpu1irn0sQoB0nEF0CpejN+3iIvUpvNGTykPAQIePAMWUN2qYktwPE3Joyanpj+mJJ2K
         Tsp3MzfExhXAvgrIOZPH6u9xCv6/Xsf6/rvg5Pbk9nwLKNxW9Xw60Ud6/aRcnn7e3Irv
         TqIJtQA/q/5K4au9ffqtHGj53vRybE2aNDZjW6HwgEvHputhEjC9t+25tcMytqRwRsHO
         UykHnJgkwqGu7nNExPDp3xS+BZSvl7zltIlIzEquy8R8RS1mjdR3aNAri9QWh1Enn5s7
         Udfg==
X-Gm-Message-State: ACgBeo2kgBieN5DDYcjkbzChSYSBqr12AaDBndO2xhNzMF0x69TeZFfl
        XLveVtvBd3qmxLKeptiSdY3Bn19x4qPOA4nV93Ub3g==
X-Google-Smtp-Source: AA6agR6xiDoq0MuOcjXmKoqQ0VCCRFhxEFVEAMwYkRGcTXrkge5XQsjbWjXYXZNFInBBPHbAPaRW48/pN2gOonqoKzE=
X-Received: by 2002:ac8:584e:0:b0:343:781b:d15 with SMTP id
 h14-20020ac8584e000000b00343781b0d15mr30220429qth.560.1662146269021; Fri, 02
 Sep 2022 12:17:49 -0700 (PDT)
MIME-Version: 1.0
References: <SJ0PR84MB1847BE6C24D274C46A1B9B0EB27A9@SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM>
 <CADVnQy=0QF2vit1COPqfphwemHVEwuD5Q8MqUEMVAxVsANOVtA@mail.gmail.com> <SJ0PR84MB18471A151DA83FD70075B354B27A9@SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <SJ0PR84MB18471A151DA83FD70075B354B27A9@SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 2 Sep 2022 15:17:32 -0400
Message-ID: <CADVnQymOSFQSDczDa2VWF8XbbrHbQ1sFwoTjDvvdWh7+BP5Big@mail.gmail.com>
Subject: Re: retrans_stamp not cleared while testing NewReno implementation.
To:     "Arankal, Nagaraj" <nagaraj.p.arankal@hpe.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>
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

On Fri, Sep 2, 2022 at 10:19 AM Arankal, Nagaraj
<nagaraj.p.arankal@hpe.com> wrote:
>
> Hi Neal,
> Thanks a lot.
> I shall update my Kernel with proposed fix and run the tests again.

Great. Thanks for testing the patch!

I cooked a packetdrill test case, based on your scenario, to reproduce
the problem, and was able to reproduce the problem. I have pasted that
below. And then below that I have pasted a packetdrill test showing
the fixed behavior after the proposed fix patch is applied.

We will post an official patch on the list for review/discussion.

### Here is a version showing the buggy behavior on an unpatched
kernel. The TCP sender only sends 2 RTO retransmissions before timing
out the connection, even though we requested 5 retries
(net.ipv4.tcp_retries2=5):

// Reproduce a scenario reported in the netdev thread:
//  "retrans_stamp not cleared while testing NewReno implementation."
// Ensure that retrans_stamp is cleared during TS undo of an RTO episode.

--tcp_ts_tick_usecs=1000

// Set tcp_retries2 to a low value so that we time out sockets quickly.
`../common/defaults.sh
sysctl -q net.ipv4.tcp_retries2=5`

    0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
   +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
   +0 bind(3, ..., ...) = 0
   +0 listen(3, 1) = 0

   +0 < S 0:0(0) win 32792 <mss 1012,nop,nop,TS val 100 ecr 0,nop,wscale 7>
   +0 > S. 0:0(0) ack 1 <mss 1460,nop,nop,TS val 0 ecr 100,nop,wscale 8>
+.020 < . 1:1(0) ack 1 win 257 <nop,nop,TS val 120 ecr 0>
   +0 accept(3, ..., ...) = 4
   +0 write(4, ..., 1000) = 1000
   +0 > P. 1:1001(1000) ack 1 <nop,nop,TS val 20 ecr 100>
+0 %{ assert tcpi_snd_cwnd == 10, tcpi_snd_cwnd }%

// RTO and retransmit head spuriously.
+.220 > P. 1:1001(1000) ack 1 <nop,nop,TS val 220 ecr 100>
+0 %{ assert tcpi_snd_cwnd == 1, tcpi_snd_cwnd }%
+0 %{ assert tcpi_ca_state == TCP_CA_Loss }%

// ACK arrives with an ECR indicating it's ACKing the original skb,
// so we undo the loss recovery. However, since this is a non-SACK
// connection we remain in CA_Loss.
+.005 < . 1:1(0) ack 1001 win 257 <nop,nop,TS val 140 ecr 20>
+0 %{ assert tcpi_snd_cwnd == 10, tcpi_snd_cwnd }%
+0 %{ assert tcpi_ca_state == TCP_CA_Loss }%


// Much later we send something.
+11 write(4, ..., 1000) = 1000
   +0 > P. 1001:2001(1000) ack 1 <nop,nop,TS val 11253 ecr 140>
+0 %{ assert tcpi_snd_cwnd == 10, tcpi_snd_cwnd }%

// RTO and retransmit head.
+.290 > P. 1001:2001(1000) ack 1 <nop,nop,TS val 11540 ecr 140>

// RTO and retransmit head.
+.618 > P. 1001:2001(1000) ack 1 <nop,nop,TS val 12148 ecr 140>

// Check whether connection is timed out yet (it should not be):
+1.30 write(4, ..., 1000) = -1 ETIMEDOUT (Connection Timed Out)

### Here is a version showing the fixed behavior on a patched kernel.
The TCP sender correctly sends 5 RTO retransmissions before timing out
the connection, since we requested 5 retries
(net.ipv4.tcp_retries2=5):

// Reproduce a scenario reported in the netdev thread:
//  "retrans_stamp not cleared while testing NewReno implementation."
// Ensure that retrans_stamp is cleared during TS undo of an RTO episode.

--tcp_ts_tick_usecs=1000

// Set tcp_retries2 to 5 so that we should get exactly 5
// RTO retransmissions before the connection times out
// and returns ETIMEDOUT.
`../common/defaults.sh
sysctl -q net.ipv4.tcp_retries2=5`

    0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
   +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
   +0 bind(3, ..., ...) = 0
   +0 listen(3, 1) = 0

   +0 < S 0:0(0) win 32792 <mss 1012,nop,nop,TS val 100 ecr 0,nop,wscale 7>
   +0 > S. 0:0(0) ack 1 <mss 1460,nop,nop,TS val 0 ecr 100,nop,wscale 8>
+.020 < . 1:1(0) ack 1 win 257 <nop,nop,TS val 120 ecr 0>
   +0 accept(3, ..., ...) = 4
   +0 write(4, ..., 1000) = 1000
   +0 > P. 1:1001(1000) ack 1 <nop,nop,TS val 20 ecr 100>
+0 %{ assert tcpi_snd_cwnd == 10, tcpi_snd_cwnd }%

// RTO and retransmit head spuriously.
+.220 > P. 1:1001(1000) ack 1 <nop,nop,TS val 220 ecr 100>
+0 %{ assert tcpi_snd_cwnd == 1, tcpi_snd_cwnd }%
+0 %{ assert tcpi_ca_state == TCP_CA_Loss }%

// ACK arrives with an ECR indicating it's ACKing the original skb,
// so we undo the loss recovery. However, since this is a non-SACK
// connection we remain in CA_Loss.
+.005 < . 1:1(0) ack 1001 win 257 <nop,nop,TS val 140 ecr 20>
+0 %{ assert tcpi_snd_cwnd == 10, tcpi_snd_cwnd }%
+0 %{ assert tcpi_ca_state == TCP_CA_Loss }%

// Much later we send something.
+11 write(4, ..., 1000) = 1000
   +0 > P. 1001:2001(1000) ack 1 <nop,nop,TS val 11253 ecr 140>
+0 %{ assert tcpi_snd_cwnd == 10, tcpi_snd_cwnd }%

// RTO and retransmit head.
+.290 > P. 1001:2001(1000) ack 1 <nop,nop,TS val 11540 ecr 140>

// RTO and retransmit head.
+.618 > P. 1001:2001(1000) ack 1 <nop,nop,TS val 12148 ecr 140>

// RTO and retransmit head.
+1.216 > P. 1001:2001(1000) ack 1 <nop,nop,TS val 12148 ecr 140>

// RTO and retransmit head.
+2.432 > P. 1001:2001(1000) ack 1 <nop,nop,TS val 15768 ecr 140>

// RTO and retransmit head.
+4.864 > P. 1001:2001(1000) ack 1 <nop,nop,TS val 20642 ecr 140>

// Check whether connection is timed out yet (it should not be):
+9.8 write(4, ..., 1000) = -1 ETIMEDOUT (Connection Timed Out)
