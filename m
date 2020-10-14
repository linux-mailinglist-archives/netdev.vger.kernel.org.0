Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 993D928DC02
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 10:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbgJNIv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 04:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbgJNIv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 04:51:28 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0593EC051112
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 01:51:28 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g29so1548576pgl.2
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 01:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OiPR0i7+wHa3QUqS6uCBEBHCDiuSZkDII6U43bi3Hn4=;
        b=Bng59V9rHlvOPKnbAF3jluT3TopuhgEKCPkUvAH9gkDTNNIuwO1ei1iLnviBrvZ7am
         m5M61QV7szTe5KaEknPkXStIVtq8xvgFr43B8IBWOjGRwPfVnS5b+QXppfTbUjg9bWoT
         ppIei5MWGy2xMorRRUNYFLLvX9OglXMxf1mQw+AblKvrBuBv1bx9iUz3K4AlrZxSNVOB
         iPr9X3ZCAUq92TLpV3wIQWrPzrfRQ/3EfXwhUVBpYWHoxZGJtSW3swopwCkKOD/v10U3
         qn21dUULELBXwxr2pb6WFVZarnXl/7huuA9o/Wf2jwlODttL2jpygi9/ZK/5UKFu3V2z
         GfKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OiPR0i7+wHa3QUqS6uCBEBHCDiuSZkDII6U43bi3Hn4=;
        b=jvXb+jKNofGOeTHOyTgmYT0EiIRqEXwgsefWHZAK8dNoVpnaflY21swr2xyNys8GWa
         C71yNifxv75bPyuglCx91vmcxgPLyIMWYOqPIdabG5W0ZgnmglT074xbu+Nu0lYPk9ki
         H+VZRmpmE2nCjco5l7Scf5REbj667swe8jK5oV+7zIWIz6UzBWiyoBbLL5iqhw4ZKdzJ
         NyF9u/ylG3dMmYhkwTjSn3pQVyUaMwa1gcZMUxCxrZAchU4dDsFDqFHpkCFR79FwiUuo
         pFhG1WNwl6Ve+VDLVJwc+gAAj/vL8y1cXo8SO6L4O5ldfORiu287ivKEIf2fH9JtRWYo
         1TbQ==
X-Gm-Message-State: AOAM533BKKPiHtscjA2RvTxpP15fJQBlMu2etety/POF+q2d7E4IqjM7
        i73d1Qa/flE7XrrwwjBP5zWp/wjDHgb1VO27K1LQFiVHC2Q=
X-Google-Smtp-Source: ABdhPJw4JyL8Wk/k4WmWTqDXq2NeUuRYwj0TqRUfi7m2wixAmjekRsxg8WmwGR4dUcHkZmqrnQ1NlafLq6kQ3P/vYmA=
X-Received: by 2002:a63:7347:: with SMTP id d7mr3142759pgn.63.1602665487471;
 Wed, 14 Oct 2020 01:51:27 -0700 (PDT)
MIME-Version: 1.0
References: <20201011191129.991-1-xiyou.wangcong@gmail.com> <CA+FuTSfeTWBpOp+ZCBMBQPqcPUAhZcAv2unwMLqgGt_x_PkrqA@mail.gmail.com>
In-Reply-To: <CA+FuTSfeTWBpOp+ZCBMBQPqcPUAhZcAv2unwMLqgGt_x_PkrqA@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Wed, 14 Oct 2020 01:51:16 -0700
Message-ID: <CAJht_EM7KW1+sXpv2PZXwJuECuzDS7knEGGA9k6hogoPSDgW_g@mail.gmail.com>
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

On Sun, Oct 11, 2020 at 2:01 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> There is agreement that hard_header_len should be the length of link
> layer headers visible to the upper layers, needed_headroom the
> additional room required for headers that are not exposed, i.e., those
> pushed inside ndo_start_xmit.
>
> The link layer header length also has to agree with the interface
> hardware type (ARPHRD_..).
>
> Tunnel devices have not always been consistent in this, but today
> "bare" ip tunnel devices without additional headers (ipip, sit, ..) do
> match this and advertise 0 byte hard_header_len. Bareudp, vxlan and
> geneve also conform to this. Known exception that probably needs to be
> addressed is sit, which still advertises LL_MAX_HEADER and so has
> exposed quite a few syzkaller issues. Side note, it is not entirely
> clear to me what sets ARPHRD_TUNNEL et al apart from ARPHRD_NONE and
> why they are needed.
>
> GRE devices advertise ARPHRD_IPGRE and GRETAP advertise ARPHRD_ETHER.
> The second makes sense, as it appears as an Ethernet device. The first
> should match "bare" ip tunnel devices, if following the above logic.
> Indeed, this is what commit e271c7b4420d ("gre: do not keep the GRE
> header around in collect medata mode") implements. It changes
> dev->type to ARPHRD_NONE in collect_md mode.
>
> Some of the inconsistency comes from the various modes of the GRE
> driver. Which brings us to ipgre_header_ops. It is set only in two
> special cases.
>
> Commit 6a5f44d7a048 ("[IPV4] ip_gre: sendto/recvfrom NBMA address")
> added ipgre_header_ops.parse to be able to receive the inner ip source
> address with PF_PACKET recvfrom. And apparently relies on
> ipgre_header_ops.create to be able to set an address, which implies
> SOCK_DGRAM.
>
> The other special case, CONFIG_NET_IPGRE_BROADCAST, predates git. Its
> implementation starts with the beautiful comment "/* Nice toy.
> Unfortunately, useless in real life :-)". From the rest of that
> detailed comment, it is not clear to me why it would need to expose
> the headers. The example does not use packet sockets.
>
> A packet socket cannot know devices details such as which configurable
> mode a device may be in. And different modes conflict with the basic
> rule that for a given well defined link layer type, i.e., dev->type,
> header length can be expected to be consistent. In an ideal world
> these exceptions would not exist, therefore.
>
> Unfortunately, this is legacy behavior that will have to continue to
> be supported.

Thanks for your explanation. So header_ops for GRE devices is only
used in 2 special situations. In normal situations, header_ops is not
used for GRE devices. And we consider not using header_ops should be
the ideal arrangement for GRE devices.

Can we create a new dev->type (like ARPHRD_IPGRE_SPECIAL) for GRE
devices that use header_ops? I guess changing dev->type will not
affect the interface to the user space? This way we can solve the
problem of the same dev->type having different hard_header_len values.

Also, for the second special situation, if there's no obvious reason
to use header_ops, maybe we can consider removing header_ops for this
situation.
