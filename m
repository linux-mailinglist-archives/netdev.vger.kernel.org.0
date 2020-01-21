Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF93D143C74
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 13:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729596AbgAUMDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 07:03:31 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:39761 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727817AbgAUMDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 07:03:31 -0500
Received: by mail-vs1-f67.google.com with SMTP id y125so1555732vsb.6
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 04:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zFf4dMyDozEW3IOrzotkvaUe/JQt5lueh29UH6I3hws=;
        b=vfQgaOaLZtpo33lDwt40fN1I3RHm4sLamOHLsoay0xylpktnfLHDGxkj5O+J342auS
         NNnN+/sERomOnu5HQ6Y3CMDGtHWIZY+R9XnT6X63JtHZ784bTBkoqK7nLU0PwRJWmAIz
         iSOYYssI/R5vhmyCzMhelFVjqMab9lNcxMSQT2phofYoueo3ue2rU9cPB9qqi9Z5/tpi
         GXdTqQwnxVAKIacXLuBA8q1/5jTXDx3Y7PhgbV+++uVqR4+c3Vhi4isvRefL+v4bf9Mc
         H+I2FL31af3mb6ezQGXEgxeHNSI9ckP7qo8nMI+DjN9ri9+LdfMje+nb4DNQZPJPCkZz
         7NKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zFf4dMyDozEW3IOrzotkvaUe/JQt5lueh29UH6I3hws=;
        b=k8MqqNvqx9fbFbR4xTYZlym3/t0qB4YiCWCSlJeuUquO/HiN5XQoJhQ3lZp19U3HR+
         Q7VenCNzaYQiKjxin5y6l47/kCE3T9eF6Ri3G4go011CRypd8aqjJA7KP+cNFEfkLm+6
         08paCS2t9V8HBEWZHbuzyLFmg+MIuYrFVY1QkKkQtoO67sK22DPlbTeH5/EehTAxGyKl
         E8As+ie+Qq+j9GfMdZ5aZIMpRpZgNLYr3OUi/E/qetvn5z2buXjE+X1GjQedK3w+93KL
         ayhnY14uI6YcwLZdIX8AwxVmz7PMiLVr7A7gZDyrEfzuCfT99zTyig73mIVAItJnGlOC
         zM9A==
X-Gm-Message-State: APjAAAWkHQF78W6plwZDXvj20IA7zGgZBfNQPNQUoYYHTwVB0brGLtnf
        vIKEBGbCx4+tCeE6EeWoayh6Hak6TLmE5StNcwu58g==
X-Google-Smtp-Source: APXvYqwNpegnjdQXWB57I9+MexzU6SpifsJySjzeGDMhcylmgvPG2z9xw60aRjIViHzYT1LNqFAhv2P6stEMRo7zERI=
X-Received: by 2002:a67:6746:: with SMTP id b67mr2173195vsc.193.1579608210362;
 Tue, 21 Jan 2020 04:03:30 -0800 (PST)
MIME-Version: 1.0
References: <20200115060234.4mm6fsmsrryzpymi@gondor.apana.org.au>
 <9fd07805-8e2e-8c3f-6e5e-026ad2102c5a@chelsio.com> <c8d64068-a87b-36dd-910d-fb98e09c7e4b@asicdesigners.com>
 <20200117062300.qfngm2degxvjskkt@gondor.apana.org.au> <20d97886-e442-ed47-5685-ff5cd9fcbf1c@asicdesigners.com>
 <20200117070431.GE23018@gauss3.secunet.de> <318fd818-0135-8387-6695-6f9ba2a6f28e@asicdesigners.com>
 <20200117121722.GG26283@gauss3.secunet.de> <179f6f7e-f361-798b-a1c6-30926d8e8bf5@asicdesigners.com>
 <20200120093712.GM23018@gauss3.secunet.de> <b0b4ba4b-1cdd-ad0b-32e4-2bc9610ff3e1@asicdesigners.com>
In-Reply-To: <b0b4ba4b-1cdd-ad0b-32e4-2bc9610ff3e1@asicdesigners.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Tue, 21 Jan 2020 14:03:16 +0200
Message-ID: <CAOtvUMdfxx=-XQMv=aFFjzSnLCL3b5UuvVOMzJVc2odSCZGtXg@mail.gmail.com>
Subject: Re: Advertise maximum number of sg supported by driver in single request
To:     Ayush Sawal <ayush.sawal@asicdesigners.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        manojmalviya@chelsio.com, Ayush Sawal <ayush.sawal@chelsio.com>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 20, 2020 at 2:35 PM Ayush Sawal
<ayush.sawal@asicdesigners.com> wrote:

> As we have a crypto accelarator as device when the request is send to
> the crypto driver from esp_output ,
> the aead_request has all the fragments in its src sg and the problem
> which we are facing is when this
> src sg nents becomes greater than 15 ,15 is our crypto driver's max sg
> limit to handle the request in one shot.
>
> Does it make sense for a crypto driver to advertise the maximum amount
> of sg it can handle for a single
> request and then handling this in crypto framework while forming the
> crypto request?
>

As I maintain the driver of another crypto accelerator I sympathize
with the need but I question the proposed solution.
Consider: your specific driver is limited by the number of
scattergather entries. Another implementation might be limited
by something else such as the total overall size of the request buffer
and probably half a dozen other considerations.
Should we now be passing all this capability information to the crypto
API core? and what happens if a new driver
has a limitation in a different quality?

So no, the solution to advertise the specific capability limitation of
each implementation does not seem to be a good one.
We already have a solution to the problem - initiate a fallback TFM
request and use it if you cannot fulfill the request on your own.

I do agree however that having each implementation registering and
keeping their own fallback tfm request just for these cases has some
overhead and a redundancy.

Maybe a better solution would be to allow implementation to return to
the Crypto API core a special return value (maybe -EAGAIN?) that tells
it that although the request is a valid one, this specific
implementation cannot fulfil it and let the crypto API core do the
fallback?

It sounds like it can be simpler to the implementation providers AND
save some redundant code...

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
