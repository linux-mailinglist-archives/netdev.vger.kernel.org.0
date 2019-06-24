Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0953F51A29
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 19:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732688AbfFXR7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 13:59:11 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:46696 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbfFXR7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 13:59:10 -0400
Received: by mail-io1-f65.google.com with SMTP id i10so120118iol.13;
        Mon, 24 Jun 2019 10:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nbE1U6xEOpm3IU9D3zSKgqh8ByiCAVzOuHdRanCjeEg=;
        b=DEUY79I9YJbPU9gAEbNTIEUTkzPQTtIH/uy0ohe2uxbbeWjfXzsb3YfckWMH/eYguy
         bEoikx04g7bRw5dIg1eUPiTMQnZTwfBy8/HRhrnLt2ijqsPPEqEVMeoyFQby+pqM38VA
         PQaUZ29mn3PlA/9Xt+8yfWiUmuNcFP9RYQNtRjpVzzkY2ET5elWqNzxfv0yf4wYQE8yW
         xpe75higI13iR0WSJ2daD5SIbTzlN3fkigu+IAbKE8SYWL1f9gFuEkYtm9TfLpYbJTDM
         z1bcoWN7V9yxYW1WDa0CsFLlfyvi2e7c8DARjgykjJ5Xe23Nle5RuuJQ38I5czKryyIA
         rghA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nbE1U6xEOpm3IU9D3zSKgqh8ByiCAVzOuHdRanCjeEg=;
        b=tXuUoIaq5+6ZpmqGNaHbk057ui6aZJN9x3zyEM0QsXneldTMDPt68mWJh/VCVEje1V
         WCQGyptUmrr2vJwD4nvJnbYg61qg5WI9D3DbqN9+ELmMADeqZKfMyxLV2OrzD8qTt6LD
         gPYSYNhtfBsuLqsaD56J7/OLEjSYf5gNMqfyNQYrWk5VmSqxg36upeQRBOMJuXApUl//
         Jr/ziC92u+QtMODvvItx5v7pKVvJlW5Ki23wKUuS907wW0PVldAQ6aH6eH0HRP8CjgwI
         9XpRbDjJjOopmLYpBYOX5eIcleUbc4T5/PTP3umPd4sVk0tFAkRjUSbKggPpCc2VP7/5
         3jzg==
X-Gm-Message-State: APjAAAUktV30aX57ny4Q+bFV7fAv+ONllh/UKSPfhsx7r8oW8YPCHtYG
        c2TvSMx8xHG9tue+e/oO+raVBivJ
X-Google-Smtp-Source: APXvYqwkAYgsjhRtHJrdyyltZJc+3JaiO5nlXX29HpvtKn1k6CCQC5sUIYhCiudcgADjzc4HfpdXMg==
X-Received: by 2002:a6b:e702:: with SMTP id b2mr36550367ioh.175.1561399150088;
        Mon, 24 Jun 2019 10:59:10 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:f558:9f3d:eff4:2876? ([2601:282:800:fd80:f558:9f3d:eff4:2876])
        by smtp.googlemail.com with ESMTPSA id p3sm13799799iog.70.2019.06.24.10.59.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 10:59:08 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v3 1/2] ipaddress: correctly print a VF hw
 address in the IPoIB case
To:     Denis Kirjanov <kda@linux-powerpc.org>, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        dledford@redhat.com, mkubecek@suse.cz
References: <20190622180035.40245-1-dkirjanov@suse.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a669939c-d8f3-f3c8-15f4-efa236e00954@gmail.com>
Date:   Mon, 24 Jun 2019 11:59:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190622180035.40245-1-dkirjanov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/22/19 12:00 PM, Denis Kirjanov wrote:
> @@ -365,13 +367,45 @@ static void print_vfinfo(FILE *fp, struct rtattr *vfinfo)
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
> +					ifi->ifi_type == ARPHRD_ETHER ?
> +					ETH_ALEN : INFINIBAND_ALEN,
> +					ifi->ifi_type,
> +					b1, sizeof(b1)));

you still have a lot of lines that are not lined up column wise. See how
the COLOR_MAC is offset to the right from PRINT_ANY?

> +
> +	if (vf[IFLA_VF_BROADCAST]) {
> +		if (ifi->ifi_flags&IFF_POINTOPOINT) {
> +			print_string(PRINT_FP, NULL, " peer ", NULL);
> +			print_bool(PRINT_JSON,
> +					"link_pointtopoint", NULL, true);
> +		} else
> +			print_string(PRINT_FP, NULL, " brd ", NULL);
> +
> +		print_color_string(PRINT_ANY,
> +				COLOR_MAC,
> +				"broadcast",
> +				"%s",
> +				ll_addr_n2a((unsigned char *) &vf_broadcast->broadcast,
> +					ifi->ifi_type == ARPHRD_ETHER ?
> +					ETH_ALEN : INFINIBAND_ALEN,
> +					ifi->ifi_type,
> +					b1, sizeof(b1)));

And then these lines are offset to the left.
