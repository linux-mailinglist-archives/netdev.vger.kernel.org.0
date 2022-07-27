Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B15EB5828F7
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 16:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbiG0OuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 10:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232508AbiG0OuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 10:50:09 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56BCE1E;
        Wed, 27 Jul 2022 07:50:08 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id tk8so31877690ejc.7;
        Wed, 27 Jul 2022 07:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fHxG34E3tP9bUskLk8BO24fMW4a3kedY+AgkS1+8NDs=;
        b=K2EuCPdUuCdKrRdupio2gYy/Pmk68f6TldEk+hC6l663/Oym4/kw0+qrz/hhIuWRkI
         WwX6eK/ci6sEDq31YkMFNtsGP5K8w1XctVafudSO5wl+rcw8mfZh8hOYYegaj7zAtdK2
         S+l7TEF3ikjdS7Fyi7ug5Y18qrg/fiYS8Et/aJm0kQhs20RPGUjFtnKLMCLUasKayRRC
         kusKiu3ttp1DP8FQO7MLnUBUw7bEEeqIxfv4HhpDCxh8an17FRP9g++PSZmpcGdWkR+u
         kXw7LbciY3YyhyfXLJAIVl2BEMRi9VFPSqb708BKBPVBuA8sjc36cLqFqXWr1SXuxhtx
         jb8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fHxG34E3tP9bUskLk8BO24fMW4a3kedY+AgkS1+8NDs=;
        b=UpgzfqNbichGIH72VOoadHiGFMp9wnwuDyzcuUPuMyyyZludsGcfcIvYEcE8fenOlW
         fiW9l8mAK+YGhYCWQRJcrRt94MtiADF9fJlKP87xoZnhvxkE0WlgYNli3acWrOcb5nLg
         J3HxImagFZDb1gWaOy4kT9DT36diJ9ARFDlD/nojLLxBdlBcGX0ERQevLxp9jsC37LJP
         QXyBIDH1vY1ct9f+ZdWuO4/IEf8ER03g6zM60J6Z9kdJdqpuDALPbfo9fThpDTd8TJYj
         ty53tIAye8+ImBxwyaY2pWou5QSahxpGUlqaMk9Ax1j9DLfggVZKFgco4zAa8vEphnJg
         Vj8w==
X-Gm-Message-State: AJIora9sbaLaGhZfW/EOXZi3jVm4kQgRcEB4j6bRxXzEE3xMXavikrgP
        t/5YOY+mkugCCbcRV6vCaE4=
X-Google-Smtp-Source: AGRyM1vL/Mp0+Xm2RfJ993f1+fQLomAJ4TxqnUeS4sd83s7mZYWMbdHmtFcifHxuQ+H/u4drfUOm2Q==
X-Received: by 2002:a17:907:72cf:b0:72b:9943:4caf with SMTP id du15-20020a17090772cf00b0072b99434cafmr17382372ejc.370.1658933407073;
        Wed, 27 Jul 2022 07:50:07 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id n9-20020a056402514900b0043cbdb16fbbsm1005761edd.24.2022.07.27.07.50.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 07:50:06 -0700 (PDT)
Date:   Wed, 27 Jul 2022 17:50:04 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH v5 01/14] net: dsa: qca8k: cache match data to
 speed up access
Message-ID: <20220727145004.7bywtng4emuanbuk@skbuf>
References: <20220727113523.19742-1-ansuelsmth@gmail.com>
 <20220727113523.19742-2-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727113523.19742-2-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 01:35:10PM +0200, Christian Marangi wrote:
> Using of_device_get_match_data is expensive. Cache match data to speed
> up access and rework user of match data to use the new cached value.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
