Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5595C2FF11F
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 17:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388216AbhAUQzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 11:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388308AbhAUQyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 11:54:35 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FB9C0613ED;
        Thu, 21 Jan 2021 08:53:54 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id g1so3314057edu.4;
        Thu, 21 Jan 2021 08:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bcwkAyno8WqzFymWEGyp24H8TAkA0jp++RY9Bw53OdE=;
        b=Xq/ocX+0m3kZT4umHvJyrvYKZdCpob7dfMGT9Ioy/Qd540/PZN02zLDk8x7bEz/+Xr
         Luxh7Ab8M2/YPybpj5dnbMm+u7CcaKpPOtK9QX4kATjYpceQsnH+YI0YMHXVlQ6Reiog
         4z83LppwNlC33VY1rSnRR4i8X7qoXwmKjrOf8ojxHle+TKCRBXTdDwkGX+zS4bXVJgwJ
         PBcl5QpfhEklt38zzFDTqgDwAbqcnKMqQqEb81TVXp2+Tk3f4wCTN8VHvheSAeQj/INn
         FeBYkaGRe2NYf71vdXayN66pAzLfOk8rokwztRF5VvFfTfPzURXSBmibSV3MIP+gVLl0
         5GpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bcwkAyno8WqzFymWEGyp24H8TAkA0jp++RY9Bw53OdE=;
        b=ox1phwOItGRy9q7JBizckUje9t1uxZcTUcN/YaQvWgablCw4s8TDgOUrbQHZNwFQYW
         cpS26Zze2OF8/J8ypdp+OPaVBLUHVviT30J/6N9fqaE6YBC9b7JxsJmucv5Z2Oo6F2WB
         zz6LfR8Hx9AT0WnzEFiEPuOneEtl2OkE0fPX81Jq4+RLmu5ag1Ipy/OSP7RSXOnv993d
         n/XXIZ67xIiT2WHWuEh5B+gHIBMSrl1mRWidtDCGM1ULzoYZ+w9UoQ5dXxgRKQMQ4e4M
         9DrtPddzPdW5EbAhc7z8OBxF1CR6yQ5nuKKXHKNtHIPDHsHSdyiZE+0/mFXidrMLYpBz
         uTNQ==
X-Gm-Message-State: AOAM531L6ZVZGVgaRoczJc4UVmvIt+Ef5tEbNk1zkh5t39HPNqsHZoIN
        h1rwFJ/9b0OyOQjau/A2rgg=
X-Google-Smtp-Source: ABdhPJytdr1Bo1bVvMiN4it9HUs9v5agv16uFdFJeqL4tqJ52C2GcLxL/fvt7r2G1VTNdztsGQoKfg==
X-Received: by 2002:a05:6402:1914:: with SMTP id e20mr24823edz.89.1611248033317;
        Thu, 21 Jan 2021 08:53:53 -0800 (PST)
Received: from anparri (host-87-19-67-41.retail.telecomitalia.it. [87.19.67.41])
        by smtp.gmail.com with ESMTPSA id r26sm3252191edc.95.2021.01.21.08.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 08:53:52 -0800 (PST)
Date:   Thu, 21 Jan 2021 17:53:45 +0100
From:   Andrea Parri <parri.andrea@gmail.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 4/4] hv_netvsc: Restrict configurations on isolated guests
Message-ID: <20210121165345.GA2101@anparri>
References: <20210119175841.22248-1-parri.andrea@gmail.com>
 <20210119175841.22248-5-parri.andrea@gmail.com>
 <BL0PR2101MB0930CF4297121B1BB904AA7DCAA29@BL0PR2101MB0930.namprd21.prod.outlook.com>
 <20210121040526.GA264889@anparri>
 <BL0PR2101MB0930698DBF66828F4EE4CDA8CAA19@BL0PR2101MB0930.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL0PR2101MB0930698DBF66828F4EE4CDA8CAA19@BL0PR2101MB0930.namprd21.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > @@ -544,7 +545,8 @@ static int negotiate_nvsp_ver(struct hv_device
> > > > *device,
> > > >  	init_packet->msg.v2_msg.send_ndis_config.capability.ieee8021q = 1;
> > > >
> > > >  	if (nvsp_ver >= NVSP_PROTOCOL_VERSION_5) {
> > > > -		init_packet->msg.v2_msg.send_ndis_config.capability.sriov =
> > > > 1;
> > > > +		if (!hv_is_isolation_supported())
> > > > +			init_packet-
> > > > >msg.v2_msg.send_ndis_config.capability.sriov = 1;
> > >
> > > Please also add a log there stating we don't support sriov in this case.
> > Otherwise,
> > > customers will ask why vf not showing up.
> > 
> > IIUC, you're suggesting that I append something like:
> > 
> > +		else
> > +			netdev_info(ndev, "SR-IOV not advertised: isolation
> > supported\n");
> > 
> > I've added this locally; please let me know if you had something else
> > /better in mind.
> 
> This message explains the failure reason better:
>   "SR-IOV not advertised by guests on the host supporting isolation"

Applied.


> > > > @@ -579,12 +588,17 @@ static int netvsc_connect_vsp(struct hv_device
> > > > *device,
> > > >  	init_packet = &net_device->channel_init_pkt;
> > > >
> > > >  	/* Negotiate the latest NVSP protocol supported */
> > > > -	for (i = ARRAY_SIZE(ver_list) - 1; i >= 0; i--)
> > > > +	for (i = ARRAY_SIZE(ver_list) - 1; i >= 0; i--) {
> > > > +		if (!nvsp_is_valid_version(ver_list[i])) {
> > > > +			ret = -EPROTO;
> > > > +			goto cleanup;
> > > > +		}
> > >
> > > This code can catch the invalid, but cannot get the current host nvsp
> > version.
> > > I'd suggest move this check after version negotiation is done. So we can log
> > what's
> > > the current host nvsp version, and why we fail it (the expected nvsp ver).
> > 
> > Mmh, invalid versions are not negotiated.  How about I simply add the
> > following logging right before the above 'ret = -EPROTO' say?
> > 
> > +			netdev_err(ndev, "Invalid NVSP version %x
> > (expected >= %x): isolation supported\n",
> > +				   ver_list[i], NVSP_PROTOCOL_VERSION_61);
> > 
> > (or something along these lines)
> 
> The negotiation process runs from the latest to oldest. If the host is 5, your code 
> will fail before trying v6.0, and log:
> 	"Invalid NVSP version 60000  (expected >= 60001): isolation supported"
> This will make user think the NVSP version is 6.0.
> 
> Since you will let the NIC fail and cleanup, there is no harm to check the version 
> after negotiation. And this case is unexpected from a "normal" host. So I suggest 
> move the check after negotiation is done, then we know the actual host nvsp 
> version that causing this issue. And we can bring the accurate info to host team 
> for better diagnosability.

Fair enough, will do.


> Please point out this invalid version is caused by the host side, like this:
> 	"Invalid NVSP version 0x50000  (expected >= 0x60001) from the host with isolation support"
> Also please use "0x%x" for hexadecimal numbers.

Sure.


> > > > @@ -1357,7 +1371,8 @@ static void netvsc_receive_inband(struct
> > > > net_device *ndev,
> > > >  		break;
> > > >
> > > >  	case NVSP_MSG4_TYPE_SEND_VF_ASSOCIATION:
> > > > -		netvsc_send_vf(ndev, nvmsg, msglen);
> > > > +		if (!hv_is_isolation_supported())
> > > > +			netvsc_send_vf(ndev, nvmsg, msglen);
> > >
> > > When the driver doesn't advertise SRIOV, this message is not expected.
> > > Instead of ignore silently, we should log an error.
> > 
> > I've appended:
> > 
> > +		else
> > +			netdev_err(ndev, "Unexpected VF message:
> > isolation supported\n");
> 
> Please log the msg type:
>   "Ignore VF_ASSOCIATION msg from the host supporting isolation"

Applied.

Thanks,
  Andrea
