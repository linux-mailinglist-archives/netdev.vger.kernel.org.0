Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B872D652EFA
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 10:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbiLUJw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 04:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiLUJwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 04:52:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0CE2315B
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 01:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671616121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0DqqQu4/p5Bu6Q7O7nz3+VdKcBNnQK+05f7RglHv4Ow=;
        b=M7kxC1+CrO5KHOlI+en7V2Ny17G+i4uYKcyyVtrdhG1dl8XxcTbhlifOcZflMjUT+UCM7v
        ERK9oaRTD32CoVfp+pTXA6kEiP7FoGP4x1RL8oJNdapPHvx8VXpsgCz9+yrE84qU84TC4G
        zWj98I5HihrRAtJ0FZSaOSh1DHhOWik=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-339-4R0DfpRYMQWRAVp27akiww-1; Wed, 21 Dec 2022 04:48:40 -0500
X-MC-Unique: 4R0DfpRYMQWRAVp27akiww-1
Received: by mail-ej1-f70.google.com with SMTP id qa18-20020a170907869200b007df87611618so9798816ejc.1
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 01:48:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0DqqQu4/p5Bu6Q7O7nz3+VdKcBNnQK+05f7RglHv4Ow=;
        b=mG74DC5X0cRagW43+fVdSBCnUkKJemnH5iEKVLGe+IJ6R0IC9adJaiNswMzdftOBlP
         QxO1BUUffcZFasAYenuCCD+fAbTvA0vfHtQeCHdPFgw8CK28ltAWamEBtWgFjLSwTtK5
         592gamSmrIyueb6V9Ta/kTt0gOl4l7VlX/+wc0tR5X8B8wJMR6fpC7yfkVOm1TaFvyLN
         RkRa8wug4Dv9o119uP9fPYVDacWhri8Aq+wOER82Mv3zuGhQtbz6Rsq9/Xma4fqhJE9K
         rbMIByyiH1jzzfORC55fm0ufefonFOfRlhYkXodiKkRBFb5LqUQCfVn3GUkg5J3vhEG6
         oFAQ==
X-Gm-Message-State: AFqh2ko72bmbH5xUsOY+5z5HhnBnVfqrau9wp1YqJv4WgV3edbNG0OOv
        USiMJeEY2Ig0Adla3+PSrvlwM2DNnOa2KI1ME1ie8lVXpXjfChzjYIEuoc6ZD3hYQt/EdWCj0py
        jmgO2ktQ+rkeniimu
X-Received: by 2002:a17:907:c315:b0:7c1:b65:11d with SMTP id tl21-20020a170907c31500b007c10b65011dmr753061ejc.12.1671616118845;
        Wed, 21 Dec 2022 01:48:38 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtXq/DqLZypRBgXlsoku35xMEoLRmpUgHrTrjHXWDRpvqe0wCawvopmqvcqI9F8PnUQjh6dsQ==
X-Received: by 2002:a17:907:c315:b0:7c1:b65:11d with SMTP id tl21-20020a170907c31500b007c10b65011dmr753056ejc.12.1671616118637;
        Wed, 21 Dec 2022 01:48:38 -0800 (PST)
Received: from [10.39.192.150] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id z1-20020a1709063a0100b00780982d77d1sm6815795eje.154.2022.12.21.01.48.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Dec 2022 01:48:38 -0800 (PST)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     Aaron Conole <aconole@redhat.com>
Cc:     netdev@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, dev@openvswitch.org,
        Ilya Maximets <i.maximets@ovn.org>,
        wangchuanlei <wangchuanlei@inspur.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: openvswitch: release vport resources on failure
Date:   Wed, 21 Dec 2022 10:48:37 +0100
X-Mailer: MailMate (1.14r5933)
Message-ID: <DDDE110D-D874-4DB0-9A8B-D796897976F7@redhat.com>
In-Reply-To: <20221220212717.526780-1-aconole@redhat.com>
References: <20221220212717.526780-1-aconole@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20 Dec 2022, at 22:27, Aaron Conole wrote:

> A recent commit introducing upcall packet accounting failed to properly=

> release the vport object when the per-cpu stats struct couldn't be
> allocated.  This can cause dangling pointers to dp objects long after
> they've been released.
>
> Cc: Eelco Chaudron <echaudro@redhat.com>
> Cc: wangchuanlei <wangchuanlei@inspur.com>
> Fixes: 1933ea365aa7 ("net: openvswitch: Add support to count upcall pac=
kets")
> Reported-by: syzbot+8f4e2dcfcb3209ac35f9@syzkaller.appspotmail.com
> Signed-off-by: Aaron Conole <aconole@redhat.com>
> ---

Thanks for finding and fixing this! The changes look good to me.

Acked-by: Eelco Chaudron <echaudro@redhat.com>


>  net/openvswitch/datapath.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index 932bcf766d63..6774baf9e212 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -1854,7 +1854,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, st=
ruct genl_info *info)
>  	vport->upcall_stats =3D netdev_alloc_pcpu_stats(struct vport_upcall_s=
tats_percpu);
>  	if (!vport->upcall_stats) {
>  		err =3D -ENOMEM;
> -		goto err_destroy_portids;
> +		goto err_destroy_vport;
>  	}
>
>  	err =3D ovs_dp_cmd_fill_info(dp, reply, info->snd_portid,
> @@ -1869,6 +1869,8 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, st=
ruct genl_info *info)
>  	ovs_notify(&dp_datapath_genl_family, reply, info);
>  	return 0;
>
> +err_destroy_vport:
> +	ovs_dp_detach_port(vport);
>  err_destroy_portids:
>  	kfree(rcu_dereference_raw(dp->upcall_portids));
>  err_unlock_and_destroy_meters:
> @@ -2316,7 +2318,7 @@ static int ovs_vport_cmd_new(struct sk_buff *skb,=
 struct genl_info *info)
>  	vport->upcall_stats =3D netdev_alloc_pcpu_stats(struct vport_upcall_s=
tats_percpu);
>  	if (!vport->upcall_stats) {
>  		err =3D -ENOMEM;
> -		goto exit_unlock_free;
> +		goto exit_unlock_free_vport;
>  	}
>
>  	err =3D ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
> @@ -2336,6 +2338,8 @@ static int ovs_vport_cmd_new(struct sk_buff *skb,=
 struct genl_info *info)
>  	ovs_notify(&dp_vport_genl_family, reply, info);
>  	return 0;
>
> +exit_unlock_free_vport:
> +	ovs_dp_detach_port(vport);
>  exit_unlock_free:
>  	ovs_unlock();
>  	kfree_skb(reply);
> -- =

> 2.31.1

