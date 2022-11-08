Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E77620BD5
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 10:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbiKHJNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 04:13:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233339AbiKHJND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 04:13:03 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4546F1C115
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 01:13:02 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id kt23so36829035ejc.7
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 01:13:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ufVIoxwEXxgTh2/7bpWdKQTyzJOQN3AhET3ItjQPSfA=;
        b=O+WilHJwMlARzL1I5hkP4S4pnq1B0I80Q/h1nFMhk68x1FXk6BSxzX/YbHxdh7OSYg
         d0/03WK1wqxS/flZmbMlfqrIuF4G9AZk2qqnSvdHfMJs1Lz6D8opUXUDdpVnjZg71KcW
         1CokJhUBf4XAhv8/FdsGPLUAMot8z9ZebJ7loYlPqeyHJHWCWYwU8wqCe5P9PwH2mBmn
         iHbPuqalwa8GrH3fWHGIzwUn0EbLdWnrH3uNoWACwcFvc9mAG+mmGqzfUHtdxph0Rk0p
         RgBp0cESkiHjwDHFI7+V4Szl+pqpIe4AgdIy8NXuY2dp7a2Ogfbe4yVYoiFQDO3sG25g
         PrQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ufVIoxwEXxgTh2/7bpWdKQTyzJOQN3AhET3ItjQPSfA=;
        b=K5eyHhVic0l/WxIz94ZCcMpUV8Ltk8VyBWw/ZFA30cm8kerxWMHWmKLGe3mzsAvizL
         A0t9ZY1wB5zRZxE3YkaKb7+YvSy65puBrBxoVl2kGxc+x1/3rZk9F/QPu9fyMYJehM48
         6F2I5MjuYqqT18VJwdIO/hH6ueYjNs13vsHYdTS5yBbOtLSQ+XZPbs5TL5IChkgiaFre
         ARoAXfcW+zTptki2x13QuXTphwuHv2FxS5W0viGINCkC5H5474W9srsEZKAahGzW/KGK
         ebBlNRpt0u258v6OVcEPyQqaLH/Q8iINT+nvvudze+HPf12PfP0wkCydgA3XDP57zgCu
         ndCw==
X-Gm-Message-State: ACrzQf3WftijuM2jtclo6DC+R3NH6GuTWEyq9s9ZhOvTRlhmLMbMg610
        4i6SuwZoANd/vCe7UdbjVXA=
X-Google-Smtp-Source: AMsMyM5xv7sDFbPPVqkcXB6mtfYaKYb6yQAUrytGzwE3CwsKA411CdMaXpOIVnXXhGY5oEdVLRd+zQ==
X-Received: by 2002:a17:907:9603:b0:742:9ed3:3af2 with SMTP id gb3-20020a170907960300b007429ed33af2mr51458660ejc.510.1667898780656;
        Tue, 08 Nov 2022 01:13:00 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id s7-20020a056402014700b00461a98a2128sm5243486edu.26.2022.11.08.01.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 01:13:00 -0800 (PST)
Date:   Tue, 8 Nov 2022 11:12:58 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: Re: [PATCH 1/9] net: dsa: allow switch drivers to override default
 slave PHY addresses
Message-ID: <20221108091258.iaea3dhkjcuandvb@skbuf>
References: <20221108082330.2086671-1-lukma@denx.de>
 <20221108082330.2086671-1-lukma@denx.de>
 <20221108082330.2086671-2-lukma@denx.de>
 <20221108082330.2086671-2-lukma@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108082330.2086671-2-lukma@denx.de>
 <20221108082330.2086671-2-lukma@denx.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lukasz,

On Tue, Nov 08, 2022 at 09:23:22AM +0100, Lukasz Majewski wrote:
> From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> 
> Avoid having to define a PHY for every physical port when PHY addresses
> are fixed, but port index != PHY address.
> 
> Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
> Signed-off-by: Lukasz Majewski <lukma@denx.de>
> [Adjustments for newest kernel upstreaming]

(I got reminded by the message)
How are things going with the imx28 MTIP L2 switch? Upstreaming went
silent on that.
