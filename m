Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628F82BB967
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbgKTWtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727728AbgKTWtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:49:20 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B51C0613CF;
        Fri, 20 Nov 2020 14:49:19 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id f20so15050408ejz.4;
        Fri, 20 Nov 2020 14:49:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cCnI/wMDAF7RJoCx4G1FksWrB+6TjayQ16BTP1sr3Ps=;
        b=LdOjOmVKq8MIy8skzxkBTNKhivBUHoSgm765Y8xC7vsrLPth6PgiUydZjF8u0IfB67
         VbWSLMZYm4SQlLma504hSQ6TZKt1kW04BGHU0/gwuLnxyV4jcWsZvNOeWf8oqDq4Dvga
         Ig5i4owibb9SdZDwrjYH7g7U4xP40pUGz6mEhjDZxvT9mKfiTMzjjOX+YNSBKo6yh2ai
         jyjF3VNYJSvd/BIDcktiYcinyxUTsonThyIAHDizXfFu3c9CTMECAbG2w+FcB07MRkSs
         VwvHk0umhpQ0iRNmnuRYqpzk6f47aMnIC0LH6QidZ+JBExFg7tYEKeNyYMkJWEKfqdg/
         6AMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cCnI/wMDAF7RJoCx4G1FksWrB+6TjayQ16BTP1sr3Ps=;
        b=byNlb7tG3Z1t80qpp4GZGc439IvaU79XE1RBS8xZ5c1X2AFC3sjAZuaiqPnICeilwQ
         vrP2wQpeTTAo00VMfi9qNVRqve16cN0n9EwSuH/ZPox4pJw3sc8eZTkc+URu5OUVFDs7
         boHrpkeEK1bS53F9WYsaI/mpJi0wamJveQ1sJ26OqR9gEyn3OpLtNkJP7loGXUj2HV7b
         /eQ4TUXLLfgCCMpKCf9GsknawbQ3y3I+JWkCwD66MH7sVOzZIHqFQIAOZ9hCyS4qLoX/
         i/N6EvMbbuxk1NKxIkpAEJxVnKtwNGc2CYIdjPxqLdMfJePJ1XUGmMDTXvlOzyFiY+Ff
         wE3Q==
X-Gm-Message-State: AOAM530AJ4iCWVZx+Cv8YpRYXlbQXOY/SdXVcWYQkn4MoTpUrghPXkl+
        SqC49weukV2zIGi5meZSGeWzH9YAHHE=
X-Google-Smtp-Source: ABdhPJwF8EJeDVFQcJ+ZJsZkgs1fnqz0fDkJ+KccOqigXoVKl+v3EzQJeXX0KzDg7JKSsC3q+tHwfA==
X-Received: by 2002:a17:906:e254:: with SMTP id gq20mr35334900ejb.520.1605912558455;
        Fri, 20 Nov 2020 14:49:18 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id n7sm1650365edb.34.2020.11.20.14.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 14:49:17 -0800 (PST)
Date:   Sat, 21 Nov 2020 00:49:16 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 05/12] net: dsa: microchip: ksz9477: move
 chip reset to ksz9477_switch_init()
Message-ID: <20201120224916.fjkau25rc7qdsgri@skbuf>
References: <20201118203013.5077-1-ceggers@arri.de>
 <20201118203013.5077-6-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118203013.5077-6-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 09:30:06PM +0100, Christian Eggers wrote:
> The next patch will add basic interrupt support. Chip reset must be
> performed before requesting the IRQ, so move this from ksz9477_setup()
> to ksz9477_init().
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
