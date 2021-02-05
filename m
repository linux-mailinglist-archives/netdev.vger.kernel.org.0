Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07C9311851
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbhBFCei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbhBFCcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:32:22 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2208BC08ECAA;
        Fri,  5 Feb 2021 14:31:34 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id y187so7118099wmd.3;
        Fri, 05 Feb 2021 14:31:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OGkdoF9M+3UHWUpJpcL+F1t+md4Wtn4nbfKuUxKA+lw=;
        b=OJXGhu/oA37QRNKNPvFHp9JUOLW7WmM7tR/uGem0it+xgf84yzzyRqdAl6IeGLIVOX
         0npkDlFfk3DExhzVa1wjH12H6FF6kw76mtNs3aFJ1srnOtJTUecBSo/gJXYt+eM8fUic
         DblPuV7d8Vwc0J1fbNOjVn/rd0Ykl0nF7Ji3xBBGxLqUU3xjsIV69b5QPFcLW1pIXEpT
         lSCBG2eT3Myt1czM338XYrM2GxjaR8u7ZIdReXVxByDwdB1wZxOzJYGDqvZV3KtWwo/J
         hRfoOKoHJx8/Tv5xzSYWjaEeiBLDowf7+tnZ9wtQZDXwQ+ofl9WgDu3LgGTsUqteF8du
         1gyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OGkdoF9M+3UHWUpJpcL+F1t+md4Wtn4nbfKuUxKA+lw=;
        b=FUFTPTVWCp4LEZA9cUvQhmYW5+D4omKzLKBmLe3z/aiuiOpgMJV3rZtQ4UThRHVpn9
         RQ8oY5eCCh7WZtyiojG2SFWxQvkIGW7ETVqJr4XK37d7XsU++CBXtKsG6HgK4tfswcfs
         mbj4JMEVl50oQ37EB/0s9MKbySxYHQvH968Q8Ppaq0jcG+FSaF3fOTUBZe/8eN/HH1zW
         OnkWWz0HX92V0qy3r+zV6WM0NQQnF96Zd/n4yolhzlhESH2Di0qfH+p86lKwmzC2Dj81
         ffRL8DA282e+Fxhmq61wSIrJ87qMZ1jztD3Noh5vlw1RbtrZKYehlf3r+e5VleoefTAG
         df/A==
X-Gm-Message-State: AOAM530m2QJPgowJCj1J8xSFGSeEKH4S9UfuiOBvBGP4Fc7BCSapoLxW
        JDxwPuhBDt7+v1zBLKXS+/V/FzEjy5cwsA==
X-Google-Smtp-Source: ABdhPJzArfqsgcTZr4tf8P+QkK/7PQxFGptMBSKBaLkutC8oJ0Urk+cXLensYO1LhlWb3BKOt2GFww==
X-Received: by 2002:a1c:5a54:: with SMTP id o81mr5328234wmb.50.1612564292839;
        Fri, 05 Feb 2021 14:31:32 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:11de:46a1:319f:d28? (p200300ea8f1fad0011de46a1319f0d28.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:11de:46a1:319f:d28])
        by smtp.googlemail.com with ESMTPSA id b18sm13962344wrm.57.2021.02.05.14.31.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 14:31:32 -0800 (PST)
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Raju Rangoju <rajur@chelsio.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Casey Leedom <leedom@chelsio.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
References: <20210205214621.GA198699@bjorn-Precision-5520>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH resend net-next v2 2/3] PCI/VPD: Change Chelsio T4 quirk
 to provide access to full virtual address space
Message-ID: <6d05f72b-9a61-6da8-e70e-d4b3cdf3ca28@gmail.com>
Date:   Fri, 5 Feb 2021 23:31:24 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210205214621.GA198699@bjorn-Precision-5520>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.02.2021 22:46, Bjorn Helgaas wrote:
> [+cc Casey, Rahul]
> 
> On Fri, Feb 05, 2021 at 08:29:45PM +0100, Heiner Kallweit wrote:
>> cxgb4 uses the full VPD address space for accessing its EEPROM (with some
>> mapping, see t4_eeprom_ptov()). In cudbg_collect_vpd_data() it sets the
>> VPD len to 32K (PCI_VPD_MAX_SIZE), and then back to 2K (CUDBG_VPD_PF_SIZE).
>> Having official (structured) and inofficial (unstructured) VPD data
>> violates the PCI spec, let's set VPD len according to all data that can be
>> accessed via PCI VPD access, no matter of its structure.
> 
> s/inofficial/unofficial/
> 
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/pci/vpd.c | 7 +++----
>>  1 file changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/pci/vpd.c b/drivers/pci/vpd.c
>> index 7915d10f9..06a7954d0 100644
>> --- a/drivers/pci/vpd.c
>> +++ b/drivers/pci/vpd.c
>> @@ -633,9 +633,8 @@ static void quirk_chelsio_extend_vpd(struct pci_dev *dev)
>>  	/*
>>  	 * If this is a T3-based adapter, there's a 1KB VPD area at offset
>>  	 * 0xc00 which contains the preferred VPD values.  If this is a T4 or
>> -	 * later based adapter, the special VPD is at offset 0x400 for the
>> -	 * Physical Functions (the SR-IOV Virtual Functions have no VPD
>> -	 * Capabilities).  The PCI VPD Access core routines will normally
>> +	 * later based adapter, provide access to the full virtual EEPROM
>> +	 * address space. The PCI VPD Access core routines will normally
>>  	 * compute the size of the VPD by parsing the VPD Data Structure at
>>  	 * offset 0x000.  This will result in silent failures when attempting
>>  	 * to accesses these other VPD areas which are beyond those computed
>> @@ -644,7 +643,7 @@ static void quirk_chelsio_extend_vpd(struct pci_dev *dev)
>>  	if (chip == 0x0 && prod >= 0x20)
>>  		pci_set_vpd_size(dev, 8192);
>>  	else if (chip >= 0x4 && func < 0x8)
>> -		pci_set_vpd_size(dev, 2048);
>> +		pci_set_vpd_size(dev, PCI_VPD_MAX_SIZE);
> 
> This code was added by 7dcf688d4c78 ("PCI/cxgb4: Extend T3 PCI quirk
> to T4+ devices") [1].  Unfortunately that commit doesn't really have
> the details about what it fixes, other than the silent failures it
> mentions in the comment.
> 
> Some devices hang if we try to read at the wrong VPD address, and this
> can be done via the sysfs "vpd" file.  Can you expand the commit log
> with an argument for why it is always safe to set the size to
> PCI_VPD_MAX_SIZE for these devices?
> 

Seeing t4_eeprom_ptov() there is data at the end of the VPD address
space, but there may be gaps in between. I don't have test hw,
therefore it would be good if Chelsio could confirm that accessing
any address in the VPD address space (32K) is ok. If a VPD address
isn't backed by EEPROM, it should return 0x00 or 0xff, and not hang
the device.

> The fact that cudbg_collect_vpd_data() fiddles around with
> pci_set_vpd_size() suggests to me that there is *some* problem with
> reading parts of the VPD.  Otherwise, why would they bother?
> 
> 940c9c458866 ("cxgb4: collect vpd info directly from hardware") [2]
> added the pci_set_vpd_size() usage, but doesn't say why it's needed.
> Maybe Rahul will remember?
> 

In addition we have cb92148b58a4 ("PCI: Add pci_set_vpd_size() to set
VPD size"). To me it seems the VPD size quirks and this commit
try to achieve the same: allow to override the autodetected VPD len

The quirk mechanism is well established, and if possible I'd like
to get rid of pci_set_vpd_size(). I don't like the idea that the
PCI core exposes API calls for accessing a proprietary VPD data
format of one specific vendor (cxgb4 is the only user of
pci_set_vpd_size()).

> Bjorn
> 
> [1] https://git.kernel.org/linus/7dcf688d4c78
> [2] https://git.kernel.org/linus/940c9c458866
> 
>>  }
>>  
>>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_CHELSIO, PCI_ANY_ID,
>> -- 
>> 2.30.0
>>
>>
>>

