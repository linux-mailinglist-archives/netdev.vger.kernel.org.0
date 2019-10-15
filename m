Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E94D8D6CCA
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 03:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbfJOBUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 21:20:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55458 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727225AbfJOBUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 21:20:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9F1FWPh010787;
        Tue, 15 Oct 2019 01:20:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=nym7061D2humZLEh2kG3wf0wlc8iedL8d/xD0a8SLCw=;
 b=cyPZYuf+Y3/agJ7stYDWA0yGfNrfCGgYx3LBqHWkkYoZFhF5jOB5aksdvxLFR066Xp9+
 R90SentljpqICpgsGxhWV2ZKN+74QSyAxyKdFS9f+Ty2nTqQhjCH1qIdFICmw9VtnufW
 olIhZ8YgYNDP+DcnMC9oxGGY5K9NK1n+/ubvd/0Z9ou7p43HYhYgX7UFRKsXoYTa5TDf
 2xPGMuR0GnFF2hl5JmA1uUfO6jNaLHBtfgKmyqg+2tQunuC0MAvpzdjA4NRChMCK2NSM
 Pg2iR9oUasadnCUsf73sZXof93Q1mjKhAcISwk0ISiyE/F/GgvlvYw1aERHOAxXiS68X Nw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2vk6sqccup-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 01:20:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9F1J5WK152858;
        Tue, 15 Oct 2019 01:20:13 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2vkrbkx48v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Oct 2019 01:20:13 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9F1K7er019180;
        Tue, 15 Oct 2019 01:20:08 GMT
Received: from [192.168.1.3] (/114.88.246.185)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Oct 2019 01:20:07 +0000
Subject: Re: [RFC PATCH 0/2] block: use eBPF to redirect IO completion
To:     Hou Tao <houtao1@huawei.com>, linux-block@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org, axboe@kernel.dk,
        ast@kernel.org
Cc:     hare@suse.com, osandov@fb.com, ming.lei@redhat.com,
        damien.lemoal@wdc.com, bvanassche@acm.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com
References: <20191014122833.64908-1-houtao1@huawei.com>
From:   Bob Liu <bob.liu@oracle.com>
Message-ID: <68fd4fe2-7008-4d7c-b8a6-dc7906dcd291@oracle.com>
Date:   Tue, 15 Oct 2019 09:20:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20191014122833.64908-1-houtao1@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910150010
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9410 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910150010
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/14/19 8:28 PM, Hou Tao wrote:
> For network stack, RPS, namely Receive Packet Steering, is used to
> distribute network protocol processing from hardware-interrupted CPU
> to specific CPUs and alleviating soft-irq load of the interrupted CPU.
> 
> For block layer, soft-irq (for single queue device) or hard-irq
> (for multiple queue device) is used to handle IO completion, so
> RPS will be useful when the soft-irq load or the hard-irq load
> of a specific CPU is too high, or a specific CPU set is required
> to handle IO completion.
> 
> Instead of setting the CPU set used for handling IO completion
> through sysfs or procfs, we can attach an eBPF program to the
> request-queue, provide some useful info (e.g., the CPU
> which submits the request) to the program, and let the program
> decides the proper CPU for IO completion handling.
> 

But it looks like there isn't any benefit than through sysfs/procfs?

> In order to demonostrate the effect of IO completion redirection,
> a test programm is built to redirect the IO completion handling
> to all online CPUs or a specific CPU set:
> 
> 	./test_blkdev_ccpu -d /dev/vda
> or
> 	./test_blkdev_ccpu -d /dev/nvme0n1 -s 4,8,10-13
> 
> However I am still trying to find out a killer scenario for

Speaking about scenario, perhaps attaching a filter could be useful? 
So that the data can be processed the first place.

-
Bob

> the eBPF redirection, so suggestions and comments are welcome.
> 
> Regards,
> Tao
> 
> Hou Tao (2):
>   block: add support for redirecting IO completion through eBPF
>   selftests/bpf: add test program for redirecting IO completion CPU
> 
>  block/Makefile                                |   2 +-
>  block/blk-bpf.c                               | 127 +++++++++
>  block/blk-mq.c                                |  22 +-
>  block/blk-softirq.c                           |  27 +-
>  include/linux/blkdev.h                        |   3 +
>  include/linux/bpf_blkdev.h                    |   9 +
>  include/linux/bpf_types.h                     |   1 +
>  include/uapi/linux/bpf.h                      |   2 +
>  kernel/bpf/syscall.c                          |   9 +
>  tools/include/uapi/linux/bpf.h                |   2 +
>  tools/lib/bpf/libbpf.c                        |   1 +
>  tools/lib/bpf/libbpf_probes.c                 |   1 +
>  tools/testing/selftests/bpf/Makefile          |   1 +
>  .../selftests/bpf/progs/blkdev_ccpu_rr.c      |  66 +++++
>  .../testing/selftests/bpf/test_blkdev_ccpu.c  | 246 ++++++++++++++++++
>  15 files changed, 507 insertions(+), 12 deletions(-)
>  create mode 100644 block/blk-bpf.c
>  create mode 100644 include/linux/bpf_blkdev.h
>  create mode 100644 tools/testing/selftests/bpf/progs/blkdev_ccpu_rr.c
>  create mode 100644 tools/testing/selftests/bpf/test_blkdev_ccpu.c
> 

