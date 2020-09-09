Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C0C2630B2
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 17:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730361AbgIIPij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 11:38:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38735 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730413AbgIIPhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 11:37:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599665850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EuXDHvuAdSkUYMH4iVJeihKuXi2neB1nlUOzoXyEoh8=;
        b=hc2Nv68fFpDEt7mALbucFXZAiDmqvnCmnbhrazc9oyqS1P8cDg46f4d+BMRScsu/kSV6XJ
        uJY3Hcz7xP0XtdHV5VdwjHv3o5j6WGSlHjBtO1DjStge03oS59APxv47/39+b7C43sXoh8
        9ElShCECJ03lGK1GzH538rBnozoxAyI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-zNQccg6MPpSbu914gkb6BQ-1; Wed, 09 Sep 2020 11:37:26 -0400
X-MC-Unique: zNQccg6MPpSbu914gkb6BQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7EAA11DDFD;
        Wed,  9 Sep 2020 15:37:24 +0000 (UTC)
Received: from carbon (unknown [10.40.208.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 85ECA19C78;
        Wed,  9 Sep 2020 15:37:16 +0000 (UTC)
Date:   Wed, 9 Sep 2020 17:37:14 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     brouer@redhat.com,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, Maxim Mikityanskiy <maximmi@mellanox.com>,
        <magnus.karlsson@intel.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH bpf-next 0/6] xsk: exit NAPI loop when AF_XDP Rx ring is
 full
Message-ID: <20200909173714.25a3ce43@carbon>
In-Reply-To: <11f663ec-5ea7-926c-370d-0b67d3052583@nvidia.com>
References: <20200904135332.60259-1-bjorn.topel@gmail.com>
        <0257f769-0f43-a5b7-176d-7c5ff8eaac3a@intel.com>
        <11f663ec-5ea7-926c-370d-0b67d3052583@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Sep 2020 13:32:01 +0300
Maxim Mikityanskiy <maximmi@nvidia.com> wrote:

>  From the driver API perspective, I would prefer to see a simpler API if 
> possible. The current API exposes things that the driver shouldn't know 
> (BPF map type), and requires XSK-specific handling. It would be better 
> if some specific error code returned from xdp_do_redirect was reserved 
> to mean "exit NAPI early if you support it". This way we wouldn't need 
> two new helpers, two xdp_do_redirect functions, and this approach would 
> be extensible to other non-XSK use cases without further changes in the 
> driver, and also the logic to opt-in the feature could be put inside the 
> kernel.

I agree.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

