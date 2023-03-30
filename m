Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 341C16D0119
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 12:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbjC3KXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 06:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbjC3KXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 06:23:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF7183DC
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 03:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680171788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=59FDE+8LM1RTgNxCSNxSrwpKtHARF1ER91IIjRZ5nx4=;
        b=c/Tfi6O+Q5UPXfRx7n428Eho3OILFOGFH4Jipf7jlUg9nyijGHjAesM44GUN45lkKypUZ0
        tmNP7VgAjtpkkC7TUmdbOefSkJjt0nPZRRWBmOcRhAeeG32zRp+QG12q2AsKbWjc72VXkx
        yOlkwoT6GnkcdK8H86zoJOC+7POqaew=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-6-DUSP2QJKP0mZGdRsZKyjJw-1; Thu, 30 Mar 2023 06:23:07 -0400
X-MC-Unique: DUSP2QJKP0mZGdRsZKyjJw-1
Received: by mail-qv1-f71.google.com with SMTP id pr2-20020a056214140200b005b3ed9328a3so7984456qvb.10
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 03:23:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680171786;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=59FDE+8LM1RTgNxCSNxSrwpKtHARF1ER91IIjRZ5nx4=;
        b=jr9yWs5XEA9ih30HrK6BHgoHmyeVPcB46WSF/RYGrYRiQYP8rqrGoOMS1NeYpK/KuU
         mikW2FaQyz7/6qZNXe/aRtKOdi7mNPE8far2cgN5fc+3W9kifAX4yenH4+dDHzOLMTKc
         1uJX8cpDpH2V/CmlxiWEJuM+M4bSWnm/Fgtm2gW89Esce9/tcFYtG6lR4y5buiSFD/Yc
         oJOL1HWEo6FkLmwnIRjmqRB0MfaODZsyixmPoa5CeSEaEtICwLJkeOiMmSnCQ00IrfOi
         5ggnKd49LU2XDSN1dcCNzpIE5YYt+QSrPPh6lz7V/vZnVL/LKDMUGKu84oPmJaaZkOrj
         doPw==
X-Gm-Message-State: AO0yUKWaosYvQONVAVSqCTO8iagIxczfG13lDu3ggBQa63IoD/BRosQ8
        zssDaSqi4vlxlGuXN+cwTv/PS9d2gmQHggSi72FkL4F0tahn9nSn1wGys6cIdm/SY6+i4bH+KwE
        DXXiMQZP4a8LhWeeV
X-Received: by 2002:a05:622a:14c7:b0:3ba:151a:d300 with SMTP id u7-20020a05622a14c700b003ba151ad300mr35694847qtx.60.1680171786535;
        Thu, 30 Mar 2023 03:23:06 -0700 (PDT)
X-Google-Smtp-Source: AK7set9hwJzPdjL3B3XEC/SRjMmxy4i5zJ3rFc0P7bDk8NNBjognN6HOVj4HrMl2WPZD3H6XIItrvA==
X-Received: by 2002:a05:622a:14c7:b0:3ba:151a:d300 with SMTP id u7-20020a05622a14c700b003ba151ad300mr35694825qtx.60.1680171786267;
        Thu, 30 Mar 2023 03:23:06 -0700 (PDT)
Received: from debian (2a01cb058918ce003af3a313a65b3409.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:3af3:a313:a65b:3409])
        by smtp.gmail.com with ESMTPSA id d140-20020a376892000000b007467a4d8691sm15500145qkc.47.2023.03.30.03.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 03:23:05 -0700 (PDT)
Date:   Thu, 30 Mar 2023 12:23:02 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Andrea Righi <andrea.righi@canonical.com>
Cc:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Wojciech Drewek <wojciech.drewek@intel.com>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] l2tp: generate correct module alias strings
Message-ID: <ZCVjBkdySj5BhMja@debian>
References: <20230330095442.363201-1-andrea.righi@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230330095442.363201-1-andrea.righi@canonical.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 11:54:42AM +0200, Andrea Righi wrote:
> Commit 65b32f801bfb ("uapi: move IPPROTO_L2TP to in.h") moved the
> definition of IPPROTO_L2TP from a define to an enum, but since
> __stringify doesn't work properly with enums, we ended up breaking the
> modalias strings for the l2tp modules:
> 
>  $ modinfo l2tp_ip l2tp_ip6 | grep alias
>  alias:          net-pf-2-proto-IPPROTO_L2TP
>  alias:          net-pf-2-proto-2-type-IPPROTO_L2TP
>  alias:          net-pf-10-proto-IPPROTO_L2TP
>  alias:          net-pf-10-proto-2-type-IPPROTO_L2TP
> 
> Use the resolved number directly in MODULE_ALIAS_*() macros (as we
> already do with SOCK_DGRAM) to fix the alias strings:
> 
> $ modinfo l2tp_ip l2tp_ip6 | grep alias
> alias:          net-pf-2-proto-115
> alias:          net-pf-2-proto-115-type-2
> alias:          net-pf-10-proto-115
> alias:          net-pf-10-proto-115-type-2
> 
> Moreover, fix the ordering of the parameters passed to
> MODULE_ALIAS_NET_PF_PROTO_TYPE() by switching proto and type.

Thanks!

Just to be explicit to the maintainers, this patch is for the net tree
(next time, you can use [PATCH net] to make that clear).

> Fixes: 65b32f801bfb ("uapi: move IPPROTO_L2TP to in.h")
> Link: https://lore.kernel.org/lkml/ZCQt7hmodtUaBlCP@righiandr-XPS-13-7390
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
> ---
>  net/l2tp/l2tp_ip.c  | 8 ++++----
>  net/l2tp/l2tp_ip6.c | 8 ++++----
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
> index 4db5a554bdbd..41a74fc84ca1 100644
> --- a/net/l2tp/l2tp_ip.c
> +++ b/net/l2tp/l2tp_ip.c
> @@ -677,8 +677,8 @@ MODULE_AUTHOR("James Chapman <jchapman@katalix.com>");
>  MODULE_DESCRIPTION("L2TP over IP");
>  MODULE_VERSION("1.0");
>  
> -/* Use the value of SOCK_DGRAM (2) directory, because __stringify doesn't like
> - * enums
> +/* Use the values of SOCK_DGRAM (2) as type and IPPROTO_L2TP (115) as protocol,
> + * because __stringify doesn't like enums
>   */
> -MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET, 2, IPPROTO_L2TP);
> -MODULE_ALIAS_NET_PF_PROTO(PF_INET, IPPROTO_L2TP);
> +MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET, 115, 2);
> +MODULE_ALIAS_NET_PF_PROTO(PF_INET, 115);
> diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
> index 2478aa60145f..5137ea1861ce 100644
> --- a/net/l2tp/l2tp_ip6.c
> +++ b/net/l2tp/l2tp_ip6.c
> @@ -806,8 +806,8 @@ MODULE_AUTHOR("Chris Elston <celston@katalix.com>");
>  MODULE_DESCRIPTION("L2TP IP encapsulation for IPv6");
>  MODULE_VERSION("1.0");
>  
> -/* Use the value of SOCK_DGRAM (2) directory, because __stringify doesn't like
> - * enums
> +/* Use the values of SOCK_DGRAM (2) as type and IPPROTO_L2TP (115) as protocol,
> + * because __stringify doesn't like enums
>   */
> -MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET6, 2, IPPROTO_L2TP);
> -MODULE_ALIAS_NET_PF_PROTO(PF_INET6, IPPROTO_L2TP);
> +MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET6, 115, 2);
> +MODULE_ALIAS_NET_PF_PROTO(PF_INET6, 115);
> -- 
> 2.39.2
> 

