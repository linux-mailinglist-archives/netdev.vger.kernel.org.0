Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92D985EF987
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 17:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbiI2Pwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 11:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235150AbiI2Pwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 11:52:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796AC1C00E8
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 08:52:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664466754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kuiqZx/RAnUtiGssVG4E5Z1MJ/WsbTPAOEY4LpM4ulk=;
        b=FS7f5f7BfQvyFKZn3Az+KW9H1yjI5DqgnPAqaJ2+bmchT6uzt+4FAZQ5fmtVz5bDfQ0tip
        ZMBEtMZU7/Ox/5erfDMWabSKMUP1SPxJrKBZdJEZhJpsdMyeremM9aGr4f2Lb5AcImkO6L
        uLtST7MphxlTDNagdVxd3UBMNnG4bL0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-152-EE-Y_c9zPkarDlDOzLvkHw-1; Thu, 29 Sep 2022 11:52:33 -0400
X-MC-Unique: EE-Y_c9zPkarDlDOzLvkHw-1
Received: by mail-wr1-f72.google.com with SMTP id g27-20020adfa49b000000b0022cd5476cc7so694697wrb.17
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 08:52:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=kuiqZx/RAnUtiGssVG4E5Z1MJ/WsbTPAOEY4LpM4ulk=;
        b=CQgTlW8tWlLy/tQEbQPH/a+CbUijAkZrUWh8WCDCCSPCIrWy8BmdOu1vWz3Kl4TIUS
         4Ku2WZWx+dFqCOAjDDlJRaTtFbmW4LELN23WKlfN226IUJZEJWgJFbbg22P3SNE5QcHE
         SF6fnJljavExN7PTAzqugT6TqSQbzu2rWr+8KfDuJMP8GLsKQVIFBu7c2CoqZpjJ92HD
         87nAqaYVNsSbt9+jyaDPXqrt1WUXtbcmNc+UWq9b8ELohfBBnVzHGeo5oSmJk9IJqIyZ
         OFyojNbkqxlN9593bBFInCTnDpJ0g9yNFQxfsqamMdNHQEAvmdspjlkbp5cyQzbZXbkH
         EGdA==
X-Gm-Message-State: ACrzQf1aD1KZRsef8tx18IdOzA5BTjapH42kuwcTqXc3yQEY5JuvIM5i
        afDEfJjxEkITMf05Vl9r1u9FWgew1GdsZFWBQ3J4/3EoxPhG7GedX64Bo+fC+C45OJ5N55mj3CG
        v854NwAueFOukHRF+
X-Received: by 2002:adf:eb84:0:b0:22a:917e:1c20 with SMTP id t4-20020adfeb84000000b0022a917e1c20mr2840514wrn.223.1664466751969;
        Thu, 29 Sep 2022 08:52:31 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7gNjnJCeI69D5fzgrTmBRuaYmQV7KqBU5sZU7OmM1ftH2fvCIyYE24OYjtg5gKAYHFQgrHHw==
X-Received: by 2002:adf:eb84:0:b0:22a:917e:1c20 with SMTP id t4-20020adfeb84000000b0022a917e1c20mr2840500wrn.223.1664466751743;
        Thu, 29 Sep 2022 08:52:31 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id f13-20020a056000128d00b0022afcc11f65sm6996484wrx.47.2022.09.29.08.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 08:52:31 -0700 (PDT)
Date:   Thu, 29 Sep 2022 17:52:28 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, stephen@networkplumber.org, sdf@google.com,
        f.fainelli@gmail.com, fw@strlen.de, linux-doc@vger.kernel.org,
        razor@blackwall.org, nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next 1/6] docs: add more netlink docs (incl. spec
 docs)
Message-ID: <20220929155228.GD6761@localhost.localdomain>
References: <20220929011122.1139374-1-kuba@kernel.org>
 <20220929011122.1139374-2-kuba@kernel.org>
 <20220929133413.GA6761@localhost.localdomain>
 <20220929073224.2f3869ca@kernel.org>
 <20220929151145.GC6761@localhost.localdomain>
 <20220929084715.3c9626f7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929084715.3c9626f7@kernel.org>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 08:47:15AM -0700, Jakub Kicinski wrote:
> Folded it a little bit:
> 
> diff --git a/Documentation/core-api/netlink.rst b/Documentation/core-api/netlink.rst
> index 2a97f765d0d2..7b98dd48a6af 100644
> --- a/Documentation/core-api/netlink.rst
> +++ b/Documentation/core-api/netlink.rst
> @@ -37,15 +37,15 @@ added whether it replies with a full message or only an ACK is uAPI and
>  cannot be changed. It's better to err on the side of replying.
>  
>  Specifically NEW and ADD commands should reply with information identifying
> -the created object such as the allocated object's ID.
> -
> -Having to rely on ``NLM_F_ECHO`` is a hack, not a valid design.
> +the created object such as the allocated object's ID (without having to
> +resort to using ``NLM_F_ECHO``).
>  
>  NLM_F_ECHO
>  ----------
>  
>  Make sure to pass the request info to genl_notify() to allow ``NLM_F_ECHO``
> -to take effect.
> +to take effect.  This is useful for programs that need precise feedback
> +from the kernel (for example for logging purposes).

That's very clear, thanks!

