Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE14538DAE
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 11:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245175AbiEaJ1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 05:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241523AbiEaJ1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 05:27:01 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C5C1A071
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 02:26:59 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id gd1so5041757pjb.2
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 02:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QlNwcLAtK9Wf4a5JvqdT8rjT05vWHV8epHTseF/hcbg=;
        b=YaVtzo7D/BbCgcAPuR8S7xs0o9W5XyfKgVGEOZQiyAJYQCICyCAZ2FV7u8f13kFUfB
         Rg5LEdzJlFPNxf64u4wG+snCbRqgoCqxshI4P3bHWV2SM7UVEv8JsgPgVgXhTTZyiHt9
         4xDg/MClrvjV9/CpIe53rFY7RybahbDOapFm5jBNLccyKXZFAYypmBht0o2aLKmcikgc
         U9ybxGs7odI59GkGJDJvd8GhEH1lEO75t18WpMsOMFz6TI3Qz8FMDx8NXyDFvVH62EwY
         7NXhzQW5Fi4pnoWCKsa5Kl0/6gLDRhSzm3fBKKaAmvQXJiAXqfKDeyHvSUFPkKgOFxKh
         b36g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QlNwcLAtK9Wf4a5JvqdT8rjT05vWHV8epHTseF/hcbg=;
        b=p3Wmt6TZXfAK5qTs/soEpTOY9LHsvmkacKppMTS2XDmu7zJUAWRVFv1HdP9JCeF8EC
         7OXKvzAS/5zny7QoI9YoC4de630ESrXMjuEoIEnLQ9qRzmhvXpZM5BjDD5cCG6MUtEDr
         2ji1J4XTOIjrhV6gSQ8Slvnre0zirX3AKKw1PMYjo4xIjmuHVXFAJ84P1NZ+f6pRd+aF
         CmNdqgjp1eqBh88MD+SkdbFSlHuS3ss4foXUwJVqM1kvDpSz9F2/oCLN++PchHjYzWPj
         Ygvi7IU/ibuY3i6AsODp2/mZKPZT3YGm5R3icJ96sJAmGNko6sn7rgasipngR8sYiVXN
         66rA==
X-Gm-Message-State: AOAM533jyXJBQolcIBdsRatdRRHciCZwZ+bntxJrwn1l0C64b2xNSkmF
        HFvQ6RPXE52jo2YyhwWPBsAP03AYQEitFw==
X-Google-Smtp-Source: ABdhPJyT1vXBldHkj56m4YMnfye1hsvLj/aMeq+oGx0OUYGqT3ghsLGFHgMugMxOvbusEm90FACDQg==
X-Received: by 2002:a17:902:ecc3:b0:161:eda6:1e8d with SMTP id a3-20020a170902ecc300b00161eda61e8dmr53832462plh.108.1653989218964;
        Tue, 31 May 2022 02:26:58 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t18-20020a1709028c9200b0016160b33319sm10547522plo.246.2022.05.31.02.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 02:26:57 -0700 (PDT)
Date:   Tue, 31 May 2022 17:26:50 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Jonathan Toppins <jtoppins@redhat.com>, netdev@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next] Bonding: add per port priority support
Message-ID: <YpXfWrdIxspEsCPl@Laptop-X1>
References: <20220412041322.2409558-1-liuhangbin@gmail.com>
 <1d6de134-c14e-4170-d2ad-873db62d8275@redhat.com>
 <20134.1649778941@famine>
 <Yl07fecwg6cIWF8w@Laptop-X1>
 <YmKCPSIzXjvystdy@Laptop-X1>
 <YnTYUmso0D29CDcg@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnTYUmso0D29CDcg@Laptop-X1>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 06, 2022 at 04:12:02PM +0800, Hangbin Liu wrote:
> On Fri, Apr 22, 2022 at 06:24:05PM +0800, Hangbin Liu wrote:
> > On Mon, Apr 18, 2022 at 06:20:52PM +0800, Hangbin Liu wrote:
> > > > 	Agreed, on both the comment and in regards to using the extant
> > > > bonding options management stuff.
> > > > 
> > > > >Also, in the Documentation it is mentioned that this parameter is only
> > > > >used in modes active-backup and balance-alb/tlb. Do we need to send an
> > > > >error message back preventing the modification of this value when not in
> > > > >these modes?
> > > > 
> > > > 	Using the option management stuff would get this for free.
> > > 
> > > Hi Jav, Jon,
> > > 
> > > I remembered the reason why I didn't use bond default option management.
> > > 
> > > It's because the bonding options management only take bond and values. We
> > > need to create an extra string to save the slave name and option values.
> > > Then in bond option setting function we extract the info from the string
> > > and do setting again, like the bond_option_queue_id_set().
> > > 
> > > I think this is too heavy for just an int value setting for slave.
> > > As we only support netlink for new options. There is no need to handle
> > > string setting via sysfs. For mode checking, we do just do like:
> > > 
> > > if (!bond_uses_primary(bond))
> > > 	return -EACCES;
> > > 
> > > So why bother the bonding options management? What do you think?
> > > Do you have a easier way to get the slave name in options management?
> > > If yes, I'm happy to use the default option management.
> > 
> > Hi Jay,
> > 
> > Any comments?
> > 
> 
> Hi Jay,
> 
> I'm still waiting for your comments before post v2 patch. Appreciate if you
> could have a better way about handling the slave name in options management.

Hi Jay, ping?
