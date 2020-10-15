Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F234B28F958
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 21:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731385AbgJOTTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 15:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731307AbgJOTTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 15:19:19 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA41C061755
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 12:19:19 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id b19so2163844pld.0
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 12:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=no5am6odifkah69bJodn/41MZdd8H5a26iXHPbcA3d4=;
        b=HAYyJT3FrfDqn7nkJXuhBIgq4dyuU6rLaCk4+If65GaLk2MQXVEnmWhq2i4nltDUj3
         y2XV+10KQBsAmDMGEvXbmfokoaOzdsS5gGRdfE7pH+qS8zx16C0/rp85CdZg8IONmr2o
         5GTbCskJ/malBHutlEY2rVEsPJBvg/3rfFmw7QwiTRk8ruxKNe/vAlRF+V7955ktX7hC
         qzfmJcDpQysyArGaOzbnaNIqtGK6NH9QFvLIHSigHSSFni0i2BQwBGacPi2lCrVEYYt4
         71SYLPlVZN6sFvP0M23//cvAZmh1jqsFfpdYvESmWM5X58cMcPqHjX3DHRkdNEtembpF
         jc4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=no5am6odifkah69bJodn/41MZdd8H5a26iXHPbcA3d4=;
        b=NOVttvTcyV7NolwV5/oFWqNVnMoobidxqNX38C6+v3Qnb6sE0DLB9PwhuQ8ihkmBHj
         c0HiS5tE6TE67G0t9HFXjYHfU1//vfAfJmcBSHQcjMGsH6uSA/vg3P/ey8pWkerE5R8F
         tFpW8u3yxMpf1BnHpMHBpQMZA3m+NLfi4VIF7oXcKJr78C6w4TMAWoyjdI1brxjtlAYr
         nBR7T1+Nu9mLoz8c506SaoRc/i3ln/8Hfdh1MHWfsaU/g9fhZyJiE9OhXNim8CtPwEvm
         kp7+56DeYr7bO8vDRhg6+QhRAa32tZOHAaNAS9veCq1XyZIlw69bwfGSyeqQrkldQCWs
         rG2w==
X-Gm-Message-State: AOAM5321va7B0wMP1I4sfk7yIjWhskarfO2UOb0sjnAwuf7TWHeoTZPa
        fFFXFMd4DdGTXkdZ/D48KsyOHSdr4Sv0oDCtB/dBsEEHRNA=
X-Google-Smtp-Source: ABdhPJyHGO1ui4AaHFL6nheLjUkRmNnbaibdkekjmh21EPJhMPf4fHQbNyfzZ2tHT4nJSXT8cRCizqp/4aTTJfyrvbs=
X-Received: by 2002:a17:90a:aa91:: with SMTP id l17mr197915pjq.198.1602789558793;
 Thu, 15 Oct 2020 12:19:18 -0700 (PDT)
MIME-Version: 1.0
References: <20201011191129.991-1-xiyou.wangcong@gmail.com>
 <CA+FuTSfeTWBpOp+ZCBMBQPqcPUAhZcAv2unwMLqgGt_x_PkrqA@mail.gmail.com>
 <CAJht_EM7KW1+sXpv2PZXwJuECuzDS7knEGGA9k6hogoPSDgW_g@mail.gmail.com>
 <CA+FuTScUwbuxJ-bed+5s_KVXMTj_com+K438hM61zaOp9Muvkg@mail.gmail.com>
 <CAJht_ENhobjCkQmKBB6DtZkx599F3dQyHA4i43=SDSzNkWPLgQ@mail.gmail.com>
 <CA+FuTSd=54S48QXk3-3CBeSdj8L3DAnRRE6LLmeXaN1kUq-_ww@mail.gmail.com>
 <CAJht_EPFCTjv6JAMWFgCdgYpwfEVYB9_r0HaiKUTwekEiPnoDg@mail.gmail.com>
 <CAJht_EN2f=3fwjsW5GcXEAZJuJ934HFVAwxBFff-FAT17a=64w@mail.gmail.com> <CA+FuTSf+7fwJHBMog4wiGRmhD32qfdGVhnOarA9jpdeti822xw@mail.gmail.com>
In-Reply-To: <CA+FuTSf+7fwJHBMog4wiGRmhD32qfdGVhnOarA9jpdeti822xw@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 15 Oct 2020 12:19:07 -0700
Message-ID: <CAJht_EOP3_+R-6_SNZHM9scOO2aWhz1TjFs-0jZbjqBYBiHZ-Q@mail.gmail.com>
Subject: Re: [Patch net v2] ip_gre: set dev->hard_header_len and
 dev->needed_headroom properly
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 6:42 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Wed, Oct 14, 2020 at 10:25 PM Xie He <xie.he.0141@gmail.com> wrote:
> >
> > Actually I think dev->type can be seen from user space. For example,
> > when you type "ip link", it will display the link type for you. So I
> > think it is useful to keep different dev->type labels without merging
> > them even if they appear to have no difference.
>
> Ah, indeed. These constants are matched in iproute2 in lib/ll_types.c
> to string representations.
>
> Good catch. Yes, then they have to stay as is.

So in this case it may be better to keep dev->type as ARHPHRD_IPGRE
for GRE devices with or without header_ops. This way we can avoid the
need to update iproute2.

We can still consider changing GRE devices in collect_md mode from
ARPHRD_NONE to ARHPHRD_IPGRE. The original author who changed it to
ARPHRD_NONE might assume ARHPHRD_IPGRE is for GRE devices with
header_ops, so he felt he needed to distinguish GRE devices without
header_ops by dev->type. However, ARHPHRD_IPGRE is actually already
used for GRE devices with header_ops AND without header_ops. So it
doesn't hurt to use ARHPHRD_IPGRE for GRE devices in collect_md mode,
too. This would also make iproute2 to correctly display GRE devices in
collect_md mode as GRE devices.
