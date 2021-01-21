Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D68E2FE0E4
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 05:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728648AbhAUEkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 23:40:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729511AbhAUEDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 23:03:33 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337D8C061575
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 20:02:53 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id i7so517895pgc.8
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 20:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sG+8U2a0VzflH0AQCilm4xiwM2Lp+RWQMQAIENGnnIw=;
        b=dND3ZqHtHbU9r7q6L/5Z5KJM9n6yPI2SjuXSH2ZpUS288tKvvbT8GcRdlEA1QhKyvf
         rAgIZis1j9Au4KeIiUZw8N5yjCZsFCTMM1ArwqUr/0Q1YkJsn0Dsa2XjhEUNsdPiX5O8
         7yoBS5RhIZUl/J7aPKEAhnwQY0iEZlRwT3515U7WlKdqTrkdhTwNJ+XR+BxuSNiA31wR
         lMlMRyjJc3+qJdnVx6km+8+uKpxQXlb2Wb1ZBuSb2ay3223xs93iFD7K2vtXdfEJDBVm
         PXxrHna68yIFgZlL6EgYC+zRyw8pnUK3DwQEu6KAFS4WVxNAyoGMjKeXH96vNCo8WtPN
         3O0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sG+8U2a0VzflH0AQCilm4xiwM2Lp+RWQMQAIENGnnIw=;
        b=Cek3K8zzJLoacVLOHsJZbhNQaMdThHIHmGon3AAp8X7mfvMsU/8uEbdAYQ21adl56M
         jP+D4di+4MNfp5kHVutvtZsxW+gSgVeZOnszJK4NiZokX+EZWzAQA5YR/4yVBYBozpat
         8/cUafS/53f8z76m2il4QO13I/CDrHQSPfvI6YO0Q88Lw+i8V/o+8Xhi4mYAAV403SvF
         UnMc37KNsGhI4S8QwNn1jU9cLo+5CcX/Dls2HO9Wc5JsfMs499Z6TszNW7JhUtphR0q7
         m6DyBkWXxjknsGNSXevq+oVQUr43GdZ+14SPex91Kqjpu9lbFoNYVNyMUQzWZpCzBHl3
         7GVQ==
X-Gm-Message-State: AOAM531Omf4gZ6ctg8qPwikjuALJpyX9HQJJtThNj4wmbrgmVXQnAllq
        VPemMl7zvBgz9FMiABk6u+U=
X-Google-Smtp-Source: ABdhPJzwmlV0jFIiKSJ448zHTCVV8bamoVvn4EPTLVcYkoNnsSwrxuw8FXuje7os5C9OceLWqggL7g==
X-Received: by 2002:a65:4206:: with SMTP id c6mr6298368pgq.262.1611201772644;
        Wed, 20 Jan 2021 20:02:52 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 7sm3512263pfh.142.2021.01.20.20.02.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jan 2021 20:02:51 -0800 (PST)
Subject: Re: [PATCH v5 net-next 08/10] net: dsa: felix: convert to the new
 .{set,del}_tag_protocol DSA API
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        UNGLinuxDriver@microchip.com
References: <20210121023616.1696021-1-olteanv@gmail.com>
 <20210121023616.1696021-9-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <edf8dbc4-7f6c-cf25-8b2b-f5dae8af0f0c@gmail.com>
Date:   Wed, 20 Jan 2021 20:02:48 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210121023616.1696021-9-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/20/2021 6:36 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> In expectation of the new tag_ocelot_8021q tagger implementation, we
> need to be able to do runtime switchover between one tagger and another.
> So we must implement the .set_tag_protocol() and .del_tag_protocol() for
> the current NPI-based tagger.
> 
> We move the felix_npi_port_init function in expectation of the future
> driver configuration necessary for tag_ocelot_8021q: we would like to
> not have the NPI-related bits interspersed with the tag_8021q bits.
> 
> Note that the NPI port is no longer configured when the .setup() method
> concludes - aka when ocelot_init() and ocelot_init_port() are called.
> So we need to set the replicator groups - the PGIDs - again, when the
> NPI port is configured - in .set_tag_protocol(). So we export and call
> ocelot_apply_bridge_fwd_mask().
> 
> The conversion from this:
> 
> 	ocelot_write_rix(ocelot,
> 			 ANA_PGID_PGID_PGID(GENMASK(ocelot->num_phys_ports, 0)),
> 			 ANA_PGID_PGID, PGID_UC);
> 
> to this:
> 
> 	cpu_flood = ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports));
> 	ocelot_rmw_rix(ocelot, cpu_flood, cpu_flood, ANA_PGID_PGID, PGID_UC);
> 
> is perhaps non-trivial, but is nonetheless non-functional. The PGID_UC
> (replicator for unknown unicast) is already configured out of hardware
> reset to flood to all ports except ocelot->num_phys_ports (the CPU port
> module). All we change is that we use a read-modify-write to only add
> the CPU port module to the unknown unicast replicator, as opposed to
> doing a full write to the register.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
