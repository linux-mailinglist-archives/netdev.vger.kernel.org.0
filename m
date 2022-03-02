Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7DC24CAC46
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 18:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243762AbiCBRlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 12:41:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243758AbiCBRlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 12:41:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8902BC6238
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 09:40:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646242831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JyjfMrT0G3MMP6j88rE4l7Lk3LApCxkQNoMo5uVNK0s=;
        b=XT+mzPsw9db30hhsicZkHGdN1/ANSxwVNmbKnph1YASN4kqFoVby+bs+aoNVnlLgGI4PPp
        6NWnjAd7Qtexb/2RzJ453T50WZEOB5SFKkCu5DAuZPNv/shS9mz1nSLMDFYgoNckfk7OgA
        O0fUzgB0d9+aEmDDQbP9rgOhMyo3SSo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-224-gYpK2sS3N923RqrwtvRzHQ-1; Wed, 02 Mar 2022 12:40:27 -0500
X-MC-Unique: gYpK2sS3N923RqrwtvRzHQ-1
Received: by mail-wr1-f70.google.com with SMTP id o1-20020adfe801000000b001f023455317so901747wrm.3
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 09:40:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JyjfMrT0G3MMP6j88rE4l7Lk3LApCxkQNoMo5uVNK0s=;
        b=uePh77KYUgDjYetBTUotGsAKqUOKRDnjnma2PTvIQnpGRYHqAToguc34b8hNw9hsEx
         pmdnt0OP664ozofF2krdbF02zJwROoQwIfd0i8ypx94Y85kuxiD5E6UQFmaARKUi/8r/
         2WEcyty09X9WM57JzCN0Va2WemuYkYWweU+hyl2b69gEq4EVY2dvD18i5vbcNueUuGot
         S0KURCQcdecQfh6QfUwuP1P4roJvIv9ftZTTlchgEoDedIoylbphFQJwdo76w642pjN8
         UcniqvbNYsLR5iK2sCIpijUQZl0lzEyKQ7fH7BD+dCve9iv15tqVwbH4swHEtD+cTagh
         a+ZQ==
X-Gm-Message-State: AOAM530+gE36jlFaWvtMgvhH6OXFphXvMWU8kj5dgIp6gffGobRrwRZk
        SVhgl4+bLR5y3A+O8KwBJglkQYtpsfMPwKP2ezTyuBEYB1HX/MTlqj+BDAYpa/16DOfkephUKAE
        KKRiLMoCCA9JfxMcy
X-Received: by 2002:a5d:50c5:0:b0:1f0:2111:8f74 with SMTP id f5-20020a5d50c5000000b001f021118f74mr5617170wrt.211.1646242826347;
        Wed, 02 Mar 2022 09:40:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJysuw7h5K5VHEG1LKknLtJaA2xeQdS/AotHrBcn/QRDP3McufiQqi6/jU1o7dIdWL8RLLk3gw==
X-Received: by 2002:a5d:50c5:0:b0:1f0:2111:8f74 with SMTP id f5-20020a5d50c5000000b001f021118f74mr5617157wrt.211.1646242826119;
        Wed, 02 Mar 2022 09:40:26 -0800 (PST)
Received: from debian.home (2a01cb058d3818005c1e4a7b0f47339f.ipv6.abo.wanadoo.fr. [2a01:cb05:8d38:1800:5c1e:4a7b:f47:339f])
        by smtp.gmail.com with ESMTPSA id n5-20020a05600c3b8500b00380fc02ff76sm7214671wms.15.2022.03.02.09.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 09:40:25 -0800 (PST)
Date:   Wed, 2 Mar 2022 18:40:23 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH net] ipv4: fix route lookups when handling ICMP redirects
 and PMTU updates
Message-ID: <20220302174023.GA6904@debian.home>
References: <cffd245430d10fa2a14c32d1c768eef7cfeb8963.1646068241.git.gnault@redhat.com>
 <922b4932-fcd5-d362-4679-6689046560c7@kernel.org>
 <20220228205440.GA24680@debian.home>
 <faca5750-911d-151f-d5fa-7a8ed3b43b08@kernel.org>
 <20220301114107.GB24680@debian.home>
 <a30e29bf-c182-66d7-0d5a-bd42aa6a3e47@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a30e29bf-c182-66d7-0d5a-bd42aa6a3e47@kernel.org>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 09:19:43AM -0700, David Ahern wrote:
> On 3/1/22 4:41 AM, Guillaume Nault wrote:
> > And my final point was that the need for ip_rt_fix_tos() is temporary:
> > I plan to do the call paths review anyway, to make them initialise tos
> > and scope properly, thus removing the need for RTO_ONLINK. I already
> > have a draft patch series, but as I said that's work for net-next.
> 
> ok, if the cleanup is going to happen in -next then this simple patch
> seems good for net and stable

That's the plan, though I won't have time to submit the cleanup before
the next merge window (as we're already at -rc6 and I still have more
work to do to remove RTO_ONLINK).

