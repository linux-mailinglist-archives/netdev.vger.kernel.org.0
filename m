Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725BA2B2A70
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 02:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgKNBZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 20:25:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgKNBZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 20:25:49 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77BAAC0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 17:25:49 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id l12so10161555ilo.1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 17:25:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OLGPcN4G6TbF7NHxfQPn/r++WRRMbk61T2RJHOY8YDg=;
        b=KqDcfuGRwbJkZZAm0uvyxiKaBhqE99ApOE7jCKUA0icOczlBjhYY1qAh67XckXS8Ld
         iBeO+qvTdpPMGCHRmrVuujNIrjAOJUXiz0xq3VUnA6GGeK9Q9YSmm6w+UU8cdGQIcSSF
         zmU9DTc90afrNGQ7vNbMco+Zn0XLERxtU9+CFgxYetpHRlqROT7KKtOpfjXzPo+ZTf0q
         10vKUh7/z3DznGxMhb83GAWKD8jZh2pc4n5rxpVPdf/79oLFlB+Q445sS7OlTWTO60lo
         PPDBYPV4KQtQLyT7wAM0X0iPR9H0EWRLX5GfrWeivWwJ2k2WvD/Ra4wsdj449SMWKMni
         z/Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OLGPcN4G6TbF7NHxfQPn/r++WRRMbk61T2RJHOY8YDg=;
        b=BNjQhTFP2j/C1/Vx/r6go7MJ2+eTPIuuWB2f002ixKRmi/xG5xW2thgZ9XN5rSRg80
         gJ+ckIMtCIZy1G9tURDxDngD9mc6uV27SLTrUQ71NxoKHULIFGImBTczh+f6m+hCi1Ek
         1XaG5Kp2bUHobBU9AyerjeYSQSgjnCiLQUfFfoUjDETR5r5xUlGNzmF1dv18qI/mHXxn
         wuYp+pGlJBfVPPCVFBQd8j2tif6RLwy1cApjXZtnsRIPJyNZqvPNHcKWBU5zYge6zY6z
         F/71pKYir5oaXhGwnGhi2v5sCSC2aGhxaGbw9FOPE6GSTtLqAPZMkGqbewcwW4zH3X4H
         sn0w==
X-Gm-Message-State: AOAM531KSC6VSDzq2v8qOljsL/VcIV7q5UZnjVinyI/rkyOyoX9gu7U+
        pFHHVJ1bbjYsTpkWZcni+OESfTMBkYjOO/XH9CY=
X-Google-Smtp-Source: ABdhPJwzJoHIFhcrAoDFZsGbQNS5hlq2ttQC4TfLpTCO+POG02Yu5b3LnSFnpY4XLiNWdyy4rEnnAi0y8th5sa3DDl0=
X-Received: by 2002:a92:ca86:: with SMTP id t6mr1844085ilo.95.1605317148565;
 Fri, 13 Nov 2020 17:25:48 -0800 (PST)
MIME-Version: 1.0
References: <20201113214429.2131951-1-anthony.l.nguyen@intel.com> <20201113214429.2131951-9-anthony.l.nguyen@intel.com>
In-Reply-To: <20201113214429.2131951-9-anthony.l.nguyen@intel.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 13 Nov 2020 17:25:37 -0800
Message-ID: <CAKgT0Uedphdr1RvdB_Zw5aAH-2CuudwGK8OenrvrQ1bE0XK-pQ@mail.gmail.com>
Subject: Re: [net-next v3 08/15] ice: don't always return an error for Get PHY
 Abilities AQ command
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        Stefan Assmann <sassmann@redhat.com>,
        Aaron Brown <aaron.f.brown@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 1:49 PM Tony Nguyen <anthony.l.nguyen@intel.com> wrote:
>
> From: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
>
> There are times when the driver shouldn't return an error when the Get
> PHY abilities AQ command (0x0600) returns an error. Instead the driver
> should log that the error occurred and continue on. This allows the
> driver to load even though the AQ command failed. The user can then
> later determine the reason for the failure and correct it.
>
> Signed-off-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
> Tested-by: Aaron Brown <aaron.f.brown@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
> index 7db5fd977367..3c600808d0da 100644
> --- a/drivers/net/ethernet/intel/ice/ice_common.c
> +++ b/drivers/net/ethernet/intel/ice/ice_common.c
> @@ -925,7 +925,7 @@ enum ice_status ice_init_hw(struct ice_hw *hw)
>                                      ICE_AQC_REPORT_TOPO_CAP, pcaps, NULL);
>         devm_kfree(ice_hw_to_dev(hw), pcaps);
>         if (status)
> -               goto err_unroll_sched;
> +               ice_debug(hw, ICE_DBG_PHY, "Get PHY capabilities failed, continuing anyway\n");
>
>         /* Initialize port_info struct with link information */
>         status = ice_aq_get_link_info(hw->port_info, false, NULL, NULL);
> --
> 2.26.2
>

If we are expecting the user to correct things then we should be
putting out a warning via dev_warn() rather than a debug message.
Otherwise the user is just going to have to come back through and turn
on debugging and reload the driver in order to figure out what is
going on. In my mind it should get the same treatment as an outdated
NVM image in ice_aq_ver_check().
