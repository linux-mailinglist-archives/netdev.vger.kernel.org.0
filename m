Return-Path: <netdev+bounces-6066-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F0D3714A1E
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 15:18:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EE27280DA9
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 13:18:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A22546FDE;
	Mon, 29 May 2023 13:18:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DDC6FD5
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 13:18:41 +0000 (UTC)
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2478D188
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 06:18:16 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-510f525e06cso5697340a12.2
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 06:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1685366294; x=1687958294;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ekH/XPPL11xeKHaj9D6lSLg3OZVj5G8ttFan0W5KnI8=;
        b=g4QHDjpT4S77avoZxAHq41BxBNa4BuJgDXddpg8aHMfKgTdpn9YReZo+21hMlaD6D6
         iItVduypcbFD1PjRrNqqS5/QWJOL91v1aEFHpy+Piv/tQOnuZ/8900d3KLD+6yDZhpm8
         X6wsiZd+yTlVGwf81XT+iF86AUW8ST3rrYJH3d9m6JgVUaln+cfboCE/t06YMe26S0es
         c2sU8/+VTR6vh/mJBoSD0FtL5ey707nXvJBnNTOplj/IuWYkb+eGAvC4KaabeIcV/qqn
         cAFSzamLycnVQmnzCf3uNEYn2E5MOitp6ku2o3dUjWvxoSHLSoFR2oKaiFJPjyWHirkb
         N+SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685366294; x=1687958294;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ekH/XPPL11xeKHaj9D6lSLg3OZVj5G8ttFan0W5KnI8=;
        b=YfFXNQ6jRa4uGXfG+RCF+tcmOKHumhnohTyfRFA3MQaNfSu6ZPZPtkcRDVWkQfMumE
         9LRSzMv9Uwd+TRXNbg3Y5jkHQc4AJGy3bREDHijYSLkd9qtYOxKsIhdVQIuR4fPZDDy0
         PuqwKbT/lD78E8DOjIi2rCJ26F0ZxVegsgHzOna3YPH+UmQe3S88OwFZGSjUoz/tfa0p
         pxmJrNoP100HFRJWhslWMXAt5D8VRb+TaBGuA3Vt6Oe66BU7QhzXeB0jnT8R82YbpRo/
         ltetqbSKhIAWMZCGhylNJDPMz/+AOeFP6M3+zCJ9YAFcbfQouNTh/WRg8pg5nNuADxP6
         3pJw==
X-Gm-Message-State: AC+VfDyN1zb7l80VfcqdPSh+YREcl40q+grlrY8DYFIgM15NFt7iSGKD
	QeCAR8sw1hK7Zp4JLF1efiCKDA==
X-Google-Smtp-Source: ACHHUZ6zbhEgQPjq7oOZNBX+tPtndmda+yq2VADwzviivMW15bGWEM9qWHvOIfGuhVga4zwWuziKxw==
X-Received: by 2002:a17:906:ee83:b0:94f:2a13:4e01 with SMTP id wt3-20020a170906ee8300b0094f2a134e01mr9124363ejb.74.1685366293633;
        Mon, 29 May 2023 06:18:13 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id e18-20020a170906249200b0096f503ae4b0sm5912249ejb.26.2023.05.29.06.18.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 May 2023 06:18:13 -0700 (PDT)
Message-ID: <cddf6ca0-3c9f-3ee2-1145-f68b3da73fab@blackwall.org>
Date: Mon, 29 May 2023 16:18:11 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v2 2/8] flow_dissector: Dissect layer 2 miss from
 tc skb extension
Content-Language: en-US
To: Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
 bridge@lists.linux-foundation.org
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, taras.chornyi@plvision.eu, saeedm@nvidia.com,
 leon@kernel.org, petrm@nvidia.com, vladimir.oltean@nxp.com,
 claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
 UNGLinuxDriver@microchip.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
 jiri@resnulli.us, roopa@nvidia.com, simon.horman@corigine.com
References: <20230529114835.372140-1-idosch@nvidia.com>
 <20230529114835.372140-3-idosch@nvidia.com>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230529114835.372140-3-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 29/05/2023 14:48, Ido Schimmel wrote:
> Extend the 'FLOW_DISSECTOR_KEY_META' key with a new 'l2_miss' field and
> populate it from a field with the same name in the tc skb extension.
> This field is set by the bridge driver for packets that incur an FDB or
> MDB miss.
> 
> The next patch will extend the flower classifier to be able to match on
> layer 2 misses.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
> 
> Notes:
>     v2:
>     * Split from flower patch.
>     * Use tc skb extension instead of 'skb->l2_miss'.
> 
>  include/net/flow_dissector.h |  2 ++
>  net/core/flow_dissector.c    | 10 ++++++++++
>  2 files changed, 12 insertions(+)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>



