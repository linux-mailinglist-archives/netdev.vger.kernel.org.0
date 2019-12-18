Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9F8C1251B1
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 20:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbfLRTVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 14:21:01 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:34591 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbfLRTVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 14:21:01 -0500
Received: by mail-qk1-f194.google.com with SMTP id j9so2914421qkk.1
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 11:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kngeUhN0+/tB1LD8Ax/eWo93efkPx0yMU7mcnSsLERk=;
        b=eSqT27M0qhGrc+jC0LvEIIcg6NJyRpHkR+VE02wJpO01FK2GBG0jjGDVMAV257fe32
         pAGGzSii60Mxyt+yF/6sj8p7QryDjiXv3c0BzqJ56nKhXTWkfABmno2ly6qvsxn2sOiI
         DqCsM1KULVH6NpONzmRLs50iPsKYT7PRSoMR090Y6MLb7R8kJU8ydIt7FxQzfN1MvNMb
         aJ3dVEYFIpCLl1qDUpESfPfD5P7CzT8GQf3A4dgkrRaF7/frxRo4u+R7z3+MoxB4OfyH
         iKpNOYds8KnVC3Xk4P05x89M+75hnqcYHVIBD+BpjvW6h8FYFVDCXwX8UO/9fz+lLLLm
         Cklg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=kngeUhN0+/tB1LD8Ax/eWo93efkPx0yMU7mcnSsLERk=;
        b=bF33uR74DmL0F36Xzs7TLeapCbDbCJtNwMnHsBwsntj1dpF2I6tM8cFoVP9NT6epup
         zov3s73iOrZARStYoL9mGTtmV3Sdr2GuzNyNjWEY542nK3JCckucZWLvrdnYJiyLBPFI
         0M+gPiSkYnQ8Ko7R6jtEQk2ZtHEvafdVARbba4fCx7tUo6Tjz8OXIGty0otVXg5U9tRq
         q9kYcEm97IY8mb6ZM+Q+l5oqQE6HUoNXlZBAen2wz5cDoWmpiE6vA4AOAQmZQB/LTqmv
         ZOg97oo9gdm94kx9qaGbbWbe2veUfepkOH75QEN/+wvA6elSy4Hl2+7kcYjaWb/4/sLV
         yIxg==
X-Gm-Message-State: APjAAAUphLc30BMrr20XwhQl4uxnLpgPNzbQs29TStjA+AXMFf+JDvND
        DQEAfrK9Dt9+SRqnXtcKAZPkEUm2+wk=
X-Google-Smtp-Source: APXvYqyaiElVYz/it9vtIykNw+hkQRqNn63ZNd+Cc0/OBh0tj0rDprBsWVafJuA+yBucr2joJNCI0Q==
X-Received: by 2002:a05:620a:a0b:: with SMTP id i11mr4366979qka.11.1576696860196;
        Wed, 18 Dec 2019 11:21:00 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id d25sm910105qka.39.2019.12.18.11.20.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 18 Dec 2019 11:20:59 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1ihesU-0003Y2-QV; Wed, 18 Dec 2019 15:20:58 -0400
Date:   Wed, 18 Dec 2019 15:20:58 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     'Greg KH' <gregkh@linuxfoundation.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>
Subject: Re: [PATCH v3 04/20] i40e: Register a virtbus device to provide RDMA
Message-ID: <20191218192058.GH17227@ziepe.ca>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
 <20191209224935.1780117-5-jeffrey.t.kirsher@intel.com>
 <20191210153959.GD4053085@kroah.com>
 <9DD61F30A802C4429A01CA4200E302A7B6B9345E@fmsmsx124.amr.corp.intel.com>
 <20191214083753.GB3318534@kroah.com>
 <9DD61F30A802C4429A01CA4200E302A7B6B9AFF7@fmsmsx124.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7B6B9AFF7@fmsmsx124.amr.corp.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 06:57:10PM +0000, Saleem, Shiraz wrote:
> diff --git a/include/linux/net/intel/i40e_client.h b/include/linux/net/intel/i40e_client.h
> index 7e147d3..5c81261 100644
> +++ b/include/linux/net/intel/i40e_client.h
> @@ -83,11 +83,11 @@ struct i40e_params {
>  
>  /* Structure to hold Lan device info for a client device */
>  struct i40e_info {
>  	struct i40e_client_version version;

I hope this isn't the inter-module versioning stuff we already Nak'd?

>  	u8 lanmac[6];

Is this different from the mac reachable from the netdev?

>  	struct net_device *netdev;
>  	struct pci_dev *pcidev;
> +	struct virtbus_device *vdev;

If there is only one of these per virtbus_device then why do we need
to split the structure?

>  	u8 __iomem *hw_addr;
>  	u8 fid;	/* function id, PF id or VF id */
>  #define I40E_CLIENT_FTYPE_PF 0
> @@ -112,6 +112,11 @@ struct i40e_info {
>  	u32 fw_build;                   /* firmware build number */
>  };
>  
> +struct i40e_virtbus_device {
> +	struct virtbus_device vdev;
> +	struct i40e_info *ldev;

Is the lifetime actually any better? Will ldev be freed and left
danling before virtbus_device is released?

Jason
