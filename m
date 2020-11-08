Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58B22AAC9C
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 18:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbgKHRX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 12:23:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbgKHRX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 12:23:59 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04320C0613CF;
        Sun,  8 Nov 2020 09:23:59 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id cw8so8958217ejb.8;
        Sun, 08 Nov 2020 09:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uD64SD5fYYKuZojXh2+SfJdFKMHHbdamTtqLh7UBTdM=;
        b=bTybsTGOrgdrX6JpB5DmG3e3+RnRky96XWd+X4BigQRxWvYWKkTTjoPcqSQuj+UoHM
         gjjcq+Ittpcfkd8K/+hfDCmgG/rX8SkiHWjf5fha+yTjAvCxuVDDeO7mmqyRbkrOUWgY
         2YFp2n+Fa8SUGG5MiODs4NT1O39oS2InuSxppdVSgvHWVnJxmQiGxLbl2Ta7gFP4t4js
         0myutQT0TT18+Hr17I5iqGw+pUHIkK5emGawkmHau/9oZfEwRuy+4Gl8HBdWPGcGYWKQ
         xOCcFDPxeGOqwIom23ImzSaUlxfKGJgy3yLxvhMtrFV7nr0K/bEn8/AblTGbWkGuaGzo
         DBVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uD64SD5fYYKuZojXh2+SfJdFKMHHbdamTtqLh7UBTdM=;
        b=lDtYGkyD7GJNWfXSuiVZ4nfmwQamCWRdm/BNi1uU9aLPA74zkedBgYnkCrLYH054mm
         WhAwlKGPh5Msf0H9Zsz6qVP1grkKIwkkexI4YZ54NNplWhRXZDDpI3S4K/4v7YIJeUFj
         LvETtJQIadUrB8TVEDR6mYmSlCprLRgxzAtF8Kp9HtK8wpNpK4AbDUJpbaDZBmlw4SjM
         pO035ouTd3zfk2EJh2UIMjdFQXTP1VF2hdqah6A4ZoHGayEz+ezuixd1uFbil4uSJT6Q
         KeXGi4aGM4Wij9dUSj/u7M6CvPfBItjoqqcv7+9V/VH3jVKOKJqiXjK+LJCXQAmCZ/Rm
         hJWQ==
X-Gm-Message-State: AOAM532Qp5p/ehAcvm6K/4CnVZla6iUBWHxGcIrDkgm7C3QCL2/hFkwn
        uDisyLEOLKpwdqZC3B+jzDc=
X-Google-Smtp-Source: ABdhPJxYQ4Zfg49EHq19QOmgWVb1oT6QWIOHR8Yb5UnhIhbt4IaUFO05W6XsjDSktsB4II+VG/T3cA==
X-Received: by 2002:a17:906:415a:: with SMTP id l26mr11240222ejk.442.1604856237745;
        Sun, 08 Nov 2020 09:23:57 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id y12sm6448297edv.33.2020.11.08.09.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 09:23:57 -0800 (PST)
Date:   Sun, 8 Nov 2020 19:23:55 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: listen for
 SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE on foreign bridge neighbors
Message-ID: <20201108172355.5nwsw3ek5qg6z7yx@skbuf>
References: <20201108131953.2462644-1-olteanv@gmail.com>
 <20201108131953.2462644-4-olteanv@gmail.com>
 <CALW65jb+Njb3WkY-TUhsHh1YWEzfMcXoRAXshnT8ke02wc10Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALW65jb+Njb3WkY-TUhsHh1YWEzfMcXoRAXshnT8ke02wc10Uw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 08, 2020 at 10:09:25PM +0800, DENG Qingfang wrote:
> Can it be turned off for switches that support SA learning from CPU?

Is there a good reason I would add another property per switch and not
just do it unconditionally?
