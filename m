Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDEE1102FC0
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 00:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbfKSXMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 18:12:44 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39917 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfKSXMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 18:12:43 -0500
Received: by mail-lf1-f67.google.com with SMTP id f18so6204786lfj.6
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 15:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=J6djBZAZ4NKmoE5rDlXQqbYC4TEITCNxIlH5HQol9VI=;
        b=Vjz8znJ6cb48JQjUqD6uTuZV0ePVCQHg2q8rjcLMUst/MwnYK5I8QKVAODVhtFGomV
         Nc2qf1AXDeKZGyVudF42PKOCi42xtrwsdb9l6Gt2B2JBAxUt8ZQZCbPB7XPRyBZ8XRos
         Cmu34UdrptldO+ncwB3Txz9DFyC4ZNmpBXK+iRmZ3V+R/wTj4aZ6NiRUgHwiepjkouFJ
         iE3cC7RZudMqPTkXB/GWq6Ba6+EAC2vMqxvluLSRQZ93TZt39k8kq4/P2oMS8lc5pFG/
         qylQEC6Vrz/MNPE/ic5RLYJldRFhSeDSkbb0wjV77HbUgUZwA7iUaVbV/1DgZRNMfje2
         ebyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=J6djBZAZ4NKmoE5rDlXQqbYC4TEITCNxIlH5HQol9VI=;
        b=Up1MMVFBRFlzGDpZegjiYurbNUIkIKIEO1/pCm1EVPDqOv+TIXjooWV2BsEmnSWgOD
         1Tw7gTxAKpggcKT3vVOfvu4VKIssc8T5c6qQo78r+pIiOKn2Llvc7tIP3wYHkHZE59w3
         mrMH2iyFYTQzSZWjbm8e2oQtowMhjyuGpDNb/FF9d3fSdY7dtl+5WVv0wU8h8i4vvOxj
         055tUGTFVIX7EKez0xbklnLd517CJXltdadpDGS1WI5EnNA1i8tNj7uo8x1kaneXdkxb
         zO3MHQcJluzxZDDHAQ2hKhqhoF/bMmz3R5kWJyYBCgzyVbJr6MC+1t+SSYRXQViVvKTW
         sDeA==
X-Gm-Message-State: APjAAAUO6869HKaBlk9oPILQcscZ2REumG70UXE/qm+C3WWpL8lMscsP
        E4j2Bc24bHQ6OgqNgY3ju1P0AQ==
X-Google-Smtp-Source: APXvYqzEPJDu2v7/BPSwTZzTsuB/P5qIDv0tkxu6tWkp9wShP1RJG9l88xRd/STrMH9vn7E9/djg9Q==
X-Received: by 2002:ac2:53ba:: with SMTP id j26mr147420lfh.92.1574205160201;
        Tue, 19 Nov 2019 15:12:40 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id p88sm11086298ljp.13.2019.11.19.15.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 15:12:39 -0800 (PST)
Date:   Tue, 19 Nov 2019 15:12:21 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v7 net-next 07/13] net: ethernet: ti: introduce cpsw 
 switchdev based driver part 1 - dual-emac
Message-ID: <20191119151221.14ff2d28@cakuba.netronome.com>
In-Reply-To: <20191119221925.28426-8-grygorii.strashko@ti.com>
References: <20191119221925.28426-1-grygorii.strashko@ti.com>
        <20191119221925.28426-8-grygorii.strashko@ti.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Nov 2019 00:19:19 +0200, Grygorii Strashko wrote:
> From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> 
> Part 1:
>  Introduce basic CPSW dual_mac driver (cpsw_new.c) which is operating in
> dual-emac mode by default, thus working as 2 individual network interfaces.
> Main differences from legacy CPSW driver are:
> 
>  - optimized promiscuous mode: The P0_UNI_FLOOD (both ports) is enabled in
> addition to ALLMULTI (current port) instead of ALE_BYPASS. So, Ports in
> promiscuous mode will keep possibility of mcast and vlan filtering, which
> is provides significant benefits when ports are joined to the same bridge,
> but without enabling "switch" mode, or to different bridges.
>  - learning disabled on ports as it make not too much sense for
>    segregated ports - no forwarding in HW.
>  - enabled basic support for devlink.
> 
> 	devlink dev show
> 		platform/48484000.switch
> 
> 	devlink dev param show
> 	 platform/48484000.switch:
> 	name ale_bypass type driver-specific
> 	 values:
> 		cmode runtime value false
> 
>  - "ale_bypass" devlink driver parameter allows to enable
> ALE_CONTROL(4).BYPASS mode for debug purposes.
>  - updated DT bindings.

Could you please add documentation for the devlink parameter under
Documentation/networking/devlink-params-* ?
