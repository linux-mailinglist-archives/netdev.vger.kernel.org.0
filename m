Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9124638C922
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 16:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236671AbhEUOYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 10:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235731AbhEUOYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 10:24:06 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF49C061574
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 07:22:42 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id k16so20263732ios.10
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 07:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=B9lPlJVVEWfMLD+zEmEsxgqPwP/dCW8wmJ3vlyYvbg8=;
        b=mGWga2uOn0uAraM7WrozxL/thfBESvkLuiUcxScYTKItgVWH3f1u7x5yKzKKeQmKrg
         IS6VIwPkEqjEZjdARp0htL91oZA6X+eyNxjL4+cbdupxIcXYLw6deoDppbEawDU9b6j/
         E0GQ9PJSiGk0lncRvZT6J+HKmnmNj4j7T+siFW7zvD8zdgAPJDCk/OtMo+oRxZ4M7WXE
         d3XosUrGOKNL4sFifFNUsmpztvT6VABT2LmaTItskoN+gLR9+dhT4aeGqSLp7Zey/d27
         xNrpfe2ZI+GKaHhMBScURsxQt3+qqgCiID1rt/N9UjMTnPWKiiSYHw+3gB5eeMVuz+i6
         AmMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=B9lPlJVVEWfMLD+zEmEsxgqPwP/dCW8wmJ3vlyYvbg8=;
        b=O28hPef+NMba2xOz2I9jzU+8GUxO5KK57isqXapRlf8ITPMj+eWOih3lrK8vs/dhd5
         aA3ukGYEuR2S+HZXmOHXg4UQ9WyW5WqmxQzEMRCCdcuXCmTQGYqFcui2Z7d/878JVbKP
         FLlqYB34DgeJFmezbmf9HHLPfDi5qCFubC7CUWB9K3H2KcTh1QqcqyS3x2YZtl+nSHqK
         ZOMkrB5EJweIakeyqL+M9auD5kzOM2PkOU7jnSmpGCDd0G9lmUT/TRdElNgFBOFH04nb
         G0ZHucLbvG3i+70Sfk9Eu+kIS4BRPRMqCCzE0IozhNsomPz4ENr943VmJOv8/58MqH08
         NyOQ==
X-Gm-Message-State: AOAM531R7dcZvsVXtaaiBqA2vM3iZ1LbKA3w6wSPkTj1CYUGpOe6iVWC
        HaBw7PRyfST/cHXcrvzSPp+pfbLk6nh6ttvUyw==
X-Google-Smtp-Source: ABdhPJwhH0/OxPXpbD4dOS4c8kQTg9+ge9Y+2yEKT4jtBZvEeaWuomqZ4v/iFqdkOEmV+3Es5KMJWZsoIT7sTG7FNGE=
X-Received: by 2002:a02:900b:: with SMTP id w11mr4667667jaf.5.1621606962260;
 Fri, 21 May 2021 07:22:42 -0700 (PDT)
MIME-Version: 1.0
From:   Jinmeng Zhou <jjjinmeng.zhou@gmail.com>
Date:   Fri, 21 May 2021 22:22:31 +0800
Message-ID: <CAA-qYXi2Hcyi_PCQeYTP2BjUGp92oQogGSc0BLkS7UGvp9O31w@mail.gmail.com>
Subject: Fwd: the missing check bug before calling ip_route_output_flow().
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, shenwenbosmile@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear maintainers,

hi, our team has found and reported a missing check bug on Linux
kernel v5.10.7 using static analysis.
We are looking forward to having more experts' eyes on this. Thank you!


> Thu, 6 May 2021 11:01:24 -0700 Jakub Kicinski <kuba@kernel.org> wrote:
> > On Thu, 6 May 2021 15:50:33 +0800 Jinmeng Zhou wrote:
> > hi, our team has found a missing check bug on Linux kernel v5.10.7 using
> static analysis.
> > We think there is a missing check bug in ip_route_output_key() before calling
> function ip_route_output_flow().
>
> Thank you for the report!
>
> > There is a check calls to security_sk_classify_flow() in function ip_route_newports().
> > 1. // check security_sk_classify_flow() ///////////////
> > 2. static inline struct rtable *ip_route_newports(struct flowi4 *fl4, struct rtable *rt,
> > 3.       __be16 orig_sport, __be16 orig_dport,
> > 4.       __be16 sport, __be16 dport,
> > 5.       struct sock *sk)
> > 6. {
> > 7. ...
> > 8.   security_sk_classify_flow(sk, flowi4_to_flowi(fl4));
> > 9.   return ip_route_output_flow(sock_net(sk), fl4, sk);
> > 10. ...
> > 11. }
> >
> > While, ip_route_output_key() does not have check.
> > 1. // no check ////////////////////////////////////
> > 2. static inline struct rtable *ip_route_output_key(struct net *net, struct flowi4 *flp)
> > 3. {
> > 4.   return ip_route_output_flow(net, flp, NULL);
> > 5. }
> >
> > On the path from user-reachable function to ip_route_output_key() also does not contain this check. There is a call chain:
> > nft_reject_ipv4_eval() =>
> > nf_send_reset() =>
>
> This path looks like ICMP reject path, so it's not run in a context of
> any process, I'm not sure security checks make sense in such context.
> But again please circulate the report more widely, add people who have
> touched the code in the past and relevant mailing lists.
>
> > ip_route_me_harder() =>
> > ip_route_output_key()
> >
> > 1. static const struct nft_expr_ops nft_reject_ipv4_ops = {
> > 2.
> > 3.   .eval = nft_reject_ipv4_eval,
> > 4.
> > 5. };
> > 6. static int __init nft_reject_ipv4_module_init(void)
> > 7. {
> > 8.   return nft_register_expr(&nft_reject_ipv4_type);
> > 9. }
> > 10. module_init(nft_reject_ipv4_module_init);
> >
> > Therefore we think the buggy function can be triggered.
> >
> > Thanks!
> >
> >
> > Best regards,
> > Jinmeng Zhou


We want to add further explanation.
We find that ip_route_output_flow() is used at 18 places in total.
In most cases, the function is placed behind the security check
security_sk_classify_flow() or its last parameter is NULL.

We also observe if the last parameter of ip_route_output_flow() is NULL,
usually, there will be no security check.

However, we find only 2 usages in function ipv4_sk_update_pmtu() where
the last parameter is not NULL and there is no security check.


1. void ipv4_sk_update_pmtu(struct sk_buff *skb, struct sock *sk, u32 mtu)
2. {
3.    ...
4.    if (odst->obsolete && !odst->ops->check(odst, 0)) {
5.    rt = ip_route_output_flow(sock_net(sk), &fl4, sk);
6.    if (IS_ERR(rt))
7.      goto out;
8.
9.       new = true;
10.   }
11.
12.   __ip_rt_update_pmtu((struct rtable *)xfrm_dst_path(&rt->dst), &fl4, mtu);
13.
14.   if (!dst_check(&rt->dst, 0)) {
15.     if (new)
16.       dst_release(&rt->dst);
17.
18.     rt = ip_route_output_flow(sock_net(sk), &fl4, sk);
19.     if (IS_ERR(rt))
20.       goto out;
21.
22.     new = true;
23.   }
24.   ...
25. }

ipv4_sk_update_pmtu() is called by 3 callers, ping_err(), raw_err()
and __udp4_lib_err().
They are likely to handle the error condition.


Thanks!

Best regards,
Jinmeng Zhou
