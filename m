Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33EE43D4378
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 01:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbhGWXKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 19:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233064AbhGWXKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 19:10:05 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F44C061757
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 16:50:37 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id gv20-20020a17090b11d4b0290173b9578f1cso7496428pjb.0
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 16:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=7SgSAGeBNdE+RA8pXrl6mKtbBX/ebG3IJgy0AQX8hc0=;
        b=JdZ2J1vly0JPvePL7fRD5u4EeqxDK6UCnnvbOgZikfiwKMPo9ZVT4oxL6Uoddx3aoK
         pIogPBd+hP3lUsAZMA5wvErEaoqtChi8XjV5Ly9mvZcaAlUxlSPnE83bBlEMKZsDbBNP
         7ZFrMxYeLILVIkQCXvynFna2fnxg/OV0Sy0eVVQdVOPjddH6fD/fGEYfcm3gMW4y2qHF
         33K/UmTdu4CXor49QOyKdSJbgHMHve8oT55CDvD0HQmEKJDwbvfrEGcSD2v8shgeFHHy
         IjeA+2LT6hCd0rpX+kGOaPUyyr7wiIzen//8X3qXkajXxBB6oi/0RCrFnnAMRwX1rsIq
         5idA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=7SgSAGeBNdE+RA8pXrl6mKtbBX/ebG3IJgy0AQX8hc0=;
        b=gqqSvEI+SOVS3MGKU6+kacGgJutwxu9AQud7Xg7BX+LhWluc7aCuJgl2E7pRzVxzyS
         u5I5/XrgJQjUz4Hg+GqKPDnBmlIlb+1EN/omZx42MmnbH0BJZpftopyKwUXBTMTV9DdU
         Q+VT3jHe16bEdliPTaeKY27/a4xAQMM6G0k+OzBAw806kglPy1vmz6VkwSxL6QlkyF5l
         UCm2AUAu3+fUuTGb4fGB5Bz6eXrVfPHFofICCUYfGI6ouDwXOkAXx8rr/VXZAbifkZq3
         MJq3Pg9+XR2jI6z1kx12JlzEbG5cTx0U53HorahIgkhPCIqC7JONeHCjnCCQnL6zS01/
         e7dA==
X-Gm-Message-State: AOAM531inL2wWOBMHLSQMa9398cyQY20yloWznapvvJKMJKIpaIfQL1d
        sX+3aFwBO/fesayiPdRHPEm5MQ==
X-Google-Smtp-Source: ABdhPJyzkVQkkyk9OkHiq19/FYweIn2HodFTbUd6MKsFaJf9VM/Q3R4gEz5zGqm0hlaIUdLfR3ak9A==
X-Received: by 2002:a65:568c:: with SMTP id v12mr7248539pgs.88.1627084236603;
        Fri, 23 Jul 2021 16:50:36 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id q18sm35081914pfj.178.2021.07.23.16.50.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 16:50:35 -0700 (PDT)
Subject: Re: [PATCH net-next v6 2/6] ethtool: improve compat ioctl handling
To:     Arnd Bergmann <arnd@kernel.org>, netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Christoph Hellwig <hch@lst.de>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Marco Elver <elver@google.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
References: <20210722142903.213084-1-arnd@kernel.org>
 <20210722142903.213084-3-arnd@kernel.org>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <b58e4938-6e3f-e766-bf3a-0b88b134903f@pensando.io>
Date:   Fri, 23 Jul 2021 16:50:33 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210722142903.213084-3-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/22/21 7:28 AM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> The ethtool compat ioctl handling is hidden away in net/socket.c,
> which introduces a couple of minor oddities:
>
> - The implementation may end up diverging, as seen in the RXNFC
>    extension in commit 84a1d9c48200 ("net: ethtool: extend RXNFC
>    API to support RSS spreading of filter matches") that does not work
>    in compat mode.
>
> - Most architectures do not need the compat handling at all
>    because u64 and compat_u64 have the same alignment.
>
> - On x86, the conversion is done for both x32 and i386 user space,
>    but it's actually wrong to do it for x32 and cannot work there.
>
> - On 32-bit Arm, it never worked for compat oabi user space, since
>    that needs to do the same conversion but does not.
>
> - It would be nice to get rid of both compat_alloc_user_space()
>    and copy_in_user() throughout the kernel.
>
> None of these actually seems to be a serious problem that real
> users are likely to encounter, but fixing all of them actually
> leads to code that is both shorter and more readable.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Something's odd here...  I didn't dive in to find the actual problem, 
but here's what I did find.  This doesn't happen before the patchset, 
but does happen after the patchset.  I built the kernel on a RHEL 8.4 
box using their config file as a basis.

[root@sln-dev ~]# ethtool --version
ethtool version 5.8

[root@sln-dev ~]# ethtool -i eno1
driver: tg3
version: 5.14.0-rc2-net-next-sln+
firmware-version: 5719-v1.46 NCSI v1.5.18.0
expansion-rom-version:
bus-info: 0000:02:00.0
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes
supports-priv-flags: no

[root@sln-dev ~]# ethtool -x eno1
Cannot get RX ring count: Bad address

And we get a stack trace here:
[ 1221.631085] ------------[ cut here ]------------
[ 1221.631105] Buffer overflow detected (8 < 192)!
[ 1221.631125] WARNING: CPU: 27 PID: 2363 at 
include/linux/thread_info.h:200 ethtool_rxnfc_copy_to_user+0x2b/0xb0
[ 1221.631150] Modules linked in: xt_CHECKSUM xt_MASQUERADE xt_conntrack 
ipt_REJECT nf_reject_ipv4 nft_compat nft_counter nft_chain_nat nf_nat 
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables nfnetlink tun 
bridge stp llc intel_rapl_msr intel_rapl_common isst_if_common rpcrdma 
rdma_ucm ib_srpt ib_isert iscsi_target_mod target_core_mod nfit ib_iser 
libnvdimm libiscsi scsi_transport_iscsi ib_umad ib_ipoib rdma_cm rfkill 
x86_pkg_temp_thermal intel_powerclamp iw_cm ib_cm coretemp kvm_intel kvm 
sunrpc mlx5_ib irqbypass crct10dif_pclmul crc32_pclmul 
ghash_clmulni_intel ib_uverbs rapl ipmi_ssif intel_cstate ib_core 
intel_uncore mei_me pcspkr ses mei enclosure acpi_ipmi hpwdt hpilo 
ioatdma intel_pch_thermal ipmi_si lpc_ich dca ipmi_devintf 
ipmi_msghandler acpi_tad acpi_power_meter ip_tables xfs libcrc32c sd_mod 
t10_pi sg mlx5_core mgag200 drm_kms_helper syscopyarea sysfillrect 
sysimgblt fb_sys_fops drm mlxfw pci_hyperv_intf ionic tls crc32c_intel 
smartpqi serio_raw tg3 scsi_transport_sas
[ 1221.631199]  psample i2c_algo_bit wmi dm_mirror dm_region_hash dm_log 
dm_mod fuse
[ 1221.631364] CPU: 27 PID: 2363 Comm: ethtool Tainted: G S W         
5.14.0-rc2-net-next-sln+ #7
[ 1221.631384] Hardware name: HPE ProLiant DL360 Gen10/ProLiant DL360 
Gen10, BIOS U32 01/23/2021
[ 1221.631401] RIP: 0010:ethtool_rxnfc_copy_to_user+0x2b/0xb0
[ 1221.631416] Code: 1f 44 00 00 41 55 65 48 8b 04 25 00 6f 01 00 41 54 
55 53 f6 40 10 02 75 23 be 08 00 00 00 48 c7 c7 20 f2 f1 89 e8 32 7d 14 
00 <0f> 0b 41 bd f2 ff ff ff 5b 44 89 e8 5d 41 5c 41 5d c3 48 89 fd 48
[ 1221.631451] RSP: 0018:ffffadc906e5bbd8 EFLAGS: 00010286
[ 1221.631463] RAX: 0000000000000000 RBX: ffffadc906e5bc00 RCX: 
0000000000000027
[ 1221.631478] RDX: 0000000000000027 RSI: ffff91163f857c80 RDI: 
ffff91163f857c88
[ 1221.631492] RBP: 0000000000000000 R08: 0000000000000000 R09: 
c0000000ffff7fff
[ 1221.631507] R10: 0000000000000001 R11: ffffadc906e5b9e8 R12: 
0000000000000000
[ 1221.631535] R13: 00007ffc5be4c730 R14: 00000000000000c0 R15: 
ffff90f83b558000
[ 1221.631551] FS:  00007fb10a942740(0000) GS:ffff91163f840000(0000) 
knlGS:0000000000000000
[ 1221.631584] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1221.631598] CR2: 000055ae4763a6f0 CR3: 0000001053530001 CR4: 
00000000007706e0
[ 1221.631621] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 1221.631636] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[ 1221.631667] PKRU: 55555554
[ 1221.631676] Call Trace:
[ 1221.631686]  ethtool_get_rxnfc+0xe8/0x1a0
[ 1221.631700]  dev_ethtool+0xb1a/0x2a20
[ 1221.631711]  ? do_set_pte+0xcb/0x110
[ 1221.632313]  ? inet_ioctl+0x158/0x1a0
[ 1221.632849]  ? page_counter_try_charge+0x57/0xc0
[ 1221.633374]  ? __cond_resched+0x15/0x30
[ 1221.633880]  dev_ioctl+0xb5/0x4e0
[ 1221.634374]  sock_do_ioctl+0x92/0xd0
[ 1221.634867]  sock_ioctl+0x246/0x340
[ 1221.635335]  __x64_sys_ioctl+0x81/0xc0
[ 1221.635817]  do_syscall_64+0x37/0x80
[ 1221.636281]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 1221.636760] RIP: 0033:0x7fb109ed062b
[ 1221.637210] Code: 0f 1e fa 48 8b 05 5d b8 2c 00 64 c7 00 26 00 00 00 
48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 2d b8 2c 00 f7 d8 64 89 01 48
[ 1221.638151] RSP: 002b:00007ffc5be4c6f8 EFLAGS: 00000246 ORIG_RAX: 
0000000000000010
[ 1221.638649] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 
00007fb109ed062b
[ 1221.639135] RDX: 00007ffc5be4c870 RSI: 0000000000008946 RDI: 
0000000000000003
[ 1221.639647] RBP: 00007ffc5be4c860 R08: 00007ffc5be4c870 R09: 
0000000000000001
[ 1221.640154] R10: 000055ae4764a934 R11: 0000000000000246 R12: 
000055ae47613b60
[ 1221.640647] R13: 00007ffc5be4c870 R14: 000055ae4764718e R15: 
000055ae47647196
[ 1221.641124] ---[ end trace 422c6846895775bd ]---



Cheers,
sln

> ---
> Changes in v2:
>   - remove extraneous 'inline' keyword (davem)
>   - split helper functions into smaller units (hch)
>   - remove arm oabi check with missing dependency (0day bot)
> ---
>   include/linux/ethtool.h |   4 --
>   net/ethtool/ioctl.c     | 136 +++++++++++++++++++++++++++++++++++-----
>   net/socket.c            | 125 +-----------------------------------
>   3 files changed, 121 insertions(+), 144 deletions(-)
>
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index 232daaec56e4..4711b96dae0c 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -17,8 +17,6 @@
>   #include <linux/compat.h>
>   #include <uapi/linux/ethtool.h>
>   
> -#ifdef CONFIG_COMPAT
> -
>   struct compat_ethtool_rx_flow_spec {
>   	u32		flow_type;
>   	union ethtool_flow_union h_u;
> @@ -38,8 +36,6 @@ struct compat_ethtool_rxnfc {
>   	u32				rule_locs[];
>   };
>   
> -#endif /* CONFIG_COMPAT */
> -
>   #include <linux/rculist.h>
>   
>   /**
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index baa5d10043cb..6134b180f59f 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -7,6 +7,7 @@
>    * the information ethtool needs.
>    */
>   
> +#include <linux/compat.h>
>   #include <linux/module.h>
>   #include <linux/types.h>
>   #include <linux/capability.h>
> @@ -807,6 +808,120 @@ static noinline_for_stack int ethtool_get_sset_info(struct net_device *dev,
>   	return ret;
>   }
>   
> +static noinline_for_stack int
> +ethtool_rxnfc_copy_from_compat(struct ethtool_rxnfc *rxnfc,
> +			       const struct compat_ethtool_rxnfc __user *useraddr,
> +			       size_t size)
> +{
> +	struct compat_ethtool_rxnfc crxnfc = {};
> +
> +	/* We expect there to be holes between fs.m_ext and
> +	 * fs.ring_cookie and at the end of fs, but nowhere else.
> +	 * On non-x86, no conversion should be needed.
> +	 */
> +	BUILD_BUG_ON(!IS_ENABLED(CONFIG_X86_64) &&
> +		     sizeof(struct compat_ethtool_rxnfc) !=
> +		     sizeof(struct ethtool_rxnfc));
> +	BUILD_BUG_ON(offsetof(struct compat_ethtool_rxnfc, fs.m_ext) +
> +		     sizeof(useraddr->fs.m_ext) !=
> +		     offsetof(struct ethtool_rxnfc, fs.m_ext) +
> +		     sizeof(rxnfc->fs.m_ext));
> +	BUILD_BUG_ON(offsetof(struct compat_ethtool_rxnfc, fs.location) -
> +		     offsetof(struct compat_ethtool_rxnfc, fs.ring_cookie) !=
> +		     offsetof(struct ethtool_rxnfc, fs.location) -
> +		     offsetof(struct ethtool_rxnfc, fs.ring_cookie));
> +
> +	if (copy_from_user(&crxnfc, useraddr, min(size, sizeof(crxnfc))))
> +		return -EFAULT;
> +
> +	*rxnfc = (struct ethtool_rxnfc) {
> +		.cmd		= crxnfc.cmd,
> +		.flow_type	= crxnfc.flow_type,
> +		.data		= crxnfc.data,
> +		.fs		= {
> +			.flow_type	= crxnfc.fs.flow_type,
> +			.h_u		= crxnfc.fs.h_u,
> +			.h_ext		= crxnfc.fs.h_ext,
> +			.m_u		= crxnfc.fs.m_u,
> +			.m_ext		= crxnfc.fs.m_ext,
> +			.ring_cookie	= crxnfc.fs.ring_cookie,
> +			.location	= crxnfc.fs.location,
> +		},
> +		.rule_cnt	= crxnfc.rule_cnt,
> +	};
> +
> +	return 0;
> +}
> +
> +static int ethtool_rxnfc_copy_from_user(struct ethtool_rxnfc *rxnfc,
> +					const void __user *useraddr,
> +					size_t size)
> +{
> +	if (compat_need_64bit_alignment_fixup())
> +		return ethtool_rxnfc_copy_from_compat(rxnfc, useraddr, size);
> +
> +	if (copy_from_user(rxnfc, useraddr, size))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static int ethtool_rxnfc_copy_to_compat(void __user *useraddr,
> +					const struct ethtool_rxnfc *rxnfc,
> +					size_t size, const u32 *rule_buf)
> +{
> +	struct compat_ethtool_rxnfc crxnfc;
> +
> +	memset(&crxnfc, 0, sizeof(crxnfc));
> +	crxnfc = (struct compat_ethtool_rxnfc) {
> +		.cmd		= rxnfc->cmd,
> +		.flow_type	= rxnfc->flow_type,
> +		.data		= rxnfc->data,
> +		.fs		= {
> +			.flow_type	= rxnfc->fs.flow_type,
> +			.h_u		= rxnfc->fs.h_u,
> +			.h_ext		= rxnfc->fs.h_ext,
> +			.m_u		= rxnfc->fs.m_u,
> +			.m_ext		= rxnfc->fs.m_ext,
> +			.ring_cookie	= rxnfc->fs.ring_cookie,
> +			.location	= rxnfc->fs.location,
> +		},
> +		.rule_cnt	= rxnfc->rule_cnt,
> +	};
> +
> +	if (copy_to_user(useraddr, &crxnfc, min(size, sizeof(crxnfc))))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static int ethtool_rxnfc_copy_to_user(void __user *useraddr,
> +				      const struct ethtool_rxnfc *rxnfc,
> +				      size_t size, const u32 *rule_buf)
> +{
> +	int ret;
> +
> +	if (compat_need_64bit_alignment_fixup()) {
> +		ret = ethtool_rxnfc_copy_to_compat(useraddr, rxnfc, size,
> +						   rule_buf);
> +		useraddr += offsetof(struct compat_ethtool_rxnfc, rule_locs);
> +	} else {
> +		ret = copy_to_user(useraddr, &rxnfc, size);
> +		useraddr += offsetof(struct ethtool_rxnfc, rule_locs);
> +	}
> +
> +	if (ret)
> +		return -EFAULT;
> +
> +	if (rule_buf) {
> +		if (copy_to_user(useraddr, rule_buf,
> +				 rxnfc->rule_cnt * sizeof(u32)))
> +			return -EFAULT;
> +	}
> +
> +	return 0;
> +}
> +
>   static noinline_for_stack int ethtool_set_rxnfc(struct net_device *dev,
>   						u32 cmd, void __user *useraddr)
>   {
> @@ -825,7 +940,7 @@ static noinline_for_stack int ethtool_set_rxnfc(struct net_device *dev,
>   		info_size = (offsetof(struct ethtool_rxnfc, data) +
>   			     sizeof(info.data));
>   
> -	if (copy_from_user(&info, useraddr, info_size))
> +	if (ethtool_rxnfc_copy_from_user(&info, useraddr, info_size))
>   		return -EFAULT;
>   
>   	rc = dev->ethtool_ops->set_rxnfc(dev, &info);
> @@ -833,7 +948,7 @@ static noinline_for_stack int ethtool_set_rxnfc(struct net_device *dev,
>   		return rc;
>   
>   	if (cmd == ETHTOOL_SRXCLSRLINS &&
> -	    copy_to_user(useraddr, &info, info_size))
> +	    ethtool_rxnfc_copy_to_user(useraddr, &info, info_size, NULL))
>   		return -EFAULT;
>   
>   	return 0;
> @@ -859,7 +974,7 @@ static noinline_for_stack int ethtool_get_rxnfc(struct net_device *dev,
>   		info_size = (offsetof(struct ethtool_rxnfc, data) +
>   			     sizeof(info.data));
>   
> -	if (copy_from_user(&info, useraddr, info_size))
> +	if (ethtool_rxnfc_copy_from_user(&info, useraddr, info_size))
>   		return -EFAULT;
>   
>   	/* If FLOW_RSS was requested then user-space must be using the
> @@ -867,7 +982,7 @@ static noinline_for_stack int ethtool_get_rxnfc(struct net_device *dev,
>   	 */
>   	if (cmd == ETHTOOL_GRXFH && info.flow_type & FLOW_RSS) {
>   		info_size = sizeof(info);
> -		if (copy_from_user(&info, useraddr, info_size))
> +		if (ethtool_rxnfc_copy_from_user(&info, useraddr, info_size))
>   			return -EFAULT;
>   		/* Since malicious users may modify the original data,
>   		 * we need to check whether FLOW_RSS is still requested.
> @@ -893,18 +1008,7 @@ static noinline_for_stack int ethtool_get_rxnfc(struct net_device *dev,
>   	if (ret < 0)
>   		goto err_out;
>   
> -	ret = -EFAULT;
> -	if (copy_to_user(useraddr, &info, info_size))
> -		goto err_out;
> -
> -	if (rule_buf) {
> -		useraddr += offsetof(struct ethtool_rxnfc, rule_locs);
> -		if (copy_to_user(useraddr, rule_buf,
> -				 info.rule_cnt * sizeof(u32)))
> -			goto err_out;
> -	}
> -	ret = 0;
> -
> +	ret = ethtool_rxnfc_copy_to_user(useraddr, &info, info_size, rule_buf);
>   err_out:
>   	kfree(rule_buf);
>   
> diff --git a/net/socket.c b/net/socket.c
> index 0b2dad3bdf7f..ec63cf6de33e 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -3152,128 +3152,6 @@ static int compat_dev_ifconf(struct net *net, struct compat_ifconf __user *uifc3
>   	return 0;
>   }
>   
> -static int ethtool_ioctl(struct net *net, struct compat_ifreq __user *ifr32)
> -{
> -	struct compat_ethtool_rxnfc __user *compat_rxnfc;
> -	bool convert_in = false, convert_out = false;
> -	size_t buf_size = 0;
> -	struct ethtool_rxnfc __user *rxnfc = NULL;
> -	struct ifreq ifr;
> -	u32 rule_cnt = 0, actual_rule_cnt;
> -	u32 ethcmd;
> -	u32 data;
> -	int ret;
> -
> -	if (get_user(data, &ifr32->ifr_ifru.ifru_data))
> -		return -EFAULT;
> -
> -	compat_rxnfc = compat_ptr(data);
> -
> -	if (get_user(ethcmd, &compat_rxnfc->cmd))
> -		return -EFAULT;
> -
> -	/* Most ethtool structures are defined without padding.
> -	 * Unfortunately struct ethtool_rxnfc is an exception.
> -	 */
> -	switch (ethcmd) {
> -	default:
> -		break;
> -	case ETHTOOL_GRXCLSRLALL:
> -		/* Buffer size is variable */
> -		if (get_user(rule_cnt, &compat_rxnfc->rule_cnt))
> -			return -EFAULT;
> -		if (rule_cnt > KMALLOC_MAX_SIZE / sizeof(u32))
> -			return -ENOMEM;
> -		buf_size += rule_cnt * sizeof(u32);
> -		fallthrough;
> -	case ETHTOOL_GRXRINGS:
> -	case ETHTOOL_GRXCLSRLCNT:
> -	case ETHTOOL_GRXCLSRULE:
> -	case ETHTOOL_SRXCLSRLINS:
> -		convert_out = true;
> -		fallthrough;
> -	case ETHTOOL_SRXCLSRLDEL:
> -		buf_size += sizeof(struct ethtool_rxnfc);
> -		convert_in = true;
> -		rxnfc = compat_alloc_user_space(buf_size);
> -		break;
> -	}
> -
> -	if (copy_from_user(&ifr.ifr_name, &ifr32->ifr_name, IFNAMSIZ))
> -		return -EFAULT;
> -
> -	ifr.ifr_data = convert_in ? rxnfc : (void __user *)compat_rxnfc;
> -
> -	if (convert_in) {
> -		/* We expect there to be holes between fs.m_ext and
> -		 * fs.ring_cookie and at the end of fs, but nowhere else.
> -		 */
> -		BUILD_BUG_ON(offsetof(struct compat_ethtool_rxnfc, fs.m_ext) +
> -			     sizeof(compat_rxnfc->fs.m_ext) !=
> -			     offsetof(struct ethtool_rxnfc, fs.m_ext) +
> -			     sizeof(rxnfc->fs.m_ext));
> -		BUILD_BUG_ON(
> -			offsetof(struct compat_ethtool_rxnfc, fs.location) -
> -			offsetof(struct compat_ethtool_rxnfc, fs.ring_cookie) !=
> -			offsetof(struct ethtool_rxnfc, fs.location) -
> -			offsetof(struct ethtool_rxnfc, fs.ring_cookie));
> -
> -		if (copy_in_user(rxnfc, compat_rxnfc,
> -				 (void __user *)(&rxnfc->fs.m_ext + 1) -
> -				 (void __user *)rxnfc) ||
> -		    copy_in_user(&rxnfc->fs.ring_cookie,
> -				 &compat_rxnfc->fs.ring_cookie,
> -				 (void __user *)(&rxnfc->fs.location + 1) -
> -				 (void __user *)&rxnfc->fs.ring_cookie))
> -			return -EFAULT;
> -		if (ethcmd == ETHTOOL_GRXCLSRLALL) {
> -			if (put_user(rule_cnt, &rxnfc->rule_cnt))
> -				return -EFAULT;
> -		} else if (copy_in_user(&rxnfc->rule_cnt,
> -					&compat_rxnfc->rule_cnt,
> -					sizeof(rxnfc->rule_cnt)))
> -			return -EFAULT;
> -	}
> -
> -	ret = dev_ioctl(net, SIOCETHTOOL, &ifr, NULL);
> -	if (ret)
> -		return ret;
> -
> -	if (convert_out) {
> -		if (copy_in_user(compat_rxnfc, rxnfc,
> -				 (const void __user *)(&rxnfc->fs.m_ext + 1) -
> -				 (const void __user *)rxnfc) ||
> -		    copy_in_user(&compat_rxnfc->fs.ring_cookie,
> -				 &rxnfc->fs.ring_cookie,
> -				 (const void __user *)(&rxnfc->fs.location + 1) -
> -				 (const void __user *)&rxnfc->fs.ring_cookie) ||
> -		    copy_in_user(&compat_rxnfc->rule_cnt, &rxnfc->rule_cnt,
> -				 sizeof(rxnfc->rule_cnt)))
> -			return -EFAULT;
> -
> -		if (ethcmd == ETHTOOL_GRXCLSRLALL) {
> -			/* As an optimisation, we only copy the actual
> -			 * number of rules that the underlying
> -			 * function returned.  Since Mallory might
> -			 * change the rule count in user memory, we
> -			 * check that it is less than the rule count
> -			 * originally given (as the user buffer size),
> -			 * which has been range-checked.
> -			 */
> -			if (get_user(actual_rule_cnt, &rxnfc->rule_cnt))
> -				return -EFAULT;
> -			if (actual_rule_cnt < rule_cnt)
> -				rule_cnt = actual_rule_cnt;
> -			if (copy_in_user(&compat_rxnfc->rule_locs[0],
> -					 &rxnfc->rule_locs[0],
> -					 rule_cnt * sizeof(u32)))
> -				return -EFAULT;
> -		}
> -	}
> -
> -	return 0;
> -}
> -
>   static int compat_siocwandev(struct net *net, struct compat_ifreq __user *uifr32)
>   {
>   	compat_uptr_t uptr32;
> @@ -3428,8 +3306,6 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
>   		return old_bridge_ioctl(argp);
>   	case SIOCGIFCONF:
>   		return compat_dev_ifconf(net, argp);
> -	case SIOCETHTOOL:
> -		return ethtool_ioctl(net, argp);
>   	case SIOCWANDEV:
>   		return compat_siocwandev(net, argp);
>   	case SIOCGIFMAP:
> @@ -3442,6 +3318,7 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
>   		return sock->ops->gettstamp(sock, argp, cmd == SIOCGSTAMP_OLD,
>   					    !COMPAT_USE_64BIT_TIME);
>   
> +	case SIOCETHTOOL:
>   	case SIOCBONDSLAVEINFOQUERY:
>   	case SIOCBONDINFOQUERY:
>   	case SIOCSHWTSTAMP:

