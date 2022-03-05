Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 190314CE680
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 20:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbiCETBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 14:01:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiCETBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 14:01:37 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0F75AA78;
        Sat,  5 Mar 2022 11:00:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BEAB3CE0957;
        Sat,  5 Mar 2022 19:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FD8C340EC;
        Sat,  5 Mar 2022 19:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646506842;
        bh=zWhrfFFYUoTwiNUraXxSf4+e7ma2/l09MR0Xu9OVbXI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TmgI9JgVoxZG4/01E3S/Ghq+3mLOjM3eD9RP5HYbl0HhXj2hwERpGtKR1F8rL4kbt
         0VAMwLoSomXSi/DNxUYWS539CE7tNBHhW6fOonjTsuk2OAJ72iGEpWA9xDQ3tXlYUT
         Pj3AZhpxYKjaDlijUPI/QkN96tn9ICjYHLYS95V1Egj4qCJW4nlFUjZEY3OJw+WTK5
         2gSMevhXzkpznDKQB+7VEHoL7CbZaurX1mKU00O+PPK/GkaYLt5vzgx08TzHKRuqcf
         hmbopn9/M9TISambUNKaXYX7BEkge0tqn+xJGK7f1AlMKXdOQJoNVaIJ+qqotFNwgc
         0RZUEkvlEbx4w==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id B98F6403C8; Sat,  5 Mar 2022 16:00:39 -0300 (-03)
Date:   Sat, 5 Mar 2022 16:00:39 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     James Clark <james.clark@arm.com>
Cc:     German Gomez <german.gomez@arm.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] perf test: Add perf_event_attr tests for the arm_spe
 event
Message-ID: <YiOzV7cUbWDNNMdH@kernel.org>
References: <20220126160710.32983-1-german.gomez@arm.com>
 <fb98e7fd-bf0f-bc3b-ad2a-2775d2ef321d@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb98e7fd-bf0f-bc3b-ad2a-2775d2ef321d@arm.com>
X-Url:  http://acmel.wordpress.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, Feb 28, 2022 at 03:05:21PM +0000, James Clark escreveu:
> 
> 
> On 26/01/2022 16:07, German Gomez wrote:
> > Adds a couple of perf_event_attr tests for the fix introduced in [1].
> > The tests check that the correct sample_period value is set in the
> > struct perf_event_attr of the arm_spe events.
> > 
> > [1]: https://lore.kernel.org/all/20220118144054.2541-1-german.gomez@arm.com/
> > 
> > Signed-off-by: German Gomez <german.gomez@arm.com>
> 
> Reviewed-by: James Clark <james.clark@arm.com>

Thanks, applied.

- Arnaldo

 
> > ---
> >  tools/perf/tests/attr/README                  |  2 +
> >  tools/perf/tests/attr/base-record-spe         | 40 +++++++++++++++++++
> >  tools/perf/tests/attr/test-record-spe-period  | 12 ++++++
> >  .../tests/attr/test-record-spe-period-term    | 12 ++++++
> >  4 files changed, 66 insertions(+)
> >  create mode 100644 tools/perf/tests/attr/base-record-spe
> >  create mode 100644 tools/perf/tests/attr/test-record-spe-period
> >  create mode 100644 tools/perf/tests/attr/test-record-spe-period-term
> > 
> > diff --git a/tools/perf/tests/attr/README b/tools/perf/tests/attr/README
> > index 1116fc6bf2ac..454505d343fa 100644
> > --- a/tools/perf/tests/attr/README
> > +++ b/tools/perf/tests/attr/README
> > @@ -58,6 +58,8 @@ Following tests are defined (with perf commands):
> >    perf record -c 100 -P kill                    (test-record-period)
> >    perf record -c 1 --pfm-events=cycles:period=2 (test-record-pfm-period)
> >    perf record -R kill                           (test-record-raw)
> > +  perf record -c 2 -e arm_spe_0// -- kill       (test-record-spe-period)
> > +  perf record -e arm_spe_0/period=3/ -- kill    (test-record-spe-period-term)
> >    perf stat -e cycles kill                      (test-stat-basic)
> >    perf stat kill                                (test-stat-default)
> >    perf stat -d kill                             (test-stat-detailed-1)
> > diff --git a/tools/perf/tests/attr/base-record-spe b/tools/perf/tests/attr/base-record-spe
> > new file mode 100644
> > index 000000000000..08fa96b59240
> > --- /dev/null
> > +++ b/tools/perf/tests/attr/base-record-spe
> > @@ -0,0 +1,40 @@
> > +[event]
> > +fd=*
> > +group_fd=-1
> > +flags=*
> > +cpu=*
> > +type=*
> > +size=*
> > +config=*
> > +sample_period=*
> > +sample_type=*
> > +read_format=*
> > +disabled=*
> > +inherit=*
> > +pinned=*
> > +exclusive=*
> > +exclude_user=*
> > +exclude_kernel=*
> > +exclude_hv=*
> > +exclude_idle=*
> > +mmap=*
> > +comm=*
> > +freq=*
> > +inherit_stat=*
> > +enable_on_exec=*
> > +task=*
> > +watermark=*
> > +precise_ip=*
> > +mmap_data=*
> > +sample_id_all=*
> > +exclude_host=*
> > +exclude_guest=*
> > +exclude_callchain_kernel=*
> > +exclude_callchain_user=*
> > +wakeup_events=*
> > +bp_type=*
> > +config1=*
> > +config2=*
> > +branch_sample_type=*
> > +sample_regs_user=*
> > +sample_stack_user=*
> > diff --git a/tools/perf/tests/attr/test-record-spe-period b/tools/perf/tests/attr/test-record-spe-period
> > new file mode 100644
> > index 000000000000..75f8c9cd8e3f
> > --- /dev/null
> > +++ b/tools/perf/tests/attr/test-record-spe-period
> > @@ -0,0 +1,12 @@
> > +[config]
> > +command = record
> > +args    = --no-bpf-event -c 2 -e arm_spe_0// -- kill >/dev/null 2>&1
> > +ret     = 1
> > +arch    = aarch64
> > +
> > +[event-10:base-record-spe]
> > +sample_period=2
> > +freq=0
> > +
> > +# dummy event
> > +[event-1:base-record-spe]
> > diff --git a/tools/perf/tests/attr/test-record-spe-period-term b/tools/perf/tests/attr/test-record-spe-period-term
> > new file mode 100644
> > index 000000000000..8f60a4fec657
> > --- /dev/null
> > +++ b/tools/perf/tests/attr/test-record-spe-period-term
> > @@ -0,0 +1,12 @@
> > +[config]
> > +command = record
> > +args    = --no-bpf-event -e arm_spe_0/period=3/ -- kill >/dev/null 2>&1
> > +ret     = 1
> > +arch    = aarch64
> > +
> > +[event-10:base-record-spe]
> > +sample_period=3
> > +freq=0
> > +
> > +# dummy event
> > +[event-1:base-record-spe]

-- 

- Arnaldo
