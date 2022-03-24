Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58004E6B34
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 00:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355786AbiCXX0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 19:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355777AbiCXX0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 19:26:22 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE01EA6E34;
        Thu, 24 Mar 2022 16:24:48 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id u3so8675471wrg.3;
        Thu, 24 Mar 2022 16:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gbcTt7PKznp7xX+RFiZTZsMSrvKKcg7TzmpForC+1PE=;
        b=pk+WGrsKj3qCut+OpEUiMONYzGDxLCe28nEfSeRicBl7iAdnNx1FIt9Y6VoIeK/hpN
         bzlElI3gPgjuWPeS9WrEmd9qrHphTbLVLFv/36PrIsYsZFTx7NtQTLFFdEpZpRqkUxrO
         j4uPZ7C6qds17HW90+I1VLQg/a5Kp1ddXD/gBFSiYbtIXlc1iZ5UTKQSwgVa03+PVC8z
         5aisBxq4nPLGQlIBKaHY5HktI4ZcECLxwwx5Y/d8SUUGyBFUI5r3XTDUB1jUS7q/Z209
         p+I9L4NdIYTaz1Y6mjCzS5dp14KwyoGogKIVuGpdudlldBMv8z6CjXSKCwEMqxe0/3Vi
         U2Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gbcTt7PKznp7xX+RFiZTZsMSrvKKcg7TzmpForC+1PE=;
        b=Qr/cAlp0lDwEoNHIGo6WwTT/yh9+rqi6s9Yy9fRcmYf3EjCRwqECgW0jTWzCb1Gwt2
         ufzyYEzrpMzw/ZhJpqQxL7PWVjscNIwWWKvFqkQ3KmwDd0rAlhj2p1vp6Caf/VGUrifO
         u+0pEFiDzfvmKoU+nHXaWfLZlzJUf52depQt2B8icVScxEEfpEcLtc/fqURkpR6nU7pt
         4VyCOXrEafK+b0hfo35wr05jp6s45JHLFxpfoVA0XFO1xUoU4m3F6xysKU/S9Vrzk9yd
         sMmaExohUj06Zy6XMWWj/NmjY92yOPqIPq5mdUGVtWtznRI2wPCtSGQayo2bfhxg2lRS
         bEyw==
X-Gm-Message-State: AOAM532pr+NWpUtOdGx+NngS71nvYVR3EEAnDePp9mjYUidbrs4R472R
        1zf/c4FjXJc0huoiAuZc0lo=
X-Google-Smtp-Source: ABdhPJxdTzG8p4/+ibB3Lx6BrFZ2InqzINxR3UEr0PMSaa+mEOZBh4dKQbjszAubSP/awj35VKySIg==
X-Received: by 2002:a5d:5041:0:b0:203:ecc8:47de with SMTP id h1-20020a5d5041000000b00203ecc847demr6453284wrt.240.1648164286647;
        Thu, 24 Mar 2022 16:24:46 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-69-170.ip85.fastwebnet.it. [93.42.69.170])
        by smtp.gmail.com with ESMTPSA id i206-20020a1c3bd7000000b0038bfc3ab76csm3206042wma.48.2022.03.24.16.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 16:24:46 -0700 (PDT)
Date:   Fri, 25 Mar 2022 00:24:44 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 1/4] drivers: net: dsa: qca8k: drop MTU tracking
 from qca8k_priv
Message-ID: <Yjz9vNrHvFxCxAY1@Ansuel-xps.localdomain>
References: <20220322014506.27872-2-ansuelsmth@gmail.com>
 <20220322115812.mwue2iu2xxrmknxg@skbuf>
 <YjnRQNg/Do0SwNq/@Ansuel-xps.localdomain>
 <20220322135535.au5d2n7hcu4mfdxr@skbuf>
 <YjnXOF2TZ7o8Zy2P@Ansuel-xps.localdomain>
 <20220324104524.ou7jyqcbfj3fhpvo@skbuf>
 <YjzYK3oDDclLRmm2@Ansuel-xps.localdomain>
 <20220324210508.doj7fsjn3ihronnx@skbuf>
 <Yjz6WxkElADpJ5e7@Ansuel-xps.localdomain>
 <20220324231423.qyyyd72nn75i7kdc@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324231423.qyyyd72nn75i7kdc@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 25, 2022 at 01:14:23AM +0200, Vladimir Oltean wrote:
> On Fri, Mar 25, 2022 at 12:10:19AM +0100, Ansuel Smith wrote:
> > Ok i'm reworking this in v2 with the stmmac change and the change to
> > change mtu following what is done for mt7530. Thx a lot for the
> > suggestion. Happy that the additional space can be dropped and still use
> > a more correct and simple approach.
> 
> That's all fine, but if you read the news you'll notice that net-next is
> currently closed and will probably be so for around 2 weeks.
> The pull request for 5.18 was sent by Jakub yesterday:
> https://patchwork.kernel.org/project/netdevbpf/patch/20220323180738.3978487-1-kuba@kernel.org/
> Not sure why the status page says it's still open, it'll probably be
> updated eventually:
> http://vger.kernel.org/~davem/net-next.html

Thanks for the alert! I will send an RFC then hoping to get some review
tag.
About the html page, I was also confused some times ago where net-next
was closed and the page was with the "We are open" image. Wonder if it's
a CDN problem? No idea but to me that page looks to be a quicker way
than checking net-next last commit or checking the mailing list.

-- 
	Ansuel
