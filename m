Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0FFA624CF5
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 22:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbiKJVZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 16:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbiKJVZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 16:25:46 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FF81D6
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 13:25:44 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id z5-20020a17090a8b8500b00210a3a2364fso6551348pjn.0
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 13:25:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FqT8RNqA6N+wkWAA/Wp0lnh4zf1zebWRqFlwsZzhVdA=;
        b=vzXqQ44B1d8XbbXWy2IafbNlpQPwkRunZEV7DUzzUsBFhmUa7/qjUBUigpItSsdzWA
         sYbTJgE74PY8zjl0b7z4T6Ich3X6OO7eNlEzYmMvmmIO5ImAXw5X0OPDA3utHkkUi5qn
         Kr0IU65/YezgeXMXFS2K4BQ7IHagEbEWohVg2C7deJsUEeh0qOt5Tt1GjvtGswTh/t04
         sIGyLgkZeqqIR1HcEVFdg2oArXo2wEjsZp4vN9Meez53/QALMC+bW9aRtT99cFxZH2y2
         fMIlTocEmjU+cm7Tpr5j78rU+HMAU1lfMg6GD+RkCs2kiu/YKgx/4Ulz/5VLRWO+VtLA
         0uJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FqT8RNqA6N+wkWAA/Wp0lnh4zf1zebWRqFlwsZzhVdA=;
        b=LgWOBIh8Um/lRh2hCKjFDc/zei7MOQ/0FOgkLswmcR0xzS4AJWoL4Cx6ie8Y5TXbTd
         kPIN6L2Q97fPxYL9IcnxmWZoAMa4WCwywa42VWC60EjduDUnzhBP/8txy8P9rOy1tLdb
         8kUwXJ9+2Cd79LhZw935C1avU24GISqQOTBqhNeNNZaO/iS+0p+SG2ppmm+rhYiN0NTt
         pumd+pZ0Tois+NI30UqB7LOFW/YK7E6bMF0j/LcgbP2WfSk0ODYCEt3FkYvMfCA6aqyg
         eSbP5GuQ1tB4pSAH+zBkXgqL9BQTw+tLd4zTt3jLbdeWyInFGaxR7sXxs0r+nv6Coc/2
         /giw==
X-Gm-Message-State: ACrzQf1sBPcyaLpaCnYL+GemwFIcjzjwawpSFk/MvghR/GkwhM0g+m7V
        SzT76eKjW/oW8OZNAa1gPBlxJA==
X-Google-Smtp-Source: AMsMyM4LDmiyXr0CKIAfsj8WCUM8AdgnnKTfq2QEBek8gEcU91ztCAV8oK4Tm2SS+zjJ1zKQujqiFQ==
X-Received: by 2002:a17:902:b48d:b0:181:b55a:f987 with SMTP id y13-20020a170902b48d00b00181b55af987mr2129611plr.67.1668115544306;
        Thu, 10 Nov 2022 13:25:44 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id u21-20020a634715000000b00464aa9ea6fasm91676pga.20.2022.11.10.13.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 13:25:43 -0800 (PST)
Date:   Thu, 10 Nov 2022 13:25:40 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     John Ousterhout <ouster@cs.stanford.edu>
Cc:     netdev@vger.kernel.org
Subject: Re: Upstream Homa?
Message-ID: <20221110132540.44c9463c@hermes.local>
In-Reply-To: <CAGXJAmzTGiURc7+Xcr5A09jX3O=VzrnUQMp0K09kkh9GMaDy4A@mail.gmail.com>
References: <CAGXJAmzTGiURc7+Xcr5A09jX3O=VzrnUQMp0K09kkh9GMaDy4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Nov 2022 11:42:35 -0800
John Ousterhout <ouster@cs.stanford.edu> wrote:

> Several people at the netdev conference asked me if I was working to
> upstream the Homa transport protocol into the kernel. I have assumed
> that this is premature, given that there is not yet significant usage of
> Homa, but they encouraged me to start a discussion about upstreaming
> with the netdev community.
> 
> So, I'm sending this message to ask for advice about (a) what state
> Homa needs to reach before it would be appropriate to upstream it,
> and, (b) if/when that time is reached, what is the right way to go about it.
> Homa currently has about 13K lines of code, which I assume is far too
> large for a single patch set; at the same time, it's hard to envision a
> manageable first patch set with enough functionality to be useful by itself.
> 
> -John-

There are lots of experimental protocols already in Linux.
The usual upstream problem areas are:
 - coding style

 - compatibility layers
   developers don't care about code to run on older versions or other OS.
   
 - user API
   once you define it hard to change, need to get it right

 - tests
   is there a way to make sure it works on all platforms

Heuristics and bug fixing are fine, in fact having a wider community
will help.
