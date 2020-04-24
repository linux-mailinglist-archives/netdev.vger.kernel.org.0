Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDE81B76AF
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 15:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgDXNN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 09:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbgDXNN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 09:13:26 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0FC6C09B046
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 06:13:25 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id n6so9851495ljg.12
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 06:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=nDPT+ZJV2CPq97DCHIlmvXZGmifjSJc4mNEmnMWJwWM=;
        b=WRLW/bbmRMkfS9O1ECWVAAWtvAPmuPSSoAM3jlf2LRvXEY9zNzbfxDoSugIiOxISkc
         6RnGh/1395GKZqaUR+3rh2sqZxh/QmuRJ1o+RIk1YI+S7dITrAKAyeSL16PkK1KsLvPY
         Gz4mjzkpzQGUJIRpMQJl2BLDptZPAthVvlPGU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nDPT+ZJV2CPq97DCHIlmvXZGmifjSJc4mNEmnMWJwWM=;
        b=SWJuyAdgxsSZeAYXrwNX3dxn88zfJL3naBH0icC1kMT08uT72LeQB3BAytXScAHzYK
         yrKcY62b4lEYapDsM7XCqwX0y5XyN6MkTjNGaDGK2ID4rViALXl0dJGQyau0rmMcFny9
         egipY0+MujK85FyjUiBHZ6RM8CHHwXKGRGPgtdzUt5+sItnbeaphF2edr00CgOnN9tn0
         kl4lG9UcH6q8lezBd9STDclAtUp86o6XYGykgKXplQW9j0QRjHBRO6xqsGLktcZ6kCdG
         bGNJsHrO3YbRFQBsAY8l5u97mEZnxNK4BJeEoZMayD9rKAehw6c29bHmCzdTxLbwq4Ui
         zf7Q==
X-Gm-Message-State: AGi0PubXw2gv9iN45CKvsC7GfVWnOOhdDtb/6OlyWehCNVOV2IkBX1tY
        IclVIBKmhRA6gTUCCCQjNaIQnQ==
X-Google-Smtp-Source: APiQypIlDsND4ZoXJCYhXZw8Pemxq0b7qjO3eidwGiYlnSIoSi1xbnZzLio6Jxah6p4cT+Bmf8gtYg==
X-Received: by 2002:a2e:90cd:: with SMTP id o13mr6214339ljg.220.1587734003888;
        Fri, 24 Apr 2020 06:13:23 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s30sm4489540lfc.93.2020.04.24.06.13.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2020 06:13:23 -0700 (PDT)
Subject: Re: [PATCH net-next v3 05/11] bridge: mrp: Add MRP interface.
To:     Horatiu Vultur <horatiu.vultur@microchip.com>, davem@davemloft.net,
        jiri@resnulli.us, ivecera@redhat.com, kuba@kernel.org,
        roopa@cumulusnetworks.com, olteanv@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20200422161833.1123-1-horatiu.vultur@microchip.com>
 <20200422161833.1123-6-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <67f65f7e-9c1e-a420-b527-bc379f9563c1@cumulusnetworks.com>
Date:   Fri, 24 Apr 2020 16:13:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200422161833.1123-6-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/04/2020 19:18, Horatiu Vultur wrote:
> Define the MRP interface.
> This interface is used by the netlink to update the MRP instances and by the MRP
> to make the calls to switchdev to offload it to HW.
> 
> It defines an MRP instance 'struct br_mrp' which is a list of MRP instances.
> Which will be part of the 'struct net_bridge'. Each instance has 2 ring ports,
> a bridge and an ID.
> 
> In case the HW can't generate MRP Test frames then the SW will generate those.
> 
> br_mrp_add - adds a new MRP instance.
> 
> br_mrp_del - deletes an existing MRP instance. Each instance has an ID(ring_id).
> 
> br_mrp_set_port_state - changes the port state. The port can be in forwarding
>   state, which means that the frames can pass through or in blocked state which
>   means that the frames can't pass through except MRP frames. This will
>   eventually call the switchdev API to notify the HW. This information is used
>   also by the SW bridge to know how to forward frames in case the HW doesn't
>   have this capability.
> 
> br_mrp_set_port_role - a port role can be primary or secondary. This
>   information is required to be pushed to HW in case the HW can generate
>   MRP_Test frames.  Because the MRP_Test frames contains a file with this
>   information. Otherwise the HW will not be able to generate the frames
>   correctly.
> 
> br_mrp_set_ring_state - a ring can be in state open or closed. State open means
>   that the mrp port stopped receiving MRP_Test frames, while closed means that
>   the mrp port received MRP_Test frames. Similar with br_mrp_port_role, this
>   information is pushed in HW because the MRP_Test frames contain this
>   information.
> 
> br_mrp_set_ring_role - a ring can have the following roles MRM or MRC. For the
>   role MRM it is expected that the HW can terminate the MRP frames, notify the
>   SW that it stopped receiving MRP_Test frames and trapp all the other MRP
>   frames.  While for MRC mode it is expected that the HW can forward the MRP
>   frames only between the MRP ports and copy MRP_Topology frames to CPU. In
>   case the HW doesn't support a role it needs to return an error code different
>   than -EOPNOTSUPP.
> 
> br_mrp_start_test - this starts/stops the generation of MRP_Test frames. To stop
>   the generation of frames the interval needs to have a value of 0. In this case
>   the userspace needs to know if the HW supports this or not. Not to have
>   duplicate frames(generated by HW and SW). Because if the HW supports this then
>   the SW will not generate anymore frames and will expect that the HW will
>   notify when it stopped receiving MRP frames using the function
>   br_mrp_port_open.
> 
> br_mrp_port_open - this function is used by drivers to notify the userspace via
>   a netlink callback that one of the ports stopped receiving MRP_Test frames.
>   This function is called only when the node has the role MRM. It is not
>   supposed to be called from userspace.
> 
> br_mrp_port_switchdev_add - this corresponds to the function br_mrp_add,
>   and will notify the HW that a MRP instance is added. The function gets
>   as parameter the MRP instance.
> 
> br_mrp_port_switchdev_del - this corresponds to the function br_mrp_del,
>   and will notify the HW that a MRP instance is removed. The function
>   gets as parameter the ID of the MRP instance that is removed.
> 
> br_mrp_port_switchdev_set_state - this corresponds to the function
>   br_mrp_set_port_state. It would notify the HW if it should block or not
>   non-MRP frames.
> 
> br_mrp_port_switchdev_set_port - this corresponds to the function
>   br_mrp_set_port_role. It would set the port role, primary or secondary.
> 
> br_mrp_switchdev_set_role - this corresponds to the function
>   br_mrp_set_ring_role and would set one of the role MRM or MRC.
> 
> br_mrp_switchdev_set_ring_state - this corresponds to the function
>   br_mrp_set_ring_state and would set the ring to be open or closed.
> 
> br_mrp_switchdev_send_ring_test - this corresponds to the function
>   br_mrp_start_test. This will notify the HW to start or stop generating
>   MRP_Test frames. Value 0 for the interval parameter means to stop generating
>   the frames.
> 
> br_mrp_port_open - this function is used to notify the userspace that the port
>   lost the continuity of MRP Test frames.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  net/bridge/br_private_mrp.h | 63 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 63 insertions(+)
>  create mode 100644 net/bridge/br_private_mrp.h
> 

Reviewed-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>


