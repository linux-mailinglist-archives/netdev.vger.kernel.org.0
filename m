Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90BD769B1F7
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 18:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjBQRoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 12:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjBQRoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 12:44:37 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311DD70940;
        Fri, 17 Feb 2023 09:44:36 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id 4-20020a05600c22c400b003dc4fd6e61dso1500087wmg.5;
        Fri, 17 Feb 2023 09:44:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=auVrVbOSTA9pQeJfPXz91TlriegzpUKwC2EMUID2gPE=;
        b=kPts36a0DOfrWbE5EDMVM8XUTfPhcct1+Wh6iYrEUNULUaJQQ940e2QgPodOvnNQ3O
         PYVdDfrIzrIPE0Vc2g/vfe89g2tIAWRInxGmIeY2ABwKLrTGnwzSZXS4/ClMgmErrlyZ
         2VJyFiXyf6FXfFu8h4TAk5sbo9ObWj2hpaMsr5iTHYK0yLpQeXx/71BXJmUTcn6Wvk9c
         PmQQIK6oRsnk/d8C/SuDJEsTzFKhOVo3Uq5HnXasc+0Bv5iNajhahka3DZoCuSzV0nXu
         U1ZgVBV32o0fJltdnu8cEis7bX2g96yWawZ5DbL8oya33c0Sw88227zU/BpoJxCJOwQD
         DEAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=auVrVbOSTA9pQeJfPXz91TlriegzpUKwC2EMUID2gPE=;
        b=zhR1inJqGY8yG2qKKs9jUFCHLGNNcYodvO+Gttq9qnflp4+yhjX3jBLcGTZ/uJEsKB
         JbpQ2SJysQId/lrk101SKxenFsery1IpFEwNRHSpeZUYxfAUpWb/KnLBDlODQAL115aa
         kKADHUqy3arQJnObYxtuDOV0ks7u9Lfue53bMEr7KZDIRNR0H3dKn9yt9Ki+I5hVbLS/
         WPIiCElH8IwRDOOMRfg0PMRRjHIWeXeoWTcnn27VpUCumQipcBiOfyZoMuxkYMNzzI+O
         li5PGj1qQO+89N4zmm3OqwroPlqiJP/THgtJJmZF8JmyYb7Ml8B309ZXY7R+8Tff9RBx
         oNHw==
X-Gm-Message-State: AO0yUKXVqSjHKUby8f4xewJC/5inYIYvNtRVLFLErsegTv6jqLq8BRFN
        jxBIngbcl8P9ZVoFrdX4cB4=
X-Google-Smtp-Source: AK7set/fy/Eb7Sue92rcdrDm3lCCSH8M5LFbef1BLFLsabLm+s8mqQPhJsjPKF5bbxALYzTFXwfvuA==
X-Received: by 2002:a05:600c:30ca:b0:3d5:365b:773e with SMTP id h10-20020a05600c30ca00b003d5365b773emr1835463wmn.39.1676655874493;
        Fri, 17 Feb 2023 09:44:34 -0800 (PST)
Received: from skbuf ([188.25.231.176])
        by smtp.gmail.com with ESMTPSA id x14-20020a1c7c0e000000b003e20970175dsm6651711wmc.32.2023.02.17.09.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 09:44:34 -0800 (PST)
Date:   Fri, 17 Feb 2023 19:44:31 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans Schultz <netdev@kapio-technology.com>
Cc:     Simon Horman <simon.horman@corigine.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "maintainer:MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next 5/5] net: dsa: mv88e6xxx: implementation of
 dynamic ATU entries
Message-ID: <20230217174431.bkkvfmtno56mfh5a@skbuf>
References: <20230130173429.3577450-1-netdev@kapio-technology.com>
 <20230130173429.3577450-6-netdev@kapio-technology.com>
 <Y9lkXlyXg1d1D0j3@corigine.com>
 <9b12275969a204739ccfab972d90f20f@kapio-technology.com>
 <Y9zDxlwSn1EfCTba@corigine.com>
 <20230203204422.4wrhyathxfhj6hdt@skbuf>
 <Y94TebdRQRHMMj/c@corigine.com>
 <4abbe32d007240b9c3aea9c8ca936fa3@kapio-technology.com>
 <Y+EkiAyexZrPoCpP@corigine.com>
 <87fsb83q5s.fsf@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fsb83q5s.fsf@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 14, 2023 at 10:14:55PM +0100, Hans Schultz wrote:
> On Mon, Feb 06, 2023 at 17:02, Simon Horman <simon.horman@corigine.com> wrote:
> >
> > Just to clarify my suggestion one last time, it would be along the lines
> > of the following (completely untested!). I feel that it robustly covers
> > all cases for fdb_flags. And as a bonus doesn't need to be modified
> > if other (unsupported) flags are added in future.
> >
> > 	if (fdb_flags & ~(DSA_FDB_FLAG_DYNAMIC))
> > 		return -EOPNOTSUPP;
> >
> > 	is_dynamic = !!(fdb_flags & DSA_FDB_FLAG_DYNAMIC)
> > 	if (is_dynamic)
> > 		state = MV88E6XXX_G1_ATU_DATA_STATE_UC_AGE_7_NEWEST;
> >
> >
> > And perhaps for other drivers:
> >
> > 	if (fdb_flags & ~(DSA_FDB_FLAG_DYNAMIC))
> > 		return -EOPNOTSUPP;
> > 	if (fdb_flags)
> > 		return 0;
> >
> > Perhaps a helper would be warranted for the above.
> 
> How would such a helper look? Inline function is not clean.
> 
> >
> > But in writing this I think that, perhaps drivers could return -EOPNOTSUPP
> > for the DSA_FDB_FLAG_DYNAMIC case and the caller can handle, rather tha
> > propagate, -EOPNOTSUPP.
> 
> I looked at that, but changing the caller is also a bit ugly.

Answering on behalf of Simon, and hoping he will agree.

You are missing a big opportunity to make the kernel avoid doing useless work.
The dsa_slave_fdb_event() function runs in atomic switchdev notifier context,
and schedules a deferred workqueue item - dsa_schedule_work() - to get sleepable
context to program hardware.

Only that scheduling a deferred work item is not exactly cheap, so we try to
avoid doing that unless we know that we'll end up doing something with that
FDB entry once the deferred work does get scheduled:

	/* Check early that we're not doing work in vain.
	 * Host addresses on LAG ports still require regular FDB ops,
	 * since the CPU port isn't in a LAG.
	 */
	if (dp->lag && !host_addr) {
		if (!ds->ops->lag_fdb_add || !ds->ops->lag_fdb_del)
			return -EOPNOTSUPP;
	} else {
		if (!ds->ops->port_fdb_add || !ds->ops->port_fdb_del)
			return -EOPNOTSUPP;
	}

What you should be doing is you should be using the pahole tool to find
a good place for a new unsigned long field in struct dsa_switch, and add
a new field ds->supported_fdb_flags. You should extend the early checking
from dsa_slave_fdb_event() and exit without doing anything if the
(fdb->flags & ~ds->supported_fdb_flags) expression is non-zero.

This way you would kill 2 birds with 1 stone, since individual drivers
would no longer need to check the flags; DSA would guarantee not calling
them with unsupported flags.

It would be also very good to reach an agreement with switchdev
maintainers regarding the naming of the is_static/is_dyn field.

It would also be excellent if you could rename "fdb_flags" to just
"flags" within DSA.
