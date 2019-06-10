Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59D693BF9D
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 00:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390453AbfFJWwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 18:52:51 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37285 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390301AbfFJWwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 18:52:51 -0400
Received: by mail-lj1-f194.google.com with SMTP id 131so9593548ljf.4
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 15:52:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G0NAejhmEvRuu+rO8iY1KPiXgNlEWtZFyMC870o8MPI=;
        b=Jxf5ifIQI2YeVT5883nBhdb2RSDqTnAML+kcqe9Et/H/CRLBBQUNTRHzsGEbyB6gvX
         kzqH+4ys901vBA3H1yT+VvaoL15EDsmeMQo6cZShFkQInBI6BQnM6pU8shPr/+Z01Y/9
         A8qUe9/anOFQoh2y+u/qfmQ1HISyu5U2XD87suyP+2JTWaNKpDGkQr7BDv0JwLtdf8z4
         mPSOgZ9NtrApn2BUkVinCspxK1lGtWjfCr3x6F/X/DB8F8+6iohX0Wmp7lZpETsnH0WA
         MUKUCMgp8eM++QYvuKbJLwywHHzqp+cjo+54ovHw20Eo98IkpJPKF3eQaYMfBD0/wFQg
         Kxzg==
X-Gm-Message-State: APjAAAXcDbgwT/M38rE7SFZH3Gm+9F31RIKTancYnyw5XvzCdBiEf3k3
        RqB6jwCl7m9Jm8jYoXEYaOKUwPMDOWNOw/X08YdTdYxDMYU=
X-Google-Smtp-Source: APXvYqwkY1Dw0DKJBWkXZmRQAHxC+SOQV+sSKNTjE32SALamKfPob7KjgyoiQ0R0nq0Q/Tbu03iKYVksMhCAC2V1u0o=
X-Received: by 2002:a2e:9753:: with SMTP id f19mr14291500ljj.113.1560207169430;
 Mon, 10 Jun 2019 15:52:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190610221613.7554-1-mcroce@redhat.com> <20190610221613.7554-2-mcroce@redhat.com>
 <20190610154552.4dfa54af@hermes.lan>
In-Reply-To: <20190610154552.4dfa54af@hermes.lan>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Tue, 11 Jun 2019 00:52:13 +0200
Message-ID: <CAGnkfhyJeN853gmNX+Op88b4OTkuQdQt==FttFdb4WVPNmQ7zA@mail.gmail.com>
Subject: Re: [PATCH iproute2 1/2] netns: switch netns in the child when
 executing commands
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 12:46 AM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Tue, 11 Jun 2019 00:16:12 +0200
> Matteo Croce <mcroce@redhat.com> wrote:
>
> > +     printf("\nnetns: %s\n", nsname);
> > +     cmd_exec(argv[0], argv, true, nsname);
> >       return 0;
>
> simple printf breaks JSON output.

It was just moved from on_netns_label(). I will check how the json
output works when running doall and provide a similar behaviour.

Anyway, I noticed that the VRF env should be reset but only in the
child. I'm adding a function pointer to cmd_exec which will
point to an hook which changes the netns when doing 'ip netns exec'
and reset the VRF on vrf exec.

Regards,
-- 
Matteo Croce
per aspera ad upstream
