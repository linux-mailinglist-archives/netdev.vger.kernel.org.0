Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 383A728AAD5
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 00:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387615AbgJKWEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 18:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387413AbgJKWEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 18:04:05 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E872EC0613CE
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 15:04:04 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id b19so7473337pld.0
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 15:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DGt2LH96Kxq88DfPlUf+pj+CJbLE0qinnhOXNZj4TL4=;
        b=UFqnwS7wYdBe/oMjOCTBgDEg8vTuxxHwN1nypqTJXJwjlg85Van3l8HnwnAAOAyPU9
         HkbsAOaYhFUSc/6xkyeycXI/NtCq9a0CqwoNlVIC8259C8HeK4AE8hHM0tMKC5sYCBgc
         pwEWHtMe2pQbvtE4tsq+raU9zghEUwh6IzmeWh77vkZ8a6Szm5+XQKcWdNNcCIbS3702
         YmYwFk5oOMujGvplR/3M4zD0hkWoRPdQ6qqMg4ykW9Ai+xqrdX5Y8J36k+IR89/euxDZ
         E7lW2O2tZSWLKh2988X4CvziEcWbOgdFb6AYv1SoyBbVxM9D/x5Kmp3+BytWPUj/9E0B
         VFGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DGt2LH96Kxq88DfPlUf+pj+CJbLE0qinnhOXNZj4TL4=;
        b=qxl76GlIR7AKLIk3qAVuryN6bSOA5ZLPjWsvIUykgj3QD6bR3UVA7ePPY9iWfM2Bxc
         vILMe57NLh/VFxBksmz1QVtocZ6C0zoouXa0wh6cSy+71nSx0nL69XEzFO792+R/j8d7
         +WqJLC+UKtdjkdPYZ1WcHrRxSpm2Jt4nsKCv7dplWy0tY+EIbpIutTbp8vtVHxCtIw5R
         2MH5KMXxuKcKA8wtC6vxo33TfLWaxppU2cCt+S37OjEAAXG3b1RnJfl0PeLTlLAx1ifs
         bAgdKQq+tIPiFYFPprUEYyMLDpGj0O5FLyXlBC5593TAXLt8SuF1VTHp4Mt8i4ayOg4j
         6dMQ==
X-Gm-Message-State: AOAM530Yf3nPHAYqALvrBppETan1ysKkC2lcEZhySGG4qYFRLLXG83yN
        pmDPka/p0hiMu1fh6gaGEFI/eE0oNiGVWJhb4Lo=
X-Google-Smtp-Source: ABdhPJy1aF+tKSTtbGST7eTqCBov7Z0CR1gpV2Ifg+zajqYmevDnR6TVTCpqF/ugYAaRLczuV3OrPNv4BAmr7FUIFpU=
X-Received: by 2002:a17:902:c154:b029:d4:bb6f:6502 with SMTP id
 20-20020a170902c154b02900d4bb6f6502mr14341532plj.23.1602453844533; Sun, 11
 Oct 2020 15:04:04 -0700 (PDT)
MIME-Version: 1.0
References: <20201011191129.991-1-xiyou.wangcong@gmail.com> <CA+FuTSfeTWBpOp+ZCBMBQPqcPUAhZcAv2unwMLqgGt_x_PkrqA@mail.gmail.com>
In-Reply-To: <CA+FuTSfeTWBpOp+ZCBMBQPqcPUAhZcAv2unwMLqgGt_x_PkrqA@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sun, 11 Oct 2020 15:03:53 -0700
Message-ID: <CAJht_EM_dDKrCWEB5i_1r5Vkz+6wee84ACfVSOogznZ90r+32g@mail.gmail.com>
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

Nice explanation of the situation. I agree with you.

Thanks!
