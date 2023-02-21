Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF4469DE79
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 12:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233987AbjBULJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 06:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233756AbjBULJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 06:09:08 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16E0199D6;
        Tue, 21 Feb 2023 03:09:06 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id z8so3703695wrm.8;
        Tue, 21 Feb 2023 03:09:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Sr29IUNFl1Es+DFTQ9Wkt/+4+xunAUuHcNBn1GNqO6A=;
        b=l6ORORe20pHz+02XF12kKK9k4EpbQQaNhULNcOmAmdIp/TO7CABihjStWp+3n+kPgb
         UKJThanWl4QDv+IMJP7iNQE9ulA3McUwXKTW2JYrBS9pRh+T/nv49JFyv+7Icud4jxnu
         uslBdcRs2DUXBWXdi/cBmYX0gaaI4BlTYa57hVlTTQD5POEIosqvuIhNthfzFldOh0KS
         LAxAUUbrWVFv323FbFec6tUbYHGelXxXwCUTrF2w2QtSGIcsCwo4vvegbzznIbbgaoES
         U1NlNNvCv5NUtiBeqXrkmbbg7ChU77Kbzwo9Gc5XRvsZVzEyWAf4sd0qXRCkSiv9Rohk
         nwHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Sr29IUNFl1Es+DFTQ9Wkt/+4+xunAUuHcNBn1GNqO6A=;
        b=Vpj3BdxZUb+db8mkbtyUvP+R/GB+CeLH9gCTPF4l0c4NpG46vXfBT1kAn0Tje03jom
         UTqMvYQJsonq7fQAtzA32/9A5myqT7TEgCBDCrQ3p3wr7rV7geJm68zIMSTyn2q1R5Q7
         1RsRLYCoZROuMwf54BP/9SCpHGqdeg56oIWWEQstLqkCEO9+8egVzQ3c6zBK09NozgeY
         PsBNskOd5iBkFUQhJMY/U7nWDOIORkMFDczGIDfXRFbbjnrxoy3HcpTM10YQDxAkAnMy
         6HZgut8iTyFFBoyOsf8ZpygmxGHFH3W3dSaF/7j93+nWmbf2xLh+f1i2+0S/qvM3qUeO
         0pCQ==
X-Gm-Message-State: AO0yUKXlvQvDao7OZEmjy8fgrlMTchEDrD+/KF9b8+5hgFUwzmu0qiXh
        IaC2ZlWGf0z1g8vSTJB2vl0r+sgHye0=
X-Google-Smtp-Source: AK7set9RDCFkAuaznK49ld3k89+Y+FerV8gzxtAUWBy62EsISPMuh/RHL1RqXxHqQu/Ms2WKTGoPgQ==
X-Received: by 2002:adf:e689:0:b0:2c5:5da4:a3b1 with SMTP id r9-20020adfe689000000b002c55da4a3b1mr4695130wrm.69.1676977745339;
        Tue, 21 Feb 2023 03:09:05 -0800 (PST)
Received: from ?IPV6:2a01:c22:6e4d:5f00:c8b7:365d:f8a9:9c38? (dynamic-2a01-0c22-6e4d-5f00-c8b7-365d-f8a9-9c38.c22.pool.telefonica.de. [2a01:c22:6e4d:5f00:c8b7:365d:f8a9:9c38])
        by smtp.googlemail.com with ESMTPSA id e28-20020a5d595c000000b002c54a2037d1sm5361878wri.75.2023.02.21.03.09.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 03:09:04 -0800 (PST)
Message-ID: <86136114-a451-c485-ade2-cfa79d5124e1@gmail.com>
Date:   Tue, 21 Feb 2023 11:52:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v8 RESEND 1/6] r8169: Disable ASPM L1.1 on 8168h
Content-Language: en-US
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>, nic_swsd@realtek.com,
        bhelgaas@google.com
Cc:     koba.ko@canonical.com, acelan.kao@canonical.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        vidyas@nvidia.com, rafael.j.wysocki@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
References: <20230221023849.1906728-1-kai.heng.feng@canonical.com>
 <20230221023849.1906728-2-kai.heng.feng@canonical.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20230221023849.1906728-2-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21.02.2023 03:38, Kai-Heng Feng wrote:
> ASPM L1/L1.1 gets enabled based on [0], but ASPM L1.1 was actually
> disabled too [1].
> 
> So also disable L1.1 for better compatibility.
> 
> [0] https://bugs.launchpad.net/bugs/1942830
> [1] https://git.launchpad.net/~canonical-kernel/ubuntu/+source/linux-oem/+git/focal/commit/?id=c9b3736de48fd419d6699045d59a0dd1041da014
> 
These references are about problems with L1.2 (which is disabled
per default in mainline). They don't allow any statement about whether
L1.1 is problematic too (and under which circumstances).
At least on my system with RTL8168h there's no problem with L1.1
when running iperf.

> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
> v8:
>  - New patch.
> 
>  drivers/net/ethernet/realtek/r8169_main.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 45147a1016bec..1c949822661ae 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -5224,13 +5224,13 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  
>  	/* Disable ASPM L1 as that cause random device stop working
>  	 * problems as well as full system hangs for some PCIe devices users.
> -	 * Chips from RTL8168h partially have issues with L1.2, but seem
> -	 * to work fine with L1 and L1.1.
> +	 * Chips from RTL8168h partially have issues with L1.1 and L1.2, but
> +	 * seem to work fine with L1.
>  	 */
>  	if (rtl_aspm_is_safe(tp))
>  		rc = 0;
>  	else if (tp->mac_version >= RTL_GIGA_MAC_VER_46)
> -		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1_2);
> +		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1_1 | PCIE_LINK_STATE_L1_2);
>  	else
>  		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
>  	tp->aspm_manageable = !rc;

