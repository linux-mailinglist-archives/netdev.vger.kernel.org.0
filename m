Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8608D19C803
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 19:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389711AbgDBRbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 13:31:07 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38909 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388979AbgDBRbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 13:31:06 -0400
Received: by mail-qt1-f194.google.com with SMTP id z12so4018437qtq.5
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 10:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Wn9rCFyEYr8QEnNWLfbzPzKfssG+pw0324f/pdrm2YY=;
        b=VUmtIGLU0ybeBOIGrlOyNQ11/wPlhjnO2RXlKYyFQ31bI6JbzpFh99fQNImdXSxbQt
         /xSYU8YSmJcofBMQcb8DrrbmFzCKp+kJcmhoPHA4gYpkaA9exP3hn1AMJJzilo6X6n7U
         8/c22WK1L/2OMDull9RGq+sHXAkMBRvSkhLo33jz2Yok0H3ATN33tXllkb5ycTnSrDAe
         x1NE8vSgiBh0PfxodDPkXuSWWi99TXCFM+wrLwRpV/s0hBLPXCfqT8Mrm+kLepL7+MI5
         HKPO6AqqAc8VGe/iAZjHd2wG0c4+cNcQmMgrRlmmUc8ArXqhMubvpcMLYBvdTfkLE8dS
         Mxuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Wn9rCFyEYr8QEnNWLfbzPzKfssG+pw0324f/pdrm2YY=;
        b=i8LvqryQJrVIQy+76LJfotClk3spvKgHdI3n/q6ro7aiw0rVAl69JsmhBqwBXn2kO5
         WDqzs5VU4OIa7/uykRZkzyOzbWVhumPEBYrRxlLg02PTtEHiwIhBwQL8kWZ+OUDvZM3+
         ErH+yoiY83yUFw2RQyPUuxM9GaqApXZpHDpUrX43vBkzxRFbOqNzf3b0ZqFUm4ad4R8/
         ILo3PSt1Pd09MSnZz0MS143EEKkbfgZtfxpKfwJNVavTG71wbda3tiOEmLU+YK6Azq9g
         8+TYHrKKNN054LeJFDfH6zNhMZ1XAgN/5N+aloJ6/hbYdZdF3buNOiT2w4GkBnQ2XrVb
         FXpw==
X-Gm-Message-State: AGi0PuY2PDRbiPd7XxgsgRCX4C4vHuLDG3q1wMISSIRt9/Y560w4XAz2
        uXUbeh8fToQdEKG5OJSYID0=
X-Google-Smtp-Source: APiQypJCbEpuiS5UaTvdWleBvcv3HDhLGL7UwP/CdGeIBjt3MCcua68IRsBEFBI3+R1PbKM/EvvCLA==
X-Received: by 2002:ac8:2ff5:: with SMTP id m50mr4060014qta.327.1585848665845;
        Thu, 02 Apr 2020 10:31:05 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:f4d2:b187:10d3:9b08? ([2601:282:803:7700:f4d2:b187:10d3:9b08])
        by smtp.googlemail.com with ESMTPSA id 207sm4025963qkf.69.2020.04.02.10.31.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Apr 2020 10:31:04 -0700 (PDT)
Subject: Re: [PATCH net-next v2] net: core: enable SO_BINDTODEVICE for
 non-root users
To:     Vincent Bernat <vincent@bernat.ch>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Martin KaFai Lau <kafai@fb.com>
References: <20200331132009.1306283-1-vincent@bernat.ch>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <611648ff-7a61-5dbf-d2a4-b18f8f7513e9@gmail.com>
Date:   Thu, 2 Apr 2020 11:31:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200331132009.1306283-1-vincent@bernat.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/31/20 7:20 AM, Vincent Bernat wrote:
> Currently, SO_BINDTODEVICE requires CAP_NET_RAW. This change allows a
> non-root user to bind a socket to an interface if it is not already
> bound. This is useful to allow an application to bind itself to a
> specific VRF for outgoing or incoming connections. Currently, an
> application wanting to manage connections through several VRF need to
> be privileged.
> 
> Previously, IP_UNICAST_IF and IPV6_UNICAST_IF were added for
> Wine (76e21053b5bf3 and c4062dfc425e9) specifically for use by
> non-root processes. However, they are restricted to sendmsg() and not
> usable with TCP. Allowing SO_BINDTODEVICE would allow TCP clients to
> get the same privilege. As for TCP servers, outside the VRF use case,
> SO_BINDTODEVICE would only further restrict connections a server could
> accept.
> 
> When an application is restricted to a VRF (with `ip vrf exec`), the
> socket is bound to an interface at creation and therefore, a
> non-privileged call to SO_BINDTODEVICE to escape the VRF fails.
> 
> When an application bound a socket to SO_BINDTODEVICE and transmit it
> to a non-privileged process through a Unix socket, a tentative to
> change the bound device also fails.
> 
> Before:
> 
>     >>> import socket
>     >>> s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
>     >>> s.setsockopt(socket.SOL_SOCKET, socket.SO_BINDTODEVICE, b"dummy0")
>     Traceback (most recent call last):
>       File "<stdin>", line 1, in <module>
>     PermissionError: [Errno 1] Operation not permitted
> 
> After:
> 
>     >>> import socket
>     >>> s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
>     >>> s.setsockopt(socket.SOL_SOCKET, socket.SO_BINDTODEVICE, b"dummy0")
>     >>> s.setsockopt(socket.SOL_SOCKET, socket.SO_BINDTODEVICE, b"dummy0")
>     Traceback (most recent call last):
>       File "<stdin>", line 1, in <module>
>     PermissionError: [Errno 1] Operation not permitted
> 
> Signed-off-by: Vincent Bernat <vincent@bernat.ch>
> ---
>  net/core/sock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/sock.c b/net/core/sock.c
> index da32d9b6d09f..ce1d8dce9b7a 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -574,7 +574,7 @@ static int sock_setbindtodevice_locked(struct sock *sk, int ifindex)
>  
>  	/* Sorry... */
>  	ret = -EPERM;
> -	if (!ns_capable(net->user_ns, CAP_NET_RAW))
> +	if (sk->sk_bound_dev_if && !ns_capable(net->user_ns, CAP_NET_RAW))
>  		goto out;
>  
>  	ret = -EINVAL;
> 


Reviewed-by: David Ahern <dsahern@gmail.com>

