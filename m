Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07AE22E90C0
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 08:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbhADHGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 02:06:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26351 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726148AbhADHGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 02:06:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609743917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7jV/b1qkJ/bT/FIZ0qTc/fmDTqo3xcqkhKGWdVPv3Ks=;
        b=R38+29jIT2048C3Jk8mlxJtlrpAB47lg4qGLB2SzeFm9WB8EDRI6xP0wI3RI1drg9Ptpwl
        bQTus7l8yC5OSo1iges88n6Ew9E6qGevTgWtOEKgUjH+0kSd2krGn2O4i6HtzSdLNwq7M+
        n2mX4P6cb8VW57LisZADLarP7SW76BQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-505-Y0yoWDnSPTaaHTKx2YDjvQ-1; Mon, 04 Jan 2021 02:05:13 -0500
X-MC-Unique: Y0yoWDnSPTaaHTKx2YDjvQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A5EE800D55;
        Mon,  4 Jan 2021 07:05:12 +0000 (UTC)
Received: from [10.72.13.91] (ovpn-13-91.pek2.redhat.com [10.72.13.91])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9AF735D9D3;
        Mon,  4 Jan 2021 07:05:07 +0000 (UTC)
Subject: Re: [PATCH linux-next v2 7/7] vdpa_sim_net: Add support for user
 supported devices
To:     Parav Pandit <parav@nvidia.com>,
        virtualization@lists.linux-foundation.org
Cc:     mst@redhat.com, elic@nvidia.com, netdev@vger.kernel.org
References: <20201112064005.349268-1-parav@nvidia.com>
 <20210104033141.105876-1-parav@nvidia.com>
 <20210104033141.105876-8-parav@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ea07c16e-6bc5-0371-4b53-4bf4c75d5af8@redhat.com>
Date:   Mon, 4 Jan 2021 15:05:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210104033141.105876-8-parav@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/1/4 上午11:31, Parav Pandit wrote:
>   static int __init vdpasim_net_init(void)
>   {
>   	int ret = 0;
> @@ -176,6 +264,8 @@ static int __init vdpasim_net_init(void)
>   
>   	if (default_device)
>   		ret = vdpasim_net_default_dev_register();
> +	else
> +		ret = vdpasim_net_mgmtdev_init();
>   	return ret;
>   }
>   
> @@ -183,6 +273,8 @@ static void __exit vdpasim_net_exit(void)
>   {
>   	if (default_device)
>   		vdpasim_net_default_dev_unregister();
> +	else
> +		vdpasim_net_mgmtdev_cleanup();
>   }
>   
>   module_init(vdpasim_net_init);
> -- 2.26.2


I wonder what's the value of keeping the default device that is out of 
the control of management API.

Thanks

