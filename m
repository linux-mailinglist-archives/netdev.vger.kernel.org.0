Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5FDE2EBE5E
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbhAFNOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbhAFNOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 08:14:37 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E25C06134C
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 05:13:57 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id w1so4863549ejf.11
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 05:13:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=PtNUsD0BRtgF2IA+9Pz7ik0xMTD2xJGw6gRo5kMgjbY=;
        b=Xq5XsCqbLPOy42RH6cbkAhWz94FQyMI/r0WuBFNKlTfDQuLB8h5KVgIZIEsT+5UgXD
         5q79MlCGPezBmWptX/8X4zb+odP7Ov1qyJJnDTDdx9bN/+HP10NFlDiUVkitFHJUfbXb
         FhYUc/VXYdeqDPRUBO6V82B4+n/rwzwqmDj8g8jyFBAEN1cs9A9SyBOaQziQPvnnuoF5
         QtFUg12NaOJH+Llp5nt/2D35LtsB6GC2JlSSyDHSq5hzOBlJWaz/cwqBvhJLIbqewCkv
         z3Bim5MkCm0LAr6OUuWUJBZ3Oag9i7dLG/6zdUZeb5ukPqEOBAuygC+mPeYODOT4gd8U
         lNDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=PtNUsD0BRtgF2IA+9Pz7ik0xMTD2xJGw6gRo5kMgjbY=;
        b=bKVwg8Y01rLT2s/f1LAMKS+1ynas/ETaf2lVayEbuu/p7owDDQ6D7GjQo0yVus3iD6
         94/n7GtOabzW+y63Ff2YEn7YDA61rWnhdK4ruBK9I1FbLnC+6m42FH8wX0kefMzirzGT
         GkYA7B39ySpbniSMQxdv0bJSXGid2n0zwHBdPeEIRcVN3admgYTHbIZr1s6fDuABzzbI
         RRFhecMrQ3t7gNZoZjyC7t9duVB2f0hL6s/HSKh7qbu/wh2ZZgzlzEClXUX2O7e3Lta+
         n78+jguDVjad61PXWFG9WfctzeWDDG0w3edm744FReKjD1hK0m/YS2nczrIFPuSFVdwx
         oOlQ==
X-Gm-Message-State: AOAM531adkxTp4lw0fWUGmaImmwfxCVDTNGNH1lktkiKZjkk9dQrjp2V
        bzvpoyqpWjXZUvSbeBMII/I=
X-Google-Smtp-Source: ABdhPJwrG2IqQMZhRyYA/iKo2dMDBqINv9SwSdXnQJY7jraboNKsHwTiOwE3t95rIQAt/oeX7poY6g==
X-Received: by 2002:a17:906:3883:: with SMTP id q3mr2845248ejd.160.1609938835866;
        Wed, 06 Jan 2021 05:13:55 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id m7sm1262715eji.118.2021.01.06.05.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 05:13:55 -0800 (PST)
Date:   Wed, 6 Jan 2021 15:13:54 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        netdev@vger.kernel.org, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Matteo Croce <mcroce@microsoft.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH net-next] net: mvpp2: increase MTU limit when XDP enabled
Message-ID: <20210106131354.7khatbjkao3rj63z@skbuf>
References: <20210105171921.8022-1-kabel@kernel.org>
 <20210105172437.5bd2wypkfw775a4v@svensmacbookair.sven.lan>
 <20210105184308.1d2b7253@kernel.org>
 <X/TKNlir5Cyimjn3@lunn.ch>
 <20210106125608.5f6fab6f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210106125608.5f6fab6f@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 06, 2021 at 12:56:08PM +0100, Marek Behún wrote:
> I found out that on Turris MOX I am able to route 2.5gbps (at MTU 1500)
> with XDP. But when not using XDP, when the packets go via kernel's
> stack, MOX is able to route less than 1gbps (cca 800mbps, at MTU
> 1500, and the CPU is at 100%).

Read this:
https://patchwork.ozlabs.org/project/netdev/patch/73223229-6bc0-2647-6952-975961811866@gmail.com/

Disable GRO on the DSA interfaces and you'll be just fine even with IP
forwarding done by the network stack. You don't _need_ XDP for this.
