Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E562C47ED
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 19:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732793AbgKYSvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 13:51:53 -0500
Received: from smtp.uniroma2.it ([160.80.6.22]:34413 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730989AbgKYSvw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 13:51:52 -0500
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 0APIof21029257;
        Wed, 25 Nov 2020 19:50:46 +0100
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id AFEE3120099;
        Wed, 25 Nov 2020 19:50:36 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1606330237; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RI2z5auShChbvX++r2Eysg8y/Lw5LNxiLNrqt336ilY=;
        b=a9BFTfaTFwoIPlEon8IwPMC8Zd4D2AYhXbCfhWgkLjDpooYa6+D8KnoBGoxtlHRRsDZKWN
        e0jsV6ediANHCbDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1606330237; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RI2z5auShChbvX++r2Eysg8y/Lw5LNxiLNrqt336ilY=;
        b=uhniSVljPrm5cmIiqWilJ6AKE101ATakXX/24p2Vj0OIT2PBRnLZHW6G1XgobI9SRFGSxJ
        +d03TmH4kA+BfcZ5WuYfRXyqv9AH7AyXUX4xRu5uKKq+jdtedMIWcRSCsvvuQzkmb9ZbB8
        s0+OQCDsnyFADSm+02aWGrRmWSdMoccCI+virAPvTQIYMttoTP3M+QH/DfDS10iZr7H9G+
        ZDeDHUPSKOzUmnA+CHsNYOLYL7LqdTkDQW+x1DBeIhVKy/A0ayWu4u/FEexKTz0VzLD0q6
        74Rz26bPBHpriYNHHF9vkiCQ0NXOpd1WEstbt2xtHHPts5qTX3mUCC2VKXwzyw==
Date:   Wed, 25 Nov 2020 19:50:36 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [net-next v3 5/8] seg6: add support for the SRv6 End.DT4
 behavior
Message-Id: <20201125195036.4b5b5645ff32926ca83b1359@uniroma2.it>
In-Reply-To: <20201124154017.4b1a905c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201123182857.4640-1-andrea.mayer@uniroma2.it>
        <20201123182857.4640-6-andrea.mayer@uniroma2.it>
        <20201124154017.4b1a905c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,
thanks for your review.

On Tue, 24 Nov 2020 15:40:17 -0800
Jakub Kicinski <kuba@kernel.org> wrote:

> On Mon, 23 Nov 2020 19:28:53 +0100 Andrea Mayer wrote:
> > +static int cmp_nla_vrftable(struct seg6_local_lwt *a, struct seg6_local_lwt *b)
> > +{
> > +	struct seg6_end_dt_info *info_a = seg6_possible_end_dt_info(a);
> > +	struct seg6_end_dt_info *info_b = seg6_possible_end_dt_info(b);
> > +
> > +	if (IS_ERR(info_a) || IS_ERR(info_b))
> > +		return 1;
> 
> Isn't this impossible? I thought cmp() can only be called on fully
> created lwtunnels and if !CONFIG_NET_L3_MASTER_DEV the tunnel won't 
> be created?
> 

The function cmp_nla_vrftable() can be called only if the lwtunnel is created
successfully.

A SRv6 behavior using a vrftable attribute can be successfully instantiated only
if CONFIG_NET_L3_MASTER_DEV is set. Otherwise (CONFIG_NET_L3_MASTER_DEV not set),
the function parse_nla_vrftable() returns an error (obtained from the
seg6_possible_end_dt_info()) and tunnel creation fails.

The pointer returned from seg6_possible_end_dt_info() depends on
CONFIG_NET_L3_MASTER_DEV. I thought it would be reasonable to check its validity
in functions that make explicit use of seg6_possible_end_dt_info() even in cases
where this was not strictly necessary (i.e: cmp_nla_vrftable()).

Therefore, it turns out to be an impossible case. I can remove these checks in
the next v4.

Thank you,
Andrea

> > +	if (info_a->vrf_table != info_b->vrf_table)
> > +		return 1;
> > +
> > +	return 0;
