Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4196E4720
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 14:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjDQMHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 08:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjDQMHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 08:07:13 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926E29763;
        Mon, 17 Apr 2023 05:06:19 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-5068e99960fso1751672a12.1;
        Mon, 17 Apr 2023 05:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681733157; x=1684325157;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O57mrzEQl+JYaGZtJy1x1lN7X8uESH2irzWiTH+Xp+Q=;
        b=Jo8IqV3oexSFcEqeoV+4+YpqHqPG2p92tFC9VUcRyc+h2URtMupbe8Bfc+cc0ItBFz
         BKsVT+RupmOjoU1iFAk3PqdpqeTWjVIKR4MyROo7brETGPiaUq+OyzYCoUfPauOZIi1q
         GeB38FbUVTEdJP98GRtb+YcE/FHtQVYoW89V8VZkBeIIr5TAxQOy9JFwSQ3P+Wz/lSPw
         3MCiXb+EG6Bh7wpWSD5abjVtndUwutdx6YcU6XM+jcTIfmYXrppg285EAGoSGGnC1CRw
         rfsvH6TeR5U23GmQESSDy2bpn2vMNfoTVfhKWhbczsfcYy8lXULIJUCsssVDnZqxbIrN
         dLLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681733157; x=1684325157;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O57mrzEQl+JYaGZtJy1x1lN7X8uESH2irzWiTH+Xp+Q=;
        b=U+4LtLfGGqnd9ziJxU5+VhZnOfqXmnJ5MYEHtAbcx2NN4/spaJmEGZXLCnsiKSlNXb
         wB17NgK9Q0NkaflQ9eIG6rs/bvi7tyx4KAjgPJgxlwtMTEnO385jLt0VQtWm1r2V8LFe
         m0nwTu+BxQN0deGFJg1DA5LwKnOopAz1VXhRwMyN7qkcevIh/Um6rvkUqtIxNmB8GUtQ
         NT/Vo1g4WEaAxQPGRGO3rVceHaMbQKbadqJL+jdEmFutFnH1fwSJxSdMx98EHKVm3leQ
         1aIM4RVfyrj8O6+sugcNX4LwU1VNrgnTycodbcZPsfUy1RlAwXaUk+H5nEtuQAphxftP
         jnhw==
X-Gm-Message-State: AAQBX9dAtkNFNWxsiY1I6wxIzQnoih3cL9/7990U+6xqaf2CdLANVsqv
        j/0li6Ag4luA5enDWy13tvM=
X-Google-Smtp-Source: AKy350ZAbDAIhMZVPC8n5UW+zY/RbI8RX+dj65L+OtuCGWPqu9VvUOvbBo57seJSsSn7ixoNfEt6gA==
X-Received: by 2002:a05:6402:12d2:b0:506:843f:8017 with SMTP id k18-20020a05640212d200b00506843f8017mr8726747edx.3.1681733156904;
        Mon, 17 Apr 2023 05:05:56 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id q1-20020aa7d441000000b0050499afe96bsm5776144edr.10.2023.04.17.05.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 05:05:56 -0700 (PDT)
Date:   Mon, 17 Apr 2023 15:05:54 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v1 2/2] net: dsa: microchip: Add partial ACL
 support for ksz9477 switches
Message-ID: <20230417120554.gyrintyd2urredak@skbuf>
References: <20230411172456.3003003-1-o.rempel@pengutronix.de>
 <20230411172456.3003003-3-o.rempel@pengutronix.de>
 <20230413042936.GA12562@pengutronix.de>
 <20230416165904.2y7zwgyxwltjzj7m@skbuf>
 <20230417114130.GB11474@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417114130.GB11474@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 01:41:30PM +0200, Oleksij Rempel wrote:
> According to my tests, ACL has higher priority compared to 802.1p module.
> 
> dcbnl is a new word for me, will need to understand if first :)
> What is the best example to use it with DSCP?

https://github.com/Mellanox/mlxsw/wiki/Quality-of-Service
tools/testing/selftests/drivers/net/ocelot/basic_qos.sh
