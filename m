Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45D3E166ABD
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 00:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbgBTXGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 18:06:16 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46653 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbgBTXGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 18:06:16 -0500
Received: by mail-qk1-f196.google.com with SMTP id u124so143232qkh.13
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 15:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XkOTAOMcNc1IVEFTEsYF74ee6aJfy0dk3qnKTOfIb+o=;
        b=k0B6QsU55aXc/tAkmdquBVptl49yQdaKZ842RKzr52WaHd7dULw3IdWH/3cD4DX2Ct
         vzgkZvQQy1Uq+0syRXXzE72WJgnVuY88aFThQrEaG4B/UWwhEIbp5Vie+oejLeImU6bB
         ePQcuOiX6cLkW9ioPjlECqEpDzd9cX7zHiIUmiXrKGaPXhcq9LcUsopdBx9NMlRPM0Vb
         BS+KnuoGiC9z0iYbX4qUK/zb/tVNIO5oLQLRRaBuXdYjQA1N6X9mPUrnwxAfxmD9hdh+
         jU9Y/CLVckBWfm2hwFxcZdrb9NCExxBFXTIEQyLrEP1KkPx1CWCta5ycN78qhn1JTcfx
         aiIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XkOTAOMcNc1IVEFTEsYF74ee6aJfy0dk3qnKTOfIb+o=;
        b=K5URa1mBkoX3e6PEpAKkUDPQt1bFrnNwtKkyz7xytDpazntHFj5GwMyAfilo/NwSJO
         RRKbVpEW01iYWlpTkbwaqsUzWWxhcje9NmwPGkJ24RitdxnhaudUjYqBJ5UTY2K+Roaw
         L5KrwCdVb71pCyWjpHZu8m15VKufDJqztJ+mTRSkIin0xUgXYgoQN1GHoXTgFiNl3Yrx
         koxbj5YcijY48MS+XTHQQvfPf2fOS9j2MTpECok7OUtj5OR+3bXTDuSGo9zloRiSnC77
         SvCN+IDJQ1GervTH1RtDiVzoPtFAorF9kYA/MTXCZN6J9AsnxVbfz2Et4b3gZrxGzGHf
         dNew==
X-Gm-Message-State: APjAAAVDAn9xgm2oNRicIUQaNMHpiYYUGr3Dr/kr474/4vkKq2NVl16E
        /3HC/qNei5DRa+TBFMjqQxYbxqgRC6bwDQ==
X-Google-Smtp-Source: APXvYqyWOy7fG5gEgq1f8u7XI/wrD9auB5FL3ePxqOteIFSD2ZS6mfTCkbk/jTsqRKHx4mECWkaJYQ==
X-Received: by 2002:a37:4a16:: with SMTP id x22mr30918089qka.88.1582239975412;
        Thu, 20 Feb 2020 15:06:15 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id 65sm542770qtf.95.2020.02.20.15.06.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 20 Feb 2020 15:06:14 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1j4uta-0002gS-9M; Thu, 20 Feb 2020 19:06:14 -0400
Date:   Thu, 20 Feb 2020 19:06:14 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Parav Pandit <parav@mellanox.com>
Cc:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: Re: [RFC PATCH v4 10/25] RDMA/irdma: Add driver framework definitions
Message-ID: <20200220230614.GF31668@ziepe.ca>
References: <20200212191424.1715577-1-jeffrey.t.kirsher@intel.com>
 <20200212191424.1715577-11-jeffrey.t.kirsher@intel.com>
 <6f01d517-3196-1183-112e-8151b821bd72@mellanox.com>
 <9DD61F30A802C4429A01CA4200E302A7C60C94AF@fmsmsx124.amr.corp.intel.com>
 <AM0PR05MB4866395BD477FAD269BCAE07D1130@AM0PR05MB4866.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR05MB4866395BD477FAD269BCAE07D1130@AM0PR05MB4866.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 10:24:05PM +0000, Parav Pandit wrote:
> 
> 
> > From: Saleem, Shiraz <shiraz.saleem@intel.com>
> > Sent: Tuesday, February 18, 2020 2:43 PM
> > To: Parav Pandit <parav@mellanox.com>; Kirsher, Jeffrey T
> > <jeffrey.t.kirsher@intel.com>; davem@davemloft.net;
> > gregkh@linuxfoundation.org
> > Cc: Ismail, Mustafa <mustafa.ismail@intel.com>; netdev@vger.kernel.org;
> > linux-rdma@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> > jgg@ziepe.ca
> > Subject: RE: [RFC PATCH v4 10/25] RDMA/irdma: Add driver framework
> > definitions
> > 
> > [..]
> > 
> > > > +static int irdma_devlink_reload_up(struct devlink *devlink,
> > > > +				   struct netlink_ext_ack *extack) {
> > > > +	struct irdma_dl_priv *priv = devlink_priv(devlink);
> > > > +	union devlink_param_value saved_value;
> > > > +	const struct virtbus_dev_id *id = priv->vdev->matched_element;
> > >
> > > Like irdma_probe(), struct iidc_virtbus_object *vo is accesible for the given
> > priv.
> > > Please use struct iidc_virtbus_object for any sharing between two drivers.
> > > matched_element modification inside the virtbus match() function and
> > > accessing pointer to some driver data between two driver through this
> > > matched_element is not appropriate.
> > 
> > We can possibly avoid matched_element and driver data look up here.
> > But fundamentally, at probe time (see irdma_gen_probe) the irdma driver
> > needs to know which generation type of vdev we bound to. i.e. i40e or ice ?
> > since we support both.
> > And based on it, extract the driver specific virtbus device object, i.e
> > i40e_virtbus_device vs iidc_virtbus_object and init that device.
> > 
> > Accessing driver_data off the vdev matched entry in irdma_virtbus_id_table
> > is how we know this generation info and make the decision.
> > 
> If there is single irdma driver for two different virtbus device
> types, it is better to have two instances of
> virtbus_register_driver() with different matching string/id.

Yes, I think this also makes sense

The probe mechanism should include the entry pointer like PCI does for
probe so that the driver knows what to do.

Jason
