Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFCAD38C8F1
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 16:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbhEUOKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 10:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235438AbhEUOKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 10:10:47 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE18C061574
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 07:09:24 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id d25so8462609ioe.1
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 07:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=ksbwF1DACoW1xyP/TpSKRv2WcRb+fpdS+gLAG487HXE=;
        b=ZBZHSRETTxfAAU1zK7VO2VfUGOtjNVnHldyugoBduSmHgUxUyf5Dw5wqz19C1HbJBG
         7ovnRXuaTHC7MZ0oeyH9s6hJ1XUg6S3igMyIn07Qd4+YyMp0CT5kM7ci4JOAva+qa6Zc
         72fyTmUAD90Rbxa8ZmRfzKd3J9Oo9qM1RCLXhIj/x2rnMs7ynPDcyfjtbrUNYmG+vOXk
         l3XI0YxB82q+r4tnVQUkzOEw1mNd7Hi20DXc//rADW0L4+xxFa5YGhTp+J+LCRYBvSX4
         jMTA1WD80jrtg6Dhqcb5PHasCjUugvizulDlX0/Nm0SE1YPhSaNfisjhg0eUyJhrFtUS
         J55A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=ksbwF1DACoW1xyP/TpSKRv2WcRb+fpdS+gLAG487HXE=;
        b=c6X9ntfjb3X6Q0uBJQumj/wMPcQ3zakDQElCNV/s1dJWCO2Kcuy1xrI1fJd43/zbOi
         j7nCZnaO3DIJDJYp3WlVMNAN/+Ani+NEy7sr8h7Y+xx/4lNrrIoCrWfcsUBmnYSfvNCs
         6oip4Poqgrit0y7gl25r3IoVN9IQ6FypcvtweJvBq8BmlyF3whe7OZyFaS0V+BoeDPdy
         WF5JfDgB1m37Kx+CwyJpz7D+Swu8XaiTO08Ro+4oouXgHwlUscz1AXaA052pHBlouy8C
         stkF5yehb7vMUbHfSC9YrEPYQX4bwDNM/38g5hYDxTP8df59y4au0gfR0ITtRu8lTAQl
         4BIQ==
X-Gm-Message-State: AOAM532JRfbkifw0MF8QZ/Pw+CKxF6DojhIBiPbwcpBXnH9ggg8ZIMTp
        YezXQsCd7q0+eWKVTh6trLmF6dEwVitR/8fvHw==
X-Google-Smtp-Source: ABdhPJzHUhEig+LTv2nbcQ9LvRgNqKXHZ039Ee/PsE86TAuzysRPC/9czygAUoiH5JWZxPyiRDeWuGbidQVlttJOb7c=
X-Received: by 2002:a6b:f80e:: with SMTP id o14mr8269965ioh.176.1621606163355;
 Fri, 21 May 2021 07:09:23 -0700 (PDT)
MIME-Version: 1.0
From:   Jinmeng Zhou <jjjinmeng.zhou@gmail.com>
Date:   Fri, 21 May 2021 22:09:12 +0800
Message-ID: <CAA-qYXj44McN44UVOCx_vanHXddR5ToVBTEir7mrmWO5GmoGcA@mail.gmail.com>
Subject: Fwd: A missing check bug in unix_create1().
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, shenwenbosmile@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear maintainers,

hi, our team has reported two bugs on Linux kernel v5.10.7 using
static analysis.
The first one is confirmed and we submit a patch to fix the bug, and
it is accepted.

For the second bug in function unix_create1(),
we are looking forward to having more experts' eyes on this. Thank you!

> On Fri, May 7, 2021 at 1:57 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Thu, 6 May 2021 15:15:08 +0800 Jinmeng Zhou wrote:
> > hi, our team has found two bugs on Linux kernel v5.10.7 using static
> > analysis, a missing check bug and an inconsistent check bug.

> Thanks a lot for the report!

> > Before calling sk_alloc(), rawsock_create() uses capable() to check,
> > xsk_create() uses ns_capable() to check, while unix_create1() does not
> > check anything. As shown below, capable() actually checks the capability
> > of init_user_ns, however, ns_capable() is possibly checks other user namespace.
> >
> > 1. bool capable(int cap)
> > 2. {
> > 3.   return ns_capable(&init_user_ns, cap);
> > 4. }
> >
> > As shown, rawsock_create() uses capable() to check CAP_NET_RAW that checks the capability of init_user_ns.
> > 1. // check capable() ////////////////////////////////////
> > 2. static int rawsock_create(struct net *net, struct socket *sock,
> > 3.   const struct nfc_protocol *nfc_proto, int kern) {
> > 4. ...
> > 5.   if (sock->type == SOCK_RAW) {
> > 6.     if (!capable(CAP_NET_RAW))
> > 7.       return -EPERM;
> > 8.     sock->ops = &rawsock_raw_ops;
> > 9.   } else {
> > 10.     sock->ops = &rawsock_ops;
> > 11.   }
> > 12.   sk = sk_alloc(net, PF_NFC, GFP_ATOMIC, nfc_proto->proto, kern);
> > 13. ...
> > 14. }
>
> Indeed, this one should likely use the ns-aware check. Would you mind
> sending a fix? (please make sure you CC the authors of this code,
> folks who touched it most recently and other relevant developers you
> can think of).
>
> > Function xsk_create() checks the capability of net->user_ns before calling sk_alloc().
> > 1. // check ns_capable() ////////////////////////////////////
> > 2. static int xsk_create(struct net *net, struct socket *sock, int protocol,
> > 3.       int kern)
> > 4. {
> > 5.   struct xdp_sock *xs;
> > 6.   struct sock *sk;
> > 7.   if (!ns_capable(net->user_ns, CAP_NET_RAW))
> > 8.     return -EPERM;
> > 9.   if (sock->type != SOCK_RAW)
> > 10.     return -ESOCKTNOSUPPORT;
> > 11.   if (protocol)
> > 12.     return -EPROTONOSUPPORT;
> > 13.   sock->state = SS_UNCONNECTED;
> > 14.   sk = sk_alloc(net, PF_XDP, GFP_KERNEL, &xsk_proto, kern);
> > 15. ...
> > 16. }
> >
> > There is no check before calling sk_alloc().
> > 1. // no check ////////////////////////////////////
> > 2. static struct sock *unix_create1(struct net *net, struct socket *sock, int kern)
> > 3. {
> > 4.   struct sock *sk = NULL;
> > 5.   struct unix_sock *u;
> > 6.   atomic_long_inc(&unix_nr_socks);
> > 7.   if (atomic_long_read(&unix_nr_socks) > 2 * get_max_files())
> > 8.     goto out;
> > 9.   sk = sk_alloc(net, PF_UNIX, GFP_KERNEL, &unix_proto, kern);
> > 10. ...
> > 11. }
>
> I believe this is fine, unix sockets don't really have a meaningful
> notion of raw packets. But please feel free to report this to other
> folks and perhaps CC the netdev@vger.kernel.org<mailto:netdev@vger.kernel.org> mailing list to get
> more eyes on this.
>
> > All these three functions are assigned to the create field of their corresponding struct.
> > 1. static const struct nfc_protocol rawsock_nfc_proto = {
> > 2. ...
> > 3.   .create   = rawsock_create
> > 4. };
> > 5. static const struct net_proto_family xsk_family_ops = {
> > 6. ...
> > 7.   .create = xsk_create,
> > 8. ...
> > 9. };
> > 10. static const struct net_proto_family unix_family_ops = {
> > 11. ...
> > 12.   .create = unix_create,
> > 13. ...
> > 14. };
> > (unix_create => unix_create1)
> >
> > They are used to create sock similarly, especially the last two
> > functions assigned to the same struct type, net_proto_family. Therefore,
> > we believe these functions share the similar functionality. There will
> > be bugs if they use different permission checks or some functions do not
> > have any check.
> >
> > Thanks!
> >
> >
> > Best regards,
> > Jinmeng Zhou

Sorry for the late reply, thanks again!

Best regards,
Jinmeng Zhou
