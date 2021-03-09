Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7EC332FC8
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 21:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbhCIUVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 15:21:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbhCIUUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 15:20:35 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486DFC06174A;
        Tue,  9 Mar 2021 12:20:35 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id k12so22484158ljg.9;
        Tue, 09 Mar 2021 12:20:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AfXw+qVWQcd4NrOrbXZrQXqyq31FL/q6lgj/WpezipQ=;
        b=KDekO9jGfJLKbb4BqvmpSnnuFmrIr4dnIN/+DUrZDmWS0lSy3f2GMNuQmsrUck/Gtp
         TtsczpLgGTv5PpLwyvj1pXGa7Ya1+A58H3hzoC+MzuapwJ10WDnp6Bzyrpyp7hQi8j2F
         YzTmu+wNTl8w/xdk3rf/nqMTKbuqmCT8ActLmTEg4QTb1hceUpFASn0YZj/tb6gtHBiA
         1N9c2UQaSZ1dfu8q4XPp0YVD8TnTzAanXsvLgChaG3p0p/SnjD3cmu4+FV/xT/N59Cde
         p2ZDbjdW63qgtwRud+OwUSbXzQRCWI7gl1zhFOSjD/WqL6zVI2ZvDuVAdsi8c2HZ2Klb
         o1aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AfXw+qVWQcd4NrOrbXZrQXqyq31FL/q6lgj/WpezipQ=;
        b=rigV2YkEawwAijhjypIgA1TzRoLFwyBk088n/PGaCXg7nVZpXjIr7ZlukQW1nakXG6
         RFpoQLZwlp7h0tbn/EBGzdaULfhDvZ98xjZ4lybucARZPZ5CccX8Etok1WfATBgZcwAR
         hzYnPVEnc5S/bfQ2sSNahfBWqTWSmCclNYtfh3Ve/lii2+uMPk74BbxzSG2ZHuhT0qRq
         GuXfk5hXl151U5RT+Q0DHz3fKefwPat2nsmnzYYEVAlcvj8VZHpSmzCWkGOQ7ZPL2ky6
         Tnsp7DpBa71+SmQyOutLHEa3mdtyHn3PikJEoXWmgoVjChLPJPXuCtrgvJQypPPhQxfu
         zO9A==
X-Gm-Message-State: AOAM532rqMxga3t94KTZTJzjVR5D4aoVu/oUKBwzpTeKIXbHObuX52Gm
        LiNMPNfGlWXIA/M6O7RoOsqqhKDO91pb2afQB80=
X-Google-Smtp-Source: ABdhPJxvyOaj1SF0Qci9pDW0/BqtzIFadX8bq8mUFHy1Pm5A4e3HoWoocfPa9DK8oj8UY/ZBIfSDoCVd0aFPcGfU2m0=
X-Received: by 2002:a2e:900b:: with SMTP id h11mr18100141ljg.258.1615321233728;
 Tue, 09 Mar 2021 12:20:33 -0800 (PST)
MIME-Version: 1.0
References: <20210309044349.6605-1-tonylu@linux.alibaba.com>
 <20210309124011.709c6cd3@gandalf.local.home> <5fda3ef7-d760-df4f-e076-23b635f6c758@gmail.com>
 <20210309150227.48281a18@gandalf.local.home> <fffda629-0028-2824-2344-3507b75d9188@gmail.com>
In-Reply-To: <fffda629-0028-2824-2344-3507b75d9188@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 9 Mar 2021 12:20:22 -0800
Message-ID: <CAADnVQLSyH8Kk4g6TDbS0w3zETLyXka917DKDn9Gjha-b5w-dw@mail.gmail.com>
Subject: Re: [PATCH] net: add net namespace inode for all net_dev events
To:     David Ahern <dsahern@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Tony Lu <tonylu@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 9, 2021 at 12:18 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 3/9/21 1:02 PM, Steven Rostedt wrote:
> > On Tue, 9 Mar 2021 12:53:37 -0700
> > David Ahern <dsahern@gmail.com> wrote:
> >
> >> Changing the order of the fields will impact any bpf programs expecting
> >> the existing format
> >
> > I thought bpf programs were not API. And why are they not parsing this
> > information? They have these offsets hard coded???? Why would they do that!
> > The information to extract the data where ever it is has been there from
> > day 1! Way before BPF ever had access to trace events.
>
> BPF programs attached to a tracepoint are passed a context - a structure
> based on the format for the tracepoint. To take an in-tree example, look
> at samples/bpf/offwaketime_kern.c:
>
> ...
>
> /* taken from /sys/kernel/debug/tracing/events/sched/sched_switch/format */
> struct sched_switch_args {
>         unsigned long long pad;
>         char prev_comm[16];
>         int prev_pid;
>         int prev_prio;
>         long long prev_state;
>         char next_comm[16];
>         int next_pid;
>         int next_prio;
> };
> SEC("tracepoint/sched/sched_switch")
> int oncpu(struct sched_switch_args *ctx)
> {
>
> ...
>
> Production systems do not typically have toolchains installed, so
> dynamic generation of the program based on the 'format' file on the
> running system is not realistic. That means creating the programs on a
> development machine and installing on the production box. Further, there
> is an expectation that a bpf program compiled against version X works on
> version Y.

This is not true.
