Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D790B69BA42
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 14:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjBRNao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 08:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBRNan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 08:30:43 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6098718AAE
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 05:30:40 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id z10so2414483edc.6
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 05:30:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cbFmP3hjj+vdNVYBkJEnbBtqjNWrrRKRSkqvw4WLXLw=;
        b=px5BT7nj4e69BzjMqyjomCPpBZnrA7rm+MpEE70Uklk9BGEI/iApLw5RqfEpdKWvgB
         7L8X3iwCI7Z2cSKZTHWggh19J5WJ0Rd/ym2N6BXeJ6kfbWqVxDhuy0CAchUXmN8nfGHe
         OHGZ5wY4adNxEfzJA7S1se+RgjOlByjDPKobpvtsRs8CQ8HouiTX7qXiKzlNF3vAoyCD
         oTK+YRvKh/GD3he8NReHrCNfUkx12/hVWBC4LfNSraoyjT+kRmWFASu4eAFgyCW9+KJY
         OKPCec5MZaytizRnIGmlYCYY7Jdnvot4tQjaH/c6ORYhwAVqxXNReiT902BbNSqvRf2U
         h8+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cbFmP3hjj+vdNVYBkJEnbBtqjNWrrRKRSkqvw4WLXLw=;
        b=boF8e4/PBV85Bf7f9zKFgCnh8xGAxa7gnLrxmw5j3o7WRMUw4oQlzX6fz6lrDIIZjL
         7LjcmCi4IEdoMTmvo6JG1gZSCm7x0I0089ux4/YDCrLDu7D3jFM/+ApvmO7a/YxjHSPp
         HrYJckDPd+g7jdnAlPUTkpXm6fjKsTNnnYnDFh8C71Or0u5frX1A0HGd0DY76rNFiv9u
         OBE3wsnrQj0cj/GB7gpXkwQGImULL1p5yLiw8LndRzjiITRcaH2HJCULPttlST/gKWWK
         dAI1VzZzttngJEaLnN5DRj37FcQclloVXMr7SwGLKr/rH3YXAHONshJZODTKoszjguJJ
         y/+Q==
X-Gm-Message-State: AO0yUKXTqp4p2gZMontMIGEGSKsbwpGdpYAwLci/00Jw5Fy901NEG2ar
        4h4IS6vMRB9LemILmir+NGV9uKp6C48Uew==
X-Google-Smtp-Source: AK7set9O8TPqvltimXhiVeZGh3YjNo2fSzYeJ5Gi8m5+cCm0M79FIVsRAYSoVhm1tXk8ziaZEyIRLg==
X-Received: by 2002:a17:907:7ea8:b0:8b1:2823:cec6 with SMTP id qb40-20020a1709077ea800b008b12823cec6mr4898052ejc.43.1676727038723;
        Sat, 18 Feb 2023 05:30:38 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id dv4-20020a170906b80400b008b904cb2bcdsm1292182ejb.11.2023.02.18.05.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Feb 2023 05:30:38 -0800 (PST)
Date:   Sat, 18 Feb 2023 15:30:36 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Angelo Dureghello <angelo@kernel-space.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: mv88e6321, dual cpu port
Message-ID: <20230218133036.ec3fsaefs5jn7l7f@skbuf>
References: <7e29d955-2673-ea54-facb-3f96ce027e96@kernel-space.org>
 <20230123191844.ltcm7ez5yxhismos@skbuf>
 <Y87pLbMC4GRng6fa@lunn.ch>
 <7dd335e4-55ec-9276-37c2-0ecebba986b9@kernel-space.org>
 <Y8/jrzhb2zoDiidZ@lunn.ch>
 <7e379c00-ceb8-609e-bb6d-b3a7d83bbb07@kernel-space.org>
 <20230216125040.76ynskyrpvjz34op@skbuf>
 <Y+4oqivlA/VcTuO6@lunn.ch>
 <20230216153120.hzhcfo7t4lk6eae6@skbuf>
 <07ac38b4-7e11-82bd-8c24-4362d7c83ca0@kernel-space.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07ac38b4-7e11-82bd-8c24-4362d7c83ca0@kernel-space.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 07:39:11PM +0100, Angelo Dureghello wrote:
> I have a last issue, migrating from 5.4.70,
> in 5.15.32 i have this error for both sfp cages:
> 
> # [   45.860784] mv88e6085 5b040000.ethernet-1:1d: p0: phylink_mac_link_state() failed: -95
> [   45.860814] mv88e6085 5b040000.ethernet-1:1d: p0: phylink_mac_link_state() failed: -95
> [   49.093371] mv88e6085 5b040000.ethernet-1:1d: p1: phylink_mac_link_state() failed: -95
> [   49.093400] mv88e6085 5b040000.ethernet-1:1d: p1: phylink_mac_link_state() failed: -95
> 
> Is seems related to the fact that i am in in-band-status,
> but 6321 has not serdes_pcs_get_state() op.
> 
> How can i fix this ?
> 
> Thanks !
> -- 
> Angelo Dureghello

Looking at mv88e6321_ops in the latest net-next and in 5.4, I see no
serdes ops implemented in net-next. OTOH, in 5.4, the equivalent of the
current .serdes_pcs_get_state() which is now missing was .port_link_state().
In 5.4, mv88e6321_ops had .port_link_state() set to mv88e6352_port_link_state(),
but this got deleted with commit dc745ece3bd5 ("net: dsa: mv88e6xxx:
remove port_link_state functions") and seemingly was not replaced with
anything for 6321.

I don't actually know how this is supposed to work. Maybe Russell King can help?
