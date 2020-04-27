Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED991BAB9F
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 19:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgD0RsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 13:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725963AbgD0RsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 13:48:24 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38AFC0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 10:48:24 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id q10so17551174ile.0
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 10:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=vAXcjX6ee0HekimclcSWgL02NYtmHVfyc98d/l/9Qd4=;
        b=Ut1BagHBWYIDTM+MtNjev5WdRZPSPtxukukOzToPtXmhiqm3NXgdfNYlG+oGs5UUla
         SUB2TifRC2JTdfdaSZy5AusiEN0b9DzCXixv8Gwh1umhZlSz9vWHKhcwUZni0ITIPd9E
         BOLTYElTHBnDZEVi7htxilepsPeIwhzFJ2TL13m1Uzs52hdsUSxhUtsVKn4Z8QHOteKf
         Ulm6IISw1VFxdSDcDnhvzly4PsBrPw4Op312Cgfh4kbRLqJz96ma3rtl+OtTp4yYujnP
         cxhkFblie4FEl82YgePt/VF+8lGOPV9YLm3AnQ6cXKvhwKTQG9LyV5fnRk8SY+umMIIu
         b5Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=vAXcjX6ee0HekimclcSWgL02NYtmHVfyc98d/l/9Qd4=;
        b=nqRsyDWJ02BTLroRVataUTs2zV1FaT5LPsuq4tmQZiuAkQ0Duw0Oz+1I4fImvB35TC
         ZeLcZvFligs+NGIDNgPliZEwSoRw5y+c5knuFbqkP2RSRjXfppVfPhB+nvs4apAUjZMB
         qjb3QlF4LIrAOIOtw8KUyAsUTijyPlXOTRrcQUkaoUuYueyMLoexqbGuaw/sDuIT/VN8
         VGIKSgTOSaRvVFABenePpLGFhZ5hDBYoHwOx1vghKSrvzqHay+gEHiGF//i3VPnW+cz3
         H5h08pr3NBfu8H29wXxG7W/UNbzS9tCejPRajuMEkBjqAcjH4yQ5TGHFY+wPqZ0WpZ4j
         xwjw==
X-Gm-Message-State: AGi0PuY3qVfE9kjIPbNRIQjSeYO3ElLnZX4zONsJc0+WoAbmAFSNvmPm
        uD9frBGERR0B+3U67yB+FKA=
X-Google-Smtp-Source: APiQypJmkNZx+tR8UPBjrd+/QZ7KrBcPcuDrdr7wgNwylTZ0jYmIcQQhoN3YFZHsvQqawMYLeSz64g==
X-Received: by 2002:a92:48d0:: with SMTP id j77mr21385736ilg.274.1588009703973;
        Mon, 27 Apr 2020 10:48:23 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id n6sm5223097iog.16.2020.04.27.10.48.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 10:48:23 -0700 (PDT)
Date:   Mon, 27 Apr 2020 10:48:14 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Message-ID: <5ea71ade547e3_a372ad3a5ecc5b811@john-XPS-13-9370.notmuch>
In-Reply-To: <20200424201428.89514-14-dsahern@kernel.org>
References: <20200424201428.89514-1-dsahern@kernel.org>
 <20200424201428.89514-14-dsahern@kernel.org>
Subject: RE: [PATCH v3 bpf-next 13/15] selftest: Add test for xdp_egress
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern wrote:
> From: David Ahern <dahern@digitalocean.com>
> 
> Add selftest for xdp_egress. Add xdp_drop program to veth connecting
> a namespace to drop packets and break connectivity.
> 
> Signed-off-by: David Ahern <dahern@digitalocean.com>
> ---

[...]

> +################################################################################
> +# main
> +
> +if [ $(id -u) -ne 0 ]; then
> +	echo "selftests: $TESTNAME [SKIP] Need root privileges"
> +	exit $ksft_skip
> +fi
> +
> +if ! ip link set dev lo xdp off > /dev/null 2>&1; then
> +	echo "selftests: $TESTNAME [SKIP] Could not run test without the ip xdp support"
> +	exit $ksft_skip
> +fi
> +
> +if [ -z "$BPF_FS" ]; then
> +	echo "selftests: $TESTNAME [SKIP] Could not run test without bpffs mounted"
> +	exit $ksft_skip
> +fi
> +
> +if ! bpftool version > /dev/null 2>&1; then
> +	echo "selftests: $TESTNAME [SKIP] Could not run test without bpftool"
> +	exit $ksft_skip
> +fi

This is consistent with test_xdp_veth.sh so it is probably ok for this series
but I think it would be nice to go back and make these fail on errors. Or at
least fail on bpffs mount. Seems other tests fail on bpffs mount failures so
would be OK I think.

Otherwise LGTM.
