Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDCD84B8FBD
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 18:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237348AbiBPR4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 12:56:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233780AbiBPRz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 12:55:59 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296E22722CB
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 09:55:47 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id m17so5194746edc.13
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 09:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Q6x6BbVdOoNpH8f4C7slAOI9NyIVPr5g2ngaZoYHCck=;
        b=qpJQyf+NTf54U94NBdzsALv5fQNVZb8UwI/dyQeFc0jvEC1jnxrICZBcKmac0ar/by
         svUO9GPBjI3B+S1FStlqbq47zCylMGetp71jS+Tg2tsGGDurMf6NN4fA0ccagH1sijMA
         C0GqUoGhMqyy2aeJNQ/AAD1cFEw7aAQbQKotyJ+l0BA/twroWf21c/n1UkkCZJot5yCQ
         2rD//EjQnKzmmZGTwdEDLcHJBcFDhe7Vm3CFG8yR2o++l0W32DZiUEq/dcMhscDoGSFc
         46deBecQzhj7GsDE8SEQYEX+sErYDJYO3A1Zj5QqFrchgDn4cK0pojMdzEZNLiPA/sp4
         te4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Q6x6BbVdOoNpH8f4C7slAOI9NyIVPr5g2ngaZoYHCck=;
        b=jOkNKHK8EpGXDU1nT/ED2tfhfxRR/eKalQYuzRnUgGFvO11mtM07U+AFg5rNCaL9VM
         ykCM9UfbgiQHIxH73vMyFW1JlQ6Bn0M6XpSMTXCjKppag+SzsL+W9LJg+0MNNgUkPbur
         3vpxgqWz9n1oXhcXlftS+G50sXKcKYdwo4T5qPMOThFpLLfzSB8ZbuW9Wd/pA/aEHYp/
         8DbaU0RHCPT3ZgI65iDjWfp5F08KuDfPmVz2HnIwve0OrzY7LiQrwmX5R6PfquHSwi2v
         PQ4FbySX42IYP27yOVCceNzUJi9lkZlUAjCrD2vk0ELvMNsj8UI62d+UbLTyFjHBWLny
         jKmA==
X-Gm-Message-State: AOAM533pptOK3aUsi/j/6lzMJyRSP/IhpwW9X6pczi/zHyE6l2ZcVlHt
        WqDY6aCdWpligU+A044P5sg=
X-Google-Smtp-Source: ABdhPJziXb5aqOGpTng34mJZJrrLPPBOPcgv9Ic54Ag25+ZSFzMia5vg2+OuZi9H93xhyS2PvJlxww==
X-Received: by 2002:a50:9991:0:b0:410:a3e5:5066 with SMTP id m17-20020a509991000000b00410a3e55066mr4329811edb.49.1645034145613;
        Wed, 16 Feb 2022 09:55:45 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id g2sm2118120edb.12.2022.02.16.09.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 09:55:44 -0800 (PST)
Date:   Wed, 16 Feb 2022 19:55:43 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Andrew Lunn <andrew@lunn.ch>,
        Juergen Borleis <jbe@pengutronix.de>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        lorenzo@kernel.org
Subject: Re: DSA using cpsw and lan9303
Message-ID: <20220216175543.l6smw26vl4qencau@skbuf>
References: <yw1x8rud4cux.fsf@mansr.com>
 <d19abc0a-4685-514d-387b-ac75503ee07a@gmail.com>
 <20220215205418.a25ro255qbv5hpjk@skbuf>
 <yw1xa6er2bno.fsf@mansr.com>
 <20220216141543.dnrnuvei4zck6xts@skbuf>
 <yw1x5ype3n6r.fsf@mansr.com>
 <20220216142634.uyhcq7ptjamao6rl@skbuf>
 <20220216170027.yrkj5r4zberrx3qb@skbuf>
 <yw1xy22a1z63.fsf@mansr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yw1xy22a1z63.fsf@mansr.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 05:47:32PM +0000, Måns Rullgård wrote:
> The LAN9303 has (R)MII for port 0 and internal PHYs for ports 1/2, so
> there's really only one sensible way to connect it, even though the
> switch core has identical functionality for all ports.

As strange as it may seem to you, people are connecting other switches
to a Beaglebone Black and using one of the internal PHY ports as a CPU
port. That driver did not need any modification for that particular
aspect (the port number), even though that use case was not directly planned:
https://patchwork.kernel.org/project/netdevbpf/patch/20210814025003.2449143-11-colin.foster@in-advantage.com/#24380929
