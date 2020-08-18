Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B630248FF0
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 23:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgHRVLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 17:11:50 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:47029 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726176AbgHRVLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 17:11:49 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 88B7D5C0058;
        Tue, 18 Aug 2020 17:11:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 18 Aug 2020 17:11:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        mime-version:content-transfer-encoding:content-type:cc:subject
        :from:to:date:message-id:in-reply-to; s=fm1; bh=QS1MqSS+ObdNKAEI
        9D/28OrqnncNLKCTH+R889x7y0w=; b=eE6+s0NefrdgthrnY3HyRbc+MFy1NM6+
        URxCR6UymqcLO3UVrBEICYijCak4SGqIQfSHgomjnL2dnyADli6m/mkxux7NdJJP
        1iuYnUaJX/r667IXl90KrelFbELZ9Iv8T2/buZkYvZJjOGhD7O09oP9hEChHb5C2
        RWfJQZeBdBuzFiTkLi0ZhY1eLLPl//v4dqdyxE991Wv/p6K/lJD5VXQceovEPJas
        KeldrxadZXfzkQfodvku03qYdcls16MkfwCGr/V8XVPOZuiBUV8YTQq0CkYPIGS1
        YbmfwsYvneFIVBrb6DmBwyRW+2rTiEPZVt1u3YZlqt8n/5QFMiPe1Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=QS1MqSS+ObdNKAEI9D/28OrqnncNLKCTH+R889x7y0w=; b=cS+RRI8Q
        g2/GCc+B5vogl/Qct7eXg7knS+R2MSFje7G9iY/JLCCqGlqs2TBR7kXiVF63xRJg
        PuInscrvW5ZZFYR3/1L5UfJrlBVuViqhcT0YcTom0KtV9dph3VuhKyjcGokcq9rM
        FmvCA2R5WH62i0qthG6MyuLKZIs2u2SstAX0Y/A0T73YYvfv1+HGWsJ74cy4oBeo
        THdet88UDIhXx1y3mNCCNY6WcOw2J/lxGEd4+myN0rwqoJ04c9Z0ekstfa3FIGqF
        ajh/K78BufW5QhDnHg+KVV1Bos4uOFptHmnDttocyh+cy6lL+PuVRLmYiTuOIZHv
        bu/44WP2oe8vDw==
X-ME-Sender: <xms:FEQ8X0A_NRT8r4g-2ejXdooX2M_d1ygGESO0CMatDl748kjUovySoA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtiedgudefkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enfghrlhcuvffnffculdefhedmnecujfgurhepggfgtgfuhffvfffkjgesthhqredttddt
    jeenucfhrhhomhepfdffrghnihgvlhcuighufdcuoegugihusegugihuuhhurdighiiiqe
    enucggtffrrghtthgvrhhnpeejfefhudeffefhjedvvefhheduledtueejvedugedvjedv
    jeeljefggedtjeejveenucfkphepjeefrdelfedrvdegjedrudefgeenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdig
    hiii
X-ME-Proxy: <xmx:FEQ8X2iKdYhQ6oejPGA2peW7LBjhkkJBe8x1J13yUoOr7BwYlJExsg>
    <xmx:FEQ8X3m2pXO_Fs7lVCOtSNy2YQQsb-VEevYzG9Osfrysp_y9xhsWlg>
    <xmx:FEQ8X6zT7omDvJyhpeHRpbyqLstFUmxPUycWZ2q2IabExpedrW-Fbg>
    <xmx:FEQ8X4H0cOAtW09zXO2OwFPUhyWEFFB9HUkoOQlM8xFJjnza2N7zUQ>
Received: from localhost (c-73-93-247-134.hsd1.ca.comcast.net [73.93.247.134])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1A71E3060067;
        Tue, 18 Aug 2020 17:11:47 -0400 (EDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Cc:     "bpf" <bpf@vger.kernel.org>, "Networking" <netdev@vger.kernel.org>,
        <mchehab@kernel.org>, "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Martin Lau" <kafai@fb.com>, <maze@google.com>,
        <ashkan.nikravesh@intel.com>
Subject: Re: [PATCH] bpf: Add bpf_ktime_get_real_ns
From:   "Daniel Xu" <dxu@dxuuu.xyz>
To:     "Andrii Nakryiko" <andrii.nakryiko@gmail.com>,
        <bimmy.pujari@intel.com>
Date:   Tue, 18 Aug 2020 13:50:48 -0700
Message-Id: <C50F3QS9W4JM.1OIVL1ZHWEIWI@maharaja>
In-Reply-To: <CAEf4BzYMaU14=5bzzasAANJW7w2pNxHZOMDwsDF_btVWvf9ADA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon Jul 27, 2020 at 10:01 PM PDT, Andrii Nakryiko wrote:
> On Mon, Jul 27, 2020 at 4:35 PM <bimmy.pujari@intel.com> wrote:
> >
> > From: Ashkan Nikravesh <ashkan.nikravesh@intel.com>
> >
> > The existing bpf helper functions to get timestamp return the time
> > elapsed since system boot. This timestamp is not particularly useful
> > where epoch timestamp is required or more than one server is involved
> > and time sync is required. Instead, you want to use CLOCK_REALTIME,
> > which provides epoch timestamp.
> > Hence add bfp_ktime_get_real_ns() based around CLOCK_REALTIME.
> >
>
> This doesn't seem like a good idea. With time-since-boot it's very
> easy to translate timestamp into a real time on the host.=20

For bpftrace, we have a need to get millisecond-level precision on
timestamps. bpf has nanosecond level precision via
bpf_ktime_get[_boot]_ns(), but to the best of my knowledge userspace
doesn't have a high precision boot timestamp.

There's /proc/stat's btime, but that's second-level precision. There's
also /proc/uptime which has millisecond-level precision but you need to
make a second call to get current time. Between those two calls there
could be some unknown delta. For millisecond we could probably get away
with calculating a delta and warning on large delta but maybe one day
we'll want microsecond-level precision.

I'll probably put up a patch to add nanoseconds to btime (new field in
/proc/stat) to see how it's received. But either this patch or my patch
would work for bpftrace.

[...]

Thanks,
Daniel
