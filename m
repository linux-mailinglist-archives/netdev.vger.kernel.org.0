Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A060A413BD0
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 22:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234764AbhIUU4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 16:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232145AbhIUU4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 16:56:24 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5020CC061574;
        Tue, 21 Sep 2021 13:54:55 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id e16so520367qte.13;
        Tue, 21 Sep 2021 13:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CBgQKC9x3rXx8bnqetO+LnWZKEtCE6w8tfs7wyWJx7w=;
        b=YPqoDdqDfCjvZs3JJP+x8EjpCrPr+EMAZvW7DXyuPI3rbQ5iVhlijMWmP0expCQu1/
         tOLqU62XU+ZF0Zf/lbVoX6O53r8WWwm/cBgDI5NQFlbwF+RsMZ02LSzIBhCym+Davc3o
         +tuttL942BVeuI0mdVo0kwc+g4u5Opj7T9kfOsp1pL5YlHM80mJqGqN0lLP/zJhmSsHd
         edGCBzQD1dbECYO9lSsXJhH4PxknevM3KhC9EygBWIQe4ynvrvZtfUQELObly9OH6oNm
         g1auJHQl2BwOcrwDs27pfbq3vKs/SDg6JBXdmHv7mUZhVfYp081r1nnn4lzpHdg3qRKK
         IXOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CBgQKC9x3rXx8bnqetO+LnWZKEtCE6w8tfs7wyWJx7w=;
        b=aLLTEqEtri6MtFg1THov5SgwxNuwMjd/9FX3VC69+r059NhNzKrm1VxYQahT+LTXpC
         pTUonOpUx3dcj4a/Pep0FsM4foexfRZdXZCpVIQ0/WCuegK5TW+qhKCkGipT/pw72CC5
         6lW23ccWiwylTekRfsOd0OtFWi1G8ixYRsH/m1MsCmKlqinTBb3VYb1Yuu/7O+t5pM0j
         Dp53nwRY4Y4N4/a4xNeQBgWB000reydfqdzDzyn+gIgcnqGAnUhUOyMynZVxXF1ILeUJ
         o8ErHctdepfcOP2e8cSEyIjLQERz0pF/+ImpKSLCjs5pHP06XeA5zL4P2V3R6d/Fmw8A
         GkjA==
X-Gm-Message-State: AOAM5324IQWcH4EfacDE7iuk3m7wXQqRI1cjxkecI7wjCq5M0RTULnSo
        RFqvvKeuVulsxbj0hkqzdNdqroVAaEIOSqYqeXNit7kz
X-Google-Smtp-Source: ABdhPJzTe5g2s442wLcm99KHCG8zwygAlImSC0uT8GQnEznD3GgsaLJaFtoLK5dTehDhMkisJuKf5qnE5UUbFUDn1QU=
X-Received: by 2002:ac8:1e93:: with SMTP id c19mr30257615qtm.55.1632257694568;
 Tue, 21 Sep 2021 13:54:54 -0700 (PDT)
MIME-Version: 1.0
References: <1631867098-3891002-1-git-send-email-jiasheng@iscas.ac.cn>
In-Reply-To: <1631867098-3891002-1-git-send-email-jiasheng@iscas.ac.cn>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Tue, 21 Sep 2021 13:54:43 -0700
Message-ID: <CAOrHB_BjF-MKEAnCr4OtTEFZppKM9H5kHj2bh6SnggeCQGm5cw@mail.gmail.com>
Subject: Re: [PATCH 2/2] openvswitch: Fix condition check in
 output_userspace() by using nla_ok()
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 17, 2021 at 1:25 AM Jiasheng Jiang <jiasheng@iscas.ac.cn> wrote:
>
> Just using 'rem > 0' might be unsafe, so it's better
> to use the nla_ok() instead.
> Because we can see from the nla_next() that
> '*remaining' might be smaller than 'totlen'. And nla_ok()
> will avoid it happening.
> For example, ovs_dp_process_packet() -> ovs_execute_actions()
> -> do_execute_actions() -> output_userspace(), and attr comes
> from OVS_CB(skb)->input_vport,which restores the received packet
> from the user space.
>
> Fixes: ccb1352e76cff0524e7ccb2074826a092dd13016
> ('net: Add Open vSwitch kernel components.')
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>

> ---
>  net/openvswitch/actions.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> index c23537f..e8236dd 100644
> --- a/net/openvswitch/actions.c
> +++ b/net/openvswitch/actions.c
> @@ -915,8 +915,7 @@ static int output_userspace(struct datapath *dp, struct sk_buff *skb,
>         upcall.cmd = OVS_PACKET_CMD_ACTION;
>         upcall.mru = OVS_CB(skb)->mru;
>
> -       for (a = nla_data(attr), rem = nla_len(attr); rem > 0;
> -            a = nla_next(a, &rem)) {
> +       nla_for_each_nested(a, attr, rem) {
>                 switch (nla_type(a)) {
>                 case OVS_USERSPACE_ATTR_USERDATA:
>                         upcall.userdata = a;

These nl-attributes are built and verified at time of OVS flow
install, so the rest of checks in nla_ok, is not required.
