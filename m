Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD004587D0
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 02:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbhKVBoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 20:44:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbhKVBoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 20:44:07 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325A5C061574;
        Sun, 21 Nov 2021 17:41:02 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id t5so70094660edd.0;
        Sun, 21 Nov 2021 17:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j8XFWWjDsVEnC3bQiBgasTNHcyOoBnNSVWKYjD0uv+Q=;
        b=SliAfjpeJtw6aAbl3ATj7cbUydN04jSl6QGK23hQ0Mu41WpyAOu203eYTVZ5svSnI4
         qYHElZFmfdNn9IGruxb5MGeygWSJxs18+eCEQhFIt5fjxlkziVMFdG/smjb5jB7pluAj
         csZISjJfjWE2jVNv95VO5amTheGmb7hGCeAGSoageVrjo/U9Lw+2vKe5TkhgjnsXxqW5
         5rT7G99UJxH5nL+Q++AruEO7AXN+hiKpY0VZBv8PKhn2BKWEdHbd3tYsXfSMJovde3x7
         OId5S4wJgfvSgF6210loy7wQqjDOBdMR+fxS7q4KS0mz5C0x+vtlgf67QWPpYeFPrmcd
         hCjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j8XFWWjDsVEnC3bQiBgasTNHcyOoBnNSVWKYjD0uv+Q=;
        b=nu5QFmHhWV5TqSAiRyG+Wkte7fzNRacCMlSeAYxCUWVP3syzSJUrn+IHCR/DXEFjRW
         AGT67CacPQuQLQb3VpKxmj7LLu1LsxhYBaXBOCutrrPyGOw0jTMWyNrw9EXv3KHg6QLf
         +Mj85cQBkn9NfbbC5gIcrpDW94Ip3FRcbOzHUsNgqEo97/rSt1QSsqJ1kdC9pJdYLqmq
         Pvz4VZh0sSARopiiSTjki319p3JnH/GxDDKMMh03Y6+VkoKsf1QEcM7XbtIbweY6SKPo
         /z+0Md+KqM+0syHIaqyVBhwibhv8ZbmOAUp+W4isZzvAzk6ppnZmFzbVO+vJl+O9y8UR
         aW5A==
X-Gm-Message-State: AOAM533ZhF74Ne8f9+0qBizDsZaBwQHsQPD5vlyVXFAWFmm+1HZlyTdh
        Y6/+vggBRVNLOiBJqkOlf0vgsbieIJU=
X-Google-Smtp-Source: ABdhPJyUvZP0+3tzw3IGRUG4Nbt1tGyB22GkhrT4R6nhT1tj9pVno3PRb48JolRLKK4aflm7w5AsQw==
X-Received: by 2002:a17:907:94c2:: with SMTP id dn2mr23168746ejc.325.1637545260741;
        Sun, 21 Nov 2021 17:41:00 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id c8sm3241427edu.60.2021.11.21.17.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 17:41:00 -0800 (PST)
Date:   Mon, 22 Nov 2021 03:40:58 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2 8/9] net: dsa: qca8k: add set_ageing_time
 support
Message-ID: <20211122014058.ffamphqxrgbftpaq@skbuf>
References: <20211122010313.24944-1-ansuelsmth@gmail.com>
 <20211122010313.24944-9-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211122010313.24944-9-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 02:03:12AM +0100, Ansuel Smith wrote:
> qca8k support setting ageing time in step of 7s. Add support for it and
> set the max value accepted of 7645m.
> Documentation talks about support for 10000m but that values doesn't
> make sense as the value doesn't match the max value in the reg.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
