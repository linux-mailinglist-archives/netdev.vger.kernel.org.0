Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE3243292C
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 23:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232651AbhJRVkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 17:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233527AbhJRVkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 17:40:13 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB46C061765
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 14:38:01 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id d9so4756390edh.5
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 14:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D4/S956yr106t3LKks68I5mxYFr0YWPDjv2cZtJsKl0=;
        b=YMlBcET5y8025OGf/QO1Buydhip73j9aOA5btGLvLfsheHOgvtdI9ZKssyiGbSTcqk
         Xj73ewNycpDhvUM/jLIIgNA3m/2VH/5i8rKHK2TFtXJcA1BhzDBMwThNqkin+ZklbR8g
         7IIoFjpKESL9IHtQp/UdvNbrOQl+HOZao7gEZfM6hRn8uZrMnv+ShLQlxHXE0vgoWJus
         V+u9lmt1RD5DmTmV0inSBEVk23NIa+fU4K9WZwGNZx/N2MI3+iKZXYfuhMyTaExajANe
         tkiZu92uLKqcB3kZ+GoYPzfigxDOt5BP4b9OIMADABabiZ9mxPIjlZ23ZDVyPR5YcDpv
         e55Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D4/S956yr106t3LKks68I5mxYFr0YWPDjv2cZtJsKl0=;
        b=YWcY8HHSfkfDmxlQg0Fi8TYmNbo32JiXoZBHYlN76lCdgAfk5uNH+SZioV7EBWSMKE
         XVRlfm1dRpeCbXtMplesT3WeSumHljPEoIvv6ngCWEQk2LawyBGDHu7cfpUzwgLCN0qX
         rLZYfMMqMJ7xvdGSWGBZ+Zk3NrPOGusrd7fNiXIShugC6xzWTadrdz30cEkp4Sgh3uNE
         PDJgGcXEjAOHmj1Kkvrlh1HWMmWMxBi8qZrKFk9WGfPAmc5EPnr0fWQDYxIPTyZ4gYIF
         dnA2EALyzmJ+PMJLxJ46p22jAe62/2Tdk3z1BMqaLP44+kkUtJtvFA52sqDtKztlCUUK
         pTJg==
X-Gm-Message-State: AOAM533vP3Y++boCzrZ19q8Hmn5j8bE31XajgYWaH91G0ghQU9XKs54N
        tffggefRmOVqO64jU49aKv8=
X-Google-Smtp-Source: ABdhPJzIM01aPtuXTjpo5g9DCMy/k8XcbDLlA/8Zos3KCknANxABgsCNHGNYEbyXQr4aDhd9OLF58w==
X-Received: by 2002:aa7:dbcf:: with SMTP id v15mr48200397edt.243.1634593080334;
        Mon, 18 Oct 2021 14:38:00 -0700 (PDT)
Received: from skbuf ([188.26.184.231])
        by smtp.gmail.com with ESMTPSA id og39sm9427258ejc.93.2021.10.18.14.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 14:37:59 -0700 (PDT)
Date:   Tue, 19 Oct 2021 00:37:58 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        idosch@idosch.org, f.fainelli@gmail.com, snelson@pensando.io
Subject: Re: [PATCH net-next 1/6] ethernet: add a helper for assigning port
 addresses
Message-ID: <20211018213758.mgl4sc7yeloa6dst@skbuf>
References: <20211018211007.1185777-1-kuba@kernel.org>
 <20211018211007.1185777-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018211007.1185777-2-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 02:10:02PM -0700, Jakub Kicinski wrote:
> We have 5 drivers which offset base MAC addr by port id.
> Create a helper for them.
> 
> This helper takes care of overflows, which some drivers
> did not do, please complain if that's going to break
> anything!
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> --

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
