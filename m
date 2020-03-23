Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A29B718FE78
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 21:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgCWULm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 16:11:42 -0400
Received: from smtprelay0085.hostedemail.com ([216.40.44.85]:44634 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725830AbgCWULm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 16:11:42 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id B46D3837F24D;
        Mon, 23 Mar 2020 20:11:40 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2892:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:6117:6691:7688:7903:8957:9025:10004:10400:10471:10848:11026:11232:11658:11914:12043:12295:12296:12297:12438:12740:12760:12895:13019:13069:13071:13255:13311:13357:13439:14096:14097:14180:14181:14659:14721:14775:21060:21080:21627:30054:30055:30060:30075:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: blood13_2b83efc501e40
X-Filterd-Recvd-Size: 3004
Received: from XPS-9350.home (unknown [47.151.136.130])
        (Authenticated sender: joe@perches.com)
        by omf05.hostedemail.com (Postfix) with ESMTPA;
        Mon, 23 Mar 2020 20:11:38 +0000 (UTC)
Message-ID: <03547be94c4944ca672c7aef2dd38b0fb1eedc84.camel@perches.com>
Subject: Re: [PATCH v1 1/2] Bluetooth: btusb: Indicate Microsoft vendor
 extension for Intel 9460/9560 and 9160/9260
From:   Joe Perches <joe@perches.com>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Miao-chen Chou <mcchou@chromium.org>,
        Bluetooth Kernel Mailing List 
        <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Alain Michaud <alainm@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date:   Mon, 23 Mar 2020 13:09:50 -0700
In-Reply-To: <57C56801-7F3B-478A-83E9-1D2376C60666@holtmann.org>
References: <20200323072824.254495-1-mcchou@chromium.org>
         <20200323002820.v1.1.I0e975833a6789e8acc74be7756cd54afde6ba98c@changeid>
         <04021BE3-63F7-4B19-9F0E-145785594E8C@holtmann.org>
         <421d27670f2736c88e8c0693e3ff7c0dcfceb40b.camel@perches.com>
         <57C56801-7F3B-478A-83E9-1D2376C60666@holtmann.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-03-23 at 19:48 +0100, Marcel Holtmann wrote:
> Hi Joe,

Hello Marcel.

> > > > This adds a bit mask of driver_info for Microsoft vendor extension and
> > > > indicates the support for Intel 9460/9560 and 9160/9260. See
> > > > https://docs.microsoft.com/en-us/windows-hardware/drivers/bluetooth/
> > > > microsoft-defined-bluetooth-hci-commands-and-events for more information
> > > > about the extension. This was verified with Intel ThunderPeak BT controller
> > > > where msft_vnd_ext_opcode is 0xFC1E.
> > []
> > > > diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
> > []
> > > > @@ -315,6 +315,10 @@ struct hci_dev {
> > > > 	__u8		ssp_debug_mode;
> > > > 	__u8		hw_error_code;
> > > > 	__u32		clock;
> > > > +	__u16		msft_vnd_ext_opcode;
> > > > +	__u64		msft_vnd_ext_features;
> > > > +	__u8		msft_vnd_ext_evt_prefix_len;
> > > > +	void		*msft_vnd_ext_evt_prefix;
> > 
> > msft is just another vendor.
> > 
> > If there are to be vendor extensions, this should
> > likely use a blank line above and below and not
> > be prefixed with msft_
> 
> there are other vendors, but all of them are different. So this needs to be prefixed with msft_ actually. But I agree that having empty lines above and below makes it more readable.

So struct hci_dev should become a clutter
of random vendor extensions?

Perhaps there should instead be something like
an array of char at the end of the struct and
various vendor specific extensions could be
overlaid on that array or just add a void *
to whatever info that vendors require.



