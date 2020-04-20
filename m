Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C401B184E
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727836AbgDTVVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:21:40 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:50713 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbgDTVVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 17:21:40 -0400
Received: from mail-qk1-f175.google.com ([209.85.222.175]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1M8QBa-1jME0w0w8u-004WBT; Mon, 20 Apr 2020 23:21:38 +0200
Received: by mail-qk1-f175.google.com with SMTP id s63so12424977qke.4;
        Mon, 20 Apr 2020 14:21:37 -0700 (PDT)
X-Gm-Message-State: AGi0Puapn3pzsSjFq8EOH0000TaDlRf81+g4XIcKDgtDuqTCpi7K4m/K
        O1u18aqNmoBTklQJR9zSWuKlKkTig7VMIuuL5QA=
X-Google-Smtp-Source: APiQypIaFeSdV4og7SRTXrUGDCD7aWTwle449qQck76jzO7TzeWF3vHD7ARk5tzDYrr6baMd38PaTIvn3e99YTS70l8=
X-Received: by 2002:a37:9d08:: with SMTP id g8mr18060484qke.138.1587417696998;
 Mon, 20 Apr 2020 14:21:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200416085627.1882-1-clay@daemons.net> <6fef3a00-6c18-b775-d1b4-dfd692261bd3@ti.com>
 <20200420093610.GA28162@arctic-shiba-lx> <CAK8P3a36ZxNJxUS4UzrwJiMx8UrgYPkcv4X6yYw7EC4jRBbbGQ@mail.gmail.com>
 <20200420170051.GB11862@localhost> <CAK8P3a11CqpDJzjy5QfV-ebHgRxUu8SRVTJPPmsus1O1+OL72Q@mail.gmail.com>
 <20200420211819.GA16930@localhost>
In-Reply-To: <20200420211819.GA16930@localhost>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 20 Apr 2020 23:21:20 +0200
X-Gmail-Original-Message-ID: <CAK8P3a18540y3zqR=mqKhj-goinN3c-FGKvAnTHnLgBxiPa4mA@mail.gmail.com>
Message-ID: <CAK8P3a18540y3zqR=mqKhj-goinN3c-FGKvAnTHnLgBxiPa4mA@mail.gmail.com>
Subject: Re: [PATCH] net: cpts: Condition WARN_ON on PTP_1588_CLOCK
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Clay McClure <clay@daemons.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sekhar Nori <nsekhar@ti.com>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:VuckYJQW3oH7FVW16mR1NS4ocgKR0A04GbOmCFnjBog9jsI1GHM
 1jm5mdU76kGOxyQI8dokpWr0qL++f6aZJt7DXC39XxhreKox9UfzWlCL1Nrr6jphAWSDmH0
 +3o7OPQ/TJcfn0Tn9+aTI0EkPnW38ZY6UUOXEYLVoXwJkfy+oTYWFlAX6iyH0dkH7SzPYzu
 etrVZlimMtoqzhMSshQeg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:xZlgQyBcYEU=:X4MCE7AFb4Bn46kKMxTKfc
 Cl7MQlR3Zdxcoun90U7N45+vbS1IikNf6BMmDD0aeqoHUxl31PSbvBdkjPxA0e62DdTH3ysc4
 Dh68ouTgFVjC+yDBRqeczax9NGUK8movbgVrR7hGPIkMaOcPrQuyYDjM0L1oATmv5O3sNs9Fl
 wKXspeZFHE3oiEnmXwQSFXkKnrIWLjTzPW3Ak1MVVVIix8iZtTDuqbq5tvYwKqeEyAdgCr5V0
 f31RsE45x1o4ssxU9ciYwkmLpAi/vlcLZPH8a3d+vNoJaHcdQdfS4Ax3jmnGinr/vApxLaYdb
 h+BE44BpP0HIBgFvl6Voks61quX1acxg9GDs1RbClm0aoQRpCCzp8uEUW6qAvhPsoBDkrnyDj
 IXGrm3cb8R80Fl4TzwH0ompYko8Nqd1oHU+ByA8ODQRge/tSa2nqQE3aw71QhH+c4SGSLb44L
 F0CRBt9fD6F76ZrhQAJWjnBwKRY/REjlI4aQZ5Nr3dZuqFVwX38i1s6OnWlVBj8DOrLMpzijf
 dbKA/ung3nhiVUT9j/2ZrTWRbzwBkE9S96E9n178IJJ+BUiwJOHrcWdOvwag5w4dPynLtbU6/
 Y9s/ltogSvrAU6+6pYjdSHS1bgpqqogrjz1XmkcRcpTV1EYV9aVB0TJge0kOXGSJNcKPUn6e7
 wH7lc/NSDA7/4gquCqJ4hjdtR3umsQ+OmrDG6iR2D3oeJMIidxzLNlsMJ3SBeNbZAD749bXle
 EBxijgnWUgJfWA+95k8OWhyyws2QGbsuY5dqaDAw2N4pY2ARKiqAGQpXGk8J6KldStQxuUaJr
 igRLY7sV5wqZe3nvI/9wpJ6vWSu/Zfx6JHh7dZkZ/XATSuGnNg=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 11:18 PM Richard Cochran
<richardcochran@gmail.com> wrote:
> On Mon, Apr 20, 2020 at 08:57:05PM +0200, Arnd Bergmann wrote:
> > > d1cbfd771ce82 (Nicolas Pitre       2016-11-11 172) #if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
> > > d1cbfd771ce82 (Nicolas Pitre       2016-11-11 173)
> > > d1cbfd771ce82 (Nicolas Pitre       2016-11-11 174) /**
> > > d1cbfd771ce82 (Nicolas Pitre       2016-11-11 175)  * ptp_clock_register() - register a PTP hardware clock driver
> > > d1cbfd771ce82 (Nicolas Pitre       2016-11-11 176)  *
> > > d1cbfd771ce82 (Nicolas Pitre       2016-11-11 177)  * @info:   Structure describing the new clock.
> > > d1cbfd771ce82 (Nicolas Pitre       2016-11-11 178)  * @parent: Pointer to the parent device of the new clock.
> > > d1cbfd771ce82 (Nicolas Pitre       2016-11-11 179)  *
> > > d1cbfd771ce82 (Nicolas Pitre       2016-11-11 180)  * Returns a valid pointer on success or PTR_ERR on failure.  If PHC
> > > d1cbfd771ce82 (Nicolas Pitre       2016-11-11 181)  * support is missing at the configuration level, this function
> > > d1cbfd771ce82 (Nicolas Pitre       2016-11-11 182)  * returns NULL, and drivers are expected to gracefully handle that
> > > d1cbfd771ce82 (Nicolas Pitre       2016-11-11 183)  * case separately.
> > > d1cbfd771ce82 (Nicolas Pitre       2016-11-11 184)  */
> >
> > The key here is "gracefully". The second patch from Clay just turns NULL into
> >  -EOPNOTSUPP and treats the compile-time condition into a runtime error.
>
> You are talking about the cpts driver, no?
>
> I'm worried about ptp_clock_register(), because it does return NULL if
> IS_REACHABLE(CONFIG_PTP_1588_CLOCK), and this is the "correct"
> behavior ever since November 2016.
>
> If somebody wants to change that stub to return EOPNOTSUPP, then fine,
> but please have them audit the callers and submit a patch series.

It's not great, but we have other interfaces like this that can return NULL for
success when the subsystem is disabled. The problem is when there is
a mismatch between the caller treating NULL as failure when it is meant to
be "successful lack of object returned".

       Arnd
