Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95AC815969A
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 18:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729612AbgBKRum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 12:50:42 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40482 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728786AbgBKRum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 12:50:42 -0500
Received: by mail-wm1-f68.google.com with SMTP id t14so4711149wmi.5
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 09:50:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:message-id:in-reply-to
         :date:mime-version;
        bh=AMwwDbLy+3cZfgAmWY8sK6TmOoQdrk/L8DkzfEsyPo0=;
        b=aHpKGFe0JSoHnFaboywwj1R6khiKhuMXMFo/YHyr5XrsmKb7OFjn3yunSeOQBFODj8
         AjUMsfFxaXGfRj9HR/xPm1AMXv8ebunAYRoaCSM4K/+m030pCFsrIUkFp9LkH+vo2MMg
         A2USU2TydRXcbBCTTjvrHBflwcWIVa5s+gl3jXOfhk1YSR4uP/NMRI7sAGZy3QOXmrd9
         8k4utfPxWqRinCRTi1bXmXWPPlsV0mkHAhIi2JVQ5qEy0TufvKBvEyPEUd5PG9k7T054
         iK0YjWWfEtz5h6k2CZO/pFjR1Ksea58t5KFfQhc5T93U7SSEmazC5UI2L4O3PT+ng9gK
         2T9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :message-id:in-reply-to:date:mime-version;
        bh=AMwwDbLy+3cZfgAmWY8sK6TmOoQdrk/L8DkzfEsyPo0=;
        b=hmvaROBk0oj9lqAIpskTXZOtun3PtusfEIuToh5wB4MYblIxr+NU7HPPYETAlVDoYP
         XlH1UQkyICyoU99AxtROIdu7DEnSL/Wo8Pq34lzAbZj6i9qma3+3UVCPGSsLALaNNqc5
         5jQ3MOW7rg+N2y8/cyH3sfI83P9psoIsA/mixXAl5FPA4vC9KBh2tfox/oQ8mOSc9j0W
         /KV60MiNO3zGsT10uMW/EFQ8LzeGiSrk8oV76/JQt4qMYItLSjWL6P5W1CYxReKCBnVL
         zWm+Uas6eyCoCz5mveMy3LWbz2KUDuCFz1vo3PurE+evKn9gBB2NgJz9+9ELwaUq411X
         lJEw==
X-Gm-Message-State: APjAAAXnLMoVhF/HH3i4rondns717vioD5Coc/EMFNo+LmoY6PjIMrCr
        V9p5kYr0PCIZ907t3FMAhVUytFn2
X-Google-Smtp-Source: APXvYqzcN74Efd+gXg562KhtoBIHH51kq79LsMWggl8SrrgaXuH2ftYMzS32A3347dg2j8RNE9zJvg==
X-Received: by 2002:a7b:c4c3:: with SMTP id g3mr6639606wmk.131.1581443441008;
        Tue, 11 Feb 2020 09:50:41 -0800 (PST)
Received: from yaviefel (ip-213-220-234-169.net.upcbroadband.cz. [213.220.234.169])
        by smtp.gmail.com with ESMTPSA id y20sm4472616wmi.25.2020.02.11.09.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 09:50:40 -0800 (PST)
References: <20200211073256.32652-1-liuhangbin@gmail.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <pmachata@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] selftests: forwarding: use proto icmp for {gretap,ip6gretap}_mac testing
Message-ID: <87eev1rp8g.fsf@mellanox.com>
In-reply-to: <20200211073256.32652-1-liuhangbin@gmail.com>
Date:   Tue, 11 Feb 2020 18:50:38 +0100
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hangbin Liu <liuhangbin@gmail.com> writes:

> For tc ip_proto filter, when we extract the flow via __skb_flow_dissect()
> without flag FLOW_DISSECTOR_F_STOP_AT_ENCAP, we will continue extract to
> the inner proto.
>
> So for GRE + ICMP messages, we should not track GRE proto, but inner ICMP
> proto.
>
> For test mirror_gre.sh, it may make user confused if we capture ICMP
> message on $h3(since the flow is GRE message). So I move the capture
> dev to h3-gt{4,6}, and only capture ICMP message.

[...]

> Fixes: ba8d39871a10 ("selftests: forwarding: Add test for mirror to gretap")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

This looks correct. The reason we never saw this internally is that the
ASIC puts the outer protocol to ACL ip_proto. Thus the flower rule 77
actually only matched in HW, not in both HW and SW like it should, given
the missing skip_sw.

Reviewed-by: Petr Machata <pmachata@gmail.com>
Tested-by: Petr Machata <pmachata@gmail.com>

Thanks!

> ---
>  .../selftests/net/forwarding/mirror_gre.sh    | 25 ++++++++++---------
>  1 file changed, 13 insertions(+), 12 deletions(-)
>
> diff --git a/tools/testing/selftests/net/forwarding/mirror_gre.sh b/tools/testing/selftests/net/forwarding/mirror_gre.sh
> index e6fd7a18c655..0266443601bc 100755
> --- a/tools/testing/selftests/net/forwarding/mirror_gre.sh
> +++ b/tools/testing/selftests/net/forwarding/mirror_gre.sh
> @@ -63,22 +63,23 @@ test_span_gre_mac()
>  {
>  	local tundev=$1; shift
>  	local direction=$1; shift
> -	local prot=$1; shift
>  	local what=$1; shift
>
> -	local swp3mac=$(mac_get $swp3)
> -	local h3mac=$(mac_get $h3)
> +	case "$direction" in
> +	ingress) local src_mac=$(mac_get $h1); local dst_mac=$(mac_get $h2)
> +		;;
> +	egress) local src_mac=$(mac_get $h2); local dst_mac=$(mac_get $h1)
> +		;;
> +	esac
>
>  	RET=0
>
>  	mirror_install $swp1 $direction $tundev "matchall $tcflags"
> -	tc filter add dev $h3 ingress pref 77 prot $prot \
> -		flower ip_proto 0x2f src_mac $swp3mac dst_mac $h3mac \
> -		action pass
> +	icmp_capture_install h3-${tundev} "src_mac $src_mac dst_mac $dst_mac"
>
> -	mirror_test v$h1 192.0.2.1 192.0.2.2 $h3 77 10
> +	mirror_test v$h1 192.0.2.1 192.0.2.2 h3-${tundev} 100 10
>
> -	tc filter del dev $h3 ingress pref 77
> +	icmp_capture_uninstall h3-${tundev}
>  	mirror_uninstall $swp1 $direction
>
>  	log_test "$direction $what: envelope MAC ($tcflags)"
> @@ -120,14 +121,14 @@ test_ip6gretap()
>
>  test_gretap_mac()
>  {
> -	test_span_gre_mac gt4 ingress ip "mirror to gretap"
> -	test_span_gre_mac gt4 egress ip "mirror to gretap"
> +	test_span_gre_mac gt4 ingress "mirror to gretap"
> +	test_span_gre_mac gt4 egress "mirror to gretap"
>  }
>
>  test_ip6gretap_mac()
>  {
> -	test_span_gre_mac gt6 ingress ipv6 "mirror to ip6gretap"
> -	test_span_gre_mac gt6 egress ipv6 "mirror to ip6gretap"
> +	test_span_gre_mac gt6 ingress "mirror to ip6gretap"
> +	test_span_gre_mac gt6 egress "mirror to ip6gretap"
>  }
>
>  test_all()
