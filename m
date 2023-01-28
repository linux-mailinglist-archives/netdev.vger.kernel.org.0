Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B50767FA05
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 18:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235049AbjA1Rkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 12:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234767AbjA1Rki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 12:40:38 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3306A2C661
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 09:40:10 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id z31so5242106pfw.4
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 09:40:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pFFvdYk1vXHiZkBaxVTiany7Px8U4wk+N7m1SeKmWQo=;
        b=whGqje+vaK/kd3RjWuiHwV8jPWfjPi1A2arjb+Ms3jkVeBLS7vK8zAzuttJs4xWcoO
         FrKe/Y90SBbQ5dB7RB4DbLK1hcJjVZ+v2P3YnfHZ6hoCeB/rzVV9gp8AKITqpQ03gdsr
         ek7OP+uYODUDJq3QzptZjCQ8eb0C3vO3IMxTd3+erq03BBDW4BupFJBBz2I0CsHQAQUW
         qDsrfkTK5Kwc/j3CkUWXYsuCnCh3h7cuT+Y8ODhe6+9gXrMWwz90NKjiMJYXTahhWtPM
         bHc96dxgAu8ws1XdNtyINUcnKoNQRdJ2sYzW3FNvcV5HG474RQS986JqaKmWKUtf2dBE
         9YBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pFFvdYk1vXHiZkBaxVTiany7Px8U4wk+N7m1SeKmWQo=;
        b=1B2OXopdWjcT0czSzSXjFXLuvRUCdV4o0OfGsL+m5fWH7MecnzJKMqI22GJoK/taiI
         SjlGzYmZLFnJIaKPFEFQpuy+0NAy9DxEwCx44TQxY5XdaF9n/3mEJhPvcdE5CTKMw4vV
         jgefP29tX87jMpz7PJHJxq9owWfY7adWXVKBJdWD+ZdHBXt4KzzDv9yFGihQVIynKn/E
         lqTD+2O++83b+MuoA8XzfR6asTIhxl2Y7HMwciZn5RBhX0f0VTNTWSUdTSdqJHUhqQD/
         2fGY8LUQNgpSYbmoIdw6HkC39GSGbOzD3zo95F58mg7ZrJjcqfKcsZ+qCNF6RSawy7Yn
         w8uw==
X-Gm-Message-State: AO0yUKUYIVdHgZ9dYrtilbqO7ppAbcULCJ6IoI81fr8/ShahvQaQravU
        kpS2NQ0aK78clpd1ImptUzmSOw==
X-Google-Smtp-Source: AK7set8AN4Ofx81eCY1begDuoePyC+p31KB7u1UEFhz5BQ8fgTJixPkA7CUNZKN2LghzsBwTXV7dtw==
X-Received: by 2002:aa7:8e01:0:b0:593:9265:3963 with SMTP id c1-20020aa78e01000000b0059392653963mr2768223pfr.31.1674927606810;
        Sat, 28 Jan 2023 09:40:06 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d16-20020a056a0024d000b005828071bf7asm4575667pfv.22.2023.01.28.09.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jan 2023 09:40:06 -0800 (PST)
Date:   Sat, 28 Jan 2023 09:40:05 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Chuck Lever <chuck.lever@oracle.com>, netdev@vger.kernel.org,
        hare@suse.com, dhowells@redhat.com, kolga@netapp.com,
        jmeneghi@redhat.com, bcodding@redhat.com, jlayton@redhat.com
Subject: Re: [PATCH v2 2/3] net/handshake: Add support for PF_HANDSHAKE
Message-ID: <20230128094005.55190564@hermes.local>
In-Reply-To: <20230128003212.7f37b45c@kernel.org>
References: <167474840929.5189.15539668431467077918.stgit@91.116.238.104.host.secureserver.net>
        <167474894272.5189.9499312703868893688.stgit@91.116.238.104.host.secureserver.net>
        <20230128003212.7f37b45c@kernel.org>
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

On Sat, 28 Jan 2023 00:32:12 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> On Thu, 26 Jan 2023 11:02:22 -0500 Chuck Lever wrote:
> > I've designed a way to pass a connected kernel socket endpoint to
> > user space using the traditional listen/accept mechanism. accept(2)
> > gives us a well-worn building block that can materialize a connected
> > socket endpoint as a file descriptor in a specific user space
> > process. Like any open socket descriptor, the accepted FD can then
> > be passed to a library such as GnuTLS to perform a TLS handshake.  
> 
> I can't bring myself to like the new socket family layer.
> I'd like a second opinion on that, if anyone within netdev
> is willing to share..

Why not just pass fd's with Unix Domain socket?
The application is going to need to be changed to handle new AF already.

Also, expanding the address families has security impacts as well.
Either all the container and LSM's need to deny your new AF or they need
to be taught to validate whether this a valid operation.
