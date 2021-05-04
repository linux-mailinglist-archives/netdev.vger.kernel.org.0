Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC06372FA2
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 20:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbhEDSTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 14:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbhEDSTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 14:19:32 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3145C061574;
        Tue,  4 May 2021 11:18:36 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id h4so10404775wrt.12;
        Tue, 04 May 2021 11:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PD5o2x4hC2GrLVKj0hWBxU0ZJAM2QadXrf4CT3uKJY0=;
        b=NicJKt0aAFERTlInOdfuxj8quLQnDuiKaczfIeDGyaDx25gGyIx+I2b1lQ4kjQN8Np
         Sn65HSVLpPprv37w3QDmXoGjgtU1KM/mM8KvEfVIdwXJKmQeDhF4DBauv6EZ5TTXvNAa
         Z4QuwhBSjjvEjyhtFc105g8362ipAaxCdxqSplA0VhBLug1ilfKjKBjHb/Cn6AzUEpEx
         iR87RMamzHaQnT+H5nYCaHU1nyGvCgJX3L6JV+IPLRNbQgjn6gMr8JR6zfP8zcIxzjBg
         dOT0kPz+bQBySRunKAGy0kLlyBQ++nnuJCcrtoToSggSjYK8RFc/n+89WaDqs05GoBGs
         YqoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PD5o2x4hC2GrLVKj0hWBxU0ZJAM2QadXrf4CT3uKJY0=;
        b=MJO2rDr6GGZaIpsXlVu1Ruzj0HxQ1JQvUNUg54VapSGL9Iq/AMp3nkI1SkYY5EeT1u
         q0wpVjfu6llaiKnFhsiD0NVFlJVNbURgUfTElJ9e09Rl9xAFnmfPM32c2XJ9R3zsVdNJ
         bguOv6LT3f6qeNVzggdtnr1xGJyFmOE5KOM8T4XocjEL3l6xH1pMHCoeCviZ0DwAFHS5
         9CZZNhSBMBXjO3vdSA+1fNwcvKnBSxMxRCiaay+uUoxCiA4Jnffhd+aqT7sh4a/kmSb1
         sgDe19Jvsxw6Mx9Fop0XuSsUqSlK8rAguBVWGJfpwe5emhTE4sCa5i1Ev+U/e5jyDRne
         ZldQ==
X-Gm-Message-State: AOAM533xQQdJiY9xzXt4hsN3zzJNF1QERzMTrIXUmyN0lhBorSyTfuLC
        816N6aclIx1dPpkyaWvaGfM=
X-Google-Smtp-Source: ABdhPJw6AN3YjhvdFUKGQS4mdGLgJA9ItQB8xfXkmTTu9QrFlJQ+fp3YvQZmhopirc+hRKnEjI7OjA==
X-Received: by 2002:a5d:590a:: with SMTP id v10mr33403207wrd.306.1620152315506;
        Tue, 04 May 2021 11:18:35 -0700 (PDT)
Received: from skbuf ([86.127.41.210])
        by smtp.gmail.com with ESMTPSA id c5sm16513668wrs.73.2021.05.04.11.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 11:18:35 -0700 (PDT)
Date:   Tue, 4 May 2021 21:18:33 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     xiaoliang.yang_1@nxp.com, Arvid.Brodin@xdin.com,
        UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, andre.guedes@linux.intel.com,
        claudiu.manoil@nxp.com, colin.king@canonical.com,
        davem@davemloft.net, idosch@mellanox.com,
        ivan.khoronzhuk@linaro.org, jiri@mellanox.com,
        joergen.andreasen@microchip.com, leoyang.li@nxp.com,
        linux-kernel@vger.kernel.org, m-karicheri2@ti.com,
        michael.chan@broadcom.com, mingkai.hu@nxp.com,
        netdev@vger.kernel.org, po.liu@nxp.com, saeedm@mellanox.com,
        vinicius.gomes@intel.com, vladimir.oltean@nxp.com,
        yuehaibing@huawei.com
Subject: Re: [net-next] net: dsa: felix: disable always guard band bit for
 TAS config
Message-ID: <20210504181833.w2pecbp2qpuiactv@skbuf>
References: <20210419102530.20361-1-xiaoliang.yang_1@nxp.com>
 <20210504170514.10729-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504170514.10729-1-michael@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Tue, May 04, 2021 at 07:05:14PM +0200, Michael Walle wrote:
> Hi,
> 
> > ALWAYS_GUARD_BAND_SCH_Q bit in TAS config register is descripted as
> > this:
> > 	0: Guard band is implemented for nonschedule queues to schedule
> > 	   queues transition.
> > 	1: Guard band is implemented for any queue to schedule queue
> > 	   transition.
> > 
> > The driver set guard band be implemented for any queue to schedule queue
> > transition before, which will make each GCL time slot reserve a guard
> > band time that can pass the max SDU frame. Because guard band time could
> > not be set in tc-taprio now, it will use about 12000ns to pass 1500B max
> > SDU. This limits each GCL time interval to be more than 12000ns.
> > 
> > This patch change the guard band to be only implemented for nonschedule
> > queues to schedule queues transition, so that there is no need to reserve
> > guard band on each GCL. Users can manually add guard band time for each
> > schedule queues in their configuration if they want.
> 
> 
> As explained in another mail in this thread, all queues are marked as
> scheduled. So this is actually a no-op, correct? It doesn't matter if
> it set or not set for now. Dunno why we even care for this bit then.

It matters because ALWAYS_GUARD_BAND_SCH_Q reduces the available throughput when set.

> > Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> > ---
> >  drivers/net/dsa/ocelot/felix_vsc9959.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> > index 789fe08cae50..2473bebe48e6 100644
> > --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> > +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> > @@ -1227,8 +1227,12 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
> >  	if (taprio->num_entries > VSC9959_TAS_GCL_ENTRY_MAX)
> >  		return -ERANGE;
> >  
> > -	ocelot_rmw(ocelot, QSYS_TAS_PARAM_CFG_CTRL_PORT_NUM(port) |
> > -		   QSYS_TAS_PARAM_CFG_CTRL_ALWAYS_GUARD_BAND_SCH_Q,
> > +	/* Set port num and disable ALWAYS_GUARD_BAND_SCH_Q, which means set
> > +	 * guard band to be implemented for nonschedule queues to schedule
> > +	 * queues transition.
> > +	 */
> > +	ocelot_rmw(ocelot,
> > +		   QSYS_TAS_PARAM_CFG_CTRL_PORT_NUM(port),
> >  		   QSYS_TAS_PARAM_CFG_CTRL_PORT_NUM_M |
> >  		   QSYS_TAS_PARAM_CFG_CTRL_ALWAYS_GUARD_BAND_SCH_Q,
> >  		   QSYS_TAS_PARAM_CFG_CTRL);
> 
> Anyway, I don't think this the correct place for this:
>  (1) it isn't per port, but a global bit, but here its done per port.

I don't understand. According to the documentation, selecting the port
whose time-aware shaper you are configuring is done through
QSYS::TAS_PARAM_CFG_CTRL.PORT_NUM.

>  (2) rmw, I presume is read-modify-write. and there is one bit CONFIG_CHAGE
>      which is set by software and cleared by hardware. What happens if it
> 	 will be cleared right after we read it. Then it will be set again, no?
> 
> So if we really care about this bit, shouldn't this be moved to switch
> initialization then?

May I know what drew your attention to this patch? Is there something wrong?
