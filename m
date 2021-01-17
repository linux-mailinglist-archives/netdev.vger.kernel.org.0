Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85CF02F9422
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 18:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729544AbhAQRZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 12:25:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728455AbhAQRZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 12:25:24 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8A4C061573
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 09:24:44 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id h16so14999582edt.7
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 09:24:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UXFx7Ha8ZV7SySHn6Xk+yfe84/duehlA0Nsu29CCnAE=;
        b=ZfoNY8FToKHkFq6OhH0wJ42RDXu+NxEk0BOMr7X5EdmlPUg+xbpdAxCmedQTRgO8P1
         xT7gjsIeYaRSONQ6slIRb3yG449sIJZ1mXqsGT2fL8t5wVHeAKKq7hvPW+FJA7xCxj7k
         +qzSn6b9W/2u/w1B8OIF8QtgBTxIOShGDNtONVDtLy8ImD2fqQ/+WAxNB1CvtJHI7vwC
         Atr4if4kqj12JV5fNlhVqpjqmpGuFzmzrwZWp9g/L0uXNF0ZiFCZBGkSgmQynC7fUtNY
         c0rIWxzoynhoo8thjPbB6CEw0Nj5eeAk66t+H/tNQs4GmOTRsWgrke9S0zD5A0F7QcRw
         02ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UXFx7Ha8ZV7SySHn6Xk+yfe84/duehlA0Nsu29CCnAE=;
        b=Jgb/mle8G734WZYXmR973K5/VJu/GBWIAiOVY/pLNkq3V3vWiVPhTSZofvQ5Ji4WpB
         fULI2TRw+CSu7nJXQsI8eK+MhoWE8nb5PBoA23PkjuGcKhtI1RXzeZmIIjQTxSwXx8ON
         1Z/J2idCRLWZ4aKGOUJwQMKPX9Ogr59/Nn7l3WzNHpEunGQm1K0hgQqpPbdcTdKnPzcM
         vlZUf/i5Ezi4M1uwLzAlFjZe0xCO/qDLFigRwdlJYjq8EP9p8OrcVdWXN6WYl/7dDjPs
         XEc6WECBsqxHrjK8p8rPIkuk2213OuYO8uf+k41mj2SDLEKnw+jTokyyij17pshZyL3w
         6dPw==
X-Gm-Message-State: AOAM531cbE2hgy0JO07DfoFlUs6ndvNmtI3VSGeVO5FWqHbJ9ZaMcmrX
        ikdiC7XG6yojzWf64LAsL9k=
X-Google-Smtp-Source: ABdhPJyoa9NXC8aOvZbY3gL2GOQRaZnumiY/QLtQcdvMs7vxo274SyAtUDPLlc5rd/X7knVrTG68bw==
X-Received: by 2002:a05:6402:2346:: with SMTP id r6mr8572019eda.8.1610904282635;
        Sun, 17 Jan 2021 09:24:42 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id b26sm4223115edy.57.2021.01.17.09.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 09:24:41 -0800 (PST)
Date:   Sun, 17 Jan 2021 19:24:40 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, roopa@nvidia.com,
        nikolay@nvidia.com, netdev@vger.kernel.org
Subject: Re: [RFC net-next 1/7] net: bridge: switchdev: Refactor
 br_switchdev_fdb_notify
Message-ID: <20210117172440.ylzfdsw3e6fvuhyj@skbuf>
References: <20210116012515.3152-1-tobias@waldekranz.com>
 <20210116012515.3152-2-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210116012515.3152-2-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 16, 2021 at 02:25:09AM +0100, Tobias Waldekranz wrote:
> Instead of having to add more and more arguments to
> br_switchdev_fdb_call_notifiers, get rid of it and build the info
> struct directly in br_switchdev_fdb_notify.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
