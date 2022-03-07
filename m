Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D42234D0263
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 16:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbiCGPER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 10:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243688AbiCGPEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 10:04:11 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A8B1EC57
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 07:03:12 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id s25so20862656lji.5
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 07:03:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=/BTt8YfLqIyHV2xz5yac4//kRwc8vucWlkgPD1H5W5U=;
        b=geSKUfzqH0ywLbmlSI4UD7XWu1DZAlvfys+W7vVP+VziMkRy9OPLCGWNyAdIXt1Bk5
         h809Vnkn1UErlMBAksU9IxSwTd3AvnT4UYUsCk8Fbj3N7QPq2u4sVhQA/K7918afijZ/
         +nXawLyl8sKtpITj3idcFoayKBWNTF8YEL15U34F09L97BWaO82jpZjN3qn9i5EP/WcK
         YqYWxTW8LazUdo+MmCRa9MQupXERDJ2rNoYVtiqDZr8AJPrvVKVP838BI0qFTNRs0JMg
         L2C3s4WjE0o6b0WRiadxWMjVi1woqYDlUuZc2YWb8XtkniDw4Hj87xdrKekXMDgAW0uC
         W9aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=/BTt8YfLqIyHV2xz5yac4//kRwc8vucWlkgPD1H5W5U=;
        b=KSgTApqbiRmZ3UDMjFe7QiufLj5IBV3pjkDyDPokwymxbWo6Q0Qp0ubL6CwNKi7v3p
         gmqBZRkkUYqCf9qiV1EZmPhZOTIwIYjQ31jd61TGY0UIJhfyjgAEFwhGBQHqkaYAvM90
         4pnYjRrqJ/0GVGD8YGwpCf3ggm5yPa/AAKbRmRjNWITwUw7kkXbnUZ81IbIWtJvw7WPH
         /vZO4IYUAv5W5YAtgVpbtlpiL+dgCD4esNAg9qEob2Mn5eaVgOOirhQu51UDED7KmX9U
         B5KBg0itEZPFDWL2fXvFFCQihPk4xRrhA9emkPvkuS7YbKXhEY1HkvlxZE3jrs7SFawp
         C/vg==
X-Gm-Message-State: AOAM532t537mBU4Dgi9XUpHACbwZmwFxUNtfiBPvhlA5HgsZvwcgMG8Y
        bxBbb6C3Spmh7Tl2TKzFr91NDg==
X-Google-Smtp-Source: ABdhPJyRIzgTgkB5vzWWj4N/L5SwvNpTpRxtAde1STA6pj+0+6N4W5+mT6ohmIbc8yWzPAk4nV5rOA==
X-Received: by 2002:a2e:9909:0:b0:244:c10b:3df2 with SMTP id v9-20020a2e9909000000b00244c10b3df2mr7871072lji.288.1646665388327;
        Mon, 07 Mar 2022 07:03:08 -0800 (PST)
Received: from wkz-x280 (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id p1-20020a05651238c100b004435d1d47fasm2890905lft.102.2022.03.07.07.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 07:03:07 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH v2 net-next 03/10] net: bridge: mst: Support setting and
 reporting MST port states
In-Reply-To: <5d3acf32-9875-de6d-7495-5e4860fb88f1@nvidia.com>
References: <20220301100321.951175-1-tobias@waldekranz.com>
 <20220301100321.951175-4-tobias@waldekranz.com>
 <53EED92D-FEAC-4CC6-AF2A-52E73F839AB5@blackwall.org>
 <5d3acf32-9875-de6d-7495-5e4860fb88f1@nvidia.com>
Date:   Mon, 07 Mar 2022 16:03:07 +0100
Message-ID: <871qzdolec.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 17:53, Roopa Prabhu <roopa@nvidia.com> wrote:
> On 3/1/22 15:19, Nikolay Aleksandrov wrote:
>> On 1 March 2022 11:03:14 CET, Tobias Waldekranz <tobias@waldekranz.com> wrote:
>>> Make it possible to change the port state in a given MSTI. This is
>>> done through a new netlink interface, since the MSTIs are objects in
>>> their own right. The proposed iproute2 interface would be:
>>>
>>>     bridge mst set dev <PORT> msti <MSTI> state <STATE>
>>>
>>> Current states in all applicable MSTIs can also be dumped. The
>>> proposed iproute interface looks like this:
>>>
>>> $ bridge mst
>>> port              msti
>>> vb1               0
>>> 		    state forwarding
>>> 		  100
>>> 		    state disabled
>>> vb2               0
>>> 		    state forwarding
>>> 		  100
>>> 		    state forwarding
>>>
>>> The preexisting per-VLAN states are still valid in the MST
>>> mode (although they are read-only), and can be queried as usual if one
>>> is interested in knowing a particular VLAN's state without having to
>>> care about the VID to MSTI mapping (in this example VLAN 20 and 30 are
>>> bound to MSTI 100):
>>>
>>> $ bridge -d vlan
>>> port              vlan-id
>>> vb1               10
>>> 		    state forwarding mcast_router 1
>>> 		  20
>>> 		    state disabled mcast_router 1
>>> 		  30
>>> 		    state disabled mcast_router 1
>>> 		  40
>>> 		    state forwarding mcast_router 1
>>> vb2               10
>>> 		    state forwarding mcast_router 1
>>> 		  20
>>> 		    state forwarding mcast_router 1
>>> 		  30
>>> 		    state forwarding mcast_router 1
>>> 		  40
>>> 		    state forwarding mcast_router 1
>>>
>>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>>> ---
>>> include/uapi/linux/if_bridge.h |  16 +++
>>> include/uapi/linux/rtnetlink.h |   5 +
>>> net/bridge/br_mst.c            | 244 +++++++++++++++++++++++++++++++++
>>> net/bridge/br_netlink.c        |   3 +
>>> net/bridge/br_private.h        |   4 +
>>> 5 files changed, 272 insertions(+)
>>>
>>> diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
>>> index b68016f625b7..784482527861 100644
>>> --- a/include/uapi/linux/if_bridge.h
>>> +++ b/include/uapi/linux/if_bridge.h
>>> @@ -785,4 +785,20 @@ enum {
>>> 	__BRIDGE_QUERIER_MAX
>>> };
>>> #define BRIDGE_QUERIER_MAX (__BRIDGE_QUERIER_MAX - 1)
>>> +
>>> +enum {
>>> +	BRIDGE_MST_UNSPEC,
>>> +	BRIDGE_MST_ENTRY,
>>> +	__BRIDGE_MST_MAX,
>>> +};
>>> +#define BRIDGE_MST_MAX (__BRIDGE_MST_MAX - 1)
>>> +
>>> +enum {
>>> +	BRIDGE_MST_ENTRY_UNSPEC,
>>> +	BRIDGE_MST_ENTRY_MSTI,
>>> +	BRIDGE_MST_ENTRY_STATE,
>>> +	__BRIDGE_MST_ENTRY_MAX,
>>> +};
>>> +#define BRIDGE_MST_ENTRY_MAX (__BRIDGE_MST_ENTRY_MAX - 1)
>>> +
>>> #endif /* _UAPI_LINUX_IF_BRIDGE_H */
>>> diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
>>> index 0970cb4b1b88..4a48f3ce862c 100644
>>> --- a/include/uapi/linux/rtnetlink.h
>>> +++ b/include/uapi/linux/rtnetlink.h
>>> @@ -192,6 +192,11 @@ enum {
>>> 	RTM_GETTUNNEL,
>>> #define RTM_GETTUNNEL	RTM_GETTUNNEL
>>>
>>> +	RTM_GETMST = 124 + 2,
>>> +#define RTM_GETMST	RTM_GETMST
>>> +	RTM_SETMST,
>>> +#define RTM_SETMST	RTM_SETMST
>>> +
>> I think you should also update selinux  (see nlmsgtab.c)
>> I'll think about this one, if there is some nice way to avoid the new rtm types.
>
> yes, since these are all port attributes, seems like 'bridge link set' 
> should work
>
> Tobias, can you pls check if extending RTM_SETLINK (with AF_BRIDGE) is 
> an option here ?
>
> ie via br_setlink

Yeah that makes sense. Not sure how I convinced myself that I needed a
separate rtm type for it. I will give it a try. Thanks!
