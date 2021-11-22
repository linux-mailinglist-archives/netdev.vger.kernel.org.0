Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF7E4587FA
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 03:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbhKVCZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 21:25:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbhKVCZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 21:25:20 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464CDC061574;
        Sun, 21 Nov 2021 18:22:14 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id e3so70065351edu.4;
        Sun, 21 Nov 2021 18:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GPKdWYi1/RITj4HeNMQskUc46kt10bqd2KmaWFRsl3c=;
        b=jkeRHuozF3Bbtb9765QGN4Zks14kJb9mYl3UnrvmhqAq0hwU2FAoWnujhaIBbkSODK
         fqcfLYmEMjWKvkyLcmxxNY70O7PwT7hhbfymWZMwGm7WwsqJKLG67VAjtpXOp9BnnGBj
         WZygyMcYrk82FLLzmG0v23PDJIYJlfXRFItjiG5t0SPfA2fpVKWz1gvJzAi3abLy6GQ4
         BDH7WFTqvTZTFYIEByYJ1cKGuBer9VYj6vHitNb1vaVe6G35QBKmTCIl7s5lRKHEr7s5
         3lBQ3AVWoqawT1T0bNXR/61QUXiqnrXjLQW0zQVbyXlPoi575ufYuMxO2Kr/Ec0XIIzh
         D1+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GPKdWYi1/RITj4HeNMQskUc46kt10bqd2KmaWFRsl3c=;
        b=Zce5fiUCRvBOJ9SZ9erOKhmwQIC/tTQoLp1RDYFCz8v/37UNnM/th+bvaDizAqqRer
         JXAQoeKbJ8/c15Wdk/OT2Gt7+YgWZ7Nrgeb6hOHkqRw8v4XdCR7+u9gIfdHZs/y0MJQE
         RPeZdLCBADMqW0byDQv8LxeHL+bhZVdvH29DiCZsYoWdbojA8nqxnYlFEesliPdyD2KY
         Cnd7Ek9mshRc6wlatbmiK3WPREEpxxm92yYmqjrTbpm/Wi3qB5Yb7P9ARae9inY4+XzP
         W1K9+sv+jEkTJlBHSwyMZgNvTwpVK/gGFJfoLdkGVc66kFRl1ia2O/2rf/fqYCyxcGFY
         Q/qA==
X-Gm-Message-State: AOAM530q6pnwj7dRA89ZXAmDZ6N4suSA4SW7QfhnCeeq1zxjletHeQAJ
        upZaXAWtxLa9geZaf0l44phx9084Yfw=
X-Google-Smtp-Source: ABdhPJzx2mYfZGorkq8LdYmc76+JVy9G9AjLopuHUCLEv+7XGJW0xHdP3PbkQIQ0+xjznFE7JZF/GA==
X-Received: by 2002:a05:6402:5206:: with SMTP id s6mr59550237edd.113.1637547732853;
        Sun, 21 Nov 2021 18:22:12 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id em21sm2969639ejc.103.2021.11.21.18.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 18:22:12 -0800 (PST)
Date:   Mon, 22 Nov 2021 04:22:11 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH v2 5/9] net: dsa: qca8k: convert qca8k to regmap
 helper
Message-ID: <20211122022211.jqlo4pts46gyavca@skbuf>
References: <20211122010313.24944-1-ansuelsmth@gmail.com>
 <20211122010313.24944-6-ansuelsmth@gmail.com>
 <20211122013853.dpprmlprm2q2f24v@skbuf>
 <619af8f3.1c69fb81.71bf6.e95d@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <619af8f3.1c69fb81.71bf6.e95d@mx.google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 02:56:58AM +0100, Ansuel Smith wrote:
> > Maybe you could keep qca8k_read and qca8k_write and make them return
> > regmap_read(priv->regmap, ...), this could reduce the patch's delta,
> > make future bugfix patches conflict less with this change, etc etc.
> > What do you think?
> 
> Problem is that many function will have to be moved to a separate file
> (for the common stuff) and they won't have qca8k_read/write/rmw...
> So converting everything to regmap would be handy as you drop the
> extra functions.
> But I see how reworking the read/write/rmw would massively reduce the
> patch delta.
> 
> When we will have to split the code, we will have this problem again and
> we will have to decide if continue using the qca8k_read/write... or drop
> them and switch to regmap.
> 
> So... yes i'm stuck as if we want to save some conflicts we will have to
> carry the extra function forver I think.
> (Wonder if the conflict problem will just be """solved""" with the code
> split as someone will have to rework the patch anyway as the function
> will be located on a different file)

Yeah, well, if you have to split then you have to split. It probably
won't be pretty, with a lot of code added for v5.16 and now for v5.17,
so it hasn't had time to reach to a larger pool of users and get cleaned
of bugs which you didn't notice. But what can you do. Other than wait
for a few months for the code to stabilize (which is counterproductive
in its own ways), probably nothing.
