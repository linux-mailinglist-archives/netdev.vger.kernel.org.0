Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE4CB1425
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 19:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfILRxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 13:53:44 -0400
Received: from mail-yw1-f43.google.com ([209.85.161.43]:44626 "EHLO
        mail-yw1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbfILRxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 13:53:43 -0400
Received: by mail-yw1-f43.google.com with SMTP id u187so9440961ywa.11
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 10:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KFWJxfXKxkTKECqHHRtYHNb4jz/B5/bqTvBlcHqTjQw=;
        b=f8PWIutOC3VSA2PobCe8iN/Zda5i9ypl4QufS66jsmsPcT0pv7fMNFLIxXUTpIuaLy
         LIxefEG8uoOExDPLrOKLL+Ey/0YlxpY9jnfVpYF6WyPMnt2s4da4zUJZzA+IekCn3aez
         KT/FSW2MCBGKAEPIisJENhjRDZxNDovHS1zG6zGIq+y45gvbUC+PtLFwQpZLeCKvBL4x
         I1xKpmyEZaD1pxWWQQ7tpRfguyRSUnuxXmweEJ1HnM/7mYne7pijzAuU1b2/wobmBdNL
         uMe1n7Q91yeEk1y6xmgFPvH79X45M8b69FSqTLPv5VXd943TGjn4ZFAyEQyc4Pd4VVdN
         6Aow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KFWJxfXKxkTKECqHHRtYHNb4jz/B5/bqTvBlcHqTjQw=;
        b=P0EhWegJmpI6msDUQNYFgimXRoRyFeg76IkhZzJxTYBfR+iSvMJshMkqm5NhceKmWI
         3XdNBfBkRmKin2830oR716Va/oWXYSqT1WrTO9ghXN3KWNJaGQS39u2Nn1qm2AGilvE0
         t4ls8kN9KwM9Anl7qEPLbP3HRUrkU1VNFFZ6J9N5B7esP1GVo6bq/iPlIk3gCqCLiJm3
         u/tA98jx41SWDGSeQ3QW1fUEIKtNMwC94giBOy6iaPwyaDDwPFtNNF6dlNHdGqjKjJTt
         392gj3YLUxPpTZ2GmkYG7oZjnr4x6JxyOFBRI+rYX4MTNTa5c8Hy3JtxRAo7rimo4Rye
         ZfxQ==
X-Gm-Message-State: APjAAAVyixkRXNcOE8ibF1Zo3J0E70OhMlJHZTePIxZXFBdnNW5b4giw
        D0f9d5/GMwpRBZTYpHEimxRa6popalPqmzKeRg==
X-Google-Smtp-Source: APXvYqwf0Zf2hVsplumXPmL/JtGhRtqnP56RSxJQj48fv0k9GajFsG47xh7O5KuqVh765FP9n4xOjZqFVYJrY4vzg6Y=
X-Received: by 2002:a81:3b09:: with SMTP id i9mr30070703ywa.166.1568310822669;
 Thu, 12 Sep 2019 10:53:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190911184807.21770-1-danieltimlee@gmail.com>
 <20190911184807.21770-2-danieltimlee@gmail.com> <20190912175921.02bcd3b6@carbon>
In-Reply-To: <20190912175921.02bcd3b6@carbon>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Fri, 13 Sep 2019 02:53:26 +0900
Message-ID: <CAEKGpzhz2jDdO2W7kaZxKQ-3Dkpvu5=DB=JumfcfxM-Hr7Fp0w@mail.gmail.com>
Subject: Re: [v2 2/3] samples: pktgen: add helper functions for IP(v4/v6) CIDR parsing
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 13, 2019 at 12:59 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Thu, 12 Sep 2019 03:48:06 +0900
> "Daniel T. Lee" <danieltimlee@gmail.com> wrote:
>
> > This commit adds CIDR parsing and IP validate helper function to parse
> > single IP or range of IP with CIDR. (e.g. 198.18.0.0/15)
>
> One question: You do know that this expansion of the CIDR will also
> include the CIDR network broadcast IP and "network-address", is that
> intentional?
>

Correct.

What I was trying to do with this script is,
I want to test RSS/RPS and it does not
really matters whether it is broadcast or network address,
since the n-tuple hashing doesn't matter whether which kind of it.

> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
