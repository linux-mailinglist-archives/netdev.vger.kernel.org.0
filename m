Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1397C40ED31
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 00:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240825AbhIPWPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 18:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240764AbhIPWPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 18:15:24 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5ECFC061574
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 15:14:03 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id bb10so4849898plb.2
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 15:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nsKSUyu0hHQgB5UB2QohPE/woU2L0fc2RfDJ5uYvuQE=;
        b=KTXECkHFaeqyUQrHRDqiE3dMQGDUNHyr56vKMCmZ0LyR+rzK2yMQx4oVNMWwuiM+gx
         wQ0sHSYY9dsluytDuOtJSEqsnZN50+R0Ee8exRa6QVc3SXpMTSNUI/0fZFLu7ObQhRyn
         gfWgfuH48PGhaoa0GR+TqUT6TfnRp+gPZ2ymisJhO2RhS67TktRs2z4B8snR4zFcv2OS
         vaH0877El3zqg88BdmHSaPlb9Pt8wUdTqYLcUIKs27XzZaTeK3JB2MA4K7pSX3usVmar
         OjLcxYTo9NWq6G0Td3C8nboMlBPw9TgCx/3GV7HD627zzLpkp68Ny4m9QBKofO1UPeki
         RXcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nsKSUyu0hHQgB5UB2QohPE/woU2L0fc2RfDJ5uYvuQE=;
        b=33EfFiG1aXVo2MuSTLtaowmrGODvNfVrRNpAIEqgyWG6e9A93TJMU/1NKsjsUEu7U/
         bmzbU5jt/Jhuz17/lvIP5Z9QXIh8ZAndoYtBi/RptLIkSs6OpaUiCrq++jjoFSwcnAvv
         w4ohjPdCzHjS2slL/0oE2oJh3Oxx7KK55bvjOUQSqKVDqTr3hG0/wSxvsjw676n0bFEP
         fS0cp6vsDAnVe1R57pFwD9ojSMHm6Y2khHI6HW9A3FhOBnF58RTXxtpzurdl/XwQOE/3
         qyk9s2FpL4DiqkH8LJeUendFQR4I/gkIPcPfsCHEPdfSfIXL4Kkn789LmJ4Ne6w0D/FL
         lPKw==
X-Gm-Message-State: AOAM53294D3JO48Ip89BwHf/nR0EZa9IJjCNQwGsVG4d0Kzdbah62lPa
        RlICIOSc3VM/YlJuwLZdyPdcMjauLDGhSQ==
X-Google-Smtp-Source: ABdhPJwhvTScpwUwUJC1hp9mKT7JGZA9I1zK8Rn3ZqsXAxD8elSEci1yrjr8BEf/J1Tw5DhrdY6aDQ==
X-Received: by 2002:a17:902:dac7:b0:138:cee7:6bbc with SMTP id q7-20020a170902dac700b00138cee76bbcmr6663254plx.0.1631830443045;
        Thu, 16 Sep 2021 15:14:03 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id 4sm3573500pjb.21.2021.09.16.15.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 15:14:02 -0700 (PDT)
Date:   Thu, 16 Sep 2021 15:13:59 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Mirko Lindner <mlindner@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] sky2: Stop printing VPD info to debugfs
Message-ID: <20210916151359.7bf742df@hermes.local>
In-Reply-To: <bbaee8ab-9b2e-de04-ee7b-571e094cc5fe@gmail.com>
References: <bbaee8ab-9b2e-de04-ee7b-571e094cc5fe@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Sep 2021 23:40:37 +0200
Heiner Kallweit <hkallweit1@gmail.com> wrote:

> Sky2 is parsing the VPD and adds the parsed information to its debugfs
> file. This isn't needed in kernel, userspace tools like lspci can be
> used to display such information nicely. Therefore remove this from
> the driver.
> 
> lspci -vv:
> 
> Capabilities: [50] Vital Product Data
> 	Product Name: Marvell Yukon 88E8070 Gigabit Ethernet Controller
> 	Read-only fields:
> 		[PN] Part number: Yukon 88E8070
> 		[EC] Engineering changes: Rev. 1.0
> 		[MN] Manufacture ID: Marvell
> 		[SN] Serial number: AbCdEfG970FD4
> 		[CP] Extended capability: 01 10 cc 03
> 		[RV] Reserved: checksum good, 9 byte(s) reserved
> 	Read/write fields:
> 		[RW] Read-write area: 1 byte(s) free
> 	End
> 
> Relevant part in debugfs file:
> 
> 0000:01:00.0 Product Data
> Marvell Yukon 88E8070 Gigabit Ethernet Controller
>  Part Number: Yukon 88E8070
>  Engineering Level: Rev. 1.0
>  Manufacturer: Marvell
>  Serial Number: AbCdEfG970FD4
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Make sense lspci seems to have gotten better at handling this now.

Acked-by: Stephen Hemminger <stephen@networkplumber.org>
