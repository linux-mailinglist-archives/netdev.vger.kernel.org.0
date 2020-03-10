Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE3C17F03A
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 06:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgCJFuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 01:50:09 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33229 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgCJFuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 01:50:09 -0400
Received: by mail-pf1-f193.google.com with SMTP id n7so5981290pfn.0;
        Mon, 09 Mar 2020 22:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=W9bU/Zk2AcF80m7xhKxshUK/wcTE2Kr6WIg44d1hu2s=;
        b=QxMU6BgZx4yPHfVi/0K908CMBcJ75C/PgYgkvpjfT5yDadMHRzTk1zq8WSPOZe+ixk
         0DcUgJ5U/chwxdGeCzZDx4RoW8T4fgrfBdwer+POqlRRb9H1upue2DWyyWIVFdX3CH5E
         wgqa5muak4UcxTx+9Cr6QCjg1Yg/AMZzrUj14e1xRacXtvKgdY0VruuwJf4QCIaOA838
         fMq/UfNweKbtu5Bfgg2r86uf1dsHSQGvn4MO9B1g0XvzoUl2uDMjimcZUR3KtGmzuuNz
         QFiK0BbwTcj3c75l53cXD3TvMZ3BDNvy+QhZg2yRfSrj63tJoy+B90rEaBtK7d0PSCtb
         GY2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=W9bU/Zk2AcF80m7xhKxshUK/wcTE2Kr6WIg44d1hu2s=;
        b=LEiyMSLgLpKz3AkCpDwXAs+oW/GkIybt0O1Y7RZ38ccVn1RZIRd8hNDri1mpkO4BGX
         3r6nrNNJ+HgpfMFxT27TRBsiqiemLeTLD3du8/u/Go8zejBy/daI2adgh54v9YC/C4vX
         Pg98I9PNGXcAk+i9pM/1qtYudm9ZfWbTQd1NsX83S51/x9UQ75WwHO/reJ4pCK9jEU9E
         BHFtghN6xTxM3xgwtyjV2AkXkrsmHIN6zjsngvsUYvjoupmfCNdJJ1KeDgL0Ljgun4hK
         ZonWOuaKX5tjDrX5xZFf23n+7kNEYkHGf/9uQT3/LB1w4JoeM6BXk4/y351t+ZoNwJpT
         6Byw==
X-Gm-Message-State: ANhLgQ0JvdheD+Q4/MdhGSbOa2gCLOYLNQdDjjXtofd8q6e33lkUjjav
        BmqE8w7rHnaQjltmiLq6FCc=
X-Google-Smtp-Source: ADFU+vu+hc9koL+SCy2kh3S85IKNm4IFplcpSbhV26CIOnD1tv81H72BVfe2Ej1OUQjX/SkLgzhrnA==
X-Received: by 2002:a63:ac57:: with SMTP id z23mr7057305pgn.90.1583819406358;
        Mon, 09 Mar 2020 22:50:06 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id y9sm10733574pgo.80.2020.03.09.22.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 22:50:05 -0700 (PDT)
Date:   Mon, 09 Mar 2020 22:49:55 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf@vger.kernel.org, gamemann@gflclan.com, lrizzo@google.com,
        netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        brouer@redhat.com
Message-ID: <5e672a83a5c07_6d9d2ad5365425b4a3@john-XPS-13-9370.notmuch>
In-Reply-To: <20200309093932.2a738ab1@carbon>
References: <158323601793.2048441.8715862429080864020.stgit@firesoul>
 <20200303184350.66uzruobalf3y76f@ast-mbp>
 <5e62750bd8c9f_17502acca07205b42a@john-XPS-13-9370.notmuch>
 <20200309093932.2a738ab1@carbon>
Subject: Re: [bpf-next PATCH] xdp: accept that XDP headroom isn't always equal
 XDP_PACKET_HEADROOM
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer wrote:
> On Fri, 06 Mar 2020 08:06:35 -0800
> John Fastabend <john.fastabend@gmail.com> wrote:
> 
> > Alexei Starovoitov wrote:
> > > On Tue, Mar 03, 2020 at 12:46:58PM +0100, Jesper Dangaard Brouer wrote:  
> [...]
> > > > 
> > > > Still for generic-XDP if headroom is less, still expand headroom to
> > > > XDP_PACKET_HEADROOM as this is the default in most XDP drivers.
> > > > 
> > > > Tested on ixgbe with xdp_rxq_info --skb-mode and --action XDP_DROP:
> > > > - Before: 4,816,430 pps
> > > > - After : 7,749,678 pps
> > > > (Note that ixgbe in native mode XDP_DROP 14,704,539 pps)
> > > >   
> > 
> > But why do we care about generic-XDP performance? Seems users should
> > just use XDP proper on ixgbe and i40e its supported.
> >
> [...]
> > 
> > Or just let ixgbe/i40e be slow? I guess I'm missing some context?
> 
> The context originates from an email thread[1] on XDP-newbies list, that
> had a production setup (anycast routing of gaming traffic[3]) that used
> XDP and they used XDP-generic (actually without realizing it).  They
> were using Intel igb driver (that don't have native-XDP), and changing
> to e.g. ixgbe (or i40e) is challenging given it requires physical access
> to the PoP (Points of Presence) and upgrading to a 10G port at the PoP
> also have costs associated.

OK maybe igb should get xdp...

I get the wanting to run an XDP program across multiple cards even when
they don't have XDP support.

> 
> Why not simply use TC-BPF (cls_bpf) instead of XDP.  I've actually been
> promoting that more people should use TC-BPF, and also in combination[2].
> The reason it makes sense to stick with XDP here is to allow them to
> deploy the same software on their PoP servers, regardless of which
> NIC driver is available.

Sounds reasonable to me.

> 
> Performance wise, I will admit that I've explicitly chosen not to
> optimize XDP-generic, and I've even seen it as a good thing that we
> have this reallocation penalty.  Given the uniform software deployment
> argument and my measurements in[1] I've changed my mind.  For the igb
> driver I'm not motivated to implement XDP-native, because a newer Intel
> CPU can handle wirespeed even-with the reallocations, but it is just
> wasteful to do these reallocations.  "Allowing" these 1Gbit/s NICs to
> work more optimally with XDP-generic, will allow us to ignore
> converting these drivers to XDP-native, and as HW gets upgraded they
> will transition seamlessly to XDP-native.

OK, might be nice to put the details in the commit message? The original
patch seemed to be mostly about 140e and ixgbe but in those case the
user (from above xdp example) would just use XDP. So more about 1gbps
and missing xdpsupport?

> 
> 
> [1] https://www.spinics.net/lists/xdp-newbies/msg01548.html
> [2] https://github.com/xdp-project/xdp-cpumap-tc
> [3] https://gitlab.com/Dreae/compressor/
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
> 


