Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDEC552FE3E
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 18:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343694AbiEUQp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 12:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbiEUQpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 12:45:52 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54170FF3;
        Sat, 21 May 2022 09:45:50 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id g3so9986222qtb.7;
        Sat, 21 May 2022 09:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hIMTrtnjZ9gqkDWInY5qR+iQZXXgSvv+Fs8Mw2FuFq0=;
        b=fBn1s4wNEYbraZzXmKP2EyONUlmW8I8BgBrKTm5RQON25DyvbzWLg+/vl/bwdVHJKP
         QLioOfyR5jbf6Mt2MzSfCjKCAdkuQc5TfsUvQ57u7K8AbEDJfIL87aaSCPXeCWwKkV3f
         dMJqant5hrCiOAypmsMB/vmwysoDXDMAMLzq1gr4/q8Q2ESVzZBC9HKmlrD7Ah0d6xMj
         ZkX9koF2urPM0YdiGb5YmK471qrZNZ8UtkIOgNpV2POVXJlc/AWy7TKU7Q48INKmVJVS
         5s0b6e5rN7dcLAhe0mi7xDXh/BScbmWMvrX9cqvnKm8ONl3Vrfa/m8+TiYmJI+0Kymvn
         17hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hIMTrtnjZ9gqkDWInY5qR+iQZXXgSvv+Fs8Mw2FuFq0=;
        b=rCulwQbc9YqiyOegLpjU1sWESCq2Df+PXRc6JdQ9Ib42hoCh+dYQJz/hbAH+qYVEix
         ZwcS1AAb8wthz5sYuZlNtAbrIpRUmXjmZECxZTfjmAQdJEolaX+CMbAidg2E6Zqh6uTm
         /h5q3Rw8dUKBriTmdQQVJOmlEXK9MudVa+YL1wy1QJ9923rHshZYPbF/0cb7ryIWzExL
         kehHkWx1vURyUrh9K6DBJVKbayiH2o3dvbNcKjI1q0INUtJ9PfH5sZnQM6wkcgsyZBnz
         I/fY9qPQqt4FaJ3X9xnRkegVUe7MJbiqfcvn7Z3vaqGo0m84QrZoPNd07Ie4513YnbaT
         +wFg==
X-Gm-Message-State: AOAM5324Xt2f2qOof7EG4eUI58MRjWS2WAKnqWBUi0XgGOm5IHqZAeSn
        UVl6bKDhvQrtJmQwwedZYA==
X-Google-Smtp-Source: ABdhPJyek8YSkEb5b3A0KQzbpWST89kREvGQc6v6hOXCeHBh9vLoseUyMrXzt0U1xN0KuHBx4A9llQ==
X-Received: by 2002:a05:622a:41:b0:2f3:c678:34df with SMTP id y1-20020a05622a004100b002f3c67834dfmr11396132qtw.67.1653151549474;
        Sat, 21 May 2022 09:45:49 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id y76-20020a37644f000000b0069ffe63228fsm1690243qkb.121.2022.05.21.09.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 May 2022 09:45:48 -0700 (PDT)
Date:   Sat, 21 May 2022 12:45:46 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        mcgrof@kernel.org, tytso@mit.edu
Subject: Re: RFC: Ioctl v2
Message-ID: <20220521164546.h7huckdwvguvmmyy@moria.home.lan>
References: <20220520161652.rmhqlvwvfrvskg4w@moria.home.lan>
 <Yof6hsC1hLiYITdh@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yof6hsC1hLiYITdh@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 20, 2022 at 10:31:02PM +0200, Andrew Lunn wrote:
> > I want to circulate this and get some comments and feedback, and if
> > no one raises any serious objections - I'd love to get collaborators
> > to work on this with me. Flame away!
> 
> Hi Kent
> 
> I doubt you will get much interest from netdev. netdev already
> considers ioctl as legacy, and mostly uses netlink and a message
> passing structure, which is easy to extend in a backwards compatible
> manor.

The more I look at netlink the more I wonder what on earth it's targeted at or
was trying to solve. It must exist for a reason, but I've written a few ioctls
myself and I can't fathom a situation where I'd actually want any of the stuff
netlink provides.

Why bother with getting a special socket type? Why asynchronous messages with
all the marshalling/unmarshalling that entails?

From what I've seen all we really want is driver private syscalls, and the
things about ioctls that suck are where it's _not_ like syscalls. Let's just
make it work more like normal function calls.
