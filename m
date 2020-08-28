Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C881E256083
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 20:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgH1Sa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 14:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgH1Sa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 14:30:57 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB838C061264;
        Fri, 28 Aug 2020 11:30:56 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id l8so22905ios.2;
        Fri, 28 Aug 2020 11:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WtlD/YX0ISFkWguzbH4vW7Oxt2gP0SItAMBJ51jlhgA=;
        b=u5ZZ+sOob/NWIylD3FsfSRO2o52LyPkjnkvg6BJJxLxSFcoY7xVzCeX4o5AGNyENgh
         I0Mtklx0pRK3QUFdILooXaJLmJSj3Zur8vtXO0BEWiBRvQtlY0JKXlNT4jlCOrhFcnh1
         1a+KUhcq6JxCCvZRlGHL2USpA9248WhAKkf261bFTE/QE+9+b+qGpsJjA2G1/hq9YJea
         2xJpQ0Znplfsa8P4kG9U326heJw15KaQ2fmJxtG0t371dOMMZojXjDsMupXG4O0shg6S
         ps8DwCx2MwUEbulW0xnuo1CB5WK7kUJT4sPD+0c5+8pQ7AezyP4AOp/tZahCkw7gtGuf
         tkJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WtlD/YX0ISFkWguzbH4vW7Oxt2gP0SItAMBJ51jlhgA=;
        b=oFX7RbgpZQV8KdiTdcYXqvwHzLsqthzyC11O1X+oFUM4gIXRPfq5bSLv1kBMJ5xab/
         XYtGttlKc1YEk6a/cSB3cZyxnFWAXYmRLlFSVLc3zkY1QuolV6/4NXz1UUx7lxT0cXIX
         JVF6/dKWnkPCGWldqZnh94ONenqBN9bl/zBmrXKN0X1+qUaI2CD26xT+ej8t+icavnbV
         F7whKLz9bMDD+W0rKmPbO3HrKrnUmcK3VeG9pkydEJR3/57qsuew2HJzRaFYfZ8MoLr4
         c2fhcWu32+7uebxDU3sFurx0ohl5ZG/zOhH79vYtCKTBgb5NfSJhmdV6v7uCbTDcQfvy
         gWeQ==
X-Gm-Message-State: AOAM533IQz2Buxby9NdVj4o4Clpv0I+ckMzbBSmhIwAVVnwVkMIiJcXn
        41brg19dhxkeuAiVU87aV4X1IPR8+DUpoALuyHta29gl2wA7y+wh
X-Google-Smtp-Source: ABdhPJxUhh6t9XVY7PhXWTL6ZE6/DqCdX1N3g+eC6XgS+va1XX9sfw3FnM26dG5G4eZephV45h3TK5YQcgAKRGahT/w=
X-Received: by 2002:a02:e4a:: with SMTP id 71mr2317041jae.133.1598639456198;
 Fri, 28 Aug 2020 11:30:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200815165030.5849-1-ztong0001@gmail.com> <20200828180742.GA20488@salvia>
 <CAA5qM4CUO47EkJ-4wRoi0wkReAXtB5isLbvBEUw045po_TY8Sw@mail.gmail.com> <20200828181928.GA14349@salvia>
In-Reply-To: <20200828181928.GA14349@salvia>
From:   Tong Zhang <ztong0001@gmail.com>
Date:   Fri, 28 Aug 2020 14:30:45 -0400
Message-ID: <CAA5qM4ACaYfdj+MwACyS1oC+GT7KoD1T73DsAMPrpO9rqbxWkw@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nf_conntrack_sip: fix parsing error
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I think the original code complaining parsing error is there for a reason,
A better way is to modify ct_sip_parse_numerical_param() and let it return
a real parsing error code instead of returning FOUND(1) and NOT FOUND(0)
if deemed necessary
Once again I'm not an expert and I'm may suggest something stupid,
please pardon my ignorance --
- Tong

On Fri, Aug 28, 2020 at 2:19 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> Then probably update this code to ignore the return value?
