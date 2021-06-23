Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 721EC3B135D
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 07:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhFWFup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 01:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWFuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 01:50:44 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD6BC061574;
        Tue, 22 Jun 2021 22:48:26 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id k16so1873510ios.10;
        Tue, 22 Jun 2021 22:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=AZ8B0+Bw5XeVcaZ1NJ4GhJlOgBdWpAMkLyJw6HcKhtY=;
        b=OYbou5qCbscoSLPvAVYCCzQNbT9Vel1f6ls8sgl+eHL+nN0HS7byalNaPBXW+caN29
         wUhkZduc0915Z/Mytj/IUUzaGW/BnZLhvnLyYtUwlkkAhYh3yTl+9qYTHn3MdkApjvEq
         MZXRkxi0VsiVe0ConGUD+ajseDRP7GvSyvGRzeaRSUaUykLACX0Gxf35rlZ2EPDwmqCi
         1zk2iHKVa7yKrE7ksj9sfPaT9zGo/UWl/GzIRat3QTZithkYsMZb9ZdwJZ/3pU7bj9f9
         VGVm4oCF7Y/C0PownDcTZ9gR8/x7qBEpYQZnhxfKtG6Ch3Sjnti5mRa9Z1ZS4T5fW9R5
         7aeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=AZ8B0+Bw5XeVcaZ1NJ4GhJlOgBdWpAMkLyJw6HcKhtY=;
        b=fXBvEshAXRrYLkZkPFdztA3sRji/Ntsa0Z7W3cZxxMQt+/zEU/THrFxKd8BTNno642
         dYOdJiSGQI17+Q0FcoFt72aRbpzAXfSpf9j7cLsXKtr1AeA9KmsKcan/ug53+JvfEKHL
         rqvEZyu2g1awPlPd/Q0Iqcu/nC/ptCyp7gPH1mZ+87J8Oo67grsszsS6DJKjd1pbaKa+
         tBO2r9GsGOxc9QvXSi3hixWc7sW//xMkWGRDTS+TelCkqTYA04uJpif4GAGL2+9OjnS9
         pKGyahocf6l4BXGraVH42z02hfQHpt/g/oKUokJRrQL4O9glW3/Fv38A/HUFoK08SJ0u
         VBBQ==
X-Gm-Message-State: AOAM530IHzx/gpXnJtIJVbEg0Iz9U/YdZmsFWbIzFfyr61VG+G2nMaBD
        veaMkgA4jvoYWZ/0TYRA6zY=
X-Google-Smtp-Source: ABdhPJzEVsVOis5Owpfg6SBPtb2+DzbxOrRViRTGcpnTtM7LNisQqh4qrX08seDfDflnXdy02Z4cnw==
X-Received: by 2002:a05:6638:2143:: with SMTP id z3mr7524853jaj.103.1624427306288;
        Tue, 22 Jun 2021 22:48:26 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id s10sm4546807ilv.81.2021.06.22.22.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 22:48:25 -0700 (PDT)
Date:   Tue, 22 Jun 2021 22:48:15 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     David Ahern <dsahern@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Message-ID: <60d2cb1fd2bf9_2052b20886@john-XPS-13-9370.notmuch>
In-Reply-To: <efe4fcfa-087b-e025-a371-269ef36a3e86@gmail.com>
References: <cover.1623674025.git.lorenzo@kernel.org>
 <60d26fcdbd5c7_1342e208f6@john-XPS-13-9370.notmuch>
 <efe4fcfa-087b-e025-a371-269ef36a3e86@gmail.com>
Subject: Re: [PATCH v9 bpf-next 00/14] mvneta: introduce XDP multi-buffer
 support
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern wrote:
> On 6/22/21 5:18 PM, John Fastabend wrote:
> > At this point I don't think we can have a partial implementation. At
> > the moment we have packet capture applications and protocol parsers
> > running in production. If we allow this to go in staged we are going
> > to break those applications that make the fundamental assumption they
> > have access to all the data in the packet.
> 
> What about cases like netgpu where headers are accessible but data is
> not (e.g., gpu memory)? If the API indicates limited buffer access, is
> that sufficient?

I never consider netgpus and I guess I don't fully understand the
architecture to say. But, I would try to argue that an XDP API
should allow XDP to reach into the payload of these GPU packets as well.
Of course it might be slow.

I'm not really convinced just indicating its a limited buffer is enough.
I think we want to be able to read/write any byte in the packet. I see
two ways to do it,

  /* xdp_pull_data moves data and data_end pointers into the frag
   * containing the byte offset start.
   *
   * returns negative value on error otherwise returns offset of
   * data pointer into payload.
   */
  int xdp_pull_data(int start)

This would be a helper call to push the xdp->data{_end} pointers into
the correct frag and then normal verification should work. From my
side this works because I can always find the next frag by starting
at 'xdp_pull_data(xdp->data_end+1)'. And by returning offset we can
always figure out where we are in the payload. This is the easiest
thing I could come up with. And hopefully for _most_ cases the bytes
we need are in the initial data. Also I don't see how extending tail
works without something like this.

My other thought, but requires some verifier work would be to extend
'struct xdp_md' with a frags[] pointer.

 struct xdp_md {
   __u32 data;
   __u32 data_end;
   __u32 data_meta;
   /* metadata stuff */
  struct _xdp_md frags[] 
  __u32 frags_end;
 }

Then a XDP program could read access a frag like so,

  if (i < xdp->frags_end) {
     frag = xdp->frags[i];
     if (offset + hdr_size < frag->data_end)
         memcpy(dst, frag->data[offset], hdr_size);
  }

The nice bit about above is you avoid the call, but maybe it doesn't
matter if you are already looking into frags pps is probably not at
64B sizes anyways.

My main concern here is we hit a case where the driver doesn't pull in
the bytes we need and then we are stuck without a workaround. The helper
looks fairly straightforward to me could we try that?

Also I thought we had another driver in the works? Any ideas where
that went...

Last, I'll add thanks for working on this everyone.

.John
