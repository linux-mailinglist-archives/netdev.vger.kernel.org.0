Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD0656B9CF
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 14:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238317AbiGHMhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 08:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238246AbiGHMhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 08:37:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82017C1A6;
        Fri,  8 Jul 2022 05:37:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FF86B826A6;
        Fri,  8 Jul 2022 12:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD1DC341C0;
        Fri,  8 Jul 2022 12:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657283837;
        bh=7bsOv8AqE7doc2BX/NF9/jSTGPilu4ZydXjBhQUadTk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LUJHQumHzpMq7yV+3V5Yp4p23EGdF8HPZEjj00Lr5moI8dfHmL/9DeCT+kd8PZwc3
         K/R3ODRkn1B2vvMS/6TpW5ctSaCO2EOrGps2mlpsQ0W98aonEDBRk+1rOrHAHVKXjU
         E7HH5ECtO0G0kv/TpJoS29kVK8jb7HjL6gAKHDqs=
Date:   Fri, 8 Jul 2022 14:37:14 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Lukasz Spintzyk <lukasz.spintzyk@synaptics.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        oliver@neukum.org, kuba@kernel.org, ppd-posix@synaptics.com
Subject: Re: [PATCH 2/2] net/cdc_ncm: Increase NTB max RX/TX values to 64kb
Message-ID: <Ysgk+mf+9CTjAizI@kroah.com>
References: <20220704070407.45618-1-lukasz.spintzyk@synaptics.com>
 <20220704070407.45618-3-lukasz.spintzyk@synaptics.com>
 <YsKVp2U3wzuSMxtQ@kroah.com>
 <cb2d33f6-1b6d-57bf-55b1-59d48cacf492@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cb2d33f6-1b6d-57bf-55b1-59d48cacf492@synaptics.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 08, 2022 at 09:40:49AM +0200, Lukasz Spintzyk wrote:
> On 04/07/2022 09:24, Greg KH wrote:
> > CAUTION: Email originated externally, do not click links or open attachments unless you recognize the sender and know the content is safe.
> > 
> > 
> > On Mon, Jul 04, 2022 at 09:04:07AM +0200, Łukasz Spintzyk wrote:
> > > DisplayLink ethernet devices require NTB buffers larger then 32kb in order to run with highest performance.
> > > 
> > > Signed-off-by: Łukasz Spintzyk <lukasz.spintzyk@synaptics.com>
> > > ---
> > >   include/linux/usb/cdc_ncm.h | 4 ++--
> > >   1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/include/linux/usb/cdc_ncm.h b/include/linux/usb/cdc_ncm.h
> > > index f7cb3ddce7fb..2d207cb4837d 100644
> > > --- a/include/linux/usb/cdc_ncm.h
> > > +++ b/include/linux/usb/cdc_ncm.h
> > > @@ -53,8 +53,8 @@
> > >   #define USB_CDC_NCM_NDP32_LENGTH_MIN         0x20
> > > 
> > >   /* Maximum NTB length */
> > > -#define      CDC_NCM_NTB_MAX_SIZE_TX                 32768   /* bytes */
> > > -#define      CDC_NCM_NTB_MAX_SIZE_RX                 32768   /* bytes */
> > > +#define      CDC_NCM_NTB_MAX_SIZE_TX                 65536   /* bytes */
> > > +#define      CDC_NCM_NTB_MAX_SIZE_RX                 65536   /* bytes */
> > 
> > Does this mess with the throughput of older devices that are not on
> > displaylink connections?
> > 
> > What devices did you test this on, and what is the actual performance
> > changes?  You offer no real information here at all, and large buffer
> > sizes does have other downsides, so determining how you tested this is
> > key.
> > 
> > Also, please wrap your changelogs at 72 columns like git asks you to do.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hi Greg,
> To my best knowledge that patch should not affect other devices because:
>  - tx,rx buffers size is initialized to 16kb with CDC_NCM_NTB_DEF_SIZE_RX,
> and CDC_NCM_NTB_DEF_SIZE_TX
>    So all existing devices should not be affected by default.
>  - In order to change tx and rx buffer max size you need to additionally
> modify cdc_ncm/tx_max and cdc_ncm/rx_max parameters. This can be done with
> udev rules and ethtool. So if you want to use higher buffer sizes you need
> to specially request that.
> For DisplayLink devices this will be done with udev rule that will be
> installed with other DisplayLink drivers.
>   - This tx,rx buffer sizes are always capped to dwNtbMaxInMaxSize and
> dwNtbMaxOutMaxSize that are advertised by the device itself. So in theory
> that values should be acceptable by the device.
> 
> Here is summary of my tests I have done on such devices:
>  - DisplayLink DL-3xxx family device
>  - DisplayLink DL-6xxx family device
>  - ASUS USB-C2500 2.5G USB3 eth adapter
>  - Plugable USB3 1G USB3 adapter
>  - EDIMAX EU-4307 USB-C adapter
>  - Dell DBQBCBC064 USB-C adapter
> 
> Unfortunately I was not able to find more or older than USB-3 device on
> company's shelf.
> 
> I was doing measurements with:
>  - iperf3 between two linux boxes
>  - http://openspeedtest.com/ instance running on local testing machine
> 
> I can provide you with detailed results, but I think they are quite verbose
> so I will stay with some high level results:
> 
> - All except one from third party usb adapters were not affected by
> increased buffer size. (I have forced them to use tx,rx size as big as their
> advertised dwNtbOutMaxSize and dwNtbInMaxSize).
>   They were generally reaching 912 - 940Mbps (download/upload)
>   Only Edimax adapter experienced decreased download size from 929Mbps to
> 827 with iper3. In openspeedtest this was decrease from 968Mbps to 886Mbps
> 
> - DisplayLink DL-3xxx family devices experienced increase of performance
>   Iperf3:
>    Download from (300Mbps to 870Mbps), also from historical measurements
> on other setup this was (90Mbps to 500Mbps)
>    Upload from 782Mbps to 844Mbps
>   Openspeedtest:
>    Download from 556Mbps to 873Mbps
>    Upload from 727Mbps to 973Mbps
> 
> - DiplayLink DL-6xxx family devices are not affected greatly by buffer size.
> It is more affected by patch enabling ZLP which prevents device from
> temporary network dropouts when playing video from web and network traffic
> going through it is high.

Lots of this information needs to go into the changelog text so that we
understand how you tested this, what you tested this on, and why you are
making this change.

thanks,

greg k-h
