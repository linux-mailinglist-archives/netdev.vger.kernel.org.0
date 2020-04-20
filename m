Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A205B1B0D9B
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 16:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbgDTOBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 10:01:16 -0400
Received: from mout.web.de ([212.227.17.11]:39629 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726006AbgDTOBO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 10:01:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1587391259;
        bh=lCOOgXGJ32O2IDoCBu8TvnQLoHY8iJa5CYd9za4Bvio=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=LqEssRfo0sRP4eL1j1jjHNc4EVGMhjpZTgUa/n/ZShxqKEAfZGasSRPhPzAK+fora
         gLXGKT+h0EFN6Wks/+ON78WHGdH8f8dgPUTASY14ks6GftEjjihzuVqOu258lbqvz0
         R3plwvINVALPu/MRW/rdrH+A/hn+dvI2Kal79Xpg=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.244.153.203]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MJCWU-1jOs1A40k6-002sgF; Mon, 20
 Apr 2020 16:00:59 +0200
Subject: Re: [net-next v2] can: ti_hecc: convert to
 devm_platform_ioremap_resource_byname()
To:     Dejin Zheng <zhengdejin5@gmail.com>, netdev@vger.kernel.org
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
References: <20200420132207.8536-1-zhengdejin5@gmail.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <940fcaa1-8500-e534-2380-39419f1ac5a0@web.de>
Date:   Mon, 20 Apr 2020 16:00:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200420132207.8536-1-zhengdejin5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Provags-ID: V03:K1:9l2O5DK3JUcDmsaQMm4bDg+TZdm07Sozdqgnln8ISEyCsfnnjl3
 aG4UK1nGs7xevBcFd5Xb3dzRIwXsQ6s8n+lpXc4T2015oRCgWJINmsXhMXRaEQVjChLht4p
 qBITa1OYM7Iloosi8PKBX5P9fGReFcN9bavXsnV4PZpbxBPhIQW8+AyMt+CBMkzrgQEcpkl
 1BxV8MuK/Jk0uUO8Wbk5Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:dCQmUc/jzio=:3peXCgS/XlwM+LT6QZNFS2
 FerFxh1jVj9MEETcSyWtJcBVaA2r7mC4K+QBQM2X0/pLOCA3sX/ktVfv3AKf9ZmB0WlgYP1dH
 kspeaxp3Axla7pywFB4wdEPAdhBpwF+9EdOuHCa2JuFp8OyPB6zNGxIZTSRoLpkCZNWKtzbAy
 G09A1kYxcPj+r+QRLHgXydJ0z0GnWcagpdqmgkZtpeOvXJ6Adr6fmrGy3Z/iFzRp55yJo58t5
 0RXtsNPvKSA06TfHmZM0QtDjRg73ICUDS4xbJck4mYAcbJKSO53YZXKjUv89jhxEd0wyNsfbQ
 vpFySBZ2gL8ce0nuCehUSGEdjbkYFYyTaZmZQJNLh4uo0ASE7/n/+Ft4oOU5qkiLalK3DH4uK
 OBZNinYEPsmCP8VtuDNLyVZwaB2S68MpCcrSGBa7hFvA1+yhWKaIj/Zb2FE+I13yRGELf4du4
 wl8UPxd0MdALkN+Aa32+wkMnvsd8a80kME/K7Gzqa9njmZWqP1mFCm78RCfPkxNiH/MdosbDi
 MTGcjlR40wk6epVK6p5uVCdSnvkdOSYyw8R76jf/g9I07Uj3DxepnK1XaXD1fGX4RXMv+clD+
 Jq3K/xgofHj/ZCPgS2JQY+4KxJFvWAX71TgOgTyaxDfF8hqiIXvUlzpSJuUTWHwclyz40ul0Y
 XGBeAMjkHXB58niHriF0H4AxB9WGs37eLV3wK/TXDAZtSM6mLDOmg2mwbrLUZj24vpYroLrfS
 tFuPiPk+j+cvv0yv+Mfi/AVATSyxNsutuJ5E4PVhN23bXkXZtPzAfZoZQxSaqs/Cs5kPh6uLt
 Fj0wlv1twA/Cxk9X9uTWVhTZZNaNTFSyvsQ3IWgf07zXa7KmRMteoZBXhZ/W2f/ighBaUfhhq
 aAwwand++MldTKea8gd/t/Ufu1n8Z38nl+R2t393mG6fNNtAfb0L0GIYzW1YSItXNnYm1J8C2
 F/6omKUkLtdll4OelPvfVeE+pGVvFEY6oLvoGL4E9wfpfck6JSqI6ERfRN96iUAldGgEKZgBc
 HZipNY0d9oYduwKMjGfZXuF1UQq/7bXkQ+Dk8agFwmNZ9wujtpY3bizJeesuD9ymOKx3lUWF8
 pui4FxLyTWf6U7E0DJKl1xAe6CcVv8ke2YpgLsKt8NDHJTqhaS9grxaAv0yXCdRvcqomZLZi4
 F1ErV2VXnja3Bz590vZuzLi08JU683pUc+9uTOv0VtweJlE0Sbx5IHe4NYY+tYXl1GvYRIkkp
 MgxaW1yJpQwdXwZSO
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> v1 -> v2:
> 	- modify the commit comments by Markus's suggestion.

Thanks for another wording fine-tuning.

Would you like to extend your adjustment interests to similar update candidates?

Example:
bgmac_probe()
https://elixir.bootlin.com/linux/v5.7-rc2/source/drivers/net/ethernet/broadcom/bgmac-platform.c#L201
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/broadcom/bgmac-platform.c?id=ae83d0b416db002fe95601e7f97f64b59514d936#n201

Regards,
Markus
