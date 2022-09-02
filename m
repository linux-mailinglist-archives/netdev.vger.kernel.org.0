Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1085AB3BE
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 16:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236411AbiIBOea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 10:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236995AbiIBOdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 10:33:54 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD8E186E9
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 06:55:46 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id g16so1709797qkl.11
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 06:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=T8ATcUJFiZWVLphQllKPiVNmvaVBRmIl3tPe+4q+fCE=;
        b=dtyrrFTm4EAZd3LtU6q3XwZLdGX7GcQXMEXkfB06SWHBHSryMWH9+LEhdAOklOwqAo
         YCDRxWHDGzPHutSnUQytlTT5EVxddxEAVFdOnKHPycrTHVQKExhKY25FkrF3LhkeRgbt
         nhYJG7Veeu2ZOYrOlYFM2Gac5LAFucz5/y8Hg2+YWzMPSzIFN6Py3RZwyiybgQw7UbF3
         j9jUuaeC9NZssj97DL083cPo/eHkqY6KT+oIZsHSyhmd8vbWQqHgDGPdKsKCuw1zb4j0
         i1JZTrLJ7zEhYJIuBYZrCkUBr++R//iO1HYv6b/isUlhu8/N6UL9o4xMDU+jg9oSjE0O
         WMWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=T8ATcUJFiZWVLphQllKPiVNmvaVBRmIl3tPe+4q+fCE=;
        b=YBfEHuk3v6HFGncZSKsZjTr8yDWGbGZFUUOpCtinWuz5q1IuiCL8AyqjRorBYt37UZ
         LcV8/1yszSmmwT2fuUC00BZBKkxp+lC+9Kv64qvDxXu2FLufKn3xQXQoSsV3brf1AEyH
         qxHlP7iq5fNf8UF537SGnHn/EDqbv5rOU+595GRYbhdA8jh8d9k/r/7ohVXG+J8K94OT
         RD5FtBvQjBN2llCNd9hjCZa0hprfyRf1jgfG3UBUHeP7r1H8KgG4eebOy3o6O1hbiHuz
         HzNbNY8oeUXTif0BHYbVgollwx0j2BVlgaeaOsR6Rnbtm7N1D1MdqY2ocmnvPnA2MlMr
         FHRg==
X-Gm-Message-State: ACgBeo16ga4dtoJBmdavhkEYtubbH9eqkNwNNuIsYeS1Ac9YFE3FKCDF
        VyLwbIUHPpS9mYNwn6SZDLwAQY1kiqu9zqzI5G/9Zg==
X-Google-Smtp-Source: AA6agR4IOcW8iv3+vid31K8MUmKO0M6jDNmORB9gjIPabe1SUBC3CSMQJzau141fYrnXm4/sacPb2kyWVmmKHDe4kXY=
X-Received: by 2002:a05:620a:2b89:b0:6bb:f400:df64 with SMTP id
 dz9-20020a05620a2b8900b006bbf400df64mr23456868qkb.395.1662126943995; Fri, 02
 Sep 2022 06:55:43 -0700 (PDT)
MIME-Version: 1.0
References: <SJ0PR84MB1847BE6C24D274C46A1B9B0EB27A9@SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <SJ0PR84MB1847BE6C24D274C46A1B9B0EB27A9@SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 2 Sep 2022 09:55:27 -0400
Message-ID: <CADVnQy=0QF2vit1COPqfphwemHVEwuD5Q8MqUEMVAxVsANOVtA@mail.gmail.com>
Subject: Re: retrans_stamp not cleared while testing NewReno implementation.
To:     "Arankal, Nagaraj" <nagaraj.p.arankal@hpe.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>
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

"


On Fri, Sep 2, 2022 at 6:29 AM Arankal, Nagaraj
<nagaraj.p.arankal@hpe.com> wrote:
>
> While testing newReno implementation on 4.19.197 based debian kernel, New=
Reno(SACK disabled) with connections that have a very low traffic, we may t=
imeout the connection too early if a second loss occurs after the first one=
 was successfully acked but no data was transferred later. Below is his des=
cription of it:
>
> When SACK is disabled, and a socket suffers multiple separate TCP retrans=
missions, that socket's ETIMEDOUT value is calculated from the time of the =
*first* retransmission instead of the *latest* retransmission.
>
> This happens because the tcp_sock's retrans_stamp is set once then never =
cleared.
>
> Take the following connection:
>
>
> (*1) One data packet sent.
> (*2) Because no ACK packet is received, the packet is retransmitted.
> (*3) The ACK packet is received. The transmitted packet is acknowledged.
>
> At this point the first "retransmission event" has passed and been recove=
red from. Any future retransmission is a completely new "event".
>
> (*4) After 16 minutes (to correspond with tcp_retries2=3D15), a new data =
packet is sent. Note: No data is transmitted between (*3) and (*4) and we d=
isabled keep alives.
>
> The socket's timeout SHOULD be calculated from this point in time, but in=
stead it's calculated from the prior "event" 16 minutes ago.
>
> (*5) Because no ACK packet is received, the packet is retransmitted.
> (*6) At the time of the 2nd retransmission, the socket returns ETIMEDOUT.
>
> From the history I came to know that there was a fix included, which woul=
d resolve above issue. Please find below patch.
>
> static bool tcp_try_undo_recovery(struct sock *sk)
>                                 * is ACKed. For Reno it is MUST to preven=
t false
>                                 * fast retransmits (RFC2582). SACK TCP is=
 safe. */
>                                tcp_moderate_cwnd(tp);
> +                             if (!tcp_any_retrans_done(sk))
> +                                             tp->retrans_stamp =3D 0;
>                                return true;
>                }
>
> However, after introducing following fix,
>
> [net,1/2] tcp: only undo on partial ACKs in CA_Loss
>
> I am not able to see retrains_stamp reset to Zero.
> Inside tcp_process_loss , we are returning from below code path.
>
> if ((flag & FLAG_SND_UNA_ADVANCED) &&
>             tcp_try_undo_loss(sk, false))
>                 return;
> because of which tp->retrans_stamp is never cleared as we failed to invok=
e tcp_try_undo_recovery.
>
> Is this a known bug in kernel code or is it an expected behavior.
>
>
> - Thanks in advance,
> Nagaraj

Thanks for the detailed bug report and analysis! I agree that
"tcp: only undo on partial ACKs in CA_Loss" introduced the
bug that you are analyzing.

I suspect we need a fix along the lines below. I will try to create
a packetdrill test to reproduce this and verify the fix below,
and will run this fix through our existing packetdrill tests.

Thanks!

commit d2f706c1be7e9822a99477edd69bc13ddd00557f
Author: Neal Cardwell <ncardwell@google.com>
Date:   Fri Sep 2 09:36:23 2022 -0400

    tcp: fix early ETIMEDOUT after spurious non-SACK RTO

    Fix a bug reported and analyzed by Nagaraj Arankal, where the handling
    of a spurious non-SACK RTO could cause a connection to fail to clear
    retrans_stamp, causing a later RTO to very prematurely time out the
    connection with ETIMEDOUT.

    Here is the buggy scenario, expanding upon Nagaraj Arankal's excellent
    report:

    (*1) Send one data packet on a non-SACK connection

    (*2) Because no ACK packet is received, the packet is retransmitted
         and we enter CA_Loss; but this retransmission is spurious.

    (*3) The ACK for the original data is received. The transmitted packet
         is acknowledged.  The TCP timestamp is before the retrans_stamp,
         so tcp_may_undo() returns true, and tcp_try_undo_loss() returns
         true without changing state to Open (because tcp_is_sack() is
         false), and tcp_process_loss() returns without calling
         tcp_try_undo_recovery().  Normally after undoing a CA_Loss
         episode, tcp_fastretrans_alert() would see that the connection
         has returned to CA_Open and fall through and call
         tcp_try_to_open(), which would set retrans_stamp to 0.  However,
         for non-SACK connections we hold the connection in CA_Loss, so do
         not fall through to call tcp_try_to_open() and do not set
         retrans_stamp to 0. So retrans_stamp is (erroneously) still
         non-zero.

         At this point the first "retransmission event" has passed and
         been recovered from. Any future retransmission is a completely
         new "event". However, retrans_stamp is erroneously still
         set. (And we are still in CA_Loss, which is correct.)

    (*4) After 16 minutes (to correspond with tcp_retries2=3D15), a new dat=
a
         packet is sent. Note: No data is transmitted between (*3) and
         (*4) and we disabled keep alives.

         The socket's timeout SHOULD be calculated from this point in
         time, but instead it's calculated from the prior "event" 16
         minutes ago (step (*2)).

    (*5) Because no ACK packet is received, the packet is retransmitted.

    (*6) At the time of the 2nd retransmission, the socket returns
         ETIMEDOUT, prematurely, because retrans_stamp is (erroneously)
         too far in the past (set at the time of (*2)).

    This commit fixes this bug by ensuring that we reuse in
    tcp_try_undo_loss() the same careful logic for non-SACK connections
    that we have in tcp_try_undo_recovery(). To avoid duplicating logic,
    we factor out that logic into a new
    tcp_is_non_sack_preventing_reopen() helper and call that helper from
    both undo functions.

    Fixes: da34ac7626b5 ("tcp: only undo on partial ACKs in CA_Loss")
    Reported-by: Nagaraj Arankal <nagaraj.p.arankal@hpe.com>
    Signed-off-by: Neal Cardwell <ncardwell@google.com>
    Change-Id: Ie58ea40bdbfe0643111a17a41eda0674f62ce76d

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index b85a9f755da41..bc2ea12221f95 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2513,6 +2513,21 @@ static inline bool tcp_may_undo(const struct
tcp_sock *tp)
         return tp->undo_marker && (!tp->undo_retrans ||
tcp_packet_delayed(tp));
 }

+static bool tcp_is_non_sack_preventing_reopen(struct sock *sk)
+{
+        struct tcp_sock *tp =3D tcp_sk(sk);
+
+        if (tp->snd_una =3D=3D tp->high_seq && tcp_is_reno(tp)) {
+                /* Hold old state until something *above* high_seq
+                 * is ACKed. For Reno it is MUST to prevent false
+                 * fast retransmits (RFC2582). SACK TCP is safe. */
+                if (!tcp_any_retrans_done(sk))
+                        tp->retrans_stamp =3D 0;
+                return true;
+        }
+        return false;
+}
+
 /* People celebrate: "We love our President!" */
 static bool tcp_try_undo_recovery(struct sock *sk)
 {
@@ -2535,14 +2550,8 @@ static bool tcp_try_undo_recovery(struct sock *sk)
         } else if (tp->rack.reo_wnd_persist) {
                 tp->rack.reo_wnd_persist--;
         }
-        if (tp->snd_una =3D=3D tp->high_seq && tcp_is_reno(tp)) {
-                /* Hold old state until something *above* high_seq
-                 * is ACKed. For Reno it is MUST to prevent false
-                 * fast retransmits (RFC2582). SACK TCP is safe. */
-                if (!tcp_any_retrans_done(sk))
-                        tp->retrans_stamp =3D 0;
+        if (tcp_is_non_sack_preventing_reopen(sk))
                 return true;
-        }
         tcp_set_ca_state(sk, TCP_CA_Open);
         tp->is_sack_reneg =3D 0;
         return false;
@@ -2578,6 +2587,8 @@ static bool tcp_try_undo_loss(struct sock *sk,
bool frto_undo)
                         NET_INC_STATS(sock_net(sk),
                                         LINUX_MIB_TCPSPURIOUSRTOS);
                 inet_csk(sk)->icsk_retransmits =3D 0;
+                if (tcp_is_non_sack_preventing_reopen(sk))
+                        return true;
                 if (frto_undo || tcp_is_sack(tp)) {
                         tcp_set_ca_state(sk, TCP_CA_Open);
                         tp->is_sack_reneg =3D 0;

neal
