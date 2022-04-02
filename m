Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5F94EFD60
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 02:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347701AbiDBASU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 20:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236739AbiDBAST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 20:18:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A1BFE196D4C
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 17:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648858587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i42/t7QO2AfQCbRsfmhAccqjWn4hDzL3ieQVQ4rCV/E=;
        b=LSETxtdpiw9fLNM3UpshqA/n1wRt36W4grV4jKqDTYprCAd3sDjrKwW4FSV9vVqawBn7AZ
        RRSW1QezzrsoiEt8/d8kpAdtMWN4kxNoLl7EEelxQfy2UnjcB7sJxeQj6G3Gjm38VL3Spx
        yZjF45AtoK4cUYHWsuUpxhb39Z9oexg=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-310-cHpVSVNNPmCxdLajE-la7g-1; Fri, 01 Apr 2022 20:16:19 -0400
X-MC-Unique: cHpVSVNNPmCxdLajE-la7g-1
Received: by mail-pf1-f198.google.com with SMTP id 77-20020a621450000000b004fa8868a49eso2408664pfu.3
        for <netdev@vger.kernel.org>; Fri, 01 Apr 2022 17:16:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i42/t7QO2AfQCbRsfmhAccqjWn4hDzL3ieQVQ4rCV/E=;
        b=LrEQZRD2PxZty0iW08XxRZ3+eDdBPlbj6AvXx3PbgTWagp/e20bbwN7cPz4++m+PBu
         +IUanb/cK2C+Ub7EOlYVe7RmvNPjpa/87J4eMUrQSLB/Q74LrBTZ4BcXxFERpF5PNE1k
         nUVH8hNYRW7dgJScpoPcdiQ7YkpSdim4m0MaHJYamtSoHjpRCOMWg5VlkIeJc8hoccRA
         9FTf/isYO1fN9r5dDr2+PGSY4nWkPfia8h8F7nhRb0+O/+EQhy0ozSjSIzH3rmHQmtYT
         q8qAxNyyi9pRTq/GUc2DtC8ogulfUUJUrgBYie/+/1pBvV4LntXYSvimF/EtCsZeSqY+
         DyHg==
X-Gm-Message-State: AOAM532xXlDdY/pls5oJSzPv3rS3gnjs/gI7Q6zmOakFzmPh8qIhSxyI
        dW0mlp1f5QTx3+oELnOw7AtElhuIvJkfsHJTaKO3RHnM0KUNwT77JYoKxUmHVAXubVjikx3VnKf
        1T1iNw9EGbchZtBgU
X-Received: by 2002:a17:90a:8417:b0:1c7:85c9:96b1 with SMTP id j23-20020a17090a841700b001c785c996b1mr14496412pjn.8.1648858577553;
        Fri, 01 Apr 2022 17:16:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyEkGGJ1rSYTj3/bfXJW1o2ofkgRKeClTRjRz2mSgvBqlVMYYitlU1cXUQGxH36NgIvQkqmhA==
X-Received: by 2002:a17:90a:8417:b0:1c7:85c9:96b1 with SMTP id j23-20020a17090a841700b001c785c996b1mr14496389pjn.8.1648858577246;
        Fri, 01 Apr 2022 17:16:17 -0700 (PDT)
Received: from fedora19.localdomain (2403-5804-6c4-aa-7079-8927-5a0f-bb55.ip6.aussiebb.net. [2403:5804:6c4:aa:7079:8927:5a0f:bb55])
        by smtp.gmail.com with ESMTPSA id q22-20020a056a00085600b004fb308e393csm4445974pfk.178.2022.04.01.17.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 17:16:16 -0700 (PDT)
Date:   Sat, 2 Apr 2022 11:16:12 +1100
From:   Ian Wienand <iwienand@redhat.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net/ethernet : set default assignment identifier to
 NET_NAME_ENUM
Message-ID: <YkeVzFqjhh1CcSkf@fedora19.localdomain>
References: <20220401063430.1189533-1-iwienand@redhat.com>
 <Ykb6d3EvC2ZvRXMV@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ykb6d3EvC2ZvRXMV@lunn.ch>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for review

On Fri, Apr 01, 2022 at 03:13:27PM +0200, Andrew Lunn wrote:
> On Fri, Apr 01, 2022 at 05:34:30PM +1100, Ian Wienand wrote:
> > As noted in the original commit 685343fc3ba6 ("net: add
> > name_assign_type netdev attribute")
> > 
> >   ... when the kernel has given the interface a name using global
> >   device enumeration based on order of discovery (ethX, wlanY, etc)
> >   ... are labelled NET_NAME_ENUM.
> > 
> > That describes this case, so set the default for the devices here to
> > NET_NAME_ENUM to better help userspace tools to know if they might
> > like to rename them.

> Is this potentially an ABI change

I don't think this counts as an ABI change; it's a fixed-size flag and
designed to be updated with more specific information on a
case-by-case basis?

> and we will get surprises when
> interfaces which were not previously renamed now are? It would be nice
> to see some justification this is actually safe to do.

I came to this through inconsistency of behaviour in a heterogeneous
OpenStack cloud environment.  Most of the clouds are kvm-based and
have NICS using virtio which fills in
/sys/class/net/<interface>/name_assign_type and this bubbles up
through udev/systemd/general magic to get the devices renamed.
However we have one outlier using Xen and the xen-netfront driver,
which I traced to here, where name_assign_type isn't set.  So I think
it's a consistency win to have it reporting itself as NET_NAME_ENUM
here.

Thanks,

-i

