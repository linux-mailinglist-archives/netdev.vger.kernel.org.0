Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B57431250
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 10:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbhJRIoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 04:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbhJRIou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 04:44:50 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6A0C06161C;
        Mon, 18 Oct 2021 01:42:39 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id ez7-20020a17090ae14700b001a132a1679bso4113466pjb.0;
        Mon, 18 Oct 2021 01:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=DAyRWJeM7WcXBmJfC8EYVSatAo1tUAa025hjrvqygj4=;
        b=pjkO0MkdRmY5FkfWW+EfXlo7coSyNA0UvLvaremgQ0bVxp1yk8zUfFBuLWo3vptr6g
         a8MwQHjz+iMGgp1Leq6G2BYTatimamqvnfcfKKxI1+WbcOLJAB8UBAp+r9iZ5Xg+mHSa
         1NuHjrmSUkaD9IKUixkCzMpvwe/0C+iOgTBN3CjWMmQzjMuVnXenqGHQfdlxzDe6CKWv
         z1SeLPMNTGiSepavXDsSHZoDc5NkxoPsQZ9/3ffhRep3fA8UPncN+0RfiGU+6TD4TOHb
         rscUJw5JZ8NQZ6ea+J42gVaBQREDiL/TFnYprSWPeYQ0fzOXDc22Z++8CoKi5p6kNNG5
         JLwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=DAyRWJeM7WcXBmJfC8EYVSatAo1tUAa025hjrvqygj4=;
        b=ox0S+115MIIDF4VCRnN896peLxd1sLMtWqknl/gyqJ+2MAE5SQq+keSpgkizi0lwI7
         GihMIh8sggYtsb9SZmyEhlnRcZfYcWoY6toa57fjmpLmnLoP7GAvRFcdpgdUlV/EKc0O
         1cQyUmxec+I8WvyWzvlw3gWxsq2tLZAcHEG8qu8lOfeBUR3oeimPXqG8bF/LhP9AWH0y
         m7+AMGNo6rXhn7naFPquJL4meVA4kBzMFGuRj6t6HSQ5riTH5wxkpuwc1mpK4NWhsNTA
         lGv83b+t0fget060G2iSu7+ZoHHd//s+GcBNseOdnJWofXiwdQJtW0YCNk68usmLhae7
         fGxA==
X-Gm-Message-State: AOAM531CbJ+G0NZFYQZ2AG9WYc04IbyigrList1WWBlhJTtsWs0aqmWr
        gJPsoXj6SsRqWgY/VdCpz6o=
X-Google-Smtp-Source: ABdhPJyYoLQM1iIllEwgPR6qgb4iSpGJ2GuiYzUTfZIXXF0pt3/TERwOOPTiYDZi2i8s2Qh/vmQT+Q==
X-Received: by 2002:a17:90b:1b49:: with SMTP id nv9mr31231964pjb.134.1634546558838;
        Mon, 18 Oct 2021 01:42:38 -0700 (PDT)
Received: from localhost.localdomain ([171.211.28.7])
        by smtp.gmail.com with ESMTPSA id x13sm11727906pge.37.2021.10.18.01.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 01:42:38 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: mt7530: correct ds->num_ports
Date:   Mon, 18 Oct 2021 16:42:30 +0800
Message-Id: <20211018084230.6710-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cd6a03b9-af49-97b4-6869-d51b461bf50a@gmail.com>
References: <20211016062414.783863-1-dqfext@gmail.com> <cd6a03b9-af49-97b4-6869-d51b461bf50a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 16, 2021 at 07:36:14PM -0700, Florian Fainelli wrote:
> On 10/15/2021 11:24 PM, DENG Qingfang wrote:
> > Setting ds->num_ports to DSA_MAX_PORTS made DSA core allocate unnecessary
> > dsa_port's and call mt7530_port_disable for non-existent ports.
> > 
> > Set it to MT7530_NUM_PORTS to fix that, and dsa_is_user_port check in
> > port_enable/disable is no longer required.
> > 
> > Cc: stable@vger.kernel.org
> > Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> 
> Do you really want to target the net tree for this change?

Yes because I consider this a bug fix.
