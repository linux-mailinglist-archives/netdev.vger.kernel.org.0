Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F2C65BF58B
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 06:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbiIUEpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 00:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiIUEpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 00:45:13 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB19474D2
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 21:45:11 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id z97so6825955ede.8
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 21:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=qzk5oLYbYGm3BHnsgSBtDHRCJL48j9t8HeQTS7gm2wg=;
        b=JxUWNI8TIHdFgVW1ngZne2CkuOQxif+pa+WY88wq2PlopW0EDUDjqn5HpjeYYMv+i0
         KViOt3GPgDmkyqt1Z/qhvKgj0X4/bRphKTWbn6kPseH6bvajEKRR7pcj9uFjlpwWBAqh
         30uffDwipf38NBdVVSL6ejnuz1edkAxWTwUk7c4HnyUzPHmH82KXM046fdsnIIejakaa
         1IUmrViZEXVLRgEc5tjo2skcoQDycenjeh7l4cZmyYa8KG8ccAlPiLR7BmWBofJ5cwYJ
         3d3HwK9T9JFItsMEdseerz+vKXidMCitosRO75NmfH0r9/U+IlUQsJV7i+L9Rk01xnwy
         acXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=qzk5oLYbYGm3BHnsgSBtDHRCJL48j9t8HeQTS7gm2wg=;
        b=kYuZKcp7E1Aomb3UOHeHfZLLieP5ZvIKWWoWBqbCLeAQhk75dpqYdPb5z+vIFbGop9
         unPAvWjBY6++Fzc3R71ulJKsfW6olxPcosT6GimBh5xPhtUaZf4dIxOy8HNRX3prx2qy
         nWZEoEo1bGLDxXFYPWKsMJA091YL2VatshhMV30erQ/9gVogXimbYZhXQuYZTOzlqUzD
         JLnxgdMRweXZ+EoS4CXcnkTKjGM7XV7IQ4g2dVeWjmq52YG8ENFUz6G8Hiqkw5oBjMo5
         5wpwcWrIbe0MGtJ3hI25/6gi/D87TYzyYBUPXh6uAkBM5zaujSxIzaaHbziHnaPOXMKV
         D4bA==
X-Gm-Message-State: ACrzQf2kY+Jysv1gREiArv/lO1Jr0VvmPcGh/x2ElqZEnvjIiHTGR2ii
        ybsvKf2PmYwOwDCem/qJWJtUKQ==
X-Google-Smtp-Source: AMsMyM7+gW+ygA22gbwvi4QbDO0COr82ooOiqv4A3s3dNUtpnD2pI6UQO3Pvu/4MBUZrJnY8xt4Fng==
X-Received: by 2002:aa7:d718:0:b0:454:5899:9eb0 with SMTP id t24-20020aa7d718000000b0045458999eb0mr7685676edq.37.1663735509924;
        Tue, 20 Sep 2022 21:45:09 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id kx15-20020a170907774f00b0073dc8d0eabesm806342ejc.15.2022.09.20.21.45.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 21:45:09 -0700 (PDT)
Message-ID: <3f2d6682-7c5c-5a6d-110b-568331650949@blackwall.org>
Date:   Wed, 21 Sep 2022 07:45:07 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH RFC net-next 0/5] net: vlan: fix bridge binding behavior
 and add selftests
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Sevinj Aghayeva <sevinj.aghayeva@gmail.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        aroulin@nvidia.com, sbrivio@redhat.com, roopa@nvidia.com,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
References: <cover.1663445339.git.sevinj.aghayeva@gmail.com>
 <78bd0e54-4ee3-bd3c-2154-9eb8b9a70497@blackwall.org>
 <20220920162954.1f4aaf7b@kernel.org>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220920162954.1f4aaf7b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/09/2022 02:29, Jakub Kicinski wrote:
> On Tue, 20 Sep 2022 12:16:26 +0300 Nikolay Aleksandrov wrote:
>> The set looks good to me, the bridge and vlan direct dependency is gone and
>> the new notification type is used for passing link type specific info.
> 
> IDK, vlan knows it's calling the bridge:
> 
> +	if ((vlan->flags ^ old_flags) & VLAN_FLAG_BRIDGE_BINDING &&
> +	    netif_is_bridge_master(vlan->real_dev)) {
> 

This one is more of an optimization so notifications are sent only when the bridge
is involved, it can be removed if other interested parties show up.

> bridge knows it's vlan calling:
> 
> +	if (is_vlan_dev(dev)) {
> +		br_vlan_device_event(dev, event, ptr);
> 
> going thru the generic NETDEV notifier seems odd.
> 
> If this is just to avoid the dependency we can perhaps add a stub 
> like net/ipv4/udp_tunnel_stub.c ?
> 

I suggested the notifier to be more generic and be able to re-use it for other link types although
I don't have other use cases in mind right now. Stubs are an alternative as long as they and
their lifetime are properly managed. I don't have a strong preference here so if you prefer
stubs I'm good.

>> If the others are ok with it I think you can send it as non-RFC, but I'd give it
>> a few more days at least. :)

Cheers,
 Nik

