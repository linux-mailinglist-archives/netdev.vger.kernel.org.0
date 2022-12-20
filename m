Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45B11651BFA
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 08:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbiLTHuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 02:50:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiLTHun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 02:50:43 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08FE2A1;
        Mon, 19 Dec 2022 23:50:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671522641; x=1703058641;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=y7kzW7wiQHNQKgWsYnF0m+caBPul5zY67fLc8pu5Ed0=;
  b=VlcdIWfxC4iflPYlY4W+zOn0vjR/B5n76OYcE5nbV2AvKHlbkxkiEtay
   XdZCLKJkR0tk0NUBhSyP743lwEIQFWCngCdgsua3dtml8Gwq5Em/KR2fY
   zyrGDGkpHwfgvU6f9kfQqApYqsillZ0i07SEigTu6VVrNZ7ho7CP3XK/5
   HYU/ifgUMlc8CEb3+C+RcDEonf3S9xRp9Wzud3G5nVAvNAoJfodpG6wdq
   xEyKYSrgDu6MTRQYnAjHcFseciknfPJmizjKQtAmFBVGf7lTMbr8f/e1/
   fMDwoi6XpeCJbb0r4NVH44LtfpfFfV6Eom9GOwKpNCJzmfYyKEfDyXwBx
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="405802822"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="405802822"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 23:50:41 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="739663471"
X-IronPort-AV: E=Sophos;i="5.96,258,1665471600"; 
   d="scan'208";a="739663471"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 23:50:38 -0800
Date:   Tue, 20 Dec 2022 08:50:28 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] iavf/iavf_main: actually log ->src mask when talking
 about it
Message-ID: <Y6FpRFt0A3NrabS8@localhost.localdomain>
References: <20221220063246.1593327-1-d-tatianin@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220063246.1593327-1-d-tatianin@yandex-team.ru>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 20, 2022 at 09:32:46AM +0300, Daniil Tatianin wrote:
> This fixes a copy-paste issue where dev_err would log the dst mask even
> though it is clearly talking about src.
> 
> Found by Linux Verification Center (linuxtesting.org) with the SVACE
> static analysis tool.
> 
> Fixes: 0075fa0fadd0 ("i40evf: Add support to apply cloud filters")
> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index c4e451ef7942..adc02adef83a 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> @@ -3850,7 +3850,7 @@ static int iavf_parse_cls_flower(struct iavf_adapter *adapter,
>  				field_flags |= IAVF_CLOUD_FIELD_IIP;
>  			} else {
>  				dev_err(&adapter->pdev->dev, "Bad ip src mask 0x%08x\n",
> -					be32_to_cpu(match.mask->dst));
> +					be32_to_cpu(match.mask->src));
>  				return -EINVAL;
>  			}
>  		}
> -- 
> 2.25.1

Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

It is good practise to include changelog in message when You send
another version. For example:

v1:
 * change fix tag to 12 chars
