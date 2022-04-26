Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45CE35101B4
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 17:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244524AbiDZPUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 11:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352717AbiDZPTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 11:19:46 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 757EF158F58
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 08:11:45 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id a15so18230651pfv.11
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 08:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FmmmDqbHZ+ZiQlU/EzbQ7prUZMU2t+mIW8jXgI0HHbE=;
        b=Kfo3WqaqE2+joZ/xnreYwCPHlBGHziTg2dpk3URzYayyC+DQl2CRvzMsUFiZ5Tzn8T
         kVLlMPZ5E3cxV50MNQAeifYzxmwCUk0tZFf2L9dsQ/z9D8KTPR+z7Jf/Vgi/nxVu0INT
         Bpf+W1X/7DWIKwF3hOWRI/BSoh30uzLTn9F1DjVJhQ3HCgsGqzrHOkQTeTHrD+A+/lvL
         JBze2Ql4pNAaK/BrMr7RvPHrh0ROnHNDWJu/rW/gw76iaMhcFnmSHi7sZhQrEvyB5J5c
         zzIu8sTy7WfOUXVD5nAqlBjOoIlfsCFeJz3wm/RGV3YVFNVfZAg99ojRwJlWqcJF9zNW
         PZQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FmmmDqbHZ+ZiQlU/EzbQ7prUZMU2t+mIW8jXgI0HHbE=;
        b=PD0ZjlCuwT34yYGcNFkoKZlJPpmw5DDc8PexfwUXkUEKBRK0xKE5fYJuK/0mmHPrb8
         1PMXHycj2aAsc82FGHPsWCSk4s1E8Xeoj4svnl1PpbR7Nren3BNwGAY0cBI8a7mHQVD5
         AxeK7yhBKFBifT0gJytp4wvYRmxw7i4v4NMNA3BBV+lgZ/HVV5lQ+RlRZS3Wsei6wyOa
         s6xBr6SDVFWO5JqrDVSGNICcer85zzWZMcGRSgeD/3rMQo+oO9yq2pzvra4QH/faYvN4
         i5C0EMIemT9sV/AhokOjV+YXtCYtaXt7lo09xkSdTUnyAhW8Qa2tTFiuaWgyeXrsejQG
         A6Gg==
X-Gm-Message-State: AOAM532ZPnRTh0jWXtFBYwh/uH9L56o3Av6+0ioFxtQN5iiFBHj6a+NA
        6aZIbNG9XDq63T/DXOUm8sXwEQ==
X-Google-Smtp-Source: ABdhPJzEWTFJ+/ZJFwOpvlYRYVHjJG2z3teSSa1k21zGhi4vqnniued+UnQRQL6L9pJr6On+OKPYgg==
X-Received: by 2002:a63:834a:0:b0:3ab:5ca7:3905 with SMTP id h71-20020a63834a000000b003ab5ca73905mr7105475pge.351.1650985904927;
        Tue, 26 Apr 2022 08:11:44 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id j189-20020a62c5c6000000b0050d59986dcdsm3165812pfg.208.2022.04.26.08.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 08:11:44 -0700 (PDT)
Date:   Tue, 26 Apr 2022 08:11:42 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>
Subject: Re: [PATCH iproute2-next v3 0/2] f_flower: match on the number of
 vlan tags
Message-ID: <20220426081142.71d58c1b@hermes.local>
In-Reply-To: <20220426091417.7153-1-boris.sukholitko@broadcom.com>
References: <20220426091417.7153-1-boris.sukholitko@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Apr 2022 12:14:15 +0300
Boris Sukholitko <boris.sukholitko@broadcom.com> wrote:

> Hi,
> 
> Our customers in the fiber telecom world have network configurations
> where they would like to control their traffic according to the number
> of tags appearing in the packet.
> 
> For example, TR247 GPON conformance test suite specification mostly
> talks about untagged, single, double tagged packets and gives lax
> guidelines on the vlan protocol vs. number of vlan tags.
> 
> This is different from the common IT networks where 802.1Q and 802.1ad
> protocols are usually describe single and double tagged packet. GPON
> configurations that we work with have arbitrary mix the above protocols
> and number of vlan tags in the packet.
> 
> The following patch series implement number of vlans flower filter. They
> add num_of_vlans flower filter as an alternative to vlan ethtype protocol
> matching. The end result is that the following command becomes possible:
> 
> tc filter add dev eth1 ingress flower \
>   num_of_vlans 1 vlan_prio 5 action drop
> 
> Also, from our logs, we have redirect rules such that:
> 
> tc filter add dev $GPON ingress flower num_of_vlans $N \
>      action mirred egress redirect dev $DEV
> 
> where N can range from 0 to 3 and $DEV is the function of $N.
> 
> Also there are rules setting skb mark based on the number of vlans:
> 
> tc filter add dev $GPON ingress flower num_of_vlans $N vlan_prio \
>     $P action skbedit mark $M
> 
> Thanks,
> Boris.
> 
> - v3: rebased to the latest iproute2-next
> - v2: add missing f_flower subject prefix
> 
> Boris Sukholitko (2):
>   f_flower: Add num of vlans parameter
>   f_flower: Check args with num_of_vlans
> 
>  tc/f_flower.c | 57 ++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 41 insertions(+), 16 deletions(-)

Can you do this with BPF? instead of kernel change?
