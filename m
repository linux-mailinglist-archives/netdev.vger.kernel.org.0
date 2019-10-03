Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D56D6CAF7B
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 21:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731894AbfJCTot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 15:44:49 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44982 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729580AbfJCTos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 15:44:48 -0400
Received: by mail-lj1-f196.google.com with SMTP id m13so4045300ljj.11
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 12:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n2k30PSN6KBYiYTwEMlue/4yres/+qOutu1EQ+XnO7s=;
        b=qzVc0KOtkoS4yPom3M2cGpmqJqWoCIiZJfppSKFXPzm9uMWDtn4YxviKAvNZzxxByQ
         IEK8KDI0rjj4tT5khb9ErYFM+/HwqpxEdQ/RGY/Y3qmzaWumMYkU3IoVPp5bZRUh+37Q
         SllPPDWJtFqbIdK9Wj/10eQ8AtbOb3q2Wc+1g44a5dmuJPQGbgLc/YHt7fSdWkoH5RYE
         KCn2RQNHyCqDVzrkeckwKNGFapW9/kmMNDOvVTetgUrHO9hU9nktdwLFKNg2XrTSmaxg
         2pqu5yznGk7syf29afgaFnZ9TH9Wk/meHbO/39CEOkPfjnyCQstFs2XtFA9jY/rpbKGY
         G4hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n2k30PSN6KBYiYTwEMlue/4yres/+qOutu1EQ+XnO7s=;
        b=JiC9RC8m0FZNqFVyS/a1/Mhq2cy5lOYCzySdXgWLKebuvJG6K6oBjbzKyzyVQi4+RE
         bguYhtU9NglhLkIZR4yV9f17OQGif7+hO+QiYHsAFc9Wo0Ez/waKzQD0fe1Q6RaK+r3+
         YPytrBiZ3o8arC6JXotHdOQy5wLKMv1IzS1JdrhGAFsY/U6ixCPUwdGeLWXBFRItTsur
         oOx7aaeK3Jd9UeMRvoBX3BCUSD5M4L3luSCfBpYAobT1QYAmVAViL9deeQ6CiZ9lP8Aj
         2A/3CgE50rg3LguaV1bD5Z3Ca/fftpVZkH4CF+9/tXbmdkdsMQcK8xCffO1McpdBQyVc
         3QUg==
X-Gm-Message-State: APjAAAW2g+eT2aw4IFCwlE+bIBFaWms2HPxrDLJ+ZFmcLs0jnT5ywvIK
        MGWe4Hym4ylxy9xDz3T7WaQrV0ez1lRa+KB8xgfqWtV+
X-Google-Smtp-Source: APXvYqxMc89qFbbJIp+wRDtBstlluUDKso1adTq2Rjxgz7mQZXWa+TozgctEeK9UgqEGMkaknLqbEOLRxSc33ZGZ36M=
X-Received: by 2002:a2e:8507:: with SMTP id j7mr6967214lji.151.1570131886502;
 Thu, 03 Oct 2019 12:44:46 -0700 (PDT)
MIME-Version: 1.0
References: <1569872344-14380-1-git-send-email-yihung.wei@gmail.com> <20191003.113136.126771249367519292.davem@davemloft.net>
In-Reply-To: <20191003.113136.126771249367519292.davem@davemloft.net>
From:   Yi-Hung Wei <yihung.wei@gmail.com>
Date:   Thu, 3 Oct 2019 12:44:35 -0700
Message-ID: <CAG1aQh+4Fvorcwq5jUw5dXK2yn+UDQJAmQ4XGKpV7EtUzciA5g@mail.gmail.com>
Subject: Re: [PATCH] openvswitch: Allow attaching helper in later commit
To:     David Miller <davem@davemloft.net>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 3, 2019 at 8:31 AM David Miller <davem@davemloft.net> wrote:
>
> From: Yi-Hung Wei <yihung.wei@gmail.com>
> Date: Mon, 30 Sep 2019 12:39:04 -0700
>
> > -             if ((nf_ct_is_confirmed(ct) ? !cached : info->commit) &&
> > +             if ((nf_ct_is_confirmed(ct) ? !cached | add_helper :
>
> I would suggest using "||" instea of "|" here since you are computing
> a boolean.

Thanks for review.  It makes sense to use "||" rather than "|".  I
will wait a bit to gather more feedback before I send v2.

Thanks,

-Yi-Hung
