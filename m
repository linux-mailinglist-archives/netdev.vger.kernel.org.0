Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92DD08AA5E
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 00:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfHLWY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 18:24:27 -0400
Received: from mail-qt1-f169.google.com ([209.85.160.169]:46451 "EHLO
        mail-qt1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726931AbfHLWY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 18:24:27 -0400
Received: by mail-qt1-f169.google.com with SMTP id j15so10915085qtl.13
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 15:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=pa1ICsz7P3S927U4GfIJ2jaFSiqBqwRpfp9iA5vLPf0=;
        b=nuGWM4SOyPy/tPta3I+dCLT+Mfazu8/mErRRmvCArmAeTXlmVzs42uL9fWd1SdvPvz
         P3R7nkVg6sYl6PBM+pfrv6+9kMJvpBElYDtBIw73VZRs5L6MRyTxZCg0ReeIXdhXBEsj
         CiWbJL2r3J3aZZ7aF47P8Chn4yRO2fqE3T4u1BnlS5EjqeLsd3LmFlbgJ2w6i0cxmCO/
         0YwFv4czEayPf3jmMjoBVMBHHivMMaOOLsblc4aoWJgM85facqDlLjy98nwECYdfKT+Q
         G4vnmpOPog3Et4uWej4bsfA9SLdOEvOKEhsQO4tpFW8VhGM2uBazH4aJ95DEj37Jdpqs
         LrHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=pa1ICsz7P3S927U4GfIJ2jaFSiqBqwRpfp9iA5vLPf0=;
        b=QEyTbVmVrMVwCunqjeuw5uH9i302bEya8NjcIvQ0iZkBTymHHhUcLSPxs0Chmnl9QG
         GiJERQfJEDCst/YQiYIKOy85bcb+zZgyGSEECJZzzRZWEhLqidofrcemhjYHbfIwGHTw
         CP6Nx5mEw8Bux4IvbGHUKOK/5E0tkd5rYEMpTT8XpRakyoir+0/VIrpku6ojFrSHepQL
         dsliEVu0bDBF/34b83mPxTjbz7RoXMq+9rwTRJMHsVSRRclcesPxXvmOIpOFqQKnVZN4
         zenJdriW4kIyaYxbHXliN4yL6UtYE2KGGSfhJuY6iXhbq2GQk+Qvlro7h0F56I0qjZpJ
         e1UQ==
X-Gm-Message-State: APjAAAWbGhIf09NMGpguVMl94Ai1hZou485wVYDooBx/RXnIF2jn59eE
        b1vrHyiF6APMjAE/XxdLbYMROg==
X-Google-Smtp-Source: APXvYqyrC0kCrpKBqEfMDt8C+v6Xrctqg0fwnwFUKW8jJp/jlvsnmd898l7XYgY6ZwoYYmeNs7u9WA==
X-Received: by 2002:aed:2d67:: with SMTP id h94mr31143435qtd.154.1565648666408;
        Mon, 12 Aug 2019 15:24:26 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o200sm8535917qke.66.2019.08.12.15.24.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 15:24:26 -0700 (PDT)
Date:   Mon, 12 Aug 2019 15:24:16 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Tieman, Henry W" <henry.w.tieman@intel.com>
Subject: Re: [net-next 01/15] ice: Implement ethtool ops for channels
Message-ID: <20190812152416.35f98091@cakuba.netronome.com>
In-Reply-To: <8a72e5d0ee26743dc5a896a426a55e6e9660f4d2.camel@intel.com>
References: <20190809183139.30871-1-jeffrey.t.kirsher@intel.com>
        <20190809183139.30871-2-jeffrey.t.kirsher@intel.com>
        <20190809141518.55fe7f8a@cakuba.netronome.com>
        <8a72e5d0ee26743dc5a896a426a55e6e9660f4d2.camel@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Aug 2019 15:07:09 +0000, Nguyen, Anthony L wrote:
> On Fri, 2019-08-09 at 14:15 -0700, Jakub Kicinski wrote:
> > On Fri,  9 Aug 2019 11:31:25 -0700, Jeff Kirsher wrote:  
> > > From: Henry Tieman <henry.w.tieman@intel.com>
> > > 
> > > Add code to query and set the number of queues on the primary
> > > VSI for a PF. This is accessed from the 'ethtool -l' and 'ethtool
> > > -L'
> > > commands, respectively.
> > > 
> > > Signed-off-by: Henry Tieman <henry.w.tieman@intel.com>
> > > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > > Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> > > Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>  
> > 
> > If you're using the same IRQ vector for RX and TX queue the channel
> > counts as combined. Looks like you are counting RX and TX separately
> > here. That's incorrect.  
> 
> Hi Jakub,
> 
> The ice driver can support asymmetric queues.  We report these
> seperately, as opposed to combined, so that the user can specify a
> different number of Rx and Tx queues.

If you have 20 IRQ vectors, 10 TX queues and 20 RX queues, the first 10
RX queues share a IRQ vector with TX queues the ethool API counts them
as 10 combined and 10 rx-only. 

10 tx-only and 20 rx-only would require 30 IRQ vectors.
