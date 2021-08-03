Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2AE3DE8C5
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 10:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234579AbhHCItH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 04:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234453AbhHCItD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 04:49:03 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F50C06175F;
        Tue,  3 Aug 2021 01:48:52 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id nd39so35245062ejc.5;
        Tue, 03 Aug 2021 01:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J4jATVkZ/USm62T2iGvuiu2c8duC0ne3ndhK/cNQVSc=;
        b=n6hJ+k9Q2YTp5upYnoq+ceszi9gr2JVEy0tSNXk/SoHDzKfQz4bBEZQHEQi+IV5npO
         yephuSH97FFPxZNlFCWVuBW5hkQ1B1+T1SnNs8AUuU9LWdgWesk0Ojko5enHuokIKZDD
         OzPE+QvbBl3tc7yS+nJlqB6W3CYAgseweuR6EA4Y7j1ipPY6atsaijeF+3HPst+8cpIr
         0cV7r/6StY2VZkKxWhDLKkZUZEGWhyR3xArxlb2pvQkSyoS703YKH8ziWfPwZKprB6+b
         GI/FMdrXyprpbH0Z/X1MK+fSKqf3RBSEL6EIw8Av4CSlVwuvrSpims/wJW/7CeYWp7Qx
         S6rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J4jATVkZ/USm62T2iGvuiu2c8duC0ne3ndhK/cNQVSc=;
        b=RJ35Cm+xvbCCDLv3pECyOtooz6tyQhLO0ier3cxP9KoUOYtJTH6PaleVYuAIa2ejTd
         o/pNQZHZKjwZSpQdNdw43TO9UBBnWkSKmTP5TASr4uf4lJbRvdHf5jHGug/NSzBCC9XN
         9c/Fc24iHD9GGq3DVJpa6bF7fQpkgO5QaJ7FTC896fbkWJYvtGnWXfrVDpiEtkKchRdD
         Jfh+fbKiK4lVGcQT21gZfhRvYGMSUSWDgSlbVf9gQQqavOOvfuHbED6W3sh5Co1z8XsN
         cCXMkfGq4eIJVyy0qm4jlR1HSgqi4ZNojl0hp0iJJeTmRJJYlpFLlkDIoosaSg9QfUUv
         2fow==
X-Gm-Message-State: AOAM532BM1A4zePwFNvQ9+5f7wr+6uhV/PNjpte1MOF42rQWqBnOvpjD
        8sDo9vwZzvUeBjZRbevFilw=
X-Google-Smtp-Source: ABdhPJwrJu/cOeoZOifSuOW4DtEVHlePqIG5oXstLiIoWH7izVOl4JlfeLo2q7D7ls4/11Lo/cpfJQ==
X-Received: by 2002:a17:906:7191:: with SMTP id h17mr19952376ejk.330.1627980530726;
        Tue, 03 Aug 2021 01:48:50 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id z10sm5809224ejg.3.2021.08.03.01.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 01:48:50 -0700 (PDT)
Date:   Tue, 3 Aug 2021 11:48:48 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Woudstra <ericwouds@gmail.com>,
        =?utf-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [RFC net-next v2 3/4] net: dsa: mt7530: set STP state also on
 filter ID 1
Message-ID: <20210803084848.cdvc5qxseott54yy@skbuf>
References: <20210731191023.1329446-1-dqfext@gmail.com>
 <20210731191023.1329446-4-dqfext@gmail.com>
 <20210802134336.gv66le6u2z52kfkh@skbuf>
 <20210802153129.1817825-1-dqfext@gmail.com>
 <20210802154226.qggqzkxe6urkx3yf@skbuf>
 <20210802155810.1818085-1-dqfext@gmail.com>
 <20210802210006.fhmb5s6dsnziyk7d@skbuf>
 <20210803082316.2910759-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803082316.2910759-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 04:23:16PM +0800, DENG Qingfang wrote:
> On Tue, Aug 03, 2021 at 12:00:06AM +0300, Vladimir Oltean wrote:
> > 
> > So then change the port STP state only for FID 1 and resend. Any other
> > reason why this patch series is marked RFC? It looked okay to me otherwise.
> 
> Okay, will resend with that change and without RFC.
> 
> By the way, if I were to implement .port_fast_age, should I only flush
> dynamically learned FDB entries? What about MDB entries?

Yes, only dynamically learned entries. That should also answer the
question about MDB entries, since a multicast address should never be a
source MAC address so they should never be dynamically learned.
The bridge should handle the deletion of static entries when needed.
