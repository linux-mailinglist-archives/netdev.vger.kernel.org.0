Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADD63754D
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 15:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728010AbfFFNea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 09:34:30 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44476 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727234AbfFFNe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 09:34:29 -0400
Received: by mail-qk1-f195.google.com with SMTP id w187so1402969qkb.11;
        Thu, 06 Jun 2019 06:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xirkV3DOzB14wA6wGRICAfj7Wrpc/HfyNCjzGeOnGKc=;
        b=MEj3AExPDyVN4I1G2SW+SUr1+x4qCvqxVBDCxtRWeITMp6cIAYQfV236ccTohX8FSa
         blnAKNB64m7Swcl3teB3EXi07NlJpTjQlSYIRGL9/Da3zZoUuK2IbMiG2PHPrJCuGxXw
         MOzttgUPmzjrlcBWHjHpqpS+/TxqpecTt+wkhizn/XoMuGQhgxmojdWqiqMA10RrC7c2
         UcXzJCWxlShVLjlEplNb6Hj/0towoyDUUdx692AzJumaaco4toerPp7ysWcYCv22Fc7z
         kQa4L45ydlKnsoK2a1+mf/H4P67wrkyzAJcrTvfMbQ8d3B2MUJ1cx0WPWohOVD9LmJ63
         f+lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xirkV3DOzB14wA6wGRICAfj7Wrpc/HfyNCjzGeOnGKc=;
        b=U3Yr2TF1oy4/dL+UmzaaWPDhsgx56PnuVRGZtmujgQSdWrzUzNk+8RWcTmc9HOokf/
         +wjfFggohXPHKMrgWhqx2t6f9oigxH3kSyVV7zEQd39pdJ3Jg0EUsf5Q8ioWSRJRaAzu
         Bnwt7RRgRoXnc8b9N6sjkAcYVSMxSkIojDA8ePPZ/X4MHgHPUDdP2B11yqhEzOEpzZrG
         M0CQwsm7ErZAAKXUOkiydmXCftDSxV4RPjkhRT5vJUjX85M2FbHRWhskp/AkJXIbmzw1
         fWffV/V0lG9b2DKA5gYqOM8lXqUfylrQqZR5hYbshhoxB3Pm+mPCQ0UcfDkl9P1KJ7Hj
         uHkA==
X-Gm-Message-State: APjAAAXSeCfUF26rJy6+FZKm7SArMOQPgJn8UV8nVUEQrWO58L7O77vI
        4lBDh+xTEaqdUZ0w1L46/8M=
X-Google-Smtp-Source: APXvYqzTMkdozEtb0Oh5NYEZq7Ry3yMH+jPn44WVyk1YibbMQ0oHHDMxV3Kn/VBJrpsl9dxlXmFWEw==
X-Received: by 2002:a37:aa4d:: with SMTP id t74mr39408551qke.144.1559828068671;
        Thu, 06 Jun 2019 06:34:28 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([177.195.208.82])
        by smtp.gmail.com with ESMTPSA id e66sm1062158qtb.55.2019.06.06.06.34.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 06:34:27 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 53B6941149; Thu,  6 Jun 2019 10:34:24 -0300 (-03)
Date:   Thu, 6 Jun 2019 10:34:24 -0300
To:     Leo Yan <leo.yan@linaro.org>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v2 1/4] perf trace: Exit when build eBPF program failure
Message-ID: <20190606133424.GB30166@kernel.org>
References: <20190606094845.4800-1-leo.yan@linaro.org>
 <20190606094845.4800-2-leo.yan@linaro.org>
 <20190606133019.GA30166@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606133019.GA30166@kernel.org>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Thu, Jun 06, 2019 at 10:30:19AM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Thu, Jun 06, 2019 at 05:48:42PM +0800, Leo Yan escreveu:
> > +++ b/tools/perf/builtin-trace.c
> > @@ -3664,6 +3664,14 @@ static int trace__config(const char *var, const char *value, void *arg)
> >  					       "event selector. use 'perf list' to list available events",
> >  					       parse_events_option);
> >  		err = parse_events_option(&o, value, 0);
> > +
> > +		/*
> > +		 * When parse option successfully parse_events_option() will
> > +		 * return 0, otherwise means the paring failure.  And it
> > +		 * returns 1 for eBPF program building failure; so adjust the
> > +		 * err value to -1 for the failure.
> > +		 */
> > +		err = err ? -1 : 0;
> 
> I'll rewrite the comment above to make it more succint and fix things
> like 'paring' (parsing):
> 
> 		/*
> 		 * parse_events_option() returns !0 to indicate failure
> 		 * while the perf_config code that calls trace__config()
> 		 * expects < 0 returns to indicate error, so:
> 		 */
> 
> 		 if (err)
> 		 	err = -1;

Even shorter, please let me know if I can keep your
Signed-off-by/authorship for this one.

- Arnaldo

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index f7e4e50bddbd..1a2a605cf068 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -3703,7 +3703,12 @@ static int trace__config(const char *var, const char *value, void *arg)
 		struct option o = OPT_CALLBACK('e', "event", &trace->evlist, "event",
 					       "event selector. use 'perf list' to list available events",
 					       parse_events_option);
-		err = parse_events_option(&o, value, 0);
+		/*
+		 * We can't propagate parse_event_option() return, as it is 1
+		 * for failure while perf_config() expects -1.
+		 */
+		if (parse_events_option(&o, value, 0))
+			err = -1;
 	} else if (!strcmp(var, "trace.show_timestamp")) {
 		trace->show_tstamp = perf_config_bool(var, value);
 	} else if (!strcmp(var, "trace.show_duration")) {
