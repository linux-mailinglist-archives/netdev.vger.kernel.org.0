Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67CC550DF67
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 13:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235418AbiDYLye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 07:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237570AbiDYLyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 07:54:32 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08D418394;
        Mon, 25 Apr 2022 04:51:27 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id m22-20020a05600c3b1600b00393ed50777aso1076759wms.3;
        Mon, 25 Apr 2022 04:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XJ/pT2oK5aPhAnt0SgjUeAgczn2W9M5zxLcGF72B8Ow=;
        b=AaD9gBLpNwX1CRS6/prSSPX49MGWFfgb99EjowEbZifKSe8SWwM980/4rv1GG6S8B+
         iaqDHPvKkaog9RnNZ73XefpATRi8Rp7BKEa7TS9UHk42JHLb5b9zm4Hi00odh3Ms4w1z
         11OTmGD5pfyKegox7AxNLZMzrxxWLm0714etCyBefPkMajNRI8IguwWgPxwX72BnTWrv
         duISK2k/mjpsCBklhJ5AkucGEkyWr0cVpEgFcg6VFzHKawb3MzYTcTNTIUrAPhOAGMve
         WCupknfzQjWHgktNWPm8gdEYEFP+5pOhYMxBGUlBzVTo/g+0hgFYwoKg5RBI3M7bGkSe
         QPOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XJ/pT2oK5aPhAnt0SgjUeAgczn2W9M5zxLcGF72B8Ow=;
        b=cqZZDX8qJOurPxaPOHUwTZ4Y832/0fiVZA8ZvGv3f2XFqLPfX8FD4fl3gioaGxBULu
         SXqP8GODGJoxAJlFVhHC/b3h/vZXIoLXSu8hobA1rKS3GgCGiXdgtI5CqJv1RZcZ76F5
         R3sgpMphCTIdiAYozof2p8saa1D+6h7M6Frvmt9SEU4ZWJonQMru6SQCDDgWgigSbodi
         yDF7ddw+FrxbVST9bO6fNj3xxPMGUZwPD6v269y/wVrOh1yKYxmO/6qo//uauiKx29qF
         Wx8CMCaZ1wZ5fb7YRPFAkWzurenzi9ffWnvWyULsxU5yQp5lXFbXFUVP4ST3mBJPcppF
         W03g==
X-Gm-Message-State: AOAM5339tSSCz+09wcw4UyvMs436XnRWGVgVkUviRK8HLlOx8ZuWSOq3
        hARI5RZj6/eEMgdrfFN82m4=
X-Google-Smtp-Source: ABdhPJzSevCSk4/IoLJw5MxkXl/zsUxFqNe/72jNMB4pW+h27l4BKkgPAH9YHi2yfaSRyw4p6QEnvQ==
X-Received: by 2002:a1c:f604:0:b0:38c:8ffd:dbb6 with SMTP id w4-20020a1cf604000000b0038c8ffddbb6mr25572557wmc.43.1650887486373;
        Mon, 25 Apr 2022 04:51:26 -0700 (PDT)
Received: from [192.168.1.5] ([41.42.183.233])
        by smtp.gmail.com with ESMTPSA id f11-20020a7bcc0b000000b0037e0c362b6dsm8645348wmh.31.2022.04.25.04.51.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Apr 2022 04:51:25 -0700 (PDT)
Message-ID: <78823e29-02b2-e052-e8bb-12bbe692db6a@gmail.com>
Date:   Mon, 25 Apr 2022 13:51:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v3 1/2] rtnetlink: add extack support in fdb del
 handlers
Content-Language: en-US
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org,
        outreachy@lists.linux.dev, roopa@nvidia.com, jdenham@redhat.com,
        sbrivio@redhat.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, shshaikh@marvell.com,
        manishc@marvell.com, intel-wired-lan@lists.osuosl.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        GR-Linux-NIC-Dev@marvell.com, bridge@lists.linux-foundation.org
References: <cover.1650800975.git.eng.alaamohamedsoliman.am@gmail.com>
 <c3a882e4fb6f9228f704ebe3c1fcace14ee6cdf2.1650800975.git.eng.alaamohamedsoliman.am@gmail.com>
 <7c8367b6-95c7-ea39-fafe-72495f343625@blackwall.org>
 <d89eefc2-664f-8537-d10e-6fdfbb6823ed@gmail.com>
 <4bf69eef-7444-1238-0f4a-fb0fccda080c@blackwall.org>
 <3bcb2d3d-8b8b-8a8f-1285-7277394b4e6b@gmail.com>
 <alpine.DEB.2.22.394.2204250808280.2759@hadrien>
From:   Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
In-Reply-To: <alpine.DEB.2.22.394.2204250808280.2759@hadrien>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On ٢٥‏/٤‏/٢٠٢٢ ٠٨:١١, Julia Lawall wrote:
>
> On Sun, 24 Apr 2022, Alaa Mohamed wrote:
>
>> On ٢٤/٤/٢٠٢٢ ٢١:٥٥, Nikolay Aleksandrov wrote:
>>> On 24/04/2022 22:49, Alaa Mohamed wrote:
>>>> On ٢٤/٤/٢٠٢٢ ٢١:٠٢, Nikolay Aleksandrov wrote:
>>>>> On 24/04/2022 15:09, Alaa Mohamed wrote:
>>>>>> Add extack support to .ndo_fdb_del in netdevice.h and
>>>>>> all related methods.
>>>>>>
>>>>>> Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
>>>>>> ---
>>>>>> changes in V3:
>>>>>>            fix errors reported by checkpatch.pl
>>>>>> ---
>>>>>>     drivers/net/ethernet/intel/ice/ice_main.c        | 4 ++--
>>>>>>     drivers/net/ethernet/mscc/ocelot_net.c           | 4 ++--
>>>>>>     drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c | 2 +-
>>>>>>     drivers/net/macvlan.c                            | 2 +-
>>>>>>     drivers/net/vxlan/vxlan_core.c                   | 2 +-
>>>>>>     include/linux/netdevice.h                        | 2 +-
>>>>>>     net/bridge/br_fdb.c                              | 2 +-
>>>>>>     net/bridge/br_private.h                          | 2 +-
>>>>>>     net/core/rtnetlink.c                             | 4 ++--
>>>>>>     9 files changed, 12 insertions(+), 12 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c
>>>>>> b/drivers/net/ethernet/intel/ice/ice_main.c
>>>>>> index d768925785ca..7b55d8d94803 100644
>>>>>> --- a/drivers/net/ethernet/intel/ice/ice_main.c
>>>>>> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
>>>>>> @@ -5678,10 +5678,10 @@ ice_fdb_add(struct ndmsg *ndm, struct nlattr
>>>>>> __always_unused *tb[],
>>>>>>     static int
>>>>>>     ice_fdb_del(struct ndmsg *ndm, __always_unused struct nlattr *tb[],
>>>>>>             struct net_device *dev, const unsigned char *addr,
>>>>>> -        __always_unused u16 vid)
>>>>>> +        __always_unused u16 vid, struct netlink_ext_ack *extack)
>>>>>>     {
>>>>>>         int err;
>>>>>> -
>>>>>> +
>>>>> What's changed here?
>>>> In the previous version, I removed the blank line after "int err;" and you
>>>> said I shouldn't so I added blank line.
>>>>
>>> Yeah, my question is are you fixing a dos ending or something else?
>>> The blank line is already there, what's wrong with it?
>> No, I didn't.
> OK, so what is the answer to the question about what changed?  It looks
> like you remove a blank line and then add it back.  But that should not
> show up as a difference when you generate the patch.
>
> When you answer a comment, please put a blank line before and after your
> answer.  Otherwise it can be hard to see your answer when it is in the
> middle of a larger patch.
>
>>> The point is it's not nice to mix style fixes and other changes, more so
>>> if nothing is mentioned in the commit message.
>> Got it, So, what should I do to fix it?
> A series?  But it is not clear that any change is needed here at all.
>
> julia

I understood but I mean how to create the patch without this but I will 
google it , Thanks Julia.


>
>>>>>>         if (ndm->ndm_state & NUD_PERMANENT) {
>>>>>>             netdev_err(dev, "FDB only supports static addresses\n");
>>>>>>             return -EINVAL;
>>>>>> diff --git a/drivers/net/ethernet/mscc/ocelot_net.c
>>>>>> b/drivers/net/ethernet/mscc/ocelot_net.c
>>>>>> index 247bc105bdd2..e07c64e3159c 100644
>>>>>> --- a/drivers/net/ethernet/mscc/ocelot_net.c
>>>>>> +++ b/drivers/net/ethernet/mscc/ocelot_net.c
>>>>>> @@ -774,14 +774,14 @@ static int ocelot_port_fdb_add(struct ndmsg
>>>>>> *ndm, struct nlattr *tb[],
>>>>>>
>>>>>>     static int ocelot_port_fdb_del(struct ndmsg *ndm, struct nlattr
>>>>>> *tb[],
>>>>>>                        struct net_device *dev,
>>>>>> -                   const unsigned char *addr, u16 vid)
>>>>>> +                   const unsigned char *addr, u16 vid, struct
>>>>>> netlink_ext_ack *extack)
>>>>>>     {
>>>>>>         struct ocelot_port_private *priv = netdev_priv(dev);
>>>>>>         struct ocelot_port *ocelot_port = &priv->port;
>>>>>>         struct ocelot *ocelot = ocelot_port->ocelot;
>>>>>>         int port = priv->chip_port;
>>>>>>
>>>>>> -    return ocelot_fdb_del(ocelot, port, addr, vid,
>>>>>> ocelot_port->bridge);
>>>>>> +    return ocelot_fdb_del(ocelot, port, addr, vid,
>>>>>> ocelot_port->bridge, extack);
>>>>>>     }
>>>>>>
>>>>>>     static int ocelot_port_fdb_dump(struct sk_buff *skb,
>>>>>> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
>>>>>> b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
>>>>>> index d320567b2cca..51fa23418f6a 100644
>>>>>> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
>>>>>> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
>>>>>> @@ -368,7 +368,7 @@ static int qlcnic_set_mac(struct net_device
>>>>>> *netdev, void *p)
>>>>>>
>>>>>>     static int qlcnic_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
>>>>>>                 struct net_device *netdev,
>>>>>> -            const unsigned char *addr, u16 vid)
>>>>>> +            const unsigned char *addr, u16 vid, struct
>>>>>> netlink_ext_ack *extack)
>>>>>>     {
>>>>>>         struct qlcnic_adapter *adapter = netdev_priv(netdev);
>>>>>>         int err = -EOPNOTSUPP;
>>>>>> diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
>>>>>> index 069e8824c264..ffd34d9f7049 100644
>>>>>> --- a/drivers/net/macvlan.c
>>>>>> +++ b/drivers/net/macvlan.c
>>>>>> @@ -1017,7 +1017,7 @@ static int macvlan_fdb_add(struct ndmsg *ndm,
>>>>>> struct nlattr *tb[],
>>>>>>
>>>>>>     static int macvlan_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
>>>>>>                    struct net_device *dev,
>>>>>> -               const unsigned char *addr, u16 vid)
>>>>>> +               const unsigned char *addr, u16 vid, struct
>>>>>> netlink_ext_ack *extack)
>>>>>>     {
>>>>>>         struct macvlan_dev *vlan = netdev_priv(dev);
>>>>>>         int err = -EINVAL;
>>>>>> diff --git a/drivers/net/vxlan/vxlan_core.c
>>>>>> b/drivers/net/vxlan/vxlan_core.c
>>>>>> index de97ff98d36e..cf2f60037340 100644
>>>>>> --- a/drivers/net/vxlan/vxlan_core.c
>>>>>> +++ b/drivers/net/vxlan/vxlan_core.c
>>>>>> @@ -1280,7 +1280,7 @@ int __vxlan_fdb_delete(struct vxlan_dev *vxlan,
>>>>>>     /* Delete entry (via netlink) */
>>>>>>     static int vxlan_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
>>>>>>                     struct net_device *dev,
>>>>>> -                const unsigned char *addr, u16 vid)
>>>>>> +                const unsigned char *addr, u16 vid, struct
>>>>>> netlink_ext_ack *extack)
>>>>>>     {
>>>>>>         struct vxlan_dev *vxlan = netdev_priv(dev);
>>>>>>         union vxlan_addr ip;
>>>>>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>>>>>> index 28ea4f8269d4..d0d2a8f33c73 100644
>>>>>> --- a/include/linux/netdevice.h
>>>>>> +++ b/include/linux/netdevice.h
>>>>>> @@ -1509,7 +1509,7 @@ struct net_device_ops {
>>>>>>                                struct nlattr *tb[],
>>>>>>                                struct net_device *dev,
>>>>>>                                const unsigned char *addr,
>>>>>> -                           u16 vid);
>>>>>> +                           u16 vid, struct netlink_ext_ack *extack);
>>>>>>         int            (*ndo_fdb_dump)(struct sk_buff *skb,
>>>>>>                             struct netlink_callback *cb,
>>>>>>                             struct net_device *dev,
>>>>>> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
>>>>>> index 6ccda68bd473..5bfce2e9a553 100644
>>>>>> --- a/net/bridge/br_fdb.c
>>>>>> +++ b/net/bridge/br_fdb.c
>>>>>> @@ -1110,7 +1110,7 @@ static int __br_fdb_delete(struct net_bridge
>>>>>> *br,
>>>>>>     /* Remove neighbor entry with RTM_DELNEIGH */
>>>>>>     int br_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
>>>>>>               struct net_device *dev,
>>>>>> -          const unsigned char *addr, u16 vid)
>>>>>> +          const unsigned char *addr, u16 vid, struct netlink_ext_ack
>>>>>> *extack)
>>>>>>     {
>>>>>>         struct net_bridge_vlan_group *vg;
>>>>>>         struct net_bridge_port *p = NULL;
>>>>>> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
>>>>>> index 18ccc3d5d296..95348c1c9ce5 100644
>>>>>> --- a/net/bridge/br_private.h
>>>>>> +++ b/net/bridge/br_private.h
>>>>>> @@ -780,7 +780,7 @@ void br_fdb_update(struct net_bridge *br, struct
>>>>>> net_bridge_port *source,
>>>>>>                const unsigned char *addr, u16 vid, unsigned long
>>>>>> flags);
>>>>>>
>>>>>>     int br_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
>>>>>> -          struct net_device *dev, const unsigned char *addr, u16
>>>>>> vid);
>>>>>> +          struct net_device *dev, const unsigned char *addr, u16 vid,
>>>>>> struct netlink_ext_ack *extack);
>>>>> This is way too long (111 chars) and checkpatch should've complained
>>>>> about it.
>>>>> WARNING: line length of 111 exceeds 100 columns
>>>>> #234: FILE: net/bridge/br_private.h:782:
>>>>> +          struct net_device *dev, const unsigned char *addr, u16 vid,
>>>>> struct netlink_ext_ack *extack);
>>>> I will fix it.
>>>>
>>>>>>     int br_fdb_add(struct ndmsg *nlh, struct nlattr *tb[], struct
>>>>>> net_device *dev,
>>>>>>                const unsigned char *addr, u16 vid, u16 nlh_flags,
>>>>>>                struct netlink_ext_ack *extack);
>>>>>> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
>>>>>> index 4041b3e2e8ec..99b30ae58a47 100644
>>>>>> --- a/net/core/rtnetlink.c
>>>>>> +++ b/net/core/rtnetlink.c
>>>>>> @@ -4223,7 +4223,7 @@ static int rtnl_fdb_del(struct sk_buff *skb,
>>>>>> struct nlmsghdr *nlh,
>>>>>>             const struct net_device_ops *ops = br_dev->netdev_ops;
>>>>>>
>>>>>>             if (ops->ndo_fdb_del)
>>>>>> -            err = ops->ndo_fdb_del(ndm, tb, dev, addr, vid);
>>>>>> +            err = ops->ndo_fdb_del(ndm, tb, dev, addr, vid, extack);
>>>>>>
>>>>>>             if (err)
>>>>>>                 goto out;
>>>>>> @@ -4235,7 +4235,7 @@ static int rtnl_fdb_del(struct sk_buff *skb,
>>>>>> struct nlmsghdr *nlh,
>>>>>>         if (ndm->ndm_flags & NTF_SELF) {
>>>>>>             if (dev->netdev_ops->ndo_fdb_del)
>>>>>>                 err = dev->netdev_ops->ndo_fdb_del(ndm, tb, dev, addr,
>>>>>> -                               vid);
>>>>>> +                               vid, extack);
>>>>>>             else
>>>>>>                 err = ndo_dflt_fdb_del(ndm, tb, dev, addr, vid);
>>>>>>
>>>>>> --
>>>>>> 2.36.0
>>>>>>
> >
