Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C75E5F7751
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 13:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiJGLVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 07:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiJGLVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 07:21:32 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFC2371B0;
        Fri,  7 Oct 2022 04:21:31 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id x59so6578440ede.7;
        Fri, 07 Oct 2022 04:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=06DqF0rk4IBMmbj2BVj8q3I6SSewRpjF5QRhHp2MSBs=;
        b=gWqYxj3TRi1wl1j+iRQ98Q6llfZFDosa5j+xVWX9jNbiEoxWGwYPDNglD769V5eDXm
         VzYIeFoYEKtU4mS3yQ1JH1zaI563BdcknV+EjHtU+igHAOfCS8jGePJGauUG/d+jS9N2
         pSt7PIy2CXo+FMigMfBAAB+UwcPBa7emFRrCuznrk0NlEQ1RZyfpHmKJyW/vVHvzmIXQ
         q/HSw7Misg7Bey3MWwqxi86HL/BnCyFjO3c0mcAx9j0dAUYc8zeGuQ8ihx9ZLhRNrTi6
         etxuCCG71DWpNcSZlsKVpv9K0wKxbNp3+9w77gL7h8lxaPBWW4dgY9jtRROBcQatExn9
         1Kjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=06DqF0rk4IBMmbj2BVj8q3I6SSewRpjF5QRhHp2MSBs=;
        b=6L9WNTFskofZ/5LIA4xltX3eNHhrP2tsGpXhscmd9EOguVDwJ4lf/BjRIFwnc7a8jb
         5h2VWGk3PytJj/Q2zZtRvkWQ6Az0n8r77KEUTmh8njSoqPOmEdA3fQzeudDOF3gUDPti
         oypM+BVoNP8UAu3Qw1oOsgr8H6k2kmNFOynuk/zCPXfCFGojRUOdj164Ucoqk79rPogo
         GzAdgohhNTuA81omthKptnqZK+AKlWDKuQV2bkP41DLHv4XO8A+S1h/y8wn9bRDJ9dBN
         1//rWGFT0vlCbwVUh/xE1CoGOtaJiP4wTi2XUMVgORxlTEB/TA+ctyxebj5ofSMO5T0k
         Kzrw==
X-Gm-Message-State: ACrzQf3khfyGyz+hY+u8P+jjeG0t5tvtAsZib7uNijj688zfjrzvQb34
        MzL604DlTzqGmLhaQBQ1s9V82Vyad5460BnzijpVbDIv2Zg=
X-Google-Smtp-Source: AMsMyM6U5nWDHOXWfxXxMzb5IbbG91blCM1b/b1JxPUoKl6NR0gISAp2IgvKP79GKcchLJzL2JEJfWcd2SvmNlpIDTg=
X-Received: by 2002:a05:6402:42cf:b0:457:ae6f:e443 with SMTP id
 i15-20020a05640242cf00b00457ae6fe443mr4106572edc.299.1665141689297; Fri, 07
 Oct 2022 04:21:29 -0700 (PDT)
MIME-Version: 1.0
From:   Vyacheslav Salnikov <snordicstr16@gmail.com>
Date:   Fri, 7 Oct 2022 17:21:18 +0600
Message-ID: <CACzz7uzbSVpLu8iqBYXTULr2aUW_9FDdkEVozK+r-BiM2rMukw@mail.gmail.com>
Subject: bridge:fragmented packets dropped by bridge
To:     netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi.

I switched from kernel versions 4.9 to 5.15 and found that the MTU on
the interfaces in the bridge does not change.
For example:
I have the following bridge:
bridge      interface
br0          sw1
               sw2
               sw3

And I change with ifconfig MTU.
I see that br0 sw1..sw3 has changed MTU from 1500 -> 1982.

But if i send a ping through these interfaces, I get 1500(I added
prints for output)
I investigated the code and found the reason:
The following commit came in the new kernel:
https://github.com/torvalds/linux/commit/ac6627a28dbfb5d96736544a00c3938fa7ea6dfb

And the behavior of the MTU setting has changed:
>
> Kernel 4.9:
> if (net->ipv4.sysctl_ip_fwd_use_pmtu ||
>    ip_mtu_locked(dst) ||
>    !forwarding)  <--- True
> return dst_mtu(dst) <--- 1982
>
>
> / 'forwarding = true' case should always honour route mtu /
> mtu = dst_metric_raw(dst, RTAX_MTU);
> if (mtu)
> return mtu;



Kernel 5.15:
>
> if (READ_ONCE(net->ipv4.sysctl_ip_fwd_use_pmtu) ||
>    ip_mtu_locked(dst) ||
>    !forwarding) { <--- True
> mtu = rt->rt_pmtu;  <--- 0
> if (mtu && time_before(jiffies, rt->dst.expires)) <-- False
> goto out;
> }
>
> / 'forwarding = true' case should always honour route mtu /
> mtu = dst_metric_raw(dst, RTAX_MTU); <---- 1500
> if (mtu) <--- True
> goto out;

As I see from the code in the end takes mtu from br_dst_default_metrics
> static const u32 br_dst_default_metrics[RTAX_MAX] = {
> [RTAX_MTU - 1] = 1500,
> };

Why is rt_pmtu now used instead of dst_mtu?
Why is forwarding = False called with dst_metric_raw?
Maybe we should add processing when mtu = rt->rt_pmtu == 0?
Could this be an error?


I found a thread discussing a similar problem. It suggested porting
the next patch:
Signed-off-by: Rundong Ge <rdong.ge@gmail.com>
---
 include/net/ip.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/ip.h b/include/net/ip.h
index 29d89de..0512de3 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -450,6 +450,8 @@ static inline unsigned int
ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 static inline unsigned int ip_skb_dst_mtu(struct sock *sk,
    const struct sk_buff *skb)
 {
+ if ((skb_dst(skb)->flags & DST_FAKE_RTABLE) && skb->dev)
+ return min(skb->dev->mtu, IP_MAX_MTU);
  if (!sk || !sk_fullsock(sk) || ip_sk_use_pmtu(sk)) {
  bool forwarding = IPCB(skb)->flags & IPSKB_FORWARDED;


Why was this patch not accepted in the end?
-- 
Best regards,
Slava.
