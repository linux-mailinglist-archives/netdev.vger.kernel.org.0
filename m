Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14260204F93
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 12:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732371AbgFWKvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 06:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732353AbgFWKva (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 06:51:30 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9582DC061795
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 03:51:29 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id c11so11388980lfh.8
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 03:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=jAVX5qNY3xX90Cjh1Jp/0eHcv8V0BN7tJ1RLPzcNmkY=;
        b=j5JxL8i2bmFYP+AJWUrt5NYM1E/hZ1+g76xW4twVTVGKD3ts2RRa6z2EYc2m9ZnAkp
         htcEhGDxIgIlsNHBS1Kmk/5YEfxOlOtC9VxcyKfPjjSuaDzF4BDD4oDVTHMFcMHHqNc1
         ohAVpEy+3IDrl8Ar9rrgMHqEYJeqWhluuXYJY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=jAVX5qNY3xX90Cjh1Jp/0eHcv8V0BN7tJ1RLPzcNmkY=;
        b=ZxaVLA6iEnpJKhIwxg1f0osRrVwGvdi8PeIP1JtFXfMOUUscoDTUNfY8B8ZV9gdcjs
         H5FzOLjJtTRqcDu3jO9Ux7KOUC7ksIeGB8sHf3Pp4oGj1pHWQtRIblausM9HCddztyAE
         SkdnZZ5j67wF1MvPQHsMxh9ky/OeF6yxfpFKU4ToTRBjR23gKXE8DoKx40yr0ruwumTF
         jDSCLe/iUw7OHthIVAU5QsZZJwH0qXxFZ8kdSNQ1vM7V3HtmxxpC4NbKQzEpU9QORGmE
         5jevZNzq3vIqY3362A5MyBRWIL9+vyvSm5cUsIEBPei961VUdyXP5Iqghj457xImja64
         o+pg==
X-Gm-Message-State: AOAM532yO/il9HUHTjr+K+7UDkXiWd+hq2DKfalCQ5v3A19FsTR41sss
        Uqqe5Y8dAWrNO+eMcct4N6tyC/k0pJf/KQ==
X-Google-Smtp-Source: ABdhPJxbnGdD/ZA++Wu2bUgEA8N29ibeSN0ZMP0hSCkMfEx4C/B2e6V4J2ZR13lythD02XxEYCmb5w==
X-Received: by 2002:a19:8407:: with SMTP id g7mr12472742lfd.61.1592909487933;
        Tue, 23 Jun 2020 03:51:27 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id q190sm3200937ljb.29.2020.06.23.03.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2020 03:51:27 -0700 (PDT)
References: <20200622160300.636567-1-jakub@cloudflare.com> <20200622160300.636567-3-jakub@cloudflare.com> <CAEf4BzYY8NcmprF-V3SxBgiF0mqNpK-qrymt=wvz6iCON=geiw@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com
Subject: Re: [PATCH bpf-next 2/3] bpf, netns: Keep attached programs in bpf_prog_array
In-reply-to: <CAEf4BzYY8NcmprF-V3SxBgiF0mqNpK-qrymt=wvz6iCON=geiw@mail.gmail.com>
Date:   Tue, 23 Jun 2020 12:51:26 +0200
Message-ID: <87tuz2m4wh.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 08:23 AM CEST, Andrii Nakryiko wrote:
> On Mon, Jun 22, 2020 at 9:04 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> Prepare for having multi-prog attachments for new netns attach types by
>> storing programs to run in a bpf_prog_array, which is well suited for
>> iterating over programs and running them in sequence.
>>
>> Because bpf_prog_array is dynamically resized, after this change a
>> potentially blocking memory allocation in bpf(PROG_QUERY) callback can
>> happen, in order to collect program IDs before copying the values to
>> user-space supplied buffer. This forces us to adapt how we protect access
>> to the attached program in the callback. As bpf_prog_array_copy_to_user()
>> helper can sleep, we switch from an RCU read lock to holding a mutex that
>> serializes updaters.
>>
>> To handle bpf(PROG_ATTACH) scenario when we are replacing an already
>> attached program, we introduce a new bpf_prog_array helper called
>> bpf_prog_array_replace_item that will exchange the old program with a new
>> one. bpf-cgroup does away with such helper by computing an index into the
>> array based on program position in an external list of attached
>> programs/links. Such approach seems fragile, however, when dummy progs can
>> be left in the array after a memory allocation failure on link release.
>
> bpf-cgroup can have the same BPF program present multiple times in the
> effective prog array due to inheritance. It also has strict
> guarantee/requirement about relative order of programs in parent
> cgroup vs child cgroups. For such cases, replacing a BPF program based
> on its pointer is not going to work correctly.

Thanks for the explanation. That did not occur to me. Incorporated it
into the description in v2.

>
> We do need to make sure that cgroup detachment never fails by falling
> back to replacing BPF prog with dummy prog, though. If you are
> interested in a challenge, you are very welcome to do that! :)

I keep a list of tasks for a slow day.

[...]
