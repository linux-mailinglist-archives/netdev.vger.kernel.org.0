Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED03415FF94
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 18:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgBOR6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 12:58:09 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:42614 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgBOR6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 12:58:09 -0500
Received: by mail-io1-f68.google.com with SMTP id z1so13523661iom.9
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 09:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kSgHNN86DBH1bzgT1omIP17yn+wSMefBALOV0kkVzPM=;
        b=GXSPm1DOARLPbybQ3NItzvuhTTsxDtMkZWg3fjOXs6ymw2odSYMo/GuPHKdKF6aflO
         q1CEVSaytrXrgpmMLQPVrfVwW9yIXyZtTw2GlspG9g2I/JHFD2DWYdNV7UZ2bZiD2vd7
         y8PdD+LmpJskRhW+ySeV1rksjvO/MF9UWhSCa0FhMzMjAGPEX1cIzZ9q4AnQAz4SP4zn
         U9l+Qucw0LUGi4JaoKeuk38K0Cs/d1v3ojmWEfH5zIcSp9yfN/Yb/Qyw5uVXtqhd1vB1
         oXU9TJF/gYQ9cKaB+gmO6u47pc6p+JUOUIlC2vKDPPMDEkxtdoRMrCJqoEQ2jSNBh0t5
         INOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kSgHNN86DBH1bzgT1omIP17yn+wSMefBALOV0kkVzPM=;
        b=mF4cjqIoP3UKmpEtbG7PYbLRkptyPAX5RZD/dM2AoQhL7HzvPXen6Bk3om6ER4suz3
         MScxh+Iubwg16ZVn95ziDa6Em+Dv7vbAHohEZVSOC11QmcfeqI0GVwyiYjrzu4SOCGu5
         XiYjlkwuDX3HJc6YDwmS5k6gv+/i1oW+2Wpv7jivH/phX3jXJ9WdzREAIPXr45CEmgeU
         XDccwmfpAFebtqe9Tv6nnNPpQn7pwxkzNQfK1FxtSdZ3gk12qZg0iuGK9I1Y2u+NREyt
         luAB/caTXmVLCVVP2c1I9PJ817khna7jMW5i0QYUMVoZE8lm3q60xciTIsnoTdFg1Way
         THeA==
X-Gm-Message-State: APjAAAU8Tu8lvvftpesYWV1cHR6xe/iHNvAtY3tNQVPGdtwxcb58dwn5
        FVU8jPYcYzy3SZs3Iq+mjpQ=
X-Google-Smtp-Source: APXvYqy+8jghg/7O8bs1V0CJvFUvytOd9ttAP9ekE2SfBhRJPhLHZKv+Gxxf4d6zzy7/7CS8NSPtIw==
X-Received: by 2002:a02:cba5:: with SMTP id v5mr7191255jap.64.1581789488784;
        Sat, 15 Feb 2020 09:58:08 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:65d1:a3b2:d15f:79af? ([2601:282:803:7700:65d1:a3b2:d15f:79af])
        by smtp.googlemail.com with ESMTPSA id r22sm3347203ilb.25.2020.02.15.09.58.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Feb 2020 09:58:07 -0800 (PST)
Subject: Re: [PATCH net 2/2] ipv6: Fix nlmsg_flags when splitting a multipath
 route
To:     Benjamin Poirier <bpoirier@cumulusnetworks.com>,
        netdev@vger.kernel.org
Cc:     =?UTF-8?Q?Michal_Kube=c4=8dek?= <mkubecek@suse.cz>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
References: <20200212014107.110066-1-bpoirier@cumulusnetworks.com>
 <20200212014107.110066-2-bpoirier@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2a2ea941-edaa-acc1-6345-01614d240bc8@gmail.com>
Date:   Sat, 15 Feb 2020 10:58:06 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200212014107.110066-2-bpoirier@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/20 6:41 PM, Benjamin Poirier wrote:
> When splitting an RTA_MULTIPATH request into multiple routes and adding the
> second and later components, we must not simply remove NLM_F_REPLACE but
> instead replace it by NLM_F_CREATE. Otherwise, it may look like the netlink
> message was malformed.
> 
> For example,
> 	ip route add 2001:db8::1/128 dev dummy0
> 	ip route change 2001:db8::1/128 nexthop via fe80::30:1 dev dummy0 \
> 		nexthop via fe80::30:2 dev dummy0
> results in the following warnings:
> [ 1035.057019] IPv6: RTM_NEWROUTE with no NLM_F_CREATE or NLM_F_REPLACE
> [ 1035.057517] IPv6: NLM_F_CREATE should be set when creating new route
> 
> This patch makes the nlmsg sequence look equivalent for __ip6_ins_rt() to
> what it would get if the multipath route had been added in multiple netlink
> operations:
> 	ip route add 2001:db8::1/128 dev dummy0
> 	ip route change 2001:db8::1/128 nexthop via fe80::30:1 dev dummy0
> 	ip route append 2001:db8::1/128 nexthop via fe80::30:2 dev dummy0
> 
> Fixes: 27596472473a ("ipv6: fix ECMP route replacement")
> Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
> ---
>  net/ipv6/route.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 4fbdc60b4e07..2931224b674e 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -5198,6 +5198,7 @@ static int ip6_route_multipath_add(struct fib6_config *cfg,
>  		 */
>  		cfg->fc_nlinfo.nlh->nlmsg_flags &= ~(NLM_F_EXCL |
>  						     NLM_F_REPLACE);
> +		cfg->fc_nlinfo.nlh->nlmsg_flags |= NLM_F_CREATE;
>  		nhn++;
>  	}
>  
> 

Reviewed-by: David Ahern <dsahern@gmail.com>
