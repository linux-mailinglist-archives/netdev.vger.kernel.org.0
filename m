Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9931A4B94C5
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 00:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238557AbiBPX7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 18:59:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiBPX7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 18:59:47 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCED141E00;
        Wed, 16 Feb 2022 15:59:33 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id m3so681717eda.10;
        Wed, 16 Feb 2022 15:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ew3Xa6gAkKuI3fbgTzfugwZyLwcI+iWPyFMlpPcJqSU=;
        b=lzLlxHdlUXuCNjAZXfB7KIiUyR2VTKiPDBb2e3w1ic5GAMa6RADuUnSP235pHdBE0S
         Y6pXgEkpSSXGh0Dkv6ZE1kH8yj86StQ67CgwCsBEOJeRSGKM/gmV/8lssmfONoQscBBm
         WIrmEO6Gp5zFC+SXIPw7oj8xPKAro+stJenE2hYACXdsQyOWwORnFtpoiPN5nGaUHUtc
         O8E4RBYmNk9gD/9B5IVPqdDlQ3c8NCl9jmnK6oNffNzBHyGs1y+HkWIKlvN0qdoz/AeS
         XqfIX54VIXdHZeExVT5ryY+Hi9+/SXuIET46jMer/Ly5kfp0bVeQns0y6MsUFeJMfNl9
         KfYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ew3Xa6gAkKuI3fbgTzfugwZyLwcI+iWPyFMlpPcJqSU=;
        b=X7rq7YYoEWIcrUsIZ+bLPAF2je7Fn8lY47JdlnJxQQI90N5gTP4/30E1ZXNuNM7qaY
         OacuCNKHR5KSm2qMFpt2kY4u6KLHdSeSEVXridqJhWPxNZclcT9AvzbiIsyMapm6vnbv
         YAyhzRdQPt3tsE9iCraMh+255CxTOY4PKv1usy5CeCwLrvjN5XaDNFzIjsiuIkNFw/cC
         Ml/PMGV9uMl+JOt0sd/juqbDzgjcfBv5npVi36EaOslx24cgPaY7N3Ap/XrbXqZEblwg
         V4MUMzwHExdBnHrtUtU23Rp+H+YwWZiWenwDsQJq70B1XGa2KOPoawUY2fzlPAfhMVrr
         pZcA==
X-Gm-Message-State: AOAM5329Dg4hD2n/Ya0AcWqEaL47vd/oz/G3Vvi7T2WrojJN2hrU8JVy
        EcSfrHCDs0przem7A6giBpQ=
X-Google-Smtp-Source: ABdhPJzxhRAKn6gfWozQLlVghwYgV9gcYOil6MNq6epB4uIe7Pt8jH6Viqbhd7wo8j6FCloc0Das2Q==
X-Received: by 2002:a05:6402:27c7:b0:412:80f9:18af with SMTP id c7-20020a05640227c700b0041280f918afmr181405ede.127.1645055971842;
        Wed, 16 Feb 2022 15:59:31 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id h8sm2453908edk.14.2022.02.16.15.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 15:59:31 -0800 (PST)
Date:   Thu, 17 Feb 2022 01:59:30 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mans Rullgard <mans@mansr.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Juergen Borleis <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: dsa: lan9303: add VLAN IDs to master device
Message-ID: <20220216235930.q2l3lr7p7pf5hozo@skbuf>
References: <20220216204818.28746-1-mans@mansr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216204818.28746-1-mans@mansr.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 08:48:18PM +0000, Mans Rullgard wrote:
> If the master device does VLAN filtering, the IDs used by the switch
> must be added for any frames to be received.  Do this in the
> port_enable() function, and remove them in port_disable().
> 
> Signed-off-by: Mans Rullgard <mans@mansr.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
