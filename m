Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52CC3BE5C4
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 11:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhGGJoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 05:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbhGGJoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 05:44:37 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B55C061764
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 02:41:57 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1m1440-0007R2-9B; Wed, 07 Jul 2021 11:41:52 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1m143y-0001IM-E5; Wed, 07 Jul 2021 11:41:50 +0200
Date:   Wed, 7 Jul 2021 11:41:50 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     David Jander <david@protonic.nl>
Cc:     dev.kurt@vandijck-laurijssen.be, mkl@pengutronix.de,
        wg@grandegger.com, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>
Subject: Re: [PATCH v1 2/2] net: j1939: extend UAPI to notify about RX status
Message-ID: <20210707094150.rbccshvdp67fknbe@pengutronix.de>
References: <20210706115758.11196-1-o.rempel@pengutronix.de>
 <20210706115758.11196-2-o.rempel@pengutronix.de>
 <20210706152834.44e62837@erd992>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210706152834.44e62837@erd992>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:32:43 up 216 days, 23:39, 46 users,  load average: 0.04, 0.07,
 0.06
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 06, 2021 at 03:28:34PM +0200, David Jander wrote:
> On Tue,  6 Jul 2021 13:57:58 +0200
> Oleksij Rempel <o.rempel@pengutronix.de> wrote:
> 
> > -static size_t j1939_sk_opt_stats_get_size(void)
> > +static size_t j1939_sk_opt_stats_get_size(enum j1939_sk_errqueue_type type)
> >  {
> > -	return
> > -		nla_total_size(sizeof(u32)) + /* J1939_NLA_BYTES_ACKED */
> > -		0;
> > +	switch (type) {
> > +	case J1939_ERRQUEUE_RX_RTS:
> > +		return
> > +			nla_total_size(sizeof(u32)) + /* J1939_NLA_BYTES_ALL */
> > +			nla_total_size(sizeof(u64)) + /* J1939_NLA_DEST_ADDR */
> > +			nla_total_size(sizeof(u64)) + /* J1939_NLA_SRC_ADDR */
> 
> DST and SRC address are u8...?

done

> > +			nla_total_size(sizeof(u64)) + /* J1939_NLA_DEST_NAME */
> > +			nla_total_size(sizeof(u64)) + /* J1939_NLA_SRC_NAME */
> > +		nla_put_u8(stats, J1939_NLA_SRC_ADDR,
> > +			   session->skcb.addr.sa);
> > +		nla_put_u8(stats, J1939_NLA_DEST_ADDR,
> > +			   session->skcb.addr.da);
> 
> See above.
> Also, shouldn't the order of these be the same as in
> j1939_sk_opt_stats_get_size()... for readability?

ack, done

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
