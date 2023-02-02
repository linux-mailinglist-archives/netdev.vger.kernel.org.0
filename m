Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A456687E53
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 14:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbjBBNLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 08:11:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjBBNLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 08:11:54 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4888C1C2;
        Thu,  2 Feb 2023 05:11:48 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id qw12so5860621ejc.2;
        Thu, 02 Feb 2023 05:11:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=a+cCNsETz45YshQhIXFqkY19MDAG9vwzg6TDida0acI=;
        b=FDvJZDzGsgAEMjCpCqlqBT+PBl4a2blZbOek7/96cShN4m9VVf8llxb4QL91Q2pREM
         IZwYiBAF8Va8EKeZYQqwWF/P2izfpuHDvAMJCnbeR3Sz101I+OyLJGiQpeVnSwDlnzDw
         q/nwcIkSRIQZaWeopYQeSb9MH+OqsFO9jg7kJBZhMOm3qV6IuGEgUgvLFAtuf0SMJPQR
         umCYMBYnLJ4iLwx7HEWba+Y8wF8RrL0ZjbK+gEYMj82Q3M1CLrBYaQyEXpLFiIH0yQ9R
         beFI4wX3Eb64ocRKgbd2Oaba9NFGzek6sR2+pIk2RTZAYwNUJn6lPSPddXeR13scxzhk
         ty5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a+cCNsETz45YshQhIXFqkY19MDAG9vwzg6TDida0acI=;
        b=voUcLJ/WXy/N2vYcASG5yuxseTGFghtakwPG5i/iqIG1E3rBwQQPlkgxdZMeTq1RT7
         Sec3sCMAqcc9LVLbOVX00kJ5D70UGBp5Tw4ZcEEIE/zFSxnJKcaL0CEuMcAVozmAig/E
         nE+76bDahxSJ9NF8qn4ko2d1paF9kBho2duiNvuAYoj+jFcSABdZPxo6D5dYDmhtBJR3
         +A0pUT3fYvUcL1xgT+KjaUHdd5c8LVWMEXK5gE4/1HHd7XgNJCOVq7fdL1i02Lr/hyoy
         2wWrSOJo58saCrG2Z69Eluj6qys0hT3DujKKtssulFiw0kbxAvI5/xxIeLtF72vqe0/G
         HWBg==
X-Gm-Message-State: AO0yUKWwoCjWqAT/xk2gWM8y7GcsLzDsfOX4RIFAKsC+0Z5sIzneRZqz
        hMxSyRurc/DJLeUs3oyr2oOJRWa3H3cdvr6r0K4=
X-Google-Smtp-Source: AK7set9hD1sKrfL/oqG07C+GcTpdhn1+P/ka9gwI6H5WuilXBISkfu4T376/iB14fVp+Mh1YUyv8+OJ4heqzUo3pa44=
X-Received: by 2002:a17:906:8395:b0:888:f761:87aa with SMTP id
 p21-20020a170906839500b00888f76187aamr2079361ejx.163.1675343506695; Thu, 02
 Feb 2023 05:11:46 -0800 (PST)
MIME-Version: 1.0
References: <20230127122018.2839-1-kerneljasonxing@gmail.com>
 <Y9fdRqHp7sVFYbr6@boxer> <CAL+tcoBbUKO5Y_dOjZWa4iQyK2C2O76QOLtJ+dFQgr_cpqSiyQ@mail.gmail.com>
 <192d7154-78a6-e7a0-2810-109b864bbb4f@intel.com> <CAL+tcoBtQSeGi5diwUeg1LryYsB2wDg1ow19F2eApjh7hYbcsA@mail.gmail.com>
 <af77ad0e-fde7-25da-dc3f-5d19133addba@intel.com>
In-Reply-To: <af77ad0e-fde7-25da-dc3f-5d19133addba@intel.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Thu, 2 Feb 2023 21:11:10 +0800
Message-ID: <CAL+tcoCXFtTATi_=h5Yoh3DUx4NeTDG4SexA=0HP8z99TkipLA@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH v2 net] ixgbe: allow to increase MTU to
 some extent with XDP enabled
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, bpf@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 1, 2023 at 7:15 PM Alexander Lobakin
<alexandr.lobakin@intel.com> wrote:
>
> From: Jason Xing <kerneljasonxing@gmail.com>
> Date: Tue, 31 Jan 2023 19:23:59 +0800
>
> > On Tue, Jan 31, 2023 at 7:08 PM Alexander Lobakin
> > <alexandr.lobakin@intel.com> wrote:
>
> [...]
>
> >>>> You said in this thread that you've done several tests - what were they?
> >>>
> >>> Tests against XDP are running on the server side when MTU varies from
> >>> 1500 to 3050 (not including ETH_HLEN, ETH_FCS_LEN and VLAN_HLEN) for a
> >>
> >
> >> BTW, if ixgbe allows you to set MTU of 3050, it needs to be fixed. Intel
> >> drivers at some point didn't include the second VLAN tag into account,
> >
> > Yes, I noticed that.
> >
> > It should be like "int new_frame_size = new_mtu + ETH_HLEN +
> > ETH_FCS_LEN + (VLAN_HLEN * 2)" instead of only one VLAN_HLEN, which is
> > used to compute real size in ixgbe_change_mtu() function.
> > I'm wondering if I could submit another patch to fix the issue you
> > mentioned because the current patch tells a different issue. Does it
> > make sense?
>
> Yes, please send as a separate patch. It's somewhat related to the
> topic, but better to keep commits atomic.

Hi Alexander,

I'm not sure if I should wait for the current patch to get reviewed,
then I'll write the vlan related patch we talked about based on the
current patch?

Thanks,
Jason

>
> >
> > If you're available, please help me review the v3 patch I've already
> > sent to the mailing-list. Thanks anyway.
> > The Link is https://lore.kernel.org/lkml/20230131032357.34029-1-kerneljasonxing@gmail.com/
> > .
> >
> > Thanks,
> > Jason
>
> Thanks,
> Olek
>
