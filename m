Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 035515BE63D
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 14:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbiITMuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 08:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiITMuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 08:50:14 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844404AD40
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 05:50:13 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1oachX-0001zP-Qx; Tue, 20 Sep 2022 14:50:11 +0200
Received: from mfe by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1oachX-0006os-HI; Tue, 20 Sep 2022 14:50:11 +0200
Date:   Tue, 20 Sep 2022 14:50:11 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Juergen Borleis <jbe@pengutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH] net: fec: limit register access on i.MX6UL
Message-ID: <20220920125011.em66q7t7buywvr4m@pengutronix.de>
References: <20220920095106.66924-1-jbe@pengutronix.de>
 <Yym2I8SYMW7HRWLD@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yym2I8SYMW7HRWLD@lunn.ch>
User-Agent: NeoMutt/20180716
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22-09-20, Andrew Lunn wrote:
> > +/* for i.MX6ul */
> > +static u32 fec_enet_register_offset_6ul[] = {
> > +	FEC_IEVENT, FEC_IMASK, FEC_R_DES_ACTIVE_0, FEC_X_DES_ACTIVE_0,
> > +	FEC_ECNTRL, FEC_MII_DATA, FEC_MII_SPEED, FEC_MIB_CTRLSTAT, FEC_R_CNTRL,
> > +	FEC_X_CNTRL, FEC_ADDR_LOW, FEC_ADDR_HIGH, FEC_OPD, FEC_TXIC0, FEC_RXIC0,
> > +	FEC_HASH_TABLE_HIGH, FEC_HASH_TABLE_LOW, FEC_GRP_HASH_TABLE_HIGH,
> > +	FEC_GRP_HASH_TABLE_LOW, FEC_X_WMRK, FEC_R_DES_START_0,
> > +	FEC_X_DES_START_0, FEC_R_BUFF_SIZE_0, FEC_R_FIFO_RSFL, FEC_R_FIFO_RSEM,
> > +	FEC_R_FIFO_RAEM, FEC_R_FIFO_RAFL, FEC_RACC,
> > +	RMON_T_DROP, RMON_T_PACKETS, RMON_T_BC_PKT, RMON_T_MC_PKT,
> > +	RMON_T_CRC_ALIGN, RMON_T_UNDERSIZE, RMON_T_OVERSIZE, RMON_T_FRAG,
> > +	RMON_T_JAB, RMON_T_COL, RMON_T_P64, RMON_T_P65TO127, RMON_T_P128TO255,
> > +	RMON_T_P256TO511, RMON_T_P512TO1023, RMON_T_P1024TO2047,
> > +	RMON_T_P_GTE2048, RMON_T_OCTETS,
> > +	IEEE_T_DROP, IEEE_T_FRAME_OK, IEEE_T_1COL, IEEE_T_MCOL, IEEE_T_DEF,
> > +	IEEE_T_LCOL, IEEE_T_EXCOL, IEEE_T_MACERR, IEEE_T_CSERR, IEEE_T_SQE,
> > +	IEEE_T_FDXFC, IEEE_T_OCTETS_OK,
> > +	RMON_R_PACKETS, RMON_R_BC_PKT, RMON_R_MC_PKT, RMON_R_CRC_ALIGN,
> > +	RMON_R_UNDERSIZE, RMON_R_OVERSIZE, RMON_R_FRAG, RMON_R_JAB,
> > +	RMON_R_RESVD_O, RMON_R_P64, RMON_R_P65TO127, RMON_R_P128TO255,
> > +	RMON_R_P256TO511, RMON_R_P512TO1023, RMON_R_P1024TO2047,
> > +	RMON_R_P_GTE2048, RMON_R_OCTETS,
> > +	IEEE_R_DROP, IEEE_R_FRAME_OK, IEEE_R_CRC, IEEE_R_ALIGN, IEEE_R_MACERR,
> > +	IEEE_R_FDXFC, IEEE_R_OCTETS_OK
> > +};
> >  #else
> >  static __u32 fec_enet_register_version = 1;
> 
> Seeing this, i wonder if the i.MX6ul needs its own register version,
> so that ethtool(1) knows what registers are valid?

Regarding the uAPI (uapi/linux/ethtool.h):
8<-------------------------------------------------
 * @version: Dump format version.  This is driver-specific and may
 *      distinguish different chips/revisions.  Drivers must use new
 *      version numbers whenever the dump format changes in an
 *      incompatible way.
8<-------------------------------------------------
I would say yes.

Regards,
  Marco
