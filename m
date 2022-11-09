Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF4C6221E9
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 03:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbiKICXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 21:23:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiKICXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 21:23:41 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70733CE09
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 18:23:40 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id k15so15440529pfg.2
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 18:23:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k1hlIcLvDM2TvXNx8JutOJSIG2DccN9Gi8iiaJskLDI=;
        b=qFagyHVKD69vbY5Du6qxJkiffT5G3B2uxzNhSrowZvGZA1QkfUYt8ZPeggOUvjXxQY
         aQJsMAe+gCcJPu38WkvcFXHm4h4Z8o9dC/DmAMluC8UPzNw/UMnalVFWEMCjCW0tY030
         yVLyaiUAFSZNNOmmxWNsgP9xwXZIBoxjHrkgK/CcrREjft1ghc5hNXXk3eNgY3qNLcLe
         BU/WblPvRICDvSNI4SDDVU9JyWZnnfbLcVHMH7GdOU84p4ooEr7XCR0yRngofUdtYGAc
         VGLDMhoxj0hAwJ4jdgZnknF3/4eALH7Ux1OvW6pEdP2IETtesqMh0lq3XDIRYx3vCtrt
         QcSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k1hlIcLvDM2TvXNx8JutOJSIG2DccN9Gi8iiaJskLDI=;
        b=szRJ6cqrCC4OCs6aJrGOU4CuI2ZajKgRcVIYrFwful8KQTBfPtrIvV9BTm4daZFXIe
         Pn68XfxMO2skKgEk7dbpf3pkNAqv19GTLAb4018E2lBAXmVJm4FvSNBbjJT7calQQy2E
         0Y07AhI4HQa+5a4qxcCiStcEo+uqz6gbgIqYPbXiPb6cQUQQZM/JgGI2ZJsFJZShZjfF
         gnsdGxyma+3HIEArRUEY4mcmiGDwkOJBwGZvsOQUSCRrUFIhiQli9ho8C0NeEGoFUdGe
         Gz9VF6ntOhZ0Nln6vEh6VoYtWL7S5//AkmnVwA7grQ9Rx5GyphyFbWvK9GltEoOtNU4K
         E/Hg==
X-Gm-Message-State: ACrzQf0sXlSlsUuEhprwUPDsGubfgPcPv6GfBEHmbAUp0yrJnDtd+Nde
        7G+6Ta2m9d7s56cSkK8kzQc=
X-Google-Smtp-Source: AMsMyM7BRqJgUMki7OMyN2NJX1WHYdEBO4Ox15/wpS/yJS8WCfgDvPurvqrTr/Z6I7PZHxB05+ToYw==
X-Received: by 2002:a62:ea0d:0:b0:55f:8624:4d8b with SMTP id t13-20020a62ea0d000000b0055f86244d8bmr58745599pfh.74.1667960619894;
        Tue, 08 Nov 2022 18:23:39 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k12-20020a6555cc000000b0043c22e926f8sm6467084pgs.84.2022.11.08.18.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 18:23:38 -0800 (PST)
Date:   Wed, 9 Nov 2022 10:23:31 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jay Vosburgh <j.vosburgh@gmail.com>
Cc:     netdev@vger.kernel.org, oe-kbuild-all@lists.linux.dev,
        kernel test robot <lkp@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>, Liang Li <liali@redhat.com>
Subject: Re: [PATCHv2 net] bonding: fix ICMPv6 header handling when receiving
 IPv6 messages
Message-ID: <Y2sPI+E8RgaM2ND5@Laptop-X1>
References: <20221108070035.177036-1-liuhangbin@gmail.com>
 <202211082322.B7ILgv9S-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202211082322.B7ILgv9S-lkp@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 12:06:32AM +0800, kernel test robot wrote:
> All warnings (new ones prefixed by >>):
> 
>    drivers/net/bonding/bond_main.c: In function 'bond_na_rcv':
> >> drivers/net/bonding/bond_main.c:3242:77: warning: passing argument 4 of 'skb_header_pointer' discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
>     3242 |         hdr = skb_header_pointer(skb, sizeof(struct ipv6hdr), sizeof(_hdr), &_hdr);
>          |                                                                             ^~~~~

Oh...When I post patches, I always rebuild the whole kernel. Maybe I missed
this warning as the build info passed to fast. I will only build the module
like the bot did in future...

I have post a new version to fix this.

>                     from drivers/net/bonding/bond_main.c:35:
>    In function 'fortify_memcpy_chk',
>        inlined from 'iph_to_flow_copy_v4addrs' at include/net/ip.h:566:2,
>        inlined from 'bond_flow_ip' at drivers/net/bonding/bond_main.c:3983:3:
>    include/linux/fortify-string.h:413:25: warning: call to '__read_overflow2_field' declared with attribute warning: detected read beyond size of field (2nd parameter); maybe use struct_group()? [-Wattribute-warning]
>      413 |                         __read_overflow2_field(q_size_field, size);
>          |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    In function 'fortify_memcpy_chk',
>        inlined from 'iph_to_flow_copy_v6addrs' at include/net/ipv6.h:900:2,
>        inlined from 'bond_flow_ip' at drivers/net/bonding/bond_main.c:3993:3:
>    include/linux/fortify-string.h:413:25: warning: call to '__read_overflow2_field' declared with attribute warning: detected read beyond size of field (2nd parameter); maybe use struct_group()? [-Wattribute-warning]
>      413 |                         __read_overflow2_field(q_size_field, size);
>          |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

I will post another patch to fix this warning.

Thanks
Hangbin
