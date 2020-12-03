Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351D12CCAE6
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 01:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgLCANk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 19:13:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLCANj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 19:13:39 -0500
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6684C0613D6
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 16:12:53 -0800 (PST)
Received: by mail-ot1-x331.google.com with SMTP id z23so118538oti.13
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 16:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j5LK56uwTPZVqXTbtsdwvr/cNhG5w3B3FP0/Cfpybx4=;
        b=fIx/2wfVipHJWernMx6+/aVJOSX7OnMGpirXNs1cxe1AtrjgHLpQHzRmK0LvfCWU1h
         6V45se2QuXi1bfFIsPBdVjaRY1TlMljfV07jsZild0EZGxesygOnp5avmeXnUtvYs5aE
         ofRIcaDHUFDxIqrU7TklsGbWjsteZ8Gj+dqy7oWiVlGIoMKveokEWumjajDp/68dZRL/
         n6yy+ncAYMwfIb4nywFamn1hOoieZWEYHTncG/vjFonK12sdesYhdmSBJ6IvPj0TtAPK
         i86Bq2hpaRh5JUe9Hxr+iGq+3kBfiG/dx24gLmMxQZmWSFwNN9/ibNS7eN8dXEU6tlyy
         inFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j5LK56uwTPZVqXTbtsdwvr/cNhG5w3B3FP0/Cfpybx4=;
        b=da1PHQRWFb4V6Bol+Vgo6DBE7mJAiqVRfDSOXrXAwCXCwknXdExvkbB2EEPSQ22eNK
         JfHf8IMI5gPPdZC3SD0w2Vhama3PY9asNeNuwtEQPFzT/+WaOFvhMy6KhN3YP8WGs1r0
         2lKSvorkuaXKoi9NM5icLUG58m98UQu3mOAFbMlMXVh2HsyC6sirhnA2McKDUxCI4e1+
         8PcZB10yU2snvpRdKc8qu8tS1D/iHramDWCuj3BCJnZDDuH6oSStwcOv8iBJ9jrpbRA8
         Hic0SgCnf+5vCdjZbtav+vJgN3WLJqB8cvI0vwdY+7HYW3/pckXZLoUM+d2UJGMGcP1d
         gkZg==
X-Gm-Message-State: AOAM530InWA3sbhIKxc3PhWvyQ+FWMlwBFEwE09285OuFeOwymVZxULF
        607YR1CGIaO/fdZHyvoSPAW/4xOpJaI=
X-Google-Smtp-Source: ABdhPJwJYxbuGo0hucAF+x8i1eP4WtnxX7OzEcg8v85O/oad7bjskyw5f6Krcg4dhe1uaMN9q26NZg==
X-Received: by 2002:a9d:2ac5:: with SMTP id e63mr332431otb.218.1606954373017;
        Wed, 02 Dec 2020 16:12:53 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id p8sm51367oig.22.2020.12.02.16.12.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Dec 2020 16:12:52 -0800 (PST)
Subject: Re: Linux IPV6 TCP egress path device passed for LOCAL_OUT hook is
 incorrect
To:     Preethi Ramachandra <preethir@juniper.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Jimmy Jose <jimmyj@juniper.net>,
        Reji Thomas <rejithomas@juniper.net>,
        Yogesh Ankolekar <ayogesh@juniper.net>
References: <3D696DFB-7D22-44A6-9869-D2EFDEBDDEEB@juniper.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7b4f897a-b315-09eb-58f2-5e0b4a33ec73@gmail.com>
Date:   Wed, 2 Dec 2020 17:12:51 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <3D696DFB-7D22-44A6-9869-D2EFDEBDDEEB@juniper.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/2/20 4:31 AM, Preethi Ramachandra wrote:
> Hi David Ahren,
> 
> In TCP egress path for ipv6 the device passed to NF_INET_LOCAL_OUT hook should be skb_dst(skb)->dev instead of dst->dev.
> 
> https://elixir.bootlin.com/linux/latest/source/net/ipv6/ip6_output.c#L202
> struct dst_entry *dst = skb_dst(skb); >>> This may return slave device.
> 
> In this code path the DST Dev and SKB DST Dev will be set to VRF master device.
> ip6_xmit->l3mdev_ip6_out->vrf_l3_out->vrf_ip6_out (This will set SKB DST Dev to vrf0)
> 
> However, once the control passes back to ip6_xmit, https://elixir.bootlin.com/linux/latest/source/net/ipv6/ip6_output.c#L280
> Slave device is passed to LOCAL_OUT nf_hook instead of skb_dst(skb)->dev.
> 
> return NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_OUT,
>        net, (struct sock *)sk, skb, NULL, dst->dev, <<<< Should be skb_dst(skb)->dev
>        dst_output);

The vrf device version of that call is managed by the vrf driver. See
vrf_ip6_out_direct():

       err = nf_hook(NFPROTO_IPV6, NF_INET_LOCAL_OUT, net, sk,
                      skb, NULL, vrf_dev, vrf_ip6_out_direct_finish);
