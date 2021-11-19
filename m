Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D81AD45680A
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 03:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233816AbhKSCYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 21:24:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbhKSCYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 21:24:40 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B39EC061574;
        Thu, 18 Nov 2021 18:21:39 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id x6so24259941edr.5;
        Thu, 18 Nov 2021 18:21:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bLv4z1YgRSxxNj2meoBJG3nBTaq7Cb6Ni8OvuFAyxQw=;
        b=lQuyqFwokAnl8QhTi0Ia3yGbeg5+dDQxVyo7iqFhHymQucVc91AE06wm5ChMcqZx+V
         zb3vS00Cq/GDAyuOHhUhm++LcDzCcUwgv8ZMuJ9J0mqN8CuYElJ/nrWj0VP92LNXWhXp
         VKXSx04/SeFzowyuD06y5TbYsLyGu9dXWdY70W3BKGUujaMyd+6aH0Cpn7XXl7gQXNDw
         S0/I6zmdfPy4V/TqzFUewsgpq1mndyU+tkxwKPS60WPOGLCVRKtioeVqW8WRHURQtC/L
         FW85QDrqn5JAvZE7q76WfuUma+ODlvmlYQkaJiPSLk8+l64AluG8MOLXZggEQUEhAF/F
         NpCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bLv4z1YgRSxxNj2meoBJG3nBTaq7Cb6Ni8OvuFAyxQw=;
        b=Vj2M8wPXruG/SaqGS4sJlfBgySL4NdgDkYE9dKGrA1LlmWSux3aYpkbptC+pVj9dU6
         VUYlyor5F14hUB1zZq5eTMnPkeKdPaDIs/WV4EIs+MmAJ02WZwS/X+dDBh5zFcXuNoGY
         Qq3wTQ5y/trKpFoAE7TFYyHT7h3gHXN6qdRMuChZUpYIlB4QyjiGyRRW8ADjdCveeGnl
         +jN+sPm+0W3LzEzjj08vKaN32PsWd1pmNcTp710OZoe6GOHTndW7VR2z2Pipu76GZdN7
         jPnxlSRPwIQr+bB7ilJ8+qSxokpTL2pWRhOZtbxFinPE7r4eEj8dVSqTOZdWPoV73b9w
         FVKA==
X-Gm-Message-State: AOAM532cDR7cN/V0x9xBmJqCdqc+inaYXidz0b2KuQ5Gz9MKwFrm+5RJ
        QFbuIpbAvm6VXsqDTKteNLg=
X-Google-Smtp-Source: ABdhPJxdP30XKax9MS1JBUc5k9znb9gzgnnuaSOJzA9iP75YvEkI2iyAsfFGhqUd83cExnddPH2wDA==
X-Received: by 2002:a17:907:9608:: with SMTP id gb8mr2912403ejc.301.1637288497750;
        Thu, 18 Nov 2021 18:21:37 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id ji14sm558560ejc.89.2021.11.18.18.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 18:21:37 -0800 (PST)
Date:   Fri, 19 Nov 2021 04:21:36 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next PATCH 18/19] net: dsa: qca8k: use
 device_get_match_data instead of the OF variant
Message-ID: <20211119022136.p5adloeuertpyh4n@skbuf>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
 <20211117210451.26415-19-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117210451.26415-19-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 10:04:50PM +0100, Ansuel Smith wrote:
> Drop of_platform include and device_get_match_data instead of the OF
> variant.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---

Why? Any ACPI device coming?
