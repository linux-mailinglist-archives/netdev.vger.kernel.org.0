Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26CBC6E460D
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 13:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjDQLKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 07:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbjDQLJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 07:09:54 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611E6448B
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 04:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681729734; x=1713265734;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XoNlC6hZUX9afGsGq9CxRFyJKsFqyn+FCX1eo3K60Io=;
  b=C7ky8Gj6euB36ksK/pfIaey+1mo0VCACj4z670UeojiQ1LSd8n69XrOJ
   kzhJF5V0UPfEN5Ku/IBXVEnUwNqjdnvlZLdqrz9LJQehiwc3nevymjunG
   am2iE3qUhEk7VPhkcq2+BYkhj1PjOQv3XyIXQ+u5c8IBjT85R9gajUk8I
   sJ+HyDkbA4+zZrpM6/0Pc5ILMWw7wQmrO9CC0491nmDWmC6CFx3Ubj0n5
   16mHTI2lgKfMshelNAv9DBCBZ5IbPwO7Y3OxxcIrqewb10/8EeK86gmqd
   ZXKh5KyeQbU1+j0yMBMPy28Kqauiae6S+qPTcB05HlJhoYzHq66W6IJu7
   g==;
X-IronPort-AV: E=Sophos;i="5.99,204,1677567600"; 
   d="scan'208";a="221196703"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Apr 2023 04:07:12 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 17 Apr 2023 04:07:12 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 17 Apr 2023 04:07:11 -0700
Date:   Mon, 17 Apr 2023 13:07:11 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Shmuel Hazan <shmuel.h@siklu.com>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC PATCH] net: mvpp2: tai: add extts support
Message-ID: <20230417110711.fmmszumm522ycb7f@soft-dev3-1>
References: <43bfd860b5f387f9344b251b7c83a795d1a96596.camel@siklu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <43bfd860b5f387f9344b251b7c83a795d1a96596.camel@siklu.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 04/16/2023 16:23, Shmuel Hazan wrote:
> [Some people who received this message don't often get email from shmuel.h@siklu.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]

Hi Shmuel,

Don't forget to send the patch to all maintainers of this file.
You can get a list of maintainers using the script 'get_maintainer.pl'

> 
> This commit add support for capturing
> a timestamp in which the PTP_PULSE pin,
> received a signal.
> 
> This feature is needed in order to synchronize
> multiple clocks in the same board, using
> tools like ts2phc from the linuxptp project.
> 
> On the Armada 8040, this is the only way to
> do so as a result of multiple erattas with
> the PTP_PULSE_IN interface that was designed
> to synchronize the TAI on an external PPS
> signal (the errattas are FE-6856276, FE-7382160
> from document MV-S501388-00).
> 
> This patch introduces a pinctrl
> configuration "extts" that will be selected
> once the user had enabled extts, and then
> will be returned back to the "default"
> pinctrl config once it has been disabled.
> 
> This pinctrl mess is needed due to the fact that
> there is no way for us to distinguish between
> an external trigger (e.g. from the PTP_PULSE_IN
> pin) or an internal one, triggered by the registers.

I think the line wrapper around should be 75. You will need to reformat
your commit message.
> 
> An example should be:
> 
> &cp1_ethernet {
>         pinctrl-names = "default", "extts";
>         pinctrl-0 = <&cp1_mpp6_gpio>;
>         pinctrl-1 = <&cp1_mpp6_ptp>;
>         status = "okay";
> };
> 
> This feature has been tested on an Aramda
> 8040 based board, with linuxptp 3.1.1's ts2phc.
> 
> Signed-off-by: Shmuel Hazan <shmuel.h@siklu.com>
> ---
>  .../net/ethernet/marvell/mvpp2/mvpp2_tai.c    | 210 ++++++++++++++++-
> -
>  1 file changed, 191 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
> b/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
> index 1b57573dd866..1dd2f977eb4f 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
> @@ -32,6 +32,8 @@
>   *
>   * Consequently, we support none of these.
>   */
> +#include <linux/pinctrl/consumer.h>
> +#include <linux/ptp_clock.h>

Why not keeping the alphabetic order?

>  #include <linux/io.h>
>  #include <linux/ptp_clock_kernel.h>
>  #include <linux/slab.h>
> @@ -53,6 +55,10 @@
>  #define TCSR_CAPTURE_1_VALID           BIT(1)
>  #define TCSR_CAPTURE_0_VALID           BIT(0)
> 
> +#define MVPP2_PINCTRL_EXTTS_STATE              "extts"
> +#define MAX_PINS 1
> +#define EXTTS_PERIOD_MS 95
> +
>  struct mvpp2_tai {
>         struct ptp_clock_info caps;
>         struct ptp_clock *ptp_clock;
> @@ -62,6 +68,11 @@ struct mvpp2_tai {
>         /* This timestamp is updated every two seconds */
>         struct timespec64 stamp;
>         u16 poll_worker_refcount;
> +       bool extts_enabled:1;

I think you introduce a hole in here. You can try using pahole to show
the struct layout.

> +       struct pinctrl *extts_pinctrl;
> +       struct pinctrl_state *default_pinctrl_state;
> +       struct pinctrl_state *extts_pinctrl_state;
> +       struct ptp_pin_desc pin_config[MAX_PINS];
>  };
> 
>  static void mvpp2_tai_modify(void __iomem *reg, u32 mask, u32 set)
> @@ -102,6 +113,25 @@ static void mvpp22_tai_read_ts(struct timespec64
> *ts, void __iomem *base)
>         readl_relaxed(base + 24);
>  }
> 
> +static int mvpp22_tai_try_read_ts(struct timespec64 *ts, void __iomem
> *base)
> +{
> +       int ret = 0;

ret doesn't need to be initialized as you assigned a value on all the
branches of the if.

> +       long tcsr = readl(base + MVPP22_TAI_TCSR);

Please use reverse x-mas notation.

> +
> +       if (tcsr & TCSR_CAPTURE_1_VALID) {
> +               mvpp22_tai_read_ts(ts, base +
> MVPP22_TAI_TCV1_SEC_HIGH);
> +               ret = 0;
> +       } else if (tcsr & TCSR_CAPTURE_0_VALID) {
> +               mvpp22_tai_read_ts(ts, base +
> MVPP22_TAI_TCV0_SEC_HIGH);
> +               ret = 0;
> +       } else {
> +               /* We don't seem to have a reading... */
> +               ret = -EBUSY;
> +       }
> +
> +       return ret;
> +}
> +
>  static void mvpp2_tai_write_tlv(const struct timespec64 *ts, u32
> frac,
>                                 void __iomem *base)
>  {
> @@ -116,14 +146,17 @@ static void mvpp2_tai_write_tlv(const struct
> timespec64 *ts, u32 frac,
> 
>  static void mvpp2_tai_op(u32 op, void __iomem *base)
>  {
> +       u32 reg_val;
> +
> +       reg_val = mvpp2_tai_read(base + MVPP22_TAI_TCFCR0);
>         /* Trigger the operation. Note that an external unmaskable
>          * event on PTP_EVENT_REQ will also trigger this action.
>          */
>         mvpp2_tai_modify(base + MVPP22_TAI_TCFCR0,
>                          TCFCR0_TCF_MASK | TCFCR0_TCF_TRIGGER,
>                          op | TCFCR0_TCF_TRIGGER);
> -       mvpp2_tai_modify(base + MVPP22_TAI_TCFCR0, TCFCR0_TCF_MASK,
> -                        TCFCR0_TCF_NOP);
> +       mvpp2_tai_modify(base + MVPP22_TAI_TCFCR0, TCFCR0_TCF_MASK |
> TCFCR0_TCF_TRIGGER,
> +                        reg_val);
>  }
> 
>  /* The adjustment has a range of +0.5ns to -0.5ns in 2^32 steps, so
> has units
> @@ -240,8 +273,11 @@ static int mvpp22_tai_gettimex64(struct
> ptp_clock_info *ptp,
>         struct mvpp2_tai *tai = ptp_to_tai(ptp);
>         unsigned long flags;
>         void __iomem *base;
> -       u32 tcsr;
>         int ret;
> +       u32 reg_val;

Please use reverse x-mas notation.

> +
> +       if (tai->extts_enabled)
> +               return -EBUSY;
> 
>         base = tai->base;
>         spin_lock_irqsave(&tai->lock, flags);
> @@ -250,25 +286,17 @@ static int mvpp22_tai_gettimex64(struct
> ptp_clock_info *ptp,
>          * triggered event, and an external event on PTP_EVENT_REQ.
> So this
>          * is incompatible with external use of PTP_EVENT_REQ.
>          */
> +       reg_val = mvpp2_tai_read(base + MVPP22_TAI_TCFCR0);
>         ptp_read_system_prets(sts);
>         mvpp2_tai_modify(base + MVPP22_TAI_TCFCR0,
>                          TCFCR0_TCF_MASK | TCFCR0_TCF_TRIGGER,
>                          TCFCR0_TCF_CAPTURE | TCFCR0_TCF_TRIGGER);
>         ptp_read_system_postts(sts);
> -       mvpp2_tai_modify(base + MVPP22_TAI_TCFCR0, TCFCR0_TCF_MASK,
> -                        TCFCR0_TCF_NOP);
> +       mvpp2_tai_modify(base + MVPP22_TAI_TCFCR0,
> +                        TCFCR0_TCF_MASK | TCFCR0_TCF_TRIGGER,
> +                        reg_val);
> 
> -       tcsr = readl(base + MVPP22_TAI_TCSR);
> -       if (tcsr & TCSR_CAPTURE_1_VALID) {
> -               mvpp22_tai_read_ts(ts, base +
> MVPP22_TAI_TCV1_SEC_HIGH);
> -               ret = 0;
> -       } else if (tcsr & TCSR_CAPTURE_0_VALID) {
> -               mvpp22_tai_read_ts(ts, base +
> MVPP22_TAI_TCV0_SEC_HIGH);
> -               ret = 0;
> -       } else {
> -               /* We don't seem to have a reading... */
> -               ret = -EBUSY;
> -       }
> +       ret = mvpp22_tai_try_read_ts(ts, base);
>         spin_unlock_irqrestore(&tai->lock, flags);
> 
>         return ret;
> @@ -280,6 +308,7 @@ static int mvpp22_tai_settime64(struct
> ptp_clock_info *ptp,
>         struct mvpp2_tai *tai = ptp_to_tai(ptp);
>         unsigned long flags;
>         void __iomem *base;
> +       u32 reg_val;
> 
>         base = tai->base;
>         spin_lock_irqsave(&tai->lock, flags);
> @@ -289,23 +318,48 @@ static int mvpp22_tai_settime64(struct
> ptp_clock_info *ptp,
>          * into the TOD counter. Note that an external unmaskable
> event on
>          * PTP_EVENT_REQ will also trigger this action.
>          */
> +       reg_val = mvpp2_tai_read(base + MVPP22_TAI_TCFCR0);
>         mvpp2_tai_modify(base + MVPP22_TAI_TCFCR0,
>                          TCFCR0_PHASE_UPDATE_ENABLE |
>                          TCFCR0_TCF_MASK | TCFCR0_TCF_TRIGGER,
>                          TCFCR0_TCF_UPDATE | TCFCR0_TCF_TRIGGER);
> -       mvpp2_tai_modify(base + MVPP22_TAI_TCFCR0, TCFCR0_TCF_MASK,
> -                        TCFCR0_TCF_NOP);
> +       mvpp2_tai_modify(base + MVPP22_TAI_TCFCR0,
> +                        TCFCR0_PHASE_UPDATE_ENABLE |
> +                        TCFCR0_TCF_MASK | TCFCR0_TCF_TRIGGER,
> +                        reg_val);
> +
>         spin_unlock_irqrestore(&tai->lock, flags);
> 
>         return 0;
>  }
> 
> +static void do_aux_work_extts(struct mvpp2_tai *tai)
> +{
> +       struct ptp_clock_event event;
> +       int ret;
> +
> +       ret = mvpp22_tai_try_read_ts(&tai->stamp, tai->base);
> +       /* We are not managed to read a TS, try again later */
> +       if (ret)
> +               return;
> +
> +       /* Triggered - save timestamp */
> +       event.type = PTP_CLOCK_EXTTS;
> +       event.index = 0; /* We only have one channel */

If you have only one channel, you should not check that in the
'mvpp22_tai_verify_pin' that you always use channel 0?

> +       event.timestamp = timespec64_to_ns(&tai->stamp);
> +       ptp_clock_event(tai->ptp_clock, &event);
> +}
> +
>  static long mvpp22_tai_aux_work(struct ptp_clock_info *ptp)
>  {
>         struct mvpp2_tai *tai = ptp_to_tai(ptp);
> 
> -       mvpp22_tai_gettimex64(ptp, &tai->stamp, NULL);
> +       if (tai->extts_enabled) {
> +               do_aux_work_extts(tai);
> +               return msecs_to_jiffies(EXTTS_PERIOD_MS);
> +       }
> 
> +       mvpp22_tai_gettimex64(ptp, &tai->stamp, NULL);
>         return msecs_to_jiffies(2000);
>  }
> 
> @@ -390,6 +444,92 @@ void mvpp22_tai_stop(struct mvpp2_tai *tai)
>         ptp_cancel_worker_sync(tai->ptp_clock);
>  }
> 
> +static void mvpp22_tai_capture_enable(struct mvpp2_tai *tai, bool
> enable)
> +{
> +       mvpp2_tai_modify(tai->base + MVPP22_TAI_TCFCR0,
> +                        TCFCR0_TCF_MASK,
> +                        enable ? TCFCR0_TCF_CAPTURE :
> TCFCR0_TCF_NOP);
> +}
> +
> +static int mvpp22_tai_req_extts_enable(struct mvpp2_tai *tai,
> +                                      struct ptp_clock_request *rq,
> int on)
> +{
> +       u8 index = rq->extts.index;
> +       int ret = 0;
> +
> +       if (!tai->extts_pinctrl)
> +               return -EINVAL;
> +
> +       /* Reject requests with unsupported flags */
> +       if (rq->extts.flags & ~(PTP_ENABLE_FEATURE |
> +                               PTP_RISING_EDGE |
> +                               PTP_FALLING_EDGE |
> +                               PTP_STRICT_FLAGS))
> +               return -EOPNOTSUPP;
> +
> +       /* Reject requests to enable time stamping on falling edge */
> +       if ((rq->extts.flags & PTP_ENABLE_FEATURE) &&
> +           (rq->extts.flags & PTP_FALLING_EDGE))
> +               return -EOPNOTSUPP;
> +
> +       if (index >= MAX_PINS)
> +               return -EINVAL;
> +
> +       if (on)
> +               ret = pinctrl_select_state(tai->extts_pinctrl, tai-
> >extts_pinctrl_state);
> +       else
> +               ret = pinctrl_select_state(tai->extts_pinctrl, tai-
> >default_pinctrl_state);
> +       if (ret)
> +               goto out;
> +
> +       tai->extts_enabled = on != 0;
> +       mvpp22_tai_capture_enable(tai, tai->extts_enabled);
> +
> +       /* We need to enable the poll worker in order for events to
> be polled */
> +       if (on)
> +               mvpp22_tai_start(tai);
> +       else
> +               mvpp22_tai_stop(tai);
> +
> +out:
> +       return ret;
> +}
> +
> +static int mvpp22_tai_enable(struct ptp_clock_info *ptp,
> +                            struct ptp_clock_request *rq, int on)
> +{
> +       struct mvpp2_tai *tai = ptp_to_tai(ptp);
> +       int err = -EOPNOTSUPP;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&tai->lock, flags);
> +
> +       switch (rq->type) {
> +       case PTP_CLK_REQ_EXTTS:
> +               err = mvpp22_tai_req_extts_enable(tai, rq, on);
> +               break;
> +       default:
> +               break;
> +       }
> +
> +       spin_unlock_irqrestore(&tai->lock, flags);
> +       return err;
> +}
> +
> +static int mvpp22_tai_verify_pin(struct ptp_clock_info *ptp, unsigned
> int pin,
> +                                enum ptp_pin_function func, unsigned
> int chan)
> +{
> +       switch (func) {
> +       case PTP_PF_NONE:
> +       case PTP_PF_EXTTS:
> +               break;
> +       case PTP_PF_PEROUT:
> +       case PTP_PF_PHYSYNC:
> +               return -1;
> +       }
> +       return 0;
> +}
> +
>  static void mvpp22_tai_remove(void *priv)
>  {
>         struct mvpp2_tai *tai = priv;
> @@ -402,6 +542,7 @@ int mvpp22_tai_probe(struct device *dev, struct
> mvpp2 *priv)
>  {
>         struct mvpp2_tai *tai;
>         int ret;
> +       int i;

If you prefer, you can declare i inside the for loop.

> 
>         tai = devm_kzalloc(dev, sizeof(*tai), GFP_KERNEL);
>         if (!tai)
> @@ -409,6 +550,23 @@ int mvpp22_tai_probe(struct device *dev, struct
> mvpp2 *priv)
> 
>         spin_lock_init(&tai->lock);
> 
> +       tai->extts_pinctrl = devm_pinctrl_get_select_default(dev);
> +       if (!IS_ERR(tai->extts_pinctrl)) {
> +               tai->default_pinctrl_state =
> pinctrl_lookup_state(tai->extts_pinctrl,
> +
> PINCTRL_STATE_DEFAULT);
> +               tai->extts_pinctrl_state = pinctrl_lookup_state(tai-
> >extts_pinctrl,
> +                                                               MVPP2
> _PINCTRL_EXTTS_STATE);
> +
> +               if (IS_ERR(tai->default_pinctrl_state) || IS_ERR(tai-
> >extts_pinctrl_state)) {
> +                       pinctrl_put(tai->extts_pinctrl);
> +                       tai->extts_pinctrl = NULL;
> +                       tai->default_pinctrl_state = NULL;
> +                       tai->extts_pinctrl_state = NULL;
> +               }
> +       } else {
> +               tai->extts_pinctrl = NULL;
> +       }
> +
>         tai->base = priv->iface_base;
> 
>         /* The step size consists of three registers - a 16-bit
> nanosecond step
> @@ -444,12 +602,26 @@ int mvpp22_tai_probe(struct device *dev, struct
> mvpp2 *priv)
> 
>         tai->caps.owner = THIS_MODULE;
>         strscpy(tai->caps.name, "Marvell PP2.2", sizeof(tai-
> >caps.name));
> +       tai->caps.n_ext_ts = MAX_PINS;
> +       tai->caps.n_pins = MAX_PINS;
>         tai->caps.max_adj = mvpp22_calc_max_adj(tai);
>         tai->caps.adjfine = mvpp22_tai_adjfine;
>         tai->caps.adjtime = mvpp22_tai_adjtime;
>         tai->caps.gettimex64 = mvpp22_tai_gettimex64;
>         tai->caps.settime64 = mvpp22_tai_settime64;
>         tai->caps.do_aux_work = mvpp22_tai_aux_work;
> +       tai->caps.enable = mvpp22_tai_enable;
> +       tai->caps.verify = mvpp22_tai_verify_pin;
> +       tai->caps.pin_config = tai->pin_config;
> +
> +       for (i = 0; i < tai->caps.n_pins; ++i) {
> +               struct ptp_pin_desc *ppd = &tai->caps.pin_config[i];
> +
> +               snprintf(ppd->name, sizeof(ppd->name),
> "PTP_PULSE_IN%d", i);
> +               ppd->index = i;
> +               ppd->func = PTP_PF_NONE;
> +               ppd->chan = 0;
> +       }
> 
>         ret = devm_add_action(dev, mvpp22_tai_remove, tai);
>         if (ret)
> --
> 2.40.0
> 
> 

-- 
/Horatiu
