Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D111B34A7A9
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 13:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbhCZM5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 08:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbhCZM5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 08:57:23 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0AE6C0613AA;
        Fri, 26 Mar 2021 05:57:22 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id j3so6160229edp.11;
        Fri, 26 Mar 2021 05:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2d5mLXjGef+34ljNMWfhznBd3gdEcnI8Z558NOXmNeY=;
        b=soHD8EmsW6vEFPAJRHAm8HE1H5ARTOZVUrSm77BHOJHlE9TA4MItjQ/2Qh8rNE0gWK
         o/dNF1toSmwthhde2EymIkvEjBEAbBq6t5gctBaoQVkDL4o5HBJmq1Uzrg4zt4CcdWIC
         tewvPg5EI94LDnVMdgzaOKlPa6QUUKl2ZnrqY36rNc9fVrrlm5IoFiSsYJpSe+gOz3mj
         lrM/JG6W0bmoJ1IJMbSt1Ktb4u+X10c96OKes3ikPRErVGTmxODzoMAvxvPB5MCjY5Lk
         yy5AT02fzD2uAH8RiRgGECUUKtWp5tcUcNDREU4GZzR1UUWgTjAPzWlZCHMhny2U+Q1j
         c+Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2d5mLXjGef+34ljNMWfhznBd3gdEcnI8Z558NOXmNeY=;
        b=oe/AfqiwlgICfm2FI4Quf0tTBlh2xjuUdWnLqiu/JGAX4SuSVU/V5b3sukD3OpZZQt
         HzdLO/eVmoezV2KSViy9kjhcIY3q7FubFz6P7LkmE0VFa3eeT6o6urAtqifH2CXw8Fx9
         WmyyOLdl9v3LJl+8DVQ+XN8cTksgjK8lmb+7jriQ2raaq/X/i/nj27luyBpfpeqmYTDt
         ljPQwMJqs8wTkaUIxkkuUWvrSwkEAr7oVF2R8Is9nUDPIKXX1xAIaOp0LDUXrD84y+QY
         /ajocmm7DFkAnu5TVy6gbhpAJBA5fux4imLWG02l96TbyqYe/FFpHncNQPoRCj0KZtDD
         S1VA==
X-Gm-Message-State: AOAM530svDYHytWh65RexZaim++CYNuYuYP8XWi+ItDPpCxlgor1Aajs
        jyKr1/89zlnm9PTlblwArx0=
X-Google-Smtp-Source: ABdhPJzXCcQ6Esr0+ycPzvrS0MjjMteMZRlGvPuTs88Gk1DJz3koSY3Qvo21jp6ChzB73whRvmPCag==
X-Received: by 2002:aa7:d0c2:: with SMTP id u2mr14768449edo.158.1616763441682;
        Fri, 26 Mar 2021 05:57:21 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id 90sm4432309edr.69.2021.03.26.05.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 05:57:21 -0700 (PDT)
Date:   Fri, 26 Mar 2021 14:57:20 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: dsa: Allow default tag protocol to be
 overridden from DT
Message-ID: <20210326125720.fzmqqmeotzbgt4kd@skbuf>
References: <20210326105648.2492411-1-tobias@waldekranz.com>
 <20210326105648.2492411-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326105648.2492411-3-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tobias,

On Fri, Mar 26, 2021 at 11:56:47AM +0100, Tobias Waldekranz wrote:
>  	} else {
> -		dst->tag_ops = dsa_tag_driver_get(tag_protocol);
> -		if (IS_ERR(dst->tag_ops)) {
> -			if (PTR_ERR(dst->tag_ops) == -ENOPROTOOPT)
> -				return -EPROBE_DEFER;
> -			dev_warn(ds->dev, "No tagger for this switch\n");
> -			dp->master = NULL;
> -			return PTR_ERR(dst->tag_ops);
> -		}
> +		dst->tag_ops = tag_ops;
>  	}

This will conflict with George's bug fix for 'net', am I right?
https://patchwork.kernel.org/project/netdevbpf/patch/20210322202650.45776-1-george.mccollister@gmail.com/

Would you mind resending after David merges 'net' into 'net-next'?

This process usually looks like commit d489ded1a369 ("Merge
git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net"). However,
during this kernel development cycle, I have seen no merge of 'net' into
'net-next' since commit 05a59d79793d ("Merge
git://git.kernel.org:/pub/scm/linux/kernel/git/netdev/net"), but that
comes directly from Linus Torvalds' v5.12-rc2.

Nonetheless, at some point (and sooner rather than later, I think),
David or Jakub should merge the two trees. I would prefer to do it this
way because the merge is going to be a bit messy otherwise, and I might
want to cherry-pick these patches to some trees and it would be nice if
the history was linear.

Thanks!
