Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73049647EC8
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 08:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiLIHw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 02:52:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLIHw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 02:52:28 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F3A4FF9D
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 23:52:27 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id o15so2610498wmr.4
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 23:52:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YQ4b+q/xAzhxcWk+HTn7pTbcjlOt6DHs6L/eJIRo8Q8=;
        b=pu+MvrrIHTIpdKlGXc7Y8wpmxWZCc2c/of308f6qDqoYe8LDc2TlOQskHdzymywFJ5
         oJ2FHsYAHH6CiiH0NtT7AaGqQSAnYZW5SMC2vEY0arM4Bosn+I8hSRu4Awzd2fRrpx0h
         Z37H8EvBF7l431wVPIujQngZ1Sgf2goTC4BzlA+t9vcL/Bog8IaMQAIsCxGirUAjEhvk
         ohMFWYEvpRdxVsYq+BDF1kZtvxwkGbcISJoTl92UA2QMnr6ePOOBi7pPZsugPy8eTasP
         BW/qjjsOLv3IFB45D3Z49PaH07lijie0fElo2BqSEQ92T20pgxJ5nK2hQpVkNOKMP0qI
         s5+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YQ4b+q/xAzhxcWk+HTn7pTbcjlOt6DHs6L/eJIRo8Q8=;
        b=F+rnUYQoOv1lyLMw/U1WjlWaF2wLD0L2bHlYfJ3rGuEEnokVzyIHvPyFHl1kXFmamQ
         6ZxbExk9j6Jd+VT1OrMjqPwv2B741+aINUWR3MnWjdwZnZ5B3i5+8ghrFcukuTP1d/yY
         F+erHg8b1Ypm05bNSp8ZNLYYZ/JLCjgrRvM7XgraQ6lTsGyKpTw21Tbrv4UQ0qoTKx0m
         MPt0lkBUW4ky0rkmDBNq20Vp1mxw8Ap9QlhG30Rw4pZ3rxO6dhpJsvcZ2ytDUPJ8rPTS
         ZrpDH7SLT0uXW80KJ+WGWCrGDtetgueDYxH2a9vtrtutWl1A8p2TXKqOuQ8OTUl3UDH8
         tb6Q==
X-Gm-Message-State: ANoB5plsSCm+65tKsfiVUyt11Bd7l9J2CenNLen7Eb1+Vk5icm9mw93h
        LC6bi90ocE+bX0XM8zVbpGoRLg==
X-Google-Smtp-Source: AA0mqf5KRJd9O3z4wvu1gvbbgEqDZYjmIF65M+fMTtO4qqe+Tiu8dWPPKEHq0OyzjMUX+vkG5qFEnw==
X-Received: by 2002:a05:600c:3b19:b0:3cf:5584:e714 with SMTP id m25-20020a05600c3b1900b003cf5584e714mr4023649wms.25.1670572345963;
        Thu, 08 Dec 2022 23:52:25 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id o30-20020a05600c511e00b003a3442f1229sm8287969wms.29.2022.12.08.23.52.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Dec 2022 23:52:25 -0800 (PST)
Message-ID: <ed2bb9b0-d3bd-604d-ef7d-ddd145ffd13b@blackwall.org>
Date:   Fri, 9 Dec 2022 09:52:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 10/14] bridge: mcast: Allow user space to add (*,
 G) with a source list and filter mode
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, mlxsw@nvidia.com
References: <20221208152839.1016350-1-idosch@nvidia.com>
 <20221208152839.1016350-11-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221208152839.1016350-11-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/12/2022 17:28, Ido Schimmel wrote:
> Add new netlink attributes to the RTM_NEWMDB request that allow user
> space to add (*, G) with a source list and filter mode.
> 
> The RTM_NEWMDB message can already dump such entries (created by the
> kernel) so there is no need to add dump support. However, the message
> contains a different set of attributes depending if it is a request or a
> response. The naming and structure of the new attributes try to follow
> the existing ones used in the response.
> 
> Request:
> 
> [ struct nlmsghdr ]
> [ struct br_port_msg ]
> [ MDBA_SET_ENTRY ]
> 	struct br_mdb_entry
> [ MDBA_SET_ENTRY_ATTRS ]
> 	[ MDBE_ATTR_SOURCE ]
> 		struct in_addr / struct in6_addr
> 	[ MDBE_ATTR_SRC_LIST ]		// new
> 		[ MDBE_SRC_LIST_ENTRY ]
> 			[ MDBE_SRCATTR_ADDRESS ]
> 				struct in_addr / struct in6_addr
> 		[ ...]
> 	[ MDBE_ATTR_GROUP_MODE ]	// new
> 		u8
> 
> Response:
> 
> [ struct nlmsghdr ]
> [ struct br_port_msg ]
> [ MDBA_MDB ]
> 	[ MDBA_MDB_ENTRY ]
> 		[ MDBA_MDB_ENTRY_INFO ]
> 			struct br_mdb_entry
> 		[ MDBA_MDB_EATTR_TIMER ]
> 			u32
> 		[ MDBA_MDB_EATTR_SOURCE ]
> 			struct in_addr / struct in6_addr
> 		[ MDBA_MDB_EATTR_RTPROT ]
> 			u8
> 		[ MDBA_MDB_EATTR_SRC_LIST ]
> 			[ MDBA_MDB_SRCLIST_ENTRY ]
> 				[ MDBA_MDB_SRCATTR_ADDRESS ]
> 					struct in_addr / struct in6_addr
> 				[ MDBA_MDB_SRCATTR_TIMER ]
> 					u8
> 			[...]
> 		[ MDBA_MDB_EATTR_GROUP_MODE ]
> 			u8
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
> 
> Notes:
>     v1:
>     * Use an array instead of list to store source entries.
>     * Drop br_mdb_config_attrs_fini().
> 
>  include/uapi/linux/if_bridge.h |  20 +++++
>  net/bridge/br_mdb.c            | 130 +++++++++++++++++++++++++++++++++
>  2 files changed, 150 insertions(+)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

