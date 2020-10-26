Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041DC298D8F
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 14:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1736671AbgJZNNG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 26 Oct 2020 09:13:06 -0400
Received: from smtp7.web4u.cz ([81.91.87.87]:43652 "EHLO mx-8.mail.web4u.cz"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387722AbgJZNLg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 09:11:36 -0400
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Oct 2020 09:11:30 EDT
Received: from mx-8.mail.web4u.cz (localhost [127.0.0.1])
        by mx-8.mail.web4u.cz (Postfix) with ESMTP id 4D2D31FFF9A;
        Mon, 26 Oct 2020 14:04:08 +0100 (CET)
Received: from baree.pikron.com (unknown [94.112.11.73])
        (Authenticated sender: ppisa@pikron.com)
        by mx-8.mail.web4u.cz (Postfix) with ESMTPA id B048D1FFF68;
        Mon, 26 Oct 2020 14:04:07 +0100 (CET)
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     Pavel Machek <pavel@ucw.cz>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        Carsten Emde <c.emde@osadl.org>
Subject: Re: [PATCH v6 3/6] can: ctucanfd: add support for CTU CAN FD open-source IP core - bus independent part.
Date:   Mon, 26 Oct 2020 14:04:07 +0100
User-Agent: KMail/1.9.10
Cc:     linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, mark.rutland@arm.com,
        armbru@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        Petr Porazil <porazil@pikron.com>,
        Drew Fustini <pdp7pdp7@gmail.com>
References: <cover.1603354744.git.pisa@cmp.felk.cvut.cz> <886a8e0749e0521bf83a88313008a3f38031590b.1603354744.git.pisa@cmp.felk.cvut.cz> <20201022110213.GC26350@duo.ucw.cz>
In-Reply-To: <20201022110213.GC26350@duo.ucw.cz>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <202010261404.07417.pisa@cmp.felk.cvut.cz>
X-W4U-Auth: 4e9955ddfc015ef9726aa4e09f38c48b34e8fad8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Pavel and others,

thanks for review and suggestions. I have spent weekend
to attempt to resolve the most of the suggestions.

The result is merge request to our projects

  https://gitlab.fel.cvut.cz/canbus/ctucanfd_ip_core/-/merge_requests/372

I am running test with two CTU CAN FD cores and two SJA1000 FD tollereant
against two CTU CAN FD cores on PCIe board on my home machine
from the morning. Zynq XCANs are not put into the mix because
they are not FD tolerant.

Actual statistics from Zynq system

can2: flags=193<UP,RUNNING,NOARP>  mtu 16  Open Cores SJA1000 FD tollerant
        unspec 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  txqueuelen 10  (UNSPEC)
        RX packets 2431626  bytes 14089057 (13.4 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 329075  bytes 2383757 (2.2 MiB)
        TX errors 65043  dropped 0 overruns 0  carrier 0  collisions 0
        device interrupt 49

can3: flags=193<UP,RUNNING,NOARP>  mtu 16  Open Cores SJA1000 FD tollerant
        unspec 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  txqueuelen 10  (UNSPEC)
        RX packets 2695281  bytes 15459822 (14.7 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device interrupt 50

can4: flags=193<UP,RUNNING,NOARP>  mtu 72  CTU CAN FD on Zynq
        unspec 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  txqueuelen 10  (UNSPEC)
        RX packets 84791228  bytes 1307744193 (1.2 GiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 1189540  bytes 17447286 (16.6 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device interrupt 47

can5: flags=193<UP,RUNNING,NOARP>  mtu 72  CTU CAN FD on Zynq
        unspec 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  txqueuelen 10  (UNSPEC)
        RX packets 81264790  bytes 1273404732 (1.1 GiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 4715979  bytes 51786821 (49.3 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device interrupt 48

Statistic from my the Intel Core 2 based system, only CTU CAN FD, EMS PCI board
not used, it is not FD tollereant.

can2: flags=193<UP,RUNNING,NOARP>  mtu 72  CTU CAN FD on DB4CGX15
        unspec 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  txqueuelen 10  (UNSPEC)
        RX packets 77731204  bytes 1222332122 (1.1 GiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 847131  bytes 13328222 (12.7 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device interrupt 33

can3: flags=193<UP,RUNNING,NOARP>  mtu 72  CTU CAN FD on DB4CGX15
        unspec 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  txqueuelen 10  (UNSPEC)
        RX packets 1830253  bytes 28749064 (27.4 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 76340684  bytes 1200464054 (1.1 GiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device interrupt 33

There is no indication of errors in the logs. On the other hand,
massive renames and even some code functional changes to allow
rewrite some parts to be better readable could introduce
some errors.

Automatic systemic tests and builds do passed in the final
version

  https://gitlab.fel.cvut.cz/canbus/ctucanfd_ip_core/-/pipelines/25070

Same as automatic test at computes at the university

  https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top/-/pipelines/25071

So hopefully nothing is broken but testing for all corner cases
after this update can take weeks.

The response to review notes follows. I will wait for remarks form the community
or at least check for typos from colleagues and then I send v7 series.

Best wishes,

Pavel

On Thursday 22 of October 2020 13:02:13 Pavel Machek wrote:
> Hi!
>
> > From: Martin Jerabek <martin.jerabek01@gmail.com>
> >
> > This driver adds support for the CTU CAN FD open-source IP core.
> > More documentation and core sources at project page
> > (https://gitlab.fel.cvut.cz/canbus/ctucanfd_ip_core).
> > The core integration to Xilinx Zynq system as platform driver
> > is available
> > (https://gitlab.fel.cvut.cz/canbus/zynq/zynq-can-sja1000-top).
> > Implementation on Intel FGA based PCI Express board is available from
> > project (https://gitlab.fel.cvut.cz/canbus/pcie-ctu_can_fd).
>
> Is "FGA" a typo? Yes, it is.

Fixed

> Anyway, following link tells me:
>
> Project 'canbus/pcie-ctu_can_fd' was moved to
> 'canbus/pcie-ctucanfd'. Please update any links and bookmarks that may
> still have the old path. Fixing it in Kconfig is more important.

Unification of ctu_can_fd -> ctucanfd done for file names, driver paths,
device tree and documentation. Not enough resources to unify HDL sources,
generated files etc. It would break history (blames etc.), testing etc.,
there are more than 4k occurrences.

> > +++ b/drivers/net/can/ctucanfd/Kconfig
> > @@ -0,0 +1,15 @@
> >
> > +if CAN_CTUCANFD
> > +
> > +endif
>
> Empty -> drop?

TODO

> > +++ b/drivers/net/can/ctucanfd/Makefile
> > @@ -0,0 +1,7 @@
> > +# SPDX-License-Identifier: GPL-2.0-only
> >
> > +++ b/drivers/net/can/ctucanfd/ctu_can_fd.c
> > @@ -0,0 +1,1105 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
>
> Having Makefile and sources with different licenses is rather unusual.

UNified

> > +static const char * const ctucan_state_strings[] = {
> > +	"CAN_STATE_ERROR_ACTIVE",
> > +	"CAN_STATE_ERROR_WARNING",
> > +	"CAN_STATE_ERROR_PASSIVE",
> > +	"CAN_STATE_BUS_OFF",
> > +	"CAN_STATE_STOPPED",
> > +	"CAN_STATE_SLEEPING"
> > +};
>
> Put this near function that uses this?

ctucan_state_to_str() moved after array, array defined with strict
correspondence of index to text.

> > +/**
> > + * ctucan_set_bittiming - CAN set bit timing routine
> > + * @ndev:	Pointer to net_device structure
> > + *
> > + * This is the driver set bittiming routine.
> > + * Return: 0 on success and failure value on error
> > + */
> >
> > +/**
> > + * ctucan_chip_start - This routine starts the driver
> > + * @ndev:	Pointer to net_device structure
> > + *
> > + * This is the drivers start routine.
> > + *
> > + * Return: 0 on success and failure value on error
> > + */
>
> Good documentation is nice, but repeating "This routine starts the
> driver" in "This is the drivers start routine." is not too helpful.

Included relevant text as well as I have decided to move call
to ctucan_reset() out of ctucan_chip_start() and slightly reorder/clarify
some part of initialization and error handling.

> > +/**
> > + * ctucan_start_xmit - Starts the transmission
> > + * @skb:	sk_buff pointer that contains data to be Txed
> > + * @ndev:	Pointer to net_device structure
> > + *
> > + * This function is invoked from upper layers to initiate transmission.
> > This + * function uses the next available free txbuf and populates their
> > fields to + * start the transmission.
> > + *
> > + * Return: %NETDEV_TX_OK on success and failure value on error
> > + */
>
> Based on other documentation, I'd expect this to return -ESOMETHING on
> error, but it returns NETDEV_TX_BUSY.

Clarified NETDEV_TX_BUSY case and decided to drop frame if there is
problem with format, length or other parameters during attempt
to move frame into hardware.

> > +	/* Check if the TX buffer is full */
> > +	if (unlikely(!CTU_CAN_FD_TXTNF(ctu_can_get_status(&priv->p)))) {
> > +		netif_stop_queue(ndev);
> > +		netdev_err(ndev, "BUG!, no TXB free when queue awake!\n");
> > +		return NETDEV_TX_BUSY;
> > +	}
>
> You call stop_queue() without spinlock...

I hope that netif_stop_queue can be called from ctucan_start_xmit
without locking and that during ctucan_start_xmit() call, would networking
core postpone finish of netif_wake_queue(ndev) invoked from other CPU
core or kernel thread. I have send longer request for clarification
in previous reply and I would be happy, if somebody can check
that my findings are right. If all that locking in network core work
as I understand it then I would move the second call out of spinlock.
But if there are differences how locking in networking core works
between kernel versions (I have noticed some indication in the past)
then I think that actual solution is correct and more robust.
Even other drivers calls netif_stop_queue from irq lock protected
regions...

> > +	spin_lock_irqsave(&priv->tx_lock, flags);
> > +
> > +	ctucan_hw_txt_set_rdy(&priv->p, txb_id);
> > +
> > +	priv->txb_head++;
> > +
> > +	/* Check if all TX buffers are full */
> > +	if (!CTU_CAN_FD_TXTNF(ctu_can_get_status(&priv->p)))
> > +		netif_stop_queue(ndev);
> > +
> > +	spin_unlock_irqrestore(&priv->tx_lock, flags);
>
> ...and then with spinlock held. One of them is buggy.

See above.

> > +/**
> > + * xcan_rx -  Is called from CAN isr to complete the received
> > + *		frame processing
> > + * @ndev:	Pointer to net_device structure
> > + *
> > + * This function is invoked from the CAN isr(poll) to process the Rx
> > frames. It + * does minimal processing and invokes "netif_receive_skb" to
> > complete further + * processing.
> > + * Return: 1 on success and 0 on failure.
> > + */
>
> Adapt to usual 0 / -EFOO?

I have clarified that 1 is used to inform that frame has been fully received
and sent to the network layer. 0 inform that there is frame first word read
but SKB cannot be (hopefully temporarily) allocated. -EAGAIN indicate unlikelly
condition that function is called when there is no frame in Rx FIFO, this indicates
HW bug because this cannot happen when Rx FIFO frame count is not zero.

> > +	/* Check for Arbitration Lost interrupt */
> > +	if (isr.s.ali) {
> > +		if (dologerr)
> > +			netdev_info(ndev, "  arbitration lost");
> > +		priv->can.can_stats.arbitration_lost++;
> > +		if (skb) {
> > +			cf->can_id |= CAN_ERR_LOSTARB;
> > +			cf->data[0] = CAN_ERR_LOSTARB_UNSPEC;
> > +		}
> > +	}
> > +
> > +	/* Check for Bus Error interrupt */
> > +	if (isr.s.bei) {
> > +		netdev_info(ndev, "  bus error");
>
> Missing "if (dologerr)" here?

Bus error is result of series of troubles and should be logged. Bus restart
after bus error is rate limited by driver nad hardware, so the missing 
dologerr is intentional there. I have added \n to all messages and left them
to be considered independent.

> > +static int ctucan_rx_poll(struct napi_struct *napi, int quota)
> > +{
> > +	struct net_device *ndev = napi->dev;
> > +	struct ctucan_priv *priv = netdev_priv(ndev);
> > +	int work_done = 0;
> > +	union ctu_can_fd_status status;
> > +	u32 framecnt;
> > +
> > +	framecnt = ctucan_hw_get_rx_frame_count(&priv->p);
> > +	netdev_dbg(ndev, "rx_poll: %d frames in RX FIFO", framecnt);
>
> This will be rather noisy, right?

OK, usesfull during development and only on debug level but removed now.

> > +	/* Check for RX FIFO Overflow */
> > +	status = ctu_can_get_status(&priv->p);
> > +	if (status.s.dor) {
> > +		struct net_device_stats *stats = &ndev->stats;
> > +		struct can_frame *cf;
> > +		struct sk_buff *skb;
> > +
> > +		netdev_info(ndev, "  rx fifo overflow");
>
> And this goes at different loglevel, which will be confusing?

Levels try to be reciprocal to severity and proportional to occurrence
frequency. Can be tuned for sure. Some most flooding are ratelimited.

> > +/**
> > + * xcan_tx_interrupt - Tx Done Isr
> > + * @ndev:	net_device pointer
> > + */
> > +static void ctucan_tx_interrupt(struct net_device *ndev)
>
> Mismatch between code and docs.

Corrected.

> > +	netdev_dbg(ndev, "%s", __func__);
>
> This is inconsistent with other debugging.... and perhaps it is time
> to remove this kind of debugging for merge.

I have removed some and will consider others.
We are far from being production silicon version, so some debugging
helps even "hardware"/HDL development.

It seems that checkpatch pushes me in use of __func__.

WARNING: Prefer using '"%s...", __func__' to using 'ctucan_set_bittiming', this function's name, in a string
#127: FILE: /home/pi/fpga/can-fd/ctu-can-fd/CAN_FD_IP_Core/driver/linux/ctucanfd_base.c:127:
+	netdev_dbg(ndev, "ctucan_set_bittiming\n");

Generally, I am not sure if it is problem to have there many debugs
at NET debug level. Today, when it is possible to control debug
levels on per file basis it should not be so big problem and it can
help to debug code and hardware interaction. It can be removed
any time later.

> > +/**
> > + * xcan_interrupt - CAN Isr
> > + */
> > +static irqreturn_t ctucan_interrupt(int irq, void *dev_id)
>
> Inconsistent.

Corrected.

> > +		/* Error interrupts */
> > +		if (isr.s.ewli || isr.s.fcsi || isr.s.ali) {
> > +			union ctu_can_fd_int_stat ierrmask = { .s = {
> > +				  .ewli = 1, .fcsi = 1, .ali = 1, .bei = 1 } };
> > +			icr.u32 = isr.u32 & ierrmask.u32;
>
> We normally do bit arithmetics instead of this.

As described, my intention is to use only fields and bits mapping
which is directly generated from IPXACT specification
and team decision was to to use structs for bitfields.
So I do not want to add manually introduced defines.
Even that core interface is stabilized at least for version 2.x now,
I want all code to directly reflect HW design changes.

> > +	{
> > +		union ctu_can_fd_int_stat imask;
> > +
> > +		imask.u32 = 0xffffffff;
> > +		ctucan_hw_int_ena_clr(&priv->p, imask);
> > +		ctucan_hw_int_mask_set(&priv->p, imask);
> > +	}
>
> More like this. Plus avoid block here...?

Block is to inform, that imask is really local and you do not
need to look for it elsewhere in the function.
But you prefer flat so I move define to start and remove
block. In this case all F are OK, we know that there is nothing
else than interrupts enable, mask bits, and if all should be
stopped in response to error, then there cannot be problem even after
some move of bitfileds in the register.

> > +/**
> > + * ctucan_close - Driver close routine
> > + * @ndev:	Pointer to net_device structure
> > + *
> > + * Return: 0 always
> > + */
>
> You see, this is better. No need to say "Driver close routine"
> twice. Now, make the rest consistent :-).
>
> > +EXPORT_SYMBOL(ctucan_suspend);
> > +EXPORT_SYMBOL(ctucan_resume);
>
> _GPL?

Not critical for me, may be Ondrej Ille has some opinion there.

> And what kind of multi-module stuff are you doing that you need
> symbols exported?

Seems to be understood from followup patches.

> > +int ctucan_probe_common(struct device *dev, void __iomem *addr, int irq,
> > unsigned int ntxbufs, +			unsigned long can_clk_rate, int pm_enable_call,
> > +			void (*set_drvdata_fnc)(struct device *dev, struct net_device *ndev))
> > +{
>
> Splitting/simplifying this somehow would be good.

If you confirm my offer to move to structure with options then
I look at it. On the other hand when functions prototype
changes it enforces all users to get update which can bee
better to catch problems than sillent structure fields addition.
If zeroed the first then probably manageable too.

> > +/* Register descriptions: */
> > +union ctu_can_fd_frame_form_w {
> > +	uint32_t u32;
>
> u32, as you write elsewhere.

As I already described these generated files should be used one
to one in QEMU and other tools. There seems to be acceptable
to use uint32_t in the kernel for these cases.
Definition of u32 type in all other cases would lead often
to unwanted pollute of namespace.

> > +	struct ctu_can_fd_frame_form_w_s {
> > +#ifdef __LITTLE_ENDIAN_BITFIELD
> > +  /* FRAME_FORM_W */
> > +		uint32_t dlc                     : 4;
> > +		uint32_t reserved_4              : 1;
> > +		uint32_t rtr                     : 1;
> > +		uint32_t ide                     : 1;
> > +		uint32_t fdf                     : 1;
> > +		uint32_t reserved_8              : 1;
> > +		uint32_t brs                     : 1;
> > +		uint32_t esi_rsv                 : 1;
> > +		uint32_t rwcnt                   : 5;
> > +		uint32_t reserved_31_16         : 16;
> > +#else
>
> I believe you should simply avoid using bitfields.

I have already described that my personal tendency
is similar but in this case big and little part
is kept consistent by generation and it was preferred
solution by colleagues. There are more places where this
style is used in the kernel and we do not use overlay structures
for hardware directly. Value is read by iored/iowrite in all cases
and union/struct works only for local variables to parse
bitfields. It is correct from IO synchronization
and single access rules and it optimizes to same code
as use of defines on local variables.

> > +union ctu_can_fd_timestamp_l_w {
> > +	uint32_t u32;
> > +	struct ctu_can_fd_timestamp_l_w_s {
> > +  /* TIMESTAMP_L_W */
> > +		uint32_t time_stamp_31_0        : 32;
> > +	} s;
> > +};
>
> This is crazy.

Yes, but generated from spec so it is kept consistent.
Adding exception for case that size of field is 32-bits
is possible but when field size changes it would cause
incorrect access.

> > +union ctu_can_fd_data_5_8_w {
> > +	uint32_t u32;
> > +	struct ctu_can_fd_data_5_8_w_s {
> > +#ifdef __LITTLE_ENDIAN_BITFIELD
> > +  /* DATA_5_8_W */
> > +		uint32_t data_5                  : 8;
> > +		uint32_t data_6                  : 8;
> > +		uint32_t data_7                  : 8;
> > +		uint32_t data_8                  : 8;
> > +#else
> > +		uint32_t data_8                  : 8;
> > +		uint32_t data_7                  : 8;
> > +		uint32_t data_6                  : 8;
> > +		uint32_t data_5                  : 8;
> > +#endif
> > +	} s;
> > +};
>
> even more crazy.

This is mainly for documentation where it has place and reason.
It is used only in sense of data area start in the driver.

> > +#ifdef __KERNEL__
> > +# include <linux/can/dev.h>
> > +#else
> > +/* The hardware registers mapping and low level layer should build
> > + * in userspace to allow development and verification of CTU CAN IP
> > + * core VHDL design when loaded into hardware. Debugging hardware
> > + * from kernel driver is really difficult, leads to system stucks
> > + * by error reporting etc. Testing of exactly the same code
> > + * in userspace together with headers generated automatically
> > + * generated from from IP-XACT/cactus helps to driver to hardware
> > + * and QEMU emulation model consistency keeping.
> > + */
> > +# include "ctu_can_fd_linux_defs.h"
> > +#endif
>
> Please remove non-kernel code for merge.

As I tried to describe these mechanism allows to ensure that
there is match between HW access generated registers description
and manual algorithmic part of HW interface and actual implementation
of registers file by different test from userpace run during each
driver or HDL update. I am convinced personally that it worth
to be run and tested. Alternative to #ifdef is file patching 
during userspace build, but we use same files with symliks only
during GitLab runner execution. It would complicate things
on our side and can lead to not catching problem which would cost
really much more than four additional lines. I have added description
for others to understand value of this solution.
If really requested to be removed, then I would follow
requirement but with bad taste what more worthless problems
I have to spent my time. 

> > +void ctucan_hw_write32(struct ctucan_hw_priv *priv,
> > +		       enum ctu_can_fd_can_registers reg, u32 val)
> > +{
> > +	iowrite32(val, priv->mem_base + reg);
> > +}
>
> And get rid of this kind of abstraction layer.

We need to support big endian and little endian mapping
in same driver. I.e. bigendian MIPS with little endian
PCI mapping (that is standard) and big endian for SoC
integration. I really think that linux/regmap.h is
to big monster for this simple purpose. See my previous
analysis and reference to similar conclusions of M_CAN
authors.

> > +// TODO: rename or do not depend on previous value of id
>
> TODO: grep for TODO and C++ comments before attempting merge.

There should not be any C++ comment except SPDX, which seems to be
preffered even in other kernel C files and TODOs. They go after
my colleagues providing basic HW abstraction. I have replaced C++
comments in ctucanfd_hw.h.

Code restructured to resolve this TODO.

> > +static bool ctucan_hw_len_to_dlc(u8 len, u8 *dlc)
> > +{
> > +	*dlc = can_len2dlc(len);
> > +	return true;
> > +}
>
> Compared to how well other code is documented... This one is voodoo.

Wrapper removed, can_len2dlc used directly.

Generally ctucanfd_hw.h/ctucanfd_hw.c provides documented API
to the driver. Who wants to poke with ctucanfd_hw.h/ctucanfd_hw.c
should read HW, registers docs, to which code directly corresponds.

  http://canbus.pages.fel.cvut.cz/ctucanfd_ip_core/Progdokum.pdf
  http://canbus.pages.fel.cvut.cz/ctucanfd_ip_core/ctu_can_fd_architecture.pdf

> > +bool ctucan_hw_set_ret_limit(struct ctucan_hw_priv *priv, bool enable,
> > u8 limit) +{
> > +	union ctu_can_fd_mode_settings reg;
> > +
> > +	if (limit > CTU_CAN_FD_RETR_MAX)
> > +		return false;
> > +
> > +	reg.u32 = priv->read_reg(priv, CTU_CAN_FD_MODE);
> > +	reg.s.rtrle = enable ? RTRLE_ENABLED : RTRLE_DISABLED;
> > +	reg.s.rtrth = limit & 0xF;
> > +	priv->write_reg(priv, CTU_CAN_FD_MODE, reg.u32);
> > +	return true;
> > +}
>
> As elsewhere, I'd suggest 0/-ERRNO.

I would prefer this HW documenting layer without dependency
of concrete systems status reporting mechanisms.
EXXX rule can be followed but at cost of testing, other
systems integration etc.

> > +void ctucan_hw_set_mode_reg(struct ctucan_hw_priv *priv,
> > +			    const struct can_ctrlmode *mode)
> > +{
> > +	u32 flags = mode->flags;
> > +	union ctu_can_fd_mode_settings reg;
> > +
> > +	reg.u32 = priv->read_reg(priv, CTU_CAN_FD_MODE);
> >
> > +	if (mode->mask & CAN_CTRLMODE_LOOPBACK)
> > +		reg.s.ilbp = flags & CAN_CTRLMODE_LOOPBACK ?
> > +					INT_LOOP_ENABLED : INT_LOOP_DISABLED;
>
> Not sure what is going on here, but having mode->flags in same format
> as hardware register would help...?

Converts SocketCAN defined code to actual encoding in the HDL

https://elixir.bootlin.com/linux/latest/source/include/uapi/linux/can/netlink.h#L95

So this is to have external API of HW access functions as close to SocketCAN
as possible.

> > +	switch (fnum) {
> > +	case CTU_CAN_FD_FILTER_A:
> > +		if (reg.s.sfa)
> > +			return true;
> > +	break;
> > +	case CTU_CAN_FD_FILTER_B:
> > +		if (reg.s.sfb)
> > +			return true;
> > +	break;
> > +	case CTU_CAN_FD_FILTER_C:
> > +		if (reg.s.sfc)
> > +			return true;
> > +	break;
> > +	}
>
> Check indentation of break statemnts, also elsewhere in this file

Strange that checkpatch accepts this, but changing.

> > +bool ctucan_hw_get_range_filter_support(struct ctucan_hw_priv *priv)
> > +{
> > +	union ctu_can_fd_filter_control_filter_status reg;
> > +
> > +	reg.u32 = priv->read_reg(priv, CTU_CAN_FD_FILTER_CONTROL);
> > +
> > +	if (reg.s.sfr)
> > +		return true;
>
> return !!reg.s.sfr; ?

Replaced

> > +enum ctu_can_fd_tx_status_tx1s ctucan_hw_get_tx_status(struct
> > ctucan_hw_priv +							*priv, u8 buf)
>
> ...
>
> > +	default:
> > +		status = ~0;
> > +	}
> > +	return (enum ctu_can_fd_tx_status_tx1s)status;
> > +}
>
> Is ~0 in the enum?

Hmm enum ctu_can_fd_tx_status_tx1s is generated from IPXACT CTU CAN FD specification.
The ~0 is there to catch fatal problems, to put something, which does not match
any enum value. Changing enum is problematic, it would require to change
generator or specification... It is to catch real problem in the code
implementation. So I am not sure what else I can do there.

> > +	// TODO: use named constants for the command
>
> TODO...
>
> > +// TODO: AL_CAPTURE and ERROR_CAPTURE

Removed, I am not sure what was on the mind of colleagues who has placed this TODO there.

> > +#if defined(__LITTLE_ENDIAN_BITFIELD) == defined(__BIG_ENDIAN_BITFIELD)
> > +# error __BIG_ENDIAN_BITFIELD or __LITTLE_ENDIAN_BITFIELD must be
> > defined. +#endif
> >
> :-).
> :
> > +// True if Core is transceiver of current frame
> > +#define CTU_CAN_FD_IS_TRANSMITTER(stat) (!!(stat).ts)
> > +
> > +// True if Core is receiver of current frame
> > +#define CTU_CAN_FD_IS_RECEIVER(stat) (!!(stat).s.rxs)
>
> Why not, documentation is nice. But it is in big contrast to other
> parts of code where there's no docs at all.

The ctucanfd_hw.h API should be documented for driver implementers.
ctucanfd_hw.c require to read real HW docs.

> > +struct ctucan_hw_priv;
> > +#ifndef ctucan_hw_priv
> > +struct ctucan_hw_priv {
> > +	void __iomem *mem_base;
> > +	u32 (*read_reg)(struct ctucan_hw_priv *priv,
> > +			enum ctu_can_fd_can_registers reg);
> > +	void (*write_reg)(struct ctucan_hw_priv *priv,
> > +			  enum ctu_can_fd_can_registers reg, u32 val);
> > +};
> > +#endif
>
> Should not be needed in kernel.

Old mechanism, actual user space tests can live without it.

> > +/**
> > + * ctucan_hw_read_rx_word - Reads one word of CAN Frame from RX FIFO
> > Buffer. + *
> > + * @priv: Private info
> > + *
> > + * Return: One wword of received frame
>
> Typo 'word'.
>
> > +++ b/drivers/net/can/ctucanfd/ctu_can_fd_regs.h
> > @@ -0,0 +1,971 @@
> > +
> > +/* This file is autogenerated, DO NOT EDIT! */
> > +
>
> Yay. How is that supposed to work after merge?
>
> Best regards,
> 								Pavel

On Thursday 22 of October 2020 13:39:52 Pavel Machek wrote:
> > @@ -12,4 +12,13 @@ config CAN_CTUCANFD
> >
> >  if CAN_CTUCANFD
> >
> > +config CAN_CTUCANFD_PCI
> > +	tristate "CTU CAN-FD IP core PCI/PCIe driver"
> > +	depends on PCI
> > +	help
> > +	  This driver adds PCI/PCIe support for CTU CAN-FD IP core.
> > +	  The project providing FPGA design for Intel EP4CGX15 based DB4CGX15
> > +	  PCIe board with PiKRON.com designed transceiver riser shield is
> > available +	  at https://gitlab.fel.cvut.cz/canbus/pcie-ctu_can_fd .
> > +
> >  endif
>
> Ok, now the if in the first patch makes sense. It can stay.
>
> And it is separate module, so EXPORT_SYMBOLs make sense. Ok.

I have changed dependency to not use if but
  depends on CAN_CTUCANFD

> > +#ifndef PCI_VENDOR_ID_TEDIA
> > +#define PCI_VENDOR_ID_TEDIA 0x1760
> > +#endif
> >
> > +#define PCI_DEVICE_ID_TEDIA_CTUCAN_VER21 0xff00
>
> These should go elsewhere.

Kept for now, I will adapt to suggestions but I would
prefer to put it independent to allow easy backports
for meanwhile. 

> > +#define PCI_DEVICE_ID_ALTERA_CTUCAN_TEST  0xCAFD

Test integration not in use removed.

>
> > +static bool use_msi = 1;
> > +static bool pci_use_second = 1;
>
> true?

Changed to true.

On Thursday 22 of October 2020 13:43:06 Pavel Machek wrote:
> Hi!
>
> > +++ b/drivers/net/can/ctucanfd/Kconfig
> > @@ -21,4 +21,15 @@ config CAN_CTUCANFD_PCI
> >  	  PCIe board with PiKRON.com designed transceiver riser shield is
> > available at https://gitlab.fel.cvut.cz/canbus/pcie-ctu_can_fd .
> >
> > +config CAN_CTUCANFD_PLATFORM
> > +	tristate "CTU CAN-FD IP core platform (FPGA, SoC) driver"
> > +	depends on OF || COMPILE_TEST
> > +	help
>
> This is likely wrong, as it can enable config of CAN_CTUCANFD=M,
> CAN_CTUCANFD_PLATFORM=y, right?

Chanegd to depends on

> > @@ -8,3 +8,6 @@ ctucanfd-y := ctu_can_fd.o ctu_can_fd_hw.o
> >
> >  obj-$(CONFIG_CAN_CTUCANFD_PCI) += ctucanfd_pci.o
> >  ctucanfd_pci-y := ctu_can_fd_pci.o
> > +
> > +obj-$(CONFIG_CAN_CTUCANFD_PLATFORM) += ctucanfd_platform.o
> > +ctucanfd_platform-y += ctu_can_fd_platform.o
>
> Can you simply add right object files directly?

I have done rename in many places to fullfill this single line.
Full rename in HDL would require to analyze 4k+ occurrences.

On Thursday 22 of October 2020 13:25:40 Pavel Machek wrote:
> On Thu 2020-10-22 10:36:21, Pavel Pisa wrote:
> > CTU CAN FD IP core documentation based on Martin Jeřábek's diploma theses
> > Open-source and Open-hardware CAN FD Protocol Support
> > https://dspace.cvut.cz/handle/10467/80366
> > .
> >
> > ---
> >  .../ctu/FSM_TXT_Buffer_user.png               | Bin 0 -> 174807 bytes
>
> Maybe picture should stay on website, somewhere. It is rather big for
> kernel sources.

I have invested time to redraw image in Inscape and do more
optimization to reduce 172K to 16K SVG.

> > +About SocketCAN
> > +---------------
> > +
> > +SocketCAN is a standard common interface for CAN devices in the Linux
> > +kernel. As the name suggests, the bus is accessed via sockets, similarly
> > +to common network devices. The reasoning behind this is in depth
> > +described in `Linux SocketCAN
> > <https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Doc
> >umentation/networking/can.rst>`_. +In short, it offers a
> > +natural way to implement and work with higher layer protocols over CAN,
> > +in the same way as, e.g., UDP/IP over Ethernet.
>
> Drop? Or at least link directly to the file in kernel tree?

What is the best way to cross-reference RST documentation in Linux kernel
sources??

> > +Device probe
> > +~~~~~~~~~~~~
...
>
> Dunno. Is it suitable? This is supposed to be ctu-can documentation,
> not "how hardware works" docs.

I would be happy if it stays in our standalone build.
If it is problem for mainline I try to reduce text.
Help, suggestions etc. much appreciated.
Mr. Ille, Mr. Jerabek and others, please help there.
Same with checking for errors.

Thanks for your time (when you reached the end of the discussion),

Pavel
