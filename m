Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 000F65F9E13
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 13:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbiJJLzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 07:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232103AbiJJLyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 07:54:43 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D676B0F;
        Mon, 10 Oct 2022 04:54:35 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id z3so14560876edc.10;
        Mon, 10 Oct 2022 04:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KGr4jSMmWA90fSl51SKsE39vGZMWNw/HAcCXt0fhKdY=;
        b=kVxTKEZT0JE8DxPI1MKAO1+TSjUzqdK9Xb3/LvmgX4TB3kpU4d15e6WvDtPOMAiOqs
         1c2fUpzymPh3GzRbb7YlquXYNwfmChAebHuikACAHDZNauveryBbTH0Y0lagv/fuyDQE
         gUkvcPbfz05D8QJLrzzmoUBABg8kVO8p8XaOI9k9U17jznxPq4dWpbCvbb1JQEEUuHDT
         8/sqy3p/sLIo3HrZo1szWfYS2u54tgp28uewWRDJ4weTyc7As/SZkyj570CdS1g9s9EP
         4sOpKArqRq1J9xJ1cx/g/Z4/s4wX8g/VKxhwVxWq19BlDSNkGAl/N+SGea5t1m1HtMOz
         Q9mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KGr4jSMmWA90fSl51SKsE39vGZMWNw/HAcCXt0fhKdY=;
        b=EQU5pMpQGd3rk2uaVBimxlhM3+K5MHR9/m2PEqaEyh2HRp5k2vHb8CIGDkTRqDXhai
         IZnsfAlUhTeRbrwgYLkFt2uaq5hWSEgA6sy8705ub1f8HlAj836i59MwXU0+C1CTlioC
         h7IAL1BugCNyX9P+KIeJe/MA8t1ZKh06JL1u8OEyYcCKubxFX7rfz/MhdjBYHSS4POo6
         3ApSdtZSPgwlHsyNZKDqxFa/Cg0Sd+dhQMILAIAbMsd5AXBtdUqsW0NLRGaixcXTj3Lo
         S3Ui2dzj1fdSlHY9BuADfQlKVIyrLGgn3SA0Y5cEhq/alfyecODxXnIiycrCXWLSc5Gd
         noCQ==
X-Gm-Message-State: ACrzQf3UMBG6csM0Qgu2R6H9ulMfkyJsybA4T0rEad6ao23Fm0hJj8sl
        qAaS2vfoEIIEbk7e80XjbHc=
X-Google-Smtp-Source: AMsMyM7quX5qXUoOWshryYE7DqQCachD0+epum1Q2oHEIfwFJthClv4ZMW4uyUuf5a482gYLAISctA==
X-Received: by 2002:a05:6402:e9b:b0:454:351c:c222 with SMTP id h27-20020a0564020e9b00b00454351cc222mr17893846eda.216.1665402873268;
        Mon, 10 Oct 2022 04:54:33 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id c18-20020aa7d612000000b0045720965c7asm6971501edr.11.2022.10.10.04.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 04:54:32 -0700 (PDT)
Date:   Mon, 10 Oct 2022 14:54:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.0 11/77] net: dsa: all DSA masters must be down
 when changing the tagging protocol
Message-ID: <20221010115430.kloc3urkycsbyele@skbuf>
References: <20221009220754.1214186-1-sashal@kernel.org>
 <20221009220754.1214186-11-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221009220754.1214186-11-sashal@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 09, 2022 at 06:06:48PM -0400, Sasha Levin wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> [ Upstream commit f41ec1fd1c20e2a4e60a4ab8490b3e63423c0a8a ]
> 
> The fact that the tagging protocol is set and queried from the
> /sys/class/net/<dsa-master>/dsa/tagging file is a bit of a quirk from
> the single CPU port days which isn't aging very well now that DSA can
> have more than a single CPU port. This is because the tagging protocol
> is a switch property, yet in the presence of multiple CPU ports it can
> be queried and set from multiple sysfs files, all of which are handled
> by the same implementation.
> 
> The current logic ensures that the net device whose sysfs file we're
> changing the tagging protocol through must be down. That net device is
> the DSA master, and this is fine for single DSA master / CPU port setups.
> 
> But exactly because the tagging protocol is per switch [ tree, in fact ]
> and not per DSA master, this isn't fine any longer with multiple CPU
> ports, and we must iterate through the tree and find all DSA masters,
> and make sure that all of them are down.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

Not needed for stable kernels, please drop, thanks.
