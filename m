Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B557E61DB
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 10:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfJ0Jlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 05:41:51 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34697 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfJ0Jlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Oct 2019 05:41:51 -0400
Received: by mail-lj1-f193.google.com with SMTP id 139so8020919ljf.1
        for <netdev@vger.kernel.org>; Sun, 27 Oct 2019 02:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BrhnFBsbXDqNMcYUiH03iBwLiNX8xr4Q1bfprIrpD7k=;
        b=HxIk5s2H/q1/jC62LrpEk9/3B/B0/XJFLjNc2LqQbpUSeb4zZNEIcVK1Sjp9zw5/JA
         GfVbUL8vgRye3zHeD3CYrAJfVTlhHMPVnn6lwCq5rQPlhFJQO0sh/JgCmqlQ/5h5gUEF
         lHa+fllCJEQX4JFm4GMh/sfgywLmTJl6HNrn4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BrhnFBsbXDqNMcYUiH03iBwLiNX8xr4Q1bfprIrpD7k=;
        b=cQx/hoYJho28Ud5+0DRi2zCj622yG+IU+1f7f+G9ZqnPiNth0nWEzKKL+39YCiDnp8
         jpsLFVPHFLquAIVUnAwctH1ll8i7zWBhfPlPMDQm0M5Ktm7CnBVdN1MIprTFaVSq4oVv
         4g4xatrfwr+W8CPiAKzRCysEMhkuPAYMowU/cWvRoi7yuyuHa3cku/svSKH0D1DNatsJ
         XefZX8hEJgDtdoTvWPcHHdf+c7MT41ugOmohx3S/Cfizt/sDbPKpejogIg+F7NENQ8Zg
         GTvDhIhgcouV4LS7pB+Twqqy9ITrPOjDVqk8LdUXRehBst9YGelnrTBST2WCu5/uy7el
         /hig==
X-Gm-Message-State: APjAAAWC+fDHEllQzH/BPP8UeVCW7ON/wBHIr8n7syISJj7bo/s62jKZ
        zfAbkb7BB0Uvu/n1CrKfvSJUyQ==
X-Google-Smtp-Source: APXvYqxcJX3t2mpc0suZd5f04dgHdMA0L8MIQYRf475oClDVy7rD/VfHkoQCfVBI93gYIuMYUvPlrg==
X-Received: by 2002:a2e:3016:: with SMTP id w22mr8302255ljw.117.1572169308728;
        Sun, 27 Oct 2019 02:41:48 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id r21sm3427158ljn.65.2019.10.27.02.41.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Oct 2019 02:41:47 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 3/3] iplink: bond: print 3ad actor/partner
 oper states as strings
To:     Andy Roulin <aroulin@cumulusnetworks.com>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, roopa@cumulusnetworks.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net
References: <1572132594-2006-1-git-send-email-aroulin@cumulusnetworks.com>
 <1572132594-2006-4-git-send-email-aroulin@cumulusnetworks.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <cd73c11e-e8bd-615d-0513-bb3e3797f342@cumulusnetworks.com>
Date:   Sun, 27 Oct 2019 11:41:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1572132594-2006-4-git-send-email-aroulin@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/10/2019 02:29, Andy Roulin wrote:
> The 802.3ad actor/partner operating states are only printed as
> numbers, e.g,
> 
> ad_actor_oper_port_state 15
> 
> Add an additional output in ip link show that prints a string describing
> the individual 3ad bit meanings in the following way:
> 
> ad_actor_oper_port_state_str <active,short_timeout,aggregating,in_sync>
> 
> JSON output is also supported, the field becomes a json array:
> 
> "ad_actor_oper_port_state_str":
> 	["active","short_timeout","aggregating","in_sync"]
> 
> Signed-off-by: Andy Roulin <aroulin@cumulusnetworks.com>
> Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> Acked-by: Roopa Prabhu <roopa@cumulusnetworks.com>
> ---
>  ip/iplink_bond_slave.c | 38 ++++++++++++++++++++++++++++++++++----
>  1 file changed, 34 insertions(+), 4 deletions(-)
> 
> diff --git a/ip/iplink_bond_slave.c b/ip/iplink_bond_slave.c
> index 4eaf72b8..99beeca1 100644
> --- a/ip/iplink_bond_slave.c
> +++ b/ip/iplink_bond_slave.c
> @@ -68,6 +68,28 @@ static void print_slave_mii_status(FILE *f, struct rtattr *tb)
>  			     slave_mii_status[status]);
>  }
>  
> +static void print_slave_oper_state(FILE *fp, const char *name, __u16 state)
> +{
> +

extra new line here

> +	open_json_array(PRINT_ANY, name);
> +	if (!is_json_context())
> +		fprintf(fp, " <");
> +#define _PF(s, str) if (state&AD_STATE_##s) {				\
> +			state &= ~AD_STATE_##s;				\
> +			print_string(PRINT_ANY, NULL,   		\
> +				     state ? "%s," : "%s", str); }
> +	_PF(LACP_ACTIVITY, "active");
> +	_PF(LACP_TIMEOUT, "short_timeout");
> +	_PF(AGGREGATION, "aggregating");
> +	_PF(SYNCHRONIZATION, "in_sync");
> +	_PF(COLLECTING, "collecting");
> +	_PF(DISTRIBUTING, "distributing");
> +	_PF(DEFAULTED, "defaulted");
> +	_PF(EXPIRED, "expired");
> +#undef _PF
> +	close_json_array(PRINT_ANY, "> ");
> +}
> +
>  static void bond_slave_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
>  {
>  	SPRINT_BUF(b1);
> @@ -106,17 +128,25 @@ static void bond_slave_print_opt(struct link_util *lu, FILE *f, struct rtattr *t
>  			  "ad_aggregator_id %d ",
>  			  rta_getattr_u16(tb[IFLA_BOND_SLAVE_AD_AGGREGATOR_ID]));
>  
> -	if (tb[IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE])
> +	if (tb[IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE]) {
> +		__u8 state = rta_getattr_u8(tb[IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE]);
> +
>  		print_int(PRINT_ANY,
>  			  "ad_actor_oper_port_state",
>  			  "ad_actor_oper_port_state %d ",
> -			  rta_getattr_u8(tb[IFLA_BOND_SLAVE_AD_ACTOR_OPER_PORT_STATE]));
> +			  state);
> +		print_slave_oper_state(f, "ad_actor_oper_port_state_str", state);
> +	}
> +
> +	if (tb[IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE]) {
> +		__u16 state = rta_getattr_u8(tb[IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE]);
>  
> -	if (tb[IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE])
>  		print_int(PRINT_ANY,
>  			  "ad_partner_oper_port_state",
>  			  "ad_partner_oper_port_state %d ",
> -			  rta_getattr_u16(tb[IFLA_BOND_SLAVE_AD_PARTNER_OPER_PORT_STATE]));
> +			  state);
> +		print_slave_oper_state(f, "ad_partner_oper_port_state_str", state);
> +	}
>  }
>  
>  static int bond_slave_parse_opt(struct link_util *lu, int argc, char **argv,
> 

