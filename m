Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB6452FF0B
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 21:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345425AbiEUTqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 15:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238301AbiEUTqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 15:46:07 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646D315802
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 12:46:03 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 202so3390983pfu.0
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 12:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zX5ok7BJ7D+wfGwmQ8/pQkeL6pnnmgUlA3fKtsver3U=;
        b=WOzdn6iO4OrpBAgQhS+QhjwGJ1+p1jNil1znlCHh1oyStS/cCmofFee1gCmgKV00FQ
         SQX1GEC0F98jIatP1VV2t9F04XF9Q0nSe3EsuhfSA/AI2/IVqwm1KtF2pW0KDmnm3WGI
         VW9Ttok+oxGHkkzwgPg3/81BJB2YmSEiraKkE6xmPNa2oxxNHsxAi5cQ7kIgXnPBpF7q
         9gCJIl7jVbqRkgdD490aNOQNlvhhyWa8SndtLn53/sXqiCK9+HfjkyaFmKmXrNJNhjtJ
         O8LxeCRMpP16/ABpUxMUbFQiEEYXpC/MmnkMykxcJMBZxd4HhkwPa/vneb+YOPLlLKqt
         I/tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zX5ok7BJ7D+wfGwmQ8/pQkeL6pnnmgUlA3fKtsver3U=;
        b=Lmzpc9YgJfFhHTCnG3n1Qq/jSxFiY6hA6q6iOfP3girpmzKHGmOehUxE/RWKJAGe83
         ZZPQcaNXDUfHJmAAIb8+Leu0yUDuRqCbIxoBMrBKFnnyg/uVPVcpUVhCVaH47b/hzHBa
         7MTjABAD5U2/zN/0HyU68OUaaknCAgYDTNjkGVw8Ta3ljLD9QC57wvYHKbKYjtptgXGj
         jU50CwIFj/qNhQogSLX+jxuk3CRMoOAD9+0yVU/Ip9bh78UWKQX2Es8eSI9TCyra+wGy
         m132B+9fdnpN7nF7FawAQf6A0q1TziwwT9Um/ZYxfUJj08/DIw040nP6FV1YvftnJZVY
         SrSA==
X-Gm-Message-State: AOAM530SpJRMltE7eQNSp/9TUbtaaZIMhDSFjOHzkr3R4m74Uu0lRE7/
        yZxFfBKeIO7oM5pyz8o9rAcomXnjx5XV3w==
X-Google-Smtp-Source: ABdhPJxbcUpunxaw0PstfwrdemrAznw9JU57xGuOAyg7DM7aIFDIXAliI8Nxt6ZJIbS/N6XC+EMeow==
X-Received: by 2002:a63:1e0c:0:b0:3f2:5b19:24d0 with SMTP id e12-20020a631e0c000000b003f25b1924d0mr13900376pge.562.1653162362867;
        Sat, 21 May 2022 12:46:02 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id k11-20020a170902760b00b0015eaa9aee50sm1955491pll.202.2022.05.21.12.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 May 2022 12:46:02 -0700 (PDT)
Date:   Sat, 21 May 2022 12:45:59 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, mcgrof@kernel.org, tytso@mit.edu
Subject: Re: RFC: Ioctl v2
Message-ID: <20220521124559.69414fec@hermes.local>
In-Reply-To: <20220521164546.h7huckdwvguvmmyy@moria.home.lan>
References: <20220520161652.rmhqlvwvfrvskg4w@moria.home.lan>
        <Yof6hsC1hLiYITdh@lunn.ch>
        <20220521164546.h7huckdwvguvmmyy@moria.home.lan>
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

On Sat, 21 May 2022 12:45:46 -0400
Kent Overstreet <kent.overstreet@gmail.com> wrote:

> On Fri, May 20, 2022 at 10:31:02PM +0200, Andrew Lunn wrote:
> > > I want to circulate this and get some comments and feedback, and if
> > > no one raises any serious objections - I'd love to get collaborators
> > > to work on this with me. Flame away!  
> > 
> > Hi Kent
> > 
> > I doubt you will get much interest from netdev. netdev already
> > considers ioctl as legacy, and mostly uses netlink and a message
> > passing structure, which is easy to extend in a backwards compatible
> > manor.  
> 
> The more I look at netlink the more I wonder what on earth it's targeted at or
> was trying to solve. It must exist for a reason, but I've written a few ioctls
> myself and I can't fathom a situation where I'd actually want any of the stuff
> netlink provides.

Netlink was built for networking operations, you want to set something like a route with a large
number of varying parameters in one transaction. And you don't want to have to invent
a new system call every time a new option is added.

Also, you want to monitor changes and see these events for a userspace control
application such as a routing daemon.

