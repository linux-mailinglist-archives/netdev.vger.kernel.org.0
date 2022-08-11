Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2D8058F6AF
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 06:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbiHKEQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 00:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiHKEPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 00:15:51 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4DF32BB3
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 21:15:38 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id f65so16120380pgc.12
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 21:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc;
        bh=jD3m6RDt1PX0kFj4jWTV8+G5BestFH20tpKIVQkHwsE=;
        b=V8fdZFVZ8o1HiYv/nsLFvHy84JOytRzhAEbT7OWlQtDjlGW9obP6i6Zj03VG1ajnkI
         MwPQN0Bf7iJHJtG+4rhBE3qp3EPY7hcFAezf3Pf9B688cxa7dvmcUp8UAAQiYEg8z1Ft
         iumzu7n/0P9AOQeNDe88Jrnekp4Ax/SoLGLPx67BbJL2vooaOm4BjAAoqeN8JWWAtLq5
         iQ5UfibwKo9djDGFBFsqMw3tNi1vVb8bf90atOj+qcuDZ1dtEcgQnzvaY9F7X1+FdXt9
         J2nSs7J/elucbXaSl4XF+py5pLwjUqIUR/L8hVFBC+VzU9L+jpv0ZBmKmM1nJsGzmwFf
         FXTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=jD3m6RDt1PX0kFj4jWTV8+G5BestFH20tpKIVQkHwsE=;
        b=UyioYUceVnDXEYuaUjB7ROqENoHHyjLYSjmUpkENdR7ZpmaCZZ5PHhtHpPdqRZs4tn
         MOAVGEO1wR8WNfH1z9yG2hZJ2VOF6YcP3r5fdEUNw4SXZxqDpJhYkA14JzCl4CGbf9XS
         efgXe9l0V6FyB1SXOmPNuiDkv2lqXAetko/N7RWZxikWYD+P2BnM0mG7tfpLngRZ7F0o
         /V6+0IclKrg0QXha8Wk/ZVAeDN0TkXlRVmjiwxYVp+IYD1GhUCTIEqch5v8ktPePdQWp
         CJvmlugw7rX0R8ubTvyUy3HyaGME2flAdt8swAI0r5Ngyj6CYhHXiSjYExFWcN6+vmKA
         YJlA==
X-Gm-Message-State: ACgBeo2j7R+KDf5iCk/AaMaXmOJCFBclgT0J6+DCgUAG1w+x7JvpNrTP
        2Bv+EoK1HsKwPRGL0CSjQizB/g==
X-Google-Smtp-Source: AA6agR5hWwFjVkAILIksi7p8N6+u7kUafhVfSw3A1vN5mxNctK0DPHteTdKm+DAk7+vmb6Ku2sKgGw==
X-Received: by 2002:a05:6a00:2446:b0:528:5f22:5b6f with SMTP id d6-20020a056a00244600b005285f225b6fmr30608938pfj.73.1660191337661;
        Wed, 10 Aug 2022 21:15:37 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id u63-20020a638542000000b0041aa01c8bb0sm10408590pgd.10.2022.08.10.21.15.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 21:15:37 -0700 (PDT)
Date:   Wed, 10 Aug 2022 21:15:34 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, sdf@google.com, jacob.e.keller@intel.com,
        vadfed@fb.com, johannes@sipsolutions.net, jiri@resnulli.us,
        dsahern@kernel.org, fw@strlen.de, linux-doc@vger.kernel.org
Subject: Re: [RFC net-next 0/4] ynl: YAML netlink protocol descriptions
Message-ID: <20220810211534.0e529a06@hermes.local>
In-Reply-To: <20220811022304.583300-1-kuba@kernel.org>
References: <20220811022304.583300-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Aug 2022 19:23:00 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> Netlink seems simple and reasonable to those who understand it.
> It appears cumbersome and arcane to those who don't.
> 
> This RFC introduces machine readable netlink protocol descriptions
> in YAML, in an attempt to make creation of truly generic netlink
> libraries a possibility. Truly generic netlink library here means
> a library which does not require changes to support a new family
> or a new operation.
> 
> Each YAML spec lists attributes and operations the family supports.
> The specs are fully standalone, meaning that there is no dependency
> on existing uAPI headers in C. Numeric values of all attribute types,
> operations, enums, and defines and listed in the spec (or unambiguous).
> This property removes the need to manually translate the headers for
> languages which are not compatible with C.
> 
> The expectation is that the spec can be used to either dynamically
> translate between whatever types the high level language likes (see
> the Python example below) or codegen a complete libarary / bindings
> for a netlink family at compilation time (like popular RPC libraries
> do).
> 
> Currently only genetlink is supported, but the "old netlink" should
> be supportable as well (I don't need it myself).
> 
> On the kernel side the YAML spec can be used to generate:
>  - the C uAPI header
>  - documentation of the protocol as a ReST file
>  - policy tables for input attribute validation
>  - operation tables
> 
> We can also codegen parsers and dump helpers, but right now the level
> of "creativity & cleverness" when it comes to netlink parsing is so
> high it's quite hard to generalize it for most families without major
> refactoring.
> 
> Being able to generate the header, documentation and policy tables
> should balance out the extra effort of writing the YAML spec.
> 
> Here is a Python example I promised earlier:
> 
>   ynl = YnlFamily("path/to/ethtool.yaml")
>   channels = ynl.channels_get({'header': {'dev_name': 'eni1np1'}})
> 
> If the call was successful "channels" will hold a standard Python dict,
> e.g.:
> 
>   {'header': {'dev_index': 6, 'dev_name': 'eni1np1'},
>    'combined_max': 1,
>    'combined_count': 1}
> 
> for a netdevsim device with a single combined queue.
> 
> YnlFamily is an implementation of a YAML <> netlink translator (patch 3).
> It takes a path to the YAML spec - hopefully one day we will make
> the YAMLs themselves uAPI and distribute them like we distribute
> C headers. Or get them distributed to a standard search path another
> way. Until then, the YNL library needs a full path to the YAML spec and
> application has to worry about the distribution of those.
> 
> The YnlFamily reads all the info it needs from the spec, resolves
> the genetlink family id, and creates methods based on the spec.
> channels_get is such a dynamically-generated method (i.e. grep for
> channels_get in the python code shows nothing). The method can be called
> passing a standard Python dict as an argument. YNL will look up each key
> in the YAML spec and render the appropriate binary (netlink TLV)
> representation of the value. It then talks thru a netlink socket
> to the kernel, and deserilizes the response, converting the netlink
> TLVs into Python types and constructing a dictionary.
> 
> Again, the YNL code is completely generic and has no knowledge specific
> to ethtool. It's fairly simple an incomplete (in terms of types
> for example), I wrote it this afternoon. I'm also pretty bad at Python,
> but it's the only language I can type which allows the method
> magic, so please don't judge :) I have a rather more complete codegen
> for C, with support for notifications, kernel -> user policy/type
> verification, resolving extack attr offsets into a path
> of attribute names etc, etc. But that stuff needs polishing and
> is less suitable for an RFC.
> 
> The ability for a high level language like Python to talk to the kernel
> so easily, without ctypes, manually packing structs, copy'n'pasting
> values for defines etc. excites me more than C codegen, anyway.
> 
> 
> Patch 1 adds a bit of documentation under Documentation/, it talks
> more about the schemas themselves.
> 
> Patch 2 contains the YAML schema for the YAML specs.
> 
> Patch 3 adds the YNL Python library.
> 
> Patch 4 adds a sample schema for ethtool channels and a demo script.
> 
> 
> Jakub Kicinski (4):
>   ynl: add intro docs for the concept
>   ynl: add the schema for the schemas
>   ynl: add a sample python library
>   ynl: add a sample user for ethtool
> 
>  Documentation/index.rst                     |   1 +
>  Documentation/netlink/bindings/ethtool.yaml | 115 +++++++
>  Documentation/netlink/index.rst             |  13 +
>  Documentation/netlink/netlink-bindings.rst  | 104 ++++++
>  Documentation/netlink/schema.yaml           | 242 ++++++++++++++
>  tools/net/ynl/samples/ethtool.py            |  30 ++
>  tools/net/ynl/samples/ynl.py                | 342 ++++++++++++++++++++
>  7 files changed, 847 insertions(+)
>  create mode 100644 Documentation/netlink/bindings/ethtool.yaml
>  create mode 100644 Documentation/netlink/index.rst
>  create mode 100644 Documentation/netlink/netlink-bindings.rst
>  create mode 100644 Documentation/netlink/schema.yaml
>  create mode 100755 tools/net/ynl/samples/ethtool.py
>  create mode 100644 tools/net/ynl/samples/ynl.py
> 

Would rather this be part of iproute2 rather than requiring it
to be maintained separately and part of the kernel tree.
