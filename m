Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87C2E5BE243
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 11:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbiITJnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 05:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiITJnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 05:43:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FD643E78
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 02:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663667022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KxJc4EwdNPOPw/+t4sVZ14DqF5XTa5bzeTRnaZ5IV5A=;
        b=EzXStHi1GpyhSpfCUOaLZLOJcLDBe4mYUajrn8sMpM81NuEiEBEom0rNM4i1UgCsxndr75
        sYJY7fm60yud6u6GwAZQ9sRQJuf6kvEkqFKw+xaWMQpszlzR0bv9v7qcstPueR+cPj33NB
        LO4iB7EQyzbPxdIo74I7rdIpm6vBN3A=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-497-6SD14g6sMS-HMShqynwzhA-1; Tue, 20 Sep 2022 05:43:38 -0400
X-MC-Unique: 6SD14g6sMS-HMShqynwzhA-1
Received: by mail-qk1-f200.google.com with SMTP id u6-20020a05620a430600b006ce769b7150so1503535qko.0
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 02:43:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=KxJc4EwdNPOPw/+t4sVZ14DqF5XTa5bzeTRnaZ5IV5A=;
        b=NT3oPCSahH6bbbHsNnAVkA2Ie54adDehzRtmIQiqTWBjicVcDjTXlczff7rkX2JP48
         9kDH03X6qzN/vOHXhj1gR6BhnTNspRcYnGZjlu7mWU7xV7YTg7vPACvkEIsdiQZNQ3NS
         dfjS2bIydqM8ogKIfu0oNiB2+QOCCTnQRE95rvcaUXbncvDxNpo2YnmOnZThQxmzgmZl
         cT+VvNRLBdYxXChmsCaudaEyIEcpnub6DXFVyBmniZEWjiz2KN2ysqbZCjkXKWH1ru5O
         E+Yt7QwMXaxPyw1vlXHBXYyZG1KTiLxYQF/XATbsaWy+6FaVpAOdhPQL+C86wbahBJKq
         WhkQ==
X-Gm-Message-State: ACrzQf0Mm257ghJyROj2tcSaBb8KHiXpsC7Pjbj64BB6cbif5AL4/2gH
        EJR/3/nIhjvim+8gr01jn4mqImXgyed1yS3/gJ0UaH8EA1M24aNA7rhwwRfpDj+AsAa65esXFo2
        q0+6bkKC5cTyzbvjJ
X-Received: by 2002:ad4:5c6f:0:b0:4aa:a393:fe85 with SMTP id i15-20020ad45c6f000000b004aaa393fe85mr18124727qvh.124.1663667017768;
        Tue, 20 Sep 2022 02:43:37 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4EHobH+Cg0wFbiwpGjrOYGZH8L9AGUDFxY5LfTZXhip0iniWZeT8JNoZ5YwoD/7aFHxPicoQ==
X-Received: by 2002:ad4:5c6f:0:b0:4aa:a393:fe85 with SMTP id i15-20020ad45c6f000000b004aaa393fe85mr18124721qvh.124.1663667017552;
        Tue, 20 Sep 2022 02:43:37 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-114-90.dyn.eolo.it. [146.241.114.90])
        by smtp.gmail.com with ESMTPSA id f9-20020ac840c9000000b0035a7070e909sm617157qtm.38.2022.09.20.02.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 02:43:37 -0700 (PDT)
Message-ID: <4697415ff25b60b83a649c6b832d9694c2cba807.camel@redhat.com>
Subject: Re: [PATCH 1/2] net: openvswitch: allow metering in non-initial
 user namespace
From:   Paolo Abeni <pabeni@redhat.com>
To:     Michael =?ISO-8859-1?Q?Wei=DF?= 
        <michael.weiss@aisec.fraunhofer.de>
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Date:   Tue, 20 Sep 2022 11:43:33 +0200
In-Reply-To: <20220911173825.167352-2-michael.weiss@aisec.fraunhofer.de>
References: <20220911173825.167352-1-michael.weiss@aisec.fraunhofer.de>
         <20220911173825.167352-2-michael.weiss@aisec.fraunhofer.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2022-09-11 at 19:38 +0200, Michael Weiß wrote:
> The Netlink interface for metering was restricted to global CAP_NET_ADMIN
> by using GENL_ADMIN_PERM. To allow metring in a non-inital user namespace,
> e.g., a container, this is changed to GENL_UNS_ADMIN_PERM.
> 
> Signed-off-by: Michael Weiß <michael.weiss@aisec.fraunhofer.de>
> ---
>  net/openvswitch/meter.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
> index 04a060ac7fdf..e9ef050a0dd5 100644
> --- a/net/openvswitch/meter.c
> +++ b/net/openvswitch/meter.c
> @@ -687,9 +687,9 @@ static const struct genl_small_ops dp_meter_genl_ops[] = {
>  	},
>  	{ .cmd = OVS_METER_CMD_SET,
>  		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> -		.flags = GENL_ADMIN_PERM, /* Requires CAP_NET_ADMIN
> -					   *  privilege.
> -					   */
> +		.flags = GENL_UNS_ADMIN_PERM, /* Requires CAP_NET_ADMIN
> +					       *  privilege.
> +					       */
>  		.doit = ovs_meter_cmd_set,
>  	},
>  	{ .cmd = OVS_METER_CMD_GET,
> @@ -699,9 +699,9 @@ static const struct genl_small_ops dp_meter_genl_ops[] = {
>  	},
>  	{ .cmd = OVS_METER_CMD_DEL,
>  		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> -		.flags = GENL_ADMIN_PERM, /* Requires CAP_NET_ADMIN
> -					   *  privilege.
> -					   */
> +		.flags = GENL_UNS_ADMIN_PERM, /* Requires CAP_NET_ADMIN
> +					       *  privilege.
> +					       */
>  		.doit = ovs_meter_cmd_del
>  	},
>  };

It looks like the user namespace can allocate quite a bit of memory
with multiple meters, I think it's better additionally change
GFP_KERNEL to GFP_KERNEL_ACCOUNT in dp_meter_create().

Also plese add an explicit target tree in the subj when posting the
next revision, thanks!

Paolo

