Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA9B29469B
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 04:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440090AbgJUCht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 22:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440082AbgJUChs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 22:37:48 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE2EC0613CE;
        Tue, 20 Oct 2020 19:37:46 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id i5so851128edr.5;
        Tue, 20 Oct 2020 19:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=y3k7r6MRALM8QYMM8r4V3Z5YJ0zPqyut63Xahu5+4sw=;
        b=a4cJ1bkdtV7u42x/LEoQn8WDnK3R06Chgjyw8HVEiPOawX1nAM532Oj2NGzqU/PYq1
         iHlJRsH9/LxcUoX/WRpJAaVWbF8C2Sk/BDx8fOcDHZSVZD1JRXDKgvvSNUKIRDkq+Z3r
         qoJJfb748p5vcVkATXh/rKb+ghirS1gclZMRTAnXUi7g4xjpZsC8sH/KAsqWOP+5gTL1
         sWtNnRZiuLdK64Rodb69OT4hHswR/JgHKcxvDDDLw6KJnPi0nXHRQp2lGGsNU0JjvFSN
         NvVRRQeR7qflZOaaVZ3bWB+q5jDy5SyCjtpCeV593CnHC+ANCsBIWW7kA5foaWBSGUJL
         UJfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=y3k7r6MRALM8QYMM8r4V3Z5YJ0zPqyut63Xahu5+4sw=;
        b=lCyV9NaJzQcx33DWEIi1Mdg4o0RPlJr3yiXGaJazTE1eEtjx0vjuOB2xjOOHAdZ8aZ
         aV/j47ADu9FUKdeaFSd0Z0JbpyvVz/OPX6CfpkEr5HBOJdbsfDBxWwrLUNBGeg8aB0OH
         iB6RNOpPwi8Mla718i/b9t5zdsSGXW6An3ETNV5gqfRNBeBJN2uDTIl6xNRKpL/llQm9
         BcUta6ByrVEiMzuCZAdc4R7VIQL9QpA9wYc78GTZldSX2Ikyx0wMyvxtnQ/jXkCVf9tR
         joKPUjIfcjwdVJfw8+S/4i4NWddmlswr1KBVc6ijF2LCc96U5QH2S3jQUfAXGiipDFlo
         MRfQ==
X-Gm-Message-State: AOAM532b1AUeW7+5046fg05Zj12aWYRlIXbO7jqbdvoLVMFj6ztC/7B4
        ZGwNEInCvcGwzpR9GH8EZsiG0e6FEfuQKt54f0s=
X-Google-Smtp-Source: ABdhPJx8Ke+fSB76kZaruZsNhiqb4vwaXpNG/8cynM3eDnwxnamN3L9gEKlyb2buUHK8mOtte0EArdln9NXREw2+lE0=
X-Received: by 2002:a05:6402:1a43:: with SMTP id bf3mr936992edb.8.1603247865582;
 Tue, 20 Oct 2020 19:37:45 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1603102503.git.geliangtang@gmail.com> <20201020163923.6feef9ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201020163923.6feef9ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Geliang Tang <geliangtang@gmail.com>
Date:   Wed, 21 Oct 2020 10:37:33 +0800
Message-ID: <CA+WQbwuHpxpSLK1Y4bTArNm1QxMQ28WQiFT+gyJoN_Neid3sow@mail.gmail.com>
Subject: Re: [MPTCP][PATCH net-next 0/2] init ahmac and port of mptcp_options_received
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Krystad <peter.krystad@linux.intel.com>,
        netdev@vger.kernel.org, mptcp <mptcp@lists.01.org>,
        "To: Phillip Lougher <phillip@squashfs.org.uk>, Andrew Morton
        <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Coly Li
        <colyli@suse.de>, linux-fsdevel@vger.kernel.org," 
        <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Jakub Kicinski <kuba@kernel.org> =E4=BA=8E2020=E5=B9=B410=E6=9C=8821=E6=97=
=A5=E5=91=A8=E4=B8=89 =E4=B8=8A=E5=8D=887:39=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, 19 Oct 2020 18:23:14 +0800 Geliang Tang wrote:
> > This patchset deals with initializations of mptcp_options_received's tw=
o
> > fields, ahmac and port.
>
> Applied, but two extra comments:
>  - please make sure the commit messages are in imperative form
>    e.g. "Initialize x..." rather than "This patches initializes x.."
>  - I dropped the Fixes tag from patch 2, and only queued patch 1 for
>    stable - patch 2 is a minor clean up, right?

Yes, that's right. Thanks for applying and updating the patches.

-Geliang

>
> Thanks!
