Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E3D6DCBF7
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 22:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbjDJUBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 16:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjDJUB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 16:01:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4D71BF8
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 13:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681156844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zlVBu6kDOZRhDnqlh1bHjrtccNzhWJl3JqOwXzW7ubY=;
        b=XdaS6kWgkdTp3k+BYriVFIIcWWX8M1A8IqHDbyPIS+5fyw5jvdoXx7PajFP5P6muQHeOI6
        Rp2AV7HA8RXR7uVq+3+3iqXeF/AkAsFlcOtszZm7kKTKTPpPvqbVxaM6lkDiXWCkf0se9Z
        nvMC2y1kIVc0nFmkoYzcXtai9jUxnrY=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-XcIL7RBUMpqLAQM8ywsbrw-1; Mon, 10 Apr 2023 16:00:42 -0400
X-MC-Unique: XcIL7RBUMpqLAQM8ywsbrw-1
Received: by mail-il1-f198.google.com with SMTP id q17-20020a056e020c3100b003245df8be9fso4699107ilg.14
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 13:00:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681156842; x=1683748842;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zlVBu6kDOZRhDnqlh1bHjrtccNzhWJl3JqOwXzW7ubY=;
        b=R3oS3KPDLWuoorWMdGesTWT3benBne07GfyWYaHx56T2UElI3x14Kdv2X18f6N/lZv
         8ltKx8FApNXCrRr4HiOf4jeWpU3JXYzmNIkWZd4+j7Ze8ZtVKi6sH1BqJl7t81gHQTX1
         oArQB5PwmmzVfHUa7EBXTClNYzTzQB8Mjcc61nKK/SqkRBP+4QMnHiBqRRMP5U57VYyk
         igygXMSWdLi/gTQmb9N9YUPTptnIWBflUo58YoBcboGWx94aXK6BZWrpYysuYGiR95E4
         3ulQMopzCCP2TOw+5eJMVUA78WQJm7vPNA8uwkYyE64pLnqVgy681k4LQxhIiA1ozww1
         UWnQ==
X-Gm-Message-State: AAQBX9e5oUI881pQiNiv4IT88C+lpz95nvdKBdyPz4uDYt09rqBkxZGc
        35WM19kjoA/ni0mh+7I9c4Q3pLZ/5mR7wOY41dMMxNqhWau2hp4rSebl/QSzGBjGTXn2PcdzANi
        CawFccmggy0ij7bxo
X-Received: by 2002:a05:6e02:6c7:b0:328:136e:1420 with SMTP id p7-20020a056e0206c700b00328136e1420mr7956972ils.29.1681156841841;
        Mon, 10 Apr 2023 13:00:41 -0700 (PDT)
X-Google-Smtp-Source: AKy350bqLT3YVhxSj7uXsPGF5I8ISDak73VX0H2CEclnM2TZcFgVaaX6JzyBSoNtwXgYcW2HwC6xww==
X-Received: by 2002:a05:6e02:6c7:b0:328:136e:1420 with SMTP id p7-20020a056e0206c700b00328136e1420mr7956961ils.29.1681156841639;
        Mon, 10 Apr 2023 13:00:41 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id cp18-20020a056638481200b0039deb26853csm3492464jab.10.2023.04.10.13.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 13:00:40 -0700 (PDT)
Date:   Mon, 10 Apr 2023 14:00:39 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     <brett.creeley@amd.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <drivers@pensando.io>,
        <leon@kernel.org>, <jiri@resnulli.us>
Subject: Re: [PATCH v9 net-next 00/14] pds_core driver
Message-ID: <20230410140039.5c1da8f1.alex.williamson@redhat.com>
In-Reply-To: <20230406234143.11318-1-shannon.nelson@amd.com>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
Organization: Red Hat
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

On Thu, 6 Apr 2023 16:41:29 -0700
Shannon Nelson <shannon.nelson@amd.com> wrote:

> Summary:
> --------
> This patchset implements a new driver for use with the AMD/Pensando
> Distributed Services Card (DSC), intended to provide core configuration
> services through the auxiliary_bus and through a couple of EXPORTed
> functions for use initially in VFio and vDPA feature specific drivers.
> 
> To keep this patchset to a manageable size, the pds_vdpa and pds_vfio
> drivers have been split out into their own patchsets to be reviewed
> separately.

FYI, this fails to build w/o DYNAMIC_DEBUG set due to implicit
declaration of dynamic_hex_dump().  Seems the ionic driver avoids this
by including linux/dynamic_debug.h.  Other use cases have #ifdef around
their uses.  Thanks,

Alex

