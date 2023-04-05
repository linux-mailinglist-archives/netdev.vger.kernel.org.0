Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721746D791D
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 11:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236804AbjDEJ6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 05:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237005AbjDEJ6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 05:58:32 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53BD65BA6
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 02:58:11 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id le6so33905040plb.12
        for <netdev@vger.kernel.org>; Wed, 05 Apr 2023 02:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680688683;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k9I0yRMdoO8x7olMmIuJiiPBtSp7pI+oOgNM7Q9C1XQ=;
        b=BGSu+W9XOpBLpTgmyehxwfkcmSytBSlB2LP/ib5VPdR6vrQGlD64pS3tRBYWfjYEia
         GavjOI0Tfl5SCfxUHOEC+nTb550ybL/lFBRk8Ljig6wjInNrg/kqg7WgCOf609xvt2AV
         bsP4WMc6wyOVWr2ETRqOy1tohShfGmms0//c50Per3VJd2auwU6jzOifRPCUuyvu6Bmp
         zGYeXtH3sL9es5A31OCSfjlO/saWQqAPyhEZesqpsA3ZCVnM89y2LtUF2zKwcML2qMUH
         oCxr8TBaYXFj6jFW/1HXdajwWsIdsWrUjoCGSjL/YZeG/gGtoooBAM06cYwchPkvPJ0K
         H0sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680688683;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k9I0yRMdoO8x7olMmIuJiiPBtSp7pI+oOgNM7Q9C1XQ=;
        b=fnkgD5T2xigqfoKqP/0AbIfzpK7+U2GxDpqipgaRFyvK0d+HQVt8mwc0UbZN2vWwpj
         eNul9leONkDuNLmF9iwaUdRYot/aASF2Iup8Q3biHs9VmtpsQxIKtg5PeqrpU0TUnltK
         DrOo1nnIitOpcn2X3/Sr5dTGN1fgCrepHJrcEi7xRkgSdHc/+zUYhhsV+KWWwWuKXXbx
         LNrEjegQjpBXP89xHbGQXdXJcE+RK3f1V+wTxNmMJwqQmMSq/uE0ox4jNtI8/qRhc7ft
         8K5Aeqs5SFwui4I4Zv6eNnWQI4jnFKLXrfpG/jaw7JR2bHT3Fzg1v8WflN7naAtbOH7M
         dKTQ==
X-Gm-Message-State: AAQBX9fV8s4vSMNfcwD4W8dyohysjJwaIWvssT1K8BwYfPyRBOJJHbTC
        NnJrNG5TjGzTkQc74DwgNlMRu2kQCAPk7w==
X-Google-Smtp-Source: AKy350YkZuvWLLcHftDsv+8xkrz3Ltg0X1P6rgkB1dF8sBr2fqRFFZMs/IwbkuDG6LV1kmVOD0uhiA==
X-Received: by 2002:a05:6a20:4914:b0:d9:162d:98e8 with SMTP id ft20-20020a056a20491400b000d9162d98e8mr4876454pzb.13.1680688683383;
        Wed, 05 Apr 2023 02:58:03 -0700 (PDT)
Received: from Laptop-X1 ([2409:8a02:782e:a1c0:2082:5d32:9dce:4c17])
        by smtp.gmail.com with ESMTPSA id u4-20020a62ed04000000b005a84ef49c63sm10173067pfh.214.2023.04.05.02.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 02:58:02 -0700 (PDT)
Date:   Wed, 5 Apr 2023 17:57:54 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Liang Li <liali@redhat.com>
Subject: Re: [PATCH net 2/3] selftests: bonding: re-format bond option tests
Message-ID: <ZC1GInfrzuZ8Rj8p@Laptop-X1>
References: <20230329101859.3458449-1-liuhangbin@gmail.com>
 <20230329101859.3458449-3-liuhangbin@gmail.com>
 <301d2861-1390-eaea-4521-90d4dcfe7336@redhat.com>
 <ZCZGDQezuxXJuMd5@Laptop-X1>
 <ZCuLTjZjg7pZqO0X@Laptop-X1>
 <ec1b7951-2890-9603-dce3-5623de4b814d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec1b7951-2890-9603-dce3-5623de4b814d@redhat.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 12:34:03PM -0400, Jonathan Toppins wrote:
> > > > I like this idea, we might want to separate network topology from library
> > > > code however. That way a given test case can just include a predefined
> > > 
> > > Would you like to help explain more clear? Separate network topology to where?
> > 
> > 
> > Hi Jon, would you please help explain this part?
> 
> Thanks for the ping. It looks like several test cases build largely the same
> virtual network topology and then execute the test case. I was attempting to
> point out that it might be better to provide a standard network topology and
> then each test case utilizes this standard topology instead of each test
> case rolling its own. Also, with my comment about separating out the
> topology from library code I was accounting for the ability to support
> multiple topologies, fe:
> 
>  bond_lib.sh
>  bond_topo_gateway.sh
>  bond_topo_2.sh
> 
> Then a given test case only includes/sources `bond_topo_gateway.sh` which
> creates the virtual network.

Thank Jon, this is much clear to me now. I'm not good at naming.
For topology with 2 down link devices, 1 client, I plan to name it
bond_topo_2d1c.sh. So 3 down links devices, 2 clients will be
bond_topo_3d2c.sh. If there is no switch between server and client, it could
be bond_topo_2d1c_ns.sh.

I'm not sure if the name is weird to you. Any comments?

Thanks
Hangbin
