Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3EA8107BD7
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 01:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfKWADj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 19:03:39 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:46524 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbfKWADi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 19:03:38 -0500
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 14FB413C359;
        Fri, 22 Nov 2019 16:03:38 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 14FB413C359
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1574467418;
        bh=+wBV21eX9w6usg+q1qTEXcJDr8i+yoSuwxyJIbHSnMI=;
        h=To:Cc:From:Subject:Date:From;
        b=GSiQNQkooPTa290tFmgLM0T73KlfIF1BibXomQUp+hUW7Qsm/5jV/4u4nqhoF1PRy
         1xPMt7wutpwu+jy2XBLisrdDLSjfbyqRa7ax/uLklme/J3RsiMMUOac2Ck5ysZXVux
         9r5byQvVT9z21VUukJFu46Pdc2VN5jJQ65B+qA/M=
To:     netdev <netdev@vger.kernel.org>
Cc:     David Ahern <dsahern@gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Subject: VRF and/or cgroups problem on Fedora-30, 5.2.21+ kernel
Organization: Candela Technologies
Message-ID: <05276b67-406b-2744-dd7c-9bda845a5bb1@candelatech.com>
Date:   Fri, 22 Nov 2019 16:03:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

We see a problem on a particular system when trying to run 'ip vrf exec _vrf1 ping 1.1.1.1'.
This system reproduces the problem all the time, but other systems with exact same (as far as
we can tell) software may fail occasionally, but then it will work again.

Here is an strace output.  I changed to the "/sys/fs/cgroup/unified/user.slice/user-1000.slice/session-2.scope/vrf/_vrf1"
directory as root user, and could view the files in that directory, so I'm not sure why the strace shows error 5.

Any idea what could be the problem and/or how to fix it or debug further?


This command was run as root user.

....

openat(AT_FDCWD, "/proc/15650/cgroup", O_RDONLY) = 5
fstat(5, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
read(5, "10:pids:/user.slice/user-1000.sl"..., 1024) = 274
close(5)                               = 0
mkdir("/sys", 0755)                     = -1 EEXIST (File exists)
mkdir("/sys", 0755)                     = -1 EEXIST (File exists)
mkdir("/sys/fs", 0755)                  = -1 EEXIST (File exists)
mkdir("/sys/fs", 0755)                  = -1 EEXIST (File exists)
mkdir("/sys/fs/cgroup", 0755)           = -1 EEXIST (File exists)
mkdir("/sys/fs/cgroup", 0755)           = -1 EEXIST (File exists)
mkdir("/sys/fs/cgroup/unified", 0755)   = -1 EEXIST (File exists)
mkdir("/sys/fs/cgroup/unified", 0755)   = -1 EEXIST (File exists)
mkdir("/sys/fs/cgroup/unified/user.slice", 0755) = -1 EEXIST (File exists)
mkdir("/sys/fs/cgroup/unified/user.slice", 0755) = -1 EEXIST (File exists)
mkdir("/sys/fs/cgroup/unified/user.slice/user-1000.slice", 0755) = -1 EEXIST (File exists)
mkdir("/sys/fs/cgroup/unified/user.slice/user-1000.slice", 0755) = -1 EEXIST (File exists)
mkdir("/sys/fs/cgroup/unified/user.slice/user-1000.slice/session-2.scope", 0755) = -1 EEXIST (File exists)
mkdir("/sys/fs/cgroup/unified/user.slice/user-1000.slice/session-2.scope", 0755) = -1 EEXIST (File exists)
mkdir("/sys/fs/cgroup/unified/user.slice/user-1000.slice/session-2.scope/vrf", 0755) = -1 EEXIST (File exists)
mkdir("/sys/fs/cgroup/unified/user.slice/user-1000.slice/session-2.scope/vrf", 0755) = -1 EEXIST (File exists)
mkdir("/sys/fs/cgroup/unified/user.slice/user-1000.slice/session-2.scope/vrf/_vrf1", 0755) = -1 EEXIST (File exists)
mkdir("/sys/fs/cgroup/unified/user.slice/user-1000.slice/session-2.scope/vrf/_vrf1", 0755) = -1 EEXIST (File exists)
openat(AT_FDCWD, "/sys/fs/cgroup/unified/user.slice/user-1000.slice/session-2.scope/vrf/_vrf1", O_RDONLY|O_DIRECTORY) = 5
bpf(BPF_PROG_LOAD, {prog_type=BPF_PROG_TYPE_CGROUP_SOCK, insn_cnt=6, insns=0x7ffc8e5d1e00, license="GPL", log_level=1, log_size=262144, log_buf="", 
kern_version=KERNEL_VERSION(0, 0, 0), prog_flags=0, prog_name="", prog_ifindex=0, expected_attach_type=BPF_CGROUP_INET_INGRESS, prog_btf_fd=0, 
func_info_rec_size=0, func_info=NULL, func_info_cnt=0, line_info_rec_size=0, line_info=NULL, line_info_cnt=0}, 112) = -1 EPERM (Operation not permitted)
write(2, "Failed to load BPF prog: 'Operat"..., 51Failed to load BPF prog: 'Operation not permitted'


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

