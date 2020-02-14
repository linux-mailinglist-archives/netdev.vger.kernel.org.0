Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDB2F15D738
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 13:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729032AbgBNMSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 07:18:10 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:25883 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728582AbgBNMSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 07:18:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581682689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GxW6IZnV896EyTIDav2L+lzzwUj9aa2oWUdly4vXUC0=;
        b=N0XtH1YuRlmxzk5iXFJuyaORhUUWoVdDckw/Dy5HsNfng3L7BdqchovgH7i9qxw98jT1GL
        7B/TInyZveMM+BnTUNmeV+x/l+Ey3wNuqVvHwqLUkyvpVXTFRExpNuLpPfDLs2aiQPeAJJ
        uqz4gLazbErUVb4L+azGFrq6jT/9QcA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-MK9NJI1dNLuSmoQWLwyTRg-1; Fri, 14 Feb 2020 07:18:07 -0500
X-MC-Unique: MK9NJI1dNLuSmoQWLwyTRg-1
Received: by mail-wr1-f72.google.com with SMTP id n23so3913141wra.20
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 04:18:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GxW6IZnV896EyTIDav2L+lzzwUj9aa2oWUdly4vXUC0=;
        b=CVZcobuT+oI8dQH6trB7wSp+GANt0npmOIBGaW6uehqt1adQ5qArRSBD20PhMJ1j2/
         eFNv8tGhEcGsQuMMjhXrK3ksw16IDdZWSo5z9HWSUFYG+gUCutYJ8eNzmoLyZ/kS04so
         2akLXIPZm9ZQ5Ehr9KtNSGbMcvQTB8qPHCfpBuhYKo+590WIteBbhX0gjgWssCjbkaGH
         qUZkVRBSRNaOm7BjqC+s8hv/ljdD6ycEJwz0f8RAI9I4PletB5+e6X7CXT72cEiGCi3g
         24qa+HeHQUmchkA69agrV+BQiV0svgh6FUji00xF7xqmqoPKtwHkyN+jDwe9LNLzZOQp
         n29A==
X-Gm-Message-State: APjAAAVMuTkB0MtSsqCN2Ztrm0HIcUfgqILqwmj0KhF0wvCUtTlx/uay
        tZ3IcputzEcYfSM7heuhpyij5k9BEB79FWWPI2BwXwHklok5T+jdUR+nWXk7PbyVVvIJpcgWZ64
        1W1oRX1hHhJc+VIas
X-Received: by 2002:a7b:c183:: with SMTP id y3mr4446309wmi.0.1581682686276;
        Fri, 14 Feb 2020 04:18:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqzwoB+X56u/QQ+OuiMD+r6zCO5Q/ZdH2SzDJvMsIaVp2/BPI4RW23G1odXHXaJ+AQ/de/gnRg==
X-Received: by 2002:a7b:c183:: with SMTP id y3mr4446285wmi.0.1581682686037;
        Fri, 14 Feb 2020 04:18:06 -0800 (PST)
Received: from steredhat (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id t81sm7120128wmg.6.2020.02.14.04.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 04:18:05 -0800 (PST)
Date:   Fri, 14 Feb 2020 13:18:03 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Sebastien Boeuf <sebastien.boeuf@intel.com>
Cc:     netdev@vger.kernel.org, stefanha@redhat.com, davem@davemloft.net
Subject: Re: [PATCH v3 0/2] Enhance virtio-vsock connection semantics
Message-ID: <20200214121803.kpblkpywkvwkoc7h@steredhat>
References: <20200214114802.23638-1-sebastien.boeuf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214114802.23638-1-sebastien.boeuf@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 14, 2020 at 12:48:00PM +0100, Sebastien Boeuf wrote:
> This series improves the semantics behind the way virtio-vsock server
> accepts connections coming from the client. Whenever the server
> receives a connection request from the client, if it is bound to the
> socket but not yet listening, it will answer with a RST packet. The
> point is to ensure each request from the client is quickly processed
> so that the client can decide about the strategy of retrying or not.
> 
> The series includes along with the improvement patch a new test to
> ensure the behavior is consistent across all hypervisors drivers.
> 
> Sebastien Boeuf (2):
>   net: virtio_vsock: Enhance connection semantics
>   tools: testing: vsock: Test when server is bound but not listening
> 
>  net/vmw_vsock/virtio_transport_common.c |  1 +
>  tools/testing/vsock/vsock_test.c        | 77 +++++++++++++++++++++++++
>  2 files changed, 78 insertions(+)
> 

Thanks,
now they apply cleanly!

Tested-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

