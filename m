Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA50C40436F
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 04:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234679AbhIICK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 22:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbhIICK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 22:10:28 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909BDC061575;
        Wed,  8 Sep 2021 19:09:19 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso308788pjh.5;
        Wed, 08 Sep 2021 19:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WCQL+26ndWehB3HytgD9RHZNJoTuFQiOzRw3KyTzECs=;
        b=K0jOqmzn+w4bLA4mSd8wBAITdn3nf21/87iTnEEsX54ypDt//ifRuYxWGPXARFQec5
         24JveKsWTZiOzcHy/irXh19NwjFJ0v4ZLV7pSRVZ/wV5kg75E7Abyk7Kll8fTOkBPnJb
         VKxnAsoC3foqFM+J2ljWP+CHQfv1QvYArmD4jZeJkQ+V22hXDpysF8h7DWARqetPrtml
         d/qx6sUaxhd8PWt+sue1AsrWgHclUbIR51rRElpymavJg3XgSNwPBwWsoOACKEv6oNSB
         ROyM7tbun0myWyOSIB8WR1YRyYomdkPjC7rTsr3WzZpvHYwaQTcYER2tCZnllP6MV73a
         mk0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WCQL+26ndWehB3HytgD9RHZNJoTuFQiOzRw3KyTzECs=;
        b=t+IXpImzyNKmlxI/P2hNmTNcMP2FLHdLXO2MpBUrU0sWIi2TvROqtSgOQjR0TzPCKg
         YFyY1jsTGDiLG5OFQs0m4CEN0CxbB47z2I88Ni3UM0hrseYblTfOlUljYMX87oHBqtXi
         HRG8Ukb0kj/1elrvGESDP4s7Trb7pYn6xsKVzBQvSJ1sitT0XKC5uR3f1N+Pb9aFqPMR
         hQtfk56sAOzQXAdiPibTQxgbii0ZXNTP205KIEG/gPjhm9UvUyRC01WVamxPZ4eIvfuU
         XAvC+T1vNhPISI+pFzJj0h8kizoaDqtGnfr1kepHsSZH3HZxtROAAlvShZ5wPokX9Qyl
         8GsA==
X-Gm-Message-State: AOAM532Qxx10bkVbK3QnI/X1PkjAfCDHnn0GHOuELxt7o+AqbrJMbl+0
        SO1+oJMDGgTmrSljbnCAi5E=
X-Google-Smtp-Source: ABdhPJxl68lYuI77ex5AJLVsBvo8R8x4GXECVWZkFVi4DnztYmI5D930KIbiq700Gxuia2LGPMSIog==
X-Received: by 2002:a17:902:ec90:b0:13a:34f9:cfe9 with SMTP id x16-20020a170902ec9000b0013a34f9cfe9mr669621plg.74.1631153359116;
        Wed, 08 Sep 2021 19:09:19 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id p30sm174357pfh.116.2021.09.08.19.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 19:09:18 -0700 (PDT)
Date:   Wed, 8 Sep 2021 19:09:15 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "Machnikowski, Maciej" <maciej.machnikowski@intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Saeed Mahameed <saeed@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Message-ID: <20210909020915.GA30747@hoboy.vegasvil.org>
References: <PH0PR11MB495152B03F32A5A17EDB2F6CEAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210907075509.0b3cb353@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR11MB49512C265E090FC8741D8510EAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210907124730.33852895@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR11MB495169997552152891A69B57EAD49@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210908092115.191fdc28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR11MB4951AA3C65DD8E7612F5F396EAD49@PH0PR11MB4951.namprd11.prod.outlook.com>
 <YTkQTQM6Is4Hqmxh@lunn.ch>
 <20210908152027.313d7168@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YTlAT+1wkazy3Uge@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTlAT+1wkazy3Uge@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 09, 2021 at 12:59:27AM +0200, Andrew Lunn wrote:
> On Wed, Sep 08, 2021 at 03:20:27PM -0700, Jakub Kicinski wrote:
> > On Wed, 8 Sep 2021 21:34:37 +0200 Andrew Lunn wrote:
> > > Since we are talking about clocks and dividers, and multiplexors,
> > > should all this be using the common clock framework, which already
> > > supports most of this? Do we actually need something new?
> > 
> > Does the common clock framework expose any user space API?
> 
> Ah, good point. No, i don't think it does, apart from debugfs, which
> is not really a user space API, and it contains read only descriptions
> of the clock tree, current status, mux settings, dividers etc.

Wouldn't it make sense to develop some kind of user land API to
manipulate the common clock framework at run time?

Just dreaming...

Richard
