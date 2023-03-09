Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B976B2006
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 10:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbjCIJ36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 04:29:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjCIJ3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 04:29:40 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1DD67736
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 01:29:37 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id ec29so4391597edb.6
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 01:29:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1678354176;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9lxTz1XA1XqHiv1JrpSHXqzz9osoooJiJz3ckinOVoU=;
        b=NhHILSo3XFgH7N7eKZ5jxHYm15cSgRxXk/yJ56YX7RFK1PPnDWCMLrnFsdfXdncfUx
         M+DmpqH+i0oJiwN1NwjoC/D3ARBIv6TrmUxUIPJgYMmbzo/y7LIfQtRv7sQI6i4Newgn
         wJfvfgWdoG5vUr20rwgqxhgIj8di5nM6vC/ueerhD3BHajLZUs5oTnIzgwNLWmyjkg5Z
         rrYd445EpfFBvtLgJKNlMTjYPPj1KuXMkoQWqryDqdB5xl18nILtYo9CAsX8iRqHWyOx
         OR6DxZldntfIzZ2PuSgRhcUdsiA5WOuGB0cdW2DwhE5a8xZmH6rGNny94DnPHuQgE8Uh
         52gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678354176;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9lxTz1XA1XqHiv1JrpSHXqzz9osoooJiJz3ckinOVoU=;
        b=PJL6OctclrLdNI9m3tn2QB7BCk1/pGfKVzlJs5y3M77s1ptDeVKy35oGu6X+B1IE+J
         ZMusLA151kvmbC4VDb5IgmG7YkE5SyZASCpueq1ms8nnzrXQmvVBA3oX5UENMbnlEENd
         XeTlU+MMwhTGUIaDwaubcYpHbQMAEdXDNUxAL54FEvlE9l8vYO7iH4ig7gPp4Fjhao8R
         cFgqCSMKEcEv+iZLmOt6gu678Zfms0L4WZpYfqROsVMq/GhYucKCARpRIOtX506GdqF3
         Jc++3NyAMD3nmDZCm7ymiabG6wwlMxY/DGVahfKtPv+AIiJGTuva6pKE2bI8LxogSJqe
         5KcQ==
X-Gm-Message-State: AO0yUKVSvxAYrPEM784tjxVtIiE7a0+meQTafPTHKwXapkTYyHPWLCoX
        thJkZUjtU8dWBOK9tnL20j+UMQ==
X-Google-Smtp-Source: AK7set/JD7XQ66C7cR0MD2QCkMMg+hNZC6DMMaWQWHajmC4c8mBUEqEqFsAYzWhKcAW7995LUYoV4A==
X-Received: by 2002:a17:907:a0b:b0:8b2:7567:9c30 with SMTP id bb11-20020a1709070a0b00b008b275679c30mr30416063ejc.59.1678354175925;
        Thu, 09 Mar 2023 01:29:35 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id r17-20020a50aad1000000b004bfa4f747d2sm9300126edc.54.2023.03.09.01.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 01:29:34 -0800 (PST)
Date:   Thu, 9 Mar 2023 10:29:33 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, leon@kernel.org
Subject: Re: [PATCH RFC v4 net-next 02/13] pds_core: add devcmd device
 interfaces
Message-ID: <ZAmm/bUs8FbWn+wp@nanopsycho>
References: <20230308051310.12544-1-shannon.nelson@amd.com>
 <20230308051310.12544-3-shannon.nelson@amd.com>
 <ZAhXZFABVgsVBzfF@nanopsycho>
 <02b934ee-edd9-08f1-3571-5efe7687b546@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02b934ee-edd9-08f1-3571-5efe7687b546@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 09, 2023 at 03:05:13AM CET, shannon.nelson@amd.com wrote:
>On 3/8/23 1:37 AM, Jiri Pirko wrote:
>> Wed, Mar 08, 2023 at 06:12:59AM CET, shannon.nelson@amd.com wrote:

[..]


>> > +static int identity_show(struct seq_file *seq, void *v)
>> > +{
>> > +      struct pdsc *pdsc = seq->private;
>> > +      struct pds_core_dev_identity *ident;
>> > +      int vt;
>> > +
>> > +      ident = &pdsc->dev_ident;
>> > +
>> > +      seq_printf(seq, "asic_type:        0x%x\n", pdsc->dev_info.asic_type);
>> > +      seq_printf(seq, "asic_rev:         0x%x\n", pdsc->dev_info.asic_rev);
>> > +      seq_printf(seq, "serial_num:       %s\n", pdsc->dev_info.serial_num);
>> > +      seq_printf(seq, "fw_version:       %s\n", pdsc->dev_info.fw_version);
>> 
>> What is the exact reason of exposing this here and not trought well
>> defined devlink info interface?
>
>These do show up in devlink dev info eventually, but that isn't for another
>couple of patches.  This gives us info here for debugging the earlier patches
>if needed.

Implement it properly from the start and avoid these, please.


>
>> 
>> 
>> > +      seq_printf(seq, "fw_status:        0x%x\n",
>> > +                 ioread8(&pdsc->info_regs->fw_status));
>> > +      seq_printf(seq, "fw_heartbeat:     0x%x\n",
>> > +                 ioread32(&pdsc->info_regs->fw_heartbeat));
>> > +


[..]

>> > +static int pdsc_identify(struct pdsc *pdsc)
>> > +{
>> > +      struct pds_core_drv_identity drv = { 0 };
>> > +      size_t sz;
>> > +      int err;
>> > +
>> > +      drv.drv_type = cpu_to_le32(PDS_DRIVER_LINUX);
>> > +      drv.kernel_ver = cpu_to_le32(LINUX_VERSION_CODE);
>> > +      snprintf(drv.kernel_ver_str, sizeof(drv.kernel_ver_str),
>> > +               "%s %s", utsname()->release, utsname()->version);
>> > +      snprintf(drv.driver_ver_str, sizeof(drv.driver_ver_str),
>> > +               "%s %s", PDS_CORE_DRV_NAME, utsname()->release);
>> 
>> Why exactly are you doing this? Looks very wrong.
>
>This helps us when debugging on the DSC side - we can see which host driver
>is using the interface (PXE, Linux, etc).  This is modeled from what we have
>in our out-of-tree ionic driver interface, but I need to trim it down to be
>less snoopy.

Device should not care who is on the other side in my opinion. Jakub,
any thoughts?

>
>sln
