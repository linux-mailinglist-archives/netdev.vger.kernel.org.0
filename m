Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7AB616E2E
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 21:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbiKBUBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 16:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiKBUB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 16:01:29 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F502BD5
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 13:01:28 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id p3so17607588pld.10
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 13:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=crDMk0R12pE4R+rJIlvy8EsGZM7TBfRAPYKWnpWAGHY=;
        b=UK9/AZo0Gy9FmiPW3MCdfsBkfo+eIrkJ8azyv3CjPHoN4MhEkiNCR8PNH7yhFsYAOV
         OcpJgIYxLNKdG/2WV1Ir7KHesKgC3PaVShkuvcivzT1/xw5yHoEnTL+CL4JhdOo7Cq6/
         kZ7Q7PuO5Kq6Dkv2HcO0D8R73xSRLPR7rqXcY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=crDMk0R12pE4R+rJIlvy8EsGZM7TBfRAPYKWnpWAGHY=;
        b=xMQkIccFSchq75YSTrqcMhw3yNtuY/RHqdA0Y5FlWWuW35regY/JXSNP5F2aOqPldE
         c/SNxyr7tgMwAORGOWXoYkq27fIeOOZnMYmglvM1a8yppSLuiq4e2AJ2C6liB1tDK9Yt
         2/j9lv3ApHcE6/OblmLepWPji4lR+z78qzJFZYhJVNZ3BOgQ6BGZw2ymASys3Ch3l5XW
         pPbbmWYsSUqQ5V2EyF142Alg8WaQXEyM8cFT1zg0dNELgxL5fnaO4AtGjEhS7Un9G2Dd
         l8kYdG95sXj1O4g8FJBx+9blChH8KnuRk8eaVw1BERuC5AjIFyYkAPSdfLd/8Ud38Gkq
         1TzQ==
X-Gm-Message-State: ACrzQf38iuGWpfSPqsP6KLntq3EoZVMyq4HnfOAEeqjlPSbXTnIoUBRd
        JJ1SWdoxMdkcB/FFkJOOLa5UHQ==
X-Google-Smtp-Source: AMsMyM6jJViHjLqCoTS++I8Qer6oLGbkwZ5YrvtcOzrUTmAZhCWRZ2VARz0FuIZVfUtOhdEVS0FtHA==
X-Received: by 2002:a17:903:41ca:b0:186:a68e:c06d with SMTP id u10-20020a17090341ca00b00186a68ec06dmr25774406ple.61.1667419287620;
        Wed, 02 Nov 2022 13:01:27 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id z184-20020a6233c1000000b0056c47a5c34dsm8825142pfz.122.2022.11.02.13.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 13:01:27 -0700 (PDT)
Date:   Wed, 2 Nov 2022 13:01:26 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Heiko Carstens <hca@linux.ibm.com>,
        Sami Tolvanen <samitolvanen@google.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, llvm@lists.linux.dev,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 1/3] s390/ctcm: Fix return type of ctc{mp,}m_tx()
Message-ID: <202211021259.9169F5CBE@keescook>
References: <20221102163252.49175-1-nathan@kernel.org>
 <Y2LJmr8gE2I7gOP5@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2LJmr8gE2I7gOP5@osiris>
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 02, 2022 at 08:48:42PM +0100, Heiko Carstens wrote:
> On Wed, Nov 02, 2022 at 09:32:50AM -0700, Nathan Chancellor wrote:
> > should s390 select ARCH_SUPPORTS_CFI_CLANG in the future.
> 
> Yes, s390 should select that :)
> 
> But, is there any switch or option I need to set when compiling clang,
> so it knows about the kcfi sanitizer?
> 
> I get:
> clang-16: error: unsupported option '-fsanitize=kcfi' for target 's390x-ibm-linux'
> 
> > clang --version
> clang version 16.0.0 (https://github.com/llvm/llvm-project.git e02110e2ab4dd71b276e887483f0e6e286d243ed)

You'll need the "generic arch support": https://reviews.llvm.org/D135411
which is _almost_ landed. Testing would be welcome, for sure!

Sami, do you have any notes on what common things were needed to get
arm64 and x86_64 booting under kCFI? My only oh-so-helpful notes are
"keep CFI away from early boot code". :P

-- 
Kees Cook
