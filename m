Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCCA2FE06F
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 05:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbhAUEIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 23:08:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727397AbhAUEGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 23:06:17 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57BAC061575;
        Wed, 20 Jan 2021 20:05:36 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id w1so671524ejf.11;
        Wed, 20 Jan 2021 20:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zs6nSLWspOzJqzLNgoacVdZyTUWqV9xzCEETdLcLPsQ=;
        b=LmQybOaHo8pPZgfP/7PYgTHhoAYSkU92YKB1eDd56IHDO/q7pvfeaF/YdpTau8Tzot
         K+K+CGNX+V/EEe2EK7C3bCh3F6SWnJtuFBz0YCgORgD1KDqm7GYq+80nLbQycPpAmwnP
         up3xz/UBcwIZNAm2ikmb5ItcPQTP4ICS7cbjMvhnNFcyeNwtA/nqOPcaJdQex7Uq6X0+
         8ogLOzJq89bcJNQ3SOICQBYhXfP5umDOl+y708pwXZIazSD2wYuljzmzpvJXa7K9SOMN
         QwUlfL6CZ9XD+tpwF97ebOFGGwbN9f6+x6OIaxz4C+VUPHFJUNEA2a97aNpgoOcHmdeI
         yrfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zs6nSLWspOzJqzLNgoacVdZyTUWqV9xzCEETdLcLPsQ=;
        b=ZFA4Do4G7XrOOmMAOxroTf7YwoyCAPqGdweVa6NkYRjdzMWz+cnLCTJf9vEbyg6HuW
         /Z1PsceVccflWXJP6wUyoFAg3ATOcVE2PisHypW9Rcq82vELCmK9kyxX+vfp4C8itqIx
         oyXJhV8Qo9nc2u0KZV/g2MK4Kt4pq6wei6iZ0SBD+rCRfGRZ3uYFTu+398vHO3Vylst9
         nlI4cCqqmSWLbxpVOeRN8qUzrPWUuGJForEIOrp9LUloSTdLfWxYOm0ebB2y0FNlqN6S
         X4THWG7yQzQLhjFSQCtJWiHefmaGlMhyQ+GXjVkH8vFaDVy4tMOUUZ5guDIifi2uMO+7
         a4OA==
X-Gm-Message-State: AOAM532+FpjsI+SlqjTCBGp6Qvu9Y2hXBafBKdyn8TVtYIduY5ZFXUAf
        tVwavv80umMEMk0XqbmO7FQ=
X-Google-Smtp-Source: ABdhPJyKV3+u535B0idc4ds2VqvuYq1L6d9Z7qrEl/D6cxjqWSbVxkCz4IYLY3Haa/w7Sekbhe3a0g==
X-Received: by 2002:a17:906:a848:: with SMTP id dx8mr7929336ejb.37.1611201935364;
        Wed, 20 Jan 2021 20:05:35 -0800 (PST)
Received: from anparri (93-41-36-81.ip79.fastwebnet.it. [93.41.36.81])
        by smtp.gmail.com with ESMTPSA id v15sm1676494ejj.4.2021.01.20.20.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 20:05:34 -0800 (PST)
Date:   Thu, 21 Jan 2021 05:05:26 +0100
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
Message-ID: <20210121040526.GA264889@anparri>
References: <20210119175841.22248-1-parri.andrea@gmail.com>
 <20210119175841.22248-5-parri.andrea@gmail.com>
 <BL0PR2101MB0930CF4297121B1BB904AA7DCAA29@BL0PR2101MB0930.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL0PR2101MB0930CF4297121B1BB904AA7DCAA29@BL0PR2101MB0930.namprd21.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > @@ -544,7 +545,8 @@ static int negotiate_nvsp_ver(struct hv_device
> > *device,
> >  	init_packet->msg.v2_msg.send_ndis_config.capability.ieee8021q = 1;
> > 
> >  	if (nvsp_ver >= NVSP_PROTOCOL_VERSION_5) {
> > -		init_packet->msg.v2_msg.send_ndis_config.capability.sriov =
> > 1;
> > +		if (!hv_is_isolation_supported())
> > +			init_packet-
> > >msg.v2_msg.send_ndis_config.capability.sriov = 1;
> 
> Please also add a log there stating we don't support sriov in this case. Otherwise,
> customers will ask why vf not showing up.

IIUC, you're suggesting that I append something like:

+		else
+			netdev_info(ndev, "SR-IOV not advertised: isolation supported\n");

I've added this locally; please let me know if you had something else
/better in mind.


> > @@ -563,6 +565,13 @@ static int negotiate_nvsp_ver(struct hv_device
> > *device,
> >  	return ret;
> >  }
> > 
> > +static bool nvsp_is_valid_version(u32 version)
> > +{
> > +       if (hv_is_isolation_supported())
> > +               return version >= NVSP_PROTOCOL_VERSION_61;
> > +       return true;
> Hosts support isolation should run nvsp 6.1+. This error is not expected.
> Instead of fail silently, we should log an error to explain why it's failed, and the current version and expected version.

Please see my next comment below.


> > +}
> > +
> >  static int netvsc_connect_vsp(struct hv_device *device,
> >  			      struct netvsc_device *net_device,
> >  			      const struct netvsc_device_info *device_info)
> > @@ -579,12 +588,17 @@ static int netvsc_connect_vsp(struct hv_device
> > *device,
> >  	init_packet = &net_device->channel_init_pkt;
> > 
> >  	/* Negotiate the latest NVSP protocol supported */
> > -	for (i = ARRAY_SIZE(ver_list) - 1; i >= 0; i--)
> > +	for (i = ARRAY_SIZE(ver_list) - 1; i >= 0; i--) {
> > +		if (!nvsp_is_valid_version(ver_list[i])) {
> > +			ret = -EPROTO;
> > +			goto cleanup;
> > +		}
> 
> This code can catch the invalid, but cannot get the current host nvsp version.
> I'd suggest move this check after version negotiation is done. So we can log what's
> the current host nvsp version, and why we fail it (the expected nvsp ver).

Mmh, invalid versions are not negotiated.  How about I simply add the
following logging right before the above 'ret = -EPROTO' say?

+			netdev_err(ndev, "Invalid NVSP version %x (expected >= %x): isolation supported\n",
+				   ver_list[i], NVSP_PROTOCOL_VERSION_61);

(or something along these lines)


> > @@ -1357,7 +1371,8 @@ static void netvsc_receive_inband(struct
> > net_device *ndev,
> >  		break;
> > 
> >  	case NVSP_MSG4_TYPE_SEND_VF_ASSOCIATION:
> > -		netvsc_send_vf(ndev, nvmsg, msglen);
> > +		if (!hv_is_isolation_supported())
> > +			netvsc_send_vf(ndev, nvmsg, msglen);
> 
> When the driver doesn't advertise SRIOV, this message is not expected.
> Instead of ignore silently, we should log an error.

I've appended:

+		else
+			netdev_err(ndev, "Unexpected VF message: isolation supported\n");

Please let me know if I got this wrong.

Thanks,
  Andrea
