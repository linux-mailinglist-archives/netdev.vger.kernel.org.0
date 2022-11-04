Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCC561926A
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 09:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiKDIIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 04:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiKDIIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 04:08:32 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A1F21266
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 01:08:31 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id m14-20020a17090a3f8e00b00212dab39bcdso7564327pjc.0
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 01:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=n+M9jSVS5yN6WBH23Kfpy/+DIv5SCL7QqYC3ii5kmyE=;
        b=QaWlkve6wfj75MhOg1CYM1m0OxfnTUqg6ext8zUkoo/d9macxsSI60/6ZbuxaHbShD
         Xhitk8+b7VvCeBF7SMAaVtIYbFxRXrWMnp/+hbV/qrv9XFbnwPyzwXYXnuDKLUryW/EK
         YhTQtJEjef4qquhso8xsq1kVuGVyBqkk4wP4By6dlK9/zC2xUoY/uvn1yEwrokJlrSYP
         fdzb97mvSP8Q9174mlWfyJU2SEG73qNodDUR/37vsb4qZF6F6YR2ClaJVs7H049o+B/S
         zVBkeO/kZykRQDl//p6on136F9n9TuE/xw+QKKDYybP4rXxT5qVLKOE0+FHLTW1zlz6K
         EKtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n+M9jSVS5yN6WBH23Kfpy/+DIv5SCL7QqYC3ii5kmyE=;
        b=rn9tKroO7Dv4RVMRVZ2nzkoTYddmndNnCw7BpqQ1JlvIi2gp1OCL0AhDfgMwXNBq1A
         TZC1uymvqcllawxPMn4+7f5Gx5hxduHiyDgBkoXk2cZwR4iOY8tUq/WgIlmuqylOEcAu
         c2wBKjIDtB6rgDmXOOFZOMhx60qUEtumFpnidArM+tJ7IBsUQDom9AVKJL2JVrUwx5bh
         RwGQdvxdSu/1iPte9OeYhlJKeGPb2S4hseDyTUaFIX9Bd47rKdwToO/TX/ZpF5Xq+7m0
         IlsbkZe2EL5FeuJn/u92pbERLho5Mu5KLGRR6FHnl3qoZ5xuLyMCiHz6bvN9QDyixK/m
         DwKQ==
X-Gm-Message-State: ACrzQf3feO0IP4fgtpINMBGFRaEJc5MjbGlmDfOIf0o+NtW8kvPsvHVg
        5JZn4qDz/Y6FoilbqVRYRgs=
X-Google-Smtp-Source: AMsMyM4u064fXWFeyQhPhuqdcpusnn3Lq2BVSFRDr8m4Eu4oYGZvK0JrzKc+XmpPDf/vt+QT8bld3w==
X-Received: by 2002:a17:902:efc7:b0:183:9254:cc70 with SMTP id ja7-20020a170902efc700b001839254cc70mr282887plb.18.1667549310721;
        Fri, 04 Nov 2022 01:08:30 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id k14-20020a170902ce0e00b0016dbdf7b97bsm1924970plg.266.2022.11.04.01.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 01:08:30 -0700 (PDT)
Date:   Fri, 4 Nov 2022 16:08:26 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>, Liang Li <liali@redhat.com>
Subject: Re: [PATCH net] bonding: fix ICMPv6 header handling when receiving
 IPv6 messages
Message-ID: <Y2TIeiI1s+hdBPlL@Laptop-X1>
References: <20221101091356.531160-1-liuhangbin@gmail.com>
 <72467.1667297563@vermin>
 <Y2Ehg4AGAwaDRSy1@Laptop-X1>
 <Y2EqgyAChS1/6VqP@Laptop-X1>
 <171898.1667491439@vermin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171898.1667491439@vermin>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 03, 2022 at 05:03:59PM +0100, Jay Vosburgh wrote:
> 	Briefly looking at the patch, the commit message needs updating,
> and I'm curious to know why pskb_may_pull can't be used.

Oh, forgot to reply this. pskb_may_pull() need "struct sk_buff *skb" but we
defined "const struct sk_buff *skb" in bond_na_rcv().

Thanks
Hangbin
