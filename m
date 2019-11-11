Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E56CF7A35
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 18:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfKKRt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 12:49:58 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34768 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbfKKRt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 12:49:58 -0500
Received: by mail-qt1-f195.google.com with SMTP id i17so5003033qtq.1
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 09:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+b/prdXiChqXrDLN6fg8F0sRifSBV6CYQ704ds7X8bY=;
        b=bgT+PJeyLGo/tn+aSRVNpN7gCjYn/oRc80lYiSXJLI79g/RihuuEhCT7ujzPrA3VeP
         v0t+YE3TVLIa0AiBSKGpXxNKzrxnm+iu6VO00pnlwKQDmZh8SDJ1s7+cG9iCRe4yG5lG
         jKeQkMxKMAzFMp4eRDHXEDYsF110TPxhNMMZ30/X852GdBJlV7bPkJEnb57mxLno641S
         qAwFrNS54ZiNLymYVejObHfUlgTEPGMyUNjXm0aDWTwp54cYt0vslyIf+lCsV8Gedq9h
         yWEPimuShaecVDQpO5GMKDRpIpL8LXd1RehlsOBwiGIE5M8kmkUjxAuThfEucDQRgYxV
         Doeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+b/prdXiChqXrDLN6fg8F0sRifSBV6CYQ704ds7X8bY=;
        b=IrEvYQAS1+vFx0BCTHgby0aoVQOqBjiYrxdxnsO+76OPnDqc9sKI3gmEEYqtFcQQrQ
         jbyOrakVINNzhAS1gfmww8THJwUwqbMkAnEV12rx/twwgIpOHwKvGKOKro8f4xj+P4aU
         8ONCNbx8ORxluBX1oyB3ZCczCu7tfZtY/3sf1dkcT/Z5L8Xy4Dqkj96h+8HLLXeIadbJ
         +J+8UEF9TIOANyCyIvHB20AEsaY2FAQ5hEYLqNtBkrL5xtQ/ex1eMGchXor3HuYQYSPj
         e2loxJdcHOSnFpYVA+EDCxA4ATtBpk6qic3cdSk52SPiH5/nbOqW/5QEsmy3lnPggfCx
         8cqw==
X-Gm-Message-State: APjAAAXLP3r9QAp+TFVDmpbvrQQubpZ8T2tkRYkfbakrRuyUd39ILQ9j
        xd3kC5ayepRqCJfMLL2kJ//1X4hmAaX57WfOpr5YcQ==
X-Google-Smtp-Source: APXvYqy5f3F4pZhu16CxXOuGuRNTTlL+XeTiPKSaRJxwRi8DeVdGAOFa/C0eiwoN7Zd/5eF7CvvmPy5gGpi8yEiB/4Y=
X-Received: by 2002:ac8:384f:: with SMTP id r15mr27335023qtb.155.1573494596743;
 Mon, 11 Nov 2019 09:49:56 -0800 (PST)
MIME-Version: 1.0
References: <20191101173219.18631-1-edumazet@google.com> <20191101.145923.2168876543627475825.davem@davemloft.net>
 <CAC=O2+SdhuLmsDEUsNQS3hbEH_Puy07gxsN98dQzTNsF0qx2UA@mail.gmail.com>
 <CANn89iJUVcpbknBsKn5aJLhJP6DkhErZBcEh3P_uwGs4ZJbMYQ@mail.gmail.com>
 <CAC=O2+R3gHT6RtqL6RPiWsyuptpa+vrSQsxdN=DW1LaD1B-vGw@mail.gmail.com> <CANn89iLPfy6Nbk0pouySQq=xVsEOGJMkVEXM=nKWW3=e4OGjoQ@mail.gmail.com>
In-Reply-To: <CANn89iLPfy6Nbk0pouySQq=xVsEOGJMkVEXM=nKWW3=e4OGjoQ@mail.gmail.com>
From:   Thiemo Nagel <tnagel@google.com>
Date:   Mon, 11 Nov 2019 18:48:09 +0100
Message-ID: <CAC=O2+QG6vdJxjHT9yVQ4c78qG6LdREJch0Z5gKvcdfO94t9Rg@mail.gmail.com>
Subject: Re: [PATCH net] inet: stop leaking jiffies on the wire
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Eric,

I think we should distinguish two different problems here:
a) There's insufficient entropy to seed the RNG. As a consequence,
observing a (partial) sequence of numbers may allow an attacker to
determine the internal state, independently of whether the RNG is
cryptographically secure or not.
b) The RNG is not cryptographically secure. In that case, observing a
(partial) sequence of numbers may allow an attacker to determine the
internal state, independent of the amount of entropy that was used to
seed it.

Problem a) is hard -- as you mention, it may require hardware support
to solve it fully. However the problem that I'm suggesting to address
is b), and that likely can be solved by swapping out prandom_u32() for
get_random_u32().

> If IP ID had to be cryptographically secure, you can be sure we would
> have addressed the problem 20 years ago.

I don't think this is a valid point at all. There are countless
examples of things that weren't known 20 years ago but that are better
understood today. One relevant example is RFC7258 which only came out
in 2014.

Kind regards,
Thiemo
