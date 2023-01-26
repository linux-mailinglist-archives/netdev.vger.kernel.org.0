Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C935F67C7EF
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 11:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236999AbjAZKBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 05:01:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236951AbjAZKBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 05:01:50 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9548402C3
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 02:01:48 -0800 (PST)
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 3189F3F2FB
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 10:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1674727307;
        bh=qmbeNJYddIm33c9TQhZva/uzIIudmnT9AUCV4avsvwY=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=D81rGlh+8gIfEk1MB4XRcgfw40DqYG6G9TdYGi4CiGSisJMVNqtKncyNzvN/W77h4
         tZ5Uv9H+aphKHyCxU5K39N9r94yRaZLk67AdNEpB6f6IaJzThhxn3ZB07JF6WySNah
         3KQYa52z4dN9GhM9ZT2UlZQM40m7cwwheP2Nq2rSJWDAyeSoG5LWKHcOv/AIcO+6ZY
         zjBE33wyzX15yiyr1CWxJ2MiBcHEl65StT7bytgwT2fefFZ2s/ngOsf698ARrjZVbB
         e8aaRbpLdiwA5GPKs+BcqcfG0ajhcFAlI33p9GXdaRcQSs47q7974e5X1hVTg2vQnt
         Hlc1Kvv9bXW/A==
Received: by mail-wm1-f69.google.com with SMTP id o5-20020a05600c4fc500b003db0b3230efso2576332wmq.9
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 02:01:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qmbeNJYddIm33c9TQhZva/uzIIudmnT9AUCV4avsvwY=;
        b=EpU5i5QEI2u+tgLKz+JT2groBDeJ/jZIjJdJ6RnXc4NUyGbA9HMOa9WgQ+liBl7VJ1
         Ksw9dCykuDoPW7LosMKo/H/2wTePqIhOcbGFh8vCyeWU/JcH00lVex8efXOtwEkexrff
         6r56vuGAeLOl+uGyioGHS2Qz9YoexKQLflMhllZH49faAyQ4KCzijd/gxX5A23HxVCI+
         NgAvAX7VnUMdayCWT9D7LlNp5YNaFw5lGCS14ouRWodukZOij1DHaAdAU6M7wQjv9yOG
         mp4pfOVE3Dtg54cYGBZ4ABPzNYxdfJ1Qx3G+ZNfCwLV1PI/JYkdO9XlUSkvuWFcSkEhI
         OP7A==
X-Gm-Message-State: AFqh2koqxOZiZY9NuZM1dNc36aiu8+m4di6CHM6EhgvnLG4xBJU7bQRB
        Mm3MyAND1uEHCe0UFLd59yclrML+gd76P/qJnzNUwouRRwlRd4iVf5anfD2hbNYBJ+K+e++QUqX
        ZdEKeIUZBY89W/6eLqnRuaN1beaGhIudapQ==
X-Received: by 2002:a05:600c:224a:b0:3da:fa15:8658 with SMTP id a10-20020a05600c224a00b003dafa158658mr38175481wmm.32.1674727306700;
        Thu, 26 Jan 2023 02:01:46 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsACBfudiPPidBi8+IIBTW1b0+zkM2W0/wb9NMshJQpl91iZI+fLXOJeCGFHPIUki0qMi8aqQ==
X-Received: by 2002:a05:600c:224a:b0:3da:fa15:8658 with SMTP id a10-20020a05600c224a00b003dafa158658mr38175466wmm.32.1674727306453;
        Thu, 26 Jan 2023 02:01:46 -0800 (PST)
Received: from qwirkle ([81.2.157.149])
        by smtp.gmail.com with ESMTPSA id bd16-20020a05600c1f1000b003d1f3e9df3csm4435258wmb.7.2023.01.26.02.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 02:01:46 -0800 (PST)
Date:   Thu, 26 Jan 2023 10:01:44 +0000
From:   Andrei Gherzan <andrei.gherzan@canonical.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2 1/2] selftests: net: Fix missing nat6to4.o when
 running udpgro_frglist.sh
Message-ID: <Y9JPiA11CHNOMibr@qwirkle>
References: <20230125211350.113855-1-andrei.gherzan@canonical.com>
 <20230125230843.6ea157b1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125230843.6ea157b1@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Thanks for taking a look at this.

On 23/01/25 11:08PM, Jakub Kicinski wrote:
> On Wed, 25 Jan 2023 21:13:49 +0000 Andrei Gherzan wrote:
> > The udpgro_frglist.sh uses nat6to4.o which is tested for existence in
> > bpf/nat6to4.o (relative to the script). This is where the object is
> > compiled. Even so, the script attempts to use it as part of tc with a
> > different path (../bpf/nat6to4.o). As a consequence, this fails the script:
> 
> Is this a recent regression? Can you add a Fixes tag?

This issue seems to be included from the beginning (edae34a3ed92). I can't say
why this was not seen before upstream but on our side, this test was disabled
internally due to lack of CC support in BPF programs. This was fixed in the
meanwhile in 837a3d66d698 (selftests: net: Add cross-compilation support for
BPF programs) and we found this issue while trying to reenable the test.

So if you think that is reasonable, I could add a Fixes tag for the initial 
script commit edae34a3ed92 (selftests net: add UDP GRO fraglist + bpf
self-tests) and push a v3.

> What tree did you base this patch on? Doesn't seem to apply

The patches were done on top of
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git, the master
branch - 948ef7bb70c4 (Merge tag 'modules-6.2-rc6' of
git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux). There is another
merge that happened in the meanwhile but the rebase works without issues. I can
send a rebased v3 if needed.

> 
> > Error opening object ../bpf/nat6to4.o: No such file or directory
> > Cannot initialize ELF context!
> > Unable to load program
> > 
> > This change refactors these references to use a variable for consistency
> > and also reformats two long lines.
> > 
> > Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>

-- 
Andrei Gherzan
