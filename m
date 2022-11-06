Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91AF561E558
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 19:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiKFSkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 13:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKFSkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 13:40:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050E7FCCB;
        Sun,  6 Nov 2022 10:40:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5BFBB80CA2;
        Sun,  6 Nov 2022 18:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3B2C433C1;
        Sun,  6 Nov 2022 18:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667760041;
        bh=AVnsoYGb2+AD+XRwI/0qYBFYN0B977pukexcxCro4fM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=obXaSTt/yx69kdCi6VfoD+7BNQfjeRBCgEHNImgGqs3BLbmzZEzei7tX+sESkfaQU
         XmbyBUggVLVRN0HciufzMpVy8MXcGPnu8Wkm5VR3mZZmHsPmvRqE0XUAAs8h/WfKEx
         c68YBGqf5nsinyS+L6PZI3ILK+32mfvcq48GhpB1a+XzBBSX/UbJKQfMPSu5I/aRRA
         4Kg9x1dXMgKaO4WTNR/mQT3PDILHgdRkWlwdxx3jpUE/sIEyHzqZeHaKlfmHHn8gcN
         g9b0Q4eqyWZa8XF1hoXfm5BfhYn5JC9vXue2V3dZrCG7mTJREeoghW0Rq/y/MMQ/j3
         KKscj4Uiphagg==
Date:   Sun, 6 Nov 2022 20:40:36 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Veerasenareddy Burru <vburru@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lironh@marvell.com, aayarekar@marvell.com, sedara@marvell.com,
        sburla@marvell.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] octeon_ep: support Octeon device CNF95N
Message-ID: <Y2f/pE5Fr5wJUtSJ@unreal>
References: <20221101153539.22630-1-vburru@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101153539.22630-1-vburru@marvell.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 08:35:39AM -0700, Veerasenareddy Burru wrote:
> Add support for Octeon device CNF95N.
> CNF95N is a Octeon Fusion family product with same PCI NIC
> characteristics as CN93 which is currently supported by the driver.
> 
> Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
> ---
>  .../ethernet/marvell/octeon_ep/octep_main.c   | 19 ++++++++++++++++---
>  .../ethernet/marvell/octeon_ep/octep_main.h   |  2 ++
>  2 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> index 9089adcb75f9..e956c1059fc8 100644
> --- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> @@ -23,6 +23,7 @@ struct workqueue_struct *octep_wq;
>  /* Supported Devices */
>  static const struct pci_device_id octep_pci_id_tbl[] = {
>  	{PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, OCTEP_PCI_DEVICE_ID_CN93_PF)},
> +	{PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, OCTEP_PCI_DEVICE_ID_CNF95N_PF)},
>  	{0, },
>  };
>  MODULE_DEVICE_TABLE(pci, octep_pci_id_tbl);
> @@ -907,6 +908,18 @@ static void octep_ctrl_mbox_task(struct work_struct *work)
>  	}
>  }
>  
> +static const char *octep_devid_to_str(struct octep_device *oct)
> +{
> +	switch (oct->chip_id) {
> +	case OCTEP_PCI_DEVICE_ID_CN93_PF:
> +		return "CN93XX";
> +	case OCTEP_PCI_DEVICE_ID_CNF95N_PF:
> +		return "CNF95N";
> +	default:
> +		return "Unsupported";
> +	}
> +}
> +
>  /**
>   * octep_device_setup() - Setup Octeon Device.
>   *
> @@ -939,9 +952,9 @@ int octep_device_setup(struct octep_device *oct)
>  
>  	switch (oct->chip_id) {
>  	case OCTEP_PCI_DEVICE_ID_CN93_PF:
> -		dev_info(&pdev->dev,
> -			 "Setting up OCTEON CN93XX PF PASS%d.%d\n",
> -			 OCTEP_MAJOR_REV(oct), OCTEP_MINOR_REV(oct));
> +	case OCTEP_PCI_DEVICE_ID_CNF95N_PF:
> +		dev_info(&pdev->dev, "Setting up OCTEON %s PF PASS%d.%d\n",
> +			 octep_devid_to_str(oct), OCTEP_MAJOR_REV(oct), OCTEP_MINOR_REV(oct));
>  		octep_device_setup_cn93_pf(oct);
>  		break;
>  	default:
> diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.h b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
> index 025626a61383..123ffc13754d 100644
> --- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
> +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
> @@ -21,6 +21,8 @@
>  #define  OCTEP_PCI_DEVICE_ID_CN93_PF 0xB200
>  #define  OCTEP_PCI_DEVICE_ID_CN93_VF 0xB203
>  
> +#define  OCTEP_PCI_DEVICE_ID_CNF95N_PF 0xB400    //95N PF

AFAIK, correct comment style is /* */ and not //.

BTW, patch should include target "[PATCH net-next]...".

> +
>  #define  OCTEP_MAX_QUEUES   63
>  #define  OCTEP_MAX_IQ       OCTEP_MAX_QUEUES
>  #define  OCTEP_MAX_OQ       OCTEP_MAX_QUEUES
> -- 
> 2.36.0
> 
