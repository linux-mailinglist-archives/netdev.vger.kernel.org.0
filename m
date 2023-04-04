Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1A66D56C1
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 04:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbjDDC2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 22:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232579AbjDDC2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 22:28:39 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0246EDD
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 19:28:36 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id j13so29110913pjd.1
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 19:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680575315;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=392+WT6GsxxrCIs2uzKVQ99rTrfrqzKvAPnhOs+mblM=;
        b=UAExiW7vg3sRpRz2Li9xkgmLWobLrO6eroqNqpIS0kGYsx0OKPmj/uYwXxUCSb8PWd
         qMZEl6ddwRRoeyPDSyI6Rvvgaz1a6cy46iNeM6a47/RM5fU8gSVzAVp/zjb9HKXez9E4
         Z3L742gFIPxqySDIFnfb/YeccqqGTHUUvLcb6tHJOMC+VjM//9vBb+1PUmPL6cYDVbD6
         yUVR1grawSVZA2kBC/HUg+D+8aPgrGxHDv7chZEWY4Tl+d8MrQjJQP++sJSKqBH7yvPi
         MPEjEJbYLpJV5gKF79OaYOR2/Crxj1tVcsIfOy5oDpMd2VrYdEB2jy3Ga0ToS4CnozZS
         QOLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680575315;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=392+WT6GsxxrCIs2uzKVQ99rTrfrqzKvAPnhOs+mblM=;
        b=OnP3kpTXlRKnVoUh9qAWhCnZnfVTrIb2k8f/BglBpFfQRzrKqYPr4WwZhN+P750zZr
         D/a/r7qCwyL+MSzUr6uLT4CyvOwEr9NcN/0P8jaG60hcWXAt5YBWFHi5nyrxWSRf/clA
         NaG48Jytoh4uwNfusAJ/VjB8lSIvuF2foXX1GS59eC9Ut3lShLNEiyDbJdHsRmt+vk4i
         E+IZ43DFwp/tGeQd93kaMMfALeGxtm7jR6WjP4F146Eq0VfnKacJeYcsAO35We+P+o3m
         A6bQ/+NFFz4lp2IRHnK6w4m74U80eusMk1K+8nfzQmDXwugyDYIGo01GKioZMO6OcSUj
         HXtg==
X-Gm-Message-State: AAQBX9eawEtUY6Tde1xcLcrauEMQrji+u8KNF+cDLyL1dqAj4eHKkT0q
        SOzoTMYmE+lfSlKguI6tKXI=
X-Google-Smtp-Source: AKy350avaUffdyTBX5r4qF0MOAkFKuucFq93YFMoXeBGKm4VDlKVw3w+7yid8UQKAAmKhse7V26ZwQ==
X-Received: by 2002:a17:902:db07:b0:19c:c9da:a62e with SMTP id m7-20020a170902db0700b0019cc9daa62emr1216433plx.54.1680575315344;
        Mon, 03 Apr 2023 19:28:35 -0700 (PDT)
Received: from Laptop-X1 ([2409:8a02:782e:a1c0:2082:5d32:9dce:4c17])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902f7ca00b001994a0f3380sm7223666plw.265.2023.04.03.19.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 19:28:34 -0700 (PDT)
Date:   Tue, 4 Apr 2023 10:28:30 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Liang Li <liali@redhat.com>
Subject: Re: [PATCH net 2/3] selftests: bonding: re-format bond option tests
Message-ID: <ZCuLTjZjg7pZqO0X@Laptop-X1>
References: <20230329101859.3458449-1-liuhangbin@gmail.com>
 <20230329101859.3458449-3-liuhangbin@gmail.com>
 <301d2861-1390-eaea-4521-90d4dcfe7336@redhat.com>
 <ZCZGDQezuxXJuMd5@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCZGDQezuxXJuMd5@Laptop-X1>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 10:31:47AM +0800, Hangbin Liu wrote:
> > > +++ b/tools/testing/selftests/drivers/net/bonding/bond_lib.sh
> > 
> > I like this idea, we might want to separate network topology from library
> > code however. That way a given test case can just include a predefined
> 
> Would you like to help explain more clear? Separate network topology to where?


Hi Jon, would you please help explain this part?

Thanks
Hangbin

> 
> > topology. A quick review of the test cases show a 2 node setup is the most
> > common across all test cases.
> 
> Liang suggested that with 2 clients we can test xmit_hash_policy. In
> client_create() I only create 1 client for current testing. We can add more
> clients in future.
> 
> Thanks
> Hangbin
