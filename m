Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6474D25E6
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 02:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbiCIBOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 20:14:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbiCIBMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 20:12:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7DC1F156795
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 16:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646787311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T3YlkzGJk2287R66yfIoh7bh71PvFD9B+joUPjBFIVo=;
        b=MB9zMT5LEsPMyTBivIRZJanhGRU133ZGz85QMERzjp9UFpwxA0N0Dn/zZCTBOP7fhqZn3D
        p0qH5W2maaPGiGjDi+/XY1opUxHMRvP/pGKT9Y4Xb+bk1mqrpzFkRPkPOKvaN+y3rGxC2Y
        yj9lf+hzN3oiy6pkhERhlCrt5h7j/jE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-217-q3HVg0F9NCCE4xQcT0LVxw-1; Tue, 08 Mar 2022 19:55:10 -0500
X-MC-Unique: q3HVg0F9NCCE4xQcT0LVxw-1
Received: by mail-wr1-f69.google.com with SMTP id n4-20020a5d4844000000b001f1ed76e943so165988wrs.22
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 16:55:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=T3YlkzGJk2287R66yfIoh7bh71PvFD9B+joUPjBFIVo=;
        b=4FxI8xwawn8PWIu8tz5ZNumJTLr0Dyo5mbzHaHyYzZbrwzpM31dvZG1skd4y9GBgzi
         ke0vBNzbTmKacjSYGcKJnPp9XPd1uveMBJJvICgjGQWChnxxnn7r0UMrsO2K+tCv4OUZ
         8CVZd6DstjfoABUthX/A2/MWcbGpyyvBSHhnxiu2VbK88fWKUoWje0Tw1hH1gSkcoA90
         3JJ1tW6f1TXDRRB3ab87DuSl5lfcm8e074Fjg/GOusRSsKvQwlW147Mhy0IsWriZvnp/
         N3EbRyqvo0sUtFKUizL8Kvx/JiAeG2kPdOTMPl/Q9adJ5+o2nb2Tf57/hvqeCgXj9GnJ
         FqfA==
X-Gm-Message-State: AOAM531i8EWhtYZUb+yBK59TKSaMBV2Dsh2whJ4EYkpWXmdM4Nqh56IL
        UXvepbQGTc+VgGYQx+M6I8A3qaOLInEa3b1LCMPev1vxpLU33NjIRElRP6cL3/KimGX7waRF6kO
        Fzo0yXhF8vm5rV2WT
X-Received: by 2002:adf:f1cb:0:b0:1f0:62ff:bd0 with SMTP id z11-20020adff1cb000000b001f062ff0bd0mr14336972wro.53.1646787309288;
        Tue, 08 Mar 2022 16:55:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxp8WCSyZf+briMlrlT/Pl7DcNGO0h6iRzHahLzjVQyuMxcgGndnChHzmOD/BqGfW84ygCLrA==
X-Received: by 2002:adf:f1cb:0:b0:1f0:62ff:bd0 with SMTP id z11-20020adff1cb000000b001f062ff0bd0mr14336955wro.53.1646787308963;
        Tue, 08 Mar 2022 16:55:08 -0800 (PST)
Received: from debian.home (2a01cb058d3818005c1e4a7b0f47339f.ipv6.abo.wanadoo.fr. [2a01:cb05:8d38:1800:5c1e:4a7b:f47:339f])
        by smtp.gmail.com with ESMTPSA id 7-20020a05600c228700b00389865c646dsm385606wmf.14.2022.03.08.16.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 16:55:08 -0800 (PST)
Date:   Wed, 9 Mar 2022 01:55:06 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net 0/2] selftests: pmtu.sh: Fix cleanup of processes
 launched in subshell.
Message-ID: <20220309005506.GA1708@debian.home>
References: <cover.1646776561.git.gnault@redhat.com>
 <36d7619f-0fb4-e23b-2d2b-e0d27fd517ee@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36d7619f-0fb4-e23b-2d2b-e0d27fd517ee@linuxfoundation.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 04:51:46PM -0700, Shuah Khan wrote:
> On 3/8/22 3:14 PM, Guillaume Nault wrote:
> > Depending on the options used, pmtu.sh may launch tcpdump and nettest
> > processes in the background. However it fails to clean them up after
> > the tests complete.
> > 
> > Patch 1 allows the cleanup() function to read the list of PIDs launched
> > by the tests.
> > Patch 2 fixes the way the nettest PIDs are retrieved.
> > 
> > v2:
> >    * Use tcpdump's immediate mode to capture packets even in short lived
> >      tests.
> >    * Add patch 2 to fix the nettest_pids list.
> > 
> > Guillaume Nault (2):
> >    selftests: pmtu.sh: Kill tcpdump processes launched by subshell.
> >    selftests: pmtu.sh: Kill nettest processes launched in subshell.
> > 
> >   tools/testing/selftests/net/pmtu.sh | 21 +++++++++++++++++----
> >   1 file changed, 17 insertions(+), 4 deletions(-)
> > 
> 
> Both of these look good to me. One nit on commit header. Please
> include net in the patch subject line in the future.
> 
> e.g: selftests:net pmtu.sh

Thanks, I'll do that next time (I just reused keywords used by other
commits for this file).

> Tested them on my system. Seeing these messages even after building
> nettest:
> 
> 'nettest' command not found; skipping tests
>   xfrm6udp not supported
> TEST: vti6: PMTU exceptions (ESP-in-UDP)                            [SKIP]
> 'nettest' command not found; skipping tests
>   xfrm4udp not supported
> TEST: vti4: PMTU exceptions (ESP-in-UDP)                            [SKIP]
> 'nettest' command not found; skipping tests
>   xfrm6udprouted not supported
> TEST: vti6: PMTU exceptions, routed (ESP-in-UDP)                    [SKIP]
> 'nettest' command not found; skipping tests
>   xfrm4udprouted not supported
> 
> Might not be related to this patch though. I jusr ran pmtu.sh from
> net directory.

Personally I just modified my PATH before running pmtu.sh. Not sure if
there's a better way. But in any case, that's not related to this
patch.

> Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
> 
> thanks,
> -- Shuah
> 

