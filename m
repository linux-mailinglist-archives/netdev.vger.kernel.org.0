Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEF35100C3C
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 20:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfKRTdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 14:33:25 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45603 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbfKRTdZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 14:33:25 -0500
Received: by mail-wr1-f68.google.com with SMTP id z10so20907862wrs.12
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 11:33:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rNwcpaiaZQrX345KzttaY7j6spDQbPibj2LcMlNLNxw=;
        b=PU4iVDDrppxuDv+7qgCdKXR7pqjDBwl0bem3UGt6XMLvOjvesqTY7WZcGgqXOCD5rP
         eHD3n3hAG9gtTxLzs4Qfh5pO9auL7WbYZDWSpgkglL+7dawY1SaBe0lBs0DrXyi1QpxT
         GJep5/voCDPxiMMt7nfz0DTIg2RvdJX9njBDPSL8yf/r/NFikg5jFPXodRZAGs0XowCj
         MTkXXdzhzNcUaW+gDJTa6KiBlVfws1+8OGpVqhOM4AdfiVFB3LeJ0L/A38quEhc1+aAH
         A3v7MYFiZSeaU0j/m96sqwn0L06ZKmcLbGtZqsiFse+0Hd18yZoxlUR97P/ah8jokD08
         8dEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rNwcpaiaZQrX345KzttaY7j6spDQbPibj2LcMlNLNxw=;
        b=sAXj+duIFSI2LqNggksLgm4esIZf+eZvDjlBo733amrclR2TsvWPyujD9EypqPXUjv
         yExEEG9LiVSxpInQ5g9WnfYbNSMTla3z2PI8ZaBXWaVcwnJGjEt+rJtKO2PCt9r9D1Ob
         J6pWfWcNOlvXg/ILW+fnEAwLm0CxgooK5MkT6Imkso+iCprwJUXCnK8cP2eOM1fJVxG0
         07hV+GE5FVrrZDXz58BfhE1wmgYkeaMxU4YTmPIxtghkF6q3gdHNZbWCIJFFcIcbJfV8
         o1YBAUPYfGbFGTfYU/hOoqBluY3S+vTtiKeKsLayIi3/3Du8pH9YbhDymQDOPHDjpfvH
         YrSA==
X-Gm-Message-State: APjAAAVskx2W2ZBHBhMBimPDkPn6VW0+/Qesu04Gtc+5urfGAcVEVwwr
        8WVJGHNSCb3mEAg0fhLlok6e9aQW
X-Google-Smtp-Source: APXvYqwEfwsIq3f+CGwo/B+9mEqqYJ3Y+/J46LBJ53m5L0BjEUr78wp7EGxhbgrvUFlyVuvaxCSvUw==
X-Received: by 2002:adf:b1cb:: with SMTP id r11mr23719134wra.246.1574105603508;
        Mon, 18 Nov 2019 11:33:23 -0800 (PST)
Received: from ?IPv6:2003:ea:8f2d:7d00:e016:8d04:5d1f:5991? (p200300EA8F2D7D00E0168D045D1F5991.dip0.t-ipconnect.de. [2003:ea:8f2d:7d00:e016:8d04:5d1f:5991])
        by smtp.googlemail.com with ESMTPSA id f188sm438296wmf.3.2019.11.18.11.33.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 11:33:22 -0800 (PST)
Subject: Re: [PATCH net-next] r8169: disable TSO on a single version of
 RTL8168c to fix performance
To:     Corinna Vinschen <vinschen@redhat.com>, netdev@vger.kernel.org
Cc:     nic_swsd@realtek.com, David Miller <davem@davemloft.net>
References: <20191118095503.25611-1-vinschen@redhat.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <44352432-e6ad-3e3c-4fea-9ad59f7c4ae9@gmail.com>
Date:   Mon, 18 Nov 2019 20:33:16 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191118095503.25611-1-vinschen@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.11.2019 10:55, Corinna Vinschen wrote:
> During performance testing, I found that one of my r8169 NICs suffered
> a major performance loss, a 8168c model.
> 
> Running netperf's TCP_STREAM test didn't return the expected
> throughput of > 900 Mb/s, but rather only about 22 Mb/s.  Strange
> enough, running the TCP_MAERTS and UDP_STREAM tests all returned with
> throughput > 900 Mb/s, as did TCP_STREAM with the other r8169 NICs I can
> test (either one of 8169s, 8168e, 8168f).
> 
> Bisecting turned up commit 93681cd7d94f83903cb3f0f95433d10c28a7e9a5,
> "r8169: enable HW csum and TSO" as the culprit.
> 
> I added my 8168c version, RTL_GIGA_MAC_VER_22, to the code
> special-casing the 8168evl as per the patch below.  This fixed the
> performance problem for me.
> 
> Fixes: 93681cd7d94f ("r8169: enable HW csum and TSO")
> Signed-off-by: Corinna Vinschen <vinschen@redhat.com>

Thanks for reporting and the fix. Just two small nits:
- fix should be annotated "net", not "net-next"
- comment blocks in net subsystem don't have /* on a separate line

Apart from that:
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>

Out of curiosity: Did you test also with iperf3? If yes,
do you see the same issue?

> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index d8fcdb9db8d1..1de11ac05bd6 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -6952,8 +6952,12 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  		dev->gso_max_segs = RTL_GSO_MAX_SEGS_V1;
>  	}
>  
> -	/* RTL8168e-vl has a HW issue with TSO */
> -	if (tp->mac_version == RTL_GIGA_MAC_VER_34) {
> +	/*

not net style comment

> +	 * RTL8168e-vl and one RTL8168c variant are known to have a
> +	 * HW issue with TSO.
> +	 */
> +	if (tp->mac_version == RTL_GIGA_MAC_VER_34 ||
> +	    tp->mac_version == RTL_GIGA_MAC_VER_22) {
>  		dev->vlan_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
>  		dev->hw_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
>  		dev->features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
> 

