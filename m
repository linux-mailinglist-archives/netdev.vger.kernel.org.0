Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 501784F0E4
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 00:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfFUW4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 18:56:12 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41184 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbfFUW4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 18:56:12 -0400
Received: by mail-io1-f68.google.com with SMTP id w25so1809804ioc.8;
        Fri, 21 Jun 2019 15:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o0aS6H4XnPbjM06tmeubqKxhYqrJuIMbDlI1z1uRYaA=;
        b=lMqjkIv3ngQY8SkxDAxSClVCsQ4NTIBpNcARTi5jQniiSDtdMJ1SL2tjwfuI5jM6S1
         o/3L42HYalVDzlsm48Rgg8JMoPX2fyfIvnCNw4E1m4fyuQ/3HVt9026w7hutpVqOOi59
         uzk+RuYDe0g7QOpSVLczMZFgqB8IiymmcR0eoIPW9FimNxMVSMb49fldwO670WshRhL/
         xWxnHkoygb9NcjAFnEfpJu0sy7CCoyZszp/giYwwfku81dP0kE0sIltsO9SAes2MaqtC
         Wb9bmXylWq6wxfqJvZ5xNLR9AcHkKD/Yu2/9IWoudusojj88+ZsLy0sCZPhanAYm6vd9
         zcHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o0aS6H4XnPbjM06tmeubqKxhYqrJuIMbDlI1z1uRYaA=;
        b=Ps8pz1UPbDwQZ3ZFMh01dIeWO9cgSj3x6ZuIk0bb6qL7YfCI1+raKmSDCrMPzC4ddn
         yVVMYXfpb3QbrY2UPhNUdEg0KATiRZpPfwmcMo47DHquKcT3XswWzMMZD7SaQOMs7cXP
         Zxb1xldnadToNN/+ekQ2oub8b5h4P3fvTlVQHxpbHLhIE6g2F1v3NWBuJ77ME4XGnVHe
         kCGPWAtEhMDC7S+EIzIVxh2F20Pwp760XkHY1IjJjT/K1fL5dzJcsSaShqZywFOfiU1s
         vqSdNKL0FThGFJ1I236AWIu46HkqIPWsc8hGdPsqcR2lbSQenC1N0hHDRHQJPWHwdXkD
         IntQ==
X-Gm-Message-State: APjAAAW17dvOgweymXdLoJ3HOBk3Cn1IVduX/uIuYmHx0d0gY20TJS5+
        cNNi5sdtF5TWYlFj5JqkLYFF9+7h
X-Google-Smtp-Source: APXvYqyju42CJSeqBa2mlMoMCX+lfeInuPpcEeBOiUyldn4bSdY3mwpgWSv6IHQR2aOKSQ5YJaxe8Q==
X-Received: by 2002:a05:6602:1d2:: with SMTP id w18mr4238842iot.157.1561157771449;
        Fri, 21 Jun 2019 15:56:11 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:563:6fa4:e349:a2f8? ([2601:284:8200:5cfb:563:6fa4:e349:a2f8])
        by smtp.googlemail.com with ESMTPSA id n21sm3101239ioh.30.2019.06.21.15.56.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 15:56:10 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2 1/2] ipaddress: correctly print a VF hw
 address in the IPoIB case
To:     Denis Kirjanov <kda@linux-powerpc.org>, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        dledford@redhat.com, mkubecek@suse.cz
References: <20190620090249.106704-1-dkirjanov@suse.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <68e73778-a739-4337-0e48-280483a73569@gmail.com>
Date:   Fri, 21 Jun 2019 16:56:09 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190620090249.106704-1-dkirjanov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/20/19 3:02 AM, Denis Kirjanov wrote:
> @@ -349,9 +350,10 @@ static void print_af_spec(FILE *fp, struct rtattr *af_spec_attr)
>  
>  static void print_vf_stats64(FILE *fp, struct rtattr *vfstats);
>  
> -static void print_vfinfo(FILE *fp, struct rtattr *vfinfo)
> +static void print_vfinfo(struct ifinfomsg *ifi, FILE *fp, struct rtattr *vfinfo)
>  {
>  	struct ifla_vf_mac *vf_mac;
> +	struct ifla_vf_broadcast *vf_broadcast;
>  	struct ifla_vf_tx_rate *vf_tx_rate;
>  	struct rtattr *vf[IFLA_VF_MAX + 1] = {};
>  
> @@ -365,13 +367,43 @@ static void print_vfinfo(FILE *fp, struct rtattr *vfinfo)
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
> +                                           ll_addr_n2a((unsigned char *) &vf_broadcast->broadcast,
> +                                                       ifi->ifi_type == ARPHRD_ETHER ? ETH_ALEN : INFINIBAND_ALEN,
> +                                                       ifi->ifi_type,
> +                                                       b1, sizeof(b1)));
> +	}
>  

you have a number of alignment problems with the above changes. you can
run checkpatch from the kernel repo on it to verify the coding standards.
