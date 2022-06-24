Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A0F559367
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 08:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbiFXG1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 02:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbiFXG1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 02:27:48 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1456C50E00
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 23:27:47 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id 23so2881608ybe.8
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 23:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PMmPjlIzbBrSVNtBauiiJrL24zSp7CtYuD6q/mhBtTc=;
        b=radPOjg7V8cYvEYB9Ri3EBQuPTgd8sJT6BUhsJV6fVEl4+OCRY7na0G8MExXH/xmn1
         Z+zzkUXfuvlZ8wgrKKSJa7/reTFlkzWLTU5wFSM5mxHFwbZU9M99j9GT8g+H7lkmnyxk
         dnc0xgmT18rkI/jaZ1U8u0o50rv2PnBbc8KupvjUtApWx4s3u2lzDru4Ey6X1hkZuuQd
         nE7V94QkzLpY78GsadAsexJ697XbVHKyWqXxvtnd65yzz9k81JxdzmLFt52tfwGTjW1E
         m/2jhArN+UoBHVHBAMhdJpP2mrpYoatY/WWM8IW0rULAvwdmVy5brmfiuslchmjbpidB
         FXCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PMmPjlIzbBrSVNtBauiiJrL24zSp7CtYuD6q/mhBtTc=;
        b=wMYyYXeJkoUis6cs9j9Zj1sO3s5mcrxgsPWI4A03jx7i1O9b0EkctqZtVpcPRqIz0V
         RrmjRR9+HD3fyQnSP4c0Ek0mZFs/FaxWNi+v8vPB+18yj0HZY3bBXIWovRFeA4BRfHSu
         bJX9JiKbHJwEp3biIGIdHjFAFfTxHmVmzN0i8l0M+La8kuWf+wvx3gK/GBTrt3L+laJz
         or+0tyg0izkIEg5OXaZnCsq7Qtazht+nfh5KT8rRtPp6Tlk6xO4fytCag0Od99CTPXis
         UAztehbrzXN8zpam6J8vookrj4+zTKdHn6MGdLbEq4fMKluMqBjEAGUpiPm0gewFkRTI
         okkA==
X-Gm-Message-State: AJIora/dYbGwWopWWrFYvM+YSHTi2xxtKx6yHgY7vH9X4yBEC2uHWCNN
        V5RVYpgCi3L5BfuQlawr0UQCL7hyX21iEXVXaFdw/Q==
X-Google-Smtp-Source: AGRyM1uY1fNnZ9UQYqsUxB2LshDJRQ51KYS/MKoGFi5qLbo71+R+hVZ8XU9hKywlwmAbbkhFFNxSY8BiwVe7/bayGzA=
X-Received: by 2002:a25:e211:0:b0:669:9cf9:bac7 with SMTP id
 h17-20020a25e211000000b006699cf9bac7mr10616590ybe.407.1656052066048; Thu, 23
 Jun 2022 23:27:46 -0700 (PDT)
MIME-Version: 1.0
References: <1656050956-9762-1-git-send-email-quic_subashab@quicinc.com>
In-Reply-To: <1656050956-9762-1-git-send-email-quic_subashab@quicinc.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 24 Jun 2022 08:27:34 +0200
Message-ID: <CANn89iJ_HBEkiU3ToAjcv_KHz3f77DJpycKcU=74X3rNst-V6g@mail.gmail.com>
Subject: Re: [PATCH net-next] net: Print real skb addresses for all net events
To:     Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, quic_jzenner@quicinc.com,
        Cong Wang <cong.wang@bytedance.com>, qitao.xu@bytedance.com,
        Sean Tranchetti <quic_stranche@quicinc.com>
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

On Fri, Jun 24, 2022 at 8:09 AM Subash Abhinov Kasiviswanathan
<quic_subashab@quicinc.com> wrote:
>
> Commit 65875073eddd ("net: use %px to print skb address in trace_netif_re=
ceive_skb")
> added support for printing the real addresses for the events using
> net_dev_template.
>

It is not clear why the 'real address' is needed in trace events.

I would rather do the opposite.

diff --git a/include/trace/events/net.h b/include/trace/events/net.h
index 032b431b987b63b5fab1d3c763643d6192f2c325..da611a7aaf970f541949cdd87ac=
9203c4c7e81b1
100644
--- a/include/trace/events/net.h
+++ b/include/trace/events/net.h
@@ -136,7 +136,7 @@ DECLARE_EVENT_CLASS(net_dev_template,
                __assign_str(name, skb->dev->name);
        ),

-       TP_printk("dev=3D%s skbaddr=3D%px len=3D%u",
+       TP_printk("dev=3D%s skbaddr=3D%p len=3D%u",
                __get_str(name), __entry->skbaddr, __entry->len)
 )

diff --git a/include/trace/events/qdisc.h b/include/trace/events/qdisc.h
index 59c945b66f9c7469bc071e2a27efb8bfa9eb19f7..a3995925cb057021dc779344d19=
f7e3724f6df3c
100644
--- a/include/trace/events/qdisc.h
+++ b/include/trace/events/qdisc.h
@@ -41,7 +41,7 @@ TRACE_EVENT(qdisc_dequeue,
                __entry->txq_state      =3D txq->state;
        ),

-       TP_printk("dequeue ifindex=3D%d qdisc handle=3D0x%X parent=3D0x%X
txq_state=3D0x%lX packets=3D%d skbaddr=3D%px",
+       TP_printk("dequeue ifindex=3D%d qdisc handle=3D0x%X parent=3D0x%X
txq_state=3D0x%lX packets=3D%d skbaddr=3D%p",
                  __entry->ifindex, __entry->handle, __entry->parent,
                  __entry->txq_state, __entry->packets, __entry->skbaddr )
 );
@@ -70,7 +70,7 @@ TRACE_EVENT(qdisc_enqueue,
                __entry->parent  =3D qdisc->parent;
        ),

-       TP_printk("enqueue ifindex=3D%d qdisc handle=3D0x%X parent=3D0x%X
skbaddr=3D%px",
+       TP_printk("enqueue ifindex=3D%d qdisc handle=3D0x%X parent=3D0x%X s=
kbaddr=3D%p",
                  __entry->ifindex, __entry->handle, __entry->parent,
__entry->skbaddr)
 );



> However, tracing the packet traversal shows a mix of hashes and real
> addresses. Pasting a sample trace for reference-
>
> ping-14249   [002] .....  3424.046612: netif_rx_entry: dev=3Dlo napi_id=
=3D0x3 queue_mapping=3D0
> skbaddr=3D00000000dcbed83e vlan_tagged=3D0 vlan_proto=3D0x0000 vlan_tci=
=3D0x0000 protocol=3D0x0800
> ip_summed=3D0 hash=3D0x00000000 l4_hash=3D0 len=3D84 data_len=3D0 truesiz=
e=3D768 mac_header_valid=3D1
> mac_header=3D-14 nr_frags=3D0 gso_size=3D0 gso_type=3D0x0
> ping-14249   [002] .....  3424.046615: netif_rx: dev=3Dlo skbaddr=3Dfffff=
f888e5d1000 len=3D84
>
> Switch the trace print formats to %px for all the events to have a
> consistent format of printing the real addresses in all cases.
>
> Signed-off-by: Sean Tranchetti <quic_stranche@quicinc.com>
> Signed-off-by: Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
> ---
>  include/trace/events/net.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/include/trace/events/net.h b/include/trace/events/net.h
> index 032b431..2651350 100644
> --- a/include/trace/events/net.h
> +++ b/include/trace/events/net.h
> @@ -58,7 +58,7 @@ TRACE_EVENT(net_dev_start_xmit,
>                 __entry->gso_type =3D skb_shinfo(skb)->gso_type;
>         ),
>
> -       TP_printk("dev=3D%s queue_mapping=3D%u skbaddr=3D%p vlan_tagged=
=3D%d vlan_proto=3D0x%04x vlan_tci=3D0x%04x protocol=3D0x%04x ip_summed=3D%=
d len=3D%u data_len=3D%u network_offset=3D%d transport_offset_valid=3D%d tr=
ansport_offset=3D%d tx_flags=3D%d gso_size=3D%d gso_segs=3D%d gso_type=3D%#=
x",
> +       TP_printk("dev=3D%s queue_mapping=3D%u skbaddr=3D%px vlan_tagged=
=3D%d vlan_proto=3D0x%04x vlan_tci=3D0x%04x protocol=3D0x%04x ip_summed=3D%=
d len=3D%u data_len=3D%u network_offset=3D%d transport_offset_valid=3D%d tr=
ansport_offset=3D%d tx_flags=3D%d gso_size=3D%d gso_segs=3D%d gso_type=3D%#=
x",
>                   __get_str(name), __entry->queue_mapping, __entry->skbad=
dr,
>                   __entry->vlan_tagged, __entry->vlan_proto, __entry->vla=
n_tci,
>                   __entry->protocol, __entry->ip_summed, __entry->len,
> @@ -91,7 +91,7 @@ TRACE_EVENT(net_dev_xmit,
>                 __assign_str(name, dev->name);
>         ),
>
> -       TP_printk("dev=3D%s skbaddr=3D%p len=3D%u rc=3D%d",
> +       TP_printk("dev=3D%s skbaddr=3D%px len=3D%u rc=3D%d",
>                 __get_str(name), __entry->skbaddr, __entry->len, __entry-=
>rc)
>  );
>
> @@ -215,7 +215,7 @@ DECLARE_EVENT_CLASS(net_dev_rx_verbose_template,
>                 __entry->gso_type =3D skb_shinfo(skb)->gso_type;
>         ),
>
> -       TP_printk("dev=3D%s napi_id=3D%#x queue_mapping=3D%u skbaddr=3D%p=
 vlan_tagged=3D%d vlan_proto=3D0x%04x vlan_tci=3D0x%04x protocol=3D0x%04x i=
p_summed=3D%d hash=3D0x%08x l4_hash=3D%d len=3D%u data_len=3D%u truesize=3D=
%u mac_header_valid=3D%d mac_header=3D%d nr_frags=3D%d gso_size=3D%d gso_ty=
pe=3D%#x",
> +       TP_printk("dev=3D%s napi_id=3D%#x queue_mapping=3D%u skbaddr=3D%p=
x vlan_tagged=3D%d vlan_proto=3D0x%04x vlan_tci=3D0x%04x protocol=3D0x%04x =
ip_summed=3D%d hash=3D0x%08x l4_hash=3D%d len=3D%u data_len=3D%u truesize=
=3D%u mac_header_valid=3D%d mac_header=3D%d nr_frags=3D%d gso_size=3D%d gso=
_type=3D%#x",
>                   __get_str(name), __entry->napi_id, __entry->queue_mappi=
ng,
>                   __entry->skbaddr, __entry->vlan_tagged, __entry->vlan_p=
roto,
>                   __entry->vlan_tci, __entry->protocol, __entry->ip_summe=
d,
> --
> 2.7.4
>
