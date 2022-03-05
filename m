Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F39FB4CE692
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 20:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbiCETdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 14:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231192AbiCETda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 14:33:30 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C6EB78
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 11:32:39 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id p17so10532290plo.9
        for <netdev@vger.kernel.org>; Sat, 05 Mar 2022 11:32:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3lACy8kbH5e46DsTT/OtxwWn/dnxl9hVaFrhjhiwNtk=;
        b=UngYwJe4RSjvzBLgkFZl9znKSnmCeUIdGIRIb2d9JF5VzNAyk8mwc8GmEUBZBpnDOY
         iGwSi5RGi1B6cnk++sYLreb8QH4sKX+phxkvTToXYtuXDy9Z4uIe9WW40FPmS3qDaD3a
         uGz8UeW02rcrG/iYGOzetpFlh8M7BlMoQ+MQbr6Itrmgp8XnNteMhpRhTow4a1ZCDis+
         V94UPUl4DO9nM2DRhMODoEc7d/VdugEb/OVQzfUqAsz3+s+7Cxwal9EYmTpo3/rsIB8w
         lGolQ9NImBris++CGTufd0CvYBedupeS6RMxV3hUZitFyoTOc+mlfS932wquINf/F+ul
         Xgqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3lACy8kbH5e46DsTT/OtxwWn/dnxl9hVaFrhjhiwNtk=;
        b=Gm1hry7rokYBww8QI30eZC++qWq5E24y8cC+6L5r/EpfxN7VGUQZUSE9+IC+hbw1qj
         hYp7USYmmbG3LOga5QZw4uZndUIZUcIJ2mIhUALIi+P7fQZvKtQ9hdGmcKzpT2qlrev6
         JXSXWV2FDjr9lPzOP1hPpHElOI9v83ZnZnVP714PIRlNMiufGNO8fcwTJOE94OIlrfgp
         ciqqqlaLZ+VUyzY1lRnjM8YRyhqVy7uC04TovQX2UlQzaOUCzaEn0VqkPl9oY7LAjduj
         DxY6/8cymSEwHNIWvjBixQZV/rbPvDyJd6IvERW6jwvWBbNzYiZ+V5B5n7JBtGSY4KI1
         junw==
X-Gm-Message-State: AOAM533Bs0H41tH1zBEwOaM9yJxnjHZ6+Wm7pTBVlqCfCCL2NiRUSwTh
        eZM+pW8Q0Hmy8OYwYNk7QOi4qf3x7UgfpA==
X-Google-Smtp-Source: ABdhPJx/7Y1Gy8drYU6tq4YZDKB1KT2nlVkI/VNWGDuKmP50lzM3qttALfCRGknX+fJ3CsQ9CuHTmQ==
X-Received: by 2002:a17:903:2489:b0:14f:fe0b:554b with SMTP id p9-20020a170903248900b0014ffe0b554bmr4763742plw.113.1646508758864;
        Sat, 05 Mar 2022 11:32:38 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id d5-20020a056a0010c500b004e1b283a072sm10667100pfu.76.2022.03.05.11.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 11:32:38 -0800 (PST)
Date:   Sat, 5 Mar 2022 11:32:35 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] configure: Allow command line override of
 toolchain
Message-ID: <20220305113235.7a90329b@hermes.local>
In-Reply-To: <dfe64c90-88ea-9d85-412e-d2064f3f5e52@kernel.org>
References: <20220228015435.1328-1-dsahern@kernel.org>
        <Yh93f0XP0DijocNa@shredder>
        <dfe64c90-88ea-9d85-412e-d2064f3f5e52@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Mar 2022 11:11:43 -0700
David Ahern <dsahern@kernel.org> wrote:

> On 3/2/22 6:56 AM, Ido Schimmel wrote:
> > David, are you sure this patch is needed? Even without it I can override
> > from the command line:
> > 
> > $ make V=1 CC=gcc
> > 
> > lib
> > make[1]: Entering directory '/home/idosch/code/iproute2/lib'
> > gcc -Wall -Wstrict-prototypes  -Wmissing-prototypes -Wmissing-declarations -Wold-style-definition -Wformat=2 -O2 -pipe -I../include -I../include/uapi -DRESOLVE_HOSTNAMES -DLIBDIR=\"/usr/lib\" -DCONFDIR=\"/etc/iproute2\" -DNETNS_RUN_DIR=\"/var/run/netns\" -DNETNS_ETC_DIR=\"/etc/netns\" -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -DHAVE_SETNS -DHAVE_HANDLE_AT -DHAVE_SELINUX -DHAVE_ELF -DHAVE_LIBMNL -DNEED_STRLCPY -DHAVE_LIBCAP -DHAVE_SETNS -DHAVE_HANDLE_AT -DHAVE_SELINUX -DHAVE_ELF -DHAVE_LIBMNL -DNEED_STRLCPY -DHAVE_LIBCAP -fPIC   -c -o libgenl.o libgenl.c
> > ...
> > 
> > $ make V=1 CC=clang
> > 
> > lib
> > make[1]: Entering directory '/home/idosch/code/iproute2/lib'
> > clang -Wall -Wstrict-prototypes  -Wmissing-prototypes -Wmissing-declarations -Wold-style-definition -Wformat=2 -O2 -pipe -I../include -I../include/uapi -DRESOLVE_HOSTNAMES -DLIBDIR=\"/usr/lib\" -DCONFDIR=\"/etc/iproute2\" -DNETNS_RUN_DIR=\"/var/run/netns\" -DNETNS_ETC_DIR=\"/etc/netns\" -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -DHAVE_SETNS -DHAVE_HANDLE_AT -DHAVE_SELINUX -DHAVE_ELF -DHAVE_LIBMNL -DNEED_STRLCPY -DHAVE_LIBCAP -DHAVE_SETNS -DHAVE_HANDLE_AT -DHAVE_SELINUX -DHAVE_ELF -DHAVE_LIBMNL -DNEED_STRLCPY -DHAVE_LIBCAP -fPIC   -c -o libgenl.o libgenl.c
> >   
> 
> interesting. As I recall the change was needed when I was testing
> Stephen's patches for a clean compile with clang. Either way, the patch
> was already merged.
> 

Right, it maybe necessary for configure. I was using clang after already having done
configure step on my system (with gcc).
