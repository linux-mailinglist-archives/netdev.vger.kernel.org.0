Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6F44EE508
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 02:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243280AbiDAAMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 20:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbiDAAMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 20:12:13 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DD55EBD1
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 17:10:25 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id f23so2220751ybj.7
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 17:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vEokMkj72NuhB24rYanG62mFcOcH7Owq+UHZmqUgZMY=;
        b=cvgB9eFdWwReKAQ6Z4zSl9n5kGmBeHMrysnUa3KCQQbwwhmi75g71fydaV1AfHwW8o
         jE23ISxmFgViVmNukNKEQUEkVfNMuqAp7OnJW1e5s4G9VGiJkPKPelSYcKZeNswzKRru
         HTu3SIon5slPjzL0I2o36H/PPVAQzFxgWEXY1sh6zM7vFaKqGDh6Yrlrcq+gsWJgLl52
         SJdZbzBca5oodEKfv46J3zr9g1czNs4HmUhNHKQljjL1efi0IERM/qcItik+jRLLU1+m
         U6qYdAdOLqiYl5PCH8Uk4WfeARdU4ooiZxEFduBXgfjvUk3VTDCph7A9PriJzaS8cp5a
         AoCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vEokMkj72NuhB24rYanG62mFcOcH7Owq+UHZmqUgZMY=;
        b=xtNpp2J2xbLm/A3pAW43ZG556U601Ilu6pujRFLdlbfhKubXnqcInJ9qIm3Vse685+
         c91393/p89A9Sy/CguOPpTTKnAOFzpMnzeK5UHEZtqWp+kidbqBh79KALzb9YP+dqa4G
         PEeAgmerXm2RwrzuE4pzD/b6ktpjECJ0oGOZ+u+SYRDA2pYVR+cgz3Umz4fy4eTFt3IF
         xtB0NpspUTcwMQi6YB51O8wZif34K6zXi0gO2oMAKPhUIxGRPISmDlqg7ISXYxmPcsPB
         dOQSSjdPjjZmn8KNENAcJl+mSxQ1+Fc5WCV8HDO9DTymn/AIIguekjQMso9iEiwLqiBU
         +1EQ==
X-Gm-Message-State: AOAM532280zfzfIgQyagDwm0zE6RF8p5P5EMmdLJsAKCFO3o700R9Uu+
        MSV4pvbm7AOnhryOO3LKEj6FHKgckVE8g0ruPLwurg==
X-Google-Smtp-Source: ABdhPJwq+lSHV95usZHAMzoiT3tGMgn/2lk9paQDMVn/7x55gLLZbp0IdEV6gI0km/HugOTqTpKdaq+rjw8egUreigY=
X-Received: by 2002:a25:4003:0:b0:633:8ab5:b93e with SMTP id
 n3-20020a254003000000b006338ab5b93emr6345191yba.387.1648771824594; Thu, 31
 Mar 2022 17:10:24 -0700 (PDT)
MIME-Version: 1.0
References: <E1nZMdl-0006nG-0J@plastiekpoot> <CADVnQyn=A9EuTwxe-Bd9qgD24PLQ02YQy0_b7YWZj4_rqhWRVA@mail.gmail.com>
 <eaf54cab-f852-1499-95e2-958af8be7085@uls.co.za> <CANn89iKHbmVYoBdo2pCQWTzB4eFBjqAMdFbqL5EKSFqgg3uAJQ@mail.gmail.com>
 <10c1e561-8f01-784f-c4f4-a7c551de0644@uls.co.za> <CADVnQynf8f7SUtZ8iQi-fACYLpAyLqDKQVYKN-mkEgVtFUTVXQ@mail.gmail.com>
 <e0bc0c7f-5e47-ddb7-8e24-ad5fb750e876@uls.co.za> <CANn89i+Dqtrm-7oW+D6EY+nVPhRH07GXzDXt93WgzxZ1y9_tJA@mail.gmail.com>
 <CADVnQyn=VfcqGgWXO_9h6QTkMn5ZxPbNRTnMFAxwQzKpMRvH3A@mail.gmail.com> <5f1bbeb2-efe4-0b10-bc76-37eff30ea905@uls.co.za>
In-Reply-To: <5f1bbeb2-efe4-0b10-bc76-37eff30ea905@uls.co.za>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 31 Mar 2022 17:10:13 -0700
Message-ID: <CANn89i+KsjGUppc3D8KLa4XUd-dzS3A+yDxbv2bRkDEkziS1qw@mail.gmail.com>
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP connections
To:     Jaco Kroon <jaco@uls.co.za>
Cc:     Neal Cardwell <ncardwell@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 31, 2022 at 4:06 PM Jaco Kroon <jaco@uls.co.za> wrote:
>
> Hi Neal,
>
> This sniff was grabbed ON THE CLIENT HOST.  There is no middlebox or
> anything between the sniffer and the client.  Only the firewall on the
> host itself, where we've already establish the traffic is NOT DISCARDED
> (at least not in filter/INPUT).
>
> Setup on our end:
>
> 2 x routers, usually each with a direct peering with Google (which is
> being ignored at the moment so instead traffic is incoming via IPT over DD).
>
> Connected via switch to
>
> 2 x firewalls, of which ONE is active (they have different networks
> behind them, and could be active / standby for different networks behind
> them - avoiding active-active because conntrackd is causing more trouble
> than it's worth), Linux hosts, using netfilter, has been operating for
> years, no recent kernel upgrades.

Next step would be to attempt removing _all_ firewalls, especially not
common setups like yours.

conntrack had a bug preventing TFO deployment for a while, because
many boxes kept buggy kernel versions for years.

356d7d88e088687b6578ca64601b0a2c9d145296 netfilter: nf_conntrack: fix
tcp_in_window for Fast Open
