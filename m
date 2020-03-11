Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F591180EDA
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 05:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgCKELT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 00:11:19 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34477 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgCKELS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 00:11:18 -0400
Received: by mail-io1-f68.google.com with SMTP id h131so532701iof.1
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 21:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yD04ayhgXRDh2Wl14Dl/6WW6EzN36RLlzsjiX7OaNuY=;
        b=aOmFT9V8AG2kc6w0nm0D72zCpQWbzAe3YjDSPGrbsPCuJSdBkdLUopBrWh1BZ2Vs1+
         5yEczlFcDDT9DUqR8UKk2JoLEtMsb2cBwAnKL26Mnc0lpErLfLoYPdYr1UVEF5kVFfKo
         EC89LXwn9YtGsLNABoI+rnE8yCGYYdg6qNBIF8pvQjovNvEASg7Nd1aqp5ams6JgFStP
         RcPWC1s28mQSvRG60ZX0WTsDVdnRbvhWWwVY7uq10KuTgx/kjZ0dxSdKAejXUNTmdVD2
         Vq9/XgdHlFvLT3TiKtTQSdA/zNkQGkgkKfk7oImUudsxH5qWWz4fB7fog/R9s39itgQi
         qOXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yD04ayhgXRDh2Wl14Dl/6WW6EzN36RLlzsjiX7OaNuY=;
        b=GPRlSemkYnrIwW7lQCkctYFpo1Dh/deGMe/3Vj2DimX6WgImJr02JSYryah4fkcfFn
         tvWxyptcNum9Nfp2Scv2f0mW59dkbEGLQp/YO2psY45Ao4NRPp7PfR/n67+MZds87muR
         Y72Se9oziWjSiyv1/H+fGfaNMmD+rooKAhNJ59BlesR8NlVxQG8uEhJYJOs+QKUJjpxU
         gigtQUXW07QVow2fqjnsu+xsTBxAbt3LYnB2MTHvd+UQyMZuhtxVd3X/iRUDDZBf58XL
         ELF260rKy47uAYuFpnVBPTcof7GszjmYL3PIqIgAMbQgYRSaDAh/5Loy9k2eTTbuNrW7
         8/GQ==
X-Gm-Message-State: ANhLgQ3mjerf9Iv/NLAOLpQA8xF1uu4QxgxEBk3vTA5mg/IWCu4/W1SL
        AVawChgkmBCl8xYARiXVBEhKzD64rH/wHwyd20U=
X-Google-Smtp-Source: ADFU+vuJiOLGfNgc2YhvQOZtD5ggqJ7qS8rFI1p3PsIYjNpev3VqvVcqZ0b9EKPbGH77EpR9/H7KtXwl1gDTSOp6MA4=
X-Received: by 2002:a02:81cd:: with SMTP id r13mr1271226jag.98.1583899877795;
 Tue, 10 Mar 2020 21:11:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAHfguVw9unGL-_ETLzRSVCFqHH5_etafbj1MLaMB+FywLpZjTA@mail.gmail.com>
 <20200310221221.GD8012@unicorn.suse.cz>
In-Reply-To: <20200310221221.GD8012@unicorn.suse.cz>
From:   Andrej Ras <kermitthekoder@gmail.com>
Date:   Tue, 10 Mar 2020 21:11:06 -0700
Message-ID: <CAHfguVy4=Gtm0cmToswashVSwmS+kOk57qg+H+jspaHrH8tJkg@mail.gmail.com>
Subject: Re: What does this code do
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I understand that the code is appending data, what I do not understand
is why is it first calculating the remaining space by taking the
difference using the size of mtu and if the difference is <= 0 it
recalculates the difference using maxfraglen. Why not just use
maxfraglen -- All we need to know is how much more data can be added
to the skb.


On Tue, Mar 10, 2020 at 3:12 PM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Tue, Mar 10, 2020 at 02:42:11PM -0700, Andrej Ras wrote:
> > While browsing the Linux networking code I came across these two lines
> > in __ip_append_data() which I do not understand.
> >
> >                 /* Check if the remaining data fits into current packet. */
> >                 copy = mtu - skb->len;
> >                 if (copy < length)
> >                         copy = maxfraglen - skb->len;
> >                 if (copy <= 0) {
> >
> > Why not just use maxfraglen.
> >
> > Perhaps someone can explain why this is needed.
>
> This function appends more data to an skb which can already contain some
> payload. Therefore you need to take current length (from earlier) into
> account, not only newly appended data.
>
> This can be easily enforced e.g. with TCP_CORK or UDP_CORK socket option
> or MSG_MORE flag.
>
> Michal Kubecek
