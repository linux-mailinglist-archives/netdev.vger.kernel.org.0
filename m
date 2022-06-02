Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 583C553BBFF
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 17:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236694AbiFBP5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 11:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236684AbiFBP5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 11:57:45 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7706453E04
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 08:57:44 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id y196so5099696pfb.6
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 08:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=geyGj2h8e5l4UvjaG7yeOltvkAXWrkX3tnYPm/28OpM=;
        b=J7oc9gaOHz7cu1wMvim5v58b0ncAlSkdd+bBZQ652fPzpKuCR8VDXEHy+a3i9H/aJE
         u3CjahDq48eE5TS/3qSTkFrPYG/1VEB25jXMY2Tatgm+CLAB1t+Q4/lOkTkT3RRB3bYl
         pB0tamF8CO4YSYzxaYNVmz3GDSOtIsGMMGJGmBnEMfxCGfVcrVIzM2mh3cVJbVsDHlrN
         zthxjcfxsTHBmJIcBoyGHfk1I7E2hPz6LEpp9ZRdbvhkkMhGAKcjigS+m1M5/PXxuOAc
         ure4OMlDX/BkcLE0wpTCwP4zDYDXL5Z2k3OJMikfhCiwHtDyNy7tvSKFlwi4WtUTH5rf
         EIgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=geyGj2h8e5l4UvjaG7yeOltvkAXWrkX3tnYPm/28OpM=;
        b=dxwt//EndH39itGN/SsFgLUVUVAzXALfEshwYzQqDQaJybECO71+jd1fnUrUyRrp+i
         P7ZW2CWJBoDunLF6yJijpa/4BpwAc7QXp5OXbL/LXNwsE+W7VC8C0qcbcM8VVuHsFhFu
         +ewSAeV3RrI596JbGQmonVWK1DRGTcc1PJdYDuwGsJgbVbPpnOSL5bcZC0U8AZbczprt
         mEjdHzx3HfMQr53IEFLJznWKyyQG6MOVuw2yJnrRkZrF43H4oJPnqLSnL0v8HWYqRhB4
         2qmRp1PWRQV/ddDgQMBh3jYbF9ygNwpUutUlyhy8zDAyqnxFLLdqsKmzm8JNbqk7OsLT
         oA1g==
X-Gm-Message-State: AOAM533LVWOmvEPxIqiU3kKLQbadKhPDaCTktsBHCWgCdIAXNVesI3su
        jn+cva0n5cFDvbh2N9TFsK8=
X-Google-Smtp-Source: ABdhPJyZX0VZHGnsu0fmc0nF/zEyM2xuUFHR/oXBozjNIgICnhchUzL3uIfQcp+/6NcvJopwanUuRA==
X-Received: by 2002:a05:6a00:8cb:b0:510:9ec4:8f85 with SMTP id s11-20020a056a0008cb00b005109ec48f85mr5908257pfu.24.1654185463778;
        Thu, 02 Jun 2022 08:57:43 -0700 (PDT)
Received: from [192.168.0.128] ([98.97.39.9])
        by smtp.googlemail.com with ESMTPSA id s11-20020a170902a50b00b001661f9ada6dsm3402479plq.143.2022.06.02.08.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 08:57:43 -0700 (PDT)
Message-ID: <f16ef33a4b12cebae2e2300a509014cd5de4a0d2.camel@gmail.com>
Subject: Re: [PATCH v4] igb: Assign random MAC address instead of fail in
 case of invalid one
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Lixue Liang <lianglixuehao@126.com>, pmenzel@molgen.mpg.de
Cc:     anthony.l.nguyen@intel.com, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, kuba@kernel.org,
        lianglixue@greatwall.com.cn, netdev@vger.kernel.org
Date:   Thu, 02 Jun 2022 08:57:41 -0700
In-Reply-To: <20220601150428.33945-1-lianglixuehao@126.com>
References: <20220601150428.33945-1-lianglixuehao@126.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-06-01 at 15:04 +0000, Lixue Liang wrote:
> From: Lixue Liang <lianglixue@greatwall.com.cn>
> 
> In some cases, when the user uses igb_set_eeprom to modify the MAC
> address to be invalid, the igb driver will fail to load. If there is no
> network card device, the user must modify it to a valid MAC address by
> other means.
> 
> Since the MAC address can be modified, then add a random valid MAC address
> to replace the invalid MAC address in the driver can be workable, it can
> continue to finish the loading, and output the relevant log reminder.
> 
> Signed-off-by: Lixue Liang <lianglixue@greatwall.com.cn>
> ---
> Changelog:
> * v4:
>   - Change the igb_mian in the title to igb
>   - Fix dev_err message: replace "already assigned random MAC address" 
>     with "Invalid MAC address. Assigned random MAC address" 
>   Suggested-by Tony <anthony.l.nguyen@intel.com>
> 
> * v3:
>   - Add space after comma in commit message 
>   - Correct spelling of MAC address
>   Suggested-by Paul <pmenzel@molgen.mpg.de>
> 
> * v2:
>   - Change memcpy to ether_addr_copy
>   - Change dev_info to dev_err
>   - Fix the description of the commit message
>   - Change eth_random_addr to eth_hw_addr_random
>   Reported-by: kernel test robot <lkp@intel.com>
> 
>  drivers/net/ethernet/intel/igb/igb_main.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index 34b33b21e0dc..5e3b162e50ac 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -3359,9 +3359,10 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	eth_hw_addr_set(netdev, hw->mac.addr);
>  
>  	if (!is_valid_ether_addr(netdev->dev_addr)) {
> -		dev_err(&pdev->dev, "Invalid MAC Address\n");
> -		err = -EIO;
> -		goto err_eeprom;
> +		eth_hw_addr_random(netdev);
> +		ether_addr_copy(hw->mac.addr, netdev->dev_addr);
> +		dev_err(&pdev->dev,
> +			"Invalid MAC address. Assigned random MAC address\n");
>  	}
>  
>  	igb_set_default_mac_filter(adapter);

Losing the MAC address is one of the least destructive things you can
do by poking the EEPROM manually. There are settings in there for other
parts of the EEPROM for the NIC that can just as easily prevent the
driver from loading, or worse yet even prevent it from appearing on the
PCIe bus in some cases. So I don't see the user induced EEPROM
corruption as a good justification for this patch as the user shouldn't
be poking the EEPROM if they cannot do so without breaking things.

With that said I would be okay with adding this with the provision that
there is a module parameter to turn on this funcitonality. The
justification would be that the user is expecting to have a corrupted
EEPROM because they are working with some pre-production board or
uninitialized sample. This way if somebody is wanting to update the
EEPROM on a bad board they can use the kernel to do it, but they have
to explicitly enable this mode and not just have the fact that their
EEPROM is corrupted hidden as error messages don't necessarily get
peoples attention unless they are seeing some other issue.

