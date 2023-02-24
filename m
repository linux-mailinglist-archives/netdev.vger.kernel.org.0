Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9FA6A2147
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjBXSQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBXSQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:16:28 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321E16C51B
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:16:26 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id ck15so949866edb.0
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gak9Zz54oLK2DF9YpUqRiFQ6ukYGvkDO0C2i7WdaOeY=;
        b=gdLTnb38YYKn4MongG0BubSyl0hpHUqBWZR94WcoZMFIiHwVWIDD7y2ZiZCESfynlE
         4TSdc20lTzPizkraAGX6Xn7nAGEUU/rqzLXjirwNG4GRRcBB+RkoYfEQP4btQJ/g9b4n
         g9zUE/MWLubgePon7GIO3QIabn+bE5eIK0T8K0lVnFOkWUGpucJpEoK6JPlUSsjuq5uW
         IDVuwTQ/7dqehDYhZHZK9ZdnacK7/VM6/fMFRZ601LQrZmn2rVAOBW1Trdm0j+7ZYvTP
         gaDQs6kzVe+eWlIapXdU6XE+YIrwmZEc/uSH48dp0c3s46twtwisZH8afgcmQdv8KZEc
         7afw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gak9Zz54oLK2DF9YpUqRiFQ6ukYGvkDO0C2i7WdaOeY=;
        b=GEY0fwIBIEb/c/Oi4ydXfl5eUS8wj0No3TGkECPDBtGfx07wke3hapO18lEkKQ/YBo
         Eb4671GFl/NZCJhDvhi1Quju9OYIjD3KJcLQpXQSqsDVCEsho4pw++tcGr27asCCnqa0
         dkC09B4DReFaulC18kpUYE0xRwdvBpd4MEDaDXWQxVLlgHrST0mICqS4tgw19jRZWUDG
         8xI8lrsYYId8hH1xcBuDvpfktS57x4Hy8jsEDMXPScQO9gmLDE2NvgFFWTPnESldlRQJ
         1CC0bzvtyGXuyWPr+4frl7Xk1ldbfF2yujwL4Wm6EpFKv84tn6VwIcU7QjDcgImnf75C
         vayQ==
X-Gm-Message-State: AO0yUKXP298+E73htPnX3jRUOH9oZl6+qQxsb+waJ7jxKjKAfSJwpDeP
        nQz7KLRlaXa+DZagdSfd0kw=
X-Google-Smtp-Source: AK7set8jAvGyMs/tPbD6rDql0jkDWTgwnU8tO9QM38LyHAZxJYKMVQsKQRDgKDr17LK6rRm6mVzDUQ==
X-Received: by 2002:a17:906:694f:b0:872:84dd:8903 with SMTP id c15-20020a170906694f00b0087284dd8903mr25378672ejs.59.1677262584543;
        Fri, 24 Feb 2023 10:16:24 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id ay14-20020a170906d28e00b008d2d2d617ccsm6811606ejb.17.2023.02.24.10.16.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 10:16:24 -0800 (PST)
Date:   Fri, 24 Feb 2023 20:16:21 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: Choose a default DSA CPU port
Message-ID: <20230224181621.gri7vlqh44tpjkot@skbuf>
References: <a4936eb8-dfaa-e2f8-b956-75e86546fbf3@arinc9.com>
 <trinity-4025f060-3bb8-4260-99b7-e25cbdcf9c27-1676800164589@3c-app-gmx-bs35>
 <20230221002713.qdsabxy7y74jpbm4@skbuf>
 <trinity-105e0c2e-38e7-4f44-affd-0bc41d0a426b-1677086262623@3c-app-gmx-bs54>
 <20230222180623.cct2kbhyqulofzad@skbuf>
 <9c9ab755-9b5e-4e76-0e3c-119d567fc39d@arinc9.com>
 <20230222193440.c2vzg7j7r32xwr5l@skbuf>
 <e89af7bd-2f4c-3865-afa5-276a6acbc16f@arinc9.com>
 <trinity-c58a37c3-aa55-48b3-9d6c-71520ad2a81d-1677262043715@3c-app-gmx-bap70>
 <20230224181326.5lbph42bs566t2ci@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224181326.5lbph42bs566t2ci@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 08:13:26PM +0200, Vladimir Oltean wrote:
> On Fri, Feb 24, 2023 at 07:07:23PM +0100, Frank Wunderlich wrote:
> > root@bpi-r2:~# ethtool -S eth0 | grep -v ': 0'
> > NIC statistics:
> >      tx_bytes: 1643364546
> >      tx_packets: 1121377
> >      rx_bytes: 1270088499
> >      rx_packets: 1338400
> >      p06_TxUnicast: 1338274
> >      p06_TxMulticast: 120
> >      p06_TxBroadcast: 6
> >      p06_TxPktSz65To127: 525948
> >      p06_TxPktSz128To255: 5
> >      p06_TxPktSz256To511: 16
> >      p06_TxPktSz512To1023: 4
> >      p06_Tx1024ToMax: 812427
> >      p06_TxBytes: 1275442099
> >      p06_RxFiltering: 16
> >      p06_RxUnicast: 1121339
> >      p06_RxMulticast: 37
> >      p06_RxBroadcast: 1
> >      p06_RxPktSz64: 3
> >      p06_RxPktSz65To127: 43757
> >      p06_RxPktSz128To255: 3
> >      p06_RxPktSz256To511: 3
> >      p06_RxPktSz1024ToMax: 1077611
> >      p06_RxBytes: 1643364546
> 
> Looking at the drivers, I see pause frames aren't counted in ethtool -S,
> so we wouldn't know this. However the slowdown *is* lossless, so the
> hypothesis is still not disproved.
> 
> Could you please test after removing the "pause" property from the
> switch's port@6 device tree node?

ah, it is..

static const struct mt7530_mib_desc mt7530_mib[] = {
	MIB_DESC(1, 0x2c, "TxPause"),
};

however it's still good to retest with this variable eliminated.
