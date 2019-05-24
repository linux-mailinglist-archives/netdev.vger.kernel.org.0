Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10A7629D67
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 19:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390955AbfEXRom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 13:44:42 -0400
Received: from mail-ua1-f67.google.com ([209.85.222.67]:38227 "EHLO
        mail-ua1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbfEXRom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 13:44:42 -0400
Received: by mail-ua1-f67.google.com with SMTP id r19so3909594uap.5
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 10:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=7PvtPwweWOME38vsYbdUWFDJ3QLUoixmag8ZjFrrNJs=;
        b=tKjPwNAFpy8/k7GeMjn8QjQYhmk8+WnXpK9fPQqlbrw350LME5KlFLhcIW5N6K/wht
         p8dI9/HWZrgtesQm/5Gzw5b7qs3R1dKStKXOLdEzmeAo0AioHTERrEWvlZRLKWDf/A41
         eXV9I6IvcczBitw3UdN5w16s2rtHS0CzSSWrfbyI7FGLQSTXOWw4I/m5rDBVt4fCkZEg
         1nDIsBzPaN5WZfY+bYwnJXF8uFzEcWdm+bUItcmBOxzfJQxnCcsx1lAJ8posgHTFtRqx
         9D8deAr5XtLPbmuqMQ0CotXCM4U4GT5GpO93mfqCsHXe/VuUxlkaGg5OmxMdSEZMDX+x
         ZBwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=7PvtPwweWOME38vsYbdUWFDJ3QLUoixmag8ZjFrrNJs=;
        b=rWqNVgjUVx8oMmMNd//4cYCBWjNZO6dMJjdGjDY3kty+YrG8ucnivBvLfDtvB4jzic
         bisj3Yop6gOP0yghPYYdmPWMlVJD03Cu24lSByh1POo0SqpjacyyYJJsGQwcfD1aMh6I
         RD9WP7+0uuJ9odDTgGdYXe1ofI3wm48Zo1U2TiifLD07sB8RNgDDTdkrSZFL2T45ks50
         FjAuJYD1FWsGKxOxuoDOpDJi+E8PJHmCWVN3p8EQz82MbdO0Ac69ujMe/dHA6fDTVKcD
         57NGKSaHQgljavu0hOqglL86Lt4YV6VTXstM1c6n4x+cHf5hJbAdGBHqruXLzOcOqg8y
         NEEw==
X-Gm-Message-State: APjAAAWwOkNSzKYJ2ANQuMpnyXs2rsW0ZQW+5akDDmJonFRRgIQ8cm9Z
        YeqfuI4ZklWj1O0YJjefR+1jew==
X-Google-Smtp-Source: APXvYqz6vOgSNIsBmayhPzM3e8gF15IXsQjBC9zDB7u0j1FUX5UY4EWsMJo4M01dUuphYUhoiizV4g==
X-Received: by 2002:ab0:4127:: with SMTP id j36mr21914179uad.125.1558719881065;
        Fri, 24 May 2019 10:44:41 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d4sm709517vkl.6.2019.05.24.10.44.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 24 May 2019 10:44:40 -0700 (PDT)
Date:   Fri, 24 May 2019 10:44:36 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Andy Gospodarek" <andy@greyhouse.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: Re: [PATCH v3 net-next 0/3] flow_offload: Re-add per-action
 statistics
Message-ID: <20190524104436.35bf913b@cakuba.netronome.com>
In-Reply-To: <355202da-6c69-1034-eb29-e03edfe0fe2c@solarflare.com>
References: <9804a392-c9fd-8d03-7900-e01848044fea@solarflare.com>
        <20190522152001.436bed61@cakuba.netronome.com>
        <fa8a9bde-51c1-0418-5f1b-5af28c4a67c1@mojatatu.com>
        <20190523091154.73ec6ccd@cakuba.netronome.com>
        <1718a74b-3684-0160-466f-04495be5f0ca@solarflare.com>
        <20190523102513.363c2557@cakuba.netronome.com>
        <bf4c9a41-ea81-4d87-2731-372e93f8d53d@solarflare.com>
        <1506061d-6ced-4ca2-43fa-09dad30dc7e6@solarflare.com>
        <20190524100329.4e1f0ce4@cakuba.netronome.com>
        <355202da-6c69-1034-eb29-e03edfe0fe2c@solarflare.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 May 2019 18:27:39 +0100, Edward Cree wrote:
> On 24/05/2019 18:03, Jakub Kicinski wrote:
> > On Fri, 24 May 2019 14:57:24 +0100, Edward Cree wrote: =20
> >> Argh, there's a problem: an action doesn't have a (directly) associated
> >> =C2=A0block, and all the TC offload machinery nowadays is built around=
 blocks.
> >> Since this action might have been used in _any_ block (and afaik there=
's
> >> =C2=A0no way, from the action, to find which) we'd have to make callba=
cks on
> >> =C2=A0_every_ block in the system, which sounds like it'd perform even=
 worse
> >> =C2=A0than the rule-dumping approach.
> >> Any ideas? =20
> > Simplest would be to keep a list of offloaders per action, but maybe
> > something more clever would appear as one rummages through the code. =20
> Problem with that is where to put the list heads; you'd need something th=
at
> =C2=A0was allocated per action x block, for those blocks on which at leas=
t one
> =C2=A0offloader handled the rule (in_hw_count > 0).

I was thinking of having the list per action, but I haven't looked at
the code TBH.  Driver would then request to be added to each action's
list..

> Then you'd also have to update that when a driver bound/unbound from a
> =C2=A0block (fl_reoffload() time).
> Best I can think of is keeping the cls_flower.rule allocated in
> =C2=A0fl_hw_replace_filter() around instead of immediately freeing it, and
> =C2=A0having a list_head in each flow_action_entry.=C2=A0 But that really=
 looks like
> =C2=A0an overcomplicated mess.
> TBH I'm starting to wonder if just calling all tc blocks in existence is
> =C2=A0really all that bad.=C2=A0 Is there a plausible use case with huge =
numbers of
> =C2=A0bound blocks?

Once per RTM_GETACTION?  The simplicity of that has it's allure..
It doesn't give you an upstream user for a cookie, though :S
