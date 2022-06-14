Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9DC54AE97
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 12:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239485AbiFNKkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 06:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbiFNKkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 06:40:39 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1426B396A0;
        Tue, 14 Jun 2022 03:40:39 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id h5so10729734wrb.0;
        Tue, 14 Jun 2022 03:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=BJB3Jj+W5NRHZEZPtOT6087E76LkDf+KkklgOlWVWzg=;
        b=Vx9jgtkwFhdUaWrGkqkzajXjR7Jmjk7cSeF52w5i5LknZZbrFOqcOkF7qZRpf/ga3x
         d4GtXKlDEaZ6mXMxClErNdgkth+XYPu0uG4P+rJYx9ylxK0o7iQLa8gOlrfTHjmi98j4
         Wh3H5GjFpxFsh9e16Xkmk89ceigDXefdv+XRR5mutiF6b4UrUZRWW2zO+CT9U2c24EoI
         Vj0q8tsyTfqWc6bBlRA8OXESzZXZR9iOzujRPJeEmNxr9w8h3N1uQh/li+mOiQ52xxAb
         A9rzOsVoaRmihLMnVqP4J5eu+vcoqxX9S6jVuIU8jRwG6CQ4TC1M5mJuwHKBkQHjVQzm
         A97g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=BJB3Jj+W5NRHZEZPtOT6087E76LkDf+KkklgOlWVWzg=;
        b=vDPHNDMu9lkJvaOlRYufa9vyp6n6uVl1r79v8yFXLQBbkFxaQCNfB5iZzOjhK5JkhT
         lmZgpGaDJhQ3Vlh3NLCIGrZCm19DZ2ZrhMLs6CyucK6zdmaOVb0XXQorUdIYiQ8+Jemm
         7nWBSxHRAsbumeAtf9U3uhpNCizwQqksIYXH2TQx5XA4UGnAVsZh4lHU/SqvHNUZFqzA
         TmBu/Xdm3b4Pi+YJGEitDU8egLcHeQ36ZGpfQu4gj0lbjuV3YIS1ahc5EUsoK71WIAlu
         t42/ZJmihqA3/hW8T2J0DGAgqS+oEIa4Tb6y6faNjBrxvrFXYp5I5YOXw7a9gBoZpnXb
         I3Wg==
X-Gm-Message-State: AJIora/0V4YS/eaZKGhfk5DXUxqfGdxT2Sa6iDDZg7ReXntkTW8n2tte
        83b09rq73g7rKrKqwDsdBXQ=
X-Google-Smtp-Source: AGRyM1uoZWrC1W/k512tGAzARKScdtlh9G+N0yFoFFFZiLcqKJi4jpBJsGpSKHqWRKl+/5ViIFOUHg==
X-Received: by 2002:a05:6000:1866:b0:218:40cc:a26e with SMTP id d6-20020a056000186600b0021840cca26emr4270476wri.678.1655203237290;
        Tue, 14 Jun 2022 03:40:37 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id f6-20020a05600c154600b0039c5ab7167dsm18006041wmg.48.2022.06.14.03.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 03:40:36 -0700 (PDT)
Message-ID: <62a865a4.1c69fb81.81506.21c5@mx.google.com>
X-Google-Original-Message-ID: <Yqhlo8WayYq+68ex@Ansuel-xps.>
Date:   Tue, 14 Jun 2022 12:40:35 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Mentovai <mark@moxienet.com>
Subject: Re: [net-next PATCH 2/2] net: ethernet: stmmac: reset force speed
 bit for ipq806x
References: <20220609002831.24236-1-ansuelsmth@gmail.com>
 <20220609002831.24236-2-ansuelsmth@gmail.com>
 <20220613224917.325aca0a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220613224917.325aca0a@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 13, 2022 at 10:49:17PM -0700, Jakub Kicinski wrote:
> On Thu,  9 Jun 2022 02:28:31 +0200 Christian 'Ansuel' Marangi wrote:
> > +	dn = of_get_child_by_name(pdev->dev.of_node, "fixed-link");
> > +	ret = of_property_read_u32(dn, "speed", &link_speed);
> > +	if (ret) {
> > +		dev_err(dev, "found fixed-link node with no speed");
> > +		return ret;
> 
> Doesn't this return potentially leak the reference on dn?
> You move the of_node_put() right before the if (ret) {
>

Totally right. Will fix in v2.

> > +	}
> > +
> > +	of_node_put(dn);

-- 
	Ansuel
