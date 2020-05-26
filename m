Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405D71E1F66
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 12:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731873AbgEZKK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 06:10:27 -0400
Received: from foss.arm.com ([217.140.110.172]:48548 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731716AbgEZKK1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 06:10:27 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7F6941FB;
        Tue, 26 May 2020 03:10:26 -0700 (PDT)
Received: from bogus (unknown [10.37.8.209])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 56E413F52E;
        Tue, 26 May 2020 03:10:22 -0700 (PDT)
Date:   Tue, 26 May 2020 11:10:19 +0100
From:   Sudeep Holla <sudeep.holla@arm.com>
To:     Jianyong Wu <Jianyong.Wu@arm.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        Steven Price <Steven.Price@arm.com>,
        Justin He <Justin.He@arm.com>, Wei Chen <Wei.Chen@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kaly Xin <Kaly.Xin@arm.com>, nd <nd@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH v12 03/11] psci: export smccc conduit get helper.
Message-ID: <20200526101019.GB11414@bogus>
References: <20200522083724.38182-1-jianyong.wu@arm.com>
 <20200522083724.38182-4-jianyong.wu@arm.com>
 <20200522131206.GA15171@bogus>
 <HE1PR0802MB255537CD21C5E7F7F4A899A2F4B30@HE1PR0802MB2555.eurprd08.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <HE1PR0802MB255537CD21C5E7F7F4A899A2F4B30@HE1PR0802MB2555.eurprd08.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 01:37:56AM +0000, Jianyong Wu wrote:
> Hi Sudeep,
> 
> > -----Original Message-----
> > From: Sudeep Holla <sudeep.holla@arm.com>
> > Sent: Friday, May 22, 2020 9:12 PM
> > To: Jianyong Wu <Jianyong.Wu@arm.com>
> > Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> > tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> > maz@kernel.org; richardcochran@gmail.com; Mark Rutland
> > <Mark.Rutland@arm.com>; will@kernel.org; Suzuki Poulose
> > <Suzuki.Poulose@arm.com>; Steven Price <Steven.Price@arm.com>; Justin
> > He <Justin.He@arm.com>; Wei Chen <Wei.Chen@arm.com>;
> > kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; linux-
> > kernel@vger.kernel.org; Kaly Xin <Kaly.Xin@arm.com>; nd <nd@arm.com>;
> > Sudeep Holla <Sudeep.Holla@arm.com>; kvmarm@lists.cs.columbia.edu;
> > linux-arm-kernel@lists.infradead.org
> > Subject: Re: [RFC PATCH v12 03/11] psci: export smccc conduit get helper.
> > 
> > On Fri, May 22, 2020 at 04:37:16PM +0800, Jianyong Wu wrote:
> > > Export arm_smccc_1_1_get_conduit then modules can use smccc helper
> > > which adopts it.
> > >
> > > Acked-by: Mark Rutland <mark.rutland@arm.com>
> > > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > > ---
> > >  drivers/firmware/psci/psci.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/drivers/firmware/psci/psci.c
> > > b/drivers/firmware/psci/psci.c index 2937d44b5df4..fd3c88f21b6a 100644
> > > --- a/drivers/firmware/psci/psci.c
> > > +++ b/drivers/firmware/psci/psci.c
> > > @@ -64,6 +64,7 @@ enum arm_smccc_conduit
> > > arm_smccc_1_1_get_conduit(void)
> > >
> > >  	return psci_ops.conduit;
> > >  }
> > > +EXPORT_SYMBOL(arm_smccc_1_1_get_conduit);
> > >
> > 
> > I have moved this into drivers/firmware/smccc/smccc.c [1] Please update
> > this accordingly.
> 
> Ok, I will remove this patch next version.

You may need it still, just that this patch won't apply as the function
is moved to a new file.

-- 
Regards,
Sudeep
