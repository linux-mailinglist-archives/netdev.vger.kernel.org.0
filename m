Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CABE30317
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 22:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfE3UBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 16:01:34 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34932 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfE3UBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 16:01:34 -0400
Received: by mail-lj1-f193.google.com with SMTP id h11so7325802ljb.2
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 13:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xHTu5Y/36MEqwnN11ZHruwFNlA0FJURgmDJt7FE/4y8=;
        b=JyjfewCxqs9P6zucEu3lR5OQLMDl8lqLZgiC9dHbKBne8tGSzHmvrmwCLCxvJvaNwa
         G04i9ZmkkgGeJrsl37oRhSxRcdJPVkpX/rHCi5ore/XuRwJyUGgpIx9q+uZdfd8VZSO4
         ClGoF0K2EdIsqxtOhpctRB3wN2WurHvJqKpnWMvWK7kFFmJ5++QlMuD49nxxLFVDpjZR
         NxbBQsY0RzoP5ac+4UShUrbM0RX5PbggY3uILY1IlwtBGtCyf7ol9eYEoRZREdR+8Ie2
         Zt/QTkS75grE54hVk7lOCL85TRb08uUk+AgVe7aSVRG8oZuuV48OclvR8Lk/poo9/svP
         qLyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xHTu5Y/36MEqwnN11ZHruwFNlA0FJURgmDJt7FE/4y8=;
        b=G3+gZ7DHtf9d5Ajc29GMIDRwx81EvGshw1BnYK9NKfw50PjwbMJoZ6Ml6sO3CTRlj6
         oH8repVPcabFg6SNROcLUYoraJb8nRqp1WdH8wQo3SRa2dnqXAnwzw7YEYkgjvaR5avg
         Z+vykzsKsYPthK58/B/wc2+Zaovts6G8VtDLsk/vHFzT4YX0NZSv+MyxVZS64LYoEXea
         HIJzCq3yFOmZDCtqjMIevxgPt2mH3mhS9+uxx6I6/G4ltrDCc7spt/T5E+msR/mnysAZ
         tahf6nmkKGOTwDdwqLpuRtHKn39dr9kxtBlI+Fi4scHqgx9Z0VX8JFF4yC+1XJm/ViSp
         SUZw==
X-Gm-Message-State: APjAAAU0FiAsRlu4Oh4zAQynOMZ655MeWoNSIxwtW6kRzzT54pxQ0PU0
        aFOYEAvqzHWUYn32PaNV9XE21E0364Zg7OcV3G8=
X-Google-Smtp-Source: APXvYqw/HMVxgAfrqpkMzU2KY+rHAW/J/GmQNfjdSltZ+2r30bpCiTGKguLiH7M9D3FO+P+/PKSuOjKkXF6Ah37Mbtw=
X-Received: by 2002:a2e:994:: with SMTP id 142mr3298618ljj.192.1559246491844;
 Thu, 30 May 2019 13:01:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAADnVQ+nHXrFOutkdGfD9HxMfRYQuUJwK8UMPGtbrMQBNH4Ddg@mail.gmail.com>
 <d110441b-8d69-0d11-207f-96716d7bc725@gmail.com> <CAADnVQJ-aBTFC1BeMiNRD=42qcdw83D_t0zDVzEX+OfFvt7K0g@mail.gmail.com>
 <20190530.110149.956896317988019526.davem@davemloft.net> <CAADnVQJT8UJntO=pSYGN-eokuWGP_6jEeLkFgm2rmVvxmGtUCg@mail.gmail.com>
 <65320e39-8ea2-29d8-b5f9-2de0c0c7e689@gmail.com>
In-Reply-To: <65320e39-8ea2-29d8-b5f9-2de0c0c7e689@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 30 May 2019 13:01:19 -0700
Message-ID: <CAADnVQ+KqC0XCgKSBcCHB8hgQroCq=JH7Pi5NN4B9hN3xtUvYw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/7] net: add struct nexthop to fib{6}_info
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 11:52 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 5/30/19 12:27 PM, Alexei Starovoitov wrote:
> > On Thu, May 30, 2019 at 11:01 AM David Miller <davem@davemloft.net> wrote:
> >>
> >> From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> >> Date: Thu, 30 May 2019 08:18:10 -0700
> >>
> >>> On Thu, May 30, 2019 at 8:16 AM David Ahern <dsahern@gmail.com> wrote:
> >>>>
> >>>> On 5/30/19 9:06 AM, Alexei Starovoitov wrote:
> >>>>> Huge number of core changes and zero tests.
> >>>>
> >>>> As mentioned in a past response, there are a number of tests under
> >>>> selftests that exercise the code paths affected by this change.
> >>>
> >>> I see zero new tests added.
> >>
> >> If the existing tests give sufficient coverage, your objections are not
> >> reasonable Alexei.
> >
> > I completely disagree. Existing tests are not sufficient.
> > It is a new feature for the kernel with corresponding iproute2 new features,
> > yet there are zero tests.
> >
>
> Your objection was based on changes to core code ("Huge number of core
> changes and zero tests"), not new code paths.
>
> The nexthop code paths are not live yet. More changes are needed before
> that can happen. I have been sending the patches in small, reviewable
> increments to be kind to reviewers than a single 27 patch set with
> everything (the remaining set which is over the limit BTW).
>
> Once iproute2 has the nexthop command (patches sent to the list) AND the
> RTA_NHID patches are in, I have this as the final set:
>
> 8c0b06b9813e selftests: Add test cases for nexthop objects
> ea5c19e4dc7c selftests: Add nexthop objects to router_multipath.sh
> 3be7b15d1e56 selftests: pmtu: Move running of test into a new function
> a896b2206ea5 selftests: pmtu: Move route installs to a new function
> cfa48193d0b8 selftests: pmtu: Add support for routing via nexthop objects
> 3d09a79208b9 selftests: icmp_redirect: Add support for routing via
> nexthop objects

cool. that's exactly what I was asking about.
Could you please post them to the mailing list as RFC or some
not-yet-to-be-merged tag?
And in the main patch set, just say in cover letter:
"here look at this set posted separately, because of such and such"

> As always, my patches can be viewed by anyone:
>     https://github.com/dsahern/linux

sure, but it's counter to the standard code review procedure we have.
Pointing a link to your tree doesn't make them reviewable on the
public mailing list.
I very much prefer to do code reviews by looking at the tests first.
It gives me a better idea on api, use cases, etc.

> That includes:
> 1. a test script doing functional validation of the nexthop code
> (net/ipv4/nexthop.c), along with stack integration (e.g., v6 nexthop
> with v4 routes) and traffic (ping).
>
> 2. updates to existing exception tests (pmtu and redirect) with the
> nexthop obects used for routing
>
> 3. updates to the existing router_multipath script with the nexthop
> obects used for routing and validating balanced selection in paths.

great.

>
> Latest branch is:
>    https://github.com/dsahern/linux/tree/5.2-next-nexthops-v14
>
> In addition to the functional and runtime tests listed above:
> 1. I have all kinds of MPLS and network functional tests that I run. I
> have already committed to sending those for inclusion, it is a matter of
> time.

cool. first time I hear.

> 2. The FRR team has had a kernel with these patches for 5+ months adding
> support for nexthops to FRR. They have their own test suites used for
> their development.

what is FRR team? First time I hear about them as well.

> 3. The patches are included in our 4.19 kernel and subjected to our
> suite of smoke and validation tests.

it's also great to hear, but your kernel tree is not a substitute
for netdev community with many companies contributing and running
those kernels, syzbots, buildbots, etc.
I have no doubt that you test your patches, but these patches also touch
the very core of networking that we all are care deeply about.
Hence we want to be able to run all those tests on our kernels too.
