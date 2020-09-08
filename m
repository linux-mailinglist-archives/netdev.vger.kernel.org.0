Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38E3260EF7
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 11:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbgIHJpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 05:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728591AbgIHJpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 05:45:21 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F0AC061573;
        Tue,  8 Sep 2020 02:45:21 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id x14so18337034wrl.12;
        Tue, 08 Sep 2020 02:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IbF4MU0tO5pswZ6Pf+mZyMeSB7RqS4XxH2UG10CWEPo=;
        b=vSOqIB7TrF49RNzF6LTLMvuhqUHbu8pPkNld+Ur5otxVnKNYsiB1iNOCtJGl+Q36A+
         NKd9Yro0J90rkuTvX3Op+Q8U455lgryWCQXRDQC5tW+252tWx+Bg69jbPsGfYqbnWXHq
         lsqX+O7hXeK8th7dl0rhZaXJte3OVd49hBoEMFe5hDvd6IVmY08C8+g75Ovmt/tG3o5B
         SOG0zRcUJSD6N9wLqVPOBmTAcLIR2U35k8GO5saXaHZMyupT5GJ50BPj+DFoNyyukIwt
         K/Uj41EYey5yLcAGPdzh3BdM/GAELuBQWQdUdkzz7af2ohKcg/Dc9PNi4xXkayaFNChZ
         Ywmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IbF4MU0tO5pswZ6Pf+mZyMeSB7RqS4XxH2UG10CWEPo=;
        b=cK4DTxFb39mTAM5k7sPcluP8tiwUq98RTdKt8lUBf/kRWkLbcrzf2EDDpVVLPJMPDn
         YAlwk92uVKGJVHExQ3v4Zwz3ha0FnI4tXSplOHoqAzhLeoYyIgUAo0jDdVBOycRWwOEJ
         RA8Arp+S7C4KE65KubC80Lo1ReNfJrau42GSyLvFhbF7V1Lb4Be5AQR6/h2qfc1N3vP2
         hQC+/JpLPXadux3II/m5NyPqnzWVYhoa/sXV5lXBSnAvQ3zJunTmdIko+wImLEZueFtO
         5eFB/HJ3lNnfUGKn4fThhcT5Cyo/WYToZTcfxtRs23Q6VQjufB0Z0TYziH5cqe8tFljU
         OhBQ==
X-Gm-Message-State: AOAM533zVcoPv/IdOaNN8KYM4VIp8uXQYzNl/6Ji1kugPPkikUR35923
        nOjpYvwFq8QCeeLM53gy3ng=
X-Google-Smtp-Source: ABdhPJxUlZ5lo45dizuZCwuKoIJvidv7xhWhsQPD4SzFzSoSVpatc9q0HJU6UuhnfmNdW5wMVzvisg==
X-Received: by 2002:adf:eb86:: with SMTP id t6mr19271165wrn.411.1599558319684;
        Tue, 08 Sep 2020 02:45:19 -0700 (PDT)
Received: from [192.168.8.147] ([37.172.73.222])
        by smtp.gmail.com with ESMTPSA id v204sm31915261wmg.20.2020.09.08.02.45.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 02:45:19 -0700 (PDT)
Subject: Re: [PATCH bpf-next 4/4] ixgbe, xsk: use XSK_NAPI_WEIGHT as NAPI poll
 budget
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org
References: <20200907150217.30888-1-bjorn.topel@gmail.com>
 <20200907150217.30888-5-bjorn.topel@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6bbf1793-d2be-b724-eec4-65546d4cbc9c@gmail.com>
Date:   Tue, 8 Sep 2020 11:45:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200907150217.30888-5-bjorn.topel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/7/20 5:02 PM, Björn Töpel wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> Start using XSK_NAPI_WEIGHT as NAPI poll budget for the AF_XDP Rx
> zero-copy path.
> 
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> index 3771857cf887..f32c1ba0d237 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
> @@ -239,7 +239,7 @@ int ixgbe_clean_rx_irq_zc(struct ixgbe_q_vector *q_vector,
>  	bool failure = false;
>  	struct sk_buff *skb;
>  
> -	while (likely(total_rx_packets < budget)) {
> +	while (likely(total_rx_packets < XSK_NAPI_WEIGHT)) {
>  		union ixgbe_adv_rx_desc *rx_desc;
>  		struct ixgbe_rx_buffer *bi;
>  		unsigned int size

This is a violation of NAPI API. IXGBE is already diverging a bit from best practices.

There are reasons we want to control the budget from callers,
if you want bigger budget just increase it instead of using your own ?

I would rather use a generic patch.

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7bd4fcdd0738a718d8b0f7134523cd87e4dcdb7b..33bcbdb6fef488983438c6584e3cbb0a44febb1a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2311,11 +2311,14 @@ static inline void *netdev_priv(const struct net_device *dev)
  */
 #define SET_NETDEV_DEVTYPE(net, devtype)       ((net)->dev.type = (devtype))
 
-/* Default NAPI poll() weight
- * Device drivers are strongly advised to not use bigger value
- */
+/* Default NAPI poll() weight. Highly recommended. */
 #define NAPI_POLL_WEIGHT 64
 
+/* Device drivers are strongly advised to not use bigger value,
+ * as this might cause latencies in stress conditions.
+ */
+#define NAPI_POLL_WEIGHT_MAX 256
+
 /**
  *     netif_napi_add - initialize a NAPI context
  *     @dev:  network device
diff --git a/net/core/dev.c b/net/core/dev.c
index 4086d335978c1bf62bd3965bd2ea96a4ac06b13d..496713fb6075bd8e5e22725e7c817172858e1dd7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6608,7 +6608,7 @@ void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
        INIT_LIST_HEAD(&napi->rx_list);
        napi->rx_count = 0;
        napi->poll = poll;
-       if (weight > NAPI_POLL_WEIGHT)
+       if (weight > NAPI_POLL_WEIGHT_MAX)
                netdev_err_once(dev, "%s() called with weight %d\n", __func__,
                                weight);
        napi->weight = weight;
