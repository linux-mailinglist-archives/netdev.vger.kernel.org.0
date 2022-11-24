Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E218E637545
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 10:36:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiKXJgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 04:36:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiKXJga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 04:36:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A84C6D2C
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 01:35:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669282533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3lD3X1Z3DwL6oHpIWZE9wQ9xBbUQb4Md6bY08DZINX4=;
        b=e0eV8NRIO9AQ+hyf0CBPiEZ0nrBNmA0zTePbCkX/XI3ToVLFrhdBJxXwdC7VQLuU5WLBJd
        JiVfSfFsuGXMYIPtvPNLxI15uOnuOVmZ5oeE/R8bqQh+m2+6U48+wE9BqwXRyXxNClyrRn
        Hz8v/ijdwScFJ3ln8hjCZrKj/pHBaEA=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-626--FIFEsL_Oje7RdwA7cf1YA-1; Thu, 24 Nov 2022 04:35:30 -0500
X-MC-Unique: -FIFEsL_Oje7RdwA7cf1YA-1
Received: by mail-qk1-f199.google.com with SMTP id bl21-20020a05620a1a9500b006fa35db066aso1409993qkb.19
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 01:35:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3lD3X1Z3DwL6oHpIWZE9wQ9xBbUQb4Md6bY08DZINX4=;
        b=4WJ9MeWVCu0f44DNxc9WGeFLhfKfnrMGpB1gzPTq7XB11nACQO11AYU3OJvhHWRMrZ
         fCNFw1/cfraumiVboglVThG96SjIhK/AtMYq48Mqyno6zOE/E7k7sGG2rxG2sp13+Xt3
         DAdb59spJVkObuo0MgGiysmQixw2Fk1ZCfIgFje2LP5gBX+u+ZJTtusPfxlx2aC73SeR
         83vit2K8qgoezrXJ3Iwdyr52YNLAkneXhEC1zSG6IBJj9adqi38YTlrfPxZuISkeY3Vb
         afp0AHEs9zgVWfJp/YP1RjJkrVs22mbKLPV7nyZ15+zts+UwS/Oe4vyMIABop3pF7byd
         kuRA==
X-Gm-Message-State: ANoB5pkRzOJJvT6kfriStHME7eM7QFxwl/TAKQDW+QPsaCj6bpYAnMLG
        ZJ19X4oovgk0cX6C9JsqTnXtSivCiz14IfPRMdJoRsS9pSZGJgnWsfVnCNkkAjUom3gqY7TwSdj
        tiSugGeFiaKrc2Dk1
X-Received: by 2002:a05:620a:1905:b0:6fa:6636:a7b0 with SMTP id bj5-20020a05620a190500b006fa6636a7b0mr11659589qkb.55.1669282529665;
        Thu, 24 Nov 2022 01:35:29 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6UkOX2dmUYou/ibDwcHju3ZGcCFxTzlbvTEeEtb3pXW+tGL8BHSEyyBgVEQel0np7r58qmIw==
X-Received: by 2002:a05:620a:1905:b0:6fa:6636:a7b0 with SMTP id bj5-20020a05620a190500b006fa6636a7b0mr11659581qkb.55.1669282529361;
        Thu, 24 Nov 2022 01:35:29 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id s3-20020ae9de03000000b006ce1bfbd603sm543050qkf.124.2022.11.24.01.35.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 01:35:29 -0800 (PST)
Message-ID: <59bcf09d5eabf36eda1f940b755e3bca218f9df0.camel@redhat.com>
Subject: Re: [PATCH v2] net: usb: cdc_ether: add u-blox 0x1343 composition
From:   Paolo Abeni <pabeni@redhat.com>
To:     Davide Tronchin <davide.tronchin.94@gmail.com>, kuba@kernel.org
Cc:     bjorn@mork.no, marco.demarco@posteo.net, netdev@vger.kernel.org,
        Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org
Date:   Thu, 24 Nov 2022 10:35:25 +0100
In-Reply-To: <20221123084924.3369-1-davide.tronchin.94@gmail.com>
References: <20221122204438.25442c0c@kernel.org>
         <20221123084924.3369-1-davide.tronchin.94@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-11-23 at 09:49 +0100, Davide Tronchin wrote:
> Add CDC-ECM support for LARA-L6.
> 
> LARA-L6 module can be configured (by AT interface) in three different
> USB modes:
> * Default mode (Vendor ID: 0x1546 Product ID: 0x1341) with 4 serial
> interfaces
> * RmNet mode (Vendor ID: 0x1546 Product ID: 0x1342) with 4 serial
> interfaces and 1 RmNet virtual network interface
> * CDC-ECM mode (Vendor ID: 0x1546 Product ID: 0x1343) with 4 serial
> interface and 1 CDC-ECM virtual network interface
> 
> In CDC-ECM mode LARA-L6 exposes the following interfaces:
> If 0: Diagnostic
> If 1: AT parser
> If 2: AT parser
> If 3: AT parset/alternative functions
> If 4: CDC-ECM interface
> 
> Signed-off-by: Davide Tronchin <davide.tronchin.94@gmail.com>
> ---
> 
> V1 -> V2 add missing Signed-off
> 
> lsusb verbose output:
> 
> $ lsusb -v -d 1546:1343
> 
> Bus 001 Device 045: ID 1546:1343 U-Blox AG u-blox Modem
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass          239 Miscellaneous Device
>   bDeviceSubClass         2 
>   bDeviceProtocol         1 Interface Association
>   bMaxPacketSize0        64
>   idVendor           0x1546 U-Blox AG
>   idProduct          0x1343 
>   bcdDevice            0.00
>   iManufacturer           4 u-blox
>   iProduct                3 u-blox Modem
>   iSerial                 5 d6da37e3
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength       0x00c9
>     bNumInterfaces          6
>     bConfigurationValue     1
>     iConfiguration          2 u-blox Configuration
>     bmAttributes         0xc0
>       Self Powered
>     MaxPower              500mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           2
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass    255 Vendor Specific Subclass
>       bInterfaceProtocol     48 
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x01  EP 1 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        1
>       bAlternateSetting       0
>       bNumEndpoints           3
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass    255 Vendor Specific Subclass
>       bInterfaceProtocol    255 Vendor Specific Protocol
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               5
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x02  EP 2 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        2
>       bAlternateSetting       0
>       bNumEndpoints           3
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass    254 
>       bInterfaceProtocol    255 
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x84  EP 4 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               5
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x85  EP 5 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x03  EP 3 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        3
>       bAlternateSetting       0
>       bNumEndpoints           3
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass    255 Vendor Specific Subclass
>       bInterfaceProtocol    255 Vendor Specific Protocol
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x86  EP 6 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               5
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x87  EP 7 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x04  EP 4 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>     Interface Association:
>       bLength                 8
>       bDescriptorType        11
>       bFirstInterface         4
>       bInterfaceCount         2
>       bFunctionClass          2 Communications
>       bFunctionSubClass       0 
>       bFunctionProtocol       0 
>       iFunction               0 
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        4
>       bAlternateSetting       0
>       bNumEndpoints           1
>       bInterfaceClass         2 Communications
>       bInterfaceSubClass      6 Ethernet Networking
>       bInterfaceProtocol      0 
>       iInterface              0 
>       CDC Header:
>         bcdCDC               1.10
>       CDC Ethernet:
>         iMacAddress                      1 00A0C6A37E30
>         bmEthernetStatistics    0x00000000
>         wMaxSegmentSize              16384
>         wNumberMCFilters            0x0001
>         bNumberPowerFilters              0
>       CDC Union:
>         bMasterInterface        4
>         bSlaveInterface         5 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x88  EP 8 IN
>         bmAttributes            3
>           Transfer Type            Interrupt
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0040  1x 64 bytes
>         bInterval               5
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        5
>       bAlternateSetting       0
>       bNumEndpoints           0
>       bInterfaceClass        10 CDC Data
>       bInterfaceSubClass      0 
>       bInterfaceProtocol      0 
>       iInterface              0 
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        5
>       bAlternateSetting       1
>       bNumEndpoints           2
>       bInterfaceClass        10 CDC Data
>       bInterfaceSubClass      0 
>       bInterfaceProtocol      0 
>       iInterface              0 
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x89  EP 9 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x05  EP 5 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               0
> Device Qualifier (for other device speed):
>   bLength                10
>   bDescriptorType         6
>   bcdUSB               2.00
>   bDeviceClass          239 Miscellaneous Device
>   bDeviceSubClass         2 
>   bDeviceProtocol         1 Interface Association
>   bMaxPacketSize0        64
>   bNumConfigurations      1
> Device Status:     0x0000
>   (Bus Powered)
> 
> ---
>  drivers/net/usb/cdc_ether.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
> index e11f70911acc..8911cd2ed534 100644
> --- a/drivers/net/usb/cdc_ether.c
> +++ b/drivers/net/usb/cdc_ether.c
> @@ -989,6 +989,12 @@ static const struct usb_device_id	products[] = {
>  				      USB_CDC_SUBCLASS_ETHERNET,
>  				      USB_CDC_PROTO_NONE),
>  	.driver_info = (unsigned long)&wwan_info,
> +}, {
> +	/* U-blox LARA-L6 */
> +	USB_DEVICE_AND_INTERFACE_INFO(UBLOX_VENDOR_ID, 0x1343, USB_CLASS_COMM,
> +				      USB_CDC_SUBCLASS_ETHERNET,
> +				      USB_CDC_PROTO_NONE),
> +	.driver_info = (unsigned long)&wwan_info,
>  }, {
>  	/* Cinterion PLS8 modem by GEMALTO */
>  	USB_DEVICE_AND_INTERFACE_INFO(0x1e2d, 0x0061, USB_CLASS_COMM,

CC: Oliver, linux-usb 

@Davide: the patch LGTM, please include all the relevant recipients.
This kind of patches should at least land on the usb ML, thanks!

Paolo

