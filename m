Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4984B8C72
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 16:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234561AbiBPPa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 10:30:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbiBPPay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 10:30:54 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A506D25A94C;
        Wed, 16 Feb 2022 07:30:42 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id p15so83774ejc.7;
        Wed, 16 Feb 2022 07:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0zjszkS6L6DSZoEqedm7iPNnjeIn+MY1NQcvdazgDhc=;
        b=gT2fWhDq/JdiRg2VBRoLumjxX/EVuxDes4PsA8gSKKHw5jrCN45wqLTlJRd7/31g7N
         ie/aGyodDyn4OWM2lABsH2ruq5qqv5XXUCHdgjusimhazi36eoDF8UI80UnNj3WxE0b5
         hyS0Y0gRD19c4fkpcPBdKhubn4gTbf5DRgd37jZf0QxWdDilt3YPvfJi2lvNPEVgba6G
         JxWTg7Vy9lowtTG43T/4m80ebSLzSx7/NB86qYea1ftQ3CmCBuB/ceJnOuOyaP4tSIIj
         Js9GNkUT9a7V/bSvRPZI3uNDFcOlSYXNhFadWYSAbgj+jvcMT95O9dxjM+h0tvJGObEa
         vDsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0zjszkS6L6DSZoEqedm7iPNnjeIn+MY1NQcvdazgDhc=;
        b=xjEB7+yK/tweJ27frFNxl7v0Fi8woV614spJiGa25gW+Q7q8+dhzhvTJqmwAtjzEhR
         P2HtuI3Nl9rZ6i8aauzpV+FwlLhZjpGJQtC6W+oUppsRbpRI207N39E+pJ8SWCsqsTeE
         dZ5NZTFkiWMTTmn/Lsn1FA76Bv2c7hdG1KCCygv8zGljBZa0D0Di3NcL/TIn7onYXWjV
         5umUy+MsQwFo3wQo10vZm4GaJHk4bMrqWTLbeodpiFipaNfFoz5khnUom72NgGdmt/i0
         3uzaZQ8K7Em/HCvJ0MDNQ6GXeUXK98mD7Lk7Fwilb6TOVNXgINbUsgX8CYoJWCMCxnkG
         FgdA==
X-Gm-Message-State: AOAM533xyfkDBwWmezd+/1Oxi1igkaL/9TPCT/ja1kjoAMTUvfb6vEpQ
        2UZ8WDwQmY7IKRJrgJf75lYBLfA4KqU=
X-Google-Smtp-Source: ABdhPJyaHD3bvBYXztT5gaV68mlWnB1CcFPhW6uRF1Od4ZdC+t9dgdw7kjkwGDoHsdQcoi1XPlxl+A==
X-Received: by 2002:a17:906:3ad3:b0:6cd:382b:86e5 with SMTP id z19-20020a1709063ad300b006cd382b86e5mr2656336ejd.145.1645025441086;
        Wed, 16 Feb 2022 07:30:41 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id p18sm22029ejm.63.2022.02.16.07.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 07:30:40 -0800 (PST)
Date:   Wed, 16 Feb 2022 17:30:39 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mans Rullgard <mans@mansr.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Juergen Borleis <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: lan9303: add VLAN IDs to master device
Message-ID: <20220216153039.ow7gcmfbjjfeekuc@skbuf>
References: <20220216151111.6376-1-mans@mansr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216151111.6376-1-mans@mansr.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 03:11:11PM +0000, Mans Rullgard wrote:
> If the master device does VLAN filtering, the IDs used by the switch
> must be added for any frames to be received.  Do this in the
> port_enable() function, and remove them in port_disable().
> 
> Signed-off-by: Mans Rullgard <mans@mansr.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
