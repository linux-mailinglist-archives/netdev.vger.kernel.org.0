Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACD98162F1C
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 19:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgBRSya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 13:54:30 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53793 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgBRSy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 13:54:29 -0500
Received: by mail-wm1-f67.google.com with SMTP id s10so3868838wmh.3;
        Tue, 18 Feb 2020 10:54:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1dJr5fWtmgL5ZWKfudWGcy2nFnCOukxqjG9HGhea3rc=;
        b=i26UeAYelCy7U1A8/lwfSWuKD6ty6MuaX0kbrq6tzijhBOyrJHSPcHPMflkjW4ctmg
         dXOzg8z8CpuvzrqZRiqoJTViSk1VgSAzkRoasR83KQaslqB1kzObh37AkUQ3kcBFBri9
         3SlMcjIG3y5o3BAvpVKCk6yOGFTS9VpnYv5qu5WMS/Z95Mm18CQljUcsP2/2KL88z3Rp
         BauSmQyR5TGyrYyKDGfVzSAbcvcebAw4Hk8XsbOvk5/ngH+Oa/yLlW3wfCVDMSFPac7f
         LnLryS8huIxPvunu7OoWrweZdRD86earFdvzrES3bJKxlMfySGH6LfBmlwBiSbRJUaFo
         ZGaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1dJr5fWtmgL5ZWKfudWGcy2nFnCOukxqjG9HGhea3rc=;
        b=PsArpl4FYXeU1u0fADXgTH/DqwqljOXkWd6IdgmyL4jVyTN5gsYBhMmUPee2MYOOYA
         TYGz6IBNkgmbRUIWPsoId+LThVZecHiTBXbDI9RWEzR+iJ+ei1Gx/TVp7tvvw1fWos8K
         ttrw+STElWP5WtSWMF2mZ6uMAzM1ftaRtF9OdnS1opnuajD92tJmKJa4O0suCCpgbIaY
         HgtlU1a7W1hJG2RpG79LpyPMcUuP/Py5VFolGrMnMlTTVkmLuOps+nje97+RcoO1CCu+
         Q0nlZmhTMr9bYSueZdKu0e/pMHzXlYZvvTocNOjkRLfCxTQ0C0yRtfxh08Tv/oe7TBKV
         oAbg==
X-Gm-Message-State: APjAAAVLIV9GBSBu3LDW1VI2dMuG+lMZtwdCvwQpo5KPHTX/C9L/M8AU
        av/gxLlpeb6bjYHR00BIW0Fqa+n3vYM=
X-Google-Smtp-Source: APXvYqxYgBXJufEEemNhgT0u53WakZwZ21MeNb7+y3FjScnyw0psrHFJLQKWd4DJGrX4UhzYbMWY6A==
X-Received: by 2002:a05:600c:230d:: with SMTP id 13mr4828770wmo.12.1582052067709;
        Tue, 18 Feb 2020 10:54:27 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:5cb0:582f:968:ec00? (p200300EA8F2960005CB0582F0968EC00.dip0.t-ipconnect.de. [2003:ea:8f29:6000:5cb0:582f:968:ec00])
        by smtp.googlemail.com with ESMTPSA id u14sm6925152wrm.51.2020.02.18.10.54.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 10:54:27 -0800 (PST)
Subject: Re: [PATCH net-next 3/3] net: use new helper tcp_v6_gso_csum_prep
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Parvi Kaustubhi <pkaustub@cisco.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Guo-Fu Tseng <cooldavid@cooldavid.org>,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        Timur Tabi <timur@kernel.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Ronak Doshi <doshir@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        linux-hyperv@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
References: <76cd6cfc-f4f3-ece7-203a-0266b7f02a12@gmail.com>
 <9270ae4b-feb1-6a4d-8a22-fbe5e47b7617@gmail.com>
 <CAKgT0UdP78GGnowWC85YiTAHOr63NiLa25=2TSckKBEzGBdeJA@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <e6b59cad-b6a6-73fc-7d75-3cc9ce6411ab@gmail.com>
Date:   Tue, 18 Feb 2020 19:54:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0UdP78GGnowWC85YiTAHOr63NiLa25=2TSckKBEzGBdeJA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.02.2020 19:34, Alexander Duyck wrote:
> On Mon, Feb 17, 2020 at 1:43 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> Use new helper tcp_v6_gso_csum_prep in additional network drivers.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/ethernet/atheros/alx/main.c       |  5 +---
>>  .../net/ethernet/atheros/atl1c/atl1c_main.c   |  6 ++---
>>  drivers/net/ethernet/brocade/bna/bnad.c       |  7 +----
>>  drivers/net/ethernet/cisco/enic/enic_main.c   |  3 +--
>>  drivers/net/ethernet/intel/e1000/e1000_main.c |  6 +----
>>  drivers/net/ethernet/intel/e1000e/netdev.c    |  5 +---
>>  drivers/net/ethernet/jme.c                    |  7 +----
>>  .../net/ethernet/pensando/ionic/ionic_txrx.c  |  5 +---
>>  drivers/net/ethernet/qualcomm/emac/emac-mac.c |  7 ++---
>>  drivers/net/ethernet/socionext/netsec.c       |  6 +----
>>  drivers/net/hyperv/netvsc_drv.c               |  5 +---
>>  drivers/net/usb/r8152.c                       | 26 ++-----------------
>>  drivers/net/vmxnet3/vmxnet3_drv.c             |  5 +---
>>  13 files changed, 16 insertions(+), 77 deletions(-)
>>
> 
> It might make sense to break this up into several smaller patches
> based on the maintainers for the various driver bits.
> 
OK

> So the changes all look fine to me, but I am not that familiar with
> the non-Intel drivers.
> 
> Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 

