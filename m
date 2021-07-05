Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B913BC3AC
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 23:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbhGEVit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 17:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbhGEVis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 17:38:48 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5522AC061574;
        Mon,  5 Jul 2021 14:36:10 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id b2so30827402ejg.8;
        Mon, 05 Jul 2021 14:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tmua9CFWb5xZc/P+9Sif+g3MHJZH4MPiPQftuOh3umc=;
        b=J4656etXNvb9IV6GxUlD1Wm43uNT49gzlAXYHlAyDYDqlNNZ3E9+3XyquicQMj3lS1
         ibj+FlqncUEl8qFYCqzJJhdS+/kn4AQYvZk1lW1XR+QjdRnDJZU+YFPXHOMzb0PotoSA
         e4KR9Iv1FB2CcdCA7/6lbx9qwdiBMpqF9PHtIrtEBgcn9Ek5DmGSxaCTcOcET4Hz+8oI
         5tn98fauZghBQB9zKFV8wv/2urKdUR3TQAN6dnrKggMCWTTd3aIyQFrp4ivIUbzSOHzo
         Juu5sktdPlIQdkN6ECWxvpEwcTnQj15BfmBv3axMjNXLKWdVYDgPyqDfR3yK9gHW08p+
         Rl6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tmua9CFWb5xZc/P+9Sif+g3MHJZH4MPiPQftuOh3umc=;
        b=SH7QwmkOJvF/sFJsCsw9LW0EfOD1e0L3hkL/N5nIkqg0DMaSwxYUmeUd0F9RGsHMXn
         7PBWxFvLS9hTqah1kga3JssSm+e8l54ZZE+66QvQKnKoz1CfYqJ4uJwekFUdsjncMUQh
         vEc1bv6eQ4jvhOLoM81ZtXqm1sv6EoPbnU1IlEEaAyyivZ0ybcUeD+vm9T2SwHJ711kN
         E66StKgLSdh9ceWrRtml+log+sFxq6BHMvgLPIaDrJin0/Wyz3hPqm+OsiwHX46G/nOR
         G5Etl27fKsveL8Jgnr5479sope0RGdK5nf4pVQ5dqvZNCu8YLyMCNZki3kHmLcyRsK0J
         iU7Q==
X-Gm-Message-State: AOAM531XBz+CtD0uEo2pjux1enmAVpVg3vOcQHR0BJHpwyrv55qfuPzx
        q/q594rTt7h4YoknCMep4mt0p0wr1dY5TX29N7A=
X-Google-Smtp-Source: ABdhPJxkOPt//+UgEIZucHrEiPqPV4S7ut9qX3fMt2h+UUlW/J9xZph7Bxoa4TZXwzcml7YCYNkAs9z/glufXr8Vlig=
X-Received: by 2002:a17:906:bc2:: with SMTP id y2mr14894932ejg.489.1625520968826;
 Mon, 05 Jul 2021 14:36:08 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1623674025.git.lorenzo@kernel.org> <1316f3ef2763ff4c02244fb726c61568c972514c.1623674025.git.lorenzo@kernel.org>
 <CAKgT0Ue7TsgwbQF+mfeDB-18Q-R29YZWe=y6Kgeg0xxbwds=vw@mail.gmail.com>
 <YNsVcy8e4Mgyg7g3@lore-desk> <CAKgT0Ucg5RbzKt63u5RfXee94kd+1oJ+o_qgUwCwnVCoQjDdPw@mail.gmail.com>
 <YOMq0WRu4lsGZJk2@lore-desk>
In-Reply-To: <YOMq0WRu4lsGZJk2@lore-desk>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 5 Jul 2021 14:35:57 -0700
Message-ID: <CAKgT0Udn90g9s3RYiGA0hFz7bXaepPNJNqgRjMtwjpdj1zZTDw@mail.gmail.com>
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

On Mon, Jul 5, 2021 at 8:52 AM Lorenzo Bianconi
<lorenzo.bianconi@redhat.com> wrote:
>
> > On Tue, Jun 29, 2021 at 5:43 AM Lorenzo Bianconi
> > <lorenzo.bianconi@redhat.com> wrote:
> > >
> > > > On Mon, Jun 14, 2021 at 5:50 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > > > >
> > > > > Introduce flags field in xdp_frame/xdp_buffer data structure
> > > > > to define additional buffer features. At the moment the only
> > > > > supported buffer feature is multi-buffer bit (mb). Multi-buffer bit
> > > > > is used to specify if this is a linear buffer (mb = 0) or a multi-buffer
> > > > > frame (mb = 1). In the latter case the shared_info area at the end of
> > > > > the first buffer will be properly initialized to link together
> > > > > subsequent buffers.
> > > > >
> > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > >
> > > > Instead of passing this between buffers and frames I wonder if this
> > > > wouldn't be better to place in something like the xdp_mem_info
> > > > structure since this is something that would be specific to how the
> > > > device is handling memory anyway. You could probably split the type
> > > > field into a 16b type and a 16b flags field. Then add your bit where 0
> > > > is linear/legacy and 1 is scatter-gather/multi-buffer.
> > > >
> > >
> > > ack, this should be fine but I put the flag field in xdp_buff/xdp_frame
> > > in order to reuse it for some xdp hw-hints (e.g rx checksum type).
> > > We can put it in xdp_mem_info too but I guess it would be less intuitive, what
> > > do you think?
> >
> > I think it makes the most sense in xdp_mem_info. It already tells us
> > what to expect in some respect in regards to memory layout as it tells
> > us if we are dealing with shared pages or whole pages and how to
> > recycle them. I would think that applies almost identically to
> > scatter-gather XDP the same way.
>
> Hi Alex,
>
> Reviewing the code to address this comment I think I spotted a corner case
> where we can't use this approach. Whenever we run dev_map_bpf_prog_run()
> we loose mb info converting xdp_frame to xdp_buff since
> xdp_convert_frame_to_buff() does not copy it and we have no xdp_rxq_info there.
> Do you think we should add a rxq_info there similar to what we did for cpumap?
> I think it is better to keep the previous approach since it seems cleaner and
> reusable in the future. What do you think?
>

Hi Lorenzo,

What about doing something like breaking up the type value in
xdp_mem_info? The fact is having it as an enum doesn't get us much
since we have a 32b type field but are only storing 4 possible values
there currently

The way I see it, scatter-gather is just another memory model
attribute rather than being something entirely new. It makes as much
sense to have a bit there for MEM_TYPE_PAGE_SG as it does for
MEM_TYPE_PAGE_SHARED. I would consider either splitting the type field
into two 16b fields. For example you might have one field that
describes the source pool which is currently either allocated page
(ORDER0, SHARED), page_pool (PAGE_POOL), or XSK pool (XSK_BUFF_POOL),
and then two flags for type with there being either shared and/or
scatter-gather.

Also, looking over the code I don't see any reason why current
ORDER0/SHARED couldn't be merged as the free paths are essentially
identical since the MEM_TYPE_PAGE_SHARED path would function perfectly
fine to free MEM_TYPE_PAGE_ORDER0 pages.

Thanks,

- Alex
