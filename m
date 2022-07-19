Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADD4957A045
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbiGSOCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233242AbiGSOCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:02:16 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06393DAA;
        Tue, 19 Jul 2022 06:13:41 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id k30so19500993edk.8;
        Tue, 19 Jul 2022 06:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WUbsObxlwNUc+uX38d0WkFQigiyo40r0eaI9dp9OC9E=;
        b=Id84D3On4wPf2/2IPr55TqCW4N+Oh9NfnWXCdFAMsTCTXszoCUbGlfYa30I/pOVNwC
         ewon/cZ2Av3d6wkFv2E2WZtkN9aBijksjS+lxxNlHrIbMs6zsjVAVFIUs5GvtLHy8Lrr
         4+on5n9OzbQn7bfRHzGKELrrzgdCv29kASi/bHsX9SggKstC8R+5qfQmyX0ledEn9G5w
         4fIsBwO700P0z8sG3dF+YoARLFfsy3eb6J7tGPQTH1coR04kIhPEwbgts2XOkSRFEjpI
         9g3//CGMnatLp8wfHTKg/fHBd0U/IV6UxGDZUOfjCT2fZtm+NAxZ/F04G41htfqCHVDR
         tM8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WUbsObxlwNUc+uX38d0WkFQigiyo40r0eaI9dp9OC9E=;
        b=SuSAZz502g1u14/kYafHLvImJu2cYEx+H71doOcID8zymxmY+8+jZC/bsZsp3P/k60
         v8EFmGFnm9TwU1aPq71RTuJyH49lL/V9oIt8/OCkmomDh22z1gcfRDTwf4nd+HgQ2aSL
         BFLXQr3KK3jtoNh1hFptbXbko7Ix8OlgpDAHZIBXge8d1qaOhJ5t8ucfyAn5j4MT5gSA
         q0av0++xpRs6IYX1q7c5bn+KUsQfQCxdjdqaYRYyre6qB7YJ0Sd1yAiAOhlLpAxv/MGk
         5GwiZpMUaRRkWDkevrjcbBVsdeEVXKrpvBnaxmzNwLROrnDOx6RJAVBjqUCOveIRnDdt
         iOIQ==
X-Gm-Message-State: AJIora/KHuRuDTqMcXVRMbp99nvWgTYLXbDrTUYwa41sojspb2j+LoPP
        VLjMeZDL04rx4sLiMVeOqgk=
X-Google-Smtp-Source: AGRyM1srzB2CZQcweHApMnAFUgYSdsRyUMSl2kUEUUAgyZww553aCaTTxbIPBygMGx46Cc5LObLZqw==
X-Received: by 2002:a05:6402:50cd:b0:43a:c694:9089 with SMTP id h13-20020a05640250cd00b0043ac6949089mr43786564edb.386.1658236418436;
        Tue, 19 Jul 2022 06:13:38 -0700 (PDT)
Received: from skbuf ([188.27.185.104])
        by smtp.gmail.com with ESMTPSA id wj18-20020a170907051200b0072af92fa086sm6674702ejb.32.2022.07.19.06.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:13:37 -0700 (PDT)
Date:   Tue, 19 Jul 2022 16:13:35 +0300
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
Subject: Re: [net-next PATCH v2 05/15] net: dsa: qca8k: move fdb/vlan/mib
 init functions to common code
Message-ID: <20220719131335.ef6mmakmiocb6cme@skbuf>
References: <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-7-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719005726.8739-7-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 02:57:16AM +0200, Christian Marangi wrote:
> The same fdb,vlan and mib function are used by drivers based on qca8k
> family switch.
> Move them to common code to make them accessible also by other drivers.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---

Make port_fast_age be part of this patch too, it belongs to the FDB
class of functions. This in turn makes it possible to avoid exporting
qca8k_fdb_access().
