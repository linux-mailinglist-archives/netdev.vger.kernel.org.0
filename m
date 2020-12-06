Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9132D0001
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 01:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgLFApO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 19:45:14 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55462 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgLFApO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 19:45:14 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B60eEf5060353;
        Sun, 6 Dec 2020 00:43:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=HkCUOSWvqLu+nBPfr5F9soHOjj7dqb0JHi/ppMxbkoA=;
 b=SmL8LRkkNKCmIU6z3cX+05cOdon0pJBnEOmWIdqfh36Rr5bUjMrT3i+QFXk9zlg05Nym
 CiMOd/lw8Q1DX5m5ug09RGjZbXqRtZ3gQrELK1RIUZeFZoF7ps+xDAyWdFKYmp4aw5Mx
 LvwP+bDNl0hJZ6sV02xcT44ZXt3/9QafmvxC7jF+Imb7Hb/fJc3J5/4xDP/Lw66sZN+7
 Op8P0mffSbSRwBqWZbOtQ1uoEO7+0jPvNp+HzPnt+jAzuGSvXuwSek1+2g8Nu1MDjkj0
 Fk1h6fFl5JPDfzJXrfuXMgKXGDTMe4nBiCwQgIc8ITlJWw3crVWeqpiLajQTPQaL22LL VA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3581mqhgv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 06 Dec 2020 00:43:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B60aTY2068040;
        Sun, 6 Dec 2020 00:43:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 358kyp1cvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Dec 2020 00:43:44 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B60hgfm032637;
        Sun, 6 Dec 2020 00:43:42 GMT
Received: from dhcp-10-175-160-212.vpn.oracle.com (/10.175.160.212)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 05 Dec 2020 16:43:42 -0800
Date:   Sun, 6 Dec 2020 00:43:36 +0000 (GMT)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Yonghong Song <yhs@fb.com>
cc:     Alan Maguire <alan.maguire@oracle.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, rostedt@goodmis.org, mingo@redhat.com,
        haoluo@google.com, jolsa@kernel.org, quentin@isovalent.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, shuah@kernel.org, lmb@cloudflare.com,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 bpf-next 0/3] bpf: support module BTF in BTF display
 helpers
In-Reply-To: <3dce8546-60d4-bb94-2c7a-ed352882cd37@fb.com>
Message-ID: <alpine.LRH.2.23.451.2012060038260.1505@localhost>
References: <1607107716-14135-1-git-send-email-alan.maguire@oracle.com> <3dce8546-60d4-bb94-2c7a-ed352882cd37@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9826 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 malwarescore=0 suspectscore=10 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9826 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=10 mlxlogscore=999
 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012060003
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Sat, 5 Dec 2020, Yonghong Song wrote:

> 
> 
> __builtin_btf_type_id() is really only supported in llvm12
> and 64bit return value support is pushed to llvm12 trunk
> a while back. The builtin is introduced in llvm11 but has a
> corner bug, so llvm12 is recommended. So if people use the builtin,
> you can assume 64bit return value. libbpf support is required
> here. So in my opinion, there is no need to do feature detection.
> 
> Andrii has a patch to support 64bit return value for
> __builtin_btf_type_id() and I assume that one should
> be landed before or together with your patch.
> 
> Just for your info. The following is an example you could
> use to determine whether __builtin_btf_type_id()
> supports btf object id at llvm level.
> 
> -bash-4.4$ cat t.c
> int test(int arg) {
>   return __builtin_btf_type_id(arg, 1);
> }
> 
> Compile to generate assembly code with latest llvm12 trunk:
>   clang -target bpf -O2 -S -g -mcpu=v3 t.c
> In the asm code, you should see one line with
>   r0 = 1 ll
> 
> Or you can generate obj code:
>   clang -target bpf -O2 -c -g -mcpu=v3 t.c
> and then you disassemble the obj file
>   llvm-objdump -d --no-show-raw-insn --no-leading-addr t.o
> You should see below in the output
>   r0 = 1 ll
> 
> Use earlier version of llvm12 trunk, the builtin has
> 32bit return value, you will see
>   r0 = 1
> which is a 32bit imm to r0, while "r0 = 1 ll" is
> 64bit imm to r0.
>

Thanks for this Yonghong!  I'm thinking the way I'll tackle it
is to simply verify that the upper 32 bits specifying the
veth module object id are non-zero; if they are zero, we'll skip
the test (I think a skip probably makes sense as not everyone will
have llvm12). Does that seem reasonable?

With the additional few minor changes on top of Andrii's patch,
the use of __builtin_btf_type_id() worked perfectly. Thanks!

Alan
