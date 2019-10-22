Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A120EE0B4B
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 20:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730808AbfJVSRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 14:17:07 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39682 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727226AbfJVSRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 14:17:07 -0400
Received: by mail-qk1-f193.google.com with SMTP id 4so17167255qki.6
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 11:17:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=IAJUt/vLXQXxuyMX+swJHjPexvNuUqlo5dHZ7AlMbe8=;
        b=jpMdroYu6ki7Yw9ahOhHVFC6FjM/ZIWtI+DCzwhQKUJ2QwmkrNVkewh6pAgu1Z59dK
         pA+Z+DcJ7fGDd8H+qM7J1rcq4wnqTeItnqZqM2y951Q7nOuZcvtJxlI/Zl706eYh5ODX
         QO2arpZ9JCmtZWGOuw6IIAyV2cPa7O1bKP94sHnob+Nnfvmy66OZ4M+PQf8JFoic0FDR
         f8RfmIweFB1emXNSq9qLuCdqPIBJGyLawOVol+o5xJDSeqg2utm6SW/30d79JF4WBhyB
         zKbwGdtsi3ADMJh6tHEuzfyq+kYJgUVTAUTzmK1WXNw/FOgtvPSo3iclQxn6H9mJXn74
         SFCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=IAJUt/vLXQXxuyMX+swJHjPexvNuUqlo5dHZ7AlMbe8=;
        b=AsTmyXVeq7vyZuRuC7FaZ/3uK0Li0giEtj41yNDwfZTTv/VMk3LUb4erH2UT2JGTTr
         b0ouSQ/IGVKzT4z7vUZ6w6vF9CQ9EpQS7XuWdD+34D7ZnBGlbDa9cTA/SiatygOfblov
         mGCcwjVsFIU7DV3m1jdArvI3Wuv/hV+QjqL7Nr2aHsv1mc+FVzX7GVtTpabNmcDD8Eqp
         OAxyU8zoUoQu1IUTzIEzUXpYcaMqXEIYneK/yC/ydwsI5S6LxFKRnR//jDNnRlwVpuA1
         1BP++5dytp1vMt4bpeDhPr9hivglCbRw/eyMSm+ap2EvA1gOR/claJbZvrgt6VudwicF
         cdMA==
X-Gm-Message-State: APjAAAWoBl/exHdbkOPjHfcH7UfbUwrz9lOQzxXKvmRnunHtpbXHd3dV
        pv+u9o76OpZFW/C501X+msaXSQ==
X-Google-Smtp-Source: APXvYqyXURyLKDMwN1GmVgk4rC+WHgMWjwtz6AeWeDQMxkBAzbgFFqmG70CikJ0fMDTpWiB7znQxag==
X-Received: by 2002:a05:620a:1e:: with SMTP id j30mr4175428qki.301.1571768226544;
        Tue, 22 Oct 2019 11:17:06 -0700 (PDT)
Received: from sevai (69-196-152-194.dsl.teksavvy.com. [69.196.152.194])
        by smtp.gmail.com with ESMTPSA id p7sm10795138qkc.21.2019.10.22.11.17.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Oct 2019 11:17:06 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs\@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong\@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri\@resnulli.us" <jiri@resnulli.us>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "dcaratti\@redhat.com" <dcaratti@redhat.com>,
        "pabeni\@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH net-next 00/13] Control action percpu counters allocation by netlink flag
References: <20191022141804.27639-1-vladbu@mellanox.com>
        <20191022143539.GY4321@localhost.localdomain>
        <vbfmudsx26l.fsf@mellanox.com>
Date:   Tue, 22 Oct 2019 14:17:04 -0400
In-Reply-To: <vbfmudsx26l.fsf@mellanox.com> (Vlad Buslov's message of "Tue, 22
        Oct 2019 14:52:37 +0000")
Message-ID: <85imog63xb.fsf@mojatatu.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vlad Buslov <vladbu@mellanox.com> writes:

> On Tue 22 Oct 2019 at 17:35, Marcelo Ricardo Leitner <mleitner@redhat.com> wrote:
>> On Tue, Oct 22, 2019 at 05:17:51PM +0300, Vlad Buslov wrote:
>>> Currently, significant fraction of CPU time during TC filter allocation
>>> is spent in percpu allocator. Moreover, percpu allocator is protected
>>> with single global mutex which negates any potential to improve its
>>> performance by means of recent developments in TC filter update API that
>>> removed rtnl lock for some Qdiscs and classifiers. In order to
>>> significantly improve filter update rate and reduce memory usage we
>>> would like to allow users to skip percpu counters allocation for
>>> specific action if they don't expect high traffic rate hitting the
>>> action, which is a reasonable expectation for hardware-offloaded setup.
>>> In that case any potential gains to software fast-path performance
>>> gained by usage of percpu-allocated counters compared to regular integer
>>> counters protected by spinlock are not important, but amount of
>>> additional CPU and memory consumed by them is significant.
>>
>> Yes!
>>
>> I wonder how this can play together with conntrack offloading.  With
>> it the sw datapath will be more used, as a conntrack entry can only be
>> offloaded after the handshake.  That said, the host can have to
>> process quite some handshakes in sw datapath.  Seems OvS can then just
>> not set this flag in act_ct (and others for this rule), and such cases
>> will be able to leverage the percpu stats.  Right?
>
> The flag is set per each actions instance so client can chose not to use
> the flag in case-by-case basis. Conntrack use case requires further
> investigation since I'm not entirely convinced that handling first few
> packets in sw (before connection reaches established state and is
> offloaded) warrants having percpu counter.

Hi Vlad,

Did you consider using TCA_ROOT_FLAGS instead of adding another
per-action 32-bit flag?
