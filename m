Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0A13473BA
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 09:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbhCXIcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 04:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233734AbhCXIcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 04:32:19 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D21CC0613DE
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 01:32:19 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id u21so13467845ejo.13
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 01:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9wesJELvx+bK90Yan+GlwOUfkFnftNNGgIWX46f5DhQ=;
        b=L5atFcpsn0qNbjNj7+QZ02Oz0hoT2IwnUUb1X3pIkgCn/fQL0kEomBej8koaqkwTX6
         VOe+lESjI9UHyARWxWYqibBuTvTD685c4Xo0v2pzZX+89XuODZzvzBS5O7OBrnJooOar
         tgrPuh7FYK9KU06ShlIMEU+MvsonPD6XDVFoPLvVV3tl/8H1BiOXAYh+LHbypOJiBiEf
         EIk+/0Ul+rMGLlg7sXk14gAzOKZ2+N3cxLvo1u3fhKpe374sAw6n232doa7z01aXaZIR
         FlayPGPnu4/MJWtlHTGBNWWYPPe7JiH6tH1eKFL8IEfVDXq8NCiSC/tIHQoMrrOM60GG
         5ftw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9wesJELvx+bK90Yan+GlwOUfkFnftNNGgIWX46f5DhQ=;
        b=hakpUclvuNErLuziYlje2BYtizKINkLcelpSQvkkRXgfAdmuyxYSo4qh8DNmX7WM0l
         K379WIR2ZXeTnD4V/FHYFjmkecRIcVoTfM9Zo/faJMbcUvTs00fbFeVd3ywG5TZBRi/6
         gr1P/RZDSck6FWGSu39Ukg37HHrZ2j44KO7GkwT14snUENqpPq/UqxZ27FltATwRvtjg
         +VGwvdxorHZXKtZV8MUn2WMH76wKDhXeis1zito6PGZdcnrkD7uoxDsnXYymtyj9xwiL
         5fo+HbnTslDFF8SAUm+mgjF2mwDujC1to9tNANroHNrDnq73RZifZwhd7bWd90gAJLvv
         VntQ==
X-Gm-Message-State: AOAM532hm+tWyRV4tIQmRNdXhbFJpFYLJnKMWq8kr/nfsOROZgsu1Qvt
        XNLcEyV4RyVHEupl7EE91peqNgxEiqG8MDfKqqL0Lw==
X-Google-Smtp-Source: ABdhPJwuTFnAurZuzernlxyfX3QtBwNudCt6QCdVR9y0FMZrPDSlDQGybI886gY9MvLiyhEhD6FSCvVcRKHGerG7zE8=
X-Received: by 2002:a17:907:720a:: with SMTP id dr10mr2343237ejc.375.1616574737826;
 Wed, 24 Mar 2021 01:32:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210322121933.746237845@linuxfoundation.org> <20210322121937.071435221@linuxfoundation.org>
In-Reply-To: <20210322121937.071435221@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 24 Mar 2021 14:02:06 +0530
Message-ID: <CA+G9fYvRM+9DmGuKM0ErDnrYBOmZ6zzmMkrWevMJqOzhejWwZg@mail.gmail.com>
Subject: Re: [PATCH 5.10 104/157] mptcp: put subflow sock on connect error
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        lkft-triage@lists.linaro.org, Netdev <netdev@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Mar 2021 at 18:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Florian Westphal <fw@strlen.de>
>
> [ Upstream commit f07157792c633b528de5fc1dbe2e4ea54f8e09d4 ]
>
> mptcp_add_pending_subflow() performs a sock_hold() on the subflow,
> then adds the subflow to the join list.
>
> Without a sock_put the subflow sk won't be freed in case connect() fails.
>
> unreferenced object 0xffff88810c03b100 (size 3000):
> [..]
>     sk_prot_alloc.isra.0+0x2f/0x110
>     sk_alloc+0x5d/0xc20
>     inet6_create+0x2b7/0xd30
>     __sock_create+0x17f/0x410
>     mptcp_subflow_create_socket+0xff/0x9c0
>     __mptcp_subflow_connect+0x1da/0xaf0
>     mptcp_pm_nl_work+0x6e0/0x1120
>     mptcp_worker+0x508/0x9a0
>
> Fixes: 5b950ff4331ddda ("mptcp: link MPC subflow into msk only after accept")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

I have reported the following warnings and kernel crash on 5.10.26-rc2 [1]
The bisect reported that issue pointing out to this commit.

commit 460916534896e6d4f80a37152e0948db33376873
mptcp: put subflow sock on connect error

This problem is specific to 5.10.26-rc2.

Warning:
--------
[ 1040.114695] refcount_t: addition on 0; use-after-free.
[ 1040.119857] WARNING: CPU: 3 PID: 31925 at
/usr/src/kernel/lib/refcount.c:25 refcount_warn_saturate+0xd7/0x100
[ 1040.129769] Modules linked in: act_mirred cls_u32 sch_netem sch_etf
ip6table_nat xt_nat iptable_nat nf_nat ip6table_filter xt_conntrack
nf_conntrack nf_defrag_ipv4 libcrc32c ip6_tables nf_defrag_ipv6 sch_fq
iptable_filter xt_mark ip_tables cls_bpf sch_ingress algif_hash
x86_pkg_temp_thermal fuse [last unloaded: test_blackhole_dev]
[ 1040.159030] CPU: 3 PID: 31925 Comm: mptcp_connect Tainted: G
W     K   5.10.26-rc2 #1
[ 1040.167459] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.2 05/23/2018
[ 1040.174851] RIP: 0010:refcount_warn_saturate+0xd7/0x100

And

Kernel Panic:
-------------
[ 1069.557485] BUG: kernel NULL pointer dereference, address: 0000000000000010
[ 1069.564446] #PF: supervisor read access in kernel mode
[ 1069.569583] #PF: error_code(0x0000) - not-present page
[ 1069.574714] PGD 0 P4D 0
[ 1069.577246] Oops: 0000 [#1] SMP PTI
[ 1069.580730] CPU: 1 PID: 17 Comm: ksoftirqd/1 Tainted: G        W
 K   5.10.26-rc2 #1
[ 1069.588719] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.2 05/23/2018
[ 1069.596106] RIP: 0010:selinux_socket_sock_rcv_skb+0x3f/0x290
...
[ 1069.961697] Kernel panic - not syncing: Fatal exception in interrupt
[ 1069.968083] Kernel Offset: 0x18600000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)

steps to reproduce:
--------------------------
          - cd /opt/kselftests/mainline/net/mptcp
          - ./mptcp_join.sh  || true

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

crash test link:
https://lkft.validation.linaro.org/scheduler/job/2436164

Revert this commit and test job:
https://lkft.validation.linaro.org/scheduler/job/2437401#L1207


> ---
>  net/mptcp/subflow.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
> index 16adba172fb9..591546d0953f 100644
> --- a/net/mptcp/subflow.c
> +++ b/net/mptcp/subflow.c
> @@ -1133,6 +1133,7 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
>         spin_lock_bh(&msk->join_list_lock);
>         list_add_tail(&subflow->node, &msk->join_list);
>         spin_unlock_bh(&msk->join_list_lock);
> +       sock_put(mptcp_subflow_tcp_sock(subflow));
>
>         return err;
>

url:
[1] https://lore.kernel.org/stable/20210323182123.3ce89282@yaviniv.e18.physik.tu-muenchen.de/T/#m7994b86b52391a746e7d5be214885a5a1b2f9713

-- 
Linaro LKFT
https://lkft.linaro.org
