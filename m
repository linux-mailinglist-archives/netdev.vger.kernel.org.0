Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDDC63C052
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 13:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234568AbiK2Mv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 07:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbiK2MvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 07:51:24 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 765966036B;
        Tue, 29 Nov 2022 04:51:23 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id vp12so32246126ejc.8;
        Tue, 29 Nov 2022 04:51:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=G3Vianv53QwBde+4y0neO7GhKiBeHZDFK4V5XmXwBlA=;
        b=Om0IqUcy9EtT2JgNhJ3iAVIePbprp1q3op8g62egelwTGw1dI/yKkP4pKz6/Fj9l2W
         EUjhTSy9A7yWlzJyzPpsG8sEj5ZCfSQoBN4S9HePNz83TU63g+JcJA/NV6/bhdX+VGpB
         yhAQ3G+GYbbQ/ZCnxrWMhTgtcqc9CoSttmkluZjlisBqf+E8VeK7f7eN499Y/7C2LKSh
         b1Yj0/KT+PsqMJ8ifSDhLnm2gSxvScCvVtIyL3yhhf/Sl6oUXVy1Acunqqojn9UtwQtw
         sFLgOQXV2V4ZLLyhrNKSL2rgxDBl/txA/q/g1klgDNelp8g9+A5MdelPpWTodq415Tit
         5iLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G3Vianv53QwBde+4y0neO7GhKiBeHZDFK4V5XmXwBlA=;
        b=UfO9zejNstld079Y+3kiVDJVgfhhnzKK6lhZfD+mLCxE+a66ceeTWH/4qLQIHyhahk
         nO3zhlK2lepvx7eG32fZTJbCvmFdOXAGSF7Q02q8YtBuwb4UItlB4LIreeOFQnGdpxCy
         Pi3iW3ErNW7Nfh3IaES8X4Nty2Z69fIeC0pPHBVOf91h6PSnpYTQdJcOdwOFlRwMmGsV
         BdRAZfmZBQC6+ogPHGnMHFMVc1+ZGKKUuIgUsDkj9UIVAhvLUFSTpM1BG3EZhSEUDNXg
         y9ySXoDXMuM8wkJ/JWJOD9j1MUMw2LpriZtSWg6ewIbbq2HsCSjSE5BmL60KlZzimf1a
         sQ3A==
X-Gm-Message-State: ANoB5pkvuEOmhVUi3P2WEgydxX7p+UOHVhGR/0w0nUBdXU1AjYwONOHL
        FWfo0h+as0Nx+iYIHaXIVeM=
X-Google-Smtp-Source: AA0mqf5lUWfjY+CBqlqSkIGts0oT9WZu/+zq3r7ZpHANh/VrTcKxuYqlTwFiC/0oH0AEbg1BF6YZ/Q==
X-Received: by 2002:a17:907:2a10:b0:7a7:9b01:2a6c with SMTP id fd16-20020a1709072a1000b007a79b012a6cmr48029800ejc.153.1669726281875;
        Tue, 29 Nov 2022 04:51:21 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id g3-20020a170906538300b0078cb06c2ef9sm6107282ejo.8.2022.11.29.04.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 04:51:21 -0800 (PST)
Date:   Tue, 29 Nov 2022 15:51:18 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Jonathan Toppins <jtoppins@redhat.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next v2] bonding: uninitialized variable in
 bond_miimon_inspect()
Message-ID: <Y4YARi7a7ES00Y3q@kadam>
References: <Y4SWJlh3ohJ6EPTL@kili>
 <14024.1669660215@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14024.1669660215@famine>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 10:30:15AM -0800, Jay Vosburgh wrote:
> Dan Carpenter <error27@gmail.com> wrote:
> 
> >The "ignore_updelay" variable needs to be initialized to false.
> >
> >Fixes: f8a65ab2f3ff ("bonding: fix link recovery in mode 2 when updelay is nonzero")
> >Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
> 
> >---
> >v2: Re-order so the declarations are in reverse Christmas tree order
> >
> >Don't forget about:
> >drivers/net/bonding/bond_main.c:5071 bond_update_slave_arr() warn: missing error code here? 'bond_3ad_get_active_agg_info()' failed. 'ret' = '0'
> 
> 	The code around the cited line is correct.  A -1 return from
> bond_3ad_get_active_agg_info is not indicative of an error in the sense
> that something has failed, but indicates that there is no active
> aggregator.  The code correctly returns 0 from bond_update_slave_arr, as
> returning non-zero would cause bond_slave_arr_handler to loop, retrying
> the call to bond_update_slave_arr (via workqueue).
> 

Awesome, thanks for taking a look at this.

regards,
dan carpenter

