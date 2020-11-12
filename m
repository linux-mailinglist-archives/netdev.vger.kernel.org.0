Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C4D2B06F2
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 14:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgKLNtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 08:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727790AbgKLNtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 08:49:14 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49F35C0613D1;
        Thu, 12 Nov 2020 05:49:14 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id cq7so6234197edb.4;
        Thu, 12 Nov 2020 05:49:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MPV3yW2odt+zjcLvgi5foXaZefhlaoNMN5fVUhCTo60=;
        b=H6L/LZ9nJYkQH4482zy8zeDCX1wapP0XU54WgAmX7CthhqbXBfkJ17XH6VjF7vt1px
         kBLj9N0E9rIbY5YCVmsESFCIw1/ywXYaw83GL8fzFACttQBizerwrTuwGOIPHuIjyMYX
         +7yl1IKwNRCPOda9PldsS4yDnCd620WneDur4zumNdII/7VWQZsfu/aWdJCEJo719DVI
         Oer9dt13PfLWHNfs0fhJQGXpdX1P6K3adkYyi9IXus8w0e9MZKtSGbMItrY3mtvO3VNp
         51FTOCULRf2M9BkcXnP6B8YSooyELt0yYwc2QxV19q9W/Se7/jJ7YjDIoLrygJ4CD3Kl
         ktYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MPV3yW2odt+zjcLvgi5foXaZefhlaoNMN5fVUhCTo60=;
        b=pWVCzlzhJL09ulZIwCMl+vNw5gPj+VKAQ5TIR7wtY9W57Zlnvyvtza10Cw1qEhVLus
         DwN7OMPkdu+5px7WkAwUrmZlW2st+RMO01M9rCPHz+c1AHBAMixHp6DacQFBJ/X6ynxH
         EMf3TUszLaJ6e1n7J09CcHFOWNHMmj62m8skRDDhpdC0haNSo156p7+qr+vvcd7SJPVR
         66RPU/hlJlqKYZ7a45GAuN5/911NmuPhGkiXmA7DioxCyqtTtDiQXnWWoE1DO+dj/2OO
         7FgVBzawphuSTl1ng6I2itwFZwm89acyVVlowaP8yo8fK/Lp//ig2h3qMLQ4c8vgnOu7
         UQOw==
X-Gm-Message-State: AOAM532Y/za4n3RmhiXB1ZUhZryxX5kSjXfK7l01fdEKGp5UbhMVBZ22
        KP2sn1JNKqeHUlQIIjPcUB8=
X-Google-Smtp-Source: ABdhPJxHUT+D32ZuT+OmWB5Ksu/4xQOrJJD2gMujrBENGUJ8FLxCmqD0vL5t0JHESnEoy5paf7TX0Q==
X-Received: by 2002:a05:6402:17ac:: with SMTP id j12mr5158071edy.31.1605188952971;
        Thu, 12 Nov 2020 05:49:12 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id pg24sm2174593ejb.72.2020.11.12.05.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 05:49:11 -0800 (PST)
Date:   Thu, 12 Nov 2020 15:49:10 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: listen for
 SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE on foreign bridge neighbors
Message-ID: <20201112134910.jpbfrjfwlb3734im@skbuf>
References: <20201108131953.2462644-1-olteanv@gmail.com>
 <20201108131953.2462644-4-olteanv@gmail.com>
 <CALW65jb+Njb3WkY-TUhsHh1YWEzfMcXoRAXshnT8ke02wc10Uw@mail.gmail.com>
 <20201108172355.5nwsw3ek5qg6z7yx@skbuf>
 <c35d48cd-a1ea-7867-a125-0f900e1e8808@linux.ibm.com>
 <20201111103601.67kqkaphgztoifzl@skbuf>
 <dd9c1f37-a049-ef69-b915-214c869edb51@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd9c1f37-a049-ef69-b915-214c869edb51@linux.ibm.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 03:14:26PM +0100, Alexandra Winter wrote:
> On 11.11.20 11:36, Vladimir Oltean wrote:
> > Hi Alexandra,
> > 
> > On Wed, Nov 11, 2020 at 11:13:03AM +0100, Alexandra Winter wrote:
> >> On 08.11.20 18:23, Vladimir Oltean wrote:
> >>> On Sun, Nov 08, 2020 at 10:09:25PM +0800, DENG Qingfang wrote:
> >>>> Can it be turned off for switches that support SA learning from CPU?
> >>>
> >>> Is there a good reason I would add another property per switch and not
> >>> just do it unconditionally?
> >>>
> >> I have a similar concern for a future patch, where I want to turn on or off, whether the
> >> device driver listens to SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE for a certain interface.
> >> (Options will be: static MACs only, learning in the device or learning in bridge and notifications to device)
> >> What about 'bridge link set dev $netdev learning_sync on self' respectively the corresponding netlink message?
> > 
> > My understanding is that "learning_sync" is for pushing learnt addresses
> > from device to bridge, not from bridge to device.
> > 
> uh, sorry copy-paste error. I meant:
> 'bridge link set dev $netdev learning on self'

Even with "learning" instead of "learning_sync", I don't understand what
the "self" modifier would mean and how it would help, sorry.
