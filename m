Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46B9169FC5C
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 20:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbjBVTkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 14:40:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbjBVTj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 14:39:59 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345CD3BD87
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 11:39:56 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id ee7so19854804edb.2
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 11:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x0vleq0uwnZ52wgV61aiN2G7vvQ9WuniYUfOCwQ13xo=;
        b=F+Yf0sqtD7zGFVcS3je+YXJ6HSskD7i1ee9UvmaAP1LlTAYEt7cISRgNUT0Bbltb1H
         hgOiVdoLJenDE/kEm2lBzh6cfnJVxpZHQqsRJE5wVhkyitFh138iX5i50gb5g63uU+NQ
         RlucPqahQz2FRz+gORYu1baO9QDVirE1k9ExNXU7pH1sXyNLTKgq3hs43jYc8sUkpEgm
         Jrw3tYT38U7nZ7pFz7L6tl6jDnlHs+4oSiZE4XnIsedsw/iQL9E1WO5bBMDs6ALvxrb9
         4QUYh3ReZ5ZFACdJpL992Ws2unFtfVBNYlPofW/r4k5TE+oP48Yhb4WcQWfXS1UkFRYQ
         DUyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x0vleq0uwnZ52wgV61aiN2G7vvQ9WuniYUfOCwQ13xo=;
        b=FRpTruRqLpZma3JP8WiZMX7FiIVL31/zVl1EFRC88G4ga2ZccHRiCXE3OKvKjjYJ3D
         GPXm+0XXyW4pz/J7GvKmSLQJp957F9hYS9i24wrmGA7TzNo+RMFUqV7zmvdlEkcttLuY
         tvHHLkOttgbTEfti0gc4UX7roFheyJwdFRIrocMC2R1avbWnWu3ObfC3IrdkfVwpDO0s
         1W/TSH/5OBiqtNZnGp3Trdn24XGkCIgsRMV95FFnGRbVJFqqh7SyUCA22dZ03Mb8/INB
         wKgvoZdqFAanybc06f5NKYhlK5Y2ReHibpLmNkfD+basDmkLENnewTvP71+sXhPcavv8
         wrhQ==
X-Gm-Message-State: AO0yUKW/43YRSS3T3bbW3183nFmB2zQXYMwGXfu30AtFTimrLXf7c/TD
        t5u1OF7wpy/t5jCb8G7kJ+8=
X-Google-Smtp-Source: AK7set+7Bcg8lj7PnEGuiasJNQRfn1c1ZYCSguV9ZG0ARdWhmn9XKTxnjxxufytVix1302p8vbrsxw==
X-Received: by 2002:a17:906:374d:b0:886:ec6e:4c1 with SMTP id e13-20020a170906374d00b00886ec6e04c1mr17300248ejc.59.1677094794530;
        Wed, 22 Feb 2023 11:39:54 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id s12-20020a1709066c8c00b008d325e167f3sm4207326ejr.201.2023.02.22.11.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 11:39:54 -0800 (PST)
Date:   Wed, 22 Feb 2023 21:39:51 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: Choose a default DSA CPU port
Message-ID: <20230222193951.rjxgxmopyatyv2t7@skbuf>
References: <5833a789-fa5a-ce40-f8e5-d91f4969a7c4@arinc9.com>
 <20230218205204.ie6lxey65pv3mgyh@skbuf>
 <a4936eb8-dfaa-e2f8-b956-75e86546fbf3@arinc9.com>
 <trinity-4025f060-3bb8-4260-99b7-e25cbdcf9c27-1676800164589@3c-app-gmx-bs35>
 <20230221002713.qdsabxy7y74jpbm4@skbuf>
 <trinity-105e0c2e-38e7-4f44-affd-0bc41d0a426b-1677086262623@3c-app-gmx-bs54>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-105e0c2e-38e7-4f44-affd-0bc41d0a426b-1677086262623@3c-app-gmx-bs54>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 06:17:42PM +0100, Frank Wunderlich wrote:
> Hi
> 
> thanks vladimir for the Patch, seems to work so far...
> system now says dsa-ports are routed over eth0 and ethtool stats say it too.

Unrelated to the perf degradation reported on mt7530, just something I
noticed.

When using 2 CPU ports in the device tree and selecting port 6 by
default, mt7531 will break, because it will send STP packets to port 5:

	/* BPDU to CPU port */
	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
		mt7530_rmw(priv, MT7531_CFC, MT7531_CPU_PMAP_MASK,
			   BIT(cpu_dp->index));
		break; // breaking means that MT7531_CPU_PMAP_MASK will remain at BIT(5)
	}

Someone needs to go with a fery fine comb through the driver and analyze
the assumptions which are being made about which CPU port is active and
which one isn't.
