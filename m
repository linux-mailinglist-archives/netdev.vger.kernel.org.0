Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9990941DB60
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 15:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351713AbhI3Npx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 09:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351414AbhI3Npw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 09:45:52 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29C7C06176A;
        Thu, 30 Sep 2021 06:44:09 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id s17so22051451edd.8;
        Thu, 30 Sep 2021 06:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UjF2DK0XHqbPC53s90LqLkLXntykYrLbNoJlQA0A+CI=;
        b=MAitvzNmtLvoEHW8BbdfWwBvyQF7njfyns6d6aH6pXb65iRk+pAX8kjM/xbksSkgT3
         goGXrRPOTyGSWOtdzqi7yu8oDvIZahB4tvdGIPb7VZKSSFWtW7RsxearcgMHpzlATBtU
         TcIoh0Kb8sp1d/4ZaypFBO/jY/oR6RzIv9+e/Cxzn+iv11g4f5ju5ZfreqzNpi6USKXq
         p3pxmYTqf8A6OpUjRf4O8nYptpGIkuucVJvVb7LHI3D+nD3cIz5dbYFNsl9sC0EfLAmX
         jceDLcc2mgSGidv55WqbWx2zuI1PLLrB/cDdFDizPLtoV4IsUT3nB/DMoYbTtdylFTMs
         J9DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UjF2DK0XHqbPC53s90LqLkLXntykYrLbNoJlQA0A+CI=;
        b=CfXCJ1fff40t88tb482NLR2b975NRSFzKxLZQ1sxheU1XjIDEOj7p4dtBjPDgp+SU2
         XSB1wt0TOJPaEOsD1SSLeRrRuAWd7CG6b8nXIETqyLCE72Exelsb/ZfxFOaNRjS8XYJX
         U5gScnGkaHGwMnUeDI5pZIvFP+dcKJGrCGIm47PKHtH3tRpxKIur/ZRG9e4hHnzvT9sk
         Q9LkgHRyUHPjc2E2JVH8c2yOLFR0IfBNqvGyxF8jEs2Bdeqf0C/yclLXgQp2ZsvnMq1k
         pr+mx9jlkT89JFQqmjJ2Fi0Flewkbu3wypBwg/3VTUHh4z7meAPkTR1nTPPLAagDo2Cd
         st+g==
X-Gm-Message-State: AOAM531iqUPrjQwX8R6G1xsb/KUCH6Sznqm+e8TLCsk0qFR/CzJgaptq
        DZiwFcLMGFSVbSQ87WwSobg=
X-Google-Smtp-Source: ABdhPJx0eviuC9N/tm8dMClBGyquoSCJX4K4rzXd53RFBmp7YruazDT6tfydDczTncEX3qHZLJF9ag==
X-Received: by 2002:a17:906:c249:: with SMTP id bl9mr6780265ejb.225.1633009426246;
        Thu, 30 Sep 2021 06:43:46 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id pg17sm339319ejb.56.2021.09.30.06.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 06:43:45 -0700 (PDT)
Date:   Thu, 30 Sep 2021 16:43:43 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for
 FWNODE_FLAG_BROKEN_PARENT
Message-ID: <20210930134343.ztq3hgianm34dvqb@skbuf>
References: <CAGETcx-ZvENq8tFZ9wb_BCPZabpZcqPrguY5rsg4fSNdOAB+Kw@mail.gmail.com>
 <YSpr/BOZj2PKoC8B@lunn.ch>
 <CAGETcx_mjY10WzaOvb=vuojbodK7pvY1srvKmimu4h6xWkeQuQ@mail.gmail.com>
 <YS4rw7NQcpRmkO/K@lunn.ch>
 <CAGETcx_QPh=ppHzBdM2_TYZz3o+O7Ab9-JSY52Yz1--iLnykxA@mail.gmail.com>
 <YS6nxLp5TYCK+mJP@lunn.ch>
 <CAGETcx90dOkw+Yp5ZRNqQq2Ny_ToOKvGJNpvyRohaRQi=SQxhw@mail.gmail.com>
 <YS608fdIhH4+qJsn@lunn.ch>
 <20210831231804.zozyenear45ljemd@skbuf>
 <CAGETcx8MXzFhhxom3u2MXw8XA-uUtm9XGEbYNobfr+Ptq5+fVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx8MXzFhhxom3u2MXw8XA-uUtm9XGEbYNobfr+Ptq5+fVQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saravana,

On Wed, Sep 29, 2021 at 10:33:16PM -0700, Saravana Kannan wrote:
> On Tue, Aug 31, 2021 at 4:18 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > On Wed, Sep 01, 2021 at 01:02:09AM +0200, Andrew Lunn wrote:
> > > Rev B is interesting because switch0 and switch1 got genphy, while
> > > switch2 got the correct Marvell PHY driver. switch2 PHYs don't have
> > > interrupt properties, so don't loop back to their parent device.
> >
> > This is interesting and not what I really expected to happen. It goes to
> > show that we really need more time to understand all the subtleties of
> > device dependencies before jumping on patching stuff.
> >
> > In case the DSA tree contains more than one switch, different things
> > will happen in dsa_register_switch().
> > The tree itself is only initialized when the last switch calls
> > dsa_register_switch(). All the other switches just mark themselves as
> > present and exit probing early. See this piece of code in dsa_tree_setup:
> >
> >         complete = dsa_tree_setup_routing_table(dst);
> >         if (!complete)
> >                 return 0;
> 
> Hi Vladimir,
> 
> Can you point me to an example dts file that has a DSA tree with more
> than one switch and also point me to the switches that form the tree?
> 
> I'm working on a RFC series that tries to improve some stuff and
> having an example DTS to look at would help.
> 
> Thanks,
> Saravana

Andrew is testing with arch/arm/boot/dts/vf610-zii-dev-rev-b.dts.

Graphically it looks like this:

 +-----------------------------+
 |          VF610 SoC          |
 |          +--------+         |
 |          |  fec1  |         |
 +----------+--------+---------+
                | DSA master
                |
                | ethernet = <&fec1>;
 +--------+----------+---------------------------+
 |        |  port@6  |                           |
 |        +----------+                           |
 |        | CPU port |     dsa,member = <0 0>;   |
 |        +----------+      -> tree 0, switch 0  |
 |        |   cpu    |                           |
 |        +----------+                           |
 |                                               |
 |            switch0                            |
 |                                               |
 +-----------+-----------+-----------+-----------+
 |   port@0  |   port@1  |   port@2  |   port@5  |
 +-----------+-----------+-----------+-----------+
 |switch0phy0|switch0phy1|switch0phy2|   no PHY  |
 +-----------+-----------+-----------+-----------+
 | user port | user port | user port | DSA port  |
 +-----------+-----------+-----------+-----------+
 |    lan0   |    lan1   |    lan2   |    dsa    |
 +-----------+-----------+-----------+-----------+
                                           | link = <&switch1port6 &switch2port9>;
                                           |
                                           |
                                           |
                                           | link = <&switch0port5>;
                           +----------+----------+-------------------------+
                           |          |  port@6  |                         |
                           |          +----------+                         |
                           |          | DSA port |    dsa,member = <0 1>;  |
                           |          +----------+     -> tree 0, switch 1 |
                           |          |   dsa    |                         |
                           |          +----------+                         |
                           |                                               |
                           |            switch1                            |
                           |                                               |
                           +-----------+-----------+-----------+-----------+
                           |   port@0  |   port@1  |   port@2  |   port@5  |
                           +-----------+-----------+-----------+-----------+
                           |switch1phy0|switch1phy1|switch2phy2|   no PHY  |
                           +-----------+-----------+-----------+-----------+
                           | user port | user port | user port | DSA port  |
                           +-----------+-----------+-----------+-----------+
                           |    lan3   |    lan4   |    lan5   |   dsa     |
                           +-----------+-----------+-----------+-----------+
                                                                    | link = <&switch2port9>;
                                                                    |
                                                                    |
                                                                    |
                                                                    | link = <&switch1port5 &switch0port5>;
                                                    +----------+----------+-------------------------------------+
                                                    |          |  port@9  |                                     |
                                                    |          +----------+                                     |
                                                    |          | DSA port |      dsa,member = <0 2>;            |
                                                    |          +----------+       -> tree 0, switch 2           |
                                                    |          |   dsa    |                                     |
                                                    |          +----------+                                     |
                                                    |                                                           |
                                                    |            switch2                                        |
                                                    |                                                           |
                                                    +-----------+-----------+-----------+-----------+-----------+
                                                    |   port@0  |   port@1  |   port@2  |   port@3  |   port@4  |
                                                    +-----------+-----------+-----------+-----------+-----------+
                                                    |switch2phy0|switch2phy1|switch2phy2|   no PHY  |   no PHY  |
                                                    +-----------+-----------+-----------+-----------+-----------+
                                                    | user port | user port | user port | user port | user port |
                                                    +-----------+-----------+-----------+-----------+-----------+
                                                    |    lan6   |    lan7   |   lan8    |  optical3 |  optical4 |
                                                    +-----------+-----------+-----------+-----------+-----------+
