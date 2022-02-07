Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3349B4AB9DE
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 12:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236308AbiBGLG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 06:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240640AbiBGLDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 06:03:35 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D09C043181
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 03:03:34 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id 192so12304519pfz.3
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 03:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=QipFVohgJzcUrL8UlK2rRcSdvLXpuSzlSK+QMwQdeWY=;
        b=Qb119yI+PwQFr6jPKxXD6Ro4Zr7EG7UM/FLvCcgGAyGO4UZKe0qx5zkQ9m6t4wCsua
         Lr3C0gHfNRgM504750ff14hLhU48/xCzEwjIVySWXyX30+gdQJeo/dT3tc6VSKOD7133
         yuHaY94GUIkVEq2P9mnQSRyF/Khh14jwlIvRXiVE9LHEBIzYVnkezgNM5hXfKNtq+LcV
         +zZ1X1K3f2x928jJpPUHQnMZZsXdAbJgjxC2zwgh116dVn2to5FYas9V2M+yb7pFIuLh
         +lHAmyZISmrSYbGvxwIR6AfihL5ALm9QK8atWLuWo9sGxzPZr7brKPDvQKQR4uxZzDob
         QnNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=QipFVohgJzcUrL8UlK2rRcSdvLXpuSzlSK+QMwQdeWY=;
        b=Xqpp+louOeUreCt6Ta4WwSbR1RioY/A0GpUjT4ve8xehOY/x6gd2cMI6vmX3Qx/qzn
         1lcAn2GNGedQHlQOcsvL0H4LxuX8NnnEMr1eXMdIBmtOtDxebazgunCzWOIwrS5DvT6W
         p0klwYUrUAUTvRylR3ka+jD4saEmXNZxyrqIQiuz5HZ6kLcdvk6h1k4UVxTEdip3Ql9V
         TB9PwQKcPoHxDl1wlHz9A/mdBdsSqCRmKCUh9HoDaSmhyF6i4jiMRJ/cQLjr3dBzIVQO
         GWYGzAjiw/knJTKSn1AMiaQv2XRGvEwPnHxdJaSC+NH/1F7qupGonon+Br1F/0e+Nrcj
         iBtQ==
X-Gm-Message-State: AOAM533U1LnFSTgZgCNR6MpoBtywovfwP6yO5vNvHK9qpyT3kIAzX1KJ
        EHEOB5rtTEAj+YsNb57mdtVtUA==
X-Google-Smtp-Source: ABdhPJwzLSLHEnWnuunnTtL/YTkSva49GkpsXaZ+Y54wrksTuThVmDmOfpLyc2tgR7wI7aJjY3L6mQ==
X-Received: by 2002:a63:b207:: with SMTP id x7mr8823276pge.392.1644231813678;
        Mon, 07 Feb 2022 03:03:33 -0800 (PST)
Received: from leoy-ThinkPad-X240s ([204.124.180.34])
        by smtp.gmail.com with ESMTPSA id 142sm2799944pfy.11.2022.02.07.03.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 03:03:33 -0800 (PST)
Date:   Mon, 7 Feb 2022 19:03:25 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     German Gomez <german.gomez@arm.com>
Cc:     linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        acme@kernel.org, Mark Rutland <mark.rutland@arm.com>,
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
Message-ID: <20220207110325.GA73277@leoy-ThinkPad-X240s>
References: <20220126160710.32983-1-german.gomez@arm.com>
 <20220205081013.GA391033@leoy-ThinkPad-X240s>
 <37a1a2f9-2c94-664f-19fb-8337029b8fe5@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <37a1a2f9-2c94-664f-19fb-8337029b8fe5@arm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 07, 2022 at 10:50:26AM +0000, German Gomez wrote:
> Hi Leo, thanks for checking this
> 
> On 05/02/2022 08:10, Leo Yan wrote:
> > Hi German,
> >
> > On Wed, Jan 26, 2022 at 04:07:09PM +0000, German Gomez wrote:
> >> Adds a couple of perf_event_attr tests for the fix introduced in [1].
> >> The tests check that the correct sample_period value is set in the
> >> struct perf_event_attr of the arm_spe events.
> >>
> >> [1]: https://lore.kernel.org/all/20220118144054.2541-1-german.gomez@arm.com/
> >>
> >> Signed-off-by: German Gomez <german.gomez@arm.com>
> > I tested this patch with two commands:
> >
> > # PERF_TEST_ATTR=/tmp /usr/bin/python2 ./tests/attr.py -d ./tests/attr/ \
> >         -p ./perf -vvvvv -t test-record-spe-period
> > # PERF_TEST_ATTR=/tmp /usr/bin/python2 ./tests/attr.py -d ./tests/attr/ \
> >         -p ./perf -vvvvv -t test-record-spe-period-term
> >
> > Both testing can pass on Hisilicon D06 board.
> >
> > One question: I'm a bit concern this case will fail on some Arm64
> > platforms which doesn't contain Arm SPE modules.  E.g. below commands
> > will always fail on Arm64 platforms if SPE module is absent.  So I am
> > wandering if we can add extra checking ARM SPE event is existed or not?
>  
> The test reports "unsupported" if the return code and the 'ret' field don't match.
> 
> When I unload the SPE module:
> 
> running './tests/attr//test-record-spe-period-term'
> test limitation 'aarch64'
> unsupp  './tests/attr//test-record-spe-period-term'

Thanks for confirmation, German.

You could add my testing tag for this patch:

Tested-by: Leo Yan <leo.yan@linaro.org>
