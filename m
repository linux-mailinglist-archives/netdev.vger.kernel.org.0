Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C21128F7BD
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 19:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731308AbgJORm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 13:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728766AbgJORm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 13:42:58 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99867C061755;
        Thu, 15 Oct 2020 10:42:56 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id t9so2145376qtp.9;
        Thu, 15 Oct 2020 10:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5+UPfCYzgGrwcqIa1iV5ZAgmChHCUPL3J9p4rH01FDA=;
        b=orNGo0zwde1afeqSA0/gcY1Kn2XER0sCgjn6jAety1f30VvspGDyayMypAo7atrUGp
         fVuKno+m7/94BwiSUUtt21WB8YfyaMOui41G8LBWzCYeNDwAliExXQj9o9aawBHXWfNR
         tvUpVYH56MV36k/vCFfnNea8Yc/LcMWM7FqStO9ATzC+fa8Mqn7gt62vkk37E5Hd+8X9
         kvjaMy4JV2WqZbLZFGSXPthJ2eFIZTY2AGaniYR4YBomdmNi4hEyfJ7uIFOsHEHq5bNW
         BYwV98Kb1NIVCG71ZJO5FCYz++S9IV+AYvKW+x3gPKNG+dia/mbUMHRZ/IAe0mXqga5N
         8zlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5+UPfCYzgGrwcqIa1iV5ZAgmChHCUPL3J9p4rH01FDA=;
        b=RAYnHiyirlAdQ9gQX+cBjW0mLidwREQVI79CFI9zziaybDUrPKUPsQLbmko2AS9L8A
         1JcJaXmCnUcjCyWEqqsPNU+7p8WBkJmz4CXEQT8bSHzU2B6JZXVSzInYsq0x/AhO2fFI
         ffKteibITsB21Urz2FDOTCzHcxksByJlQFKNYsxeiTn+u8YOgw8LKOsS2imjYtLZfG9k
         O+PvsYBBf5dpEiVPaISlYEPR0HaeuQ9V6Qq27qCSapn+YHj7l0pYcqTUWigqB0rkrQn1
         Pv/ykVxxzwrJcJJaFJ7SZxHlEjKpKD3xwDnjNjR81yTBkj1g9H3mJ8t0m81qJPhtfS4G
         BLZA==
X-Gm-Message-State: AOAM533SayKp/fNw5gCDKdD+qM475DhvOc3NGkAt6zdjcVDxsrfskEMV
        WVv3zSMp73p585rTzv2iHw9W1aQIH1V0fQ==
X-Google-Smtp-Source: ABdhPJwedBeG/YiN9jupR2RqJsNi6GQ3UgVOW1De2suA/5zvTuL/QwiDN6PYiLgTmB3zJjYA9XtxAw==
X-Received: by 2002:ac8:6901:: with SMTP id e1mr5406322qtr.122.1602783775448;
        Thu, 15 Oct 2020 10:42:55 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:ee5e:869e:fafd:dd5c:4ff0])
        by smtp.gmail.com with ESMTPSA id f22sm1396015qtf.4.2020.10.15.10.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 10:42:54 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 88159C1614; Thu, 15 Oct 2020 14:42:52 -0300 (-03)
Date:   Thu, 15 Oct 2020 14:42:52 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: Re: [PATCHv3 net-next 16/16] sctp: enable udp tunneling socks
Message-ID: <20201015174252.GB11030@localhost.localdomain>
References: <cover.1602574012.git.lucien.xin@gmail.com>
 <afbaca39fa40eba694bd63c200050a49d8c8df81.1602574012.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afbaca39fa40eba694bd63c200050a49d8c8df81.1602574012.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Actually..

On Tue, Oct 13, 2020 at 03:27:41PM +0800, Xin Long wrote:
...
> Also add sysctl udp_port to allow changing the listening
> sock's port by users.
...
> ---
>  net/sctp/protocol.c |  5 +++++
>  net/sctp/sysctl.c   | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 55 insertions(+)

Xin, sorry for not noticing this earlier, but we need a documentation
update here for this new sysctl. This is important. Please add its
entry in ip-sysctl.rst.

> 
> diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
> index be002b7..79fb4b5 100644
> --- a/net/sctp/protocol.c
> +++ b/net/sctp/protocol.c
> @@ -1469,6 +1469,10 @@ static int __net_init sctp_ctrlsock_init(struct net *net)
>  	if (status)
>  		pr_err("Failed to initialize the SCTP control sock\n");
>  
> +	status = sctp_udp_sock_start(net);
> +	if (status)
> +		pr_err("Failed to initialize the SCTP udp tunneling sock\n");
                                                      ^^^ upper case please.
Nit. There are other occurrences of this.

> +
>  	return status;
...
> +	ret = proc_dointvec(&tbl, write, buffer, lenp, ppos);
> +	if (write && ret == 0) {
> +		struct sock *sk = net->sctp.ctl_sock;
> +
> +		if (new_value > max || new_value < min)
> +			return -EINVAL;
> +
> +		net->sctp.udp_port = new_value;
> +		sctp_udp_sock_stop(net);

So, if it would be disabling the encapsulation, it shouldn't be
calling _start() then, right? Like

		if (new_value)
			ret = sctp_udp_sock_start(net);
		
Otherwise _start() here will call ..._bind() with port 0, which then
will be a random one.

> +		ret = sctp_udp_sock_start(net);
> +		if (ret)
> +			net->sctp.udp_port = 0;
> +
> +		/* Update the value in the control socket */
> +		lock_sock(sk);
> +		sctp_sk(sk)->udp_port = htons(net->sctp.udp_port);
> +		release_sock(sk);
> +	}
> +
> +	return ret;
> +}
> +
>  int sctp_sysctl_net_register(struct net *net)
>  {
>  	struct ctl_table *table;
> -- 
> 2.1.0
> 
