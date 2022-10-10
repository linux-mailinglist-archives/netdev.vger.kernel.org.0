Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6150C5F9C4E
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 11:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbiJJJ5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 05:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbiJJJ5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 05:57:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10FC5F21F
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 02:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665395817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qEUa83HipRTO4aAhoNtLoSIs7ceIGkhT1Fj1jwGOpHk=;
        b=UL8XqNh1zLpKA5KjQGwhxYjETKxqBrfuDgGd1CnYUOTcDLh/zyttaNYwYQSgpxkp3vc1i6
        iucgJuhl+xCc5GLd+7PRWDTNiE8eWv+TM/3CYzzt/YovwYcVIBElk54aYltFDjic7XHeoK
        xDHZcgpIvEpycw2XHmG1mMyccT+imLM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-28-bO03Dd4TOwytMeXGM44bTg-1; Mon, 10 Oct 2022 05:56:51 -0400
X-MC-Unique: bO03Dd4TOwytMeXGM44bTg-1
Received: by mail-wm1-f72.google.com with SMTP id c3-20020a7bc843000000b003b486fc6a40so2953631wml.7
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 02:56:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qEUa83HipRTO4aAhoNtLoSIs7ceIGkhT1Fj1jwGOpHk=;
        b=pIvChxjWo4MQGQg2ugb9ebWUfgMuCa4vXy7nP6zOQ3YTISPA8U5g9BOhbUKDdhNvu/
         N2Fu81WkGpV0lrPvUCAWyMYNdzPmCnds6EFNoJAi05+W4qs+XECpmjZoNIwAAPa5PRuP
         ZKl8v39JAakGklNFQLPgCbQ85RE7UnXrYYelc+2HcTNUkYh5xv2YnbDZNG2j0n/gt9HW
         nfyzBtqQ8/XQhpibrtXHIciOhq+pvzmBuwcsg7mlgc1mTgd3ci3NlL469DaWFNM0MO0r
         E8KTUsJZ7JrISvWyNybPWVsZhoST3bxCQRpAZSUAWNElLgyUusYNQ10D0nqmjwcQkzIi
         YzwQ==
X-Gm-Message-State: ACrzQf3cNcM2olLOhka/qs+INdnx2lHQPlafJatgqVEgUZauF+TambKK
        aqYLP1YTwn2iaFHqeG0rDbl5h0EwMVv8JXM4VZLtPqNyM+sbB9jVkLJ5OhxQ9ucUjYyt3RNl8j8
        zg4Hy5IMR3siK7Y/K
X-Received: by 2002:a5d:5a18:0:b0:22f:4f72:213a with SMTP id bq24-20020a5d5a18000000b0022f4f72213amr6878632wrb.57.1665395809994;
        Mon, 10 Oct 2022 02:56:49 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM433FYGI8FP7Isu9a7tQilMCo+PxGRCkwbjKG09o/JkR0yJ5o40ZY2V9beVG4PmGMfS4c1STg==
X-Received: by 2002:a5d:5a18:0:b0:22f:4f72:213a with SMTP id bq24-20020a5d5a18000000b0022f4f72213amr6878611wrb.57.1665395809729;
        Mon, 10 Oct 2022 02:56:49 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id r1-20020a05600c35c100b003a84375d0d1sm15561178wmq.44.2022.10.10.02.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 02:56:49 -0700 (PDT)
Date:   Mon, 10 Oct 2022 11:56:45 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, stephen@networkplumber.org, sdf@google.com,
        f.fainelli@gmail.com, fw@strlen.de, linux-doc@vger.kernel.org,
        razor@blackwall.org, nicolas.dichtel@6wind.com,
        Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH net-next v2 1/7] docs: add more netlink docs (incl. spec
 docs)
Message-ID: <20221010095645.GA3551@localhost.localdomain>
References: <20220930023418.1346263-1-kuba@kernel.org>
 <20220930023418.1346263-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220930023418.1346263-2-kuba@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 07:34:12PM -0700, Jakub Kicinski wrote:
> +==============================
> +Netlink spec C code generation
> +==============================
> +
> +This document describes how Netlink specifications are used to render
> +C code (uAPI, policies etc.). It also defines the additional properties
> +allowed in older families by the ``genetlink-c`` protocol level,
> +to control the naming.
> +
> +For brevity this document refers to ``name`` properties of various
> +objects by the object type. For example ``$attr`` is the value
> +of ``name`` in an attribute, and ``$family`` is the name of the
> +family (the global ``name`` property).
> +
> +The upper case is used to denote literal values, e.g. ``$family-CMD``
> +means the concatenation of ``$family``, a dash character, and the literal
> +``CMD``.
> +
> +The names of ``#defines`` and enum values are always converted to upper case,
> +and with dashes (``-``) replaced by underscores (``_``).
> +
> +If the constructured name is a C keyword, an extra underscore is

s/constructured/constructed/

[...]

> +header
> +~~~~~~
> +
> +For C-compatible languages, header which already defines this value.
> +In case the definition is shared by multiple families (e.g. ``IFNAMSIZ``)
> +code generators for C-compabile languages may prefer to add an appropriate

s/C-compabile/C-compatible/

