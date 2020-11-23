Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEB52C1993
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 00:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbgKWXrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 18:47:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727519AbgKWXra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 18:47:30 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4D8C061A4D
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 15:47:29 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id bo9so20058087ejb.13
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 15:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M2tH0J5FjG3CWEJAM78SzCWVNgxFS8dPSbJZXIrz8eA=;
        b=bahMHd+33ExZBCoE/oR5FMEwH44L39inSA9W3/K3d6bGAEZkB7v1ob5roD/5eVpdJ0
         R+d0XQDrBNNwKmyj7FajR++y38fX39bQnAMu70cGakDlYcC/tW05dSTKflWZ2uAoQW9m
         2xCdSEgInNLrNTxIFKbecjjgDab/K6ZMjJKwyzFIhhQORgKViMZWnZTGdz20711EZ5ci
         U2ly/ZtfiZq+0PY0skLkv4AYzqD+mof+cpmMKy3FSM3JxLk/gPf8GN2BxGNVXsoFg84t
         6g1MHkNlmtLw9gyrB0EbPGvW8Ijj9ZPRVocIwgwJMvyatG/WkP6v3iQP7tU7LfrtZ+GZ
         47zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M2tH0J5FjG3CWEJAM78SzCWVNgxFS8dPSbJZXIrz8eA=;
        b=b7HJ7/Y0zbu3zahUelQJE+8fnJcAKcPLUczwlYfWnRbLKwuXOXyHAyOuG1yjDHl9IW
         6yqq52FFSsTai75HtE1hWBE0c3D5KTgeX4yEXaWP5t0Jkl0Xfjr4nkU3wQtfB4WB365J
         qkQSGUBvuLIu8DNKNoizYiAsiN+VToezU4vfWMZT4fEuuh+5IQUoewPgWdhjrEC8aNSw
         H7V8goFYiG5zWA3v32z4Bz3ERzjRTAe3Zsft/jl1GXakoSNYpyUG+URS0A/wfaiOaUlL
         lEAo3qr7b9wx2Fx9jNPDBVKHRBOPItXzOEI+nhvEyf4Jk4KRi9cyibUlKYeXHWRBNmpY
         Y/mA==
X-Gm-Message-State: AOAM5325stduT7MOwph/j19exW+JSSeexZRflzw8J0GjO2Kcx7c3LZJT
        o8CbPQshtQ9TYCvtlKb3dMNHMSItsRoMTeK7+dXj
X-Google-Smtp-Source: ABdhPJz1cUzeMfwEdEEYptfkLKXDQKCaDHJLy6k80ocYA5tN4wZuhgjNHiuJKbzQ6wUqWl7pFgW3ifxoIkY/SNwNlKM=
X-Received: by 2002:a17:906:46d6:: with SMTP id k22mr1808743ejs.542.1606175248555;
 Mon, 23 Nov 2020 15:47:28 -0800 (PST)
MIME-Version: 1.0
References: <160581265397.2575.2287441525647057669.stgit@sifl> <alpine.LRH.2.21.2011201401570.20132@namei.org>
In-Reply-To: <alpine.LRH.2.21.2011201401570.20132@namei.org>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 23 Nov 2020 18:47:17 -0500
Message-ID: <CAHC9VhStm9LXL1cG3ATS0Z=EkJSbZ7GPLWfRwb=ZiQMJc2e8qQ@mail.gmail.com>
Subject: Re: [PATCH] lsm,selinux: pass flowi_common instead of flowi to the
 LSM hooks
To:     James Morris <jmorris@namei.org>
Cc:     linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        selinux@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 10:02 PM James Morris <jmorris@namei.org> wrote:
> On Thu, 19 Nov 2020, Paul Moore wrote:
> > As pointed out by Herbert in a recent related patch, the LSM hooks do
> > not have the necessary address family information to use the flowi
> > struct safely.  As none of the LSMs currently use any of the protocol
> > specific flowi information, replace the flowi pointers with pointers
> > to the address family independent flowi_common struct.
> >
> > Reported-by: Herbert Xu <herbert@gondor.apana.org.au>
> > Signed-off-by: Paul Moore <paul@paul-moore.com>
>
> Acked-by: James Morris <jamorris@linux.microsoft.com>

Thanks.  Seeing no further comments or objections, and given the
discussion in the previous draft of the patch, I've gone again and
merged this into selinux/next.

-- 
paul moore
www.paul-moore.com
