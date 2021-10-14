Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5390442E167
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 20:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbhJNShN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 14:37:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:52056 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233937AbhJNShN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 14:37:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634236507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UZNn8kzbWIxQwtjH8lt0ko0RegzP6xW5fshzI713BkU=;
        b=b+xVlqq79Ls7Q1nNoIA3en2OE0+Wc4uXYVsOj8AcxkrW7wRp85Uj1vnj66kM6U1L4d1tMl
        bt5sBIlSRMvXGkl+Pur5yJoeX5EmhM/qwYRcz7YcXmKu52cDEOwH5E8xwteHZcMTDUBmBA
        rIJUtgGI/MCwNda3oUodjtpe1LK96d8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-BJUzd1_QP2CaybUaVeq_mQ-1; Thu, 14 Oct 2021 14:35:04 -0400
X-MC-Unique: BJUzd1_QP2CaybUaVeq_mQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35C0A801AA7;
        Thu, 14 Oct 2021 18:35:02 +0000 (UTC)
Received: from asgard.redhat.com (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DF9595DEFA;
        Thu, 14 Oct 2021 18:34:59 +0000 (UTC)
Date:   Thu, 14 Oct 2021 20:34:56 +0200
From:   Eugene Syromiatnikov <esyr@redhat.com>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, Matt Johnston <matt@codeconstruct.com.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-m68k@lists.linux-m68k.org
Subject: Re: [PATCH net-next v4 04/15] mctp: Add sockaddr_mctp to uapi
Message-ID: <20211014183456.GA8474@asgard.redhat.com>
References: <20210729022053.134453-1-jk@codeconstruct.com.au>
 <20210729022053.134453-5-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729022053.134453-5-jk@codeconstruct.com.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 10:20:42AM +0800, Jeremy Kerr wrote:
> This change introduces the user-visible MCTP header, containing the
> protocol-specific addressing definitions.

[...]

> --- a/include/uapi/linux/mctp.h
> +++ b/include/uapi/linux/mctp.h
> @@ -9,7 +9,28 @@
>  #ifndef __UAPI_MCTP_H
>  #define __UAPI_MCTP_H
>  
> +#include <linux/types.h>
> +
> +typedef __u8			mctp_eid_t;
> +
> +struct mctp_addr {
> +	mctp_eid_t		s_addr;
> +};
> +
>  struct sockaddr_mctp {
> +	unsigned short int	smctp_family;

This gap makes the size of struct sockaddr_mctp 2 bytes less at least
on m68k, are you fine with that?

> +	int			smctp_network;
> +	struct mctp_addr	smctp_addr;
> +	__u8			smctp_type;
> +	__u8			smctp_tag;
>  };

