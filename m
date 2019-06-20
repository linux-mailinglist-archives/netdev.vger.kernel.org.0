Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E05004DCA4
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 23:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbfFTVhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 17:37:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbfFTVhW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 17:37:22 -0400
Received: from localhost (odyssey.drury.edu [64.22.249.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCD92206BA;
        Thu, 20 Jun 2019 21:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561066642;
        bh=KEOsoSrb9GsSalzLDzqg7oM6M3w4KE8UClR5usfMJ1Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q5uC+Cfu5/t9zh8Kv34dJcRj/KqPoNmIcR7JTUgi6pP3MCvNOE0KMP1xi5plXrb7S
         vNTBkhiveZjiKHxdAr5tlkUVlXgFMD3L1EYk0Oxm17AFLEZAjVuLNTc3m8p/fEX6RU
         /hWtSewfL3fPw70qmZ9m5N3ww3e2jpIZIBVVqss8=
Date:   Thu, 20 Jun 2019 16:37:21 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Puranjay Mohan <puranjay12@gmail.com>
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 3/3] net: fddi: skfp: Remove unused private PCI
 definitions
Message-ID: <20190620213721.GD110859@google.com>
References: <20190620180754.15413-1-puranjay12@gmail.com>
 <20190620180754.15413-4-puranjay12@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620180754.15413-4-puranjay12@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 11:37:54PM +0530, Puranjay Mohan wrote:
> Remove unused and private PCI definitions from skfbi.h because generic PCI
> symbols are already included from pci_regs.h.
> 
> Signed-off-by: Puranjay Mohan <puranjay12@gmail.com>
> ---
>  drivers/net/fddi/skfp/h/skfbi.h | 207 +-------------------------------
>  1 file changed, 1 insertion(+), 206 deletions(-)
> 
> diff --git a/drivers/net/fddi/skfp/h/skfbi.h b/drivers/net/fddi/skfp/h/skfbi.h
> index a05ce16171be..a8af80148022 100644
> --- a/drivers/net/fddi/skfp/h/skfbi.h
> +++ b/drivers/net/fddi/skfp/h/skfbi.h
> @@ -27,46 +27,6 @@
>  /*
>   * Configuration Space header
>   */

This comment should be removed because it goes along with the
definitions below (the ones from PCI_VENDOR_ID to PCI_MAX_LAT).

> -#define	PCI_VENDOR_ID	0x00	/* 16 bit	Vendor ID */
> -#define	PCI_DEVICE_ID	0x02	/* 16 bit	Device ID */

> @@ -74,179 +34,14 @@
>   * Note: The temperature and voltage sensors are relocated on a different
>   *	 I2C bus.
>   */
> -#define I2C_ADDR_VPD	0xA0	/* I2C address for the VPD EEPROM */ 
> +#define I2C_ADDR_VPD	0xA0	/* I2C address for the VPD EEPROM */

You removed the space at the end of the I2C_ADDR_VPD line.  That space
*is* a whitespace error, but generally you should avoid fixing random
unrelated issues in the middle of your patch.  Those random fixes make
it harder because the reviewer is expecting to see unused PCI-related
things removed and seeing an I2C diff is surprising and forces him/her
to do some investigation.

> -/*	PCI_STATUS	16 bit	Status */
>  #define	PCI_PERR	0x8000	/* Bit 15:	Parity Error */
>  #define	PCI_SERR	0x4000	/* Bit 14:	Signaled SERR */
>  #define	PCI_RMABORT	0x2000	/* Bit 13:	Received Master Abort */

These should be replaced by PCI_STATUS_DETECTED_PARITY and similar
generic definitions.  You could do this in your 1/1 patch along with
PCI_REVISION_ID.

> -#define	PCI_RTABORT	0x1000	/* Bit 12:	Received Target Abort */
>  #define	PCI_STABORT	0x0800	/* Bit 11:	Sent Target Abort */
> -#define	PCI_DEVSEL	0x0600	/* Bit 10..9:	DEVSEL Timing */
> -#define	PCI_DEV_FAST	(0<<9)	/*		fast */
> -#define	PCI_DEV_MEDIUM	(1<<9)	/*		medium */
> -#define	PCI_DEV_SLOW	(2<<9)	/*		slow */
>  #define	PCI_DATAPERR	0x0100	/* Bit 8:	DATA Parity error detected */
> -#define	PCI_FB2BCAP	0x0080	/* Bit 7:	Fast Back-to-Back Capability */
> -#define	PCI_UDF		0x0040	/* Bit 6:	User Defined Features */
> -#define PCI_66MHZCAP	0x0020	/* Bit 5:	66 MHz PCI bus clock capable */
> -#define PCI_NEWCAP	0x0010	/* Bit 4:	New cap. list implemented */
> -
>  #define PCI_ERRBITS	(PCI_PERR|PCI_SERR|PCI_RMABORT|PCI_STABORT|PCI_DATAPERR)
