Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27708552E1D
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 11:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347640AbiFUJVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 05:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347572AbiFUJVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 05:21:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 02B921BE8E
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 02:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655803293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nZOnEd74AQXFhcjq0gPeO6ZcLl20MXq+9CAW4kUHPhk=;
        b=bP4VZYLeV8mG2TsyncujKqIzGovpDn8muWCSS+pQ6lgUQnXI1Kvh4jymJ9HeZkpnjsGUt5
        WBf20J4DvrZHTDXvTqrFTTDLrADrkhu8/dHzfz0aMTWXvvnMnfwJbGh16WGVc+9/gxiCjV
        ZesPuohezKhbMNG6tiLloZsvKSTnb98=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-224-7ZPLM7snOAWjue3S7KmG_w-1; Tue, 21 Jun 2022 05:21:31 -0400
X-MC-Unique: 7ZPLM7snOAWjue3S7KmG_w-1
Received: by mail-wr1-f70.google.com with SMTP id n5-20020adf8b05000000b00219ece7272bso3054228wra.8
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 02:21:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=nZOnEd74AQXFhcjq0gPeO6ZcLl20MXq+9CAW4kUHPhk=;
        b=eJU1jZRLyxo1mn/4Mq6wydKlSH/ANhL4g/rfAEefbHIyWYnj047jvE/HhMv6wBtNFK
         YQGkLdhHhTWevQAG1UAWUzm4tLBd5ILMQSA+A6vDD28zFYHyg83UdrPrNR2k22Q51v1K
         BW8MPVH82x0JJYbnaGLsqeS0fDVGwG3RGlNYzCbjZIGH2e/uYP8DtzBCAYQBW46pP73a
         nllK71hEzpjwBd4vwAaGRQTgOoL72YsNX1UahWbw2qhJ0/yy04/+KOMXBo0CuR2c+54Q
         Pph4mBeDdCGAVMocsNCTsI8terqDeuheqWrOyGBOXddO/p2pAc/CHZsskIssAKvqHb3Z
         ul7A==
X-Gm-Message-State: AOAM5307jXoKp8nkSRrEe4mMLBwtVHXh3rnJIUN00hUSljL7Dugc8+Bg
        JAvwfeaJFFtbE4V5O/40wzs/fvO27c7nZvzFuBP22hUmUtET4qwHNXA53HalmcVbdQmEtXtkWIr
        gz475svCG2sBV72eb
X-Received: by 2002:a05:600c:a02:b0:39c:97cc:82e3 with SMTP id z2-20020a05600c0a0200b0039c97cc82e3mr39876263wmp.97.1655803290388;
        Tue, 21 Jun 2022 02:21:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzeWEb14IQVnJ9AjJIo2N9ZYd0FG0oy4UPixklFrrgEsbGmxMSJZOCrJEXTWsw7jqPT7S+04w==
X-Received: by 2002:a05:600c:a02:b0:39c:97cc:82e3 with SMTP id z2-20020a05600c0a0200b0039c97cc82e3mr39876245wmp.97.1655803290172;
        Tue, 21 Jun 2022 02:21:30 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-113-202.dyn.eolo.it. [146.241.113.202])
        by smtp.gmail.com with ESMTPSA id q18-20020adfcd92000000b00219e77e489fsm10436658wrj.17.2022.06.21.02.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 02:21:29 -0700 (PDT)
Message-ID: <58f36d9554cb3dd19d52373f9496cd230ed48423.camel@redhat.com>
Subject: Re: [PATCH net-next] net: warn if mac header was not set
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>
Date:   Tue, 21 Jun 2022 11:21:28 +0200
In-Reply-To: <20220620093017.3366713-1-eric.dumazet@gmail.com>
References: <20220620093017.3366713-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, 2022-06-20 at 02:30 -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Make sure skb_mac_header(), skb_mac_offset() and skb_mac_header_len() uses
> are not fooled if the mac header has not been set.
> 
> These checks are enabled if CONFIG_DEBUG_NET=y
> 
> This commit will likely expose existing bugs in linux networking stacks.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  include/linux/skbuff.h | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 82edf0359ab32d0d7cd583676b38d569ce0b24cc..cd4a8268894acce4bde16dc0fedb7eb13706f515 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -2763,8 +2763,14 @@ static inline void skb_set_network_header(struct sk_buff *skb, const int offset)
>  	skb->network_header += offset;
>  }
>  
> +static inline int skb_mac_header_was_set(const struct sk_buff *skb)
> +{
> +	return skb->mac_header != (typeof(skb->mac_header))~0U;
> +}
> +
>  static inline unsigned char *skb_mac_header(const struct sk_buff *skb)
>  {
> +	DEBUG_NET_WARN_ON_ONCE(!skb_mac_header_was_set(skb));
>  	return skb->head + skb->mac_header;
>  }
>  
> @@ -2775,14 +2781,10 @@ static inline int skb_mac_offset(const struct sk_buff *skb)
>  
>  static inline u32 skb_mac_header_len(const struct sk_buff *skb)
>  {
> +	DEBUG_NET_WARN_ON_ONCE(!skb_mac_header_was_set(skb));

The patch LGTM. 

I'm wondering if it's worthy adding similar debug checks for network
and transport offset (with more patches). e.g. still in
skb_mac_header_len():

	DEBUG_NET_WARN_ON_ONCE(skb->network_header < skb->mac_header);

Thanks!

Paolo

