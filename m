Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C15413BDC4
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 22:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbfFJUtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 16:49:42 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36643 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727771AbfFJUtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 16:49:42 -0400
Received: by mail-pg1-f194.google.com with SMTP id a3so5653204pgb.3
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 13:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=jc8wLES0pFE0B2lIoNGk8i8nABl9F14regklvJEeVVk=;
        b=la/yliK5mleAhgBxDHwgA8x5p+WSV5kQTtiHboOuwfZ5SMAX8ofDeKi28GrcrdzYFg
         Nl4gtuuCMbqS2eoX4eDX5eoa02i6ibl9idkcRnZyaO8Cjv4xxDQXFWbfes78h7ou7L4R
         QLx9eajvNYO4jCAqlLpoqv5cxQbAUuPBqsqv5c9u+5cT4QNM/XwOGrMQ2yiBIkrNQvkT
         bQz1kAzJ1PRuc7oaUI1aWRjDFkUienoVMRgpiqk6nhaISYjDTrgSvKN0yK0L1nojdVIV
         e6UR1pNkGu9pglab8KZN4kqCuSTIB1ARcWlPud0dxGoZTQu8zS3SstIg0qgFIJUDRJLs
         KTTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=jc8wLES0pFE0B2lIoNGk8i8nABl9F14regklvJEeVVk=;
        b=JJudKWGqsAlREZHe9fSKEEyml2NxxulDtpJXhWhSSjQMM39gAJ9DVo+6aCHuWtE2Xt
         4uRZAHyKx/3lOb1HRrc+Qv2KdgHsHsCXN8OXRHsdk/NQAfjf3RFmjb12c3/F8MkRAbsy
         2yZYwbTlIZKUOdJXw9BLSntFYQV47F3iY4iZR5asuFJ57PkNiQL540mUp495OzYVXSRY
         Il1+Z3xgPduWVMqbZGC9ZL0Pxn2VsMS6fICd1VeUAvIRSyDhoHadKt/SqTCjP/v48QD6
         3fbA3C//lmy9mM070y69YmXc7aPFz6qJ0kbjn7D5oq9/XAkgMmzghfM2uGoULfX1DR1M
         Fhig==
X-Gm-Message-State: APjAAAV5Ado5OSFQCk3Fr3s87GUzBJMtv9dFz4WZML2oMCx97U59+kjR
        hmjISoedwRSyLaoe2KfLRBk=
X-Google-Smtp-Source: APXvYqzW+afO2MJZwp2jUBSRjr0bKLjWw1pgc65JW3mvax8W3y7GuS77ksHXCxrGv1njf1ifGVfo/w==
X-Received: by 2002:aa7:8394:: with SMTP id u20mr65022745pfm.252.1560199780958;
        Mon, 10 Jun 2019 13:49:40 -0700 (PDT)
Received: from [192.168.0.16] (97-115-113-19.ptld.qwest.net. [97.115.113.19])
        by smtp.gmail.com with ESMTPSA id b2sm12733733pgk.50.2019.06.10.13.49.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 13:49:40 -0700 (PDT)
Subject: Re: [ovs-dev] [PATCH net] net: openvswitch: do not free vport if
 register_netdevice() is failed.
To:     Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        pshelar@ovn.org, netdev@vger.kernel.org, dev@openvswitch.org
References: <20190609142621.30674-1-ap420073@gmail.com>
From:   Gregory Rose <gvrose8192@gmail.com>
Message-ID: <4cf21b2e-9e4c-acda-d432-24525645f385@gmail.com>
Date:   Mon, 10 Jun 2019 13:49:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190609142621.30674-1-ap420073@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/9/2019 7:26 AM, Taehee Yoo wrote:
> In order to create an internal vport, internal_dev_create() is used and
> that calls register_netdevice() internally.
> If register_netdevice() fails, it calls dev->priv_destructor() to free
> private data of netdev. actually, a private data of this is a vport.
>
> Hence internal_dev_create() should not free and use a vport after failure
> of register_netdevice().
>
> Test command
>      ovs-dpctl add-dp bonding_masters
>
> Splat looks like:
> [ 1035.667767] kasan: GPF could be caused by NULL-ptr deref or user memory access
> [ 1035.675958] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
> [ 1035.676916] CPU: 1 PID: 1028 Comm: ovs-vswitchd Tainted: G    B             5.2.0-rc3+ #240
> [ 1035.676916] RIP: 0010:internal_dev_create+0x2e5/0x4e0 [openvswitch]
> [ 1035.676916] Code: 48 c1 ea 03 80 3c 02 00 0f 85 9f 01 00 00 4c 8b 23 48 b8 00 00 00 00 00 fc ff df 49 8d bc 24 60 05 00 00 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 86 01 00 00 49 8b bc 24 60 05 00 00 e8 e4 68 f4
> [ 1035.713720] RSP: 0018:ffff88810dcb7578 EFLAGS: 00010206
> [ 1035.713720] RAX: dffffc0000000000 RBX: ffff88810d13fe08 RCX: ffffffff84297704
> [ 1035.713720] RDX: 00000000000000ac RSI: 0000000000000000 RDI: 0000000000000560
> [ 1035.713720] RBP: 00000000ffffffef R08: fffffbfff0d3b881 R09: fffffbfff0d3b881
> [ 1035.713720] R10: 0000000000000001 R11: fffffbfff0d3b880 R12: 0000000000000000
> [ 1035.768776] R13: 0000607ee460b900 R14: ffff88810dcb7690 R15: ffff88810dcb7698
> [ 1035.777709] FS:  00007f02095fc980(0000) GS:ffff88811b400000(0000) knlGS:0000000000000000
> [ 1035.777709] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1035.777709] CR2: 00007ffdf01d2f28 CR3: 0000000108258000 CR4: 00000000001006e0
> [ 1035.777709] Call Trace:
> [ 1035.777709]  ovs_vport_add+0x267/0x4f0 [openvswitch]
> [ 1035.777709]  new_vport+0x15/0x1e0 [openvswitch]
> [ 1035.777709]  ovs_vport_cmd_new+0x567/0xd10 [openvswitch]
> [ 1035.777709]  ? ovs_dp_cmd_dump+0x490/0x490 [openvswitch]
> [ 1035.777709]  ? __kmalloc+0x131/0x2e0
> [ 1035.777709]  ? genl_family_rcv_msg+0xa54/0x1030
> [ 1035.777709]  genl_family_rcv_msg+0x63a/0x1030
> [ 1035.777709]  ? genl_unregister_family+0x630/0x630
> [ 1035.841681]  ? debug_show_all_locks+0x2d0/0x2d0
> [ ... ]
>
> Fixes: cf124db566e6 ("net: Fix inconsistent teardown and release of private netdev state.")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>   net/openvswitch/vport-internal_dev.c | 18 ++++++++++++------
>   1 file changed, 12 insertions(+), 6 deletions(-)
>
> diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
> index 26f71cbf7527..5993405c25c1 100644
> --- a/net/openvswitch/vport-internal_dev.c
> +++ b/net/openvswitch/vport-internal_dev.c
> @@ -170,7 +170,9 @@ static struct vport *internal_dev_create(const struct vport_parms *parms)
>   {
>   	struct vport *vport;
>   	struct internal_dev *internal_dev;
> +	struct net_device *dev;
>   	int err;
> +	bool free_vport = true;
>   
>   	vport = ovs_vport_alloc(0, &ovs_internal_vport_ops, parms);
>   	if (IS_ERR(vport)) {
> @@ -178,8 +180,9 @@ static struct vport *internal_dev_create(const struct vport_parms *parms)
>   		goto error;
>   	}
>   
> -	vport->dev = alloc_netdev(sizeof(struct internal_dev),
> -				  parms->name, NET_NAME_USER, do_setup);
> +	dev = alloc_netdev(sizeof(struct internal_dev),
> +			   parms->name, NET_NAME_USER, do_setup);
> +	vport->dev = dev;
>   	if (!vport->dev) {
>   		err = -ENOMEM;
>   		goto error_free_vport;
> @@ -200,8 +203,10 @@ static struct vport *internal_dev_create(const struct vport_parms *parms)
>   
>   	rtnl_lock();
>   	err = register_netdevice(vport->dev);
> -	if (err)
> +	if (err) {
> +		free_vport = false;
>   		goto error_unlock;
> +	}
>   
>   	dev_set_promiscuity(vport->dev, 1);
>   	rtnl_unlock();
> @@ -211,11 +216,12 @@ static struct vport *internal_dev_create(const struct vport_parms *parms)
>   
>   error_unlock:
>   	rtnl_unlock();
> -	free_percpu(vport->dev->tstats);
> +	free_percpu(dev->tstats);
>   error_free_netdev:
> -	free_netdev(vport->dev);
> +	free_netdev(dev);
>   error_free_vport:
> -	ovs_vport_free(vport);
> +	if (free_vport)
> +		ovs_vport_free(vport);
>   error:
>   	return ERR_PTR(err);
>   }

Reviewed-by: Greg Rose <gvrose8192@gmail.com>

