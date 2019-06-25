Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67A5755374
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 17:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732413AbfFYPcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 11:32:02 -0400
Received: from mail-io1-f54.google.com ([209.85.166.54]:39515 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732393AbfFYPcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 11:32:02 -0400
Received: by mail-io1-f54.google.com with SMTP id r185so3970140iod.6
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 08:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pl6j18xP2teXBCXiFz1+ekHc82RO1v4dtHxUKcwmnSI=;
        b=xYnG3hJyz4khT/uJKxphyWjZQFQ//q3hlVe230M5KEJnEbld76vZxH0dhqV8TKmWJo
         8zg7zuJTixxzeq6fETCF+7hxbRsPwcKAEkCZab4RmBRlN5IMuVc3B4C7pXw2hM4IWaoE
         +viBxP25ebZesMJgXEzosY21FqBH7jtJfUlmzSk9Xqaf1KVqMPvFeGw9qYdI1FAyqUaT
         zo13+vCCbXRgCJrm0BskV1m1GDyXrPUMogAFwWyI+mpp5Lh2zh74nwwVqsWMctY04xV2
         VGsgpcQXYd/nJHwJT/YRiRjkz9nda3bfc/nAg3kYnlZZYJDQVbNjlIO8uYcb4Ckl6opv
         hz6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pl6j18xP2teXBCXiFz1+ekHc82RO1v4dtHxUKcwmnSI=;
        b=uDKxBWZAoj/JKVfq7Bd115EfjCvhKgZUq912SXZ7WmaHRZy6tvqzHvwwAD6Hng43vD
         kFPhF/ef5DfFut0TDxDHsIIstShkyXKFiEdSOuAywcwqFuVLhtXgayEsPl3jGBghiDBb
         qlS2VIA8bgx0DHXtyi0Je/WtWhlOrfVoaoPELgsNkmcxmHUIjvMgIzgbk3W4xsV+UoAj
         x4JAlOZibg+vkPVz3Fhx40r+2lRQUzuT5JrmZ897ue9qnJtnZ40qp2CGw83X4TAvDQtf
         3smarxhYlyUh/3Z1mrm2UKUHgOfOzoiMtpOzdP17mE7Q7GFssryQ8hFfYX3ipBjjVLrO
         ru5A==
X-Gm-Message-State: APjAAAVktZxsT6iVMQYF7r7mQa4rREPZmWJ0OKLfHQQ5gv2qSpE0Cq2E
        gXAFysf3yko8lEVRJVTnDf5wJw==
X-Google-Smtp-Source: APXvYqyYSRUYb1ugPr+PA2M18DdrwhkX5IV3FjKk+sfHRCpVUDQ/fPnQ7D2WX3PZI8HQcUgp3KoyyA==
X-Received: by 2002:a02:bb05:: with SMTP id y5mr25232740jan.93.1561476721092;
        Tue, 25 Jun 2019 08:32:01 -0700 (PDT)
Received: from localhost (c-75-72-120-115.hsd1.mn.comcast.net. [75.72.120.115])
        by smtp.gmail.com with ESMTPSA id c2sm11755771iok.53.2019.06.25.08.32.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 08:32:00 -0700 (PDT)
Date:   Tue, 25 Jun 2019 10:31:59 -0500
From:   Dan Rue <dan.rue@linaro.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Shuah Khan <shuah@kernel.org>
Subject: Re: selftests: bpf: test_libbpf.sh failed at file test_l4lb.o
Message-ID: <20190625153159.5utnn36dgku5545n@xps.therub.org>
References: <CA+G9fYsMcdHmKY66CNhsrizO-gErkOQCkTcBSyOHLpOs+8g5=g@mail.gmail.com>
 <CAEf4BzbTD8G_zKkj-S3MOeG5Hq3_2zz3bGoXhQtpt0beG8nWJA@mail.gmail.com>
 <20190621161752.d7d7n4m5q67uivys@xps.therub.org>
 <CAEf4BzaSoKA5H5rN=w+OAtUz4bD30-VOjjjY+Qv9tTAnhMweiA@mail.gmail.com>
 <20190624195336.nubi7n2np5vfjutr@xps.therub.org>
 <CAADnVQKZycXgSw6C0qa7g0y=W3xRhM_4Rqcj7ZzL=rGh_n4mgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQKZycXgSw6C0qa7g0y=W3xRhM_4Rqcj7ZzL=rGh_n4mgA@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 12:58:15PM -0700, Alexei Starovoitov wrote:
> On Mon, Jun 24, 2019 at 12:53 PM Dan Rue <dan.rue@linaro.org> wrote:
> >
> > I would say if it's not possible to check at runtime, and it requires
> > clang 9.0, that this test should not be enabled by default.
> 
> The latest clang is the requirement.
> If environment has old clang or no clang at all these tests will be failing.

Hi Alexei!

I'm not certain if I'm interpreting you as you intended, but it sounds
like you're telling me that if the test build environment does not use
'latest clang' (i guess latest as of today?), that these tests will
fail, and that is how it is going to be. If I have that wrong, please
correct me and disregard the rest of my message.

Please understand where we are coming from. We (and many others) run
thousands of tests from a lot of test frameworks, and so our environment
often has mutually exclusive requirements when it comes to things like
toolchain selection.

We believe, strongly, that a test should not emit a "fail" for a missing
requirement. Fail is a serious thing, and should be reserved for an
actual issue that needs to be investigated, reported, and fixed.

This is how we treat test failures - we investigate, report, and fix
them when possible. When they're not real failures, we waste our time
(and yours, in this case).

By adding the tests to TEST_GEN_PROGS, you're adding them to the general
test set that those of us running test farms try to run continuously
across a wide range of hardware environments and kernel branches.

My suggestion is that if you do not want us running them, don't add them
to TEST_GEN_PROGS. I thought the suggestion of testing for adequate
clang support and adding them conditionally at build-time was an idea
worth consideration.

Thanks,
Dan

-- 
Linaro - Kernel Validation
