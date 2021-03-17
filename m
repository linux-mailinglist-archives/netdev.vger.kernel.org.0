Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D2133E9DC
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 07:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbhCQGh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 02:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbhCQGhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 02:37:24 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06CE3C06174A;
        Tue, 16 Mar 2021 23:37:24 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id o9so39862440iow.6;
        Tue, 16 Mar 2021 23:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DbC+gs/ML7S9YV18aQwCjeRAbouX268bLy5YLU6qrlk=;
        b=YulLsjRVTBH4mMqaltNtXKYYbRdqV8vfeBBVKWh6kOsiKAqeOtqCTfNpWOqTR/zI9K
         gZa8AsVQJzF/lh5mHP9cGhaa4dGMid2V/0b0sGxjnFmxnIQwh/11iG2P4h2nN3hbF5vX
         1X/N7SwchxDFWK1b8ApBsalRebfsxYzudRFZvTr/hoYjOEyIBgHpxtH1Ud1UNPg8fSuC
         ZV5VMUk0f9B9VSTCm5ODOl8IMCbjZVEp5uD1aaMtj5uf2tHiq7JCu5cAkwuSSv+MXZFO
         GGczxZPjkPwP4Ng1hTnUxdrWXQnwa9xkX6KyvEhIQqSFBpEhkWgZj5p87vpbpGMpeHzD
         sPzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DbC+gs/ML7S9YV18aQwCjeRAbouX268bLy5YLU6qrlk=;
        b=tDJnzMWtWV7arbk1jlQkHwOiLosm5Qxf+cjnTFgoBD+a67Ht8dP/mkDBsqhzsQe//D
         FLyDloLT/g2Jh+w7lTwrfgtbktUdX0AscxYInkCzZjNF6sC4reXDkcsQkP+g7D3Dk85o
         HCia4PCNNwJtpIQ80Ozt13Mzpl0ZXYIRYnQDTZ5dl9hc3xUUHzrjHkPE/Q8yU6ylppEj
         LyBSDAFPL2njaHk6qaW2YQH/K6RqDbsFSk8ZC2m0lfEY0XQuw+vOWbkkiiGBi/966i1v
         1WY7qbEkczWOho23W2jWb0So16KBohSVocc4W8wGq33tpKnqx20Acp7eo3oYGaWwQWjw
         smiA==
X-Gm-Message-State: AOAM530mcX2i1fWd1iq+4bceEZeTlyZfgTAspz+7Yvz7r1Ty0MV0iU8I
        4x6NehTUFpVdwiCKxnNhW4IbW3FiwxkDGUsUFxk=
X-Google-Smtp-Source: ABdhPJxzQh1bVQDLXIpJrB9qnI3x5RzecElEOMCAuB0OT8NviU0FYdcLBko0nK83IVxcLYNrdxPcK4jFgMrzRuZwsB4=
X-Received: by 2002:a02:94cb:: with SMTP id x69mr1803285jah.8.1615963043465;
 Tue, 16 Mar 2021 23:37:23 -0700 (PDT)
MIME-Version: 1.0
References: <1615886833-71688-1-git-send-email-hkelam@marvell.com>
 <1615886833-71688-5-git-send-email-hkelam@marvell.com> <20210316100616.333704ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210316100616.333704ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Wed, 17 Mar 2021 12:07:12 +0530
Message-ID: <CALHRZuq272aJR8Jh5rS7y-b28t6eHhthPB_6aUoZExv0dCsorQ@mail.gmail.com>
Subject: Re: [net PATCH 4/9] octeontx2-af: Remove TOS field from MKEX TX
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hariprasad Kelam <hkelam@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        lcherian@marvell.com, Geetha sowjanya <gakula@marvell.com>,
        jerinj@marvell.com, Subbaraya Sundeep <sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Tue, Mar 16, 2021 at 10:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 16 Mar 2021 14:57:08 +0530 Hariprasad Kelam wrote:
> > From: Subbaraya Sundeep <sbhatta@marvell.com>
> >
> > TOS overlaps with DMAC field in mcam search key and hence installing
> > rules for TX side are failing. Hence remove TOS field from TX profile.
>
> Could you clarify what "installing rules is failing" means?
> Return error or does not behave correctly?

Returns error. The MKEX profile can be in a way where higher layer packet fields
can overwrite lower layer packet fields in output MCAM Key. The commit
42006910 ("octeontx2-af: cleanup KPU config data") introduced TX TOS field and
it overwrites DMAC. AF driver return error when TX rule is installed
with DMAC as
match criteria since DMAC gets overwritten and cannot be supported. Layers from
lower to higher in our case:
LA - Ethernet
LB - VLAN
LC - IP
LD - TCP/UDP
and so on.

We make sure there are no overlaps between layers but TOS got added by mistake.
We will elaborate the commit description and send the next version.

Thanks,
Sundeep
