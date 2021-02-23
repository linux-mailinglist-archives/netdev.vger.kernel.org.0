Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5F8323217
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 21:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbhBWU2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 15:28:08 -0500
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:50315 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234257AbhBWU2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 15:28:06 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 2B9759B1;
        Tue, 23 Feb 2021 15:26:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 23 Feb 2021 15:26:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zenhack.net; h=
        content-type:mime-version:content-transfer-encoding:from:to
        :subject:date:message-id; s=fm2; bh=KD5tX6TuD84i/FYKtPCrAU1tmLQt
        iAWOqW720seKQYQ=; b=Aqwwavn6I92dO/jW1px7nzkFIt4XM/St5fYhR8s/tHpk
        hPDMtJo9eqtUUzbJnDM7fNZoqU6WtQoFO0XR8Xoh/4YwI9FBdxLmUr9D69z8CgTi
        JrG8IoJDhH1L4sw2vVquGM+QFxT1WYLFtT7b9zGcoazSMu8Q+99yHRNnwuCjppo9
        h1Fft3hI8SEpm34ta0sep5gDfDE/o5zdcBtRRcO6Yj9wWFm5JWPKZfFtWmzywMOu
        9rcK3ESz0yLNT+AHtykZjfomJDgTx7x3NOziN9+FuxvFSq7wegj5aZX6Tiw3c0cV
        sN9vXmPowRGaDD9YrSf31oFixFj2zzXftqtUXOhdhQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=KD5tX6
        TuD84i/FYKtPCrAU1tmLQtiAWOqW720seKQYQ=; b=W65sPa+9u+yPX+Q8taaJ35
        ar10jwYv3wl3yMdPRrXBdePdm24Q1ygg9yMo1Sz7EFbeLmyKQDO3iToOf7KpSnoi
        Ht8WcRYNpGBz1ylbxivf+cCrjmZeoUBd2rRcPAPhGrCguu0owvepHH6nQDnC9ICu
        /Y6jVJ6lYrfYZlB7FwhwasER72zMP7QafDgBJTugxiTwsLZq4CDhpb8drIV+CzCG
        Yh5Ug9Az3fXvn9DSdRB48MX56bfBy6P5PB0pfJ/BLjTktVhQd7FgIfrPN5Xa047D
        Pywruhs5TxJXYlwA2rz4tPowKpC/HnWOvGI5egLbFn6+lA6CnvKBFR1+QnCPWpCQ
        ==
X-ME-Sender: <xms:CmU1YKVQiwxqdcFhXOK5OKh4rphrAem-9DKONbhaNVxXo9ehDuC6kA>
    <xme:CmU1YPgRqNmzWVmspfZ_-O2NJLT1cnqgLYeACk6xA84voj8qlgybp3Ipp49095XU7
    WEacY7TBC3VmQ_lLTc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeehgddufeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpegtggfghffvufffkfgfsehtqhertd
    dtreejnecuhfhrohhmpefkrghnucffvghnhhgrrhguthcuoehirghnseiivghnhhgrtghk
    rdhnvghtqeenucggtffrrghtthgvrhhnpeeuleehudetkeekvddtfeduledtheetteejke
    etueeijeeiheeuheetgedtgeeufeenucfkphepuddttddrtddrfeejrddvvddunecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihgrnhesiigvnh
    hhrggtkhdrnhgvth
X-ME-Proxy: <xmx:CmU1YAVi7OqwEgwp2LTon50x1nHvRfTctfsOvxAG3_2BD2PnKnuRoQ>
    <xmx:CmU1YOPs5vSrX7jAcojIZwsO48LQC-9-uH1Y9tGHosxl5yQ1GQwarQ>
    <xmx:CmU1YEbGPKyNxMQGiVjkdDFDUipZ-bALrWNspfnnYtQvGWWGArpy_g>
    <xmx:C2U1YOXhxlT60s3m9m7L7rttC2rmvAvfso5JtOW71VZVks6eXkCVGg>
Received: from localhost (pool-100-0-37-221.bstnma.fios.verizon.net [100.0.37.221])
        by mail.messagingengine.com (Postfix) with ESMTPA id 95DA124005B;
        Tue, 23 Feb 2021 15:26:50 -0500 (EST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
From:   Ian Denhardt <ian@zenhack.net>
To:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: More strict error checking in bpf_asm?
Date:   Tue, 23 Feb 2021 15:26:37 -0500
Message-ID: <161411199784.11959.16534412799839825563@localhost.localdomain>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm using the `bpf_asm` tool to do some syscall filtering, and found out
the hard way that its error checking isn't very strict. In particular,
it issues a warning (not an error) when a jump offset overflows the
instruction's field. It really seems like this *ought* to be a hard
error, but I see from the commit message in
7e22077d0c73a68ff3fd8b3d2f6564fcbcf8cb23 that this was left as a warning
due to backwards compatibility concerns.

I'm skeptical of this trade-off, but would people at least be open to
adding a -Werror flag or the like, if changing it to a hard error
unconditionally is off the table?

Relatedly, while looking through the code I noticed there are several
places where an error occurs that does cause to tool to exit without
generating code, but it exits with 0 (success) status code. It seems
like this ought to report a failure to the caller?

-Ian
