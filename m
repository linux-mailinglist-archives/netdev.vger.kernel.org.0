Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1477C344CF8
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbhCVRNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbhCVRNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 13:13:34 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4370CC061574;
        Mon, 22 Mar 2021 10:13:33 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id jy13so22524097ejc.2;
        Mon, 22 Mar 2021 10:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wwJtab4A329FXksuBKVJi/Nx6bKYmPZ1sJgf6Ui876E=;
        b=Xgfj33jtihnlxFFXPhoZp3X/m+0n1o53VZ/2wUPkn6sM4M7oPUgTs4vQZgNYH8P31u
         2WaclFiMGgj3haBEZnAfGQU1onj8LKsVA9e5JpOH88wyrRIoPS674wkmXPJKfow7DidK
         NiVdIbf0nUrMNv0Bp28JHlJYx6WDuCXyZonAmwf/uKeyRuskBmlt1h9vqmQRmF2VKgkm
         lTMSaqG8PuGbdYy0F37uRT6J+0Hjl/SbFoU4kjfU/O3LIyzablF9mSHLmh9VbNBG5uHK
         gGpJG+ZWH+9Hamw15AmNmRZ5SApBTfqx8T6FOCeyiX0GY7gLq7S/6Wke3C9UFPmM5l8w
         YSaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wwJtab4A329FXksuBKVJi/Nx6bKYmPZ1sJgf6Ui876E=;
        b=Q3RIMUdFmJInEgNxxBo59ZgbXuyAjv3DERsDDSQL+wigqbNG/31Ev+v6soYHQQgM/T
         QSctDeDAkWnGOaQO2u46YnAzD97WgFRqD3N6uJ6enMzAhVHvHCp6nj9OlfeTUvPAme97
         PeK6PvvVM4r4+72a2nAYXoIacEYS6TOn2UBJs0B8a0xzWPrFKeJxeuBuFYNffX0Njh2F
         8VxXHjoTRvyLK/i0V0E58yiyiRErzffiuRc8SQa4aZ7e/9MlYtTB9kFmWaWyjq/2W8uS
         MqDq+cYdkp7j/m5UiDSvd8CsSu7Eai1JPDc3KxJYn9R62nrvQdjK5dkgQN2ECqfr+YN1
         UBbQ==
X-Gm-Message-State: AOAM532HyUbfCy6jYDzvML95UnlRmtddKWIt+bqr+kI7x7BUAr6srldv
        o7iqzIuFUcvIOAVVwYw4Ctg=
X-Google-Smtp-Source: ABdhPJw/Ina4sv9Jg5VgGTErX7Ai4K2YyGn5xnSTpnL1mRUvu4HATjhPug/vg1hI8I7XXh8yYU9BtQ==
X-Received: by 2002:a17:906:2dc1:: with SMTP id h1mr848804eji.460.1616433210869;
        Mon, 22 Mar 2021 10:13:30 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id sb4sm9998097ejb.71.2021.03.22.10.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 10:13:30 -0700 (PDT)
Date:   Mon, 22 Mar 2021 19:13:28 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH v2 net-next 09/16] net: dsa: replay port and local
 fdb entries when joining the bridge
Message-ID: <20210322171328.6ctmzyullywm3qmk@skbuf>
References: <20210318231829.3892920-1-olteanv@gmail.com>
 <20210318231829.3892920-10-olteanv@gmail.com>
 <87wntzmbva.fsf@waldekranz.com>
 <20210322161955.c3slrmbtofswrqiz@skbuf>
 <87o8fbm80o.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o8fbm80o.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 06:07:51PM +0100, Tobias Waldekranz wrote:
> On Mon, Mar 22, 2021 at 18:19, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Mon, Mar 22, 2021 at 04:44:41PM +0100, Tobias Waldekranz wrote:
> >> I do not know if it is a problem or not, more of an observation: This is
> >> not guaranteed to be an exact replay of the events that the bridge port
> >> (i.e. bond0 or whatever) has received since, in fdb_insert, we exit
> >> early when adding local entries if that address is already in the
> >> database.
> >> 
> >> Do we have to guard against this somehow? Or maybe we should consider
> >> the current behavior a bug and make sure to always send the event in the
> >> first place?
> >
> > I don't really understand what you're saying.
> > fdb_insert has:
> >
> > 	fdb = br_fdb_find(br, addr, vid);
> > 	if (fdb) {
> > 		/* it is okay to have multiple ports with same
> > 		 * address, just use the first one.
> > 		 */
> > 		if (test_bit(BR_FDB_LOCAL, &fdb->flags))
> > 			return 0;
> > 		br_warn(br, "adding interface %s with same address as a received packet (addr:%pM, vlan:%u)\n",
> > 		       source ? source->dev->name : br->dev->name, addr, vid);
> > 		fdb_delete(br, fdb, true);
> > 	}
> >
> > 	fdb = fdb_create(br, source, addr, vid,
> > 			 BIT(BR_FDB_LOCAL) | BIT(BR_FDB_STATIC));
> >
> > Basically, if the {addr, vid} pair already exists in the fdb, and it
> > points to a local entry, fdb_create is bypassed.
> >
> > Whereas my br_fdb_replay() function iterates over br->fdb_list, which is
> > exactly where fdb_create() also lays its eggs. That is to say, unless
> > I'm missing something, that duplicate local FDB entries that skipped the
> > fdb_create() call in fdb_insert() because they were for already-existing
> > local FDB entries will also be skipped by br_fdb_replay(), because it
> > iterates over a br->fdb_list which contains unique local addresses.
> > Where am I wrong?
> 
> No you are right. I was thinking back to my attempt of offloading local
> addresses and I distinctly remembered that local addresses could be
> added without a notification being sent.
> 
> But that is not what is happening. It is just already inserted on
> another port. So the notification would reach DSA, or not, depending on
> ordering the of events. But there will be no discrepancy between that
> and the replay.

I'm not saying that the bridge isn't broken, because it is, but for
different reasons, as explained here:
https://patchwork.kernel.org/project/netdevbpf/patch/20210224114350.2791260-9-olteanv@gmail.com/

What I can do is I can make br_switchdev_fdb_notify() skip fdb entries
with the BR_FDB_LOCAL bit set, and target that patch against "net", with
a Fixes: tag of 6b26b51b1d13 ("net: bridge: Add support for notifying
devices about FDB add/del").
Then I can also skip the entries with BR_FDB_LOCAL from br_fdb_replay.
Then, when I return to the "RX filtering for DSA" series, I can add the
"is_local" bit to switchdev FDB objects, and make all drivers reject
"is_local" entries (which is what the linked patch does) unless more
specific treatment is applied to those (trap to CPU).
Nikolay?
