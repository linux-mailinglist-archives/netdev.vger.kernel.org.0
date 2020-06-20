Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1795202206
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 09:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgFTHBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 03:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbgFTHBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 03:01:47 -0400
Received: from mail-ua1-x943.google.com (mail-ua1-x943.google.com [IPv6:2607:f8b0:4864:20::943])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2F1C06174E
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 00:01:47 -0700 (PDT)
Received: by mail-ua1-x943.google.com with SMTP id b10so3957968uaf.0
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 00:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W7+ROIUihXx4SNkCH4I/lycvys/FkTV0Xt2fR9I4sVQ=;
        b=TdhclfSfzuyud7KqHLVNBzZAhC6gPKO86gJTpO8V85nkPyAbCc5JKLPW+YXRKb9891
         0m2ADiA8GdQsU3cMsLPqK1lwz8vYWt5SlNS2Bft7Dk+GDC2Q0m/muBuZxE3S1a/eT/8L
         5vWMxquqBHIAhBWmy87ebQhNhV0GJ1S/OS3jH9A9ODltl07mXbgMnQxIpJ9FW8JgU00z
         T/73G9LktPDvuOmm/wbfjctWqjHG+9DtWAVvlqKW53/WmlhJr63kOvnlLY5oQDMrHzSm
         0Sa/NxrXbXA+WV2QGvEWO2qYM5iLLctxHkcFtUsDOZXUODZszTi3/jLU69ae3dynXr6f
         dI5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W7+ROIUihXx4SNkCH4I/lycvys/FkTV0Xt2fR9I4sVQ=;
        b=NCAW2cDk6fgqUtyvic+pXlYI6dPhXQbbKSWhCMrngaC3sHy1E8hmlhjCK2KqneJz8c
         jCOXrFtrDiwwpg5U5EszdgKGXKdrL3eAaPEqrNlYdum8DgY/0Fr/1A+BV+mJQ6+/hh+l
         jLYHwc6Xvu2TfjltV5S+CpDekuDaSiw8pqOQzfgl3x485XVJiBIAuFpYcMImcVvGRdOf
         0/2CPDP1rRYVuJQJxboRBfvyZl89x9VLy35d2W9/eOZBolZOUrkZQ5rlsDquELihBNvr
         4UU4hloigaojX8BpIV1DHfz+EgVuzzCRf3YCpwsDORqZe3/ATiFqvLapkCqWUfA0elkd
         CxZw==
X-Gm-Message-State: AOAM533lDMalek/ypQ8pkdMrHxf2CeYz2PRkMhhFqP+aSJvSprPbpQJk
        02dxpnLqFs53SwL1cnRmFBvQifZM4NdZXNXRMl0=
X-Google-Smtp-Source: ABdhPJyRFntbh3a1NEPv2+kHg1kqOWPkyFeEzqGF+CLmHlXnmxM+0WJhaWFRPxBJ2WsZV44/WKDtBdE/yV1AMpvSV/w=
X-Received: by 2002:a9f:3b1c:: with SMTP id i28mr4781313uah.22.1592636506303;
 Sat, 20 Jun 2020 00:01:46 -0700 (PDT)
MIME-Version: 1.0
References: <74266291a0aba929919f71ff3dbd1c36392bb4c4.1592567032.git.lorenzo@kernel.org>
In-Reply-To: <74266291a0aba929919f71ff3dbd1c36392bb4c4.1592567032.git.lorenzo@kernel.org>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Sat, 20 Jun 2020 00:01:35 -0700
Message-ID: <CAOrHB_B2GO51hRy_kj3kdJKrFURFbKubhGvanLKCRHDc9DKeyg@mail.gmail.com>
Subject: Re: [PATCH net] openvswitch: take into account de-fragmentation in execute_check_pkt_len
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Numan Siddique <nusiddiq@redhat.com>,
        Greg Rose <gvrose8192@gmail.com>, lorenzo.bianconi@redhat.com,
        ovs dev <dev@openvswitch.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 4:48 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> ovs connection tracking module performs de-fragmentation on incoming
> fragmented traffic. Take info account if traffic has been de-fragmented
> in execute_check_pkt_len action otherwise we will perform the wrong
> nested action considering the original packet size. This issue typically
> occurs if ovs-vswitchd adds a rule in the pipeline that requires connection
> tracking (e.g. OVN stateful ACLs) before execute_check_pkt_len action.
>
> Fixes: 4d5ec89fc8d14 ("net: openvswitch: Add a new action check_pkt_len")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  net/openvswitch/actions.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> index fc0efd8833c8..9f4dd64e53bb 100644
> --- a/net/openvswitch/actions.c
> +++ b/net/openvswitch/actions.c
> @@ -1169,9 +1169,10 @@ static int execute_check_pkt_len(struct datapath *dp, struct sk_buff *skb,
>                                  struct sw_flow_key *key,
>                                  const struct nlattr *attr, bool last)
>  {
> +       struct ovs_skb_cb *ovs_cb = OVS_CB(skb);
>         const struct nlattr *actions, *cpl_arg;
>         const struct check_pkt_len_arg *arg;
> -       int rem = nla_len(attr);
> +       int len, rem = nla_len(attr);
>         bool clone_flow_key;
>
>         /* The first netlink attribute in 'attr' is always
> @@ -1180,7 +1181,8 @@ static int execute_check_pkt_len(struct datapath *dp, struct sk_buff *skb,
>         cpl_arg = nla_data(attr);
>         arg = nla_data(cpl_arg);
>
> -       if (skb->len <= arg->pkt_len) {
> +       len = ovs_cb->mru ? ovs_cb->mru : skb->len;
> +       if (len <= arg->pkt_len) {

We could also check for the segmented packet and use  segment length
for this check.
