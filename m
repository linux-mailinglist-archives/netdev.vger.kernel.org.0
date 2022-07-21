Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2D757CE21
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 16:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiGUOu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 10:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbiGUOu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 10:50:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 03D392019E
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 07:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658415026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mRR3i+3ef4HCSx3ifmCJ0snuSNPL3jZ3nYDC+QThiAc=;
        b=PTlsSjrhNqpaRxFgk/o2dlEFgUBaVLKvq7Cf8xOidVRUbFlAhrrz9aLET2iO5zEAWRDoPS
        EksHkMa3PnGEdF797lYtTtTplwGDvza/PRQKlhF4FzvmSmiI26dhKOcJSNFwUJwWwNgYfX
        4u36hbXJNks5Pb4UrObu5W6yghL4H54=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-bpTMF63bOLeUwuXjwTjAoA-1; Thu, 21 Jul 2022 10:50:23 -0400
X-MC-Unique: bpTMF63bOLeUwuXjwTjAoA-1
Received: by mail-wr1-f72.google.com with SMTP id e5-20020adfa445000000b0021e45ff3413so410842wra.14
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 07:50:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=mRR3i+3ef4HCSx3ifmCJ0snuSNPL3jZ3nYDC+QThiAc=;
        b=I3vPOSYpxSpB4q8hgOJUb0T8fA3FAJpUBKStkQDjsg2Xn0Vr+a0kXggcKPf9OA9gXT
         wgMfYXPyx6yd0V0yxpXZFlyiQhPPnGx1BM/FkKso7BqRLTHlRyQXkyyJdiqUYDChHMgJ
         +3f2/txBu4dqwyB97qGwhJ/zJMoAom5GReKrzbCAEtwS5LDemhLj+MGYx4bsu68Wn6//
         Q5oAF8P2uYECiD2N7tffDvTKC6+oH7CXE2IMqqw9xN9OqyaH4nEqh6lGIE5zazu2pn1j
         /uHIQnYxIHTTB6y+lRJstrjV6fC6eGwTzRLdwt7BbFWFNjcpJzAD7YOIwSSyiRzjwuRL
         cb7A==
X-Gm-Message-State: AJIora/cYp66m+aRmppXLeuF2I2DMVUPoPVM8S0+7oOTMe63Z8vu3mtW
        80ofmA1r3VBfuDVXLrP1mCz59YFXxjEpmd8pq/G1AuWiIl9g/jDp2GC5b1EKxuoloRcfCulsujV
        3cWZUQtVfXRb2GlKY
X-Received: by 2002:a05:600c:2116:b0:3a3:7f:f3cc with SMTP id u22-20020a05600c211600b003a3007ff3ccmr8723472wml.28.1658415021929;
        Thu, 21 Jul 2022 07:50:21 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ugSx9cn855iZ1yHuucd4k0S0tpBIy0h9aW8p2RCg0xEIbqtTnQuHzy8HOwnjCJOoZzvKZKRg==
X-Received: by 2002:a05:600c:2116:b0:3a3:7f:f3cc with SMTP id u22-20020a05600c211600b003a3007ff3ccmr8723450wml.28.1658415021608;
        Thu, 21 Jul 2022 07:50:21 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-164.dyn.eolo.it. [146.241.104.164])
        by smtp.gmail.com with ESMTPSA id l22-20020a05600c2cd600b003a2f96935c0sm389676wmc.9.2022.07.21.07.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 07:50:21 -0700 (PDT)
Message-ID: <16b633abfdcdcb624054187a5fc342bfeb9831f9.camel@redhat.com>
Subject: Re: [PATCH net-next] net: ipa: fix build
From:   Paolo Abeni <pabeni@redhat.com>
To:     Alex Elder <elder@ieee.org>, netdev@vger.kernel.org
Cc:     Alex Elder <elder@kernel.org>, Jakub Kicinski <kuba@kernel.org>
Date:   Thu, 21 Jul 2022 16:50:20 +0200
In-Reply-To: <5a1c541c-3b61-a838-1502-5224d4b8d0a4@ieee.org>
References: <7105112c38cfe0642a2d9e1779bf784a7aa63d16.1658411666.git.pabeni@redhat.com>
         <5a1c541c-3b61-a838-1502-5224d4b8d0a4@ieee.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-07-21 at 09:15 -0500, Alex Elder wrote:
> On 7/21/22 8:55 AM, Paolo Abeni wrote:
> > After commit 2c7b9b936bdc ("net: ipa: move configuration data files
> > into a subdirectory"), build of the ipa driver fails with the
> > following error:
> > 
> > drivers/net/ipa/data/ipa_data-v3.1.c:9:10: fatal error: gsi.h: No such file or directory
> > 
> > After the mentioned commit, all the file included by the configuration
> > are in the parent directory. Fix the issue updating the include path.
> > 
> > Fixes: 2c7b9b936bdc ("net: ipa: move configuration data files into a subdirectory")
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> 
> Interesting...  This didn't happen for me.
>
> 
> Can you tell me more about your particular build environment
> so I can try to reproduce it?  I haven't tested your fix yet
> in my environment.

Possibly ENOCOFFEE here, but on net-next@bf2200e8491b,

make clean; make allmodconfig; make

fails reproducibly here, with gcc 11.3.1, make 4.3.

Do you have by chance uncommited local changes?

Thanks

Paolo

