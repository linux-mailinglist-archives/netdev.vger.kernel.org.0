Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 691E564E87F
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 10:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbiLPJKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 04:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiLPJKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 04:10:05 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02F92601
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 01:10:02 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id o15so1380840wmr.4
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 01:10:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=P8eYGypynwuSZvymIkv4JxKVVgzxIbmPSqNbkFiO//s=;
        b=kaKBRPJIzEXpqxeJzsLVye+Li/upkazS9TTWfZVVfVBmWW/JlNg/TS8ByxDCZaCGKA
         I3QKWcSRfIQr9vjnI8QH8VfUjcoy5MDbl282iRc2uBlFNAEKCJZaDX9E5BDrdMuEWsj2
         F6hQzv+dG9vrzqPzL9ixEpZ5x7XIF+gR/TVD9KeWpDVVqNuUDzTTq8a4T0H6Nv+SZB+T
         XzP21JbAsgguFYSRWYuhZN24KjEd32hHvB7NtGINIMxQlxeHlye7a1fWQyWZi4vPsyAS
         O4wLsOz7Pdfdo4fKBlFCFzM3xU3SIHqdZ5dqkqloilDzBBWjti9h9n0iboociRaziZmD
         B0ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P8eYGypynwuSZvymIkv4JxKVVgzxIbmPSqNbkFiO//s=;
        b=NMhIt6z1qoXZYUEQxM9OrRtFMzAJCHoQ9lE3TecrxG1MQMfDVw44Xv6OFYImiBlzy/
         0dZn9VCAU9UVAaIWYtGJpz+1/CPXkkS91S97d4d68DdWLSEOPWxaPJEhULOM3IQAkojk
         tf+nBJRR4IA/B23p33FWFqvEbEVI9pHhFPzDqJDKrAdax53LMpAnb8Y+LKHWzssrzVmO
         uBU6kyazjJCsKkMoETpdqlt8FYGg6SlMq/VMlY7WE97qGodYinvR+O++OjV8NnfZgUEs
         TDeCyQqKn9Oc1fuaLR+LzaK4Ul3mZbbUsQ/GV4N0DYsDVG5YQJPK2/u1R105TYZKcofn
         oHcQ==
X-Gm-Message-State: AFqh2kq81impGliuqWpysSyUlP4nwnupWcYyrLJZ9CA9D0PGPBxIQ8aB
        AREiNwhTiYbWkuG29xItplsFxQ==
X-Google-Smtp-Source: AMrXdXvUKiqnh4Vqj5KqbJC6WqMYE5A5F7LjSo/Ve6vV2VF6chY9eQOtjRXOIKEfQYfwGyK2KA6G9A==
X-Received: by 2002:a1c:ed18:0:b0:3d3:4406:8a3a with SMTP id l24-20020a1ced18000000b003d344068a3amr2058713wmh.30.1671181801200;
        Fri, 16 Dec 2022 01:10:01 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id i27-20020a05600c4b1b00b003d220ef3232sm1765715wmp.34.2022.12.16.01.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 01:10:00 -0800 (PST)
Date:   Fri, 16 Dec 2022 10:09:58 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        leon@kernel.org
Subject: Re: [RFC net-next 01/15] devlink: move code to a dedicated directory
Message-ID: <Y5w15tZ68q/Sjap1@nanopsycho>
References: <20221215020155.1619839-1-kuba@kernel.org>
 <20221215020155.1619839-2-kuba@kernel.org>
 <Y5ruLxvHdlhhY+kU@nanopsycho>
 <20221215110925.6a9d0f4a@kernel.org>
 <c7c98e4a-5f41-2095-c500-c141ea56a21a@intel.com>
 <20221215114829.5bc59d7a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215114829.5bc59d7a@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Dec 15, 2022 at 08:48:29PM CET, kuba@kernel.org wrote:
>On Thu, 15 Dec 2022 11:29:02 -0800 Jacob Keller wrote:
>> >> What's "basic" about it? It sounds a bit misleading.  
>> > 
>> > Agreed, but try to suggest a better name ;)  the_rest_of_it.c ? :)
>> 
>> I tried to think of something, but you already use core elsewhere in the
>> series. If our long term goal really is to split everything out then
>> maybe "leftover.c"? Or just "devlink/devlink.c"
>
>leftover.c is fine by me. Jiri?

If the goal is to remove the file entirely eventually, I'm okay with
that.

