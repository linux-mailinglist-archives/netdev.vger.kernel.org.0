Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7865A1D4147
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 00:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbgENWpF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 14 May 2020 18:45:05 -0400
Received: from mga04.intel.com ([192.55.52.120]:36240 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728229AbgENWpF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 18:45:05 -0400
IronPort-SDR: Ivpn6KAgkNklZXSHCghDWO9t/u3qfGz6muR5s/7ya7QCmGZ2dE87ocw1zac1If/M8xidWsekMU
 RORWGYwNM2+Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 15:45:05 -0700
IronPort-SDR: 59cQRB/DrbBOz/oGdibxxejufceysKEV+KHmSyuqnuCIFH5gW61C8Hz988ABSz5cJlFJiZ6dVR
 o7Hh7m6AOVlA==
X-IronPort-AV: E=Sophos;i="5.73,392,1583222400"; 
   d="scan'208";a="251831907"
Received: from lrkorbx-mobl.amr.corp.intel.com (HELO localhost) ([10.254.66.137])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 15:45:04 -0700
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <0b37c2ee-2bdb-7137-de80-8178d856dbad@gmail.com>
References: <20200514213117.4099065-1-jeffrey.t.kirsher@intel.com> <20200514213117.4099065-3-jeffrey.t.kirsher@intel.com> <0b37c2ee-2bdb-7137-de80-8178d856dbad@gmail.com>
Subject: Re: [net-next v2 2/9] igc: Use netdev log helpers in igc_main.c
From:   Andre Guedes <andre.guedes@intel.com>
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net
Date:   Thu, 14 May 2020 15:45:03 -0700
Message-ID: <158949630392.29481.10734953827271108583@lrkorbx-mobl.amr.corp.intel.com>
User-Agent: alot/0.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiner,

Quoting Heiner Kallweit (2020-05-14 15:07:42)
> On 14.05.2020 23:31, Jeff Kirsher wrote:
> > @@ -4877,8 +4870,7 @@ static int igc_probe(struct pci_dev *pdev,
> >  
> >       if (igc_get_flash_presence_i225(hw)) {
> >               if (hw->nvm.ops.validate(hw) < 0) {
> > -                     dev_err(&pdev->dev,
> > -                             "The NVM Checksum Is Not Valid\n");
> > +                     netdev_err(netdev, "The NVM Checksum Is Not Valid\n");
> 
> Using the netdev_xxx message functions before register_netdev() doesn't
> provide a benefit. You get "(unnamed net_device) (uninitialized)" in
> the message instead of a netdev name. Therefore I went the opposite way
> for messages in probe() in 22148df0d0bd ("r8169: don't use netif_info
> et al before net_device has been registered")

Agreed. I'm fixing it. Since this log happens in an error condition, I missed
it in my tests. Thank you for pointing that out.

- Andre
