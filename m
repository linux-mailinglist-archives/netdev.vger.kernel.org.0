Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80BBFCEA01
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 19:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbfJGRBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 13:01:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53998 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727801AbfJGRBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 13:01:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x97GnWaQ038139;
        Mon, 7 Oct 2019 17:01:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2019-08-05;
 bh=J37BsPBVXyz3hzyC4XHgrvBJ2wSxJAc823dvyPMeA40=;
 b=k1G+xzjJdubboDDZm4lNB8Hx1x8JKbgN7LfSoRcdedsK8rree6KK4/ddtJyEGgq9xJxq
 vRJVL4SfZdPcUUt/SOIr8BlzBHTP2Z+75VYb8mzbMJ+nh0yugYeNVfQf14Qi3gsYki+q
 0oWcXB6NgO/iss89bxfqV1QGn0JKGKoBqhX5Ey3PTzS+b/GqGagMHVUkTnIDYZ2/9BXl
 fD/kdf8AYkVx65ZoWwcrhrNjROPZo4Ni+avZPLvN9SGJfv65+M+Ta/m+Pk/F8UY4h08Z
 3t0PsK8gaG+ng1Gsae0fVfePib8D6v4E0R7pP1Ecg1rWzQxXjZvpAxBx3YO7x3lpTbnb 4g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2vektr7xsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Oct 2019 17:01:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x97Gn5QW126833;
        Mon, 7 Oct 2019 17:01:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2vf4n9nuwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Oct 2019 17:01:22 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x97H1L5K021779;
        Mon, 7 Oct 2019 17:01:21 GMT
Received: from dhcp-10-175-213-187.vpn.oracle.com (/10.175.213.187)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Oct 2019 10:01:20 -0700
Date:   Mon, 7 Oct 2019 18:01:10 +0100 (BST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@dhcp-10-175-161-159.vpn.oracle.com
To:     Andrii Nakryiko <andriin@fb.com>
cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next] selftests/bpf: fix dependency ordering for
 attach_probe test
In-Reply-To: <20191007033037.2687437-1-andriin@fb.com>
Message-ID: <alpine.LRH.2.20.1910071800480.21931@dhcp-10-175-161-159.vpn.oracle.com>
References: <20191007033037.2687437-1-andriin@fb.com>
User-Agent: Alpine 2.20 (LRH 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9403 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910070157
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9403 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910070157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 6 Oct 2019, Andrii Nakryiko wrote:

> Current Makefile dependency chain is not strict enough and allows
> test_attach_probe.o to be built before test_progs's
> prog_test/attach_probe.o is built, which leads to assembler compainig
> about missing included binary.
> 
> This patch is a minimal fix to fix this issue by enforcing that
> test_attach_probe.o (BPF object file) is built before
> prog_tests/attach_probe.c is attempted to be compiled.
> 
> Fixes: 928ca75e59d7 ("selftests/bpf: switch tests to new bpf_object__open_{file, mem}() APIs")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Reviewed-by: Alan Maguire <alan.maguire@oracle.com>

> ---
>  tools/testing/selftests/bpf/Makefile | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 294d7472dad7..f899ed20ef4d 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -160,7 +160,8 @@ $(OUTPUT)/test_queue_map.o: test_queue_stack_map.h
>  $(OUTPUT)/test_stack_map.o: test_queue_stack_map.h
>  
>  $(OUTPUT)/flow_dissector_load.o: flow_dissector_load.h
> -$(OUTPUT)/test_progs.o: flow_dissector_load.h $(OUTPUT)/test_attach_probe.o
> +prog_tests/attach_probe.c: $(OUTPUT)/test_attach_probe.o
> +$(OUTPUT)/test_progs.o: flow_dissector_load.h
>  
>  BTF_LLC_PROBE := $(shell $(LLC) -march=bpf -mattr=help 2>&1 | grep dwarfris)
>  BTF_PAHOLE_PROBE := $(shell $(BTF_PAHOLE) --help 2>&1 | grep BTF)
> -- 
> 2.17.1
> 
> 
