Return-Path: <netdev+bounces-3221-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 226D8706139
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 09:33:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8B131C20E60
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 07:33:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F0758BF2;
	Wed, 17 May 2023 07:33:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145FD8830
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 07:33:16 +0000 (UTC)
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8BD5253
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 00:33:07 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-96adcb66f37so70375366b.1
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 00:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1684308785; x=1686900785;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dNSDSFrDFbpPqdYEuN89e9yeuyZne6fiLX09JZpnnaQ=;
        b=VmMAPOyosODi0Oa3kk/lczgV+F2wFxVZqk/0hszxe6QSeo3ux81DeWhkAFDUa5ku0B
         EBVL5IutHi6M7si8Vm8aAiOTcMFGFAjk2kxuqfj5x+sT5Wgsu9+Yjj6y0E0+GkB7eV/2
         FcWAUoD3eg8bs96ntWcLX2TarfzeCS74IoXx8FkajG2BQ+HIC36UoFg/oq4Yl4J/r7eB
         yxTxC+pJiMcArvLGowXWqL736Ukqmfc4j7mLQYNDCwG8QVYKAAeWyzgOZK/HILnza1fW
         erNjN9FdiNH4EGuBRrPcKURazxmzSrlDlhDlg9c1cencscueOAOfdJbO3HGQHPACDuZv
         +vgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684308785; x=1686900785;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dNSDSFrDFbpPqdYEuN89e9yeuyZne6fiLX09JZpnnaQ=;
        b=ggL2ZHFj/b8Hf3zC3Foo3bp8Tyrlpz3rLD3wPBBLyGj64UHzSMaEZU+GDaHegdMXq7
         7rSR0WazGnW/v+sGCVee2lJYXb49QA60GvC+FadziM1QQrbIP3PU8G3G69dbINC3Ndvp
         f7RjSewxrOI+hZinhnxqyqkejVT4dUAn8vZp4cClBypxwy26Vg+QS3h3f2Qa0wgjmsT6
         eKYSjh0U6M4HM88NoivqtJB0DCd1kP8eFhuV0UR0DmcPRZuYCC4utxqJSHOjJNd0MrwK
         yLdcyRp6QE/QjUKREpcDPv3fkCC1ki8MzLLEXgv+xEktfIFXokkob7Ir+ZfVDkMougR3
         SXZA==
X-Gm-Message-State: AC+VfDxaTgvDgt4NQGLGDSd+aAJOp2bSPqNmqctiH1X6dQy2oPWLVPLF
	r2g0YViQJkm2bowsik6M1klYWw==
X-Google-Smtp-Source: ACHHUZ4bKH6nuAL+Av8BpnIu5DQ26jMK8Rn4ZGnWU07q0yJ5uj8FsA7prleEWrWha2M97z1kBLUvMA==
X-Received: by 2002:a17:907:6d23:b0:96a:349a:6c91 with SMTP id sa35-20020a1709076d2300b0096a349a6c91mr23819008ejc.23.1684308785373;
        Wed, 17 May 2023 00:33:05 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id m26-20020a17090677da00b0096ae4451c65sm5850503ejn.157.2023.05.17.00.33.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 00:33:04 -0700 (PDT)
Message-ID: <63f12ee5-bd7d-a734-af98-e99196d84441@blackwall.org>
Date: Wed, 17 May 2023 10:33:03 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 3/4] bridge: always declare tunnel functions
Content-Language: en-US
To: Arnd Bergmann <arnd@kernel.org>, netdev@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Roopa Prabhu <roopa@nvidia.com>,
 bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20230516194625.549249-1-arnd@kernel.org>
 <20230516194625.549249-3-arnd@kernel.org>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230516194625.549249-3-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 16/05/2023 22:45, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> When CONFIG_BRIDGE_VLAN_FILTERING is disabled, two functions are still
> defined but have no prototype or caller. This causes a W=1 warning for
> the missing prototypes:
> 
> net/bridge/br_netlink_tunnel.c:29:6: error: no previous prototype for 'vlan_tunid_inrange' [-Werror=missing-prototypes]
> net/bridge/br_netlink_tunnel.c:199:5: error: no previous prototype for 'br_vlan_tunnel_info' [-Werror=missing-prototypes]
> 
> The functions are already contitional on CONFIG_BRIDGE_VLAN_FILTERING,
> and I coulnd't easily figure out the right set of #ifdefs, so just
> move the declarations out of the #ifdef to avoid the warning,
> at a small cost in code size over a more elaborate fix.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  net/bridge/br_private_tunnel.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 

This should be for -net.

Fixes: 188c67dd1906 ("net: bridge: vlan options: add support for tunnel id dumping")
Fixes: 569da0822808 ("net: bridge: vlan options: add support for tunnel mapping set/del")
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

Thanks,
 Nik




