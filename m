Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9D74FCF38
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 08:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348547AbiDLGDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 02:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235458AbiDLGDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 02:03:06 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBBCA28E15
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 23:00:49 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id u2so964221pgq.10
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 23:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KqI76uagG8TfbgWoVVHSi61opyFfJzhPH5pe/dn2GZo=;
        b=jEt9xWmEYqeyTnmtQv1B7NtZaKyhuUtFrrj4lzszWXK4NufMn40pkQhcwkBI3EM4WL
         YEzY1e/gNcaMfSYu2uxirIVkWbRvYWDu6Gvzr7nmlshpvNTdpwAMEvmvSC6j3tYfsK+L
         1woItdQHUyqfZsTV6hj333ui0j5/GMeTdiQP4Tvn4W4RyN/XQvoeFc0GpdGml1tooqaH
         68nVKEjL5BtnhWujzUFD3t6khsTgjnnbpfjUbVA16e6F4wfm14niBHmiQ0B1tvH9/8bk
         SIM9NvSuB+q4+JPZ4MRJcqMldtpOEFsTgCkyu5OfY2XwpmLZ6cGEise2c0d+4/29D8pL
         BRAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KqI76uagG8TfbgWoVVHSi61opyFfJzhPH5pe/dn2GZo=;
        b=zCSkCv2iDp0in6gehDS0r0ObdBc3klQFb18Bd1AgrxXIxbhp1ANnkjnhbYl7Y4qzVE
         KYx3WdHPNGNXRwLA2rSallPIsvXF2HLGLJwZLMggMlsZ1irM3erpjTwz8EbNLh1XZNnx
         6jYQl8W0KmkJxllsnMPxF+Y9OIpf/OOlokaa5lNP+a4iu3ufyz2SGC31xQThBoJWQ/+8
         PZxcFKhydovbucMMFmho+9I7wsGREy4xH6OppnEDkbg2BnkErD9TbV0S34B7GbGwK06A
         mtayiFsnHiUd8DOsduoS+4zNnEAquEGXYx0mm7Sh7BNmS+gozOEmH1zmd5JPQpz8Qaqn
         IZ5A==
X-Gm-Message-State: AOAM532544Ia5jGaYEkXA2RFzRNkHMqwzIZfclze5vlbAdBmfSZENTBt
        eVJsSKi872zUktkLkkLicXw=
X-Google-Smtp-Source: ABdhPJy6jQzI+NgmwtgcgA6XZ7L2P6MhGbu40aUARQtZdrB2hQsPskJtfb3PbgSMsi0rarXeky6qvQ==
X-Received: by 2002:aa7:90d5:0:b0:4e1:307c:d94a with SMTP id k21-20020aa790d5000000b004e1307cd94amr36140529pfk.38.1649743249458;
        Mon, 11 Apr 2022 23:00:49 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id nl17-20020a17090b385100b001c70883f6ccsm1435130pjb.36.2022.04.11.23.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 23:00:48 -0700 (PDT)
Date:   Tue, 12 Apr 2022 14:00:41 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next] Bonding: add per port priority support
Message-ID: <YlUViUt0NQfZYgAG@Laptop-X1>
References: <20220412041322.2409558-1-liuhangbin@gmail.com>
 <11973.1649739345@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11973.1649739345@famine>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 09:55:45PM -0700, Jay Vosburgh wrote:
> Hangbin Liu <liuhangbin@gmail.com> wrote:
> 
> >Add per port priority support for bonding. A higher number means higher
> >priority. The primary slave still has the highest priority. This option
> >also follows the primary_reselect rules.
> 
> 	The above description (and the Subject) should mention that this
> apparently refers to priority in interface selection during failover
> events.

OK, will update it. How about:

Bonding: add per port priority for current slave re-selection during failover

Add per port priority support for bonding current re-selection during failover.
A higher number means higher priority in selection. The primary slave still
has the highest priority. This option also follows the primary_reselect rules.

> >@@ -117,6 +121,7 @@ static const struct nla_policy bond_policy[IFLA_BOND_MAX + 1] = {
> > 
> > static const struct nla_policy bond_slave_policy[IFLA_BOND_SLAVE_MAX + 1] = {
> > 	[IFLA_BOND_SLAVE_QUEUE_ID]	= { .type = NLA_U16 },
> >+	[IFLA_BOND_SLAVE_PRIO]		= { .type = NLA_S32 },
> 
> 	Why used signed instead of unsigned?
> 
> 	Regardless, the valid range for the prio value should be
> documented.

I did this in purpose as team also use singed number. User could use a
negative number for a specific link while other links keep using default 0.

BTW, how to document the valid ranger for a int number, -2^31 ~ 2^31-1 or
INT_MIN ~ INT_MAX.

Thanks
Hangbin
