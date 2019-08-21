Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 849A898457
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 21:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729858AbfHUT0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 15:26:16 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35657 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729700AbfHUT0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 15:26:16 -0400
Received: by mail-pl1-f194.google.com with SMTP id gn20so1872445plb.2;
        Wed, 21 Aug 2019 12:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=PNUqpGr9n3DZ1UqJZHgWC3CBJzQFi6GomaPmjlQlmnY=;
        b=ScoclNxohaMG9qcl0/98baxq3e9Dfu1aXi059zSgcDbTLQFQx9l89ecYlFupYueNPL
         7n6UjS040PYa46dSL/ovQ5Di+AsdaKd+LWnQavuXeoIfexVGNhiN0MYkAHt5SgPzzYG0
         mgSdy5tsqOhI7JzzjQc0/i70Ubl/ywqMyTje2oVpVEqSYuuPLqY55VN03zpj+DeYVsVG
         DCKgqYU2k/KBI5upgLm9pdd+aB7VqzRKfnixDf4sssuYB2cPYYcY6aiqRGpZh96h5KMX
         bCTXRePURM+lShk4Wy7DwKEF0YnIRixnWb5o9vJjsGNZ/BUYJztcRoA8fvWb+dDjRP8h
         QHSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=PNUqpGr9n3DZ1UqJZHgWC3CBJzQFi6GomaPmjlQlmnY=;
        b=GY/tzOPT/Cip3FE3NJSSVYY/o0lQyLMoc8k978APRo9+qsA4PpYf9YsZbwY2GzsLHd
         0HBaz6xSGSKC5XROsh7+A6uiumN3+UEcuz2RuikzGpt1o/dtdQA21SezjBv6uuBO8NsI
         WtCOStSqp9tnBZ0gXb6+i1icUU6gC4WZj8bPln2MBsOq+rfpMWZRu6mActngqkHTk87i
         PwXeDd0uaFWtHGvxEk08WAygH9qc2rqw0igysaj+fcetKTnP2wfrhZI1FwbP+maq6tSb
         7H4hNBCSDuHZumfA84C7MWXMKe9Yc0k41c5QDBlyIgFZ1rBhkQSaEAHLxrxMOl8gvvGq
         aHBw==
X-Gm-Message-State: APjAAAXyMBh2Qo9Jfpz12XTZKGv0A8AtpuOZNTtJRW5mwVyFguLA/eI1
        p3IIA8qJWcv9ZXSIXuZ8vfc=
X-Google-Smtp-Source: APXvYqyiGjVoxpnDmBXTJec/nTluT/vnF4EYm4c8oxZ3SwrDPFS7iVXZJcP25WODHfum2WdVVXmgXw==
X-Received: by 2002:a17:902:e9:: with SMTP id a96mr20008772pla.169.1566415575634;
        Wed, 21 Aug 2019 12:26:15 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::678f])
        by smtp.gmail.com with ESMTPSA id e66sm24807075pfe.142.2019.08.21.12.26.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 12:26:14 -0700 (PDT)
Date:   Wed, 21 Aug 2019 12:26:12 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC bpf-next 0/5] Convert iproute2 to use libbpf (WIP)
Message-ID: <20190821192611.xmciiiqjpkujjup7@ast-mbp.dhcp.thefacebook.com>
References: <20190820114706.18546-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190820114706.18546-1-toke@redhat.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 01:47:01PM +0200, Toke Høiland-Jørgensen wrote:
> iproute2 uses its own bpf loader to load eBPF programs, which has
> evolved separately from libbpf. Since we are now standardising on
> libbpf, this becomes a problem as iproute2 is slowly accumulating
> feature incompatibilities with libbpf-based loaders. In particular,
> iproute2 has its own (expanded) version of the map definition struct,
> which makes it difficult to write programs that can be loaded with both
> custom loaders and iproute2.
> 
> This series seeks to address this by converting iproute2 to using libbpf
> for all its bpf needs. This version is an early proof-of-concept RFC, to
> get some feedback on whether people think this is the right direction.
> 
> What this series does is the following:
> 
> - Updates the libbpf map definition struct to match that of iproute2
>   (patch 1).
> - Adds functionality to libbpf to support automatic pinning of maps when
>   loading an eBPF program, while re-using pinned maps if they already
>   exist (patches 2-3).
> - Modifies iproute2 to make it possible to compile it against libbpf
>   without affecting any existing functionality (patch 4).
> - Changes the iproute2 eBPF loader to use libbpf for loading XDP
>   programs (patch 5).
> 
> 
> As this is an early PoC, there are still a few missing pieces before
> this can be merged. Including (but probably not limited to):
> 
> - Consolidate the map definition struct in the bpf_helpers.h file in the
>   kernel tree. This contains a different, and incompatible, update to
>   the struct. Since the iproute2 version has actually been released for
>   use outside the kernel tree (and thus is subject to API stability
>   constraints), I think it makes the most sense to keep that, and port
>   the selftests to use it.

It sounds like you're implying that existing libbpf format is not uapi.
It is and we cannot break it.
If patch 1 means breakage for existing pre-compiled .o that won't load
with new libbpf then we cannot use this method.
Recompiling .o with new libbpf definition of bpf_map_def isn't an option.
libbpf has to be smart before/after and recognize both old and iproute2 format.

