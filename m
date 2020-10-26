Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4ECF2992C5
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 17:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1786363AbgJZQqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 12:46:36 -0400
Received: from relay.felk.cvut.cz ([147.32.80.7]:52627 "EHLO
        relay.felk.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1780417AbgJZQok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 12:44:40 -0400
X-Greylist: delayed 1903 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Oct 2020 12:44:35 EDT
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by relay.felk.cvut.cz (8.15.2/8.15.2) with ESMTP id 09QGBSGS098063;
        Mon, 26 Oct 2020 17:11:28 +0100 (CET)
        (envelope-from pisa@cmp.felk.cvut.cz)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 09QGBRNo004427;
        Mon, 26 Oct 2020 17:11:27 +0100
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 09QGBRM9004426;
        Mon, 26 Oct 2020 17:11:27 +0100
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     Ondrej Ille <ondrej.ille@gmail.com>
Subject: Re: [PATCH v6 3/6] can: ctucanfd: add support for CTU CAN FD open-source IP core - bus independent part.
Date:   Mon, 26 Oct 2020 17:11:26 +0100
User-Agent: KMail/1.9.10
Cc:     Pavel Machek <pavel@ucw.cz>,
        Marin Jerabek <martin.jerabek01@gmail.com>,
        Jiri Novak <jnovak@fel.cvut.cz>,
        Jaroslav Beran <jara.beran@gmail.com>,
        linux-can@vger.kernel.org, devicetree@vger.kernel.org,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, mark.rutland@arm.com,
        Carsten Emde <c.emde@osadl.org>, armbru@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Porazil <porazil@pikron.com>,
        Drew Fustini <pdp7pdp7@gmail.com>
References: <cover.1603354744.git.pisa@cmp.felk.cvut.cz> <202010222221.31952.pisa@cmp.felk.cvut.cz> <CAA7Zjpam0uFCXwXS4_X5Sq3wJcNUSxOxPiTm860OXDNs-xHgyg@mail.gmail.com>
In-Reply-To: <CAA7Zjpam0uFCXwXS4_X5Sq3wJcNUSxOxPiTm860OXDNs-xHgyg@mail.gmail.com>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202010261711.26754.pisa@cmp.felk.cvut.cz>
X-FELK-MailScanner-Information: 
X-MailScanner-ID: 09QGBSGS098063
X-FELK-MailScanner: Found to be clean
X-FELK-MailScanner-SpamCheck: not spam, SpamAssassin (not cached, score=-0.1,
        required 6, BAYES_00 -0.50, KHOP_HELO_FCRDNS 0.40,
        NICE_REPLY_A -0.00, SPF_HELO_NONE 0.00, SPF_NONE 0.00)
X-FELK-MailScanner-From: pisa@cmp.felk.cvut.cz
X-FELK-MailScanner-Watermark: 1604333494.02066@+0RJaPfulAdZwH/yVOP93g
X-Spam-Status: No
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Ondrej and others,

On Monday 26 of October 2020 14:38:59 Ondrej Ille wrote:
> Hello Pavel and Pavel,
>
> first of all, Pavel (Machek) thank you for review, we appreciate it.
> We will try to fix as much mistakes as possible. Please, see my comments
> below.
>
> With Regards
> Ondrej
>
> On Thu, Oct 22, 2020 at 10:22 PM Pavel Pisa <pisa@cmp.felk.cvut.cz> wrote:
...
> > > > +/**
> > > > + * ctucan_start_xmit - Starts the transmission
> > > > + * @skb:   sk_buff pointer that contains data to be Txed
> > > > + * @ndev:  Pointer to net_device structure
> > > > + *
> > > > + * This function is invoked from upper layers to initiate
> >
> > transmission.
> >
> > > > This + * function uses the next available free txbuf and populates
> >
> > their
> >
> > > > fields to + * start the transmission.
> > > > + *
> > > > + * Return: %NETDEV_TX_OK on success and failure value on error
> > > > + */
> > >
> > > Based on other documentation, I'd expect this to return -ESOMETHING on
> > > error, but it returns NETDEV_TX_BUSY.
> >
> > I add information about explicit error/need for postpone type.
>
> Changing description, OK. Pavel Pisa, but why did you change handling of
> insertion
> failure to TXT Buffer to return NETDEV_TX_BUSY and increment tx_dropped?
> Is there some preference on what should the driver return in case of HW
> error?
> Also, couldnt we afford not to check return value of ctucan_hw_insert_frame
> ? Is purpose of
> driver to be fail-safe against HW bug which says "There is TX buffer free
> in Status register", but in reality,
> no TXT Buffer is free?
>
> If we look at when ctu_can_hw_insert_frame returns false, it is when:
>   1. We attempt to insert to non-existent TXT buffer -> Under drivers
> control to do rotation correctly.
>   2. If cfg->len > CAN_FD_MAX_LEN. Couldnt this check be removed?
> CAN_FD_MAX_LEN is
>       defined for Linux, so it is not OS agnostic... Also, is it possible
> that driver will call insert with
>       cf->len > CAN_FD_MAX_LEN?
>   3. When there is HW bug (as mentioned earlier). There are assertions in
> RTL checking this situation
>       will not happend!
> So maybe we dont even need to check return value of this function at all?

I try to follow other drivers.
So if everything is OK then return NETDEV_TX_OK.

If there is no Tx buffer available then return
NETDEV_TX_BUSY. Some retransmit or drop should be handled by
NET core in such case. This situation should not appear
in reality, because Tx queue should be stopped if there is no
free Tx buffer and should not be reenable earlien than
at least one is available. So this situation is bug in
driver logic or NET core.

If the check for CAN FD frame format fails then it is right
to drop SKB and it is handled with NETDEV_TX_OK return
in other drivers as well. Only statistic counter increments.
If the Tx buffer selected by driver s in incorrect state
then it is even more serious bug so alternative is to
stop whole driver and report fatal error.

> > > > +   /* Check for Bus Error interrupt */
> > > > +   if (isr.s.bei) {
> > > > +           netdev_info(ndev, "  bus error");
> > >
> > > Missing "if (dologerr)" here?
> >
> > Intention was to left this one to appear without rate limit, it is really
> > indication of bigger problem. But on the other hand without dologerr
> > would be quite short/unclear, but does not overflow the log buffers...
> > We would discuss what to do with my colleagues, suggestions welcomed.
>
> I agree with adding "dologerror" check here. It is true that arbitration
> lost is not really an
> error, and Bus error (error frame), therefore Bus error has higher
> "severity". Could we
> maybe do it that both have "dologerr" condition, but arbitration lost uses
> "netdev_dbg"?

Arbitration lost should not be reported nor generate interrupt
for usual can application setup.

> > > > +static int ctucan_rx_poll(struct napi_struct *napi, int quota)
> > > > +{
> > > > +   struct net_device *ndev = napi->dev;
> > > > +   struct ctucan_priv *priv = netdev_priv(ndev);
> > > > +   int work_done = 0;
> > > > +   union ctu_can_fd_status status;
> > > > +   u32 framecnt;
> > > > +
> > > > +   framecnt = ctucan_hw_get_rx_frame_count(&priv->p);
> > > > +   netdev_dbg(ndev, "rx_poll: %d frames in RX FIFO", framecnt);
> > >
> > > This will be rather noisy, right?
> >
> > It has use to debug during development but may be it should be removed
> > or controlled by other option.
>
> Maybe again suppress by "net_ratelimit" ?

I have removed this one and report only errors.

...
> > https://gitlab.fel.cvut.cz/canbus/ctucanfd_ip_core/-/blob/master/spec/CTU
> >/ip/CAN_FD_IP_Core/2.1/CAN_FD_IP_Core.2.1.xml
> >
> > Which I consider as good option which should be preserved.
> > I prefer to have only singe source of infomation
> > which is kept with rest in automatic sync.
>
> We are really trying only to use bitfields generated in ctu_can_fd_regs.
> Whether it is bitfield or
> mask, is up to debate, but we always use generated values. Linux driver is
> only one part of it
> all. The golden source (IP-XACT) is propagated to RTL, 2 different TB
> packages, constant definitions,
> generated documentation. This is the only way how to keep register map
> consistent with limited
> developer resources we have. If we corrupt this rule, we end up with 4
> different representations
> of register maps:
>    1. What Testebench thinks
>    2. What is in RTL
>    3. What is in documentation
>    4. What driver sees.
> and then we will never put it back together again...

I think that it is even important example for others. And there is not listed
use of the generated header files for functional emulation in QEMU.
I have even plan to use generator to prepare RO/RW mask for QEMU 
and IP block emulation skeleton for QEMU automatically. This part
has not been implemented during last bachelor thesis. That part
was written manually but it is in QEMU mainline now.

If there is strong preferences for macros than bitfields
we add macros generation alternative.

> > > > +   {
> > > > +           union ctu_can_fd_int_stat imask;
> > > > +
> > > > +           imask.u32 = 0xffffffff;
> > > > +           ctucan_hw_int_ena_clr(&priv->p, imask);
> > > > +           ctucan_hw_int_mask_set(&priv->p, imask);
> > > > +   }
> > >
> > > More like this. Plus avoid block here...?
> >
> > Blocks is to document that imask is really local for these
> > two lines, no need to look for it elsewhere in the function.
> > But I can move declaration to start of the function.
>
> I would also remove blocks here.

Flattened

> > > > +/**
> > > > + * ctucan_close - Driver close routine
> > > > + * @ndev:  Pointer to net_device structure
> > > > + *
> > > > + * Return: 0 always
> > > > + */
> > >
> > > You see, this is better. No need to say "Driver close routine"
> > > twice. Now, make the rest consistent :-).
> > >
> > > > +EXPORT_SYMBOL(ctucan_suspend);
> > > > +EXPORT_SYMBOL(ctucan_resume);
> > >
> > > _GPL?
> >
> > Should we be so strict??? Ondrej Ille can provide his opinion there.
>
> Is it really necessary? If yes, then we can change it.

I see no reason that it is necessary. Without GPL some vendor can come
with CTU CAN FD integration on such platform, where integration
code stays unavailable to users. But common driver part has to be made 
available. We can prevent such use of the driver code, but I see
no big wind there or financial income instrument.

...

> > Hmmm, we can add special rules to tools to skip some special cases
> > but actual files exactly math what is in documentation and VHDL
> > sources and registers implementation. See page 61 / PDF 67 of
> >
> >   http://canbus.pages.fel.cvut.cz/ctucanfd_ip_core/Progdokum.pdf
> >
> > Yes there is still space for improvements but we need to have
> > acceptable base for already running applications.
>
> Point taken. These are indeed ridiculous. I was thinking about adding some
> skip rule
> to the register map generator, but I am out of IP-XACT fields to represent
> this thing.
> Maybe I can use vendor extensions do to hide it? Or custom switch? Anyway,
> the
> same thing needs to be resolved if HW design has dedicated test registers
> which
> are for debug. I will think about some solution.

I personally prefer rules without exception. Defined 32-bit fields over
whole register are harmless and if narrowed or reorganized later then
in can help.

....

> > OK, I have invested lot of time after Marin Jerabek's submission of
> > diploma theses to make code really documented etc.. I add there something
> > even that it is really simple use of can_len2dlc. May it be, we can use
> > that directly. It is Linux specific, but clean.
>
> Using can_len2dlc seems as right option for me...

Done

> > > > +// TODO: AL_CAPTURE and ERROR_CAPTURE
> >
> > Again colleagues remark for future work. For me, it is important
> > basic function under GNU/Linux.
>
> Again, CAN be removed and moved to Issue tracker on Gitlab.

Please add issue, I have removed this one already.

> It is basically the same topic as above. We need to generate everything
> from single
> source, otherwise we are not able to keep all the targets (RTL, TB, driver,
> docs)
> consistent.

Best wishes,

Pavel
