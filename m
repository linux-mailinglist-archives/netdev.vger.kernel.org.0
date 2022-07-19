Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91C2B57A0D0
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239063AbiGSOLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238833AbiGSOK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:10:27 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF7AA19C;
        Tue, 19 Jul 2022 06:29:35 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id v12so19586103edc.10;
        Tue, 19 Jul 2022 06:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7WHAfOkhC9F+z/OW67LryPBcqkUfwOKddTQPn9vK3kE=;
        b=bZpu4dW/HUvkf0L8vIVI7WkLRas6LDpQyyvRSBelZioFpjCA/ApzeoYg+UwcC6m2tk
         V9c3v+SIvzJHtmcKPZsS+gZq4IWKh5vqfPSVf94Pda1yUB6iz4o7BIjN9LZQD0qj8V17
         D+1Py/tWRL9t4nKofJAz9pPcDkCXJu+V/EfYoPBYMqyjzGdYno6x4ikhAt/EvhWIHgkv
         xOLZ/7ZXz8RBgKfFMqy1uBv16c+9kMkZhAgnAbmuQowRdrOS/Dwt4h1KUxQq9ihwGLK9
         Dk6fs3zqAL9+uP9Vvksjb+bvAdZqQKzv6iev6uaFHGK+e96SV141COVGMeoLynjJfrKw
         Jp6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7WHAfOkhC9F+z/OW67LryPBcqkUfwOKddTQPn9vK3kE=;
        b=g2a5VTLIilueWN/ZWGhfKmbGIrd9IIU832m7XIeEMIZojf3ycedu2FdoAY1icTUPsS
         abZMgPzm0I67A69q66WrfovpMHTBITEcFrGsYVLUrhszED2hVZcWf8qaUqdPrePBFDsq
         wNDo7axUtsdVuQCVTrWFLKv+LQDPnbKqJDuJ+vPw2kRj352hy6+rbLqnbUxyCtFr/nF5
         TDOx6QADVSpexxv85mWGxMmsP2wQ7J8lrL15zZv/RbfhTCiBTA+XO+Qpc6I6gYCdtzzn
         rkr/RVg8SMn3lgrhm+YpPbPoWUkbXL1ynEoao9Q0V/cEdDldJ/u9GHI2vNXWdb879ReY
         Sk4w==
X-Gm-Message-State: AJIora/NCr0wZ2wMq3JGGwBfctuODwu6QUAN+oqUqoiTMSSKbQ7TQeJ+
        Hq5b1QdBssC7QCRXkeEfm9w=
X-Google-Smtp-Source: AGRyM1toR1MOX85UnnhHil3dzsAdsJ0gH7b7cs2+TwebFqyUxWjtSYHTfvnuCev3a77yLoGEJl63RA==
X-Received: by 2002:a05:6402:ea7:b0:43a:ecea:76e with SMTP id h39-20020a0564020ea700b0043aecea076emr44761193eda.77.1658237374195;
        Tue, 19 Jul 2022 06:29:34 -0700 (PDT)
Received: from skbuf ([188.27.185.104])
        by smtp.gmail.com with ESMTPSA id w6-20020a50fa86000000b0043ba0cf5dbasm729892edr.2.2022.07.19.06.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:29:33 -0700 (PDT)
Date:   Tue, 19 Jul 2022 16:29:31 +0300
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
Subject: Re: [net-next PATCH v2 15/15] net: dsa: qca8k: drop unnecessary
 exposed function and make them static
Message-ID: <20220719132931.p3amcmjsjzefmukq@skbuf>
References: <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-17-ansuelsmth@gmail.com>
 <20220719005726.8739-17-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719005726.8739-17-ansuelsmth@gmail.com>
 <20220719005726.8739-17-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 02:57:26AM +0200, Christian Marangi wrote:
> Some function were exposed to permit migration to common code. Drop them
> and make them static now that the user are in the same common code.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---

Hmm, ideally the last patch that removes a certain function from being
called from qca8k-8xxx.c would also delete its prototype and make it
static in qca8k-common.c. Would that be hard to change?
