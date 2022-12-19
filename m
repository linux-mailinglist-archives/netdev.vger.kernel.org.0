Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A60650BD8
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 13:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbiLSMiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 07:38:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbiLSMiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 07:38:23 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C46C0E;
        Mon, 19 Dec 2022 04:38:22 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id a16so12626426edb.9;
        Mon, 19 Dec 2022 04:38:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P35Dm6yljztCfkmMWVsbi1/Gv3F+0l+Aow/usT+geaY=;
        b=dCmmfbtEp/ZvHxbyGMC8JN5EljjzV4Ik/d/KpznueYW3PBrO2lD7xj1auiOxdVSzIu
         iBqnVPrZn5hhMfA2XuKZrfANToUJmxN5bsqen3PSxCII2EhM12cNlMv5mXRlWPNDac6J
         PJNJUtvjPY6PcTZ4Yk7Q5UjnJgyOJHuC0/1LjUTAlBovFwfUh42h/sgcxOUI7+mm9nHV
         kNrvmn82a+mzuUOUQjd15l0JBQLbEHEdtYRbTXPS0pHYeMS5daG0CTXoAA/10WEVzDOC
         u4LniD1YTcwQHuc0N5gTpZygV99PAkBe7HZLodAeT2reMITZotg0I2p9RIE89+7lxQxE
         ouoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P35Dm6yljztCfkmMWVsbi1/Gv3F+0l+Aow/usT+geaY=;
        b=yX+BTXgrrwOgSMiHa+YlUsxoakiRHkUOAL2Eh7yw0w5jK5viMEbIOFd94gqsLzE5lX
         Kxcb2SepsKrohyT60vr9VazqkUpnqY+n5ptfr19Z1u1+7eiEY2V49NOk+usdYTdlOEtA
         MXc3KqnFw4xz/ybhJzqMF2gyGqeRPYdfP02QoCx7BM8wVKFrZUeRpjmfrLaWtujwZOyh
         qYXUGwLKF6M3zJpbhv9FJAauAGpQvH0+Cvn/dIfpvKKTPUSm2UQjPaRJmEQV/jX0W7dc
         MfCDDw71arDd6+/qaZyosCpAatHXZYT0FWDTfF1ai+r65lsR4zMAG+k1OYyEWpL8gBSX
         1EjA==
X-Gm-Message-State: ANoB5pmORaqGNJ+8CRGAHOL489DFdcd/VUb59XlQW7aoV2PyCo3TRrUy
        36x8qCm37cxEqFDok8i7jec=
X-Google-Smtp-Source: AA0mqf7nS1LndcE8KUtyxgedir9em/Gg9Px9ZMYQR9upN8E4N95Pt2gG+DN6SnPKxxDoWNhlIK6+sA==
X-Received: by 2002:aa7:c40c:0:b0:46c:a1f7:d9c5 with SMTP id j12-20020aa7c40c000000b0046ca1f7d9c5mr36195056edq.38.1671453501072;
        Mon, 19 Dec 2022 04:38:21 -0800 (PST)
Received: from skbuf ([188.27.185.38])
        by smtp.gmail.com with ESMTPSA id i24-20020a50fc18000000b004701c6a403asm4284427edr.86.2022.12.19.04.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 04:38:20 -0800 (PST)
Date:   Mon, 19 Dec 2022 14:38:17 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com,
        ceggers@arri.de
Subject: Re: [Patch net-next v4 05/13] net: dsa: microchip: ptp: enable
 interrupt for timestamping
Message-ID: <20221219123817.bhsyujqgzl5mrsxw@skbuf>
References: <20221212102639.24415-1-arun.ramadoss@microchip.com>
 <20221212102639.24415-1-arun.ramadoss@microchip.com>
 <20221212102639.24415-6-arun.ramadoss@microchip.com>
 <20221212102639.24415-6-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212102639.24415-6-arun.ramadoss@microchip.com>
 <20221212102639.24415-6-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 12, 2022 at 03:56:31PM +0530, Arun Ramadoss wrote:
> +int ksz_ptp_irq_setup(struct dsa_switch *ds, u8 p)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	const struct ksz_dev_ops *ops = dev->dev_ops;
> +	struct ksz_port *port = &dev->ports[p];
> +	struct ksz_irq *ptpirq = &port->ptpirq;
> +	int ret;
> +
> +	ptpirq->dev = dev;
> +	ptpirq->masked = 0;
> +	ptpirq->nirqs = 3;
> +	ptpirq->reg_mask = ops->get_port_addr(p, REG_PTP_PORT_TX_INT_ENABLE__2);
> +	ptpirq->reg_status = ops->get_port_addr(p,
> +						REG_PTP_PORT_TX_INT_STATUS__2);
> +	snprintf(ptpirq->name, sizeof(ptpirq->name), "ptp_irq-%d", p);
> +
> +	ptpirq->irq_num = irq_find_mapping(port->pirq.domain, PORT_SRC_PTP_INT);
> +	if (ptpirq->irq_num < 0)
> +		return ptpirq->irq_num;
> +
> +	ptpirq->domain = irq_domain_add_simple(dev->dev->of_node, ptpirq->nirqs,
> +					       0, &ksz_ptp_irq_domain_ops,
> +					       ptpirq);

If I look at Documentation/core-api/irq/irq-domain.rst, I read this:

| Legacy
| ------
| 
| ::
| 
| 	irq_domain_add_simple()
| 	irq_domain_add_legacy()
| 	irq_domain_create_simple()
| 	irq_domain_create_legacy()
| 
| The Legacy mapping is a special case for drivers that already have a
| range of irq_descs allocated for the hwirqs.  It is used when the
| driver cannot be immediately converted to use the linear mapping.  For
| example, many embedded system board support files use a set of #defines
| for IRQ numbers that are passed to struct device registrations.  In that
| case the Linux IRQ numbers cannot be dynamically assigned and the legacy
| mapping should be used.
| 
| As the name implies, the \*_legacy() functions are deprecated and only
| exist to ease the support of ancient platforms. No new users should be
| added. Same goes for the \*_simple() functions when their use results
| in the legacy behaviour.
| 
| The legacy map assumes a contiguous range of IRQ numbers has already
| been allocated for the controller and that the IRQ number can be
| calculated by adding a fixed offset to the hwirq number, and
| visa-versa.  The disadvantage is that it requires the interrupt
| controller to manage IRQ allocations and it requires an irq_desc to be
| allocated for every hwirq, even if it is unused.
| 
| The legacy map should only be used if fixed IRQ mappings must be
| supported.  For example, ISA controllers would use the legacy map for
| mapping Linux IRQs 0-15 so that existing ISA drivers get the correct IRQ
| numbers.
| 
| Most users of legacy mappings should use irq_domain_add_simple() or
| irq_domain_create_simple() which will use a legacy domain only if an IRQ range
| is supplied by the system and will otherwise use a linear domain mapping.
| The semantics of this call are such that if an IRQ range is specified then
| descriptors will be allocated on-the-fly for it, and if no range is
| specified it will fall through to irq_domain_add_linear() or
| irq_domain_create_linear() which means *no* irq descriptors will be allocated.

I think you should be absolutely fine with using irq_domain_add_linear().

> +	if (!ptpirq->domain)
> +		return -ENOMEM;
> +
> +	ret = request_threaded_irq(ptpirq->irq_num, NULL, ksz_ptp_irq_thread_fn,
> +				   IRQF_ONESHOT, ptpirq->name, ptpirq);
> +	if (ret)
> +		goto out;
> +
> +	ret = ksz_ptp_msg_irq_setup(port);
> +	if (ret)
> +		goto out;

I think the error path is a bit shaky. Since request_threaded_irq() is
not the devres variant (devm_request_threaded_irq()), there should be a
free_irq() call on error.

> +
> +	return 0;
> +
> +out:
> +	irq_dispose_mapping(ptpirq->irq_num);
> +
> +	return ret;
> +}
