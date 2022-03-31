Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBFA4EDABE
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 15:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236972AbiCaNov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 09:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236969AbiCaNou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 09:44:50 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C47216A7B
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 06:43:01 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id r13so48207480ejd.5
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 06:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bk90QuOV6+H/s7wJr2puY8FcQfF2PngiIzO0yrEUqWs=;
        b=XMXyUt3kitj8UECwYmXrwvlnNwOMBh9RW3vQW+5vfheK10NBFS+1lqNOjTS2zSI6DF
         nAn3rKjQ3Wc1xid1EluprBwaYmtYsdA81tRt8sADc15KbAgDSRyxkCbwyFm+EIpcZzHn
         1y1Anj+v57vGf57JELw9zI5z13z0SYyu7cjXRkIpijScRG1N7XAN+JOzxNpm7ID5cE4d
         DFL4ox0pQfstubVUp4II5oBQ5GvVXqGjYPct85JklUn7yvTaw3yy2Gx/84/Es59kOPQn
         HSoXnhMyMgSapTGzGr4W6mCU/SN8oc01w8Js5PBN6L/e0ki7DIGzlvJKED6RSCmTH/WF
         O/IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bk90QuOV6+H/s7wJr2puY8FcQfF2PngiIzO0yrEUqWs=;
        b=vXmv8BOCHT+gHloyBWRifT8/U8BARkPx4dIb8O8YE7NCXgWHQT0Q7RhCDkUI0HAapa
         K/0enU1lkkwHusQ7F1o2nyc1oLEtRW+1sOeJZmqWjcxIDKNynL9/VvpUYr+i7w/rXRQX
         WbCYZXCBmV+nrZ5wmax94SSePJKuG+hXjeAZpSnMML9gB3c319WA1R4tUhl8UMzUHbwx
         P3RsWbvDTmE1mTGbO/1Sst9TpcsBfuIPE+AACSVksmd//vHR/f3WhD5neDvk8mfaAcHZ
         cl6aly6/dAxBaT2Q36+7SGB8HlKjWEYxAAM8QrphOGzoJEp5WuezRRpzdJWCbSoe6dpu
         q3pw==
X-Gm-Message-State: AOAM5326EG/kXs2RRSWY1idsEPq03fdBGk7dpbPBvc2j1etuvynZHB4I
        NMNbS0jgQUoFPvV+vqOPsjs=
X-Google-Smtp-Source: ABdhPJxGc+YYjpGw9JH4r5Vsr1xH0mXlmm1tEkOs3sEM3Bxenth25Bv15WCavsvw4fWy5m0GQC0png==
X-Received: by 2002:a17:906:2a0c:b0:6df:ec76:af8c with SMTP id j12-20020a1709062a0c00b006dfec76af8cmr4953498eje.269.1648734180008;
        Thu, 31 Mar 2022 06:43:00 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id k16-20020a17090646d000b006e093439cdfsm8500862ejs.89.2022.03.31.06.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 06:42:59 -0700 (PDT)
Date:   Thu, 31 Mar 2022 16:42:57 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [RFC PATCH net-next 0/2] net: tc: dsa: Implement offload of
 matchall for bridged DSA ports
Message-ID: <20220331134257.zi32tftbz3yo2lg3@skbuf>
References: <20220330113116.3166219-1-mattias.forsblad@gmail.com>
 <20220330120919.ibmwui3jwfexjes4@skbuf>
 <744ca0a6-95a3-cc81-5b09-ff417ffde401@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <744ca0a6-95a3-cc81-5b09-ff417ffde401@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 31, 2022 at 10:06:20AM +0200, Mattias Forsblad wrote:
> Hi Vladimir,
> thanks for your comments. The patch series takes in account that a foreign
> interface is bridged and doesn't offload the rule in this case (dsa_slave_check_offload).

I certainly appreciate the intention, but it could be that a foreign
interface will join the bridge after the matchall action drop is
installed on the bridge. So actively monitoring bridge joins/leaves
would be required to offload/unoffload the rule.

> Regarding your previous comment point b. Tobias could see some problems
> with that approach. I'd think he will comment on that.

I'll respond there.
