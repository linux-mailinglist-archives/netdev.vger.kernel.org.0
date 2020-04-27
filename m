Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4AC1BABB5
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 19:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgD0RwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 13:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726223AbgD0RwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 13:52:19 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A5EC0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 10:52:19 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id c16so17547385ilr.3
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 10:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=jduy6oupGWkzkfn2UioVpeJyLztRDHdfNWx877uafe4=;
        b=ZQKJhaWrDJvhYRuePfl7T9qG05aYi2uHuFHjB2MPFzyvd5M2WQI4+RMw9mN+WA5ZRt
         eomW6SEOsauyMkDid4sYPdiiftKPCfxtedaK2AMVpiwnzlIDCzgQoUQiRXESNvsqjvK8
         MiOirNriQ4fNvqvJaky3bNrhxlO6RPJqQXqxsvrUFmYtzWHojAyNoOFdUIeiTkd7SBQe
         dhcTIHfnQEQfqlsdBzOEQfktXTvvmxX4xedl7nQNt2aTdQqGmE2XJLVqpM5mi4bI4+AM
         DAUZx3ivedvnwnFZtGp16Nw4Qsq31PN8kfFc3VRV4NF/KWeCof6NZ6M8gz+z0zLjnLhU
         Dftw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=jduy6oupGWkzkfn2UioVpeJyLztRDHdfNWx877uafe4=;
        b=i6uwpbND1+csr0+HO9K48mzW0SQBVyHZEezq83hxGMR0noEQXAr9aoPrTE+HXFegLC
         6eCmPUvkNpSM8Nk61l7ETVtFz1JKRtIGeSkx/NGTaRk92OoriwCjKLCZ93d1BTmc7qJ2
         LVL3FB/5o60EL7QdyEl96GbWTPKK0IZAzgubH1Ykm3thgR+srhEMFClWCv20fRLEjaXt
         1PXgLqSX0je5V0qJt8sNsbgJ915o2cWHyBjs7GajAPabzSaI7mxEBoNUce35/jhrF6PN
         g2VXazG9+wdJZN7+NMSt/+i/3SGdQ211hJawDIqH4UxwcPPu9SG/ennCojF+o/Te9rXC
         pl+w==
X-Gm-Message-State: AGi0PuYIOWFROM309Zqlb44zTStba1WH7lLjn9ZA6yKXcU08wNr6qyhf
        mYs7BHPh3Kqa0yAg3dNcK/0=
X-Google-Smtp-Source: APiQypIuzNGAht0TMJndkz55e0x57RmNwpW186IE0/bBKbEJGY/tANYNx+OeAHWz/PnQkxJGbu4mIQ==
X-Received: by 2002:a92:5dca:: with SMTP id e71mr21193604ilg.34.1588009939109;
        Mon, 27 Apr 2020 10:52:19 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id h15sm5117810ior.20.2020.04.27.10.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 10:52:18 -0700 (PDT)
Date:   Mon, 27 Apr 2020 10:52:11 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Message-ID: <5ea71bcb29f67_a372ad3a5ecc5b864@john-XPS-13-9370.notmuch>
In-Reply-To: <5ea71ade547e3_a372ad3a5ecc5b811@john-XPS-13-9370.notmuch>
References: <20200424201428.89514-1-dsahern@kernel.org>
 <20200424201428.89514-14-dsahern@kernel.org>
 <5ea71ade547e3_a372ad3a5ecc5b811@john-XPS-13-9370.notmuch>
Subject: RE: [PATCH v3 bpf-next 13/15] selftest: Add test for xdp_egress
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend wrote:
> David Ahern wrote:
> > From: David Ahern <dahern@digitalocean.com>
> > 
> > Add selftest for xdp_egress. Add xdp_drop program to veth connecting
> > a namespace to drop packets and break connectivity.
> > 
> > Signed-off-by: David Ahern <dahern@digitalocean.com>
> > ---
> 
> [...]
> 
> > +################################################################################
> > +# main
> > +
> > +if [ $(id -u) -ne 0 ]; then
> > +	echo "selftests: $TESTNAME [SKIP] Need root privileges"
> > +	exit $ksft_skip
> > +fi
> > +
> > +if ! ip link set dev lo xdp off > /dev/null 2>&1; then
> > +	echo "selftests: $TESTNAME [SKIP] Could not run test without the ip xdp support"
> > +	exit $ksft_skip
> > +fi
> > +
> > +if [ -z "$BPF_FS" ]; then
> > +	echo "selftests: $TESTNAME [SKIP] Could not run test without bpffs mounted"
> > +	exit $ksft_skip
> > +fi
> > +
> > +if ! bpftool version > /dev/null 2>&1; then
> > +	echo "selftests: $TESTNAME [SKIP] Could not run test without bpftool"
> > +	exit $ksft_skip
> > +fi
> 
> This is consistent with test_xdp_veth.sh so it is probably ok for this series
> but I think it would be nice to go back and make these fail on errors. Or at
> least fail on bpffs mount. Seems other tests fail on bpffs mount failures so
> would be OK I think.
> 
> Otherwise LGTM.

Also would be nice to have a test case for the xdp redirect into tx case. I think
this is only going to test the skb path?

Thanks,
John
