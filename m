Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77777583C72
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 12:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236082AbiG1Ksl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 06:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236057AbiG1KsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 06:48:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 47D2FB24
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 03:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659005281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=31dprWM55S1yZ47XxvbEfbN2LPCzp7W0Mpw3g4J3zFI=;
        b=enR3tkWSOVYMn50RiTnERISPlKT9hIsjR6hOxB9Uvyry9L1AVtxXporASzpPtyOu9cnrDD
        ZH5zJSAfdzTzY5DzX7ClGo0+2TJhFDjMUXvQzFtqEtHxYYExomzuVyrNIq9SDpmAE46hZO
        /FKDN/bjVOL7zpGK4zh3KWp8qKFS5gY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-QEUhaVItOIePEJ1oKEA_cA-1; Thu, 28 Jul 2022 06:47:50 -0400
X-MC-Unique: QEUhaVItOIePEJ1oKEA_cA-1
Received: by mail-wm1-f72.google.com with SMTP id v11-20020a1cf70b000000b003a318238826so330403wmh.2
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 03:47:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=31dprWM55S1yZ47XxvbEfbN2LPCzp7W0Mpw3g4J3zFI=;
        b=zKEBmk71mb+8enDUUmJgDiMXysY6Isu6T5EoCVfVGfq4+KCR+q+cddolmHOThh3Ald
         l8iXwCp98181gAYgu3BxYE7iuP6SPeL89L4qLZUr+vYkbTioP7/yDz0FLz0FxiYFuIqP
         9Vn/7Qr3VUSdH7FbHzyLLhzVZU8VRiDRnbVGi++gNtyvnzs7ePCFrL20V4tqFegq4Uy/
         zlCNDCrWdZ+MGwd+soy4aB3HjH96WzyXKEfGGRamDo3eSOvuc4K2gwgHV8tHvrfOa672
         B6wdT0ZtiSduGy+kkxmrxM6PcoTT6B0yYFFE8nxKH9iMVoI4rAjkhts4hG8Z+n7uPrq5
         rsmw==
X-Gm-Message-State: AJIora9/rZSJec/XyA+PmDS7cn9NFlJY8OcK5jT2vyzv3iSuBKt5An8x
        8hZwJkjQGUd5JG7oeO5jAwCLlmTQBw0fCSPzRTpCNN69WcCAuEGji9PkFbXEQ14HWdwzys5VX0T
        cxLzujwSDs9oZj9XL
X-Received: by 2002:a05:600c:3b1d:b0:3a3:1fda:efcf with SMTP id m29-20020a05600c3b1d00b003a31fdaefcfmr6072887wms.49.1659005269327;
        Thu, 28 Jul 2022 03:47:49 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1usIb6uv0I8dq/Xzjgur5GbBMR4ZVwisRLqTT+hY5LzjEZVc9nqQ/7sIpYLa7bylOkwGPuQuA==
X-Received: by 2002:a05:600c:3b1d:b0:3a3:1fda:efcf with SMTP id m29-20020a05600c3b1d00b003a31fdaefcfmr6072864wms.49.1659005268831;
        Thu, 28 Jul 2022 03:47:48 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id m8-20020a05600c4f4800b003a308e9a192sm5481588wmq.30.2022.07.28.03.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 03:47:48 -0700 (PDT)
Date:   Thu, 28 Jul 2022 12:47:46 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Wojciech Drewek <wojciech.drewek@intel.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Subject: Re: [PATCH iproute-next v2 3/3] f_flower: Introduce PPPoE support
Message-ID: <20220728104746.GC18015@pc-4.home>
References: <20220728084437.486187-1-wojciech.drewek@intel.com>
 <20220728084437.486187-4-wojciech.drewek@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728084437.486187-4-wojciech.drewek@intel.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 10:44:37AM +0200, Wojciech Drewek wrote:
> Introduce PPPoE specific fields in tc-flower:
> - session id (16 bits)
> - ppp protocol (16 bits)
> Those fields can be provided only when protocol was set to
> ETH_P_PPP_SES. ppp_proto works similar to vlan_ethtype, i.e.
> ppp_proto overwrites eth_type. Thanks to that, fields from
> encapsulated protocols (such as src_ip) can be specified.
> 
> e.g.
>   # tc filter add dev ens6f0 ingress prio 1 protocol ppp_ses \
>       flower \
>         pppoe_sid 1234 \
>         ppp_proto ip \
>         dst_ip 127.0.0.1 \
>         src_ip 127.0.0.2 \
>       action drop
> 
> Vlan and cvlan is also supported, in this case cvlan_ethtype
> or vlan_ethtype has to be set to ETH_P_PPP_SES.
> 
> e.g.
>   # tc filter add dev ens6f0 ingress prio 1 protocol 802.1Q \
>       flower \
>         vlan_id 2 \
>         vlan_ethtype ppp_ses \
>         pppoe_sid 1234 \
>         ppp_proto ip \
>         dst_ip 127.0.0.1 \
>         src_ip 127.0.0.2 \
>       action drop
> 
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
> v2: add pppoe fields to explain
> ---
>  include/uapi/linux/pkt_cls.h |  3 ++
>  man/man8/tc-flower.8         | 17 ++++++++++-
>  tc/f_flower.c                | 58 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 77 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
> index 9a2ee1e39fad..a67dcd8294c9 100644
> --- a/include/uapi/linux/pkt_cls.h
> +++ b/include/uapi/linux/pkt_cls.h
> @@ -589,6 +589,9 @@ enum {
>  
>  	TCA_FLOWER_KEY_NUM_OF_VLANS,    /* u8 */
>  
> +	TCA_FLOWER_KEY_PPPOE_SID,	/* u16 */
> +	TCA_FLOWER_KEY_PPP_PROTO,	/* be16 */
> +
>  	__TCA_FLOWER_MAX,
>  };
>  
> diff --git a/man/man8/tc-flower.8 b/man/man8/tc-flower.8
> index 523935242ccf..5e486ea31d37 100644
> --- a/man/man8/tc-flower.8
> +++ b/man/man8/tc-flower.8
> @@ -40,6 +40,10 @@ flower \- flow based traffic control filter
>  .IR PRIORITY " | "
>  .BR cvlan_ethtype " { " ipv4 " | " ipv6 " | "
>  .IR ETH_TYPE " } | "
> +.B pppoe_sid
> +.IR PSID " | "
> +.BR ppp_proto " { " ip " | " ipv6 " | " mpls_uc " | " mpls_mc " | "
> +.IR PPP_PROTO " } | "
>  .B mpls
>  .IR LSE_LIST " | "
>  .B mpls_label
> @@ -202,7 +206,18 @@ Match on QinQ layer three protocol.
>  may be either
>  .BR ipv4 ", " ipv6
>  or an unsigned 16bit value in hexadecimal format.
> -
> +.TP
> +.BI pppoe_sid " PSID"
> +Match on PPPoE session id.
> +.I PSID
> +is an unsigned 16bit value in decimal format.
> +.TP
> +.BI ppp_proto " PPP_PROTO"
> +Match on PPP layer three protocol.
> +.I PPP_PROTO
> +may be either
> +.BR ip ", " ipv6 ", " mpls_uc ", " mpls_mc
> +or an unsigned 16bit value in hexadecimal format.
>  .TP
>  .BI mpls " LSE_LIST"
>  Match on the MPLS label stack.
> diff --git a/tc/f_flower.c b/tc/f_flower.c
> index 622ec321f310..c95320328b20 100644
> --- a/tc/f_flower.c
> +++ b/tc/f_flower.c
> @@ -20,6 +20,7 @@
>  #include <linux/ip.h>
>  #include <linux/tc_act/tc_vlan.h>
>  #include <linux/mpls.h>
> +#include <linux/ppp_defs.h>
>  
>  #include "utils.h"
>  #include "tc_util.h"
> @@ -55,6 +56,8 @@ static void explain(void)
>  		"			cvlan_id VID |\n"
>  		"			cvlan_prio PRIORITY |\n"
>  		"			cvlan_ethtype [ ipv4 | ipv6 | ETH-TYPE ] |\n"
> +		"			pppoe_sid PSID |\n"
> +		"			ppp_proto [ ipv4 | ipv6 | mpls_uc | mpls_mc | PPP_PROTO ]"
>  		"			dst_mac MASKED-LLADDR |\n"
>  		"			src_mac MASKED-LLADDR |\n"
>  		"			ip_proto [tcp | udp | sctp | icmp | icmpv6 | IP-PROTO ] |\n"
> @@ -1887,6 +1890,43 @@ static int flower_parse_opt(struct filter_util *qu, char *handle,
>  				fprintf(stderr, "Illegal \"arp_sha\"\n");
>  				return -1;
>  			}
> +
> +		} else if (!strcmp(*argv, "pppoe_sid")) {
> +			__be16 sid;
> +
> +			NEXT_ARG();
> +			if (eth_type != htons(ETH_P_PPP_SES)) {
> +				fprintf(stderr,
> +					"Can't set \"pppoe_sid\" if ethertype isn't PPPoE session\n");
> +				return -1;
> +			}
> +			ret = get_be16(&sid, *argv, 10);
> +			if (ret < 0 || sid == 0xffff) {
> +				fprintf(stderr, "Illegal \"pppoe_sid\"\n");

I don't think it makes sense to reject sid == 0xffff.
One might want to early match and drop such invalid packets.

