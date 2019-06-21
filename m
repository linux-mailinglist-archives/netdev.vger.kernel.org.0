Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 835844E5E9
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 12:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfFUKag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 06:30:36 -0400
Received: from mail-vk1-f193.google.com ([209.85.221.193]:34997 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfFUKag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 06:30:36 -0400
Received: by mail-vk1-f193.google.com with SMTP id k1so1191411vkb.2
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 03:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=EI8t6T/6+jeUJe3ag7opmiiNB/kHV5Pq6I8JuKgpxZw=;
        b=lOc3A8tiNcD/NYwFlIsDajmUL807WO335nB6SDppp8K/JBhz/eUQJmMdDW+seDFeq8
         W6rXJBqJFiP3rtp7qcj9kPXpIv5I7z+gFdkx0LDheZgPS8g62pLzNf08uLlZczHpsxCp
         Lloe/BIwUA43qojuX5PPzZAkwNXABTHeFj73pSmFQnhp0hiLkWx+F9wzJuNa4+OQVQRt
         6b48JdFs+aA1DICnuaOw9TD3eXnIYeW3ziHRjx1QWeeZSvaSbL/3mOeVGdBZSERFl8SB
         7on5cw9oHcFYJzZXWfnjwb5ZkUBccRzbv8gJjg7f23OPNb2wkDExONMyncCUPV1vqwD3
         qy9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=EI8t6T/6+jeUJe3ag7opmiiNB/kHV5Pq6I8JuKgpxZw=;
        b=avN0xJm3pJSm1c+yJussUkEt/wOnAbUT76tSLsxBpKapvrQOnm19YZt0Losl4F11a0
         FB66vDWD2GAppQSCERqK/bLCvgHTT2WHNx8nMlcrpF3TLNxXEnwpqb2Jjy/o1/mg/7tn
         td5Ro1LW3zme9xnIJJWABlw/4AZnXbdbNbmqoremH2EbA/2Y2AsTZDPfMIDZDPCGgr1K
         lyzWXxWpd3feYPllrjDCDc6hxdkjFJW47KApDecteRJtsbMEAOzx5oKfwOYMU9buBl7t
         ryvEkyEMZpN173yL5E8PZRIcPiu99GUH5XUiyGwEFPYl19SyrZfC7AvoXPYKGgmB/Xgb
         DcqA==
X-Gm-Message-State: APjAAAXXKaP8vEXSZ2jvlZQKs/V5N9DXeI3zggOs5LgJ8Z7WWyYBJfOi
        +Rhz0pnSymg/sxfffbL9L4U5PIXiZvTF3qbdRgmA6g==
X-Google-Smtp-Source: APXvYqwT2XTSUYNbyLe4kErqtt7gbdsZFKxyD2YEt9xQeg4JWbsZZ8kauxqAM34aCbA3HtgGFeNcI05z6HxzJqJzP+M=
X-Received: by 2002:a1f:5302:: with SMTP id h2mr7039137vkb.37.1561113034959;
 Fri, 21 Jun 2019 03:30:34 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab0:2616:0:0:0:0:0 with HTTP; Fri, 21 Jun 2019 03:30:34
 -0700 (PDT)
X-Originating-IP: [5.35.70.113]
In-Reply-To: <20190620090249.106704-1-dkirjanov@suse.com>
References: <20190620090249.106704-1-dkirjanov@suse.com>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Fri, 21 Jun 2019 13:30:34 +0300
Message-ID: <CAOJe8K3ugk1SvBKOhv5d7C8gHjJ+Tjpi9UgqNQhEan=Pf9Qx2g@mail.gmail.com>
Subject: Re: [PATCH iproute2-next v2 1/2] ipaddress: correctly print a VF hw
 address in the IPoIB case
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        dledford@redhat.com, mkubecek@suse.cz,
        Denis Kirjanov <kda@linux-powerpc.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/20/19, Denis Kirjanov <kda@linux-powerpc.org> wrote:
> Current code assumes that we print Etheret mac and
> that doesn't work in IPoIB case with SRIOV-enabled hardware
>
> Before:
> 11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
> state UP mode DEFAULT group default qlen 256
>         link/infiniband
> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
>         vf 0 MAC 14:80:00:00:66:fe, spoof checking off, link-state disable,
>     trust off, query_rss off
>     ...
>
> After:
> 11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
> state UP mode DEFAULT group default qlen 256
>         link/infiniband
> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
>         vf 0     link/infiniband
> 80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
> 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff, spoof
> checking off, link-state disable, trust off, query_rss off
>
> v1->v2: updated kernel headers to uapi commit
>
> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>

Hi Stephen,

are you going to take the patches?

Thanks!

> ---
>  ip/ipaddress.c | 42 +++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 37 insertions(+), 5 deletions(-)
>
> diff --git a/ip/ipaddress.c b/ip/ipaddress.c
> index b504200b..13ad76dd 100644
> --- a/ip/ipaddress.c
> +++ b/ip/ipaddress.c
> @@ -26,6 +26,7 @@
>
>  #include <linux/netdevice.h>
>  #include <linux/if_arp.h>
> +#include <linux/if_infiniband.h>
>  #include <linux/sockios.h>
>  #include <linux/net_namespace.h>
>
> @@ -349,9 +350,10 @@ static void print_af_spec(FILE *fp, struct rtattr
> *af_spec_attr)
>
>  static void print_vf_stats64(FILE *fp, struct rtattr *vfstats);
>
> -static void print_vfinfo(FILE *fp, struct rtattr *vfinfo)
> +static void print_vfinfo(struct ifinfomsg *ifi, FILE *fp, struct rtattr
> *vfinfo)
>  {
>  	struct ifla_vf_mac *vf_mac;
> +	struct ifla_vf_broadcast *vf_broadcast;
>  	struct ifla_vf_tx_rate *vf_tx_rate;
>  	struct rtattr *vf[IFLA_VF_MAX + 1] = {};
>
> @@ -365,13 +367,43 @@ static void print_vfinfo(FILE *fp, struct rtattr
> *vfinfo)
>  	parse_rtattr_nested(vf, IFLA_VF_MAX, vfinfo);
>
>  	vf_mac = RTA_DATA(vf[IFLA_VF_MAC]);
> +	vf_broadcast = RTA_DATA(vf[IFLA_VF_BROADCAST]);
>  	vf_tx_rate = RTA_DATA(vf[IFLA_VF_TX_RATE]);
>
>  	print_string(PRINT_FP, NULL, "%s    ", _SL_);
>  	print_int(PRINT_ANY, "vf", "vf %d ", vf_mac->vf);
> -	print_string(PRINT_ANY, "mac", "MAC %s",
> -		     ll_addr_n2a((unsigned char *) &vf_mac->mac,
> -				 ETH_ALEN, 0, b1, sizeof(b1)));
> +
> +	print_string(PRINT_ANY,
> +			"link_type",
> +			"    link/%s ",
> +			ll_type_n2a(ifi->ifi_type, b1, sizeof(b1)));
> +
> +	print_color_string(PRINT_ANY,
> +				COLOR_MAC,
> +				"address",
> +				"%s",
> +				ll_addr_n2a((unsigned char *) &vf_mac->mac,
> +					ifi->ifi_type == ARPHRD_ETHER ? ETH_ALEN : INFINIBAND_ALEN,
> +					ifi->ifi_type,
> +					b1, sizeof(b1)));
> +
> +	if (vf[IFLA_VF_BROADCAST]) {
> +		if (ifi->ifi_flags&IFF_POINTOPOINT) {
> +			print_string(PRINT_FP, NULL, " peer ", NULL);
> +			print_bool(PRINT_JSON,
> +					"link_pointtopoint", NULL, true);
> +                        } else {
> +				print_string(PRINT_FP, NULL, " brd ", NULL);
> +                        }
> +                        print_color_string(PRINT_ANY,
> +                                           COLOR_MAC,
> +                                           "broadcast",
> +                                           "%s",
> +                                           ll_addr_n2a((unsigned char *)
> &vf_broadcast->broadcast,
> +                                                       ifi->ifi_type ==
> ARPHRD_ETHER ? ETH_ALEN : INFINIBAND_ALEN,
> +                                                       ifi->ifi_type,
> +                                                       b1, sizeof(b1)));
> +	}
>
>  	if (vf[IFLA_VF_VLAN_LIST]) {
>  		struct rtattr *i, *vfvlanlist = vf[IFLA_VF_VLAN_LIST];
> @@ -1102,7 +1134,7 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
>  		open_json_array(PRINT_JSON, "vfinfo_list");
>  		for (i = RTA_DATA(vflist); RTA_OK(i, rem); i = RTA_NEXT(i, rem)) {
>  			open_json_object(NULL);
> -			print_vfinfo(fp, i);
> +			print_vfinfo(ifi, fp, i);
>  			close_json_object();
>  		}
>  		close_json_array(PRINT_JSON, NULL);
> --
> 2.12.3
>
>
