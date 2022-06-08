Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 264A1542ACE
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 11:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233840AbiFHJKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 05:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233193AbiFHJJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 05:09:18 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7343F114AAE
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 01:27:19 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id x5so20959235edi.2
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 01:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RO+2GICEalTGWxqDS+LJ84EPVrBk/pFANY3/dBpnczA=;
        b=iu/4+hXctfQAi/PtOuus7Ng+2TGisjH8LOIQ9UWUu2nOercAT2Cd30VUAnyTfknNLH
         WdK6uKicZdZC0TbPF5J7HIFl4TsLBF4H31zMAbmY0aCKC3xZ3e/ztKH5NIEPBPP6p5vb
         4E0qwO85pXzuGOofQC0LImH2xumsNiLSqpRYJAazUnZPeRKALEdhxmhv2HNaAAd67MB1
         xq8XigI4Rn4w7GBhBzsoZaK0ul6XLDXJTr0X/XG0srSvzlvnBiswdMZex1xSxz6yDNVL
         8SCfZe/q1NzKDkfDZHtQUZPwF1CzgjpFRnTfTTb2OeBSNcMUk7nUBDaqyDoOooU3ARJx
         s4sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RO+2GICEalTGWxqDS+LJ84EPVrBk/pFANY3/dBpnczA=;
        b=A7tonGhlFT36AiGJ5ZJXPwkwads8MSuZdO3xu+a/XQS7zUrO6hmRSE8pYm/rMon0zR
         cu5ZQklPYkdkt5Ajwt5mpYGeUtTEezDNhz67BEb+3+HpcPDRIitoXlSRFNlvRhvu7IbQ
         uASC6b8luSWO0+T42E56pv6PR3YWblAxR9GJ7knumh5LPex60/LbDI/oLy9KgHMss0FL
         ywEtxe6lvkqtkDT9z+0TsVLd2mWBYB1h93d7aLG5CZzkv3gCR+pUh+y6ZeIag3H0wpTa
         /BzLy/K6gb7jwAcnYFL8HFFCCm+Ei0iwVJzYPoiNFk6I98jHrsI+NDzOdeQ7OnVbwSRD
         I2Kg==
X-Gm-Message-State: AOAM533BhdjupcQCw8Z8v0p2UHso2ur+OB+w3fuK9tr9UeHiOjqOG9VY
        CFkfj6pz4cUUzPvYaH76BiJGzw==
X-Google-Smtp-Source: ABdhPJyu16RW47JnUBMKMuQ1vP3Jnqw3nPe2kNHMjMTrXF2Irw1fBYzJAanmcc85nOFSTAJtUYYUrQ==
X-Received: by 2002:a05:6402:241d:b0:42e:8f7f:3188 with SMTP id t29-20020a056402241d00b0042e8f7f3188mr29981202eda.78.1654676837684;
        Wed, 08 Jun 2022 01:27:17 -0700 (PDT)
Received: from localhost (37-48-36-122.nat.epc.tmcz.cz. [37.48.36.122])
        by smtp.gmail.com with ESMTPSA id n24-20020aa7c698000000b0042bb229e81esm11729464edq.15.2022.06.08.01.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 01:27:17 -0700 (PDT)
Date:   Wed, 8 Jun 2022 10:27:15 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, dsahern@kernel.org,
        steffen.klassert@secunet.com, jreuter@yaina.de,
        razor@blackwall.org, kgraul@linux.ibm.com, ivecera@redhat.com,
        jmaloy@redhat.com, ying.xue@windriver.com, lucien.xin@gmail.com,
        arnd@arndb.de, yajun.deng@linux.dev, atenart@kernel.org,
        richardsonnick@google.com, hkallweit1@gmail.com,
        linux-hams@vger.kernel.org, dev@openvswitch.org,
        linux-s390@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH net-next] net: rename reference+tracking helpers
Message-ID: <YqBdY0NzK9XJG7HC@nanopsycho>
References: <20220608043955.919359-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608043955.919359-1-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jun 08, 2022 at 06:39:55AM CEST, kuba@kernel.org wrote:
>Netdev reference helpers have a dev_ prefix for historic
>reasons. Renaming the old helpers would be too much churn

Hmm, I think it would be great to eventually rename the rest too in
order to maintain unique prefix for netdev things. Why do you think the
"churn" would be an issue?


>but we can rename the tracking ones which are relatively
>recent and should be the default for new code.
>
>Rename:
> dev_hold_track()    -> netdev_hold()
> dev_put_track()     -> netdev_put()
> dev_replace_track() -> netdev_ref_replace()

[...]


>diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
>index 817577e713d7..815738c0e067 100644
>--- a/drivers/net/macsec.c
>+++ b/drivers/net/macsec.c
>@@ -3462,7 +3462,7 @@ static int macsec_dev_init(struct net_device *dev)
> 		memcpy(dev->broadcast, real_dev->broadcast, dev->addr_len);
> 
> 	/* Get macsec's reference to real_dev */
>-	dev_hold_track(real_dev, &macsec->dev_tracker, GFP_KERNEL);
>+	netdev_hold(real_dev, &macsec->dev_tracker, GFP_KERNEL);

So we later decide to rename dev_hold() to obey the netdev_*() naming
scheme, we would have collision. Also, seems to me odd to have:
OLDPREFIX_x()
and
NEWPREFIX_x()
to be different functions.

For the sake of not making naming mess, could we rather have:
netdev_hold_track()
or
netdev_hold_tr() if the prior is too long
?
