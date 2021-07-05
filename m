Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3793BBC57
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 13:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbhGELrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 07:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbhGELrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 07:47:06 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B519EC061574;
        Mon,  5 Jul 2021 04:44:28 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id e14so5785379qkl.9;
        Mon, 05 Jul 2021 04:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y5GEj+8326+PbDDr2Nykyt3XrIRloqp5T0iaY8wvCN4=;
        b=G24fJESmPH7nMdQIwUF+gb58lyy7jFnZXRymXctn3VclV53TwK3vCHPmR/+fy1Xiyk
         dZrcbk1TXH/kk/UA+a6WCEsgPASxBYuaz82UQSBuNNgO+iio+ACdlfpBBU26QLIoGjiI
         dbu9d3RBTrQrDstdev67/pEn1BoL9D3wfA60ghspnb4O0cloQ6Lu5Nx3hcx5XPiNqVdG
         G1kWJSPXzWx+JdAwMj8CJMlsKRrq5z5PZGjgbBg2tbavl4CVvYtS97LWempUSqoPmSw1
         SBQZ0JnrwvvEbuVxaTvRqXLfh1+udw7lUA471drIw9XIQUJyqgWMW+v9BN+R8xSHkR7W
         BMzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y5GEj+8326+PbDDr2Nykyt3XrIRloqp5T0iaY8wvCN4=;
        b=pHrFsn9iQH3l0+h/oyKuMPc6349fuzAYYO/ycW3ipASxQR6Q6wqcyQNdXi+oauZuuI
         a3PhMP1NvbY2aR+x9J7GFVQV/Rh9cN4117YL11SV3S0gO12deQJSon3/jyDCEb1Tt0hO
         ZHr4tEkO6irBit1S9285WolQ9jJDK+6XIGJMhjDP9ofoHLnBQ4pHt90dvfi6kM0a7+qP
         5+agLZzynULyF93VkJKV3Dv16ed80BRX1g0KjpJBJG2yEqgTfdsenJcjkTrwr4q+XELj
         0UbliqZ/ZaHF9Ui6CcK7JmfUOSSFVj7t+l7y51vKngHVrFv+EkZTTcEspM3pfErZm2eC
         I6XQ==
X-Gm-Message-State: AOAM5327HD9S1yDVMjyci+wd2Aj7thO2VhlnYAYhNbmjQbRR3BKZu6WT
        zb/LYSLkFC/vINCFf2fnxJyNDUVgKOZO7o1Ctw==
X-Google-Smtp-Source: ABdhPJzzvfN9ja3xrr+zfs22ZbMSe98belDpsaJbzFRIfwLcqhb3FwVgOTTioY6zAgoIuzsz2uwHW9CofOuY+gGxr0E=
X-Received: by 2002:a05:620a:17a5:: with SMTP id ay37mr13801980qkb.465.1625485467815;
 Mon, 05 Jul 2021 04:44:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210609135537.1460244-1-joamaki@gmail.com> <20210624091843.5151-1-joamaki@gmail.com>
 <20210624091843.5151-5-joamaki@gmail.com> <31210.1625163167@famine>
In-Reply-To: <31210.1625163167@famine>
From:   Jussi Maki <joamaki@gmail.com>
Date:   Mon, 5 Jul 2021 14:44:16 +0300
Message-ID: <CAHn8xcmkDz9DG_s_6G9osakb5QD9O3AE46PfZTeAyi12h_s5rQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/4] devmap: Exclude XDP broadcast to master device
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andy Gospodarek <andy@greyhouse.net>, vfalico@gmail.com,
        Andrii Nakryiko <andrii@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 1, 2021 at 9:12 PM Jay Vosburgh <jay.vosburgh@canonical.com> wrote:
> >+      if (static_branch_unlikely(&bpf_master_redirect_enabled_key)) {
> >+              struct net_device *master = netdev_master_upper_dev_get_rcu(dev_rx);
> >+
> >+              exclude_ifindex_master = (master && exclude_ingress) ? master->ifindex : 0;
> >+      }
> >+
>
>         Will the above logic do what is intended if the device stacking
> isn't a simple bond -> ethX arrangement?  I.e., bond -> VLAN.?? -> ethX
> or perhaps even bondA -> VLAN.?? -> bondB -> ethX ?

Good point. "bond -> VLAN -> eth" isn't an issue currently as vlan
devices do not support XDP. "bondA -> bondB -> ethX" however would be
supported, so I think it makes sense to change the code to collect all
upper devices and exclude them. I'll try to follow up with an updated
patch for this soon.
