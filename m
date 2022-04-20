Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510FF508B1D
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 16:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354361AbiDTOvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 10:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345886AbiDTOvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 10:51:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18E4563B1
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 07:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650466101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PE2veXFIyHr4RgGTroiCovsOoy3LOp3buhENrBma1Kk=;
        b=YN6vDkzsnqnqrPQkbViU05CXeTcRQ1+iYYgo+jCLhds3mmUyMzmX1lvZVRrSp68uReUWec
        rQESlGJtYMCvTxVyQ20dcZAK4t9oXMXl1CnX0XeSLRxSHuuHWB1oYRAS9TzhAUhbrpqfDN
        0N+dqkFd7ZXQk0Hr5ppbOgRb0O9bdGA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-DwBYlmARP5ChsuAjxkG4Ig-1; Wed, 20 Apr 2022 10:48:19 -0400
X-MC-Unique: DwBYlmARP5ChsuAjxkG4Ig-1
Received: by mail-wr1-f72.google.com with SMTP id t15-20020adfdc0f000000b001ef93643476so467676wri.2
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 07:48:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PE2veXFIyHr4RgGTroiCovsOoy3LOp3buhENrBma1Kk=;
        b=c3FSh8FfO1ZiPyQWrFjHTTvmuCf6KvkRAXpI9/uwPW80a7wBjsn4JVK9WHb5tadxvF
         g/7uFxWSncYkz3e3x8zbFhA0JPeH2CSmP9Db8gzzcTd9T8HqPd622M78zRJyXZZ67XAF
         0bcBNr/yrCuCsJeKnT1C5fVLhokmj1IqAGbiyL5Mzx/MA6rHb/WLG0/kz9KFWoF8282Q
         zzkEia/S4R4DJQvyuPGmSBNDa3W5JRSyKJOybvMAZwOPZE9LU+NVuMZADSprcIAngVqj
         UbVH3hbyXUASmN3VW73ahSfA5GjfUmXqG6CoQCXEgcHIvAFRf/qnz0zDWe9qkXNpxFz7
         2I+A==
X-Gm-Message-State: AOAM532k21kB8NhNd+M5b/18K+QxDkgGloaNBceXudjgw02u5x5heon6
        YPFBtpIQLKDM3dCZPuaJAPkgorIBboqiMMU+Tdbyzn4ciMxBVdJRYMtQSDcbpwW3nSpTN9wau74
        9K8HLXUtdDIg1e9SJ
X-Received: by 2002:a1c:f219:0:b0:38c:782c:3bb with SMTP id s25-20020a1cf219000000b0038c782c03bbmr4036367wmc.94.1650466098780;
        Wed, 20 Apr 2022 07:48:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzaJIEe+XTDOjdmYgoixzeMA70lMLZ4MNxbixo0261S9MXwErymibmS6RBumvd097DEbHmTIg==
X-Received: by 2002:a1c:f219:0:b0:38c:782c:3bb with SMTP id s25-20020a1cf219000000b0038c782c03bbmr4036347wmc.94.1650466098614;
        Wed, 20 Apr 2022 07:48:18 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id 9-20020a056000154900b0020a849e1c41sm108598wry.13.2022.04.20.07.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 07:48:17 -0700 (PDT)
Date:   Wed, 20 Apr 2022 16:48:15 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Florent Fourcot <florent.fourcot@wifirst.fr>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Brian Baboch <brian.baboch@wifirst.fr>
Subject: Re: [PATCH net-next] Revert "rtnetlink: return EINVAL when request
 cannot succeed"
Message-ID: <20220420144815.GA3382@pc-4.home>
References: <Yl6iFqPFrdvD1wam@zx2c4.com>
 <20220419125151.15589-1-florent.fourcot@wifirst.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419125151.15589-1-florent.fourcot@wifirst.fr>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 02:51:51PM +0200, Florent Fourcot wrote:
> This reverts commit b6177d3240a4
> 
> ip-link command is testing kernel capability by sending a RTM_NEWLINK
> request, without any argument. It accepts everything in reply, except
> EOPNOTSUPP and EINVAL (functions iplink_have_newlink / accept_msg)
> 
> So we must keep compatiblity here, invalid empty message should not
> return EINVAL

"ip link" is currently unusable on net-next without this patch.
Can we please rush this fix in?

Tested-by: Guillaume Nault <gnault@redhat.com>
Fixes: b6177d3240a4 ("rtnetlink: return EINVAL when request cannot succeed")

> Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
> ---
>  net/core/rtnetlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index b943336908a7..73f2cbc440c9 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -3457,7 +3457,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
>  			return rtnl_group_changelink(skb, net,
>  						nla_get_u32(tb[IFLA_GROUP]),
>  						ifm, extack, tb);
> -		return -EINVAL;
> +		return -ENODEV;
>  	}
>  
>  	if (tb[IFLA_MAP] || tb[IFLA_PROTINFO])
> -- 
> 2.30.2
> 

