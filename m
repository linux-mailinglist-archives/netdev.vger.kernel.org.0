Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0A05663D3
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 09:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiGEHSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 03:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiGEHSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 03:18:06 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D3925E1;
        Tue,  5 Jul 2022 00:18:06 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id q6so19987885eji.13;
        Tue, 05 Jul 2022 00:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Win/NFhHy+CZ7leCxWZ5eSpJbWWRxJJPXaQBTF4b8/s=;
        b=lPfEOcOV4yz6DS4DSjq+jrMzLRqj5RliArXZZ0XKQKPh5kmuQ23Me+hUmSwjl7gNLU
         bNVDS9jwbz9wcY2+aUuQFop4M70ThNvVJ55fyWdW7b4EuBj7qQccKa7D2CYrLYw0zkA+
         PnRXmlRB3VGytXm5Ih+SVmksT8kXtfmNEUEp+FBr0fRLTluOjdpZP8R4jw6RgZTmhPeA
         PuJhuQJKWeFU94mosd0sLo7x1SU+cssQSWgABuzh9SDNXbU5FfJixwrEl6+1nLVXfZFy
         5JzSKBDSH9y6iGcVs6iCLZy5LI65anbvTWafCOc4Joyqp8fJ24oCxbTZz0GCp8KIgA9x
         mwbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Win/NFhHy+CZ7leCxWZ5eSpJbWWRxJJPXaQBTF4b8/s=;
        b=2qxbE6GFn0oJrKS3MzYBRHtmU6o/ifgw6FPytam7yerUdlsOQb6n0dvhMVw0jzrZrS
         20J069zuBwkkdwW5nDjLj0BWa+v0rLtCIDHNGodyq2BdcvoRNxSFeHZUkanxl2Ro85w5
         Gj3J3eLqnjxj9ux81bXiN2ForUPjiagSiks69eLLHmY2rUulKeIgkUi+iO6JBsdrf4Px
         AcozOvemCM/F4jULzUyn3AK1j0S1OHCz7JzPLy6GwkueiAEPnOgT+sTk1fOUDBU5CV53
         JjTP+W50gY5QoZxs2U6lO5iVOvi2mCZaX7CuNHNxS127W8qOVtTjkP3hacX6grDBG1/d
         H1XA==
X-Gm-Message-State: AJIora8PXhbvYhlTMkiBmTKUt2IPk9yE2oyYUKgPdcEJ8Ay8PzQUdLYS
        lS4R/xH1eG/64UR7qV3nyZ6uMMTRs2MNRw==
X-Google-Smtp-Source: AGRyM1tZeRDweu8OE3HHalNyIUb0AVLEmfWg8LX9GoXuzmtvqFJxERVlLNm1CjaJL0HXflzn/J44lw==
X-Received: by 2002:a17:907:a075:b0:72a:7508:c014 with SMTP id ia21-20020a170907a07500b0072a7508c014mr25012304ejc.176.1657005484615;
        Tue, 05 Jul 2022 00:18:04 -0700 (PDT)
Received: from skbuf ([188.25.231.171])
        by smtp.gmail.com with ESMTPSA id z7-20020a1709063ac700b0072321c99b78sm15169856ejd.57.2022.07.05.00.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 00:18:03 -0700 (PDT)
Date:   Tue, 5 Jul 2022 10:18:02 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, stable@vger.kernel.org,
        Doug Berger <opendmb@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH stable 4.9] net: dsa: bcm_sf2: force pause link settings
Message-ID: <20220705071802.ygfj7t2t5kiucykl@skbuf>
References: <20220704153510.3859649-1-f.fainelli@gmail.com>
 <20220704233457.tgnenjn3ct6us75i@skbuf>
 <YsPgkExHpr1NFdJw@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsPgkExHpr1NFdJw@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 05, 2022 at 08:56:16AM +0200, Andrew Lunn wrote:
> linkmode_resolve_pause() is not used yet outside of phylink, but
> should help here.

I don't think linkmode_resolve_pause() was present in 4.9.
I'm looking at what gianfar was doing at the time (gfar_get_flowctrl_cfg)
and I see mii_resolve_flowctrl_fdx() as a potentially relevant helper.
