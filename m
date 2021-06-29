Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E343B72F6
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 15:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233964AbhF2NKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 09:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233688AbhF2NJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 09:09:59 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F067C061760;
        Tue, 29 Jun 2021 06:07:31 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id q14so31194690eds.5;
        Tue, 29 Jun 2021 06:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eybvse0kYdOhyWZwFt4avTwT1xAvOttt06mlkUESuu8=;
        b=S4RBVOiGQ9AU9EjoEx0fq0nUTs/8O218qJp4GhGhaW6sQpzt//Gv2sjkSqSeQsTq/X
         1A2uaaF9E8pVDp22rV+QeUZyF9rPTNBPK7zx6NtgA4ZQCJlANo4L0QccmsW0eHwrVsan
         wlLZJKUXqU2nb2DN2PqY8ZgJS1SjoOk6g8qkY8Yq1BKbSypktCOSllDfP3dr0GINuqNB
         4FBEP+B8COso9pyUO1VgYoluOYq/C6hiDZFEDAXkuulWQk/ZwiE30gZ7ewcWbd9RFPCQ
         XD8AnMb7oQs5+R5wCEbLOQcghObUIa/UsKFak0WJJoV7PimjKT7OzmyKgxxUgXBUbEzx
         3kCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eybvse0kYdOhyWZwFt4avTwT1xAvOttt06mlkUESuu8=;
        b=rhwG7kX+t+Uj9SzIBlPH59iQ6qsqqr0fypb2sa+aaEWtogL9MYjWiqzd36ZsBrKAsZ
         ErojUkfwhj+lNuOi8jmJ2HFYP7Mkol9QpFhmQq4/+bzMw1fsiBIJ4cHqKF2yWPi0euTj
         tV8Hj7q9Qoj9iMJpZqFDwKboP+eYzjJvdYFBB/iI8pdW/xfIeaarj/R2n14WTgwRX6Zc
         WlqGG+tklOZ4sbVZFc4C4m0/48W2mtEKeJKe2GnssK8MK4++jGJpWwa8fyc3OoJ3NmbG
         b+OoOqhEeVGXHy/CmdJo2HdDlSHoasYnRz/d6dmxm914lI+akm17W9AwCn2m9whNqW5C
         fBVQ==
X-Gm-Message-State: AOAM5332aTyFRFA5WDYhLjemMYRes3y+QQKmRfbCkwVKgJT1vxf5BTF9
        HDiu6opsFeZdswPna9wFsWMgFwg2EhfC3z2Nkc0=
X-Google-Smtp-Source: ABdhPJw04cvL9c46FGApZkmu16kgUPPJmQcxsCUZhZruLW4rTyFa/dq++dcVP2Kgf2Mtg569+8640oEESPTXm/apQf4=
X-Received: by 2002:aa7:d6d6:: with SMTP id x22mr39565965edr.224.1624972050162;
 Tue, 29 Jun 2021 06:07:30 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1623674025.git.lorenzo@kernel.org> <1316f3ef2763ff4c02244fb726c61568c972514c.1623674025.git.lorenzo@kernel.org>
 <CAKgT0Ue7TsgwbQF+mfeDB-18Q-R29YZWe=y6Kgeg0xxbwds=vw@mail.gmail.com> <YNsVcy8e4Mgyg7g3@lore-desk>
In-Reply-To: <YNsVcy8e4Mgyg7g3@lore-desk>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 29 Jun 2021 06:07:19 -0700
Message-ID: <CAKgT0Ucg5RbzKt63u5RfXee94kd+1oJ+o_qgUwCwnVCoQjDdPw@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 02/14] xdp: introduce flags field in xdp_buff/xdp_frame
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        "Jubran, Samih" <sameehj@amazon.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Tirthendu <tirthendu.sarkar@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 5:43 AM Lorenzo Bianconi
<lorenzo.bianconi@redhat.com> wrote:
>
> > On Mon, Jun 14, 2021 at 5:50 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > >
> > > Introduce flags field in xdp_frame/xdp_buffer data structure
> > > to define additional buffer features. At the moment the only
> > > supported buffer feature is multi-buffer bit (mb). Multi-buffer bit
> > > is used to specify if this is a linear buffer (mb = 0) or a multi-buffer
> > > frame (mb = 1). In the latter case the shared_info area at the end of
> > > the first buffer will be properly initialized to link together
> > > subsequent buffers.
> > >
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> >
> > Instead of passing this between buffers and frames I wonder if this
> > wouldn't be better to place in something like the xdp_mem_info
> > structure since this is something that would be specific to how the
> > device is handling memory anyway. You could probably split the type
> > field into a 16b type and a 16b flags field. Then add your bit where 0
> > is linear/legacy and 1 is scatter-gather/multi-buffer.
> >
>
> ack, this should be fine but I put the flag field in xdp_buff/xdp_frame
> in order to reuse it for some xdp hw-hints (e.g rx checksum type).
> We can put it in xdp_mem_info too but I guess it would be less intuitive, what
> do you think?

I think it makes the most sense in xdp_mem_info. It already tells us
what to expect in some respect in regards to memory layout as it tells
us if we are dealing with shared pages or whole pages and how to
recycle them. I would think that applies almost identically to
scatter-gather XDP the same way.

As far as the addition of flags there is still time for that later as
we still have the 32b of unused space after frame_sz.
