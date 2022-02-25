Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1455A4C4BCE
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 18:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243535AbiBYRPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 12:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240804AbiBYRPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 12:15:43 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D844C210D6A;
        Fri, 25 Feb 2022 09:15:08 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id c6so8285701edk.12;
        Fri, 25 Feb 2022 09:15:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=G3WG7uUTPibMv4UlvUDNr8pkhZF9aM5gBm7EKESiwQE=;
        b=kN/Lf7VV1FtofEYR+BUsUA4HovKJ/0yVDOn6wpbxG6LWInXVS/osv2QteJDbj/45Jb
         o6nHsSBWS6noMbcnZq/R22qnqssxBYkXzsYSDqRRJMPnJxUiy3Ydlgp+wxK+wF+vYd5i
         Xw3aaS5FNd7n6DiQU5gGzfVz9JTKPeJOW1PguVqQt7V1YOZHW+8BDl4+33761sN43FQL
         JqdGSe6DPGMBlXBNy63vz5AF2fT1DDBVjitCfqkzzmIoUTj/oEoLQ+wKOeCAA7km93YL
         u8fBzPooGWkEWp2tKgu998RMq8eZBr2q8s6qn8QgnHjbmU2yRfKq6fRg1EEYek62mUN0
         InDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G3WG7uUTPibMv4UlvUDNr8pkhZF9aM5gBm7EKESiwQE=;
        b=78ZGKOdOGuX6OiM48KhJu8Xhsb7mEDQhw2oj2M2QBvAfIZ7qjO2Qi4V1wampDhttL/
         iJiZWHiuKmljtO9V0eyfMAdksbDGpzBwYd83sgnHGNqaizyoofbUxFz1YRCaWr96SPlh
         l41I8LRd33I9Vjmgjrs4K9+ag2RwYLJBJhF2HRfEDate9LJDAWwuU12iSiXfpqXaSHZr
         2Df8lrIbuHjovgy0kkmFxuSvv+I858NfDh4DapqijVY5sMLs7FH8JkG1y8o3OpcHLwOA
         Q63xm10cBt9DaA5pgmSFW6f2tUwdBqFgyf/ufwIW3HMRoHzoTxSP74TmjHr+Jn2b/q2x
         47Cw==
X-Gm-Message-State: AOAM530EH0ZHsFEV9hB/4k1rODr75gIyiGmb+MJkY0toitiLvIumP5Zk
        hRu4vUHoZo8WZg2lCDAgtpo=
X-Google-Smtp-Source: ABdhPJyD7IdI5q6Dj0kuFGQJ1MP+8+Lx4NPx2lLbe69aRwbYdevd534rtERymXfqt8TwMU0BkUqFPA==
X-Received: by 2002:a05:6402:1941:b0:413:2822:9c8 with SMTP id f1-20020a056402194100b00413282209c8mr8110838edz.13.1645809307282;
        Fri, 25 Feb 2022 09:15:07 -0800 (PST)
Received: from krava ([2a00:102a:4012:7bee:99f7:73f9:d8ed:b1a])
        by smtp.gmail.com with ESMTPSA id e6-20020a17090681c600b006cea1323f34sm1232211ejx.29.2022.02.25.09.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 09:15:06 -0800 (PST)
Date:   Fri, 25 Feb 2022 18:15:03 +0100
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Alexander Egorenkov <egorenar@linux.ibm.com>
Cc:     jolsa@redhat.com, andrii.nakryiko@gmail.com, andrii@kernel.org,
        ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com
Subject: Re: [RFC bpf-next 0/2] bpf: Fix BTF data for modules
Message-ID: <YhkOl42elY6RckDt@krava>
References: <YY4WfQrExICZ6jI+@krava>
 <878rtz84ol.fsf@oc8242746057.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878rtz84ol.fsf@oc8242746057.ibm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 02:19:06PM +0100, Alexander Egorenkov wrote:
> 
> Hi Jiri and Andrii,
> 
> we also have discovered this problem recently on Fedora 35 and linux-next.
> Is there any status update here ?

Andrii made the fix:
  https://lore.kernel.org/bpf/20211117194114.347675-1-andrii@kernel.org/

IIRC there's still some issues, but they dont have too big
impact on the size, it's discussed in that link

> 
> @Jiri
> Is the increase of total kernel modules size by 20MB really a big deal
> on s390x ? We would like to have it enabled on our architecture
> again ;-) And 20MB seems okay or am i missing something maybe ?

20M is not that much, the problem was that it's double the size
of all the modules and it was problem on rhel, where the impact
was much bigger for some reason

the fix seems to be already in fedora kernel so we could enable
BTF for s390x, I'll check on that

> 
> Another question i have wrt to BTF is why is it necessary to have e.g.
> _struct module_ be present within kernel module BTF if it is already
> present within vmlinux's one ? Can't the one from vmlinux be reused for
> kernel modules as well, they should be identical, right ?

that's basically the issue.. the dedup algo did not cover all the
cases so BTF kept both module structs because they were 'different'

jirka

> 
> Thanks
> Regards
> Alex
