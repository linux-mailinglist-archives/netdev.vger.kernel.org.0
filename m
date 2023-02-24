Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18ADD6A1D8D
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 15:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjBXOiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 09:38:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjBXOiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 09:38:00 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B3B34F76
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 06:37:56 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id h16so14430415qta.8
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 06:37:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MVRn8NmBScew2IivbNUh3wHl/l5PxUrcVLNq9n+p+N0=;
        b=OS/pNFZ0xkwjUHZCCfYNijJTh01bslforuw3d+JES/5Vzs1+MYsrzYloRhoVqsP84l
         XVatb7lZYhCAx1jZl0UDzjAGyZhiLw5IxKWyadixbxUCQUGT4NZa0vsKWXRK0VqQBFus
         sd17iTiDXsFA+EM2lJ/Davvp0EhXOOeCrxsZrMOUfK9LO9facRUGSF8PI/QiS1XuWbW9
         MbnYUgTSyvJOdOdPtXIR+eWARc8xg++v3S/a7L3k9uPyPKyzcY3j4HIj4R3H1gfYrItU
         5GkwoPAa29Rq4jFUuyUWNABjYvv70MM9EhalrQw/wL5rXW9UJaVIYmgNwP18phpftu6i
         auTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MVRn8NmBScew2IivbNUh3wHl/l5PxUrcVLNq9n+p+N0=;
        b=SLz5qpjez+hkEAn4yGBdArVO3S5rdjGcvZiMNrwFxZSk69bBX05ahue4vrT3e6LNga
         c8i2dYbf4vKFeHFWL9CdI0lGaToEFhDDCmlfq/W1jtAmMARKrZ/f7Kf2hPfZ0+9/5bZC
         V/j9GhcahH1YzU8SvHyQwpW0sJPo3edgs0TjLuNQTq331fxGeNvkyNyg8h5gsVZFAWzF
         gt/pu1KgVuLSaGY+xk8mzyOpgrPhHZhkWd8EJRDmH3wCFzGqnC8PIrySJTaF7E5yERlR
         vjzXF0TeRVuSoaMJw6qtkZXkrQpQwP89yi2yXsPMVjmmZwQKgqXKY88nzyAPoGTqz2L8
         QoAg==
X-Gm-Message-State: AO0yUKX2VYTFHKCYJpucxMhcYPksUOki4+boQb/cFQsuQHRI7NLVdAig
        sWnj8BjH7WnvLiCz9Kw705M=
X-Google-Smtp-Source: AK7set+d32n1HBjc5XNzRXBetklPpHo9dlrEeQp7NVo36A7e6FDeWN4FSZcsdtmVVM3UR85SdQvY8Q==
X-Received: by 2002:ac8:7f4c:0:b0:3bc:fa79:c20c with SMTP id g12-20020ac87f4c000000b003bcfa79c20cmr28142065qtk.16.1677249475922;
        Fri, 24 Feb 2023 06:37:55 -0800 (PST)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id a17-20020ac80011000000b003b868cdc689sm6825240qtg.5.2023.02.24.06.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 06:37:55 -0800 (PST)
Date:   Fri, 24 Feb 2023 09:37:55 -0500
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     nick black <dankamongmen@gmail.com>, netdev@vger.kernel.org
Cc:     Willem de Bruijn <willemb@google.com>
Message-ID: <63f8cbc36988_78f6320819@willemb.c.googlers.com.notmuch>
In-Reply-To: <Y/gg/EhIIjugLdd3@schwarzgerat.orthanc>
References: <Y/gg/EhIIjugLdd3@schwarzgerat.orthanc>
Subject: RE: [PATCH] [net] fix inaccuracies in msg_zerocopy.rst
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nick black wrote:
> Replace "sendpage" with "sendfile". Remove comment about
> ENOBUFS when the sockopt hasn't been set; experimentation
> indicates that this is not true.
> 
> Signed-off-by: nick black <dankamongmen@gmail.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>

The first error was there from the start. The second is an
inconsistency introduced with commit 5cf4a8532c99
("tcp: really ignore MSG_ZEROCOPY if no SO_ZEROCOPY")

If Documentation fixes go to net, I suggest that as Fixes tag.
