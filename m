Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7475A4BC790
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 11:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241864AbiBSJ5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 04:57:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241865AbiBSJ5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 04:57:12 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1FA50E2F;
        Sat, 19 Feb 2022 01:56:53 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id hw13so20526416ejc.9;
        Sat, 19 Feb 2022 01:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y7dI/kyXtQ5r7J/1JCw2+N0TiORB8W3a63ggFTECDo4=;
        b=ZA9bzecfezxlqpIiccEI1K27SXLtnJUjvIEbkbGMkLbgdFc1iGqVU85mJgKlmd27Ss
         HiozbCv7C4S2YiTIssUYYUrd0zqxKkMq6vZp4b0cc50nSW9sRoZd1xATLPxnA8jK7wLF
         XY4FIbMD9X2B0LBasRTc3GMGMw8dHw1M9eL8AFSUBju46diRXcQtCFpV7+jUvB5E5N9i
         1XzzVYYVTWtDWd5gJTGboaBXVKZYhalyZNB8qRLe/rMs4QA5+LG75iWuzuV+EEGww2Ua
         pYVu/YUJK7gKO3hNz6QCVJP9y7Bybqbrbr980TjsvqkWiuKlhznug6XWMkd5seDCAUXf
         u5Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y7dI/kyXtQ5r7J/1JCw2+N0TiORB8W3a63ggFTECDo4=;
        b=sIscs2HmIkRdVEpgqRI2UkGhUPSoDmE/JW6M6F7SLi6sDok6OZ53STYHMCVUQPEqGD
         Yw7j11Mun2Emsl8Hz+qsHH/lp1wsKXhffUd55FyfwZcuKT4BqQkNXDi8MbYqTkXv5vxx
         GlFf2FNYM7fWXayyHMlPo5jNCi66aNVAv+rKFpBT1BTphtZxrIN09Y1HW465DpvGtK37
         V5+2ZZbqnIItMzFG2GWyq4LvNLl/vXokKYtUDiA8zC9HLuO5HG5TbCHbIB+k/1bR1r5a
         wKP2ctrUF1lLx7NF98Cc7LQuqN6A2ZRHv5ERKUCSteVnb2gDiKrGTnSbiSKpNrLHrSvP
         pOew==
X-Gm-Message-State: AOAM530ULlhd2D3I8QTOqqBAp2+3QhZCj0NMX2otuM7/FApZUdEYZu92
        GFN27TvXWC7NRRk5T7Amp14=
X-Google-Smtp-Source: ABdhPJw4Qrnkv2nVfARx+UT+8eb2/HWEusUffAfr14s7FY4OFC+GO4J8rN+JqiY75Bv0rz9G6LWSxw==
X-Received: by 2002:a17:906:2f97:b0:6ce:3ef6:94be with SMTP id w23-20020a1709062f9700b006ce3ef694bemr9519064eji.136.1645264611500;
        Sat, 19 Feb 2022 01:56:51 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id t4sm6165304edd.7.2022.02.19.01.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 01:56:51 -0800 (PST)
Date:   Sat, 19 Feb 2022 11:56:49 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Po-Hsu Lin <po-hsu.lin@canonical.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v3 3/5] net: dsa: Add support for offloaded
 locked port flag
Message-ID: <20220219095649.zaa7exduogwbpyyh@skbuf>
References: <20220218155148.2329797-1-schultz.hans+netdev@gmail.com>
 <20220218155148.2329797-4-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218155148.2329797-4-schultz.hans+netdev@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 04:51:46PM +0100, Hans Schultz wrote:
> Among the switchcores that support this feature is the Marvell
> mv88e6xxx family.
> 
> Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Although this doesn't "add support for offloaded locked ports", that
passes right through with no DSA-level filtering, from
SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS to dsa_port_bridge_flags(),
to ds->ops->port_bridge_flags().

Rather, a clearer description of what this does is:

net: dsa: include BR_PORT_LOCKED in the list of synced brport flags

Make sure the DSA switch driver gets notified of changes to the
BR_PORT_LOCKED flag as well, for the case when a DSA port joins or
leaves a LAG that is a bridge port.
