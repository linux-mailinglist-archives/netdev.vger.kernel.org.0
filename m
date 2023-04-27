Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9886F08C6
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 17:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244212AbjD0Pwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 11:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244250AbjD0Pwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 11:52:42 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 662583A99
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 08:52:41 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1a920d484bdso67876225ad.1
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 08:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1682610761; x=1685202761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ouZe8vTGAgsO7FX7GKc0ImpPseweBHMjVqO2XRvKThc=;
        b=LeZhxdyZZ1q64N3gVaUYxE86kwIpLDLI04mfRk+I+69V/ubo3CuxS7/5EQi0ir2fpE
         f3IbgBH7gfIKReKeg+HGm6mAoTnv/VYVNEHfrGXKFDeqO6YzA5rKMUucxN3+PaQGlxQ3
         g9lvE1Wufd46CYQDVoP4z8J+brvU039b8V5EZ1DIatPZjvqNU0rlLxuJq3PCwcmxrD5k
         1BYsFspuybsVEnsoC1cUI/ChVfvNlt86oOFQyV36Eg4/xEUh5pGixGxrcohs3S9i3zu9
         FNRNfAaZk2BlUua9hZFWdaWD68FDxU19EGI4WpGXNI7HNxnrVB43v5F6lhCBttE3WHQ8
         AALQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682610761; x=1685202761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ouZe8vTGAgsO7FX7GKc0ImpPseweBHMjVqO2XRvKThc=;
        b=Ipx+6qGeZdFWbTZQy84ep8T9q+eAEkGFOHIIkaSu3AaYYvVne7TXNrPwcS69VPVQqC
         FVGP/oD7XNPG+LboqpfG7b/lIvRxAdH+lufcpHq7ZhV13EUfChDbyUPRbwl3ODL+5QoX
         lsa61PaKdwTKSdTlBOTXBUprEwvlCcHEt5ThJ70htIwe4y2p62EswMJcxWzMtyLBdTys
         ztyipBSM8bFWCVAtRzJn+kn3aA2u+Fnxiy4qWMLK69OWFRky0G+u1DiX4cHaFGCzC39Z
         R9ip4Weaid/agsiAz3cAbS6gHFeIwJqVfE7Ec3N/lPMUZMaJhtVAOesbpmad7BFiFEuB
         RLcQ==
X-Gm-Message-State: AC+VfDxLCMa9SO5G2kFXGOhWMu7MWQGieEGmzmL/NcSV3y9ziwFRW3le
        gtMI9uBqrUMiMP3M7Lom7S71P8GRDORTpcnNXg8xCg==
X-Google-Smtp-Source: ACHHUZ6sXd1YA9a0JgNz7vo27EmBMgxJHgrdPsG9UDMV+O4QEBIfKnk6WQtATGvBZrAT5l7t1xSv1g==
X-Received: by 2002:a17:902:e884:b0:1a9:6041:ca74 with SMTP id w4-20020a170902e88400b001a96041ca74mr2369713plg.24.1682610760850;
        Thu, 27 Apr 2023 08:52:40 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id gd12-20020a17090b0fcc00b00246578736bbsm11575406pjb.8.2023.04.27.08.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 08:52:40 -0700 (PDT)
Date:   Thu, 27 Apr 2023 08:52:39 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Bilal Khan <bilalkhanrecovered@gmail.com>
Cc:     majordomo@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Fix grammar in ip-rule(8) man page
Message-ID: <20230427085239.6f8906a6@hermes.local>
In-Reply-To: <CA++M5e+Edbq8qnYgGvG=oR_=Cecou_NTqxH2Z-Ld9=SdhQQLQg@mail.gmail.com>
References: <CA++M5e+Edbq8qnYgGvG=oR_=Cecou_NTqxH2Z-Ld9=SdhQQLQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Apr 2023 11:41:48 +0500
Bilal Khan <bilalkhanrecovered@gmail.com> wrote:

> Hey there,
> 
> I have identified a small grammatical error in the ip-rule(8) man
> page, and have created a patch to fix it. The current first line of
> the DESCRIPTION section reads:
> 
> > ip rule manipulates rules in the routing policy database control the route selection algorithm.  
> 
> This sentence contains a grammatical error, as "control" should either
> be changed to "that controls" (to apply to "database") or "to control"
> (to apply to "manipulates"). I have updated the sentence to read:
> 
> > ip rule manipulates rules in the routing policy database that controls the route selection algorithm.  
> 
> This change improves the readability and clarity of the ip-rule(8) man
> page and makes it easier for users to understand how to use the ip
> rule command.
> 
> I have attached the patch file
> "0001-Fix-grammar-in-ip-rule-8-man-page.patch" to this email and would
> appreciate any feedback or suggestions for improvement.

Patch is missing signed off by. For legal reasons patches are only accepted
with a valid signed-off-by which is Developers Certificate of Origin.

You can use kernel checkpatch to check iproute2 patches as well.
