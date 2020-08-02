Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B6D23580E
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 17:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgHBPS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 11:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbgHBPSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 11:18:55 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC664C06174A
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 08:18:54 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id s26so16866614pfm.4
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 08:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=i9iwRrf2lwDvUhKiNHX4e8D3124Rn0HhgZZ60jUfztc=;
        b=SpCFyhG1sl1/TTz3xmIL6IyApkITZTT0yZaqu0MWt7PR+uTbp4SMaw0K4k5OX7EmHN
         oiO9dTUHrxq4Y/OVTO6Gr0Bt7s1oxRaCJ/aL2Hsj3ednJB7GV+LzTW0ocVEmyTYucSI+
         d5X8Mh75SZy33zHzRq7rIh7u0IxoGlqo0Fq7JdaBIFaTbi+fNDxP7ckFe2WphQGX0PO7
         1odXWzUjVhz76TT0UeOPDuOwLCKMHdJ05mhDqKZUqVrR3FnIscT0Ne7v7UUqU3vByRne
         72u2P7mxoeZqG+XuxDhnZavIN9fa6j+EVbROT94qigELIehtY+VIgIcs9kTR6GI4wkVc
         icrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=i9iwRrf2lwDvUhKiNHX4e8D3124Rn0HhgZZ60jUfztc=;
        b=NPDUOSurxfPJwnuwzxBVvQiI0zPodzqGb40kWLdU4WwkAsV63Ep6qqe9xNREexnKKp
         NIpZMLdvMcyoSfSxi6yEDzCiYReyu27H5xHqG+YxxMe5rMc2C/Ci48YHgdtBllwzYCX0
         rTVdrAD93uz6uAF7hU/sH1UXQvZ/lCcaHuL+2E/xTUgMcH9oeQJHZIYaHqmbvj3o2Egm
         uUSsPCnaWtLVUGAsoWGvdKnhqTIf9Wa1XCXkAzFBebf1vB90s8swsfjhMZb0FxWOT+hY
         Qek3p6tt9y1HNeXmPKHgMNX8ATRB3Py/17Z8300m+pD3a1UeJNadDBTeYS10/unqlhOr
         f2fg==
X-Gm-Message-State: AOAM5301dwA6ts/+KUj1jhxT5BMzdlzQqs2q1UYMm6eUl1arQdaEqzTj
        bZxtl7iVXAl1nFc111ZIP/0=
X-Google-Smtp-Source: ABdhPJxnYAaQLN0O6lSPmXspAwt6vLi6oHbO+q38WAA0+DjlnoNSjc4tzBPiNbSEwW9B7zy89WW+hA==
X-Received: by 2002:a65:6706:: with SMTP id u6mr11424768pgf.69.1596381534532;
        Sun, 02 Aug 2020 08:18:54 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id m190sm15611260pfm.89.2020.08.02.08.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2020 08:18:54 -0700 (PDT)
Date:   Sun, 2 Aug 2020 08:18:51 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org,
        Petr Machata <petrm@mellanox.com>
Subject: Re: [PATCH v3 3/9] net: dsa: mv88e6xxx: Use generic helper function
Message-ID: <20200802151851.GC14759@hoboy>
References: <20200730080048.32553-1-kurt@linutronix.de>
 <20200730080048.32553-4-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730080048.32553-4-kurt@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 10:00:42AM +0200, Kurt Kanzenbach wrote:
> In order to reduce code duplication between ptp drivers, generic helper
> functions were introduced. Use them.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Tested-by: Richard Cochran <richardcochran@gmail.com>
