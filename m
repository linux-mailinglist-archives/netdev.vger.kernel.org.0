Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 209A757A0C4
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238903AbiGSOJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239017AbiGSOJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:09:13 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095AC54648;
        Tue, 19 Jul 2022 06:26:19 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id tk8so15802141ejc.7;
        Tue, 19 Jul 2022 06:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4IggUsttmS8IRj/MLnGlpCkdusK1nVkc3vXajVwbtZc=;
        b=EcI2q2oWrzWeNnUKZw1gOe6LKladc48VXtX/lO8prfBUGiOdjbmZv8n9An6kodJHzN
         hRpBc6puDfX8vsU2MipHqHgkKdmsfBwAZuOSjj9uAbGt1YpZmk5douqlpB3RwKLKJhq5
         ByZ68YOaZbqxQtqlLBBO7Ze0LWGZAFtYSG6pPokkZbDfTgc1LkOV/pYuCrco3V9JvlNf
         UdvXOMNdBaQk+UOLw551H5ZpUgrOBoFyyK5NT7sTr9HWB9Aci6LR99B4Br9MUfCISxwh
         GKjUEv40LrbMzauJdRHkBl1ko9NlXhYg+P6eyaKV2q8iaKGLbMWMRlQakm73zOm/81Pm
         ugVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4IggUsttmS8IRj/MLnGlpCkdusK1nVkc3vXajVwbtZc=;
        b=pVDa8WbDjZWIznbms14/XnVJAC1fYKDTCFBqc36IUNY5kS23bEONNv69pOALPuOg7I
         6ArrgBr0ypKkOHRu/CD+yYq7Xu+QkeBB6rpTHrH8GppfCRB7WPmPQi3mepzTjQ72iMpR
         B0uaLpVdAFWoFwi2k8e0BddaUtDEVRkGhsFpl/Eq1PszPTEig6MKg2IXxTE3fYoGLPLw
         7Ex0lxZyMtnf2ZMFhL0Do66vw15ma1zbW+Lfr2feO//L0+fWFgin6L1sfMIpA5Z758nb
         Oq3Uqn9g8f7SjUuW1kGUHTr1pGdUBBoztdVrNBuN9GwS648XhZP/0y2k0uY+m63BdE74
         j5pQ==
X-Gm-Message-State: AJIora9mpKORSZksK6STV4FgNRx3L/dBYKD00ZqUZYPrdaLl327fw54D
        ZB16Z9od6tx86E9/VZZBog0=
X-Google-Smtp-Source: AGRyM1vAAcrSN2UOChDzYoPNcAk4Rlu1hChwYLltw27SJoH7j4RvuG6PIaWyF3CCrfey5nvr+teI6Q==
X-Received: by 2002:a17:907:6e02:b0:72b:9f16:1bc5 with SMTP id sd2-20020a1709076e0200b0072b9f161bc5mr30632105ejc.676.1658237177644;
        Tue, 19 Jul 2022 06:26:17 -0700 (PDT)
Received: from skbuf ([188.27.185.104])
        by smtp.gmail.com with ESMTPSA id la15-20020a170907780f00b0072aeda86ac3sm6841667ejc.149.2022.07.19.06.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:26:17 -0700 (PDT)
Date:   Tue, 19 Jul 2022 16:26:14 +0300
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
Subject: Re: [net-next PATCH v2 13/15] net: dsa: qca8k: move port LAG
 functions to common code
Message-ID: <20220719132614.4mb3vzix4qnaehiz@skbuf>
References: <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-15-ansuelsmth@gmail.com>
 <20220719005726.8739-15-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719005726.8739-15-ansuelsmth@gmail.com>
 <20220719005726.8739-15-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 02:57:24AM +0200, Christian Marangi wrote:
> The same port LAG functions are used by drivers based on qca8k family
> switch. Move them to common code to make them accessible also by other
> drivers.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
