Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2982F0D93
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 09:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbhAKIDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 03:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbhAKIDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 03:03:03 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88B3C061786
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 00:02:22 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id c79so10470551pfc.2
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 00:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=alDRsu6NlO2Ir90sx/ABNukkaVAVh5t/9lrif/E0YC8=;
        b=XcP/GfduYXDO7NVqqE20nG/KKUHbPiYUnVwXcT7n/ZmCCDMqnFyaQ0e6SHtWUI1VzQ
         /FV9Erxl/IfhHoiLEgrbw4aWbLOQEjrRZlSMvo0qkqsNbeOLLYhfNlbYBk4QzTzfZMBW
         pr3fG++1XrC9Q7Du7o5bxPvQC1xB38+lnHuBZwIcC02zM7YvomvSoVGRqArM2eFyvl35
         yFP2+5R7teAvHWhx+10sHeVIbKCdpUN2f49mXmYr9Sk4CSbLKuNOcVPply8Xe/o5oBxU
         0b8Ng6xbkfjE+RZt08ZkOKzXylXiQEs+tihx5Ev5g7flklVxo2vKRR6oFEA4LJiAcnEw
         XYWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=alDRsu6NlO2Ir90sx/ABNukkaVAVh5t/9lrif/E0YC8=;
        b=RI6sL/Wd7sWxFPKBwzpeabl52dQi6vL1AbVqdq+hltqjZ/AYTdjQHdurzVes0is6UQ
         24NEcqkP9tlF9a5KdwUI1xzc5Iek1fiS2NhoW2/maaEtd8qoMdVc0qe1Fw2ypkQ4Oa5k
         sPUYSZSz0AEETT0dsYh8DANieNFYUnO6C2J5X3VMCGMV5b/uaMeTiMMtbColcaGJpHBU
         e/kUgbpA/1PVg8lr/BXjum8O5015naWeBWvohXWMaC3jO592LZkEGPGa/6j4nRubkzbp
         jX+UzqQPebq3lqpTS2Ke8GQyzUtqP6u5ET6WFsv7u+2u1M0oF1LtD29lGD8RMqLJBh9n
         lazQ==
X-Gm-Message-State: AOAM532SxD2A3yN0VAxDiwgInVRDEjMH4p+XeQRRfngZH28rQ6laiLMD
        2DwR5oymFfQEWxXqRGdDDf0GyoUJqfl97loBLGg=
X-Google-Smtp-Source: ABdhPJw8vlvb+zMKJfQKIQwPE+nnhTUCKMlEg6ga+N/znaVYe+tDYZX/3RDGbtRu/65jBSKjNHAaYADP9LgZc2Pl2Rg=
X-Received: by 2002:a62:2e86:0:b029:1a6:5f94:2cb with SMTP id
 u128-20020a622e860000b02901a65f9402cbmr18532955pfu.19.1610352142332; Mon, 11
 Jan 2021 00:02:22 -0800 (PST)
MIME-Version: 1.0
References: <1609757998.875103-1-xuanzhuo@linux.alibaba.com> <741209d2a42d46ebdb8249caaef7531f5ad8fa76.camel@kernel.org>
In-Reply-To: <741209d2a42d46ebdb8249caaef7531f5ad8fa76.camel@kernel.org>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 11 Jan 2021 09:02:11 +0100
Message-ID: <CAJ8uoz0xkGUd6V9-+x6pfMoqz0UjhkSBWz-dBChi=eNGM2cS4w@mail.gmail.com>
Subject: Re: mlx5 error when the skb linear space is empty
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 5, 2021 at 9:51 PM Saeed Mahameed <saeed@kernel.org> wrote:
>
> On Mon, 2021-01-04 at 18:59 +0800, Xuan Zhuo wrote:
> > hi
> >
> > In the process of developing xdp socket, we tried to directly use
> > page to
> > construct skb directly, to avoid data copy. And the MAC information
> > is also in
> > the page, which caused the linear space of skb to be empty. In this
> > case, I
> > encountered a problem :
> >
> > mlx5_core 0000:3b:00.1 eth1: Error cqe on cqn 0x817, ci 0x8, qn
> > 0x1dbb, opcode 0xd, syndrome 0x1, vendor syndrome 0x68
> > 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 00000030: 00 00 00 00 60 10 68 01 0a 00 1d bb 00 0f 9f d2
> > WQE DUMP: WQ size 1024 WQ cur size 0, WQE index 0xf, len: 64
> > 00000000: 00 00 0f 0a 00 1d bb 03 00 00 00 08 00 00 00 00
> > 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 00000020: 00 00 00 2b 00 08 00 00 00 00 00 05 9e e3 08 00
> > 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > mlx5_core 0000:3b:00.1 eth1: ERR CQE on SQ: 0x1dbb
> >
> >
> > And when I try to copy only the mac address into the linear space of
> > skb, the
> > other parts are still placed in the page. When constructing skb in
> > this way, I
> > found that although the data can be sent successfully, the sending
> > performance
> > is relatively poor!!
> >
>
> Hi,
>
> This is an expected behavior of ConnectX4-LX, ConnectX4-LX requires the
> driver to copy at least the L2 headers into the linear part, in some
> DCB/DSCP configuration it will require L3 headers.

Do I understand this correctly if I say whatever is calling
ndo_start_xmit has to make sure at least the L2 headers is in the
linear part of the skb? If Xuan does not do this, the ConnectX4 driver
crashes, but if he does, it works. So from an ndo_start_xmit interface
perspective, what is the requirement of an skb that is passed to it?
Do all users of ndo_start_xmit make sure the L2 header is in the
linear part, or are there users that do not make sure this is the
case? Judging from the ConnectX5 code it seems that the latter is
possible (since it has code to deal with this), but from the
ConnectX4, it seems like the former is true (since it does not copy
the L2 headers into the linear part as far as I can see). Sorry for my
confusion, but I think it is important to get some clarity here as it
will decide if Xuan's patch is a good idea or not in its current form.

Thank you.

> to check what the current configuration, you can check from the driver
> code:
> mlx5e_calc_min_inline() // Calculates the minimum required headers to
> copy to linear part per packet
>
> and sq->min_inline_mode; stores the minimum required by the FW.
>
> This "must copy" requirement doesn't exist for ConnectX5 and above ..

What is the

> > I would like to ask, is there any way to solve this problem?
> >
> > dev info:
> >     driver: mlx5_core
> >     version: 5.10.0+
> >     firmware-version: 14.21.2328 (MT_2470112034)
> >     expansion-rom-version:
> >     bus-info: 0000:3b:00.0
> >     supports-statistics: yes
> >     supports-test: yes
> >     supports-eeprom-access: no
> >     supports-register-dump: no
> >     supports-priv-flags: yes
> >
> >
> >
> >
>
