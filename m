Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6BEF6D4C0D
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 17:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbjDCPhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 11:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbjDCPhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 11:37:32 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8FF26A2
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 08:37:30 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id j18-20020a05600c1c1200b003ee5157346cso20131525wms.1
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 08:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680536249;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Jonmd3bIPei401bTchpqA8IWRHDAq4WrYXykU1XBUeQ=;
        b=as/fU8s82FWOd/gCRBtvY6AFMwO6nKMJJQFRlQISNB9Q518HqhyvVqL+339zARkIoO
         s7Dr6w5G/7My+DkacTP1Dt+JF10QD5gSYnuC/i6aQ5TE6Jq6WHfKg+WtLBV1yA5P70ay
         f6vEA1B5Qana18ftVQe+ij96AR8NWK0mG0T3WGmq0u/OOT3EHhUXNyjFRyZfAylxI41L
         ZKqTpfpd7O//mcJ7X61ktrKIo1EXaicgqO6dBHiwLEJe0bwikUJmP5PpqqIGlBPkG8A9
         A7gMMpl4I8FO3jf+Xv8XDEFNUbPUNfd4PJA74MF8QCTcPqxy9/Dljd3JtZwzpnTVhwrf
         7iIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680536249;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jonmd3bIPei401bTchpqA8IWRHDAq4WrYXykU1XBUeQ=;
        b=syev2aao5oxx7LK4Lt0OhffkFnCBKPyesE2lBlDEVAemPZdSTAhV6XtH8ePXDxnSsM
         SXzGz4s5ws3DtDwmACxG4vwBG4+cHp6mIhvIZM5P33ded0+VOzc3OdAdxfSisPMNZRSl
         HWHypnZkFZQuD3OB9V/mGdekfUKZF7P6sXY8qdz/rLT4OiVc1j7/VSq1KuqE0YSawY1L
         6wS61OeP/3YAaj3lKayjpliy6vlLQB8UINjt3yNR+/KXjX1bxdHvGTde2vi9vEHth2eK
         1xHSathSkNkPFkSkyJOzJ9wZF6sVSDxjata5HEpny5ugeG5KQaUwC59/iGWAxZjdSa/U
         L2lA==
X-Gm-Message-State: AO0yUKVTdmDkrvlWStwhC2r6a/Q1eDqrXoV01pcxfj0PHOF4LsPTkEdy
        RS+8Nlw2c1/IRpqkTTfNgwub+hcLDjJFtGz2
X-Google-Smtp-Source: AK7set9qOf5a9BgEVNo7UZWwMeId8KkZvXkXr1wvxEgR1EvmWlh+ysTeuU7xT9XBDWzMYvdbTqRFYA==
X-Received: by 2002:a05:600c:2118:b0:3eb:39e0:3530 with SMTP id u24-20020a05600c211800b003eb39e03530mr25330310wml.41.1680536249061;
        Mon, 03 Apr 2023 08:37:29 -0700 (PDT)
Received: from tycho (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id r1-20020a5d4941000000b002cfefa50a8esm9985868wrs.98.2023.04.03.08.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 08:37:28 -0700 (PDT)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
Date:   Mon, 3 Apr 2023 17:37:27 +0200
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hmehrtens@maxlinear.com,
        aleksander.lobakin@intel.com,
        Zahari Doychev <zdoychev@maxlinear.com>
Subject: Re: [PATCH net-next v2 2/2] selftests: net: add tc flower cfm test
Message-ID: <jw3mflicimyyutn5ntlbz2dldb5f4wplsdixihl7kajcsl2cqo@iqd7elyljbzl>
References: <20230402151031.531534-1-zahari.doychev@linux.com>
 <20230402151031.531534-3-zahari.doychev@linux.com>
 <ZCrVS0aDDx831JCY@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCrVS0aDDx831JCY@corigine.com>
X-Spam-Status: No, score=0.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 03:31:55PM +0200, Simon Horman wrote:
> On Sun, Apr 02, 2023 at 05:10:31PM +0200, Zahari Doychev wrote:
> > From: Zahari Doychev <zdoychev@maxlinear.com>
> > 
> > New cfm flower test case is added to the net forwarding selfttests.
> > 
> > Signed-off-by: Zahari Doychev <zdoychev@maxlinear.com>
> 
> ...
> 
> > +	tc_check_packets "dev $h2 ingress" 103 1
> > +	check_err $? "Did not match on corret level"
> 
> Hi Zahari,
> 
> if you need to repost for some reason you may consider
> correcting the spelling of 'corret'.

thanks, I will correct it.

> 
> ...
