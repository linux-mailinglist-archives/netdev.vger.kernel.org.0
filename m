Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24FC510B12D
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 15:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfK0OYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 09:24:55 -0500
Received: from mail-qt1-f182.google.com ([209.85.160.182]:44393 "EHLO
        mail-qt1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbfK0OYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 09:24:54 -0500
Received: by mail-qt1-f182.google.com with SMTP id g24so18673722qtq.11;
        Wed, 27 Nov 2019 06:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/ZjRuCdf64agVgNamIpbcb5ZOt2c6JCXvZXZubn5ERY=;
        b=B143iIgvlm1JsDexn4GCrp+qQaEsO5o/w7aq3nbuhAmsHjaG6+KxppfC/aTUpThg3M
         nw2FJjBdoBJ+Qgxp4jLI49dlUsxKE6rIM6LxoIm/S11yoGdNjQOYCI7BfO8LixeCR+DK
         RgmqQIQ2iwKtSH6c3OLh4Ri50zsueNjEH76p82tUcAqYAfx4ZuG83j59yDS7mN7ekdAr
         rw5niVr8wL0lHNgqJHTQRcx7luADmimJpYZJA/UXduL2lPMCzkoESXk61EBEse6WYy+C
         ZN4H5jEgIslRb9CLqmdDv6nfmZl0sWQRttiEzDlbI8JV+ewLipOdU/38LHh51WO4pWjS
         dkDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/ZjRuCdf64agVgNamIpbcb5ZOt2c6JCXvZXZubn5ERY=;
        b=AXaiCX8DURd36euyJJD62gcVPdp2FzFaM9Gx8EiWJ2iFpK6xu1VTP4MJfD/qj0QUv5
         /o4FjqDHNhPM/jWwrWNn1lcoMqQiadAuUg+/FbG6hVXIV+7W1U09khE6Hy9iUrLp1gTh
         5ppQh5AgKrzhvAGH8N075lJcLqwdVre10E1FZEJ1oLZCrgJXopBSYrk15JBjQMeGQ73n
         hHdp29oEMCx8vzqdMX8/aTOyIDf+nLK711mH+23YyB5BuOllQEYVBg3WIFXssKEAMH0g
         3yoiBhmEx65zVbUu+G7Bl4bIyuD2kai/r82rUFWTOSQTkJ3RA66zVzVHvIqWo2wBSyVJ
         ZH2w==
X-Gm-Message-State: APjAAAVPhezPgImYAj65h6PZLYvA+VmY2KdH+FNzbxHAL/O+wyyrqTj3
        /i0uuFMxVdCJV1IAS6erBsA=
X-Google-Smtp-Source: APXvYqxP+QOUP8hC+F9dIRxzhI6FukncbB5ALX6XcXCEOEdJlxtvCsiBmnKgICFiTpIOr8nfe4tFYg==
X-Received: by 2002:ac8:544e:: with SMTP id d14mr7570367qtq.321.1574864693016;
        Wed, 27 Nov 2019 06:24:53 -0800 (PST)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id f21sm6752243qkl.34.2019.11.27.06.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 06:24:52 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id B433F40D3E; Wed, 27 Nov 2019 11:24:49 -0300 (-03)
Date:   Wed, 27 Nov 2019 11:24:49 -0300
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Quentin Monnet <quentin.monnet@netronome.com>,
        Jiri Olsa <jolsa@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH 3/3] bpftool: Allow to link libbpf dynamically
Message-ID: <20191127142449.GD22719@kernel.org>
References: <20191127094837.4045-1-jolsa@kernel.org>
 <20191127094837.4045-4-jolsa@kernel.org>
 <fd22660f-2f70-4ffa-b45f-bb417d006d0a@netronome.com>
 <20191127141520.GJ32367@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127141520.GJ32367@krava>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, Nov 27, 2019 at 03:15:20PM +0100, Jiri Olsa escreveu:
> On Wed, Nov 27, 2019 at 01:38:55PM +0000, Quentin Monnet wrote:
> > 2019-11-27 10:48 UTC+0100 ~ Jiri Olsa <jolsa@kernel.org>
> > On the plus side, all build attempts from
> > tools/testing/selftests/bpf/test_bpftool_build.sh pass successfully on
> > my setup with dynamic linking from your branch.
> 
> cool, had no idea there was such test ;-)

Should be the the equivalent to 'make -C tools/perf build-test' :-)

Perhaps we should make tools/testing/selftests/perf/ link to that?

- Arnaldo
