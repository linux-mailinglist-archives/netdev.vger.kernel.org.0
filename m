Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B453E31AAF8
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 12:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbhBMLPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 06:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhBMLPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 06:15:08 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6D7C061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 03:14:27 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id i8so3586077ejc.7
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 03:14:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9BpJR39N56Am74krAWaz9wPpWNope6ntCc3XZzF/9lo=;
        b=JEWZUMRUHEzDgCQKb0i4BVQWRlbRlIxw72F9k8Tf4MlzaatHbFrO/T5M0jO4nBG4ex
         kNMZJbJsCInVBqQHJR5M8iGnD4Th9mcSzct5AFcQt4psq9mCaoZi9ob00Jpo2zqEopM6
         dT3C5DKMoNmNy3jXsphW2tpWw/1QRYb2ftbBdkW5yuIKsE+xBEBzjJ3aZ06N992g9wvj
         N42AW1rVi8MnL2Hanlm5OJCthxsu1qePtrGy7yfvgf2zrpDVTqAI6SciOPaBTkJ5nbRh
         +zYpUWdihrHAITpVsfntjWxLI9qjx7w2Ux0TbYSoRObxWXfrt5K0JGSHaxXDLXBVqxIp
         DevQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9BpJR39N56Am74krAWaz9wPpWNope6ntCc3XZzF/9lo=;
        b=Y8i1CksGavp+uoD4ba08rC6ZtXoHeRKAehcNtZrx4ApEVJBiHriuK12+b4ackhLL6d
         frVkXgU/Q118cI6fmXV6a2ao3Sjv/UQyKnYcuN8ygK1ky9bQ0wkA68mRLR183qOuoTbX
         O7kn7T9/vNDaEMaWx/QaThCtC2/2cWnkyGIcPPIAeG+OWHuBxU1QS6aMH4PSVxev/Ogc
         PFiYcwtjP7lySaTYR2oMoxWLO5rcONnb5CHZG+gOv5Bj0ZYDuFJ0lpyAyTbA5JKlRLNV
         fE2nR2N5qBu5rgtCGxc3DHfZudyyqD5G85FA8g6Hbb9gAbbv1li0yPcoFjiHeJSC/Yvv
         85MQ==
X-Gm-Message-State: AOAM532llvXhkewKQEEFKSNL8yeEdCzQvV0OUCC8oBheLfoWaACBBNGO
        P7LvpXRnKadKzfbfm57mNRNluKu62OU=
X-Google-Smtp-Source: ABdhPJy9LdbX3DGY8FpUs+Bld47m7pD3ZjrRRXcR/xm4MIkQqZyu1DT/fF/tXCcOVMeQ2pIveojBMQ==
X-Received: by 2002:a17:906:5e59:: with SMTP id b25mr7119225eju.536.1613214866431;
        Sat, 13 Feb 2021 03:14:26 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id a25sm7196184edt.16.2021.02.13.03.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 03:14:25 -0800 (PST)
Date:   Sat, 13 Feb 2021 13:14:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kernel test robot <lkp@intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kbuild-all@lists.01.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 12/12] net: dsa: tag_ocelot_8021q: add support
 for PTP timestamping
Message-ID: <20210213111424.23h4oqaahcmkow2d@skbuf>
References: <20210213001412.4154051-13-olteanv@gmail.com>
 <202102131509.tNiKQPgX-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202102131509.tNiKQPgX-lkp@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 13, 2021 at 03:42:46PM +0800, kernel test robot wrote:
>    ld: net/dsa/tag_ocelot_8021q.o: in function `ocelot_xmit_ptp':
> >> net/dsa/tag_ocelot_8021q.c:34: undefined reference to `ocelot_port_inject_frame'

Good catch, the problem is that the DSA taggers can be built without
support for the switch driver. I've created some shim definitions in
include/soc/mscc/ocelot.h:

/* Packet I/O */
#if IS_ENABLED(CONFIG_MSCC_OCELOT_SWITCH_LIB)

bool ocelot_can_inject(struct ocelot *ocelot, int grp);
void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
			      u32 rew_op, struct sk_buff *skb);
int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **skb);
void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp);

#else

static inline bool ocelot_can_inject(struct ocelot *ocelot, int grp)
{
	return true;
}

static inline void ocelot_port_inject_frame(struct ocelot *ocelot, int port,
					    int grp, u32 rew_op,
					    struct sk_buff *skb)
{
}

static inline int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp,
					struct sk_buff **skb)
{
	return -EIO;
}

static inline void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp)
{
}

#endif
