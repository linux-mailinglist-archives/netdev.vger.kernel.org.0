Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55FC8284DE
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 19:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731157AbfEWRZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 13:25:20 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35012 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730752AbfEWRZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 13:25:20 -0400
Received: by mail-qt1-f195.google.com with SMTP id a39so7701823qtk.2
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 10:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=jw3ieHIpiuuN2gVceKM+TXlU9vbb3kKDQJUo2RRdTmk=;
        b=jYb7nn5AKKzM1t9e1Ppg16EcjfJUxpFBAzxgq93doctILDNiEflj9dkYWDxD5Lfcvc
         lSX+uajkEg+LwkCdNyQxdnoWkRT7gtxAtjKkkV029TutvbYM5nCIMdAGgr0d9f7ub1bp
         2zDx2QSrmmT4BHH0lr8pARiXQ1ij/GIAnCf3Q0WFqeBa2VEBr3URAsB3gy7OF7rFJS7P
         LcvdFnox0o9qClKwPEtTybbw39BTkAPZtkrHKzJ4jQP816p3+YW4Ds47eBtMofG7m8AS
         o+SUWck9lJyW+Dwmd3wdwMsW/aC8En6/GhcpUGPhW2xQjrMjUFXNOf03S0QYI0PqzN/x
         Vo+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=jw3ieHIpiuuN2gVceKM+TXlU9vbb3kKDQJUo2RRdTmk=;
        b=Ty05mJDTon791ETUsVeDmbb1Phtb0eUeRJSs4Fvy8j4sLQ2BKL/wJCoFuQnNvbsiYZ
         K4UFFh07ItvEnkSFBpXX5NPRFnQPgIqcLejKwF5tPc/T4+dgKadp6mzvF1D+V4khL1+e
         oMGvrO4wOja0m0LkP7VpatpVAk3vDLoA8PSKuzdjZVlegbkmr70TjPFXl4rxxOV5GTcR
         sppFS0qYIxKkpCsiF5AlODHegklfijwafr/dwgMN56ZQYFeXJcd9bacnkIpcXlLW/bGk
         zgMFz1YHTs3LKt33RzEmcWEmHxnju8BF2Gmg61MtHOEzKjFyfe4R+N7b74ohy9TN2fYf
         0fhg==
X-Gm-Message-State: APjAAAWvo5Z5BAjZgCS6SIsQXtay4Fxp58WMcEC96Z1+7Qi3hsha/ABR
        Hh2OSpnzLVdXY49yx7c4lm6suQ==
X-Google-Smtp-Source: APXvYqzp3aHv77dTPDSx0+JDHbtSxm+mRyo1vJO0TtNRtUjqx0YE7zoQOREamS4Q5ddEtmnTly4+nw==
X-Received: by 2002:ac8:243:: with SMTP id o3mr53402403qtg.104.1558632319270;
        Thu, 23 May 2019 10:25:19 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v3sm20535184qtc.97.2019.05.23.10.25.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 23 May 2019 10:25:19 -0700 (PDT)
Date:   Thu, 23 May 2019 10:25:13 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "Cong Wang" <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: Re: [PATCH v3 net-next 0/3] flow_offload: Re-add per-action
 statistics
Message-ID: <20190523102513.363c2557@cakuba.netronome.com>
In-Reply-To: <1718a74b-3684-0160-466f-04495be5f0ca@solarflare.com>
References: <9804a392-c9fd-8d03-7900-e01848044fea@solarflare.com>
        <20190522152001.436bed61@cakuba.netronome.com>
        <fa8a9bde-51c1-0418-5f1b-5af28c4a67c1@mojatatu.com>
        <20190523091154.73ec6ccd@cakuba.netronome.com>
        <1718a74b-3684-0160-466f-04495be5f0ca@solarflare.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 May 2019 17:40:08 +0100, Edward Cree wrote:
> On 23/05/2019 17:11, Jakub Kicinski wrote:
> > On Thu, 23 May 2019 09:19:49 -0400, Jamal Hadi Salim wrote: =20
> >> That would still work here, no? There will be some latency
> >> based on the frequency of hardware->kernel stats updates. =20
> > I don't think so, I think the stats are only updated on classifier
> > dumps in Ed's code. =20
> Yep currently that's the case, but not as an inherent restriction (see
> =C2=A0my other mail).

I think we can all agree that the current stats offload only reporting
up-to-date HW stats when classifiers are dumped makes slight mockery of
the kernel API guarantees.  I feel like HW vendors found a subset of
the ABI to poke things in and out of the hardware, and things work
correctly if you limit yourself to that very subset.  So you only get
up-to-date stats if you dump classifiers, if you dump actions - no dice.

Whether it's on you to fix this is debatable :)  Since you're diving
into actions and adding support for shared ones, I'd say it's time to
rectify the situation.

Let's look at it this way - if you fix the RTM_GETACTION you will
necessarily add the cookie and all the other stuff you need in your
upcoming driver :)

> > But we can't be 100% sure without seeing driver code. =20
> Would it help if I posted my driver code to the list?=C2=A0 It's gonna be
> =C2=A0upstream eventually anyway, it's just that the driver as a whole
> =C2=A0isn't really in a shape to be merged just yet (mainly 'cos the
> =C2=A0hardware folks are planning some breaking changes).=C2=A0 But I can=
 post
> =C2=A0my TC handling code, or even the whole driver, if demonstrating how
> =C2=A0these interfaces can be used will help matters.

=46rom my perspective - you answered the question so I'm at 100% now ;)
