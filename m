Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D084F37FE81
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 22:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbhEMUCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 16:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232373AbhEMUCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 16:02:36 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4319C061574;
        Thu, 13 May 2021 13:01:24 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id o21so25685345iow.13;
        Thu, 13 May 2021 13:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=WF69W2heVFoVnvpdFr4fA0inEysygtcPps6DzU2q0RM=;
        b=JVuC9lswzSkxHuGJF4ey1nT+FgPuqGMHoS3U+AfZckDlbtonvwzGSoQQDwDGUm4geZ
         w/40VrXAAoh5llAL3rSBxhhFAUQ3B0nRlcps25Z1bZU5dzt9p962y3b2hdAJ3ibOi3du
         ex6pih5d3yNp9C/yNeigsKX5yfvWMD9fyASszdVr7dZt282741hYjyHpR07VXhT1e8ce
         dnzAiF0tHcvPFMf5avkfiVmMaMxBQhcYJD4XJRaSfCl/hbL5AzSI8JCUZWizpORfyZxd
         lJbENPL2D/ZJthfT32LCrapikLr1SK8rJkIDnNbv7vCGJuRm/doYYfTAiJ0ltY0EhMCg
         xg1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=WF69W2heVFoVnvpdFr4fA0inEysygtcPps6DzU2q0RM=;
        b=dHQvMSYKeafNWTnoPYpeciVmHSIOIMK8wghWo4JCfeWU3AEgyV0R+P16JzOZD+tTK0
         f40faIKPpZEw0Vk+a5oeS7VHaF8RfK9w6VS5/tO3GaQXNDSIVxik3xBEhF7/RVrTSG+f
         mZHbjGWK3v+AfPp3RzA8KXeMj2jCUuc7CnxuN3ggjlByxflgzNpUdICd2vTQGsm4JGke
         cFX8PUT2zFy9Isba0lcamM1iqVgG/0Bcjc9JLYC6On3AM1MyeDPFR7++M0kL79NOPZCY
         SfpXPL2KjfH+46Cfj1062DW4QBW7BxegsnZZIJiEWe0b9gCGAqIsDdAFIhT34yKR+5k0
         H2KQ==
X-Gm-Message-State: AOAM531ojFLyghZgmmfDeM2eKuJLgSiMzpUCj4eIBK8H72mBuK+mSXP7
        LVfIFwVETfui0TDk2NYWDTM=
X-Google-Smtp-Source: ABdhPJxqdbNwZV+jdxYB3xWCtOfHUjxy2om5SgphPteOdp4C7r1bskIQIwzZWrbmWHSpa8ROClWL3Q==
X-Received: by 2002:a05:6638:f11:: with SMTP id h17mr38542297jas.102.1620936084180;
        Thu, 13 May 2021 13:01:24 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id b11sm1802364ilv.87.2021.05.13.13.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 13:01:23 -0700 (PDT)
Date:   Thu, 13 May 2021 13:01:16 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Message-ID: <609d858c171bf_634432084c@john-XPS-13-9370.notmuch>
In-Reply-To: <20210513070447.1878448-3-liuhangbin@gmail.com>
References: <20210513070447.1878448-1-liuhangbin@gmail.com>
 <20210513070447.1878448-3-liuhangbin@gmail.com>
Subject: RE: [PATCH RESEND v11 2/4] xdp: extend xdp_redirect_map with
 broadcast support
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu wrote:
> This patch adds two flags BPF_F_BROADCAST and BPF_F_EXCLUDE_INGRESS to
> extend xdp_redirect_map for broadcast support.
> =

> With BPF_F_BROADCAST the packet will be broadcasted to all the interfac=
es
> in the map. with BPF_F_EXCLUDE_INGRESS the ingress interface will be
> excluded when do broadcasting.
> =

> When getting the devices in dev hash map via dev_map_hash_get_next_key(=
),
> there is a possibility that we fall back to the first key when a device=

> was removed. This will duplicate packets on some interfaces. So just wa=
lk
> the whole buckets to avoid this issue. For dev array map, we also walk =
the
> whole map to find valid interfaces.
> =

> Function bpf_clear_redirect_map() was removed in
> commit ee75aef23afe ("bpf, xdp: Restructure redirect actions").
> Add it back as we need to use ri->map again.
> =

> With test topology:
>   +-------------------+             +-------------------+
>   | Host A (i40e 10G) |  ---------- | eno1(i40e 10G)    |
>   +-------------------+             |                   |
>                                     |   Host B          |
>   +-------------------+             |                   |
>   | Host C (i40e 10G) |  ---------- | eno2(i40e 10G)    |
>   +-------------------+             |                   |
>                                     |          +------+ |
>                                     | veth0 -- | Peer | |
>                                     | veth1 -- |      | |
>                                     | veth2 -- |  NS  | |
>                                     |          +------+ |
>                                     +-------------------+
> =

> On Host A:
>  # pktgen/pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $d=
st_mac -s 64
> =

> On Host B(Intel(R) Xeon(R) CPU E5-2690 v3 @ 2.60GHz, 128G Memory):
> Use xdp_redirect_map and xdp_redirect_map_multi in samples/bpf for test=
ing.
> All the veth peers in the NS have a XDP_DROP program loaded. The
> forward_map max_entries in xdp_redirect_map_multi is modify to 4.
> =

> Testing the performance impact on the regular xdp_redirect path with an=
d
> without patch (to check impact of additional check for broadcast mode):=

> =

> 5.12 rc4         | redirect_map        i40e->i40e      |    2.0M |  9.7=
M
> 5.12 rc4         | redirect_map        i40e->veth      |    1.7M | 11.8=
M
> 5.12 rc4 + patch | redirect_map        i40e->i40e      |    2.0M |  9.6=
M
> 5.12 rc4 + patch | redirect_map        i40e->veth      |    1.7M | 11.7=
M
> =

> Testing the performance when cloning packets with the redirect_map_mult=
i
> test, using a redirect map size of 4, filled with 1-3 devices:
> =

> 5.12 rc4 + patch | redirect_map multi  i40e->veth (x1) |    1.7M | 11.4=
M
> 5.12 rc4 + patch | redirect_map multi  i40e->veth (x2) |    1.1M |  4.3=
M
> 5.12 rc4 + patch | redirect_map multi  i40e->veth (x3) |    0.8M |  2.6=
M
> =

> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

[...]

LGTM thanks for sticking with it.

Acked-by: John Fastabend <john.fastabend@gmail.com>=
