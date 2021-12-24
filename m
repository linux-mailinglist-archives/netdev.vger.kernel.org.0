Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D53647EB0B
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 05:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351218AbhLXEBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 23:01:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351212AbhLXEBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 23:01:16 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92A1C061757
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 20:01:15 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id v16so6637424pjn.1
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 20:01:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:to:cc:from:subject
         :content-transfer-encoding;
        bh=qfXaFkYb/kIfBlrpBQ69YN33YWc3HqccGvv48B9wnL4=;
        b=HXx6JpwtqCLLrbnXWhRAPBLv2nc67Twc0DEQ1Q0nmKlKLwfcCYtsohNSDvwLcvhtf/
         rWCqdmHw71ASDkmxIS4mQPOnXy7oQSGSHXXGbQsEw4GO0X0cFwaqFAzZdaKdvIYl7vJc
         1ustjDt89hrYZmW6mXOOMMHSG6S2K2SKxBc7OGmls8stT4BXuzrPzxHLiLAL57vPxhMz
         Fw8u/BRQUz9M6OMwHDeyKzutCtm0LMAP4EUaImwhm92ufF9YoQ7FwxjNlBt1sy1l9j7M
         FQynvd87T5gm97wzIBWmaqR7Usihmon/AylZ6JUOev3git7WooIXbHWc/4sbKodtvEaV
         tvJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:to:cc
         :from:subject:content-transfer-encoding;
        bh=qfXaFkYb/kIfBlrpBQ69YN33YWc3HqccGvv48B9wnL4=;
        b=d6bI2tp8In10BCYhdF9gSEztCrDwUIN1Gpb+5mn9SaGuq632XvCqV8uuz+Hmb4F9Hn
         HTEsdqn1Rd1xvdIC1n4/vuPH4spP0s0l+p2DeZlB4jp1QQH/xA+4L34fuOwECMZBpKe+
         Abxb88qiIrzc2SZc/q6eHkfhwpLeW3xqEeF9YrvASc3aYhWxstE2ZCiPAz1WQYu6haYK
         D3LPRsiWLj3HTdxr10elYeBf03RllGWczKmY7KCxw7WbFL6UWtk7sQV/3w3F9AHcS+Vx
         rv7ixtMYX+SFByNGtU/TK1SVeYDHZPWwrx4Zfld4gBfNYizVR16u22Syb0ztK5IowH+b
         F2hQ==
X-Gm-Message-State: AOAM530DMq0y8ZsJdkNQyR8bi3lFBYsftFd8U3eAigunuTpvFKcVqs52
        zGPr4wkAMr+co/j2R+vJW0Z7hw==
X-Google-Smtp-Source: ABdhPJzvsV6EHsBpCX/vAdUSZ0zjgMK6bB8WNv08m8ZCvBCO0pUVYuneu07DKOLIt3xSrRG+R/ptEw==
X-Received: by 2002:a17:902:e552:b0:148:a2e8:277a with SMTP id n18-20020a170902e55200b00148a2e8277amr5165877plf.129.1640318475205;
        Thu, 23 Dec 2021 20:01:15 -0800 (PST)
Received: from [10.69.75.97] ([139.177.225.244])
        by smtp.gmail.com with ESMTPSA id r11sm7138132pff.81.2021.12.23.20.01.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Dec 2021 20:01:14 -0800 (PST)
Message-ID: <c84094d2-75c1-a50d-ea9e-9dded5f01fb9@bytedance.com>
Date:   Fri, 24 Dec 2021 12:01:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        zhouchengming@bytedance.com, songmuchun@bytedance.com,
        duanxiongchun@bytedance.com, shekairui@bytedance.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Qiang Wang <wangqiang.wq.frank@bytedance.com>
Subject: Fix repeated legacy kprobes on same function
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If repeated legacy kprobes on same function in one process,
libbpf will register using the same probe name and got -EBUSY
error. So append index to the probe name format to fix this
problem.

And fix a bug in commit 46ed5fc33db9, which wrongly used the
func_name instead of probe_name to register.

Fixes: 46ed5fc33db9 ("libbpf: Refactor and simplify legacy kprobe code")
Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
Signed-off-by: Qiang Wang <wangqiang.wq.frank@bytedance.com>
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>

---
  tools/lib/bpf/libbpf.c | 5 +++--
  1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7c74342bb668..7d1097958459 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -9634,7 +9634,8 @@ static int append_to_file(const char *file, const 
char *fmt, ...)
  static void gen_kprobe_legacy_event_name(char *buf, size_t buf_sz,
                                          const char *kfunc_name, size_t 
offset)
  {
-       snprintf(buf, buf_sz, "libbpf_%u_%s_0x%zx", getpid(), 
kfunc_name, offset);
+       static int index = 0;
+       snprintf(buf, buf_sz, "libbpf_%u_%s_0x%zx_%d", getpid(), 
kfunc_name, offset, index++);
  }

  static int add_kprobe_event_legacy(const char *probe_name, bool retprobe,
@@ -9735,7 +9736,7 @@ bpf_program__attach_kprobe_opts(const struct 
bpf_program *prog,
                 gen_kprobe_legacy_event_name(probe_name, 
sizeof(probe_name),
                                              func_name, offset);

-               legacy_probe = strdup(func_name);
+               legacy_probe = strdup(probe_name);
                 if (!legacy_probe)
                         return libbpf_err_ptr(-ENOMEM);

--
2.20.1

