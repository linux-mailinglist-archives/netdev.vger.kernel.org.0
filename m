Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 121266D0E15
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 20:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjC3Sus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 14:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjC3Sur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 14:50:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B91ED314
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 11:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680202203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6UQrNZxjfu3FW/I6sK8C7BOJKbvCETQxYVwKUqa4gLk=;
        b=DwQnv4bTJJN9t4L8QMofCOGi5WIdzofjE6DnSOP2NSeLlje2i7Hfqd55PQNCWtyxWRsRXT
        P/6Ypj4bdlptSan8qUqhuziiGeqOfuT5pkJlgBTcR1bQaECj4bDdl2j5f1HpTNsRrsXXSp
        C5QhWzR+clLohBEV59HQRZQyG5DXIEU=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-47-d-MvNd5TPNSGbuPq-V0Xpg-1; Thu, 30 Mar 2023 14:50:01 -0400
X-MC-Unique: d-MvNd5TPNSGbuPq-V0Xpg-1
Received: by mail-il1-f198.google.com with SMTP id h19-20020a056e021d9300b00318f6b50475so12697501ila.21
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 11:50:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680202201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6UQrNZxjfu3FW/I6sK8C7BOJKbvCETQxYVwKUqa4gLk=;
        b=O61UWbf7lX99wrVVsq6ripvlswN13SEUTX36oCFzWJs9nnZHQwfbUGoKRVAPAsBxPy
         1UeDi9NuiSbBBWU48AXgdo1+TJg4GLIaxEwimWwi5gX52r2fFNbyyfDkKZnBC2vbCYx+
         2ZGk6BEDGO0JJb3bNObDaz6b8xGKrqRdy8unrgkpqzEBuGULcYoMHO/E0fvY8IArP/5N
         I/gXySgGsrXsYWzkhLursYviM+Le/PZj6J6h+uGoBUWtfAA7OdnT1gtPHHu8WoINawvh
         EhQul5aCkJrKZIL7rzszQwlH321OpaxFjMOIq4zvNi5VmN/RJfDmksAyJkCyv6Shbe2I
         9cTg==
X-Gm-Message-State: AO0yUKXqi3CA3EzBb5zvOCM5XwQXvsWzKy2CL0tc90kIsf/40XOz/eCG
        3JVrq8plLXPyKTYs9SUf+C0JbrE9SqUSNKj1fr4ZibGNfkLZ0cMCzG5bS46GMlpQKCmheE8bewv
        sqcxUyNhGUgpZJ1wG
X-Received: by 2002:a05:6602:228a:b0:71f:8124:de52 with SMTP id d10-20020a056602228a00b0071f8124de52mr19922009iod.9.1680202200961;
        Thu, 30 Mar 2023 11:50:00 -0700 (PDT)
X-Google-Smtp-Source: AK7set+vN+F+C7td9wLCa+FeJA73rOKlyidR7N4iFHFTnKNmuaGWlPkmBzorrxlU0FHERL7D4mtk8Q==
X-Received: by 2002:a05:6602:228a:b0:71f:8124:de52 with SMTP id d10-20020a056602228a00b0071f8124de52mr19921997iod.9.1680202200702;
        Thu, 30 Mar 2023 11:50:00 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id k14-20020a02660e000000b003c4e65fd6dfsm78865jac.176.2023.03.30.11.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 11:49:59 -0700 (PDT)
Date:   Thu, 30 Mar 2023 12:49:58 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Amit Cohen <amcohen@nvidia.com>, mlxsw@nvidia.com,
        linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH net-next 6/6] mlxsw: pci: Add support for new reset flow
Message-ID: <20230330124958.15a34c3d.alex.williamson@redhat.com>
In-Reply-To: <ZCVHtk/wqTAR4Ejd@shredder>
References: <ZCBOdunTNYsufhcn@shredder>
        <20230329160144.GA2967030@bhelgaas>
        <20230329111001.44a8c8e0.alex.williamson@redhat.com>
        <ZCVHtk/wqTAR4Ejd@shredder>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Mar 2023 11:26:30 +0300
Ido Schimmel <idosch@nvidia.com> wrote:

> On Wed, Mar 29, 2023 at 11:10:01AM -0600, Alex Williamson wrote:
> > I think we don't have it because it's unclear how it's actually
> > different from a secondary bus reset from the bridge control register,
> > which is what "bus" would do when selected for the example above.  Per
> > the spec, both must cause a hot reset.  It seems this device needs a
> > significantly longer delay though.  
> 
> Assuming you are referring to the 2ms sleep in
> pci_reset_secondary_bus(), then yes. In our case, after disabling the
> link on the downstream port we need to wait for 500ms before enabling
> it.
> 
> > Note that hot resets can be generated by a userspace driver with
> > ownership of the device and will make use of the pci-core reset
> > mechanisms.  Therefore if there is not a device specific reset, we'll
> > use the standard delays and the device ought not to get itself wedged
> > if the link becomes active at an unexpected point relative to a
> > firmware update.  This might be a point in favor of a device specific
> > reset solution in pci-core.  Thanks,  
> 
> I assume you referring to something like this:
> 
> # echo 1 > /sys/class/pci_bus/0000:03/device/0000:03:00.0/reset
> 
> Doesn't seem to have any effect (network ports remain up, at least).
> Anyway, this device is completely managed by the kernel, not a user
> space driver. I'm not aware of anyone using this method to reset the
> device.

The pci-sysfs reset attribute is only meant to reset the linked device,
so if this is a single function device then it might be accessing bus
reset, but it also might be using FLR or PM reset.  There's a
reset_method attribute to determine and select.

In any case, if the device is unaffected, that suggests we're dealing
with a device that doesn't comply with PCIe reset standards, which
might suggests it needs a device specific reset or to flag broken reset
methods regardless.

Note that QEMU is a vfio-pci userspace driver, so assigning the device
to a VM, where kernel drivers in the guest are managing the device is a
use case of userspace drivers which should have a functional reset
mechanism to avoid data leakage between userspace sessions.
 
> If I understand Bjorn and you correctly, we have two options:
> 
> 1. Keep the current implementation inside the driver.
> 
> 2. Call __pci_reset_function_locked() from the driver and move the link
> toggling to drivers/pci/quirks.c as a "device_specific" method.
> 
> Personally, I don't see any benefit in 2, but we can try to implement
> it, see if it even works and then decide.

The second option enables use cases like above, where the PCI-core can
perform an effective reset of the device rather than embedding that
into a specific driver.  Even if not intended as a primary use case,
it's a more complete solution and avoids potentially unhappy users that
assume such use cases are available.  Thanks,

Alex

