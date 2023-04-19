Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE606E7D79
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 16:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbjDSOvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 10:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233512AbjDSOvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 10:51:54 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D49E199A
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 07:51:53 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-5066ce4f725so37279a12.1
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 07:51:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1681915912; x=1684507912;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xH5mzhSneujQGMrXg7dpT14eS2iHSAK01xqAN++H9tU=;
        b=OKyhACOpH2egX8agOeFATzbOuy+vhVxGKgPSO3rAmLS+YV/sYULlFn2+QBaUswDIX6
         X12asRD5IJCQbGMeoRkvrQFZvCXnW3HJXbv6OC+O+YcvM2hmBdPOaeZysPPY1XNAPIQX
         +wRXjLCbgHaNFVDls3oXG68lWfTHko+/H0AFWF88yEO7EJj9kpXih3SVtjHwFsYEIgeE
         5SlncfQy4/4jVDK8QvR/2DNT411pvdGWLg9h0tfSkUjkVithBXWZo3ROZJt9XT6M8QXA
         nVd/vbeZnaR57hXjKaGq8WCDsfdGyLYOyTdicCdSs1U4cMtdhNZllCejaZjHdwkQjA6g
         COxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681915912; x=1684507912;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xH5mzhSneujQGMrXg7dpT14eS2iHSAK01xqAN++H9tU=;
        b=EbMbTRow7uZcAEpiV5W3n2ZVZUAKb2WmjFSWUvto7d6d99/JmK/cSO+sEM4aVjGZIz
         k9aez+QPY3zlY9zAgxqfomn5B0Ol2UNezNEHbpa7pVHrteRb2ocX9Q8F8rYEE6dHvK1H
         BcEf6K042LuEhfl5VVWOLbJ8TqCpJ9OuyKVoRReP/H5kemaIDXgmNLyeiuaoMwGWV0+F
         vWeFIoyesb2A8l5CIMxPiAA16xIsLzkE2oq6oc8b9Y1vEGIjmFauMscUKEOOutB5iyaY
         SUeUOThcdRJ5YZohxK1i6vkzCP69DVm8QdCXCAtlKok15Kmr71tkzjCDsIfuSokjOWvx
         bv9Q==
X-Gm-Message-State: AAQBX9cshQw1BjXW/sWrhNcNwa3ZVxlk77Is9auTSpstrAiGCLZsBw9R
        4Mki3Pj38OxPIKBQUZ0OZjDyBvtwAwqfIe24
X-Google-Smtp-Source: AKy350ZzvYSVYWUm8NTMeLGsZrgkvfPNhIpbv96UCKScCvOchcM4SUk4l9pHoJC0Xk8aPvqPMv0UUA==
X-Received: by 2002:a05:6402:78f:b0:505:638:413c with SMTP id d15-20020a056402078f00b005050638413cmr5523576edy.18.1681915911528;
        Wed, 19 Apr 2023 07:51:51 -0700 (PDT)
Received: from tycho (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id u15-20020aa7d88f000000b005067d6b06efsm7078576edq.17.2023.04.19.07.51.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 07:51:50 -0700 (PDT)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
Date:   Wed, 19 Apr 2023 16:51:49 +0200
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hmehrtens@maxlinear.com,
        aleksander.lobakin@intel.com,
        Zahari Doychev <zdoychev@maxlinear.com>
Subject: Re: [PATCH net-next v3 2/3] net: flower: add support for matching
 cfm fields
Message-ID: <2slqz5vg3bxj6k3fkvrjeyyuur3uoqce7hcuuav3siqgsnccex@prvv3iixeavl>
References: <20230417213233.525380-1-zahari.doychev@linux.com>
 <20230417213233.525380-3-zahari.doychev@linux.com>
 <ZD/9YejX9YQsRwkH@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZD/9YejX9YQsRwkH@corigine.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 04:40:33PM +0200, Simon Horman wrote:
> On Mon, Apr 17, 2023 at 11:32:32PM +0200, Zahari Doychev wrote:
> > From: Zahari Doychev <zdoychev@maxlinear.com>
> > 
> > Add support to the tc flower classifier to match based on fields in CFM
> > information elements like level and opcode.
> > 
> > tc filter add dev ens6 ingress protocol 802.1q \
> > 	flower vlan_id 698 vlan_ethtype 0x8902 cfm mdl 5 op 46 \
> > 	action drop
> > 
> > Signed-off-by: Zahari Doychev <zdoychev@maxlinear.com>
> 
> ...
> 
> > +static int fl_dump_key_cfm(struct sk_buff *skb,
> > +			   struct flow_dissector_key_cfm *key,
> > +			   struct flow_dissector_key_cfm *mask)
> > +{
> > +	struct nlattr *opts;
> > +	int err;
> > +	u8 mdl;
> > +
> > +	if (!memchr_inv(mask, 0, sizeof(mask)))
> 
> Perhaps this should be sizeof(*mask)
> 
> With that fixed feel free to add,
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> 

Thanks, will do and resend.

...

