Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5B1DEABF
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 13:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbfJULXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 07:23:39 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39211 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727433AbfJULXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 07:23:38 -0400
Received: by mail-qk1-f195.google.com with SMTP id 4so12197478qki.6;
        Mon, 21 Oct 2019 04:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4SIKg7fkKv4f5oFDvoKTFfO1xQS++1EKIUX0O9ZXAm0=;
        b=O4yQJ8969KS6QyYr8aiiUkpRHg4e6b/Ndys4gKsb9kSt/U4m6ZlzIbSgsdzxkt0sG+
         3k6KAK87KmCwo73LyOkI6+VQ+QUEgt7RZSuwxwAlpzr8KV0sQL0FV50NY4r1cNHZoAy4
         Hl7VwQtvP1m15wM0TSkqTBG7tRGBO1vFZu+i2kaJWZs2hYZfO/wACqZ/dqGX6lfQ7zZh
         VNRa/WBtC7v6btRyM0qAnH2o0GEmyMg/ebWgX3UfibWLq9fQzWcofGSHJuKj1188tYdT
         IAyKf3jnltsUMHqcCM3SXiM6J3emh5bFrlmt+ge/8GOmBM7YCdFlUHMJZPn2ExRVsTy/
         ZdjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4SIKg7fkKv4f5oFDvoKTFfO1xQS++1EKIUX0O9ZXAm0=;
        b=U+RV4DL2lewe6lfrR7uHbdisHbMyxgn9xAxrqeE333N68QAv5IfkbQpdM7CaZHkOPi
         z/IfW2nqGEfQFOKZM+TTiL3SlR+WS3iasaNp2Dn5+EAXiD4/nW8uLZmJupqUtxeWuNze
         miiee2sXYj9zqVD8W7kfplp/OUwIvfe5I8S72N66LLM/1XI+hCMMGr2CCVc+x/0oxuUI
         3ytPei7IyrR0hdoISJa4di3+ozOjYU20r5tFD3btaFg9abTw5D9UFQTkCVSfOl0rVB1V
         AERq1BkEryamedmip+6WbvXicp1mXc6djUP2/jiMfU23paYg5nZdDGwVcRe4SZ6oh0R+
         On4g==
X-Gm-Message-State: APjAAAUVEx7AJtWyGXekw0uf1H2DOGQ/FZlwSWzGN14Y90azak+NXUQo
        lnsAl4yfb5kB3AHoc7R50aOdQOTSzF+6UzPLrdWmmf69AS52Rg==
X-Google-Smtp-Source: APXvYqyb3cq9iqVgxSuE6BHAwvkJujJTOf6AscDEx6NWojVeM+uHa/0awpDTJBoTEsuFk1OSmoxI29XNKv01M1jsQW4=
X-Received: by 2002:a05:620a:13f2:: with SMTP id h18mr21436800qkl.218.1571657015774;
 Mon, 21 Oct 2019 04:23:35 -0700 (PDT)
MIME-Version: 1.0
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
In-Reply-To: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 21 Oct 2019 13:23:23 +0200
Message-ID: <CAJ+HfNga=XFeutQuGvGXkuWKSsDCqak-rjutOzqu-r-pwLL1-w@mail.gmail.com>
Subject: Re: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Pravin B Shelar <pshelar@ovn.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        William Tu <u9012063@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 19 Oct 2019 at 00:31, Toshiaki Makita
<toshiaki.makita1@gmail.com> wrote:
>
[...]
>
> * About OVS AF_XDP netdev
>
> Recently OVS has added AF_XDP netdev type support. This also makes use
> of XDP, but in some ways different from this patch set.
>
> - AF_XDP work originally started in order to bring BPF's flexibility to
>   OVS, which enables us to upgrade datapath without updating kernel.
>   AF_XDP solution uses userland datapath so it achieved its goal.
>   xdp_flow will not replace OVS datapath completely, but offload it
>   partially just for speed up.
>
> - OVS AF_XDP requires PMD for the best performance so consumes 100% CPU
>   as well as using another core for softirq.
>

Disclaimer; I haven't studied the OVS AF_XDP code, so this is about
AF_XDP in general.

One of the nice things about AF_XDP is that it *doesn't* force a user
to busy-poll (burn CPUs) like a regular userland pull-mode driver.
Yes, you can do that if you're extremely latency sensitive, but for
most users (and I think some OVS deployments might fit into this
category) not pinning cores/interrupts and using poll() syscalls (need
wakeup patch [1]) is the way to go. The scenario you're describing
with ksoftirqd spinning on one core, and user application on another
is not something I'd recommend, rather run your packet processing
application on one core together with the softirq processing.

Bj=C3=B6rn
[1] https://lore.kernel.org/bpf/1565767643-4908-1-git-send-email-magnus.kar=
lsson@intel.com/#t



> - OVS AF_XDP needs packet copy when forwarding packets.
>
> - xdp_flow can be used not only for OVS. It works for direct use of TC
>   flower and nftables.
>
>
> * About alternative userland (ovs-vswitchd etc.) implementation
>
> Maybe a similar logic can be implemented in ovs-vswitchd offload
> mechanism, instead of adding code to kernel. I just thought offloading
> TC is more generic and allows wider usage with direct TC command.
>
> For example, considering that OVS inserts a flow to kernel only when
> flow miss happens in kernel, we can in advance add offloaded flows via
> tc filter to avoid flow insertion latency for certain sensitive flows.
> TC flower usage without using OVS is also possible.
>
> Also as written above nftables can be offloaded to XDP with this
> mechanism as well.
>
> Another way to achieve this from userland is to add notifications in
> flow_offload kernel code to inform userspace of flow addition and
> deletion events, and listen them by a deamon which in turn loads eBPF
> programs, attach them to XDP, and modify eBPF maps. Although this may
> open up more use cases, I'm not thinking this is the best solution
> because it requires emulation of kernel behavior as an offload engine
> but flow related code is heavily changing which is difficult to follow
> from out of tree.
>
> * Note
>
> This patch set is based on top of commit 5bc60de50dfe ("selftests: bpf:
> Don't try to read files without read permission") on bpf-next, but need
> to backport commit 98beb3edeb97 ("samples/bpf: Add a workaround for
> asm_inline") from bpf tree to successfully build the module.
>
> * Changes
>
> RFC v2:
>  - Use indr block instead of modifying TC core, feedback from Jakub
>    Kicinski.
>  - Rename tc-offload-xdp to flow-offload-xdp since this works not only
>    for TC but also for nftables, as now I use indr flow block.
>  - Factor out XDP program validation code in net/core and use it to
>    attach a program to XDP from xdp_flow.
>  - Use /dev/kmsg instead of syslog.
>
> Any feedback is welcome.
> Thanks!
>
> Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
>
> Toshiaki Makita (15):
>   xdp_flow: Add skeleton of XDP based flow offload driver
>   xdp_flow: Add skeleton bpf program for XDP
>   bpf: Add API to get program from id
>   xdp: Export dev_check_xdp and dev_change_xdp
>   xdp_flow: Attach bpf prog to XDP in kernel after UMH loaded program
>   xdp_flow: Prepare flow tables in bpf
>   xdp_flow: Add flow entry insertion/deletion logic in UMH
>   xdp_flow: Add flow handling and basic actions in bpf prog
>   xdp_flow: Implement flow replacement/deletion logic in xdp_flow kmod
>   xdp_flow: Add netdev feature for enabling flow offload to XDP
>   xdp_flow: Implement redirect action
>   xdp_flow: Implement vlan_push action
>   bpf, selftest: Add test for xdp_flow
>   i40e: prefetch xdp->data before running XDP prog
>   bpf, hashtab: Compare keys in long
>
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c  |    1 +
>  include/linux/bpf.h                          |    8 +
>  include/linux/netdev_features.h              |    2 +
>  include/linux/netdevice.h                    |    4 +
>  kernel/bpf/hashtab.c                         |   27 +-
>  kernel/bpf/syscall.c                         |   42 +-
>  net/Kconfig                                  |    1 +
>  net/Makefile                                 |    1 +
>  net/core/dev.c                               |  113 ++-
>  net/core/ethtool.c                           |    1 +
>  net/xdp_flow/.gitignore                      |    1 +
>  net/xdp_flow/Kconfig                         |   16 +
>  net/xdp_flow/Makefile                        |  112 +++
>  net/xdp_flow/msgfmt.h                        |  102 +++
>  net/xdp_flow/umh_bpf.h                       |   34 +
>  net/xdp_flow/xdp_flow.h                      |   28 +
>  net/xdp_flow/xdp_flow_core.c                 |  180 +++++
>  net/xdp_flow/xdp_flow_kern_bpf.c             |  358 +++++++++
>  net/xdp_flow/xdp_flow_kern_bpf_blob.S        |    7 +
>  net/xdp_flow/xdp_flow_kern_mod.c             |  699 +++++++++++++++++
>  net/xdp_flow/xdp_flow_umh.c                  | 1043 ++++++++++++++++++++=
++++++
>  net/xdp_flow/xdp_flow_umh_blob.S             |    7 +
>  tools/testing/selftests/bpf/Makefile         |    1 +
>  tools/testing/selftests/bpf/test_xdp_flow.sh |  106 +++
>  24 files changed, 2864 insertions(+), 30 deletions(-)
>  create mode 100644 net/xdp_flow/.gitignore
>  create mode 100644 net/xdp_flow/Kconfig
>  create mode 100644 net/xdp_flow/Makefile
>  create mode 100644 net/xdp_flow/msgfmt.h
>  create mode 100644 net/xdp_flow/umh_bpf.h
>  create mode 100644 net/xdp_flow/xdp_flow.h
>  create mode 100644 net/xdp_flow/xdp_flow_core.c
>  create mode 100644 net/xdp_flow/xdp_flow_kern_bpf.c
>  create mode 100644 net/xdp_flow/xdp_flow_kern_bpf_blob.S
>  create mode 100644 net/xdp_flow/xdp_flow_kern_mod.c
>  create mode 100644 net/xdp_flow/xdp_flow_umh.c
>  create mode 100644 net/xdp_flow/xdp_flow_umh_blob.S
>  create mode 100755 tools/testing/selftests/bpf/test_xdp_flow.sh
>
> --
> 1.8.3.1
>
