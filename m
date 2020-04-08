Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCB011A2792
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 18:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730460AbgDHQz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 12:55:27 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35126 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728627AbgDHQz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 12:55:27 -0400
Received: by mail-pf1-f194.google.com with SMTP id a13so2679161pfa.2;
        Wed, 08 Apr 2020 09:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iN6v1y3bUGTA3QAXmoYx9KRomlhUAmrnaSxlwoSLx14=;
        b=RV+bouxc7T7nCtEfiH6LQkUvzxPx6z19Q7Sl8s+bVPtUjD5EcEJmeMpNLEL9oCH88h
         Di770a0NPMoYcfAWno/89FiotZ7urwA88aFxASh2QU9kOrdOEOATJPA56Qo2nQtBCyg1
         se9jGWW/uzL7E+pfwfGlA+45452Lx0JxarKQl59mXYl9pxAZiwHZjrnznbek6awOrQe/
         tw+Ly1XXYlsuozcr7Tp6/m7fHWn7pHPkc4FXZim5DzgdahsJHNnW8m2ecwZZTTdn3lso
         /QIYuCiXUp80gJczr8uxZ4m7j1O4u1MVT0rHKJzmJe7OVD+3te3fVpkkWUyB4OTkMKtd
         nRWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iN6v1y3bUGTA3QAXmoYx9KRomlhUAmrnaSxlwoSLx14=;
        b=NbDNgXHxVfvoxAeTm62veVeKYi5EaH4HTkoJ+54hWAoswIk7oqt62x3s6LK+SRexBJ
         fyp0RAVRXfea3wbUqvkOwZoGIFjAuygbJ3c67VjmnngsR4ZzaaVsMguD0XDoEi1F0cd2
         gKQwVV4fv/ijf/p4QKtzDw/79sqxx4KO3UH3I7IfjF6QWhTOchFQ923fQburTxrN3TlZ
         ioVCBAy9SRFqjx2xTJWm+nqlfui4yG7hdW+XPrkgAzjBzvOQ1117kFKrqQsw5TRwyxB2
         zBJD0JvMXzUstneK0mQQyCWoEnAAvTkPWk34ogyUPI1N0B4SyxXOyVptrs1W4GomlV58
         M0iA==
X-Gm-Message-State: AGi0PuZ5JK6QBoXEABdJKpG49CRq6IdjIPwmjfeUbsiIe+HO57SWC49O
        yqoakAokKJM8LyOvjwJC318=
X-Google-Smtp-Source: APiQypLa/L3StXHwyb5YsmgRtv1L8s0LdE+QZfIRCBwHwMqCeOpFX/AlTxWi71aR3aICTr7OnDOr5g==
X-Received: by 2002:a63:7b1a:: with SMTP id w26mr7403210pgc.298.1586364924586;
        Wed, 08 Apr 2020 09:55:24 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:c144])
        by smtp.gmail.com with ESMTPSA id p4sm16955295pfg.163.2020.04.08.09.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2020 09:55:23 -0700 (PDT)
Date:   Wed, 8 Apr 2020 09:55:19 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     sameehj@amazon.com, Grygorii Strashko <grygorii.strashko@ti.com>,
        intel-wired-lan@lists.osuosl.org, Ariel Elior <aelior@marvell.com>,
        Andy Gospodarek <gospo@broadcom.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Jason Wang <jasowang@redhat.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Robert Richter <rrichter@marvell.com>,
        GR-everest-linux-l2@marvell.com, Wei Liu <wei.liu@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mao Wenan <maowenan@huawei.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        thomas.petazzoni@bootlin.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, zorik@amazon.com, gtzalik@amazon.com,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH RFC v2 00/33] XDP extend with knowledge of frame size
Message-ID: <20200408165519.da6dr5mclqol6g26@ast-mbp>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158634658714.707275.7903484085370879864.stgit@firesoul>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 08, 2020 at 01:50:34PM +0200, Jesper Dangaard Brouer wrote:
> RFC-note: This is only an RFC because net-next is closed.
> - Please ACK patches you like, then I will collect those for later.
> 
> XDP have evolved to support several frame sizes, but xdp_buff was not
> updated with this information. This have caused the side-effect that
> XDP frame data hard end is unknown. This have limited the BPF-helper
> bpf_xdp_adjust_tail to only shrink the packet. This patchset address
> this and add packet tail extend/grow.
> 
> The purpose of the patchset is ALSO to reserve a memory area that can be
> used for storing extra information, specifically for extending XDP with
> multi-buffer support. One proposal is to use same layout as
> skb_shared_info, which is why this area is currently 320 bytes.
> 
> When converting xdp_frame to SKB (veth and cpumap), the full tailroom
> area can now be used and SKB truesize is now correct. For most
> drivers this result in a much larger tailroom in SKB "head" data
> area. The network stack can now take advantage of this when doing SKB
> coalescing. Thus, a good driver test is to use xdp_redirect_cpu from
> samples/bpf/ and do some TCP stream testing.

I did a quick look through the patches. Overall looks good to me.
Nice to see selftests as well.
If you can add an xdp selftest that uses generic xdp on lo or veth
that would be awesome.
I rarely run test_xdp*.sh tests, but run test_progs on every commit.
So having more comprehensive xdp test as part of test_progs will help us
catch breakage sooner.
