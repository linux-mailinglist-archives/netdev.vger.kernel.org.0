Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 295213C1B05
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 23:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhGHVfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 17:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbhGHVfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 17:35:14 -0400
X-Greylist: delayed 400 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 08 Jul 2021 14:32:31 PDT
Received: from mail.sf-mail.de (mail.sf-mail.de [IPv6:2a01:4f8:1c17:6fae:616d:6c69:616d:6c69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530BEC06175F
        for <netdev@vger.kernel.org>; Thu,  8 Jul 2021 14:32:31 -0700 (PDT)
Received: (qmail 4076 invoked from network); 8 Jul 2021 21:22:53 -0000
Received: from p548d4fed.dip0.t-ipconnect.de ([::ffff:84.141.79.237]:37098 HELO daneel.sf-tec.de) (auth=eike@sf-mail.de)
        by mail.sf-mail.de (Qsmtpd 0.38dev) with (TLS_AES_256_GCM_SHA384 encrypted) ESMTPSA
        for <gregkh@linuxfoundation.org>; Thu, 08 Jul 2021 23:22:53 +0200
From:   Rolf Eike Beer <eike-kernel@sf-tec.de>
To:     gregkh@linuxfoundation.org, Carlos Bilbao <bilbao@vt.edu>
Cc:     alexander.deucher@amd.com, davem@davemloft.net,
        mchehab+huawei@kernel.org, kuba@kernel.org,
        James.Bottomley@hansenpartnership.com, netdev@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: Follow the indentation coding standard on printks
Date:   Thu, 08 Jul 2021 23:25:37 +0200
Message-ID: <2148456.iZASKD2KPV@daneel.sf-tec.de>
In-Reply-To: <2784471.e9J7NaK4W3@iron-maiden>
References: <2784471.e9J7NaK4W3@iron-maiden>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1863788.PYKUYFuaPT"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart1863788.PYKUYFuaPT
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Donnerstag, 8. Juli 2021, 15:10:01 CEST schrieb Carlos Bilbao:
> Fix indentation of printks that start at the beginning of the line. Change
> this for the right number of space characters, or tabs if the file uses
> them.

> diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
> index bc8e8d9f176b..65bb700cd5af 100644
> --- a/drivers/atm/iphase.c
> +++ b/drivers/atm/iphase.c
> @@ -1246,7 +1246,7 @@ static void rx_intr(struct atm_dev *dev)
>                 ((iadev->rx_pkt_cnt - iadev->rx_tmp_cnt) == 0)) {
>          for (i = 1; i <= iadev->num_rx_desc; i++)
>                 free_desc(dev, i);
> -printk("Test logic RUN!!!!\n");
> +        printk("Test logic RUN!!!!\n");
>          writew(
> ~(RX_FREEQ_EMPT|RX_EXCP_RCVD),iadev->reass_reg+REASS_MASK_REG);
> iadev->rxing = 1;
>       }

This looks like leftover debug code and probably should just be deleted.

> diff --git a/drivers/atm/suni.c b/drivers/atm/suni.c
> index 21e5acc766b8..149605cdb859 100644
> --- a/drivers/atm/suni.c
> +++ b/drivers/atm/suni.c
> @@ -328,8 +328,8 @@ static int suni_start(struct atm_dev *dev)
>  		timer_setup(&poll_timer, suni_hz, 0);
>  		poll_timer.expires = jiffies+HZ;
>  #if 0
> -printk(KERN_DEBUG "[u] p=0x%lx,n=0x%lx\n",(unsigned long)
> poll_timer.list.prev, -    (unsigned long) poll_timer.list.next);
> +	printk(KERN_DEBUG "[u] p=0x%lx,n=0x%lx\n",(unsigned long)
> poll_timer.list.prev, +	    (unsigned long) poll_timer.list.next);
>  #endif
>  		add_timer(&poll_timer);
>  	}

This should be converted to pr_debug() and the #if 0 can be removed. Or the 
whole thing should likely just be removed, this looks like dead debug code.

> diff --git a/drivers/atm/zatm.c b/drivers/atm/zatm.c
> index cf5fffcf98a1..4fb89ed47311 100644
> --- a/drivers/atm/zatm.c
> +++ b/drivers/atm/zatm.c
> @@ -380,7 +380,7 @@ static void poll_rx(struct atm_dev *dev,int mbx)
>  			pos = zatm_dev->mbx_start[mbx];
>  		cells = here[0] & uPD98401_AAL5_SIZE;
>  #if 0
> -printk("RX IND: 0x%x, 0x%x, 0x%x, 0x%x\n",here[0],here[1],here[2],here[3]);
> +		printk("RX IND: 0x%x, 0x%x, 0x%x,
> 0x%x\n",here[0],here[1],here[2],here[3]);
> {
>  unsigned long *x;
>  		printk("POOL: 0x%08x, 0x%08x\n",zpeekl(zatm_dev,

This is lacking a loglevel, as well as the following prints. It should be 
converted to pr_debug(). The indentation of the following lines should be 
fixed, too.

> @@ -403,14 +403,14 @@ EVENT("error code 0x%x/0x%x\n",(here[3] &
> uPD98401_AAL5_ES) >> skb = ((struct rx_buffer_head *)
> bus_to_virt(here[2]))->skb;
>  		__net_timestamp(skb);
>  #if 0
> -printk("[-3..0] 0x%08lx 0x%08lx 0x%08lx 0x%08lx\n",((unsigned *)
> skb->data)[-3],
> +		printk("[-3..0] 0x%08lx 0x%08lx 0x%08lx
> 0x%08lx\n",((unsigned *) skb->data)[-3],
> ((unsigned *) skb->data)[-2],((unsigned *) skb->data)[-1],
>    ((unsigned *) skb->data)[0]);
>  #endif

These as well. But this doesn't make sense, the format string says %lx, but 
the casts are to unsigned, so I suspect this would spit warnings if enabled.

>  		EVENT("skb 0x%lx, here 0x%lx\n",(unsigned long) skb,
>  		    (unsigned long) here);
>  #if 0
> -printk("dummy: 0x%08lx, 0x%08lx\n",dummy[0],dummy[1]);
> +		printk("dummy: 0x%08lx, 0x%08lx\n",dummy[0],dummy[1]);
>  #endif
>  		size = error ? 0 : ntohs(((__be16 *) skb->data)[cells*
>  		    ATM_CELL_PAYLOAD/sizeof(u16)-3]);

Same here.

> @@ -664,7 +664,7 @@ static int do_tx(struct sk_buff *skb)
>  		EVENT("dsc (0x%lx)\n",(unsigned long) dsc,0);
>  	}
>  	else {
> -printk("NONONONOO!!!!\n");
> +		printk("NONONONOO!!!!\n");
>  		dsc = NULL;
>  #if 0
>  		u32 *put;

And this should give something more useful, at least showing the driver name 
or something like that.

> diff --git a/drivers/net/ethernet/dec/tulip/de4x5.c
> b/drivers/net/ethernet/dec/tulip/de4x5.c index b125d7faefdf..155cfe8800cd
> 100644
> --- a/drivers/net/ethernet/dec/tulip/de4x5.c
> +++ b/drivers/net/ethernet/dec/tulip/de4x5.c
> @@ -3169,7 +3169,7 @@ dc2114x_autoconf(struct net_device *dev)
> 
>      default:
>  	lp->tcount++;
> -printk("Huh?: media:%02x\n", lp->media);
> +	printk("Huh?: media:%02x\n", lp->media);
>  	lp->media = INIT;
>  	break;
>      }

That should be netdev_something, like netdev_dbg() or netdev_warn().

> diff --git a/drivers/net/sb1000.c b/drivers/net/sb1000.c
> index e88af978f63c..54a7c7613434 100644
> --- a/drivers/net/sb1000.c
> +++ b/drivers/net/sb1000.c

Here as well.

> --- a/drivers/parisc/iosapic.c
> +++ b/drivers/parisc/iosapic.c
> @@ -633,7 +633,7 @@ static void iosapic_unmask_irq(struct irq_data *d)
>  	printk("\n");
>  }
> 
> -printk("iosapic_enable_irq(): sel ");
> +	printk("iosapic_enable_irq(): sel ");
>  {
>  	struct iosapic_info *isp = vi->iosapic;
> 
> @@ -642,7 +642,7 @@ printk("iosapic_enable_irq(): sel ");
>  		printk(" %x", d1);
>  	}
>  }
> -printk("\n");
> +	printk("\n");
>  #endif
> 
>  	/*

This is also debug code. It is basically unchanged since it has been imported 
into git. So it may be time to remove the whole block. Helge?

> diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
> index dce4cdf786cd..c3381facdfc5 100644
> --- a/drivers/parisc/sba_iommu.c
> +++ b/drivers/parisc/sba_iommu.c
> @@ -1550,7 +1550,7 @@ static void sba_hw_init(struct sba_device *sba_dev)
> 
> 
>  #if 0
> -printk("sba_hw_init(): mem_boot 0x%x 0x%x 0x%x 0x%x\n",
> PAGE0->mem_boot.hpa, 
> +	printk("sba_hw_init(): mem_boot 0x%x 0x%x 0x%x
> 0x%x\n", PAGE0->mem_boot.hpa, PAGE0->mem_boot.spa, PAGE0->mem_boot.pad,
> PAGE0->mem_boot.cl_class);
> 
>  	/*

This is equally old. It should be either also removed, also this seems at 
least worth as documentation. Maybe just switch it to pr_debug() or 
dev_debug() while fixing the indentation.

Eike
--nextPart1863788.PYKUYFuaPT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSaYVDeqwKa3fTXNeNcpIk+abn8TgUCYOdtUQAKCRBcpIk+abn8
TjvKAJ9KW9u+by7dUbwpWaarnO5vdJOoeQCgn2MPuAeWlpS6renjtPDd6xD15P8=
=xCeP
-----END PGP SIGNATURE-----

--nextPart1863788.PYKUYFuaPT--



