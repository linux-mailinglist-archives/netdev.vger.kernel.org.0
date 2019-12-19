Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D13BE127167
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 00:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbfLSXZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 18:25:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:59838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbfLSXZG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 18:25:06 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B45D24676;
        Thu, 19 Dec 2019 23:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576797905;
        bh=OpW/vFNf8yuCa8Ujk2w/8mdhZTESUxbg4sfNSMdxIHE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M1mE44UBGUY1+ZZYHVyOH2bv1PtMbbuFI06lRR9E7DrnkqhLjcRo9IDKlO5eBwGm1
         Qd7ximLPII8aePutZuDhgLhjbK2UiFqoYwZ/miTjJSKxDYo4AUcsEE679zgsFz6xfE
         4MV4L1LITHTN3t1q4yfZwIpmaQgY2SVPukrUvuiI=
Date:   Thu, 19 Dec 2019 18:25:04 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, oss-drivers@netronome.com
Subject: Re: [oss-drivers] [PATCH AUTOSEL 5.4 326/350] bpf: Switch bpf_map
 ref counter to atomic64_t so bpf_map_inc() never fails
Message-ID: <20191219232504.GV17708@sasha-vm>
References: <20191210210735.9077-1-sashal@kernel.org>
 <20191210210735.9077-287-sashal@kernel.org>
 <20191210132834.157d5fc5@cakuba.netronome.com>
 <20191212162513.GB1264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191212162513.GB1264@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 05:25:13PM +0100, Daniel Borkmann wrote:
>On Tue, Dec 10, 2019 at 01:28:34PM -0800, Jakub Kicinski wrote:
>> On Tue, 10 Dec 2019 16:07:11 -0500, Sasha Levin wrote:
>> > From: Andrii Nakryiko <andriin@fb.com>
>> >
>> > [ Upstream commit 1e0bd5a091e5d9e0f1d5b0e6329b87bb1792f784 ]
>> >
>> > 92117d8443bc ("bpf: fix refcnt overflow") turned refcounting of bpf_map into
>> > potentially failing operation, when refcount reaches BPF_MAX_REFCNT limit
>> > (32k). Due to using 32-bit counter, it's possible in practice to overflow
>> > refcounter and make it wrap around to 0, causing erroneous map free, while
>> > there are still references to it, causing use-after-free problems.
>>
>> I don't think this is a bug fix, the second sentence here is written
>> in a quite confusing way, but there is no bug.
>>
>> Could you drop? I don't think it's worth the backporting pain since it
>> changes bpf_map_inc().
>
>Agree, this is not a bug fix and should not go to stable. (Also agree that
>the changelog is super confusing here and should have been done differently
>to avoid exactly where we are here. I think I pointed that out in the
>original patch, but seems this slipped through the cracks :/)

Sure, dropped, thanks!

-- 
Thanks,
Sasha
