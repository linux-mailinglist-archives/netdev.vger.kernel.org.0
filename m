Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2563649DC56
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 09:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237686AbiA0INi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 03:13:38 -0500
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:52388
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231533AbiA0INh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 03:13:37 -0500
Received: from [192.168.1.9] (unknown [222.129.35.96])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 0A3D13F165;
        Thu, 27 Jan 2022 08:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1643271215;
        bh=hw3lkqK/LDZ3HCWjOQelAYLaXklxekttKsCZttUwteA=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=GlONunEpY2/s9MVJacq+kLXgcHFQwYHDi/b+yMSnr0XU3dGFOic1B4jc6iGRPrpJh
         o36B8UpyomY2ZzMgAPc6H76RsvczBbAckEF4MilgywAL6aSZK8tLGGQEryiNt5FkJ9
         S9oIFDLuOYQbt1xMh5Gm9/69RyLMBWOLsxwyftgqATgR29cQGyfuV6m4uMGxZ+4viO
         Tvhv+fI+ZYCHsNG8YmgkFdhUR9grHJ3JJNChzcGsvb5GpYJcA0Ym0gDZ8HOq4QrsY6
         1NK9/1eLMpMfc25C3XNq3CB/MY3YHdgSqT/5qh8qTXnZQdXkIRkQc7bVrUtCpbijzG
         92IAghEebDMqw==
Message-ID: <e52f8155-61a8-0cea-b96c-a05b83cdfff9@canonical.com>
Date:   Thu, 27 Jan 2022 16:13:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough
 address
Content-Language: en-US
To:     Hayes Wang <hayeswang@realtek.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        Henning Schild <henning.schild@siemens.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Andrew Lunn <andrew@lunn.ch>, Oliver Neukum <oneukum@suse.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tiwai@suse.de" <tiwai@suse.de>
References: <20220105151427.8373-1-aaron.ma@canonical.com>
 <CAAd53p7egh8G=fPMcua_FTHrA3HA6Dp85FqVhvcSbuO2y8Xz9A@mail.gmail.com>
 <20220110085110.3902b6d4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAAd53p5mSq_bZdsZ=-RweiVLgAYU5+=Uje7TmYtAbBzZ7XCPUA@mail.gmail.com>
 <ec2aaeb0-995e-0259-7eca-892d0c878e19@amd.com>
 <20220111082653.02050070@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <3f258c23-c844-7b48-fffb-2fbf5d6d7475@amd.com>
 <20220111084348.7e897af9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <2b779fef-459f-79bb-4005-db4fd3fd057f@amd.com>
 <20220111090648.511e95e8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <5411b3a0-7e36-fa75-5c5c-eb2fda9273b1@amd.com>
 <20220112202125.105d4c58@md1za8fc.ad001.siemens.net>
 <DM4PR12MB516889A458A16D89D4562CA7E2529@DM4PR12MB5168.namprd12.prod.outlook.com>
 <de684c19-7a84-ac7c-0019-31c253d89a5f@canonical.com>
 <edff6219-b1f7-dec5-22ea-0bde9a3e0efb@canonical.com>
 <5b94f064bd5c48589ea856f68ac0e930@realtek.com>
From:   Aaron Ma <aaron.ma@canonical.com>
In-Reply-To: <5b94f064bd5c48589ea856f68ac0e930@realtek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/22 16:06, Hayes Wang wrote:
> I don't think the feature of MAC passthrough address is maintained
> by Realtek. Especially, there is no uniform way about it. The
> different companies have to maintain their own ways by themselves.
> 
> Realtek could provide the method of finding out the specific device
> for Lenovo. You could check USB OCP 0xD81F bit 3. For example,
> 
> 	ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_MISC_1);
> 	if (tp->version == RTL_VER_09 && (ocp_data & BIT(3))) {
> 		/* This is the RTL8153B for Lenovo. */
> 	}
> 

May I use the code from Realtek Outbox driver to implement the MAPT?

If so, allow me to write a patch and send here to review.

Thanks,
Aaron


> Best Regards,
> Hayes
