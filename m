Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651F51B7C49
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 18:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgDXQ7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 12:59:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60556 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728007AbgDXQ7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 12:59:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587747545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r9ZP5gBjSYcrQ1pdJzHzCOFsb7HE7nAcgutpn4kecwY=;
        b=Y60LUIzDBRVBZPDC418tlun3HpchOJPaCtwrSyTaOItKGThAgZvU88u8uenet1dSNo8L0N
        oniIJDpD5cyYPQBpLsJxDhqCLiUt6/7R5CyAVfNHv18cUv+lJHKaIHzs3b2AMDuaZlpu1R
        cj/xLLAe2sME7lPnC3Ee8rvOaamC4Gc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-DmfaigdmOXSEak0QqQVTTQ-1; Fri, 24 Apr 2020 12:59:03 -0400
X-MC-Unique: DmfaigdmOXSEak0QqQVTTQ-1
Received: by mail-ed1-f71.google.com with SMTP id b9so4078562edj.10
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 09:59:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r9ZP5gBjSYcrQ1pdJzHzCOFsb7HE7nAcgutpn4kecwY=;
        b=W0a6pOpU+puMjRbV6JONl4Cm3zHTaHvXpj8XTwVGVkYNbGeabgzlMS9iZ9cozKGB0C
         NA52LYqcOBJQUctY05fv0dtDkn2Dt9Ula4UHyRuDOzLdF5UKrmo3XzNE0F8RQyvA1ExE
         bdqzljEx/CcgU/1wIpMwYVtvK069p5QvKU8bKjCRPecdI/UarV7xdvERIkwIQRRQpCa2
         HM2Ov9TlrspPUgshrgmVedogR2x+wRpw/ne8I+PIcbMBhAiU9UGoR0BrADE2pUzD1B7k
         JTZ7hfazw3WKeVQookzWP0HSIFFVVKDzLZu34iRpuu8AeES3IWaB23xsqa8Fp9v6kpc8
         jSPw==
X-Gm-Message-State: AGi0PuZ22o37nnSzrYnxpkukgHvnoS+53qokACVYiX0qGZNCCzohJk6g
        /v61bjOr1t38n9ZbgX1Q/MPOcZ3N5q8YfJ2/ok9UETQeY+RLIekz9FYMIQT492Kmy4Ualo7jnTd
        aYDKh6Zx2xDP16nNCxUrV9sgiPg4ZEKPa
X-Received: by 2002:a17:906:18a2:: with SMTP id c2mr468694ejf.167.1587747541715;
        Fri, 24 Apr 2020 09:59:01 -0700 (PDT)
X-Google-Smtp-Source: APiQypJccAotCPBFuVal0QFfdgGjKHKIkMmrVZkQm1WSV6Qf4e9b1GkUXmoJdOPa+/Ymg6kstujmHhkSgAbNnwWjkTg=
X-Received: by 2002:a17:906:18a2:: with SMTP id c2mr468683ejf.167.1587747541491;
 Fri, 24 Apr 2020 09:59:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200423175857.20180-1-jhs@emojatatu.com>
In-Reply-To: <20200423175857.20180-1-jhs@emojatatu.com>
From:   Andrea Claudi <aclaudi@redhat.com>
Date:   Fri, 24 Apr 2020 18:58:50 +0200
Message-ID: <CAPpH65w0Lz2C+T8Zqa43OJgvM1Ky9VVsYafR9OkgFVCTnV_5dw@mail.gmail.com>
Subject: Re: [PATCH iproute2 v3 0/2] bpf: memory access fixes
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        linux-netdev <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, daniel@iogearbox.net,
        asmadeus@codewreck.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 7:59 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> From: Jamal Hadi Salim <jhs@mojatatu.com>
>
> Changes from V2:
>  1) Dont initialize tmp on stack (Stephen)
>  2) Dont look at the return code of snprintf (Dominique)
>  3) Set errno to EINVAL instead of returning -EINVAL for consistency (Dominique)
>
> Changes from V1:
>  1) use snprintf instead of sprintf and fix corresponding error message.
>  Caught-by: Dominique Martinet <asmadeus@codewreck.org>
>  2) Fix memory leak and extraneous free() in error path
>
> Jamal Hadi Salim (2):
>   bpf: Fix segfault when custom pinning is used
>   bpf: Fix mem leak and extraneous free() in error path
>
>  lib/bpf.c | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
>
> --
> 2.20.1
>

Acked-by: Andrea Claudi <aclaudi@redhat.com>

