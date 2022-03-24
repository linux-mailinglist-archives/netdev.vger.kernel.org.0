Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D17E4E6B14
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 00:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355673AbiCXXQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 19:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239206AbiCXXQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 19:16:01 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B673DA43;
        Thu, 24 Mar 2022 16:14:27 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id k10so7361838edj.2;
        Thu, 24 Mar 2022 16:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SedGnKtgy7D4uHn/EAVxLJ+phxDEmsyN4o3d2Fi1R5w=;
        b=YCBsm9/45JrFckeFsVcUzxSAY7xGlJVbCYPfU0b81OCTv04YuLdlcguOqtSNJ5GPRm
         NhIhAUfE38aNNdTOKDu2RB6vV643Ks+oLn5CsPzr4kmBRYSPQ7Nj9pElgGzaCkWupQUD
         Y37dE0wwkSRFDubphO26t2zsA2L/Ox2yfmjabetwvypPtgizW9crULqkZ7ZxHjC0tr8o
         GGow81Kvu2i1esCHPkGChQddYimAwfN+Tjt7QINMwCWkYLoiXbt9QRek2NuFF7mnkzcp
         he0IWU1xh0uYlnGK/EthT/FRPsiBjog1vpGv6julnIxefl5G4CrWTa2WYNBQ1TGciFdz
         FaaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SedGnKtgy7D4uHn/EAVxLJ+phxDEmsyN4o3d2Fi1R5w=;
        b=PM2DDW8nGG4D0U2OGEEvfcRfTWDKqXZ4L0P+JVA544DoQzswaL+bGhODAtd3iY4jRU
         nPgwKFomwq3/C0YlwY6QINlyOd3TuitPXod3TFWKXGUpKZTR9WJC5xcoy7kRMoAXEa2j
         LO/czBieLW4amxP9Qhg6vcjHiVP2HssZWM/eUEmuScqNiH9MNToH5yPmYoDJw+WPsey1
         LTwJ32JZVU2KkfwaJPTTJ4RJKqKzgPxjWXQtx0USQ9VrmdyNWcZKvHlgbY64V4FIJJ2G
         0/WJ3MhPqPPIvGiYz65AlS3+Pfba0bufqoZ8ahCJqVm7AP5mT0GeV0RQSBxT4HliWVfh
         eizQ==
X-Gm-Message-State: AOAM532CF2dYkRcxlM9dAekX7+RWAWysLyFrXF0459kvbk2pigZg0+BO
        J4MBccSDvpUgCLen5getPlQ=
X-Google-Smtp-Source: ABdhPJy8atCAxCCGe8u38MQ6DSrri9I7C+5EsHWFYZBSzI0+hkRfKTnDFLpAM1P1yEMsf1GhkF9ktQ==
X-Received: by 2002:aa7:dbd6:0:b0:408:4a31:97a5 with SMTP id v22-20020aa7dbd6000000b004084a3197a5mr9614328edt.186.1648163665968;
        Thu, 24 Mar 2022 16:14:25 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id k7-20020aa7c047000000b004132d3b60aasm1993858edo.78.2022.03.24.16.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 16:14:25 -0700 (PDT)
Date:   Fri, 25 Mar 2022 01:14:23 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 1/4] drivers: net: dsa: qca8k: drop MTU tracking
 from qca8k_priv
Message-ID: <20220324231423.qyyyd72nn75i7kdc@skbuf>
References: <20220322014506.27872-1-ansuelsmth@gmail.com>
 <20220322014506.27872-2-ansuelsmth@gmail.com>
 <20220322115812.mwue2iu2xxrmknxg@skbuf>
 <YjnRQNg/Do0SwNq/@Ansuel-xps.localdomain>
 <20220322135535.au5d2n7hcu4mfdxr@skbuf>
 <YjnXOF2TZ7o8Zy2P@Ansuel-xps.localdomain>
 <20220324104524.ou7jyqcbfj3fhpvo@skbuf>
 <YjzYK3oDDclLRmm2@Ansuel-xps.localdomain>
 <20220324210508.doj7fsjn3ihronnx@skbuf>
 <Yjz6WxkElADpJ5e7@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yjz6WxkElADpJ5e7@Ansuel-xps.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 25, 2022 at 12:10:19AM +0100, Ansuel Smith wrote:
> Ok i'm reworking this in v2 with the stmmac change and the change to
> change mtu following what is done for mt7530. Thx a lot for the
> suggestion. Happy that the additional space can be dropped and still use
> a more correct and simple approach.

That's all fine, but if you read the news you'll notice that net-next is
currently closed and will probably be so for around 2 weeks.
The pull request for 5.18 was sent by Jakub yesterday:
https://patchwork.kernel.org/project/netdevbpf/patch/20220323180738.3978487-1-kuba@kernel.org/
Not sure why the status page says it's still open, it'll probably be
updated eventually:
http://vger.kernel.org/~davem/net-next.html
