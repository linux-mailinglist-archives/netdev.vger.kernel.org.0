Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD5760CA7B
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 13:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbiJYLAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 07:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232170AbiJYLAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 07:00:39 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40930B3B1E
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:00:38 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id ud5so7913126ejc.4
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XwmRTbb7Z1iwYqyAXL7gKB2BP7kYpxso4h/Svsr1CMI=;
        b=csA4tV2W4ZPfUGsLZe9XIg6GPvBX0o6HttxaPDBrirhtOECbekGMAlDBM9lzWqmKwc
         VvLUe4zPT5C27KQ5VReqNEn/JzcranIVRM2aqTI5a0qoBhn1lBsCvpVl6dngfsH21ug1
         /j3HZXqMMiRSLTjWU7CLja/lLWLp0YhnCddQN2LR88Gk/kqI0YxcC9SWNXE9C8wIrvOn
         dNJnFVt9Rv5S4ldgQFqBMQFkfQxXX6nGQXugGQTNJMyqZbSI4+lMgDobYZuJ8zbTf2yM
         8N2r79YY8ICkwGzHJ9ZaHoC3JkkCBZ7pT/Zz2aWFe1ojKQ2NWuXvq40+gLFhbAg+sfiJ
         PztQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XwmRTbb7Z1iwYqyAXL7gKB2BP7kYpxso4h/Svsr1CMI=;
        b=A2PUV5qjjuSjkxX5abjyLhpnzCPevsB2MhyQsP3FvkGL7f9Wrtyfu/la/np9Y6V3QO
         CiTVH+5Dz2a6S7uCGfvKKPW9Jw5KHHRDincJBPjWjug1/ubBR1N5gaaYIoz2Rf4z2QV6
         7Ucdvp8KbdQNQqTeVll5/usEOFQMMqVaWEVcd+uctYFqlrOlPHxVBEXG8b7SubJjXzV2
         Vt+94b9sMfJcBOz0nNH404ng3L5UVRIzt+Q59GrU7pb+tuNPIVnQ5O5nVdfxqyjTmlhC
         1wYtmxxzrhAfnG9J515Y/pl1xOlL/cRdM+Mb1+ngVZz1usJF5P4VmtnJmDWfHGNVEooP
         l35Q==
X-Gm-Message-State: ACrzQf2YEjJ0pqZ+uUeBtlsCkbv4zogxaNtXE2tvbDeWV6A6+/5Gagug
        FRP2tC0OKLojDZ2L8PZ6RRB7+A==
X-Google-Smtp-Source: AMsMyM5TvxPC6AZyWop4BCjg3BEgUkG4n9UgYEwrn78ckvahizQdXWcBIl9MWSA+mIKv19MxMIN5UQ==
X-Received: by 2002:a17:906:ef8b:b0:791:9980:b7b9 with SMTP id ze11-20020a170906ef8b00b007919980b7b9mr32017396ejb.636.1666695636384;
        Tue, 25 Oct 2022 04:00:36 -0700 (PDT)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id z17-20020a170906271100b0078a543e9301sm1165349ejc.200.2022.10.25.04.00.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Oct 2022 04:00:36 -0700 (PDT)
Message-ID: <9c0eb6c4-a52c-f2a9-b9be-c4b9805ac44f@blackwall.org>
Date:   Tue, 25 Oct 2022 14:00:34 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [RFC PATCH net-next 01/16] bridge: Add MAC Authentication Bypass
 (MAB) support
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@nvidia.com, petrm@nvidia.com,
        ivecera@redhat.com, roopa@nvidia.com, netdev@kapio-technology.com,
        vladimir.oltean@nxp.com, mlxsw@nvidia.com
References: <20221025100024.1287157-1-idosch@nvidia.com>
 <20221025100024.1287157-2-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20221025100024.1287157-2-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/10/2022 13:00, Ido Schimmel wrote:
> From: "Hans J. Schultz" <netdev@kapio-technology.com>
> 
> Hosts that support 802.1X authentication are able to authenticate
> themselves by exchanging EAPOL frames with an authenticator (Ethernet
> bridge, in this case) and an authentication server. Access to the
> network is only granted by the authenticator to successfully
> authenticated hosts.
> 
> The above is implemented in the bridge using the "locked" bridge port
> option. When enabled, link-local frames (e.g., EAPOL) can be locally
> received by the bridge, but all other frames are dropped unless the host
> is authenticated. That is, unless the user space control plane installed
> an FDB entry according to which the source address of the frame is
> located behind the locked ingress port. The entry can be dynamic, in
> which case learning needs to be enabled so that the entry will be
> refreshed by incoming traffic.
> 
> There are deployments in which not all the devices connected to the
> authenticator (the bridge) support 802.1X. Such devices can include
> printers and cameras. One option to support such deployments is to
> unlock the bridge ports connecting these devices, but a slightly more
> secure option is to use MAB. When MAB is enabled, the MAC address of the
> connected device is used as the user name and password for the
> authentication.
> 
> For MAB to work, the user space control plane needs to be notified about
> MAC addresses that are trying to gain access so that they will be
> compared against an allow list. This can be implemented via the regular
> learning process with the following differences:
> 
> 1. Learned FDB entries are installed with a new "locked" flag indicating
>    that the entry cannot be used to authenticate the device. The flag
>    cannot be set by user space, but user space can clear the flag by
>    replacing the entry, thereby authenticating the device.
> 
> 2. FDB entries cannot roam to locked ports to prevent unauthenticated
>    devices from disrupting traffic destined to already authenticated
>    devices.
> 
> Enable this behavior using a new bridge port option called "mab". It can
> only be enabled on a bridge port that is both locked and has learning
> enabled. A new option is added because there are pure 802.1X deployments
> that are not interested in notifications about "locked" FDB entries.
> 
> Signed-off-by: Hans J. Schultz <netdev@kapio-technology.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
> 
> Notes:
>     Changes made by me:
>     
>      * Reword commit message.
>      * Reword comment regarding 'NTF_EXT_LOCKED'.
>      * Use extack in br_fdb_add().
>      * Forbid MAB when learning is disabled.
> 
>  include/linux/if_bridge.h      |  1 +
>  include/uapi/linux/if_link.h   |  1 +
>  include/uapi/linux/neighbour.h |  8 +++++++-
>  net/bridge/br_fdb.c            | 24 ++++++++++++++++++++++++
>  net/bridge/br_input.c          | 15 +++++++++++++--
>  net/bridge/br_netlink.c        | 13 ++++++++++++-
>  net/bridge/br_private.h        |  3 ++-
>  net/core/rtnetlink.c           |  5 +++++
>  8 files changed, 65 insertions(+), 5 deletions(-)
> 

Thanks for finalizing this, the patch looks good to me.
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

Thanks,
 Nik
