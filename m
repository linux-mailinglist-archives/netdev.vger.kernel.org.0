Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46BBC5EFF49
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 23:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiI2V3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 17:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiI2V3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 17:29:23 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F56146F88
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 14:29:23 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id m130so2906611oif.6
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 14:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=zWEEW0io6OLT3d76J4YRO+ROrxoFQ09A3+z0bkYNhFk=;
        b=LEvFJnetoNHBkkAzEJsR1PxWKQVoG84Y/dJeHRNRHwsNUetMHIRQpvPy6NjFzEFffW
         NYYFj1OXKx+Gaka66SwjaDtqbrt1Y/l5VlQSQSQNZyVCvmG9PFfVDqGUjwWktp8raszl
         DxIIMvq17kw7qgy9J/IyQbze79kON/+UTztss=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=zWEEW0io6OLT3d76J4YRO+ROrxoFQ09A3+z0bkYNhFk=;
        b=3VtR3X995GG7hO76s0wYl0AvrN4wOmkpjDunPAFAJEy8Ha3I7aBLz461GoGtfaxFIZ
         WOYwB2pKSuyzPMRRv3DWZpwxW2epqCddRiLNslIOu5JlGq6GAXFWJ6L7YldnhFftt3Wv
         Ruj+Qs3tazdSNdYNmK0bwCqKMxKtU8S3M9WXKz4ym7wMRojXbuH0SEat6qJ3c6TWm/ic
         qsBIN4xplkrMIPY+45F5UPlYU5EEHKfCWeNNPEMqL4FTbtc4ODQVngSYbZLWzUQ3vJGg
         akijzUJ4kgyFNvkmPwyIY8nG6ZUHoiBzvyBloFILIs0NwZtp9Hvupj+38K0wSNHMBGnS
         /FZg==
X-Gm-Message-State: ACrzQf13QHSMbxceoOM+4ND9DfxZZt289+FAYBIhKM31Dr9fvdbp0vSt
        NsiqPWe0bxmWUt2d6rITfwuN9v69WyIBOQ==
X-Google-Smtp-Source: AMsMyM5u4C4tskX+aoU5mjWBf21sWiuNolyRYb2Y8EB+GUGPRqtcNdTX+mW/9bkdXEGyga8iQK/5hA==
X-Received: by 2002:a05:6808:1a14:b0:350:1965:8b5 with SMTP id bk20-20020a0568081a1400b00350196508b5mr2483861oib.85.1664486961999;
        Thu, 29 Sep 2022 14:29:21 -0700 (PDT)
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com. [209.85.161.47])
        by smtp.gmail.com with ESMTPSA id x19-20020a4ab913000000b004767c273d3csm133184ooo.5.2022.09.29.14.29.20
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 14:29:20 -0700 (PDT)
Received: by mail-oo1-f47.google.com with SMTP id d74-20020a4a524d000000b004755f8aae16so990338oob.11
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 14:29:20 -0700 (PDT)
X-Received: by 2002:a9d:2de3:0:b0:638:e210:c9da with SMTP id
 g90-20020a9d2de3000000b00638e210c9damr2259623otb.69.1664486959800; Thu, 29
 Sep 2022 14:29:19 -0700 (PDT)
MIME-Version: 1.0
References: <dacfc18d6667421d97127451eafe4f29@AcuMS.aculab.com>
 <CAHk-=wgS_XpzEL140ovgLwGv6yXvV7Pu9nKJbCuo5pnRfcEbvg@mail.gmail.com>
 <YzXo/DIwq65ypHNH@ZenIV> <YzXrOFpPStEwZH/O@ZenIV> <CAHk-=wjLgM06JrS21W4g2VquqCLab+qu_My67cv6xuH7NhgHpw@mail.gmail.com>
 <YzXzXNAgcJeJ3M0d@ZenIV> <YzYK7k3tgZy3Pwht@ZenIV>
In-Reply-To: <YzYK7k3tgZy3Pwht@ZenIV>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 29 Sep 2022 14:29:03 -0700
X-Gmail-Original-Message-ID: <CAHk-=wihPFFE5KcsmOnOm1CALQDWqC1JTvrwSGBS08N5avVmEA@mail.gmail.com>
Message-ID: <CAHk-=wihPFFE5KcsmOnOm1CALQDWqC1JTvrwSGBS08N5avVmEA@mail.gmail.com>
Subject: Re: [PATCH 3/4] proc: Point /proc/net at /proc/thread-self/net
 instead of /proc/self/net
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     David Laight <David.Laight@aculab.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 2:15 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> FWIW, what e.g. debian profile for dhclient has is
>   @{PROC}/@{pid}/net/dev      r,
>
> Note that it's not
>   @{PROC}/net/dev      r,

Argh. Yeah, then a bind mount or a hardlink won't work either, you're
right. I was assuming that any Apparmor rules allowed for just
/proc/net.

Oh well. I guess we're screwed any which way we turn.

           Linus
