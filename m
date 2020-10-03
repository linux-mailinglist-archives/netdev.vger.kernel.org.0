Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA25282103
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 06:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725764AbgJCEGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 00:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJCEGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 00:06:21 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB3BC0613D0;
        Fri,  2 Oct 2020 21:06:20 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id s131so5482402qke.0;
        Fri, 02 Oct 2020 21:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gXxw7rC7rv1TmJd/44mHRsSi/DMr+bhaUgsuK3Cn9Y4=;
        b=hU59I8ceg0/PHLdko9tBe6VE9EbWHJ5xIByoI7qRD6nFaWQ/5Bpat6FYL6wx8TgBHD
         F/nHULNjYXRpRUBrHaszdR921Mitm6/6BjJpyU6bbcjYtFBLNRJ4wfbPLWxw8b7UC0i1
         6EsupVMOOo0Nxke9Lk597TZVNjkaliEyBR53933gVcjbkqD9aKq1PvHNbqQRt7Vl5zww
         iFk3aWK4R3t4vS0h2cSOX2j6zSS8wTfQ/XkQF+65cfYxmFJD2btjjcGJ1+q8DJCIKBYW
         W+OxpmKuH8J6oK4B5LUfd1pizaQdUGBEhxiwzdvTETv8JWIs0ze0+j5Q61M7gweuYjwD
         ldMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gXxw7rC7rv1TmJd/44mHRsSi/DMr+bhaUgsuK3Cn9Y4=;
        b=FeJ5XbXac933/YmH4Zjf5IkFwhmc0QhiNoYUW/XIFc0t5Xtd76Y17gxHXyo7INO7We
         QHxdtw8lM+AXbct2NpdE4UngAS8U5uxjQAkMCJxcmwLhlorUl+7S/oBuXPiHf6UNI8m6
         GBc1GFVhpQldvF5aPfTAmaVRTvFn69dHRamB+Lb6lT7NVJ+6dePqbLbsmPn1er/XaQop
         FSV6TT1cKaAllIapN+a4CS8/palng94iiHftViZ0UtJhmW4IE4unOc/S0d8TRpZtquWq
         TuS3VfS4lEnAzq8Xg/dAQC3LlKKtaHlJFDIMDlfQkNLYm5YuVDTceGYEbBd/GwhSjP7R
         8kEg==
X-Gm-Message-State: AOAM533x6ngKxnn+J0a0u6fmJ014AmNOGxt/0qrLhn9owMQnqJaVrc96
        nElzRWNNs6Wo0isEnxkVnMM=
X-Google-Smtp-Source: ABdhPJxJZStiCBL9LK2lyve/Yt90/nzyWLhNELFptexWCTzqHRobpuCy8wcDEI81HG5/pmCudAheKw==
X-Received: by 2002:a05:620a:1227:: with SMTP id v7mr5301978qkj.265.1601697979500;
        Fri, 02 Oct 2020 21:06:19 -0700 (PDT)
Received: from localhost.localdomain ([177.220.172.62])
        by smtp.gmail.com with ESMTPSA id z37sm2779436qtz.67.2020.10.02.21.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 21:06:18 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 5D9ADC6195; Sat,  3 Oct 2020 01:06:16 -0300 (-03)
Date:   Sat, 3 Oct 2020 01:06:16 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem@davemloft.net
Subject: Re: [PATCH net-next 10/15] sctp: allow changing transport encap_port
 by peer packets
Message-ID: <20201003040616.GE70998@localhost.localdomain>
References: <cover.1601387231.git.lucien.xin@gmail.com>
 <3f1b88ab88b5cc5321ffe094bcfeff68a3a5ef2c.1601387231.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f1b88ab88b5cc5321ffe094bcfeff68a3a5ef2c.1601387231.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 09:49:02PM +0800, Xin Long wrote:
>  static int sctp_udp_rcv(struct sock *sk, struct sk_buff *skb)
>  {
> +	memset(skb->cb, 0, sizeof(skb->cb));
> +	SCTP_INPUT_CB(skb)->encap_port = ntohs(udp_hdr(skb)->source);

Here it's in host order already. The fact that is does this
transparent update probably hid the other issue.

> +
>  	skb_set_transport_header(skb, sizeof(struct udphdr));
>  	sctp_rcv(skb);
>  	return 0;
