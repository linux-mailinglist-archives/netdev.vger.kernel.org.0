Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD7059697
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 10:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbfF1I4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 04:56:36 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:39995 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbfF1I4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 04:56:36 -0400
Received: by mail-ua1-f68.google.com with SMTP id s4so1913871uad.7
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 01:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=jFt+h6QhqsysQ+3ej2gYu2ussJB8+V6+0nyzTBAQWVU=;
        b=sRomXfU1wtxo+CvKVEtL2foLKb+tDncXrAzh9nepTIaNcvxZo3c6IAszYhQs/cS6ss
         s1n0APzNWbssBIi2T1hz2ALI7FKcaYMK3mQdcg1Fq0oXylWHK7hUlP/HafTBZClnN9Dg
         mrFNU4FxXKhc/ao82790XuXxFnfRM3922GoWgHvpt1lDxXZqkC254zBvSB5VwI4FRdid
         MfLaaJ0qOqN9DK+OnAvpnUPlvxypEaTQXkGj/B7TLac8htx1uo2duNrJHmuORzpmZ/Hs
         Atr2J9r6Os5+fYbasRnslxzWNkNoYwGvfhpap9kAj5jzndw8vpqk1+iGZJLdkPBfeh4h
         On1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=jFt+h6QhqsysQ+3ej2gYu2ussJB8+V6+0nyzTBAQWVU=;
        b=Wa8ja6+rPoF+1m3Ylwu4B92YSIBhTQhKn/uAH77RDBNT1Yova9+w8KY9WmG0MQ3VBQ
         rK9wRxODU//wCFXYkl2g+mPKbMSr9uq/dljFBlDrrERNIFnoqKqvqBy8MSXsQh5wby7J
         fez4S86OoeeFHzBstjvNVp4dFd+x/RavAawy06fSBnch3VE6ojr7rdE3ZZmp3TQ/YauA
         XHi3jfHK8GNi3q4cPPun6GaX56VLcgTB6nacmLSKIVWQ1xJ/Zsv/s3+ACYDkgBbMIwQA
         979UCnIpUxee54p8xK+V/TZ941VlmLXRzObsVZq0YgZ/x3WAk4eqe5s0wEMxn5vSZD1D
         5BbA==
X-Gm-Message-State: APjAAAVkOSBrAukeuWnx7IT6+Bp785BJO6BhbwgkXcXKRQVx5tzwUA9J
        X8+WH+BvRwZrPfFcUWRAah4QAKG7ZS9m4u4TLSIgwVdI
X-Google-Smtp-Source: APXvYqytbXxpHEyjgLIst4RZwsT+xFHHbRswbgLcIyoEJD9OhEbOpgjEGJW0gKaPwxZDwrE+Oyte0MpmYkZNLzE7WFQ=
X-Received: by 2002:ab0:66:: with SMTP id 93mr4959579uai.135.1561712195310;
 Fri, 28 Jun 2019 01:56:35 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab0:2616:0:0:0:0:0 with HTTP; Fri, 28 Jun 2019 01:56:34
 -0700 (PDT)
X-Originating-IP: [5.35.70.113]
In-Reply-To: <a669939c-d8f3-f3c8-15f4-efa236e00954@gmail.com>
References: <20190622180035.40245-1-dkirjanov@suse.com> <a669939c-d8f3-f3c8-15f4-efa236e00954@gmail.com>
From:   Denis Kirjanov <kda@linux-powerpc.org>
Date:   Fri, 28 Jun 2019 11:56:34 +0300
Message-ID: <CAOJe8K33TOtnwbsw2vq6gGWOstrW-D-tC+kdHnTygmdCreSX6Q@mail.gmail.com>
Subject: Re: [PATCH iproute2-next v3 1/2] ipaddress: correctly print a VF hw
 address in the IPoIB case
To:     David Ahern <dsahern@gmail.com>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, dledford@redhat.com, mkubecek@suse.cz
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/24/19, David Ahern <dsahern@gmail.com> wrote:
> On 6/22/19 12:00 PM, Denis Kirjanov wrote:
>> @@ -365,13 +367,45 @@ static void print_vfinfo(FILE *fp, struct rtattr
>> *vfinfo)
>>  	parse_rtattr_nested(vf, IFLA_VF_MAX, vfinfo);
>>
>>  	vf_mac = RTA_DATA(vf[IFLA_VF_MAC]);
>> +	vf_broadcast = RTA_DATA(vf[IFLA_VF_BROADCAST]);
>>  	vf_tx_rate = RTA_DATA(vf[IFLA_VF_TX_RATE]);
>>
>>  	print_string(PRINT_FP, NULL, "%s    ", _SL_);
>>  	print_int(PRINT_ANY, "vf", "vf %d ", vf_mac->vf);
>> -	print_string(PRINT_ANY, "mac", "MAC %s",
>> -		     ll_addr_n2a((unsigned char *) &vf_mac->mac,
>> -				 ETH_ALEN, 0, b1, sizeof(b1)));
>> +
>> +	print_string(PRINT_ANY,
>> +			"link_type",
>> +			"    link/%s ",
>> +			ll_type_n2a(ifi->ifi_type, b1, sizeof(b1)));
>> +
>> +	print_color_string(PRINT_ANY,
>> +				COLOR_MAC,
>> +				"address",
>> +				"%s",
>> +				ll_addr_n2a((unsigned char *) &vf_mac->mac,
>> +					ifi->ifi_type == ARPHRD_ETHER ?
>> +					ETH_ALEN : INFINIBAND_ALEN,
>> +					ifi->ifi_type,
>> +					b1, sizeof(b1)));
>
> you still have a lot of lines that are not lined up column wise. See how
> the COLOR_MAC is offset to the right from PRINT_ANY?
>
>> +
>> +	if (vf[IFLA_VF_BROADCAST]) {
>> +		if (ifi->ifi_flags&IFF_POINTOPOINT) {
>> +			print_string(PRINT_FP, NULL, " peer ", NULL);
>> +			print_bool(PRINT_JSON,
>> +					"link_pointtopoint", NULL, true);
>> +		} else
>> +			print_string(PRINT_FP, NULL, " brd ", NULL);
>> +
>> +		print_color_string(PRINT_ANY,
>> +				COLOR_MAC,
>> +				"broadcast",
>> +				"%s",
>> +				ll_addr_n2a((unsigned char *) &vf_broadcast->broadcast,
>> +					ifi->ifi_type == ARPHRD_ETHER ?
>> +					ETH_ALEN : INFINIBAND_ALEN,
>> +					ifi->ifi_type,
>> +					b1, sizeof(b1)));
>
> And then these lines are offset to the left.

Hi David,

I've just sent a new version and I've formatted strings in the similar
way as it used through the source.

Thank you.

>
