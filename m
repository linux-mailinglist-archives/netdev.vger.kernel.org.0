Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9ED194818
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 20:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbgCZT7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 15:59:04 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:51980 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgCZT7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 15:59:04 -0400
Received: by mail-pj1-f65.google.com with SMTP id w9so2930264pjh.1;
        Thu, 26 Mar 2020 12:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=t65dqCPU1l76vOHm7W6FbHIpgdz9VRI/oHeiqigs5q0=;
        b=rqCWmZWESzs1S2Njd9eaqzopBBlCO9oexSdaImQ5EJnEPBGBJkobo14Bh2H882o8WE
         oOjL4kXASpCzgSgDY7dYHiE5MarKmrjH2H9JvJdkFZ8vby1UDKWB5ZZpySrYhuFnuJnz
         SduwcHehvwPEsu2zVtSN+o7YaE3/R6Js2OyfCxfJpG8k6GA7vYxBcjaoin1zOdLphppW
         GR7CD0s/TTqChyxC+dzkdCXCYNM6Eu65CNOec5fMjJnSRVuBl/AKaZB9idJqtzb6ca6f
         T04/g6F9lzKuB7rPFnhTxLeEU8HOtfsI5Y/dHN3xPWT6P2fLyKBX3MV0wdozJaVhpOxR
         xyJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=t65dqCPU1l76vOHm7W6FbHIpgdz9VRI/oHeiqigs5q0=;
        b=Lh7HSZxUatH2aAGkT87RW+fXGFyYg9VFnRT4CwkyYwdZsFsw9+ssOPPEOyalK/hezM
         DSttB7r/RIeQh3ATuvMofadKpHKWQ2pU3RCa4s/mWRUwApmclGcndzZkogySYVD1o5b4
         vAiZgb8SGHLjYalfo+jZs53wKNSB/MUNs6Y1yQYVcFa5W7w/bJdJ0MZxeA85598NaVVD
         pbk5mjeXWTNOqHRmQ9Rdb3Dha8cwSbZ7hnqmAzAS/CMQ3NwdNjfuYtpTJD7drNxI3LsV
         +QVhynXCXMqYygkYoqbxWM+Hv59lhbYZNSOzdAbxCr13ciwlcj8PhGfkSDK1z+3ECItH
         aw+w==
X-Gm-Message-State: ANhLgQ0htDOLwwkI9ugnZg5KVCsp1bPEZjBMmtN4DQRZRTsqAn+ZHzJU
        r0k8uolUbpeE7xAaxQtqFFA=
X-Google-Smtp-Source: ADFU+vs0+Ak7lHY3cr6PH3uVa/Fk3zCQkiJBZddrn1YUvTiBNrH5FE3mHaaCImL0x+MpmQJVJOSPlw==
X-Received: by 2002:a17:902:7793:: with SMTP id o19mr9726950pll.174.1585252742913;
        Thu, 26 Mar 2020 12:59:02 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:c7d9])
        by smtp.gmail.com with ESMTPSA id v25sm2333411pgl.55.2020.03.26.12.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 12:59:02 -0700 (PDT)
Date:   Thu, 26 Mar 2020 12:58:59 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
Message-ID: <20200326195859.u6inotgrm3ubw5bx@ast-mbp>
References: <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
 <87tv2f48lp.fsf@toke.dk>
 <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk>
 <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk>
 <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com>
 <87369wrcyv.fsf@toke.dk>
 <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com>
 <87pncznvjy.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87pncznvjy.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 01:35:13PM +0100, Toke Høiland-Jørgensen wrote:
> 
> Additionally, in the case where there is *not* a central management
> daemon (i.e., what I'm implementing with libxdp), this would be the flow
> implemented by the library without bpf_link:
> 
> 1. Query kernel for current BPF prog loaded on $IFACE
> 2. Sanity-check that this program is a dispatcher program installed by
>    libxdp
> 3. Create a new dispatcher program with whatever changes we want to do
>    (such as adding another component program).
> 4. Atomically replace the old program with the new one using the netlink
>    API in this patch series.

in this model what stops another application that is not using libdispatcher to
nuke dispatcher program ?

> Whereas with bpf_link, it would be:
> 
> 1. Find the pinned bpf_link for $IFACE (e.g., load from
>    /sys/fs/bpf/iface-links/$IFNAME).
> 2. Query kernel for current BPF prog linked to $LINK
> 3. Sanity-check that this program is a dispatcher program installed by
>    libxdp
> 4. Create a new dispatcher program with whatever changes we want to do
>    (such as adding another component program).
> 5. Atomically replace the old program with the new one using the
>    LINK_UPDATE bpf() API.

whereas here dispatcher program is only accessible to libdispatcher.
Instance of bpffs needs to be known to libdispatcher only.
That's the ownership I've been talking about.

As discussed early we need a way for _human_ to nuke dispatcher program,
but such api shouldn't be usable out of application/task.
