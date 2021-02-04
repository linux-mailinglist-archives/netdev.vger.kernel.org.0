Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFB7830E863
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233887AbhBDAPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233839AbhBDAPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 19:15:53 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EDE6C061573;
        Wed,  3 Feb 2021 16:15:13 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id e19so932395pfh.6;
        Wed, 03 Feb 2021 16:15:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JvWpJy2rHmsjHN5PZj6IB+fkeD+OgR1WsOSh0dE3jZo=;
        b=DcdNThIICdroPBZPrHQpDhNklnCJbe9ZnzTn6+0OXTp0RggbktACBbj/1ySKkTfExq
         GQXaa2MpD1bpuAngtO6b+cF4bscDI6fmWgdLsbsXehXeg5ReazGsWyWMwxfnnp3ZodyU
         yyHPzv/2AuW6QxaW+TAD8j4Cbt6WeNNBJrjPshZ2KRC0ZH2NF6TgGZO5n2khx5RIS/mF
         h6R/JHgwcEIv9mEpjwA6Ag2/W8lfksK6Pd0jRvDvMyTvROVt9er7/XEHpknE77HfLL25
         eRggybRoI5tcTg2EHz438np+UciqAGxUZWI7Yb5qwcC54DEx8JJvAE6GWVUM16Q2WFWo
         pLAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JvWpJy2rHmsjHN5PZj6IB+fkeD+OgR1WsOSh0dE3jZo=;
        b=TNeXnqltKBToRsOjtjf3NYLIVsuDj55judbd1phyfm6DvaXi50OYO9TYRgb13sOYu+
         6ah3VXBiL4j+ROmmpUV+NXZM9k2JR92IQG5rVZyVGRxmuBybBH4OWruPvsMfbtkk/gGo
         0NisNANUvV9OGUPchIjTJ9UUVDotkFClghoszJsj2uOyovI/by7XBrypqcUVS5shz/ne
         eBBS02T3KeNNk5pHxig6WB7dyoYWn0PnrUntwSn1SR6+1aAT2QsKhw5JodlWFeJXtQ7h
         8+p16DDEVGcxa6BwsTLx+xXqLpOVE87/xe+5v0V/AIXowe9AuB37CUIKpBJOybnyyXBF
         liJA==
X-Gm-Message-State: AOAM533Uic8SM5uSVB1rs8tY7d6wiUgF9q9J+Gt/iWj+D5m0ZDXJl7vc
        xIx2JtzJ9qxgUr7NpKheOks=
X-Google-Smtp-Source: ABdhPJztQaTMJRwjH/DbIRNc/Q5eI33lUm0+gBbKUKPAG4WlRJrLe3GfI04xG/HNOGpssHxH0ZUmHA==
X-Received: by 2002:a62:8f96:0:b029:1b7:75a9:a8b7 with SMTP id n144-20020a628f960000b02901b775a9a8b7mr5578426pfd.28.1612397712706;
        Wed, 03 Feb 2021 16:15:12 -0800 (PST)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h3sm3861126pgm.67.2021.02.03.16.15.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 16:15:11 -0800 (PST)
Date:   Thu, 4 Feb 2021 08:14:58 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        bpf@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: Re: [PATCHv17 bpf-next 0/6] xdp: add a new helper for dev map
 multicast support
Message-ID: <20210204001458.GB2900@Leo-laptop-t470s>
References: <20210122074652.2981711-1-liuhangbin@gmail.com>
 <20210125124516.3098129-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125124516.3098129-1-liuhangbin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel, Alexei,

It has been one week after Maciej, Toke, John's review/ack. What should
I do to make a progress for this patch set?

Thanks
Hangbin
On Mon, Jan 25, 2021 at 08:45:10PM +0800, Hangbin Liu wrote:
> This patch is for xdp multicast support. which has been discussed before[0],
> The goal is to be able to implement an OVS-like data plane in XDP, i.e.,
> a software switch that can forward XDP frames to multiple ports.
> 
> To achieve this, an application needs to specify a group of interfaces
> to forward a packet to. It is also common to want to exclude one or more
> physical interfaces from the forwarding operation - e.g., to forward a
> packet to all interfaces in the multicast group except the interface it
> arrived on. While this could be done simply by adding more groups, this
> quickly leads to a combinatorial explosion in the number of groups an
> application has to maintain.
> 
> To avoid the combinatorial explosion, we propose to include the ability
> to specify an "exclude group" as part of the forwarding operation. This
> needs to be a group (instead of just a single port index), because there
> may have multi interfaces you want to exclude.
> 
> Thus, the logical forwarding operation becomes a "set difference"
> operation, i.e. "forward to all ports in group A that are not also in
> group B". This series implements such an operation using device maps to
> represent the groups. This means that the XDP program specifies two
> device maps, one containing the list of netdevs to redirect to, and the
> other containing the exclude list.
> 
> To achieve this, I re-implement a new helper bpf_redirect_map_multi()
> to accept two maps, the forwarding map and exclude map. If user
> don't want to use exclude map and just want simply stop redirecting back
> to ingress device, they can use flag BPF_F_EXCLUDE_INGRESS.
> 
> The 1st patch is Jesper's run devmap xdp_prog later in bulking step.
> The 2st patch add a new bpf arg to allow NULL map pointer.
> The 3rd patch add the new bpf_redirect_map_multi() helper.
> The 4-6 patches are for usage sample and testing purpose.
> 
> I did same perf tests with the following topo:
> 
> ---------------------             ---------------------
> | Host A (i40e 10G) |  ---------- | eno1(i40e 10G)    |
> ---------------------             |                   |
>                                   |   Host B          |
> ---------------------             |                   |
> | Host C (i40e 10G) |  ---------- | eno2(i40e 10G)    |
> ---------------------    vlan2    |          -------- |
>                                   | veth1 -- | veth0| |
>                                   |          -------- |
>                                   --------------------|
> On Host A:
> # pktgen/pktgen_sample03_burst_single_flow.sh -i eno1 -d $dst_ip -m $dst_mac -s 64
> 
> On Host B(Intel(R) Xeon(R) CPU E5-2690 v3 @ 2.60GHz, 128G Memory):
> Use xdp_redirect_map and xdp_redirect_map_multi in samples/bpf for testing.
> The veth0 in netns load dummy drop program. The forward_map max_entries in
> xdp_redirect_map_multi is modify to 4.
> 
> Here is the perf result with 5.10 rc6:
> 
> The are about +/- 0.1M deviation for native testing
> Version             | Test                                    | Generic | Native | Native + 2nd
> 5.10 rc6            | xdp_redirect_map        i40e->i40e      |    2.0M |   9.1M |  8.0M
> 5.10 rc6            | xdp_redirect_map        i40e->veth      |    1.7M |  11.0M |  9.7M
> 5.10 rc6 + patch1   | xdp_redirect_map        i40e->i40e      |    2.0M |   9.5M |  7.5M
> 5.10 rc6 + patch1   | xdp_redirect_map        i40e->veth      |    1.7M |  11.6M |  9.1M
> 5.10 rc6 + patch1-6 | xdp_redirect_map        i40e->i40e      |    2.0M |   9.5M |  7.5M
> 5.10 rc6 + patch1-6 | xdp_redirect_map        i40e->veth      |    1.7M |  11.6M |  9.1M
> 5.10 rc6 + patch1-6 | xdp_redirect_map_multi  i40e->i40e      |    1.7M |   7.8M |  6.4M
> 5.10 rc6 + patch1-6 | xdp_redirect_map_multi  i40e->veth      |    1.4M |   9.3M |  7.5M
> 5.10 rc6 + patch1-6 | xdp_redirect_map_multi  i40e->i40e+veth |    1.0M |   3.2M |  2.7M
> 
> Last but not least, thanks a lot to Toke, Jesper, Jiri and Eelco for
> suggestions and help on implementation.
> 
> [0] https://xdp-project.net/#Handling-multicast
> 
> v17:
> For patch 01:
> a) rename to_sent to to_send.
> b) clear bq dev_rx, xdp_prog and flush_node in __dev_flush().
> 
> v16:
> refactor bq_xmit_all logic and remove error label for patch 01
> 
> v15:
> Update bq_xmit_all() logic for patch 01.
> Add some comments and remove useless variable for patch 03.
> Use bpf_object__find_program_by_title() for patch 04 and 06.
> 
> v14:
> No code update, just rebase the code on latest bpf-next
> 
> v13:
> Pass in xdp_prog through __xdp_enqueue() for patch 01. Update related
> code in patch 03.
> 
> v12:
> Add Jesper's xdp_prog patch, rebase my works on this and latest bpf-next
> Add 2nd xdp_prog test on the sample and selftests.
> 
> v11:
> Fix bpf_redirect_map_multi() helper description typo.
> Add loop limit for devmap_get_next_obj() and dev_map_redirect_multi().
> 
> v10:
> Rebase the code to latest bpf-next.
> Update helper bpf_xdp_redirect_map_multi()
> - No need to check map pointer as we will do the check in verifier.
> 
> v9:
> Update helper bpf_xdp_redirect_map_multi()
> - Use ARG_CONST_MAP_PTR_OR_NULL for helper arg2
> 
> v8:
> a) Update function dev_in_exclude_map():
>    - remove duplicate ex_map map_type check in
>    - lookup the element in dev map by obj dev index directly instead
>      of looping all the map
> 
> v7:
> a) Fix helper flag check
> b) Limit the *ex_map* to use DEVMAP_HASH only and update function
>    dev_in_exclude_map() to get better performance.
> 
> v6: converted helper return types from int to long
> 
> v5:
> a) Check devmap_get_next_key() return value.
> b) Pass through flags to __bpf_tx_xdp_map() instead of bool value.
> c) In function dev_map_enqueue_multi(), consume xdpf for the last
>    obj instead of the first on.
> d) Update helper description and code comments to explain that we
>    use NULL target value to distinguish multicast and unicast
>    forwarding.
> e) Update memory model, memory id and frame_sz in xdpf_clone().
> f) Split the tests from sample and add a bpf kernel selftest patch.
> 
> v4: Fix bpf_xdp_redirect_map_multi_proto arg2_type typo
> 
> v3: Based on Toke's suggestion, do the following update
> a) Update bpf_redirect_map_multi() description in bpf.h.
> b) Fix exclude_ifindex checking order in dev_in_exclude_map().
> c) Fix one more xdpf clone in dev_map_enqueue_multi().
> d) Go find next one in dev_map_enqueue_multi() if the interface is not
>    able to forward instead of abort the whole loop.
> e) Remove READ_ONCE/WRITE_ONCE for ex_map.
> 
> v2: Add new syscall bpf_xdp_redirect_map_multi() which could accept
> include/exclude maps directly.
> 
> Hangbin Liu (5):
>   bpf: add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL
>   xdp: add a new helper for dev map multicast support
>   sample/bpf: add xdp_redirect_map_multicast test
>   selftests/bpf: Add verifier tests for bpf arg
>     ARG_CONST_MAP_PTR_OR_NULL
>   selftests/bpf: add xdp_redirect_multi test
> 
> Jesper Dangaard Brouer (1):
>   bpf: run devmap xdp_prog on flush instead of bulk enqueue
> 
>  include/linux/bpf.h                           |  21 ++
>  include/linux/filter.h                        |   1 +
>  include/net/xdp.h                             |   1 +
>  include/uapi/linux/bpf.h                      |  28 ++
>  kernel/bpf/devmap.c                           | 262 +++++++++++----
>  kernel/bpf/verifier.c                         |  16 +-
>  net/core/filter.c                             | 124 ++++++-
>  net/core/xdp.c                                |  29 ++
>  samples/bpf/Makefile                          |   3 +
>  samples/bpf/xdp_redirect_map_multi_kern.c     |  87 +++++
>  samples/bpf/xdp_redirect_map_multi_user.c     | 302 ++++++++++++++++++
>  tools/include/uapi/linux/bpf.h                |  28 ++
>  tools/testing/selftests/bpf/Makefile          |   3 +-
>  .../bpf/progs/xdp_redirect_multi_kern.c       | 111 +++++++
>  tools/testing/selftests/bpf/test_verifier.c   |  22 +-
>  .../selftests/bpf/test_xdp_redirect_multi.sh  | 208 ++++++++++++
>  .../testing/selftests/bpf/verifier/map_ptr.c  |  70 ++++
>  .../selftests/bpf/xdp_redirect_multi.c        | 252 +++++++++++++++
>  18 files changed, 1501 insertions(+), 67 deletions(-)
>  create mode 100644 samples/bpf/xdp_redirect_map_multi_kern.c
>  create mode 100644 samples/bpf/xdp_redirect_map_multi_user.c
>  create mode 100644 tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
>  create mode 100755 tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
>  create mode 100644 tools/testing/selftests/bpf/xdp_redirect_multi.c
> 
> -- 
> 2.26.2
> 
