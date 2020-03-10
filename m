Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D34A717F0F0
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 08:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgCJHJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 03:09:39 -0400
Received: from mail-qv1-f44.google.com ([209.85.219.44]:43004 "EHLO
        mail-qv1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgCJHJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 03:09:39 -0400
Received: by mail-qv1-f44.google.com with SMTP id ca9so2496691qvb.9
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 00:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=FEWD/ua14Jn9e96iXuNlSzIBnvTN+yI0ZefQRPXmyyQ=;
        b=dZRhJWwvqSzbYQ1mjTFm/nSevjD/02yUBBwaixdIKrtc2Bz3ptJwZAiGu+jFqLmxdG
         +Er5fFq+Zps3hxFXKide7AHuMUx4GiHQBK8ZOIQEabwgIMfBfIeCS15wl1cNs4nLfOAM
         ffpNtyurPetPzIK4nYd4RPQ/+5kCVvLmHpjE2D5yJdzexeMph0p8c5D0cqFGzYRsRrUM
         uGhofNr8bsx7yLXTdecCwxyTgdchd6i8wGAIH+bFtqarNVL83ESzVR2HI5lhGIqRF3T6
         Vm54DswyVpzIB+RjKiV2OP5L/vJeHoQ2SY4IRvTEd8YrbWajeAtNXwWV2rfSp07rq5uL
         zaNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=FEWD/ua14Jn9e96iXuNlSzIBnvTN+yI0ZefQRPXmyyQ=;
        b=FuhcFxUnMXiZxRRi40BsoJHT04N8bN/cmwE1BmvWdaLYs0wz1SI17gWSqnYT2nTt4B
         jGVp5Jx+2l4ZQINN8MqQJnwK00x3ZJR0eEcVKb/0orhWiRkLJpsUFN/7DEt/x2TGgwyZ
         YGUFFXe1nlfIl5j9vaCOrYKjpCmWRQAuyUrYhVqVORgEK/UBfU1xPhHKSwHXTwrE+7Iy
         N0yfmAZB2unsfNvWLnWDw1CXmWnE+IbMnrCqia2AI5+JFfHhbezxmr/EbEvIWEZiX7s0
         ibJ6KoYv0rirMlFrfdpIroNQc4FSuIvF4RNvh6MLgHTvzZDpNbD3nZXbzMAnPPiI4L9/
         +J8w==
X-Gm-Message-State: ANhLgQ26Q33iZXxhnuR2MyuGqseQS0gfm9fElXq08InwdCwGOW3oDKF+
        zUHjiTz5DjsoQC+vLQal1dM=
X-Google-Smtp-Source: ADFU+vtpV5NHyV+Tl1zy5mvGpQcvO9U60YRv2CorgNaqFgB+RVvoJdg2FSfeE52iNfhVEzC+o+r88g==
X-Received: by 2002:a0c:fcc4:: with SMTP id i4mr7035539qvq.191.1583824177691;
        Tue, 10 Mar 2020 00:09:37 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q142sm3645041qke.45.2020.03.10.00.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 00:09:36 -0700 (PDT)
Date:   Tue, 10 Mar 2020 15:09:29 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Jo-Philipp Wich <jo@mein.io>
Subject: Re: Regression: net/ipv6/mld running system out of memory (not a
 leak)
Message-ID: <20200310070929.GC2159@dhcp-12-139.nay.redhat.com>
References: <b9d30209-7cc2-4515-f58a-f0dfe92fa0b6@gmail.com>
 <20200303090035.GV2159@dhcp-12-139.nay.redhat.com>
 <20200303091105.GW2159@dhcp-12-139.nay.redhat.com>
 <bed8542b-3dc0-50e0-4607-59bd2aed25dd@gmail.com>
 <20200304064504.GY2159@dhcp-12-139.nay.redhat.com>
 <d34a35e0-2dbe-fab8-5cf8-5c80cb5ec645@gmail.com>
 <20200304090710.GZ2159@dhcp-12-139.nay.redhat.com>
 <63892fca-4da6-0beb-73d3-b163977ed2fb@gmail.com>
 <20200309083341.GB2159@dhcp-12-139.nay.redhat.com>
 <37e56e0b-3bde-2667-2a9c-f2304d42d008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <37e56e0b-3bde-2667-2a9c-f2304d42d008@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 09, 2020 at 01:31:16PM +0100, Rafał Miłecki wrote:
> > 2. Should we move ipv6_dev_mc_inc() from ipv6_add_dev() to ipv6_mc_up()?
> > I don't know yet, this dependents on whether we could add multicast address
> > on non-Ethernen dev.
> 
> I'm not the one to answer them surely with my limited net subsystem
> understanding :( Any idea how to proceed with this? I assume your patch
> is still the right step, do you think you can send it officially now?
> 
> 
> > > we call ipv6_mc_leave_localaddr() without ipv6_mc_join_localaddr()
> > > called first which seems unintuitive.
> > 
> > This doesn't matter much yet. As we will check if we have the address
> > in __ipv6_dev_mc_dec(), if not, we just return. But yes, form logic, this
> > looks asymmetric.
> 
> Right, just slightly unintuitive asymmetric code.

Hi Rafał,

I investigated this issue and am going to enable ipv6_mc_up for non-Ethernet
interface. The patch I sent you before will be post as a RFC for net-next.

Thanks
Hangbin
