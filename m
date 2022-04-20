Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B13550903F
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 21:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380651AbiDTTVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 15:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234251AbiDTTVQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 15:21:16 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B9ABC92
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 12:18:27 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id t25so3579378edt.9
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 12:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0joIfsZQ9fGWyjYgD8vSwXCAPANhdAIrhYAg/DBLbTQ=;
        b=eeD/0nFKELRJK4qFN1hs7/CXgaWwPM0MSYCrvnLfHNicfwGRJIYaQQaVYhV6qai6EH
         XInCISP+v66xPkb2mzVV9u83ZUR6VRWgdce5VLAfkFXUoMxZo1pPV1spb13sE1FrjtoW
         /frhlrVljTH5U6yvVP+li6RVmZSQ040cVGvKjN853+BayZRBnAXDdqBe46/VFkFddp7D
         2sj4KaaBI1UEpEMwuKsrxeSMJoOAugCEIRJyJBYja6NFx1RtBQ6axRZhIOXZnFCJGYjn
         jQgKs5KqNREjSUbTw7HWIJ2I7Zk6NrhTnB9zyEkfeSAxdo/S+vSwRxrtfmujMPsA4uQK
         /4XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0joIfsZQ9fGWyjYgD8vSwXCAPANhdAIrhYAg/DBLbTQ=;
        b=ibQPDdG3jZRFErHNCDtILBhrR5d1Sm99/xmoiCEEu9XjxE/PartvbvYEu4eV/tXRG1
         wEexOkU2ruKPqfhI8PyldYpFQ4hvpzCIN4ZIKFDsGfGyrIk8hxcviwsYKl3UMJ396zZG
         fzCZN4CIiOYYNy6BuZ4PyjsSd3j9eN12XB/wWpo8scBr4QppDEaB0q50P7JFnXcJCiD4
         ZyK/sqwXIo94z35w4V69UpcL3/qVylakG914BqhdubgLlIavUSpqFQY7FEbkQe3M5SDq
         /QaR9kqP6Pu0If+RBUCCFS92+wyiIhSoFq3W35b40efsOcT6FlsGqb588YnAxkwk0jYw
         WMwg==
X-Gm-Message-State: AOAM530IItXeV/FdT/lpnSMAQBuHsW+JDZ+NhWlY4B8h4amShwyNGoRp
        oyyijwkkT1W7+aXGjf4Y3r9oeJyEUZg=
X-Google-Smtp-Source: ABdhPJw04zW7WVw4Eo0O+yk3rzVKFBHA5tFnhswO4eRxlaTLdrAbtOtQTxeqn+/eVdEUdIzAv3ih4Q==
X-Received: by 2002:a05:6402:424e:b0:423:e4e0:fdc1 with SMTP id g14-20020a056402424e00b00423e4e0fdc1mr18146415edb.374.1650482306363;
        Wed, 20 Apr 2022 12:18:26 -0700 (PDT)
Received: from skbuf ([188.26.185.183])
        by smtp.gmail.com with ESMTPSA id en13-20020a056402528d00b00423dd17c95asm5551087edb.95.2022.04.20.12.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 12:18:25 -0700 (PDT)
Date:   Wed, 20 Apr 2022 22:18:24 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: IPv6 multicast with VRF
Message-ID: <20220420191824.wgdh5tr3mzisalsh@skbuf>
References: <20220420165457.kd5yz6a6itqfcysj@skbuf>
 <97eaffb8-2125-834e-641f-c99c097b6ee2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97eaffb8-2125-834e-641f-c99c097b6ee2@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 12:59:45PM -0600, David Ahern wrote:
> Did you adjust the FIB rules? See the documentation in the kernel repo.

Sorry, I don't understand what you mean by "adjusting". I tried various
forms of adding an IPv6 multicast route on eth0, to multiple tables,
some routes more generic and some more specific, and none seem to match
when eth0 is under a VRF, for a reason I don't really know. This does
not occur with IPv4 multicast, by the way.

By documentation I think you mean Documentation/networking/vrf.rst.
I went through it but I didn't notice something that would make me
realize what the issue is.

> And add a device scope to the `get`. e.g.,
> 
>     ip -6 route get ff02::1%eth0

I'm probably not understanding this, because:

 ip -6 route get ff02::1%eth0
Error: inet6 prefix is expected rather than "ff02::1%eth0".
