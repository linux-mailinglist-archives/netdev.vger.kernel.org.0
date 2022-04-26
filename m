Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43B0550FEBA
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 15:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350851AbiDZNXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 09:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350839AbiDZNXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 09:23:10 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B0FDF3F
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 06:20:00 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id r83so16074479pgr.2
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 06:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HLmgdCeRQnlZPI0jqFO8y9T2xXc5m6qGLiOpaSM2FSM=;
        b=jPCQfFTpQpV7n7pB7rQDJt9sEnkgB4WREXGbL8Dv7b1F2XbxwlGG9CjunEgd52tZNh
         f7b7jRWcHwxnBXWkjhTIo5RsaLGht6e7tCbque3ut0TGd+K/JWFdBL3RoZ66gTg6AWOr
         tt/4wyon5tX9Fj2AvW12rYJSMG5VjtoOlW++QPT8nwJk7gFXCOX3SrHat2epwpEjI8ww
         AFCQ8Rn77o0zNND5MQZv31aCz2DUeV3FK9hPagKRgqmRKXpwU/XnLSgFUbHZhkfSHEkJ
         o1Ok5lmOEVM5/v+cSqBQdoCuC+HiqBJ64GblVLjeciEYYmiEZfTWUZcMQfwIiTVE6i/p
         J72w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HLmgdCeRQnlZPI0jqFO8y9T2xXc5m6qGLiOpaSM2FSM=;
        b=KKae4tQqwJREZLI/8HCbfbIhcIqj+7L9YitLZWWvXxjsFZ8Wj+auLBtfwkdjSERU+c
         fyiAG5nzevJxGcX0LGHPBBhzvWAd7LgYHFyVoCKGhTHdiIvvxhuESP8GV6w0Ay3eeGaK
         LGNeJO00gjQMs9SKCsB1rqL5kRNdUYV6gWGArA/1lxTUYgDNexEtSbIbM9RXvvUkjTmW
         15iGWr+yoHWb/WBhK+Edx3tBrzFjw6Vy8ZWkO22+2dXJ01a7an/HxWZRogAfbucZ5m1t
         dcz2phaS71qVo9iydglEJnss84pvT2QyrB/foZTemLEc+y4logV3fsKcQcE8EDkIz5e5
         6yWA==
X-Gm-Message-State: AOAM531z8VbECaG/na3076is5jeKMo++s/Sn223eRmZnU0s7jPN/fAbh
        b17XcoY9GMQa4gM0AF4AZHyc4Q==
X-Google-Smtp-Source: ABdhPJywU6zSNw8eC6iZB0lW4cMNYVRUgoT39LY8hW7zbfiZnYq6dVsSlFGb05d66NZD5nCNmqfhWQ==
X-Received: by 2002:a63:86c8:0:b0:3aa:fa50:b002 with SMTP id x191-20020a6386c8000000b003aafa50b002mr13427236pgd.570.1650979199932;
        Tue, 26 Apr 2022 06:19:59 -0700 (PDT)
Received: from leoy-ThinkPad-X240s (216.24.179.102.16clouds.com. [216.24.179.102])
        by smtp.gmail.com with ESMTPSA id x22-20020a17090aa39600b001d95c09f877sm3120923pjp.35.2022.04.26.06.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 06:19:59 -0700 (PDT)
Date:   Tue, 26 Apr 2022 21:19:52 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     James Clark <james.clark@arm.com>
Cc:     Timothy Hayes <timothy.hayes@arm.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        acme@kernel.org, John Garry <john.garry@huawei.com>,
        Will Deacon <will@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH 2/3] perf: arm-spe: Fix SPE events with phys addresses
Message-ID: <20220426131952.GA1923836@leoy-ThinkPad-X240s>
References: <20220421165205.117662-1-timothy.hayes@arm.com>
 <20220421165205.117662-3-timothy.hayes@arm.com>
 <20220424125951.GD978927@leoy-ThinkPad-X240s>
 <322009d2-330c-22d4-4075-eca2042f64e1@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <322009d2-330c-22d4-4075-eca2042f64e1@arm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 10:12:36AM +0100, James Clark wrote:

[...]

> >> diff --git a/tools/perf/util/arm-spe.c b/tools/perf/util/arm-spe.c
> >> index 151cc38a171c..1a80151baed9 100644
> >> --- a/tools/perf/util/arm-spe.c
> >> +++ b/tools/perf/util/arm-spe.c
> >> @@ -1033,7 +1033,8 @@ arm_spe_synth_events(struct arm_spe *spe, struct perf_session *session)
> >>  	memset(&attr, 0, sizeof(struct perf_event_attr));
> >>  	attr.size = sizeof(struct perf_event_attr);
> >>  	attr.type = PERF_TYPE_HARDWARE;
> >> -	attr.sample_type = evsel->core.attr.sample_type & PERF_SAMPLE_MASK;
> >> +	attr.sample_type = evsel->core.attr.sample_type &
> >> +				(PERF_SAMPLE_MASK | PERF_SAMPLE_PHYS_ADDR);
> > 
> > I verified this patch and I can confirm the physical address can be
> > dumped successfully.
> > 
> > I have a more general question, seems to me, we need to change the
> > macro PERF_SAMPLE_MASK in the file util/event.h as below, so
> > here doesn't need to 'or' the flag PERF_SAMPLE_PHYS_ADDR anymore.
> > 
> > @Arnaldo, @Jiri, could you confirm if this is the right way to move
> > forward?  I am not sure why PERF_SAMPLE_MASK doesn't contain the bit
> > PERF_SAMPLE_PHYS_ADDR in current code.
> 
> I think there is a reason that PERF_SAMPLE_MASK is a subset of all the
> bits. This comment below suggests it. Is it so the mask only includes fields
> that are 64bits? That makes the __evsel__sample_size() function a simple
> multiplication of a count of all the fields that are 64bits.

After reading code, seems the conclusion "a count of all the fields
that are 64bits" is not valid.  PERF_SAMPLE_MASK contains bits
PERF_SAMPLE_IP and PERF_SAMPLE_TID, the corresponding fields 'pid'
and 'tid' in the structure perf_sample are u32 type.

>   static int
>   perf_event__check_size(union perf_event *event, unsigned int sample_size)
>   {
> 	/*
> 	 * The evsel's sample_size is based on PERF_SAMPLE_MASK which includes
> 	 * up to PERF_SAMPLE_PERIOD.  After that overflow() must be used to
> 	 * check the format does not go past the end of the event.
> 	 */
> 	if (sample_size + sizeof(event->header) > event->header.size)
> 		return -EFAULT;

Okay, thanks for sharing the info, it does show that it's deliberately to
not contain all fields in PERF_SAMPLE_MASK.  If so, this patch is fine
for me:

Reviewed-by: Leo Yan <leo.yan@linaro.org>


> 	return 0;
>   }
> 
> Having said that, the mask was updated once to add PERF_SAMPLE_IDENTIFIER to
> it, so that comment is slightly out of date now.
> 
> 
> > 
> > diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
> > index cdd72e05fd28..c905ac32ebad 100644
> > --- a/tools/perf/util/event.h
> > +++ b/tools/perf/util/event.h
> > @@ -39,7 +39,7 @@ struct perf_event_attr;
> >          PERF_SAMPLE_TIME | PERF_SAMPLE_ADDR |          \
> >         PERF_SAMPLE_ID | PERF_SAMPLE_STREAM_ID |        \
> >          PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD |         \
> > -        PERF_SAMPLE_IDENTIFIER)
> > +        PERF_SAMPLE_IDENTIFIER | PERF_SAMPLE_PHYS_ADDR)
> > 
> > Thanks,
> > Leo
> > 
> >>  	attr.sample_type |= PERF_SAMPLE_IP | PERF_SAMPLE_TID |
> >>  			    PERF_SAMPLE_PERIOD | PERF_SAMPLE_DATA_SRC |
> >>  			    PERF_SAMPLE_WEIGHT | PERF_SAMPLE_ADDR;
> >> -- 
> >> 2.25.1
> >>
