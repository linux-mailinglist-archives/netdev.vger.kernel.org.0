Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E435B5C1DB
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbfGARTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:19:18 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:39440 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbfGARTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 13:19:18 -0400
Received: by mail-io1-f66.google.com with SMTP id r185so30536589iod.6;
        Mon, 01 Jul 2019 10:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2A78zlg/wY4auVpbDBNcXhH/5hwQap2ye39x24YdrUg=;
        b=CW9nD1ChWMAPTUSKMOEyY91qcqoV+X8hxWpQCwByCw/8VsueG5dJX/62DeGe1NiREx
         z/aF9Ve4H39XXqYAEDEQo0q9FC7Lytaar2r6cDJm/dNiw/Z5Z2I4Y+kxC3UXn/mWZuJ0
         JTw0nQPoiSZk4sTM8t9QQLfsqF+myZWc3sykYgI7cOo7mLAhAi9WFxiNSfc2fW5LsAZD
         MMsyq6C8wdYYO8CiniL+LdFaGl6L9SoEJ61vDC/oaWlsPYo/P4n2YEF8JDCiGVI4XonH
         ETmN7eW13CGqI8FQMbMQoX3t1neAkcaOGbYSnwD1I2bo3DK1j7LavsrAAcol1XLar/UT
         wqMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2A78zlg/wY4auVpbDBNcXhH/5hwQap2ye39x24YdrUg=;
        b=mjI9WrATNxdptW05R63ZDNFTjKS/unv5X3UqkF3SSenGYMDhkdPFTKmmqIafZ6h2SL
         u8na85QWu/TaPU2l8kGS2QR+TV1q2qoaQPID7DyFtnT+xKuxkHCCZcrrD/wacf+XGMVP
         mo1LyAY2WfSDDMC6HlR9kmKskVXOfrR/pXG8kl4ymiG83VXqILsikYPsRltk3vQx6Nul
         f/gDAfTN7XRTpGewE6GFb0uaAwm5hwuyb9gMMcmU7D1go3KVXNXjv+4SDgoSj9A35VV3
         KvTPS7ZZsSmmkbfh7YCTOeXvbqZOsFSO5JiOsW7plpZlLtWyRQToMnOoOxRq7Tu4OoPp
         RXJw==
X-Gm-Message-State: APjAAAUv7InF9ph7dSdgfxZH4ddJjQM3txTv+R2ld2ZydKRosKhIwHK8
        1N+YKQgwXPKDCfLmtMiq1Pk=
X-Google-Smtp-Source: APXvYqyabXqvV4OKTSGkKwHDkVElpiG01t+xBXjTuln70qdqKmo07xyCC/f5WLhI48EIJX8JgdAaBw==
X-Received: by 2002:a02:c50a:: with SMTP id s10mr30739749jam.106.1562001557576;
        Mon, 01 Jul 2019 10:19:17 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:f191:fe61:9293:d1ca? ([2601:282:800:fd80:f191:fe61:9293:d1ca])
        by smtp.googlemail.com with ESMTPSA id n21sm10537257ioh.30.2019.07.01.10.19.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 10:19:16 -0700 (PDT)
Subject: Re: [PATCH net v2] ipv4: don't set IPv6 only flags to IPv4 addresses
To:     Matteo Croce <mcroce@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <20190701170155.1967-1-mcroce@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c8fac6db-6455-b138-aca9-2f54d782a0b6@gmail.com>
Date:   Mon, 1 Jul 2019 11:19:15 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190701170155.1967-1-mcroce@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/19 11:01 AM, Matteo Croce wrote:
> Avoid the situation where an IPV6 only flag is applied to an IPv4 address:
> 
>     # ip addr add 192.0.2.1/24 dev dummy0 nodad home mngtmpaddr noprefixroute
>     # ip -4 addr show dev dummy0
>     2: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
>         inet 192.0.2.1/24 scope global noprefixroute dummy0
>            valid_lft forever preferred_lft forever
> 
> Or worse, by sending a malicious netlink command:
> 
>     # ip -4 addr show dev dummy0
>     2: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
>         inet 192.0.2.1/24 scope global nodad optimistic dadfailed home tentative mngtmpaddr noprefixroute stable-privacy dummy0
>            valid_lft forever preferred_lft forever
> 
> Signed-off-by: Matteo Croce <mcroce@redhat.com>
> ---
>  net/ipv4/devinet.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
> index c6bd0f7a020a..c5ebfa199794 100644
> --- a/net/ipv4/devinet.c
> +++ b/net/ipv4/devinet.c
> @@ -62,6 +62,11 @@
>  #include <net/net_namespace.h>
>  #include <net/addrconf.h>
>  
> +#define IPV6ONLY_FLAGS	\
> +		(IFA_F_NODAD | IFA_F_OPTIMISTIC | IFA_F_DADFAILED | \
> +		 IFA_F_HOMEADDRESS | IFA_F_TENTATIVE | \
> +		 IFA_F_MANAGETEMPADDR | IFA_F_STABLE_PRIVACY)
> +
>  static struct ipv4_devconf ipv4_devconf = {
>  	.data = {
>  		[IPV4_DEVCONF_ACCEPT_REDIRECTS - 1] = 1,
> @@ -468,6 +473,9 @@ static int __inet_insert_ifa(struct in_ifaddr *ifa, struct nlmsghdr *nlh,
>  	ifa->ifa_flags &= ~IFA_F_SECONDARY;
>  	last_primary = &in_dev->ifa_list;
>  
> +	/* Don't set IPv6 only flags to IPv4 addresses */
> +	ifa->ifa_flags &= ~IPV6ONLY_FLAGS;
> +
>  	for (ifap = &in_dev->ifa_list; (ifa1 = *ifap) != NULL;
>  	     ifap = &ifa1->ifa_next) {
>  		if (!(ifa1->ifa_flags & IFA_F_SECONDARY) &&
> 

I guess at this point we can fail the address add, so this is the best
option. rtm_to_ifaddr could set a message in extack about invalid flags
- not fail the change, just warn the user that flags will be ignored.

Reviewed-by: David Ahern <dsahern@gmail.com>

