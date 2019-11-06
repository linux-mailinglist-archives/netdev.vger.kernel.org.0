Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E727EF0D9B
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 05:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbfKFENX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 23:13:23 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45607 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725768AbfKFENX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 23:13:23 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5AF1A20CF2;
        Tue,  5 Nov 2019 23:13:21 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 05 Nov 2019 23:13:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm3; bh=
        9fPd8NkoyeMPutvOXwvfGAl4ZrfOV/gls8KMdRI4UEk=; b=XD0hI0L86Lo6Vf/8
        gb6X6NQc+ZajB1lZ7xA6/wvYZAF0gJ6LKNZz4CFOVDwyKI/+ErhInawo9C6r+pR/
        Y8fGD7SGJNjS38a4QJMpOU0oUDZEIwdtuOSWFST/wAmPCVzgH4fY7iB7V2JB4exY
        t+DSfVD9Z3iNakZ6lNqHN5vVClD3iMa57GWH+aj3ORXSq8rT+aZGS4pjaXoxBnfz
        PZTtEvYNc+Y9c25Qb2c/8wog60mAHeNrSuHLLWp82EZV+uUin1iSU4lTpsR9o4MC
        q9Xh4oRBtPxPjVPoUALoS3eQ6grSp4XraKTNgYbQExWRxqp+YS7F+4waU6XZhBRE
        Zbst4Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=9fPd8NkoyeMPutvOXwvfGAl4ZrfOV/gls8KMdRI4U
        Ek=; b=lmaNePXrO8OOlZCxY1Wlsa9tNYJKP3sJ6h41DCn1GzeqAQbzGUBccdltK
        gpszokTyoFbOvK7LKiAjaRi8n4vWoqKLloeA/eTbqhVXHfs88KzufU1PgodQpJYm
        /BBWJ+ZQCGUwFr2LIZIzf0ykWwgdCxTMCyftpwJzdTcFu652LiGRHN6inRsQ9WBx
        kbGhaevsbEh4yHjR8KBLaE4r3NJJAxX3pQ4nFggZqI2LzyUYw//GgcgaJw5fuCAc
        zrIhj4N8R/uauAc6weCw/2M5orHjcQaTVMOhBcfz3w2+VwW92yw8L57i51222CQ+
        9pLj+0X4ZrE8ApaNc9Rc433xFJ+Aw==
X-ME-Sender: <xms:YEjCXY9fmfe4XuJ4SnmvQxk5omqFxceO8tyaCDHHoN9qEPA5mhkIvg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudduiedgieekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdludehmdenucfjughrpefkuffhvfffjghftggfggfgsehtjeertddt
    reejnecuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgvhicuoehruhhstghurhesrhhush
    hsvghllhdrtggtqeenucfkphepuddvvddrleelrdekvddruddtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehruhhstghurhesrhhushhsvghllhdrtggtnecuvehluhhsthgvrhfuih
    iivgeptd
X-ME-Proxy: <xmx:YEjCXb5n-yFOXWPZZ3XOf4LzVl0sT-hUjE68NRrhV1vaKCIauqOhjg>
    <xmx:YEjCXR1eoPqnoYKEVSv9Sj-gsSn7DMNfT4dDSGFVVeNCjiBGSi7e4w>
    <xmx:YEjCXSwmP5JQMRIrC3P0I0oHq7qbH5KZ1DoivTjwivqDdkK1ViSVPw>
    <xmx:YUjCXZtGBV9ZdLuJV7a1_rzcEXdh2xB_9TBvSDj3SL83a4yq7jd0Kg>
Received: from crackle.ozlabs.ibm.com (unknown [122.99.82.10])
        by mail.messagingengine.com (Postfix) with ESMTPA id 62F183060057;
        Tue,  5 Nov 2019 23:13:18 -0500 (EST)
Message-ID: <b42f1dbdba88f74149de669cb285408d640cdb79.camel@russell.cc>
Subject: Re: [RFC PATCH] powerpc/pseries/mobility: notify network peers
 after migration
From:   Russell Currey <ruscur@russell.cc>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>, linuxppc-dev@ozlabs.org
Cc:     nathanl@linux.ibm.com, netdev@vger.kernel.org, msuchanek@suse.com,
        tyreld@linux.ibm.com
Date:   Wed, 06 Nov 2019 15:13:15 +1100
In-Reply-To: <1572998794-9392-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1572998794-9392-1-git-send-email-tlfalcon@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-11-05 at 18:06 -0600, Thomas Falcon wrote:
> After a migration, it is necessary to send a gratuitous ARP
> from all running interfaces so that the rest of the network
> is aware of its new location. However, some supported network
> devices are unaware that they have been migrated. To avoid network
> interruptions and other unwanted behavior, force a GARP on all
> valid, running interfaces as part of the post_mobility_fixup
> routine.
> 
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>

Hi Thomas,

> ---
>  arch/powerpc/platforms/pseries/mobility.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/arch/powerpc/platforms/pseries/mobility.c
> b/arch/powerpc/platforms/pseries/mobility.c
> index b571285f6c14..c1abc14cf2bb 100644
> --- a/arch/powerpc/platforms/pseries/mobility.c
> +++ b/arch/powerpc/platforms/pseries/mobility.c
> @@ -17,6 +17,9 @@
>  #include <linux/delay.h>
>  #include <linux/slab.h>
>  #include <linux/stringify.h>
> +#include <linux/netdevice.h>
> +#include <linux/rtnetlink.h>
> +#include <net/net_namespace.h>
>  
>  #include <asm/machdep.h>
>  #include <asm/rtas.h>
> @@ -331,6 +334,8 @@ void post_mobility_fixup(void)
>  {
>  	int rc;
>  	int activate_fw_token;
> +	struct net_device *netdev;
> +	struct net *net;
>  
>  	activate_fw_token = rtas_token("ibm,activate-firmware");
>  	if (activate_fw_token == RTAS_UNKNOWN_SERVICE) {
> @@ -371,6 +376,21 @@ void post_mobility_fixup(void)
>  	/* Possibly switch to a new RFI flush type */
>  	pseries_setup_rfi_flush();
>  
> +	/* need to force a gratuitous ARP on running interfaces */
> +	rtnl_lock();
> +	for_each_net(net) {
> +		for_each_netdev(net, netdev) {
> +			if (netif_device_present(netdev) &&
> +			    netif_running(netdev) &&
> +			    !(netdev->flags & (IFF_NOARP |
> IFF_LOOPBACK)))
> +				call_netdevice_notifiers(NETDEV_NOTIFY_
> PEERS,
> +							 netdev);

Without curly braces following the "if" statment, the second line
(below) will be executed unconditionally, which I assume with this
indentation isn't what you want.

(reported by snowpatch)

- Russell

> +				call_netdevice_notifiers(NETDEV_RESEND_
> IGMP,
> +							 netdev);
> +		}
> +	}
> +	rtnl_unlock();
> +
>  	return;
>  }
>  

