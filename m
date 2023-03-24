Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E31AE6C7AE5
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjCXJLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231920AbjCXJLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:11:06 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2436B211E1
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 02:10:48 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id v4-20020a05600c470400b003ee4f06428fso503608wmo.4
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 02:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679649044;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SR8MpC4xKS8A77LH1pmOpXtOhyYmJ45YkVYHeV2bZQw=;
        b=KeS3cJxNh6bvu7VIokXZTFrIbzr58giAtKc9xQzVc11bEDUdvU8h94NaBDWHe4TTDi
         TxRw2WWs6RFoPnWExkATHg6dzDO7P/8vLb8GiGJfJICgGkpq8I+HdcADN6hUJQ5uLigT
         BwbKrNkW0/AqWU6DwwqDEA6EFxh/3mHSc7wxitm18KSsKwvlCjRMB5OIUJOaAArysSJL
         yyGrHW4TUgVNTwNjZJNnc726bPW5puWpYMNxSx0/W6byRhdVFh1b/1wDyJlNBIAbgK+v
         1gxLitvet8QJJBwQUKSrsBHJc7sXonZzTcG08uJBimqIMh7ehza/Y96jqa7881lwYLdx
         k38w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679649044;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SR8MpC4xKS8A77LH1pmOpXtOhyYmJ45YkVYHeV2bZQw=;
        b=Ic00px9nrnBE9llmDkLBvciDUcVA5/hsZr7vF5jU9vgc7j0VdctiRV2dCP/SNyQMG5
         Hw6ZsD2ypQBM7XPYyc1YRXyI75Bn7fTf/ppdP/WFQedICJkjOpdt0dNswZNOdqbqRxqV
         ttGNkv1mjYxOJmIM/rWMrm8setLxhYwHzpE745h4XS8n33elg70DaumKYFMG/bof1STn
         CgN1+4gWt6nxTxEEyheu0lgZz1pRjAESW+6t9H5eN+9mL18dpUX7UdCC5UppMtjQsQrg
         QncxbNElza5pBIkktvYjN2CxVe5d67UPg864Gs09kkOHnwL7mdjDSLBgndhI8laZ8WJ6
         bBRg==
X-Gm-Message-State: AO0yUKWjqvPhkzKz342GvQ6SXaQBLy9ZjvM6IngRmE8NJ84YxeMBBGfw
        JthMq3ctvb6fICmTxJ1160g=
X-Google-Smtp-Source: AK7set8xtXejGOCHoZW/8xYSbjkbay8Dl8KXaDo6SKE2qf3MT7tPB7wPj99cV05tUOb9RcIp+x0Edg==
X-Received: by 2002:a7b:c4ce:0:b0:3eb:4162:7344 with SMTP id g14-20020a7bc4ce000000b003eb41627344mr2027932wmk.22.1679649044572;
        Fri, 24 Mar 2023 02:10:44 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id c26-20020a7bc01a000000b003ee44b2effasm4309290wmb.12.2023.03.24.02.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 02:10:44 -0700 (PDT)
Date:   Fri, 24 Mar 2023 09:10:41 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, Edward Cree <ecree.xilinx@gmail.com>,
        netdev@vger.kernel.org, michal.swiatkowski@linux.intel.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 5/6] sfc: add code to register and unregister
 encap matches
Message-ID: <ZB1pEVNGn1fKTGDG@gmail.com>
Mail-Followup-To: edward.cree@amd.com, linux-net-drivers@amd.com,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        michal.swiatkowski@linux.intel.com,
        Jakub Kicinski <kuba@kernel.org>
References: <cover.1679603051.git.ecree.xilinx@gmail.com>
 <57c4e599df3fff7bf678c1813445bd6016c6db79.1679603051.git.ecree.xilinx@gmail.com>
 <20230323220530.0d979b62@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323220530.0d979b62@kernel.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 10:05:30PM -0700, Jakub Kicinski wrote:
> On Thu, 23 Mar 2023 20:45:13 +0000 edward.cree@amd.com wrote:
> > +__always_unused
> > +static int efx_tc_flower_record_encap_match(struct efx_nic *efx,
> > +					    struct efx_tc_match *match,
> > +					    enum efx_encap_type type,
> > +					    struct netlink_ext_ack *extack)
> > +{
> > +	struct efx_tc_encap_match *encap, *old;
> > +	bool ipv6;
> > +	int rc;
> 
> clang sayeth 
> 
> drivers/net/ethernet/sfc/tc.c:414:43: warning: variable 'ipv6' is uninitialized when used here [-Wuninitialized]
>         rc = efx_mae_check_encap_match_caps(efx, ipv6, extack);
>                                                  ^~~~
> drivers/net/ethernet/sfc/tc.c:356:11: note: initialize the variable 'ipv6' to silence this warning
>         bool ipv6;
>                  ^
>                   = 0

If CONFIG_IPV6 is unset it is never used, to is needs a __maybe_unused
as well.

Martin

