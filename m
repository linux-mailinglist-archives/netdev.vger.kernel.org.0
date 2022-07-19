Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49AEA578FDF
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 03:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbiGSBdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 21:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiGSBdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 21:33:15 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D215E2B1AC;
        Mon, 18 Jul 2022 18:33:14 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id r14so19526654wrg.1;
        Mon, 18 Jul 2022 18:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:to:cc:subject:references:mime-version
         :content-disposition:in-reply-to;
        bh=jvJQMWsfaQTbbjRHq6LeN1kkYs4KdvWhxU5ESEm6VBg=;
        b=W+vpm70Ei2Wm0kCdfUxWFwd7ISCXTLmlFgR7odAw5I0y5T3nW8ld17r9KxRU77xRtD
         Dkc1eTX2+YrHNhGv4KPBQBvkMdMIRe++OtUQiep6HKMbFt9SQ+dxym7L/kKlPSVN7unX
         fJfuhfjOvKe+/ln1CF8s3ujP5xScH5cuSmBzRS8sxmOjB27pLhBJAtZd4Ay1CuYbFHT5
         vAANV4OlI/6smELwDy6STp0lJYFAsJr/rYMQ1y3xM9F8FyN9O/PNWwnZhHl6E58/VgzP
         4KVE5Z1SKtAjz3P1OYRzJdS7aSGb/a/5/7W7JdoxiC84tRcU6TVGRi8wyGin2x+bnOkH
         wdeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:to:cc:subject:references
         :mime-version:content-disposition:in-reply-to;
        bh=jvJQMWsfaQTbbjRHq6LeN1kkYs4KdvWhxU5ESEm6VBg=;
        b=WZRz2kKs5wmRNfUJaX5ic702aIMhe4oLowa7khqwA9RQujWywd5+azeYDDH6RPCbFw
         s4QOtWA1TwDh3ZU/+UlOHgB1/ypblC5NQ8rJ2d1Xv+0h3kK6RPazulBLpwVhfBfM121c
         CAP/8FsIg6ig/LaMhYxacWVm0ju9+YQNE6JDCWxEXe2dAjqMKDRtNnu3zRMJxX7wHmY/
         XZvnxYM3/MmY4yXnjkf2dZe7DBStoljvLZW5NjUqPqf/CHvWVi3VczDTsJPViHXjxwBB
         z2URUIHrM3dY/2/onUJ5Tu9wm4QD5b7O0sEj/5vVrOErOnIcl1JgfGi1LoKXPvcJvEgk
         Q4JA==
X-Gm-Message-State: AJIora+PnZAyQKjNzjuZE1xDkbfJxJTTKSgs7ted1E9RiO1n7Mczbv7C
        gfb6uAtxz8gJBITUswcPsBY=
X-Google-Smtp-Source: AGRyM1tS7+CYC2hjP61pZH8M+BwFkE60UBU8JmvYo2n0O08GJHo23VkSlQptNbHjdqHIiWErA2pFcw==
X-Received: by 2002:a05:6000:1548:b0:21d:acfc:29f5 with SMTP id 8-20020a056000154800b0021dacfc29f5mr23954949wry.520.1658194393266;
        Mon, 18 Jul 2022 18:33:13 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.gmail.com with ESMTPSA id i3-20020a1c5403000000b003a2e1883a27sm23921851wmb.18.2022.07.18.18.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 18:33:12 -0700 (PDT)
Message-ID: <62d609d8.1c69fb81.d2fea.5a4b@mx.google.com>
X-Google-Original-Message-ID: <YtYF1brTYZuMqtHy@Ansuel-xps.>
Date:   Tue, 19 Jul 2022 03:16:05 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH v2 03/15] net: dsa: qca8k: move
 qca8kread/write/rmw and reg table to common code
References: <20220719005726.8739-1-ansuelsmth@gmail.com>
 <20220719005726.8739-5-ansuelsmth@gmail.com>
 <62d60620.1c69fb81.42957.a752@mx.google.com>
 <20220718183006.15e16e46@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718183006.15e16e46@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 06:30:06PM -0700, Jakub Kicinski wrote:
> On Tue, 19 Jul 2022 03:00:13 +0200 Christian Marangi wrote:
> > This slipped and was sent by mistake (and was just a typo fixed in the
> > title)
> > 
> > Please ignore. Sorry.
> 
> Please make sure you wait 24h before reposting, as per

Oh sorry... you are right, had a long discussion with Vladimir on the
changes to do and I thought it was a good idea (since v1 was really not
reviewable)

> 
> https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#i-have-received-review-feedback-when-should-i-post-a-revised-version-of-the-patches
> 
> BTW what is your name? Christian Marangi or Ansuel Smith? :S

I would prefer Ansuel but Christian Marangi is the one.

-- 
	Ansuel
