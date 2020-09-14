Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B9B2695EA
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 21:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgINTz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 15:55:57 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:21076 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725961AbgINTzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 15:55:55 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08EJoVg7015540;
        Mon, 14 Sep 2020 12:55:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pfpt0220; bh=cJIjKYcVmm7Lm8Ga0kdJNXutlbSUk6zNcD+RdkYXTf4=;
 b=VHEjBqQsEk4GgCiho2Vn3xiKS5yqlc0+bbxFR3JbtMXRxSyMciM4bG06oQBoSkV1Lzpa
 IE9wpKTIpDiQkXPMhbMXYy0jSwg+zmpHsXbKxNmpLg3DHz+pPCZKq721kuaQUR5vStQs
 79FgMU3pC3FVnmIKjTLlbQl8FIP5A262biDnrDUu/TklTPDrVcSArKaj1b+lF+Dqrq3u
 P8w580ztltw7OE9iwkljjpqLP38R1D6VwU2KkJk/5qNYlTj5gLx3pKsgmozxIgSJtmzC
 817woBh1b4VIa2/rAFLYZzLazslqRaGnbsgBKZ+rrOF2D+OY2ONY2/mg/iFPvIaP68PS Gw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 33guppxhds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 12:55:52 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 14 Sep
 2020 12:55:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 14 Sep 2020 12:55:51 -0700
Received: from yoga (unknown [10.95.131.84])
        by maili.marvell.com (Postfix) with ESMTP id 4B6ED3F703F;
        Mon, 14 Sep 2020 12:55:50 -0700 (PDT)
Date:   Mon, 14 Sep 2020 21:55:49 +0200
From:   Stanislaw Kardach <skardach@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>, <kda@semihalf.com>
Subject: Re: [PATCH net-next 3/3] octeontx2-af: add support for custom KPU
 entries
Message-ID: <20200914195549.GA10151@yoga>
References: <20200911132124.7420-1-skardach@marvell.com>
 <20200911132124.7420-4-skardach@marvell.com>
 <20200911135324.6418b50c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200911135324.6418b50c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-14_08:2020-09-14,2020-09-14 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> ________________________________________
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, September 11, 2020 10:53 PM
> To: Stanislaw Kardach [C]
> Cc: davem@davemloft.net; Sunil Kovvuri Goutham; netdev@vger.kernel.org
> Subject: [EXT] Re: [PATCH net-next 3/3] octeontx2-af: add support for custom KPU entries
>
> External Email
>
> ----------------------------------------------------------------------
> On Fri, 11 Sep 2020 15:21:24 +0200 skardach@marvell.com wrote:
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
> > index 6bfb9a9d3003..fe164b85adfb 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
> > @@ -148,7 +148,7 @@ struct npc_kpu_profile_cam {
> >       u16 dp1_mask;
> >       u16 dp2;
> >       u16 dp2_mask;
> > -};
> > +} __packed;
> >
> >  struct npc_kpu_profile_action {
> >       u8 errlev;
> > @@ -168,7 +168,7 @@ struct npc_kpu_profile_action {
> >       u8 mask;
> >       u8 right;
> >       u8 shift;
> > -};
> > +} __packed;
> >
> >  struct npc_kpu_profile {
> >       int cam_entries;
> > @@ -323,6 +323,15 @@ struct npc_mcam_kex {
> >       u64 intf_ld_flags[NPC_MAX_INTF][NPC_MAX_LD][NPC_MAX_LFL];
> >  } __packed;
> >
> > +struct npc_kpu_fwdata {
> > +     int     entries;
> > +     /* What follows is:
> > +      * struct npc_kpu_profile_cam[entries];
> > +      * struct npc_kpu_profile_action[entries];
> > +      */
> > +     u8      data[0];
> > +} __packed;
>
> Why do you mark a structure with a single int member as __packed?
>
> Please drop all the __packed attrs you add in this series.

Sorry, will fix in V2.

>
> >  module_param(mkex_profile, charp, 0000);
> >  MODULE_PARM_DESC(mkex_profile, "MKEX profile name string");
> >
> > +static char *kpu_profile; /* KPU profile name */
> > +module_param(kpu_profile, charp, 0000);
> > +MODULE_PARM_DESC(kpu_profile, "KPU profile name string");
>
> Why do you need a module parameter for this?
>
> Just decide on a filename, always request it, and if user doesn't want
> to load a special profile you'll get a -ENOENT and move on.

The use-case I am targeting here is using different profiles in
different parts of the network but re-using a single initramfs+kernel
(say a common set of platform software) via tftpboot. I.e. one custom
protocol for the edge and another for core network. Then boot parameters
are customized based on some configuration embedded in the equipment
(i.e. device tree in flash + customized uboot).
Without module parameter I think that could be done via symlinking and
delaying module loading but that means more hassle when driver is
built-in, hence the parameter.

Thanks for reviewing my patches!

Best Regards,
Stanislaw Kardach
