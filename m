Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDF36BFCD0
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 21:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjCRUnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 16:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjCRUnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 16:43:23 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4AA11E1EE
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 13:43:21 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id t13so5569833qvn.2
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 13:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679172201;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kD9TsI9ozDAeja89ikDqGZjxTpZd7src+41WKAoBUug=;
        b=mnjEQ8lfQb/QHLKRyZgowRIMtuwBBYYpp8bjDvkRBsJBkaQR46nuZ1pGVXmsrbLqMM
         joTMnf17N4+iQp0kgiyB9OSzxivxP3L9dWwoSAXr/VBYSNBb13bf7NEBGcC0S72DZHSd
         om5lE9YZXCnLftQPkNeH1jHsdOECMTR/jDf1xbBxG1rCTt86cdmzRGJrzBaeHh0gtOBi
         f2XpiMzl2vLtvCA4KGRERoW9C4qyafT3LhKFfNX/+uONoHXcGWCMG3kYbB5Q3tmFW7Gj
         EWqWWcwwbVcJtsD5jpI4zQvFtmOrLbxg8H2XT3BlIpEOw6VJeTqA1gun280eicM9qBLE
         KwMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679172201;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kD9TsI9ozDAeja89ikDqGZjxTpZd7src+41WKAoBUug=;
        b=xN0UhLiy2TjHzJ052941019/j4+MX9tPnWFXMNPysVZxin3ugWIbJRjSWgMYfrFyAl
         JA2jdmjqCwIePmd56PVfvTaRfzGY8IqPRuPpFQ5Soji5lTx9+i8WnNTactmFi4SgekOq
         kp/fBPqAsmP6NWGvBB5t7ZQZD35jrSmGkXDS2Ymj8QQLh04L1tgyEo7+2DUilfIrFFtn
         G5IgGXqoY/1BAfjOIXgu7r9VCQzmfQnhVBSFp9uf/KyW5YiUA1x9tUc0oZLhmMyd31sF
         PeVOteEEvUPMde+OYIOagMlc6jU+IxCJlQQ+On6dn7WeqCU6MctD7Z+zjziNOanztuHK
         /xZQ==
X-Gm-Message-State: AO0yUKXfidhW6r/VaX4UIZW/CUXKTeitd7SMOi2ybb4l2yR9DBMbikt5
        iaxDMr3f/8uRjr95lAH1akkq6LA8b4A=
X-Google-Smtp-Source: AK7set/CuhwlFOGJASAucM4D2oJ7aqzgqnfbUtTf0yzCh1z42kFSBsj1I6fEGXm6GUsQQITVVtItpA==
X-Received: by 2002:a05:6214:20c1:b0:570:bf43:499 with SMTP id 1-20020a05621420c100b00570bf430499mr50358898qve.9.1679172200971;
        Sat, 18 Mar 2023 13:43:20 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id i1-20020a05620a0a0100b0074631fb7ccesm4127817qka.67.2023.03.18.13.43.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 13:43:20 -0700 (PDT)
Date:   Sat, 18 Mar 2023 16:43:19 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <64162267eac9b_397cf2208fa@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230317162002.2690357-1-edumazet@google.com>
References: <20230317162002.2690357-1-edumazet@google.com>
Subject: RE: [PATCH net-next] net/packet: remove po->xmit
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

Eric Dumazet wrote:
> Use PACKET_SOCK_QDISC_BYPASS atomic bit instead of a pointer.
> 
> This removes one indirect call in fast path,
> and READ_ONCE()/WRITE_ONCE() annotations as well.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Suggested-by: Willem de Bruijn <willemb@google.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>

Reviewed-by: Willem de Bruijn <willemb@google.com>
