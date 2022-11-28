Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62F7C63B137
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 19:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234285AbiK1SYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 13:24:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232586AbiK1SYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 13:24:20 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E9A29810;
        Mon, 28 Nov 2022 10:14:18 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id x66so11295964pfx.3;
        Mon, 28 Nov 2022 10:14:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BFDhcpX13EcgYFGqz7XZnJSVQygA2ZijS9NcWowGzKs=;
        b=FA7okpeW1nXP4236uyQOhFYfdl1mTxHJEQMs4B8OPjZNh4XaXRe4OrXKJEFZ4VFeOy
         fp5I6MwdLITaaZehiZTFyiWay5oGCpiEdtw562/s18MN7jLJCzEu2NlswdoE50moIZ88
         y1906/er9ye5GhWCIuZ9V/4n4B2n2WzhOVGFW09ivq5eyHpmqfznmR4LAkxmQyc9aIGX
         DCpFFaIe44aTFJXB1R9FelXQ+GsZ1QHfN7FNl6nXCw8xUE15Waq4Jf8hIOxWuxaLbCwE
         AuF/pJ+T148R7gfnoa34QkXjZT+nv3Qq8hWGBtcqrFNh7j8B4JI7NpTnpOOSqFARZXZR
         7q6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BFDhcpX13EcgYFGqz7XZnJSVQygA2ZijS9NcWowGzKs=;
        b=EFMpMQLQm3oCHQBZVZ5kbd1fcFSaQ0Nx+Kv1aR7U66UlodxMNNABkLLqJHbvpvTHfo
         jU6L/58VvFcQXPKU0CKVHLO0VjvJEFlOq7SjgfaCzjhxStZPCk6fmaO4DTagN5fS2k/d
         rF+pg34kGdhJGqdQSGLsrvmgW4GqPAx4pmRBHCgFDj9lgnY58PkzPncv3MbNsgwPNxkM
         mIAVV0usit9xlPmLUD2ilVLTk8FdkGRwpLSwm4o3OruTHprDvfHIC4PRqScgBsPkOP2h
         bwx2NmMkCq+xenrrStkfg4QFtrU1heyLHngMn/D1okwiHdqv1NOPc8H7g2U449rcaA2F
         4E+g==
X-Gm-Message-State: ANoB5plgiGuzu9LQdlFJxahlP00VPd+diQ6xsmQh2/rTrhLRQoDCshnr
        zvLGwvGDd9kvUG4FHBF5A+E=
X-Google-Smtp-Source: AA0mqf4blPZYVabqvnbpTiOfVJIQuyfokMewYYYIAAb00VRmqFJO48K/1Qj/0Ke8eDdoPLLgfNIbEw==
X-Received: by 2002:a65:4c48:0:b0:478:28a4:52d5 with SMTP id l8-20020a654c48000000b0047828a452d5mr4183397pgr.610.1669659257813;
        Mon, 28 Nov 2022 10:14:17 -0800 (PST)
Received: from localhost ([2605:59c8:6f:2810:7d97:f259:85c:a462])
        by smtp.gmail.com with ESMTPSA id l13-20020a170902d34d00b00189217ba6ffsm9182336plk.38.2022.11.28.10.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 10:14:17 -0800 (PST)
Date:   Mon, 28 Nov 2022 10:14:14 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Pengcheng Yang <yangpc@wangsu.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Cc:     Pengcheng Yang <yangpc@wangsu.com>
Message-ID: <6384fa7626d82_59da020876@john.notmuch>
In-Reply-To: <1669634685-1717-1-git-send-email-yangpc@wangsu.com>
References: <1669634685-1717-1-git-send-email-yangpc@wangsu.com>
Subject: RE: [PATCH bpf v2 0/4] bpf, sockmap: Fix some issues with using
 apply_bytes
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

Pengcheng Yang wrote:
> Patch 1~3 fixes three issues with using apply_bytes when redirecting.
> Patch 4 adds ingress tests for txmsg with apply_bytes in selftests.
> 
> ---
> Changes in v2:
> *Patch 2: Clear psock->flags explicitly before releasing the sock lock

Yeah I think its slightly nicer Thanks for fixing this.

For the series.

Acked-by: John Fastabend <john.fastabend@gmail.com>
