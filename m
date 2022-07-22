Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76EA757DA23
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 08:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbiGVGQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 02:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232603AbiGVGQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 02:16:07 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7C867C9F
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 23:16:07 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id pc13so3531424pjb.4
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 23:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=N0SiKgIZvDnMbortSweS1GuyjttCdSpP4mXa06DGXsQ=;
        b=ORKyOom6NVCeoVTNGPEbNmIWW1dBr3lCzJFGMFySIqgw97fVggCaNiCdbXVZSKQGgT
         2sWbh2eiyVY1mNt6PMsBmvHBup21W7Str0Gj1VZsgkfA8QO+DwnjP5oZclzxRrLlXu6f
         yj4m/idfHdWPpTXokhyqvEbYJjxGVYvOHrL11SDhvGkTF99yUM6I8yno/M9WeWheUOIs
         BKa4HA8F32qtGr0IbbYnaSyv1tQGM+dCsoMBSXAxhpcn8GObY5fzyU3LBCGDAuc8GPN5
         tSa59xMx4W6rfJTTLf85NYgCQFwXIwX+h0iQha911WYY5139+BH8eVP4HS+4xTMjQJ24
         3nsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N0SiKgIZvDnMbortSweS1GuyjttCdSpP4mXa06DGXsQ=;
        b=ZZ2KcM17XKIeEObo1eVbrFymlDZT80j8AgjIApY9i9G2PmXlK7PQ1SwmCieNxXsgFR
         2UZBbA1LbEx0pes/TrOU0fmBRA/LAxqNXo202amOrqAQoqB7My/RB6XB69PnMp1bSHmc
         rcmBGTatKresoRn2biLPhllDGiW2juzGJsAeLfhwlYjlpN+JxbGLIEOgrgFzpKmotyQD
         jIE0p9EXxMcMBDbJj21zfpDmN+vb7w1Pk/ye+iZYikmbJ5uypgZFbGGNpkqwpU+6c4DO
         08hBE5k2ckOyaAgOvTmmQAfvO5vLuyoWnD/tRU8Y+iPck8f/n7x+1nekdU8/ELF22gh1
         PoeQ==
X-Gm-Message-State: AJIora+DBADUFPJKeljX0PKpdFI84BAAITJktr30AIXmRTWMVeqbUJ3S
        aPfHFsgi5dAfOBx1BUU4dzQf1430ndx6IA==
X-Google-Smtp-Source: AGRyM1uz1DNDeu6MJDzoS/9Ft7KUuq4VXSj3iKC6ndJ1XydW1jWMIhaODNf0MhAZ/irnRJuuZ9OdvQ==
X-Received: by 2002:a17:90b:3841:b0:1ef:f0ac:de55 with SMTP id nl1-20020a17090b384100b001eff0acde55mr15839013pjb.35.1658470566770;
        Thu, 21 Jul 2022 23:16:06 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 21-20020a170902c11500b0016c09e23b18sm2743864pli.154.2022.07.21.23.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 23:16:06 -0700 (PDT)
Date:   Fri, 22 Jul 2022 14:16:00 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net: mld: do not use system_wq in the mld
Message-ID: <YtpAoDrTnL9D3CrQ@Laptop-X1>
References: <20220721120316.17070-1-ap420073@gmail.com>
 <CANn89iJjc+jcyWZS1L+EfSkZYRaeVSmUHAkLKAFDRN4bCOcVyg@mail.gmail.com>
 <ea287ba8-89d6-8175-0ebb-3269328a79b4@gmail.com>
 <CANn89iL=sLeDpPfM8OKbDc7L95p+exPynZNz+tUBUve7eA42Eg@mail.gmail.com>
 <6b4db767-3fbd-66df-79c4-f0d78b27b9ee@gmail.com>
 <YtoNCKyTPNPotFhp@Laptop-X1>
 <YtomWhU9lR3ftEM+@Laptop-X1>
 <ecd370bb-dfd3-08e4-b526-fb93226b2dbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ecd370bb-dfd3-08e4-b526-fb93226b2dbb@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 01:50:14PM +0900, Taehee Yoo wrote:
> If you are okay, I would like to attach your reproducer script to the commit
> message.

Sure, please feel free to do that.

Hangbin
